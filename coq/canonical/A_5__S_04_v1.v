(* A.5/S.04.v1 -- Definition -- parents: A.5/M.01.v1, A.5/S.01.v1 *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


Section A5_S04_v1.
  Variables StateSpace ConstraintSpace : Type.
  Variable F : StateSpace -> ConstraintSpace -> StateSpace.

  (* Constrained dynamical system: x' = F(x, C) *)
  Definition A5_S04_v1_dynamics (x : StateSpace) (C : ConstraintSpace) : StateSpace :=
    F x C.
End A5_S04_v1.
