(* EQ-015/S.08.v1 — CAN-134 — Definition — parents: EQ-015/M.03.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-134 — B-SOC-RECOVLIVE

    (* CAN-134 — root: L^live_{A,g}=max_{z in J_feas} D_L(L^z_A(g),L^z0_A(g)) — domain: social — tier: Th_coqc — occurrences: 1 *)

    CANONICAL.json tier: "definition". [in_master_river]: eq.(26), already
    formalised, axiom-free, in [../coq/MR_Live.v]
    ([Section PotentialEnvelope], [live_field_gap]). Discharged here by
    aliasing, plus a fresh Th_coqc non-negativity witness (distance-to-
    self is zero, so the max-gap over a list containing the baseline
    condition is never negative) — the diagnosis-only reading Master
    River's own commentary (NC-79) gives this object. *)

Definition CAN_134_live_field_gap := @MR_Live.live_field_gap.

Section CAN_134_NonNegWitness.

  Variables Cond : Type.
  Variable L_z : Cond -> Q.
  Variable D_L : Q -> Q -> Q.
  Hypothesis D_L_self_zero : forall q : Q, D_L q q == 0.
  Hypothesis D_L_nonneg : forall q1 q2 : Q, 0 <= D_L q1 q2.

  Theorem CAN_134_gap_nonneg :
    forall (z0 : Cond) (feasible_conditions : list Cond),
      0 <= CAN_134_live_field_gap L_z D_L z0 feasible_conditions.
  Proof.
    intros z0 feasible_conditions.
    unfold CAN_134_live_field_gap, MR_Live.live_field_gap.
    induction feasible_conditions as [| c cs IH]; simpl.
    - apply Qle_refl.
    - apply Qle_trans with (y := fold_right Qmax 0 (map (fun z => D_L (L_z z) (L_z z0)) cs)).
      + exact IH.
      + apply Q.le_max_r.
  Qed.

End CAN_134_NonNegWitness.

