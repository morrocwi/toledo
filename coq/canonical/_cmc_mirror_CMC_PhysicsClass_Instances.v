(* _cmc_mirror_CMC_PhysicsClass_Instances.v -- Toledo v1.5 lane B (DEBT #45/CMC).
   Mechanical import-path republication of "solver arc (private)"'s own
   formal/CMC_PhysicsClass_Instances.v (commit 961151db33b0491cba8fabade69f594238d33f84,
   registry/coq_imports.json S5 manifest, PROVENANCE.json in
   coq/solver-arc/). The ORIGINAL file at coq/solver-arc/formal/CMC_PhysicsClass_Instances.v is
   left byte-identical and untouched -- this is a SEPARATE file, not an edit
   of the mirror.

   Why this file exists: CMC_PhysicsClass_Instances.v's own header line(s) read
   "From RDL Require Import <X>." -- correct when CMC_PhysicsClass_Instances.v is compiled
   standalone from inside coq/solver-arc/formal/ (that directory's own
   _CoqProject binds "-R . RDL", i.e. RDL = formal/ itself, flat). But
   Toledo's shared coq/canonical/build_sequential.sh and verify.sh already
   bind "-R ../solver-arc RDL" (RECURSIVE over the whole solver-arc tree,
   so formal/ is reachable as RDL.formal.<X>) -- needed by the 210
   q_formal/EQ-015 wrapper files Toledo v1.1 already shipped
   (scripts/v11_wrapa.py), which cannot be renamed. Registering formal/ a
   SECOND time under a flat "RDL" binding in the SAME coqc invocation was
   tested and confirmed to silently override/break the recursive one
   (verified empirically, 2026-09-07: a flat "-Q .../formal RDL" added
   alongside the existing "-R .../solver-arc RDL" remaps formal/ away from
   RDL.formal, breaking every existing RDL.formal.<X> Require in the 210
   already-shipped files) -- so the two conventions cannot coexist in one
   invocation. This file resolves the conflict the only way that touches
   neither the verbatim mirror nor the 210 already-shipped files: it
   republishes CMC_PhysicsClass_Instances.v's OWN body, character-for-character identical
   below except that its internal "From RDL Require Import <X>." line(s)
   are rewritten to "From RDL.formal Require Import <X>." (matching the
   ALREADY-WORKING recursive binding) -- no theorem, proof, definition,
   comment, or any other content changed. Diff is exactly the import
   line(s); verify with:
     diff <(sed -n '/^Set Implicit/,$p' CMC_PhysicsClass_Instances.v) \
          <(sed -n '/^Set Implicit/,$p' _cmc_mirror_CMC_PhysicsClass_Instances.v)
   which is empty. *)

(******************************************************************************)
(* CMC_PhysicsClass_Instances.v                                                *)
(*                                                                            *)
(* Axiom-free certified physics-class layer for the requested CMC lemmas and   *)
(* standard model witnesses.                                                   *)
(*                                                                            *)
(* This file does not assume the founder bridge axiom. Instead, it defines a   *)
(* certified target class whose retention carrier, finite-speed carrier, and   *)
(* closure witness are explicit data. From that certified class, the retention *)
(* lemma, finite-speed lemma, closure-exhaustion lemma, model-class witnesses, *)
(* and Fourier singular-face exclusion are all Coq-checkable.                  *)
(******************************************************************************)

From RDL.formal Require Import CMC_TargetClass_Definitions.
From MRC Require Import _cmc_mirror_CMC_Bridge_Decomposition.
(* rewritten from "From RDL Require Import CMC_Bridge_Decomposition." to point at this file's own already-fixed sibling mirror, not the original (which itself carries the same broken bare "From RDL" internal import) -- see header comment above. *)

Set Implicit Arguments.
Set Asymmetric Patterns.

Record CertifiedPhysicalReadout : Type := {
  certified_gamma : TransportReadout;
  certified_target : CMC_TargetClass certified_gamma;
  certified_retention_carrier : CarrierKind;
  certified_retention_valid : RetentionCarrier certified_retention_carrier;
  certified_finite_speed_carrier : CarrierKind;
  certified_finite_speed_valid : FiniteSpeedCarrier certified_finite_speed_carrier;
  certified_closure_form : ClosureForm;
  certified_closure_present :
    closure_form_present certified_gamma certified_closure_form
}.

Definition CertifiedCarrierPresent
  (r : CertifiedPhysicalReadout) (k : CarrierKind) : Prop :=
  k = certified_retention_carrier r \/ k = certified_finite_speed_carrier r.

Theorem Retention_Lemma_certified :
  forall r : CertifiedPhysicalReadout,
    retained_diffusive (certified_gamma r) ->
    exists k : CarrierKind,
      RetentionCarrier k /\ CertifiedCarrierPresent r k.
Proof.
  intros r _Hretained.
  exists (certified_retention_carrier r).
  split.
  - exact (certified_retention_valid r).
  - left. reflexivity.
Qed.

Theorem Finite_Speed_Lemma_certified :
  forall r : CertifiedPhysicalReadout,
    intrinsic_finite_speed (certified_gamma r) ->
    exists k : CarrierKind,
      FiniteSpeedCarrier k /\ CertifiedCarrierPresent r k.
Proof.
  intros r _Hintrinsic.
  exists (certified_finite_speed_carrier r).
  split.
  - exact (certified_finite_speed_valid r).
  - right. reflexivity.
Qed.

Theorem Closure_Exhaustion_Lemma_certified :
  forall r : CertifiedPhysicalReadout,
  forall kr ks : CarrierKind,
    RetentionCarrier kr ->
    FiniteSpeedCarrier ks ->
    CertifiedCarrierPresent r kr ->
    CertifiedCarrierPresent r ks ->
    NonzeroClosure (certified_gamma r).
Proof.
  intros r _kr _ks _Hret _Hspeed _Hkr _Hks.
  exists (certified_closure_form r).
  exact (certified_closure_present r).
Qed.

Theorem certified_physical_readout_has_nonzero_closure :
  forall r : CertifiedPhysicalReadout,
    NonzeroClosure (certified_gamma r).
Proof.
  intros r.
  exists (certified_closure_form r).
  exact (certified_closure_present r).
Qed.

Theorem certified_physical_readout_blocks_refuter :
  forall r : CertifiedPhysicalReadout,
    CMC_Refuter_Burden (certified_gamma r) -> False.
Proof.
  intros r Hburden.
  destruct Hburden as [_Htarget Hfree].
  pose proof (certified_physical_readout_has_nonzero_closure r) as Hnonzero.
  exact (nonzero_closure_not_closure_free Hnonzero Hfree).
Qed.

Definition CattaneoTelegraphCertified (r : CertifiedPhysicalReadout) : Prop :=
  certified_retention_carrier r = DelayedFluxCarrier /\
  certified_finite_speed_carrier r = DelayedFluxCarrier /\
  certified_closure_form r = AuxiliaryFluxState.

Definition KineticTransportCertified (r : CertifiedPhysicalReadout) : Prop :=
  certified_retention_carrier r = HiddenStateCarrier /\
  certified_finite_speed_carrier r = HiddenStateCarrier /\
  certified_closure_form r = KineticHiddenState.

Definition FluxLimitedDiffusionCertified (r : CertifiedPhysicalReadout) : Prop :=
  certified_retention_carrier r = StoredStateCarrier /\
  certified_finite_speed_carrier r = SupportLimiterCarrier /\
  certified_closure_form r = NonlinearSupportGenerator.

Definition WaveBoundedPropagatorCertified (r : CertifiedPhysicalReadout) : Prop :=
  certified_retention_carrier r = StoredStateCarrier /\
  certified_finite_speed_carrier r = BoundedConeCarrier /\
  certified_closure_form r = BoundedPropagator.

Theorem cattaneo_telegraph_closure_witness :
  forall r : CertifiedPhysicalReadout,
    CattaneoTelegraphCertified r ->
    closure_form_present (certified_gamma r) AuxiliaryFluxState.
Proof.
  intros r Hclass.
  destruct Hclass as [_ [_ Hform]].
  rewrite <- Hform.
  exact (certified_closure_present r).
Qed.

Theorem cattaneo_telegraph_blocks_refuter :
  forall r : CertifiedPhysicalReadout,
    CattaneoTelegraphCertified r ->
    CMC_Refuter_Burden (certified_gamma r) -> False.
Proof.
  intros r _Hclass Hburden.
  exact (certified_physical_readout_blocks_refuter r Hburden).
Qed.

Theorem kinetic_transport_closure_witness :
  forall r : CertifiedPhysicalReadout,
    KineticTransportCertified r ->
    closure_form_present (certified_gamma r) KineticHiddenState.
Proof.
  intros r Hclass.
  destruct Hclass as [_ [_ Hform]].
  rewrite <- Hform.
  exact (certified_closure_present r).
Qed.

Theorem kinetic_transport_blocks_refuter :
  forall r : CertifiedPhysicalReadout,
    KineticTransportCertified r ->
    CMC_Refuter_Burden (certified_gamma r) -> False.
Proof.
  intros r _Hclass Hburden.
  exact (certified_physical_readout_blocks_refuter r Hburden).
Qed.

Theorem flux_limited_diffusion_closure_witness :
  forall r : CertifiedPhysicalReadout,
    FluxLimitedDiffusionCertified r ->
    closure_form_present (certified_gamma r) NonlinearSupportGenerator.
Proof.
  intros r Hclass.
  destruct Hclass as [_ [_ Hform]].
  rewrite <- Hform.
  exact (certified_closure_present r).
Qed.

Theorem flux_limited_diffusion_blocks_refuter :
  forall r : CertifiedPhysicalReadout,
    FluxLimitedDiffusionCertified r ->
    CMC_Refuter_Burden (certified_gamma r) -> False.
Proof.
  intros r _Hclass Hburden.
  exact (certified_physical_readout_blocks_refuter r Hburden).
Qed.

Theorem wave_bounded_propagator_closure_witness :
  forall r : CertifiedPhysicalReadout,
    WaveBoundedPropagatorCertified r ->
    closure_form_present (certified_gamma r) BoundedPropagator.
Proof.
  intros r Hclass.
  destruct Hclass as [_ [_ Hform]].
  rewrite <- Hform.
  exact (certified_closure_present r).
Qed.

Theorem wave_bounded_propagator_blocks_refuter :
  forall r : CertifiedPhysicalReadout,
    WaveBoundedPropagatorCertified r ->
    CMC_Refuter_Burden (certified_gamma r) -> False.
Proof.
  intros r _Hclass Hburden.
  exact (certified_physical_readout_blocks_refuter r Hburden).
Qed.

Definition FourierHeatSingularMemorylessFace (g : TransportReadout) : Prop :=
  diffusion_positive g /\
  speed_positive g /\
  speed_finite g /\
  ClosureFree g /\
  ~ intrinsic_finite_speed g.

Theorem fourier_heat_singular_memoryless_face_not_finite_speed_target :
  forall g : TransportReadout,
    FourierHeatSingularMemorylessFace g -> ~ CMC_TargetClass g.
Proof.
  intros g Hfourier Htarget.
  destruct Hfourier as [_ [_ [_ [_ Hnot_intrinsic]]]].
  unfold CMC_TargetClass in Htarget.
  destruct Htarget as [_ [_ [_ [_ [Hintrinsic _]]]]].
  exact (Hnot_intrinsic Hintrinsic).
Qed.

Theorem fourier_heat_singular_memoryless_face_not_refuter :
  forall g : TransportReadout,
    FourierHeatSingularMemorylessFace g -> ~ CMC_Refuter_Burden g.
Proof.
  intros g Hfourier Hburden.
  destruct Hburden as [Htarget _Hfree].
  exact (fourier_heat_singular_memoryless_face_not_finite_speed_target
    Hfourier Htarget).
Qed.

Print Assumptions Retention_Lemma_certified.
Print Assumptions Finite_Speed_Lemma_certified.
Print Assumptions Closure_Exhaustion_Lemma_certified.
Print Assumptions cattaneo_telegraph_closure_witness.
Print Assumptions kinetic_transport_closure_witness.
Print Assumptions flux_limited_diffusion_closure_witness.
Print Assumptions wave_bounded_propagator_closure_witness.
Print Assumptions fourier_heat_singular_memoryless_face_not_finite_speed_target.
