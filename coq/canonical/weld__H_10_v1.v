(* weld/H.10.v1 — CAN-094 — Definition — parents: weld/M.01.v1 — occurrences 7 *)

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
(** ** CAN-094 — self-context-agency

    (* CAN-094 — root: A:=capacity to decide under context retaining accountability; S:=(goals,constraints,stakes,role,local evidence,lived situation) — domain: human–AI — tier: Definition — occurrences: 7 *)

    CANONICAL.json tier: "definition/proposition". No Master River eq.
    citation. Agency is typed as a [Prop]-valued predicate on a decision
    given a context; the context itself is a typed six-field record. *)

Section CAN_094_SelfContextAgency.

  Variables GoalsT ConstraintsT StakesT2 RoleT EvidenceT SituationT DecisionT : Type.

  Record ContextS : Type := mkContextS
    { cs_goals : GoalsT ; cs_constraints : ConstraintsT ; cs_stakes : StakesT2
    ; cs_role : RoleT ; cs_evidence : EvidenceT ; cs_situation : SituationT }.

  Variable retains_accountability : DecisionT -> ContextS -> Prop.

  Definition CAN_094_is_agency (d : DecisionT) (s : ContextS) : Prop :=
    retains_accountability d s.

End CAN_094_SelfContextAgency.

