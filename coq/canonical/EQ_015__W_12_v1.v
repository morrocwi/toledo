(* EQ-015/W.12.v1 — CAN-153 — Definition — parents: EQ-015/M.03.v1 — occurrences 3 *)

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
(** ** CAN-153 — social-reproduction

    (* CAN-153 — root: Hdot^cap=f(Care,Health,Education,Nutrition,Community)-delta_H H^cap; productive necessity of humans <> social necessity of reproduction — domain: world-system — tier: Th_coqc — occurrences: 3 *)

    CANONICAL.json tier: "definition/hypothesis-Open (dynamic sign
    explicitly left open)". No Master River eq. citation (After Labour
    eq.(38)-(39),(56), record 22481924) — freshly formalised. The
    accumulation stepper is typed over an abstractly-declared input
    function [f_val] (never committing to a specific functional form the
    source itself leaves general); the dynamic *sign* of [Hdot^cap] is
    exactly what the source states is left open, so it is recorded as a
    [Prop]-valued Definition, deliberately un-proved. The non-collapse
    itself ("productive necessity ≠ social necessity") is discharged via
    the shared generic witness [CAN_ws_generic_rise_not_entail_rise]. *)

Section CAN_153_SocialReproduction.

  Definition CAN_153_H_cap_next (f_val delta_H H_cap_t : Q) : Q :=
    H_cap_t + f_val - delta_H * H_cap_t.

  (* dynamic sign of Hdot^cap: explicitly Open in the source, typed and
     left un-proved, never a decided Theorem. *)
  Definition CAN_153_Open_dynamic_sign (f_val delta_H H_cap_t : Q) : Prop :=
    CAN_153_H_cap_next f_val delta_H H_cap_t > H_cap_t.

End CAN_153_SocialReproduction.

Definition CAN_153_productive_not_social_necessity_witness :=
  CAN_ws_generic_rise_not_entail_rise.

