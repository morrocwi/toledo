(* EQ-015/W.10.v1 — CAN-151 — Definition — parents: EQ-015/M.03.v1 — occurrences 6 *)

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
(** ** CAN-151 — human-systemic-position

    (* CAN-151 — root: P^H_t=(Gamma^eff)^tGamma(A^corr)^tA(Lambda^live)^tLambda(r^H)^tR(S^H)^tS(X^H)^tX/(1+D^H)^tD; Ydot>0 =/=> Pdot^H>0 — domain: world-system — tier: Th_coqc — occurrences: 6 *)

    CANONICAL.json tier: "definition". Master River v1.4 eq.(58)-(59)
    [after_labour]. Direct reuse of [MR_WorldSystem.v]'s [P_H_index]
    (Definition, eq.58) and [eq59_output_rise_not_position_rise]
    (Th_coqc, eq.59) — no redefinition. *)

Definition CAN_151_P_H_index := MR_WorldSystem.P_H_index.
Definition CAN_151_output_rise_not_position_rise :=
  MR_WorldSystem.eq59_output_rise_not_position_rise.

