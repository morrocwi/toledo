(* EQ-015/H.22.v1 — CAN-086 — Definition — parents: EQ-015/M.02.v1 — occurrences 2 *)

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
(** ** CAN-086 — DCP-remove-stage

    (* CAN-086 — root: Reset: fresh framing/session/source route; Removal: absence of decisive AI assistance — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". No Master River eq. citation. Both
    named conditions are typed as declared [Prop]s over an abstract
    session-state and assistance-record type, never asserted to hold. *)

Section CAN_086_DCPRemoveStage.

  Variables SessionT AssistT : Type.
  Variable is_fresh_route : SessionT -> Prop.
  Variable decisive_assistance : AssistT -> Prop.

  Definition CAN_086_is_reset (s : SessionT) : Prop := is_fresh_route s.
  Definition CAN_086_is_removal (a : AssistT) : Prop := ~ decisive_assistance a.

End CAN_086_DCPRemoveStage.

