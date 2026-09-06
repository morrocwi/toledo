# LEDGER — family "human-ai-reading"

Coq 8.20.1. Build/verify command used throughout (RAM discipline: one file
at a time, never parallel `coqc`):

```sh
cd research/society-justice-peace/master-river
coqc -Q coq_canon MRC -Q coq MR coq_canon/MRC_human_ai_reading_a.v
coqc -Q coq_canon MRC -Q coq MR coq_canon/MRC_human_ai_reading_b.v
```

Both files compiled clean: zero errors, zero warnings, in that order
(`_b.v` does not depend on `_a.v` — the two are independent, split for
size only, per the task's own "split _a/_b if large" instruction).

Family assignment record: `../registry/family_human-ai-reading.json`.
Assignment method: `domain: "human–AI"` in `../registry/CANONICAL.json`
(74 ids, `CAN-041`..`CAN-114`, verbatim from `../registry/COLLAPSE.md`
§"Human–AI domain (74 ids)"). This family is **not** root-spine (the nine
`domain: "root"` spine_ids are family `root-spine`,
`coq_canon/MRC_root_spine.v`/`MRC_master.v`, produced by a different pass)
— per COLLAPSE.md §2, "The Master River v1.4 human–AI chain (eq. 44/65/
66/79) is one `q_HAI` reading of the spine above, not a second equation".
Because this family reads the spine rather than adding to it, **no
`MRC_master.v` is produced by this pass** — the master-equation
composition and the `DomainReading`/`weld_holds` apparatus belong to the
root-spine family's file, not to a domain reading of it.

## Reuse of `../coq/MR_*.v`

Of the 74 ids, **23** cite a specific Master River v1.4 `eq.(NN)` in their
own `canonical_source` field and are discharged by `Require Import`-ing
the already-compiled, already axiom-free `coq/MR_*.v` module that
formalises that eq. number and aliasing its identifier under the CAN id —
never redefining it. The other **51** ids are standalone (their own
`canonical_source` cites a record id, not a Master River eq. number:
Readout Genesis Standalone Synthesis 21529456, Experience Is the Human
LoRA 21425420, Epistemic Fusion/Tunnel v8.1 22331922, How Humans Should
Converse with AI / DCP 22481928, The Epistemic Chain Reaction 22308072,
CTSA Human-Return Readout 22339909, Before Meaning Before Choice 22424434,
After Labour 22481924, Choice Begins Before Choice 22357788, Experience Is
Meaning-Giving 22357744, Mind as Information Horizon 19640361, Meaning
Before Naming 22410666, and others) and are freshly formalised in this
pass, in the same Section+Variables/Hypotheses, Q/nat/bool/list/Inductive
discipline as every other file in this repository.

| CAN id → `MR_*.v` module(s) reused |
|---|
| CAN-041, 042 → `MR_Prompt`, `MR_TopicEntry` |
| CAN-044 → `MR_TopicEntry` |
| CAN-045, 046, 047 → `MR_Prompt` |
| CAN-057, 058, 059, 060 → `MR_Live`, `MR_WorldSystem` |
| CAN-062 → `MR_Retention` |
| CAN-066 → `MR_Retention`, `MR_Prompt` |
| CAN-075, 076, 079 → `MR_Retention` |
| CAN-088 → `MR_TopicEntry` |
| CAN-098, 100, 102, 103, 104, 105, 106 → `MR_HCA` |

