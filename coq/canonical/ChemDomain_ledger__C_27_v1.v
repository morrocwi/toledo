(* ChemDomain_ledger/C.27.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Nernst equation: E = E0 - (RT/nF) ln Q_rxn.
   The reaction quotient is named Q_rxn here to avoid shadowing the Q type.
   ln is an opaque Q -> Q function. *)
Section C27_v1.
  Variable lnfn : Q -> Q.

  Definition C27_v1_nernst (E0 R T n F Q_rxn : Q) : Q :=
    E0 - (R * T / (n * F)) * lnfn Q_rxn.
End C27_v1.
