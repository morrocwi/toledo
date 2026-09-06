(* EQ-015/H.24.v1 — CAN-088 — Definition — parents: EQ-015/M.02.v1 — occurrences 5 *)

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
(** ** CAN-088 — DCP-return-action-feedback

    (* CAN-088 — root: I_s->a_s->delta^world_{s+1}->H_{s+1,0}; LiveProblem->Question->Dialogue->HumanReturn->Action->WorldFeedback->RevisionOrNewProblem — domain: human–AI — tier: Definition — occurrences: 5 *)

    CANONICAL.json tier: "definition (World-closure proposition itself
    [Open])". Registry drift note: [in_master_river]=[74], but the id's
    own [canonical_text]/[canonical_source] cite eq.(50)-(51) verbatim
    (see file header); followed here as the more specific fields.
    Direct reuse of [MR_TopicEntry.v] eq.(50)-(51): [dcp_closure_50] (the
    typed world-closure step) and [CycleStage]/[cycle_next_51] (the
    seven-stage wider cycle). *)

Definition CAN_088_world_closure := MR_TopicEntry.dcp_closure_50.
Definition CAN_088_CycleStage := MR_TopicEntry.CycleStage.
Definition CAN_088_cycle_next := MR_TopicEntry.cycle_next_51.

