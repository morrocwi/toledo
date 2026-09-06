(* A.5/H.08.v1 — CAN-074 — Definition — parents: A.5/M.01.v1 — occurrences 4 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Require Import MR.MR_Prompt.
Require Import MR.MR_Retention.
Require Import MR.MR_TopicEntry.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-074 — assisted-vs-return-noncollapse

    (* CAN-074 — root: DeltaPerformance_AI>0 does-not-imply DeltaH_return>0 — domain: human–AI — tier: Th_coqc — occurrences: 4 *)

    CANONICAL.json tier: "law/definition". No Master River eq. citation.
    The failure of the naive implication is discharged as a witnessed
    counter-instance over [Q]: a case where assisted performance improves
    (strictly positive delta) yet unaided human return does not (delta
    zero) — a genuine, checkable non-implication, not assumed. *)

Section CAN_074_AssistedVsReturnNonCollapse.

  Theorem CAN_074_assisted_gain_does_not_imply_return_gain :
    exists delta_perf delta_return : Q,
      delta_perf > 0 /\ ~ (delta_return > 0) /\ delta_return == 0.
  Proof.
    exists 1, 0.
    split; [lra | split; [lra | reflexivity] ].
  Qed.

End CAN_074_AssistedVsReturnNonCollapse.

