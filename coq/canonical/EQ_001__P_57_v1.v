(* EQ-001/P.57.v1 -- Toledo v1.1 lane B2 -- finite_diagnostic *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* redshift as relative retained-step rate: dtheta_i = N dtheta_o and
   N<>0 imply dtheta_o = dtheta_i / N. *)
Theorem EQ001_P57_inverse_rate :
  forall N dtheta_i dtheta_o : Q, ~ (N == 0) ->
    dtheta_i == N * dtheta_o -> dtheta_o == dtheta_i / N.
Proof. intros N di do' HN Heq. rewrite Heq. field. exact HN. Qed.
