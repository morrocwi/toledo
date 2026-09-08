(* weld/P.02.v1 -- open_prop -- The Deborah number for telegraph-causal outflows *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* De := tau * Omega; observational inference rule D/tau ~ (ell*Rg/Delta t)^2 from a measured outflow lag. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Empirical). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition weld__P_02_v1_hyp
  (tau Omega De ell Rg dt : Q)
  : Prop :=
  De = tau * Omega /\ De / tau = (ell * Rg / dt) * (ell * Rg / dt).
