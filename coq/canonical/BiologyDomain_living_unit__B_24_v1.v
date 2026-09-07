(* BiologyDomain_living_unit/B.24.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Moran/Wright-Fisher genic-selection fixation probability:
   p_fix = (1 - exp(-2s)) / (1 - exp(-2 N s)).
   exp is treated as an opaque Q -> Q function. *)
Section B24_v1.
  Variable expfn : Q -> Q.

  Definition B24_v1_fixation_probability (N s : Q) : Q :=
    (1 - expfn (- 2 * s)) / (1 - expfn (- 2 * N * s)).
End B24_v1.
