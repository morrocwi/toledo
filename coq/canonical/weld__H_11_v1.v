(* weld/H.11.v1 — CAN-110 — Definition — parents: weld/M.03.v1 — occurrences 5 *)

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
(** ** CAN-110 — rival-model-ladder-prechoice

    (* CAN-110 — root: M0=formal option count+preference; M1=affordance/capability+cost; M2=constructed-preference/salience; M3=predictive/active-inference; M4=... — domain: human–AI — tier: Definition — occurrences: 5 *)

    CANONICAL.json tier: "definition". No Master River eq. citation. A
    closed finite [Inductive] enumeration of the rival pre-choice models,
    each paired with its own declared evaluation function via a common
    interface record — the ladder ordering itself is a plain [nat]-valued
    index, never a continuum scale. *)

Section CAN_110_RivalModelLadder.

  Inductive RivalModel : Type :=
    | M0_FormalOption | M1_AffordanceCost | M2_ConstructedPreference
    | M3_PredictiveActiveInference | M4_Other.

  Definition CAN_110_ladder_index (m : RivalModel) : nat :=
    match m with
    | M0_FormalOption => 0
    | M1_AffordanceCost => 1
    | M2_ConstructedPreference => 2
    | M3_PredictiveActiveInference => 3
    | M4_Other => 4
    end.

End CAN_110_RivalModelLadder.

