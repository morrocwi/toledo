(* EQ-015/W.55.v1 — Definition — parents: EQ-015/M.01.v1, EQ-015/W.19.v1 *)
(* also carries the Coq apparatus for the founder-excluded prose member '22481926:Proposition 3' (the Reversibility Principle itself, CAN_163_Open_reversibility_principle) -- ruled not_an_equation, so it carries no child code of its own; its (deliberately un-proved, Open) declaration is kept here, disclosed, since it is stated over exactly this reversibility-window apparatus. *)

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

Definition CAN_163_reversibility_window := MR_WorldSystem.reversibility_window.
Definition CAN_163_in_reversibility_window := MR_WorldSystem.in_reversibility_window.

Definition CAN_163_Open_reversibility_principle
           (C_rec_j tau_rec_j : nat -> Q) (Cbar_j taubar_j : Q) (t : nat) : Prop :=
  CAN_163_in_reversibility_window C_rec_j tau_rec_j Cbar_j taubar_j t = true ->
  exists t' : nat, (t <= t')%nat.

