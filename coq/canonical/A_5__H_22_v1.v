(* A.5/H.22.v1 -- not_yet_formalised -> open_prop -- Effort v0.3 Eq.32: NEW NON-COLLAPSE *)
(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)
(* \text{Exposure} \neq \text{Retained Revision} \neq \text{Certified Learning} \neq \text{Improvement} *)
(* Toledo v1.5 lane B (DEBT #45 part 2): finite-model open_prop --
   every symbol not already fixed by the statement above is a local
   Section Parameter (its type chosen only so the equation
   type-checks; nothing about what it computes is asserted).
   Unproved by design (Dr/Open source label). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.
From MRC Require Import _hrp_verdict_vocab.

Section A_5__H_22_v1_sec.
  Parameter Stage : Type.
  Parameter ExposureStage RetainedRevisionStage CertifiedLearningStage ImprovementStage : Stage.
  Definition A_5__H_22_v1_hyp : Prop :=
    ExposureStage <> RetainedRevisionStage /\
    RetainedRevisionStage <> CertifiedLearningStage /\
    CertifiedLearningStage <> ImprovementStage.
End A_5__H_22_v1_sec.
