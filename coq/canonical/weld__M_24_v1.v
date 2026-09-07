(* weld/M.24.v1 -- not_yet_formalised -> open_prop -- Effort v0.3 Eq.19: NEW PROPOSITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* SID_Q(n,m) = \mathsf{EQUIV}_Q \;\not\Rightarrow\; \mathcal{G}_n = \mathcal{G}_m *)
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

Section weld__M_24_v1_sec.
  Parameter GState : Type.
  Parameter G_n : nat -> GState.
  Parameter SID_Q : nat -> nat -> Verdict.
  Definition weld__M_24_v1_hyp : Prop :=
    ~ (forall n m : nat, SID_Q n m = EQUIV_Q -> G_n n = G_n m).
End weld__M_24_v1_sec.
