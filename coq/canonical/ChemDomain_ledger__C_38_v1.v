(* ChemDomain_ledger/C.38.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Marcus electron-transfer theory:
   k = A exp(-(dG0 + lambda)^2 / (4 lambda kB T)).
   exp is an opaque Q -> Q function. *)
Section C38_v1.
  Variable expfn : Q -> Q.

  Definition C38_v1_marcus (A dG0 lambda kB T : Q) : Q :=
    A * expfn (- (dG0 + lambda) * (dG0 + lambda) / (4 * lambda * kB * T)).
End C38_v1.
