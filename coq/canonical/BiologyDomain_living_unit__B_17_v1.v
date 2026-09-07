(* BiologyDomain_living_unit/B.17.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Hill equation cooperative ligand binding: Y = S^n / (S05^n + S^n).
   The Hill coefficient n is generally non-integer, so exponentiation is an
   opaque Q -> Q -> Q operation here (never a computed real power). *)
Section B17_v1.
  Variable qpow : Q -> Q -> Q.  (* qpow base exponent *)

  Definition B17_v1_hill_equation (S S05 n : Q) : Q :=
    qpow S n / (qpow S05 n + qpow S n).
End B17_v1.
