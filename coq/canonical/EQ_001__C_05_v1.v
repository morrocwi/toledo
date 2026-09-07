(* EQ-001/C.05.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* RT-REFINE-005: for a finite state set, repeatedly splitting cells by
   declared readout and successor-cell signatures terminates in an exact
   closed refinement. A real combinatorial termination claim; not proved
   here (would need a partition-refinement development), stated openly. *)
Definition EQ001_C05_hyp
  (State : Type) (refine_step : list (list State) -> list (list State))
  (is_closed : list (list State) -> Prop) : Prop :=
  forall (P0 : list (list State)),
    exists k : nat, is_closed (Nat.iter k refine_step P0).
