# MR_Ledger.md — Master Equation River Coq Ledger

One row per equation. `Print Assumptions` result is from `./verify.sh`
(re-run it after any change; do not hand-edit the result column without
re-running). **Never delete another block's rows — append only.**

Paper source of record: `../v1_3/main.tex` (Master Equation River v1.3).
Tier source: the running text around each equation plus Table 2
(`\label{tab:status}`, "Epistemic Status of Each Segment") and the
genealogy table (`\label{tab:genealogy}`).

## Block A — eq. (1)–(18) (MR_Foundation.v, MR_Resonance.v)

| eq. | File | Identifier(s) | Tier | `Print Assumptions` |
|---|---|---|---|---|
| 1 | MR_Foundation.v | `R_H` (Variable, Section `Foundation1`) | Definition | n/a (Definition, not a proof obligation) |
| 2 | MR_Foundation.v | `Psi_H` (Variable, Section `Foundation1`) | Definition | n/a |
| 3 | MR_Foundation.v | `MeaningModes` (Record); `meaning_modes_decomposition_faithful` | Definition | Closed under the global context |
| 4 | MR_Foundation.v | `Phi_E` (Variable, Section `Foundation1`) | Definition | n/a |
| 5 | MR_Foundation.v | `eq5_experience_is_phenomenon_and_meaning_jointly` | Th_coqc (narrow witness lemma only: a finite model where the compression is jointly sensitive to phenomenon and meaning; the paper's thesis itself stays at its own tier, Dr) | Closed under the global context |
| 6 | MR_Foundation.v | `L_H` (Variable, Section `Naming`); witness `naming_can_remain_unstable` | Definition | Closed under the global context (witness) |
| 7 | MR_Foundation.v | `NamingChainStep` (Record); `naming_chain` (Fixpoint) | Definition | n/a |
| 8 | MR_Foundation.v | `eq8_retention_can_change_the_reader` | Th_coqc (narrow witness lemma only: a finite model where retention-with-update is not idle; the paper's thesis stays Dr) | Closed under the global context |
| 9 | MR_Resonance.v | `Retrieve` (Variable, Section `Resonance`) | Definition | n/a |
| 10 | MR_Resonance.v | `C_H` (Variable, Section `Resonance`) | Definition | n/a |
| 11 | MR_Resonance.v | `eq11_resonance_non_collapse` (+ `notion_value_injective`) | Th_coqc | Closed under the global context |
| 12 | MR_Resonance.v | `EncounterHistory`, `Omega` (Variable), `rhythm_at` | Definition | n/a |
| 13 | MR_Resonance.v | `momentum` (Fixpoint, scaffold); `Open_eq13` | Open | n/a (Open Prop, not proved by design) |
| 14 | MR_Resonance.v | `accessibility_score`, `disc_gain_nat`, `kappa_next`; `Open_eq14` | Open | n/a (Open Prop, not proved by design) |
| 15 | MR_Resonance.v | `eq15_rhythm_alone_does_not_determine_accessibility`, `eq15_kappa_next_genuinely_varies` | Th_coqc | Closed under the global context (both) |
| 16 | MR_Resonance.v | `accum_work`, `accum_work_cons`, `eq16_accum_work_monotone_on_nonneg_extension`, `eq16_accum_work_nonneg_of_all_nonneg` | Th_coqc (bookkeeping facts about the definition only: monotone/non-negative sums over Q; the transition claim of eq. 18 remains Open) | Closed under the global context (all three proved lemmas) |
| 17 | MR_Resonance.v | `effective_work` (Section `EffectiveWork`) | Definition | n/a |
| 18 | MR_Resonance.v | `threshold_crossed`, `threshold_crossed_decidable`; `Open_eq18` | Open | `threshold_crossed_decidable`: Closed under the global context; `Open_eq18`: n/a (Open Prop) |

### Notes on Block A tiering decisions

- **eq. 5** ("Experience = phenomenon-as-meaningfully-read"): the paper's
  own Table 2 places this among "Dr conceptual theses". Since a bare
  conceptual thesis is not itself a Coq proof obligation, it is upgraded to
  **Th_coqc** by exhibiting the concrete witnessed model the thesis is
  defending: `Experience' := X * MeaningModes` with `Phi_E'` the pairing
  map, and proving the compression is genuinely joint (varying either
  factor changes the output) — i.e. experience is neither phenomenon alone
  nor meaning alone.
- **eq. 8**: Human LoRA's stated consequence ("the same biological
  individual may no longer be the same effective reader") is formalised as
  a non-triviality witness (`U_H` on `bool` via `negb`), not as a universal
  claim that retention always changes the reader.
- **eq. 13, 14**: tiered **Open** per the genealogy table's own words for
  eq. 13 ("this is an Open hypothesis") and Table 2's explicit listing of
  "recent-path momentum" and "history-shaped accessibility" under "Open
  empirical hypotheses" — even though the underlying recursions/scores are
  fully well-typed, computable `Q`-valued functions (defined as scaffolding
  for eq. 15's proof). Eq. 14's continuum `exp(...)` is replaced by a
  declared discrete rational surrogate `disc_gain_nat`, recorded as a
  substitution in the source comment, not silently imported from
  `Coq.Reals`.
- **eq. 15**: the paper's "canonical correction" (rhythm/momentum/
  attraction/switching-cost are parallel descriptors, not a derivation
  chain "Rhythm ⇒ m_t") is formalised as **Th_coqc**: a witnessed
  non-collapse showing `rhythm_at` (a function of `(T,B)` alone) cannot
  determine `accessibility_score`, which genuinely varies independently.
- **eq. 16–18** (accumulation/barrier/release): the paper's own hedge after
  eq. 18 ("a candidate transition topology, not a claim that every kind of
  human change obeys a universal threshold") and Table 2's "barrier/
  transition topology" Open listing apply specifically to the *causal*
  claim that crossing the threshold triggers a transition. The
  *bookkeeping* underneath it is not itself hedged, so: eq. 16 (the finite
  accumulation sum) is **Th_coqc** (monotonicity/non-negativity proved over
  `Q`); eq. 17 (the effective-work modulation) is **Definition** (typing
  only, `g`'s shape is not fixed by the paper); eq. 18 (crossing the
  threshold triggers a transition) is **Open**, with the threshold
  comparison itself proved decidable as a `Lemma` (that decidability proof
  is `Th_coqc`-grade on its own, but is scaffolding for the Open causal
  claim, not a re-tagging of eq. 18).

### Equations this pass could not honestly formalise

None. All of eq. (1)–(18) are formalised above at exactly one tier each,
with no `Admitted` and no equation skipped.

---

## Block B — eq. (19)–(45), (65)–(66) (MR_Live.v, MR_Prompt.v, MR_Retention.v, MR_Corrections.v, MR_River.v)

| eq. | File | Identifier(s) | Tier | `Print Assumptions` |
|---|---|---|---|---|
| 19 | MR_Live.v | `Pi_live`, `eq19_live_subset_feas`, `eq19_live_subset_phys`, `eq19_full_nesting` | Th_coqc | Closed under the global context (all three) |
| 20 | MR_Live.v | `live_field` | Definition | n/a |
| 21 | MR_Live.v | `live_ge_threshold`, `Pi_live` | Definition | n/a |
| 22 | MR_Live.v | `is_valid_choice` | Definition | n/a |
| 23 | MR_Live.v | `eq23_enactment_may_differ_from_choice`; `Trajectory`, `Obs`, `O_q`, `eq23_observation_loses_information` | Th_coqc | Closed under the global context (both) |
| 24 | MR_Live.v | `Stage`, `stage_value`, `stage_value_injective`, `eq24_stage_chain_non_collapse` | Th_coqc | Closed under the global context (both proved) |
| 25 | MR_Live.v | `p_star`; `p_star_upper_bound` | Definition | Closed under the global context (supporting lemma) |
| 26 | MR_Live.v | `live_field_gap` | Definition | n/a |
| 27 | MR_Prompt.v | `L_H` (Variable, Section `PrePromptCoupling`) | Definition | n/a |
| 28 | MR_Prompt.v | `AI_step`, `R_H_readout`, `ai_turn` | Definition | n/a |
| 29 | MR_Prompt.v | `U_H` (Variable), `next_state` | Definition | n/a |
| 30 | MR_Prompt.v | `toy_update`, `toy_lambda_live`, `eq30_live_weight_may_change` | Th_coqc | Closed under the global context |
| 31 | MR_Prompt.v | `F_hash_dlg` (Variable), `dlg_step` | Definition | n/a |
| 32 | MR_Prompt.v | `chi_recip`, `eq32_chi_recip_bounds` | Th_coqc | Closed under the global context |
| 33 | MR_Prompt.v | `ReturnBattery`, `mk_return_battery` | Definition | n/a |
| 34 | MR_Prompt.v | `RET`, `eq34_RET_rearrangement` | Th_coqc | Closed under the global context |
| 35 (`eq:lowrank`) | MR_Retention.v | `candidate_update`, `is_low_rank` | Definition | n/a |
| 36 (`eq:gate`) | MR_Retention.v | `retention_gate_update`, `gate_weight_valid`; `gate_avoids_eta_doubling_witness` | Definition | Closed under the global context (supporting witness) |
| 37 | MR_Retention.v | `ai_momentum_resets` | Definition | n/a |
| 38 | MR_Retention.v | `KnowledgeStatus`, `status_value`, `eq38_candidate_status_non_collapse` | Th_coqc | Closed under the global context |
| 39 | MR_Retention.v | `Delta_gt`, `eq39_sign_scale_pos_case`, `eq39_sign_scale_neg_case`, `eq39_sign_scale_zero_case` | Th_coqc | Closed under the global context (all three) |
| 40 | MR_Retention.v | `AUG`, `SYN`, `eq40_aug_syn_non_collapse` | Th_coqc | Closed under the global context |
| 41 | MR_Retention.v | `HReturn`, `mk_h_return` | Definition | n/a |
| 42 | MR_Retention.v | `EndChainNotion`, `end_chain_value`, `eq42_end_chain_non_collapse` | Th_coqc | Closed under the global context |
| 43 | MR_Corrections.v | `gamma_mu`, `kappa_sem`, `lambda_live_c` (Variables, Section `KappaCollisionResolved`); `kappa_rename_arities` | Definition | n/a |
| 44 | MR_River.v | `master_river_44`, `one_pass_to_h_return`, `one_pass_44_65` | Definition | n/a |
| 45 | MR_River.v | `closing_summary_45` | Definition | n/a |
| 65 | MR_River.v | `river_tail_65` | Definition | n/a |
| 66 | MR_River.v | `outer_loop_66` | Definition | n/a |

### Notes on Block B tiering decisions

- **eq. 19**: proved, not merely typed, exactly per the assignment brief's
  own worked example — `Pi_live` is *defined* (eq. 21) as a `filter` of
  `Pi_feas`, so `Pi_live subseteq Pi_feas` is a direct consequence of the
  stdlib `filter_In`, and `Pi_feas subseteq Pi_phys` is the one declared
  structural hypothesis (`feas_subset_phys`) carried over from Choice
  Begins Before Choice's own claim that structural feasibility implies
  physical possibility. Chaining the two gives the full nesting.
- **eq. 22**: typed as a `Prop` (`is_valid_choice`) rather than proved,
  because the paper states it as the *definition* of what counts as a
  valid choice (membership in the live set), not as a further claim about
  any particular chosen policy.
- **eq. 23**: two Th_coqc facts under one tag (see the in-file comment) —
  a witnessed-possibility proof that enactment can differ from choice
  (needs only a two-point-richness hypothesis on the policy space, far
  weaker than the conclusion), and a concrete lossy-instrument model
  (`O_q := length`) witnessing that an observation need not determine the
  underlying trajectory.
- **eq. 24**: the "possible≠feasible≠live≠chosen≠enacted≠observed" chain,
  formalised exactly as MR_Resonance.v's eq. 11 pattern (six enumerated
  stages, injectively valued into `nat`, pairwise `discriminate`).
- **eq. 25, 26**: Table 2 places "Potential as a Readout" among
  "Measurement architecture", not among the proved finite-diagnostic
  lemmas (those are the source paper's own L1–L4, not re-derived here);
  both are tiered **Definition**, with the paper's `max` over a
  (feasible/witnessed, resp. structural-condition) set replaced by a
  finite-list `fold_right Qmax` — the readout-first substitution recorded
  explicitly in-file. `p_star_upper_bound` is offered as a supporting
  fact (not a re-tagging of eq. 25) confirming the finite max is a real
  upper bound, using the stdlib `Qminmax` properties.
- **eq. 30**: "if a residue persists, it is then possible that
  L_{A,t+1} <> L_{A,t}" is read as witnessed possibility, so a minimal
  concrete instantiation (`nat` states, additive update, a state-reading
  weight) is exhibited rather than a universal claim derived from the
  fully abstract `PrePromptCoupling` state/update maps (which cannot, by
  themselves, entail any inequality without further hypotheses).
- **eq. 32**: `chi_recip` is built directly as a `Qmake` fraction over a
  `positive` denominator (never a real-valued limit), and the bounded-ratio
  fact `0 <= chi_recip <= 1` (implicit in the paper calling it a
  "diagnostic ratio") is proved over `Z`/`Q` from `d_recip <= sigma_card`,
  not assumed.
- **eq. 34**: `RET`'s difference-in-differences rearrangement is proved by
  `ring` on `Q` — a bookkeeping identity, not an empirical claim about
  what `RET` measures.
- **eq. 35–36** (`eq:lowrank`/`eq:gate`): tiered **Definition** per the
  paper's own words — "Master's own proposal ... not v8.1's own text".
  `gate_avoids_eta_doubling_witness` is a supporting Th_coqc-grade witness
  (not a re-tagging of eq. 36) that the single-`eta_s` gate is a genuine,
  checkable departure from the rejected double-`eta_s` draft form
  discussed in `sec:etagate` (no equation label of its own).
- **eq. 37**: tiered **Definition**, per the paper's explicit statement
  that AI-momentum reset "is a scope condition of the model, not a
  universal fact about AI with persistent memory" — stated as a `Prop` on
  a momentum trace, never asserted as a theorem.
- **eq. 38, 40, 42**: witnessed non-collapse facts on enumerated finite
  models, in the same family as eq. 11/eq. 24; eq. 40's non-collapse is
  the strongest form actually available (`AUG <> SYN` whenever the AI
  outperforms the human alone), proved over `Q` via `lra`.
- **eq. 39**: the sign-matching identity is proved case-by-case (positive,
  negative, and zero gate weight) over `Q` using the stdlib
  order-compatibility lemmas for multiplication, rather than attempting a
  single `Qcompare`-equality restatement (which would need extra
  machinery no more informative than the three cases proved directly).
- **eq. 43**: a renaming/typing act, not a claim — tiered **Definition**.
  The "resolution" of the three-way `kappa` collision is exhibited as
  three genuinely different function signatures (1, 4, and 4 arguments
  over disjoint index types), recorded as a plain arity fact
  (`kappa_rename_arities`) rather than a disguised extra theorem.
- **eq. 44, 45, 65, 66**: tiered **Definition** per the task brief and the
  paper's own text ("not a claim that every arrow carries the same
  evidential status"; "a schematic placement, not a new derivation").
  Each is formalised as a literal Coq function composition through
  abstract `Variable`s carrying the paper's own stage names/order; the
  composition's type-checking *is* the Definition-tier content asserted,
  with no additional claim about per-arrow evidential status smuggled in.
  Eq. 65 continues from the same `HReturn2` type eq. 44 reaches via
  `ctsa_return`, exactly as the paper's own "appended tail, not a
  rewriting of eq. (44)" language requires.

### Equations this pass could not honestly formalise

None. All of eq. (19)–(45) and eq. (65)–(66) (including `eq:lowrank`/
`eq:gate` = eq. 35/36) are formalised above at exactly one tier each, with
no `Admitted`, no top-level `Axiom`/`Parameter`, and no equation skipped.

---

*(Later passes covering Block C (46–64, the v1.3 additions in
MR_TopicEntry.v/MR_WorldSystem.v) append their own rows below this line —
do not edit or remove Block A's or Block B's rows above.)*

---

## Block C — eq. (46)–(64) (MR_TopicEntry.v, MR_WorldSystem.v)

| eq. | File | Identifier(s) | Tier | `Print Assumptions` |
|---|---|---|---|---|
| 46 | MR_TopicEntry.v | `L_H` (Variable, Section `TopicEntryTransport`); `topic_entry_transport` | Definition | n/a |
| 47 | MR_TopicEntry.v | `TopicEntry` (Inductive); `Legitimate` | Definition | n/a |
| 48 | MR_TopicEntry.v | `Open_eq48` | Open | n/a (Open Prop, not proved by design) |
| 49 | MR_TopicEntry.v | `ProblemOnlyPolicy` (Definition, scaffolding only); `Open_eq49` | Open | n/a (Open Prop, not proved by design) |
| 50 | MR_TopicEntry.v | `dcp_closure_50` (Section `HumanReturnClosure`) | Definition | n/a |
| 51 | MR_TopicEntry.v | `CycleStage` (Inductive); `cycle_next_51` | Definition | n/a |
| 52 | MR_WorldSystem.v | `readout_52` (Variable, Section `ReadoutDefinition`); Hypothesis `readout_ne_state`; `readout_52_hypothesis_satisfiable_on_bool` | Definition | `readout_52_hypothesis_satisfiable_on_bool`: Closed under the global context (supporting satisfiability witness) |
| 53 | MR_WorldSystem.v | `LabourCentrality`; `mk_labour_centrality` | Definition | n/a |
| 54 | MR_WorldSystem.v | `q_min`; `eq54_citizen_claim_threshold_identity` | Th_coqc | Closed under the global context |
| 55 | MR_WorldSystem.v | `Pi_live_ws`; `eq55_live_subset_feas_ws`, `eq55_live_subset_phys_ws`, `eq55_full_nesting_ws` | Th_coqc | Closed under the global context (all three) |
| 56 | MR_WorldSystem.v | `corrigible_agency_ws`; `corrigible_agency_ws_upper_bound` | Definition | Closed under the global context (supporting upper-bound lemma) |
| 57 | MR_WorldSystem.v | `ReturnProfileWS`; `mk_return_profile_ws` | Definition | n/a |
| 58 | MR_WorldSystem.v | `Qpow_nat` (Fixpoint); `P_H_index` | Definition | n/a |
| 59 | MR_WorldSystem.v | `ddiff`; `eq59_output_rise_not_position_rise` | Th_coqc | Closed under the global context |
| 60 | MR_WorldSystem.v | `eq60_machine_expansion_not_human_expansion` | Th_coqc | Closed under the global context |
| 61 | MR_WorldSystem.v | `HumanConversionVector`; `mk_human_conversion_vector` | Definition | n/a |
| 62 | MR_WorldSystem.v | `eta_HC` (Section `ConversionElasticity`) | Definition | n/a |
| 63 | MR_WorldSystem.v | `in_reversibility_window`, `reversibility_window` | Definition | n/a |
| 64 | MR_WorldSystem.v | `urgency_term` | Definition | n/a |

### Notes on Block C tiering decisions

- **eq. 46**: the identical Pre-Prompt Human State transport already typed
  as eq. (19)/(27)-family Definition in MR_Prompt.v (`L_H : HState ->
  Prompt`), restated verbatim at DCP's own session index `s` — no new
  claim, so **Definition**, not a re-tagging of eq. (27).
- **eq. 48**: tiered **Open** because the paper's own running text tags
  DCP's Problem-First Dialogue Principle "`[\textsc{Open}]`" explicitly
  (DCP eq. 6), and Table 2's "New in v1.3" Open-hypotheses row repeats
  this by citing `\eqref{eq:48}` directly. Formalised as `Open_eq48`, a
  `Prop`-valued implication between four abstract declared propositions,
  with no `Admitted`/`Axiom` — exactly the paper's own fourfold rationale,
  not proved.
- **eq. 49**: tiered **Open**, per main.tex's own Table 2
  (`\label{tab:status}`, "New in v1.3" Open-empirical-hypotheses row),
  which names eq. (49) by its own label alongside eq. (48) and states
  explicitly: "all tagged `[Open]` in their own source papers, none
  upgraded here." This is a direct, unambiguous instruction from the
  paper's source of record not to upgrade eq. (49) to a proved result — a
  witnessed non-collapse on the finite `TopicEntry`/`ProblemOnlyPolicy`
  model introduced for eq. (47) is mechanically available (parallel to
  eq. (11)/(24)/(38)/(42) in Block A/B), but formalising it as a Theorem
  would contradict the paper's own explicit tiering and so is not done.
  `Open_eq49` states the hypothesis, in the same
  `ProblemFirst -> ~ ProblemOnly` shape as `Open_eq48`, with no
  `Admitted`/`Axiom`. (Corrected 2026-09-06 per adversarial review
  BLOCK-1-eq49-tier-dishonesty: the prior pass upgraded this to Th_coqc by
  analogy to the eq.11/24/38/42 pattern without engaging Table 2's direct
  "none upgraded here" instruction — that was a tier-honesty violation,
  now fixed.)
- **eq. 50, 51**: both tiered **Definition**, in the same family as eq.
  (44)/(45)/(65)/(66) in MR_River.v — a well-typed composition (eq. 50)
  and a well-typed finite cycle-successor function (eq. 51); their
  type-checking is the Definition-tier content, with the paper's own
  hedge (`\Cref{sec:return2}`: the closure is conditional, not universal)
  not smuggled into any further claim.
- **eq. 52**: typed exactly as After Labour eq. 2 writes it, with the
  "z ≠ S" clause carried as a discharged Section `Hypothesis`
  (`readout_ne_state`), never a top-level `Axiom`, per the task's
  Section/Variables/Hypotheses discipline. A supporting satisfiability
  witness (`readout_52_hypothesis_satisfiable_on_bool`, on a two-point
  `bool` state space via `negb`) confirms the Hypothesis is not vacuous —
  scaffolding, not a re-tagging of eq. 52 itself.
- **eq. 54**: a genuine accounting-identity proof over `Q`, in exactly the
  style the task brief names for accounting identities: given
  `1 - s_t^L ≠ 0`, `q_t^min * (1 - s_t^L) == Γ̄ - s_t^L`, proved by the
  `field` tactic (confirmed available for `Q` via `QArith`'s registered
  field structure) discharging the side condition.
- **eq. 55**: After Labour's own text calls this a restatement of the
  eq. (19) nesting "already used" in `\Cref{sec:live1}"; proved by the
  identical technique as eq. (19) in MR_Live.v (`Pi_live_ws` as a `filter`
  of `Pi_feas_ws`, plus one declared structural hypothesis
  `feas_subset_phys_ws`), reindexed by person `i` rather than agent `A` so
  as not to clash with MR_Live.v's own section-local names (different
  file/module, but kept disjoint for clarity).
- **eq. 56**: "the same task-relative envelope form as eq. (25)" — tiered
  **Definition** exactly as eq. (25) is in MR_Live.v, using the identical
  finite-list `fold_right Qmax` construction (never a sup over an
  unbounded set) maximised over the live set rather than the witnessed
  set. `corrigible_agency_ws_upper_bound` is offered as a supporting fact
  (not a re-tagging of eq. 56), confirming the finite max is a genuine
  upper bound.
- **eq. 58**: the paper's own real-valued Cobb-Douglas exponents
  `theta_*` are the readout-first replacement case named in the task
  brief: exponents are declared `nat` and the power is `Qpow_nat`, a
  `Fixpoint` computing `q^n` by repeated multiplication — no
  `Coq.Reals`, no analytic power function. After Labour's own text
  ("not a welfare utility function or a validated cardinal scale but a
  typed audit index") keeps this at **Definition**, not a proof
  obligation.
- **eq. 59**: exactly the task brief's own named worked example for this
  content ("(43) Ẏ>0 ⇏ Ṗ^H>0 as a witness model where output difference
  is positive and position difference is not" — the general pattern the
  brief describes, instantiated here at the paper's actual eq. (59), the
  primary non-collapse result After Labour states at its own eq. 43).
  `Ẏ_t`/`Ṗ_t^H` are read as the discrete one-step difference `ddiff`
  (never a continuum derivative), and the theorem exhibits a concrete
  finite model where the output difference is strictly positive while the
  position-index difference is not (indeed is exactly zero, a stronger
  witness than merely "not positive").
- **eq. 60**: HCI's own "one framing inequality" (HCI eq. 1), proved by
  the identical witnessed-non-collapse technique as eq. 59, reusing the
  shared `ddiff` discrete-difference operator.
- **eq. 61–64**: all four are explicitly tagged
  "`[\textsc{Definition}]`" by the paper's own text (HCI eq. 11, 12, 17,
  19 respectively), so all four are tiered **Definition** here with no
  further claim proved. eq. 62's continuum partial log-derivative
  `∂ln C/∂ln M` is the other readout-first replacement named in the task
  brief for this block: `eta_HC` is a ratio of two one-step `Q`-valued
  relative (percentage) changes — a discrete finite-difference surrogate
  for the log-derivative, never `Coq.Reals`/`ln`/`exp`. eq. 63's
  `{t : ...}` set-builder is modelled as a decidable `filter`/`Qle_bool`
  cut over a declared finite list of time indices (the same pattern as
  eq. 21 in MR_Live.v), never an unbounded/continuum-indexed
  comprehension.

### Equations this pass could not honestly formalise

None. All of eq. (46)–(64) are formalised above at exactly one tier each,
with no `Admitted`, no top-level `Axiom`/`Parameter`, and no equation
skipped. `verify.sh` (re-run after adding `MR_TopicEntry.v`/
`MR_WorldSystem.v` and extending its identifier regex to also match
`Remark`) reports **38/38** identifiers across all three blocks — Closed
under the global context, 0 failed. (Was 39/39 before the 2026-09-06
adversarial-review fix removed `eq49_problem_first_neq_problem_only`,
re-tiering eq. (49) Th_coqc → Open per Table 2's explicit instruction;
one fewer proved identifier, zero equations skipped.)

## Block D — eq. (67)–(79) (MR_HCA.v)

Paper source of record for this block: `../v1_4/main.tex` (Master
Equation River v1.4), Section "Barrier Readout, Endorsement, Scaffold
Fading, and Opportunity Conversion" (`\label{sec:hca}`, eq. 67–78) and
the `\label{eq:79}` outer-loop tail printed in Section 5. Every equation
number in this block restates From Assistance to Human Capability
(RG-HCA) `\citep{rg_hca}`, source text
`research/textbook-written-by-ai-still-true/new-2026-09/rg-hca/main.tex`,
each traced to RG-HCA's own equation number in main.tex's running prose.

| eq. | File | Identifier(s) | Tier | `Print Assumptions` |
|---|---|---|---|---|
| 67 | MR_HCA.v | `hca_river_67` (Section `HCARiver`) | Definition | n/a |
| 68 | MR_HCA.v | `LifeCapitalContext`; `mk_life_capital_context` | Definition | n/a |
| 69 | MR_HCA.v | `BarrierType` (Inductive); `all_barrier_types`; `BarrierLedger` | Definition | n/a |
| 70 | MR_HCA.v | `eq70_observed_difficulty_not_skill_deficit` | Th_coqc | Closed under the global context |
| 71 | MR_HCA.v | `C_live` (Section `EndorsedRoutes`); `C_live_subset_C_cand` | Definition | `C_live_subset_C_cand`: Closed under the global context (supporting subset lemma) |
| 72 | MR_HCA.v | `eq72a_proactive_suggestion_not_human_goal_ownership`, `eq72b_capability_advancement_not_ai_goal_authority`, `eq72c_scaffolding_not_control` | Th_coqc | Closed under the global context (all three) |
| 73 | MR_HCA.v | `hca_ddiff` (scaffold); `Open_eq73` | Open | n/a (Open Prop, not proved by design) |
| 74 | MR_HCA.v | `world_closure_74` (Section `WorldClosureHCA`) | Definition | n/a |
| 75 | MR_HCA.v | `omega_real_75` (Section `OpportunityReadout`) | Definition | n/a |
| 76 | MR_HCA.v | `eq76a_credential_not_capability`, `eq76b_market_legibility_not_human_worth` | Th_coqc | Closed under the global context (both) |
| 77 | MR_HCA.v | `NetAdvancementRecord`; `mk_net_advancement_record` | Definition | n/a |
| 78 | MR_HCA.v | `stratum_members`, `qsum`, `qmean`; `ATE_HCA_78` (Section `ConditionalEstimand`) | Definition | n/a |
| 79 | MR_HCA.v | `hca_outer_layer_79` (Section `HCAOuterLoopLayer`) | Definition | n/a |

### Notes on Block D tiering decisions

- **eq. 67**: RG-HCA's own native river (RG-HCA eq. 5). main.tex reads it
  against eq. (51) in MR_TopicEntry.v: "inserts a Barrier Readout stage
  before Candidate Routes and appends Opportunity Conversion after World
  Feedback; it is a proactive elaboration ... not a replacement." Typed
  as a 12-stage well-typed composition through abstract `Variable`
  arrows, in the identical family as `master_river_44` in MR_River.v —
  the composition's well-typedness (it compiles) is the entire
  Definition-tier content; no claim about the evidential status of any
  individual arrow is asserted.
- **eq. 68**: "Life-Capital Context Vector [Definition]" (RG-HCA eq. 8),
  explicitly tagged by the paper. Typed as a 9-tuple, in the same family
  as `HumanConversionVector` (eq. 61) in MR_WorldSystem.v. main.tex
  states plainly it "is not a universal cardinal measure of human
  capital and does not exhaust life conditions" — Definition only.
- **eq. 69**: "typed barrier ledger" (RG-HCA eq. 12), a finite subset of
  a ten-constructor closed `Inductive` `BarrierType`, the same
  finite-enumeration discipline as `TopicEntry` (eq. 47) and
  `CycleStage` (eq. 51) in MR_TopicEntry.v. A ledger is a `list
  BarrierType` — a finite subset of a finite type, never an open-ended
  classifier.
- **eq. 70**: main.tex tags the *ledger* eq. (69) `[Definition]`, but the
  assignment brief for this pass specifically calls for eq. (70)
  ("Observed Difficulty =/= Skill Deficit", RG-HCA eq. 13) to be
  discharged as a genuine witnessed non-collapse — the same technique as
  eq. (59)/(60) in MR_WorldSystem.v — so it is upgraded to **Th_coqc**
  here: a concrete finite model (`bool`, `True`/`False` predicates) where
  a difficulty is observed and no skill deficit holds. This matches the
  narrow-witness discipline already used for eq. 5/8/16 elsewhere in
  this ledger: the witness proves the non-collapse is real on a concrete
  model, not that it holds universally.
- **eq. 71**: "the endorsed subset [Definition]" (RG-HCA eq. 16), typed
  exactly as main.tex writes it via finite-list `filter`. The subset
  fact `C_live_subset_C_cand` is a supporting lemma in the same
  "supporting fact, not a re-tagging" spirit as
  `corrigible_agency_ws_upper_bound` for eq. (56) in MR_WorldSystem.v —
  the eq. (71) tag itself stays **Definition**, per the task brief's own
  framing ("Definition + lemma").
- **eq. 72**: main.tex tags this `[Definition]`, but the task brief calls
  for all three conjuncts (Proactive Suggestion =/= Human Goal Ownership;
  Capability Advancement =/= AI Goal Authority; Scaffolding =/= Control —
  RG-HCA eq. 17–19) to be discharged as genuine witnessed non-collapses,
  so it is upgraded to **Th_coqc** here, covering the full aligned
  equation block with three separate witness theorems (one comment tag,
  three conjuncts, per house style for a single boxed multi-line
  equation).
- **eq. 73**: "candidate fading rule [\textsc{Open}]" (RG-HCA eq. 22),
  explicitly tagged Open by the paper itself ("RG-HCA marks this rule
  Open and states it should be replaced if a simpler rule performs as
  well"). Stated as `Open_eq73`, a `Prop`-valued `Definition` over
  one-step `Q`-valued finite differences (`hca_ddiff`, the same
  `ddiff`-style discrete-readout substitution as eq. (59)/(60) in
  MR_WorldSystem.v) — never discharged with a `Theorem`/`Lemma`.
- **eq. 74**: "restating the same world-closure step as eq. (50) over
  RG-HCA's own candidate HCA state Z_HCA" (RG-HCA eq. 27) — a well-typed
  3-step composition, in the identical family as `dcp_closure_50` in
  MR_TopicEntry.v and `river_tail_65` in MR_River.v.
- **eq. 75**: "a world-side opportunity readout" (RG-HCA eq. 28),
  "explicitly not a validated welfare utility function" — a typed
  6-argument function, Definition tier only, parallel to `P_H_index` for
  eq. (58) in MR_WorldSystem.v (also explicitly not a validated cardinal
  scale).
- **eq. 76**: main.tex tags this `[Definition]`, but the task brief calls
  for both conjuncts (Credential =/= Capability; Market Legibility =/=
  Human Worth — RG-HCA eq. 29–30) to be discharged as genuine witnessed
  non-collapses, so it is upgraded to **Th_coqc** here, covering both
  conjuncts of the aligned equation block with two witness theorems (one
  comment tag, two conjuncts).
- **eq. 77**: "net advancement record [Definition]" (RG-HCA eq. 36) —
  typed as a 9-tuple, in the same family as `LifeCapitalContext` (eq. 68)
  and `HumanConversionVector` (eq. 61).
- **eq. 78**: "a conditional estimand [Definition, measurement]" (RG-HCA
  eq. 37), `ATE_HCA(x) = E[Y(1) - Y(0) | K^life = x]`. Modelled over an
  explicitly finite, `Q`-valued population (`Population : list
  Individual`), a decidable stratum-membership filter
  (`stratum_members`), and the difference of two finite arithmetic means
  over `Q` (`qmean`) — never `Coq.Reals`/a continuum-measure
  expectation. A zero-member stratum yields a mean of `0` by `Q`'s own
  total division convention; this degenerate-readout behaviour is
  flagged in the source comment, not hidden. main.tex's own hedge
  ("matching or covariate adjustment is a design strategy, not part of
  the estimand itself") is honoured: no identification/causal claim is
  asserted, only the typed contrast-of-finite-averages structure.
- **eq. 79**: "RG-HCA's barrier and opportunity layer ... sits inside
  this same outer loop ... restating eq. (74)–(75) at the scale of one
  full pass" — a well-typed 2-step composition (`hca_outer_layer_79`)
  threading one pass's Human-Return state through the
  barrier/endorsement readout (eq. 69/71, abstracted as a single arrow
  since both are already typed above) and the opportunity readout
  (eq. 75) into the world-system pair `(C^H_{t+3}, P^H_{t+3})` that opens
  eq. (66) in MR_River.v. main.tex is explicit this is "a schematic
  placement ... without adding a further arrow inside eq. (44)–(65) or
  reweighting eq. (66) itself" — Definition tier, no further claim
  asserted.

### Equations this pass could not honestly formalise

None. All of eq. (67)–(79) are formalised above at exactly one tier
each, with no `Admitted`, no top-level `Axiom`/`Parameter`, and no
equation skipped. `verify.sh` (re-run after adding `MR_HCA.v`) reports
**45/45** identifiers across all four blocks — Closed under the global
context, 0 failed (38 carried over from Blocks A–C plus 7 new proved
identifiers in this block: `eq70_observed_difficulty_not_skill_deficit`,
`C_live_subset_C_cand`, `eq72a_proactive_suggestion_not_human_goal_ownership`,
`eq72b_capability_advancement_not_ai_goal_authority`,
`eq72c_scaffolding_not_control`, `eq76a_credential_not_capability`,
`eq76b_market_legibility_not_human_worth`).
