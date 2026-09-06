(* EQ-015/S.33.v1 — Definition — parents: EQ-015/M.03.v1, EQ-015/S.03.v1 *)

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

  (* Structural injustice: two agents whose costs are grossly asymmetric —
     ">>" discretely replaced by "strictly greater by at least a declared
     margin [eps] > 0", never an informal "much greater than". *)
  Definition CAN_119_structural_injustice (C : nat -> Q) (eps : Q) (i j : nat) : Prop :=
    eps > 0 /\ C i - C j > eps.

  (* Witness (tier: Th_coqc): structural injustice is a satisfiable,
     non-vacuous relation — a concrete two-agent finite model with a
     genuine cost gap exceeding a positive declared margin. *)
  Theorem CAN_119_structural_injustice_satisfiable :
    exists (C : nat -> Q) (eps : Q) (i j : nat), CAN_119_structural_injustice C eps i j.
  Proof.
    exists (fun k => if Nat.eqb k 0 then 10 else 0), 1, 0%nat, 1%nat.
    unfold CAN_119_structural_injustice. simpl. split; lra.
  Qed.

End CAN_119_ColConf.
