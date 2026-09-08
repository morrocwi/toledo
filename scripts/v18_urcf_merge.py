#!/usr/bin/env python3
"""Toledo v1.8 REGISTRAR merge -- registry/proposals/urcf_turbulence.json.

One founder-instructed proposal (2026-09-08 intake): the Retained-
Information Relaxation-Inertia turbulence prediction equation, tau_R
dI_R/dt + L_R I_R = S_R + eta_R, from a standalone research pack never
deposited on Zenodo.

Same idiom as scripts/v18_ranc_merge.py / scripts/v18_causal_merge.py:
re-reads registry/CANONICAL.json immediately before the one atomic
write, aborts if the alias/code already exists (idempotent), verifies
BOTH parents against the LIVE registry:
  - weld/S.01.v1 (instance_of) -- the Finite-Memory Laplacian/Telegraph
    Generator this equation instantiates in a new domain (turbulence
    structural state I_R instead of the social-instability state s).
  - the proposal file's own "root/EQ-008" (instance_of) -- CHECKED
    against genesis_root.json's own convention and every existing
    bare-root parent citation in CANONICAL.json (e.g. `weld/M.01.v1 <-
    weld`, `EQ-015/M.01.v1 <- EQ-015`): root codes are always cited
    BARE, never "root/"-prefixed. genesis_root.json's own row id is
    "EQ-008", not "root/EQ-008" -- the proposal file's prefix does not
    match the registry's convention and is corrected to "EQ-008" here
    (not silently kept wrong).

Preserves the proposal's own `does_not_resolve` caveat (Genesis root gap
T2 is NOT closed by this entry -- it is the easier linear/time-invariant
sub-case) verbatim inside the new entry's `drift_note` field
(registry/SCHEMA.md: "this entry's placement (parent/relation) is
disclosed as weaker than a demonstrated reading -- quotes what was
checked and why no stronger evidence was found" -- exactly this
disclosure's own shape), alongside the EQ-008 structural-match caveat
(the source paper does not itself cite EQ-008; the attachment records a
structural match found at intake, not an author claim).

origin.doi stays null (never deposited); origin.source cites the
standalone YAML pack by its exact filename, no /home path.

coq_status: open_prop (tier Definition per the source's own framing, but
unproved -- a structural instance claim, not a proof). Coq stub same
open_prop discipline as the causal-sweep stubs: no proof attempted.

Run: python3 scripts/v18_urcf_merge.py
"""
import json
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
CAN_DIR = ROOT / "coq" / "canonical"
DATE = "2026-09-08"
BY = "toledo-v1.8-urcf"

CANONICAL_PATH = REG / "CANONICAL.json"
GENESIS_PATH = REG / "genesis_root.json"
LINEAGE_PATH = REG / "LINEAGE.jsonl"
PROPOSALS_PATH = REG / "proposals" / "urcf_turbulence.json"

PARENT_WELD = "weld/S.01.v1"
PARENT_ROOT_RAW = "root/EQ-008"   # as written in the proposal file
PARENT_ROOT_CORRECTED = "EQ-008"  # registry's own bare-root convention

STATEMENT_LATEST = r"\tau_R \frac{dI_R}{dt} + L_R I_R = S_R + \eta_R"

COQ_FILE_REL = "coq/canonical/weld__P_05_v1.v"

DRIFT_NOTE = (
    "Two disclosed weaknesses, preserved from the intake proposal "
    "(registry/proposals/urcf_turbulence.json), never silently resolved: "
    "(1) parent EQ-008 (instance_of): \"The source's own definition of "
    "L_R ('graph Laplacian / scale Laplacian / linearized restoration "
    "operator / positive operator, positive semidefinite, zero-mode "
    "policy declared') matches, in words, IDM/Genesis root EQ-008's "
    "canonical definition L_R := D_W - W (weighted-degree minus "
    "retained-adjacency, a full operator on a multimode state). The "
    "source paper does not itself cite EQ-008; this attachment records a "
    "structural match found at intake, not an author claim.\" (2) "
    "does_not_resolve (genesis_root_gap T2): \"Genesis root row T2 "
    "('endogenous state-dependent L_R[I_R], where the operator itself "
    "depends on the state it is acting on') is the harder, still-open "
    "case. This equation's own stated assumption set explicitly keeps "
    "'L_R time-independent' (solution_form_linear_time_invariant) -- it "
    "is the easier linear/state-independent sub-case, not an attempted "
    "or claimed resolution of T2. State this honestly if the entry is "
    "ever cited near T2.\""
)

