(* EQ-002/E.12.v1 — CAN-221 — Dr — parents: EQ-002/M.03.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-221 — root: root-weld (CAN-001) reading — domain: epistemic —
   tier: Th_coqc — occurrences: 1 *)
(** Friction, not magic: institutional certification earns epistemic
    force through reliable friction (criticism, validation, replication,
    robustness testing, archival continuity, correction, answerability),
    not from certification-status alone. A 7-flag friction record with
    [Force] defined as "at least one friction mechanism present";
    witnessed non-collapse: a certified label can hold while every
    friction flag is false. *)
Record CAN221_Friction : Type := mkCAN221Friction
  { c221_criticism : bool
  ; c221_validation : bool
  ; c221_replication : bool
  ; c221_robustness : bool
  ; c221_archival : bool
  ; c221_correction : bool
  ; c221_answerability : bool
  }.

Definition CAN221_all_false : CAN221_Friction :=
  mkCAN221Friction false false false false false false false.

Definition CAN221_has_force (f : CAN221_Friction) : bool :=
  c221_criticism f || c221_validation f || c221_replication f || c221_robustness f
  || c221_archival f || c221_correction f || c221_answerability f.

Theorem CAN221_certified_without_force :
  forall (Certified : bool),
    Certified = true -> CAN221_has_force CAN221_all_false = false.
Proof. intros. reflexivity. Qed.

