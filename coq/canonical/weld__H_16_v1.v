(* weld/H.16.v1 -- not_yet_formalised -> open_prop -- Effort v0.3 Eq.22: NEW DERIVATION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* SameTrial_Q(n,m)=1 \iff SID_Q(n,m)\in\{\mathsf{SAME}_{mech},\mathsf{EQUIV}_Q\},\ A_n^Q \sim_Q A_m^Q,\ \mathfrak{I}_n^Q \sim_Q \mathfrak{I}_m^Q *)
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

Section weld__H_16_v1_sec.
  Parameter AgentState IdState : Type.
  Parameter A_Q : nat -> AgentState.
  Parameter I_n_Q : nat -> IdState.
  Parameter sim_A : AgentState -> AgentState -> Prop.
  Parameter sim_I : IdState -> IdState -> Prop.
  Parameter SID_Q : nat -> nat -> Verdict.
  Parameter SameTrial_Q : nat -> nat -> nat.
  Definition weld__H_16_v1_hyp (n m : nat) : Prop :=
    (SameTrial_Q n m = 1)%nat <->
      ((SID_Q n m = SAME_mech \/ SID_Q n m = EQUIV_Q) /\
       sim_A (A_Q n) (A_Q m) /\ sim_I (I_n_Q n) (I_n_Q m)).
End weld__H_16_v1_sec.
