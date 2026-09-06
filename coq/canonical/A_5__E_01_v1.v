(* A.5/E.01.v1 — CAN-037 — Definition — parents: A.5/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-037 — root: constitutional-noncollapse (CAN-008) reading — domain:
   epistemic — tier: Th_coqc — occurrences: 1 *)
(** A_n <> r_n <> x_n; root retention =/= belief state =/= meaning =/=
    experience =/= choice: event occurrence, retained record, accessible
    trace, and the four further named notions are eight pairwise-distinct
    notions, witnessed via the shared enumeration device. *)
Inductive CAN037_Notion :=
  | CAN037_Event | CAN037_Record | CAN037_Trace
  | CAN037_Retention | CAN037_Belief | CAN037_Meaning | CAN037_Experience | CAN037_Choice.

Definition CAN037_code (n : CAN037_Notion) : nat :=
  match n with
  | CAN037_Event => 0 | CAN037_Record => 1 | CAN037_Trace => 2
  | CAN037_Retention => 3 | CAN037_Belief => 4 | CAN037_Meaning => 5
  | CAN037_Experience => 6 | CAN037_Choice => 7
  end.

Theorem CAN037_non_collapse : notions_pairwise_distinct CAN037_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

