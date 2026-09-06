(* EQ-015/H.23.v1 — CAN-087 — Definition — parents: EQ-015/M.01.v1 — occurrences 2 *)

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
(** ** CAN-087 — DCP-return-conversion-vector

    (* CAN-087 — root: DeltaH_s=<DeltaC,DeltaT,DeltaS,DeltaA,DeltaAcorr,DeltaLambdalive>; F^return=f(Criticality,LearningNeed,FailureCost,DependencyRisk) — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". No Master River eq. citation. A
    typed six-field conversion-delta record, plus an abstract declared
    return-force function of its four named risk arguments. *)

Section CAN_087_DCPReturnConversionVector.

  Variables DC DT DS DA DAcorr DLambda : Type.

  Record ReturnConversionVector : Type := mkReturnConversionVector
    { rcv_C : DC ; rcv_T : DT ; rcv_S : DS
    ; rcv_A : DA ; rcv_Acorr : DAcorr ; rcv_Lambda : DLambda }.

  Definition CAN_087_return_conversion_vector := ReturnConversionVector.
  Definition CAN_087_mk_return_conversion_vector := mkReturnConversionVector.

  Variables CriticalityT LearnNeedT2 FailCostT DependRiskT2 FReturnT : Type.
  Variable f_return : CriticalityT -> LearnNeedT2 -> FailCostT -> DependRiskT2 -> FReturnT.

  Definition CAN_087_F_return := f_return.

End CAN_087_DCPReturnConversionVector.

