(* EQ-015/S.19.v1 — Definition — parents: EQ-015/M.03.v1, EQ-015/S.02.v1 *)
(* Delta_spec > 0 is likewise a bare Variable hypothesis (CAN_118_Ethical's third conjunct); kept as the Section-typed Variable it already is. *)

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
