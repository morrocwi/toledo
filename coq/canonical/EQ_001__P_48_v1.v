(* EQ-001/P.48.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* velocity composition: u21 = (u1+u2) / (1 + u1 u2 / v^2) *)
Definition EQ001_P48_u21 (u1 u2 v : Q) : Q := (u1 + u2) / (1 + u1 * u2 / (v * v)).
