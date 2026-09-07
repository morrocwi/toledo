(* ChemDomain_ledger/C.35.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Debye-Hueckel limiting law: log10(gamma) = -A z^2 sqrt(I).
   log10 and sqrt are opaque Q -> Q functions. *)
Section C35_v1.
  Variable log10fn sqrtfn : Q -> Q.

  Definition C35_v1_debye_huckel (A z I : Q) : Prop :=
    log10fn (- A * z * z * sqrtfn I) == - A * z * z * sqrtfn I.
End C35_v1.
