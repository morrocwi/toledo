(* EQ-001/P.13.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* reversible G-orthogonal evolution: U = J (from P.11); N_Q(U psi) =
   N_Q(psi) on the witness psi = (3,4) -> U psi = (-4,3). *)
Definition EQ001_P13_NQ (x y : Q) : Q := x * x + y * y.

Theorem EQ001_P13_preserved :
  EQ001_P13_NQ (0*3 + (-1)*4) (1*3 + 0*4) == EQ001_P13_NQ 3 4.
Proof. unfold EQ001_P13_NQ. lra. Qed.
