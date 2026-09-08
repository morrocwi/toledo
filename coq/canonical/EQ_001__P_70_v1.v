(* EQ-001/P.70.v1 -- open_prop -- Causal accessibility horizon / early-warning control necessity *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* Continuum: t_d <= T - d_theta(Gamma,O); Network: t_d <= T - min_{g,o} d_G(g,o); Budget: T_avail = T - t_d - dt_proc - dt_verify - dt_deploy >= 0. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Theorem). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition EQ_001__P_70_v1_hyp
  (t_d T d_theta dt_proc dt_verify dt_deploy T_avail : Q)
  : Prop :=
  t_d <= T - d_theta /\
  T_avail = T - t_d - dt_proc - dt_verify - dt_deploy /\ T_avail >= 0.
