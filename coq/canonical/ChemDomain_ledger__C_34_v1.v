(* ChemDomain_ledger/C.34.v1 -- untagged -- parents: ChemDomain_ledger *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Rigid-rotor rotational constant: B = h/(8 pi^2 mu r^2).
   pi is kept as an opaque Q constant (information-discrete-math:
   readout-invariant, never a computed real). *)
Section C34_v1.
  Variable pi_const : Q.

  Definition C34_v1_rotational_constant (h mu r : Q) : Q :=
    h / (8 * pi_const * pi_const * mu * r * r).
End C34_v1.
