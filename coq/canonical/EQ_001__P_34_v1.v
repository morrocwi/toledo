(* EQ-001/P.34.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* distinguishability and asymmetry, restating the root-backbone claim *)
Definition EQ001_P34_distinct {T : Type} (a b : T) : Prop := a <> b.
