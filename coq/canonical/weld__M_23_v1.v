(* weld/M.23.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.18: NEW DOMAIN DEFINITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* SID_Q(n,m) \in \{\mathsf{SAME}_{mech}, \mathsf{EQUIV}_Q, \mathsf{DIFF}_Q, \mathsf{HOLD}\} *)
(* Toledo v1.5 lane B (DEBT #45 part 2): finite-model definition --
   every symbol not already fixed by the statement above is a local
   Section Parameter (its type chosen only so the equation
   type-checks; nothing about what it computes is asserted).
   A defining equation/notion, not a theorem -- no proof obligation. *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.
From MRC Require Import _hrp_verdict_vocab.

Section weld__M_23_v1_sec.
  Parameter SID_Q : nat -> nat -> Verdict.
  Definition weld__M_23_v1_def (n m : nat) : Prop :=
    SID_Q n m = SAME_mech \/ SID_Q n m = EQUIV_Q \/
    SID_Q n m = DIFF_Q \/ SID_Q n m = HOLD.
End weld__M_23_v1_sec.
