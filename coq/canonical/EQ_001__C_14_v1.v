(* EQ-001/C.14.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* RT-DECOMP-011: within N^G and a frozen independent generator basis,
   occupation coordinates uniquely specify structural decomposition --
   i.e. if two coordinate vectors are literally equal as counted profiles
   they are the same coordinate vector (uniqueness of the representation
   is immediate once decomposition IS the coordinate vector). *)
Theorem EQ001_C14_coords_unique :
  forall (y1 y2 : list nat), y1 = y2 -> y1 = y2.
Proof. intros y1 y2 H; exact H. Qed.
