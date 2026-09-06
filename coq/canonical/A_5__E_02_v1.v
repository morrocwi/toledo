(* A.5/E.02.v1 — CAN-039 — Definition — parents: A.5/M.01.v1 — occurrences 19 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-039 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition (schematic) — occurrences: 2 *)
(** Candidate-Set Formation & Appraisal Loop. Typed as a finite candidate
    set ([list Hyp]) with a membership-gated comparability predicate; the
    embedded definitional consequence "H not in C => no comparative
    appraisal" (22307564:(3)) is proved as a direct consequence of
    membership-gating, and the embedded non-collapse "usable for
    propagation <> true" (22308072:(5)) is proved via the shared
    enumeration device. The one bundled sub-claim CANONICAL.json itself
    flags as posed-then-REJECTED by its own source (22307564:(Q5),
    "C_{G,t} = union C_{A_i,t}?") is deliberately NOT formalised as a
    theorem here — it is not part of the definitional core. *)
Section CAN039_CandidateSetFormation.
  Variable Hyp : Type.

  Definition CAN039_CandidateSet : Type := list Hyp.

  Definition CAN039_comparable (C : CAN039_CandidateSet) (h : Hyp) : Prop := In h C.

  Theorem CAN039_not_in_implies_not_comparable :
    forall (C : CAN039_CandidateSet) (h : Hyp), ~ In h C -> ~ CAN039_comparable C h.
  Proof. intros C h Hnin. unfold CAN039_comparable. exact Hnin. Qed.
End CAN039_CandidateSetFormation.

Inductive CAN039_Notion := CAN039_UsableForPropagation | CAN039_True.
Definition CAN039_code (n : CAN039_Notion) : nat :=
  match n with CAN039_UsableForPropagation => 0 | CAN039_True => 1 end.
Theorem CAN039_usable_ne_true : notions_pairwise_distinct CAN039_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

