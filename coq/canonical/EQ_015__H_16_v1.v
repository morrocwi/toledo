(* EQ-015/H.16.v1 — CAN-076 — Definition — parents: EQ-015/M.01.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Require Import MR.MR_Prompt.
Require Import MR.MR_Retention.
Require Import MR.MR_TopicEntry.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-076 — human-return-CTSA6

    (* CAN-076 — root: H_return = <G_CTSA, L, M, P, W, Delta_dir> — domain: human–AI — tier: Definition — occurrences: 3 *)

    CANONICAL.json tier: "definition". Direct reuse of [MR_Retention.v]
    eq.(41): the six-field [HReturn] record and its constructor. *)

Definition CAN_076_HReturn := MR_Retention.HReturn.
Definition CAN_076_mk_h_return := MR_Retention.mk_h_return.

