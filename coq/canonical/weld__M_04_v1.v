(* weld/M.04.v1 — CAN-166 — Open — parents: weld/M.03.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-166 — root: reader-equivalence (CAN-007) — domain: method —
   tier: Definition / Open — occurrences: 1 *)
(** The preregistered rival-model ladder M0..M5 any readout-retention
    theory must beat: a finite, closed enumeration (Definition tier); the
    claim that M5 in fact beats every M0..M4 on some declared metric is
    the paper's own falsifiable empirical proposal, recorded as an
    unproved [Prop] scaffold (Open), never proved here. *)
Inductive CAN166_RivalModel :=
  | CAN166_M0_ArousalIntensity
  | CAN166_M1_FamiliarityExposure
  | CAN166_M2_PredictionSurprise
  | CAN166_M3_LanguageCategoryConstruction
  | CAN166_M4_MemorySchemaRetrieval
  | CAN166_M5_ReadoutRetentionModel.

Definition CAN166_must_beat_ladder_Open
  (Metric : Type) (score : CAN166_RivalModel -> Metric) (better : Metric -> Metric -> Prop) : Prop :=
  forall m : CAN166_RivalModel, m <> CAN166_M5_ReadoutRetentionModel ->
    better (score CAN166_M5_ReadoutRetentionModel) (score m).

(* ==================================================================== *)
(** ** Group 2 — problem formation, discovery accessibility, first-passage
    discovery time, and the discriminating-action loop (CAN-167..170) *)

