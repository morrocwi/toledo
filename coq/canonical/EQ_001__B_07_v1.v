(* EQ-001/B.07.v1 -- untagged -- parents: EQ-001 *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Two-component state (integrity x, reserve e) updates under a no-free-repair
   ledger: x' + e' = x + e + j - d, for contract (d,j) and repair policy a.
   Formalised as the ledger conservation law itself (a Definition, not yet a
   theorem about any specific policy). *)
Definition EQ001_B07_v1_ledger_update (x e j d x' e' : Q) : Prop :=
  x' + e' == x + e + j - d.
