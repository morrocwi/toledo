(* EQ-001/P.40.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* O2 cone-preservation gate: B sends the cone to itself *)
Definition EQ001_P40_cone_preserving (v : Q) (B : Q * Q -> Q * Q) : Prop :=
  forall t x, Qabs x <= v * t -> Qabs (snd (B (t, x))) <= v * fst (B (t, x)).
