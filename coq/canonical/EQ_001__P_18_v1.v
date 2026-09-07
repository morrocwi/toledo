(* EQ-001/P.18.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* v^2 = K/M: a DECLARED (not derived) oscillator-parameter identification *)
Definition EQ001_P18_declared_v_sq (K M : Q) : Q := K / M.
