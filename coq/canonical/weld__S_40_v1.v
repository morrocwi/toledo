(* weld/S.40.v1 — Definition — parents: weld/M.02.v1, weld/S.03.v1 *)

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

  (* Choice-gate: with no instantiated choice of regime, no ethics,
     responsibility, or cost may be attributed at all. *)
  Definition CAN_120_choice_gate (has_choice : bool) (t1 t2 : nat) (attributed_cost : Q) : Prop :=
    has_choice = false -> attributed_cost = 0.

  (* Witness (tier: Th_coqc): the choice-gate is satisfiable both ways —
     an instance where it correctly fires (no choice, zero cost) and an
     instance where a genuine choice permits a non-zero attributed cost. *)
  Theorem CAN_120_choice_gate_satisfiable :
    CAN_120_choice_gate false 0%nat 0%nat 0
    /\ exists (has_choice : bool) (t1 t2 : nat) (c : Q),
         has_choice = true /\ c = 5 /\ CAN_120_choice_gate has_choice t1 t2 c.
  Proof.
    split.
    - unfold CAN_120_choice_gate. intro H. reflexivity.
    - exists true, 0%nat, 1%nat, 5. repeat split. unfold CAN_120_choice_gate. discriminate.
  Qed.
End CAN_120_MoralCost.
