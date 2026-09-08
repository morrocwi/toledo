(* A.5/H.19.v1 — CAN-107 — Definition — parents: A.5/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_HCA.
Require Import MR.MR_Retention.
Require Import MR.MR_TopicEntry.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-107 — HCA-worked-scenario

    (* CAN-107 — root: Outcome_C - Outcome_A <> Effect_HCA — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition/proposition". No Master River eq.
    citation. The raw outcome-difference and the (differently-defined)
    causal effect are typed as two declared [Q]-valued readouts; their
    non-identity is discharged as a witnessed instance where a
    confound makes the two diverge. *)

Section CAN_107_HCAWorkedScenario.

  Theorem CAN_107_raw_difference_ne_effect_hca :
    exists (OutcomeC OutcomeA EffectHCA confound : Q),
      OutcomeC - OutcomeA == 2 /\ EffectHCA == 1 /\
      ~ (OutcomeC - OutcomeA == EffectHCA).
  Proof.
    exists 3, 1, 1, 1.
    split; [reflexivity | split; [reflexivity | lra]].
  Qed.

End CAN_107_HCAWorkedScenario.

