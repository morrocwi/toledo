(* weld/S.33.v1 — Definition — parents: weld/M.02.v1, weld/S.03.v1 *)

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

Section CAN_120_MoralCost.

  Variable Vplus : nat -> Q.       (* per-tick worsening-load indicator, >= 0 *)
  Variable chi_causal chi_spec : Q. (* per-regime causal-memory / spectral violation indicators *)
  Variable alpha beta gamma : Q.
  Hypothesis Halpha : alpha > 0.
  Hypothesis Hbeta  : beta  > 0.
  Hypothesis Hgamma : gamma > 0.

  Definition CAN_120_moral_cost (t1 t2 : nat) : Q :=
    fold_right Qplus 0
      (map (fun _ => alpha * Vplus t1 + beta * chi_causal + gamma * chi_spec)
           (List.seq t1 (t2 - t1))).

End CAN_120_MoralCost.
