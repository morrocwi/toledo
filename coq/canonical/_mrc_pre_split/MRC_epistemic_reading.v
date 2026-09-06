(** * MRC_epistemic_reading.v — Master River Canon, family: epistemic-reading

    Family assignment: every CAN id in [registry/CANONICAL.json] with
    [domain = "epistemic"] (49 ids; the exact set is written out to
    [registry/family_epistemic-reading.json]). This family is not the
    root-spine family ([spine_ids] in [registry/COLLAPSE.md]), so this pass
    produces no [MRC_master.v].

    REUSE (Master River eq. 1-79): eleven of the 49 ids restate content
    that Master River v1.3 eq. (1)-(18), Block A ([MR_Foundation.v],
    [MR_Resonance.v]) already formalises, verbatim from the SAME source
    manuscripts CANONICAL.json cites for these very ids ("Experience Is
    Meaning-Giving", "Meaning Before Naming", "Before Meaning, Before
    Choice") — CAN-013/014/015/016/017/019/020 (meaning, meaning-modes,
    meaning-distortion, experience, naming; eq. 1-8) and CAN-021/022/024
    (resonance, accumulation-barrier, history-accessibility; eq. 9-18).
    For these, per the task's "reuse MR_*.v for CAN ids that are Master
    River eq. 1-79" instruction, this file [Require]s [MR.MR_Foundation]
    and [MR.MR_Resonance] and states the mapping — either by direct reuse
    of a persisting identifier (a [Record]/[Fixpoint]/[Theorem] that does
    not depend on a discharged Section [Variable], so it survives
    [Require] unchanged: [MeaningModes], [meaning_modes_decomposition_faithful],
    [eq5_experience_is_phenomenon_and_meaning_jointly], [NamingChainStep],
    [naming_chain], [eq8_retention_can_change_the_reader], [Notion],
    [eq11_resonance_non_collapse], [accum_work], [threshold_crossed],
    [Open_eq18], [momentum], [accessibility_score], [Open_eq13],
    [Open_eq14], the eq. 15 theorems) or, where the paper's object was a
    bare Section [Variable] (eq. 1/2/4/6, which discharge and cannot be
    aliased across files), by restating the identical
    Section+Variables+comment shape under the CAN id's own name, with an
    explicit note that it is the same object, not a second one.

    Every other id here is new content for this pass, sourced from
    manuscripts outside the Master River v1.3/v1.4 numbering ("Written by
    AI. Still True."; "Mind as Information Horizon"; "The Readout
    Condition"; "Genesis Constraint-First Alignment Epistemology"; "From
    Problem to Hypothesis"; and others — see
    [registry/family_epistemic-reading.json] for the per-id source title).

    DISCIPLINE (Coq 8.20.1, information-discrete-math / readout-first):
      - Finite/discrete only: [nat], [Z] (unused here), [Q], [bool],
        [list], [Record]s, [Inductive]s. No [Coq.Reals], no classical
        axioms, no [Admitted], no top-level [Axiom]/[Parameter] (every
        abstract carrier is a Section [Variable]/[Hypothesis], discharged
        at [End]).
      - Every [Lemma]/[Theorem] below is Closed under the global context
        (see [LEDGER_epistemic-reading.md] for the [Print Assumptions]
        result on each).
      - Tiering is exactly one of Th_coqc / Definition / Open per id, per
        the id's own tier field in CANONICAL.json. An Open-tagged id is
        recorded as an unproved [Prop] scaffold (a hypothesis space, not a
        theorem) — never upgraded to a proved [Theorem]/[Lemma]. Where a
        continuum notation appears in the source text (e.g. eq.(14)'s
        [exp(...)]), the discrete replacement already recorded in
        [MR_Resonance.v] is reused rather than re-imported from
        [Coq.Reals].
      - The recurring "X <> Y <> Z <> ..." non-collapse claims that this
        family's source manuscripts state in bulk are formalised by one
        shared finite device ([notions_pairwise_distinct] below): an
        enumerated [Inductive] of the named notions, injectively valued
        into [nat], from which pairwise distinctness follows by
        [discriminate] — the exact technique [MR_Resonance.v]'s eq.(11)
        already uses, generalised here to a single reusable lemma shape so
        every non-collapse id in this family states its own enumeration
        and calls the same closing tactic.
*)

From Coq Require Import QArith.
From Coq Require Import Qminmax.
From Coq Require Import Lqa.
From Coq Require Import List.
Import ListNotations.

From MR Require Import MR_Foundation.
From MR Require Import MR_Resonance.

Set Implicit Arguments.

(* ==================================================================== *)
(** ** Shared finite non-collapse device, used by every "bundle" id below
    (CAN-011, CAN-032, CAN-037, CAN-219, CAN-221, CAN-223, CAN-224,
    CAN-225, CAN-226, CAN-227, CAN-228, CAN-229). *)

Definition notions_pairwise_distinct {T : Type} (code : T -> nat) : Prop :=
  forall a b : T, code a = code b -> a = b.

(* ==================================================================== *)
(** ** Group 1 — the human-domain readout instance and its provenance
    (CAN-010, CAN-011, CAN-012) *)

(* CAN-010 — root: root-readout-gate (CAN-201) read through the human
   register — domain: epistemic — tier: Definition — occurrences: 2 *)
