(* EQ-015/M.04.v1 — CAN-005 — Definition — parents: EQ-015/M.03.v1 — occurrences 4 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import Arith.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import EQ_015__M_03_v1.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-005 — readout-admission-order

    (* CAN-005 — root: Retention->Structure->Translation->Readout->Meaning->Report (compressed); Retention->Structure->CandidateState->Sufficiency->Quotient->DomainDynamics->Readout->Meaning->Experience->Memory->Knowledge->CheckedReport (MEMK extension) — domain: root — tier: Definition — occurrences: 4 *)

    Not an independent root object — per COLLAPSE.md and this file's own
    header, CAN-005 is "Before Meaning, Before Choice"'s own reading of
    the CAN-004 admission order (retention through report), given as a
    compressed six-stage chain plus a twelve-stage MEMK extension. Both
    chains walk the same [nat]-indexed total order CAN-004 already
    defines; no new carrier or ordering fact is introduced here. Direct
    reuse of [CAN_004_index]/[CAN_004_Stage] — a plain alias to the
    already-proved identifier, in the same reuse-not-redefine style
    [MRC_world_system_reading.v] uses for CAN-143's alias of
    [MR_WorldSystem.LabourCentrality] — so the registry-to-corpus map
    stays total without minting a second, redundant ordering. *)

Definition CAN_005_readout_admission_order := CAN_004_index.
Definition CAN_005_readout_admission_order_stage := CAN_004_Stage.

