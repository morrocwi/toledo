(* EQ-015/E.01.v1 — CAN-013 — Definition — parents: EQ-015/M.03.v1 — occurrences 4 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-013 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition — occurrences: 2 *)
(** State mapping: the same object as [MR_Foundation.v] eq.(2)
    ([Variable Psi_H], Section [Foundation1]) — restated under this id's
    own name (a Section [Variable] cannot be aliased across files), with
    its codomain literally reusing the imported [MeaningModes] record
    from [MR_Foundation.v], not a re-declared copy. *)
Section CAN013_MeaningGiving.
  Variables Readout HState Ctx Question : Type.
  Variable Psi_H_epi : Readout -> HState -> Ctx -> Question -> MeaningModes.
  Definition CAN013_meaning_giving := Psi_H_epi.
End CAN013_MeaningGiving.

