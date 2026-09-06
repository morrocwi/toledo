(* EQ-015/S.51.v1 — Definition — parents: EQ-015/M.03.v1, EQ-015/S.06.v1 *)

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

Definition CAN_132_p_star := @MR_Live.p_star.
Definition CAN_132_p_star_upper_bound := @MR_Live.p_star_upper_bound.
