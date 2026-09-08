(* EQ-001/P.76.v1 -- open_prop -- FRW compatibility of the telegraph equation (Hubble-friction extension) *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* tau * d^2rho/dt^2 + (1 + 3*H*tau) * drho/dt = (D/a^2) * Laplacian(rho). *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Conjecture). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition EQ_001__P_76_v1_hyp
  (tau H a D d2rho_dt2 drho_dt lap_rho : Q)
  : Prop :=
  tau * d2rho_dt2 + (1 + 3 * H * tau) * drho_dt = (D / (a * a)) * lap_rho.
