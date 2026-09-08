(* EQ-015/M.08.v1 — CAN-198 — Definition — parents: EQ-015/M.02.v1 — occurrences 5 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-198 — root: root-stepper (CAN-003) — domain: method —
   tier: Definition / Open — occurrences: 5 *)
(** State mapping: this id's canonical text is exactly [MR_Resonance.v]
    eq.(13)-(15) (momentum, the discretised accessibility score, and the
    "Rhythm alone does not determine accessibility" correction), reused
    directly by alias — the same Master River content CAN-024 already
    aliases in the independent [MRC_epistemic_reading.v] family; both
    reuses are legitimate readings of the one source, not a
    re-derivation. [momentum]/[accessibility_score] retain Open tier from
    [MR_Resonance.v]'s own tiering; the non-reducibility theorems are
    Th_coqc. *)
Definition CAN198_momentum := @momentum.
Definition CAN198_Open_momentum := @Open_eq13.
Definition CAN198_accessibility_score := @accessibility_score.
Definition CAN198_Open_accessibility := @Open_eq14.
Definition CAN198_rhythm_does_not_determine_accessibility :=
  @eq15_rhythm_alone_does_not_determine_accessibility.
Definition CAN198_kappa_genuinely_varies := @eq15_kappa_next_genuinely_varies.

