(* weld/S.28.v1 — Ax — parents: weld/M.02.v1, weld/S.02.v1 *)

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

  Definition CAN_116_ManifestedRecord : Type := list Event.

  (* Axiom II: Agency-as-Choice — A_i(t') subseteq M(t'). *)
  Definition CAN_116_is_agency (A M : CAN_116_ManifestedRecord) : Prop :=
    incl A M.

End CAN_116_EthAxiom.
