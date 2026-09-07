(* EQ-001/P.68.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* minimal closed state Z_n for the metric-source system *)
Record EQ001_P68_Z := mkEQ001P68 {
  p68_Phi : Q; p68_Phi_prev : Q; p68_Psi : Q; p68_Psi_prev : Q;
  p68_Theta : Q; p68_Theta_prev : Q
}.
