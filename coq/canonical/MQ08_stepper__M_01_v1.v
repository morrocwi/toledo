(* MQ08-stepper/M.01.v1 -- open_prop -- Discrete causal calculus: primitive causal aggregation operator and its Fundamental Theorem (FTCC) *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* Primitive aggregation operator (not reducible a priori to sum/integral): X_M := M (.) X, (X_M)_j := M_j*X_j, G_M := sigma(X_M); discrete causal derivative on edge e of a causal-delay graph: CC f(e) := (f(head(e))-f(tail(e)))/delay(e); Fundamental Theorem of Causal Calculus (forward, Thm 8.2): sum over a causal path of CC f * delay = f(end)-f(start); converse (Thm 8.3): a discrete field is a causal-gradient iff its path-sums are path-independent; matching product/quotient/chain rules and discrete curl/divergence (electrodynamics-CC, causal Navier-Stokes) identities for CC on the causal-delay graph. *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: Theorem). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

Definition MQ08_stepper__M_01_v1_hyp
  (Edge Node : Type) (head tail : Edge -> Node) (delay : Edge -> Q)
  (f : Node -> Q) (CC : Edge -> Q)
  (sum_CC_delay : Q) (path_start path_end : Node)
  : Prop :=
  (forall e : Edge, CC e = (f (head e) - f (tail e)) / delay e) /\
  (sum_CC_delay = f path_end - f path_start ->
     sum_CC_delay = f path_end - f path_start).
