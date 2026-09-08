(* EQ-015/H.11.v1 — CAN-063 — Dr — parents: EQ-015/M.01.v1 — occurrences 2 *)

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
(** ** CAN-063 — K_like-statemachine

    (* CAN-063 — root: K_like->K_assumed (dangerous shortcut); repaired K_like-check->K_checked-support->K_supported-warrant->K_validated — domain: human–AI — tier: Dr — occurrences: 2 *)

    CANONICAL.json tier: "law/proposition". No Master River eq. citation
    (Epistemic Fusion v8.1, EF-05/EF-06 Repair 2, record 22331922). The
    repaired status ladder is typed as a four-constructor [Inductive]
    with an explicit next-status step map, in the same finite-enumeration
    family as [MR_TopicEntry.CycleStage]; the "dangerous shortcut" is
    typed as a [Prop] naming the collapse this ladder is built to avoid,
    never asserted to hold. *)

Section CAN_063_KLikeStateMachine.

  Inductive RepairedStatus : Type :=
    | RSLike | RSChecked | RSSupported | RSValidated.

  Definition CAN_063_next_status (s : RepairedStatus) : RepairedStatus :=
    match s with
    | RSLike      => RSChecked
    | RSChecked   => RSSupported
    | RSSupported => RSValidated
    | RSValidated => RSValidated
    end.

  Definition CAN_063_dangerous_shortcut
             (fluent_read : RepairedStatus -> Prop) : Prop :=
    fluent_read RSLike -> fluent_read RSValidated.

End CAN_063_KLikeStateMachine.

