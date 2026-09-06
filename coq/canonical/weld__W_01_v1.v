(* weld/W.01.v1 — CAN-150 — Definition — parents: weld/M.02.v1 — occurrences 1 *)

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
(** ** CAN-150 — pe-to-human-bridge

    (* CAN-150 — root: c^(PE->H)_{i,t} = B^(PE->H)(Z_t; i, g) — domain: world-system — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (After
    Labour eq.(31), record 22481924) — freshly formalised. A named
    mechanism required to convert a political-economy state reading into
    a per-person, per-goal human-agency reading — typed here exactly as
    the source states it (a declared function of the state, the person,
    and the goal), matching this id's own reading in COLLAPSE.md ("a
    named mechanism required to upgrade a political-economic relation
    into a claim about human agency") without asserting any further
    admissibility/weld property beyond what After Labour eq.(31) itself
    states. *)

Section CAN_150_PEToHumanBridge.

  Variables StateZ Person3 Goal3 Val3 : Type.
  Variable B_PE_to_H : StateZ -> Person3 -> Goal3 -> Val3.

  Definition CAN_150_pe_to_human_bridge
             (Z_t : StateZ) (i : Person3) (g : Goal3) : Val3 :=
    B_PE_to_H Z_t i g.

End CAN_150_PEToHumanBridge.

