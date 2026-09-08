(* EQ-001/P.71.v1 -- open_prop -- Black-hole singularity regularization under causal memory *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* tau*d^2(phi)/dt^2 + d(phi)/dt = D*Laplacian(phi); finite core radius r_min ~ (G*M*tau^2)^(1/3) replaces the point singularity, a finite maximum core density, and matching quasi-normal-mode-frequency/echo-delay predictions. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Postulate). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition EQ_001__P_71_v1_hyp
  (tau D G M r_min : Q) (phi : Q -> Q) (pde_holds : Prop)
  : Prop :=
  pde_holds /\ r_min > 0.
