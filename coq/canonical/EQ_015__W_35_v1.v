(* EQ-015/W.35.v1 — Definition — parents: EQ-015/M.03.v1, EQ-015/W.07.v1 *)

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

Section CAN_146_OwnershipAccumulation.

  Definition CAN_146_ownership_share (W_i W_total : Q) : Q := W_i / W_total.
End CAN_146_OwnershipAccumulation.