STATUS_NOTE = (
    "URCF turbulence proposal (2026-09-08); unverified, PASS_WITH_LIMITS "
    "per the source's own numerical run_log_anchor (6 test cases x 3 grid "
    "sizes x 3 viscosities); no glosa/cases/repro/ evidence file exists "
    "yet, no resistance rung held. Does NOT resolve Genesis root gap T2 -- "
    "see drift_note."
)

COQ_SRC = f"""(* weld/P.05.v1 -- open_prop -- Retained-information relaxation-inertia *)
(* turbulence prediction equation: instance_of weld/S.01.v1 (Finite-Memory *)
(* Laplacian/Telegraph Generator) applied to a new domain (turbulence *)
(* structural state I_R), and a structural (not author-cited) match to *)
(* IDM/Genesis root EQ-008's L_R := D_W - W. Does NOT resolve Genesis root *)
(* gap T2 (this is the linear/time-invariant L_R sub-case only). *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* {STATEMENT_LATEST} *)
(* Toledo v1.8 (URCF merge): finite-model open_prop -- I_R, S_R, eta_R are *)
(* abstract Section Parameters over a declared state space; L_R is a *)
(* declared positive-semidefinite linear operator on that space (per the *)
(* source's own zero-mode-policy declaration); tau_R > 0. Unproved by *)
(* design (source's own "Definition", not a proved theorem). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Section weld__P_05_v1_sec.
  Variable Time : Type.
  Variable State : Type.        (* the declared state space I_R lives in *)
  Variable zero : State.
  Variable add sub : State -> State -> State.
  Variable scale : Q -> State -> State.
  Variable L_R : State -> State.        (* declared linear operator *)
  Variable positive_semidefinite : (State -> State) -> Prop.
  Variable I_R S_R eta_R : Time -> State.
  Variable dI_R_dt : Time -> State.
  Variable tau_R : Q.

  Definition weld__P_05_v1_hyp : Prop :=
    tau_R > 0 /\\
    positive_semidefinite L_R /\\
    forall t : Time,
      add (scale tau_R (dI_R_dt t)) (L_R (I_R t)) = add (S_R t) (eta_R t).
End weld__P_05_v1_sec.
"""

NEW_ENTRY = {
    "code": "weld/P.05.v1",
    "root": "weld",
    "layer": "reading",
    "domain": "P",
    "aliases": ["URCF:relaxation-inertia-turbulence-law", "EQ-URCF-TURB-004"],
    "name": "Retained-information relaxation-inertia turbulence prediction equation",
    "statement": {"latest": STATEMENT_LATEST, "format": "latex"},
    "statements_history": [
        {
            "v": 1,
            "statement": STATEMENT_LATEST,
            "date": DATE,
            "reason": (
                f"{BY}: initial capture from "
                "URCF_RTPE_TURBULENCE_RELAXATION_INERTIA_DIRECT_LP_CLOSURE_v2_2_"
                "STANDALONE_PROOF_PACK.yaml"
            ),
            "by": BY,
        }
    ],
    "parents": [
        {"code": PARENT_WELD, "derived_via": "instance_of"},
        {"code": PARENT_ROOT_CORRECTED, "derived_via": "instance_of"},
    ],
    "children": [],
    "origin": {
        "source": (
            "URCF_RTPE_TURBULENCE_RELAXATION_INERTIA_DIRECT_LP_CLOSURE_v2_2_"
            "STANDALONE_PROOF_PACK.yaml (standalone research specification, "
            "not deposited on Zenodo, not reviewed by glosa)"
        ),
        "repo_anchor": None,
        "record_id": None,
        "doi": None,
        "section": None,
    },
    "status": "unverified",
    "status_note": STATUS_NOTE,
    "superseded_by": None,
    "tier": "Definition",
    "tier_in_genesis_verbatim": "",
    "coq": {
        "file": COQ_FILE_REL,
        "identifier": "weld__P_05_v1_hyp",
        "assumptions": None,
        "imported_from": None,
        "coq_status": "open_prop",
        "coq_axioms": [],
        "coq_source_redistributed": True,
    },
    "relations": [],
    "occurrences": [],
    "role": "other",
    "first_assigned": DATE,
    "drift_note": DRIFT_NOTE,
}


