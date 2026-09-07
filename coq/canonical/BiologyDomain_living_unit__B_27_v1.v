(* BiologyDomain_living_unit/B.27.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Lotka-Volterra interior-equilibrium Jacobian eigenvalue magnitude:
   |Im(lambda)| = sqrt(alpha gamma). sqrt is an opaque Q -> Q function. *)
Section B27_v1.
  Variable sqrtfn : Q -> Q.

  Definition B27_v1_lv_eigenvalue_magnitude (alpha gamma : Q) : Q := sqrtfn (alpha * gamma).
End B27_v1.
