(* EQ-001/P.02.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ordered transitions and retention: positive retention time tau_c > 0 *)
Definition EQ001_P02_valid_retention (tau_c : Q) : Prop := tau_c > 0.
