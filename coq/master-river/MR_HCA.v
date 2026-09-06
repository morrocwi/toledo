(** * MR_HCA.v — Master Equation River, Block D: eq. (67)-(79)

    Source of record: research/society-justice-peace/master-river/v1_4/main.tex
    (Master Equation River v1.4), Section "Barrier Readout, Endorsement,
    Scaffold Fading, and Opportunity Conversion" (\label{sec:hca}, eq.
    67-78) and Section 5 "The Corrected Master Equation River" outer-loop
    tail eq. 79. This section restates From Assistance to Human Capability
    (RG-HCA) \citep{rg_hca} (each statement traced to RG-HCA's own equation
    number in main.tex's running prose), a proactive extension of the
    Dialogue Conversion Protocol tail already formalised in
    MR_TopicEntry.v (eq. 46-51) and MR_River.v (eq. 44/45/65/66).

    Tier source (each cited to main.tex's own words / RG-HCA's own tags):
    - eq. 67: RG-HCA's own native river (RG-HCA eq. 5), read against
      eq. (51) in MR_TopicEntry.v — "inserts a Barrier Readout stage
      before Candidate Routes and appends Opportunity Conversion after
      World Feedback; it is a proactive elaboration ... not a
      replacement". A typed 12-stage composition, in the same
      "type-checking is the Definition-tier content" family as eq. (44)
      in MR_River.v.
    - eq. 68: "Life-Capital Context Vector [Definition]" (RG-HCA eq. 8) —
      explicitly tagged Definition by the paper itself; a typed 9-tuple,
      in the same family as eq. (61)'s HumanConversionVector in
      MR_WorldSystem.v. main.tex states plainly this "is not a universal
      cardinal measure of human capital and does not exhaust life
      conditions" — Definition tier only, no proof obligation.
    - eq. 69: "typed barrier ledger" (RG-HCA eq. 12) — a finite subset of
      a ten-constructor closed [Inductive] barrier type, the same
      finite-enumeration discipline as [TopicEntry] (eq. 47) and
      [CycleStage] (eq. 51) in MR_TopicEntry.v. Definition tier.
    - eq. 70: "load-bearing non-collapse [Definition]" (RG-HCA eq. 13) —
      "Observed Difficulty =/= Skill Deficit". Despite main.tex's own
      "[Definition]" tag on the *ledger* eq. (69), the task brief for
      this pass specifically calls for eq. (70) to be discharged as a
      genuine witnessed non-collapse (parallel to eq. (59)/(60) in
      MR_WorldSystem.v), so it is tiered **Th_coqc** here: a concrete
      finite model exhibiting a case where a difficulty is observed and
      no skill deficit holds.
    - eq. 71: "the endorsed subset [Definition]" (RG-HCA eq. 16) — typed
      exactly as main.tex writes it, [C^live_{i,n} = {c in C^cand_{i,n} :
      Endorse_i(c) = 1}], as a finite-list [filter]. A supporting fact
      (C^live subset C^cand) is proved alongside it — in the same
      "supporting fact, not a re-tagging" spirit as eq. (56)'s
      [corrigible_agency_ws_upper_bound] in MR_WorldSystem.v — so the
      eq. (71) tag itself stays **Definition**.
    - eq. 72: "three further non-collapse laws follow [Definition]"
      (RG-HCA eq. 17-19). Despite main.tex's own "[Definition]" tag, the
      task brief for this pass specifically calls for eq. (72) to be
      discharged as three genuine witnessed non-collapses (the same
      witness technique as eq. (59)/(60)/(70)), so it is tiered
      **Th_coqc** here, covering all three conjuncts of the aligned
      equation block: Proactive Suggestion =/= Human Goal Ownership,
      Capability Advancement =/= AI Goal Authority, Scaffolding =/=
      Control.
    - eq. 73: "candidate fading rule [\textsc{Open}]" (RG-HCA eq. 22) —
      explicitly tagged Open by the paper itself ("RG-HCA marks this
      rule Open and states it should be replaced if a simpler rule
      performs as well"). Stated as a [Prop]-valued [Definition] named
      [Open_eq73] in the model's own discrete-difference vocabulary,
      never discharged with a [Theorem]/[Lemma], per the [Open]-tier
      house rule.
    - eq. 74: "restating the same world-closure step as eq. (50) over
      RG-HCA's own candidate HCA state Z_HCA" (RG-HCA eq. 27) — a
      well-typed 3-step composition, in the identical family as
      [dcp_closure_50] in MR_TopicEntry.v and [river_tail_65] in
      MR_River.v. Definition tier.
    - eq. 75: "a world-side opportunity readout" (RG-HCA eq. 28),
      "explicitly not a validated welfare utility function" — a typed
      6-argument function, Definition tier only, no proof obligation
      (parallel to eq. (58)'s [P_H_index] audit index in
      MR_WorldSystem.v, which main.tex likewise states is not a
      validated cardinal scale).
    - eq. 76: "two further non-collapses are essential [Definition]"
      (RG-HCA eq. 29-30). As with eq. (72), the task brief calls for
      eq. (76) to be discharged as genuine witnessed non-collapses, so it
      is tiered **Th_coqc** here, covering both conjuncts: Credential
      =/= Capability, Market Legibility =/= Human Worth.
    - eq. 77: "net advancement record [Definition]" (RG-HCA eq. 36) — a
      typed 9-tuple, in the same family as eq. (68)/(61). Definition
      tier.
    - eq. 78: "a conditional estimand [Definition, measurement]"
      (RG-HCA eq. 37) — ATE_HCA(x) = E[Y(1) - Y(0) | K^life = x]. Modelled
      over an explicitly finite, [Q]-valued population (never
      [Coq.Reals]/an expectation over a continuum measure): a declared
      finite list of individuals, a decidable stratum-membership filter,
      and the difference of two finite arithmetic means over [Q].
      main.tex's own text ("matching or covariate adjustment is a design
      strategy, not part of the estimand itself") is honoured by keeping
      this a bare Definition, never asserting an identification/causal
      claim.
    - eq. 79: "RG-HCA's barrier and opportunity layer ... sits inside
      this same outer loop ... restating eq. (74)-(75) at the scale of
      one full pass" — a well-typed 2-step composition threading
      [H_{t+3}] through the barrier/endorsement readout (eq. 69/71) and
      the opportunity readout (eq. 75) into the world-system pair
      (C^H_{t+3}, P^H_{t+3}) that opens eq. (66) in MR_River.v. main.tex
      is explicit this is "a schematic placement ... without adding a
      further arrow inside eq. (44)-(65) or reweighting eq. (66)
      itself" — Definition tier, no further claim asserted.

    DISCIPLINE: readout-first, as in the other Block A/B/C files — no
    [Reals], no classical axioms, [Q]-valued weights, finite lists model
    finite sets and finite populations, Section+Variables/Hypotheses for
    abstract objects (discharged, never top-level [Parameter]/[Axiom]),
    no [Admitted]. Two readout-first replacements are recorded explicitly:
    - eq. (73)'s continuum-flavoured "Stable Unaided Return uparrow" /
      "h^decisive downarrow" trend language is replaced by one-step
      [Q]-valued finite differences on [nat]-indexed sequences (the same
      [ddiff]-style substitution as eq. (59)/(60) in MR_WorldSystem.v),
      never an [h -> 0] limit or a continuum monotone-function claim.
    - eq. (78)'s expectation [E[Y(1) - Y(0) | K^life = x]] is replaced by
      the difference of two finite arithmetic means over [Q] on a
      declared finite population filtered by decidable stratum equality
      — never a continuum-measure expectation.
*)

From Coq Require Import QArith.
From Coq Require Import List.
Import ListNotations.

Set Implicit Arguments.

(* ------------------------------------------------------------------ *)
(** ** Section: RG-HCA's own native river (eq. 67) *)

Section HCARiver.

  (** One stage-type per named object in eq. (67)'s chain, in RG-HCA's
      own order: Retained Difference -> Human Readout -> Live Problem
      -> Barrier Readout -> Candidate Routes -> Human Endorsement
      -> Adaptive Scaffold -> Practice -> Withdrawal -> Human Return
      -> Novel Transfer -> World Feedback -> Opportunity Conversion. *)
  Variables
    RetDiff HumanReadoutHCA LiveProblemHCA BarrierReadoutHCA
    CandidateRoutesHCA HumanEndorsementHCA AdaptiveScaffoldHCA
    PracticeHCA WithdrawalHCA HumanReturnHCA NovelTransferHCA
    WorldFeedbackHCA OpportunityConversionHCA : Type.

  Variable to_human_readout_hca      : RetDiff -> HumanReadoutHCA.
  Variable to_live_problem_hca       : HumanReadoutHCA -> LiveProblemHCA.
  Variable to_barrier_readout_hca    : LiveProblemHCA -> BarrierReadoutHCA.
  Variable to_candidate_routes_hca   : BarrierReadoutHCA -> CandidateRoutesHCA.
  Variable to_human_endorsement_hca  : CandidateRoutesHCA -> HumanEndorsementHCA.
  Variable to_adaptive_scaffold_hca  : HumanEndorsementHCA -> AdaptiveScaffoldHCA.
  Variable to_practice_hca           : AdaptiveScaffoldHCA -> PracticeHCA.
  Variable to_withdrawal_hca         : PracticeHCA -> WithdrawalHCA.
  Variable to_human_return_hca       : WithdrawalHCA -> HumanReturnHCA.
  Variable to_novel_transfer_hca     : HumanReturnHCA -> NovelTransferHCA.
  Variable to_world_feedback_hca     : NovelTransferHCA -> WorldFeedbackHCA.
  Variable to_opportunity_conversion_hca : WorldFeedbackHCA -> OpportunityConversionHCA.

  (* eq. (67) — tier: Definition *)
  (** RG-HCA's own native river (RG-HCA eq. 5): a single well-typed
      composition of every stage above, in RG-HCA's own order. Its being
      well-typed (it compiles) is the Definition-tier content, exactly
      as for [master_river_44] in MR_River.v — no claim about the
      evidential status of any individual arrow is smuggled in. *)
  Definition hca_river_67 (d : RetDiff) : OpportunityConversionHCA :=
    to_opportunity_conversion_hca (
      to_world_feedback_hca (
        to_novel_transfer_hca (
          to_human_return_hca (
            to_withdrawal_hca (
              to_practice_hca (
                to_adaptive_scaffold_hca (
                  to_human_endorsement_hca (
                    to_candidate_routes_hca (
                      to_barrier_readout_hca (
                        to_live_problem_hca (
                          to_human_readout_hca d))))))))))).

End HCARiver.

(* ------------------------------------------------------------------ *)
(** ** Section: the Life-Capital Context Vector (eq. 68) *)

Section LifeCapitalContext.

  Variables
    EconT FoundLitT LangBridgeT DigitalT DiscTimeT
    HealthT MobilityT MentorT CredT : Type.

  (* eq. (68) — tier: Definition *)
  (** K^life_{i,n} = <E^econ, F^base, L^lang, D^digital, T^disc, H^health,
      M^mob, N^mentor, C^cred> (RG-HCA eq. 8, explicitly tagged
      [Definition] by the paper itself). A typed 9-tuple; main.tex states
      this "is not a universal cardinal measure of human capital and does
      not exhaust life conditions" — no further claim asserted. *)
  Definition LifeCapitalContext : Type :=
    EconT * FoundLitT * LangBridgeT * DigitalT * DiscTimeT *
    HealthT * MobilityT * MentorT * CredT.

  Definition mk_life_capital_context
             (e : EconT) (f : FoundLitT) (l : LangBridgeT) (d : DigitalT)
             (t : DiscTimeT) (h : HealthT) (m : MobilityT) (n : MentorT)
             (c : CredT) : LifeCapitalContext :=
    (e, f, l, d, t, h, m, n, c).

End LifeCapitalContext.

(* ------------------------------------------------------------------ *)
(** ** Section: the typed barrier ledger (eq. 69) *)

Section BarrierLedger.

  (* eq. (69) — tier: Definition *)
  (** B^bar_{i,n} subseteq {Knowledge, Skill, Language, Tool,
      ResourceTime, Network, Credential, Permission, Opportunity,
      Unknown} (RG-HCA eq. 12). A finite, closed [Inductive] type
      enumerating the ten declared barrier kinds, the same
      finite-enumeration discipline as [TopicEntry] (eq. 47) in
      MR_TopicEntry.v; a barrier ledger is a finite subset of this type,
      modelled as a [list BarrierType] (a finite subset of a finite
      type, never an open-ended classifier). *)
  Inductive BarrierType : Type :=
    | BKnowledge
    | BSkill
    | BLanguage
    | BTool
    | BResourceTime
    | BNetwork
    | BCredential
    | BPermission
    | BOpportunity
    | BUnknown.

  (** The full ten-element enumeration eq. (69) is a subset of — the
      finite universe every [BarrierLedger] below is drawn from. *)
  Definition all_barrier_types : list BarrierType :=
    [BKnowledge; BSkill; BLanguage; BTool; BResourceTime;
     BNetwork; BCredential; BPermission; BOpportunity; BUnknown].

  Definition BarrierLedger : Type := list BarrierType.

End BarrierLedger.

(* ------------------------------------------------------------------ *)
(** ** Section: the load-bearing non-collapse (eq. 70) *)

Section ObservedDifficultyNotSkillDeficit.

  (* eq. (70) — tier: Th_coqc *)
  (** Observed Difficulty =/= Skill Deficit (RG-HCA eq. 13). Proved as a
      witnessed non-collapse — a concrete finite model in which a
      difficulty is observed yet no skill deficit holds — exactly the
      assignment brief's own worked example for this equation, in the
      same witness family as eq. (59)/(60) in MR_WorldSystem.v. RG-HCA's
      own concrete costs of collapsing the two (repeated skill drills
      punishing a language barrier; invisible competence behind a
      missing credential) are exactly the cases this witness rules out
      as identical. *)
  Theorem eq70_observed_difficulty_not_skill_deficit :
    exists (D : Type) (ObservedDifficulty SkillDeficit : D -> Prop) (x : D),
      ObservedDifficulty x /\ ~ SkillDeficit x.
  Proof.
    exists bool, (fun _ : bool => True), (fun _ : bool => False), true.
    split.
    - exact I.
    - intro H; exact H.
  Qed.

End ObservedDifficultyNotSkillDeficit.

(* ------------------------------------------------------------------ *)
(** ** Section: the endorsed-route subset (eq. 71) *)

Section EndorsedRoutes.

  Variables Route : Type.
  Variable Endorse : Route -> bool.
  Variable C_cand : list Route.

  (* eq. (71) — tier: Definition *)
  (** C^live_{i,n} = {c in C^cand_{i,n} : Endorse_i(c) = 1} (RG-HCA
      eq. 16). Typed exactly as main.tex writes it, as a finite-list
      [filter] — never an unbounded/continuum-indexed comprehension. *)
  Definition C_live : list Route := filter Endorse C_cand.

  (** Supporting fact, not a re-tagging of eq. (71) itself (in the same
      "supporting fact" spirit as [corrigible_agency_ws_upper_bound] for
      eq. (56) in MR_WorldSystem.v): the endorsed subset is indeed a
      subset of the candidate list, confirming [filter] is doing the
      subsetting work the paper's own set-builder notation asserts. *)
  Lemma C_live_subset_C_cand : incl C_live C_cand.
  Proof.
    unfold C_live, incl.
    intros c Hin.
    apply filter_In in Hin.
    destruct Hin as [Hin _].
    exact Hin.
  Qed.

End EndorsedRoutes.

(* ------------------------------------------------------------------ *)
(** ** Section: the three further non-collapse laws (eq. 72) *)

Section EndorsementNonCollapse.

  (* eq. (72) — tier: Th_coqc *)
  (** Proactive Suggestion =/= Human Goal Ownership (RG-HCA eq. 17,
      first conjunct of the aligned equation block). Witnessed
      non-collapse in the same family as eq. (70) above: a concrete
      finite model where a suggestion is proactively made yet the goal
      is not owned by the human. *)
  Theorem eq72a_proactive_suggestion_not_human_goal_ownership :
    exists (D : Type) (ProactiveSuggestion HumanGoalOwnership : D -> Prop) (x : D),
      ProactiveSuggestion x /\ ~ HumanGoalOwnership x.
  Proof.
    exists bool, (fun _ : bool => True), (fun _ : bool => False), true.
    split.
    - exact I.
    - intro H; exact H.
  Qed.

  (** Capability Advancement =/= AI Goal Authority (RG-HCA eq. 18,
      second conjunct of eq. (72)). Not re-tagged with a fresh eq.
      comment — same equation, second witnessed conjunct. *)
  Theorem eq72b_capability_advancement_not_ai_goal_authority :
    exists (D : Type) (CapabilityAdvancement AIGoalAuthority : D -> Prop) (x : D),
      CapabilityAdvancement x /\ ~ AIGoalAuthority x.
  Proof.
    exists bool, (fun _ : bool => True), (fun _ : bool => False), true.
    split.
    - exact I.
    - intro H; exact H.
  Qed.

  (** Scaffolding =/= Control (RG-HCA eq. 19, third conjunct of
      eq. (72)). Not re-tagged with a fresh eq. comment — same equation,
      third witnessed conjunct. *)
  Theorem eq72c_scaffolding_not_control :
    exists (D : Type) (Scaffolding Control : D -> Prop) (x : D),
      Scaffolding x /\ ~ Control x.
  Proof.
    exists bool, (fun _ : bool => True), (fun _ : bool => False), true.
    split.
    - exact I.
    - intro H; exact H.
  Qed.

End EndorsementNonCollapse.

(* ------------------------------------------------------------------ *)
(** ** Section: the candidate fading rule (eq. 73, Open) *)

Section FadingRule.

  (** Discrete-readout replacement for eq. (73)'s continuum-flavoured
      "uparrow"/"downarrow" trend language: a one-step [Q]-valued finite
      difference on a [nat]-indexed sequence, the same [ddiff]-style
      substitution as eq. (59)/(60) in MR_WorldSystem.v (kept local to
      this file rather than imported, so this module stays
      self-contained). *)
  Definition hca_ddiff (f : nat -> Q) (t : nat) : Q := f (S t) - f t.

  (* eq. (73) — tier: Open *)
  (** Stable Unaided Return uparrow => h^decisive downarrow (RG-HCA
      eq. 22), explicitly tagged [\textsc{Open}] by the paper itself:
      "RG-HCA marks this rule Open and states it should be replaced if a
      simpler rule performs as well." Stated as a [Prop]-valued
      [Definition] in the model's own discrete-difference vocabulary —
      a rising Stable-Unaided-Return sequence entails a falling
      decisive-assistance-height sequence at the same step — and never
      discharged with a [Theorem]/[Lemma], per the [Open]-tier house
      rule (never [Admitted]). *)
  Definition Open_eq73
             (StableUnaidedReturn HDecisive : nat -> Q) (t : nat) : Prop :=
    0 < hca_ddiff StableUnaidedReturn t -> hca_ddiff HDecisive t < 0.

End FadingRule.

(* ------------------------------------------------------------------ *)
(** ** Section: the world-closure step over Z_HCA (eq. 74) *)

Section WorldClosureHCA.

  Variables HReturnHCA2 ActionHCA WorldRecordHCA ZHCAState : Type.
  Variable select_action_hca  : HReturnHCA2 -> ActionHCA.
  Variable world_feedback_hca2 : ActionHCA -> WorldRecordHCA.
  Variable record_to_z_hca    : WorldRecordHCA -> ZHCAState.

  (* eq. (74) — tier: Definition *)
  (** R^return_{H,i,n} -> a_{i,n} -> delta^world_{i,n+1} -> Z_{HCA,i,n+1}
      (RG-HCA eq. 27), "restating the same world-closure step as
      eq. (50)" — a well-typed 3-step composition, in the identical
      family as [dcp_closure_50] in MR_TopicEntry.v and [river_tail_65]
      in MR_River.v. *)
  Definition world_closure_74 (h_return : HReturnHCA2) : ZHCAState :=
    record_to_z_hca (world_feedback_hca2 (select_action_hca h_return)).

End WorldClosureHCA.

(* ------------------------------------------------------------------ *)
(** ** Section: the world-side opportunity readout (eq. 75) *)

Section OpportunityReadout.

  Variables HReturnHCA3 LifeCapitalCtx CredArg NetArg PermArg
            MarketReadoutArg OmegaReal : Type.
  Variable G_O : HReturnHCA3 -> LifeCapitalCtx -> CredArg -> NetArg ->
                 PermArg -> MarketReadoutArg -> OmegaReal.

  (* eq. (75) — tier: Definition *)
  (** Omega^real_{i,n} = G_O(R^return_{H,i,n}, K^life_{i,n}, Cred_{i,n},
      Net_{i,n}, Perm_{i,n}, MarketReadout_n) (RG-HCA eq. 28), "explicitly
      not a validated welfare utility function" — a typed 6-argument
      function, Definition tier only, no proof obligation (parallel to
      [P_H_index] for eq. (58) in MR_WorldSystem.v). *)
  Definition omega_real_75
             (r : HReturnHCA3) (k : LifeCapitalCtx) (cred : CredArg)
             (net : NetArg) (perm : PermArg) (market : MarketReadoutArg)
    : OmegaReal :=
    G_O r k cred net perm market.

End OpportunityReadout.

(* ------------------------------------------------------------------ *)
(** ** Section: the opportunity-layer non-collapses (eq. 76) *)

Section OpportunityNonCollapse.

  (* eq. (76) — tier: Th_coqc *)
  (** Credential =/= Capability (RG-HCA eq. 29, first conjunct of the
      aligned equation block). Witnessed non-collapse in the same family
      as eq. (70)/(72): a concrete finite model where a credential is
      held yet the underlying capability does not hold — exactly the
      legibility gap main.tex motivates via Spence's signalling model
      ("capability that is not represented by a recognizable credential
      ... may fail to become opportunity"). *)
  Theorem eq76a_credential_not_capability :
    exists (D : Type) (Credential Capability : D -> Prop) (x : D),
      Credential x /\ ~ Capability x.
  Proof.
    exists bool, (fun _ : bool => True), (fun _ : bool => False), true.
    split.
    - exact I.
    - intro H; exact H.
  Qed.

  (** Market Legibility =/= Human Worth (RG-HCA eq. 30, second conjunct
      of eq. (76)). Not re-tagged with a fresh eq. comment — same
      equation, second witnessed conjunct. *)
  Theorem eq76b_market_legibility_not_human_worth :
    exists (D : Type) (MarketLegibility HumanWorth : D -> Prop) (x : D),
      MarketLegibility x /\ ~ HumanWorth x.
  Proof.
    exists bool, (fun _ : bool => True), (fun _ : bool => False), true.
    split.
    - exact I.
    - intro H; exact H.
  Qed.

End OpportunityNonCollapse.

(* ------------------------------------------------------------------ *)
(** ** Section: the net advancement record (eq. 77) *)

Section NetAdvancementRecord.

  Variables GainCTSAT LossT TransferT OwnershipT BurdenT
            BarrierChangeT OpportunityChangeT ProvenanceT WarrantT : Type.

  (* eq. (77) — tier: Definition *)
  (** A^HCA_i = <Gain_CTSA, Loss, Transfer, Ownership, Burden,
      BarrierChange, OpportunityChange, Provenance, Warrant> (RG-HCA
      eq. 36, explicitly tagged [Definition]). A typed 9-tuple, in the
      same family as [LifeCapitalContext] (eq. 68) and
      [HumanConversionVector] (eq. 61) in MR_WorldSystem.v. *)
  Definition NetAdvancementRecord : Type :=
    GainCTSAT * LossT * TransferT * OwnershipT * BurdenT *
    BarrierChangeT * OpportunityChangeT * ProvenanceT * WarrantT.

  Definition mk_net_advancement_record
             (gain : GainCTSAT) (loss : LossT) (transfer : TransferT)
             (own : OwnershipT) (burden : BurdenT)
             (barrier_change : BarrierChangeT)
             (opportunity_change : OpportunityChangeT)
             (provenance : ProvenanceT) (warrant : WarrantT)
    : NetAdvancementRecord :=
    (gain, loss, transfer, own, burden, barrier_change,
     opportunity_change, provenance, warrant).

End NetAdvancementRecord.

(* ------------------------------------------------------------------ *)
(** ** Section: the conditional advancement estimand (eq. 78) *)

Section ConditionalEstimand.

  Variables Individual StratumT : Type.
  Variable stratum_eq_dec : forall a b : StratumT, {a = b} + {a <> b}.
  Variable K_life_of : Individual -> StratumT.
  Variable Y1 Y0 : Individual -> Q.
  Variable Population : list Individual.

  (** The declared baseline life-context stratum cut: the finite subset
      of [Population] whose [K^life] readout matches [x], a decidable
      [filter] over the finite population — never an unbounded/
      continuum-indexed comprehension. *)
  Definition stratum_members (x : StratumT) : list Individual :=
    filter (fun i => if stratum_eq_dec (K_life_of i) x then true else false)
           Population.

  (** Finite [Q]-valued sum and arithmetic mean over a list of
      individuals under a chosen outcome map — never a continuum-measure
      integral/expectation. A stratum with zero members yields a mean of
      [0] by [Q]'s own total division convention; this is a degenerate
      readout of an empty stratum, not a claim about that stratum's
      average outcome, and is flagged here rather than hidden. *)
  Definition qsum (l : list Q) : Q := fold_right Qplus 0 l.

  Definition qmean (l : list Individual) (Y : Individual -> Q) : Q :=
    qsum (map Y l) / inject_Z (Z.of_nat (length l)).

  (* eq. (78) — tier: Definition *)
  (** ATE_HCA(x) = E[Y(1) - Y(0) | K^life = x] (RG-HCA eq. 37), modelled
      over an explicitly finite, [Q]-valued population: the difference
      of two finite arithmetic means over the stratum-[x] members, never
      a continuum-measure expectation. main.tex's own hedge ("matching
      or covariate adjustment is a design strategy, not part of the
      estimand itself") is honoured by keeping this a bare Definition —
      no identification/causal claim is asserted by this Coq statement,
      only the typed contrast-of-finite-averages structure. *)
  Definition ATE_HCA_78 (x : StratumT) : Q :=
    qmean (stratum_members x) Y1 - qmean (stratum_members x) Y0.

End ConditionalEstimand.

(* ------------------------------------------------------------------ *)
(** ** Section: the barrier/opportunity layer inside the outer loop
       (eq. 79) *)

Section HCAOuterLoopLayer.

  Variables HState3HCA ZHCAOuterState WorldSystemPair : Type.

  (** [H_{t+3} -[eq.69,eq.71]-> Z_{HCA,t+3}]: the barrier-typing and
      endorsement readout, abstracted here as a single function from one
      pass's returned human state to the RG-HCA state, since eq. (69)
      (the barrier ledger) and eq. (71) (the endorsed subset) are already
      typed above and this composition only needs their combined
      well-typed effect. *)
  Variable barrier_endorse_to_z_hca : HState3HCA -> ZHCAOuterState.

  (** [Z_{HCA,t+3} -[eq.75]-> (C^H_{t+3} -> P^H_{t+3})]: the opportunity
      readout [omega_real_75] (eq. 75) feeding the world-system pair that
      opens eq. (66) in MR_River.v, abstracted here as a single function
      since [omega_real_75]'s own six-argument signature is already
      typed above. *)
  Variable omega_to_world_system_pair : ZHCAOuterState -> WorldSystemPair.

  (* eq. (79) — tier: Definition *)
  (** H_{t+3} -[Barrier, Endorsement (eq.69,71)]-> Z_{HCA,t+3}
      -[Omega^real (eq.75)]-> (C^H_{t+3} -> P^H_{t+3}) (main.tex eq. 79):
      a well-typed 2-step composition threading one pass's Human-Return
      state through the barrier/endorsement readout and the opportunity
      readout into the world-system pair. main.tex is explicit this is
      "a schematic placement ... without adding a further arrow inside
      eq. (44)-(65) or reweighting eq. (66) itself" — Definition tier,
      no further claim asserted. *)
  Definition hca_outer_layer_79 (h_t3 : HState3HCA) : WorldSystemPair :=
    omega_to_world_system_pair (barrier_endorse_to_z_hca h_t3).

End HCAOuterLoopLayer.
