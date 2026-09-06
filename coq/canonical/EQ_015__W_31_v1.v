(* EQ-015/W.31.v1 — Definition — parents: EQ-015/M.01.v1, EQ-015/W.06.v1 *)

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

  Definition CAN_145_AD (C_t I_t G_t NX_t : Q) : Q := C_t + I_t + G_t + NX_t.
End CAN_145_DemandRealization.
