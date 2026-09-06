(* EQ-002/H.03.v1 — CAN-098 — Definition — parents: EQ-002/M.03.v1 — occurrences 2 *)

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
(** ** CAN-098 — HCA-native-river

    (* CAN-098 — root: RetainedDifference->HumanReadout->LiveProblem->BarrierReadout->CandidateRoutes->HumanEndorsement->AdaptiveScaffold->Practice->Withdrawal->HumanReturn->NovelTransfer->WorldFeedback->OpportunityConversion — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". Direct reuse of [MR_HCA.v]
    eq.(67): the thirteen-stage [hca_river_67] composition. *)

Definition CAN_098_hca_native_river := MR_HCA.hca_river_67.

