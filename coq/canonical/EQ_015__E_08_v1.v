(* EQ-015/E.08.v1 — CAN-023 — Definition — parents: EQ-015/M.03.v1 — occurrences 13 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-023 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Th_coqc — occurrences: 2 *)
(** State mapping: literally [MR_Foundation.v]'s
    [eq8_retention_can_change_the_reader] (eq. 8): only a selected residue
    of a readout updates the retained state, and that update genuinely can
    (not must) change the reader — witnessed on the smallest finite state
    space ([bool] via [negb]). Reused directly. *)
Definition CAN023_retention_can_change_reader := eq8_retention_can_change_the_reader.

