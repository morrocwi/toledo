(* EQ-015/H.32.v1 — CAN-104 — Open — parents: EQ-015/M.02.v1 — occurrences 3 *)

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
(** ** CAN-104 — scaffold-fading

    (* CAN-104 — root: StableUnaidedReturn-up => h^decisive-down [Open] — domain: human–AI — tier: Open — occurrences: 3 *)

    CANONICAL.json tier: "hypothesis/Open". Direct reuse of [MR_HCA.v]
    eq.(73): [hca_ddiff] (the discrete-difference substitution) and
    [Open_eq73], left un-proved exactly as the source file leaves it. *)

Definition CAN_104_hca_ddiff := MR_HCA.hca_ddiff.
Definition CAN_104_Open_scaffold_fading := @MR_HCA.Open_eq73.

