(* A.5/E.06.v1 — CAN-225 — Open — parents: A.5/M.01.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-225 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Th_coqc (non-collapse bundle) / Open (H6 companion) —
   occurrences: 1 *)
(** Section 8/11's own family: Exposure <> FeltIntensity <> Retention <>
    Improvement; ExternalPattern <> Meaning <> ExplicitNaming;
    SharedStimulus <> SharedInnerState. Witnessed via the shared
    enumeration device on a representative 9-notion sample. The bundled
    companion H6 ("No automatic improvement") is explicitly [Open] per
    CANONICAL.json — recorded separately as an unproved [Prop] scaffold,
    not folded into this non-collapse witness. *)
Inductive CAN225_Notion :=
  | CAN225_Exposure | CAN225_FeltIntensity | CAN225_Retention | CAN225_Improvement
  | CAN225_ExternalPattern | CAN225_Meaning | CAN225_ExplicitNaming
  | CAN225_SharedStimulus | CAN225_SharedInnerState.

Definition CAN225_code (n : CAN225_Notion) : nat :=
  match n with
  | CAN225_Exposure => 0 | CAN225_FeltIntensity => 1 | CAN225_Retention => 2
  | CAN225_Improvement => 3 | CAN225_ExternalPattern => 4 | CAN225_Meaning => 5
  | CAN225_ExplicitNaming => 6 | CAN225_SharedStimulus => 7 | CAN225_SharedInnerState => 8
  end.

Theorem CAN225_non_collapse : notions_pairwise_distinct CAN225_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

Definition CAN225_H6_no_automatic_improvement_Open
  (Subject : Type) (Exposure Improves : Subject -> Prop) : Prop :=
  forall s : Subject, Exposure s -> Improves s.

