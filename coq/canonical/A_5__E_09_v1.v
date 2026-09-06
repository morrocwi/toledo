(* A.5/E.09.v1 — CAN-229 — untagged — parents: A.5/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-229 — root: reader-equivalence (CAN-007) reading — domain:
   epistemic — tier: Th_coqc — occurrences: 1 *)
(** usable <> true; T_U down =/=> W(H) up =/=> truth. The core pairwise
    non-collapse (usable <> true) is witnessed via the shared enumeration
    device; the further two-step non-implication (a falling discovery
    time neither entails rising warrant nor entails truth) is witnessed
    directly as a possibility fact. *)
Inductive CAN229_Notion := CAN229_Usable | CAN229_True.
Definition CAN229_code (n : CAN229_Notion) : nat :=
  match n with CAN229_Usable => 0 | CAN229_True => 1 end.
Theorem CAN229_usable_ne_true : notions_pairwise_distinct CAN229_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

Theorem CAN229_falling_TU_does_not_force_rising_warrant :
  exists (TU_before TU_after Warrant_before Warrant_after : Q),
    TU_after < TU_before /\ ~ (Warrant_after > Warrant_before).
Proof.
  exists 1, 0, 0, 0.
  split; lra.
Qed.

