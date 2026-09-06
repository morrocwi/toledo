(* weld/S.48.v1 — Definition — parents: weld/M.03.v1, weld/S.05.v1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

Section CAN_123_CollectiveReadout.

  Variables IndZ TimeT AggT CouplT SemVal EventT : Type.

  Record CAN_123_GroupState : Type := mkGroupState
    { gs_individuals : list IndZ
    ; gs_time        : TimeT
    ; gs_aggregator  : AggT
    ; gs_coupling    : CouplT
    }.

  Variable q_sem_G : CAN_123_GroupState -> SemVal.

  Definition CAN_123_group_readout (Z : CAN_123_GroupState) : SemVal := q_sem_G Z.

End CAN_123_CollectiveReadout.
