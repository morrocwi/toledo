(* A.8/M.16.v1 — CAN-195 — finite_diagnostic — parents: A.8/M.01.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-195 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 3 *)
Section CAN195_DiscoveryJustification.
  Variables ClaimScope SamplingScope : Q.
  Definition CAN195_scope_constraint : Prop := ClaimScope <= SamplingScope.
End CAN195_DiscoveryJustification.
Inductive CAN195_Pipeline := CAN195_PracticeObservation | CAN195_Hypothesis.

