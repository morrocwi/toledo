#!/usr/bin/env python3
"""Toledo v1.8 REGISTRAR merge -- Religious Attribution Non-Collapse (RANC), sec.8.1
of "Plural Interfaces, Singular Commitments" (Yaoharee Lahtee, v1.0, 2026-09-08).

The manuscript states exactly one formally stated object: five distinct
levels of analysis -- O (model output), P (product policy), N (institutional
normative commitment), B_i (belief of actor i), J_i (person-specific
religious classification of i) -- related by O != P != N != B_i != J_i, plus
the stronger non-entailment O =/=> J_i unless each transition is
independently evidenced.

phi_check (search Toledo first, per Toledo Equation Source Policy): searched
registry/CANONICAL.json for every reading whose name or statement mentions
"religio", "belief", "attribution", "takfir", "tawhid", "taaruf",
"non-collapse", "non_collapse" -- 70+ hits, all reviewed. The closest
structural precedent is weld/H.33.v1 (Core Epistemic Structure non-collapse:
Experience-Based Expertise != Interactional Expertise != AI Model), a
3-object non-collapse chain over epistemic-registration roles. RANC is a
DIFFERENT object under the phi-criterion: 5 objects, not 3; the objects are
model-output/policy/institution/belief/religious-classification, not
registration roles; no renaming, positive-scale, or constant-substitution
bijection maps one statement onto the other. No exact, renaming, or
positive-scale match was found for the 5-level chain or its O =/=> J_i
non-entailment clause anywhere in the 1273-entry canonical array. Registered
as a NEW object, parented on weld/H.33.v1 (derived_via: "reads" -- same
non-collapse discipline, different domain), root "weld", domain H
(human/philosophy), tier Definition per the source's own framing (an
asserted non-identity relation among five defined objects, not itself a
proved theorem -- the source text calls this a "principle", sec.8.1).

Origin DOI is a PLACEHOLDER pending this manuscript's own Zenodo deposit --
see origin.doi below and the drift_note. The chair must patch origin.doi
(and add a statements_history "revised" LINEAGE event, never edit the row
silently) once the real DOI is minted, per EPIS-TOLEDO-FIRST's "deposited
sources are never edited" rule (this row is not yet a deposited source itself
until the DOI is real, so the placeholder-patch is the one permitted
follow-up edit, not a violation of that rule).

Idempotent: re-reads registry/CANONICAL.json immediately before the one
atomic write, aborts if weld/H.51.v1 already exists (re-run safe). Never
touches mcp/, latex/, README/CHANGELOG/CITATION. Touches only: (a) the one
new entry appended, (b) weld/H.33.v1's children[] (recomputed), (c) top-level
counts{} recompute over the full array, (d) one LINEAGE.jsonl append.

Run: python3 scripts/v18_ranc_merge.py
"""
import json
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
CANONICAL_PATH = REG / "CANONICAL.json"
LINEAGE_PATH = REG / "LINEAGE.jsonl"
COQ_DIR = ROOT / "coq" / "canonical"

DATE = "2026-09-08"
BY = "toledo-v1.8-ranc"

NEW_CODE = "weld/H.51.v1"
NEW_ID = "CAN-1274"
PARENT_CODE = "weld/H.33.v1"

STATEMENT_LATEST = (
    r"O \not\equiv P \not\equiv N \not\equiv B_i \not\equiv J_i \text{, and } "
    r"O \nRightarrow J_i \text{ unless each transition is independently evidenced}"
)

COQ_FILE_REL = "coq/canonical/weld__H_51_v1.v"
COQ_IDENT = "weld__H_51_v1_hyp"

