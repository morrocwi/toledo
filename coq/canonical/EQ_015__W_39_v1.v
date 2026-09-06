(* EQ-015/W.39.v1 — Definition — parents: EQ-015/M.03.v1, EQ-015/W.08.v1 *)

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

Section CAN_148_ConversionGates.

  Definition CAN_148_G_conv (V_full V_excl : Q) : Q :=
    1 - Qmax 0 (V_excl / V_full).

  Definition CAN_148_Dependency (w G_conv_val X : Q) : Q :=
    w * G_conv_val * (1 - X).
End CAN_148_ConversionGates.
