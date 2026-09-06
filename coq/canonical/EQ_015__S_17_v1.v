(* EQ-015/S.17.v1 — Definition — parents: EQ-015/M.03.v1, EQ-015/S.02.v1 *)
(* Ethical Load (Lyapunov potential) V_{A,R} >= 0 is read here via its operational content already in this corpus (the per-tick non-increase clause CAN_118_non_increasing); the source's own file states no separate non-negativity construct for V itself. *)

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

Section CAN_118_EthLoad.

  Variable V : nat -> Q.       (* ethical-load ledger, one value per tick *)
  Variable tau_c : Q.          (* causal-memory admissibility parameter *)
  Variable Delta_spec : Q.     (* spectral-stability margin *)

  Definition CAN_118_non_increasing : Prop :=
    forall n : nat, V (S n) <= V n.

End CAN_118_EthLoad.
