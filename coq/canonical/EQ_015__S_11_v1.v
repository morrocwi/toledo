(* EQ-015/S.11.v1 — CAN-137 — Definition — parents: EQ-015/M.03.v1 — occurrences 7 *)

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
(** ** CAN-137 — B-SOC-SEVENDIST

    (* CAN-137 — root: D1..D7 seven distinctions anatomy of "potential" — domain: social — tier: Th_coqc — occurrences: 7 *)

    CANONICAL.json tier: "definition". Seven non-collapsing pairs
    dissecting the single word "potential" — the formal justification
    underlying B-SOC-POTENTIAL/B-SOC-RECOVENV/B-SOC-RECOVLIVE above —
    restated, exactly as CAN-129, as a 7-constructor [Inductive] with an
    injective [nat] index. *)

Inductive CAN_137_Distinction : Type :=
  | D1_PotentialVsExercisedVsObserved | D2_DeclaredVsWitnessedSet
  | D3_Layer1VsLayer2 | D4_TaskVsAggregatePotential
  | D5_FeasibleVsPermitted | D6_DiagnosisVsAttribution
  | D7_RecoverableGapVsAccumulatedLoss.

Definition CAN_137_index (d : CAN_137_Distinction) : nat :=
  match d with
  | D1_PotentialVsExercisedVsObserved => 0 | D2_DeclaredVsWitnessedSet => 1
  | D3_Layer1VsLayer2 => 2 | D4_TaskVsAggregatePotential => 3
  | D5_FeasibleVsPermitted => 4 | D6_DiagnosisVsAttribution => 5
  | D7_RecoverableGapVsAccumulatedLoss => 6
  end.

Theorem CAN_137_index_injective :
  forall d1 d2 : CAN_137_Distinction, CAN_137_index d1 = CAN_137_index d2 -> d1 = d2.
Proof. intros [] []; simpl; try reflexivity; try discriminate. Qed.

