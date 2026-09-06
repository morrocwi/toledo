(* EQ-015/W.22.v1 — Definition — parents: EQ-015/M.01.v1, EQ-015/W.03.v1 *)

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

Section CAN_142_MachineCapacityBlock.

  Definition CAN_142_M_index (K_M A_AI B_RB_val : Q) (kappa alpha beta : nat) : Q :=
    MR_WorldSystem.Qpow_nat K_M kappa
    * MR_WorldSystem.Qpow_nat A_AI alpha
    * MR_WorldSystem.Qpow_nat B_RB_val beta.
End CAN_142_MachineCapacityBlock.
