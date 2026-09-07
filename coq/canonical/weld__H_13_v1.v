(* weld/H.13.v1 -- not_yet_formalised -> open_prop -- Effort v0.3 Eq.6: NEW PROPOSITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* N_{ext} < \infty \;\not\Rightarrow\; N_{int} = N_{ext} *)
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

Section weld__H_13_v1_sec.
  Parameter N_ext N_int : nat -> nat.
  Definition weld__H_13_v1_hyp : Prop :=
    exists m : nat, N_int m <> N_ext m.
End weld__H_13_v1_sec.
