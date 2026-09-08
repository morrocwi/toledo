(* EQ-015/H.19.v1 — CAN-079 — Definition — parents: EQ-015/M.01.v1 — occurrences 2 *)

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
(** ** CAN-079 — outcome-vector-J*

    (* CAN-079 — root: J*_s=(AUGs,SYNs,RETs); AUGs=Pjoint-PH; SYNs=Pjoint-max(PH,PAI) — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". Direct reuse of [MR_Retention.v]
    eq.(40): [AUG]/[SYN] and the proved non-collapse
    [eq40_aug_syn_non_collapse]. *)

Definition CAN_079_AUG := MR_Retention.AUG.
Definition CAN_079_SYN := MR_Retention.SYN.
Definition CAN_079_aug_syn_non_collapse_witness := MR_Retention.eq40_aug_syn_non_collapse.

