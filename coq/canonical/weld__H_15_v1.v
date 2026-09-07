(* weld/H.15.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.21: NEW DOMAIN DEFINITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \mathfrak{I}_n^Q := \mathfrak{I}_Q(\mathcal{G}_n, A_n^Q, c_n) *)
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

Section weld__H_15_v1_sec.
  Parameter GState Context AgentState QModel IdState : Type.
  Parameter G_n : nat -> GState.
  Parameter A_Q : nat -> AgentState.
  Parameter c_n : nat -> Context.
  Parameter I_Q : GState -> AgentState -> Context -> IdState.
  Parameter I_n_Q : nat -> IdState.
  Definition weld__H_15_v1_def (n : nat) : Prop :=
    I_n_Q n = I_Q (G_n n) (A_Q n) (c_n n).
End weld__H_15_v1_sec.
