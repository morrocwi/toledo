(* weld/S.31.v1 -- Toledo v1.1 lane B2 -- Definition *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* Causal violation indicator chi_causal(R) := 1[tau_c'(R) ~= 0]; "~="
   read here as exact rational equality (no tolerance parameter given). *)
Definition weld_S31_chi_causal (tau_c_prime : Q) : bool :=
  if Qeq_bool tau_c_prime 0 then true else false.
