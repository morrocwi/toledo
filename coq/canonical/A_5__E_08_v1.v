(* A.5/E.08.v1 — CAN-227 — Dr — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-227 — root: constitutional-noncollapse (CAN-008) reading — domain:
   epistemic — tier: Dr — occurrences: 1 *)
(** "Successful adaptation = mental health" is explicitly REJECTED by the
    source. Witnessed non-collapse via the shared enumeration device. *)
Inductive CAN227_Notion := CAN227_SuccessfulAdaptation | CAN227_MentalHealth.
Definition CAN227_code (n : CAN227_Notion) : nat :=
  match n with CAN227_SuccessfulAdaptation => 0 | CAN227_MentalHealth => 1 end.
Theorem CAN227_non_collapse : notions_pairwise_distinct CAN227_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

