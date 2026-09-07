(* BiologyDomain_living_unit/B.18.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Lotka-Volterra predator-prey interior equilibrium:
   (x_star, y_star) = (gamma/delta, alpha/beta) *)
Definition B18_v1_lv_equilibrium (alpha beta gamma delta : Q) : Q * Q :=
  (gamma / delta, alpha / beta).
