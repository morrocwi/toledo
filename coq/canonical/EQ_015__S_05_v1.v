(* EQ-015/S.05.v1 — CAN-130 — Dr — parents: EQ-015/M.03.v1 — occurrences 5 *)

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
(** ** CAN-130 — B-SOC-MEANPROP

    (* CAN-130 — root: P1..P5 meaning-shaped practical possibility — domain: social — tier: Open — occurrences: 5 *)

    CANONICAL.json tier: "proposition". Prose propositions, not formal
    equations, tagged readout R only loosely (per CANONICAL.json's own
    note). Typed as an abstract enumeration with an abstract,
    Section-discharged holds-predicate, exactly as CAN-127 above, and
    deliberately left un-proved — tier: Open. *)

Inductive CAN_130_MeanPropItem : Type := MP_P1 | MP_P2 | MP_P3 | MP_P4 | MP_P5.

Section CAN_130_MeaningProps.
  Variable CAN_130_holds : CAN_130_MeanPropItem -> Prop.
End CAN_130_MeaningProps.

