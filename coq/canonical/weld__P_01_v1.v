(* weld/P.01.v1 -- open_prop -- Category-theoretic no-go: persistent class bias requires record-cost asymmetry *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* S[F] = sum_i ell(f_i), for F=(f_tau o ... o f_1), ell(id)=0, ell(g o f)=ell(g)+ell(f); No-Go Theorem: a persistent class bias (e.g. matter/antimatter-style asymmetry) requires an asymmetry in record-formation cost, via a Gibbs-measure path-selection argument and a large-beta concentration theorem. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Theorem). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition weld__P_01_v1_hyp
  (Class : Type) (record_cost : Class -> Q)
  (persistent_class_bias record_cost_asymmetry : Prop)
  : Prop :=
  persistent_class_bias -> record_cost_asymmetry.
