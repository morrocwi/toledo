(* EQ-001/P.37.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* null coordinates on the cone: n+ = v t + x, n- = v t - x *)
Definition EQ001_P37_n_plus (v t x : Q) : Q := v * t + x.
Definition EQ001_P37_n_minus (v t x : Q) : Q := v * t - x.
