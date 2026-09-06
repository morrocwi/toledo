(* weld/S.43.v1 — Definition — parents: weld/M.03.v1, weld/S.04.v1 *)

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

Section CAN_122_BeliefRelation.

  Variables Agent Prop_ Context BeliefFactors : Type.

  Record CAN_122_BeliefVector : Type := mkBeliefVector
    { bv_e : Q ; bv_c : Q ; bv_s : Q ; bv_a : Q ; bv_eta : Q ; bv_g : Q ; bv_r : Q }.

  Variable Rel_B : Agent -> Prop_ -> Context -> CAN_122_BeliefVector.
  Variable U_B   : CAN_122_BeliefVector -> CAN_122_BeliefVector.   (* per-tick update *)
  Variable Stabilize_B : list CAN_122_BeliefVector -> CAN_122_BeliefVector.  (* group stabilisation *)

  Definition CAN_122_Bel := Rel_B.

End CAN_122_BeliefRelation.
