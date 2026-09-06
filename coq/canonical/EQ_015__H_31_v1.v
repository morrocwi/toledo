(* EQ-015/H.31.v1 — CAN-100 — Definition — parents: EQ-015/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_HCA.
Require Import MR.MR_Retention.
Require Import MR.MR_TopicEntry.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-100 — life-capital-context

    (* CAN-100 — root: K^life_{i,n} = <Econ,FoundLit,LangBridge,Digital,DiscTime,Health,Mobility,Mentor,Cred> — domain: human–AI — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". Direct reuse of [MR_HCA.v]
    eq.(68): [LifeCapitalContext] and its constructor. *)

Definition CAN_100_LifeCapitalContext := MR_HCA.LifeCapitalContext.
Definition CAN_100_mk_life_capital_context := MR_HCA.mk_life_capital_context.