COQ_SRC = f"""(* {NEW_CODE} -- open_prop -- Religious Attribution Non-Collapse (RANC): *)
(* model output, product policy, institutional normative commitment, an *)
(* actor's interior belief, and a person-specific religious classification *)
(* are five distinct objects; none may be silently identified with, or *)
(* taken to entail, another. *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* {STATEMENT_LATEST} *)
(* Toledo v1.8 (RANC merge): finite-model open_prop -- every symbol not *)
(* already fixed by the statement above is a local Section Parameter (its *)
(* type chosen only so the equation type-checks; nothing about what it *)
(* computes is asserted). Unproved by design (source's own "Definition", *)
(* not a proved theorem). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.
From MRC Require Import _hrp_verdict_vocab.

Section weld__H_51_v1_sec.
  Parameter Level : Type.
  Parameter O_out P_pol N_norm B_bel J_cls : Level.
  Definition weld__H_51_v1_hyp : Prop :=
    O_out <> P_pol /\\
    P_pol <> N_norm /\\
    N_norm <> B_bel /\\
    B_bel <> J_cls.
End weld__H_51_v1_sec.
"""

NEW_ENTRY = {
    "id": NEW_ID,
    "code": NEW_CODE,
    "root": "weld",
    "layer": "reading",
    "domain": "H",
    "aliases": ["RANC"],
    "name": "Religious Attribution Non-Collapse (RANC): model output, product policy, institutional norm, actor belief, and person-specific religious classification are distinct",
    "statement": {"latest": STATEMENT_LATEST, "format": "latex"},
    "statements_history": [
        {
            "v": 1,
            "statement": STATEMENT_LATEST,
            "date": DATE,
            "reason": (
                "toledo-v1.8-ranc: initial capture from \"Plural Interfaces, Singular "
                "Commitments\" (Yaoharee Lahtee, v1.0, 2026-09-08), sec.8.1, "
                "\"Religious Attribution Non-Collapse\""
            ),
            "by": BY,
        }
    ],
    "parents": [
        {"code": PARENT_CODE, "derived_via": "reads"},
    ],
    "children": [],
    "origin": {
        "source": "domain_registry",
        "repo_anchor": None,
        "record_id": None,
        "doi": "PLACEHOLDER-PENDING-ZENODO-DEPOSIT-plural-interfaces-singular-commitments-v1.0",
        "section": "8.1 Religious Attribution Non-Collapse (RANC), \"The five-level model\"",
        "label": None,
    },
    "status": "unverified",
    "status_note": (
        "Origin DOI is a placeholder pending this manuscript's own Zenodo deposit; "
        "the chair must patch origin.doi via a LINEAGE 'revised' event once minted, "
        "never a silent edit."
    ),
    "superseded_by": None,
    "tier": "Definition",
    "tier_in_genesis_verbatim": "[New Definition / Proposal] -- \"Religious Attribution Non-Collapse\" principle, sec.8.1",
    "coq": {
        "file": COQ_FILE_REL,
        "identifier": COQ_IDENT,
        "assumptions": None,
        "imported_from": None,
        "coq_status": "open_prop",
        "coq_axioms": [],
        "coq_source_redistributed": True,
    },
    "relations": [],
    "occurrences": [
        {
            "record_id": None,
            "doi": None,
            "label": "sec.8.1 Religious Attribution Non-Collapse (RANC)",
            "section": "8. Religious Attribution Non-Collapse (RANC)",
            "raw_key": "plural_interfaces_singular_commitments_v1_0:RANC",
        }
    ],
    "role": "other",
    "first_assigned": DATE,
    "drift_note": (
        "Rooted at weld and parented on weld/H.33.v1 (the Core Epistemic Structure "
        "non-collapse rule) because both are asserted non-collapse disciplines over "
        "typed levels of analysis, but RANC is a genuinely different object (5 levels "
        "-- output/policy/institution/belief/religious-classification -- vs 3 "
        "registration roles; no phi-criterion renaming/scale/substitution bijection "
        "maps one onto the other). This is a disclosed convention (same discipline "
        "family, not a demonstrated restatement of the parent's own statement), per "
        "SCHEMA.md's drift_note field. Tiered Definition, not Dr, per the source "
        "manuscript's own framing (sec.8.1 calls this a stated 'principle' defining a "
        "non-identity relation among five named objects, not a proved theorem) -- "
        "note for the chair: the structurally closest precedent, weld/H.33.v1, was "
        "instead tiered Dr ('an asserted non-collapse rule ... not itself a bare "
        "typed definition'); this entry follows the source manuscript's explicit "
        "Definition framing rather than that precedent, and the divergence is "
        "recorded here rather than silently resolved either way."
    ),
    "provenance_note_verbatim": (
        "Religious Attribution Non-Collapse (RANC): O \\not\\equiv P \\not\\equiv N "
        "\\not\\equiv B_i \\not\\equiv J_i -- model output, product policy, "
        "institutional normative commitment, an actor's interior belief, and a "
        "person-specific religious classification are five distinct objects; none "
        "may be silently identified with, or taken to entail, another "
        "(O \\nRightarrow J_i unless each transition is independently evidenced). "
        "\"Plural Interfaces, Singular Commitments\" (Yaoharee Lahtee, v1.0, "
        "2026-09-08), sec.8.1."
    ),
}


