(* EQ-015/W.25.v1 — Definition — parents: EQ-015/M.01.v1, EQ-015/W.04.v1 *)

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

Definition CAN_143_LabourCentrality := MR_WorldSystem.LabourCentrality.
Definition CAN_143_mk_labour_centrality := MR_WorldSystem.mk_labour_centrality.