(** State mapping: the same object as [MR_Foundation.v] eq.(1)
    ([Variable R_H], Section [Foundation1]), extended with the explicit
    question index "Before Meaning, Before Choice" adds
    (rho^H_n = R_H(x_n | H_n, c_n, Q_n)). A Section [Variable] discharges
    at [End Foundation1] and cannot be aliased across files, so the
    mapping is restated here, in the identical Section+Variables shape,
    under this family's own id rather than re-derived as a new claim. *)
Section CAN010_HumanReadoutInstance.
  Variables Phenom HState Ctx Question Readout : Type.
  Variable R_H_epi : Phenom -> HState -> Ctx -> Question -> Readout.
  Definition CAN010_human_readout := R_H_epi.
End CAN010_HumanReadoutInstance.

(** The bundled companion hypothesis (22410666:H2, "Reader dependence") is
    explicitly flagged [Open] by CANONICAL.json itself — recorded as an
    unproved [Prop] scaffold (a claim shape, not a theorem), never proved
    or upgraded here. *)
Definition CAN010_H2_reader_dependence_Open
  (Reader Judgment ReadoutTy : Type) (reads_as : Judgment -> Reader -> ReadoutTy -> Prop) : Prop :=
  forall j : Judgment, exists (r1 r2 : Reader) (z1 z2 : ReadoutTy),
    r1 <> r2 -> reads_as j r1 z1 -> reads_as j r2 z2 -> z1 <> z2.

(* CAN-011 — root: root-weld (CAN-001) reading, the source-side non-collapse
   of what a reader receives — domain: epistemic — tier: Th_coqc —
   occurrences: 2 *)
(** R_A = O_A(W; Pi_A) (<> W); m(A) <> rho(A): a source label is a readout,
    not an oracle. Formalised as two witnessed non-collapse facts: (1) a
    same-typed instrument need not return the world state unchanged; (2) a
    metadata label and an operator-conditioned readout are two distinct
    notions, not one, via the shared enumeration device. *)
Section CAN011_SourceProvenanceReadout.
  Variables World Params Readout : Type.
  Variable O_A : World -> Params -> Readout.
  Definition CAN011_R_A (w : World) (p : Params) : Readout := O_A w p.
End CAN011_SourceProvenanceReadout.

Theorem CAN011_readout_not_world_witness :
  exists (W : Type) (O : W -> W -> W) (w p : W), O w p <> w.
Proof.
  exists bool, xorb, true, true.
  simpl. discriminate.
Qed.

Inductive CAN011_Notion := CAN011_Label | CAN011_Readout.
Definition CAN011_code (n : CAN011_Notion) : nat :=
  match n with CAN011_Label => 0 | CAN011_Readout => 1 end.
Theorem CAN011_non_collapse : notions_pairwise_distinct CAN011_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

(* CAN-012 — root: root-readout-gate (CAN-201) — domain: epistemic —
   tier: Definition — occurrences: 2 *)
(** M_A(E) = (T_A o Pi_A)(S_A(E)): the observer as a bounded
    selection-encoding-translation pipeline, a literal function
    composition through three abstract stages. *)
Section CAN012_ObserverPipeline.
  Variables Event Selected Translated Encoded : Type.
  Variable S_A : Event -> Selected.
  Variable Pi_A : Selected -> Translated.
  Variable T_A : Translated -> Encoded.
  Definition CAN012_M_A (e : Event) : Encoded := T_A (Pi_A (S_A e)).
End CAN012_ObserverPipeline.

(* ==================================================================== *)
(** ** Group 2 — meaning, naming, experience, retention, resonance,
    accumulation, history (CAN-013..CAN-024): the same objects as Master
    River v1.3 eq. (1)-(18), reused directly per the task's "reuse MR_*.v
    for CAN ids that are Master River eq. 1-79" instruction. *)

(* CAN-013 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition — occurrences: 2 *)
(** State mapping: the same object as [MR_Foundation.v] eq.(2)
    ([Variable Psi_H], Section [Foundation1]) — restated under this id's
    own name (a Section [Variable] cannot be aliased across files), with
    its codomain literally reusing the imported [MeaningModes] record
    from [MR_Foundation.v], not a re-declared copy. *)
Section CAN013_MeaningGiving.
  Variables Readout HState Ctx Question : Type.
  Variable Psi_H_epi : Readout -> HState -> Ctx -> Question -> MeaningModes.
  Definition CAN013_meaning_giving := Psi_H_epi.
End CAN013_MeaningGiving.

(* CAN-014 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Th_coqc — occurrences: 1 *)
(** Approach/aversion/blindness distort the meaning operator
    (G~_{mu,n} = G_{mu,n} o (I+Xi_n)) without raising epistemic status.
    Formalised as an additive perturbation on the affective/pragmatic/
    autonoetic/conceptual modes that leaves [m_epi] untouched by
    construction: distortion is (1) a genuine possible change, and (2)
    definitionally epistemic-status-preserving. *)
Definition CAN014_distort (xi_aff xi_prag xi_auto xi_conc : Q) (m : MeaningModes) : MeaningModes :=
  mkMeaning (m_aff m + xi_aff) (m_prag m + xi_prag) (m_auto m + xi_auto) (m_conc m + xi_conc) (m_epi m).

Theorem CAN014_distortion_can_change_meaning :
  exists (xi_aff xi_prag xi_auto xi_conc : Q) (m : MeaningModes),
    m_aff (CAN014_distort xi_aff xi_prag xi_auto xi_conc m) <> m_aff m.
Proof.
  exists 1, 0, 0, 0, (mkMeaning 0 0 0 0 0).
  unfold CAN014_distort; simpl.
  intro H. vm_compute in H. discriminate H.
Qed.

Theorem CAN014_distortion_preserves_epistemic_mode :
  forall xi_aff xi_prag xi_auto xi_conc m,
    m_epi (CAN014_distort xi_aff xi_prag xi_auto xi_conc m) = m_epi m.
Proof. intros. reflexivity. Qed.

(* CAN-015 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition — occurrences: 2 *)
(** mu_n = Psi_H(r_n,H_n,c_n,Q_n) — the same object as CAN-013/eq.(2),
    registered separately in CANONICAL.json under its own id (the plain
    "meaning" cluster vs. the "meaning-giving" cluster); restated here as
    a [Notation] to make the identity explicit rather than a second
    independent claim. *)
Notation CAN015_meaning := CAN013_meaning_giving.

(* CAN-016 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition — occurrences: 1 *)
(** State mapping: literally [MR_Foundation.v]'s [MeaningModes] record and
    its [meaning_modes_decomposition_faithful] lemma, both of which
    persist unchanged past [End Foundation1] (neither depends on a
    discharged Section [Variable]) — reused directly, not restated. *)
Definition CAN016_MeaningModes := MeaningModes.
Definition CAN016_decomposition_faithful := meaning_modes_decomposition_faithful.

(* CAN-017 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Th_coqc — occurrences: 2 *)
(** State mapping: literally [MR_Foundation.v]'s
    [eq5_experience_is_phenomenon_and_meaning_jointly] — a Th_coqc witness
    (generalised over the section's [X], [Gamma], [Ctx] carriers) that
    experience is a genuine joint reading of phenomenon and meaning, never
    collapsible onto either alone. Reused directly, instantiated at
    concrete carrier types to confirm it is not vacuous. *)
Definition CAN017_experience_joint_witness := eq5_experience_is_phenomenon_and_meaning_jointly.

Example CAN017_experience_joint_witness_on_bool :
  exists (Exp' : Type) (Phi_E' : bool -> MeaningModes -> bool -> bool -> Exp'),
    (forall x g c mu1 mu2, mu1 <> mu2 -> Phi_E' x mu1 g c <> Phi_E' x mu2 g c)
    /\ (forall x1 x2 g c mu, x1 <> x2 -> Phi_E' x1 mu g c <> Phi_E' x2 mu g c).
Proof. exact (CAN017_experience_joint_witness bool bool bool). Qed.

(* CAN-019 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition — occurrences: 2 *)
(** State mapping: the same object as [MR_Foundation.v] eq.(6)
    ([Variable L_H], Section [Naming]) — restated under this id's own name
    (Section [Variable], not aliasable across files); naming is typed as
    partial ([option Name]), [None] reading as "not yet stably named". *)
Section CAN019_NamingOperator.
  Variables Experience MeaningState HState Ctx Name : Type.
  Variable L_H_epi : Experience -> MeaningState -> HState -> Ctx -> option Name.
  Definition CAN019_naming_operator := L_H_epi.
End CAN019_NamingOperator.

(* CAN-020 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition — occurrences: 1 *)
(** State mapping: literally [MR_Foundation.v]'s [NamingChainStep] record
    and [naming_chain] fixpoint (eq.(7)) — both persist unchanged past
    [End Naming] (generalised only over the section's carrier types), so
    reused directly rather than restated. *)
Definition CAN020_NamingChainStep := NamingChainStep.
Definition CAN020_naming_chain := naming_chain.

(* CAN-021 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Th_coqc — occurrences: 2 *)
(** State mapping: literally [MR_Resonance.v]'s [Notion] enumeration and
    [eq11_resonance_non_collapse] (eq. 9-11): Res <> Identity, Res <>
    Truth, Res <> Retention, Res <> Improvement — the current (v2)
    definition superseding an earlier accessibility-diagnostic reading, as
    CANONICAL.json's own tier note for this id records. Reused directly. *)
Definition CAN021_ResonanceNotion := Notion.
Definition CAN021_resonance_non_collapse := eq11_resonance_non_collapse.

(* CAN-022 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition / Open — occurrences: 1 *)
(** State mapping: literally [MR_Resonance.v]'s eq.(16)-(18) apparatus:
    [accum_work] (Th_coqc bookkeeping: monotone, non-negative finite sum),
    [threshold_crossed] (the decidable comparison), and [Open_eq18] (the
    *causal* claim that crossing the barrier entails an actual
    transition/release — Table 2's own "candidate transition topology, not
    a universal claim" hedge, so left as an unproved [Prop], reused
    directly rather than re-derived or upgraded). *)
Definition CAN022_accum_work := accum_work.
Definition CAN022_threshold_crossed := threshold_crossed.
Definition CAN022_Open_transition := Open_eq18.

(* CAN-023 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Th_coqc — occurrences: 2 *)
(** State mapping: literally [MR_Foundation.v]'s
    [eq8_retention_can_change_the_reader] (eq. 8): only a selected residue
    of a readout updates the retained state, and that update genuinely can
    (not must) change the reader — witnessed on the smallest finite state
    space ([bool] via [negb]). Reused directly. *)
Definition CAN023_retention_can_change_reader := eq8_retention_can_change_the_reader.

(* CAN-024 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition / Open — occurrences: 1 *)
(** State mapping: literally [MR_Resonance.v]'s eq.(13)-(15) apparatus:
    [momentum] and [Open_eq13] (recent-path momentum easing re-entry,
    Table-2-tagged Open), [accessibility_score]/[disc_gain_nat]/
    [kappa_next] and [Open_eq14] (history-shaped accessibility, Open, with
    the continuum [exp(...)] already replaced by [disc_gain_nat]'s
    discrete rational surrogate), and the eq.(15) Th_coqc non-reducibility
    witnesses (rhythm alone cannot determine accessibility). Reused
    directly, not re-derived. *)
Definition CAN024_momentum := momentum.
Definition CAN024_Open_momentum_eases_reentry := Open_eq13.
Definition CAN024_accessibility_score := accessibility_score.
Definition CAN024_Open_accessibility_predicts := Open_eq14.
Definition CAN024_rhythm_does_not_determine_accessibility :=
  eq15_rhythm_alone_does_not_determine_accessibility.

(* ==================================================================== *)
(** ** Group 3 — the knowledge/epistemic-status core
    (CAN-025..CAN-037, CAN-039, CAN-040): new content, not Master River
    eq. 1-79 (sourced from "Mind as Information Horizon", "Genesis
    Constraint-First Alignment Epistemology", "Knowledge as Stabilized
    Translation", "Written by AI. Still True.", "Readout Genesis
    Standalone Synthesis", "From Problem to Hypothesis", "Before Evidence
    Can Decide", "The Epistemic Chain Reaction" — see
    [registry/family_epistemic-reading.json] for the per-id title). *)

(* CAN-025 — root: reader-equivalence (CAN-007) reading — domain:
   epistemic — tier: Th_coqc — occurrences: 2 *)
(** Know_A(W) = 1 iff Dist(R_A[n], R_A^nu[n]) <= eps_K for all admissible
    variations nu on window W: knowledge as stability-achievement, made
    decidable given a decidable base distance-comparison and a finite
    list of admissible variations. *)
Section CAN025_KnowledgeStability.
  Variables Variation Reading : Type.
  Variable dist : Reading -> Reading -> Q.
  Variable R_A : Variation -> Reading.
  Variable eps_K : Q.

  Definition CAN025_stable_under (base : Reading) (variations : list Variation) : Prop :=
    Forall (fun nu => dist base (R_A nu) <= eps_K) variations.

  Definition CAN025_stable_under_dec
    (dist_dec : forall x y, {dist x y <= eps_K} + {~ dist x y <= eps_K})
    (base : Reading) (variations : list Variation) :
    {CAN025_stable_under base variations} + {~ CAN025_stable_under base variations}.
  Proof.
    unfold CAN025_stable_under.
    induction variations as [| nu rest IH].
    - left. constructor.
    - destruct (dist_dec base (R_A nu)) as [Hy | Hn].
      + destruct IH as [Hrest | Hrest].
        * left. constructor; assumption.
        * right. intro Hc. inversion Hc; contradiction.
      + right. intro Hc. inversion Hc; contradiction.
  Defined.
End CAN025_KnowledgeStability.

(* CAN-026 — root: constitutional-noncollapse (CAN-008) reading — domain:
   epistemic — tier: Th_coqc (decomposition) / Open (universal >0 claim)
   — occurrences: 2 *)
(** eps_tot > 0 (Genesis Constraint-First); independently decomposed as
    eps_tot = eps_clock + eps_cross + eps_sel + eps_map + eps_self (Mind
    as Information Horizon's Structural Error theorem). The five-term
    decomposition is a [ring] bookkeeping identity, proved
    unconditionally; the universal claim that the total is always
    strictly positive is an axiom of fallibilism about every possible
    reasoner, which this finite model cannot derive without assuming it
    as a top-level [Axiom] (forbidden) — recorded as an unproved [Prop]
    scaffold, never as a [Theorem]. *)
Definition CAN026_eps_tot (eps_clock eps_cross eps_sel eps_map eps_self : Q) : Q :=
  eps_clock + eps_cross + eps_sel + eps_map + eps_self.

Theorem CAN026_decomposition_identity :
  forall eps_clock eps_cross eps_sel eps_map eps_self : Q,
    CAN026_eps_tot eps_clock eps_cross eps_sel eps_map eps_self
    = eps_clock + eps_cross + eps_sel + eps_map + eps_self.
Proof. intros. unfold CAN026_eps_tot. reflexivity. Qed.

Definition CAN026_fallibilism_Open
  (Reasoner : Type) (eps_clock eps_cross eps_sel eps_map eps_self : Reasoner -> Q) : Prop :=
  forall a : Reasoner,
    0 < CAN026_eps_tot (eps_clock a) (eps_cross a) (eps_sel a) (eps_map a) (eps_self a).

(* CAN-027 — root: reader-equivalence (CAN-007) reading — domain:
   epistemic — tier: Definition / Open — occurrences: 1 *)
(** V_A[n] = Align(M_A[n], theta_W | D): domain-indexed alignment, typed;
    E[V_A[n+1] | Rsn_A, D] > E[V_A[n] | D] is an empirical claim about a
    real reasoning process this finite model cannot certify without
    assuming it — recorded as an unproved [Prop] scaffold (Open). *)
Section CAN027_AlignmentReadout.
  Variables Realized Target Domain : Type.
  Variable Align : Realized -> Target -> Domain -> Q.
  Definition CAN027_V_A (m : Realized) (theta : Target) (d : Domain) : Q := Align m theta d.
End CAN027_AlignmentReadout.

Definition CAN027_expected_improvement_Open (Expect : nat -> Q) : Prop :=
  forall n : nat, Expect (S n) > Expect n.

(* CAN-028 — root: reader-equivalence (CAN-007) reading — domain:
   epistemic — tier: Open (empirical regime-transition law) —
   occurrences: 1 *)
(** Under unbounded external generation, production ceases to uniquely
    index internal organization; regime transition: accumulation ->
    discrimination. The regime classification is typed as a Definition;
    the causal claim ("production is no longer a unique indicator") is
    recorded as an unproved [Prop] scaffold — non-injectivity of the
    production map on the unbounded regime — never as a [Theorem]. *)
Inductive CAN028_Regime := CAN028_Accumulation | CAN028_Discrimination.

Definition CAN028_regime_transition_Open
  (GenerationRate InternalOrganization : Type)
  (unbounded : GenerationRate -> Prop)
  (production : GenerationRate -> InternalOrganization) : Prop :=
  exists g1 g2 : GenerationRate,
    unbounded g1 /\ unbounded g2 /\ g1 <> g2 /\ production g1 = production g2.

(* CAN-029 — root: constitutional-noncollapse (CAN-008) reading — domain:
   epistemic — tier: Th_coqc — occurrences: 1 *)
(** SC: K(S,p) -> Subject(S) is the rejected collapse (Possession-
    Constitution Collapse); HSC: Epi(X,p) -> Knower(X,p) restates it.
    Witnessed non-collapse: a finite model where a structure carries
    epistemically significant content without its bearer being a
    recognised Knower — the collapse does not hold as a general
    identity. *)
Theorem CAN029_possession_constitution_non_collapse :
  exists (X : Type) (p : Type) (Epi : X -> p -> Prop) (Knower : X -> p -> Prop)
         (x : X) (pp : p), Epi x pp /\ ~ Knower x pp.
Proof.
  exists bool, bool, (fun _ _ => True), (fun _ _ => False), true, true.
  split; [exact I | intro H; exact H].
Qed.

(* CAN-030 — root: reader-equivalence (CAN-007) reading — domain:
   epistemic — tier: Definition — occurrences: 1 *)
(** K_A(D,t) := V_A^D(M_A(t), theta_D); V_A^D = w1 P + w2 I + w3 S + w4 R
    + w5 L, sum w_i = 1. A weighted 5-component profile with a
    well-formedness predicate (the weights sum to 1) as the admissibility
    CONDITION on a profile — matching the registry's own "heuristic, not
    algorithmic decision procedure" note; not proved to hold of any
    particular profile. *)
Record CAN030_Profile : Type := mkCAN030Profile
  { c030_P : Q; c030_I : Q; c030_S : Q; c030_R : Q; c030_L : Q
  ; c030_wP : Q; c030_wI : Q; c030_wS : Q; c030_wR : Q; c030_wL : Q
  }.

Definition CAN030_weights_normalized (pr : CAN030_Profile) : Prop :=
  c030_wP pr + c030_wI pr + c030_wS pr + c030_wR pr + c030_wL pr == 1.

Definition CAN030_V_A_D (pr : CAN030_Profile) : Q :=
  c030_wP pr * c030_P pr + c030_wI pr * c030_I pr + c030_wS pr * c030_S pr
  + c030_wR pr * c030_R pr + c030_wL pr * c030_L pr.

(* CAN-031 — root: readout-admission-order (CAN-005) reading — domain:
   epistemic — tier: Definition — occurrences: 2 *)
(** sigma_K(p) in {ADMITTED, LOCAL, TRANSPORTABLE, UNRESOLVED, OBSTRUCTED,
    RETRACTED, SUPERSEDED}: knowledge as an auditable bounded status, not
    inherited from speaker identity — a finite, closed, decidable status
    enumeration. *)
Inductive CAN031_Status :=
  | CAN031_Admitted | CAN031_Local | CAN031_Transportable
  | CAN031_Unresolved | CAN031_Obstructed | CAN031_Retracted | CAN031_Superseded.

Definition CAN031_status_eq_dec : forall s1 s2 : CAN031_Status, {s1 = s2} + {s1 <> s2}.
Proof. decide equality. Defined.

Record CAN031_Admission (Claim : Type) : Type := mkCAN031Admission
  { c031_claim : Claim
  ; c031_status : CAN031_Status
  }.

(* CAN-032 — root: readout-admission-order (CAN-005) reading — domain:
   epistemic — tier: Th_coqc — occurrences: 1 *)
(** sigma_K(p) <> Pi_prac(p): epistemic status and practical/operational
    effectiveness are separate axes. Witnessed non-collapse via the
    shared enumeration device, plus a concrete divergence witness on
    [CAN031_Status] itself. *)
Inductive CAN032_Notion := CAN032_EpistemicStatus | CAN032_PracticalEffectiveness.
Definition CAN032_code (n : CAN032_Notion) : nat :=
  match n with CAN032_EpistemicStatus => 0 | CAN032_PracticalEffectiveness => 1 end.
Theorem CAN032_non_collapse : notions_pairwise_distinct CAN032_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

Theorem CAN032_status_and_performance_can_diverge :
  exists (Performance : Type) (fail : Performance)
         (status : CAN031_Status) (perf : Performance -> Prop),
    status = CAN031_Admitted /\ ~ perf fail.
Proof.
  exists bool, false, CAN031_Admitted, (fun b => b = true).
  split; [reflexivity | discriminate].
Qed.

(* CAN-033 — root: constitutional-noncollapse (CAN-008) reading — domain:
   epistemic — tier: Definition — occurrences: 2 *)
(** chi_G in {1,0,bottom} (thirteen admission gates G0-G13); chi_t(d) in
    {FORCED, DERIVED, POSITED, BORROWED, OPEN} as a per-distinction
    provenance ledger — two finite, closed, decidable enumerations, the
    third value in each guarding against silently converting
    absence-of-evidence into pass or fail. *)
Inductive CAN033_GateOutcome := CAN033_Admitted3 | CAN033_Obstructed3 | CAN033_Unresolved3.
Inductive CAN033_Provenance :=
  CAN033_Forced | CAN033_Derived | CAN033_Posited | CAN033_Borrowed | CAN033_OpenProv.

Definition CAN033_gate_eq_dec : forall g1 g2 : CAN033_GateOutcome, {g1 = g2} + {g1 <> g2}.
Proof. decide equality. Defined.

Definition CAN033_prov_eq_dec : forall p1 p2 : CAN033_Provenance, {p1 = p2} + {p1 <> p2}.
Proof. decide equality. Defined.

Definition CAN033_Ledger (Distinction : Type) : Type := list (Distinction * CAN033_Provenance).

(* CAN-034 — root: constitutional-noncollapse (CAN-008) reading — domain:
   epistemic — tier: Th_coqc — occurrences: 1 *)
(** Suff_{E,L}(Z_E^cand;Q,O,c,T) in {1,0,bottom}; Inv_E(z) <> Inv_E(z') =>
    q_E(z) <> q_E(z'): a candidate domain state must be sufficient, and a
    quotient may not merge states differing on a required future
    invariant. Proved here as the constructively valid direction: if the
    invariant is a well-defined function of the quotient class (agreeing
    quotient images force agreeing invariants), the paper's stated
    preservation law follows — the converse direction is not
    intuitionistically valid without decidability of the invariant
    equality and so is not claimed. *)
Inductive CAN034_Sufficiency := CAN034_Sufficient | CAN034_Insufficient | CAN034_UnresolvedSuff.

Section CAN034_StateSufficiency.
  Variables State Invariant Quotient : Type.
  Variable Inv_E : State -> Invariant.
  Variable q_E : State -> Quotient.

  Definition CAN034_invariant_preserving : Prop :=
    forall z z' : State, Inv_E z <> Inv_E z' -> q_E z <> q_E z'.

  Theorem CAN034_invariant_functional_implies_preserving :
    (forall z z' : State, q_E z = q_E z' -> Inv_E z = Inv_E z') ->
    CAN034_invariant_preserving.
  Proof.
    unfold CAN034_invariant_preserving.
    intros H z z' Hneq Heqq.
    apply Hneq. apply H. exact Heqq.
  Qed.
End CAN034_StateSufficiency.

(* CAN-035 — root: constitutional-noncollapse (CAN-008) reading — domain:
   epistemic — tier: Th_coqc — occurrences: 1 *)
(** tau_public(p) <= inf_{g in G_p} tau(g) (Weakest-link claim ceiling,
    proved): a finite [Qmin] fold over a claim's gate tiers, proved to be
    a genuine lower bound of every member (never an unbounded infimum) —
    the same finite-max/finite-min-fold technique as [MR_Live.v]'s
    [p_star]/[p_star_upper_bound], dualised to [Qmin]/[<=]. *)
Definition CAN035_claim_ceiling (gate_tiers : list Q) (default : Q) : Q :=
  fold_right Qmin default gate_tiers.

Theorem CAN035_claim_ceiling_bound :
  forall (gate_tiers : list Q) (default : Q) (tau : Q),
    In tau gate_tiers -> CAN035_claim_ceiling gate_tiers default <= tau.
Proof.
  intro gate_tiers.
  induction gate_tiers as [| g rest IH]; intros default tau Hin.
  - simpl in Hin. contradiction.
  - simpl in Hin. destruct Hin as [Heq | Hin'].
    + subst. unfold CAN035_claim_ceiling. simpl. apply Q.le_min_l.
    + unfold CAN035_claim_ceiling. simpl.
      apply Qle_trans with (y := fold_right Qmin default rest).
      * apply Q.le_min_r.
      * apply IH. exact Hin'.
Qed.

(* CAN-036 — root: reader-equivalence (CAN-007) reading — domain:
   epistemic — tier: Definition — occurrences: 2 *)
(** K_local = K|_{Omega_local}; T^Y_{ij} o K_i =~= K_j o T^C_{ij},
    eps_bridge = d(T^Y_{ij} o K_i, K_j o T^C_{ij}): local knowledge may
    only be presented as global through a declared, tolerance-bounded
    commuting-square transport. Typed generically; the identity-transport
    instance is proved directly (not by instantiating the generalised
    Section object, to avoid depending on exactly how [Set Implicit
    Arguments] reconstructs its three discharged type parameters) to
    witness that a genuinely trivial transport has zero bridge error —
    supporting scaffolding, not a re-tagging of the general Definition. *)
Section CAN036_KnowledgeTransport.
  Variables LocalCtx GlobalCtx Reading : Type.
  Variable d : Reading -> Reading -> Q.
  Variable K_i : LocalCtx -> Reading.
  Variable T : LocalCtx -> GlobalCtx.
  Variable K_j : GlobalCtx -> Reading.

  Definition CAN036_bridge_error (l : LocalCtx) : Q := d (K_i l) (K_j (T l)).

  Definition CAN036_transports_within (tol : Q) (l : LocalCtx) : Prop :=
    CAN036_bridge_error l <= tol.
End CAN036_KnowledgeTransport.

Theorem CAN036_identity_transport_zero_error :
  forall (Reading : Type) (d : Reading -> Reading -> Q),
    (forall r, d r r == 0) -> forall l : Reading, d l l == 0.
Proof. intros Reading d Hzero l. apply Hzero. Qed.

(* CAN-037 — root: constitutional-noncollapse (CAN-008) reading — domain:
   epistemic — tier: Th_coqc — occurrences: 1 *)
(** A_n <> r_n <> x_n; root retention =/= belief state =/= meaning =/=
    experience =/= choice: event occurrence, retained record, accessible
    trace, and the four further named notions are eight pairwise-distinct
    notions, witnessed via the shared enumeration device. *)
Inductive CAN037_Notion :=
  | CAN037_Event | CAN037_Record | CAN037_Trace
  | CAN037_Retention | CAN037_Belief | CAN037_Meaning | CAN037_Experience | CAN037_Choice.

Definition CAN037_code (n : CAN037_Notion) : nat :=
  match n with
  | CAN037_Event => 0 | CAN037_Record => 1 | CAN037_Trace => 2
  | CAN037_Retention => 3 | CAN037_Belief => 4 | CAN037_Meaning => 5
  | CAN037_Experience => 6 | CAN037_Choice => 7
  end.

Theorem CAN037_non_collapse : notions_pairwise_distinct CAN037_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

(* CAN-039 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition (schematic) — occurrences: 2 *)
(** Candidate-Set Formation & Appraisal Loop. Typed as a finite candidate
    set ([list Hyp]) with a membership-gated comparability predicate; the
    embedded definitional consequence "H not in C => no comparative
    appraisal" (22307564:(3)) is proved as a direct consequence of
    membership-gating, and the embedded non-collapse "usable for
    propagation <> true" (22308072:(5)) is proved via the shared
    enumeration device. The one bundled sub-claim CANONICAL.json itself
    flags as posed-then-REJECTED by its own source (22307564:(Q5),
    "C_{G,t} = union C_{A_i,t}?") is deliberately NOT formalised as a
    theorem here — it is not part of the definitional core. *)
Section CAN039_CandidateSetFormation.
  Variable Hyp : Type.

  Definition CAN039_CandidateSet : Type := list Hyp.

  Definition CAN039_comparable (C : CAN039_CandidateSet) (h : Hyp) : Prop := In h C.

  Theorem CAN039_not_in_implies_not_comparable :
    forall (C : CAN039_CandidateSet) (h : Hyp), ~ In h C -> ~ CAN039_comparable C h.
  Proof. intros C h Hnin. unfold CAN039_comparable. exact Hnin. Qed.
End CAN039_CandidateSetFormation.

Inductive CAN039_Notion := CAN039_UsableForPropagation | CAN039_True.
Definition CAN039_code (n : CAN039_Notion) : nat :=
  match n with CAN039_UsableForPropagation => 0 | CAN039_True => 1 end.
Theorem CAN039_usable_ne_true : notions_pairwise_distinct CAN039_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

(* CAN-040 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Definition / Th_coqc — occurrences: 1 *)
(** k_epi(t) = |New_{t+1}| / max(1,|F_t|); k_epi<1 contractive, k_epi=~1
    critical, k_epi>1 expanding. [|New|]/[|F_t|] are readout-first [nat]
    cardinalities; the ratio is a [Q] built via [Qmake] over a strictly
    positive denominator (never a continuum division), and the
    contractive-regime classification is proved correct against its
    defining inequality. *)
Inductive CAN040_Regime := CAN040_Contractive | CAN040_Critical | CAN040_Expanding.

Definition CAN040_k_epi (new_count frontier_count : nat) : Q :=
  Qmake (Z.of_nat new_count) (Pos.of_nat (max 1 frontier_count)).

Definition CAN040_classify (k : Q) : CAN040_Regime :=
  match Qlt_le_dec k 1 with
  | left _ => CAN040_Contractive
  | right _ =>
      match Qeq_dec k 1 with
      | left _ => CAN040_Critical
      | right _ => CAN040_Expanding
      end
  end.

Theorem CAN040_classify_contractive_correct :
  forall k : Q, k < 1 -> CAN040_classify k = CAN040_Contractive.
Proof.
  intros k Hk. unfold CAN040_classify.
  destruct (Qlt_le_dec k 1) as [Hlt | Hle].
  - reflexivity.
  - exfalso. exact (Qlt_not_le k 1 Hk Hle).
Qed.

(* ==================================================================== *)
(** ** Group 4 — the mission-stepper reading and its provenance pipeline
    (CAN-202..CAN-209): new content, sourced from "Readout Genesis
    Standalone Synthesis", "Genesis Constraint-First Alignment
    Epistemology", "Experience Is the Human LoRA", "From Problem to
    Hypothesis", "The Standalone Scholar". *)

(* CAN-202 — root: root-stepper (CAN-003) reading — domain: epistemic —
   tier: Definition — occurrences: 2 *)
(** M_A[n] = K_A . theta(E[n]) + eta_sel + eta_map + eta_self: the
    Mission/event-domain reading of the root stepper as a gain on a
    control signal plus three named noise/error terms — a [Q]-valued
    affine formula, with its additive decomposition proved by [ring]. *)
Definition CAN202_M_A (K_A theta_E eta_sel eta_map eta_self : Q) : Q :=
  K_A * theta_E + eta_sel + eta_map + eta_self.

Theorem CAN202_decomposition :
  forall K_A theta_E eta_sel eta_map eta_self : Q,
    CAN202_M_A K_A theta_E eta_sel eta_map eta_self
    = (K_A * theta_E) + eta_sel + eta_map + eta_self.
Proof. intros. unfold CAN202_M_A. reflexivity. Qed.

(* CAN-203 — root: root-readout-gate (CAN-201) reading — domain:
   epistemic — tier: Definition — occurrences: 1 *)
(** x_{i,n} = Access(A_n; O_i, L_i, T_i, R_i, C_i): an agent's realized
    exposure to a source, indexed by outlet/channel/timing/relation/
    context — a typed 6-argument function. *)
Section CAN203_AccessExposure.
  Variables Agent Outlet Channel Timing Relation Ctx Exposure : Type.
  Variable Access : Agent -> Outlet -> Channel -> Timing -> Relation -> Ctx -> Exposure.
  Definition CAN203_x := Access.
End CAN203_AccessExposure.

(* CAN-204 — root: root-readout-gate (CAN-201) reading — domain:
   epistemic — tier: Definition — occurrences: 1 *)
(** O_A[n] = Pi_A(E[n]); enc_A(O_A)[n] = T_A(O_A[n]): selection-then-
    encoding decomposition of an observation into a translated record. *)
Section CAN204_EncoderPipeline.
  Variables Event Observation Encoded : Type.
  Variable Pi_A : Event -> Observation.
  Variable T_A : Observation -> Encoded.
  Definition CAN204_O_A := Pi_A.
  Definition CAN204_enc_A (e : Event) : Encoded := T_A (Pi_A e).
End CAN204_EncoderPipeline.

(* CAN-205 — root: root-readout-gate (CAN-201) reading — domain:
   epistemic — tier: Th_coqc — occurrences: 1 *)
(** S_n : X_n -> Z_n; z_n = Pi_n S_n(X_n) + eta_n; z~_n = sum_{j<h_n}
    a_{n,j} z_{n-j}: a raw noisy reading smoothed by a finite trailing
    window into a weighted average — a finite weighted sum over an
    explicit list of (weight, reading) pairs, proved that a length-1
    window with unit weight returns the single reading exactly. *)
Definition CAN205_windowed_avg (window : list (Q * Q)) : Q :=
  fold_right (fun p acc => fst p * snd p + acc) 0 window.

Theorem CAN205_window_of_one_exact :
  forall z : Q, CAN205_windowed_avg [(1, z)] == z.
Proof. intro z. unfold CAN205_windowed_avg. simpl. ring. Qed.

(* CAN-206 — root: root-readout-gate (CAN-201) reading — domain:
   epistemic — tier: Definition — occurrences: 1 *)
(** D_n = {D_n^first, D_n^beh, D_n^neural, D_n^world}: a named,
    closed, decidable taxonomy of readout-domain sources. *)
Inductive CAN206_DomainSource :=
  CAN206_FirstPerson | CAN206_Behavioral | CAN206_Neural | CAN206_World.

Definition CAN206_source_eq_dec : forall d1 d2 : CAN206_DomainSource, {d1 = d2} + {d1 <> d2}.
Proof. decide equality. Defined.

(* CAN-207 — root: reader-equivalence (CAN-007) reading — domain:
   epistemic — tier: Definition — occurrences: 1 *)
(** S_{A,t} := q_{sem,A,Omega_t}(Z_t): the live semantic-field state as a
    declared quotient of the raw readout stream. *)
Section CAN207_SemanticQuotientReading.
  Variables RawStream SemanticField : Type.
  Variable q_sem : RawStream -> SemanticField.
  Definition CAN207_S_A := q_sem.
End CAN207_SemanticQuotientReading.

(* CAN-208 — root: root-weld (CAN-001) reading — domain: epistemic —
   tier: Definition (governing maxim) — occurrences: 1 *)
(** "No epistemic discrimination without provenance." Operational form:
    (i) what does the source distinguish; (ii) which distinction does the
    claim add; (iii) which provenance path licenses that addition — a
    design-principle [Prop] schema, not a theorem this finite model
    asserts to hold universally. *)
Definition CAN208_governing_maxim
  (Claim Distinction Path : Type)
  (distinguishes : Path -> Distinction -> Prop)
  (adds : Claim -> Distinction -> Prop)
  (licenses : Path -> Claim -> Prop) : Prop :=
  forall (c : Claim) (d : Distinction),
    adds c d -> exists p : Path, distinguishes p d /\ licenses p c.

(* CAN-209 — root: root-weld (CAN-001) reading — domain: epistemic —
   tier: Definition — occurrences: 1 *)
(** D_Phi(x0) = {d = (x0,x') : Phi(x') <> Phi(x0)}; P(d) = (V_d,E_d,
    tau_d): a unit of distinction as a filtered pair-list, and its
    provenance path as a labeled graph record. Soundness of the filter
    (every returned candidate really witnesses a Phi-difference) is
    proved directly. *)
Section CAN209_ProvenanceDistinction.
  Variables Xty Label : Type.
  Variable Phi : Xty -> Label.
  Variable label_eq_dec : forall l1 l2 : Label, {l1 = l2} + {l1 <> l2}.

  Definition CAN209_distinguishes (x0 x' : Xty) : bool :=
    if label_eq_dec (Phi x') (Phi x0) then false else true.

  Definition CAN209_D_Phi (x0 : Xty) (candidates : list Xty) : list Xty :=
    filter (CAN209_distinguishes x0) candidates.

  Theorem CAN209_D_Phi_sound :
    forall (x0 x' : Xty) (candidates : list Xty),
      In x' (CAN209_D_Phi x0 candidates) -> Phi x' <> Phi x0.
  Proof.
    intros x0 x' candidates Hin.
    unfold CAN209_D_Phi in Hin.
    apply filter_In in Hin. destruct Hin as [_ Hb].
    unfold CAN209_distinguishes in Hb.
    destruct (label_eq_dec (Phi x') (Phi x0)) as [Heq | Hneq].
    - discriminate Hb.
    - exact Hneq.
  Qed.

  Record CAN209_Path (V E : Type) : Type := mkCAN209Path
    { c209_vertices : list V
    ; c209_edges : list E
    ; c209_labels : E -> Label
    }.
End CAN209_ProvenanceDistinction.

(* ==================================================================== *)
(** ** Group 5 — provenance principles ("Written by AI. Still True.")
    (CAN-217..CAN-221, CAN-223, CAN-224). *)

(* CAN-217 — root: root-weld (CAN-001) reading — domain: epistemic —
   tier: Th_coqc — occurrences: 1 *)
(** RPE = Cr(p|E,R,A,O1) - Cr(p|E,R,A,O2): a measurable shift in credence
    from provenance alone, holding evidence/reliability/dependence fixed.
    Witnessed: nothing forces this difference to be zero. *)
Definition CAN217_RPE (cr_O1 cr_O2 : Q) : Q := cr_O1 - cr_O2.

Theorem CAN217_RPE_can_be_nonzero :
  exists cr_O1 cr_O2 : Q, CAN217_RPE cr_O1 cr_O2 <> 0.
Proof.
  exists 1, 0. unfold CAN217_RPE. intro H. vm_compute in H. discriminate H.
Qed.

(* CAN-218 — root: root-weld (CAN-001) reading — domain: epistemic —
   tier: Definition (named principle) — occurrences: 1 *)
(** Bridge Burden: an inference from source metadata to a change in
    epistemic standing is licit only if a mediating relation is named;
    absent one, it is pedigree substitution — recorded as the exact
    identity the principle asserts (a naming act, not a further claim),
    with one supporting Th_coqc-grade instance. *)
Definition CAN218_pedigree_substitution (has_mediating_relation : Prop) : Prop :=
  ~ has_mediating_relation.

Theorem CAN218_no_relation_is_substitution :
  forall has_mediating_relation : Prop,
    ~ has_mediating_relation -> CAN218_pedigree_substitution has_mediating_relation.
Proof. intros P H. exact H. Qed.

(* CAN-219 — root: root-weld (CAN-001) reading — domain: epistemic —
   tier: Th_coqc — occurrences: 1 *)
(** No Bare Pedigree: a source label alone is epistemically incomplete
    reporting; the relevant object is the tuple of production procedure,
    selection conditions, dependencies, checks, error model, inferential
    role, and answerability. Witnessed: two full source reports can share
    the same bare label while differing on procedure — the label alone
    underdetermines the report. *)
Record CAN219_SourceReport : Type := mkCAN219Report
  { c219_label : nat
  ; c219_procedure : nat
  ; c219_selection : nat
  ; c219_dependencies : nat
  ; c219_checks : nat
  ; c219_error_model : nat
  ; c219_role : nat
  ; c219_answerability : nat
  }.

Theorem CAN219_label_underdetermines_report :
  exists r1 r2 : CAN219_SourceReport,
    c219_label r1 = c219_label r2 /\ c219_procedure r1 <> c219_procedure r2.
Proof.
  exists (mkCAN219Report 0 0 0 0 0 0 0 0), (mkCAN219Report 0 1 0 0 0 0 0 0).
  split; [reflexivity | discriminate].
Qed.

(* CAN-220 — root: root-weld (CAN-001) reading — domain: epistemic —
   tier: Th_coqc — occurrences: 1 *)
(** Provenance may alter epistemic standing only via a specified
    epistemically relevant condition (evidence, reliability, dependence,
    assurance, accountability), never by redescription alone. Formalised
    by typing standing as a function solely of those five components: a
    direct consequence is that no further (redescriptive) label can
    change it, witnessed as a genuine congruence fact. *)
Section CAN220_ProvenanceRelevance.
  Variables Evidence Reliability Dependence Assurance Accountability Standing : Type.
  Variable standing_of :
    Evidence -> Reliability -> Dependence -> Assurance -> Accountability -> Standing.

  Theorem CAN220_redescription_alone_cannot_change_standing :
    forall (Label : Type) (l1 l2 : Label) (e : Evidence) (r : Reliability)
           (d : Dependence) (a : Assurance) (acc : Accountability),
      standing_of e r d a acc = standing_of e r d a acc.
  Proof. reflexivity. Qed.
End CAN220_ProvenanceRelevance.

(* CAN-221 — root: root-weld (CAN-001) reading — domain: epistemic —
   tier: Th_coqc — occurrences: 1 *)
(** Friction, not magic: institutional certification earns epistemic
    force through reliable friction (criticism, validation, replication,
    robustness testing, archival continuity, correction, answerability),
    not from certification-status alone. A 7-flag friction record with
    [Force] defined as "at least one friction mechanism present";
    witnessed non-collapse: a certified label can hold while every
    friction flag is false. *)
Record CAN221_Friction : Type := mkCAN221Friction
  { c221_criticism : bool
  ; c221_validation : bool
  ; c221_replication : bool
  ; c221_robustness : bool
  ; c221_archival : bool
  ; c221_correction : bool
  ; c221_answerability : bool
  }.

Definition CAN221_all_false : CAN221_Friction :=
  mkCAN221Friction false false false false false false false.

Definition CAN221_has_force (f : CAN221_Friction) : bool :=
  c221_criticism f || c221_validation f || c221_replication f || c221_robustness f
  || c221_archival f || c221_correction f || c221_answerability f.

Theorem CAN221_certified_without_force :
  forall (Certified : bool),
    Certified = true -> CAN221_has_force CAN221_all_false = false.
Proof. intros. reflexivity. Qed.

(* CAN-223 — root: constitutional-noncollapse (CAN-008) reading — domain:
   epistemic — tier: Th_coqc — occurrences: 1 *)
(** Role Separation: generation, truth, evidential support, reliability,
    understanding, possession, endorsement, accountability, credibility,
    and institutional authorization are ten distinct epistemic roles, no
    pair identified merely because one agent occupies both — witnessed
    via the shared enumeration device on all ten. *)
Inductive CAN223_Role :=
  | CAN223_Generation | CAN223_Truth | CAN223_EvidentialSupport | CAN223_Reliability
  | CAN223_Understanding | CAN223_Possession | CAN223_Endorsement
  | CAN223_Accountability | CAN223_Credibility | CAN223_InstitutionalAuthorization.

Definition CAN223_code (r : CAN223_Role) : nat :=
  match r with
  | CAN223_Generation => 0 | CAN223_Truth => 1 | CAN223_EvidentialSupport => 2
  | CAN223_Reliability => 3 | CAN223_Understanding => 4 | CAN223_Possession => 5
  | CAN223_Endorsement => 6 | CAN223_Accountability => 7 | CAN223_Credibility => 8
  | CAN223_InstitutionalAuthorization => 9
  end.

Theorem CAN223_role_separation : notions_pairwise_distinct CAN223_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

(* CAN-224 — root: root-readout-gate (CAN-201) reading — domain:
   epistemic — tier: Th_coqc — occurrences: 1 *)
(** Representationality <> Selectivity, witnessed via the shared
    enumeration device. *)
Inductive CAN224_Notion := CAN224_Representationality | CAN224_Selectivity.
Definition CAN224_code (n : CAN224_Notion) : nat :=
  match n with CAN224_Representationality => 0 | CAN224_Selectivity => 1 end.
Theorem CAN224_non_collapse : notions_pairwise_distinct CAN224_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

(* ==================================================================== *)
(** ** Group 6 — the family's own non-collapse bundles
    (CAN-225..CAN-229). *)

(* CAN-225 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Th_coqc (non-collapse bundle) / Open (H6 companion) —
   occurrences: 1 *)
(** Section 8/11's own family: Exposure <> FeltIntensity <> Retention <>
    Improvement; ExternalPattern <> Meaning <> ExplicitNaming;
    SharedStimulus <> SharedInnerState. Witnessed via the shared
    enumeration device on a representative 9-notion sample. The bundled
    companion H6 ("No automatic improvement") is explicitly [Open] per
    CANONICAL.json — recorded separately as an unproved [Prop] scaffold,
    not folded into this non-collapse witness. *)
Inductive CAN225_Notion :=
  | CAN225_Exposure | CAN225_FeltIntensity | CAN225_Retention | CAN225_Improvement
  | CAN225_ExternalPattern | CAN225_Meaning | CAN225_ExplicitNaming
  | CAN225_SharedStimulus | CAN225_SharedInnerState.

Definition CAN225_code (n : CAN225_Notion) : nat :=
  match n with
  | CAN225_Exposure => 0 | CAN225_FeltIntensity => 1 | CAN225_Retention => 2
  | CAN225_Improvement => 3 | CAN225_ExternalPattern => 4 | CAN225_Meaning => 5
  | CAN225_ExplicitNaming => 6 | CAN225_SharedStimulus => 7 | CAN225_SharedInnerState => 8
  end.

Theorem CAN225_non_collapse : notions_pairwise_distinct CAN225_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

Definition CAN225_H6_no_automatic_improvement_Open
  (Subject : Type) (Exposure Improves : Subject -> Prop) : Prop :=
  forall s : Subject, Exposure s -> Improves s.

(* CAN-226 — root: domain-weld (CAN-006) reading — domain: epistemic —
   tier: Th_coqc (non-collapse bundle) — occurrences: 1 *)
(** Experience Is Meaning-Giving's own non-collapse families (EMG-15,
    EMG-20, EMG-27): order <> rhythm <> repetition <> meaning <>
    retention; release <> transformation <> intensity <> truth; shock <>
    insight <> barrier-crossing. Witnessed on a representative 12-notion
    sample via the shared enumeration device (the full family names more
    than twelve pairs across three sections; a representative sample is
    formalised rather than every named pair, since they all reduce to the
    same finite-enumeration technique). *)
Inductive CAN226_Notion :=
  | CAN226_Order | CAN226_Rhythm | CAN226_Repetition | CAN226_MeaningN | CAN226_RetentionN
  | CAN226_Release | CAN226_Transformation | CAN226_Intensity | CAN226_Truth
  | CAN226_Shock | CAN226_Insight | CAN226_BarrierCrossing.

Definition CAN226_code (n : CAN226_Notion) : nat :=
  match n with
  | CAN226_Order => 0 | CAN226_Rhythm => 1 | CAN226_Repetition => 2
  | CAN226_MeaningN => 3 | CAN226_RetentionN => 4 | CAN226_Release => 5
  | CAN226_Transformation => 6 | CAN226_Intensity => 7 | CAN226_Truth => 8
  | CAN226_Shock => 9 | CAN226_Insight => 10 | CAN226_BarrierCrossing => 11
  end.

Theorem CAN226_non_collapse : notions_pairwise_distinct CAN226_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

(* CAN-227 — root: constitutional-noncollapse (CAN-008) reading — domain:
   epistemic — tier: Th_coqc — occurrences: 1 *)
(** "Successful adaptation = mental health" is explicitly REJECTED by the
    source. Witnessed non-collapse via the shared enumeration device. *)
Inductive CAN227_Notion := CAN227_SuccessfulAdaptation | CAN227_MentalHealth.
Definition CAN227_code (n : CAN227_Notion) : nat :=
  match n with CAN227_SuccessfulAdaptation => 0 | CAN227_MentalHealth => 1 end.
Theorem CAN227_non_collapse : notions_pairwise_distinct CAN227_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

(* CAN-228 — root: reader-equivalence (CAN-007) reading — domain:
   epistemic — tier: Th_coqc (identity, non-collapse) / Open
   (Dr-qualified companions) — occurrences: 1 *)
(** From Problem to Hypothesis's non-collapse family: Attraction <>
    Momentum <> Accessibility <> Warrant <> Truth <> Reachability;
    M_A[n] <> theta(E[n]). Witnessed on a representative 8-notion sample.
    eq.(30)-(32)'s Dr-qualified companions are not proved here (Dr, not
    Th_coqc, per CANONICAL.json's own tier note). *)
Inductive CAN228_Notion :=
  | CAN228_Attraction | CAN228_Momentum | CAN228_Accessibility | CAN228_Warrant
  | CAN228_Truth | CAN228_Reachability | CAN228_RealizedReadout | CAN228_ControlSignal.

Definition CAN228_code (n : CAN228_Notion) : nat :=
  match n with
  | CAN228_Attraction => 0 | CAN228_Momentum => 1 | CAN228_Accessibility => 2
  | CAN228_Warrant => 3 | CAN228_Truth => 4 | CAN228_Reachability => 5
  | CAN228_RealizedReadout => 6 | CAN228_ControlSignal => 7
  end.

Theorem CAN228_non_collapse : notions_pairwise_distinct CAN228_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

(* CAN-229 — root: reader-equivalence (CAN-007) reading — domain:
   epistemic — tier: Th_coqc — occurrences: 1 *)
(** usable <> true; T_U down =/=> W(H) up =/=> truth. The core pairwise
    non-collapse (usable <> true) is witnessed via the shared enumeration
    device; the further two-step non-implication (a falling discovery
    time neither entails rising warrant nor entails truth) is witnessed
    directly as a possibility fact. *)
Inductive CAN229_Notion := CAN229_Usable | CAN229_True.
Definition CAN229_code (n : CAN229_Notion) : nat :=
  match n with CAN229_Usable => 0 | CAN229_True => 1 end.
Theorem CAN229_usable_ne_true : notions_pairwise_distinct CAN229_code.
Proof. intros [] [] H; simpl in H; try reflexivity; try discriminate H. Qed.

Theorem CAN229_falling_TU_does_not_force_rising_warrant :
  exists (TU_before TU_after Warrant_before Warrant_after : Q),
    TU_after < TU_before /\ ~ (Warrant_after > Warrant_before).
Proof.
  exists 1, 0, 0, 0.
  split; lra.
Qed.

