(* BiologyDomain_living_unit/B.08.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Allele frequency from genotype counts:
   q = (2 n_aa + n_Aa) / (2 (n_AA + n_Aa + n_aa)) *)
Definition B08_v1_allele_freq (n_AA n_Aa n_aa : Q) : Q :=
  (2 * n_aa + n_Aa) / (2 * (n_AA + n_Aa + n_aa)).
