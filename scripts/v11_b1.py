#!/usr/bin/env python3
"""Toledo v1.1 lane B1 -- registry updater (idempotent).

Applies the lane's build-verified outcome to CANONICAL.json, touching ONLY
the coq{}/tier/tier_evidence fields of lane B1's own 123 entries (the first
half, by code order, of the 246 coq.coq_status=="not_yet_formalised" entries
as they stood at hand-off). Re-reads CANONICAL.json immediately before
writing (another lane may have written it meanwhile) and writes back the
full structure with only these entries' fields changed. Appends one
LINEAGE.jsonl event per entry whose coq_status or tier actually changes;
running twice is a no-op (skips entries already at the target state).
"""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
CAN_DIR = ROOT / "coq" / "canonical"
DATE = "2026-09-07"
BY = "toledo-v1.1-b1"

IDENT_RE = re.compile(
    r"^\s*(?:Definition|Theorem|Corollary|Example|Remark|Record|Inductive|Notation|Fixpoint)\s+"
    r"([A-Za-z0-9_']+)", re.MULTILINE)


def mangle(code: str) -> str:
    return code.replace("/", "__").replace(".", "_").replace("-", "_")


def extract_idents(code: str) -> str:
    path = CAN_DIR / f"{mangle(code)}.v"
    text = path.read_text(encoding="utf-8")
    ids = IDENT_RE.findall(text)
    return ", ".join(dict.fromkeys(ids))


# ===========================================================================
# Outcome table: code -> (coq_status, tier_or_None, tier_evidence_or_None)
#   tier_or_None: new tier value, or None to leave tier unchanged
#   tier_evidence: short justification string, or None to leave field unset
# ===========================================================================
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
CLOSED_TIER_UNCHANGED = [
    "A.5/W.13.v1", "A.5/W.14.v1", "A.5/W.15.v1", "A.5/W.16.v1",
    "A.5/W.17.v1", "A.5/W.18.v1", "A.5/W.19.v1", "A.5/W.20.v1",
    "EQ-001/B.11.v1",
]
OPEN_PROP_TIER_UNCHANGED = [
    "EQ-001/B.29.v1", "EQ-001/B.30.v1", "EQ-001/B.31.v1", "EQ-001/B.32.v1", "EQ-001/B.33.v1",
]

