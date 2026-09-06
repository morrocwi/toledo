(* EQ-015/M.10.v1 — CAN-200 — Definition — parents: EQ-015/M.02.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-200 — root: root-stepper (CAN-003) — domain: method —
   tier: Definition / Th_coqc — occurrences: 2 *)
(** The protocol usability-burden vector as a typed [Record]; "optimal is
    not the same notion as adoptable" is witnessed by a two-constructor
    enumeration closed under [discriminate]. *)
Record CAN200_Burden := CAN200_mkBurden {
  can200_time : Q;
  can200_cogload : Q;
  can200_vercost : Q;
  can200_interrupt : Q;
  can200_literacy : Q
}.
Inductive CAN200_OptimalOrAdoptable := CAN200_EpistemicallyOptimal | CAN200_BehaviorallyAdoptable.
Theorem CAN200_optimal_ne_adoptable :
  CAN200_EpistemicallyOptimal <> CAN200_BehaviorallyAdoptable.
Proof. discriminate. Qed.
