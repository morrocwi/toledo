(* EQ-015/E.12.v1 — CAN-202 — Definition — parents: EQ-015/M.02.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-202 — root: root-stepper (CAN-003) reading — domain: epistemic —
   tier: Definition — occurrences: 2 *)
(** M_A[n] = K_A . theta(E[n]) + eta_sel + eta_map + eta_self: the
    Mission/event-domain reading of the root stepper as a gain on a
    control signal plus three named noise/error terms — a [Q]-valued
    affine formula, with its additive decomposition proved by [ring]. *)
Definition CAN202_M_A (K_A theta_E eta_sel eta_map eta_self : Q) : Q :=
  K_A * theta_E + eta_sel + eta_map + eta_self.

Theorem CAN202_decomposition :
  forall K_A theta_E eta_sel eta_map eta_self : Q,
    CAN202_M_A K_A theta_E eta_sel eta_map eta_self
    = (K_A * theta_E) + eta_sel + eta_map + eta_self.
Proof. intros. unfold CAN202_M_A. reflexivity. Qed.

