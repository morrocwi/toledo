(* weld/S.27.v1 — Ax — parents: weld/M.02.v1, weld/S.02.v1 *)

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

Section CAN_116_EthAxiom.

  Variable Event : Type.

  (* Axiom I: Reality-as-Record — M(t') is (typed as) a finite record. *)
  Definition CAN_116_ManifestedRecord : Type := list Event.

End CAN_116_EthAxiom.
