(* ChemDomain_ledger/C.37.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Eyring transition-state theory: k = (kB T/h) exp(-dG_ddagger/(R T)).
   exp is an opaque Q -> Q function. *)
Section C37_v1.
  Variable expfn : Q -> Q.

  Definition C37_v1_eyring (kB T h dG_ddagger R : Q) : Q :=
    (kB * T / h) * expfn (- dG_ddagger / (R * T)).
End C37_v1.
