(* ChemDomain_ledger/C.42.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Stokes-Einstein diffusion coefficient: D = kB T/(6 pi eta r).
   pi is kept as an opaque Q constant (information-discrete-math:
   readout-invariant, never a computed real). *)
Section C42_v1.
  Variable pi_const : Q.

  Definition C42_v1_stokes_einstein (kB T eta r : Q) : Q :=
    kB * T / (6 * pi_const * eta * r).
End C42_v1.
