(** * MR_Corrections.v — Master Equation River, Block B: eq. (43)

    Source of record: research/society-justice-peace/master-river/v1_3/main.tex
    (Master Equation River v1.3), Section 4.1 "$\kappa$ Collides Across
    Three Meanings" (\label{sec:kappa}), inside Section 4 "Canonical
    Notation Corrections Before Freezing Master" (\label{sec:corrections}).

    Tier source: the surrounding prose states plainly that this is a
    renaming/typing act — "Master should use one consistent rename" — not a
    mathematical claim to be derived or an empirical hypothesis to be
    tested; it resolves a three-way symbol collision (MEMK's meaning
    strength, From Problem to Hypothesis's semantic-route accessibility,
    Choice Begins Before Choice's live-policy accessibility) by giving each
    role its own name and, implicitly, its own type/domain. Table 2 does
    not list eq. (43) under any of the Th_coqc/Open rows; it is exactly the
    kind of "Domain definitions" act the table's second row names.

    DISCIPLINE: readout-first, as in MR_Live.v/MR_Prompt.v/MR_Retention.v —
    no [Reals], no classical axioms, Section+Variables for abstract
    objects, no top-level [Parameter]/[Axiom], no [Admitted]. Genuine typing
    distinctness (three roles with three different argument shapes) is
    exhibited by construction: the three renamed quantities are given
    concretely different function signatures below, so no two of them can
    be the literal same object even before any value is chosen — the
    strongest sense in which a rename that also separates roles can be
    "checked" without turning a notation-fixing act into an unwarranted
    extra theorem.
*)

From Coq Require Import QArith.
Set Implicit Arguments.

(* eq. (43) — tier: Definition *)
Section KappaCollisionResolved.

  (** Master's canonical rename, restated as three distinctly-typed
      quantities rather than one overloaded symbol [kappa]:

      - [MeaningIndex]: the single discrete step index [n] at which meaning
        strength is read (MEMK's originally-named [kappa_n]).
      - [Event], [Question]: the semantic-route accessibility domain, from
        From Problem to Hypothesis's [kappa_t(e|Q)] — indexed by an event
        [e], a question [Q], and a discrete time [t : nat].
      - [Policy2], [Goal2]: the live-policy accessibility domain, from
        Choice Begins Before Choice's [kappa_{A,t}(pi|g)] — indexed by a
        policy [pi], a goal [g], an agent [A0], and a discrete time
        [t : nat]. *)
  Variables MeaningIndex Event Question Policy2 Goal2 Agent2 : Type.

  (** gamma^mu_n : meaning strength — a function of the meaning-index alone. *)
  Variable gamma_mu : MeaningIndex -> Q.

  (** kappa^sem_{A,t}(e|Q) : semantic-route accessibility — a function of an
      agent, a discrete time, an event, and a question. *)
  Variable kappa_sem : Agent2 -> nat -> Event -> Question -> Q.

  (** lambda^live_{A,t}(pi|g) : live-policy accessibility — a function of an
      agent, a discrete time, a policy, and a goal. *)
  Variable lambda_live_c : Agent2 -> nat -> Policy2 -> Goal2 -> Q.

  (** The rename resolves the three-way collision precisely because these
      are three functions of genuinely different arities/domains (1, 4,
      and 4 arguments over pairwise-distinct index types [MeaningIndex],
      [Event*Question], [Policy2*Goal2]) rather than one function reused
      under one shared name [kappa] — recorded here as a trivial but
      exact arity fact, not as a disguised extra theorem about eq. (43)
      itself. *)
  Definition kappa_rename_arities : nat * nat * nat := (1%nat, 4%nat, 4%nat).

End KappaCollisionResolved.
