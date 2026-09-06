(* EQ-015/H.02.v1 — CAN-043 — Definition — parents: EQ-015/M.01.v1 — occurrences 5 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import List.
Require Import MR.MR_Live.
Require Import MR.MR_Prompt.
Require Import MR.MR_Retention.
Require Import MR.MR_TopicEntry.
Require Import MR.MR_WorldSystem.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* ==================================================================== *)
(** ** CAN-043 — entry-state-anchor

    (* CAN-043 — root: A0 = <P0,M0,U0,E0,F0,S0> — domain: human–AI — tier: Definition — occurrences: 5 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (DCP
    v1.3-latest eq.(12)-(13), record 22481928, superseding Epistemic
    Fusion v8.1 EF-01/02/03) — freshly formalised. A six-field record
    typed exactly as the paper's latest form, never the superseded
    seven-field [H0*] tuple (kept only in prose here as provenance). *)

Section CAN_043_EntryStateAnchor.

  Variables Problem Model Unknowns Evidence ChangeCond Stakes : Type.

  Record EntryStateAnchor : Type := mkEntryStateAnchor
    { esa_P0 : Problem
    ; esa_M0 : Model
    ; esa_U0 : Unknowns
    ; esa_E0 : Evidence
    ; esa_F0 : ChangeCond
    ; esa_S0 : Stakes
    }.

  Definition CAN_043_entry_state_anchor := EntryStateAnchor.
  Definition CAN_043_mk_entry_state_anchor := mkEntryStateAnchor.

End CAN_043_EntryStateAnchor.

