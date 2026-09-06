(** * MRC_method_reading_a.v — Master River Canon, family: method-reading (part a)

    Family assignment: every CAN id in [registry/CANONICAL.json] with
    [domain = "method"] (69 ids; the exact set is written out to
    [registry/family_method-reading.json]). This family is not the
    root-spine family ([spine_ids] in [registry/COLLAPSE.md]), so this pass
    produces no [MRC_master.v]. Per [registry/COLLAPSE.md] "method is not
    given its own reading-table column: it ... reads the spine as an audit
    layer over whichever domain produced the claim" — every id below reads
    one of the nine root-spine ids (CAN-001/003/004/006/007/008/009/201),
    named in each id's own CAN-comment.

    This is a companion pair with [MRC_method_reading_b.v] (CAN-210..216,
    CAN-230..256); the two files are independent siblings (neither
    [Require]s the other), matching the existing [MRC_human_ai_reading_a.v]
    / [_b.v] split. Part a covers CAN-165..200 (35 ids, following the
    numeric block [registry/COLLAPSE.md]'s own method-domain table already
    uses).

    REUSE (Master River eq. 1-79): the method domain's source manuscripts
    ("Knowledge Topology and the First Passage to Usable Hypotheses",
    "From Problem to Hypothesis", "The Standalone Scholar",
    "Rigour Without Infrastructure", "State of Evidence for the Readout
    Hypothesis-Generation Programme", "How Humans Should Converse with
    AI") are, with exactly one exception, disjoint from the chapters
    Master River v1.3/v1.4 itself formalises (eq. 1-79, in
    [MR_Foundation.v] .. [MR_HCA.v]) — they are the credit/provenance/
    governance audit layer, not a further domain reading of the spine's
    own agents-in-a-world chapters. The one exception is CAN-198
    (rhythm-momentum-accessibility): its canonical text is exactly
    [MR_Resonance.v] eq. (13)-(15) (momentum, the discretised accessibility
    score, and the "Rhythm alone does not determine accessibility"
    correction), so CAN-198 below [Require]s [MR.MR_Resonance] and reuses
    those identifiers directly by alias, the same technique already used
    for CAN-024 in [MRC_epistemic_reading.v] (an independent family also
    reading the same eq. 13-15 content; both aliases are legitimate reuses
    of the one Master River source, not a re-derivation). Every other id
    in this file is new content for this pass.

    DISCIPLINE (Coq 8.20.1, information-discrete-math / readout-first):
      - Finite/discrete only: [nat], [Q], [bool], [list], [Record]s,
        [Inductive]s. No [Coq.Reals], no classical axioms, no [Admitted],
        no top-level [Axiom]/[Parameter] (every abstract carrier is a
        Section [Variable]/[Hypothesis], discharged at [End]).
      - Every [Lemma]/[Theorem] below is Closed under the global context
        (see [LEDGER_method-reading.md] for the [Print Assumptions] result
        on each).
      - Tiering is exactly one of Th_coqc / Definition / Open per id, per
        the id's own tier field in [registry/CANONICAL.json]. An
        Open-tagged id is recorded as an unproved [Prop] scaffold, never
        upgraded to a proved [Theorem]/[Lemma]. Continuum notation in the
        source text (exp(.), a cube root, a supremum over an unbounded
        path space, mutual information / a data-processing inequality)
        is never silently imported from [Coq.Reals]; each such spot is
        either replaced by a finite/rational surrogate (as
        [MR_Resonance.v] eq.(14) already does for exp), left as an
        abstract Section [Variable]/[Hypothesis] operation with no
        continuum content assumed, or recorded [Open].
      - Two small shared devices, defined once below and reused across
        several ids in this file (each id's own CAN-comment says which
        device it instantiates), mirror the "one reusable technique, many
        call sites" discipline already used in [MRC_epistemic_reading.v]
        and [MR_Live.v]/[MR_HCA.v]'s [fold_right Qmax]/[qsum] pattern:
        (1) [mr_factorization_thm] / [mr_no_factorization_when_fiber_varies]
            — a downstream distinction is admissible relative to an
            upstream readout iff it factors through it (CAN-165's own
            named "Factorization Theorem"), and the converse failure mode
            (CAN-216's worked audit);
        (2) [fold_right Qplus 0] / [fold_right Qmin] bookkeeping bounds,
            the same finite-fold technique as [MR_Live.v]'s [p_star] /
            [MR_HCA.v]'s [qsum], dualised to a lower bound where the
            source paper's own object is a minimum (CAN-181) or a sum
            (CAN-194).
*)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import Lia.
From Coq Require Import List.
Import ListNotations.

From MR Require Import MR_Resonance.

Set Implicit Arguments.

(* ==================================================================== *)
(** ** Shared device 1 — readout-factorization admissibility (used by
    CAN-165, CAN-216) *)

Section MRFactorization.
  Variables X Y Z : Type.
  Variable R : X -> Y.
  Variable Phi : X -> Z.

  (** Fiber-constancy: [Phi] cannot distinguish two [X]-points [R] itself
      does not distinguish. *)
  Definition mr_admissible : Prop := forall x x', R x = R x' -> Phi x = Phi x'.

  Variable Rinv_dec : forall y : Y, {x : X | R x = y} + (forall x, R x <> y).
  Variable default : Z.

  (** The factored map g : Y -> Z, built by finite/decidable search over
      the (declared, per-[y]) preimage witness — never by unbounded
      choice. *)
  Definition mr_g_of (y : Y) : Z :=
    match Rinv_dec y with
    | inl (exist _ x _) => Phi x
    | inr _ => default
    end.

  (** The Factorization Theorem: admissibility (fiber-constancy) is
      exactly the condition under which [Phi] factors as [g o R]. *)
  Theorem mr_factorization_thm : mr_admissible -> forall x, Phi x = mr_g_of (R x).
  Proof.
    intros Hadm x. unfold mr_g_of.
    destruct (Rinv_dec (R x)) as [[x' Hx'] | Hno].
    - apply Hadm. symmetry. exact Hx'.
    - exfalso. apply (Hno x). reflexivity.
  Qed.
End MRFactorization.

(** The converse failure: if an upstream map [K] is constant on two points
    where a downstream process [C] differs, no factorisation [C = G o K]
    can exist for any [G] — CAN-216's worked audit is an instance of this. *)
Lemma mr_no_factorization_when_fiber_varies :
  forall (X Y Z : Type) (K : X -> Y) (C : X -> Z) (x1 x2 : X),
    K x1 = K x2 -> C x1 <> C x2 -> ~ exists G : Y -> Z, forall x, C x = G (K x).
Proof.
  intros X Y Z K C x1 x2 Heq Hne [G HG].
  apply Hne. rewrite (HG x1), (HG x2), Heq. reflexivity.
Qed.

(* ==================================================================== *)
(** ** Shared device 2 — finite-fold bookkeeping bounds (used by CAN-181,
    CAN-194), dualising [MR_Live.v]'s [p_star_upper_bound] / [MR_HCA.v]'s
    [qsum] to a [Qmin] lower bound and a nonnegative-summand lower bound. *)

Definition mr_qmin_fold (l : list Q) (d : Q) : Q := fold_right Qmin d l.

Lemma mr_qmin_fold_le : forall (l : list Q) (d x : Q), In x l -> mr_qmin_fold l d <= x.
Proof.
  induction l as [| a rest IH]; intros d x Hin.
  - simpl in Hin. contradiction.
  - simpl in Hin. destruct Hin as [Heq | Hin'].
    + subst. unfold mr_qmin_fold. simpl. apply Q.le_min_l.
    + unfold mr_qmin_fold. simpl.
      apply Qle_trans with (y := mr_qmin_fold rest d).
      * apply Q.le_min_r.
      * apply IH. exact Hin'.
Qed.

Definition mr_qsum (l : list Q) : Q := fold_right Qplus 0 l.

Lemma mr_qsum_nonneg : forall l, (forall y, In y l -> 0 <= y) -> 0 <= mr_qsum l.
Proof.
  induction l as [| a rest IH]; intro Hnn.
  - unfold mr_qsum. simpl. lra.
  - unfold mr_qsum in *. simpl.
    assert (Ha : 0 <= a) by (apply Hnn; left; reflexivity).
    assert (Hrest : 0 <= fold_right Qplus 0 rest)
      by (apply IH; intros y Hy; apply Hnn; right; exact Hy).
    lra.
Qed.

Lemma mr_qsum_ge_member : forall (l : list Q) (x : Q),
  In x l -> (forall y, In y l -> 0 <= y) -> x <= mr_qsum l.
Proof.
  induction l as [| a rest IH]; intros x Hin Hnn.
  - simpl in Hin. contradiction.
  - simpl in Hin. unfold mr_qsum in *. simpl. destruct Hin as [Heq | Hin'].
    + subst.
      assert (Hrest : 0 <= fold_right Qplus 0 rest).
      { apply mr_qsum_nonneg. intros y Hy. apply Hnn. right. exact Hy. }
      lra.
    + assert (Ha : 0 <= a) by (apply Hnn; left; reflexivity).
      assert (Hle : x <= fold_right Qplus 0 rest)
        by (apply IH; [exact Hin' | intros y Hy; apply Hnn; right; exact Hy]).
      lra.
Qed.

(* ==================================================================== *)
(** ** Group 1 — readout-factorization admissibility and the rival-model
    ladder (CAN-165, CAN-166) *)

(* CAN-165 — root: root-readout-gate (CAN-201) — domain: method —
   tier: Th_coqc / Open — occurrences: 20 *)
(** Phi:X->Z is admissible relative to R:X->Y iff constant on every fiber
    of R (ker R subset ker Phi), equivalently Phi factors as g o R — the
    source's own "Factorization Theorem", instantiating shared device 1
    above. The stochastic form (C = G composed with K-star) and the data-processing
    inequality are recorded as an [Open] scaffold: mutual information is a
    continuum (log-based) quantity with no discrete/[Q] surrogate fixed
    here, so it is left abstract rather than silently imported from
    [Coq.Reals]. The non-collapse companion (R*<>Rtilde: the actual source
    relation need not equal a claimant's model of it) is witnessed on a
    minimal two-valued instance. *)
Definition CAN165_admissible := @mr_admissible.
Definition CAN165_g_of := @mr_g_of.
Definition CAN165_factorization_thm := @mr_factorization_thm.

Definition CAN165_data_processing_inequality_Open
  (T : Type) (MutualInfo : T -> T -> Q) (chain : nat -> T) : Prop :=
  forall j : nat, MutualInfo (chain 0%nat) (chain (S j)) <= MutualInfo (chain 0%nat) (chain j).

Theorem CAN165_source_relation_may_differ_from_model :
  exists R1 R2 : bool -> bool, R1 <> R2.
Proof.
  exists (fun b => b), negb. intro H.
  apply (f_equal (fun f => f true)) in H.
  simpl in H. discriminate.
Qed.

(* CAN-166 — root: reader-equivalence (CAN-007) — domain: method —
   tier: Definition / Open — occurrences: 1 *)
(** The preregistered rival-model ladder M0..M5 any readout-retention
    theory must beat: a finite, closed enumeration (Definition tier); the
    claim that M5 in fact beats every M0..M4 on some declared metric is
    the paper's own falsifiable empirical proposal, recorded as an
    unproved [Prop] scaffold (Open), never proved here. *)
Inductive CAN166_RivalModel :=
  | CAN166_M0_ArousalIntensity
  | CAN166_M1_FamiliarityExposure
  | CAN166_M2_PredictionSurprise
  | CAN166_M3_LanguageCategoryConstruction
  | CAN166_M4_MemorySchemaRetrieval
  | CAN166_M5_ReadoutRetentionModel.

Definition CAN166_must_beat_ladder_Open
  (Metric : Type) (score : CAN166_RivalModel -> Metric) (better : Metric -> Metric -> Prop) : Prop :=
  forall m : CAN166_RivalModel, m <> CAN166_M5_ReadoutRetentionModel ->
    better (score CAN166_M5_ReadoutRetentionModel) (score m).

(* ==================================================================== *)
(** ** Group 2 — problem formation, discovery accessibility, first-passage
    discovery time, and the discriminating-action loop (CAN-167..170) *)

(* CAN-167 — root: reader-equivalence (CAN-007) — domain: method —
   tier: Definition — occurrences: 3 *)
(** A problem is a retained residual (r_t = A*eps_t - delta_t, a finite
    [Q]-valued discrepancy, with the quadratic cost V_t = (1/2) w r_t^2 as
    its scalar bookkeeping surrogate for the source's r^T W r); a question
    is an abstract selection out of the retained residual. *)
Definition CAN167_residual (A eps delta : Q) : Q := A * eps - delta.
Definition CAN167_cost (w r : Q) : Q := (1#2) * w * r * r.

Section CAN167_Retention.
  Variables ResidualTy RetainedProblem ContrastTy : Type.
  Variable Retain_Pi : ResidualTy -> RetainedProblem.
  Variable Question_Pi : RetainedProblem -> ContrastTy.
  Definition CAN167_problem := Retain_Pi.
  Definition CAN167_question_selects := Question_Pi.
End CAN167_Retention.

(* CAN-168 — root: reader-equivalence (CAN-007) — domain: method —
   tier: Definition / Th_coqc — occurrences: 10 *)
(** Reachability is not accessibility: [CAN168_path_prob] is the
    finite-product path measure over a [Q]-valued access kernel (never a
    supremum over an unbounded path set — a genuine sup is left Open where
    it would appear); the non-collapse content ("reachable does not force
    high accessibility") is witnessed concretely: a strictly positive but
    small path value is neither zero (reachable) nor [CAN168_high]. *)
Section CAN168_DiscoveryAccessibility.
  Variable Sem : Type.
  Variable kappa : nat -> Sem -> Sem -> Q.

  Fixpoint CAN168_path_prob (t : nat) (s : Sem) (path : list Sem) : Q :=
    match path with
    | [] => 1
    | s' :: rest => kappa t s s' * CAN168_path_prob t s' rest
    end.

  Definition CAN168_reachable (t : nat) (s : Sem) (path : list Sem) : Prop :=
    ~ Qeq (CAN168_path_prob t s path) 0.
End CAN168_DiscoveryAccessibility.

Definition CAN168_high (q : Q) : Prop := (1#2) <= q.

Theorem CAN168_positive_but_not_high : exists q : Q, ~ Qeq q 0 /\ ~ CAN168_high q.
Proof.
  exists (1#100). split.
  - intro Hc. apply Qeq_bool_iff in Hc. vm_compute in Hc. discriminate.
  - intro Hc. assert (Hb : Qle_bool (1#2) (1#100) = true) by (apply Qle_bool_iff; exact Hc).
    vm_compute in Hb. discriminate.
Qed.

(* CAN-169 — root: reader-equivalence (CAN-007) — domain: method —
   tier: Definition / Open — occurrences: 19 *)
(** Discovery time as a first-passage stopping time: the bounded
    (fuel-indexed) search [CAN169_tau_U_bounded] is fully computable
    (Definition tier); the unbounded infimum over all [n] is left as an
    unproved existential [Prop] (Open — no finite Coq model decides an
    unbounded search without a supplied fuel bound). "usable<>true" is
    witnessed as a minimal two-valued instance: membership in the usable
    set and boolean truth are different notions, so they may diverge. *)
Section CAN169_FirstPassage.
  Variable St : Type.
  Variable in_target : St -> bool.
  Variable step_seq : nat -> St.

  Fixpoint CAN169_first_hit (fuel start : nat) : option nat :=
    match fuel with
    | O => None
    | S f => if in_target (step_seq start) then Some start else CAN169_first_hit f (S start)
    end.

  Definition CAN169_tau_U_bounded (fuel : nat) : option nat := CAN169_first_hit fuel 0.
End CAN169_FirstPassage.

Definition CAN169_tau_U_unbounded_Open (St : Type) (in_target : St -> bool) (step_seq : nat -> St) : Prop :=
  exists n : nat, in_target (step_seq n) = true.

Theorem CAN169_usable_ne_actually_true :
  exists is_usable is_true_claim : bool, is_usable = true /\ is_true_claim = false.
Proof. exists true, false. auto. Qed.

(* CAN-170 — root: reader-equivalence (CAN-007) — domain: method —
   tier: Definition — occurrences: 4 *)
Section CAN170_DiscriminatingActionLoop.
  Variables ActionTy Obs BeliefTy ReaderTy : Type.
  Variable delta_hat : ReaderTy -> ActionTy -> Q.
  Variable delta_star : ActionTy -> Q.
  Definition CAN170_discriminating (i j : ReaderTy) (u : ActionTy) : Prop :=
    delta_hat i u <> delta_hat j u.
  Definition CAN170_local_residual (i : ReaderTy) (u : ActionTy) : Q :=
    delta_hat i u - delta_star u.
End CAN170_DiscriminatingActionLoop.

(* ==================================================================== *)
(** ** Group 3 — provenance ledger, DCP status categories, credit-Goodhart
    guard, and the tier-ledger invariant (CAN-171..174) *)

(* CAN-171 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 2 *)
Section CAN171_ProvenanceLedger.
  Variables ProvTy TierTy DefectTy ReaderTy FalsifierTy : Type.
  Record CAN171_LedgerEntry := CAN171_mkEntry {
    can171_prov : ProvTy;
    can171_tier : TierTy;
    can171_defect : DefectTy;
    can171_reader : ReaderTy;
    can171_falsifier : FalsifierTy
  }.
End CAN171_ProvenanceLedger.

(* CAN-172 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 1 *)
Inductive CAN172_Status :=
  | CAN172_Source | CAN172_AISynthesis | CAN172_HumanInference
  | CAN172_Candidate | CAN172_Decision.

(* CAN-173 — root: historical-invariance (CAN-009) — domain: method —
   tier: Th_coqc — occurrences: 2 *)
(** The Provenance Relevance Constraint gates each evidence term to {0,1}
    before it is credited; a real inequality follows: the PRC-gated valid
    credit total never exceeds the ungated raw total, given every raw term
    is nonnegative. *)
Section CAN173_CreditGoodhart.
  Variable Evidence : Type.
  Variable weight evidence_val : Evidence -> Q.
  Variable PRC : Evidence -> bool.
  Hypothesis nonneg : forall e, 0 <= weight e * evidence_val e.

  Definition CAN173_valid_term (e : Evidence) : Q :=
    if PRC e then weight e * evidence_val e else 0.
  Definition CAN173_C_valid (l : list Evidence) : Q :=
    fold_right (fun e acc => CAN173_valid_term e + acc) 0 l.
  Definition CAN173_C_raw (l : list Evidence) : Q :=
    fold_right (fun e acc => weight e * evidence_val e + acc) 0 l.

  Lemma CAN173_term_le : forall e, CAN173_valid_term e <= weight e * evidence_val e.
  Proof.
    intro e. unfold CAN173_valid_term. destruct (PRC e).
    - apply Qle_refl.
    - apply nonneg.
  Qed.

  Theorem CAN173_valid_le_raw : forall l, CAN173_C_valid l <= CAN173_C_raw l.
  Proof.
    induction l as [| e rest IH].
    - simpl. apply Qle_refl.
    - unfold CAN173_C_valid, CAN173_C_raw in *. simpl.
      apply Qplus_le_compat.
      + apply CAN173_term_le.
      + apply IH.
  Qed.
End CAN173_CreditGoodhart.

(* CAN-174 — root: reader-equivalence (CAN-007) — domain: method —
   tier: Definition — occurrences: 1 *)
(** ClaimStrength <= EvidenceStrength: a bare order relation over [Q]; the
    reflexive instance (claim strength exactly at its own evidence
    ceiling) is offered as Th_coqc-grade scaffolding confirming the
    Definition is not vacuous, not a re-tagging of the invariant itself. *)
Definition CAN174_invariant (claim_strength evidence_strength : Q) : Prop :=
  claim_strength <= evidence_strength.

Theorem CAN174_invariant_refl : forall e : Q, CAN174_invariant e e.
Proof. intro e. unfold CAN174_invariant. apply Qle_refl. Qed.

(* ==================================================================== *)
(** ** Group 4 — K2 procurement heuristics, the theorizing pipeline, and
    scholarly-capital bookkeeping (CAN-175, CAN-177, CAN-178) *)

(* CAN-175 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 3 *)
Section CAN175_K2Procurement.
  Variables Cash lamH H lamL L D R I eps175 : Q.
  Definition CAN175_cost_k2 : Q := (Cash + lamH * H + lamL * L) / (D * R * I + eps175).

  Variables PReview Depth Fit Prep Latency : Q.
  Definition CAN175_expected_yield : Q := (PReview * Depth * Fit) / (Cash + Prep + Latency + eps175).

  Variables DepthE RelE IndepE : Q.
  Definition CAN175_effective_k2 : Q := DepthE * RelE * IndepE.
End CAN175_K2Procurement.

(* CAN-177 — root: domain-weld (CAN-006) — domain: method —
   tier: Definition — occurrences: 5 *)
Inductive CAN177_TheoryStage :=
  | CAN177_Phenomenon | CAN177_ExistingExplanations | CAN177_PreciseInadequacy
  | CAN177_Mechanism | CAN177_Boundary | CAN177_Propositions.
Inductive CAN177_EngineAStage :=
  | CAN177_PhenomenonA | CAN177_TheoreticalInadequacyA
  | CAN177_MechanismA | CAN177_ConceptualContributionA.
Inductive CAN177_EngineBStage :=
  | CAN177_PracticeB | CAN177_ObservationB | CAN177_InterventionB
  | CAN177_EvidenceB | CAN177_ImplementationB.
Definition CAN177_bridge (practice_delta_theory : bool) : bool := practice_delta_theory.
Lemma CAN177_bridge_iff : forall b, CAN177_bridge b = true <-> b = true.
Proof. intro b. unfold CAN177_bridge. tauto. Qed.

(* CAN-178 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 4 *)
Section CAN178_ScholarlyCapital.
  Variables I0 R0 N0 P0 : Q.
  Definition CAN178_K0_start : Q := I0 + R0 + N0 + P0.

  Variables Qv Cv Vv Uv Xv Tv : Q.
  Variable f178 : Q -> Q -> Q -> Q -> Q -> Q -> Q.
  Definition CAN178_E_t : Q := f178 Qv Cv Vv Uv Xv Tv.

  Variables Access LanguageQ SituatedObservation TranslationCapacity TrustQ : Q.
  Definition CAN178_PosCap : Q := Access * LanguageQ * SituatedObservation * TranslationCapacity * TrustQ.

  Variables P_A Co Bi : Q.
  Definition CAN178_NetPractice : Q := P_A - (Co + Bi).
End CAN178_ScholarlyCapital.

(* ==================================================================== *)
(** ** Group 5 — the knowledge-state ladder, epistemic isolation, and
    bottleneck inversion (CAN-179..181) *)

(* CAN-179 — root: reader-equivalence (CAN-007) — domain: method —
   tier: Th_coqc — occurrences: 3 *)
(** K0<K1<K2<K3: a finite, closed [Inductive] staged order, injectively
    coded into [nat]; the ladder is strictly increasing at every step, a
    genuine (if small) [nat]-arithmetic theorem. *)
Inductive CAN179_KState := CAN179_K0 | CAN179_K1 | CAN179_K2 | CAN179_K3.
Definition CAN179_code (k : CAN179_KState) : nat :=
  match k with
  | CAN179_K0 => 0 | CAN179_K1 => 1 | CAN179_K2 => 2 | CAN179_K3 => 3
  end.
Definition CAN179_lt (k1 k2 : CAN179_KState) : Prop := (CAN179_code k1 < CAN179_code k2)%nat.
Theorem CAN179_ladder_strictly_increasing :
  CAN179_lt CAN179_K0 CAN179_K1 /\ CAN179_lt CAN179_K1 CAN179_K2 /\ CAN179_lt CAN179_K2 CAN179_K3.
Proof. unfold CAN179_lt; simpl; repeat split; lia. Qed.

(* CAN-180 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition / Open — occurrences: 3 *)
(** The Epistemic Isolation Constraint, stated as a strict [Q] inequality
    between human-formation and AI-production rates (Definition tier); its
    stated governance consequence (build synthetic-formation
    infrastructure) is a policy recommendation, not a derivable fact, and
    is recorded as an unproved implication scaffold (Open). *)
Section CAN180_EIC.
  Variables mu_H_f mu_A : Q.
  Definition CAN180_EIC : Prop := mu_H_f < mu_A.
  Variable BuildInfra : Prop.
  Definition CAN180_EIC_implies_Open : Prop := CAN180_EIC -> BuildInfra.
End CAN180_EIC.

(* CAN-181 — root: historical-invariance (CAN-009) — domain: method —
   tier: Th_coqc / Definition — occurrences: 4 *)
(** Lambda = min over the named bottleneck rates, instantiating shared
    device 2 ([mr_qmin_fold]): a genuine lower-bound theorem, dualising
    [MR_Live.v]'s [p_star_upper_bound]. The cube-root aggregator [V_c] is
    left as an abstract Section operation (never [Coq.Reals]' real cube
    root); [D_e] and the velocity constraint are typed Definitions, not
    proved (the source states them as governance heuristics, not
    theorems). *)
Definition CAN181_Lambda (l : list Q) (d : Q) : Q := mr_qmin_fold l d.
Definition CAN181_Lambda_le_each := mr_qmin_fold_le.

Section CAN181_Extra.
  Variables H_bn L_bn T_bn A_bn : Q.
  Variable cbrt181 : Q -> Q.
  Definition CAN181_Vc : Q := cbrt181 (H_bn * L_bn * T_bn).
  Definition CAN181_De : Q := A_bn * (1 - CAN181_Vc).
  Variables PublicOutputVelocity VerificationCapacity : Q.
  Definition CAN181_velocity_constraint : Prop := PublicOutputVelocity <= VerificationCapacity.
End CAN181_Extra.

(* ==================================================================== *)
(** ** Group 6 — the DVP protocol, programme legibility, recognition
    conversion, and credit-velocity governance (CAN-182..185) *)

(* CAN-182 — root: root-stepper (CAN-003) — domain: method —
   tier: Definition — occurrences: 3 *)
Inductive CAN182_Outcome := CAN182_Resolve | CAN182_Declare.
Definition CAN182_decision (Disagreement HumanAvailable : bool) : CAN182_Outcome :=
  if Disagreement then (if HumanAvailable then CAN182_Resolve else CAN182_Declare) else CAN182_Resolve.

(* CAN-183 — root: root-readout-gate (CAN-201) — domain: method —
   tier: Definition — occurrences: 3 *)
(** Coh_effective = Coh_latent * L_g: a genuine bound follows given
    0<=L_g<=1 and Coh_latent nonnegative, offered here as Th_coqc-grade
    scaffolding for a Definition-tier id (matching the "supporting lemma,
    not a re-tagging" style already used for similar ids). *)
Section CAN183_ProgrammeLegibility.
  Variables Coh_latent L_g : Q.
  Definition CAN183_Coh_effective : Q := Coh_latent * L_g.
  Theorem CAN183_effective_le_latent :
    0 <= Coh_latent -> 0 <= L_g <= 1 -> CAN183_Coh_effective <= Coh_latent.
  Proof.
    intros Hnn [Hnn2 Hle1]. unfold CAN183_Coh_effective.
    rewrite (Qmult_comm Coh_latent L_g).
    rewrite <- (Qmult_1_l Coh_latent) at 2.
    apply Qmult_le_compat_r; assumption.
  Qed.
End CAN183_ProgrammeLegibility.

(* CAN-184 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition / Open — occurrences: 3 *)
Section CAN184_RecognitionConversion.
  Variables AuthorTy ProblemTy : Type.
  Variable A_s : AuthorTy -> ProblemTy -> nat -> Q.
  Definition CAN184_monotone_increase_Open : Prop :=
    forall (a : AuthorTy) (p : ProblemTy) (t : nat), A_s a p t < A_s a p (S t).
End CAN184_RecognitionConversion.
Inductive CAN184_PaperRole :=
  | CAN184_Paper1_Theme | CAN184_Paper2_SameThemeNewMechanism
  | CAN184_Paper3_EmpiricalTest | CAN184_Paper4_BoundaryExtension.

(* CAN-185 — root: root-weld (CAN-001) — domain: method —
   tier: Definition / Th_coqc — occurrences: 17 *)
(** Deliberately heuristic bookkeeping (per the registry's own tier note):
    [CAN185_chi] and [CAN185_VC]/[CAN185_priority] are typed Definitions;
    the recursive credit-stock bound [B_{t+1} <= B_t + M_t] (mint minus a
    nonnegative burn term) is a genuine, if modest, [Q]-linear-arithmetic
    theorem. *)
Section CAN185_CreditVelocity.
  Variables lambda_mint lambda_conv eps185 : Q.
  Definition CAN185_chi : Q := lambda_mint / (lambda_conv + eps185).

  Variable M omega X : nat -> Q.
  Fixpoint CAN185_B (B0 : Q) (t : nat) : Q :=
    match t with
    | O => B0
    | S t' => CAN185_B B0 t' + M t' - omega t' * X t'
    end.

  Hypothesis omega_X_nonneg : forall t, 0 <= omega t * X t.
  Theorem CAN185_B_bounded_by_mint : forall B0 t, CAN185_B B0 (S t) <= CAN185_B B0 t + M t.
  Proof. intros B0 t. simpl. assert (H := omega_X_nonneg t). lra. Qed.

  Variables CreditCreation Retention Conversion Hcritical : Q.
  Definition CAN185_VC : Q := (CreditCreation * Retention * Conversion) / Hcritical.

  Variables dV MarginalHumanCost eps185b : Q.
  Definition CAN185_priority : Q := dV / (MarginalHumanCost + eps185b).
End CAN185_CreditVelocity.

(* ==================================================================== *)
(** ** Group 7 — concept-cluster compounding, the reactor-criticality
    analogy, and the legitimacy circulation loop (CAN-186..188) *)

(* CAN-186 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 3 *)
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

(* CAN-187 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 6 *)
(** An explicitly-disclaimed diagnostic analogy (source: "not a physical
    law"), formalised purely as typed [Q]-valued bookkeeping. *)
Section CAN187_ReactorAnalogy.
  Variables nu_t f_coh L_g187 p_int m_leg u_conv P_NL : Q.
  Definition CAN187_k_t : Q := nu_t * f_coh * L_g187 * p_int * m_leg * u_conv * P_NL.

  Variables w_d E_d w_p E_p eps187 : Q.
  Definition CAN187_beta_D : Q := (w_d * E_d) / (w_d * E_d + w_p * E_p + eps187).

  Variable beta_min : Q.
  Variables IntegrityClean XenonLow ConversionLogOn : bool.
  Definition CAN187_increase_mint_rate : Prop :=
    beta_min <= CAN187_beta_D /\ IntegrityClean = true /\ XenonLow = true /\ ConversionLogOn = true.

  Variables Nind Ncit : Q.
  Definition CAN187_rho_R : Q := Nind / Ncit.

  Variables Osub Eknown Cstale : bool.
  Definition CAN187_X_t : Q :=
    (if Osub then 1 else 0) + 2 * (if Eknown then 1 else 0) + 3 * (if Cstale then 1 else 0).

  Variables Nindreuse Nterminal : Q.
  Definition CAN187_BR_t : Q := Nindreuse / Nterminal.
End CAN187_ReactorAnalogy.

(* CAN-188 — root: root-stepper (CAN-003) — domain: method —
   tier: Th_coqc — occurrences: 1 *)
(** The Legitimacy Circulation Loop is a closed 5-stage cycle: iterating
    the step function 5 times returns every stage to itself, a genuine
    (fully computable, [reflexivity]-closed) theorem. *)
Inductive CAN188_LoopStage :=
  | CAN188_HorizontalGeneration | CAN188_EpistemicFriction
  | CAN188_VerticalStrengthening | CAN188_ResourceReturn | CAN188_HorizontalGrowth.

Definition CAN188_step (s : CAN188_LoopStage) : CAN188_LoopStage :=
  match s with
  | CAN188_HorizontalGeneration => CAN188_EpistemicFriction
  | CAN188_EpistemicFriction => CAN188_VerticalStrengthening
  | CAN188_VerticalStrengthening => CAN188_ResourceReturn
  | CAN188_ResourceReturn => CAN188_HorizontalGrowth
  | CAN188_HorizontalGrowth => CAN188_HorizontalGeneration
  end.

Fixpoint CAN188_iter (n : nat) (s : CAN188_LoopStage) : CAN188_LoopStage :=
  match n with O => s | S n' => CAN188_step (CAN188_iter n' s) end.

Theorem CAN188_loop_returns : forall s, CAN188_iter 5 s = s.
Proof. intro s; destruct s; simpl; reflexivity. Qed.

(* ==================================================================== *)
(** ** Group 8 — the residual model, geographic coverage, and the
    integrity firewall (CAN-189..191) *)

(* CAN-189 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 1 *)
Section CAN189_ResidualModel.
  Variables Aa eps189 delta189 W189 : Q.
  Definition CAN189_r : Q := Aa * eps189 - delta189.
  Definition CAN189_V : Q := (1#2) * W189 * CAN189_r * CAN189_r.
End CAN189_ResidualModel.

(* CAN-190 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc / Definition — occurrences: 9 *)
(** P_local not-subset D_AI: a genuine list non-containment fact, proved
    generically then specialised; the remaining formulas (S_G, the
    global/Thai conversion-plan pair) are typed Definitions. *)
Lemma mr_list_non_containment_witness :
  forall (X : Type) (l1 l2 : list X) (x : X),
    In x l1 -> ~ In x l2 -> ~ (forall y, In y l1 -> In y l2).
Proof. intros X l1 l2 x Hx1 Hx2 Hsub. apply Hx2. apply Hsub. exact Hx1. Qed.

Section CAN190_GeographicCoverage.
  Variable ProvinceTy : Type.
  Definition CAN190_not_subset (P_local D_AI : list ProvinceTy) : Prop :=
    ~ (forall y, In y P_local -> In y D_AI).
  Definition CAN190_not_subset_witness := @mr_list_non_containment_witness ProvinceTy.

  Variables Lg Gg Mg Bg Fg : Q.
  Definition CAN190_S_G : Q := Lg * Gg * Mg * Bg * Fg.

  Record CAN190_ConversionPlan := CAN190_mkPlan { can190_global : Q; can190_thai : Q }.
End CAN190_GeographicCoverage.

(* CAN-191 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 3 *)
Inductive CAN191_FirewallStage :=
  | CAN191_AICandidate | CAN191_OriginalSource | CAN191_ClaimMatch | CAN191_VerifiedCitation.
Definition CAN191_scram (FreezeNewRelease Correction ReAudit : bool) : bool :=
  andb FreezeNewRelease (andb Correction ReAudit).

(* ==================================================================== *)
(** ** Group 9 — the human-mastery gate, the standalone-scholar
    architecture, and the feasibility budget (CAN-192..194) *)

(* CAN-192 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 1 *)
Definition CAN192_H_g (questions_defended : nat) : Q := (Z.of_nat questions_defended # 10).

(* CAN-193 — root: constitutional-ordering (CAN-004) — domain: method —
   tier: Definition — occurrences: 3 *)
Inductive CAN193_ArchStage :=
  | CAN193_Phenomenon | CAN193_AIExploration | CAN193_DVP | CAN193_HumanMastery
  | CAN193_Integrity | CAN193_K1 | CAN193_GlobalLocalFriction | CAN193_K2
  | CAN193_Revision | CAN193_K3.
Record CAN193_EpistemicPosition := CAN193_mkPosition {
  can193_recognizable_problem : bool;
  can193_repeat_human_nodes : bool;
  can193_citable_assets : bool;
  can193_correction_history : bool
}.
Record CAN193_CrediblePath := CAN193_mkPath {
  can193_early_timestamp : bool;
  can193_explicit_provisionality : bool;
  can193_rapid_revision : bool;
  can193_external_friction : bool;
  can193_eventual_certification : bool
}.

(* CAN-194 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition / Th_coqc — occurrences: 5 *)
(** B_year, instantiating shared device 2 ([mr_qsum]): a genuine bound
    (each nonnegative budget line is at most the total) follows directly
    from [mr_qsum_ge_member]. *)
Section CAN194_FeasibilityBudget.
  Variables B_conf B_ethics B_soft B_data B_pub B_travel : Q.
  Definition CAN194_B_year : list Q := [B_conf; B_ethics; B_soft; B_data; B_pub; B_travel].
  Definition CAN194_B_year_total : Q := mr_qsum CAN194_B_year.

  Theorem CAN194_component_le_total :
    (forall y, In y CAN194_B_year -> 0 <= y) ->
    In B_conf CAN194_B_year -> B_conf <= CAN194_B_year_total.
  Proof. intros. unfold CAN194_B_year_total. apply mr_qsum_ge_member; assumption. Qed.

  Variables H_planned H_sustainable : Q.
  Definition CAN194_portfolio_shrink : Prop := H_sustainable < H_planned.

  Variable PublicWIP : nat.
  Definition CAN194_wip_bound : Prop := (PublicWIP <= 3)%nat.

  Variables I_i N_i E_i F_i Y_i S_i D_i C_i Frag_i COI_i eps194 : Q.
  Definition CAN194_priority : Q :=
    (I_i * N_i * E_i * F_i * Y_i * S_i) / (D_i + C_i + Frag_i + COI_i + eps194).
End CAN194_FeasibilityBudget.

(* ==================================================================== *)
(** ** Group 10 — discovery-justification separation, evidence-registry
    non-collapse, knowledge-topology sensitivity, rhythm/momentum
    accessibility, mind-body coupling, and the DCP burden vector
    (CAN-195..200) *)

(* CAN-195 — root: historical-invariance (CAN-009) — domain: method —
   tier: Definition — occurrences: 3 *)
Section CAN195_DiscoveryJustification.
  Variables ClaimScope SamplingScope : Q.
  Definition CAN195_scope_constraint : Prop := ClaimScope <= SamplingScope.
End CAN195_DiscoveryJustification.
Inductive CAN195_Pipeline := CAN195_PracticeObservation | CAN195_Hypothesis.

(* CAN-196 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Th_coqc — occurrences: 6 *)
(** The evidence-registry non-collapse chain, on one shared finite
    enumeration: each named pair is disjoint by construction, so every
    inequality below is closed by [discriminate] alone (the same
    discipline as [MR_Resonance.v] eq.(11), simplified — Coq's own
    constructor-disjointness makes the epistemic family's nat-injective-
    coding indirection unnecessary here). *)
Inductive CAN196_EvidenceNotion :=
  | CAN196_NeighboringEvidence | CAN196_FormalVariableValidation | CAN196_TruthOfIntegratedTheory
  | CAN196_Reachability | CAN196_Accessibility | CAN196_GenerationSpeed | CAN196_QualityWarrant
  | CAN196_AIOutputVolume | CAN196_EpistemicDiversity | CAN196_Attraction | CAN196_Warrant.

Theorem CAN196_neighboring_ne_formal :
  CAN196_NeighboringEvidence <> CAN196_FormalVariableValidation.
Proof. discriminate. Qed.
Theorem CAN196_formal_ne_truth :
  CAN196_FormalVariableValidation <> CAN196_TruthOfIntegratedTheory.
Proof. discriminate. Qed.
Theorem CAN196_reachability_ne_accessibility :
  CAN196_Reachability <> CAN196_Accessibility.
Proof. discriminate. Qed.
Theorem CAN196_speed_ne_quality :
  CAN196_GenerationSpeed <> CAN196_QualityWarrant.
Proof. discriminate. Qed.
Theorem CAN196_volume_ne_diversity :
  CAN196_AIOutputVolume <> CAN196_EpistemicDiversity.
Proof. discriminate. Qed.
Theorem CAN196_attraction_chain :
  CAN196_Attraction <> CAN196_Accessibility
  /\ CAN196_Accessibility <> CAN196_Warrant
  /\ CAN196_Warrant <> CAN196_TruthOfIntegratedTheory.
Proof. repeat split; discriminate. Qed.

(* CAN-197 — root: constitutional-noncollapse (CAN-008) — domain: method —
   tier: Open — occurrences: 1 *)
(** "Distinct knowledge topologies force distinct first-passage laws" is
    the paper's own central hypothesis — a general injectivity claim about
    an abstract map that no finite Coq model can decide without assuming
    it; recorded as an unproved [Prop] scaffold. *)
Definition CAN197_topology_sensitivity_Open
  (GraphTy LawTy : Type) (tau_law : GraphTy -> LawTy) : Prop :=
  forall g1 g2 : GraphTy, g1 <> g2 -> tau_law g1 <> tau_law g2.

(* CAN-198 — root: root-stepper (CAN-003) — domain: method —
   tier: Th_coqc / Open — occurrences: 5 *)
(** State mapping: this id's canonical text is exactly [MR_Resonance.v]
    eq.(13)-(15) (momentum, the discretised accessibility score, and the
    "Rhythm alone does not determine accessibility" correction), reused
    directly by alias — the same Master River content CAN-024 already
    aliases in the independent [MRC_epistemic_reading.v] family; both
    reuses are legitimate readings of the one source, not a
    re-derivation. [momentum]/[accessibility_score] retain Open tier from
    [MR_Resonance.v]'s own tiering; the non-reducibility theorems are
    Th_coqc. *)
Definition CAN198_momentum := @momentum.
Definition CAN198_Open_momentum := @Open_eq13.
Definition CAN198_accessibility_score := @accessibility_score.
Definition CAN198_Open_accessibility := @Open_eq14.
Definition CAN198_rhythm_does_not_determine_accessibility :=
  @eq15_rhythm_alone_does_not_determine_accessibility.
Definition CAN198_kappa_genuinely_varies := @eq15_kappa_next_genuinely_varies.

(* CAN-199 — root: constitutional-ordering (CAN-004) — domain: method —
   tier: Definition — occurrences: 3 *)
(** Coupled brain-body / mind-core dynamics, neither alone: a mutually
    recursive pair of finite [Q]-valued sequences, each step folding in
    the other's coupling term — the discrete surrogate for
    B[t+1]=F(B[t])+C_H(H[t]), H[t+1]=G(H[t])+C_B(B[t]). *)
Section CAN199_MindBodyCoupling.
  Variable F199 G199 C_H199 C_B199 : Q -> Q.

  Fixpoint CAN199_B (B0 H0 : Q) (t : nat) : Q :=
    match t with
    | O => B0
    | S t' => F199 (CAN199_B B0 H0 t') + C_H199 (CAN199_H B0 H0 t')
    end
  with CAN199_H (B0 H0 : Q) (t : nat) : Q :=
    match t with
    | O => H0
    | S t' => G199 (CAN199_H B0 H0 t') + C_B199 (CAN199_B B0 H0 t')
    end.

  Variable R199 : Q -> Q -> Q.
  Definition CAN199_E (B0 H0 : Q) (t : nat) : Q := R199 (CAN199_B B0 H0 t) (CAN199_H B0 H0 t).
End CAN199_MindBodyCoupling.

(* CAN-200 — root: root-stepper (CAN-003) — domain: method —
   tier: Definition / Th_coqc — occurrences: 2 *)
(** The protocol usability-burden vector as a typed [Record]; "optimal is
    not the same notion as adoptable" is witnessed by a two-constructor
    enumeration closed under [discriminate]. *)
Record CAN200_Burden := CAN200_mkBurden {
  can200_time : Q;
  can200_cogload : Q;
  can200_vercost : Q;
  can200_interrupt : Q;
  can200_literacy : Q
}.
Inductive CAN200_OptimalOrAdoptable := CAN200_EpistemicallyOptimal | CAN200_BehaviorallyAdoptable.
Theorem CAN200_optimal_ne_adoptable :
  CAN200_EpistemicallyOptimal <> CAN200_BehaviorallyAdoptable.
Proof. discriminate. Qed.
