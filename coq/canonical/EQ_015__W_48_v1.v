(* EQ-015/W.48.v1 — Definition — parents: EQ-015/M.01.v1, EQ-015/W.11.v1 *)

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

  Definition CAN_152_time_budget_valid
             (l_wage l_care l_learn l_civic l_leisure : Q) : Prop :=
    l_wage + l_care + l_learn + l_civic + l_leisure == 1.

  Theorem CAN_152_time_budget_satisfiable :
    CAN_152_time_budget_valid (1#5) (1#5) (1#5) (1#5) (1#5).
  Proof. unfold CAN_152_time_budget_valid. reflexivity. Qed.

End CAN_152_SocialRoleStanding.
