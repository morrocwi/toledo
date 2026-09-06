(* EQ-015/W.15.v1 — CAN-158 — Definition — parents: EQ-015/M.01.v1 — occurrences 1 *)

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
(** ** CAN-158 — human-return-worldsystem

    (* CAN-158 — root: R^return_{H,t} = <C_t, T_t, S^skill_t, A^alt_t> — domain: world-system — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". Master River v1.4 eq.(57)
    [after_labour eq.35]. Direct reuse of [MR_WorldSystem.v]'s
    [ReturnProfileWS]/[mk_return_profile_ws] — no redefinition. Per
    CANONICAL.json's own note, this parallels CTSA's Human-Return tuples
    (CAN-076/CAN-077, human-AI family) but After Labour explicitly does
    not assert instrument identity — kept under its own distinct type, as
    [MR_WorldSystem.v] itself already records. *)

Definition CAN_158_ReturnProfileWS := MR_WorldSystem.ReturnProfileWS.
Definition CAN_158_mk_return_profile_ws := MR_WorldSystem.mk_return_profile_ws.

