(* A.5/W.06.v1 — Definition — parents: A.5/M.01.v1, A.5/W.01.v1 *)

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

Section CAN_147_ScarceAssetRent.

  Definition CAN_147_Gamma_eff (Gamma_net B_scarce_val : Q) : Q :=
    Qmax 0 (Gamma_net - B_scarce_val).

  Theorem CAN_147_abundance_not_low_burden_not_freedom :
    exists (M B_scarce_seq Gamma_net_seq : nat -> Q) (t : nat),
      0 < M (S t) - M t /\
      0 < B_scarce_seq (S t) - B_scarce_seq t /\
      ~ (0 < CAN_147_Gamma_eff (Gamma_net_seq (S t)) (B_scarce_seq (S t))
             - CAN_147_Gamma_eff (Gamma_net_seq t) (B_scarce_seq t)).
  Proof.
    exists (fun n => match n with O => 0 | S _ => 1 end).
    exists (fun n => match n with O => 0 | S _ => 1 end).
    exists (fun _ => 1).
    exists O.
    simpl.
    split. lra.
    split. lra.
    unfold CAN_147_Gamma_eff.
    assert (H1 : Qmax 0 (1 - 0) == 1) by (apply Q.max_r; lra).
    assert (H2 : Qmax 0 (1 - 1) == 0) by (apply Q.max_l; lra).
    rewrite H1. rewrite H2. lra.
  Qed.

End CAN_147_ScarceAssetRent.
