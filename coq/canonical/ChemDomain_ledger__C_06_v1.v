(* ChemDomain_ledger/C.06.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* pH scale: pH = -log10([H+]). log10 is an opaque Q -> Q function. *)
Section C06_v1.
  Variable log10fn : Q -> Q.

  Definition C06_v1_pH (H_plus : Q) : Q := - log10fn H_plus.
End C06_v1.
