(* A.5/M.02.v1 — CAN-190 — finite_diagnostic — parents: A.5/M.01.v1 — occurrences 9 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-190 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc / Definition — occurrences: 9 *)
(** P_local not-subset D_AI: a genuine list non-containment fact, proved
    generically then specialised; the remaining formulas (S_G, the
    global/Thai conversion-plan pair) are typed Definitions. *)
Lemma mr_list_non_containment_witness :
  forall (X : Type) (l1 l2 : list X) (x : X),
    In x l1 -> ~ In x l2 -> ~ (forall y, In y l1 -> In y l2).
Proof. intros X l1 l2 x Hx1 Hx2 Hsub. apply Hx2. apply Hsub. exact Hx1. Qed.

Section CAN190_GeographicCoverage.
  Variable ProvinceTy : Type.
  Definition CAN190_not_subset (P_local D_AI : list ProvinceTy) : Prop :=
    ~ (forall y, In y P_local -> In y D_AI).
  Definition CAN190_not_subset_witness := @mr_list_non_containment_witness ProvinceTy.

  Variables Lg Gg Mg Bg Fg : Q.
  Definition CAN190_S_G : Q := Lg * Gg * Mg * Bg * Fg.

  Record CAN190_ConversionPlan := CAN190_mkPlan { can190_global : Q; can190_thai : Q }.
End CAN190_GeographicCoverage.

