(* weld/S.18.v1 -- Toledo v1.1 lane B2 -- Dr *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* control lever: increase dissipation (Gamma up) *)
Definition weld__S_18_v1_lever (Gamma_new Gamma_old : Q) : Prop :=
  Gamma_new > Gamma_old.
