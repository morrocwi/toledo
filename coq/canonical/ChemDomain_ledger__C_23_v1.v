(* ChemDomain_ledger/C.23.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Van der Waals real-gas equation of state:
   P = nRT/(V - nb) - a n^2/V^2 *)
Definition C23_v1_van_der_waals (n R T V a b : Q) : Q :=
  n * R * T / (V - n * b) - a * n * n / (V * V).
