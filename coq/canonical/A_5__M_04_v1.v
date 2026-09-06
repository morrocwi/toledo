(* A.5/M.04.v1 — CAN-197 — Open — parents: A.5/M.01.v1 — occurrences 1 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-197 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Open — occurrences: 1 *)
(** "Distinct knowledge topologies force distinct first-passage laws" is
    the paper's own central hypothesis — a general injectivity claim about
    an abstract map that no finite Coq model can decide without assuming
    it; recorded as an unproved [Prop] scaffold. *)
Definition CAN197_topology_sensitivity_Open
  (GraphTy LawTy : Type) (tau_law : GraphTy -> LawTy) : Prop :=
  forall g1 g2 : GraphTy, g1 <> g2 -> tau_law g1 <> tau_law g2.

