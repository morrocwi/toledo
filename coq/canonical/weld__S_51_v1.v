(* weld/S.51.v1 -- open_prop -- Causal-access-constrained learning: mask-weighted shrinkage theorem *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* A(t) := R_avail(t) / C_task(t); per-feature causal-access mask X_M, causal-access-constrained risk R_CA, mask-weighted normal equations Sigma_M*theta=gamma_M; Monotone Shrinkage Theorem: theta*(p)->0 as access probability p->0, for spuriously-correlated features. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Theorem). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition weld__S_51_v1_hyp
  (theta_star : Q -> Q)
  : Prop :=
  forall eps : Q, eps > 0 ->
    exists p0 : Q, forall p : Q, 0 < p -> p < p0 -> Qabs (theta_star p) < eps.
