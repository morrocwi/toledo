(* EQ-015/H.17.v1 — CAN-077 — Definition — parents: EQ-015/M.01.v1 — occurrences 2 *)

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
(** ** CAN-077 — human-return-CTSA4

    (* CAN-077 — root: R^return_H = <C, T, S, A> — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". No Master River eq. citation
    (CTSA Human-Return Readout, record 22339909) — a distinct, lighter
    four-field record from CAN-076's six-field [HReturn] (a different
    chapter's own reduced audit tuple; not merged, per CANONICAL.json's
    own separate-id treatment). *)

Section CAN_077_HumanReturnCTSA4.

  Variables Cont Trans Stab AccT : Type.

  Record ReturnCTSA4 : Type := mkReturnCTSA4
    { r4_C : Cont ; r4_T : Trans ; r4_S : Stab ; r4_A : AccT }.

  Definition CAN_077_human_return_ctsa4 := ReturnCTSA4.
  Definition CAN_077_mk_human_return_ctsa4 := mkReturnCTSA4.

End CAN_077_HumanReturnCTSA4.
