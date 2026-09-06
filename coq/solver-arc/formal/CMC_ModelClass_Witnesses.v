(******************************************************************************)
(* CMC_ModelClass_Witnesses.v                                                  *)
(*                                                                            *)
(* Axiom-free bookkeeping theorems for concrete model-class closure witnesses. *)
(* These theorems do not claim that a real physical system belongs to a class; *)
(* they prove that once a class supplies its witness form, it cannot be a CMC   *)
(* refuter.                                                                    *)
(******************************************************************************)

From RDL Require Import CMC_TargetClass_Definitions.

Set Implicit Arguments.
Set Asymmetric Patterns.

Inductive WitnessModelClass : Type :=
| CattaneoTelegraphClass
| KineticProjectionClass
| WaveBoundedPropagatorClass
| FluxLimitedClass
| GraphLocalRetainedClass
| KernelMemoryClass
| OperatorMemoryClass.

Definition primary_witness_form (c : WitnessModelClass) : ClosureForm :=
  match c with
  | CattaneoTelegraphClass => AuxiliaryFluxState
  | KineticProjectionClass => KineticHiddenState
  | WaveBoundedPropagatorClass => BoundedPropagator
  | FluxLimitedClass => NonlinearSupportGenerator
  | GraphLocalRetainedClass => GraphLocalStorage
  | KernelMemoryClass => TemporalKernel
  | OperatorMemoryClass => OperatorMemory
  end.

Definition ClassWitness (c : WitnessModelClass) (g : TransportReadout) : Prop :=
  CMC_TargetClass g /\ closure_form_present g (primary_witness_form c).

Theorem class_witness_has_nonzero_closure :
  forall (c : WitnessModelClass) (g : TransportReadout),
    ClassWitness c g -> NonzeroClosure g.
Proof.
  intros c g Hclass.
  destruct Hclass as [_ Hpresent].
  exists (primary_witness_form c).
  exact Hpresent.
Qed.

Theorem class_witness_not_closure_free :
  forall (c : WitnessModelClass) (g : TransportReadout),
    ClassWitness c g -> ~ ClosureFree g.
Proof.
  intros c g Hclass.
  apply nonzero_closure_not_closure_free.
  exact (class_witness_has_nonzero_closure Hclass).
Qed.

Theorem class_witness_blocks_refuter :
  forall (c : WitnessModelClass) (g : TransportReadout),
    ClassWitness c g -> CMC_Refuter_Burden g -> False.
Proof.
  intros c g Hclass Hburden.
  destruct Hburden as [_ Hfree].
  exact (class_witness_not_closure_free Hclass Hfree).
Qed.

Definition FourierMemorylessFace (g : TransportReadout) : Prop :=
  diffusion_positive g /\ ClosureFree g /\ ~ intrinsic_finite_speed g.

Theorem fourier_memoryless_face_not_target :
  forall g : TransportReadout,
    FourierMemorylessFace g -> ~ CMC_TargetClass g.
Proof.
  intros g Hfourier Htarget.
  destruct Hfourier as [_ [_ Hnot_intrinsic]].
  unfold CMC_TargetClass in Htarget.
  destruct Htarget as [_ [_ [_ [_ [Hintrinsic _]]]]].
  exact (Hnot_intrinsic Hintrinsic).
Qed.

Print Assumptions class_witness_blocks_refuter.
Print Assumptions fourier_memoryless_face_not_target.
