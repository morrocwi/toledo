(* A.5/H.16.v1 — CAN-102 — Definition — parents: A.5/M.01.v1 — occurrences 2 *)

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
(** ** CAN-102 — barrier-readout

    (* CAN-102 — root: B^bar subset of {Knowledge,Skill,...,Unknown}; ObservedDifficulty<>SkillDeficit — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". Direct reuse of [MR_HCA.v]
    eq.(69)-(70): [BarrierType]/[BarrierLedger] and the proved
    [eq70_observed_difficulty_not_skill_deficit]. *)

Definition CAN_102_BarrierType := MR_HCA.BarrierType.
Definition CAN_102_BarrierLedger := MR_HCA.BarrierLedger.
Definition CAN_102_observed_difficulty_ne_skill_deficit_witness :=
  MR_HCA.eq70_observed_difficulty_not_skill_deficit.

