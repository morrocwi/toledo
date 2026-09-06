# LEDGER_epistemic-reading.md — Coq Canon Ledger, family: epistemic-reading

One row per CAN id. `Print Assumptions` result is from a direct check
(`coqc -Q coq_canon MRC -Q coq MR <scratch file requiring MRC_epistemic_reading>`,
then `Print Assumptions <identifier>` on every proved identifier and every
constructive `Defined` term below) — re-run after any change to
`MRC_epistemic_reading.v`.

Family assignment: every CAN id in `registry/CANONICAL.json` with
`domain == "epistemic"` (49 ids, written out in full to
`registry/family_epistemic-reading.json`). This is **not** the root-spine
family (`spine_ids` in `registry/COLLAPSE.md`), so this pass produces no
`MRC_master.v`.

Compilation: `coqc -Q coq_canon MRC -Q coq MR coq_canon/MRC_epistemic_reading.v`
— one file, compiled alone (never alongside a full-repo/full-arc audit), per
the standing "no repeated full-arc re-audits" workflow rule. Result: **clean
compile, 0 errors, 0 `Admitted`, 0 top-level `Axiom`/`Parameter`.**

## Reuse of Master River eq. (1)-(18) (Block A, `MR_Foundation.v` /
`MR_Resonance.v`)

Eleven of the 49 ids (CAN-013/014/015/016/017/019/020 and
CAN-021/022/023/024) restate content Master River v1.3 Block A already
formalises, verbatim from the same source manuscripts CANONICAL.json cites
for these ids ("Experience Is Meaning-Giving", "Meaning Before Naming",
"Before Meaning, Before Choice"). Where the Master River object is a
persisting identifier (a `Record`/`Fixpoint`/`Theorem` not depending on a
discharged Section `Variable`), this file reuses it directly by a thin
`Definition CANnnn_x := mr_identifier.` alias — see the "reuse of" column
below. Where the Master River object was itself a bare Section `Variable`
(eq. 1/2/4/6), a `Variable` discharges at `End` and cannot be aliased
across files, so the mapping is instead restated in the identical
Section+Variables+comment shape under the CAN id's own name, with an
explicit in-file note that it is the same object, not a second one — this
is **not** a re-derivation or a second independent claim.

## Table

