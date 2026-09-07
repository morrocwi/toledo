(* weld/S.30.v1 -- Toledo v1.1 lane B2 -- Ax *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* Admissible Regime Set: R in R_adm(t') -- foundational (Ax-tier)
   membership assumption, stated as an open Prop over abstract carriers,
   never a top-level Axiom. *)
Definition weld_S30_hyp
  (Regime Time : Type) (R_adm : Time -> Regime -> Prop) (R : Regime) (t' : Time)
  : Prop := R_adm t' R.
