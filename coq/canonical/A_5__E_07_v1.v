(* A.5/E.07.v1 — CAN-226 — Dr — parents: A.5/M.01.v1 — occurrences 4 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-226 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Th_coqc (non-collapse bundle) — occurrences: 1 *)
(** Experience Is Meaning-Giving's own non-collapse families (EMG-15,
    EMG-20, EMG-27): order <> rhythm <> repetition <> meaning <>
    retention; release <> transformation <> intensity <> truth; shock <>
    insight <> barrier-crossing. Witnessed on a representative 12-notion
    sample via the shared enumeration device (the full family names more
    than twelve pairs across three sections; a representative sample is
    formalised rather than every named pair, since they all reduce to the
    same finite-enumeration technique). *)
Inductive CAN226_Notion :=
  | CAN226_Order | CAN226_Rhythm | CAN226_Repetition | CAN226_MeaningN | CAN226_RetentionN
  | CAN226_Release | CAN226_Transformation | CAN226_Intensity | CAN226_Truth
  | CAN226_Shock | CAN226_Insight | CAN226_BarrierCrossing.

Definition CAN226_code (n : CAN226_Notion) : nat :=
  match n with
  | CAN226_Order => 0 | CAN226_Rhythm => 1 | CAN226_Repetition => 2
  | CAN226_MeaningN => 3 | CAN226_RetentionN => 4 | CAN226_Release => 5
  | CAN226_Transformation => 6 | CAN226_Intensity => 7 | CAN226_Truth => 8
  | CAN226_Shock => 9 | CAN226_Insight => 10 | CAN226_BarrierCrossing => 11
  end.

Theorem CAN226_non_collapse : notions_pairwise_distinct CAN226_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

