(* EQ-015/M.07.v1 — CAN-193 — Definition — parents: EQ-015/M.03.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-193 — root: constitutional-ordering (CAN-004) — domain: method —
   tier: Definition — occurrences: 3 *)
Inductive CAN193_ArchStage :=
  | CAN193_Phenomenon | CAN193_AIExploration | CAN193_DVP | CAN193_HumanMastery
  | CAN193_Integrity | CAN193_K1 | CAN193_GlobalLocalFriction | CAN193_K2
  | CAN193_Revision | CAN193_K3.
Record CAN193_EpistemicPosition := CAN193_mkPosition {
  can193_recognizable_problem : bool;
  can193_repeat_human_nodes : bool;
  can193_citable_assets : bool;
  can193_correction_history : bool
}.
Record CAN193_CrediblePath := CAN193_mkPath {
  can193_early_timestamp : bool;
  can193_explicit_provisionality : bool;
  can193_rapid_revision : bool;
  can193_external_friction : bool;
  can193_eventual_certification : bool
}.

