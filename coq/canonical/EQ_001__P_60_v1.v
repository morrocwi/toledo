(* EQ-001/P.60.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* Unruh-fix: kappa_R = N * a_local (internally normalized readout).
   Exact witness: a_local=7/2, N=4 => kappa_R=14, finite, kappa_R <> a_local. *)
Definition EQ001_P60_kappa_R (N a_local : Q) : Q := N * a_local.

Theorem EQ001_P60_witness :
  EQ001_P60_kappa_R 4 (7 # 2) == 14 /\ ~ (EQ001_P60_kappa_R 4 (7 # 2) == 7 # 2).
Proof. unfold EQ001_P60_kappa_R. split; [lra | intro H; lra]. Qed.
