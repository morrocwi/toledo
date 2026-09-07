(* BiologyDomain_living_unit/B.21.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Mutation-selection balance, recessive allele: q_hat = sqrt(mu/s).
   sqrt is treated as an opaque Q -> Q function. *)
Section B21_v1.
  Variable sqrtfn : Q -> Q.

  Definition B21_v1_mutation_selection_balance (mu s : Q) : Q := sqrtfn (mu / s).
End B21_v1.
