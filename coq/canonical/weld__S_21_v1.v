(* weld/S.21.v1 -- Toledo v1.1 lane B2 -- Dr *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* control lever: shorten memory (tau down) *)
Definition weld__S_21_v1_lever (tau_new tau_old : Q) : Prop :=
  tau_new < tau_old.
