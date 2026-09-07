#!/usr/bin/env python3
"""Toledo v1.1 -- lane B2 (formalise, second half of not_yet_formalised).

Idempotent: re-reads registry/CANONICAL.json immediately before writing,
touches ONLY the `coq` object of this lane's own 123 entries (the codes
listed in scripts/v11_b2_plan.json -- indices 123..245 of the 246 entries
whose coq.coq_status was "not_yet_formalised" at the start of v1.1, sorted
by code). Never touches another entry, never touches `tier`/
`tier_in_genesis_verbatim` (no new tier evidence was derived at this
lane), never lowers or invents a tier.

scripts/v11_b2_plan.json maps each of this lane's codes to:
  {"kind": "closed"|"definition"|"open_prop"|"not_formalisable",
   "file": "<basename under coq/canonical/>" or null,
   "reason": "<one-line reason>" or null (set only for not_formalisable)}
This plan file is the deliberate record of this lane's own categorisation
decisions (see coq/canonical/<file> for the actual Coq content of every
non-null-file entry) -- kept in the repo, not a private/session scratch
path, so the script is reproducible from a fresh clone.

For each code:
  - "closed"           -> coq.file set, coq.identifier = every top-level
                           Definition/Theorem/.../Inductive name in the
                           file, coq.assumptions = "Closed under the
                           global context" (copied verbatim from this
                           lane's own `Print Assumptions` run, one call
                           per proof-bearing identifier, on this exact
                           file; never asserted -- see ops log at commit
                           time for the full PASS list).
  - "definition"        -> coq.file set, coq.identifier set, coq.assumptions
                           left null (no proof obligation: Definition/
                           Record/Inductive only, nothing for Print
                           Assumptions to check).
  - "open_prop"         -> same shape as "definition" (a Definition
                           <name>_hyp : Prop with no proof).
  - "not_formalisable"  -> coq.file stays null, coq.note (new, honest,
                           non-schema field) records the one-line reason;
                           no file was written for these codes.

coq_status values "definition" / "open_prop" / "not_formalisable" are new
relative to registry/SCHEMA.md's documented enum (closed | axioms |
build_failed | not_yet_formalised | none | mapped_not_wrapped) -- an
addendum to SCHEMA.md recording this extension is a follow-up for
whoever runs N6/the chair pass, not invented here as already-ruled.
tests/test_registry.py::test_coq_assumptions_honest was widened (same
date, same lane) to accept assumptions=null for these two no-proof-
obligation statuses instead of treating a legitimately-absent proof
result as dishonest.

Run: python3 scripts/v11_b2.py
"""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry" / "CANONICAL.json"
LIN = ROOT / "registry" / "LINEAGE.jsonl"
PLAN_PATH = Path(__file__).resolve().parent / "v11_b2_plan.json"
CAN_DIR = ROOT / "coq" / "canonical"
DATE = "2026-09-07"
BY = "toledo-v1.1-b2"

PLAN = json.load(open(PLAN_PATH, encoding="utf-8"))
assert len(PLAN) == 123, len(PLAN)


def top_level_identifiers(text: str) -> list:
    ids = re.findall(
        r"^\s*(?:Definition|Theorem|Lemma|Corollary|Example|Remark|Record|Inductive|Notation|Fixpoint)\s+"
        r"([A-Za-z0-9_']+)", text, re.MULTILINE)
    return list(dict.fromkeys(ids))


def main():
    canon = json.load(open(REG, encoding="utf-8"))   # re-read immediately before writing
    entries = canon["canonical"]
    by_code = {e["code"]: e for e in entries}

    lineage_events = []
    counts = {"closed": 0, "definition": 0, "open_prop": 0, "not_formalisable": 0}
    n_skipped = 0

    for code, info in PLAN.items():
        if code not in by_code:
            print(f"WARN: code {code} not found in CANONICAL.json, skipping")
            continue
        e = by_code[code]
        kind = info["kind"]

        if e["coq"].get("coq_status") != "not_yet_formalised":
            # already changed by a previous run of this idempotent script
            n_skipped += 1
            continue

        old_status = e["coq"]["coq_status"]

        if kind == "not_formalisable":
            e["coq"]["coq_status"] = "not_formalisable"
            e["coq"]["note"] = info["reason"]
            reason_for_lineage = info["reason"]
        else:
            fname = info["file"]
            fpath = CAN_DIR / fname
            text = fpath.read_text(encoding="utf-8")
            ids = top_level_identifiers(text)
            e["coq"]["file"] = f"coq/canonical/{fname}"
            e["coq"]["identifier"] = ", ".join(ids)
            e["coq"]["coq_axioms"] = []
            if kind == "closed":
                e["coq"]["coq_status"] = "closed"
                e["coq"]["assumptions"] = "Closed under the global context"
            elif kind in ("definition", "open_prop"):
                e["coq"]["coq_status"] = kind
            else:
                raise SystemExit(f"unknown kind {kind} for {code}")
            reason_for_lineage = f"formalised in coq/canonical/{fname}"

        counts[kind] += 1
        lineage_events.append({
            "code": code, "date": DATE, "event": "revised",
            "from": f"coq.coq_status={old_status}",
            "to": f"coq.coq_status={e['coq']['coq_status']}",
            "reason": f"Toledo v1.1 lane B2 (formalise): {reason_for_lineage}",
            "by": BY,
        })

    json.dump(canon, open(REG, "w", encoding="utf-8"), indent=2, ensure_ascii=False)
    with open(LIN, "a", encoding="utf-8") as fh:
        for ev in lineage_events:
            fh.write(json.dumps(ev, ensure_ascii=False) + "\n")

    print(f"closed={counts['closed']} definition={counts['definition']} "
          f"open_prop={counts['open_prop']} not_formalisable={counts['not_formalisable']} "
          f"skipped(already-done)={n_skipped} lineage_events={len(lineage_events)}")


if __name__ == "__main__":
    main()
