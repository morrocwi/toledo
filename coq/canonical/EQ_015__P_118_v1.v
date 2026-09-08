(* EQ-015/P.118.v1 -- open_prop -- The mass-free identity: Schwarzschild radius x causal-memory time = Planck length squared *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* R_s * c * tau_c = G*hbar/c^3 = ell_P^2. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Definition). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition EQ_015__P_118_v1_hyp
  (R_s c tau_c G hbar ell_P : Q)
  : Prop :=
  R_s * c * tau_c = (G * hbar) / (c * c * c) /\
  (G * hbar) / (c * c * c) = ell_P * ell_P.
