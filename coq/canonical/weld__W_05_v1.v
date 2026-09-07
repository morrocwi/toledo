(* weld/W.05.v1 -- not_yet_formalised -> open_prop -- Candidate-validation backlog recursion (New Derivation 1) *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* B_{t+1} = \max\left\{ 0, (1-\delta_B)B_t+\Lambda_t-\mu_t \right\} *)
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

Section weld__W_05_v1_sec.
  Parameter delta_B : Q.
  Parameter Lambda_t mu_t B : nat -> Q.
  Definition weld__W_05_v1_hyp (t : nat) : Prop :=
    B (S t) = Qmax 0 ((1 - delta_B) * B t + Lambda_t t - mu_t t).
End weld__W_05_v1_sec.
