(* EQ-001/P.47.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* relative simultaneity: Delta t' = - Gamma_R u Delta x / v^2 *)
Definition EQ001_P47_delta_tprime (Gamma_R u v Delta_x : Q) : Q :=
  - Gamma_R * u * Delta_x / (v * v).
