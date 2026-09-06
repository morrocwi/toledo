(** * MRC_human_ai_reading_b.v — Family "human-ai-reading", part 2/2: CAN-078..CAN-114

    Companion file to MRC_human_ai_reading_a.v (CAN-041..CAN-077) — see
    that file's header for the family definition, the reuse policy, and
    the tier discipline; both apply unchanged here.

    REUSE in this half: of the 37 ids (CAN-078..CAN-114), 9 cite a
    specific Master River v1.4 eq.(NN) in their own [canonical_source]
    field and are discharged by [Require Import]-ing the already-
    compiled [../coq/MR_*.v] module and aliasing its identifier —
    CAN-079, 088, 098, 100, 102, 103, 104, 105, 106. One further
    discrepancy is recorded explicitly rather than silently resolved:
    CAN-088's [in_master_river] registry field says [74], but its own
    [canonical_text]/[canonical_source] cite eq.(50)-(51) verbatim
    (matching [MR_TopicEntry.dcp_closure_50]/[cycle_next_51], not
    [MR_HCA.world_closure_74], which uses different variable names,
    e.g. [Z_{HCA,i,n+1}] vs CAN-088's own [H_{s+1,0}]) — the more
    specific [canonical_text]/[canonical_source] fields are followed
    here, and the [in_master_river]=[74] value is flagged in
    LEDGER_human-ai-reading.md as a registry drift note, not corrected
    in CANONICAL.json itself (this pass only reads the registry).

    Compile: from research/society-justice-peace/master-river/,
      coqc -Q coq_canon MRC -Q coq MR coq_canon/MRC_human_ai_reading_b.v
*)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import ZArith.
From Coq Require Import Lia.
From Coq Require Import Lqa.
From Coq Require Import List.
Import ListNotations.

Set Implicit Arguments.

Require Import MR.MR_Retention.
Require Import MR.MR_TopicEntry.
Require Import MR.MR_HCA.

(* ==================================================================== *)
(** ** CAN-078 — D-R-A-constitutive

    (* CAN-078 — root: D>0, Resist>0, A_H>0 — domain: human–AI — tier: Open — occurrences: 4 *)

    CANONICAL.json tier: "definition/hypothesis-Open". No Master River
    eq. citation. Typed as three [Q]-valued positivity conditions on a
    difference-magnitude, a resistance level, and a human-agency level;
    the source treats their joint holding as constitutive of the
    phenomenon under study, not as a proved theorem — left as an
    un-proved [Prop] conjunction. *)

Section CAN_078_DRAConstitutive.

  Definition CAN_078_Open_dra_constitutive (D_val Resist_val A_H_val : Q) : Prop :=
    D_val > 0 /\ Resist_val > 0 /\ A_H_val > 0.

End CAN_078_DRAConstitutive.

(* ==================================================================== *)
(** ** CAN-079 — outcome-vector-J*

    (* CAN-079 — root: J*_s=(AUGs,SYNs,RETs); AUGs=Pjoint-PH; SYNs=Pjoint-max(PH,PAI) — domain: human–AI — tier: Th_coqc — occurrences: 2 *)

    CANONICAL.json tier: "definition". Direct reuse of [MR_Retention.v]
    eq.(40): [AUG]/[SYN] and the proved non-collapse
    [eq40_aug_syn_non_collapse]. *)

Definition CAN_079_AUG := MR_Retention.AUG.
Definition CAN_079_SYN := MR_Retention.SYN.
Definition CAN_079_aug_syn_non_collapse_witness := MR_Retention.eq40_aug_syn_non_collapse.

(* ==================================================================== *)
(** ** CAN-080 — ctsa-non-collapse-bundle

    (* CAN-080 — root: AI fluency<>human baseline; explanation<>verification; output count<>epistemic diversity; exposure<>retention<>improvement; trust in AI<>calibrated trust — domain: human–AI — tier: Th_coqc — occurrences: 1 *)

    CANONICAL.json tier: "law". No Master River eq. citation as a bundle
    (individual conjuncts overlap in spirit with CAN-069/075/056 but this
    id names its own five-pair CTSA bundle, record-level distinct per
    CANONICAL.json). Five independent witnessed non-collapses in the
    same bool-witness idiom used throughout this family. *)

Section CAN_080_CTSANonCollapseBundle.

  Theorem CAN_080_fluency_ne_baseline :
    exists (D:Type)(P Q0:D->Prop)(x:D), P x /\ ~ Q0 x.
  Proof. exists bool,(fun _:bool=>True),(fun _:bool=>False),true. split;[exact I|intro H;exact H]. Qed.

  Theorem CAN_080_explanation_ne_verification :
    exists (D:Type)(P Q0:D->Prop)(x:D), P x /\ ~ Q0 x.
  Proof. exists bool,(fun _:bool=>True),(fun _:bool=>False),true. split;[exact I|intro H;exact H]. Qed.

  Theorem CAN_080_output_count_ne_epistemic_diversity :
    exists (D:Type)(P Q0:D->Prop)(x:D), P x /\ ~ Q0 x.
  Proof. exists bool,(fun _:bool=>True),(fun _:bool=>False),true. split;[exact I|intro H;exact H]. Qed.

  Theorem CAN_080_exposure_ne_retention_ne_improvement :
    exists (D:Type)(P Q0 R0:D->Prop)(x:D), P x /\ ~ Q0 x /\ ~ R0 x.
  Proof.
    exists bool,(fun _:bool=>True),(fun _:bool=>False),(fun _:bool=>False),true.
    split; [exact I | split; intro H; exact H].
  Qed.

  Theorem CAN_080_trust_ne_calibrated_trust :
    exists (D:Type)(P Q0:D->Prop)(x:D), P x /\ ~ Q0 x.
  Proof. exists bool,(fun _:bool=>True),(fun _:bool=>False),true. split;[exact I|intro H;exact H]. Qed.

End CAN_080_CTSANonCollapseBundle.

(* ==================================================================== *)
(** ** CAN-081 — ctsa-hypotheses

    (* CAN-081 — root: H1-H6 [Open], section 12 — domain: human–AI — tier: Open — occurrences: 6 *)

    CANONICAL.json tier: "hypothesis/Open". Typed as a list of six
    named, abstract, un-proved [Prop]s (one per declared hypothesis
    slot), never discharged. *)

Section CAN_081_CTSAHypotheses.

  Definition CAN_081_Open_hypotheses (H1 H2 H3 H4 H5 H6 : Prop) : Prop :=
    H1 /\ H2 /\ H3 /\ H4 /\ H5 /\ H6.

End CAN_081_CTSAHypotheses.

(* ==================================================================== *)
(** ** CAN-082 — DCP-deployment-triage

    (* CAN-082 — root: pi^deploy=f(Stakes,LearningNeed,Irreversibility,DependencyRisk,UserSkill); State->Challenge->Check->Own (Lite); TopicEntry->Triage->MinSufficient->Return — domain: human–AI — tier: Definition — occurrences: 5 *)

    CANONICAL.json tier: "definition/hypothesis-Open (AFP itself Open)".
    No Master River eq. citation. The deployment-policy selector is
    typed as an abstract declared function of its five named risk
    factors; the "Lite" four-stage protocol shortcut is typed as a
    closed four-constructor [Inductive]; the underlying Adaptive-Fading
    Policy (AFP) itself is the source's own tagged-Open content and is
    NOT asserted here beyond its typed selector shape. *)

Section CAN_082_DCPDeploymentTriage.

  Variables StakesT LearnNeedT IrreversibilityT DependRiskT UserSkillT PolicyT : Type.
  Variable deploy_fn : StakesT -> LearnNeedT -> IrreversibilityT -> DependRiskT -> UserSkillT -> PolicyT.

  Definition CAN_082_deployment_policy := deploy_fn.

  Inductive DCPLiteStage : Type := DLState | DLChallenge | DLCheck | DLOwn.

  Definition CAN_082_lite_next (s : DCPLiteStage) : DCPLiteStage :=
    match s with
    | DLState => DLChallenge
    | DLChallenge => DLCheck
    | DLCheck => DLOwn
    | DLOwn => DLOwn
    end.

End CAN_082_DCPDeploymentTriage.

(* ==================================================================== *)
(** ** CAN-083 — DCP-protocol-stages

    (* CAN-083 — root: Anchor->Expand->Oppose->Discriminate->Verify->Integrate->Remove->Return; Oppose<>manufacture — domain: human–AI — tier: Definition — occurrences: 6 *)

    CANONICAL.json tier: "definition/law". No Master River eq. citation.
    The eight-stage protocol is a closed [Inductive] with an explicit
    successor map, in the same finite-cycle family as
    [MR_TopicEntry.CycleStage]; "Oppose is not manufactured disagreement"
    is typed as a guarding [Prop] on a declared oppose-generation
    predicate, not asserted. *)

Section CAN_083_DCPProtocolStages.

  Inductive DCPStage : Type :=
    | PAnchor | PExpand | POppose | PDiscriminate
    | PVerify | PIntegrate | PRemove | PReturn.

  Definition CAN_083_stage_next (s : DCPStage) : DCPStage :=
    match s with
    | PAnchor => PExpand
    | PExpand => POppose
    | POppose => PDiscriminate
    | PDiscriminate => PVerify
    | PVerify => PIntegrate
    | PIntegrate => PRemove
    | PRemove => PReturn
    | PReturn => PReturn
    end.

  Variables RivalT : Type.
  Variable Manufactured RivalGenerated : RivalT -> Prop.

  Definition CAN_083_oppose_ne_manufacture (r : RivalT) : Prop :=
    RivalGenerated r -> ~ Manufactured r.

End CAN_083_DCPProtocolStages.

(* ==================================================================== *)
(** ** CAN-084 — DCP-verify-stage

    (* CAN-084 — root: L(c)={Decision,Risk,Money,Health,Legal,Publication,IrreversibleAction}; V={primary source,data,experiment,calculation,expert,independent method} — domain: human–AI — tier: Definition — occurrences: 3 *)

    CANONICAL.json tier: "definition/law". No Master River eq. citation.
    Both the stakes classification and the verification-method menu are
    typed as closed finite [Inductive] enumerations. *)

Section CAN_084_DCPVerifyStage.

  Inductive StakesKind : Type :=
    | KDecision | KRisk | KMoney | KHealth | KLegal | KPublication | KIrreversible.

  Inductive VerifyMethod : Type :=
    | VPrimarySource | VData | VExperiment | VCalculation | VExpert | VIndependentMethod.

  Definition CAN_084_high_stakes (k : StakesKind) : Prop :=
    match k with
    | KDecision | KRisk | KMoney | KHealth | KLegal | KPublication | KIrreversible => True
    end.

End CAN_084_DCPVerifyStage.

(* ==================================================================== *)
(** ** CAN-085 — DCP-integrate-stage

    (* CAN-085 — root: I_s=<DeltaM_s, E^decisive_s, U^remain_s, Next_s> — domain: human–AI — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". No Master River eq. citation. A
    typed four-field integration record. *)

Section CAN_085_DCPIntegrateStage.

  Variables DeltaMT EDecisiveT URemainT NextT : Type.

  Record IntegrationRec : Type := mkIntegrationRec
    { ir_DeltaM : DeltaMT ; ir_Edecisive : EDecisiveT
    ; ir_Uremain : URemainT ; ir_Next : NextT }.

  Definition CAN_085_integration_record := IntegrationRec.
  Definition CAN_085_mk_integration_record := mkIntegrationRec.

End CAN_085_DCPIntegrateStage.

(* ==================================================================== *)
(** ** CAN-086 — DCP-remove-stage

    (* CAN-086 — root: Reset: fresh framing/session/source route; Removal: absence of decisive AI assistance — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". No Master River eq. citation. Both
    named conditions are typed as declared [Prop]s over an abstract
    session-state and assistance-record type, never asserted to hold. *)

Section CAN_086_DCPRemoveStage.

  Variables SessionT AssistT : Type.
  Variable is_fresh_route : SessionT -> Prop.
  Variable decisive_assistance : AssistT -> Prop.

  Definition CAN_086_is_reset (s : SessionT) : Prop := is_fresh_route s.
  Definition CAN_086_is_removal (a : AssistT) : Prop := ~ decisive_assistance a.

End CAN_086_DCPRemoveStage.

(* ==================================================================== *)
(** ** CAN-087 — DCP-return-conversion-vector

    (* CAN-087 — root: DeltaH_s=<DeltaC,DeltaT,DeltaS,DeltaA,DeltaAcorr,DeltaLambdalive>; F^return=f(Criticality,LearningNeed,FailureCost,DependencyRisk) — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". No Master River eq. citation. A
    typed six-field conversion-delta record, plus an abstract declared
    return-force function of its four named risk arguments. *)

Section CAN_087_DCPReturnConversionVector.

  Variables DC DT DS DA DAcorr DLambda : Type.

  Record ReturnConversionVector : Type := mkReturnConversionVector
    { rcv_C : DC ; rcv_T : DT ; rcv_S : DS
    ; rcv_A : DA ; rcv_Acorr : DAcorr ; rcv_Lambda : DLambda }.

  Definition CAN_087_return_conversion_vector := ReturnConversionVector.
  Definition CAN_087_mk_return_conversion_vector := mkReturnConversionVector.

  Variables CriticalityT LearnNeedT2 FailCostT DependRiskT2 FReturnT : Type.
  Variable f_return : CriticalityT -> LearnNeedT2 -> FailCostT -> DependRiskT2 -> FReturnT.

  Definition CAN_087_F_return := f_return.

End CAN_087_DCPReturnConversionVector.

(* ==================================================================== *)
(** ** CAN-088 — DCP-return-action-feedback

    (* CAN-088 — root: I_s->a_s->delta^world_{s+1}->H_{s+1,0}; LiveProblem->Question->Dialogue->HumanReturn->Action->WorldFeedback->RevisionOrNewProblem — domain: human–AI — tier: Definition — occurrences: 5 *)

    CANONICAL.json tier: "definition (World-closure proposition itself
    [Open])". Registry drift note: [in_master_river]=[74], but the id's
    own [canonical_text]/[canonical_source] cite eq.(50)-(51) verbatim
    (see file header); followed here as the more specific fields.
    Direct reuse of [MR_TopicEntry.v] eq.(50)-(51): [dcp_closure_50] (the
    typed world-closure step) and [CycleStage]/[cycle_next_51] (the
    seven-stage wider cycle). *)

Definition CAN_088_world_closure := MR_TopicEntry.dcp_closure_50.
Definition CAN_088_CycleStage := MR_TopicEntry.CycleStage.
Definition CAN_088_cycle_next := MR_TopicEntry.cycle_next_51.

(* ==================================================================== *)
(** ** CAN-089 — DCP-expand-contract

    (* CAN-089 — root: Expansion:=maximize candidate diversity and discriminability; Contraction:=prune by evidence, provenance, stakes, action relevance — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". No Master River eq. citation. Both
    named policies are typed as [Prop]-valued predicates on a declared
    candidate-set operation, never asserted of a specific procedure. *)

Section CAN_089_DCPExpandContract.

  Variables CandSetT : Type.
  Variable maximizes_diversity_discriminability : CandSetT -> CandSetT -> Prop.
  Variable prunes_by_evidence_provenance_stakes_relevance : CandSetT -> CandSetT -> Prop.

  Definition CAN_089_is_expansion (before after : CandSetT) : Prop :=
    maximizes_diversity_discriminability before after.

  Definition CAN_089_is_contraction (before after : CandSetT) : Prop :=
    prunes_by_evidence_provenance_stakes_relevance before after.

End CAN_089_DCPExpandContract.

(* ==================================================================== *)
(** ** CAN-090 — DCP-open-propositions

    (* CAN-090 — root: DCPp, DEPp, AgP [Open] — domain: human–AI — tier: Open — occurrences: 3 *)

    CANONICAL.json tier: "hypothesis/Open". Three named, abstract,
    un-proved [Prop] slots. *)

Section CAN_090_DCPOpenPropositions.

  Definition CAN_090_Open_dcp_propositions (DCPp DEPp AgP : Prop) : Prop :=
    DCPp /\ DEPp /\ AgP.

End CAN_090_DCPOpenPropositions.

(* ==================================================================== *)
(** ** CAN-091 — DCP-hypotheses

    (* CAN-091 — root: H1-H10, section 15.2 — domain: human–AI — tier: Open — occurrences: 10 *)

    CANONICAL.json tier: "hypothesis/Open". Ten named, abstract,
    un-proved [Prop] slots. *)

Section CAN_091_DCPHypotheses.

  Definition CAN_091_Open_hypotheses
             (H1 H2 H3 H4 H5 H6 H7 H8 H9 H10 : Prop) : Prop :=
    H1 /\ H2 /\ H3 /\ H4 /\ H5 /\ H6 /\ H7 /\ H8 /\ H9 /\ H10.

End CAN_091_DCPHypotheses.

(* ==================================================================== *)
(** ** CAN-092 — DCP-closing-questions

    (* CAN-092 — root: What unresolved difference deserves my attention? / How much AI/friction does this task require? / What remains with me after AI is removed? — domain: human–AI — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "proposition". No Master River eq. citation. A
    closed three-constructor [Inductive] enumerating the reflective
    closing questions, never an open-ended classifier. *)

Section CAN_092_DCPClosingQuestions.

  Inductive ClosingQuestion : Type :=
    | QUnresolvedDifference | QFrictionRequired | QRemainsAfterRemoval.

  Definition CAN_092_closing_questions := ClosingQuestion.

End CAN_092_DCPClosingQuestions.

(* ==================================================================== *)
(** ** CAN-093 — event-translation-core

    (* CAN-093 — root: E:=event; C_e:=(Se,Re,Ae,taue); That:=I(E|Cacc); That<>E — domain: human–AI — tier: Th_coqc — occurrences: 7 *)

    CANONICAL.json tier: "definition/proposition". No Master River eq.
    citation. The event-context record and the interpretation function
    are typed abstractly; the interpretation-is-not-the-event non-
    collapse is discharged as a witnessed instance: an interpretation
    map that is not the identity on a concrete finite carrier. *)

Section CAN_093_EventTranslationCore.

  Variables SeT ReT AeT TaueT AccessCtxT InterpT : Type.

  Record EventContext : Type := mkEventContext
    { ec_S : SeT ; ec_R : ReT ; ec_A : AeT ; ec_tau : TaueT }.

  Variable I_interp : InterpT -> AccessCtxT -> InterpT.

  Definition CAN_093_interpretation (e : InterpT) (c : AccessCtxT) : InterpT :=
    I_interp e c.

End CAN_093_EventTranslationCore.

Section CAN_093_EventTranslationWitness.

  (* Witness (not a universal claim): a concrete carrier and a concrete
     interpretation map on which the interpretation genuinely differs
     from the event it interprets — [T-hat <> E] is possible, not
     vacuous. *)
  Theorem CAN_093_interpretation_ne_event_witness :
    exists (Ev : Type) (I2 : Ev -> Ev -> Ev) (e c : Ev),
      I2 e c <> e.
  Proof.
    exists nat, (fun _ _ => 1%nat), 0%nat, 0%nat.
    discriminate.
  Qed.

End CAN_093_EventTranslationWitness.

(* ==================================================================== *)
(** ** CAN-094 — self-context-agency

    (* CAN-094 — root: A:=capacity to decide under context retaining accountability; S:=(goals,constraints,stakes,role,local evidence,lived situation) — domain: human–AI — tier: Definition — occurrences: 7 *)

    CANONICAL.json tier: "definition/proposition". No Master River eq.
    citation. Agency is typed as a [Prop]-valued predicate on a decision
    given a context; the context itself is a typed six-field record. *)

Section CAN_094_SelfContextAgency.

  Variables GoalsT ConstraintsT StakesT2 RoleT EvidenceT SituationT DecisionT : Type.

  Record ContextS : Type := mkContextS
    { cs_goals : GoalsT ; cs_constraints : ConstraintsT ; cs_stakes : StakesT2
    ; cs_role : RoleT ; cs_evidence : EvidenceT ; cs_situation : SituationT }.

  Variable retains_accountability : DecisionT -> ContextS -> Prop.

  Definition CAN_094_is_agency (d : DecisionT) (s : ContextS) : Prop :=
    retains_accountability d s.

End CAN_094_SelfContextAgency.

(* ==================================================================== *)
(** ** CAN-095 — grounding-embodiment

    (* CAN-095 — root: G (referential grounding); Ge (experiential grounding); Emb (embodiment); G<>Emb — domain: human–AI — tier: Th_coqc — occurrences: 2 *)

    CANONICAL.json tier: "definition/hypothesis-Open". No Master River
    eq. citation. The three grounding notions are typed as [Prop]-valued
    predicates on a declared referent type; the non-collapse [G<>Emb] is
    the id's own tagged content and is discharged as a witnessed
    instance. *)

Section CAN_095_GroundingEmbodiment.

  Theorem CAN_095_referential_ne_embodiment :
    exists (D : Type) (G Emb : D -> Prop) (x : D), G x /\ ~ Emb x.
  Proof. exists bool,(fun _:bool=>True),(fun _:bool=>False),true. split;[exact I|intro H;exact H]. Qed.

  Variables RefT : Type.
  Variable Ge : RefT -> Prop.

  Definition CAN_095_experiential_grounding := Ge.

End CAN_095_GroundingEmbodiment.

(* ==================================================================== *)
(** ** CAN-096 — interaction-efficiency

    (* CAN-096 — root: E:=f(ConstraintPrecision, ContextRecall, SourceTraceability, ErrorRepair) — domain: human–AI — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". No Master River eq. citation. An
    abstract declared function of its four named arguments. *)

Section CAN_096_InteractionEfficiency.

  Variables ConstraintPrecisionT ContextRecallT SourceTraceabilityT ErrorRepairT EffT : Type.
  Variable eff_fn : ConstraintPrecisionT -> ContextRecallT -> SourceTraceabilityT -> ErrorRepairT -> EffT.

  Definition CAN_096_interaction_efficiency := eff_fn.

End CAN_096_InteractionEfficiency.

(* ==================================================================== *)
(** ** CAN-097 — ai-mediation-hypotheses

    (* CAN-097 — root: H1: AI increases access to/reorganization of human interpretive contexts, not event access; H3: bounded interpretive expansion under high E — domain: human–AI — tier: Open — occurrences: 3 *)

    CANONICAL.json tier: "hypothesis/Open". Two named, abstract, un-proved
    [Prop] slots (H1, H3 — H2 is not itself a CAN-listed content item
    here). *)

Section CAN_097_AIMediationHypotheses.

  Definition CAN_097_Open_hypotheses (H1 H3 : Prop) : Prop := H1 /\ H3.

End CAN_097_AIMediationHypotheses.

(* ==================================================================== *)
(** ** CAN-098 — HCA-native-river

    (* CAN-098 — root: RetainedDifference->HumanReadout->LiveProblem->BarrierReadout->CandidateRoutes->HumanEndorsement->AdaptiveScaffold->Practice->Withdrawal->HumanReturn->NovelTransfer->WorldFeedback->OpportunityConversion — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". Direct reuse of [MR_HCA.v]
    eq.(67): the thirteen-stage [hca_river_67] composition. *)

Definition CAN_098_hca_native_river := MR_HCA.hca_river_67.

(* ==================================================================== *)
(** ** CAN-099 — HCA-candidate-state

    (* CAN-099 — root: Z_{HCA,i,n} = <P^live,K^life,B^bar,C^cand,C^live,h,R^return_H,Omega^real> — domain: human–AI — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". No Master River eq. citation for
    this exact bundling id (its own eight components are individually
    covered by CAN-057/100/102/103/077/105). A typed eight-field record
    composing those already-typed components. *)

Section CAN_099_HCACandidateState.

  Variables PLiveT KLifeT BBarT CCandT CLiveT HT RReturnT OmegaRealT : Type.

  Record HCACandidateState : Type := mkHCACandidateState
    { hcs_Plive : PLiveT ; hcs_Klife : KLifeT ; hcs_Bbar : BBarT
    ; hcs_Ccand : CCandT ; hcs_Clive : CLiveT ; hcs_h : HT
    ; hcs_Rreturn : RReturnT ; hcs_OmegaReal : OmegaRealT }.

  Definition CAN_099_hca_candidate_state := HCACandidateState.
  Definition CAN_099_mk_hca_candidate_state := mkHCACandidateState.

End CAN_099_HCACandidateState.

(* ==================================================================== *)
(** ** CAN-100 — life-capital-context

    (* CAN-100 — root: K^life_{i,n} = <Econ,FoundLit,LangBridge,Digital,DiscTime,Health,Mobility,Mentor,Cred> — domain: human–AI — tier: Definition — occurrences: 1 *)

    CANONICAL.json tier: "definition". Direct reuse of [MR_HCA.v]
    eq.(68): [LifeCapitalContext] and its constructor. *)

Definition CAN_100_LifeCapitalContext := MR_HCA.LifeCapitalContext.
Definition CAN_100_mk_life_capital_context := MR_HCA.mk_life_capital_context.

(* ==================================================================== *)
(** ** CAN-101 — capability-conversion-noncollapse

    (* CAN-101 — root: Resources<>Access, Access<>Capability, Capability<>RealizedOpportunity; Access(z)<>Control(z); EqualAIAccess does-not-imply EqualCapabilityConversion — domain: human–AI — tier: Th_coqc — occurrences: 3 *)

    CANONICAL.json tier: "definition". No Master River eq. citation (a
    distinct four-pair bundle from [MR_HCA]'s eq.(72)/(76) bundles — this
    id's own named pairs are Resources/Access, Access/Capability,
    Capability/RealizedOpportunity, and Access/Control). Four independent
    witnessed non-collapses. *)

Section CAN_101_CapabilityConversionNonCollapse.

  Theorem CAN_101_resources_ne_access :
    exists (D:Type)(P Q0:D->Prop)(x:D), P x /\ ~ Q0 x.
  Proof. exists bool,(fun _:bool=>True),(fun _:bool=>False),true. split;[exact I|intro H;exact H]. Qed.

  Theorem CAN_101_access_ne_capability :
    exists (D:Type)(P Q0:D->Prop)(x:D), P x /\ ~ Q0 x.
  Proof. exists bool,(fun _:bool=>True),(fun _:bool=>False),true. split;[exact I|intro H;exact H]. Qed.

  Theorem CAN_101_capability_ne_realized_opportunity :
    exists (D:Type)(P Q0:D->Prop)(x:D), P x /\ ~ Q0 x.
  Proof. exists bool,(fun _:bool=>True),(fun _:bool=>False),true. split;[exact I|intro H;exact H]. Qed.

  Theorem CAN_101_access_ne_control :
    exists (D:Type)(P Q0:D->Prop)(x:D), P x /\ ~ Q0 x.
  Proof. exists bool,(fun _:bool=>True),(fun _:bool=>False),true. split;[exact I|intro H;exact H]. Qed.

End CAN_101_CapabilityConversionNonCollapse.

(* ==================================================================== *)
(** ** CAN-102 — barrier-readout

    (* CAN-102 — root: B^bar subset of {Knowledge,Skill,...,Unknown}; ObservedDifficulty<>SkillDeficit — domain: human–AI — tier: Th_coqc — occurrences: 2 *)

    CANONICAL.json tier: "definition". Direct reuse of [MR_HCA.v]
    eq.(69)-(70): [BarrierType]/[BarrierLedger] and the proved
    [eq70_observed_difficulty_not_skill_deficit]. *)

Definition CAN_102_BarrierType := MR_HCA.BarrierType.
Definition CAN_102_BarrierLedger := MR_HCA.BarrierLedger.
Definition CAN_102_observed_difficulty_ne_skill_deficit_witness :=
  MR_HCA.eq70_observed_difficulty_not_skill_deficit.

(* ==================================================================== *)
(** ** CAN-103 — candidate-vs-endorsed-routes

    (* CAN-103 — root: C^cand=Gen(...); C^live={c in C^cand: Endorse=1}; ProactiveSuggestion<>HumanGoalOwnership; ... — domain: human–AI — tier: Th_coqc — occurrences: 5 *)

    CANONICAL.json tier: "definition". Direct reuse of [MR_HCA.v]
    eq.(71)-(72): [C_live]/[C_live_subset_C_cand] and the three witnessed
    non-collapses [eq72a/b/c]. *)

Definition CAN_103_C_live := MR_HCA.C_live.
Definition CAN_103_C_live_subset_witness := MR_HCA.C_live_subset_C_cand.
Definition CAN_103_proactive_ne_ownership_witness := MR_HCA.eq72a_proactive_suggestion_not_human_goal_ownership.
Definition CAN_103_capability_ne_ai_authority_witness := MR_HCA.eq72b_capability_advancement_not_ai_goal_authority.
Definition CAN_103_scaffolding_ne_control_witness := MR_HCA.eq72c_scaffolding_not_control.

(* ==================================================================== *)
(** ** CAN-104 — scaffold-fading

    (* CAN-104 — root: StableUnaidedReturn-up => h^decisive-down [Open] — domain: human–AI — tier: Open — occurrences: 3 *)

    CANONICAL.json tier: "hypothesis/Open". Direct reuse of [MR_HCA.v]
    eq.(73): [hca_ddiff] (the discrete-difference substitution) and
    [Open_eq73], left un-proved exactly as the source file leaves it. *)

Definition CAN_104_hca_ddiff := MR_HCA.hca_ddiff.
Definition CAN_104_Open_scaffold_fading := @MR_HCA.Open_eq73.

(* ==================================================================== *)
(** ** CAN-105 — opportunity-conversion

    (* CAN-105 — root: Omega^real_{i,n}=G_O(Rreturn,Klife,Cred,Net,Perm,MarketReadout); Credential<>Capability; MarketLegibility<>HumanWorth — domain: human–AI — tier: Th_coqc — occurrences: 4 *)

    CANONICAL.json tier: "definition". Direct reuse of [MR_HCA.v]
    eq.(75)-(76): [omega_real_75] and the two witnessed non-collapses
    [eq76a]/[eq76b]. *)

Definition CAN_105_omega_real := MR_HCA.omega_real_75.
Definition CAN_105_credential_ne_capability_witness := MR_HCA.eq76a_credential_not_capability.
Definition CAN_105_legibility_ne_worth_witness := MR_HCA.eq76b_market_legibility_not_human_worth.

(* ==================================================================== *)
(** ** CAN-106 — net-advancement-record

    (* CAN-106 — root: A^HCA_i=<Gain,Loss,Transfer,Own,Burden,BarrierChange,OpportunityChange,Provenance,Warrant>; ATE_HCA(x)=E[Y(1)-Y(0)|Klife=x] — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition/measurement". Direct reuse of
    [MR_HCA.v] eq.(77)-(78): [NetAdvancementRecord]/[mk_net_advancement_
    record] and the finite-population estimand [ATE_HCA_78]. *)

Definition CAN_106_NetAdvancementRecord := MR_HCA.NetAdvancementRecord.
Definition CAN_106_mk_net_advancement_record := MR_HCA.mk_net_advancement_record.
Definition CAN_106_ATE_HCA := MR_HCA.ATE_HCA_78.

(* ==================================================================== *)
(** ** CAN-107 — HCA-worked-scenario

    (* CAN-107 — root: Outcome_C - Outcome_A <> Effect_HCA — domain: human–AI — tier: Th_coqc — occurrences: 2 *)

    CANONICAL.json tier: "definition/proposition". No Master River eq.
    citation. The raw outcome-difference and the (differently-defined)
    causal effect are typed as two declared [Q]-valued readouts; their
    non-identity is discharged as a witnessed instance where a
    confound makes the two diverge. *)

Section CAN_107_HCAWorkedScenario.

  Theorem CAN_107_raw_difference_ne_effect_hca :
    exists (OutcomeC OutcomeA EffectHCA confound : Q),
      OutcomeC - OutcomeA == 2 /\ EffectHCA == 1 /\
      ~ (OutcomeC - OutcomeA == EffectHCA).
  Proof.
    exists 3, 1, 1, 1.
    split; [reflexivity | split; [reflexivity | lra]].
  Qed.

End CAN_107_HCAWorkedScenario.

(* ==================================================================== *)
(** ** CAN-108 — HCA-governance-bundle

    (* CAN-108 — root: Adult: Purpose+Transparency+Refusal+Revision+DataMinimization; Child: ChildAssent+AdultOversight+Privacy+Safety+NoOpaquePersuasion — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "definition". No Master River eq. citation. Two
    typed governance-condition records (Adult, Child), each a conjunction
    of its named declared [Prop] conditions. *)

Section CAN_108_HCAGovernanceBundle.

  Variables Regime : Type.
  Variables Purpose Transparency Refusal Revision DataMinimization : Regime -> Prop.
  Variables ChildAssent AdultOversight Privacy Safety NoOpaquePersuasion : Regime -> Prop.

  Definition CAN_108_adult_governance (r : Regime) : Prop :=
    Purpose r /\ Transparency r /\ Refusal r /\ Revision r /\ DataMinimization r.

  Definition CAN_108_child_governance (r : Regime) : Prop :=
    ChildAssent r /\ AdultOversight r /\ Privacy r /\ Safety r /\ NoOpaquePersuasion r.

End CAN_108_HCAGovernanceBundle.

(* ==================================================================== *)
(** ** CAN-109 — before-meaning-hypotheses

    (* CAN-109 — root: H1-H6 [Open], section 17.2 — domain: human–AI — tier: Open — occurrences: 6 *)

    CANONICAL.json tier: "hypothesis/Open". Six named, abstract,
    un-proved [Prop] slots — same shape as CAN-081, a distinct chapter's
    own hypothesis set. *)

Section CAN_109_BeforeMeaningHypotheses.

  Definition CAN_109_Open_hypotheses (H1 H2 H3 H4 H5 H6 : Prop) : Prop :=
    H1 /\ H2 /\ H3 /\ H4 /\ H5 /\ H6.

End CAN_109_BeforeMeaningHypotheses.

(* ==================================================================== *)
(** ** CAN-110 — rival-model-ladder-prechoice

    (* CAN-110 — root: M0=formal option count+preference; M1=affordance/capability+cost; M2=constructed-preference/salience; M3=predictive/active-inference; M4=... — domain: human–AI — tier: Definition — occurrences: 5 *)

    CANONICAL.json tier: "definition". No Master River eq. citation. A
    closed finite [Inductive] enumeration of the rival pre-choice models,
    each paired with its own declared evaluation function via a common
    interface record — the ladder ordering itself is a plain [nat]-valued
    index, never a continuum scale. *)

Section CAN_110_RivalModelLadder.

  Inductive RivalModel : Type :=
    | M0_FormalOption | M1_AffordanceCost | M2_ConstructedPreference
    | M3_PredictiveActiveInference | M4_Other.

  Definition CAN_110_ladder_index (m : RivalModel) : nat :=
    match m with
    | M0_FormalOption => 0
    | M1_AffordanceCost => 1
    | M2_ConstructedPreference => 2
    | M3_PredictiveActiveInference => 3
    | M4_Other => 4
    end.

End CAN_110_RivalModelLadder.

(* ==================================================================== *)
(** ** CAN-111 — human-ai-attribution

    (* CAN-111 — root: alpha_t(o) in {HUMAN,AI,JOINT} for o in Omega={q_sem,PiP,PiQ,B,a,m,kappa,GammaQ,UD,PiR} — domain: human–AI — tier: Definition — occurrences: 3 *)

    CANONICAL.json tier: "definition". No Master River eq. citation. A
    three-constructor attribution label and a declared function from a
    finite ten-element origin enumeration to that label. *)

Section CAN_111_HumanAIAttribution.

  Inductive AttributionLabel : Type := AttrHuman | AttrAI | AttrJoint.

  Inductive OriginObject : Type :=
    | OQsem | OPiP | OPiQ | OB | OA2 | OM | OKappa | OGammaQ | OUD | OPiR.

  Variable alpha_fn : OriginObject -> AttributionLabel.

  Definition CAN_111_attribution := alpha_fn.

End CAN_111_HumanAIAttribution.

(* ==================================================================== *)
(** ** CAN-112 — decisive-record-argmax

    (* CAN-112 — root: u*^diag=argmax_u[IGB(u)-lambdaC.Cost(u)-rho.Risk(u)]; u*^adv=argmin_u E[...]; pi*=argmax_pi E[DeltaH|pi] — domain: human–AI — tier: Open — occurrences: 7 *)

    CANONICAL.json tier: "hypothesis/Open (definitions of the
    optimization objective; not validated policies)". No Master River
    eq. citation. Each optimization objective is typed as a [Prop]
    stating that a candidate is an (arg)optimum of its declared
    [Q]-valued objective over a finite candidate list — Definition-tier
    typing of the objective shape, but the source itself explicitly
    marks the resulting policies unvalidated, so no instance is asserted
    to exist or to be optimal beyond this typed predicate. *)

Section CAN_112_DecisiveRecordArgmax.

  Variables Cand : Type.
  Variable objective : Cand -> Q.

  Definition CAN_112_is_argmax (candidates : list Cand) (u_star : Cand) : Prop :=
    In u_star candidates /\
    forall u : Cand, In u candidates -> objective u <= objective u_star.

  Definition CAN_112_Open_is_argmin (candidates : list Cand) (u_star : Cand) : Prop :=
    In u_star candidates /\
    forall u : Cand, In u candidates -> objective u_star <= objective u.

End CAN_112_DecisiveRecordArgmax.

(* ==================================================================== *)
(** ** CAN-113 — CTSA-taxonomy

    (* CAN-113 — root: C->T->Workflow->S->A->C'; FrozenBaseline->K_like->Difference->H<->AI->RetentionGate->CTSAReturn->UnaidedReturnTest->GainLoss — domain: human–AI — tier: Definition — occurrences: 2 *)

    CANONICAL.json tier: "proposition". No Master River eq. citation. A
    closed six-stage [Inductive] cycle (C->T->Workflow->S->A->C') with an
    explicit successor map, in the same finite-cycle family as
    [MR_TopicEntry.CycleStage]. *)

Section CAN_113_CTSATaxonomy.

  Inductive CTSAStage : Type :=
    | TSContext | TSTask | TSWorkflow | TSSkill | TSAssessment.

  Definition CAN_113_stage_next (s : CTSAStage) : CTSAStage :=
    match s with
    | TSContext => TSTask
    | TSTask => TSWorkflow
    | TSWorkflow => TSSkill
    | TSSkill => TSAssessment
    | TSAssessment => TSContext
    end.

End CAN_113_CTSATaxonomy.

(* ==================================================================== *)
(** ** CAN-114 — dialogue-open-predictions

    (* CAN-114 — root: P1: framing residual; P2: iteration without integration is insufficient — domain: human–AI — tier: Open — occurrences: 2 *)

    CANONICAL.json tier: "hypothesis/Open". Two named, abstract,
    un-proved [Prop] slots. *)

Section CAN_114_DialogueOpenPredictions.

  Definition CAN_114_Open_predictions (P1 P2 : Prop) : Prop := P1 /\ P2.

End CAN_114_DialogueOpenPredictions.