| CAN id | key | Coq tier | Identifier(s) | Reuse of (Master River) | `Print Assumptions` |
|---|---|---|---|---|---|
| CAN-010 | human-readout-instance | Definition (+ Open H2) | `CAN010_human_readout_instance` (Section `CAN010_HumanReadoutInstance`); `CAN010_H2_reader_dependence_Open` | MR_Foundation.v eq.(1) `R_H` (Variable, restated) | n/a (Definition; Open Prop not proved) |
| CAN-011 | source-provenance-readout | Th_coqc | `CAN011_R_A`; `CAN011_readout_not_world_witness`; `CAN011_Notion`/`CAN011_non_collapse` | — (new) | Both theorems: Closed under the global context |
| CAN-012 | observer-pipeline | Definition | `CAN012_M_A` | — (new) | n/a |
| CAN-013 | meaning-giving | Definition | `CAN013_meaning_giving` | MR_Foundation.v eq.(2) `Psi_H` (Variable, restated; codomain reuses `MeaningModes`) | n/a |
| CAN-014 | meaning-distortion | Th_coqc | `CAN014_distort`; `CAN014_distortion_can_change_meaning`; `CAN014_distortion_preserves_epistemic_mode` | — (new) | Both theorems: Closed under the global context |
| CAN-015 | meaning | Definition | `CAN015_meaning` (`Notation` alias for `CAN013_meaning_giving`) | same object as CAN-013 / MR eq.(2) | n/a |
| CAN-016 | meaning-modes | Definition | `CAN016_MeaningModes`; `CAN016_decomposition_faithful` | MR_Foundation.v eq.(3) `MeaningModes` + `meaning_modes_decomposition_faithful`, reused directly | Closed under the global context |
| CAN-017 | experience-equation | Th_coqc | `CAN017_experience_joint_witness`; `CAN017_experience_joint_witness_on_bool` | MR_Foundation.v eq.(5) `eq5_experience_is_phenomenon_and_meaning_jointly`, reused directly | Both: Closed under the global context |
| CAN-019 | naming-operator | Definition | `CAN019_naming_operator` | MR_Foundation.v eq.(6) `L_H` (Variable, restated) | n/a |
| CAN-020 | naming-loop | Definition | `CAN020_NamingChainStep`; `CAN020_naming_chain` | MR_Foundation.v eq.(7) `NamingChainStep`/`naming_chain`, reused directly | Closed under the global context |
| CAN-021 | resonance | Th_coqc | `CAN021_ResonanceNotion`; `CAN021_resonance_non_collapse` | MR_Resonance.v eq.(9)-(11) `Notion`/`eq11_resonance_non_collapse`, reused directly | Closed under the global context |
| CAN-022 | accumulation-barrier | Definition / Open | `CAN022_accum_work`; `CAN022_threshold_crossed`; `CAN022_Open_transition` | MR_Resonance.v eq.(16)-(18), reused directly | `accum_work` bookkeeping: Closed under the global context; `Open_eq18`: n/a (Open Prop) |
| CAN-023 | retention-update | Th_coqc | `CAN023_retention_can_change_reader` | MR_Foundation.v eq.(8) `eq8_retention_can_change_the_reader`, reused directly | Closed under the global context |
| CAN-024 | history-accessibility | Definition / Open | `CAN024_momentum`; `CAN024_Open_momentum_eases_reentry`; `CAN024_accessibility_score`; `CAN024_Open_accessibility_predicts`; `CAN024_rhythm_does_not_determine_accessibility` | MR_Resonance.v eq.(13)-(15), reused directly | eq.15 witness: Closed under the global context; eq.13/14 Open Props: n/a |
| CAN-025 | knowledge-stability | Th_coqc | `CAN025_stable_under`; `CAN025_stable_under_dec` | — (new) | `CAN025_stable_under_dec`: Closed under the global context |
| CAN-026 | fallibilism-axiom | Th_coqc (decomposition) / Open (universal >0) | `CAN026_eps_tot`; `CAN026_decomposition_identity`; `CAN026_fallibilism_Open` | — (new) | `CAN026_decomposition_identity`: Closed under the global context; `CAN026_fallibilism_Open`: n/a (Open Prop, not proved) |
| CAN-027 | alignment-readout | Definition / Open | `CAN027_V_A`; `CAN027_expected_improvement_Open` | — (new) | n/a (Definition; Open Prop not proved) |
| CAN-028 | generative-abundance-law | Open | `CAN028_Regime`; `CAN028_regime_transition_Open` | — (new) | n/a (Open Prop, not proved by design) |
| CAN-029 | knower-constitution | Th_coqc | `CAN029_possession_constitution_non_collapse` | — (new) | Closed under the global context |
| CAN-030 | context-indexed-evaluation | Definition | `CAN030_Profile`; `CAN030_weights_normalized`; `CAN030_V_A_D` | — (new) | n/a |
| CAN-031 | knowledge-admission | Definition | `CAN031_Status`; `CAN031_status_eq_dec`; `CAN031_Admission` | — (new) | `CAN031_status_eq_dec`: Closed under the global context |
| CAN-032 | practical-effectiveness | Th_coqc | `CAN032_Notion`/`CAN032_non_collapse`; `CAN032_status_and_performance_can_diverge` | — (new) | Both: Closed under the global context |
| CAN-033 | tier-ledger | Definition | `CAN033_GateOutcome`; `CAN033_Provenance`; `CAN033_gate_eq_dec`; `CAN033_prov_eq_dec`; `CAN033_Ledger` | — (new) | both `_eq_dec`: Closed under the global context |
| CAN-034 | state-sufficiency | Th_coqc | `CAN034_Sufficiency`; `CAN034_invariant_preserving`; `CAN034_invariant_functional_implies_preserving` | — (new) | Closed under the global context |
| CAN-035 | claim-ceiling | Th_coqc | `CAN035_claim_ceiling`; `CAN035_claim_ceiling_bound` | dualises MR_Live.v `p_star`/`p_star_upper_bound` (`Qmax`) to `Qmin` | Closed under the global context |
| CAN-036 | knowledge-transport | Definition | `CAN036_bridge_error`; `CAN036_transports_within`; `CAN036_identity_transport_zero_error` | — (new) | supporting witness: Closed under the global context |
| CAN-037 | memk-record-noncollapse | Th_coqc | `CAN037_Notion`; `CAN037_non_collapse` | — (new) | Closed under the global context |
| CAN-039 | B-EPI-CANDSET | Definition | `CAN039_CandidateSet`; `CAN039_comparable`; `CAN039_not_in_implies_not_comparable`; `CAN039_Notion`/`CAN039_usable_ne_true` | — (new) | both proved facts: Closed under the global context |
| CAN-040 | B-EPI-KEPI | Definition / Th_coqc | `CAN040_Regime`; `CAN040_k_epi`; `CAN040_classify`; `CAN040_classify_contractive_correct` | — (new) | Closed under the global context |
| CAN-202 | mission-stepper-reading | Definition | `CAN202_M_A`; `CAN202_decomposition` | — (new) | Closed under the global context |
| CAN-203 | access-exposure-function | Definition | `CAN203_x` | — (new) | n/a |
| CAN-204 | encoder-pipeline | Definition | `CAN204_O_A`; `CAN204_enc_A` | — (new) | n/a |
| CAN-205 | windowed-sensor-readout | Th_coqc | `CAN205_windowed_avg`; `CAN205_window_of_one_exact` | — (new) | Closed under the global context |
| CAN-206 | domain-taxonomy-Dn | Definition | `CAN206_DomainSource`; `CAN206_source_eq_dec` | — (new) | `CAN206_source_eq_dec`: Closed under the global context |
| CAN-207 | semantic-quotient-reading | Definition | `CAN207_S_A` | — (new) | n/a |
| CAN-208 | provenance-governing-maxim | Definition | `CAN208_governing_maxim` | — (new) | n/a (Prop schema, not proved) |
| CAN-209 | provenance-distinction-and-path | Definition | `CAN209_distinguishes`; `CAN209_D_Phi`; `CAN209_D_Phi_sound`; `CAN209_Path` | — (new) | `CAN209_D_Phi_sound`: Closed under the global context |
| CAN-217 | residual-provenance-effect | Th_coqc | `CAN217_RPE`; `CAN217_RPE_can_be_nonzero` | — (new) | Closed under the global context |
| CAN-218 | bridge-burden-principle | Definition | `CAN218_pedigree_substitution`; `CAN218_no_relation_is_substitution` | — (new) | Closed under the global context |
| CAN-219 | no-bare-pedigree-principle | Th_coqc | `CAN219_SourceReport`; `CAN219_label_underdetermines_report` | — (new) | Closed under the global context |
| CAN-220 | provenance-relevance-constraint | Th_coqc | `CAN220_redescription_alone_cannot_change_standing` | — (new) | Closed under the global context |
| CAN-221 | friction-not-magic-principle | Th_coqc | `CAN221_Friction`; `CAN221_all_false`/`CAN221_has_force`; `CAN221_certified_without_force` | — (new) | Closed under the global context |
| CAN-223 | role-separation-principle | Th_coqc | `CAN223_Role`; `CAN223_code`; `CAN223_role_separation` | — (new) | Closed under the global context |
| CAN-224 | representationality-selectivity-noncollapse | Th_coqc | `CAN224_Notion`; `CAN224_non_collapse` | — (new) | Closed under the global context |
| CAN-225 | affective-semantic-non-collapse-bundle | Th_coqc (bundle) / Open (H6) | `CAN225_Notion`; `CAN225_non_collapse`; `CAN225_H6_no_automatic_improvement_Open` | — (new) | `CAN225_non_collapse`: Closed under the global context; H6: n/a (Open Prop) |
| CAN-226 | meaning-giving-non-collapse-bundle | Th_coqc | `CAN226_Notion`; `CAN226_non_collapse` | — (new) | Closed under the global context |
| CAN-227 | human-lora-adaptation-non-collapse | Th_coqc | `CAN227_Notion`; `CAN227_non_collapse` | — (new) | Closed under the global context |
| CAN-228 | hypothesis-space-non-collapse-bundle | Th_coqc (bundle) / Open (Dr companions) | `CAN228_Notion`; `CAN228_non_collapse` | — (new) | Closed under the global context |
| CAN-229 | discovery-topology-non-collapse-bundle | Th_coqc | `CAN229_Notion`; `CAN229_usable_ne_true`; `CAN229_falling_TU_does_not_force_rising_warrant` | — (new) | Both: Closed under the global context |

