(* A.5/W.11.v1 — Definition — parents: A.5/M.01.v1, A.5/W.02.v1 *)

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

Definition CAN_154_channel_noncollapse_witness :=
  CAN_ws_generic_rise_not_entail_rise.
