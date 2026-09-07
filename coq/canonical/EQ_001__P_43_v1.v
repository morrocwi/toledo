(* EQ-001/P.43.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* forced null rescaling: n+' = n+/kappa, n-' = kappa*n-, kappa>0, so
   Qv' = Qv automatically. *)
Theorem EQ001_P43_rescale_invariant :
  forall n_plus n_minus kappa : Q, ~ (kappa == 0) ->
    (n_plus / kappa) * (kappa * n_minus) == n_plus * n_minus.
Proof. intros n_plus n_minus kappa Hk. field. exact Hk. Qed.
