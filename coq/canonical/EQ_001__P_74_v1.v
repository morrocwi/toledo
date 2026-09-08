(* EQ-001/P.74.v1 -- open_prop -- The covariant damped-stiff field equation (telegraph + stiffness term) *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* Box(Phi) + 2*lambda*(u^mu grad_mu Phi) + Omega^2*Phi = 0; reduces to ordinary Cattaneo-telegraph dynamics when Omega=0; yields a mass-hierarchy relation and a MOND-like acceleration scale a0 ~= c*H0. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Postulate). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition EQ_001__P_74_v1_hyp
  (BoxPhi lambda u_grad_Phi Omega Phi a0 c H0 : Q)
  : Prop :=
  BoxPhi + 2 * lambda * u_grad_Phi + Omega * Omega * Phi = 0 /\ a0 = c * H0.
