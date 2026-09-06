(* weld/M.10.v1 — CAN-177 — Definition — parents: weld/M.02.v1 — occurrences 5 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-177 — root: domain-weld (CAN-006) — domain: method —
   tier: Definition — occurrences: 5 *)
Inductive CAN177_TheoryStage :=
  | CAN177_Phenomenon | CAN177_ExistingExplanations | CAN177_PreciseInadequacy
  | CAN177_Mechanism | CAN177_Boundary | CAN177_Propositions.
Inductive CAN177_EngineAStage :=
  | CAN177_PhenomenonA | CAN177_TheoreticalInadequacyA
  | CAN177_MechanismA | CAN177_ConceptualContributionA.
Inductive CAN177_EngineBStage :=
  | CAN177_PracticeB | CAN177_ObservationB | CAN177_InterventionB
  | CAN177_EvidenceB | CAN177_ImplementationB.
Definition CAN177_bridge (practice_delta_theory : bool) : bool := practice_delta_theory.
Lemma CAN177_bridge_iff : forall b, CAN177_bridge b = true <-> b = true.
Proof. intro b. unfold CAN177_bridge. tauto. Qed.

