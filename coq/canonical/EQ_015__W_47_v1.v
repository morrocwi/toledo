(* EQ-015/W.47.v1 — Definition — parents: EQ-015/M.01.v1, EQ-015/W.11.v1 *)

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

Section CAN_152_SocialRoleStanding.

  Definition CAN_152_S_H_next (s1 s2 delta_S W_t N_t S_H_t : Q) : Q :=
    S_H_t + s1 * W_t + s2 * N_t - delta_S * S_H_t.
End CAN_152_SocialRoleStanding.
