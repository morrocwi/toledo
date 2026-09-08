(* EQ-015/M.05.v1 — CAN-182 — finite_diagnostic — parents: EQ-015/M.02.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-182 — root: root-stepper (CAN-003) — domain: method —
   tier: finite_diagnostic — occurrences: 3 *)
Inductive CAN182_Outcome := CAN182_Resolve | CAN182_Declare.
Definition CAN182_decision (Disagreement HumanAvailable : bool) : CAN182_Outcome :=
  if Disagreement then (if HumanAvailable then CAN182_Resolve else CAN182_Declare) else CAN182_Resolve.

