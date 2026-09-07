(* ChemDomain_ledger/C.36.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Michaelis-Menten enzyme kinetics: v = Vmax [S] / (Km + [S]) *)
Definition C36_v1_michaelis_menten (Vmax S Km : Q) : Q := Vmax * S / (Km + S).
