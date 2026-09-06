(* EQ-015/E.04.v1 — CAN-017 — Definition — parents: EQ-015/M.03.v1 — occurrences 11 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-017 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Th_coqc — occurrences: 2 *)
(** State mapping: literally [MR_Foundation.v]'s
    [eq5_experience_is_phenomenon_and_meaning_jointly] — a Th_coqc witness
    (generalised over the section's [X], [Gamma], [Ctx] carriers) that
    experience is a genuine joint reading of phenomenon and meaning, never
    collapsible onto either alone. Reused directly, instantiated at
    concrete carrier types to confirm it is not vacuous. *)
Definition CAN017_experience_joint_witness := eq5_experience_is_phenomenon_and_meaning_jointly.

Example CAN017_experience_joint_witness_on_bool :
  exists (Exp' : Type) (Phi_E' : bool -> MeaningModes -> bool -> bool -> Exp'),
    (forall x g c mu1 mu2, mu1 <> mu2 -> Phi_E' x mu1 g c <> Phi_E' x mu2 g c)
    /\ (forall x1 x2 g c mu, x1 <> x2 -> Phi_E' x1 mu g c <> Phi_E' x2 mu g c).
Proof. exact (CAN017_experience_joint_witness bool bool bool). Qed.

