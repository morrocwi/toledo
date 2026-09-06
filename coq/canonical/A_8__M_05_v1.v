(* A.8/M.05.v1 — CAN-175 — finite_diagnostic — parents: A.8/M.01.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-175 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 3 *)
Section CAN175_K2Procurement.
  Variables Cash lamH H lamL L D R I eps175 : Q.
  Definition CAN175_cost_k2 : Q := (Cash + lamH * H + lamL * L) / (D * R * I + eps175).

  Variables PReview Depth Fit Prep Latency : Q.
  Definition CAN175_expected_yield : Q := (PReview * Depth * Fit) / (Cash + Prep + Latency + eps175).

  Variables DepthE RelE IndepE : Q.
  Definition CAN175_effective_k2 : Q := DepthE * RelE * IndepE.
End CAN175_K2Procurement.

