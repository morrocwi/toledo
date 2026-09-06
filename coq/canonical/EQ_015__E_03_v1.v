(* EQ-015/E.03.v1 — CAN-015 — Definition — parents: EQ-015/M.03.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import EQ_015__E_01_v1.
From MRC Require Import MRC_Prelude.

(* CAN-015 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition — occurrences: 2 *)
(** mu_n = Psi_H(r_n,H_n,c_n,Q_n) — the same object as CAN-013/eq.(2),
    registered separately in CANONICAL.json under its own id (the plain
    "meaning" cluster vs. the "meaning-giving" cluster); restated here as
    a [Notation] to make the identity explicit rather than a second
    independent claim. *)
Notation CAN015_meaning := CAN013_meaning_giving.

