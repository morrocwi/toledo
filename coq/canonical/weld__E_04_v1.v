(* weld/E.04.v1 — CAN-032 — Definition — parents: weld/M.03.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import weld__E_03_v1.
From MRC Require Import MRC_Prelude.

(* CAN-032 — root: readout-admission-order (CAN-005) reading — domain:
   epistemic — tier: Definition — occurrences: 1 *)
(** sigma_K(p) <> Pi_prac(p): epistemic status and practical/operational
    effectiveness are separate axes. Witnessed non-collapse via the
    shared enumeration device, plus a concrete divergence witness on
    [CAN031_Status] itself. *)
Inductive CAN032_Notion := CAN032_EpistemicStatus | CAN032_PracticalEffectiveness.
Definition CAN032_code (n : CAN032_Notion) : nat :=
  match n with CAN032_EpistemicStatus => 0 | CAN032_PracticalEffectiveness => 1 end.
Theorem CAN032_non_collapse : notions_pairwise_distinct CAN032_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

Theorem CAN032_status_and_performance_can_diverge :
  exists (Performance : Type) (fail : Performance)
         (status : CAN031_Status) (perf : Performance -> Prop),
    status = CAN031_Admitted /\ ~ perf fail.
Proof.
  exists bool, false, CAN031_Admitted, (fun b => b = true).
  split; [reflexivity | discriminate].
Qed.

