(* EQ-015/H.05.v1 — CAN-047 — Definition — parents: EQ-015/M.02.v1 — occurrences 5 *)

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
(** ** CAN-047 — human-AI-session-stepper

    (* CAN-047 — root: Z_dlg[s,n+1]=F#_dlg(Z_dlg[s,n],uH,uAI,c,T); chi_recip=|D_recip|/|Sigma| — domain: human–AI — tier: Definition — occurrences: 5 *)

    CANONICAL.json tier: "definition (chi_recip explicitly not
    warrant/truth)". Direct reuse of [MR_Prompt.v] eq.(31)-(32):
    [dlg_step] (the finite dialogue-turn stepper) and [chi_recip] together
    with its proved bounded-ratio fact [eq32_chi_recip_bounds]. *)

Definition CAN_047_dialogue_session_stepper := MR_Prompt.dlg_step.
Definition CAN_047_chi_recip := MR_Prompt.chi_recip.
Definition CAN_047_chi_recip_bounds_witness := MR_Prompt.eq32_chi_recip_bounds.

