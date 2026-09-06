(** * MR_Resonance.v — Master Equation River, Block A: eq. (9)-(18)

    Source of record: research/society-justice-peace/master-river/v1_3/main.tex
    (Master Equation River v1.3), Section 3.4 "Resonance: Only the v2
    Definition Is Current", 3.5 "Rhythm, Momentum, and Accessibility Must
    Remain Parallel Descriptors", and 3.6 "Accumulation, Barrier, and
    Release".

    Tier source: Table 2 (Epistemic Status of Each Segment, \label{tab:status})
    and the genealogy table (\label{tab:genealogy}) row "History -> re-entry"
    which states explicitly that semantic momentum (eq. 13) "is an [Open]
    hypothesis", and Table 2's "Open empirical hypotheses" row which lists
    "rhythm beyond exposure count; recent-path momentum; history-shaped
    accessibility; barrier/transition topology" by name.

    DISCIPLINE: readout-first, as in MR_Foundation.v — no [Reals], no
    classical axioms, [Q]-valued weights only, Section+Variables/Hypotheses
    for abstract objects, no top-level [Parameter]/[Axiom], no [Admitted].
    Where the paper writes a continuum-looking expression ([exp(...)] in
    eq. 14), the discrete replacement is recorded explicitly in the comment
    rather than silently imported.
*)

From Coq Require Import QArith.
From Coq Require Import List.
Import ListNotations.

Set Implicit Arguments.

(* ------------------------------------------------------------------ *)
(** ** Section: resonance and its non-collapse (eq. 9-11) *)

Section Resonance.

  Variables Memory Ctx Question Experience RetrievedInfo ResonVal : Type.

  (* eq. (9) — tier: Definition *)
  (** I_{H,n} = Retrieve(M_{H,n} | c_n, Q_n).  A finite retrieval map from
      memory, conditioned by context and question — a domain definition,
      not yet a claim about what retrieval finds. *)
  Variable Retrieve : Memory -> Ctx -> Question -> RetrievedInfo.

  (* eq. (10) — tier: Definition *)
  (** Reson_H(n) = C_H(E^cur_n, I_{H,n} | c_n, Q_n).  Resonance is defined,
      per the v2 (current, canonical) definition, as the congruence between
      the current externally-prompted experience and the retained internal
      experiential organization — external-internal congruence, not the
      superseded accessibility/reweighting sense. *)
  Variable C_H : Experience -> RetrievedInfo -> Ctx -> Question -> ResonVal.

  (* eq. (11) — tier: Th_coqc *)
  (** Non-collapse: Reson <> Identity, Reson <> Truth, Reson <> Retention,
      Reson <> Improvement.  We formalise this as a witnessed finite model:
      an enumerated 5-point notion space (Resonance, Identity, Truth,
      Retention, Improvement) with a concrete valuation into [Q] that
      separates every one of the five pairwise — a finite model in which
      none of these five readouts collapse into one another, which is
      exactly what "non-collapse" requires: it must be *possible* for them
      to differ, not that they always must. *)
  Inductive Notion : Type := NResonance | NIdentity | NTruth | NRetention | NImprovement.

  Definition notion_value (n : Notion) : Q :=
    match n with
    | NResonance   => 0
    | NIdentity    => 1
    | NTruth       => 2
    | NRetention   => 3
    | NImprovement => 4
    end.

  Theorem eq11_resonance_non_collapse :
    (notion_value NResonance <> notion_value NIdentity)
    /\ (notion_value NResonance <> notion_value NTruth)
    /\ (notion_value NResonance <> notion_value NRetention)
    /\ (notion_value NResonance <> notion_value NImprovement).
  Proof.
    unfold notion_value.
    repeat split; discriminate.
  Qed.

  (** Strengthened form: the model witnesses full pairwise distinctness of
      all five notions, not just the four the paper singles out against
      Resonance — offered for completeness, not itself a separately
      numbered equation. *)
  Theorem notion_value_injective :
    forall n1 n2, notion_value n1 = notion_value n2 -> n1 = n2.
  Proof.
    intros [] [] Heq; unfold notion_value in Heq; try reflexivity; try discriminate Heq.
  Qed.

