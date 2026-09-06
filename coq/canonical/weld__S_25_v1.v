(* weld/S.25.v1 — Dr — parents: weld/M.01.v1, weld/S.01.v1 *)

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

Section CAN_115_L1_L4_Open.

  Variables verts' : list nat.
  Variable W' Gamma' : nat -> Q.
  Variable J' : nat -> Q.
  Variable dt' : Q.
  Variable s_star : nat -> Q.          (* the fixed point s* = A^{-1} J, left abstract *)
  Variable intervention : (nat -> Q) -> nat -> (nat -> Q).  (* bounded, amplitude-only, ticks-held *)
  (* L3: raising dissipation gamma_i (operator-level, not amplitude
     suppression) can push the fixed point permanently below threshold at
     zero ongoing force. *)
  Variable CAN_115_L3_operator_change : Prop.
End CAN_115_L1_L4_Open.
