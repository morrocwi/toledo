(* A.5/H.09.v1 — CAN-075 — Definition — parents: A.5/M.01.v1 — occurrences 2 *)

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
(** ** CAN-075 — exposure-retention-improvement-noncollapse

    (* CAN-075 — root: Exposure<>Retention<>Improvement — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition/law". Direct reuse of
    [MR_Retention.v] eq.(42): the first triple of its six-notion
    [EndChainNotion] enumeration (Exposure, Retention, Improvement) and
    the relevant conjunct of [eq42_end_chain_non_collapse]. *)

Definition CAN_075_EndChainNotion := MR_Retention.EndChainNotion.
Definition CAN_075_end_chain_value := MR_Retention.end_chain_value.

Theorem CAN_075_exposure_retention_improvement_non_collapse :
  MR_Retention.end_chain_value MR_Retention.NExposure
    <> MR_Retention.end_chain_value MR_Retention.NRetention2 /\
  MR_Retention.end_chain_value MR_Retention.NRetention2
    <> MR_Retention.end_chain_value MR_Retention.NImprovement2.
Proof.
  pose proof MR_Retention.eq42_end_chain_non_collapse as [H1 [H2 _]].
  split; assumption.
Qed.

