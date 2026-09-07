(* EQ-001/P.03.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* discrete ticks: t = n * Delta_theta *)
Definition EQ001_P03_tick (Delta_theta : Q) (n : nat) : Q :=
  (Z.of_nat n # 1) * Delta_theta.
