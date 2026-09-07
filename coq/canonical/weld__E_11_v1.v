(* weld/E.11.v1 -- not_yet_formalised -> open_prop -- Effort v0.3 Eq.1: NEW NON-COLLAPSE *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \text{uncertainty} \not\equiv \text{stochastic mechanism} \\ \text{stochastic mechanism} \not\equiv \text{other-agent control} \\ \text{other-agent control} \not\equiv \text{unresolved residual} *)
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

Section weld__E_11_v1_sec.
  Parameter Cause : Type.
  Parameter UncertaintyCause StochasticMechanismCause OtherAgentControlCause UnresolvedResidualCause : Cause.
  Definition weld__E_11_v1_hyp : Prop :=
    UncertaintyCause <> StochasticMechanismCause /\
    StochasticMechanismCause <> OtherAgentControlCause /\
    OtherAgentControlCause <> UnresolvedResidualCause.
End weld__E_11_v1_sec.
