(* EQ-015/H.10.v1 — CAN-062 — Definition — parents: EQ-015/M.03.v1 — occurrences 6 *)

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
(** ** CAN-062 — K_like-noncollapse

    (* CAN-062 — root: AI(Q)=K_like, K_like<>K_validated — domain: human–AI — tier: Th_coqc — occurrences: 6 *)

    CANONICAL.json tier: "law/definition". Direct reuse of
    [MR_Retention.v] eq.(38): [KnowledgeStatus] (the two-point
    [K_like]/[K_validated] enumeration) and the proved non-collapse
    [eq38_candidate_status_non_collapse]. *)

Definition CAN_062_KnowledgeStatus := MR_Retention.KnowledgeStatus.
Definition CAN_062_status_value := MR_Retention.status_value.
Definition CAN_062_non_collapse_witness := MR_Retention.eq38_candidate_status_non_collapse.

