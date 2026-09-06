(* weld/E.05.v1 — CAN-033 — Definition — parents: weld/M.03.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-033 — root: constitutional-noncollapse (CAN-008) reading — domain:
   epistemic — tier: Definition — occurrences: 2 *)
(** chi_G in {1,0,bottom} (thirteen admission gates G0-G13); chi_t(d) in
    {FORCED, DERIVED, POSITED, BORROWED, OPEN} as a per-distinction
    provenance ledger — two finite, closed, decidable enumerations, the
    third value in each guarding against silently converting
    absence-of-evidence into pass or fail. *)
Inductive CAN033_GateOutcome := CAN033_Admitted3 | CAN033_Obstructed3 | CAN033_Unresolved3.
Inductive CAN033_Provenance :=
  CAN033_Forced | CAN033_Derived | CAN033_Posited | CAN033_Borrowed | CAN033_OpenProv.

Definition CAN033_gate_eq_dec : forall g1 g2 : CAN033_GateOutcome, {g1 = g2} + {g1 <> g2}.
Proof. decide equality. Defined.

Definition CAN033_prov_eq_dec : forall p1 p2 : CAN033_Provenance, {p1 = p2} + {p1 <> p2}.
Proof. decide equality. Defined.

Definition CAN033_Ledger (Distinction : Type) : Type := list (Distinction * CAN033_Provenance).

