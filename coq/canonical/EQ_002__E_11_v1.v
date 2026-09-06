(* EQ-002/E.11.v1 — CAN-206 — Dr — parents: EQ-002/M.03.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-206 — root: root-readout-gate (CAN-201) reading — domain:
   epistemic — tier: Definition — occurrences: 1 *)
(** D_n = {D_n^first, D_n^beh, D_n^neural, D_n^world}: a named,
    closed, decidable taxonomy of readout-domain sources. *)
Inductive CAN206_DomainSource :=
  CAN206_FirstPerson | CAN206_Behavioral | CAN206_Neural | CAN206_World.

Definition CAN206_source_eq_dec : forall d1 d2 : CAN206_DomainSource, {d1 = d2} + {d1 <> d2}.
Proof. decide equality. Defined.

