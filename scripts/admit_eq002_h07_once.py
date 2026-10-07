#!/usr/bin/env python3
import json
import pathlib
import re

root = pathlib.Path(".")
canonical_path = root / "registry" / "CANONICAL.json"
lineage_path = root / "registry" / "LINEAGE.jsonl"
coq_path = root / "coq" / "canonical" / "EQ_002__H_07_v1.v"
proposal_path = root / "mcp" / "proposals" / "manual-2026-10-07_zoom-hca-master-weld.json"
workflow_path = root / ".github" / "workflows" / "admit-eq002-h07-once.yml"
self_path = root / "scripts" / "admit_eq002_h07_once.py"

obj = json.loads(canonical_path.read_text(encoding="utf-8"))
code = "EQ-002/H.07.v1"
internal_id = "CAN-1318"

if any(e.get("code") == code for e in obj["canonical"]):
    raise SystemExit(f"FAIL-CLOSED: {code} already exists")
if any(e.get("id") == internal_id for e in obj["canonical"]):
    raise SystemExit(f"FAIL-CLOSED: {internal_id} already exists")

existing_h = sorted(
    e["code"] for e in obj["canonical"]
    if e.get("root") == "EQ-002" and e.get("domain") == "H"
)
if not {"EQ-002/H.05.v1", "EQ-002/H.06.v1"}.issubset(set(existing_h)):
    raise SystemExit(f"FAIL-CLOSED: expected H.05/H.06; found {existing_h}")

max_can = max(
    [int(m.group(1)) for e in obj["canonical"]
     if (m := re.fullmatch(r"CAN-(\d+)", str(e.get("id", ""))))],
    default=0,
)
if max_can != 1317:
    raise SystemExit(
        f"FAIL-CLOSED: expected max CAN id 1317, found {max_can}; registrar must reassign"
    )

parent_codes = [
    "EQ-002/M.03.v1",
    "EQ-002/H.03.v1",
    "A.5/H.17.v1",
    "EQ-015/H.32.v1",
    "A.5/H.18.v1",
    "A.8/H.03.v1",
]
by_code = {e["code"]: e for e in obj["canonical"]}
missing = [p for p in parent_codes if p not in by_code]
if missing:
    raise SystemExit(f"FAIL-CLOSED: missing parents {missing}")

statement = (
    "Z^Zoom_{i,g,t} --q_B--> B^bar_{i,t} "
    "--u*_{diag}--> C^cand_{i,t} "
    "--Endorse_i--> C^live_{i,t} "
    "--pi*_{scaffold}--> R^return_{H,i,t+1} "
    "--Retention--> DeltaH_{i,t+1} "
    "--LiveField--> L_{H,i,t+1} "
    "--G_O--> Omega^real_{i,t+1} "
    "--Record--> A^HCA_{i,t+1}"
)