**Registry drift note (disclosed, not silently resolved):** CAN-088's
`in_master_river` field in CANONICAL.json says `[74]`, which would suggest
`MR_HCA.world_closure_74`. Its own `canonical_text`
(`I_s→a_s→δ^world_{s+1}→H_{s+1,0}`) and `canonical_source` ("Master
Equation River v1.4 eq.(50)-(51) [dialogue_conversion_protocol]") instead
match `MR_TopicEntry.dcp_closure_50`/`cycle_next_51` verbatim —
`world_closure_74` uses different variable names (`R^return_{H,i,n}`,
`Z_{HCA,i,n+1}`) for a structurally similar but textually distinct
world-closure step. The more specific `canonical_text`/`canonical_source`
fields were followed (`dcp_closure_50`/`cycle_next_51` aliased under
CAN-088); CANONICAL.json itself was not edited by this pass (registry
edits are out of scope for a formaliser pass).

## `MRC_human_ai_reading_a.v` — CAN-041..CAN-077 (37 ids)

| CAN id | key | Coq identifier(s) | tier (this file) | tier (CANONICAL.json's own words) |
|---|---|---|---|---|
| CAN-041 | pre-prompt-human-state-transport | `CAN_041_pre_prompt_human_state_transport` (= `MR_Prompt.next_state`) | Definition | law (named principle) / definition |
| CAN-042 | pre-prompt-transport | `CAN_042_bounded_transport`; `CAN_042_bounded_transport_satisfiable_on_nat` | Definition + Th_coqc witness | definition |
| CAN-043 | entry-state-anchor | `EntryStateAnchor` (Record), `CAN_043_mk_entry_state_anchor` | Definition | definition |
| CAN-044 | DCP-topic-entry | `CAN_044_TopicEntry`, `CAN_044_Legitimate` (= `MR_TopicEntry`); `CAN_044_Open_ProblemFirst_implication`, `CAN_044_Open_ProblemFirst_ne_ProblemOnly` (Open, un-proved) | Definition (eq.47) / Open (eq.48-49) | definition/law (PFDP itself [Open]) |
| CAN-045 | B-HAI-PREPROMPT | `CAN_045_prompt_coupling_and_update` (= `MR_Prompt.next_state`); `CAN_045_live_weight_may_change_witness` (= `MR_Prompt.eq30_live_weight_may_change`) | Definition + Th_coqc witness | identity (27,28,30); definition (29) |
| CAN-046 | ai-response-chain | `CAN_046_ai_response_chain` (= `MR_Prompt.ai_turn`) | Definition | definition |
| CAN-047 | human-AI-session-stepper | `CAN_047_dialogue_session_stepper` (= `MR_Prompt.dlg_step`), `CAN_047_chi_recip`; `CAN_047_chi_recip_bounds_witness` | Definition + Th_coqc witness | definition (chi_recip explicitly not warrant/truth) |
| CAN-048 | agency-conditional-chain | `CAN_048_agency_conditional_chain` | Definition | definition |
| CAN-049 | agency-quotient | `CAN_049_agency_readout`, `CAN_049_is_automorphism`, `CAN_049_Aut` | Definition | definition |
| CAN-050 | self-readout | `SelfState` (Record, 10 fields), `CAN_050_mk_self_readout` | Definition | definition |
| CAN-051 | horizon-triad | `CAN_051_horizon_triad`; `CAN_051_Open_dynamic_to_information_bridge`, `CAN_051_Open_information_to_phenomenal_bridge` (Open, un-proved) | Definition + Open | definition / hypothesis-Open (bridge IP_K explicitly open) |
| CAN-052 | release-dynamics | `CAN_052_release_step`, `CAN_052_sufficient_release_condition` | Definition | definition (sufficient condition) |
| CAN-053 | meta-readout-governance | `CAN_053_second_order_readout`, `CAN_053_governance_bundle`; `CAN_053_Open_no_free_governance` (Open, un-proved) | Definition + Open | definition / law (no-free-governance) / measurement |
| CAN-054 | selective-retention-mechanism | `CAN_054_gate_weight_valid`, `CAN_054_retained_update`, `CAN_054_finite_bottleneck`; `CAN_054_finite_bottleneck_satisfiable`; `CAN_054_Open_empirical_programme` (Open, un-proved) | Definition + Th_coqc witness + Open | definition / theorem (rank bounds, proved in-article) / hypothesis-Open |
| CAN-055 | human-domain-state-graph | `HumanRetainedGraph` (Record), `CAN_055_Dr_spine_equation` | Definition | definition / Dr-interpretive |
| CAN-056 | B-HAI-SYNERGY | `CAN_056_synergy_ratio`; `CAN_056_more_output_ne_more_diversity`; `CAN_056_Open_H1_H2` (Open, un-proved) | Definition + Th_coqc witness + Open | definition (11) / identity (12) / hypothesis [Open] (16)-(17) |
| CAN-057 | live-possibility | `CAN_057_Pi_live` (= `MR_Live.Pi_live`); `CAN_057_full_nesting_witness`, `CAN_057_full_nesting_worldsystem_witness` | Th_coqc | definition |
| CAN-058 | live-set-weight | `CAN_058_live_field`, `CAN_058_live_ge_threshold` (= `MR_Live`) | Definition | definition |
| CAN-059 | choice-noncollapse-chain | `CAN_059_is_valid_choice`; `CAN_059_enactment_may_differ_witness`, `CAN_059_observation_loses_information_witness`, `CAN_059_stage_chain_non_collapse_witness` (= `MR_Live`) | Th_coqc | definition |
| CAN-060 | corrigible-agency-witnessed | `CAN_060_p_star`; `CAN_060_p_star_upper_bound_witness` (= `MR_Live`) | Definition + Th_coqc witness | definition (measurement architecture; empirical claims Open) |
| CAN-061 | live-possibility-dynamics | `CAN_061_live_weight_may_change_witness` (= `MR_Prompt.eq30_...`); `CAN_061_Open_live_field_dynamic` (Open, un-proved) | Th_coqc (possibility half) + Open (dynamic law) | definition / hypothesis-Open (dynamic law explicitly Open) |
| CAN-062 | K_like-noncollapse | `CAN_062_KnowledgeStatus`, `CAN_062_status_value` (= `MR_Retention`); `CAN_062_non_collapse_witness` | Th_coqc | law/definition |
| CAN-063 | K_like-statemachine | `RepairedStatus` (Inductive), `CAN_063_next_status`, `CAN_063_dangerous_shortcut` | Definition | law/proposition |
| CAN-064 | human-ai-transport | `TransportDefect` (Inductive), `CAN_064_transport_condition` | Definition | definition (transport condition, Maker-Checker firewall) |
| CAN-065 | domain-weld-defect | `CAN_065_domain_weld_defect` | Definition | definition |
| CAN-066 | session-retention-gate | `CAN_066_candidate_update`, `CAN_066_is_low_rank`, `CAN_066_retention_gate_update`, `CAN_066_RET` (= `MR_Retention`, `MR_Prompt`); `CAN_066_gate_avoids_doubling_witness`, `CAN_066_RET_rearrangement_witness` | Th_coqc | definition (Master's own proposal) |
| CAN-067 | gain-tunnel-functions | `CAN_067_Delta_s`, `CAN_067_is_expansion`, `CAN_067_is_tunnel` | Definition | proposition |
| CAN-068 | epistemic-fusion-architecture-sequence | `CAN_068_epistemic_fusion_sequence` | Definition | proposition |
| CAN-069 | fusion-non-collapse-bundle | `CAN_069_fluency_ne_baseline`, `CAN_069_explanation_ne_verification`, `CAN_069_resistance_quality_ne_accessibility`, `CAN_069_uncertainty_signal_ne_truth` | Th_coqc (×4) | law (mixed definitional/empirical) |
| CAN-070 | equivalence-class-diagnostic | `CAN_070_D_eff`, `CAN_070_d_s` | Definition | measurement |
| CAN-071 | resistance-quality-accessibility | `CAN_071_R_ep`, `CAN_071_U_R`, `CAN_071_R_ex`; `CAN_071_quality_ne_accessibility` | Definition + Th_coqc witness | proposition/law |
| CAN-072 | calibration-audit | `CalibrationRecord` (Record), `CAN_072_calibration_error` | Definition | measurement |
| CAN-073 | ctsa-bridge | `CAN_073_Open_ctsa_bridge` (Open, un-proved) | Open | hypothesis/Open |
| CAN-074 | assisted-vs-return-noncollapse | `CAN_074_assisted_gain_does_not_imply_return_gain` | Th_coqc | law/definition |
| CAN-075 | exposure-retention-improvement-noncollapse | `CAN_075_EndChainNotion` (= `MR_Retention`); `CAN_075_exposure_retention_improvement_non_collapse` | Th_coqc | definition/law |
| CAN-076 | human-return-CTSA6 | `CAN_076_HReturn`, `CAN_076_mk_h_return` (= `MR_Retention.HReturn`) | Definition | definition |
| CAN-077 | human-return-CTSA4 | `ReturnCTSA4` (Record), `CAN_077_mk_human_return_ctsa4` | Definition | definition |

## `MRC_human_ai_reading_b.v` — CAN-078..CAN-114 (37 ids)

| CAN id | key | Coq identifier(s) | tier (this file) | tier (CANONICAL.json's own words) |
|---|---|---|---|---|
| CAN-078 | D-R-A-constitutive | `CAN_078_Open_dra_constitutive` (Open, un-proved) | Open | definition/hypothesis-Open |
| CAN-079 | outcome-vector-J* | `CAN_079_AUG`, `CAN_079_SYN` (= `MR_Retention`); `CAN_079_aug_syn_non_collapse_witness` | Th_coqc | definition |
| CAN-080 | ctsa-non-collapse-bundle | `CAN_080_fluency_ne_baseline`, `CAN_080_explanation_ne_verification`, `CAN_080_output_count_ne_epistemic_diversity`, `CAN_080_exposure_ne_retention_ne_improvement`, `CAN_080_trust_ne_calibrated_trust` | Th_coqc (×5) | law |
| CAN-081 | ctsa-hypotheses | `CAN_081_Open_hypotheses` (Open, un-proved) | Open | hypothesis/Open |
| CAN-082 | DCP-deployment-triage | `CAN_082_deployment_policy`, `DCPLiteStage` (Inductive), `CAN_082_lite_next` | Definition | definition/hypothesis-Open (AFP itself Open) |
| CAN-083 | DCP-protocol-stages | `DCPStage` (Inductive, 8 ctors), `CAN_083_stage_next`, `CAN_083_oppose_ne_manufacture` | Definition | definition/law |
| CAN-084 | DCP-verify-stage | `StakesKind`, `VerifyMethod` (Inductive), `CAN_084_high_stakes` | Definition | definition/law |
| CAN-085 | DCP-integrate-stage | `IntegrationRec` (Record), `CAN_085_mk_integration_record` | Definition | definition |
| CAN-086 | DCP-remove-stage | `CAN_086_is_reset`, `CAN_086_is_removal` | Definition | definition |
| CAN-087 | DCP-return-conversion-vector | `ReturnConversionVector` (Record), `CAN_087_F_return` | Definition | definition |
| CAN-088 | DCP-return-action-feedback | `CAN_088_world_closure` (= `MR_TopicEntry.dcp_closure_50`), `CAN_088_CycleStage`/`CAN_088_cycle_next` (= `MR_TopicEntry`) | Definition | definition (World-closure proposition itself [Open]) |
| CAN-089 | DCP-expand-contract | `CAN_089_is_expansion`, `CAN_089_is_contraction` | Definition | definition |
| CAN-090 | DCP-open-propositions | `CAN_090_Open_dcp_propositions` (Open, un-proved) | Open | hypothesis/Open |
| CAN-091 | DCP-hypotheses | `CAN_091_Open_hypotheses` (Open, un-proved) | Open | hypothesis/Open |
| CAN-092 | DCP-closing-questions | `ClosingQuestion` (Inductive) | Definition | proposition |
| CAN-093 | event-translation-core | `EventContext` (Record), `CAN_093_interpretation`; `CAN_093_interpretation_ne_event_witness` | Definition + Th_coqc witness | definition/proposition |
| CAN-094 | self-context-agency | `ContextS` (Record), `CAN_094_is_agency` | Definition | definition/proposition |
| CAN-095 | grounding-embodiment | `CAN_095_referential_ne_embodiment`; `CAN_095_experiential_grounding` | Th_coqc | definition/hypothesis-Open |
| CAN-096 | interaction-efficiency | `CAN_096_interaction_efficiency` | Definition | definition |
| CAN-097 | ai-mediation-hypotheses | `CAN_097_Open_hypotheses` (Open, un-proved) | Open | hypothesis/Open |
| CAN-098 | HCA-native-river | `CAN_098_hca_native_river` (= `MR_HCA.hca_river_67`) | Definition | definition |
| CAN-099 | HCA-candidate-state | `HCACandidateState` (Record, 8 fields), `CAN_099_mk_hca_candidate_state` | Definition | definition |
| CAN-100 | life-capital-context | `CAN_100_LifeCapitalContext`, `CAN_100_mk_life_capital_context` (= `MR_HCA`) | Definition | definition |
| CAN-101 | capability-conversion-noncollapse | `CAN_101_resources_ne_access`, `CAN_101_access_ne_capability`, `CAN_101_capability_ne_realized_opportunity`, `CAN_101_access_ne_control` | Th_coqc (×4) | definition |
| CAN-102 | barrier-readout | `CAN_102_BarrierType`, `CAN_102_BarrierLedger` (= `MR_HCA`); `CAN_102_observed_difficulty_ne_skill_deficit_witness` | Th_coqc | definition |
| CAN-103 | candidate-vs-endorsed-routes | `CAN_103_C_live` (= `MR_HCA.C_live`); `CAN_103_C_live_subset_witness`, `CAN_103_proactive_ne_ownership_witness`, `CAN_103_capability_ne_ai_authority_witness`, `CAN_103_scaffolding_ne_control_witness` | Th_coqc | definition |
| CAN-104 | scaffold-fading | `CAN_104_hca_ddiff` (= `MR_HCA`); `CAN_104_Open_scaffold_fading` (= `MR_HCA.Open_eq73`, Open, un-proved) | Open | hypothesis/Open |
| CAN-105 | opportunity-conversion | `CAN_105_omega_real` (= `MR_HCA.omega_real_75`); `CAN_105_credential_ne_capability_witness`, `CAN_105_legibility_ne_worth_witness` | Th_coqc | definition |
| CAN-106 | net-advancement-record | `CAN_106_NetAdvancementRecord`, `CAN_106_ATE_HCA` (= `MR_HCA`) | Definition | definition/measurement |
| CAN-107 | HCA-worked-scenario | `CAN_107_raw_difference_ne_effect_hca` | Th_coqc | definition/proposition |
| CAN-108 | HCA-governance-bundle | `CAN_108_adult_governance`, `CAN_108_child_governance` | Definition | definition |
| CAN-109 | before-meaning-hypotheses | `CAN_109_Open_hypotheses` (Open, un-proved) | Open | hypothesis/Open |
| CAN-110 | rival-model-ladder-prechoice | `RivalModel` (Inductive, 5 ctors), `CAN_110_ladder_index` | Definition | definition |
| CAN-111 | human-ai-attribution | `AttributionLabel`, `OriginObject` (Inductive), `CAN_111_attribution` | Definition | definition |
| CAN-112 | decisive-record-argmax | `CAN_112_is_argmax`; `CAN_112_Open_is_argmin` (Open, un-proved) | Definition + Open | hypothesis/Open |
| CAN-113 | CTSA-taxonomy | `CTSAStage` (Inductive, 5 ctors), `CAN_113_stage_next` | Definition | proposition |
| CAN-114 | dialogue-open-predictions | `CAN_114_Open_predictions` (Open, un-proved) | Open | hypothesis/Open |

## Summary

- **74 / 74** CAN ids formalised, one primary Coq identifier per id (a
  `Definition`/`Record`/`Inductive`, per the `family_human-ai-reading.json`
  member list), each carrying the required
  `(* CAN-nnn — root: ... — domain: human–AI — tier: T — occurrences: n *)`
  comment. **0 could not be formalised.**
- Tier split, counted directly from the `tier:` field of each CAN id's own
  one-line comment tag in the two `.v` files (`grep -oE` + tally, not
  hand-counted): **21 Th_coqc** (CAN-045, 047, 054, 056, 057, 059, 062,
  066, 069, 071, 074, 075, 079, 080, 093, 095, 101, 102, 103, 105, 107 — a
  proved witness/non-collapse/bound is this id's own headline content),
  **40 Definition**, **13 Open** (a stated, deliberately un-proved `Prop`:
  CAN-044, 051, 061, 073, 078, 081, 090, 091, 097, 104, 109, 112, 114 —
  every CAN id whose own tag was set to `Open` because its *headline*
  content, not merely a side component, is the source's own tagged-Open
  claim). 21 + 40 + 13 = 74. (Several `Definition`- and `Th_coqc`-tagged
  ids additionally carry a smaller Open *sub*-component typed alongside
  their main content — e.g. CAN-053's no-free-governance law, CAN-054's
  empirical programme, CAN-056's H1/H2 — see each id's own row above; the
  one-line tag reflects the id's dominant, proof-obligation-bearing
  content, per the same convention `MRC_root_spine.v` uses.)
- **23** ids alias an identifier from an already-compiled `../coq/MR_*.v`
  module (`MR_Prompt`, `MR_TopicEntry`, `MR_Live`, `MR_WorldSystem`,
  `MR_Retention`, `MR_HCA`) rather than redefining it — see the reuse
  table above. **51** ids are freshly formalised.
- **40** `Print Assumptions` checks were run (every `Theorem`/`Remark` in
  both files that this pass itself proves, plus every alias to an
  already-proved `MR_*.v` theorem reused under a CAN id) via a scratch
  file `Require`-ing both `MRC.MRC_human_ai_reading_a`/`_b` and calling
  `Print Assumptions` on each in turn: **all 40 report "Closed under the
  global context"** — zero axioms, zero admitted lemmas, in the entire
  reused-plus-fresh proof graph for this family.
- `grep -nE "Admitted|^Axiom|^Parameter"` on both files: the only two
  matches are inside the discipline-statement comment in
  `MRC_human_ai_reading_a.v`'s own header (naming these forbidden
  constructs, never using them). No `Admitted`, no top-level
  `Axiom`/`Parameter` anywhere in either module.
- `coqc -Q coq_canon MRC -Q coq MR <file>` compiles both files clean
  (exit 0, zero warnings) under Coq 8.20.1, compiled one file at a time
  (never parallel), per the RAM discipline.
- No `Coq.Reals`, no classical axioms, no functional extensionality.
  Every numeric object lives on `Q` (gate weights, ratios, calibration
  error, the release stepper, `RET`/`AUG`/`SYN`) or `nat` (ranks, ladder
  indices, stage counts); every finite enumeration (`BarrierType`,
  `TopicEntry`, `DCPStage`, `RivalModel`, `AttributionLabel`, `CTSAStage`,
  `RepairedStatus`, `StakesKind`/`VerifyMethod`, `ClosingQuestion`,
  `TransportDefect`) is a closed `Inductive`, never an open-ended
  classifier. Discrete replacements recorded in-line at each site:
  - CAN-042/054/056/069/071/074/075/080/093/095/101/102/103/105/107: every
    "A ≠ B" or "A ⇏ B" claim from the source prose is discharged as a
    **witnessed** non-collapse/non-implication on a small finite model
    (mostly the `bool`/`(fun _ => True)`/`(fun _ => False)` idiom already
    established in `../coq/MR_HCA.v`'s `eq70`/`eq72`/`eq76` family, or a
    concrete `nat`/`Q` counter-instance) — never a universal claim that
    the two named notions always differ, and never left as an unmotivated
    `Prop` where the source itself asserts a checkable inequality.
  - CAN-055's continuum-flavoured second-order field equation
    (`mu δ²φ + d δφ + κ L φ + ∂V(φ) = J − η`) is typed as a `Q` equation
    over abstractly-declared discrete-difference terms, explicitly
    Dr-interpretive (not asserted), matching the source's own "not a
    derived biological law" caveat.
  - CAN-070/072's finite-population statistics (`D_s^eff`, calibration
    error) are `nat`/`Q`-valued readouts of finite lists (`length`,
    `fold_right`), never a continuum-measure cardinality or expectation.
  - CAN-052's non-negativity projection uses `Qmax _ 0`, never a
    continuum clamp.
- Registry drift disclosed above (CAN-088's `in_master_river` field vs.
  its own `canonical_text`/`canonical_source`) — not silently resolved,
  not corrected in `CANONICAL.json` (out of scope for a formaliser pass).
- No `MRC_master.v` produced by this pass — see "Reuse" section header
  above for why (this family reads the spine; it is not root-spine).

Could not formalise: **none**. All 74 CAN ids in `family_human-ai-reading.json`
have exactly one tagged Coq identifier in `MRC_human_ai_reading_a.v` or
`MRC_human_ai_reading_b.v`.
