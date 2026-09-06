# LEDGER_method-reading.md — Coq Canon Ledger, family: method-reading

One row per CAN id. `Print Assumptions` result is from a direct check
(`coqc -Q coq_canon MRC -Q coq MR <scratch file requiring both
MRC_method_reading_a and MRC_method_reading_b>`, then `Print Assumptions
<identifier>` on every proved `Theorem`/`Lemma`) — re-run after any change
to either file. All 61 proved identifiers across both files return
**"Closed under the global context"** — see the "Compilation and
verification" section below for the exact command and full result.

Family assignment: every CAN id in `registry/CANONICAL.json` with
`domain == "method"` (69 ids, written out in full to
`registry/family_method-reading.json`). This is **not** the root-spine
family (`spine_ids` in `registry/COLLAPSE.md`), so this pass produces no
`MRC_master.v`. Per `registry/COLLAPSE.md`'s own description of the method
domain: "method is not given its own reading-table column: it does not
read the spine as a fourth *domain* ... it reads the spine as an audit
layer over whichever domain produced the claim" — every id below reads one
of the nine root-spine ids (CAN-001/003/004/006/007/008/009/201), recorded
in each id's own in-file CAN-comment.

Split into two independent sibling files (neither `Require`s the other,
matching the existing `MRC_human_ai_reading_a.v` / `_b.v` pattern):
- `coq_canon/MRC_method_reading_a.v` — CAN-165..200 (35 ids)
- `coq_canon/MRC_method_reading_b.v` — CAN-210..216, CAN-230..256 (34 ids)

Compilation: each file compiled alone, one at a time (never in parallel,
never alongside a full-repo/full-arc audit), per the standing "no repeated
full-arc re-audits" workflow rule:
```
coqc -Q coq_canon MRC -Q coq MR coq_canon/MRC_method_reading_a.v
coqc -Q coq_canon MRC -Q coq MR coq_canon/MRC_method_reading_b.v
```
Result for both: **clean compile, 0 errors, 0 `Admitted`, 0 top-level
`Axiom`/`Parameter`.**

## Reuse of Master River eq. (1)-(79)

The method domain's source manuscripts are, with exactly **one**
exception, disjoint from the chapters Master River v1.3/v1.4 itself
formalises (eq. 1-79, in `MR_Foundation.v` .. `MR_HCA.v`) — they are the
credit/provenance/governance audit layer over the spine, not a further
domain reading of its agents-in-a-world chapters. The one exception:

- **CAN-198** (rhythm-momentum-accessibility): its canonical text is
  exactly `MR_Resonance.v` eq.(13)-(15) — `momentum`, the discretised
  `accessibility_score`, and the "Rhythm alone does not determine
  accessibility" correction theorems. `MRC_method_reading_a.v` `Require`s
  `MR.MR_Resonance` and reuses these identifiers directly by alias
  (`CAN198_momentum := momentum`, etc.) — the same Master River content
  CAN-024 already aliases independently in `MRC_epistemic_reading.v` (a
  different family). Both reuses are legitimate readings of the one
  source, not a re-derivation.

Every other one of the 69 ids is new content for this pass, sourced from
"Rigour Without Infrastructure", "The Readout Condition", "State of
Evidence for the Readout Hypothesis-Generation Programme", "Knowledge
Topology and the First Passage to Usable Hypotheses", "From Problem to
Hypothesis", "The Standalone Scholar", "Mind as Information Horizon", and
"How Humans Should Converse with AI" (see `registry/family_method-reading.json`
for the per-id source-title list). CAN-216 additionally reuses this
family's *own* CAN-165 apparatus (the Factorization Theorem, converse
direction) — a within-family, not a Master-River, reuse; `_b.v` restates
the small generic lemma locally (`mrb_no_factorization_when_fiber_varies`)
rather than `Require`-ing `_a.v`, per the independent-sibling discipline
both `_a`/`_b` files declare.

## Two shared devices (declared once per file, instantiated by several ids)

