(* A.5/S.06.v1 -- Definition -- parents: A.5/M.01.v1, A.5/S.01.v1 *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)
(* discretises the source's continuum derivative d/dt via a one-tick difference (information-discrete-math table); the probabilistic 'in expectation' qualifier is not modelled. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


Section A5_S06_v1.
  Variable StateSpace : Type.
  Variable dist_to_V : StateSpace -> Q.  (* d(x,V): distance-to-viable-region readout *)

  (* Persistence regulation condition, discretised per the derivative -> discrete
     difference replacement (d/dt[d(x(t),V)] < 0 becomes: the readout strictly
     decreases from one tick to the next). The source's "(in expectation)"
     qualifier needs a probability structure not present in this finite model
     and is not modelled here -- only the deterministic decrease direction is. *)
  Definition A5_S06_v1_persistence_regulation (x : nat -> StateSpace) (t : nat) : Prop :=
    dist_to_V (x (S t)) < dist_to_V (x t).
End A5_S06_v1.
