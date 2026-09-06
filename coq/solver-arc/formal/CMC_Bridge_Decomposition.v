(******************************************************************************)
(* CMC_Bridge_Decomposition.v                                                  *)
(*                                                                            *)
(* Decomposes the founder-level CMC bridge into smaller named proof            *)
(* obligations: retention carrier, intrinsic finite-speed carrier, and         *)
(* closure exhaustion for the coupled carriers.                                *)
(******************************************************************************)

From RDL Require Import CMC_TargetClass_Definitions.

Set Implicit Arguments.
Set Asymmetric Patterns.

Inductive CarrierKind : Type :=
| PastInfluenceCarrier
| StoredStateCarrier
| DelayedFluxCarrier
| ModalPersistenceCarrier
| PathHistoryCarrier
| HiddenStateCarrier
| BoundedConeCarrier
| SupportLimiterCarrier
| GraphLocalBufferCarrier
| HiddenNonlocalCarrier.

Definition RetentionCarrier (k : CarrierKind) : Prop :=
  match k with
  | PastInfluenceCarrier => True
  | StoredStateCarrier => True
  | DelayedFluxCarrier => True
  | ModalPersistenceCarrier => True
  | PathHistoryCarrier => True
  | HiddenStateCarrier => True
  | BoundedConeCarrier => False
  | SupportLimiterCarrier => False
  | GraphLocalBufferCarrier => True
  | HiddenNonlocalCarrier => True
  end.

Definition FiniteSpeedCarrier (k : CarrierKind) : Prop :=
  match k with
  | PastInfluenceCarrier => False
  | StoredStateCarrier => True
  | DelayedFluxCarrier => True
  | ModalPersistenceCarrier => True
  | PathHistoryCarrier => True
  | HiddenStateCarrier => True
  | BoundedConeCarrier => True
  | SupportLimiterCarrier => True
  | GraphLocalBufferCarrier => True
  | HiddenNonlocalCarrier => True
  end.

Parameter carrier_present : TransportReadout -> CarrierKind -> Prop.

Definition CMC_Retention_Lemma : Prop :=
  forall g : TransportReadout,
    retained_diffusive g ->
    exists k : CarrierKind, RetentionCarrier k /\ carrier_present g k.

Definition CMC_FiniteSpeed_Lemma : Prop :=
  forall g : TransportReadout,
    intrinsic_finite_speed g ->
    exists k : CarrierKind, FiniteSpeedCarrier k /\ carrier_present g k.

Definition CMC_Closure_Exhaustion_Lemma : Prop :=
  forall g : TransportReadout,
  forall kr ks : CarrierKind,
    RetentionCarrier kr ->
    FiniteSpeedCarrier ks ->
    carrier_present g kr ->
    carrier_present g ks ->
    exists f : ClosureForm, closure_form_present g f.

Axiom cmc_retention_lemma_obligation : CMC_Retention_Lemma.
Axiom cmc_finite_speed_lemma_obligation : CMC_FiniteSpeed_Lemma.
Axiom cmc_closure_exhaustion_obligation : CMC_Closure_Exhaustion_Lemma.

Theorem decomposed_bridge_obligation :
  CMC_Bridge_Obligation.
Proof.
  unfold CMC_Bridge_Obligation.
  intros g Htarget.
  unfold CMC_TargetClass in Htarget.
  destruct Htarget as [_ [_ [_ [Hretained [Hintrinsic _]]]]].
  destruct (cmc_retention_lemma_obligation g Hretained)
    as [kr [Hretention_carrier Hkr]].
  destruct (cmc_finite_speed_lemma_obligation g Hintrinsic)
    as [ks [Hspeed_carrier Hks]].
  exact (@cmc_closure_exhaustion_obligation
    g kr ks Hretention_carrier Hspeed_carrier Hkr Hks).
Qed.

Theorem decomposed_no_refuter :
  forall g : TransportReadout,
    CMC_Refuter_Burden g -> False.
Proof.
  exact (bridge_obligation_blocks_refuter decomposed_bridge_obligation).
Qed.

Print Assumptions decomposed_bridge_obligation.
Print Assumptions decomposed_no_refuter.
