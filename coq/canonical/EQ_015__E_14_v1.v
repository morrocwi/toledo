(* EQ-015/E.14.v1 — CAN-219 — Dr — parents: EQ-015/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-219 — root: root-weld (CAN-001) reading — domain: epistemic —
   tier: Th_coqc — occurrences: 1 *)
(** No Bare Pedigree: a source label alone is epistemically incomplete
    reporting; the relevant object is the tuple of production procedure,
    selection conditions, dependencies, checks, error model, inferential
    role, and answerability. Witnessed: two full source reports can share
    the same bare label while differing on procedure — the label alone
    underdetermines the report. *)
Record CAN219_SourceReport : Type := mkCAN219Report
  { c219_label : nat
  ; c219_procedure : nat
  ; c219_selection : nat
  ; c219_dependencies : nat
  ; c219_checks : nat
  ; c219_error_model : nat
  ; c219_role : nat
  ; c219_answerability : nat
  }.

Theorem CAN219_label_underdetermines_report :
  exists r1 r2 : CAN219_SourceReport,
    c219_label r1 = c219_label r2 /\ c219_procedure r1 <> c219_procedure r2.
Proof.
  exists (mkCAN219Report 0 0 0 0 0 0 0 0), (mkCAN219Report 0 1 0 0 0 0 0 0).
  split; [reflexivity | discriminate].
Qed.

