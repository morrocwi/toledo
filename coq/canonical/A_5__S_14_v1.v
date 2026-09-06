(* A.5/S.14.v1 — Definition — parents: A.5/M.01.v1, A.5/S.03.v1 *)

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

Definition CAN_128_live_full_nesting := @MR_Live.eq19_full_nesting.
Definition CAN_128_is_valid_choice := @MR_Live.is_valid_choice.
