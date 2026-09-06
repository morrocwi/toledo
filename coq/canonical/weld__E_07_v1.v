(* weld/E.07.v1 — CAN-035 — Dr — parents: weld/M.03.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-035 — root: constitutional-noncollapse (CAN-008) reading — domain:
   epistemic — tier: Th_coqc — occurrences: 1 *)
(** tau_public(p) <= inf_{g in G_p} tau(g) (Weakest-link claim ceiling,
    proved): a finite [Qmin] fold over a claim's gate tiers, proved to be
    a genuine lower bound of every member (never an unbounded infimum) —
    the same finite-max/finite-min-fold technique as [MR_Live.v]'s
    [p_star]/[p_star_upper_bound], dualised to [Qmin]/[<=]. *)
Definition CAN035_claim_ceiling (gate_tiers : list Q) (default : Q) : Q :=
  fold_right Qmin default gate_tiers.

Theorem CAN035_claim_ceiling_bound :
  forall (gate_tiers : list Q) (default : Q) (tau : Q),
    In tau gate_tiers -> CAN035_claim_ceiling gate_tiers default <= tau.
Proof.
  intro gate_tiers.
  induction gate_tiers as [| g rest IH]; intros default tau Hin.
  - simpl in Hin. contradiction.
  - simpl in Hin. destruct Hin as [Heq | Hin'].
    + subst. unfold CAN035_claim_ceiling. simpl. apply Q.le_min_l.
    + unfold CAN035_claim_ceiling. simpl.
      apply Qle_trans with (y := fold_right Qmin default rest).
      * apply Q.le_min_r.
      * apply IH. exact Hin'.
Qed.

