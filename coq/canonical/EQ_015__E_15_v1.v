(* EQ-015/E.15.v1 — CAN-228 — Dr — parents: EQ-015/M.02.v1 — occurrences 9 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-228 — root: reader-equivalence (CAN-007) reading — domain:
   epistemic — tier: Th_coqc (identity, non-collapse) / Open
   (Dr-qualified companions) — occurrences: 1 *)
(** From Problem to Hypothesis's non-collapse family: Attraction <>
    Momentum <> Accessibility <> Warrant <> Truth <> Reachability;
    M_A[n] <> theta(E[n]). Witnessed on a representative 8-notion sample.
    eq.(30)-(32)'s Dr-qualified companions are not proved here (Dr, not
    Th_coqc, per CANONICAL.json's own tier note). *)
Inductive CAN228_Notion :=
  | CAN228_Attraction | CAN228_Momentum | CAN228_Accessibility | CAN228_Warrant
  | CAN228_Truth | CAN228_Reachability | CAN228_RealizedReadout | CAN228_ControlSignal.

Definition CAN228_code (n : CAN228_Notion) : nat :=
  match n with
  | CAN228_Attraction => 0 | CAN228_Momentum => 1 | CAN228_Accessibility => 2
  | CAN228_Warrant => 3 | CAN228_Truth => 4 | CAN228_Reachability => 5
  | CAN228_RealizedReadout => 6 | CAN228_ControlSignal => 7
  end.

Theorem CAN228_non_collapse : notions_pairwise_distinct CAN228_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

