(* A.5/S.05.v1 -- Definition -- parents: A.5/M.01.v1, A.5/S.01.v1 *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


Section A5_S05_v1.
  Variable StateSpace : Type.
  Variable V : StateSpace -> Prop.  (* the viable region V of the state space, as a predicate *)

  (* Viable region membership: x(t) in V, for all t in the interval of observation *)
  Definition A5_S05_v1_viable_at (x : nat -> StateSpace) : Prop :=
    forall t : nat, V (x t).
End A5_S05_v1.
