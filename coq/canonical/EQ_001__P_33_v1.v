(* EQ-001/P.33.v1 -- Toledo v1.1 lane B2 -- Open *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* superposition gate: linear combinations of the two witness components
   stay in the closed pair and N_Q is additive (Pythagorean) on them. *)
Definition EQ001_P33_NQ (x y : Q) : Q := x * x + y * y.

Theorem EQ001_P33_pythagorean_additive :
  forall x y : Q, EQ001_P33_NQ x 0 + EQ001_P33_NQ 0 y == EQ001_P33_NQ x y.
Proof. intros x y. unfold EQ001_P33_NQ. lra. Qed.
