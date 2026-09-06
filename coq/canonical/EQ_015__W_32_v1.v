(* EQ-015/W.32.v1 — Definition — parents: EQ-015/M.01.v1, EQ-015/W.06.v1 *)

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

  Definition CAN_145_chi_dem (AD_t Y_t : Q) : Q := Qmin 1 (AD_t / Y_t).

  Theorem CAN_145_chi_dem_le_one :
    forall AD_t Y_t : Q, CAN_145_chi_dem AD_t Y_t <= 1.
  Proof. intros. unfold CAN_145_chi_dem. apply Q.le_min_l. Qed.
End CAN_145_DemandRealization.
