(** * MR_TopicEntry.v — Master Equation River, Block C: eq. (46)-(51)

    Source of record: research/society-justice-peace/master-river/v1_3/main.tex
    (Master Equation River v1.3), Section "Topic Entry and Agenda Ownership
    Before the Prompt" (\label{sec:topicentry3}, eq. 46-49) and Section
    "Human Return, Action, and World Feedback" (\label{sec:return2},
    eq. 50-51). Both sections restate, in Master's own session index [s],
    material from How Humans Should Converse with AI (Dialogue Conversion
    Protocol, DCP) v1.3 \citep{dialogue_conversion_protocol}, each
    statement traced to DCP's own equation number in the surrounding prose.

    Tier source:
    - eq. 46: restates the pre-prompt transport already typed as eq. (27)
      in MR_Prompt.v (Definition tier there), now at DCP's own session
      index [s] — the same Definition-tier transport, not a new claim.
    - eq. 47: DCP eq. 5, a finite enumeration of three legitimate entry
      modes — Table 2's "New in v1.3" row lists this among "Domain
      definitions".
    - eq. 48: DCP's Problem-First Dialogue Principle is explicitly tagged
      "[\textsc{Open}]" in the paper's own running text (DCP eq. 6), and
      Table 2's "New in v1.3" Open row repeats this ("The Problem-First
      Dialogue Principle (\eqref{eq:48})").
    - eq. 49: the paper states this as a guarding non-collapse (DCP eq. 7,
      restated at DCP eq. 43); main.tex's own Table 2 (\label{tab:status},
      the "New in v1.3" Open-empirical-hypotheses row) explicitly names
      eq. (49) together with eq. (48) and states plainly: "all tagged
      [Open] in their own source papers, none upgraded here." The paper's
      source of record forbids upgrading this equation, so despite the
      surface resemblance to the witnessed "<>" non-collapse proofs at
      eq. (11)/(24)/(38)/(42), eq. (49) is tiered Open here, not Th_coqc.
    - eq. 50, 51: the paper calls this a "closure" (DCP eq. 29) and a
      "wider cycle" (DCP eq. 30) — a typed sequential composition/cycle,
      Definition tier, in the same family as eq. (44)/(45)/(65)/(66) in
      MR_River.v ("a schematic placement, not a new derivation").

    DISCIPLINE: readout-first, as in the other Block A/B files — no
    [Reals], no classical axioms, Section+Variables/Hypotheses for
    abstract objects (discharged, never top-level [Parameter]/[Axiom]), no
    [Admitted]. eq. (47)'s finite entry-mode enumeration and eq. (51)'s
    finite cycle-stage enumeration are both closed [Inductive] types (a
    finite, witnessed readout of the paper's own finite list of modes/
    stages), never an open-ended classifier.
*)

From Coq Require Import QArith.
Set Implicit Arguments.

(* ------------------------------------------------------------------ *)
(** ** Section: the topic-entry transport (eq. 46) *)

Section TopicEntryTransport.

  Variables HState Prompt : Type.

  (* eq. (46) — tier: Definition *)
  (** H_{s,0} --L_H--> Q_{s,0}.  The same Pre-Prompt Human State transport
      already typed as eq. (27) in MR_Prompt.v, restated here at DCP's own
      session index [s] rather than the turn index [t]: a (generally
      lossy) map from the retained human state at the start of session [s]
      to the bounded prompt the AI actually receives. *)
  Variable L_H : HState -> Prompt.

  Definition topic_entry_transport (H_s0 : HState) : Prompt := L_H H_s0.

End TopicEntryTransport.

(* ------------------------------------------------------------------ *)
(** ** Section: topic-entry modes, the Problem-First principle, and its
       guarding non-collapse (eq. 47-49) *)

