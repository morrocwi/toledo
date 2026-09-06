(* EQ-015/W.19.v1 — Definition — parents: EQ-015/M.01.v1 *)
(* N4 split (2026-09-06): this bundle's own Coq apparatus has been
   distributed to its child codes (registry/CANONICAL.json "split_children"); kept
   as a thin re-export so existing `Require`s of this module keep resolving. *)

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

From MRC Require Export EQ_015__W_55_v1.
From MRC Require Export EQ_015__W_57_v1.
