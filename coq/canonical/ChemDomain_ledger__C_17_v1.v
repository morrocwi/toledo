(* ChemDomain_ledger/C.17.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Solubility product Ksp, molar solubility of a 1:1 salt: s = sqrt(Ksp).
   sqrt is an opaque Q -> Q function. *)
Section C17_v1.
  Variable sqrtfn : Q -> Q.

  Definition C17_v1_solubility (Ksp : Q) : Q := sqrtfn Ksp.
End C17_v1.
