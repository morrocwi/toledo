(* Face.10.IdentifiabilityGate/E.01.v1 -- Toledo v1.1 lane B2 -- Definition *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* Forced-Identification Fraction: Phi_FI = 1 - V*(C pi) / V*(C) *)
Definition Face10_E01_PhiFI (VstarCpi VstarC : Q) : Q := 1 - VstarCpi / VstarC.

Theorem Face10_E01_zero_when_equal :
  forall VstarC : Q, ~ (VstarC == 0) -> Face10_E01_PhiFI VstarC VstarC == 0.
Proof. intros VstarC H. unfold Face10_E01_PhiFI. field. exact H. Qed.