- **Readout-factorization** (`MRC_method_reading_a.v`, CAN-165): a
  downstream distinction is admissible relative to an upstream readout iff
  it factors through it — the source's own named "Factorization Theorem",
  proved constructively via a declared per-value preimage witness (never
  unbounded choice). The converse failure mode (an upstream map constant
  where a downstream process differs forbids any factorisation) is used by
  CAN-216 (restated locally in `_b.v`).
- **Finite-fold bookkeeping bounds** (`MRC_method_reading_a.v`, CAN-181,
  CAN-194): `fold_right Qmin` / `fold_right Qplus 0`, the same technique
  as `MR_Live.v`'s `p_star`/`p_star_upper_bound` and `MR_HCA.v`'s `qsum`,
  dualised to a genuine lower bound (a minimum is at most every listed
  rate; a nonnegative sum is at least any one of its listed components).
- **Shared non-collapse enumeration** (`MRC_method_reading_b.v`,
  CAN-230..256 plus CAN-196 in `_a.v`): one closed finite `Inductive` per
  file, whose constructors are pairwise distinct by Coq's own
  constructor-disjointness — every `X<>Y` claim below closes with
  `discriminate` alone, with **no** injective-`nat`-coding indirection
  needed. This is a deliberate simplification over `MRC_epistemic_reading.v`'s
  `notions_pairwise_distinct` device (noted explicitly in both files'
  headers): that indirection buys nothing extra here since `discriminate`
  already certifies disjointness directly from the `Inductive` definition.

## Table

