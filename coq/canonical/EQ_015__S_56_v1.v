(* EQ-015/S.56.v1 — Definition — parents: EQ-015/M.03.v1, EQ-015/S.07.v1 *)

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

Section CAN_133_RecoverableEnvelope.

  Variables Cond : Type.
  Variable A_corr : Cond -> Q.
  Variable J_feas : list Cond.

  Definition CAN_133_p_star2 (p_of : Cond -> Q) : Q :=
    fold_right Qmax 0 (map p_of J_feas).

End CAN_133_RecoverableEnvelope.
