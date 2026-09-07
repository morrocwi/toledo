(* ChemDomain_ledger/C.22.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Colligative property closed form: dT = i K m (boiling-point elevation /
   freezing-point depression, one closed form for both via K = Kb or K = Kf). *)
Definition C22_v1_colligative_dT (i K m : Q) : Q := i * K * m.
