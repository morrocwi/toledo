(* BiologyDomain_living_unit/B.25.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Kingman coalescent expected TMRCA: E[TMRCA] = 2 (1 - 1/n) Ne *)
Definition B25_v1_expected_tmrca (n Ne : Q) : Q := 2 * (1 - 1 / n) * Ne.
