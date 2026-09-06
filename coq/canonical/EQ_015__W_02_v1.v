(* EQ-015/W.02.v1 — CAN-141 — Definition — parents: EQ-015/M.01.v1 — occurrences 1 *)

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
(** ** CAN-141 — epistemic-firewall-validation

    (* CAN-141 — root: Z_{t+1}=Z_t+v_tG_t-delta_Z Z_t, 0<=v_t<=1 — domain: world-system — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (After
    Labour eq.(3), record 22481924) — freshly formalised. The continuum
    ODE [Z-dot = v_t G_t - delta_Z Z_t] is read discretely as a one-step
    stock update; the bounded-validation-rate requirement [0<=v_t<=1] is
    a declared [Prop], not silently assumed. *)

Section CAN_141_EpistemicFirewall.

  Definition CAN_141_Z_next (v_t G_t delta_Z Z_t : Q) : Q :=
    Z_t + v_t * G_t - delta_Z * Z_t.

  Definition CAN_141_valid_validation_rate (v_t : Q) : Prop :=
    0 <= v_t <= 1.

End CAN_141_EpistemicFirewall.

