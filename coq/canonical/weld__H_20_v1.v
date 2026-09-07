(* weld/H.20.v1 -- not_yet_formalised -> open_prop -- Effort v0.3 Eq.26: NEW PROPOSITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \mathfrak{I}_{n+1}^Q \not\sim_Q \mathfrak{I}_n^Q *)
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

Section weld__H_20_v1_sec.
  Parameter IdState : Type.
  Parameter I_n_Q : nat -> IdState.
  Parameter sim_I : IdState -> IdState -> Prop.
  Definition weld__H_20_v1_hyp (n : nat) : Prop :=
    ~ sim_I (I_n_Q (S n)) (I_n_Q n).
End weld__H_20_v1_sec.
