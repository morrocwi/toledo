(* EQ-001/P.75.v1 -- open_prop -- Effective proton radius as a function of probe causal time *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* r_p^eff(tau_c,l) = r_p^core + Delta_r * sqrt(tau_c,l); numerical prediction of a ~4% electron-vs-muon proton-radius discrepancy matched to the observed muonic-hydrogen puzzle, plus a further falsifiable tau-lepton prediction. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Empirical). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition EQ_001__P_75_v1_hyp
  (r_p_core Delta_r tau_c r_p_eff : Q) (sqrtf : Q -> Q)
  : Prop :=
  r_p_eff = r_p_core + Delta_r * sqrtf tau_c.
