(* EQ-015/S.34.v1 — Definition — parents: EQ-015/M.03.v1, EQ-015/S.04.v1 *)
(* carries the JOINT 17-item non-collapse proof for all of EQ-015/S.34.v1..EQ-015/S.50.v1 (a single 17-constructor Inductive type with an injective nat index, proved once) -- see this bundle's own header for the source's stated reason ('the same MRC_root_spine.v CAN_004_Stage pattern, scaled up: injectivity of the index is the single witnessed fact'). *)

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
