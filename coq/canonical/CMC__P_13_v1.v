(* CMC/P.13.v1 -- mapped_not_wrapped -> wrapped -- restates wave_bounded_propagator_blocks_refuter (solver arc (private)@961151db33b0491cba8fabade69f594238d33f84:coq/solver-arc/formal/CMC_PhysicsClass_Instances.v) -- parents: CMC *)
(* name: wave_bounded_propagator_blocks_refuter (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias -- the
   type below is copied character-for-character from this entry's own
   registry/CANONICAL.json statement.latest (format "coq"), which is
   itself the literal source declaration (registry/coq_map.json evidence).
   The proof is `exact wave_bounded_propagator_blocks_refuter.` against the already-verified import
   below -- no new proof technique, no new claim. *)

From RDL.formal Require Import CMC_TargetClass_Definitions.
From MRC Require Import _cmc_mirror_CMC_Bridge_Decomposition.
From MRC Require Import _cmc_mirror_CMC_PhysicsClass_Instances.

Theorem CMC__P_13_v1_restates_wave_bounded_propagator_blocks_refuter : forall r : CertifiedPhysicalReadout,
    WaveBoundedPropagatorCertified r ->
    CMC_Refuter_Burden (certified_gamma r) -> False.
Proof. exact wave_bounded_propagator_blocks_refuter. Qed.

Print Assumptions CMC__P_13_v1_restates_wave_bounded_propagator_blocks_refuter.
