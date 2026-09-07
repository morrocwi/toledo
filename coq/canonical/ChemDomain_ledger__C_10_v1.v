(* ChemDomain_ledger/C.10.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Graham's law of effusion: rate1/rate2 = sqrt(M2/M1).
   sqrt is an opaque Q -> Q function. *)
Section C10_v1.
  Variable sqrtfn : Q -> Q.

  Definition C10_v1_grahams_law (rate1 rate2 M1 M2 : Q) : Prop :=
    rate1 / rate2 == sqrtfn (M2 / M1).
End C10_v1.
