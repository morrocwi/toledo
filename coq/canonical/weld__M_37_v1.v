(* weld/M.37.v1 -- open_prop -- IPR-based structural-localization fingerprint and quantile boundary-regime closure rule for graph-Laplacian diagnostics *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* IPR(mode_k) = sum_i |v_ki|^4 / (sum_i |v_ki|^2)^2; Delta := IPR(most-localized mode)/mean(IPR); Boundary-Regime Closure: system flagged 'bounded' iff Delta exceeds a quantile-derived tail threshold over an ensemble. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Definition). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition weld__M_37_v1_hyp
  (IPR mean_IPR threshold Delta : Q) (bounded : Prop)
  : Prop :=
  Delta = IPR / mean_IPR /\ (Delta > threshold <-> bounded).
