(* A.5/H.24.v1 -- not_yet_formalised -> open_prop -- Agent accuracy gain does not entail network corrigibility gain *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \Delta Accuracy_{\mathrm{agent}}>0 \not\Rightarrow \Delta Corrigibility_{\mathcal G}>0 *)
(* Toledo v1.5 fix (SCHEMA-CONSISTENCY-1): finite-model open_prop --
   every symbol not already fixed by the statement above is a local
   Section Parameter (its type chosen only so the equation
   type-checks; nothing about what it computes is asserted).
   Unproved by design (Dr source label). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Section A_5__H_24_v1_sec.
  Parameter Agent Network : Type.
  Parameter AccuracyGain : Agent -> Prop.
  Parameter CorrigibilityGain : Network -> Prop.
  Parameter network_of : Agent -> Network.
  Definition A_5__H_24_v1_hyp : Prop :=
    ~ (forall a : Agent, AccuracyGain a -> CorrigibilityGain (network_of a)).
End A_5__H_24_v1_sec.
