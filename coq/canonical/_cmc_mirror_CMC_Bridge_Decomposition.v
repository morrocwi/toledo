(* _cmc_mirror_CMC_Bridge_Decomposition.v -- Toledo v1.5 lane B (DEBT #45/CMC).
   Mechanical import-path republication of "solver arc (private)"'s own
   formal/CMC_Bridge_Decomposition.v (commit 961151db33b0491cba8fabade69f594238d33f84,
   registry/coq_imports.json S5 manifest, PROVENANCE.json in
   coq/solver-arc/). The ORIGINAL file at coq/solver-arc/formal/CMC_Bridge_Decomposition.v is
   left byte-identical and untouched -- this is a SEPARATE file, not an edit
   of the mirror.

   Why this file exists: CMC_Bridge_Decomposition.v's own header line(s) read
   "From RDL Require Import <X>." -- correct when CMC_Bridge_Decomposition.v is compiled
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
   republishes CMC_Bridge_Decomposition.v's OWN body, character-for-character identical
   below except that its internal "From RDL Require Import <X>." line(s)
   are rewritten to "From RDL.formal Require Import <X>." (matching the
   ALREADY-WORKING recursive binding) -- no theorem, proof, definition,
   comment, or any other content changed. Diff is exactly the import
   line(s); verify with:
     diff <(sed -n '/^Set Implicit/,$p' CMC_Bridge_Decomposition.v) \
          <(sed -n '/^Set Implicit/,$p' _cmc_mirror_CMC_Bridge_Decomposition.v)
   which is empty. *)

(******************************************************************************)
(* CMC_Bridge_Decomposition.v                                                  *)
(*                                                                            *)
(* Decomposes the founder-level CMC bridge into smaller named proof            *)
(* obligations: retention carrier, intrinsic finite-speed carrier, and         *)
(* closure exhaustion for the coupled carriers.                                *)
(******************************************************************************)

From RDL.formal Require Import CMC_TargetClass_Definitions.

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
