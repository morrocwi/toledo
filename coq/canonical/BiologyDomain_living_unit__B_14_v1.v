(* BiologyDomain_living_unit/B.14.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)
(* discretises dC/dx as a supplied finite-difference quotient (information-discrete-math table). *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Fick's first law of diffusion: rate = D A (dC/dx).
   dC/dx is the source's own continuum derivative, discretised
   (information-discrete-math table) as an already-computed finite
   difference quotient supplied as a Q parameter. *)
Definition B14_v1_ficks_law (D A dC_dx : Q) : Q := D * A * dC_dx.
