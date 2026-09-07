(* EQ-009/E.02.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* T1 conservation check: Q(z_n) + sum Q(rho_j) = Q(z_0), a conservation
   predicate parametrized by an opaque quantity functional Q_of (the
   actual numeric <1e-12 tolerance check is an external numerical
   verification, not reproduced here). *)
Definition EQ009_E02_conserved
  (Q_of : Q -> Q) (zn z0 : Q) (rhos : list Q) : Prop :=
  Q_of zn + fold_right Qplus 0 (map Q_of rhos) == Q_of z0.
