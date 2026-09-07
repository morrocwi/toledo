(* ChemDomain_ledger/C.11.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Hess's law of constant heat summation: the total reaction enthalpy is the
   sum of a finite list of signed step enthalpies. *)
Definition C11_v1_hess_total (steps : list Q) : Q := fold_right Qplus 0 steps.
