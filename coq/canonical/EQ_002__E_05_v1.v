(* EQ-002/E.05.v1 — CAN-020 — Definition — parents: EQ-002/M.03.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-020 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition — occurrences: 1 *)
(** State mapping: literally [MR_Foundation.v]'s [NamingChainStep] record
    and [naming_chain] fixpoint (eq.(7)) — both persist unchanged past
    [End Naming] (generalised only over the section's carrier types), so
    reused directly rather than restated. *)
Definition CAN020_NamingChainStep := NamingChainStep.
Definition CAN020_naming_chain := naming_chain.

