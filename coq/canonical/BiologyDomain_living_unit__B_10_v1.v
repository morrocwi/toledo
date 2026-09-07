(* BiologyDomain_living_unit/B.10.v1 -- untagged -- parents: BiologyDomain_living_unit *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Exponential (Malthusian) population growth: N = N0 exp(r t).
   exp is treated as an opaque Q -> Q function (information-discrete-math:
   a transcendental is a readout-invariant, never computed from a continuum
   limit here). *)
Section B10_v1.
  Variable expfn : Q -> Q.

  Definition B10_v1_exponential_growth (N0 r t : Q) : Q := N0 * expfn (r * t).
End B10_v1.
