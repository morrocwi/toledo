(* EQ-015/S.29.v1 — Definition — parents: EQ-015/M.03.v1, EQ-015/S.03.v1 *)

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

Section CAN_119_ColConf.

  Variable V_G : nat -> Q.               (* collective ethical-load ledger *)
  Variable individual_margins : list Q.  (* {Delta_spec(R_i)}_i, finite, declared *)
  Variable V_indiv : nat -> Q.           (* one representative individual ledger, for Conf *)

  Definition CAN_119_min_margin : Q :=
    match individual_margins with
    | nil => 0
    | x :: xs => fold_right Qmin x xs
    end.

  Definition CAN_119_Eth_col : Prop :=
    (forall n, V_G (S n) <= V_G n) /\ CAN_119_min_margin > 0.

End CAN_119_ColConf.
