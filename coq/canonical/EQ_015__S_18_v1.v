(* EQ-015/S.18.v1 — Definition — parents: EQ-015/M.03.v1, EQ-015/S.02.v1 *)
(* tau_c > 0 is a bare Variable hypothesis in the source (CAN_118_Ethical's second conjunct), not a separately named Coq construct of its own; kept as the Section-typed Variable it already is. *)

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

End CAN_118_EthLoad.
