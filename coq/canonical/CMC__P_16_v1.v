(* CMC/P.16.v1 -- open_prop -- Covariant action and weighted Lyapunov stability gate for causal transport *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* F[s] = Integral d^3x [ (kappa/2)(grad s)^2 + Psi(s) ]  (free-energy functional whose Euler-Lagrange equation reproduces the single-pole causal-transport/Cattaneo relation); plus a weighted Lyapunov stability-gate functional (integrand H_tilde, global dissipation condition) for the transport system and its FLRW/two-flux-superfluid extensions. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Postulate). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition CMC__P_16_v1_hyp
  (S : Type) (F : S -> Q) (kappa : Q) (grad_s Psi : S -> Q)
  (weighted_lyapunov_dissipative : Prop)
  : Prop :=
  (forall x : S, F x = kappa * grad_s x + Psi x) /\ weighted_lyapunov_dissipative.
