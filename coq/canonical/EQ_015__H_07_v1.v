(* EQ-015/H.07.v1 — CAN-057 — Definition — parents: EQ-015/M.03.v1 — occurrences 4 *)

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
(** ** CAN-057 — live-possibility

    (* CAN-057 — root: Pi^live_{A,t}(g) subset Pi^feas_{A,t}(g) subset Pi^phys_t(g) — domain: human–AI — tier: Definition — occurrences: 4 *)

    CANONICAL.json tier: "definition". Direct reuse of [MR_Live.v]
    eq.(19)/(21) (agent scale) and [MR_WorldSystem.v] eq.(55) (its
    world-system-scale restatement, After Labour eq. 32) — both already
    proved nestings, aliased under this one id. *)

Definition CAN_057_Pi_live := MR_Live.Pi_live.
Definition CAN_057_full_nesting_witness := MR_Live.eq19_full_nesting.
Definition CAN_057_full_nesting_worldsystem_witness := MR_WorldSystem.eq55_full_nesting_ws.

