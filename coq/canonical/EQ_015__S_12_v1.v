(* EQ-015/S.12.v1 — CAN-138 — Open — parents: EQ-015/M.03.v1 — occurrences 3 *)

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

(* ==================================================================== *)
(** ** CAN-138 — B-SOC-FALSIF

    (* CAN-138 — root: P-B (channel shift), P-C (excluded path), P-D (layer-2 dominates) — domain: social — tier: Open — occurrences: 3 *)

    CANONICAL.json tier: "hypothesis/Open". Empirical falsification tests
    of B-SOC-POTENTIAL/B-SOC-RECOVENV/B-SOC-SEVENDIST's D3 layer
    distinction. Typed exactly as CAN-127/CAN-130/CAN-131 above and
    deliberately left un-proved — tier: Open. *)

Inductive CAN_138_Falsif : Type := PF_PB_ChannelShift | PF_PC_ExcludedPath | PF_PD_Layer2Dominates.

Section CAN_138_Falsifiers.
  Variable CAN_138_holds : CAN_138_Falsif -> Prop.
End CAN_138_Falsifiers.

