(* EQ-002/E.06.v1 — CAN-024 — Definition — parents: EQ-002/M.03.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-024 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition / Open — occurrences: 1 *)
(** State mapping: literally [MR_Resonance.v]'s eq.(13)-(15) apparatus:
    [momentum] and [Open_eq13] (recent-path momentum easing re-entry,
    Table-2-tagged Open), [accessibility_score]/[disc_gain_nat]/
    [kappa_next] and [Open_eq14] (history-shaped accessibility, Open, with
    the continuum [exp(...)] already replaced by [disc_gain_nat]'s
    discrete rational surrogate), and the eq.(15) Th_coqc non-reducibility
    witnesses (rhythm alone cannot determine accessibility). Reused
    directly, not re-derived. *)
Definition CAN024_momentum := momentum.
Definition CAN024_Open_momentum_eases_reentry := Open_eq13.
Definition CAN024_accessibility_score := accessibility_score.
Definition CAN024_Open_accessibility_predicts := Open_eq14.
Definition CAN024_rhythm_does_not_determine_accessibility :=
  eq15_rhythm_alone_does_not_determine_accessibility.

(* ==================================================================== *)
(** ** Group 3 — the knowledge/epistemic-status core
    (CAN-025..CAN-037, CAN-039, CAN-040): new content, not Master River
    eq. 1-79 (sourced from "Mind as Information Horizon", "Genesis
    Constraint-First Alignment Epistemology", "Knowledge as Stabilized
    Translation", "Written by AI. Still True.", "Readout Genesis
    Standalone Synthesis", "From Problem to Hypothesis", "Before Evidence
    Can Decide", "The Epistemic Chain Reaction" — see
    [registry/family_epistemic-reading.json] for the per-id title). *)

