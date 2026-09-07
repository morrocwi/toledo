(* EQ-001/P.50.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* minimal closed state Z_n = (Phi_n, Phi_{n-1}, Psi_n, Psi_{n-1}, Theta_n) *)
Record EQ001_P50_MinimalState := mkEQ001P50 {
  p50_Phi : Q; p50_Phi_prev : Q; p50_Psi : Q; p50_Psi_prev : Q; p50_Theta : Q
}.
