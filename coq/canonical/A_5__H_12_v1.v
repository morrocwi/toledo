(* A.5/H.12.v1 — CAN-084 — Definition — parents: A.5/M.01.v1 — occurrences 3 *)

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
(** ** CAN-084 — DCP-verify-stage

    (* CAN-084 — root: L(c)={Decision,Risk,Money,Health,Legal,Publication,IrreversibleAction}; V={primary source,data,experiment,calculation,expert,independent method} — domain: human–AI — tier: Definition — occurrences: 3 *)

    CANONICAL.json tier: "definition/law". No Master River eq. citation.
    Both the stakes classification and the verification-method menu are
    typed as closed finite [Inductive] enumerations. *)

Section CAN_084_DCPVerifyStage.

  Inductive StakesKind : Type :=
    | KDecision | KRisk | KMoney | KHealth | KLegal | KPublication | KIrreversible.

  Inductive VerifyMethod : Type :=
    | VPrimarySource | VData | VExperiment | VCalculation | VExpert | VIndependentMethod.

  Definition CAN_084_high_stakes (k : StakesKind) : Prop :=
    match k with
    | KDecision | KRisk | KMoney | KHealth | KLegal | KPublication | KIrreversible => True
    end.

End CAN_084_DCPVerifyStage.

