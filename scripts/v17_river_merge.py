#!/usr/bin/env python3
"""Toledo v1.7 REGISTRAR merge -- registry/proposals/equation_river.json.

The Equation River: 6 founder-instructed proposals (Blackbox Log
BBL-2026-09-08-238) modelling how one equation, once it exists, grows
stronger step by step in our own context -- think, register in Toledo,
Th_coqc, reproducible computation with an outside oracle, review, world
record -- and returns to the model (interruption -> revision, never editing
the deposited source).

For each proposal: phi-check against registry/CANONICAL.json (re-read
immediately before writing, per the concurrent-run discipline below) by
normalised statement text and by alias/name. All 6 ladder-rung/CES parent
codes (weld/H.30.v1, weld/H.33.v1, EQ-015/H.24.v1) and both root codes
(Q, R, in genesis_root.json) already exist -- checked below, abort if not.
No existing entry states the same rung-set / strengthening-law / sigma
readout / return-map / non-collapse / stage-3-4-on-Q content, so all 6
become new entries (weld/M.??, EQ-015/H.??, EQ-015/M.??), each the next nn
for its own (root, domain) continuing from CANONICAL.json's own live
maximum for that key.

Idempotent: an alias already present anywhere in CANONICAL.json means that
proposal was already merged on a prior run -- skipped, not re-added.

Concurrency discipline: another run may be adding sidecar files under
registry/executable/ concurrently. This script never reads or writes
anything under registry/executable/, and re-reads CANONICAL.json
immediately before writing so it only ever touches the entries it itself
adds in this run (read-compute-write with no long-held state from a stale
snapshot).

No /home paths, usernames, private repo names, AI vendor names, or
priority words appear anywhere in the entries or lineage this script
writes.

Outputs: registry/CANONICAL.json, registry/LINEAGE.jsonl (both existing
files, appended/rewritten in place), and (new)
registry/proposals/equation_river.merged.json mapping every proposal id to
the final code it resolved to.

Never touches mcp/, coq/, latex/, README/CHANGELOG/CITATION, or
registry/executable/.

Run: python3 scripts/v17_river_merge.py
"""
import json
import re
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
DATE = "2026-09-08"
BY = "toledo-v1.7-river"

CANONICAL_PATH = REG / "CANONICAL.json"
GENESIS_PATH = REG / "genesis_root.json"
LINEAGE_PATH = REG / "LINEAGE.jsonl"

RIVER_PROPOSALS_PATH = REG / "proposals" / "equation_river.json"
RIVER_MERGED_MAP_PATH = REG / "proposals" / "equation_river.merged.json"

FOUNDER_INSTRUCTION_QUOTE = (
    "2026-09-08: model how one equation, once it exists, grows stronger step "
    "by step within our context -- think, register in Toledo, Th_coqc, "
    "reproducible computation with an outside oracle, review, world record -- "
    "and returns to the model"
)

CODE_RE = re.compile(
    r"^(?P<root>EQ-0\d{2}|[A-Za-z][A-Za-z0-9]*(?:[._-][A-Za-z0-9]+)*)"
    r"(?:/(?P<domain>[EHSWMPCB])\.(?P<seq>\d{2,4})(?:\.v(?P<rev>[1-9]\d*))?)?$"
)

DEFAULT_COQ = {
    "file": None, "identifier": None, "assumptions": None, "imported_from": None,
    "coq_status": "open_prop", "coq_axioms": [], "coq_source_redistributed": True,
}


def root_of(code: str) -> str:
    """Root portion of a code -- everything before the first '/<D>.' reading
    suffix, or the whole string if it is itself a bare root/placeholder code
    (e.g. 'weld/M.??.v1' -> 'weld', 'EQ-015/H.??.v1' -> 'EQ-015', 'Q' -> 'Q')."""
    return code.split("/", 1)[0]


def domain_of_placeholder(code: str) -> str:
    """Pull the single-letter domain out of a 'root/D.??.v1'-shaped proposal
    placeholder code."""
    mo = re.match(r"^.+/([EHSWMPCB])\.\?\?\.v\d+$", code)
    if not mo:
        raise SystemExit(f"cannot read placeholder domain out of code {code!r}")
    return mo.group(1)


def normalise_statement(latex: str) -> str:
    """Loose normalisation for the phi-check: collapse whitespace, drop
    LaTeX spacing/formatting macros, lowercase. Good enough to catch a
    verbatim-or-near-verbatim restatement without claiming to be a real
    equivalence prover."""
    s = latex.lower()
    s = re.sub(r"\\(text|mathrm|big|quad|,|;|!)\b", " ", s)
    s = re.sub(r"[\\{}$]", " ", s)
    s = re.sub(r"\s+", " ", s).strip()
    return s


