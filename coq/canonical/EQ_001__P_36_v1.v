(* EQ-001/P.36.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* finite causal cone: |x| <= v * t *)
Definition EQ001_P36_in_cone (v t x : Q) : Prop := Qabs x <= v * t.
