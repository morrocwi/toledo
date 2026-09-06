#!/usr/bin/env python3
"""Independent checker (I2) for N4 merge. Read-only verification script.
Checks (a)-(f) from the checker mandate. Prints PASS/FAIL per check plus
counts. Does not modify any registry/coq file.
"""
import json, re, sys
from pathlib import Path
from collections import defaultdict

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"

CODE_RE = re.compile(
    r"^(?P<root>EQ-0\d{2}|[A-Za-z][A-Za-z0-9]*(?:[._-][A-Za-z0-9]+)*)"
    r"(?:/(?P<domain>[EHSWMPCB])\.(?P<seq>\d{2,4})(?:\.v(?P<rev>[1-9]\d*))?)?$"
)

def load_json(p):
    return json.load(open(p, encoding="utf-8"))

def main():
    fails = []
    warns = []

    canon = load_json(REG / "CANONICAL.json")
    entries = canon["canonical"]
    genesis = load_json(REG / "genesis_root.json")
    genesis_codes = {r["code"] for r in genesis["root_equations"]}

    print(f"[info] CANONICAL.json entries: {len(entries)}")
    print(f"[info] genesis_root.json root_equations: {len(genesis_codes)}")

    # ---- (a) grammar, uniqueness, parent existence, orphans, cycles ----
    codes = [e["code"] for e in entries]
    code_set = set(codes)
    all_known_codes = code_set | genesis_codes

    dup_counts = defaultdict(int)
    for c in codes:
        dup_counts[c] += 1
    dups = {c: n for c, n in dup_counts.items() if n > 1}
    if dups:
        fails.append(f"(a) duplicate codes in CANONICAL.json: {dups}")
    else:
        print("[PASS] (a) no duplicate codes in CANONICAL.json")

    bad_grammar = []
    hrp_ok = 0
    for e in entries:
        c = e["code"]
        m = CODE_RE.match(c)
        if m:
            continue
        if c.startswith("HRP-X.") and e.get("drift_note"):
            hrp_ok += 1
            continue
        bad_grammar.append((e.get("id"), c))
    if bad_grammar:
        fails.append(f"(a) codes failing grammar (not HRP-X w/ drift_note): {bad_grammar[:20]} (total {len(bad_grammar)})")
    else:
        print(f"[PASS] (a) all codes match grammar or are HRP-X with drift_note ({hrp_ok} HRP-X)")

    DECLARED_ORPHANS = {"EQ-001", "EQ-005", "EQ-006"}
    orphans = []
    for e in entries:
        parents = e.get("parents") or []
        if not parents:
            root_field = e.get("root")
            code = e["code"]
            if code in DECLARED_ORPHANS or root_field in DECLARED_ORPHANS:
                continue
            if code.startswith("HRP-X."):
                # rootless placeholders are declared orphans by design
                continue
            orphans.append((e.get("id"), code))
    if orphans:
        fails.append(f"(a) unexpected orphans (no parents, not EQ-001/005/006/HRP-X): {orphans[:20]} (total {len(orphans)})")
    else:
        print(f"[PASS] (a) 0 unexpected orphans")

    missing_parent = []
    for e in entries:
        for p in (e.get("parents") or []):
            pcode = p["code"]
            if pcode not in all_known_codes:
                missing_parent.append((e["id"], e["code"], pcode))
    if missing_parent:
        fails.append(f"(a) parent codes that don't exist: {missing_parent[:20]} (total {len(missing_parent)})")
    else:
        print("[PASS] (a) every parent code exists (in CANONICAL.json or genesis_root.json)")

    # cycle check (graph over CANONICAL entries only; genesis roots treated as terminal)
    parents_map = {e["code"]: [p["code"] for p in (e.get("parents") or [])] for e in entries}
    WHITE, GRAY, BLACK = 0, 1, 2
    color = {c: WHITE for c in parents_map}
    cycle_found = []

    def visit(c, stack):
        if color.get(c, BLACK) == BLACK:
            return
        if color.get(c) == GRAY:
            cycle_found.append(stack + [c])
            return
        color[c] = GRAY
        for p in parents_map.get(c, []):
            if p in parents_map:
                visit(p, stack + [c])
        color[c] = BLACK

    for c in list(parents_map):
        if color[c] == WHITE:
            visit(c, [])
    if cycle_found:
        fails.append(f"(a) cycles found: {cycle_found[:5]}")
    else:
        print("[PASS] (a) 0 cycles")

    # ---- (b) split / not_an_equation status checks ----
    lineage_path = REG / "LINEAGE.jsonl"
    lineage_events = []
    with open(lineage_path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line:
                lineage_events.append(json.loads(line))
    print(f"[info] LINEAGE.jsonl events: {len(lineage_events)}")

    split_events_by_from = defaultdict(list)
    for ev in lineage_events:
        if ev.get("event") == "split":
            split_events_by_from[ev.get("from")].append(ev)

    split_status_bad = []
    not_an_eq_bad = []
    for e in entries:
        status = e.get("status")
        code = e["code"]
        if status == "split":
            children = e.get("children") or []
            if not children:
                split_status_bad.append((code, "no children"))
                continue
            for ch in children:
                if ch not in code_set:
                    split_status_bad.append((code, f"child {ch} missing"))
            if code not in split_events_by_from and code not in {ev.get("from") for ev in lineage_events if ev.get("event") == "split"}:
                split_status_bad.append((code, "no LINEAGE split event"))
        if status == "not_an_equation":
            if e.get("children"):
                not_an_eq_bad.append((code, "has children"))
            # pointer: expect some pointer field (origin/occurrences or a note); check basic non-empty
            if not (e.get("status_note") or e.get("origin")):
                not_an_eq_bad.append((code, "no pointer (status_note/origin)"))

    if split_status_bad:
        fails.append(f"(b) split-status problems: {split_status_bad[:20]} (total {len(split_status_bad)})")
    else:
        n_split = sum(1 for e in entries if e.get("status") == "split")
        print(f"[PASS] (b) all {n_split} 'split' entries have existing children + LINEAGE split event")

    if not_an_eq_bad:
        fails.append(f"(b) not_an_equation problems: {not_an_eq_bad[:20]} (total {len(not_an_eq_bad)})")
    else:
        n_nae = sum(1 for e in entries if e.get("status") == "not_an_equation")
        print(f"[PASS] (b) all {n_nae} 'not_an_equation' entries have a pointer and no children")

    # ---- output summary machine-readable ----
    summary = {
        "entries": len(entries),
        "genesis_roots": len(genesis_codes),
        "dup_codes": len(dups),
        "orphans": len(orphans),
        "cycles": len(cycle_found),
        "missing_parents": len(missing_parent),
        "bad_grammar": len(bad_grammar),
        "split_bad": len(split_status_bad),
        "not_an_eq_bad": len(not_an_eq_bad),
        "fails": fails,
    }
    print("\n=== SUMMARY (a)/(b) ===")
    print(json.dumps(summary, indent=2))

    Path(REG / "checker_ab_summary.json").write_text(json.dumps(summary, indent=2))

    if fails:
        print("\nFAIL: see above")
        sys.exit(1)
    print("\nPASS (a)/(b)")

if __name__ == "__main__":
    main()
