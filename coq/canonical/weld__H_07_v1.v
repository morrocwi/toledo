(* weld/H.07.v1 — CAN-066 — Definition — parents: weld/M.01.v1 — occurrences 4 *)

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
(** ** CAN-066 — session-retention-gate

    (* CAN-066 — root: DeltaOmegatilde_s=BsAs, rank<<dH; Omega_{s+1,0}=Omega_{s,0}+eta_s.DeltaOmegatilde_s; RET=(Ppost-Ppre)HAI-(Ppost-Ppre)HC — domain: human–AI — tier: Th_coqc — occurrences: 4 *)

    CANONICAL.json tier: "definition (Master's own proposal, not v8.1's
    own text for the low-rank form)". Direct reuse of [MR_Retention.v]
    eq.(35)-(36) (the candidate low-rank update and single-eta retention
    gate, plus the [gate_avoids_eta_doubling_witness] Th_coqc fact) and
    [MR_Prompt.v] eq.(33)-(34) (the return battery and [RET] estimand,
    plus its proved rearrangement identity). *)

Definition CAN_066_candidate_update := MR_Retention.candidate_update.
Definition CAN_066_is_low_rank := MR_Retention.is_low_rank.
Definition CAN_066_retention_gate_update := MR_Retention.retention_gate_update.
Definition CAN_066_gate_weight_valid := MR_Retention.gate_weight_valid.
Definition CAN_066_gate_avoids_doubling_witness := MR_Retention.gate_avoids_eta_doubling_witness.
Definition CAN_066_RET := MR_Prompt.RET.
Definition CAN_066_RET_rearrangement_witness := MR_Prompt.eq34_RET_rearrangement.

