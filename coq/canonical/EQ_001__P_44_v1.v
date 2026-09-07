(* EQ-001/P.44.v1 -- Toledo v1.1 lane B2 -- untagged *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* Gamma_R from kappa and relative velocity. Exact witness:
   v=5/4, u=3/4 -> beta=3/5, kappa=2, Gamma_R=5/4. *)
Definition EQ001_P44_beta (u v : Q) : Q := u / v.
Definition EQ001_P44_kappa_sq (beta : Q) : Q := (1 + beta) / (1 - beta).
Definition EQ001_P44_Gamma_R (kappa : Q) : Q := (kappa + 1 / kappa) / 2.

Theorem EQ001_P44_witness :
  EQ001_P44_beta (3 # 4) (5 # 4) == 3 # 5 /\
  EQ001_P44_kappa_sq (3 # 5) == 4 /\
  EQ001_P44_Gamma_R 2 == 5 # 4.
Proof.
  split. unfold EQ001_P44_beta. field.
  split. unfold EQ001_P44_kappa_sq. field.
  unfold EQ001_P44_Gamma_R. field.
Qed.
