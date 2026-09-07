#!/usr/bin/env python3
"""Toledo v1.1, Lane C (roots + tiers, no coqc) -- scripts/v11_C.py, task (3).

For every registry/CANONICAL.json entry with tier == "untagged" (332 at
launch), look at the entry's own SOURCE OCCURRENCE text (not just its
tier_in_genesis_verbatim field, which can carry an inherited/decomposed
value from a parent's mixed-tier statement rather than this entry's own
occurrence) for an explicit tier tag matching the schema's controlled
vocabulary (Th_coqc | finite_diagnostic | Dr | Open | Definition | Ax |
RETRACTED), and set tier + tier_evidence {quote, source, line} ONLY where
the source states one plainly. Every other untagged entry is left
untagged -- this script never infers a tier from a different, uncontrolled
free-text vocabulary (e.g. domain_registry's own "class=...;
domain_claim_boundary_tier=..." tags, or a bare "identity"/"law"/
"theorem"/"proposition" paper_tier) or from a tier claimed for only ONE
term of a composite parent statement.

Two source shapes are checked directly, by re-reading the actual files:

  (a) textbook occurrences (occurrences[].raw_key matching "<record_id>:
      <label>") -- registry/eq_<record_id>.json's own "paper_tier" field
      for that label is the source's own explicit tag. Mapped only when
      ALL occurrences for the entry agree AND the tag maps unambiguously:
      "definition" (with any parenthetical qualifier) -> Definition;
      an "axiom" tag -> Ax; a tag containing "[Open]"/"/Open" as its own
      token -> Open. Bare "identity"/"law"/"theorem"/"proposition"/
      "measurement"/"corollary" tags are NOT in the controlled vocabulary
      and are left untagged (that is the honest-loss point of the
      tier_in_genesis_verbatim field).

  (b) solver-arc "imported_equations.rows[N]" occurrences (registry/
      src_solver_arc.json) -- the row's own "use_text" field sometimes
      carries a literal bracketed tag, e.g. "interpretive anchor, `[Dr]`"
      or "imported argument/conclusion, `[AX/import]`". Mapped only when
      the row carries EXACTLY ONE such bracketed tag (a row stating two
      alternative-sounding tags, e.g. "(`[Dr]`/`[AX/import]`)", is
      genuinely ambiguous in the source itself and is left untagged
      rather than guessed).

Idempotent: entries already retagged by a prior run of this script keep
their new tier (tier != "untagged") and are skipped on rerun; the file is
re-read immediately before writing (another lane may have written it
meanwhile), and only tier/tier_evidence on this script's own touched
entries are merged back in.

Run: python3 scripts/v11_C.py [--dry-run]
Inputs : registry/CANONICAL.json, registry/eq_<record_id>.json (per
         textbook occurrence), registry/src_solver_arc.json
Outputs: registry/CANONICAL.json (tier + tier_evidence fields only, on
         entries this script itself retags)
         registry/LINEAGE.jsonl (one "revised" event per retagged entry)
"""
import argparse
import json
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
DATE = "2026-09-07"
BY = "toledo-v1.1-C"

VALID_TIERS = {"Th_coqc", "finite_diagnostic", "Dr", "Open", "Definition", "Ax", "RETRACTED"}


def grep_line(path: Path, needle: str) -> str:
    """Best-effort line number of the first literal occurrence of `needle`
    in `path`, formatted "path:line". Returns "path:?" if not found (never
    fabricates a number)."""
    try:
        out = subprocess.run(
            ["grep", "-n", "-F", needle, str(path)],
            capture_output=True, text=True, timeout=10,
        ).stdout
        first = out.splitlines()[0] if out.splitlines() else None
        if first:
            lineno = first.split(":", 1)[0]
            rel = path.relative_to(ROOT)
            return f"{rel}:{lineno}"
    except Exception:
        pass
    rel = path.relative_to(ROOT)
    return f"{rel}:?"


def map_paper_tier(tag: str):
    """Map a textbook paper_tier string to a controlled tier, or None."""
    t = tag.strip()
    if re.search(r"\[Open\]|/Open\b", t):
        return "Open"
    if re.search(r"(^|[\s/\[,])Dr([\s\]\),/]|$)", t):
        return "Dr"
    if t.startswith("axiom"):
        return "Ax"
    if t == "finite_diagnostic" or t.startswith("finite_diagnostic "):
        return "finite_diagnostic"
    if t.startswith("definition"):
        return "Definition"
    return None


