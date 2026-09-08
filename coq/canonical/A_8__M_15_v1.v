(* A.8/M.15.v1 — CAN-194 — finite_diagnostic — parents: A.8/M.01.v1 — occurrences 5 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-194 — root: historical-invariance (CAN-009) — domain: method —
   tier: finite_diagnostic / Th_coqc — occurrences: 5 *)
(** B_year, instantiating shared device 2 ([mr_qsum]): a genuine bound
    (each nonnegative budget line is at most the total) follows directly
    from [mr_qsum_ge_member]. *)
Section CAN194_FeasibilityBudget.
  Variables B_conf B_ethics B_soft B_data B_pub B_travel : Q.
  Definition CAN194_B_year : list Q := [B_conf; B_ethics; B_soft; B_data; B_pub; B_travel].
  Definition CAN194_B_year_total : Q := mr_qsum CAN194_B_year.

  Theorem CAN194_component_le_total :
    (forall y, In y CAN194_B_year -> 0 <= y) ->
    In B_conf CAN194_B_year -> B_conf <= CAN194_B_year_total.
  Proof. intros. unfold CAN194_B_year_total. apply mr_qsum_ge_member; assumption. Qed.

  Variables H_planned H_sustainable : Q.
  Definition CAN194_portfolio_shrink : Prop := H_sustainable < H_planned.

  Variable PublicWIP : nat.
  Definition CAN194_wip_bound : Prop := (PublicWIP <= 3)%nat.

  Variables I_i N_i E_i F_i Y_i S_i D_i C_i Frag_i COI_i eps194 : Q.
  Definition CAN194_priority : Q :=
    (I_i * N_i * E_i * F_i * Y_i * S_i) / (D_i + C_i + Frag_i + COI_i + eps194).
End CAN194_FeasibilityBudget.

(* ==================================================================== *)
(** ** Group 10 — discovery-justification separation, evidence-registry
    non-collapse, knowledge-topology sensitivity, rhythm/momentum
    accessibility, mind-body coupling, and the DCP burden vector
    (CAN-195..200) *)

