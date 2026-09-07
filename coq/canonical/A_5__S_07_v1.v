(* A.5/S.07.v1 -- Definition -- parents: A.5/M.01.v1, A.5/S.01.v1 *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


Section A5_S07_v1.
  Variables StateSpace ConstraintSpace : Type.
  Variable G : StateSpace -> ConstraintSpace -> ConstraintSpace.

  (* Constraint evolution law: C_{t+1} = G(x_t, C_t) *)
  Definition A5_S07_v1_constraint_evolution (x : StateSpace) (C : ConstraintSpace) : ConstraintSpace :=
    G x C.
End A5_S07_v1.
