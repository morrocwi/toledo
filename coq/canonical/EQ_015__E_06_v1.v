(* EQ-015/E.06.v1 — CAN-021 — Dr — parents: EQ-015/M.03.v1 — occurrences 5 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-021 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Dr — occurrences: 2 *)
(** State mapping: literally [MR_Resonance.v]'s [Notion] enumeration and
    [eq11_resonance_non_collapse] (eq. 9-11): Res <> Identity, Res <>
    Truth, Res <> Retention, Res <> Improvement — the current (v2)
    definition superseding an earlier accessibility-diagnostic reading, as
    CANONICAL.json's own tier note for this id records. Reused directly. *)
Definition CAN021_ResonanceNotion := Notion.
Definition CAN021_resonance_non_collapse := eq11_resonance_non_collapse.

