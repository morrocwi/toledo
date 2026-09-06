(* EQ-015/H.33.v1 — CAN-108 — Definition — parents: EQ-015/M.02.v1 — occurrences 2 *)

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
(** ** CAN-108 — HCA-governance-bundle

    (* CAN-108 — root: Adult: Purpose+Transparency+Refusal+Revision+DataMinimization; Child: ChildAssent+AdultOversight+Privacy+Safety+NoOpaquePersuasion — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". No Master River eq. citation. Two
    typed governance-condition records (Adult, Child), each a conjunction
    of its named declared [Prop] conditions. *)

Section CAN_108_HCAGovernanceBundle.

  Variables Regime : Type.
  Variables Purpose Transparency Refusal Revision DataMinimization : Regime -> Prop.
  Variables ChildAssent AdultOversight Privacy Safety NoOpaquePersuasion : Regime -> Prop.

  Definition CAN_108_adult_governance (r : Regime) : Prop :=
    Purpose r /\ Transparency r /\ Refusal r /\ Revision r /\ DataMinimization r.

  Definition CAN_108_child_governance (r : Regime) : Prop :=
    ChildAssent r /\ AdultOversight r /\ Privacy r /\ Safety r /\ NoOpaquePersuasion r.

End CAN_108_HCAGovernanceBundle.

