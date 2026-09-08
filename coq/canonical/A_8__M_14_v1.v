(* A.8/M.14.v1 — CAN-192 — finite_diagnostic — parents: A.8/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-192 — root: historical-invariance (CAN-009) — domain: method —
   tier: finite_diagnostic — occurrences: 1 *)
Definition CAN192_H_g (questions_defended : nat) : Q := (Z.of_nat questions_defended # 10).

