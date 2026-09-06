(* EQ-015/E.11.v1 — CAN-030 — Definition — parents: EQ-015/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-030 — root: reader-equivalence (CAN-007) reading — domain:
   epistemic — tier: Definition — occurrences: 1 *)
(** K_A(D,t) := V_A^D(M_A(t), theta_D); V_A^D = w1 P + w2 I + w3 S + w4 R
    + w5 L, sum w_i = 1. A weighted 5-component profile with a
    well-formedness predicate (the weights sum to 1) as the admissibility
    CONDITION on a profile — matching the registry's own "heuristic, not
    algorithmic decision procedure" note; not proved to hold of any
    particular profile. *)
Record CAN030_Profile : Type := mkCAN030Profile
  { c030_P : Q; c030_I : Q; c030_S : Q; c030_R : Q; c030_L : Q
  ; c030_wP : Q; c030_wI : Q; c030_wS : Q; c030_wR : Q; c030_wL : Q
  }.

Definition CAN030_weights_normalized (pr : CAN030_Profile) : Prop :=
  c030_wP pr + c030_wI pr + c030_wS pr + c030_wR pr + c030_wL pr == 1.

Definition CAN030_V_A_D (pr : CAN030_Profile) : Q :=
  c030_wP pr * c030_P pr + c030_wI pr * c030_I pr + c030_wS pr * c030_S pr
  + c030_wR pr * c030_R pr + c030_wL pr * c030_L pr.

