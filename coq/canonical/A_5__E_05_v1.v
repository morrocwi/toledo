(* A.5/E.05.v1 — CAN-224 — Dr — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-224 — root: root-readout-gate (CAN-201) reading — domain:
   epistemic — tier: Dr — occurrences: 1 *)
(** Representationality <> Selectivity, witnessed via the shared
    enumeration device. *)
Inductive CAN224_Notion := CAN224_Representationality | CAN224_Selectivity.
Definition CAN224_code (n : CAN224_Notion) : nat :=
  match n with CAN224_Representationality => 0 | CAN224_Selectivity => 1 end.
Theorem CAN224_non_collapse : notions_pairwise_distinct CAN224_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

(* ==================================================================== *)
(** ** Group 6 — the family's own non-collapse bundles
    (CAN-225..CAN-229). *)

