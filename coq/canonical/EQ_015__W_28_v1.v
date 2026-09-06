(* EQ-015/W.28.v1 — Definition — parents: EQ-015/M.01.v1, EQ-015/W.05.v1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

Definition CAN_144_q_min := MR_WorldSystem.q_min.
Definition CAN_144_citizen_claim_threshold_identity :=
  MR_WorldSystem.eq54_citizen_claim_threshold_identity.
