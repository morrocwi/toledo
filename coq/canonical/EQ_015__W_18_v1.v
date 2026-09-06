(* EQ-015/W.18.v1 — CAN-162 — Definition — parents: EQ-015/M.01.v1 — occurrences 1 *)

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
(** ** CAN-162 — bad-mode-state

    (* CAN-162 — root: B_t = <D_t, Gdot^conv_t, C^info_t, 1-X^H_t, 1-r_H, 1-Lambda^live_H, 1-A^corr_H, 1-Gamma^eff, 1-H^cap> — domain: world-system — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (The
    Human Conversion Imperative Section 7, record 22481926) — freshly
    formalised. A typed 9-tuple record over declared [Q] shortfall/level
    coordinates; a sustained trajectory reading, per the source's own
    caveat, is prose here, not a further Coq obligation. *)

Record BadModeState : Type := mkBadModeState
  { bms_D : Q          (* dependency *)
  ; bms_Gdot_conv : Q  (* gate-power drift *)
  ; bms_C_info : Q     (* informational concentration *)
  ; bms_shortfall_X : Q     (* 1 - X^H *)
  ; bms_shortfall_r : Q     (* 1 - r_H *)
  ; bms_shortfall_Lambda : Q (* 1 - Lambda^live_H *)
  ; bms_shortfall_Acorr : Q  (* 1 - A^corr_H *)
  ; bms_shortfall_Gamma : Q  (* 1 - Gamma^eff *)
  ; bms_shortfall_Hcap : Q   (* 1 - H^cap *)
  }.

Definition CAN_162_BadModeState := BadModeState.
Definition CAN_162_mk_bad_mode_state := mkBadModeState.

