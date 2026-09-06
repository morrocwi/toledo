(* EQ-015/E.10.v1 — CAN-028 — Dr — parents: EQ-015/M.02.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-028 — root: reader-equivalence (CAN-007) reading — domain:
   epistemic — tier: Open (empirical regime-transition law) —
   occurrences: 1 *)
(** Under unbounded external generation, production ceases to uniquely
    index internal organization; regime transition: accumulation ->
    discrimination. The regime classification is typed as a Definition;
    the causal claim ("production is no longer a unique indicator") is
    recorded as an unproved [Prop] scaffold — non-injectivity of the
    production map on the unbounded regime — never as a [Theorem]. *)
Inductive CAN028_Regime := CAN028_Accumulation | CAN028_Discrimination.

Definition CAN028_regime_transition_Open
  (GenerationRate InternalOrganization : Type)
  (unbounded : GenerationRate -> Prop)
  (production : GenerationRate -> InternalOrganization) : Prop :=
  exists g1 g2 : GenerationRate,
    unbounded g1 /\ unbounded g2 /\ g1 <> g2 /\ production g1 = production g2.

