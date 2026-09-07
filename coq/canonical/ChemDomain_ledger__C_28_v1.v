(* ChemDomain_ledger/C.28.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Arrhenius equation, two-temperature activation energy:
   Ea = -R ln(k2/k1) / (1/T2 - 1/T1). ln is an opaque Q -> Q function. *)
Section C28_v1.
  Variable lnfn : Q -> Q.

  Definition C28_v1_arrhenius_ea (R k1 k2 T1 T2 : Q) : Q :=
    - R * lnfn (k2 / k1) / (1 / T2 - 1 / T1).
End C28_v1.
