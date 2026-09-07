(* weld/S.16.v1 -- Toledo v1.1 lane B2 -- Dr *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Qabs.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* minimal 2-node matrix model L = [[-alpha, eps],[eps,-beta]], alpha,beta>0 *)
Record weld_S16_L := mkweldS16 { s16_alpha : Q; s16_eps : Q; s16_beta : Q }.
Definition weld_S16_valid (L : weld_S16_L) : Prop :=
  s16_alpha L > 0 /\ s16_beta L > 0.
