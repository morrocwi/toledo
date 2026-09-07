(* CMC/P.03.v1 -- mapped_not_wrapped -> wrapped -- restates Closure_Exhaustion_Lemma_certified (solver arc (private)@961151db33b0491cba8fabade69f594238d33f84:coq/solver-arc/formal/CMC_PhysicsClass_Instances.v) -- parents: CMC *)
(* name: Closure_Exhaustion_Lemma_certified (Theorem) *)
(* tier: Th_coqc (registry/coq_map.json status = "Closed under the global context" (Print Assumptions output, verified in the S7 Coq-import pass) -- the corpus's own working definition of Th_coqc (machine-checked, axiom-free).) *)
(* Toledo v1.5 lane B (DEBT #45): restatement, not a bare alias -- the
   type below is copied character-for-character from this entry's own
   registry/CANONICAL.json statement.latest (format "coq"), which is
   itself the literal source declaration (registry/coq_map.json evidence).
   The proof is `exact Closure_Exhaustion_Lemma_certified.` against the already-verified import
   below -- no new proof technique, no new claim. *)

From RDL.formal Require Import CMC_TargetClass_Definitions.
From MRC Require Import _cmc_mirror_CMC_Bridge_Decomposition.
From MRC Require Import _cmc_mirror_CMC_PhysicsClass_Instances.

Theorem CMC__P_03_v1_restates_Closure_Exhaustion_Lemma_certified : forall r : CertifiedPhysicalReadout,
  forall kr ks : CarrierKind,
    RetentionCarrier kr ->
    FiniteSpeedCarrier ks ->
    CertifiedCarrierPresent r kr ->
    CertifiedCarrierPresent r ks ->
    NonzeroClosure (certified_gamma r).
Proof. exact Closure_Exhaustion_Lemma_certified. Qed.

Print Assumptions CMC__P_03_v1_restates_Closure_Exhaustion_Lemma_certified.
