(* A.5/S.18.v1 — Definition — parents: A.5/M.01.v1, A.5/S.03.v1 *)

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

Definition CAN_128_enactment_may_differ_from_choice :=
  @MR_Live.eq23_enactment_may_differ_from_choice.
Definition CAN_128_observation_loses_information :=
  @MR_Live.eq23_observation_loses_information.
