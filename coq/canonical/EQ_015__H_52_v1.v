(* EQ-015/H.52.v1 -- open_prop -- SOMA-READ causal readout chain S(t)->R(t)->{E(t),P(t)}->A(t) for somatic agency *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* Causal chain: S(t) [unknown-endpoint x reduced-agency contract] -> R(t) [recoverability readout] -> {E(t),P(t)} [endpoint observability, defensive policy] -> A(t) [action/policy transition]; preregistered human protocol, FROZEN draft pre-ethics. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Empirical). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition EQ_015__H_52_v1_hyp
  (Time State : Type) (S R E P A : Time -> State)
  (causal_link : State -> State -> Prop)
  : Prop :=
  forall t : Time, causal_link (S t) (R t) /\
                   (causal_link (R t) (E t) /\ causal_link (R t) (P t)).
