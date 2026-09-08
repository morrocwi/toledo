(* weld/M.39.v1 -- open_prop -- Causal State History: non-Markovian generalisation axioms and cross-domain theorems *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* H_t is an operational record constructed from past states {X_s}_{s<=t} via a reproducible protocol with fixed tolerance (epsilon, SNR); generalises S_{n+1}=F(S_n,u_n,c_n,T_n) to Psi(t)=F(Psi(t),{Psi(t')}_{t'<=t}) with an explicit semigroup/generator structure, three axioms (order-sensitivity, monotone records, dissipation-with-memory), and three cross-domain theorems (a finite-volume log-Sobolev inequality on lattice histories, a history-aware flux-closure bound for Navier-Stokes, a diamond-norm contraction bound for quantum measurement). *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Definition). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition weld__M_39_v1_hyp
  (Time State : Type) (H : Time -> State) (F : State -> State)
  (order_sensitivity monotone_records dissipation_with_memory : Prop)
  : Prop :=
  order_sensitivity /\ monotone_records /\ dissipation_with_memory /\
  (forall t : Time, exists s : State, H t = s).
