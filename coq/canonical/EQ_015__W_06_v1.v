(* EQ-015/W.06.v1 — CAN-145 — Definition — parents: EQ-015/M.01.v1 — occurrences 5 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-145 — demand-realization

    (* CAN-145 — root: AD_t=C+I+G+NX; chi^dem=min{1,AD/Y}; Pi^M=chi^dem Y - Cost^M — domain: world-system — tier: Th_coqc — occurrences: 5 *)

    CANONICAL.json tier: "definition/identity". No Master River eq.
    citation (After Labour eq.(22)-(25),(55), record 22481924) — freshly
    formalised. [chi^dem]'s realization-rate clamp is [Qmin 1 (AD/Y)],
    the identical finite [Qmin] idiom [MR_WorldSystem.v] already uses for
    Cobb-Douglas-style clamps; its "never above full realization" bound is
    a genuine, if small, Th_coqc fact rather than an unmotivated
    Definition. *)

Section CAN_145_DemandRealization.

  Definition CAN_145_AD (C_t I_t G_t NX_t : Q) : Q := C_t + I_t + G_t + NX_t.

  Definition CAN_145_chi_dem (AD_t Y_t : Q) : Q := Qmin 1 (AD_t / Y_t).

  Theorem CAN_145_chi_dem_le_one :
    forall AD_t Y_t : Q, CAN_145_chi_dem AD_t Y_t <= 1.
  Proof. intros. unfold CAN_145_chi_dem. apply Q.le_min_l. Qed.

  Definition CAN_145_Pi_M (chi_dem_val Y_t Cost_M_t : Q) : Q :=
    chi_dem_val * Y_t - Cost_M_t.

End CAN_145_DemandRealization.

