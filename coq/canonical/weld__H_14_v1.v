(* weld/H.14.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.20: NEW DOMAIN DEFINITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* A_n^Q := q_A(S_n, T_n, c_n; Q) *)
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

Section weld__H_14_v1_sec.
  Parameter SigState TState Context AgentState QModel : Type.
  Parameter S_n : nat -> SigState.
  Parameter T_n : nat -> TState.
  Parameter c_n : nat -> Context.
  Parameter Qm : QModel.
  Parameter q_A : SigState -> TState -> Context -> QModel -> AgentState.
  Parameter A_Q : nat -> AgentState.
  Definition weld__H_14_v1_def (n : nat) : Prop :=
    A_Q n = q_A (S_n n) (T_n n) (c_n n) Qm.
End weld__H_14_v1_sec.
