(* EQ-015/S.14.v1 — Definition — parents: EQ-015/M.02.v1, EQ-015/S.01.v1 *)

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

  (* CE-06 (update law): the two defining equations a regime's data
     must satisfy at one tick. *)
  Definition CAN_117_record_updates (R : CAN_117_Regime) (M M' : CAN_117_Record) : Prop :=
    M' = reg_T_R R M.

End CAN_117_Regime.