| CAN id | key | Coq tier | Identifier(s) | Reuse of | `Print Assumptions` |
|---|---|---|---|---|---|
| CAN-165 | readout-factorization-admissibility | Th_coqc / Open | `CAN165_admissible`; `CAN165_g_of`; `CAN165_factorization_thm`; `CAN165_data_processing_inequality_Open`; `CAN165_source_relation_may_differ_from_model` | — (new) | `mr_factorization_thm`, `CAN165_source_relation_may_differ_from_model`: Closed under the global context; Open Prop not proved |
| CAN-166 | rival-model-ladder-experience | Definition / Open | `CAN166_RivalModel`; `CAN166_must_beat_ladder_Open` | — (new) | n/a (Definition; Open Prop not proved) |
| CAN-167 | problem-formation | Definition | `CAN167_residual`; `CAN167_cost`; `CAN167_problem`; `CAN167_question_selects` | — (new) | n/a |
| CAN-168 | discovery-accessibility | Definition / Th_coqc | `CAN168_path_prob`; `CAN168_reachable`; `CAN168_high`; `CAN168_positive_but_not_high` | — (new) | `CAN168_positive_but_not_high`: Closed under the global context |
| CAN-169 | discovery-first-passage | Definition / Open | `CAN169_first_hit`; `CAN169_tau_U_bounded`; `CAN169_tau_U_unbounded_Open`; `CAN169_usable_ne_actually_true` | — (new) | `CAN169_usable_ne_actually_true`: Closed under the global context; unbounded Open Prop not proved |
| CAN-170 | discriminating-action-loop | Definition | `CAN170_discriminating`; `CAN170_local_residual` | — (new) | n/a |
| CAN-171 | provenance-ledger | Definition | `CAN171_LedgerEntry` | — (new) | n/a |
| CAN-172 | DCP-status-categories | Definition | `CAN172_Status` | — (new) | n/a |
| CAN-173 | credit-provenance-goodhart | Th_coqc | `CAN173_valid_term`; `CAN173_C_valid`; `CAN173_C_raw`; `CAN173_term_le`; `CAN173_valid_le_raw` | — (new) | Both lemmas: Closed under the global context |
| CAN-174 | tier-ledger-invariant | Definition | `CAN174_invariant`; `CAN174_invariant_refl` | — (new) | `CAN174_invariant_refl`: Closed under the global context |
| CAN-175 | k2-procurement | Definition | `CAN175_cost_k2`; `CAN175_expected_yield`; `CAN175_effective_k2` | — (new) | n/a |
| CAN-177 | theorizing-pipeline | Definition | `CAN177_TheoryStage`; `CAN177_EngineAStage`; `CAN177_EngineBStage`; `CAN177_bridge`; `CAN177_bridge_iff` | — (new) | `CAN177_bridge_iff`: Closed under the global context |
| CAN-178 | scholarly-capital-bookkeeping | Definition | `CAN178_K0_start`; `CAN178_E_t`; `CAN178_PosCap`; `CAN178_NetPractice` | — (new) | n/a |
| CAN-179 | knowledge-state-ladder | Th_coqc | `CAN179_KState`; `CAN179_code`; `CAN179_lt`; `CAN179_ladder_strictly_increasing` | — (new) | Closed under the global context |
| CAN-180 | epistemic-isolation-constraint | Definition / Open | `CAN180_EIC`; `CAN180_EIC_implies_Open` | — (new) | n/a (Open Prop not proved) |
| CAN-181 | bottleneck-inversion | Th_coqc / Definition | `CAN181_Lambda`; `CAN181_Lambda_le_each`; `CAN181_Vc`; `CAN181_De`; `CAN181_velocity_constraint` | `MR_Live.v` `p_star_upper_bound` (dualised `Qmax`->`Qmin`, shared device) | `mr_qmin_fold_le`: Closed under the global context |
| CAN-182 | dvp-protocol | Definition | `CAN182_Outcome`; `CAN182_decision` | — (new) | n/a |
| CAN-183 | programme-legibility | Definition | `CAN183_Coh_effective`; `CAN183_effective_le_latent` | — (new) | `CAN183_effective_le_latent`: Closed under the global context |
| CAN-184 | recognition-conversion | Definition / Open | `CAN184_monotone_increase_Open`; `CAN184_PaperRole` | — (new) | n/a (Open Prop not proved) |
| CAN-185 | credit-velocity-governance | Definition / Th_coqc | `CAN185_chi`; `CAN185_B`; `CAN185_B_bounded_by_mint`; `CAN185_VC`; `CAN185_priority` | — (new) | `CAN185_B_bounded_by_mint`: Closed under the global context |
| CAN-186 | concept-cluster-compounding | Definition | `CAN186_CompoundingStage`; `CAN186_credit_leverage`; `CAN186_PC_superseded` | — (new) | n/a |
| CAN-187 | reactor-criticality-analogy | Definition | `CAN187_k_t`; `CAN187_beta_D`; `CAN187_increase_mint_rate`; `CAN187_rho_R`; `CAN187_X_t`; `CAN187_BR_t` | — (new) | n/a |
| CAN-188 | legitimacy-circulation-loop | Th_coqc | `CAN188_LoopStage`; `CAN188_step`; `CAN188_iter`; `CAN188_loop_returns` | — (new) | Closed under the global context |
| CAN-189 | residual-model | Definition | `CAN189_r`; `CAN189_V` | — (new) | n/a |
| CAN-190 | geographic-coverage | Th_coqc / Definition | `mr_list_non_containment_witness`; `CAN190_not_subset`; `CAN190_not_subset_witness`; `CAN190_S_G`; `CAN190_ConversionPlan` | — (new) | `mr_list_non_containment_witness`: Closed under the global context |
| CAN-191 | integrity-firewall | Definition | `CAN191_FirewallStage`; `CAN191_scram` | — (new) | n/a |
| CAN-192 | human-mastery-gate | Definition | `CAN192_H_g` | — (new) | n/a |
| CAN-193 | standalone-scholar-architecture | Definition | `CAN193_ArchStage`; `CAN193_EpistemicPosition`; `CAN193_CrediblePath` | — (new) | n/a |
| CAN-194 | feasibility-budget | Definition / Th_coqc | `CAN194_B_year`; `CAN194_B_year_total`; `CAN194_component_le_total`; `CAN194_portfolio_shrink`; `CAN194_wip_bound`; `CAN194_priority` | `MR_HCA.v` `qsum` / `MR_Live.v` `p_star` (shared device) | `CAN194_component_le_total`: Closed under the global context |
| CAN-195 | discovery-justification-separation | Definition | `CAN195_scope_constraint`; `CAN195_Pipeline` | — (new) | n/a |
| CAN-196 | evidence-registry-noncollapse | Th_coqc | `CAN196_EvidenceNotion`; `CAN196_neighboring_ne_formal`; `CAN196_formal_ne_truth`; `CAN196_reachability_ne_accessibility`; `CAN196_speed_ne_quality`; `CAN196_volume_ne_diversity`; `CAN196_attraction_chain` | — (new) | All six: Closed under the global context |
| CAN-197 | knowledge-topology-firstpassage | Open | `CAN197_topology_sensitivity_Open` | — (new) | n/a (Open Prop, not proved by design) |
| CAN-198 | rhythm-momentum-accessibility | Th_coqc / Open | `CAN198_momentum`; `CAN198_Open_momentum`; `CAN198_accessibility_score`; `CAN198_Open_accessibility`; `CAN198_rhythm_does_not_determine_accessibility`; `CAN198_kappa_genuinely_varies` | `MR_Resonance.v` eq.(13)-(15), reused directly by alias | The two eq.15 theorems: Closed under the global context; `Open_eq13`/`Open_eq14` aliases: n/a (Open, inherited unchanged) |
| CAN-199 | mind-body-coupling | Definition | `CAN199_B`; `CAN199_H`; `CAN199_E` | — (new) | n/a |
| CAN-200 | DCP-burden-vector | Definition / Th_coqc | `CAN200_Burden`; `CAN200_OptimalOrAdoptable`; `CAN200_optimal_ne_adoptable` | — (new) | `CAN200_optimal_ne_adoptable`: Closed under the global context |
| CAN-210 | identification-ladder | Definition / Th_coqc | `CAN210_first_false`; `CAN210_level`; `CAN210_level_correct` | — (new) | `CAN210_level_correct`: Closed under the global context |
| CAN-211 | typed-augmentation-grammar | Definition | `CAN211_AugmentationKind`; `CAN211_kinds_pairwise_distinct`; `CAN211_access_aug`; `CAN211_contrast_aug`; `CAN211_decision_policy_aug` | — (new) | `CAN211_kinds_pairwise_distinct`: Closed under the global context |
| CAN-212 | ead-provenance-norms | Definition / Th_coqc | `CAN212_adequate`; `CAN212_adequate_intro` | — (new) | `CAN212_adequate_intro`: Closed under the global context |
| CAN-213 | epistemic-overreach-and-silent-lift | Definition / Th_coqc | `CAN213_overreach`; `CAN213_silent_lift`; `CAN213_silent_lift_is_overreach` | — (new) | `CAN213_silent_lift_is_overreach`: Closed under the global context |
| CAN-214 | essential-dependency-defeater-routing | Definition / Th_coqc | `CAN214_intersect`; `CAN214_Ess`; `CAN214_misrouted_defeat` | — (new) | `CAN214_misrouted_defeat`: Closed under the global context |
| CAN-215 | worked-audit-diagnostic-test | Th_coqc | `CAN215_p_D_given_pos`; `CAN215_bayes_value` | — (new) | Closed under the global context |
| CAN-216 | retained-record-contamination-route | Th_coqc | `mrb_no_factorization_when_fiber_varies`; `CAN216_worked_no_factorization` | CAN-165's Factorization Theorem apparatus, converse direction (within-family reuse; restated locally in `_b.v`) | Closed under the global context |
| CAN-230 | credit-not-epistemic-value | Th_coqc | `CAN2xx_MethodNotion`; `CAN230_credit_not_epistemic_value` | — (new) | Closed under the global context |
| CAN-231 | friction-not-fellowship | Th_coqc | `CAN231_friction_not_fellowship` | — (new) | Closed under the global context |
| CAN-232 | self-experience-not-general-evidence | Th_coqc | `CAN232_self_experience_not_general_evidence` | — (new) | Closed under the global context |
| CAN-233 | positional-access-not-population-authority | Th_coqc | `CAN233_positional_access_not_population_authority` | — (new) | Closed under the global context |
| CAN-234 | community-trust-not-representativeness | Th_coqc | `CAN234_community_trust_not_representativeness` | — (new) | Closed under the global context |
| CAN-235 | dvp-not-k2 | Th_coqc | `CAN235_dvp_not_k2` | — (new) | Closed under the global context |
| CAN-236 | many-models-not-independence | Th_coqc | `CAN236_many_models_not_independence` | — (new) | Closed under the global context |
| CAN-237 | mechanical-not-semantic-validity | Th_coqc | `CAN237_mechanical_not_semantic_validity` | — (new) | Closed under the global context |
| CAN-238 | source-existence-not-claim-support | Th_coqc | `CAN238_source_existence_not_claim_support` | — (new) | Closed under the global context |
| CAN-239 | friendship-not-independent-evidence | Th_coqc | `CAN239_friendship_not_independent_evidence` | — (new) | Closed under the global context |
| CAN-240 | correspondence-not-peer-review | Th_coqc | `CAN240_correspondence_not_peer_review` | — (new) | Closed under the global context |
| CAN-241 | intellectual-affinity-not-truth | Th_coqc | `CAN241_intellectual_affinity_not_truth` | — (new) | Closed under the global context |
| CAN-242 | activation-action-not-credit-event | Th_coqc | `CAN242_activation_action_not_credit_event` | — (new) | Closed under the global context |
| CAN-243 | rawspeed-not-vc | Th_coqc | `CAN243_rawspeed_not_vc` | — (new) | Closed under the global context |
| CAN-244 | lh-lv-not-truth | Th_coqc | `CAN244_lh_lv_not_truth` | — (new) | Closed under the global context |
| CAN-245 | mission-stepper-not-theta | Th_coqc | `CAN245_mission_stepper_not_theta` | — (new) | Closed under the global context |
| CAN-246 | multiai-consensus-not-geographic-completeness | Th_coqc | `CAN246_multiai_consensus_not_geographic_completeness` | — (new) | Closed under the global context |
| CAN-247 | doubleblind-bonus-not-requirement | Th_coqc | `CAN247_doubleblind_bonus_not_requirement` | — (new) | Closed under the global context |
| CAN-248 | k2global-not-k2thai | Th_coqc | `CAN248_k2global_not_k2thai` | — (new) | Closed under the global context |
| CAN-249 | interventioncreator-not-soleevaluator | Th_coqc | `CAN249_interventioncreator_not_soleevaluator` | — (new) | Closed under the global context |
| CAN-250 | practiceexperience-not-populationevidence | Th_coqc | `CAN250_practiceexperience_not_populationevidence` | — (new) | Closed under the global context |
| CAN-251 | at-not-ctscholarly | Th_coqc | `CAN251_at_not_ctscholarly` | — (new) | Closed under the global context |
| CAN-252 | mattention-not-mtruth-mk2 | Th_coqc | `CAN252_mattention_not_mtruth_mk2` | — (new) | Closed under the global context |
| CAN-253 | nohuman-not-researchstop | Th_coqc | `CAN253_nohuman_not_researchstop` | — (new) | Closed under the global context |
| CAN-254 | prestige-not-apc-approval | Definition | `CAN254_prestige_not_apc_approval`; `CAN254_approval_requires` | — (new) | `CAN254_prestige_not_apc_approval`: Closed under the global context; `approval_requires` is a Definition, not proved |
| CAN-255 | disclosurepenalty-not-concealment | Definition | `CAN255_disclosurepenalty_not_concealment`; `CAN255_penalty_requires` | — (new) | `CAN255_disclosurepenalty_not_concealment`: Closed under the global context; `penalty_requires` is a Definition, not proved |
| CAN-256 | aicontribution-not-epistemicresponsibility | Th_coqc | `CAN256_aicontribution_not_epistemicresponsibility` | — (new) | Closed under the global context |

