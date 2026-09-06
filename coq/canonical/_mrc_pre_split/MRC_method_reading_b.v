(** * MRC_method_reading_b.v — Master River Canon, family: method-reading (part b)

    Companion file to [MRC_method_reading_a.v] (CAN-165..200) — see that
    file's header for the family's full assignment rationale, discipline
    statement, and reuse analysis (all of which apply here unchanged).
    This file is an independent sibling: it does not [Require]
    [MRC_method_reading_a.v] (matching the existing
    [MRC_human_ai_reading_a.v] / [_b.v] split, where the two halves are
    likewise independent). Part b covers CAN-210..216 (7 ids) and
    CAN-230..256 (27 ids) — 34 ids, the remainder of the 69-id method
    domain after part a's 35.

    REUSE (Master River eq. 1-79): none of these 34 ids restate Master
    River v1.3/v1.4 chapter content; every one is new content for this
    pass, sourced from the same credit/provenance/audit-layer manuscripts
    part a documents ("Rigour Without Infrastructure", "The Readout
    Condition", "State of Evidence for the Readout Hypothesis-Generation
    Programme", "The Standalone Scholar", "How Humans Should Converse with
    AI").

    Two small shared devices are re-declared locally in this file (a
    two-line duplication rather than a cross-file [Require] of
    [MRC_method_reading_a.v], per the independent-sibling discipline
    above): a factorization-failure lemma (CAN-216) and, for the 27-id
    "X<>Y" credit/evidence guard-pair block (CAN-230..256, plus the two
    embedded pairs in CAN-235/243/246/253 whose surface connective is
    "=/=>" rather than "<>" — [registry/COLLAPSE.md] itself tiers all of
    these "identity (non-collapse)", so this file follows the registry's
    own classification rather than manufacturing two different proof
    shapes for one underlying claim shape), one shared finite enumeration
    [CAN2xx_MethodNotion] whose constructors are pairwise distinct by
    Coq's own constructor-disjointness — closed by [discriminate] alone,
    with no injective-[nat]-coding indirection needed (a simplification
    over [MRC_epistemic_reading.v]'s device, noted there too).

    DISCIPLINE (Coq 8.20.1, information-discrete-math / readout-first): as
    stated in [MRC_method_reading_a.v]'s header — finite/discrete only, no
    [Coq.Reals], no classical axioms, no [Admitted], no top-level
    [Axiom]/[Parameter], every [Lemma]/[Theorem] Closed under the global
    context (see [LEDGER_method-reading.md]).
*)

From Coq Require Import QArith.
From Coq Require Import List.
From Coq Require Import Lia.
Import ListNotations.

Set Implicit Arguments.

(* ==================================================================== *)
(** ** Group 1 — the identification ladder and the typed augmentation
    grammar (CAN-210, CAN-211) *)

(* CAN-210 — root: domain-weld (CAN-006) — domain: method —
   tier: Definition / Th_coqc — occurrences: 2 *)
(** A nested ladder of admissible identification sets A0 subset A1 subset
    ... subset Am, read as a [bool] membership sequence per candidate
    point (true = still inside the set at that rung); [CAN210_level]
    locates the first rung the point falls out of by a finite (fuel-free,
    structurally recursive on the list) search, and the search is proved
    correct: the located index genuinely marks a rung with [false]
    membership. *)
Fixpoint CAN210_first_false (l : list bool) (idx : nat) : option nat :=
  match l with
  | [] => None
  | b :: rest => if b then CAN210_first_false rest (S idx) else Some idx
  end.

Definition CAN210_level (membership : list bool) : option nat :=
  CAN210_first_false membership 0.

Theorem CAN210_level_correct : forall l idx j,
  CAN210_first_false l idx = Some j -> (idx <= j)%nat /\ nth (j - idx) l true = false.
Proof.
  induction l as [| b rest IH]; intros idx j H.
  - simpl in H. discriminate.
  - simpl in H. destruct b eqn:Hb.
    + apply IH in H. destruct H as [Hle Hnth].
      split.
      * lia.
      * assert (Heq : (j - idx = S (j - S idx))%nat) by lia.
        rewrite Heq. simpl. exact Hnth.
    + injection H as Heq. subst j.
      split.
      * lia.
      * assert (Heq0 : (idx - idx = 0)%nat) by lia.
        rewrite Heq0. simpl. reflexivity.
Qed.

(* CAN-211 — root: constitutional-ordering (CAN-004) — domain: method —
   tier: Definition — occurrences: 4 *)
(** The source's own four-part taxonomy of ways an epistemic basis can be
    augmented (access, contrast/relevance, inferential commitment,
    decision-policy) as a closed finite [Inductive], pairwise distinct by
    construction. *)
Inductive CAN211_AugmentationKind :=
  | CAN211_AccessAug | CAN211_ContrastAug | CAN211_InferentialAug | CAN211_DecisionPolicyAug.

Theorem CAN211_kinds_pairwise_distinct :
  CAN211_AccessAug <> CAN211_ContrastAug
  /\ CAN211_ContrastAug <> CAN211_InferentialAug
  /\ CAN211_InferentialAug <> CAN211_DecisionPolicyAug
  /\ CAN211_AccessAug <> CAN211_DecisionPolicyAug.
Proof. repeat split; discriminate. Qed.

Section CAN211_Grammar.
  Variables Y1 Y2 Xty : Type.
  Definition CAN211_access_aug (y1 : Y1) (y2 : Y2) : Y1 * Y2 := (y1, y2).
  Definition CAN211_contrast_aug (Xsub : Xty -> Prop) : Xty -> Prop := Xsub.
  Variables DecisionState Action : Type.
  Variable decision_policy : DecisionState -> Action.
  Definition CAN211_decision_policy_aug := decision_policy.
End CAN211_Grammar.

(* ==================================================================== *)
(** ** Group 2 — provenance-adequacy norms and their two named failure
    modes (CAN-212, CAN-213) *)

(* CAN-212 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition / Th_coqc — occurrences: 3 *)
(** The Existence-Attribution-Disclosure triad: adequate provenance is
    exactly the conjunction of the three named norms, left abstract as
    Section [Prop]s (each is itself a further per-study predicate, not
    re-derived here); the introduction lemma confirms the conjunction is
    not vacuous. *)
Section CAN212_EAD.
  Variables ExistenceP AttributionP DisclosureP : Prop.
  Definition CAN212_adequate : Prop := ExistenceP /\ AttributionP /\ DisclosureP.
  Theorem CAN212_adequate_intro : ExistenceP -> AttributionP -> DisclosureP -> CAN212_adequate.
  Proof. intros; unfold CAN212_adequate; auto. Qed.
End CAN212_EAD.

(* CAN-213 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition / Th_coqc — occurrences: 2 *)
(** Epistemic overreach as a three-way disjunction; silent lift is
    defined as exactly its third disjunct (a concealed essential
    augmentation), so "silent lift implies overreach" is a genuine, if
    short, logical inclusion — not a re-tagging. *)
Section CAN213_Overreach.
  Variables LacksAdequatePath AttributedWithoutLicense ConcealsEssentialAugmentation : Prop.
  Definition CAN213_overreach : Prop :=
    LacksAdequatePath \/ AttributedWithoutLicense \/ ConcealsEssentialAugmentation.
  Definition CAN213_silent_lift : Prop := ConcealsEssentialAugmentation.
  Theorem CAN213_silent_lift_is_overreach : CAN213_silent_lift -> CAN213_overreach.
  Proof. intro H. unfold CAN213_overreach. right. right. exact H. Qed.
End CAN213_Overreach.

(* ==================================================================== *)
(** ** Group 3 — the essential-dependency set and its misrouted-defeat
    corollary (CAN-214) *)

(* CAN-214 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Definition / Th_coqc — occurrences: 3 *)
(** Ess(d) as a finite intersection (fold) over the declared dependency
    paths' vertex sets; the misrouted-defeat corollary — if the actual and
    represented essential sets differ at some node, the two sets are
    themselves unequal — is exactly the general fact "a witnessed
    asymmetric membership forces list inequality", proved once and
    generically. *)
Section CAN214_EssentialDependency.
  Variable Vertex : Type.
  Variable vertex_dec : forall a b : Vertex, {a = b} + {a <> b}.

  Definition CAN214_intersect (l1 l2 : list Vertex) : list Vertex :=
    filter (fun v => if in_dec vertex_dec v l2 then true else false) l1.

  Definition CAN214_Ess (default : list Vertex) (paths_V : list (list Vertex)) : list Vertex :=
    fold_right CAN214_intersect default paths_V.

  Theorem CAN214_misrouted_defeat :
    forall (Ess Ess_hat : list Vertex) (v : Vertex),
      In v Ess -> ~ In v Ess_hat -> Ess <> Ess_hat.
  Proof. intros Ess Ess_hat v Hin Hnin Heq. subst. contradiction. Qed.
End CAN214_EssentialDependency.

(* ==================================================================== *)
(** ** Group 4 — the worked base-rate audit and the retained-record
    contamination route (CAN-215, CAN-216) *)

(* CAN-215 — root: historical-invariance (CAN-009) — domain: method —
   tier: Th_coqc — occurrences: 2 *)
(** The worked Bayes example: P(D|+) = 0.90*0.01 / (0.90*0.01+0.09*0.99),
    checked exactly against its reduced fraction 10/109 (approx 0.0917) by
    a decidable [Q] computation, never a floating approximation. *)
Definition CAN215_p_D_given_pos : Q :=
  ((9#10) * (1#100)) / (((9#10) * (1#100)) + ((9#100) * (99#100))).

Theorem CAN215_bayes_value : Qeq_bool CAN215_p_D_given_pos (10#109) = true.
Proof. vm_compute. reflexivity. Qed.

(* CAN-216 — root: root-weld (CAN-001) — domain: method —
   tier: Th_coqc — occurrences: 2 *)
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

(* CAN-230 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN230_credit_not_epistemic_value : CAN2xx_Credit <> CAN2xx_EpistemicValue.
Proof. discriminate. Qed.

(* CAN-231 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN231_friction_not_fellowship : CAN2xx_Friction <> CAN2xx_Fellowship.
Proof. discriminate. Qed.

(* CAN-232 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN232_self_experience_not_general_evidence :
  CAN2xx_SelfExperience <> CAN2xx_GeneralEvidence.
Proof. discriminate. Qed.

(* CAN-233 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN233_positional_access_not_population_authority :
  CAN2xx_PositionalAccess <> CAN2xx_PopulationAuthority.
Proof. discriminate. Qed.

(* CAN-234 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN234_community_trust_not_representativeness :
  CAN2xx_CommunityTrust <> CAN2xx_Representativeness.
Proof. discriminate. Qed.

(* CAN-235 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 3 *)
(** Registry tier: "identity (non-collapse)" despite the source's own
    "=/=>" connective (DVP does not force reaching K2) — formalised, per
    the registry's own classification, as the same notion-distinctness
    shape as every other id in this block. *)
Theorem CAN235_dvp_not_k2 : CAN2xx_DVP <> CAN2xx_K2.
Proof. discriminate. Qed.

(* CAN-236 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN236_many_models_not_independence :
  CAN2xx_ManyModels <> CAN2xx_Independence.
Proof. discriminate. Qed.

(* CAN-237 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 3 *)
Theorem CAN237_mechanical_not_semantic_validity :
  CAN2xx_MechanicalValidity <> CAN2xx_SemanticValidity.
Proof. discriminate. Qed.

(* CAN-238 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 2 *)
Theorem CAN238_source_existence_not_claim_support :
  CAN2xx_SourceExistence <> CAN2xx_ClaimSupport.
Proof. discriminate. Qed.

(* CAN-239 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN239_friendship_not_independent_evidence :
  CAN2xx_Friendship <> CAN2xx_IndependentEvidence.
Proof. discriminate. Qed.

(* CAN-240 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN240_correspondence_not_peer_review :
  CAN2xx_Correspondence <> CAN2xx_PeerReview.
Proof. discriminate. Qed.

(* CAN-241 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN241_intellectual_affinity_not_truth :
  CAN2xx_IntellectualAffinity <> CAN2xx_Truth.
Proof. discriminate. Qed.

(* CAN-242 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN242_activation_action_not_credit_event :
  CAN2xx_ActivationAction <> CAN2xx_CreditEvent.
Proof. discriminate. Qed.

(* CAN-243 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN243_rawspeed_not_vc : CAN2xx_RawSpeedDown <> CAN2xx_VCDown.
Proof. discriminate. Qed.

(* CAN-244 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN244_lh_lv_not_truth :
  CAN2xx_LH <> CAN2xx_Truth /\ CAN2xx_LV <> CAN2xx_Truth.
Proof. split; discriminate. Qed.

(* CAN-245 — root: root-stepper (CAN-003) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN245_mission_stepper_not_theta : CAN2xx_MA_n <> CAN2xx_ThetaE.
Proof. discriminate. Qed.

(* CAN-246 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 2 *)
Theorem CAN246_multiai_consensus_not_geographic_completeness :
  CAN2xx_MultiAIConsensus <> CAN2xx_GeographicCompleteness.
Proof. discriminate. Qed.

(* CAN-247 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN247_doubleblind_bonus_not_requirement :
  CAN2xx_DoubleBlind <> CAN2xx_Requirement.
Proof. discriminate. Qed.

(* CAN-248 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 2 *)
Theorem CAN248_k2global_not_k2thai : CAN2xx_K2Global <> CAN2xx_K2Thai.
Proof. discriminate. Qed.

(* CAN-249 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 2 *)
Theorem CAN249_interventioncreator_not_soleevaluator :
  CAN2xx_InterventionCreator <> CAN2xx_SoleEvaluator.
Proof. discriminate. Qed.

(* CAN-250 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN250_practiceexperience_not_populationevidence :
  CAN2xx_PracticeExperience <> CAN2xx_PopulationEvidence.
Proof. discriminate. Qed.

(* CAN-251 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN251_at_not_ctscholarly : CAN2xx_At <> CAN2xx_CtScholarly.
Proof. discriminate. Qed.

(* CAN-252 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN252_mattention_not_mtruth_mk2 :
  CAN2xx_MAttention <> CAN2xx_MTruth /\ CAN2xx_MAttention <> CAN2xx_MK2.
Proof. split; discriminate. Qed.

(* CAN-253 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
Theorem CAN253_nohuman_not_researchstop :
  CAN2xx_NoHumanAvailable <> CAN2xx_ResearchStop.
Proof. discriminate. Qed.

(* CAN-254 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Definition — occurrences: 1 *)
(** Governance-definition tier per the registry (not "identity"): the
    distinctness half is offered as Th_coqc-grade scaffolding on the
    shared enumeration; the conditional requirement chain is a typed,
    unproved [Prop] (a governance rule, not a theorem). *)
Theorem CAN254_prestige_not_apc_approval : CAN2xx_Prestige <> CAN2xx_APCApproval.
Proof. discriminate. Qed.

Section CAN254_ApprovalChain.
  Variables FieldFit CreditYield BudgetFit APCApprovalHolds : Prop.
  Definition CAN254_approval_requires : Prop :=
    APCApprovalHolds -> FieldFit /\ CreditYield /\ BudgetFit.
End CAN254_ApprovalChain.

(* CAN-255 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Definition — occurrences: 1 *)
Theorem CAN255_disclosurepenalty_not_concealment :
  CAN2xx_DisclosurePenalty <> CAN2xx_Concealment.
Proof. discriminate. Qed.

Section CAN255_PenaltyChain.
  Variables BetterProvenance BetterHumanDefence VenueFit DisclosurePenaltyHolds : Prop.
  Definition CAN255_penalty_requires : Prop :=
    DisclosurePenaltyHolds -> BetterProvenance /\ BetterHumanDefence /\ VenueFit.
End CAN255_PenaltyChain.

(* CAN-256 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 2 *)
Theorem CAN256_aicontribution_not_epistemicresponsibility :
  CAN2xx_AIContribution <> CAN2xx_EpistemicResponsibility.
Proof. discriminate. Qed.
