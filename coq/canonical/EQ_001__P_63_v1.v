(* EQ-001/P.63.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* Schwarzschild calculator identity: r_s = 2 G E / c^4 (declared, not derived) *)
Definition EQ001_P63_r_s (G E c : Q) : Q := 2 * G * E / (c * c * c * c).
