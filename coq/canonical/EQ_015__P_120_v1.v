(* EQ-015/P.120.v1 -- open_prop -- Observer-dependent (redshifted) causal-memory time *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* tau_c^(distant)(r) = sqrt(1 - R_s/r) * tau_c^(proper). *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Definition). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition EQ_015__P_120_v1_hyp
  (R_s r tau_c_proper tau_c_distant : Q) (sqrtf : Q -> Q)
  : Prop :=
  tau_c_distant = sqrtf (1 - R_s / r) * tau_c_proper.
