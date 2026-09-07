(* EQ-001/P.66.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* geometry source S_Theta = Phi^T G_a Psi. Exact witness:
   G_1=[[0,1],[1,0]], Phi_n=[1,0], Psi_n=[0,1] => S_Theta=1. *)
Theorem EQ001_P66_witness :
  1 * (0 * 0 + 1 * 1) + 0 * (1 * 0 + 0 * 1) == 1.
Proof. lra. Qed.