entry = {
    "id": internal_id,
    "code": code,
    "root": "EQ-002",
    "layer": "reading",
    "domain": "H",
    "aliases": ["PROP-ZHCA-MASTER-01", "Zoom-HCA-Master-Weld"],
    "name": "Synchronous videoconference learning to Human Capability master weld",
    "statement": {"latest": statement, "format": "ascii-math"},
    "statements_history": [{
        "v": 1,
        "statement": statement,
        "date": "2026-10-07",
        "reason": (
            "Human-registrar-approved admission after TG-RFG-01 reuse-first review, "
            "phenomenology stress testing, public-dataset-backed stress testing, and "
            "correction of a preflight code collision. Registers only the missing "
            "synchronous-videoconference domain composition; reuses existing HCA objects "
            "for barriers, human-endorsed routes, scaffold fading, realized opportunity, "
            "and net advancement."
        ),
        "by": "human-registrar-approved-2026-10-07",
    }],
    "parents": [
        {
            "code": "EQ-002/M.03.v1",
            "derived_via": "reads",
            "evidence": "Primary EQ-002 readout lineage for this domain reading.",
        },
        {
            "code": "EQ-002/H.03.v1",
            "derived_via": "specializes",
            "evidence": (
                "Reuses the registered HCA native river and specializes it to "
                "synchronous group videoconference learning."
            ),
        },
        {
            "code": "A.5/H.17.v1",
            "derived_via": "specializes",
            "evidence": (
                "Reuses candidate-route generation and human endorsement; "
                "AI suggestion is not human choice."
            ),
        },
        {
            "code": "EQ-015/H.32.v1",
            "derived_via": "specializes",
            "evidence": "Reuses scaffold fading and stable unaided-return logic.",
        },
        {
            "code": "A.5/H.18.v1",
            "derived_via": "specializes",
            "evidence": (
                "Reuses realized opportunity rather than equating capability "
                "with opportunity."
            ),
        },
        {
            "code": "A.8/H.03.v1",
            "derived_via": "specializes",
            "evidence": "Reuses the HCA net-advancement record as terminal record.",
        },
    ],
    "children": [],
    "origin": {
        "source": "domain_registry",
        "repo_anchor": None,
        "record_id": None,
        "doi": None,
        "section": (
            "TOLEDO-ZOOM Global Standalone HCA integration; "
            "human-registrar-approved domain specialization, 2026-10-07"
        ),
    },
    "status": "current",
    "status_note": "",
    "superseded_by": None,
    "tier": "Definition",
    "tier_in_genesis_verbatim": (
        "New Derivation / Proposal; admitted as Definition after registrar review"
    ),
    "coq": {
        "file": "coq/canonical/EQ_002__H_07_v1.v",
        "identifier": "EQ_002__H_07_v1_master_weld",
        "assumptions": None,
        "imported_from": None,
        "coq_status": "definition",
        "coq_axioms": [],
        "coq_source_redistributed": True,
    },
    "relations": [
        {
            "type": "reads",
            "target": "weld/M.02.v1",
            "note": (
                "Uses canonical domain-weld compatibility; "
                "does not replace or strengthen it."
            ),
        },
        {
            "type": "refines",
            "target": "A.5/H.08.v1",
            "note": (
                "Makes Assisted performance != Unaided Human Return explicit "
                "in the learning-to-HCA path."
            ),
        },
        {
            "type": "refines",
            "target": "A.5/H.09.v1",
            "note": (
                "Extends Exposure != Retention != Improvement toward capability "
                "and realized opportunity without collapsing stages."
            ),
        },
    ],
    "occurrences": [],
    "role": "domain-gate",
    "first_assigned": "2026-10-07",
    "drift_note": (
        "Domain specialization only. No scalar human-potential score is defined. "
        "Proximal videoconference-learning architecture has phenomenological and "
        "public-dataset-backed support; distal HCA stages (stable unaided return, "
        "live possibility expansion, realized opportunity) remain end-to-end empirical "
        "validation gaps. The chain is registered as a Definition/composition, "
        "not as a proved causal law."
    ),
}

obj["canonical"].append(entry)

for p in parent_codes:
    pe = by_code[p]
    pe.setdefault("children", [])
    if code not in pe["children"]:
        pe["children"].append(code)

canonical_path.write_text(
    json.dumps(obj, ensure_ascii=False, indent=2) + "\n",
    encoding="utf-8",
)

lineage_row = {
    "code": code,
    "date": "2026-10-07",
    "event": "assigned",
    "from": None,
    "to": (
        "EQ-002/H.07.v1: synchronous videoconference learning -> HCA master weld; "
        "tier=Definition; status=current; internal id=CAN-1318"
    ),
    "reason": (
        "Human registrar approval following TG-RFG-01 reuse-first review. "
        "Initial H.05 suggestion was rejected after direct CANONICAL.json inspection "
        "showed existing EQ-002/H.05.v1 and H.06.v1; H.07 is the corrected next slot. "
        "The admitted object is only the missing domain composition and preserves "
        "all registered HCA non-collapse boundaries."
    ),
    "by": "human-registrar-approved-2026-10-07",
}
with lineage_path.open("a", encoding="utf-8") as fh:
    fh.write(json.dumps(lineage_row, ensure_ascii=False) + "\n")

coq_path.write_text("""(* EQ-002/H.07.v1 -- synchronous videoconference learning to HCA master weld *)
(* Registry tier: Definition. This file defines the composition only. *)
(* It proves no empirical or causal claim and introduces no axioms. *)

Section EQ_002__H_07_v1_sec.

  Parameter ZoomState Barrier CandidateRoute LiveRoute : Type.
  Parameter HumanReturn ReturnDelta LiveField : Type.
  Parameter RealizedOpportunity NetAdvancement : Type.

  Parameter q_B : ZoomState -> Barrier.
  Parameter u_diag : Barrier -> CandidateRoute.
  Parameter endorse : CandidateRoute -> LiveRoute.
  Parameter scaffold : LiveRoute -> HumanReturn.
  Parameter retain : HumanReturn -> ReturnDelta.
  Parameter live_field : ReturnDelta -> LiveField.
  Parameter G_O : LiveField -> RealizedOpportunity.
  Parameter record_advancement : RealizedOpportunity -> NetAdvancement.

  Definition EQ_002__H_07_v1_master_weld
      (z : ZoomState) : NetAdvancement :=
    record_advancement
      (G_O
        (live_field
          (retain
            (scaffold
              (endorse
                (u_diag
                  (q_B z))))))).

End EQ_002__H_07_v1_sec.
""", encoding="utf-8")

for path in (proposal_path, workflow_path, self_path):
    if path.exists():
        path.unlink()

print("ADMITTED", code, internal_id)
print("canonical_count", len(obj["canonical"]))
