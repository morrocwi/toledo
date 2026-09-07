(* weld/S.20.v1 -- Toledo v1.1 lane B2 -- Dr *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* control lever: limit propagation (Lij down) *)
Definition weld__S_20_v1_lever (Lij_new Lij_old : Q) : Prop :=
  Lij_new < Lij_old.
