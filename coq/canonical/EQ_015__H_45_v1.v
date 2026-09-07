(* EQ-015/H.45.v1 -- not_yet_formalised -> definition -- Collective Epistemic Hallucination (CEH) status-inflation chain *)
(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* K_{\mathrm{like}} \overset{forget}{\longrightarrow} K_{\mathrm{assumed}} \overset{recursion}{\longrightarrow} K_{\mathrm{reinforced}} \overset{misattribution}{\longrightarrow} K_{\mathrm{collectively\ warranted\text{-}looking}} *)
(* Toledo v1.5 fix (SCHEMA-CONSISTENCY-1): finite-model definition --
   every symbol not already fixed by the statement above is a local
   Section Parameter (its type chosen only so the equation
   type-checks; nothing about what it computes is asserted).
   A defining equation/notion, not a theorem -- no proof obligation. *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Section EQ_015__H_45_v1_sec.
  Parameter KStatus : Type.
  Parameter K_like K_assumed K_reinforced K_collectively_warranted : KStatus.
  Parameter forget_step recursion_step misattribution_step : KStatus -> KStatus -> Prop.
  Definition EQ_015__H_45_v1_def : Prop :=
    forget_step K_like K_assumed /\
    recursion_step K_assumed K_reinforced /\
    misattribution_step K_reinforced K_collectively_warranted.
End EQ_015__H_45_v1_sec.
