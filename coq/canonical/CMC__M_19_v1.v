(* CMC/M.19.v1 -- open_prop -- Causal-memory kernel uniqueness / CMF classification (multiple independent proof routes) *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* Any kernel K satisfying causality(P1)+passivity(P2)+finite-order recurrence(H2) is a Completely-Monotone-Finite-resource (CMF) superposition of geometric-decay channels K(n)=sum_k w_k*r_k^n, w_k>=0, 0<r_k<1, certified via Bernstein's theorem/alternating-difference test plus a positive-real (passivity) PSD factorization; the single-exponential-channel special case G(tau)=(D/tau_c)e^{-tau/tau_c} is independently forced by (a) a finite-dimensional local Hamiltonian plus a Lieb-Robinson locality bound, (b) a Laplace-transform + Paley-Wiener causality argument with a Planck-scale lower bound on tau_c, and (c) a direct axiomatic characterization proving the telegraph PDE is the unique linear second-order class member satisfying finite propagation speed, dissipative stability, and source-freedom. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Theorem). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition CMC__M_19_v1_hyp
  (Kernel : Type) (causal passive finite_order_recurrence : Kernel -> Prop)
  (is_CMF : Kernel -> Prop)
  : Prop :=
  forall K : Kernel, causal K -> passive K -> finite_order_recurrence K -> is_CMF K.
