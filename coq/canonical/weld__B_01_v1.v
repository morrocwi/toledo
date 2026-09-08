(* weld/B.01.v1 -- open_prop -- Environment-coupled admissibility bandwidth (external-covariate derating of causal recovery bandwidth) *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* gamma_eff(PM2.5) = gamma_0 * D(PM2.5), D a monotone-decreasing derating function of ambient PM2.5 concentration, thresholded at operational bands; reduces admissible recovery bandwidth under poor air quality. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Definition). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition weld__B_01_v1_hyp
  (gamma0 : Q) (D : Q -> Q) (monotone_decreasing : (Q -> Q) -> Prop)
  (gamma_eff : Q -> Q)
  : Prop :=
  monotone_decreasing D /\ (forall pm25 : Q, gamma_eff pm25 = gamma0 * D pm25).