## Compilation and verification (exact commands run)

```
cd <local path redacted>
coqc -q -Q coq_canon MRC -Q coq MR coq_canon/MRC_method_reading_a.v
coqc -q -Q coq_canon MRC -Q coq MR coq_canon/MRC_method_reading_b.v
```
Both: no output, exit 0, `.vo` produced. `Print Assumptions` was then run
(via a scratch file `Require`-ing both compiled modules) on every one of
the 61 `Theorem`/`Lemma` identifiers across both files (27 in `_a.v`, 34
in `_b.v`) — **all 61 return "Closed under the global context"**, 0
`Admitted`, 0 `Axiom`, 0 `Parameter`.

## Tiering notes

- **CAN-165 / CAN-216**: a genuinely reusable pair — CAN-165's
  Factorization Theorem (fiber-constancy iff factors through the
  readout) and its converse failure mode (fiber-constant-but-differing
  downstream values forbid any factorisation) are, respectively, the
  positive and negative halves of the same fact. CAN-216's worked audit
  is exactly the converse-direction instance. The data-processing
  inequality inside CAN-165 stays Open: mutual information is a
  continuum, log-based quantity with no [Q] surrogate declared here
  (unlike `MR_Resonance.v` eq.(14)'s `exp`, which that file already
  replaces with a declared discrete gain surrogate — no equivalent
  declared substitute exists in this pass for information-theoretic
  mutual information, so it is left abstract rather than silently
  imported from `Coq.Reals` or approximated without saying so).
