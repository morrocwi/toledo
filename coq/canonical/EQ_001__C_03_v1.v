(* EQ-001/C.03.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* RT-EXTENT-003: if the columns of N form a basis for the admitted kernel
   subspace, every admitted change delta has coordinates xi with delta = N xi.
   General linear-algebra existence claim over Q; not proved constructively
   here (would need a full basis/spanning-set library, not built for this
   pass) -- stated honestly as an open Prop, no proof. *)
Definition EQ001_C03_hyp
  (Vec Coord : Type) (N : Coord -> Vec) (in_kernel : Vec -> Prop)
  (spans : Prop) : Prop :=
  spans -> forall delta : Vec, in_kernel delta -> exists xi : Coord, delta = N xi.
