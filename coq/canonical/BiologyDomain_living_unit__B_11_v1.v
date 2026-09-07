(* BiologyDomain_living_unit/B.11.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Logistic population growth with carrying capacity:
   N = K / (1 + ((K - N0)/N0) exp(-r t)) *)
Section B11_v1.
  Variable expfn : Q -> Q.

  Definition B11_v1_logistic_growth (K N0 r t : Q) : Q :=
    K / (1 + ((K - N0) / N0) * expfn (- r * t)).
End B11_v1.
