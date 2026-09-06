(* EQ-015/W.20.v1 — Definition — parents: EQ-015/M.01.v1, EQ-015/W.03.v1 *)

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

Section CAN_142_MachineCapacityBlock.

  Definition CAN_142_B_RB (N_RB q_RB : Q) : Q := N_RB * q_RB.

  (* eq.(5): B^RB_t = N^RB_t q^RB_t, a genuine definitional identity. *)
  Theorem CAN_142_B_RB_identity :
    forall N_RB q_RB : Q, CAN_142_B_RB N_RB q_RB == N_RB * q_RB.
  Proof. intros. unfold CAN_142_B_RB. reflexivity. Qed.
End CAN_142_MachineCapacityBlock.
