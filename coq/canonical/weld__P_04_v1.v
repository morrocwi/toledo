(* weld/P.04.v1 -- open_prop -- Explicit closed-form telegraph Green's function (1D) *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* G = [e^{-t/(2 tau)} / (2v)] H(vt-|x|) [ delta(|x|-vt) + (I0(xi) + (vt/sqrt(v^2 t^2 - x^2)) I1(xi)) / (2 tau) ], xi = sqrt(v^2 t^2 - x^2) / (2 v tau); reduces to the heat-kernel / wave-kernel limiting cases as tau->0 / tau->infinity. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Theorem). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition weld__P_04_v1_hyp
  (v tau x t xi G : Q) (Hstep delta I0 I1 exp_neg sqrtf : Q -> Q)
  : Prop :=
  xi = sqrtf (v * v * t * t - x * x) / (2 * v * tau) /\
  G = (exp_neg (t / (2 * tau)) / (2 * v)) * Hstep (v * t - Qabs x) *
      (delta (Qabs x - v * t) +
       (I0 xi + (v * t / sqrtf (v * v * t * t - x * x)) * I1 xi) / (2 * tau)).