- **CAN-181 / CAN-194**: the two ids instantiating the finite-fold
  bookkeeping device also each carry one abstract, unproved-by-design
  piece — CAN-181's cube-root aggregator `cbrt181` (a Section `Variable`,
  never `Coq.Reals`' real cube root, since a general cube root is not
  rational-closed) and CAN-194's velocity/portfolio inequalities (governance
  heuristics, not derivable facts).
- **CAN-196 / CAN-230..256**: the method domain's dominant non-collapse
  block (COLLAPSE.md's own "27-item method-domain credit/evidence
  guard-pair" count, CAN-230..256, plus CAN-196's own six-way chain) is
  handled by one shared finite enumeration per file, closed by
  `discriminate` alone — deliberately **not** re-using
  `MRC_epistemic_reading.v`'s nat-injective-coding
  `notions_pairwise_distinct` device, since Coq's own
  constructor-disjointness already gives every needed inequality directly
  and the extra coding indirection would exercise no new proof technique.
  CAN-235/236/243/246/253's source connective is "=/=>" (a stated
  non-implication) rather than a bare "<>", but `registry/COLLAPSE.md`
  itself tiers all of them "identity (non-collapse)" alongside the
  strict-inequality ids — this file follows the registry's own
  classification rather than manufacturing two different proof shapes
  (an equality-style `discriminate` fact vs. a genuine implication
  counterexample) for what the registry treats as one claim shape.
