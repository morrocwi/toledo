(* A.5/S.12.v1 — Definition — parents: A.5/M.01.v1, A.5/S.01.v1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

Section CAN_121_AgencyHierarchy.

  Variables X C H : Type.
  Variable F : X -> C -> X.

  Definition CAN_121_L4_predictive (G4 : X -> C -> X -> C) : Type := X -> C -> X -> C.

End CAN_121_AgencyHierarchy.
