(* A.5/H.20.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.30: NEW DOMAIN DEFINITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* LC_Q(n) = \mathsf{PASS} \iff RB_Q(n)=1 \wedge \Lambda_Q(n) = \mathsf{PASS} *)
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

Section A_5__H_20_v1_sec.
  Parameter RB_Q : nat -> nat.
  Parameter Lambda_Q LC_Q : nat -> Verdict.
  Definition A_5__H_20_v1_def (n : nat) : Prop :=
    LC_Q n = PASS <-> ((RB_Q n = 1)%nat /\ Lambda_Q n = PASS).
End A_5__H_20_v1_sec.
