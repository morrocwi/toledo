(* ChemDomain_ledger/C.32.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Bragg's law: n lambda = 2 d sin(theta). sin is an opaque Q -> Q function. *)
Section C32_v1.
  Variable sinfn : Q -> Q.

  Definition C32_v1_braggs_law (n lambda d theta : Q) : Prop :=
    n * lambda == 2 * d * sinfn theta.
End C32_v1.
