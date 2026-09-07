(* EQ-001/P.55.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* observer-normalization / redshift / lapse quotient:
   dtheta_i = N dtheta_o, nu_o = N nu_i *)
Definition EQ001_P55_theta_i (N dtheta_o : Q) : Q := N * dtheta_o.
Definition EQ001_P55_nu_o (N nu_i : Q) : Q := N * nu_i.
