(* weld/S.32.v1 -- Toledo v1.1 lane B2 -- Definition *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* Spectral violation indicator chi_spec(R) := 1[Delta_spec(R) <= 0] *)
Definition weld_S32_chi_spec (Delta_spec : Q) : bool := Qle_bool Delta_spec 0.
