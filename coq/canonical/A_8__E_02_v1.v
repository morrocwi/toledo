(* A.8/E.02.v1 — CAN-217 — Definition — parents: A.8/M.01.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-217 — root: root-weld (CAN-001) reading — domain: epistemic —
   tier: Th_coqc — occurrences: 1 *)
(** RPE = Cr(p|E,R,A,O1) - Cr(p|E,R,A,O2): a measurable shift in credence
    from provenance alone, holding evidence/reliability/dependence fixed.
    Witnessed: nothing forces this difference to be zero. *)
Definition CAN217_RPE (cr_O1 cr_O2 : Q) : Q := cr_O1 - cr_O2.

Theorem CAN217_RPE_can_be_nonzero :
  exists cr_O1 cr_O2 : Q, CAN217_RPE cr_O1 cr_O2 <> 0.
Proof.
  exists 1, 0. unfold CAN217_RPE. intro H. vm_compute in H. discriminate H.
Qed.

