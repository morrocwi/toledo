(* EQ-001/P.12.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* positive quantum norm N_Q(psi) = <psi, G psi>, G = I2. Exact witness. *)
Definition EQ001_P12_NQ (x y : Q) : Q := x * x + y * y.

Theorem EQ001_P12_witness : EQ001_P12_NQ 3 4 == 25 /\ EQ001_P12_NQ 0 0 == 0.
Proof. unfold EQ001_P12_NQ. split; lra. Qed.
