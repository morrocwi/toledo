(* EQ-002/E.04.v1 — CAN-016 — Definition — parents: EQ-002/M.03.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-016 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition — occurrences: 1 *)
(** State mapping: literally [MR_Foundation.v]'s [MeaningModes] record and
    its [meaning_modes_decomposition_faithful] lemma, both of which
    persist unchanged past [End Foundation1] (neither depends on a
    discharged Section [Variable]) — reused directly, not restated. *)
Definition CAN016_MeaningModes := MeaningModes.
Definition CAN016_decomposition_faithful := meaning_modes_decomposition_faithful.

