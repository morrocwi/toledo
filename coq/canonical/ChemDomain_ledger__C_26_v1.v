(* ChemDomain_ledger/C.26.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Van 't Hoff equation: ln(K2/K1) = -(dH/R)(1/T2 - 1/T1).
   ln is an opaque Q -> Q function. *)
Section C26_v1.
  Variable lnfn : Q -> Q.

  Definition C26_v1_vant_hoff (K1 K2 dH R T1 T2 : Q) : Prop :=
    lnfn (K2 / K1) == - (dH / R) * (1 / T2 - 1 / T1).
End C26_v1.
