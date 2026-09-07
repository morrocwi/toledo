(* EQ-001/P.45.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* observer coordinate transforms: x' = Gamma_R (x - u t),
   t' = Gamma_R (t - u x / v^2). Exact witness: Gamma_R=5/4, u=3/4,
   v=5/4, (t=8,x=5) -> (t'=7, x'=-5/4); Qv = Qv' = 75. *)
Definition EQ001_P45_xprime (Gamma_R u t x : Q) : Q := Gamma_R * (x - u * t).
Definition EQ001_P45_tprime (Gamma_R u v t x : Q) : Q :=
  Gamma_R * (t - u * x / (v * v)).
Definition EQ001_P45_Qv (v t x : Q) : Q := v * v * t * t - x * x.

Theorem EQ001_P45_witness :
  EQ001_P45_xprime (5 # 4) (3 # 4) 8 5 == -(5 # 4) /\
  EQ001_P45_tprime (5 # 4) (3 # 4) (5 # 4) 8 5 == 7 /\
  EQ001_P45_Qv (5 # 4) 8 5 == 75 /\
  EQ001_P45_Qv (5 # 4) 7 (-(5 # 4)) == 75.
Proof.
  unfold EQ001_P45_xprime, EQ001_P45_tprime, EQ001_P45_Qv. repeat split; field.
Qed.
