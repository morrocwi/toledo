(* EQ-015/H.38.v1 -- not_yet_formalised -> open_prop -- Effort v0.3 Eq.28: NEW DERIVATION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* Y_{n+1}^{world} \to O_Q \to \mu_{n+1}^Q \to E_{n+1}^Q \to \mathrm{Retain}_Q \to A_{n+1}^Q *)
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

Section EQ_015__H_38_v1_sec.
  Parameter WorldEvent Observation Model Effect Agent : Type.
  Parameter Y_world : nat -> WorldEvent.
  Parameter O_Q : WorldEvent -> Observation.
  Parameter mu_Q : Observation -> Model.
  Parameter E_Q : Model -> Effect.
  Parameter Retain_Q : Effect -> Agent -> Agent.
  Parameter A_Q : nat -> Agent.
  Definition EQ_015__H_38_v1_hyp (n : nat) : Prop :=
    A_Q (S n) = Retain_Q (E_Q (mu_Q (O_Q (Y_world (S n))))) (A_Q n).
End EQ_015__H_38_v1_sec.