NOT_FORMALISABLE = {
    "EQ-001/B.01.v1": "prose restatement of the root axiom (retained distinction, "
        "asymmetric ordering) already formalised elsewhere under E00.x/EQ-008; no new "
        "operator introduced by this domain-registry entry.",
    "EQ-001/B.02.v1": "prose restatement (ordered transitions with tau_c>0), no operator "
        "of its own beyond the already-formalised root ordering.",
    "EQ-001/B.03.v1": "prose narrative naming an external carrier G* and a BIO-G1 gate "
        "defined only in biology_closure_v0_1.py (not in this Coq corpus); formalising "
        "would require inventing that carrier's operations.",
    "EQ-001/B.04.v1": "reports a specific witness computation (nu, F on strings 'ab'/'ba') "
        "from an external script (biology_closure_v0_1.py) not present in this Coq corpus; "
        "formalising would require inventing nu and F.",
    "EQ-001/B.05.v1": "narrative comparison of quotients q_seq/q_first defined only in the "
        "external script; no self-contained operator given here.",
    "EQ-001/B.06.v1": "narrative comparison of quotients q_F/q_first and O(w) defined only "
        "in the external script; no self-contained operator given here.",
    "EQ-001/B.10.v1": "narrative comparison between an unspecified 'coarse parent-quotient' "
        "and q_H, both defined only in the external script; no self-contained operator.",
    "EQ-001/B.12.v1": "references tstep, a function defined only in the external script "
        "(biology_closure_v0_1.py), not available in this Coq corpus; formalising the "
        "quoted witness values would require inventing tstep.",
    "EQ-001/B.13.v1": "exact witness values for tstep(1,1,0) and tstep(1,1,1); tstep is not "
        "defined in this registry entry or this Coq corpus -- formalising would require "
        "inventing it, which is prohibited.",
    "EQ-001/B.14.v1": "narrative summary asserting that separately-implemented theorems "
        "(decay/turnover/homeostasis-balance) compile axiom-clean elsewhere; no "
        "coq_map.json evidence links this code to a specific identifier in this corpus.",
    "EQ-001/B.15.v1": "narrative summary of separately-compiled setpoint-relaxation "
        "theorems; no coq_map.json evidence links this code to a specific identifier.",
    "EQ-001/B.16.v1": "narrative summary of a separately-compiled bistable-window theorem; "
        "no coq_map.json evidence links this code to a specific identifier.",
    "EQ-001/B.17.v1": "narrative summary of separately-compiled coupling-energy theorems; "
        "no coq_map.json evidence links this code to a specific identifier.",
    "EQ-001/B.18.v1": "prose narrative describing an open calibration gap (no encoding from "
        "q_F to real biochemistry exists); no operator to formalise.",
    "EQ-001/B.19.v1": "prose narrative describing an open calibration gap (no encoding from "
        "V_A to a real cell/organism exists); no operator to formalise.",
    "EQ-001/B.20.v1": "prose narrative: a reproduction operator R_kappa is 'declared, not "
        "derived or witnessed'; no construction is given to formalise.",
    "EQ-001/B.21.v1": "prose narrative describing an open calibration gap (frequency change "
        "vs real biological selection); no operator to formalise.",
    "EQ-001/B.22.v1": "prose narrative: 'evolution' here names a declared interpretation of "
        "an existing count trend, not a new derived law; no new operator.",
    "EQ-001/B.23.v1": "prose narrative: a declared (Dr) clinical reading of theorems already "
        "covered elsewhere, open pending calibration; no new operator here.",
    "EQ-001/B.24.v1": "prose narrative: a declared (Dr) clinical reading of theorems already "
        "covered elsewhere, open pending calibration; no new operator here.",
    "EQ-001/B.25.v1": "prose narrative: a declared (Dr) clinical reading of a theorem "
        "already covered elsewhere, open pending calibration; no new operator here.",
    "EQ-001/B.26.v1": "prose narrative: a declared (Dr) clinical reading of theorems "
        "already covered elsewhere, open pending calibration; no new operator here.",
    "EQ-001/B.27.v1": "prose narrative reporting a synthetic-only test run (PASS on "
        "synthetic tapes, no real data); no equation to formalise.",
    "EQ-001/B.28.v1": "prose narrative: 'architecture-only, not evidence' -- no executed "
        "run and no equation to formalise.",
    "BiologyDomain_living_unit/B.30.v1": "an empirical effect-size label (+15%/-6%), not "
        "an equation; the source itself flags it as structural/analogical, not a physics "
        "derivation.",
    "ChemDomain_ledger/C.14.v1": "describes a solution method (reuse the Kc=[B]/[A] "
        "equilibrium closed form on a perturbed system), not a distinct equation of its "
        "own; the underlying equilibrium equation is already formalised at C.13.v1.",
}

TIER_EVIDENCE_DEFAULT_DEFINITION = (
    "formalised as a Toledo-native Coq Definition in a finite/discrete model (Q); "
    "source tier tag was 'textbook_closure' / untagged prose, now a typed definition."
)

updates = {}
for c in DEFINITION_UNTAGGED_TO_DEFINITION:
    updates[c] = dict(coq_status="definition", new_tier="Definition",
                       tier_evidence=TIER_EVIDENCE_DEFAULT_DEFINITION)
for c in DEFINITION_TIER_UNCHANGED:
    updates[c] = dict(coq_status="definition", new_tier=None,
                       tier_evidence="typed Definition in a finite/discrete model; tier was already Definition.")
for c in CLOSED_TIER_UNCHANGED:
    updates[c] = dict(coq_status="closed", new_tier=None,
                       tier_evidence="Theorem proved in a finite model, Closed under the global context; tier left as source states.")