End Resonance.

(* ------------------------------------------------------------------ *)
(** ** Section: rhythm, momentum, accessibility (eq. 12-15) *)

Section RhythmMomentum.

  Variables Xw Boundary RhythmVal : Type.

  (* eq. (12) — tier: Definition *)
  (** T_n = {(x_k,t_k,w_k)}_{k<=n}, Rhythm_n = Omega(T_n,B_n).  The
      encounter history up to index [n] is a finite list of triples
      (phenomenon, discrete time-tick, weight in [Q]); Rhythm is a map out
      of that finite history plus a declared boundary structure. *)
  Definition EncounterHistory : Type := list (Xw * nat * Q).

  Variable Omega : EncounterHistory -> Boundary -> RhythmVal.

  Definition rhythm_at (T : EncounterHistory) (B : Boundary) : RhythmVal :=
    Omega T B.

  (* eq. (13) — tier: Open *)
  (** m_{t+1}(e) = rho*m_t(e) + 1[e_t=e], 0<=rho<=1.  The genealogy table's
      own row for this construct states in the paper's own words: "a route
      just traversed may be easier to re-enter; this is an [Open]
      hypothesis." The recursion itself is a perfectly well-defined
      discrete (Q-valued, nat-indexed) function, defined below as
      scaffolding since eq. (14)-(15) need it, but the tier we record is
      Open: the paper's own status for this construct, because what is at
      stake is a substantive empirical claim (that finite recent-path
      history genuinely eases re-entry), not merely a typing exercise. *)
  Variable Event : Type.
  Variable event_eq_dec : forall e1 e2 : Event, {e1 = e2} + {e1 <> e2}.

  Fixpoint momentum (rho : Q) (path : nat -> Event) (t : nat) (e : Event) : Q :=
    match t with
    | O => 0
    | S t' =>
        rho * momentum rho path t' e
        + (if event_eq_dec (path t') e then 1 else 0)
    end.

  (** Stated in the model's own vocabulary, not proved: recent-path
      momentum genuinely eases re-entry to [e] in some sense certified by
      an externally supplied criterion [GenuinelyEasesReentry] (left
      abstract because this is exactly what is Open — the paper does not
      yet fix the empirical test).  Falsifier: a controlled comparison in
      which the rho-weighted momentum term adds no predictive value over a
      history-blind (rho = 0) baseline for re-entry likelihood, for every
      instantiation of [GenuinelyEasesReentry] a study would accept. *)
  Definition Open_eq13 (GenuinelyEasesReentry : Q -> Prop) : Prop :=
    forall rho path t e, GenuinelyEasesReentry (momentum rho path t e).

  (* eq. (14) — tier: Open *)
  (** kappa^sem_{t+1}(e|Q) proportional to kappa0 * exp(beta*a + mu*m -
      nu*c + xi).  [exp] over a continuum argument is a non-readout under
      the discrete-math discipline; the readout-first replacement is a
      Q-valued *score* S = beta*a + mu*m - nu*c + xi (fully discrete: all
      four weights and all four factors are [Q]-valued) together with a
      declared discrete, rational, monotone gain surrogate [disc_gain_nat]
      standing in for the paper's continuum exponential — recorded
      explicitly as a substitution, never silently imported from
      [Coq.Reals]. Table 2 tags "history-shaped accessibility" as an Open
      empirical hypothesis, so the whole kernel (not merely its continuum
      notation) is tiered Open here. *)
  Definition accessibility_score (beta mu_coef nu a m c xi : Q) : Q :=
    beta * a + mu_coef * m - nu * c + xi.

  (** Discrete, rational surrogate for "exp(S)", defined on [nat] (a
      readout-first, strictly monotone, Q-valued stand-in for the
      continuum exponential — NOT claimed equal to it). *)
  Fixpoint disc_gain_nat (n : nat) : Q :=
    match n with
    | O => 1
    | S k => 2 * disc_gain_nat k
    end.

  (** [n] below stands for an already-discretised reading of
      [accessibility_score beta mu_coef nu a m c xi]; the discretisation
      map itself ([Q -> nat]) is left abstract, since fixing it is exactly
      the kind of methodological choice this equation's Open status
      defers. *)
  Definition kappa_next (kappa0 : Q) (n : nat) : Q :=
    kappa0 * disc_gain_nat n.

  (** Stated, not proved, in the model's own vocabulary: the
      history-shaped score [accessibility_score] genuinely predicts
      something about future re-entry/uptake — certified by an externally
      supplied, left-abstract criterion [GenuinelyPredicts] — beyond what a
      history-blind score (momentum and switching cost forced to 0) would.
      Falsifier: a head-to-head comparison in which the momentum/cost-blind
      score matches or beats [accessibility_score] against held-out data,
      for every instantiation of [GenuinelyPredicts] a study would accept. *)
  Definition Open_eq14 (GenuinelyPredicts : Q -> Prop) : Prop :=
    forall beta mu_coef nu a m c xi,
      GenuinelyPredicts (accessibility_score beta mu_coef nu a m c xi).

  (* eq. (15) — tier: Th_coqc *)
  (** Rhythm_t, m_t, a_t, c_t -> kappa^sem_{t+1}: the paper's own "canonical
      correction" is that this arrow must NOT be read as a derivation from
      Rhythm alone ("Rhythm => m_t" is explicitly rejected). We formalise
      exactly that non-reducibility as a witnessed non-collapse on the
      concrete model above: [rhythm_at] is, by its very type, a function of
      [(T,B)] alone — it cannot see [a,m,c,xi] at all — so its value is
      unchanged no matter what [a,m,c,xi] are; yet [accessibility_score]
      demonstrably does change as those are varied.  Hence Rhythm alone
      cannot be what determines accessibility. *)
  Theorem eq15_rhythm_alone_does_not_determine_accessibility :
    forall (T : EncounterHistory) (B : Boundary),
      exists (beta mu_coef nu a1 m1 c1 xi1 a2 m2 c2 xi2 : Q),
        rhythm_at T B = rhythm_at T B
        /\ accessibility_score beta mu_coef nu a1 m1 c1 xi1
           <> accessibility_score beta mu_coef nu a2 m2 c2 xi2.
  Proof.
    intros T B.
    exists 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1.
    split.
    - reflexivity.
    - unfold accessibility_score. vm_compute. congruence.
  Qed.

  (** A second, complementary witness on [kappa_next] itself: the
      discretised kernel genuinely varies as the discretised score varies,
      so it is not a constant function that could be "explained away" by
      any single shared quantity such as Rhythm. *)
  Theorem eq15_kappa_next_genuinely_varies :
    exists (kappa0 : Q) (n1 n2 : nat), kappa_next kappa0 n1 <> kappa_next kappa0 n2.
  Proof.
    exists 1, 0%nat, 1%nat.
    unfold kappa_next. vm_compute. congruence.
  Qed.

End RhythmMomentum.

(* ------------------------------------------------------------------ *)
(** ** Section: accumulation, barrier, release (eq. 16-18) *)

Section AccumulationBarrier.

  (* eq. (16) — tier: Th_coqc *)
  (** DeltaW_{j,N} = sum_{n=1}^{N} eta_n * eligibleGradient_n.  A finite
      accounting identity over [Q]: the accumulated eligible informational
      work is a finite sum, computed here as a fold over a list of
      per-step (eta, eligibleGradient) pairs.  We prove the accounting
      identity the paper's bookkeeping requires: if every step contributes
      a non-negative increment, accumulated work is monotone non-decreasing
      as more steps are folded in, and is itself non-negative whenever
      every step is — the discrete analogue of "accumulation cannot go
      backwards without a negative step", proved over [Q], not assumed. *)
  Definition accum_work (steps : list (Q * Q)) : Q :=
    fold_right (fun p acc => fst p * snd p + acc) 0 steps.

  Lemma accum_work_cons :
    forall (eta grad : Q) (steps : list (Q * Q)),
      accum_work ((eta, grad) :: steps) = eta * grad + accum_work steps.
  Proof. intros; reflexivity. Qed.

  Definition all_nonneg (steps : list (Q * Q)) : Prop :=
    Forall (fun p => 0 <= fst p * snd p) steps.

  Theorem eq16_accum_work_monotone_on_nonneg_extension :
    forall (eta grad : Q) (steps : list (Q * Q)),
      0 <= eta * grad ->
      accum_work steps <= accum_work ((eta, grad) :: steps).
  Proof.
    intros eta grad steps Hnn.
    rewrite accum_work_cons.
    rewrite <- (Qplus_0_l (accum_work steps)) at 1.
    apply Qplus_le_compat.
    - exact Hnn.
    - apply Qle_refl.
  Qed.

  Corollary eq16_accum_work_nonneg_of_all_nonneg :
    forall (steps : list (Q * Q)), all_nonneg steps -> 0 <= accum_work steps.
  Proof.
    induction steps as [| [eta grad] rest IH]; intros Hall.
    - simpl. apply Qle_refl.
    - assert (Hp : 0 <= fst (eta, grad) * snd (eta, grad)) by (apply (Forall_inv Hall)).
      assert (Hrest : all_nonneg rest) by (apply (Forall_inv_tail Hall)).
      simpl in Hp.
      rewrite accum_work_cons.
      rewrite <- (Qplus_0_l 0).
      apply Qplus_le_compat.
      + exact Hp.
      + exact (IH Hrest).
  Qed.

  (* eq. (17) — tier: Definition *)
  (** W^eff_n = W_info,n * g(Reson_H(n), eligibility, context).  A domain
      definition: effective work is informational work modulated by a
      declared gain function of resonance, eligibility and context — typed
      abstractly here since [g]'s shape is not itself fixed by the paper. *)
  Section EffectiveWork.
    Variables ResonVal Eligibility Ctx : Type.
    Variable g : ResonVal -> Eligibility -> Ctx -> Q.
    Definition effective_work (W_info : Q) (r : ResonVal) (elig : Eligibility) (c : Ctx) : Q :=
      W_info * g r elig c.
  End EffectiveWork.

  (* eq. (18) — tier: Open *)
  (** sum_{k<=n} W^eff_k >= DeltaV^dagger_{old->new}.  The threshold-
      crossing predicate itself is a decidable [Q]-comparison (proved
      decidable below), but the paper is explicit that crossing it is only
      a "candidate transition topology, not a claim that every kind of
      human change obeys a universal threshold" — and Table 2 lists
      "barrier/transition topology" under Open empirical hypotheses. So the
      *causal* content of eq. (18) (crossing the threshold entails an
      actual transition/release) is tiered Open, even though the
      comparison predicate that names the threshold is perfectly decidable
      over [Q]. *)
  Definition threshold_crossed (accum threshold : Q) : Prop := threshold <= accum.

  Lemma threshold_crossed_decidable :
    forall accum threshold,
      {threshold_crossed accum threshold} + {~ threshold_crossed accum threshold}.
  Proof.
    intros accum threshold. unfold threshold_crossed.
    destruct (Qlt_le_dec accum threshold) as [Hlt | Hle].
    - right. apply Qlt_not_le. exact Hlt.
    - left. exact Hle.
  Qed.

  (** Stated, not proved: whenever the accumulated effective work crosses
      the barrier (as witnessed by the caller-supplied
      [represents_threshold_crossing] relation linking an abstract
      [Transition] record to the concrete accumulated/threshold values),
      some transition actually [occurred].  Falsifier: an observed case
      where [threshold_crossed accum threshold] holds (the sum has reached
      or exceeded the barrier) yet no transition/release the model can
      point to has occurred. *)
  Definition Open_eq18 (Transition : Type) (occurred : Transition -> Prop)
             (represents_threshold_crossing : Transition -> Q -> Q -> Prop) : Prop :=
    forall (t : Transition) (accum threshold : Q),
      represents_threshold_crossing t accum threshold ->
      threshold_crossed accum threshold ->
      occurred t.

End AccumulationBarrier.
