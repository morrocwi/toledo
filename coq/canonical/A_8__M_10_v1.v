(* A.8/M.10.v1 — CAN-186 — finite_diagnostic — parents: A.8/M.01.v1 — occurrences 3 *)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
From MR Require Import MR_Resonance.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-186 — root: historical-invariance (CAN-009) — domain: method —
   tier: finite_diagnostic — occurrences: 3 *)
Inductive CAN186_CompoundingStage :=
  | CAN186_FlagshipConcept | CAN186_Preprint | CAN186_Conference
  | CAN186_Journal | CAN186_EmpiricalTest | CAN186_ComparativeExtension | CAN186_Grant.
Section CAN186_Leverage.
  Variables CreditEvents CoreInvestment eps186 : Q.
  Definition CAN186_credit_leverage : Q := CreditEvents / (CoreInvestment + eps186).

  (** PC_i is marked "(superseded)" by the source manuscript itself;
      recorded here only as a Definition, never promoted or reused as a
      live metric elsewhere in this pass. *)
  Variables JournalQuality ProgrammeFit ContributionStrength UptakePotential : Q.
  Definition CAN186_PC_superseded : Q :=
    JournalQuality * ProgrammeFit * ContributionStrength * UptakePotential.
End CAN186_Leverage.

