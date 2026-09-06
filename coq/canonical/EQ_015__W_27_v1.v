(* EQ-015/W.27.v1 — Definition — parents: EQ-015/M.01.v1, EQ-015/W.05.v1 *)

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

Section CAN_144_ClaimConstitution.

  Definition CAN_144_convex_combine (a b : Q) : Q := a + b * (1 - a).

  Theorem CAN_144_convex_combine_identity :
    forall a b : Q, CAN_144_convex_combine a b == 1 - (1 - a) * (1 - b).
  Proof. intros a b. unfold CAN_144_convex_combine. ring. Qed.

  (* Gamma_t = s^L_t + q_t (1 - s^L_t) *)
  Definition CAN_144_Gamma_t (s_L_t q_t : Q) : Q := CAN_144_convex_combine s_L_t q_t.

End CAN_144_ClaimConstitution.
