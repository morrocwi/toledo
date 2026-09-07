(* CMC/M.17.v1 -- mapped_not_wrapped -> wrapped -- restates bridge_obligation_blocks_refuter (solver arc (private)@961151db33b0491cba8fabade69f594238d33f84:coq/solver-arc/formal/CMC_TargetClass_Definitions.v) -- parents: CMC *)
(* name: bridge_obligation_blocks_refuter (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias -- the
   type below is copied character-for-character from this entry's own
   registry/CANONICAL.json statement.latest (format "coq"), which is
   itself the literal source declaration (registry/coq_map.json evidence).
   The proof is `exact bridge_obligation_blocks_refuter.` against the already-verified import
   below -- no new proof technique, no new claim. *)

From RDL.formal Require Import CMC_TargetClass_Definitions.

Theorem CMC__M_17_v1_restates_bridge_obligation_blocks_refuter : CMC_Bridge_Obligation ->
  forall g : TransportReadout,
    CMC_Refuter_Burden g -> False.
Proof. exact bridge_obligation_blocks_refuter. Qed.

Print Assumptions CMC__M_17_v1_restates_bridge_obligation_blocks_refuter.
