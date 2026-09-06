(* EQ-015/S.04.v1 — CAN-129 — Definition — parents: EQ-015/M.03.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-129 — B-SOC-NCLIST

    (* CAN-129 — root: 17-item non-collapse role-separation list — domain: social — tier: Th_coqc — occurrences: 3 *)

    CANONICAL.json tier: "definition". The fullest, most general
    non-collapse statement in this group's corpus, restated as a
    17-constructor [Inductive] with an injective [nat] index — the same
    [MRC_root_spine.v] [CAN_004_Stage]/[CAN_004_index] pattern, scaled up:
    injectivity of the index is the single witnessed fact that makes "17
    named things, none collapsing into another" a checked claim rather
    than an assertion. *)

Inductive CAN_129_NCItem : Type :=
  | NC_ObjPossVsFeas | NC_FeasVsLive | NC_LiveVsStatedPref
  | NC_StatedPrefVsFreeConsent | NC_ChoiceVsEnactment | NC_EnactmentVsEvalVisible
  | NC_OptionCountVsEffectiveAgency | NC_AccessibilityVsWarrant
  | NC_ResonanceVsConsent | NC_RepetitionVsLegitimacy | NC_RetentionVsImprovement
  | NC_NormConformityVsAbsenceOfAgency | NC_ResistanceVsAgency
  | NC_MeaningShapingVsDomination | NC_LiveNarrowingVsStructuralViolence
  | NC_AIInfluenceVsManipulation | NC_CoupledPerformanceVsHumanReturn.

Definition CAN_129_index (i : CAN_129_NCItem) : nat :=
  match i with
  | NC_ObjPossVsFeas => 0 | NC_FeasVsLive => 1 | NC_LiveVsStatedPref => 2
  | NC_StatedPrefVsFreeConsent => 3 | NC_ChoiceVsEnactment => 4
  | NC_EnactmentVsEvalVisible => 5 | NC_OptionCountVsEffectiveAgency => 6
  | NC_AccessibilityVsWarrant => 7 | NC_ResonanceVsConsent => 8
  | NC_RepetitionVsLegitimacy => 9 | NC_RetentionVsImprovement => 10
  | NC_NormConformityVsAbsenceOfAgency => 11 | NC_ResistanceVsAgency => 12
  | NC_MeaningShapingVsDomination => 13 | NC_LiveNarrowingVsStructuralViolence => 14
  | NC_AIInfluenceVsManipulation => 15 | NC_CoupledPerformanceVsHumanReturn => 16
  end.

Theorem CAN_129_index_injective :
  forall i1 i2 : CAN_129_NCItem, CAN_129_index i1 = CAN_129_index i2 -> i1 = i2.
Proof. intros [] []; simpl; try reflexivity; try discriminate. Qed.

