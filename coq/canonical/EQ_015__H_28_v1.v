(* EQ-015/H.28.v1 — CAN-096 — Definition — parents: EQ-015/M.02.v1 — occurrences 1 *)

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
(** ** CAN-096 — interaction-efficiency

    (* CAN-096 — root: E:=f(ConstraintPrecision, ContextRecall, SourceTraceability, ErrorRepair) — domain: human–AI — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". No Master River eq. citation. An
    abstract declared function of its four named arguments. *)

Section CAN_096_InteractionEfficiency.

  Variables ConstraintPrecisionT ContextRecallT SourceTraceabilityT ErrorRepairT EffT : Type.
  Variable eff_fn : ConstraintPrecisionT -> ContextRecallT -> SourceTraceabilityT -> ErrorRepairT -> EffT.

  Definition CAN_096_interaction_efficiency := eff_fn.

End CAN_096_InteractionEfficiency.

