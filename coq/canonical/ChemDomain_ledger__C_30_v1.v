(* ChemDomain_ledger/C.30.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Second-order integrated rate law: 1/[A] = 1/[A]0 + k t *)
Definition C30_v1_second_order (A A0 k t : Q) : Prop := 1 / A == 1 / A0 + k * t.
