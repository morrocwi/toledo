(* EQ-015/H.01.v1 — CAN-041 — Definition — parents: EQ-015/M.01.v1 — occurrences 4 *)

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
(** ** CAN-041 — pre-prompt-human-state-transport

    (* CAN-041 — root: H_t ->^LH Q_t; Q_t->AI_t->Y_t ->^RH E^AI_{H,t}; H_{t+1}=U_H(H_t,E^AI_{H,t},d,X) — domain: human–AI — tier: Definition — occurrences: 4 *)

    CANONICAL.json tier: "law (named principle) / definition". Reuse: this
    is exactly [MR_Prompt.v]'s eq.(27)-(29) composition — [ai_turn] (the
    prompt-out/experience-back leg, eq. 27-28) folded into [next_state]
    (the full state update, eq. 29). No redefinition: a plain alias to the
    already section-discharged, already axiom-free identifier. *)

Definition CAN_041_pre_prompt_human_state_transport := MR_Prompt.next_state.