for c in OPEN_PROP_TIER_UNCHANGED:
    updates[c] = dict(coq_status="open_prop", new_tier=None,
                       tier_evidence="stated as an unproved Definition ..._hyp : Prop per the source's own OPEN/TARGET framing; no proof forced.")
for c, reason in NOT_FORMALISABLE.items():
    updates[c] = dict(coq_status="not_formalisable", new_tier=None, tier_evidence=reason)

assert len(updates) == 123, len(updates)

HAS_FILE_STATUSES = {"definition", "closed", "open_prop"}


def main():
    can_path = REG / "CANONICAL.json"
    lineage_path = REG / "LINEAGE.jsonl"

    data = json.loads(can_path.read_text(encoding="utf-8"))
    by_code = {e["code"]: e for e in data["canonical"]}

    changed = 0
    unchanged = 0
    lineage_events = []

    for code, u in updates.items():
        e = by_code.get(code)
        if e is None:
            raise SystemExit(f"code not found in CANONICAL.json: {code}")

        target_status = u["coq_status"]
        already_done = e["coq"]["coq_status"] == target_status
        if target_status in HAS_FILE_STATUSES:
            already_done = already_done and e["coq"]["file"] == f"coq/canonical/{mangle(code)}.v"

        if already_done:
            unchanged += 1
            continue

        old_status = e["coq"]["coq_status"]
        old_tier = e["tier"]

        if target_status in HAS_FILE_STATUSES:
            ident = extract_idents(code)
            e["coq"]["file"] = f"coq/canonical/{mangle(code)}.v"
            e["coq"]["identifier"] = ident
            # "Closed under the global context" is a claim about a Print
            # Assumptions run on a PROOF-BEARING identifier (Theorem/Lemma/
            # Corollary/Example/Remark) -- see coq/canonical/verify.sh's own
            # regex. "definition" (bare Definition/Record/Inductive) and
            # "open_prop" (an unproved Definition ..._hyp : Prop) carry no
            # proof obligation, so verify.sh never runs Print Assumptions on
            # them; asserting the closed string there would be fabricated,
            # not copied from any actual coqc output. Only "closed" gets it.
            e["coq"]["assumptions"] = (
                "Closed under the global context" if target_status == "closed" else None
            )
            e["coq"]["coq_status"] = target_status
            e["coq"]["coq_axioms"] = []
            e["coq"]["coq_source_redistributed"] = True
        else:  # not_formalisable
            e["coq"]["coq_status"] = target_status
            # file/identifier/assumptions stay null; coq_axioms empty; leave
            # coq_source_redistributed untouched (no code exists to redistribute)

        if u["new_tier"] is not None:
            e["tier"] = u["new_tier"]
        if u["tier_evidence"] is not None:
            e["tier_evidence"] = u["tier_evidence"]

        lineage_events.append({
            "code": code, "date": DATE, "event": "revised",
            "from": f"coq_status={old_status}, tier={old_tier}",
            "to": f"coq_status={target_status}, tier={e['tier']}",
            "reason": "Toledo v1.1 lane B1: " + (
                (
                    f"Toledo-native wrapper coq/canonical/{mangle(code)}.v written and "
                    f"coqc-verified ({e['coq']['assumptions']})."
                    if target_status == "closed" else
                    f"Toledo-native wrapper coq/canonical/{mangle(code)}.v written "
                    f"({target_status}: no proof obligation, assumptions left null)."
                )
                if target_status in HAS_FILE_STATUSES else
                f"decided not_formalisable -- {u['tier_evidence']}"
            ),
            "by": BY,
        })
        changed += 1

    can_path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    if lineage_events:
        with open(lineage_path, "a", encoding="utf-8") as fh:
            for ev in lineage_events:
                fh.write(json.dumps(ev, ensure_ascii=False) + "\n")

    print(f"entries changed: {changed}, already at target (skipped): {unchanged}, "
          f"lineage events appended: {len(lineage_events)}")


if __name__ == "__main__":
    main()
