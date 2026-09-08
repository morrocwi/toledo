(* A.5/H.17.v1 — CAN-103 — Definition — parents: A.5/M.01.v1 — occurrences 5 *)

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
(** ** CAN-103 — candidate-vs-endorsed-routes

    (* CAN-103 — root: C^cand=Gen(...); C^live={c in C^cand: Endorse=1}; ProactiveSuggestion<>HumanGoalOwnership; ... — domain: human–AI — tier: Definition — occurrences: 5 *)

    CANONICAL.json tier: "definition". Direct reuse of [MR_HCA.v]
    eq.(71)-(72): [C_live]/[C_live_subset_C_cand] and the three witnessed
    non-collapses [eq72a/b/c]. *)

Definition CAN_103_C_live := MR_HCA.C_live.
Definition CAN_103_C_live_subset_witness := MR_HCA.C_live_subset_C_cand.
Definition CAN_103_proactive_ne_ownership_witness := MR_HCA.eq72a_proactive_suggestion_not_human_goal_ownership.
Definition CAN_103_capability_ne_ai_authority_witness := MR_HCA.eq72b_capability_advancement_not_ai_goal_authority.
Definition CAN_103_scaffolding_ne_control_witness := MR_HCA.eq72c_scaffolding_not_control.

