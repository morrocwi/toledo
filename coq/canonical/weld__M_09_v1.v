(* weld/M.09.v1 — CAN-174 — finite_diagnostic — parents: weld/M.03.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-174 — root: reader-equivalence (CAN-007) — domain: method —
   tier: finite_diagnostic — occurrences: 1 *)
(** ClaimStrength <= EvidenceStrength: a bare order relation over [Q]; the
    reflexive instance (claim strength exactly at its own evidence
    ceiling) is offered as Th_coqc-grade scaffolding confirming the
    Definition is not vacuous, not a re-tagging of the invariant itself. *)
Definition CAN174_invariant (claim_strength evidence_strength : Q) : Prop :=
  claim_strength <= evidence_strength.

Theorem CAN174_invariant_refl : forall e : Q, CAN174_invariant e e.
Proof. intro e. unfold CAN174_invariant. apply Qle_refl. Qed.

(* ==================================================================== *)
(** ** Group 4 — K2 procurement heuristics, the theorizing pipeline, and
    scholarly-capital bookkeeping (CAN-175, CAN-177, CAN-178) *)

