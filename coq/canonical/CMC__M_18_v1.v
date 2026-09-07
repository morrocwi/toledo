(* CMC/M.18.v1 -- mapped_not_wrapped -> wrapped -- restates cmc_no_refuter_under_axioms (solver arc (private)@961151db33b0491cba8fabade69f594238d33f84:coq/solver-arc/formal/CMC_TargetClass_Definitions.v) -- parents: CMC *)
(* name: cmc_no_refuter_under_axioms (Theorem) *)
(* tier: Ax (registry/coq_map.json status = "axioms:['cmc_bridge_axiom']" (Print Assumptions names a disclosed axiom dependency); tier capped at Ax, the tier of its weakest disclosed dependency, per registry/SCHEMA.md's rule that tier is never raised above the source's own evidence.) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias -- the
   type below is copied character-for-character from this entry's own
   registry/CANONICAL.json statement.latest (format "coq"), which is
   itself the literal source declaration (registry/coq_map.json evidence).
   The proof is `exact cmc_no_refuter_under_axioms.` against the already-verified import
   below -- no new proof technique, no new claim. *)

From RDL.formal Require Import CMC_TargetClass_Definitions.

Theorem CMC__M_18_v1_restates_cmc_no_refuter_under_axioms : forall g : TransportReadout,
    CMC_Refuter_Burden g -> False.
Proof. exact cmc_no_refuter_under_axioms. Qed.

Print Assumptions CMC__M_18_v1_restates_cmc_no_refuter_under_axioms.
