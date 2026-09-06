(* EQ-015/W.51.v1 — Definition — parents: EQ-015/M.01.v1, EQ-015/W.16.v1 *)

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

Definition CAN_159_machine_expansion_not_human_expansion :=
  MR_WorldSystem.eq60_machine_expansion_not_human_expansion.
