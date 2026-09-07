(* weld/S.19.v1 -- Toledo v1.1 lane B2 -- Dr *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* control lever: reduce environmental load (Senv down) *)
Definition weld__S_19_v1_lever (Senv_new Senv_old : Q) : Prop :=
  Senv_new < Senv_old.
