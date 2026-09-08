(* weld/M.14.v1 — CAN-216 — Dr — parents: weld/M.01.v1 — occurrences 2 *)

From Coq Require Import QArith.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.
Set Implicit Arguments.
From MRC Require Import MRC_Prelude.

(* CAN-216 — root: root-weld (CAN-001) — domain: method —
   tier: Dr — occurrences: 2 *)
(** The worked audit of a hidden extra access route: if a supposedly fixed
    background source [K*] is constant across two cases whose actual
    downstream process [C] differs (because [C] secretly also reads a
    retained record varying with the target alternative), then no
    factorisation [C = G o K*] can exist for any [G] — the converse
    failure mode of CAN-165's Factorization Theorem, proved once here
    (a two-line duplicate of [MRC_method_reading_a.v]'s
    [mr_no_factorization_when_fiber_varies], per this file's declared
    independent-sibling discipline). *)
Lemma mrb_no_factorization_when_fiber_varies :
  forall (X Y Z : Type) (K : X -> Y) (C : X -> Z) (x1 x2 : X),
    K x1 = K x2 -> C x1 <> C x2 -> ~ exists G : Y -> Z, forall x, C x = G (K x).
Proof.
  intros X Y Z K C x1 x2 Heq Hne [G HG].
  apply Hne. rewrite (HG x1), (HG x2), Heq. reflexivity.
Qed.

Definition CAN216_worked_no_factorization := @mrb_no_factorization_when_fiber_varies.

(* ==================================================================== *)
(** ** Group 5 — the shared method-domain non-collapse enumeration,
    instantiating CAN-230..256's 27-item credit/evidence guard-pair block
    ([registry/COLLAPSE.md]'s own count and name for this block) *)

(** One closed, finite enumeration of every named notion appearing in the
    27 "X<>Y" (or registry-classified-as-equivalent "X =/=> Y") pairs
    below. Coq's own constructor-disjointness makes every pairwise
    inequality below a one-line [discriminate] — no further coding or
    injectivity lemma is needed (a simplification over
    [MRC_epistemic_reading.v]'s nat-injective-coding device, which is not
    required here and so is not imported). *)
Inductive CAN2xx_MethodNotion :=
  | CAN2xx_Credit | CAN2xx_EpistemicValue
  | CAN2xx_Friction | CAN2xx_Fellowship
  | CAN2xx_SelfExperience | CAN2xx_GeneralEvidence
  | CAN2xx_PositionalAccess | CAN2xx_PopulationAuthority
  | CAN2xx_CommunityTrust | CAN2xx_Representativeness
  | CAN2xx_DVP | CAN2xx_K2
  | CAN2xx_ManyModels | CAN2xx_Independence
  | CAN2xx_MechanicalValidity | CAN2xx_SemanticValidity
  | CAN2xx_SourceExistence | CAN2xx_ClaimSupport
  | CAN2xx_Friendship | CAN2xx_IndependentEvidence
  | CAN2xx_Correspondence | CAN2xx_PeerReview
  | CAN2xx_IntellectualAffinity | CAN2xx_Truth
  | CAN2xx_ActivationAction | CAN2xx_CreditEvent
  | CAN2xx_RawSpeedDown | CAN2xx_VCDown
  | CAN2xx_LH | CAN2xx_LV
  | CAN2xx_MA_n | CAN2xx_ThetaE
  | CAN2xx_MultiAIConsensus | CAN2xx_GeographicCompleteness
  | CAN2xx_DoubleBlind | CAN2xx_Requirement
  | CAN2xx_K2Global | CAN2xx_K2Thai
  | CAN2xx_InterventionCreator | CAN2xx_SoleEvaluator
  | CAN2xx_PracticeExperience | CAN2xx_PopulationEvidence
  | CAN2xx_At | CAN2xx_CtScholarly
  | CAN2xx_MAttention | CAN2xx_MTruth | CAN2xx_MK2
  | CAN2xx_NoHumanAvailable | CAN2xx_ResearchStop
  | CAN2xx_Prestige | CAN2xx_APCApproval
  | CAN2xx_DisclosurePenalty | CAN2xx_Concealment
  | CAN2xx_AIContribution | CAN2xx_EpistemicResponsibility.

