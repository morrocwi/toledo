(* A.5/H.02.v1 — CAN-044 — Definition — parents: A.5/M.01.v1 — occurrences 6 *)

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
(** ** CAN-044 — DCP-topic-entry

    (* CAN-044 — root: TopicEntry in {LiveProblem,OpenExploration,RoutineDelegation}; ProblemFirst=>4 consequents [Open]; ProblemFirst<>ProblemOnly [Open] — domain: human–AI — tier: Open — occurrences: 6 *)

    CANONICAL.json tier: "definition/law (PFDP itself [Open])". Direct
    reuse of [MR_TopicEntry.v] eq.(47)-(49): the finite [TopicEntry]
    enumeration and [Legitimate] predicate (eq. 47, Definition) are
    aliased below; the Problem-First implication (eq. 48) and the
    Problem-First<>Problem-Only guard (eq. 49) are both tagged [Open] by
    main.tex's own Table 2 and are aliased to [Open_eq48]/[Open_eq49] —
    [Prop]-valued, never discharged with a proof, exactly as
    MR_TopicEntry.v itself leaves them. *)

Definition CAN_044_TopicEntry := MR_TopicEntry.TopicEntry.
Definition CAN_044_Legitimate := MR_TopicEntry.Legitimate.
Definition CAN_044_Open_ProblemFirst_implication := @MR_TopicEntry.Open_eq48.
Definition CAN_044_ProblemOnlyPolicy := @MR_TopicEntry.ProblemOnlyPolicy.
Definition CAN_044_Open_ProblemFirst_ne_ProblemOnly := @MR_TopicEntry.Open_eq49.

