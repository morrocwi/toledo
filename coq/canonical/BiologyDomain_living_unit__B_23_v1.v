(* BiologyDomain_living_unit/B.23.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Jukes-Cantor phylogenetic distance: d = -3/4 ln(1 - 4p/3).
   ln is treated as an opaque Q -> Q function. *)
Section B23_v1.
  Variable lnfn : Q -> Q.

  Definition B23_v1_jukes_cantor (p : Q) : Q := - (3 # 4) * lnfn (1 - 4 * p / 3).
End B23_v1.
