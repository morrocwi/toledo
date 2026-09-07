(* weld/M.31.v1 -- not_yet_formalised -> open_prop -- Effort v0.3 Eq.40: NEW PROPOSITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \mathcal{U}_{n+1}^{safe} = \varnothing \;\Rightarrow\; \mathsf{STOP} *)
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

Section weld__M_31_v1_sec.
  Parameter Action Decision : Type.
  Parameter U_safe : nat -> Action -> Prop.
  Parameter STOP_dec : Decision.
  Parameter D : nat -> Decision.
  Definition weld__M_31_v1_hyp (n : nat) : Prop :=
    (~ exists u, U_safe (S n) u) -> D (S n) = STOP_dec.
End weld__M_31_v1_sec.
