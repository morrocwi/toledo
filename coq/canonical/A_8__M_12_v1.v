(* A.8/M.12.v1 — CAN-189 — Definition — parents: A.8/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-189 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 1 *)
Section CAN189_ResidualModel.
  Variables Aa eps189 delta189 W189 : Q.
  Definition CAN189_r : Q := Aa * eps189 - delta189.
  Definition CAN189_V : Q := (1#2) * W189 * CAN189_r * CAN189_r.
End CAN189_ResidualModel.

