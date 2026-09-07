(* ChemDomain_ledger/C.12.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Reaction enthalpy from average bond dissociation energies:
   dH = sum(broken) - sum(formed), over finite lists of bond energies. *)
Definition C12_v1_bond_enthalpy (broken formed : list Q) : Q :=
  fold_right Qplus 0 broken - fold_right Qplus 0 formed.
