(* weld/E.10.v1 — CAN-218 — Dr — parents: weld/M.02.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-218 — root: root-weld (CAN-001) reading — domain: epistemic —
   tier: Dr (named principle) — occurrences: 1 *)
(** Bridge Burden: an inference from source metadata to a change in
    epistemic standing is licit only if a mediating relation is named;
    absent one, it is pedigree substitution — recorded as the exact
    identity the principle asserts (a naming act, not a further claim),
    with one supporting Th_coqc-grade instance. *)
Definition CAN218_pedigree_substitution (has_mediating_relation : Prop) : Prop :=
  ~ has_mediating_relation.

Theorem CAN218_no_relation_is_substitution :
  forall has_mediating_relation : Prop,
    ~ has_mediating_relation -> CAN218_pedigree_substitution has_mediating_relation.
Proof. intros P H. exact H. Qed.

