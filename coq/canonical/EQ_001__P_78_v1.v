(* EQ-001/P.78.v1 -- open_prop -- Emergent/analogue Lorentzian metric induced by the causal-memory front speed *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* From the telegraph equation's finite front speed v_star^2(s0)=lambda*Psi''(s0)/tau_c (EQ-001/P.35.v1), builds (a) an effective analogue-gravity-style Lorentzian metric g_hat_{mu nu}=eta_{mu nu}+(1-1/n^2)u_mu u_nu with refractive index n(s), and (b) an induced flat light-cone metric ds^2=-v^2 dt^2+|dx|^2 whose curvature vanishes identically, R^alpha_{beta gamma delta}=0 (flatness theorem). *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Theorem). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition EQ_001__P_78_v1_hyp
  (v_star lambda Psi_dd tau_c Riemann : Q) (flat : Prop)
  : Prop :=
  v_star * v_star = lambda * Psi_dd / tau_c /\ (Riemann = 0 <-> flat).