Section TopicEntryModes.

  (* eq. (47) — tier: Definition *)
  (** TopicEntry in {LiveProblem, OpenExploration, RoutineDelegation}
      (DCP eq. 5).  A finite, closed enumeration of the three legitimate
      entry modes — a readout-first finite classifier, never an
      open-ended one. *)
  Inductive TopicEntry : Type :=
    | LiveProblem
    | OpenExploration
    | RoutineDelegation.

  (** DCP eq. 5 declares all three modes legitimate entry points (the
      point of eq. 49 below is precisely that legitimacy does not collapse
      onto [LiveProblem] alone); this types that declaration so eq. 49 has
      something to be proved against. *)
  Definition Legitimate (t : TopicEntry) : Prop := True.

  (* eq. (48) — tier: Open (not proved; falsifier: a topic-entry regime in
     which Problem-First formally holds — the dialogue is entered on a
     live problem — yet one of the four declared consequents demonstrably
     fails: the agenda is not actually the human's own, the dialogue
     ranges unboundedly beyond the stated problem, no world-side test of
     the outcome is available, or no human capability change survives AI
     removal) *)
  (** Problem-First => {Human Agenda Ownership, Bounded Relevance,
      World-Side Testability, Observable Human Return} (DCP eq. 6). DCP's
      own text tags this the "Problem-First Dialogue Principle [Open]";
      it is stated here exactly as an implication between four abstract,
      declared propositions, never discharged as a proof. *)
  Definition Open_eq48
             (ProblemFirst HumanAgendaOwnership BoundedRelevance
              WorldSideTestability ObservableHumanReturn : Prop) : Prop :=
    ProblemFirst ->
      HumanAgendaOwnership /\ BoundedRelevance /\
      WorldSideTestability /\ ObservableHumanReturn.

  (** "Problem-Only" as the policy that would collapse legitimacy onto
      [LiveProblem] alone. Typed here (Definition tier, not asserted) so
      eq. (49)'s Open hypothesis below has TopicEntry-vocabulary objects to
      state itself against. *)
  Definition ProblemOnlyPolicy : Prop :=
    forall t : TopicEntry, Legitimate t -> t = LiveProblem.

  (* eq. (49) — tier: Open (not proved; falsifier: a topic-entry regime in
     which Problem-First and Problem-Only are formally indistinguishable) *)
  (** Problem-First <> Problem-Only (DCP eq. 7, restated at DCP eq. 43).
      main.tex's own Table 2 (\label{tab:status}) names eq. (49) explicitly
      in its "New in v1.3" Open-empirical-hypotheses row and states "none
      upgraded here" — the paper's source of record forbids treating this
      as a proved Th_coqc result, even though a witnessed non-collapse proof
      on the finite [TopicEntry]/[ProblemOnlyPolicy] model above (parallel
      to eq. (11)/(24)/(38)/(42)) is mechanically available. We therefore
      state it only as the Open Prop the paper's own hypothesis asserts,
      in the same [ProblemFirst -> ~ ProblemOnly] shape as [Open_eq48]
      above, and do not discharge it with a Theorem/Lemma. *)
  Definition Open_eq49 (ProblemFirst ProblemOnly : Prop) : Prop :=
    ProblemFirst -> ~ ProblemOnly.

End TopicEntryModes.

(* ------------------------------------------------------------------ *)
(** ** Section: the DCP closure and the wider Live-Problem cycle
       (eq. 50-51) *)

Section HumanReturnClosure.

  Variables IntegrationRecord ActionType WorldRecord HState2 : Type.

  (* eq. (50) — tier: Definition *)
  (** I_s -> a_s -> delta^world_{s+1} -> H_{s+1,0} (DCP eq. 29).  DCP's
      closure: the integration record selects a next action, the acted-on
      situation returns a world record, and that record becomes the next
      session's pre-prompt state — a well-typed 3-step composition, in the
      same "type-checking is the Definition-tier content" spirit as
      eq. (44)/(65) in MR_River.v. *)
  Variable next_action : IntegrationRecord -> ActionType.
  Variable world_feedback : ActionType -> WorldRecord.
  Variable next_session_state : WorldRecord -> HState2.

  Definition dcp_closure_50 (I_s : IntegrationRecord) : HState2 :=
    next_session_state (world_feedback (next_action I_s)).

End HumanReturnClosure.

Section WiderCycle.

  (* eq. (51) — tier: Definition *)
  (** Live Problem -> Question -> Dialogue -> Human Return -> Action ->
      World Feedback -> Revision or New Problem (DCP eq. 30).  A finite,
      closed enumeration of the seven cycle stages together with the
      paper's own declared successor arrow at each stage, read off exactly
      in the order the text gives it. The final arrow ("Revision or New
      Problem") re-enters the cycle at [SLiveProblem]; the paper is
      explicit (\Cref{sec:return2}) that this closure is conditional on
      the topic having observable consequences, not universal — no claim
      beyond the typed successor structure itself is asserted here. *)
  Inductive CycleStage : Type :=
    | SLiveProblem
    | SQuestion
    | SDialogue
    | SHumanReturnStage
    | SAction
    | SWorldFeedback
    | SRevisionOrNewProblem.

  Definition cycle_next_51 (s : CycleStage) : CycleStage :=
    match s with
    | SLiveProblem         => SQuestion
    | SQuestion            => SDialogue
    | SDialogue            => SHumanReturnStage
    | SHumanReturnStage    => SAction
    | SAction              => SWorldFeedback
    | SWorldFeedback       => SRevisionOrNewProblem
    | SRevisionOrNewProblem => SLiveProblem
    end.

End WiderCycle.
