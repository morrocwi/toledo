(* EQ-015/E.05.v1 — CAN-019 — Definition — parents: EQ-015/M.03.v1 — occurrences 6 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-019 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition — occurrences: 2 *)
(** State mapping: the same object as [MR_Foundation.v] eq.(6)
    ([Variable L_H], Section [Naming]) — restated under this id's own name
    (Section [Variable], not aliasable across files); naming is typed as
    partial ([option Name]), [None] reading as "not yet stably named". *)
Section CAN019_NamingOperator.
  Variables Experience MeaningState HState Ctx Name : Type.
  Variable L_H_epi : Experience -> MeaningState -> HState -> Ctx -> option Name.
  Definition CAN019_naming_operator := L_H_epi.
End CAN019_NamingOperator.

