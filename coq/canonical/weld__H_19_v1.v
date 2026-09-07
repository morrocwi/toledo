(* weld/H.19.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.25: NEW DOMAIN DEFINITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* SID_Q(n,n{+}1)=\mathsf{SAME}_{mech},\quad A_{n+1}^Q \not\sim_Q A_n^Q,\quad ISW_Q(\mathcal{G}_n, A_n^Q, A_{n+1}^Q; c_n) = \mathsf{PASS} *)
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

Section weld__H_19_v1_sec.
  Parameter GState AgentState Context : Type.
  Parameter G_n : nat -> GState.
  Parameter A_Q : nat -> AgentState.
  Parameter c_n : nat -> Context.
  Parameter sim_A : AgentState -> AgentState -> Prop.
  Parameter SID_Q : nat -> nat -> Verdict.
  Parameter ISW_Q : GState -> AgentState -> AgentState -> Context -> Verdict.
  Definition weld__H_19_v1_def (n : nat) : Prop :=
    SID_Q n (S n) = SAME_mech /\
    ~ sim_A (A_Q (S n)) (A_Q n) /\
    ISW_Q (G_n n) (A_Q n) (A_Q (S n)) (c_n n) = PASS.
End weld__H_19_v1_sec.
