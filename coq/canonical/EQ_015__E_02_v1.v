(* EQ-015/E.02.v1 — CAN-014 — Definition — parents: EQ-015/M.03.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-014 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Th_coqc — occurrences: 1 *)
(** Approach/aversion/blindness distort the meaning operator
    (G~_{mu,n} = G_{mu,n} o (I+Xi_n)) without raising epistemic status.
    Formalised as an additive perturbation on the affective/pragmatic/
    autonoetic/conceptual modes that leaves [m_epi] untouched by
    construction: distortion is (1) a genuine possible change, and (2)
    definitionally epistemic-status-preserving. *)
Definition CAN014_distort (xi_aff xi_prag xi_auto xi_conc : Q) (m : MeaningModes) : MeaningModes :=
  mkMeaning (m_aff m + xi_aff) (m_prag m + xi_prag) (m_auto m + xi_auto) (m_conc m + xi_conc) (m_epi m).

Theorem CAN014_distortion_can_change_meaning :
  exists (xi_aff xi_prag xi_auto xi_conc : Q) (m : MeaningModes),
    m_aff (CAN014_distort xi_aff xi_prag xi_auto xi_conc m) <> m_aff m.
Proof.
  exists 1, 0, 0, 0, (mkMeaning 0 0 0 0 0).
  unfold CAN014_distort; simpl.
  intro H. vm_compute in H. discriminate H.
Qed.

Theorem CAN014_distortion_preserves_epistemic_mode :
  forall xi_aff xi_prag xi_auto xi_conc m,
    m_epi (CAN014_distort xi_aff xi_prag xi_auto xi_conc m) = m_epi m.
Proof. intros. reflexivity. Qed.

