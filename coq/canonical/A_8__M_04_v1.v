(* A.8/M.04.v1 — CAN-173 — finite_diagnostic — parents: A.8/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-173 — root: historical-invariance (CAN-009) — domain: method —
   tier: finite_diagnostic — occurrences: 2 *)
(** The Provenance Relevance Constraint gates each evidence term to {0,1}
    before it is credited; a real inequality follows: the PRC-gated valid
    credit total never exceeds the ungated raw total, given every raw term
    is nonnegative. *)
Section CAN173_CreditGoodhart.
  Variable Evidence : Type.
  Variable weight evidence_val : Evidence -> Q.
  Variable PRC : Evidence -> bool.
  Hypothesis nonneg : forall e, 0 <= weight e * evidence_val e.

  Definition CAN173_valid_term (e : Evidence) : Q :=
    if PRC e then weight e * evidence_val e else 0.
  Definition CAN173_C_valid (l : list Evidence) : Q :=
    fold_right (fun e acc => CAN173_valid_term e + acc) 0 l.
  Definition CAN173_C_raw (l : list Evidence) : Q :=
    fold_right (fun e acc => weight e * evidence_val e + acc) 0 l.

  Lemma CAN173_term_le : forall e, CAN173_valid_term e <= weight e * evidence_val e.
  Proof.
    intro e. unfold CAN173_valid_term. destruct (PRC e).
    - apply Qle_refl.
    - apply nonneg.
  Qed.

  Theorem CAN173_valid_le_raw : forall l, CAN173_C_valid l <= CAN173_C_raw l.
  Proof.
    induction l as [| e rest IH].
    - simpl. apply Qle_refl.
    - unfold CAN173_C_valid, CAN173_C_raw in *. simpl.
      apply Qplus_le_compat.
      + apply CAN173_term_le.
      + apply IH.
  Qed.
End CAN173_CreditGoodhart.

