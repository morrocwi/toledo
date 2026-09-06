(* EQ-015/W.50.v1 — Definition — parents: EQ-015/M.03.v1, EQ-015/W.12.v1 *)

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

Definition CAN_153_productive_not_social_necessity_witness :=
  CAN_ws_generic_rise_not_entail_rise.
