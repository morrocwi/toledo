(* A.5/W.07.v1 — Definition — parents: A.5/M.01.v1, A.5/W.02.v1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

Section CAN_154_PowerChannels.

  Variables PEcon PInfo PCoerc State3 : Type.

  Definition PowerVector : Type := PEcon * PInfo * PCoerc.

  Definition CAN_154_mk_power_vector
             (p_econ : PEcon) (p_info : PInfo) (p_coerc : PCoerc)
    : PowerVector := (p_econ, p_info, p_coerc).
End CAN_154_PowerChannels.
