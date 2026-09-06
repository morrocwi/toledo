(* EQ-015/W.34.v1 — Definition — parents: EQ-015/M.03.v1, EQ-015/W.07.v1 *)

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

  Definition CAN_146_ownership_accumulate
             (delta_W r W s_cap T_cap Tax_cap : Q) : Q :=
    (1 - delta_W) * W + r * W + s_cap + T_cap - Tax_cap.
End CAN_146_OwnershipAccumulation.
