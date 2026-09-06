(* EQ-015/W.04.v1 — CAN-143 — Definition — parents: EQ-015/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-143 — labour-centrality

    (* CAN-143 — root: L_t = <L^task,L^income,L^bottleneck,L^bargain> — domain: world-system — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". Master River v1.4 eq.(53) [after_labour].
    Direct reuse of [MR_WorldSystem.v]'s [LabourCentrality]/[mk_labour_centrality] —
    no redefinition, a plain alias to the already section-discharged
    identifier. *)

Definition CAN_143_LabourCentrality := MR_WorldSystem.LabourCentrality.
Definition CAN_143_mk_labour_centrality := MR_WorldSystem.mk_labour_centrality.

