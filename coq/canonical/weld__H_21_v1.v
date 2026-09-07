(* weld/H.21.v1 -- not_yet_formalised -> open_prop -- Effort v0.3 Eq.27: NEW PROPOSITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* SID_Q(n,n{+}1)=\mathsf{SAME}_{mech},\ A_{n+1}^Q \not\sim_Q A_n^Q,\ ISW_Q(\mathcal{G}_n, A_n^Q, A_{n+1}^Q; c_n) = \mathsf{FAIL} \;\Rightarrow\; \text{no changed-agent credit for } \mathfrak{I}^Q *)
(* Toledo v1.5 lane B (DEBT #45 part 2): finite-model open_prop --
   every symbol not already fixed by the statement above is a local
   Section Parameter (its type chosen only so the equation
   type-checks; nothing about what it computes is asserted).
   Unproved by design (Dr/Open source label). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.
From MRC Require Import _hrp_verdict_vocab.

Section weld__H_21_v1_sec.
  Parameter GState AgentState Context IdState : Type.
  Parameter G_n : nat -> GState.
  Parameter A_Q : nat -> AgentState.
  Parameter c_n : nat -> Context.
  Parameter I_n_Q : nat -> IdState.
  Parameter sim_A : AgentState -> AgentState -> Prop.
  Parameter SID_Q : nat -> nat -> Verdict.
  Parameter ISW_Q : GState -> AgentState -> AgentState -> Context -> Verdict.
  Parameter ChangedAgentCredit : nat -> IdState -> Prop.
  Definition weld__H_21_v1_hyp (n : nat) : Prop :=
    (SID_Q n (S n) = SAME_mech /\
     ~ sim_A (A_Q (S n)) (A_Q n) /\
     ISW_Q (G_n n) (A_Q n) (A_Q (S n)) (c_n n) = FAIL) ->
    ~ ChangedAgentCredit n (I_n_Q (S n)).
End weld__H_21_v1_sec.
