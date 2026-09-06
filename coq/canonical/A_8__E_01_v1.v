(* A.8/E.01.v1 — CAN-208 — Definition — parents: A.8/M.01.v1 — occurrences 6 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-208 — root: root-weld (CAN-001) reading — domain: epistemic —
   tier: Definition (governing maxim) — occurrences: 1 *)
(** "No epistemic discrimination without provenance." Operational form:
    (i) what does the source distinguish; (ii) which distinction does the
    claim add; (iii) which provenance path licenses that addition — a
    design-principle [Prop] schema, not a theorem this finite model
    asserts to hold universally. *)
Definition CAN208_governing_maxim
  (Claim Distinction Path : Type)
  (distinguishes : Path -> Distinction -> Prop)
  (adds : Claim -> Distinction -> Prop)
  (licenses : Path -> Claim -> Prop) : Prop :=
  forall (c : Claim) (d : Distinction),
    adds c d -> exists p : Path, distinguishes p d /\ licenses p c.

