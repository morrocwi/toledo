(******************************************************************************)
(* CMC_ClosureFree_Exhaustive.v                                                *)
(*                                                                            *)
(* Finite constructor audit for the CMC refuter burden. A claimed              *)
(* ClosureFree witness must deny every declared ClosureForm constructor.        *)
(******************************************************************************)

From RDL Require Import CMC_TargetClass_Definitions.

Set Implicit Arguments.
Set Asymmetric Patterns.

Definition NoNamedClosure (g : TransportReadout) : Prop :=
  ~ closure_form_present g ScalarRelaxation /\
  ~ closure_form_present g TensorMemory /\
  ~ closure_form_present g TemporalKernel /\
  ~ closure_form_present g SpectralMemory /\
  ~ closure_form_present g OperatorMemory /\
  ~ closure_form_present g PathDelay /\
  ~ closure_form_present g AuxiliaryFluxState /\
  ~ closure_form_present g KineticHiddenState /\
  ~ closure_form_present g NonlinearSupportGenerator /\
  ~ closure_form_present g BoundedPropagator /\
  ~ closure_form_present g GraphLocalStorage /\
  ~ closure_form_present g HiddenNonlocalUpdate.

Theorem closure_free_implies_no_named_closure :
  forall g : TransportReadout,
    ClosureFree g -> NoNamedClosure g.
Proof.
  intros g Hfree.
  repeat split; apply Hfree.
Qed.

Theorem no_named_closure_implies_closure_free :
  forall g : TransportReadout,
    NoNamedClosure g -> ClosureFree g.
Proof.
  intros g Hnone f.
  unfold NoNamedClosure in Hnone.
  destruct f; tauto.
Qed.

Theorem closure_free_iff_no_named_closure :
  forall g : TransportReadout,
    ClosureFree g <-> NoNamedClosure g.
Proof.
  intros g.
  split.
  - apply closure_free_implies_no_named_closure.
  - apply no_named_closure_implies_closure_free.
Qed.

Theorem refuter_burden_expands_to_named_absence :
  forall g : TransportReadout,
    CMC_Refuter_Burden g ->
    CMC_TargetClass g /\ NoNamedClosure g.
Proof.
  intros g Hburden.
  destruct Hburden as [Htarget Hfree].
  split.
  - exact Htarget.
  - exact (closure_free_implies_no_named_closure Hfree).
Qed.

Print Assumptions closure_free_iff_no_named_closure.
Print Assumptions refuter_burden_expands_to_named_absence.
