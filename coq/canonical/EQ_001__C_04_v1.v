(* EQ-001/C.04.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* RT-ADMISSIBLE-004: admitted coordinates satisfy n0 + N xi >= 0 and all
   declared capacity/boundary inequalities. General claim depending on
   EQ-001/C.03.v1's unproved basis-representation; stated as an open Prop. *)
Definition EQ001_C04_hyp
  (Coord : Type) (n0 : Coord -> Q) (Nxi : Coord -> Q) (bounds_ok : Coord -> Prop)
  : Prop :=
  forall xi : Coord, bounds_ok xi -> 0 <= n0 xi + Nxi xi.
