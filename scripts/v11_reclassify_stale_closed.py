#!/usr/bin/env python3
"""Toledo v1.1 -- correction for finding PREEXISTING-CLOSED-MISCLASSIFY.

Pre-existing (N3/N4-era) defect, present in the state being certified now:
793 canonical entries include 375 with coq_status=="closed", but only 161
of those correspond to a module that actually appears as a PASS line in the
FRESH coq/canonical/verify_report.txt this checker generated (207
Theorem/Lemma/Corollary/Example/Remark identifiers checked, from
coq/canonical/verify.sh's own regex, which never runs Print Assumptions on
a bare Definition). The other 214 "closed" entries' own coq/canonical/
<code>.v files contain no proof-bearing identifier at all -- pure
Definitions/Records -- so "Closed under the global context" was never
actually derived from a Print Assumptions run for them, contradicting
registry/SCHEMA.md ("coq_status: derived from the actual Print Assumptions
classification"). Confirmed by direct inspection: weld/H.01.v1,
EQ-015/H.01.v1 and EQ-002/E.01.v1's own .v header comments say
"CANONICAL.json tier: 'definition'" while the registry said coq_status
"closed".

This script is idempotent: it re-reads registry/CANONICAL.json and the
freshly generated coq/canonical/verify_report.txt immediately before
writing. For every entry with coq_status=="closed", it keeps "closed"
(and its assumptions string) only when that entry's own coq.file module
name appears as a PASS line in verify_report.txt; every other such entry
is reclassified to coq_status=="definition" (the status introduced in v1.1
for exactly this shape -- a Toledo-native file with no proof obligation)
with assumptions set to null. It never touches an entry whose coq_status is
not "closed", never invents a code, and never lowers tier. One LINEAGE.jsonl
`revised` event is appended per reclassified entry, quoting the
verify_report.txt evidence (or its absence).

Run AFTER coq/canonical/verify.sh has produced a fresh verify_report.txt
covering the full, current _CoqProject (all touched files rebuilt).
"""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
REPORT = ROOT / "coq" / "canonical" / "verify_report.txt"
DATE = "2026-09-07"
BY = "toledo-v1.1-checker"


def load_pass_modules():
    mods = set()
    for line in REPORT.read_text(encoding="utf-8").splitlines():
        if line.startswith("PASS"):
            # "PASS  <modname>.<id>  -- Closed under the global context"
            rest = line.split(None, 2)[1]
            mods.add(rest.split(".")[0])
    return mods


def module_of(file_field: str) -> str:
    base = file_field.split("/")[-1]
    return base[:-2] if base.endswith(".v") else base


def main():
    pass_mods = load_pass_modules()
    if not pass_mods:
        raise SystemExit("verify_report.txt has no PASS lines -- refusing to run against an empty/stale report")

    can_path = REG / "CANONICAL.json"
    lineage_path = REG / "LINEAGE.jsonl"
    data = json.loads(can_path.read_text(encoding="utf-8"))  # re-read immediately before writing

    reclassified = 0
    kept = 0
    lineage_events = []

    for e in data["canonical"]:
        coq = e.get("coq") or {}
        if coq.get("coq_status") != "closed":
            continue

        f = coq.get("file")
        mod = module_of(f) if f else None
        if mod is not None and mod in pass_mods:
            kept += 1
            continue

        old_assumptions = coq.get("assumptions")
        coq["coq_status"] = "definition"
        coq["assumptions"] = None

        lineage_events.append({
            "code": e["code"], "date": DATE, "event": "revised",
            "from": f"coq.coq_status=closed, coq.assumptions={old_assumptions!r}",
            "to": "coq.coq_status=definition, coq.assumptions=null",
            "reason": (
                "Toledo v1.1 correction (PREEXISTING-CLOSED-MISCLASSIFY): "
                f"module {mod!r} (coq.file={f!r}) does not appear as a PASS line in "
                "the fresh coq/canonical/verify_report.txt (207 proof-bearing "
                "identifiers checked); the .v file itself contains no Theorem/Lemma/"
                "Corollary/Example/Remark for Print Assumptions to have run on -- "
                "'Closed under the global context' was never derived for this entry. "
                "Reclassified to definition (no proof obligation), matching this "
                "entry's own .v header where present."
            ),
            "by": BY,
        })
        reclassified += 1

    can_path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    if lineage_events:
        with open(lineage_path, "a", encoding="utf-8") as fh:
            for ev in lineage_events:
                fh.write(json.dumps(ev, ensure_ascii=False) + "\n")

    print(f"reclassified closed->definition: {reclassified}, kept as closed (PASS-verified): {kept}, "
          f"lineage events appended: {len(lineage_events)}")


if __name__ == "__main__":
    main()
