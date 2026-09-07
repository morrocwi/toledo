(* EQ-001/P.38.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* cone product invariant: Q_v = n+ * n- = v^2 t^2 - x^2 *)
Definition EQ001_P38_n_plus (v t x : Q) : Q := v * t + x.
Definition EQ001_P38_n_minus (v t x : Q) : Q := v * t - x.
Definition EQ001_P38_Qv (v t x : Q) : Q := v * v * t * t - x * x.

Theorem EQ001_P38_cone_product :
  forall v t x : Q, EQ001_P38_n_plus v t x * EQ001_P38_n_minus v t x == EQ001_P38_Qv v t x.
Proof. intros v t x. unfold EQ001_P38_n_plus, EQ001_P38_n_minus, EQ001_P38_Qv. ring. Qed.
