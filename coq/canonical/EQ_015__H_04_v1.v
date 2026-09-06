(* EQ-015/H.04.v1 — CAN-046 — Definition — parents: EQ-015/M.02.v1 — occurrences 4 *)

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
(** ** CAN-046 — ai-response-chain

    (* CAN-046 — root: Q_t->AI_t->Y_t--RH-->E^AI_{H,t}; H_{t+1}=U_H(H_t,E^AI_{H,t},d,X) — domain: human–AI — tier: Definition — occurrences: 4 *)

    CANONICAL.json tier: "definition". The eq.(28)-(29) sub-range of the
    same [next_state] composition as CAN-041/045 (this id's own reading
    is narrower — just the AI-turn-then-update leg, without CAN-041's
    eq. 27 prompt-export framing) — aliased to [ai_turn] (eq. 28) here,
    the AI-processing/readback leg specifically. *)

Definition CAN_046_ai_response_chain := MR_Prompt.ai_turn.

