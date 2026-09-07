(* MQ08-stepper/P.01.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* discrete ticks and finite causal operator, stepped by MQ.08 *)
Definition MQ08_stepper_P01_tick (Delta_theta : Q) (n : nat) : Q :=
  (Z.of_nat n # 1) * Delta_theta.
