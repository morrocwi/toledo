(* EQ-001/P.05.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* telegraph coarse-grain / spine PDE stepper coefficients M,D,K *)
Record EQ001_P05_SpineStepper := mkEQ001P05 { p05_M : Q; p05_D : Q; p05_K : Q }.