def recompute_counts(entries):
    return {
        "entries": len(entries),
        "by_status": dict(Counter(e["status"] for e in entries)),
        "by_domain": dict(Counter(e["domain"] for e in entries if e.get("domain"))),
        "by_tier": dict(Counter(e["tier"] for e in entries)),
        "by_coq_status": dict(Counter(e["coq"]["coq_status"] for e in entries)),
        "computed": f"{DATE} from canonical[] (scripts/v18_urcf_merge.py)",
    }


def main():
    doc = json.loads(CANONICAL_PATH.read_text(encoding="utf-8"))
    entries = doc["canonical"]
    by_code = {e["code"]: e for e in entries}

    if NEW_ENTRY["code"] in by_code:
        print(f"{NEW_ENTRY['code']} already exists -- idempotent no-op, nothing to do.")
        return
    if any(a in (e.get("aliases") or []) for e in entries for a in NEW_ENTRY["aliases"]):
        print("An alias of this proposal already exists in CANONICAL.json -- "
              "idempotent no-op, nothing to do (inspect before re-running).")
        return

    if PARENT_WELD not in by_code:
        raise SystemExit(f"parent {PARENT_WELD} not found in live CANONICAL.json -- abort.")

    genesis_doc = json.loads(GENESIS_PATH.read_text(encoding="utf-8"))
    genesis_codes = {r["code"] for r in genesis_doc["root_equations"]}
    if PARENT_ROOT_CORRECTED not in genesis_codes:
        raise SystemExit(
            f"parent {PARENT_ROOT_CORRECTED!r} not found in live genesis_root.json "
            f"(proposal file's own {PARENT_ROOT_RAW!r} does not match either) -- abort."
        )
    # Confirm the registry's own convention for root parents is bare (no
    # "root/" prefix) before silently rewriting -- re-derived live, not
    # assumed, every run.
    bare_root_precedents = [
        p["code"] for e in entries for p in (e.get("parents") or [])
        if "/" not in p["code"]
    ]
    if not bare_root_precedents:
        raise SystemExit(
            "no existing entry cites a bare-root parent -- cannot confirm the "
            "'root/EQ-008' -> 'EQ-008' correction against a live precedent, abort."
        )

    max_id = 0
    for e in entries:
        mo = re.match(r"^CAN-(\d+)$", str(e.get("id", "")))
        if mo:
            max_id = max(max_id, int(mo.group(1)))
    entry = dict(NEW_ENTRY)
    entry["id"] = f"CAN-{max_id + 1}"

    entries.append(entry)

    for e in entries:
        e["children"] = []
    by_code_after = {e["code"]: e for e in entries}
    for e in entries:
        for p in e.get("parents", []):
            parent = by_code_after.get(p["code"])
            if parent is not None and e["code"] not in parent["children"]:
                parent["children"].append(e["code"])

    doc["counts"] = recompute_counts(entries)
    doc["canonical"] = entries

    CANONICAL_PATH.write_text(json.dumps(doc, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    CAN_DIR.mkdir(parents=True, exist_ok=True)
    (ROOT / COQ_FILE_REL).write_text(COQ_SRC, encoding="utf-8")

    lineage_event = {
        "code": entry["code"],
        "date": DATE,
        "event": "assigned",
        "from": None,
        "to": (
            f"new entry, tier=Definition, coq_status=open_prop, "
            f"parents={PARENT_WELD},{PARENT_ROOT_CORRECTED}"
        ),
        "reason": (
            "Toledo v1.8 (URCF turbulence merge): Retained-information "
            "relaxation-inertia turbulence prediction equation from "
            "URCF_RTPE_TURBULENCE_RELAXATION_INERTIA_DIRECT_LP_CLOSURE_v2_2_"
            "STANDALONE_PROOF_PACK.yaml. instance_of weld/S.01.v1 (same "
            "first-order retained-response law, new domain) and instance_of "
            "EQ-008 (structural match to L_R := D_W - W; proposal file's own "
            f"{PARENT_ROOT_RAW!r} corrected to the registry's bare-root "
            f"convention {PARENT_ROOT_CORRECTED!r}, per existing precedents "
            f"e.g. {bare_root_precedents[0]!r}). Does NOT resolve Genesis "
            "root gap T2 (linear/time-invariant sub-case only) -- see "
            "drift_note."
        ),
        "by": BY,
    }
    with LINEAGE_PATH.open("a", encoding="utf-8") as f:
        f.write(json.dumps(lineage_event, ensure_ascii=False) + "\n")

    print(f"Registered {entry['code']} ({entry['id']}), wrote {COQ_FILE_REL}, "
          f"appended 1 LINEAGE event.")
    print(f"counts: {doc['counts']}")


if __name__ == "__main__":
    main()
