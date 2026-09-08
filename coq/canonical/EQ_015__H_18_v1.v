(* EQ-015/H.18.v1 — CAN-078 — Definition — parents: EQ-015/M.02.v1 — occurrences 4 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_HCA.
Require Import MR.MR_Retention.
Require Import MR.MR_TopicEntry.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-078 — D-R-A-constitutive

    (* CAN-078 — root: D>0, Resist>0, A_H>0 — domain: human–AI — tier: Definition — occurrences: 4 *)

    CANONICAL.json tier: "definition/hypothesis-Open". No Master River
    eq. citation. Typed as three [Q]-valued positivity conditions on a
    difference-magnitude, a resistance level, and a human-agency level;
    the source treats their joint holding as constitutive of the
    phenomenon under study, not as a proved theorem — left as an
    un-proved [Prop] conjunction. *)

Section CAN_078_DRAConstitutive.

  Definition CAN_078_Open_dra_constitutive (D_val Resist_val A_H_val : Q) : Prop :=
    D_val > 0 /\ Resist_val > 0 /\ A_H_val > 0.

End CAN_078_DRAConstitutive.

