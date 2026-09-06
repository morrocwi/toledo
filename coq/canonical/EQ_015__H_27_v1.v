(* EQ-015/H.27.v1 — CAN-092 — Dr — parents: EQ-015/M.02.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_HCA.
Require Import MR.MR_Retention.
Require Import MR.MR_TopicEntry.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-092 — DCP-closing-questions

    (* CAN-092 — root: What unresolved difference deserves my attention? / How much AI/friction does this task require? / What remains with me after AI is removed? — domain: human–AI — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "proposition". No Master River eq. citation. A
    closed three-constructor [Inductive] enumerating the reflective
    closing questions, never an open-ended classifier. *)

Section CAN_092_DCPClosingQuestions.

  Inductive ClosingQuestion : Type :=
    | QUnresolvedDifference | QFrictionRequired | QRemainsAfterRemoval.

  Definition CAN_092_closing_questions := ClosingQuestion.

End CAN_092_DCPClosingQuestions.

