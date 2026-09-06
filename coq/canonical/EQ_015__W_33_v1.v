(* EQ-015/W.33.v1 — Definition — parents: EQ-015/M.01.v1, EQ-015/W.06.v1 *)

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

Section CAN_145_DemandRealization.

  Definition CAN_145_Pi_M (chi_dem_val Y_t Cost_M_t : Q) : Q :=
    chi_dem_val * Y_t - Cost_M_t.

End CAN_145_DemandRealization.
