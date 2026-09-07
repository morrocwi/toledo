(* EQ-001/P.41.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* O3 orientation gate: B preserves forward/backward cone orientation *)
Definition EQ001_P41_orientation_preserving (B : Q * Q -> Q * Q) : Prop :=
  forall t x, 0 <= t -> 0 <= fst (B (t, x)).