def coq_status_for(tier: str, pid: str) -> str:
    """SCHEMA.md v1.1 addendum ladder, task instruction: 'definition' for
    Definition, 'open_prop' for Dr (file null, wrapper pending)."""
    if tier == "Definition":
        return "definition"
    if tier == "Dr":
        return "open_prop"
    raise SystemExit(
        f"{pid}: tier {tier!r} is not Definition or Dr -- the task forbids "
        "assigning any higher tier than proposed."
    )


def main():
    # ------------------------------------------------------------------
    # Re-read CANONICAL.json fresh right before writing (concurrent-run
    # discipline: another process may be adding registry/executable/
    # sidecars at the same time -- we never touch that directory, and we
    # never work off a stale in-memory copy across a long span).
    # ------------------------------------------------------------------
    canonical_doc = json.load(open(CANONICAL_PATH, encoding="utf-8"))
    entries = canonical_doc["canonical"]
    by_code = {e["code"]: e for e in entries}
    entries_before = len(entries)

    genesis_doc = json.load(open(GENESIS_PATH, encoding="utf-8"))
    genesis_codes = {r["code"] for r in genesis_doc["root_equations"]}

    river_doc = json.load(open(RIVER_PROPOSALS_PATH, encoding="utf-8"))
    proposals = river_doc["proposals"]
    founder_note = river_doc.get("founder_instruction", FOUNDER_INSTRUCTION_QUOTE)

    existing_aliases = set()
    for e in entries:
        for a in e.get("aliases") or []:
            existing_aliases.add(a)

    # phi-check indices: normalised statement text -> code; name -> code
    # (case-insensitive), over the full live CANONICAL.json.
    stmt_by_norm = {}
    name_by_norm = {}
    for e in entries:
        latest = ((e.get("statement") or {}).get("latest") or "")
        if latest:
            stmt_by_norm.setdefault(normalise_statement(latest), e["code"])
        nm = (e.get("name") or "").strip().lower()
        if nm:
            name_by_norm.setdefault(nm, e["code"])

    # running (root, domain) -> current max nn, seeded from CANONICAL.json's
    # own live state (SCHEMA.md: nn assigned once from the live maximum,
    # never reused; retired/split/superseded codes still count).
    seq_state = {}
    for e in entries:
        mo = re.match(r"^(.+)/([EHSWMPCB])\.(\d+)\.v\d+$", e["code"])
        if mo:
            key = (mo.group(1), mo.group(2))
            seq_state[key] = max(seq_state.get(key, 0), int(mo.group(3)))

    def next_code(root: str, domain: str) -> str:
        key = (root, domain)
        seq_state[key] = seq_state.get(key, 0) + 1
        nn = seq_state[key]
        width = 2 if nn < 100 else len(str(nn))
        return f"{root}/{domain}.{nn:0{width}d}.v1"

    lineage_events = []
    merged_map = {}
    new_codes = []
    occurrence_notes = []
    could_not_merge = []
    skipped_already_merged = []

    max_existing_id = 0
    for e in entries:
        if isinstance(e.get("id"), str) and e["id"].startswith("RIVER-2026-09-08-"):
            try:
                max_existing_id = max(max_existing_id, int(e["id"].rsplit("-", 1)[1]))
            except ValueError:
                pass

    for prop in proposals:
        pid = prop["id"]
        aliases = list(prop["aliases"])
        primary_alias = aliases[0]

        # ------------------------------------------------------------
        # Idempotency: alias already present anywhere -> already merged.
        # ------------------------------------------------------------
        if any(a in existing_aliases for a in aliases):
            existing_code = None
            for e in entries:
                if any(a in (e.get("aliases") or []) for a in aliases):
                    existing_code = e["code"]
                    break
            merged_map[pid] = existing_code
            skipped_already_merged.append(pid)
            continue

        # ------------------------------------------------------------
        # phi-check: normalised statement, then name, against the live
        # CANONICAL.json (1,267 entries) -- the ladder rungs and CES
        # objects already exist (weld/H.30-34); if this proposal
        # restates one of them (or any other entry) verbatim/near-
        # verbatim, record an occurrence instead of a new entry.
        # ------------------------------------------------------------
        norm = normalise_statement(prop["statement"]["latest"])
        phi_match = stmt_by_norm.get(norm)
        if phi_match is None:
            phi_match = name_by_norm.get(prop["name"].strip().lower())

        if phi_match is not None:
            target = by_code[phi_match]
            occ = {
                "record_id": None,
                "doi": prop["origin"].get("doi"),
                "label": pid,
                "section": None,
                "raw_key": f"equation_river:{pid}",
                "note": "phi-equivalent to existing entry (normalised-statement/name match); "
                        "recorded as occurrence, no new entry created",
            }
            target.setdefault("occurrences", []).append(occ)
            merged_map[pid] = phi_match
            occurrence_notes.append(f"{pid} -> {phi_match} (phi-equivalent)")
            lineage_events.append({
                "code": phi_match, "date": DATE, "event": "occurrence_added",
                "from": pid, "to": phi_match,
                "reason": (
                    f"Toledo v1.7 Equation River merge: proposal {pid} ({prop['name']}) "
                    f"phi-checked as equivalent to existing entry {phi_match} by "
                    "normalised statement/name match -- recorded as occurrence per "
                    f"founder instruction (BBL-2026-09-08-238): \"{founder_note}\"."
                ),
                "by": BY,
            })
            continue

        # ------------------------------------------------------------
        # New entry path.
        # ------------------------------------------------------------
        try:
            parents = prop.get("parents") or []
            if not parents:
                raise ValueError(f"{pid}: proposal has no parents (SCHEMA.md T3.4: "
                                  "empty parents is legal only for EQ-001)")
            for p in parents:
                if p["code"] not in by_code and p["code"] not in genesis_codes:
                    raise ValueError(f"{pid}: parent code {p['code']!r} not found "
                                      "in genesis_root.json or CANONICAL.json -- abort")

            placeholder_code = prop["code"]
            root = root_of(placeholder_code)
            domain = domain_of_placeholder(placeholder_code)
            if prop.get("domain") and prop["domain"] != domain:
                raise ValueError(
                    f"{pid}: proposal 'domain' field {prop['domain']!r} does not match "
                    f"domain letter in code {placeholder_code!r}"
                )

            tier = prop["tier"]
            if tier not in ("Definition", "Dr"):
                raise ValueError(
                    f"{pid}: tier {tier!r} -- task instruction requires tier as "
                    "proposed and never higher than Definition/Dr"
                )

            code = next_code(root, domain)
            max_existing_id += 1
            entry_id = f"RIVER-2026-09-08-{max_existing_id:02d}"

            origin = dict(prop["origin"])
            # Task instruction's exact origin.source/doi for every new entry
            # this script creates (overrides/normalises the proposal file's
            # own per-item origin.source text to the single canonical form
            # specified for this merge, while keeping the proposal's own DOI
            # if one was already correct).
            origin_source = ("Blackbox Log BBL-2026-09-08-238 (founder instruction) "
                              "+ glosa P22/P23")
            origin = {
                "source": origin_source,
                "repo_anchor": None,
                "record_id": None,
                "doi": origin.get("doi") or "10.5281/zenodo.22302518",
                "section": None,
            }

            parent_quote = parents[0].get("evidence", "")
            entry = {
                "id": entry_id,
                "code": code,
                "root": root,
                "layer": "reading",
                "domain": domain,
                "aliases": aliases,
                "name": prop["name"],
                "statement": {
                    "latest": prop["statement"]["latest"],
                    "format": prop["statement"].get("format", "latex"),
                },
                "statements_history": [{
                    "v": 1,
                    "statement": prop["statement"]["latest"],
                    "date": DATE,
                    "reason": (
                        f"{BY}: initial capture from Equation River proposal {pid}, "
                        f"origin: {origin['source']}"
                    ),
                    "by": BY,
                }],
                "parents": [{"code": p["code"], "derived_via": p["derived_via"]} for p in parents],
                "children": [],
                "origin": origin,
                "status": prop.get("status", "current"),
                "status_note": prop.get("status_note", ""),
                "superseded_by": None,
                "tier": tier,
                "tier_in_genesis_verbatim": prop.get("tier_in_genesis_verbatim", ""),
                "coq": dict(DEFAULT_COQ),
                "relations": [dict(r) for r in prop.get("relations", [])],
                "occurrences": [dict(o) for o in prop.get("occurrences", [])],
                "role": prop.get("role", "other"),
                "first_assigned": DATE,
            }
            entry["coq"]["coq_status"] = coq_status_for(tier, pid)
            # file stays null (wrapper pending) per task instruction --
            # DEFAULT_COQ already sets file/identifier/assumptions/
            # imported_from to None; coq_axioms stays [].

            entries.append(entry)
            by_code[code] = entry
            existing_aliases.update(aliases)
            stmt_by_norm.setdefault(norm, code)
            name_by_norm.setdefault(prop["name"].strip().lower(), code)
            new_codes.append(code)
            merged_map[pid] = code

            lineage_events.append({
                "code": code, "date": DATE, "event": "assigned",
                "from": pid, "to": code,
                "reason": (
                    f"Toledo v1.7 Equation River merge (proposal {pid}, {prop['name']}, "
                    f"tier {tier}, parents {[p['code'] for p in parents]}): founder "
                    f"instruction (BBL-2026-09-08-238): \"{founder_note}\". "
                    f"Parent evidence quoted: \"{parent_quote}\""
                ),
                "by": BY,
            })

        except ValueError as exc:
            could_not_merge.append(str(exc))
            merged_map[pid] = None

    if could_not_merge:
        print("VALIDATION PROBLEMS (aborting before write):")
        for m in could_not_merge:
            print(" -", m)
        sys.exit(1)

    # ------------------------------------------------------------------
    # children[] = invert parents[] across the full final array.
    # ------------------------------------------------------------------
    code_set = {f["code"] for f in entries}
    children_map = {c: [] for c in code_set}
    for f in entries:
        for p in f["parents"]:
            if p["code"] in children_map:
                children_map[p["code"]].append(f["code"])
    for f in entries:
        f["children"] = sorted(set(children_map[f["code"]]))

    # ------------------------------------------------------------------
    # Validation (same shape as v14).
    # ------------------------------------------------------------------
    problems = []
    codes_seen = set()
    for f in entries:
        if not f["parents"]:
            problems.append(f"orphan: {f['code']} has no parents")
        if f["code"] in codes_seen:
            problems.append(f"duplicate code: {f['code']}")
        codes_seen.add(f["code"])
        if not CODE_RE.match(f["code"]):
            problems.append(f"grammar violation: {f['code']}")
        if f["status"] != "current" and not (f.get("status_note") or "").strip():
            problems.append(f"status={f['status']!r} with empty status_note: {f['code']}")
    if problems:
        print("VALIDATION PROBLEMS:")
        for p in problems[:50]:
            print(" -", p)
        sys.exit(1)

    # ------------------------------------------------------------------
    # counts{} recompute.
    # ------------------------------------------------------------------
    canonical_doc["counts"] = {
        "entries": len(entries),
        "by_status": dict(Counter(e["status"] for e in entries)),
        "by_domain": dict(Counter(e["domain"] for e in entries if e.get("domain"))),
        "by_tier": dict(Counter(e["tier"] for e in entries)),
        "by_coq_status": dict(Counter(e["coq"]["coq_status"] for e in entries)),
        "computed": f"{DATE} from canonical[] (scripts/v17_river_merge.py)",
    }

    # ------------------------------------------------------------------
    # Write outputs. Only entries this run added/touched are new content;
    # every pre-existing entry object is passed through unchanged (we only
    # ever appended to `entries` or appended to one entry's own
    # `occurrences[]`, never rewrote an unrelated entry's fields).
    # ------------------------------------------------------------------
    if new_codes or occurrence_notes:
        text = json.dumps(canonical_doc, indent=2, ensure_ascii=False)
        open(CANONICAL_PATH, "w", encoding="utf-8").write(text + "\n")
        print(f"Wrote {CANONICAL_PATH}: {len(entries)} canonical entries "
              f"(was {entries_before}).")

    if lineage_events:
        with open(LINEAGE_PATH, "a", encoding="utf-8") as fh:
            for ev in lineage_events:
                fh.write(json.dumps(ev, ensure_ascii=False) + "\n")
        print(f"Appended {len(lineage_events)} events to {LINEAGE_PATH}")

    json.dump(merged_map, open(RIVER_MERGED_MAP_PATH, "w", encoding="utf-8"),
               indent=2, ensure_ascii=False, sort_keys=True)
    with open(RIVER_MERGED_MAP_PATH, "a", encoding="utf-8") as fh:
        fh.write("\n")

    print("\nv1.7 Equation River merge complete.")
    print(f"  proposals total: {len(proposals)}")
    print(f"  new entries created: {len(new_codes)}: {new_codes}")
    print(f"  phi-equivalent occurrences recorded: {len(occurrence_notes)}: {occurrence_notes}")
    print(f"  already-merged (idempotent skip): {len(skipped_already_merged)}: {skipped_already_merged}")
    print(f"  alias -> code map: {json.dumps(merged_map, indent=2)}")


if __name__ == "__main__":
    main()
