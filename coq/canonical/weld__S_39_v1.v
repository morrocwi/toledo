(* weld/S.39.v1 -- Toledo v1.1 lane B2 -- Definition *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* Constitutional regime selection: R* in argmin_{R in R_adm} C_{system,R}
   s.t. tau_c'(R)>0, Delta_spec(R)>0 -- constrained argmin over a finite
   candidate list. *)
Definition weld_S39_R_star
  (candidates : list nat) (cost : nat -> Q) (feasible : nat -> bool) (default : nat)
  : nat :=
  fold_right
    (fun r best => if feasible r then (if Qle_bool (cost r) (cost best) then r else best) else best)
    default candidates.