- **CAN-198**: the one id in this family that is a direct Master River
  eq. (1)-(79) reuse (`MR_Resonance.v` eq.(13)-(15)); `momentum` and
  `accessibility_score` (and their `Open_eq13`/`Open_eq14` companions)
  keep the Open tier `MR_Resonance.v` itself assigns them — this pass
  does not re-litigate or upgrade that tiering, only the two eq.(15)
  non-reducibility theorems (already Th_coqc in the source file) are
  proved-and-reused as such.
- **CAN-186**: `CAN186_PC_superseded` types the formula CANONICAL.json's
  own canonical text marks "(superseded)" — recorded only as a
  `Definition` for completeness, deliberately never referenced by any
  other identifier in this pass and never promoted to a live/active
  metric.
- **CAN-254 / CAN-255**: registry tier is "governance definition", not
  "identity" (unlike CAN-230..253/256) — the distinctness half
  (Prestige<>APCApproval; DisclosurePenalty<>Concealment) is still proved
  on the shared enumeration as Th_coqc-grade scaffolding, but the
  conditional requirement chain each id also states
  (APCApproval => FieldFit+CreditYield+BudgetFit, and the disclosure
  analogue) is recorded only as a typed, unproved `Prop` — a governance
  rule, not a derivable theorem, matching the registry's own tier for the
  id as a whole.

## CAN ids this pass could not honestly formalise

None. All 69 ids assigned to this family (`registry/family_method-reading.json`)
are formalised above at exactly one tier each per sub-part (a
Th_coqc/Definition tier proved or typed, an Open tier recorded as an
unproved `Prop`, never upgraded), with no `Admitted`, no top-level
`Axiom`/`Parameter`, and no id skipped. Every `Theorem`/`Lemma` across
both files is confirmed "Closed under the global context" above (61 of
61 checked).
