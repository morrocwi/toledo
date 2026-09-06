(* weld/S.06.v1 — CAN-124 — Dr — parents: weld/M.01.v1 — occurrences 1 *)

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
(** ** CAN-124 — power-live-gap

    (* CAN-124 — root: L^live_{A,g}=max_{z in J_feas} D_L(L^z_A(g),L^z0_A(g)) — domain: social — tier: Th_coqc — occurrences: 1 *)

    CANONICAL.json tier: "proposition". [canonical_source] prose cites
    "Master Equation River v1.4 eq.(26)" but [in_master_river] is [null]
    in CANONICAL.json itself — a registry drift disclosed in the ledger,
    not silently resolved here. Since [canonical_text] is symbol-identical
    to CAN-134's (below), this id is aliased to the same already-compiled,
    axiom-free [MR_Live.live_field_gap] rather than re-derived. *)

Definition CAN_124_power_live_gap := @MR_Live.live_field_gap.