## Tiering notes

- **CAN-010**: restates Master River eq.(1) under this family's own id
  (a Section `Variable` cannot be aliased across compiled files); the
  bundled companion hypothesis H2 ("Reader dependence", 22410666) is
  explicitly `[Open]` per CANONICAL.json's own tier field and is recorded
  as an unproved `Prop` scaffold, never a `Theorem`.
- **CAN-013/015/016/017/019/020/021/022/023/024**: the eleven-id reuse
  block. CAN-015 is registered as a distinct id in CANONICAL.json from
  CAN-013 but is symbol-identical (`mu_n = Psi_H(...)`), so it is a
  `Notation` alias rather than a second independent object. CAN-022 and
  CAN-024 each carry an Open sub-part inherited unchanged from
  `MR_Resonance.v`'s own tiering (the *causal*/empirical claims, not the
  bookkeeping around them) — this file does not re-litigate or upgrade
  those Open tiers.
- **CAN-026**: the five-term decomposition of `eps_tot` is a definitional
  identity (proved by `reflexivity` once unfolded — not `ring`, since Q's
  `ring` structure is registered for `==`, not Leibniz `=`, and the two
  sides here are literally the same term); the universal claim "every
  reasoner's total error is strictly positive" is an axiom of fallibilism
  about every possible reasoner, which no finite Coq model can derive
  without assuming it as a top-level `Axiom` (forbidden by this pass's
  discipline) — recorded as `CAN026_fallibilism_Open`, an unproved `Prop`.
