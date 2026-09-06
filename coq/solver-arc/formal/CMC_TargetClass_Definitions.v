(******************************************************************************)
(* CMC_TargetClass_Definitions.v                                               *)
(*                                                                            *)
(* Concrete bookkeeping definitions for the Causal-Memory Closure target       *)
(* class. This file is intentionally definitional: it does not close the CMC    *)
(* bridge theorem by itself. It gives the later theorem file a non-rhetorical   *)
(* vocabulary for target class, closure forms, and refuter burden.              *)
(******************************************************************************)

Set Implicit Arguments.
Set Asymmetric Patterns.

Inductive ClosureForm : Type :=
| ScalarRelaxation
| TensorMemory
| TemporalKernel
| SpectralMemory
| OperatorMemory
| PathDelay
| AuxiliaryFluxState
| KineticHiddenState
| NonlinearSupportGenerator
| BoundedPropagator
| GraphLocalStorage
| HiddenNonlocalUpdate.

Record TransportReadout : Type := {
  diffusion_positive : Prop;
  speed_positive : Prop;
  speed_finite : Prop;
  retained_diffusive : Prop;
  intrinsic_finite_speed : Prop;
  declared_physical_readout : Prop;
  closure_form_present : ClosureForm -> Prop
}.

Definition CMC_TargetClass (g : TransportReadout) : Prop :=
  diffusion_positive g /\
  speed_positive g /\
  speed_finite g /\
  retained_diffusive g /\
  intrinsic_finite_speed g /\
  declared_physical_readout g.

Definition NonzeroClosure (g : TransportReadout) : Prop :=
  exists f : ClosureForm, closure_form_present g f.

Definition ClosureFree (g : TransportReadout) : Prop :=
  forall f : ClosureForm, ~ closure_form_present g f.

Definition CMC_Bridge_Obligation : Prop :=
  forall g : TransportReadout, CMC_TargetClass g -> NonzeroClosure g.

(* Founder-level CMC axiom, intentionally named and disclosed.
   The project does not retreat from this claim. Journal-facing work must either
   defend this axiom, instantiate it for concrete classes, or exhibit an actual
   refuter satisfying CMC_Refuter_Burden. *)
Axiom cmc_bridge_axiom : CMC_Bridge_Obligation.

Definition CMC_Refuter_Burden (g : TransportReadout) : Prop :=
  CMC_TargetClass g /\ ClosureFree g.

Theorem nonzero_closure_not_closure_free :
  forall g : TransportReadout,
    NonzeroClosure g -> ~ ClosureFree g.
Proof.
  intros g Hnonzero Hfree.
  destruct Hnonzero as [f Hf].
  exact (Hfree f Hf).
Qed.

Theorem bridge_obligation_blocks_refuter :
  CMC_Bridge_Obligation ->
  forall g : TransportReadout,
    CMC_Refuter_Burden g -> False.
Proof.
  intros Hbridge g Hburden.
  destruct Hburden as [Htarget Hfree].
  pose proof (Hbridge g Htarget) as Hnonzero.
  exact (nonzero_closure_not_closure_free Hnonzero Hfree).
Qed.

Theorem cmc_no_refuter_under_axioms :
  forall g : TransportReadout,
    CMC_Refuter_Burden g -> False.
Proof.
  exact (bridge_obligation_blocks_refuter cmc_bridge_axiom).
Qed.

Print Assumptions nonzero_closure_not_closure_free.
Print Assumptions bridge_obligation_blocks_refuter.
Print Assumptions cmc_no_refuter_under_axioms.
