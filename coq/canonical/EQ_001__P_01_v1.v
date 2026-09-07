(* EQ-001/P.01.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* retained distinction, master root: a =/= b retained as a distinction. *)
Definition EQ001_P01_distinct {T : Type} (a b : T) : Prop := a <> b.
