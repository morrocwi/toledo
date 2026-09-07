(* ChemDomain_ledger/C.24.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Clausius-Clapeyron equation: ln(P2/P1) = -(dHvap/R)(1/T2 - 1/T1).
   ln is an opaque Q -> Q function. *)
Section C24_v1.
  Variable lnfn : Q -> Q.

  Definition C24_v1_clausius_clapeyron (P1 P2 dHvap R T1 T2 : Q) : Prop :=
    lnfn (P2 / P1) == - (dHvap / R) * (1 / T2 - 1 / T1).
End C24_v1.
