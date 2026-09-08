(* EQ-002/E.02.v1 — CAN-011 — Definition — parents: EQ-002/M.03.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-011 — root: root-weld (CAN-001) reading, the source-side non-collapse
   of what a reader receives — domain: epistemic — tier: Definition —
   occurrences: 2 *)
(** R_A = O_A(W; Pi_A) (<> W); m(A) <> rho(A): a source label is a readout,
    not an oracle. Formalised as two witnessed non-collapse facts: (1) a
    same-typed instrument need not return the world state unchanged; (2) a
    metadata label and an operator-conditioned readout are two distinct
    notions, not one, via the shared enumeration device. *)
Section CAN011_SourceProvenanceReadout.
  Variables World Params Readout : Type.
  Variable O_A : World -> Params -> Readout.
  Definition CAN011_R_A (w : World) (p : Params) : Readout := O_A w p.
End CAN011_SourceProvenanceReadout.

Theorem CAN011_readout_not_world_witness :
  exists (W : Type) (O : W -> W -> W) (w p : W), O w p <> w.
Proof.
  exists bool, xorb, true, true.
  simpl. discriminate.
Qed.

Inductive CAN011_Notion := CAN011_Label | CAN011_Readout.
Definition CAN011_code (n : CAN011_Notion) : nat :=
  match n with CAN011_Label => 0 | CAN011_Readout => 1 end.
Theorem CAN011_non_collapse : notions_pairwise_distinct CAN011_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

