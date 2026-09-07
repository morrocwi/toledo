(* EQ-015/H.39.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.29: NEW DOMAIN DEFINITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* RB_Q(n) = 1 \iff A_{n+1}^Q \not\sim_Q A_n^Q *)
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

Section EQ_015__H_39_v1_sec.
  Parameter Agent : Type.
  Parameter sim_Q : Agent -> Agent -> Prop.
  Parameter A_Q : nat -> Agent.
  Parameter RB_Q : nat -> nat.
  Definition EQ_015__H_39_v1_def (n : nat) : Prop :=
    (RB_Q n = 1)%nat <-> ~ sim_Q (A_Q (S n)) (A_Q n).
End EQ_015__H_39_v1_sec.