def check_textbook(entry) -> dict | None:
    """Try to resolve a tier from textbook occurrences. Returns a dict
    with tier + tier_evidence, or None if no confident, unanimous tag."""
    occs = entry.get("occurrences", [])
    hits = []
    for occ in occs:
        rk = occ.get("raw_key", "")
        m = re.match(r"^(\d+):(.+)$", rk)
        if not m:
            continue
        rid, label = m.group(1), m.group(2)
        fn = REG / f"eq_{rid}.json"
        if not fn.exists():
            continue
        data = json.loads(fn.read_text(encoding="utf-8"))
        for eq in data.get("equations", []):
            if eq.get("label") == label:
                pt = eq.get("paper_tier")
                if pt is not None:
                    hits.append((rid, label, pt, fn))
                break
    if not hits:
        return None
    mapped = {map_paper_tier(pt) for (_, _, pt, _) in hits}
    mapped.discard(None)
    if len(mapped) != 1:
        return None  # no tag, or disagreement across occurrences -> stay untagged
    tier = next(iter(mapped))
    rid, label, pt, fn = hits[0]
    quote = f'occurrences of {entry["code"]} in eq_{rid}.json label {label} (and {len(hits)-1} more, all agreeing): "paper_tier": "{pt}"'
    return {
        "tier": tier,
        "tier_evidence": {
            "quote": quote,
            "source": f"registry/eq_{rid}.json (doi {hits[0][0] and ('10.5281/zenodo.' + rid)})",
            "line": grep_line(fn, f'"paper_tier": "{pt}"'),
        },
    }


BRACKET_TAG = re.compile(r"`?\[([A-Za-z_]+(?:/[A-Za-z_]+)?)\]`?")


def check_solver_arc_row(entry, src) -> dict | None:
    occs = entry.get("occurrences", [])
    rows = src["imported_equations"]["rows"]
    for occ in occs:
        rk = occ.get("raw_key", "")
        m = re.match(r"^imported_equations\.rows\[(\d+)\]$", rk)
        if not m:
            continue
        idx = int(m.group(1))
        row = rows[idx]
        use_text = row.get("use_text", "")
        tags = BRACKET_TAG.findall(use_text)
        if len(tags) != 1:
            continue  # zero or ambiguous multi-tag -> stay untagged
        raw_tag = tags[0]
        if raw_tag in VALID_TIERS:
            tier = raw_tag
        elif raw_tag.upper() == "AX/IMPORT":
            tier = "Ax"
        else:
            continue
        return {
            "tier": tier,
            "tier_evidence": {
                "quote": f'src_solver_arc.json imported_equations.rows[{idx}] ({row.get("equation")}, {row.get("owner")} {row.get("year")}): use_text = "{use_text}"',
                "source": "registry/src_solver_arc.json",
                "line": grep_line(REG / "src_solver_arc.json", use_text[:60]),
            },
        }
    return None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    canon = json.loads((REG / "CANONICAL.json").read_text(encoding="utf-8"))
    src = json.loads((REG / "src_solver_arc.json").read_text(encoding="utf-8"))

    n_tagged = 0
    n_left = 0
    lineage_events = []
    touched = {}

    for e in canon["canonical"]:
        if e.get("tier") != "untagged":
            continue
        result = check_textbook(e)
        if result is None:
            result = check_solver_arc_row(e, src)
        if result is None:
            n_left += 1
            continue
        old_verbatim = e.get("tier_in_genesis_verbatim", "")
        print(f"TAG  {e['code']} -> {result['tier']}  ({result['tier_evidence']['quote'][:90]}...)")
        touched[e["code"]] = result
        n_tagged += 1
        lineage_events.append({
            "code": e["code"], "date": DATE, "event": "revised",
            "from": f"tier=untagged (tier_in_genesis_verbatim={old_verbatim!r})",
            "to": f"tier={result['tier']}",
            "reason": (
                "Toledo v1.1 Lane C: the entry's own source occurrence (not an "
                "inherited/decomposed parent value) states this tier explicitly. "
                f"{result['tier_evidence']['quote']}"
            ),
            "by": BY,
        })

    print(f"Would tag {n_tagged}, leave {n_left} untagged (of {n_tagged + n_left} checked).")

    if args.dry_run or not touched:
        return

    # re-read immediately before writing (another lane may have written meanwhile)
    canon2 = json.loads((REG / "CANONICAL.json").read_text(encoding="utf-8"))
    by_code2 = {e["code"]: e for e in canon2["canonical"]}
    applied = 0
    for code, result in touched.items():
        target = by_code2.get(code)
        if target is None or target.get("tier") != "untagged":
            continue  # another lane already changed it or it vanished; do not clobber
        target["tier"] = result["tier"]
        target["tier_evidence"] = result["tier_evidence"]
        applied += 1

    # keep counts.by_tier honest
    by_tier = {}
    for e in canon2["canonical"]:
        by_tier[e.get("tier", "untagged")] = by_tier.get(e.get("tier", "untagged"), 0) + 1
    canon2.setdefault("counts", {})["by_tier"] = by_tier

    tmp = REG / "CANONICAL.json.tmp"
    tmp.write_text(json.dumps(canon2, indent=2, ensure_ascii=False), encoding="utf-8")
    tmp.replace(REG / "CANONICAL.json")

    if lineage_events:
        with open(REG / "LINEAGE.jsonl", "a", encoding="utf-8") as fh:
            for ev in lineage_events:
                fh.write(json.dumps(ev, ensure_ascii=False) + "\n")

    print(f"Applied {applied} tier changes to CANONICAL.json; {len(lineage_events)} LINEAGE events appended.")


if __name__ == "__main__":
    main()
