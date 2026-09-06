(* A.5/W.05.v1 — Definition — parents: A.5/M.01.v1, A.5/W.01.v1 *)

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

Section CAN_147_ScarceAssetRent.

  Definition CAN_147_Gamma_eff (Gamma_net B_scarce_val : Q) : Q :=
    Qmax 0 (Gamma_net - B_scarce_val).
End CAN_147_ScarceAssetRent.
