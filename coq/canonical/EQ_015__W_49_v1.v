(* EQ-015/W.49.v1 — Definition — parents: EQ-015/M.03.v1, EQ-015/W.12.v1 *)

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

