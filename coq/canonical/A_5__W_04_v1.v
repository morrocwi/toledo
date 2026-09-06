(* A.5/W.04.v1 — Definition — parents: A.5/M.01.v1, A.5/W.01.v1 *)

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

  Definition CAN_147_B_scarce (R_house R_land R_energy DS Y : Q) : Q :=
    (R_house + R_land + R_energy + DS) / Y.
End CAN_147_ScarceAssetRent.
