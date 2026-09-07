(* weld/W.06.v1 -- not_yet_formalised -> open_prop -- Positive-backlog steady state (Proposition 1, Validation-Backlog Equilibrium) *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* B^* = \frac{\Lambda-\mu}{\delta_B} \qquad \text{for }\Lambda>\mu *)
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

Section weld__W_06_v1_sec.
  Parameter Lambda mu delta_B B_star : Q.
  Definition weld__W_06_v1_hyp : Prop :=
    (Lambda > mu)%Q -> delta_B <> 0%Q -> B_star = ((Lambda - mu) / delta_B)%Q.
End weld__W_06_v1_sec.
