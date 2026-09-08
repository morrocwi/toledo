(* EQ-015/P.119.v1 -- open_prop -- Ringdown diffusivity under causal saturation *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* D_ring = c^2 * tau_220 (imposing c* = c, causal saturation); explicit falsifiable cross-event scaling law D_i/D_j = tau_220,i/tau_220,j, illustrated numerically on GW150914. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Empirical). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition EQ_015__P_119_v1_hyp
  (c D_ring tau_220 D_i D_j tau_i tau_j : Q)
  : Prop :=
  D_ring = c * c * tau_220 /\ D_i / D_j = tau_i / tau_j.
