(* EQ-015/E.07.v1 — CAN-022 — Definition — parents: EQ-015/M.02.v1 — occurrences 4 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-022 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition / Open — occurrences: 1 *)
(** State mapping: literally [MR_Resonance.v]'s eq.(16)-(18) apparatus:
    [accum_work] (Th_coqc bookkeeping: monotone, non-negative finite sum),
    [threshold_crossed] (the decidable comparison), and [Open_eq18] (the
    *causal* claim that crossing the barrier entails an actual
    transition/release — Table 2's own "candidate transition topology, not
    a universal claim" hedge, so left as an unproved [Prop], reused
    directly rather than re-derived or upgraded). *)
Definition CAN022_accum_work := accum_work.
Definition CAN022_threshold_crossed := threshold_crossed.
Definition CAN022_Open_transition := Open_eq18.

