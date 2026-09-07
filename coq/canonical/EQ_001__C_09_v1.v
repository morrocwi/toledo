(* EQ-001/C.09.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* NP-EXACT-001: numerical procedure directive -- use integer/fraction
   arithmetic for finite proof witnesses. Typed as the exact-arithmetic
   type this registry itself uses throughout (Q), no proof obligation. *)
Definition EQ001_C09_ExactArithmeticType : Type := Q.
