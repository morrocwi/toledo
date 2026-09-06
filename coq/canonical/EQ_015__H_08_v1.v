(* EQ-015/H.08.v1 — CAN-058 — Definition — parents: EQ-015/M.02.v1 — occurrences 2 *)

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
(** ** CAN-058 — live-set-weight

    (* CAN-058 — root: L_{A,t}(g)={(pi,lambda^live(pi|g)):pi in Pi^feas(g)}; Pi^live={pi: lambda^live(pi|g)>=tau_live} — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". Direct reuse of [MR_Live.v]
    eq.(20)-(21): the accessibility-weighted field [live_field] and the
    threshold cut used to build [Pi_live] itself, [live_ge_threshold]. *)

Definition CAN_058_live_field := MR_Live.live_field.
Definition CAN_058_live_ge_threshold := MR_Live.live_ge_threshold.

