(* weld/H.12.v1 — CAN-113 — Dr — parents: weld/M.01.v1 — occurrences 2 *)

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
(** ** CAN-113 — CTSA-taxonomy

    (* CAN-113 — root: C->T->Workflow->S->A->C'; FrozenBaseline->K_like->Difference->H<->AI->RetentionGate->CTSAReturn->UnaidedReturnTest->GainLoss — domain: human–AI — tier: Dr — occurrences: 2 *)

    CANONICAL.json tier: "proposition". No Master River eq. citation. A
    closed six-stage [Inductive] cycle (C->T->Workflow->S->A->C') with an
    explicit successor map, in the same finite-cycle family as
    [MR_TopicEntry.CycleStage]. *)

Section CAN_113_CTSATaxonomy.

  Inductive CTSAStage : Type :=
    | TSContext | TSTask | TSWorkflow | TSSkill | TSAssessment.

  Definition CAN_113_stage_next (s : CTSAStage) : CTSAStage :=
    match s with
    | TSContext => TSTask
    | TSTask => TSWorkflow
    | TSWorkflow => TSSkill
    | TSSkill => TSAssessment
    | TSAssessment => TSContext
    end.

End CAN_113_CTSATaxonomy.

