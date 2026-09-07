(* EQ-001/B.09.v1 -- finite_diagnostic -- parents: EQ-001 *)
(* Toledo v1.1 lane B1: formalised as a typed Definition in a finite/discrete model (Q) per registry/CANONICAL.json's own statement.latex; no Coq.Reals, no Classical, no Admitted. *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.


(* Mortality as a structural readout: irreversible exit from the viable set
   V_A -- once a trajectory leaves V_A at some tick, it never returns. *)
Section EQ001_B09_v1.
  Variable State : Type.
  Variable V_A : State -> Prop.

  Definition EQ001_B09_v1_irreversible_exit (path : nat -> State) : Prop :=
    exists n : nat, ~ V_A (path n) /\ forall m : nat, (n <= m)%nat -> ~ V_A (path m).
End EQ001_B09_v1.
