(* EQ-015/S.15.v1 — Definition — parents: EQ-015/M.02.v1, EQ-015/S.01.v1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import weld__S_02_v1.
From MRC Require Import MRC_Prelude.

Section CAN_117_Regime.

  Variable Event : Type.

  Definition CAN_117_Record := CAN_116_ManifestedRecord Event.

  Record CAN_117_Regime : Type := mkRegime
    { reg_T_R : CAN_117_Record -> CAN_117_Record                    (* translation operator: updates M *)
    ; reg_I_R : CAN_117_Record -> CAN_117_Record -> CAN_117_Record  (* interaction operator: updates A given M *)
    }.

  Definition CAN_117_agency_updates (R : CAN_117_Regime) (A M A' : CAN_117_Record) : Prop :=
    incl A' (reg_I_R R A M).

End CAN_117_Regime.
