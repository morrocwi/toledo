(* ChemDomain_ledger/C.18.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Standard electrochemical cell potential: E_cell = E_cathode - E_anode *)
Definition C18_v1_cell_potential (E_cathode E_anode : Q) : Q := E_cathode - E_anode.
