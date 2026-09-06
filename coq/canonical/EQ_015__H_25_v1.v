(* EQ-015/H.25.v1 — CAN-090 — Open — parents: EQ-015/M.02.v1 — occurrences 3 *)

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
(** ** CAN-090 — DCP-open-propositions

    (* CAN-090 — root: DCPp, DEPp, AgP [Open] — domain: human–AI — tier: Open — occurrences: 3 *)

    CANONICAL.json tier: "hypothesis/Open". Three named, abstract,
    un-proved [Prop] slots. *)

Section CAN_090_DCPOpenPropositions.

  Definition CAN_090_Open_dcp_propositions (DCPp DEPp AgP : Prop) : Prop :=
    DCPp /\ DEPp /\ AgP.

End CAN_090_DCPOpenPropositions.

