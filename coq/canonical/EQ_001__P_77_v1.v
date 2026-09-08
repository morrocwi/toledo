(* EQ-001/P.77.v1 -- open_prop -- Telegraph-to-Klein-Gordon dephasing map and derived mass-memory identity (with renormalisation-stability extension) *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* Dephasing substitution s(x,t)=e^{-t/(2 tau_c)}*psi(x,t) turns the registered telegraph equation into a Klein-Gordon-type field equation d^2psi/dt^2 - c^2*Laplacian(psi) + psi/(4 tau_c^2) = 0, identifying a derived mass m_eff = hbar/(2 c^2 tau_c) (equivalently m=1/(2 tau_c) in natural units), corroborated by ten independent routes (uncertainty, Zitterbewegung, Compton time, Margolus-Levitin, ...); a companion order-exclusion uniqueness lemma (only quadratic-order-or-lower PDEs survive) and a one-loop renormalisation-stability sketch argue the derived mass gap survives minimal gauge coupling in phi^4/Yukawa/QED/QCD/Yang-Mills completions. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Theorem). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition EQ_001__P_77_v1_hyp
  (tau_c hbar c m_eff d2psi_dt2 lap_psi psi_val : Q)
  : Prop :=
  m_eff = hbar / (2 * c * c * tau_c) /\
  d2psi_dt2 - c * c * lap_psi + psi_val / (4 * tau_c * tau_c) = 0.
