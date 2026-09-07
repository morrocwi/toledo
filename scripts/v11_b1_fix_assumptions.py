#!/usr/bin/env python3
"""Toledo v1.1 -- correction for finding B1-FABRICATED-CLOSURE.

scripts/v11_b1.py (before this fix) unconditionally wrote
coq.assumptions = "Closed under the global context" for every entry it set
to coq_status in {"definition", "closed", "open_prop"}. "definition" (a bare
Definition/Record, no proof) and "open_prop" (an unproved Definition
..._hyp : Prop) carry no proof obligation -- coq/canonical/verify.sh only
runs `Print Assumptions` on Theorem/Lemma/Corollary/Example/Remark
identifiers, never on a Definition -- so for those two statuses the string
was asserted by the script, not copied from any actual verify.sh/coqc
output (registry/SCHEMA.md: "assumptions ... never asserted, always copied
from coq/verify_all.sh's own output").

This script is idempotent: it re-reads registry/CANONICAL.json immediately
before writing, sets coq.assumptions back to null for exactly the 88 codes
lane B1 affected (the union of DEFINITION_UNTAGGED_TO_DEFINITION,
DEFINITION_TIER_UNCHANGED and OPEN_PROP_TIER_UNCHANGED from
scripts/v11_b1.py -- 83 "definition" + 5 "open_prop"), and appends one
LINEAGE.jsonl `revised` event per entry actually changed. Running it twice
is a no-op (skips entries already at assumptions=null).

It does NOT touch coq_status, tier, file, identifier, or any entry outside
this set -- scripts/v11_b1.py itself has already been fixed (this file's
sibling patch) so it will not reintroduce the bug on a future re-run.
"""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
DATE = "2026-09-07"
BY = "toledo-v1.1-b1"

# Same three lists as scripts/v11_b1.py -- the only entries this lane ever
# set to "definition" or "open_prop".
DEFINITION_UNTAGGED_TO_DEFINITION = (
    [f"BiologyDomain_living_unit/B.{i:02d}.v1" for i in range(1, 30)]
    + [f"ChemDomain_ledger/C.{i:02d}.v1" for i in list(range(1, 14)) + list(range(15, 43))]
    + ["BridgeCommute/H.01.v1"]
    + ["EQ-001/B.07.v1", "EQ-001/B.08.v1", "EQ-001/B.09.v1"]
)
DEFINITION_TIER_UNCHANGED = [
    "A.5/S.04.v1", "A.5/S.05.v1", "A.5/S.06.v1", "A.5/S.07.v1", "A.5/S.09.v1",
    "A.5/S.17.v1", "A.5/S.20.v1", "A.5/W.08.v1", "A.5/W.09.v1",
]
OPEN_PROP_TIER_UNCHANGED = [
    "EQ-001/B.29.v1", "EQ-001/B.30.v1", "EQ-001/B.31.v1", "EQ-001/B.32.v1", "EQ-001/B.33.v1",
]

TARGET_CODES = set(DEFINITION_UNTAGGED_TO_DEFINITION) | set(DEFINITION_TIER_UNCHANGED) | set(OPEN_PROP_TIER_UNCHANGED)
assert len(TARGET_CODES) == 88, len(TARGET_CODES)


def main():
    can_path = REG / "CANONICAL.json"
    lineage_path = REG / "LINEAGE.jsonl"

    data = json.loads(can_path.read_text(encoding="utf-8"))  # re-read immediately before writing
    by_code = {e["code"]: e for e in data["canonical"]}

    changed = 0
    unchanged = 0
    lineage_events = []

    for code in sorted(TARGET_CODES):
        e = by_code.get(code)
        if e is None:
            raise SystemExit(f"code not found in CANONICAL.json: {code}")

        coq = e["coq"]
        if coq.get("coq_status") not in ("definition", "open_prop"):
            raise SystemExit(
                f"{code}: expected coq_status in (definition, open_prop), "
                f"found {coq.get('coq_status')!r} -- refusing to touch, investigate"
            )

        if coq.get("assumptions") is None:
            unchanged += 1
            continue

        old_assumptions = coq["assumptions"]
        coq["assumptions"] = None

        lineage_events.append({
            "code": code, "date": DATE, "event": "revised",
            "from": f"coq.assumptions={old_assumptions!r} (asserted, no proof obligation)",
            "to": "coq.assumptions=null",
            "reason": (
                "Toledo v1.1 correction (B1-FABRICATED-CLOSURE): coq_status="
                f"{coq['coq_status']!r} carries no proof obligation (bare Definition/"
                "Record, or an unproved Definition ..._hyp : Prop) -- verify.sh never "
                "runs Print Assumptions on it, so 'Closed under the global context' was "
                "never actually derived for this entry; reset to null per SCHEMA.md's "
                "own honesty rule and matching scripts/v11_b2.py's handling of the same "
                "shape."
            ),
            "by": BY,
        })
        changed += 1

    can_path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    if lineage_events:
        with open(lineage_path, "a", encoding="utf-8") as fh:
            for ev in lineage_events:
                fh.write(json.dumps(ev, ensure_ascii=False) + "\n")

    print(f"entries corrected: {changed}, already null (skipped): {unchanged}, "
          f"lineage events appended: {len(lineage_events)}")


if __name__ == "__main__":
    main()
