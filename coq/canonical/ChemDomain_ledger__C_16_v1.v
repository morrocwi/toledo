(* ChemDomain_ledger/C.16.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Acid-base titration equivalence-point stoichiometry:
   C_acid V_acid = C_base V_base *)
Definition C16_v1_titration_equivalence (C_acid V_acid C_base V_base : Q) : Prop :=
  C_acid * V_acid == C_base * V_base.
