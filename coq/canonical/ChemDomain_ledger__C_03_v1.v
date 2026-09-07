(* ChemDomain_ledger/C.03.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Mass-mass stoichiometry from a balanced equation: given moles of reactant
   A and the balanced-equation coefficients, moles of product B = nA *
   coeffB/coeffA, then mass of B = nB * MB. *)
Definition C03_v1_mass_mass_stoichiometry (nA coeffA coeffB MB : Q) : Q :=
  (nA * coeffB / coeffA) * MB.
