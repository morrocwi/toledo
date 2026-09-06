(******************************************************************************)
(* CMC_Independent_Definitions.v                                               *)
(*                                                                            *)
(* Independent predicate layer for the CMC target-class criticism:             *)
(* RetainedDiffusive, IntrinsicFiniteSpeed, and ClosureFree must not be        *)
(* definitionally identical.                                                   *)
(******************************************************************************)

From RDL Require Import CMC_TargetClass_Definitions.
From RDL Require Import CMC_Bridge_Decomposition.

Set Implicit Arguments.
Set Asymmetric Patterns.

Inductive UpdateLawKind : Type :=
| PresentGradientOnly
| ClosureDriven (f : ClosureForm).

Record IndependentTransportSignature : Type := {
  independent_diffusion_positive : Prop;
  independent_speed_positive : Prop;
  independent_speed_finite : Prop;
  independent_declared_physical_readout : Prop;
  independent_retention_mechanism : CarrierKind -> Prop;
  independent_finite_speed_mechanism : CarrierKind -> Prop;
  independent_update_law : UpdateLawKind
}.

Definition RetainedDiffusive_independent
  (s : IndependentTransportSignature) : Prop :=
  exists k : CarrierKind,
    RetentionCarrier k /\ independent_retention_mechanism s k.

Definition IntrinsicFiniteSpeed_independent
  (s : IndependentTransportSignature) : Prop :=
  exists k : CarrierKind,
    FiniteSpeedCarrier k /\ independent_finite_speed_mechanism s k.

Definition ClosureFree_independent
  (s : IndependentTransportSignature) : Prop :=
  independent_update_law s = PresentGradientOnly.

Definition NonzeroClosure_independent
  (s : IndependentTransportSignature) : Prop :=
  exists f : ClosureForm, independent_update_law s = ClosureDriven f.

Definition CMC_TargetClass_independent
  (s : IndependentTransportSignature) : Prop :=
  independent_diffusion_positive s /\
  independent_speed_positive s /\
  independent_speed_finite s /\
  RetainedDiffusive_independent s /\
  IntrinsicFiniteSpeed_independent s /\
  independent_declared_physical_readout s.

Definition CMC_Refuter_Burden_independent
  (s : IndependentTransportSignature) : Prop :=
  CMC_TargetClass_independent s /\ ClosureFree_independent s.

Definition ClosureExhaustion_independent
  (s : IndependentTransportSignature) : Prop :=
  CMC_TargetClass_independent s -> NonzeroClosure_independent s.

Theorem independent_exhaustion_blocks_refuter :
  forall s : IndependentTransportSignature,
    ClosureExhaustion_independent s ->
    CMC_Refuter_Burden_independent s ->
    False.
Proof.
  intros s Hexhaust Hburden.
  destruct Hburden as [Htarget Hfree].
  destruct (Hexhaust Htarget) as [f Hclosure].
  unfold ClosureFree_independent in Hfree.
  rewrite Hfree in Hclosure.
  discriminate Hclosure.
Qed.

Definition retained_without_closure_signature : IndependentTransportSignature :=
  {|
    independent_diffusion_positive := True;
    independent_speed_positive := True;
    independent_speed_finite := True;
    independent_declared_physical_readout := True;
    independent_retention_mechanism :=
      fun k => k = PastInfluenceCarrier;
    independent_finite_speed_mechanism :=
      fun _k => False;
    independent_update_law := PresentGradientOnly
  |}.

Theorem retained_definition_not_closure_definition :
  RetainedDiffusive_independent retained_without_closure_signature /\
  ClosureFree_independent retained_without_closure_signature.
Proof.
  split.
  - exists PastInfluenceCarrier.
    split.
    + exact I.
    + reflexivity.
  - reflexivity.
Qed.

Definition finite_speed_without_closure_signature : IndependentTransportSignature :=
  {|
    independent_diffusion_positive := True;
    independent_speed_positive := True;
    independent_speed_finite := True;
    independent_declared_physical_readout := True;
    independent_retention_mechanism :=
      fun _k => False;
    independent_finite_speed_mechanism :=
      fun k => k = BoundedConeCarrier;
    independent_update_law := PresentGradientOnly
  |}.

Theorem finite_speed_definition_not_closure_definition :
  IntrinsicFiniteSpeed_independent finite_speed_without_closure_signature /\
  ClosureFree_independent finite_speed_without_closure_signature.
Proof.
  split.
  - exists BoundedConeCarrier.
    split.
    + exact I.
    + reflexivity.
  - reflexivity.
Qed.

Definition cattaneo_independent_signature : IndependentTransportSignature :=
  {|
    independent_diffusion_positive := True;
    independent_speed_positive := True;
    independent_speed_finite := True;
    independent_declared_physical_readout := True;
    independent_retention_mechanism :=
      fun k => k = DelayedFluxCarrier;
    independent_finite_speed_mechanism :=
      fun k => k = DelayedFluxCarrier;
    independent_update_law := ClosureDriven AuxiliaryFluxState
  |}.

Theorem cattaneo_independent_target_has_closure :
  CMC_TargetClass_independent cattaneo_independent_signature /\
  NonzeroClosure_independent cattaneo_independent_signature /\
  ~ CMC_Refuter_Burden_independent cattaneo_independent_signature.
Proof.
  split.
  - unfold CMC_TargetClass_independent.
    split; [exact I |].
    split; [exact I |].
    split; [exact I |].
    split.
    + exists DelayedFluxCarrier. split; [exact I | reflexivity].
    + split.
      * exists DelayedFluxCarrier. split; [exact I | reflexivity].
      * exact I.
  - split.
    + exists AuxiliaryFluxState. reflexivity.
    + intros Hburden.
      destruct Hburden as [_ Hfree].
      unfold ClosureFree_independent in Hfree.
      discriminate Hfree.
Qed.

Definition fourier_independent_signature : IndependentTransportSignature :=
  {|
    independent_diffusion_positive := True;
    independent_speed_positive := True;
    independent_speed_finite := True;
    independent_declared_physical_readout := True;
    independent_retention_mechanism :=
      fun _k => False;
    independent_finite_speed_mechanism :=
      fun _k => False;
    independent_update_law := PresentGradientOnly
  |}.

Theorem fourier_independent_is_not_target_class :
  ~ CMC_TargetClass_independent fourier_independent_signature.
Proof.
  intros Htarget.
  destruct Htarget as [_ [_ [_ [Hretained _]]]].
  destruct Hretained as [k [_ Hk]].
  exact Hk.
Qed.

Print Assumptions independent_exhaustion_blocks_refuter.
Print Assumptions retained_definition_not_closure_definition.
Print Assumptions finite_speed_definition_not_closure_definition.
Print Assumptions cattaneo_independent_target_has_closure.
Print Assumptions fourier_independent_is_not_target_class.
