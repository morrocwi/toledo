(* ChemDomain_ledger/C.15.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Henderson-Hasselbalch equation: pH = pKa + log10([A-]/[HA]).
   log10 is an opaque Q -> Q function. *)
Section C15_v1.
  Variable log10fn : Q -> Q.

  Definition C15_v1_henderson_hasselbalch (pKa A_minus HA : Q) : Q :=
    pKa + log10fn (A_minus / HA).
End C15_v1.
