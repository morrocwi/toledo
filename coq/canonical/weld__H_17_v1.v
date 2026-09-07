(* weld/H.17.v1 -- not_yet_formalised -> open_prop -- Effort v0.3 Eq.23: NEW NON-COLLAPSE *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \text{same source readout} \not\Rightarrow \text{same effective agent} \not\Rightarrow \text{same encounter} *)
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

Section weld__H_17_v1_sec.
  Parameter SameSourceReadout SameEffectiveAgent SameEncounter : Prop.
  Definition weld__H_17_v1_hyp : Prop :=
    ~ (SameSourceReadout -> SameEffectiveAgent) /\
    ~ (SameEffectiveAgent -> SameEncounter).
End weld__H_17_v1_sec.
