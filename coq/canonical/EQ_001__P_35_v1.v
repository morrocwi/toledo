(* EQ-001/P.35.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* finite front speed v: front-speed-squared v^2 = D / tau_c *)
Definition EQ001_P35_v_sq (D tau_c : Q) : Q := D / tau_c.
