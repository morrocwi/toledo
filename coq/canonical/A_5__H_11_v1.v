(* A.5/H.11.v1 — CAN-083 — Definition — parents: A.5/M.01.v1 — occurrences 6 *)

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
(** ** CAN-083 — DCP-protocol-stages

    (* CAN-083 — root: Anchor->Expand->Oppose->Discriminate->Verify->Integrate->Remove->Return; Oppose<>manufacture — domain: human–AI — tier: Definition — occurrences: 6 *)

    CANONICAL.json tier: "definition/law". No Master River eq. citation.
    The eight-stage protocol is a closed [Inductive] with an explicit
    successor map, in the same finite-cycle family as
    [MR_TopicEntry.CycleStage]; "Oppose is not manufactured disagreement"
    is typed as a guarding [Prop] on a declared oppose-generation
    predicate, not asserted. *)

Section CAN_083_DCPProtocolStages.

  Inductive DCPStage : Type :=
    | PAnchor | PExpand | POppose | PDiscriminate
    | PVerify | PIntegrate | PRemove | PReturn.

  Definition CAN_083_stage_next (s : DCPStage) : DCPStage :=
    match s with
    | PAnchor => PExpand
    | PExpand => POppose
    | POppose => PDiscriminate
    | PDiscriminate => PVerify
    | PVerify => PIntegrate
    | PIntegrate => PRemove
    | PRemove => PReturn
    | PReturn => PReturn
    end.

  Variables RivalT : Type.
  Variable Manufactured RivalGenerated : RivalT -> Prop.

  Definition CAN_083_oppose_ne_manufacture (r : RivalT) : Prop :=
    RivalGenerated r -> ~ Manufactured r.

End CAN_083_DCPProtocolStages.

