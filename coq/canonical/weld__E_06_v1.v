(* weld/E.06.v1 — CAN-034 — Definition — parents: weld/M.03.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-034 — root: constitutional-noncollapse (CAN-008) reading — domain:
   epistemic — tier: Definition — occurrences: 1 *)
(** Suff_{E,L}(Z_E^cand;Q,O,c,T) in {1,0,bottom}; Inv_E(z) <> Inv_E(z') =>
    q_E(z) <> q_E(z'): a candidate domain state must be sufficient, and a
    quotient may not merge states differing on a required future
    invariant. Proved here as the constructively valid direction: if the
    invariant is a well-defined function of the quotient class (agreeing
    quotient images force agreeing invariants), the paper's stated
    preservation law follows — the converse direction is not
    intuitionistically valid without decidability of the invariant
    equality and so is not claimed. *)
Inductive CAN034_Sufficiency := CAN034_Sufficient | CAN034_Insufficient | CAN034_UnresolvedSuff.

Section CAN034_StateSufficiency.
  Variables State Invariant Quotient : Type.
  Variable Inv_E : State -> Invariant.
  Variable q_E : State -> Quotient.

  Definition CAN034_invariant_preserving : Prop :=
    forall z z' : State, Inv_E z <> Inv_E z' -> q_E z <> q_E z'.

  Theorem CAN034_invariant_functional_implies_preserving :
    (forall z z' : State, q_E z = q_E z' -> Inv_E z = Inv_E z') ->
    CAN034_invariant_preserving.
  Proof.
    unfold CAN034_invariant_preserving.
    intros H z z' Hneq Heqq.
    apply Hneq. apply H. exact Heqq.
  Qed.
End CAN034_StateSufficiency.

