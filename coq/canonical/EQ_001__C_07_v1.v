(* EQ-001/C.07.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* RT-STATIONARY-007: a quotient fixed point can hide source-state cycles;
   witness: negb on bool is a genuine 2-cycle, but the constant quotient
   q := fun _ => 0 is unchanged by it (q looks "stationary" while f is not
   the identity). *)
Theorem EQ001_C07_quotient_hides_cycle :
  exists (S : Type) (f : S -> S) (q : S -> nat) (s : S),
    f (f s) = s /\ f s <> s /\ (forall x, q (f x) = q x).
Proof.
  exists bool, negb, (fun _ => 0%nat), true.
  split.
  - reflexivity.
  - split.
    + discriminate.
    + intros x; reflexivity.
Qed.