- **CAN-028**: "production ceases to uniquely index internal
  organization" is formalised as non-injectivity of the production map on
  the unbounded regime — an empirical regime-transition law, left as an
  unproved `Prop` scaffold (Open), consistent with the registry's own
  "law" (not "proposition-with-proof") tier for this id.
- **CAN-034**: `Inv_E z <> Inv_E z' -> q_E z <> q_E z'` is proved here only
  via its constructively valid direction — from the stronger premise "the
  invariant is a well-defined function of the quotient" (`q_E z = q_E z'
  -> Inv_E z = Inv_E z'`), the paper's stated law follows by a direct
  contrapositive (`A -> B` entails `~B -> ~A` intuitionistically). The
  converse direction (deriving the stronger premise from the paper's law)
  is **not** intuitionistically valid in general (it needs double-negation
  elimination on `Inv_E z = Inv_E z'`, unless that equality is assumed
  decidable) and is not claimed.
- **CAN-035**: proved by the same finite-list-fold technique as
  `MR_Live.v`'s `p_star`/`p_star_upper_bound` (`fold_right Qmax`), dualised
  to `fold_right Qmin`/`<=` — a genuine lower-bound proof, not an
  unbounded infimum.
- **CAN-039**: the one sub-claim CANONICAL.json itself discloses as
  posed-then-REJECTED by its own source (22307564:(Q5),
  `C_{G,t} = union C_{A_i,t}`?) is deliberately **not** formalised as a
  theorem here — formalising a source's own rejected claim as a proved
  fact would misrepresent it, even though a witnessed instance would be
  mechanically available.
- **CAN-225/226/228**: these three bundles each name more individual
  non-collapse pairs in their source manuscripts than are enumerated here;
  a representative finite sample (9, 12, and 8 notions respectively) is
  formalised via the shared `notions_pairwise_distinct` device rather than
  every named pair individually, since every pair reduces to the identical
  finite-enumeration/injective-`nat`-coding technique — adding more
  constructors to the same `Inductive` would not exercise any new proof
  technique. CAN-225's H6 companion and CAN-228's eq.(30)-(32) Dr-qualified
  companions are left unproved (Open / Dr respectively), matching
  CANONICAL.json's own tier notes for those specific sub-parts.
- **CAN-218**: the formalised content is a short logical restatement (a
  naming act — "absence of a mediating relation is exactly what pedigree
  substitution means" — rather than a further empirical claim), so it is
  tiered **Definition** here even though CANONICAL.json's own field reads
  "law (named principle)"; the supporting lemma is offered as
  Th_coqc-grade scaffolding, not a re-tagging of the principle itself.
- **CAN-220**: `standing_of` is typed to take exactly the five named
  epistemically-relevant components and nothing else, so "no redescriptive
  label can change standing" follows by construction — the type signature
  itself is the formal content of the constraint, and the lemma is the
  witness that this is not vacuous (the label genuinely plays no role).

## CAN ids this pass could not honestly formalise

None. All 49 ids assigned to this family (`registry/family_epistemic-reading.json`)
are formalised above at exactly one tier each (a Th_coqc/Definition tier
proved or typed, an Open tier recorded as an unproved `Prop`), with no
`Admitted`, no top-level `Axiom`/`Parameter`, and no id skipped. Every
`Theorem`/`Lemma`/proved `Definition`/`Defined` term is confirmed "Closed
under the global context" above.
