(* weld/M.26.v1 -- not_yet_formalised -> definition -- Effort v0.3 Eq.34: NEW DOMAIN DEFINITION *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* CER_Q = \mathsf{PASS} \iff ERG_D = \mathsf{PASS} \wedge ID_Q(u \to Y) = \mathsf{PASS} *)
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

Section weld__M_26_v1_sec.
  Parameter Action Outcome : Type.
  Parameter ERG_D : Verdict.
  Parameter u : Action.
  Parameter Y : Outcome.
  Parameter ID_Q : Action -> Outcome -> Verdict.
  Parameter CER_Q : Verdict.
  Definition weld__M_26_v1_def : Prop :=
    CER_Q = PASS <-> (ERG_D = PASS /\ ID_Q u Y = PASS).
End weld__M_26_v1_sec.
