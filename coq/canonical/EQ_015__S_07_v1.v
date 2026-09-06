(* EQ-015/S.07.v1 — CAN-133 — Definition — parents: EQ-015/M.03.v1 — occurrences 2 *)

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
(** ** CAN-133 — B-SOC-RECOVENV

    (* CAN-133 — root: p*(2):=max_z p*(h,z); L^recoverable=max_z A^corr(h,z)-A^corr(h,z0) — domain: social — tier: Th_coqc — occurrences: 2 *)

    CANONICAL.json tier: "definition". Not itself a Master River eq
    ([in_master_river: null]) — freshly formalised, in the same finite-max
    shape as [MR_Live.p_star]/[live_field_gap]: the layer-2 potential is
    a [fold_right Qmax] over a declared finite list of feasible structural
    conditions [J_feas], and the recoverable-envelope gap is proved
    non-negative whenever the baseline condition [z0] is itself feasible —
    a genuine Th_coqc fact, by the same [Qmax] upper-bound technique
    [MR_Live.p_star_upper_bound] uses. *)

Section CAN_133_RecoverableEnvelope.

  Variables Cond : Type.
  Variable A_corr : Cond -> Q.
  Variable J_feas : list Cond.

  Definition CAN_133_p_star2 (p_of : Cond -> Q) : Q :=
    fold_right Qmax 0 (map p_of J_feas).

  Definition CAN_133_recoverable_gap (z0 : Cond) : Q :=
    (fold_right Qmax 0 (map A_corr J_feas)) - A_corr z0.

  (* Th_coqc: the recoverable gap is non-negative whenever the baseline
     [z0] is itself among the declared feasible conditions — a max over a
     list containing [A_corr z0] cannot fall below [A_corr z0]. *)
  Theorem CAN_133_recoverable_gap_nonneg :
    forall z0 : Cond, In z0 J_feas -> 0 <= CAN_133_recoverable_gap z0.
  Proof.
    intros z0 Hin.
    unfold CAN_133_recoverable_gap.
    assert (Hle : A_corr z0 <= fold_right Qmax 0 (map A_corr J_feas)).
    { revert Hin. induction J_feas as [| c cs IH]; simpl; intros Hin.
      - contradiction.
      - destruct Hin as [-> | Hin'].
        + apply Q.le_max_l.
        + apply Qle_trans with (y := fold_right Qmax 0 (map A_corr cs)).
          * apply IH. exact Hin'.
          * apply Q.le_max_r. }
    apply Qle_minus_iff in Hle.
    (* Qle_minus_iff : x <= y <-> 0 <= y - x, in the shape we need directly. *)
    exact Hle.
  Qed.

End CAN_133_RecoverableEnvelope.

