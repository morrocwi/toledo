(* EQ-015/W.24.v1 — Definition — parents: EQ-015/M.01.v1, EQ-015/W.03.v1 *)

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

  Definition CAN_142_labour_share
             (omega_H omega_M H_t M_t : Q) (rho_exp : nat) : Q :=
    (omega_H * MR_WorldSystem.Qpow_nat H_t rho_exp)
    / (omega_H * MR_WorldSystem.Qpow_nat H_t rho_exp
       + omega_M * MR_WorldSystem.Qpow_nat M_t rho_exp).

End CAN_142_MachineCapacityBlock.
