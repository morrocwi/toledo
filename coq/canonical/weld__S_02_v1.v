(* weld/S.02.v1 — Ax — parents: weld/M.02.v1 *)
(* N4 split (2026-09-06): this bundle's own Coq apparatus has been
   distributed to its child codes (registry/CANONICAL.json "split_children"); kept
   as a thin re-export so existing `Require`s of this module keep resolving. *)

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

From MRC Require Export weld__S_27_v1.
From MRC Require Export weld__S_28_v1.
From MRC Require Export weld__S_29_v1.
