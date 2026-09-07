(* ChemDomain_ledger/C.40.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Brunauer-Emmett-Teller (BET) multilayer adsorption isotherm:
   V/Vm = C x / ((1-x)(1-x+Cx)) *)
Definition C40_v1_bet (V Vm C x : Q) : Prop :=
  V / Vm == C * x / ((1 - x) * (1 - x + C * x)).
