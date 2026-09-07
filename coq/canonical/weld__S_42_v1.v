(* weld/S.42.v1 -- Toledo v1.1 lane B2 -- Definition *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* Tragic-min consequence: R+_A in argmin_{R in R_available} C_{A,R}
   s.t. tau_c'(R)>0, Delta_spec(R)>0 -- same constrained-argmin shape
   as weld/S.39.v1, over the individually-available regime set. *)
Definition weld_S42_R_tragic_min
  (candidates : list nat) (cost : nat -> Q) (feasible : nat -> bool) (default : nat)
  : nat :=
  fold_right
    (fun r best => if feasible r then (if Qle_bool (cost r) (cost best) then r else best) else best)
    default candidates.
