(* weld/P.03.v1 -- open_prop -- Yukawa-corrected Newtonian potential for a point source *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* Phi_N(r) = -(G*M/r) * [1 - e^{-r/ell_c}], derived from an informational Poisson relation Laplacian(Phi_I)=kappa_I*s and a Helmholtz coarse-graining filter (1-ell_c^2 Laplacian)s_cg=s0, bounded by laboratory inverse-square-law tests. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Definition). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition weld__P_03_v1_hyp
  (G M r ell_c Phi_N : Q) (exp_neg : Q -> Q)
  : Prop :=
  Phi_N = - (G * M / r) * (1 - exp_neg (r / ell_c)).
