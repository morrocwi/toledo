(* EQ-002/E.01.v1 — CAN-010 — Definition — parents: EQ-002/M.03.v1 — occurrences 4 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-010 — root: root-readout-gate (CAN-201) read through the human
   register — domain: epistemic — tier: Definition — occurrences: 2 *)
(** State mapping: the same object as [MR_Foundation.v] eq.(1)
    ([Variable R_H], Section [Foundation1]), extended with the explicit
    question index "Before Meaning, Before Choice" adds
    (rho^H_n = R_H(x_n | H_n, c_n, Q_n)). A Section [Variable] discharges
    at [End Foundation1] and cannot be aliased across files, so the
    mapping is restated here, in the identical Section+Variables shape,
    under this family's own id rather than re-derived as a new claim. *)
Section CAN010_HumanReadoutInstance.
  Variables Phenom HState Ctx Question Readout : Type.
  Variable R_H_epi : Phenom -> HState -> Ctx -> Question -> Readout.
  Definition CAN010_human_readout := R_H_epi.
End CAN010_HumanReadoutInstance.

(** The bundled companion hypothesis (22410666:H2, "Reader dependence") is
    explicitly flagged [Open] by CANONICAL.json itself — recorded as an
    unproved [Prop] scaffold (a claim shape, not a theorem), never proved
    or upgraded here. *)
Definition CAN010_H2_reader_dependence_Open
  (Reader Judgment ReadoutTy : Type) (reads_as : Judgment -> Reader -> ReadoutTy -> Prop) : Prop :=
  forall j : Judgment, exists (r1 r2 : Reader) (z1 z2 : ReadoutTy),
    r1 <> r2 -> reads_as j r1 z1 -> reads_as j r2 z2 -> z1 <> z2.

