(* weld/W.03.v1 -- not_yet_formalised -> definition -- Effective candidate-validation workload (New Definition 2) *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \Lambda_t = \sum_{c\in\mathcal C_t^{new}} w(c) *)
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

Section weld__W_03_v1_sec.
  Parameter Candidate : Type.
  Parameter w : Candidate -> Q.
  Parameter C_t_new : nat -> list Candidate.
  Definition weld__W_03_v1_def (t : nat) : Q :=
    fold_right (fun c acc => (w c + acc)%Q) 0%Q (C_t_new t).
End weld__W_03_v1_sec.
