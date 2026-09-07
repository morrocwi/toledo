(* EQ-001/P.54.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* geometry-field feedback commuting square: q_LG o F_full = F_LG o q_LG *)
Definition EQ001_P54_hyp
  (A B : Type) (q_LG : A -> B) (F_full : A -> A) (F_LG : B -> B) : Prop :=
  forall x, q_LG (F_full x) = F_LG (q_LG x).
