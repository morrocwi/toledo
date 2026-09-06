(* EQ-015/S.03.v1 — CAN-119 — Definition — parents: EQ-015/M.03.v1 — occurrences 11 *)

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

(* ==================================================================== *)
(** ** CAN-119 — B-SOC-COLCONF

    (* CAN-119 — root: Eth_col(G) iff dV_G/dt<=0 and min_i Delta_spec(R_i)>0 — domain: social — tier: Definition — occurrences: 11 *)

    CANONICAL.json tier: "definition". Discrete replacement: "min_i" over
    a (finite) family of agents is [fold_right Qmin] over a declared
    finite [list Q] of per-agent margins — never an unbounded infimum. *)

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

  Definition CAN_119_Conf_ind_to_col : Prop :=
    (forall n, V_indiv (S n) <= V_indiv n) /\ ~ (forall n, V_G (S n) <= V_G n).

  Definition CAN_119_Conf_col_to_ind : Prop :=
    (forall n, V_G (S n) <= V_G n) /\ ~ (forall n, V_indiv (S n) <= V_indiv n).

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

