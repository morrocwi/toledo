(* EQ-001/P.11.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* complexification gate: J = [[0,-1],[1,0]], G = I2, J^2 = -I, J^T = -J;
   failing control J_bad = I2 has J_bad^2 = +I2 <> -I2. All entries as
   plain Q scalars (a2x2 matrix is its four entries), no record needed. *)
Section EQ001_P11.
  (* J entries: j00 j01 / j10 j11 *)
  Let j00 : Q := 0. Let j01 : Q := -1. Let j10 : Q := 1. Let j11 : Q := 0.

  Theorem EQ001_P11_J_squared_neg_I :
    (j00*j00 + j01*j10 == -1) /\ (j00*j01 + j01*j11 == 0) /\
    (j10*j00 + j11*j10 == 0) /\ (j10*j01 + j11*j11 == -1).
  Proof. unfold j00, j01, j10, j11. repeat split; lra. Qed.

  Theorem EQ001_P11_J_transpose_is_neg_J :
    (j00 == -j00) /\ (j10 == -j01) /\ (j01 == -j10) /\ (j11 == -j11).
  Proof. unfold j00, j01, j10, j11. repeat split; lra. Qed.

  Let b00 : Q := 1. Let b01 : Q := 0. Let b10 : Q := 0. Let b11 : Q := 1.

  Theorem EQ001_P11_failing_control :
    ~ (b00*b00 + b01*b10 == -1 /\ b11*b11 + b10*b01 == -1).
  Proof. unfold b00, b01, b10, b11. intros [H _]. lra. Qed.
End EQ001_P11.
