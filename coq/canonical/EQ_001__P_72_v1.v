(* EQ-001/P.72.v1 -- open_prop -- Cosmological constant as inverse cosmic causal time *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* Lambda ~ 1/tau_cosmic^2; tau_cosmic ~ H0^-1 ~ 1e17 s; vacuum-energy-density estimate rho_Lambda ~ hbar*c/(tau_cosmic^2*ell_P^3) ~ 1e-47 GeV^4; predicted dark-energy equation-of-state deviation w(z)=-1+epsilon(z). *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Empirical). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition EQ_001__P_72_v1_hyp
  (Lambda tau_cosmic H0 rho_Lambda hbar c ell_P : Q)
  : Prop :=
  tau_cosmic = 1 / H0 /\ Lambda = 1 / (tau_cosmic * tau_cosmic) /\
  rho_Lambda = (hbar * c) / (tau_cosmic * tau_cosmic * ell_P * ell_P * ell_P).
