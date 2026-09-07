(* CMC/M.02.v1 -- mapped_not_wrapped -> wrapped -- restates decomposed_no_refuter (solver arc (private)@961151db33b0491cba8fabade69f594238d33f84:coq/solver-arc/formal/CMC_Bridge_Decomposition.v) -- parents: CMC *)
(* name: decomposed_no_refuter (Theorem) *)
(* tier: Ax (registry/coq_map.json status = "axioms:['cmc_retention_lemma_obligation', 'cmc_finite_speed_lemma_obligation', 'cmc_closure_exhaustion_obligation', 'carrier_present']" (Print Assumptions names a disclosed axiom dependency); tier capped at Ax, the tier of its weakest disclosed dependency, per registry/SCHEMA.md's rule that tier is never raised above the source's own evidence.) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias -- the
   type below is copied character-for-character from this entry's own
   registry/CANONICAL.json statement.latest (format "coq"), which is
   itself the literal source declaration (registry/coq_map.json evidence).
   The proof is `exact decomposed_no_refuter.` against the already-verified import
   below -- no new proof technique, no new claim. *)

From RDL.formal Require Import CMC_TargetClass_Definitions.
From MRC Require Import _cmc_mirror_CMC_Bridge_Decomposition.

Theorem CMC__M_02_v1_restates_decomposed_no_refuter : forall g : TransportReadout,
    CMC_Refuter_Burden g -> False.
Proof. exact decomposed_no_refuter. Qed.

Print Assumptions CMC__M_02_v1_restates_decomposed_no_refuter.