def recompute_counts(entries):
    by_status = Counter(e["status"] for e in entries)
    by_domain = Counter(e["domain"] for e in entries if e["domain"])
    by_tier = Counter(e["tier"] for e in entries)
    by_coq_status = Counter(e["coq"]["coq_status"] for e in entries)
    return {
        "entries": len(entries),
        "by_status": dict(by_status),
        "by_domain": dict(by_domain),
        "by_tier": dict(by_tier),
        "by_coq_status": dict(by_coq_status),
        "computed": f"{DATE} from canonical[] (scripts/v18_ranc_merge.py)",
    }


def main():
    doc = json.loads(CANONICAL_PATH.read_text(encoding="utf-8"))
    entries = doc["canonical"]
    by_code = {e["code"]: e for e in entries}

    if NEW_CODE in by_code:
        print(f"{NEW_CODE} already exists -- idempotent no-op, nothing to do.")
        return

    if PARENT_CODE not in by_code:
        raise SystemExit(f"parent {PARENT_CODE} not found in live CANONICAL.json -- abort.")

    entries.append(NEW_ENTRY)

    # recompute children[] by inverting parents[] across the full array
    for e in entries:
        e["children"] = []
    for e in entries:
        for p in e.get("parents", []):
            parent = by_code.get(p["code"])
            if parent is not None and e["code"] not in parent["children"]:
                parent["children"].append(e["code"])
    # re-key by_code after append (weld/H.33.v1 children already mutated above)

    doc["counts"] = recompute_counts(entries)
    doc["canonical"] = entries

    CANONICAL_PATH.write_text(json.dumps(doc, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    COQ_DIR.mkdir(parents=True, exist_ok=True)
    coq_path = ROOT / COQ_FILE_REL
    coq_path.write_text(COQ_SRC, encoding="utf-8")

    lineage_event = {
        "code": NEW_CODE,
        "date": DATE,
        "event": "assigned",
        "from": None,
        "to": f"new entry, tier=Definition, coq_status=open_prop, parent={PARENT_CODE}",
        "reason": (
            "Toledo v1.8 (RANC merge): new Religious Attribution Non-Collapse object "
            "from \"Plural Interfaces, Singular Commitments\" v1.0 sec.8.1. phi_check: "
            "no existing object matches under renaming/positive-scale/constant-"
            "substitution; closest precedent weld/H.33.v1 documented as a distinct "
            "object in the entry's own drift_note. Origin DOI is a placeholder pending "
            "Zenodo deposit."
        ),
        "by": BY,
    }
    with LINEAGE_PATH.open("a", encoding="utf-8") as f:
        f.write(json.dumps(lineage_event, ensure_ascii=False) + "\n")

    print(f"Registered {NEW_CODE} ({NEW_ID}), wrote {coq_path}, appended 1 LINEAGE event.")
    print(f"counts: {doc['counts']}")


if __name__ == "__main__":
    main()
