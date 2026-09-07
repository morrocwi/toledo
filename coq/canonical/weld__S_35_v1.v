(* weld/S.35.v1 -- Toledo v1.1 lane B2 -- Definition *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* Collective moral cost: C_G[t1,t2] := sum_i w_i C_{A_i,R_i}[t1,t2] *)
Definition weld_S35_C_G (weights costs : list Q) : Q :=
  fold_right Qplus 0 (map (fun p => fst p * snd p) (combine weights costs)).
