(* BiologyDomain_living_unit/B.07.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Hardy-Weinberg equilibrium, homozygous-recessive genotype frequency: q^2
   (guarded 0 <= q <= 1 by the source; the guard is a usage precondition, not
   part of the algebraic definition itself). *)
Definition B07_v1_q_squared (q : Q) : Q := q * q.
