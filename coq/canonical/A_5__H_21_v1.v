(* A.5/H.21.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.31: NEW DOMAIN DEFINITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* IC_Q(n) = \mathsf{PASS} \iff LC_Q(n) = \mathsf{PASS} \wedge \Gamma_Q(n) > \tau_G *)
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

Section A_5__H_21_v1_sec.
  Parameter Gamma_Q : nat -> Q.
  Parameter tau_G : Q.
  Parameter LC_Q IC_Q : nat -> Verdict.
  Definition A_5__H_21_v1_def (n : nat) : Prop :=
    IC_Q n = PASS <-> (LC_Q n = PASS /\ (Gamma_Q n > tau_G)%Q).
End A_5__H_21_v1_sec.
