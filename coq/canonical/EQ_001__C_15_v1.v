(* EQ-001/C.15.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* RT-REFINE-COMP-012: a declared nonnegative-integer coarsening map P
   commutes with composition, P(c+d) = P c + P d. General additive
   projection claim over finite-support vectors; stated openly. *)
Definition EQ001_C15_hyp
  (Vec Vec' : Type) (vadd : Vec -> Vec -> Vec) (vadd' : Vec' -> Vec' -> Vec')
  (P : Vec -> Vec') : Prop :=
  forall c d : Vec, P (vadd c d) = vadd' (P c) (P d).
