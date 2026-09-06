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

From RDL Require Import CMC_TargetClass_Definitions.
From RDL Require Import CMC_Bridge_Decomposition.

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
