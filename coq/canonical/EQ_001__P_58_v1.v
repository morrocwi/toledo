(* EQ-001/P.58.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* lapse composition: N_{j|o} = N_{j|i} N_{i|o}. Exact witness:
   B_{i|o}=diag(2,8) (N=4), B_{j|i}=diag(3,27) (N=9),
   composed B_{j|o}=diag(6,216) (N=36=9*4). *)
Theorem EQ001_P58_witness :
  4 * 4 == 2 * 8 /\ 9 * 9 == 3 * 27 /\ 36 * 36 == 6 * 216 /\
  (2 * 3 == 6) /\ (8 * 27 == 216) /\ (36 == 9 * 4).
Proof. repeat split; lra. Qed.
