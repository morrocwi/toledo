(* EQ-015/E.09.v1 — CAN-027 — Definition — parents: EQ-015/M.03.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-027 — root: reader-equivalence (CAN-007) reading — domain:
   epistemic — tier: Definition / Open — occurrences: 1 *)
(** V_A[n] = Align(M_A[n], theta_W | D): domain-indexed alignment, typed;
    E[V_A[n+1] | Rsn_A, D] > E[V_A[n] | D] is an empirical claim about a
    real reasoning process this finite model cannot certify without
    assuming it — recorded as an unproved [Prop] scaffold (Open). *)
Section CAN027_AlignmentReadout.
  Variables Realized Target Domain : Type.
  Variable Align : Realized -> Target -> Domain -> Q.
  Definition CAN027_V_A (m : Realized) (theta : Target) (d : Domain) : Q := Align m theta d.
End CAN027_AlignmentReadout.

Definition CAN027_expected_improvement_Open (Expect : nat -> Q) : Prop :=
  forall n : nat, Expect (S n) > Expect n.

