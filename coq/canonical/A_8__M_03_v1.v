(* A.8/M.03.v1 — CAN-172 — Definition — parents: A.8/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-172 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 1 *)
Inductive CAN172_Status :=
  | CAN172_Source | CAN172_AISynthesis | CAN172_HumanInference
  | CAN172_Candidate | CAN172_Decision.

