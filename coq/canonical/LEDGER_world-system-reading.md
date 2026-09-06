# LEDGER — family "world-system-reading"

Coq 8.20.1. Build/verify command used throughout (RAM discipline: one file
at a time, never parallel `coqc`):

```sh
cd research/society-justice-peace/master-river
coqc -Q coq_canon MRC -Q coq MR coq_canon/MRC_world_system_reading.v
```

Compiled clean: zero errors, zero warnings. All 25 CAN ids for this family
fit in a single file (863 lines) — no `_a`/`_b` split was needed (compare
`MRC_epistemic_reading.v`, 1050 lines for 49 ids, also a single file).

Family assignment record: `../registry/family_world-system-reading.json`.
Assignment method: `domain: "world-system"` in `../registry/CANONICAL.json`
(25 ids, `CAN-140`..`CAN-164`, verbatim from `../registry/COLLAPSE.md`
§"World-system domain (25 ids)"). This family is **not** root-spine (the
nine `domain: "root"` spine_ids are family `root-spine`,
`coq_canon/MRC_root_spine.v`/`MRC_master.v`, produced by a different pass)
— per COLLAPSE.md §2: "The world-system reading has no bare
Laplacian/weld object of its own ... it enters through CAN-006 (CAN-150's
bridge) and CAN-004 (CAN-151's Human Systemic Position index) rather than
through CAN-001/CAN-003 directly." Because this family reads the spine
rather than adding to it, **no `MRC_master.v` is produced by this pass**
— the master-equation composition and the `DomainReading`/`weld_holds`
apparatus belong to the root-spine family's file, not to a domain reading
of it.

## Reuse of `../coq/MR_WorldSystem.v`

Of the 25 ids, **7** cite a specific Master River v1.4 `eq.(NN)` in their
own `canonical_source`/`in_master_river` field and are discharged by
`Require Import`-ing the already-compiled, already axiom-free
`coq/MR_WorldSystem.v` module that formalises that eq. number and
aliasing its identifier under the CAN id — never redefining it. The other
**18** ids are standalone (their own `canonical_source` cites an After
Labour or The Human Conversion Imperative equation number, not a Master
River eq. number — records `22481924`/`22481926`) and are freshly
formalised in this pass, in the same Section+Variables/Hypotheses,
Q/nat/bool/list/Inductive discipline as every other file in this
repository. Two pieces of `MR_WorldSystem.v` scaffolding that are *not*
themselves numbered equations — `Qpow_nat` (finite repeated
multiplication, discrete replacement for a continuum real exponent) and
`ddiff` (one-step finite difference, discrete replacement for a
continuum time-derivative) — are reused directly for several of the
fresh ids too, rather than re-declared.

| CAN id → `MR_WorldSystem.v` identifier(s) reused |
|---|
| CAN-142 → `Qpow_nat` (scaffolding only, not the eq.53-64 identifiers) |
| CAN-143 → `LabourCentrality`, `mk_labour_centrality` (eq.53) |
| CAN-144 → `q_min`, `eq54_citizen_claim_threshold_identity` (eq.54) |
| CAN-146, 147, 148, 153, 154, 160 → `ddiff` (scaffolding, via the shared local witness `CAN_ws_generic_rise_not_entail_rise`) |
| CAN-151 → `P_H_index`, `eq59_output_rise_not_position_rise` (eq.58-59) |
| CAN-157 → `corrigible_agency_ws`, `corrigible_agency_ws_upper_bound` (eq.56) |
| CAN-158 → `ReturnProfileWS`, `mk_return_profile_ws` (eq.57) |
| CAN-159 → `eq60_machine_expansion_not_human_expansion`, `HumanConversionVector`, `mk_human_conversion_vector`, `eta_HC` (eq.60-62) |
| CAN-163 → `reversibility_window`, `in_reversibility_window`, `urgency_term` (eq.63-64) |

## Shared scaffolding introduced by this pass (not itself a CAN id)

`CAN_ws_generic_rise_not_entail_rise` — one generic witnessed
non-collapse (a concrete finite model where one discrete-difference
sequence is strictly positive while a second, independently chosen one is
not), built directly on `MR_WorldSystem.ddiff`, proved once and reused by
plain alias for **CAN-146, CAN-147** (via bespoke concrete-number
instances of the *same* underlying technique, see below), **CAN-153,
CAN-154**, and — as a single universally quantified statement,
`CAN_160_all_separations_satisfiable` — for all nine separations bundled
under **CAN-160**.

CAN-146, CAN-147, and CAN-148 additionally carry **bespoke** concrete-`Q`
witnesses (not the generic `nat`/`Q` schema) because their own source
formulas are directly modellable in closed form: CAN-146 exhibits two
agents whose wealth accumulates to identical totals (10→15 each) despite
one receiving a positive capital transfer and the other none, so the
ownership *share* is unchanged (1/2 → 1/2); CAN-147 exhibits a rising
machine-abundance readout *and* a rising rent-burden readout over one
step while the resulting `Qmax`-clamped effective claim falls; CAN-148
exhibits full gate-control together with full exit access forcing
dependency to exactly zero for any weight. These are `Th_coqc`-tier
findings this pass proves itself, not aliases.

## `MRC_world_system_reading.v` — CAN-140..CAN-164 (25 ids)

| CAN id | key | Coq identifier(s) | tier (this file) | tier (CANONICAL.json's own words) |
|---|---|---|---|---|
| CAN-140 | labour-claim-chain | `LabourClaimStage` (Inductive, 5 ctors), `CAN_140_labour_claim_next` | Definition | definition |
| CAN-141 | epistemic-firewall-validation | `CAN_141_Z_next`, `CAN_141_valid_validation_rate` | Definition | definition |
| CAN-142 | machine-capacity-block | `CAN_142_B_RB`, `CAN_142_M_index`, `CAN_142_rho_CES`, `CAN_142_labour_share`; `CAN_142_B_RB_identity` | Definition + Th_coqc (trivial identity) | definition/identity |
| CAN-143 | labour-centrality | `CAN_143_LabourCentrality`, `CAN_143_mk_labour_centrality` (= `MR_WorldSystem`) | Definition | definition |
| CAN-144 | claim-constitution | `CAN_144_q_min`, `CAN_144_citizen_claim_threshold_identity` (= `MR_WorldSystem`); `CAN_144_convex_combine`, `CAN_144_convex_combine_identity`, `CAN_144_q_t`, `CAN_144_Gamma_t` | Th_coqc | definition/identity |
| CAN-145 | demand-realization | `CAN_145_AD`, `CAN_145_chi_dem`, `CAN_145_Pi_M`; `CAN_145_chi_dem_le_one` | Th_coqc | definition/identity |
| CAN-146 | ownership-accumulation | `CAN_146_ownership_accumulate`, `CAN_146_ownership_share`; `CAN_146_redistribution_not_ownership_reproduction` | Th_coqc | definition |
| CAN-147 | scarce-asset-rent | `CAN_147_B_scarce`, `CAN_147_Gamma_eff`; `CAN_147_abundance_not_low_burden_not_freedom` | Th_coqc | definition/identity |
| CAN-148 | conversion-gates | `CAN_148_G_conv`, `CAN_148_Dependency`; `CAN_148_concentration_not_dependency` | Th_coqc | definition |
| CAN-149 | relational-class-position | `RelationalClassPosition` (Record, 7 fields), `CAN_149_mk_relational_class_position` | Definition | definition |
| CAN-150 | pe-to-human-bridge | `CAN_150_pe_to_human_bridge` | Definition | definition |
| CAN-151 | human-systemic-position | `CAN_151_P_H_index`, `CAN_151_output_rise_not_position_rise` (= `MR_WorldSystem`) | Th_coqc | definition |
| CAN-152 | social-role-standing | `CAN_152_S_H_next`, `CAN_152_time_budget_valid`; `CAN_152_time_budget_satisfiable` | Th_coqc | definition/identity |
| CAN-153 | social-reproduction | `CAN_153_H_cap_next`; `CAN_153_Open_dynamic_sign` (Open, un-proved); `CAN_153_productive_not_social_necessity_witness` (= generic) | Th_coqc + Open | definition/hypothesis-Open (dynamic sign explicitly left open) |
| CAN-154 | power-channels | `PowerVector`, `CAN_154_mk_power_vector`; `CAN_154_Open_not_predetermined` (Open, un-proved); `CAN_154_channel_noncollapse_witness` (= generic) | Th_coqc + Open | definition/hypothesis-Open |
| CAN-155 | early-warning-diagnostic | `CAN_155_Omega` | Definition | measurement |
| CAN-156 | after-labour-river-summary | `AfterLabourRiverStage` (Inductive, 22 ctors), `CAN_156_after_labour_river_next` | Definition | definition |
| CAN-157 | corrigible-agency-worldsystem | `CAN_157_corrigible_agency_ws`, `CAN_157_corrigible_agency_ws_upper_bound` (= `MR_WorldSystem`) | Th_coqc | definition |
| CAN-158 | human-return-worldsystem | `CAN_158_ReturnProfileWS`, `CAN_158_mk_return_profile_ws` (= `MR_WorldSystem`) | Definition | definition |
| CAN-159 | human-conversion-vector | `CAN_159_machine_expansion_not_human_expansion`, `CAN_159_HumanConversionVector`, `CAN_159_mk_human_conversion_vector`, `CAN_159_eta_HC` (= `MR_WorldSystem`) | Th_coqc | definition (elasticities/thresholds require per-study declaration) |
| CAN-160 | conversion-noncollapse-bundle | `CAN_160_separation`; `CAN_160_all_separations_satisfiable` (= generic, ∀-quantified) | Th_coqc | definition |
| CAN-161 | epistemic-conversion-mechanism | `HighConversionStage`/`CAN_161_high_conversion_next`, `LowConversionStage`/`CAN_161_low_conversion_next`; `CAN_161_Open_proposition2_max_assistance_max_conversion` (Open, un-proved) | Definition + Open | definition/hypothesis-Open (Proposition 2 Open) |
| CAN-162 | bad-mode-state | `BadModeState` (Record, 9 fields), `CAN_162_mk_bad_mode_state` | Definition | definition |
| CAN-163 | reversibility-window-urgency | `CAN_163_reversibility_window`, `CAN_163_in_reversibility_window`, `CAN_163_urgency_term` (= `MR_WorldSystem`); `CAN_163_Open_reversibility_principle` (Open, un-proved) | Definition + Open | definition (Reversibility Principle itself [Open]) |
| CAN-164 | distributional-conversion | `CAN_164_I_H`; `CAN_164_Open_proposition4_broad_expansion` (Open, un-proved) | Definition + Open | definition (Proposition 4 Open) |

## Summary

- **25 / 25** CAN ids formalised, one primary Coq identifier per id (a
  `Definition`/`Record`/`Inductive`, per `family_world-system-reading.json`'s
  member list), each carrying the required
  `(* CAN-nnn — root: ... — domain: world-system — tier: T — occurrences: n *)`
  comment. **0 could not be formalised.**
- Tier split, counted directly from the `tier:` field of each CAN id's own
  one-line comment tag (`grep -oE` + tally, not hand-counted): **12
  Th_coqc** (CAN-144, 145, 146, 147, 148, 151, 152, 153, 154, 157, 159,
  160 — a proved identity/bound/witnessed-non-collapse is this id's own
  headline content), **13 Definition** (CAN-140, 141, 142, 143, 149, 150,
  155, 156, 158, 161, 162, 163, 164). 12 + 13 = 25. Five ids additionally
  carry a smaller Open *sub*-component typed alongside their main content
  and left deliberately un-proved (CAN-153's dynamic-sign law, CAN-154's
  not-predetermined institutional path, CAN-161's Proposition 2,
  CAN-163's Reversibility Principle itself, CAN-164's Proposition 4) — the
  one-line tag reflects each id's dominant, proof-obligation-bearing
  content, per the same convention `MRC_human_ai_reading_a/b.v` uses.
- **9** ids alias an identifier from the already-compiled
  `../coq/MR_WorldSystem.v` module rather than redefining it (CAN-143,
  144, 151, 157, 158, 159, 163 for numbered equations; CAN-142, and the
  `ddiff`-based generic witness behind CAN-146/147/148/153/154/160, for
  shared scaffolding) — see the reuse table above. **18** ids' primary
  content (beyond any shared scaffolding) is freshly formalised.
- **13** `Print Assumptions` checks were run via a scratch file
  `Require`-ing `MRC.MRC_world_system_reading` and calling
  `Print Assumptions` on the shared generic witness, every `Theorem` this
  pass itself proves (`CAN_142_B_RB_identity`, `CAN_144_convex_combine_identity`
  [and, via it, the aliased `CAN_144_citizen_claim_threshold_identity`],
  `CAN_145_chi_dem_le_one`, `CAN_146_redistribution_not_ownership_reproduction`,
  `CAN_147_abundance_not_low_burden_not_freedom`,
  `CAN_148_concentration_not_dependency`, `CAN_152_time_budget_satisfiable`,
  `CAN_160_all_separations_satisfiable`), and every identifier aliased
  from `MR_WorldSystem.v` that is itself a proved theorem
  (`CAN_151_output_rise_not_position_rise`,
  `CAN_157_corrigible_agency_ws_upper_bound`,
  `CAN_159_machine_expansion_not_human_expansion`): **all 13 report
  "Closed under the global context"** — zero axioms, zero admitted
  lemmas, in the entire reused-plus-fresh proof graph for this family.
- `grep -nE "Admitted|^Axiom|^Parameter"` on the file: the only two
  matches are inside the discipline-statement comment in the file's own
  header (naming these forbidden constructs, never using them). No
  `Admitted`, no top-level `Axiom`/`Parameter` anywhere in the module.
  `grep -nE "Coq\.Reals|Classical"` likewise matches only the header
  prose explaining what is *not* used.
- `coqc -Q coq_canon MRC -Q coq MR coq_canon/MRC_world_system_reading.v`
  compiles clean (exit 0, zero warnings) under Coq 8.20.1.
- No `Coq.Reals`, no classical axioms, no functional extensionality.
  Every numeric object lives on `Q` (stocks, shares, rates, weights,
  indices) or `nat` (exponents, stage indices, time steps); every finite
  enumeration (`LabourClaimStage`, `AfterLabourRiverStage`,
  `HighConversionStage`, `LowConversionStage`) is a closed `Inductive`,
  never an open-ended classifier. Discrete replacements recorded in-line
  at each site (summarised in the file's own header): every continuum
  time-derivative (`Ż`, `Ḃ`, `Ṡ`, `Ḣ`, `İ`) is a one-step `Q`-valued
  finite difference, never an `h → 0` limit; CAN-142's Cobb-Douglas-style
  index and CAN-142's labour-share exponents use declared `nat` exponents
  via `MR_WorldSystem.Qpow_nat`, never a continuum real exponent (the CES
  elasticity `ρ` itself is kept as an uninterpreted `Q` ratio and is
  never used as a fractional power); CAN-142's growth-decomposition
  identity (`Ḃ/B = Ṅ/N + q̇/q`) is a continuum log-derivative product rule
  with no exact discrete counterpart and is recorded only in prose, never
  asserted as a Coq theorem (a refused non-readout, not a silently
  completed approximation); CAN-155's early-warning diagnostic is a
  finite `list`-fold weighted sum, never a continuum integral; every "A ≠
  B"/"A ⇏ B" claim (CAN-146, 147, 148, 153, 154, 160) is a **witnessed**
  non-collapse on a small finite/`Q` model, never a universal claim that
  the two named notions always differ.
- No `MRC_master.v` produced by this pass — see "Reuse" section header
  above for why (this family reads the spine; it is not root-spine).

Could not formalise: **none**. All 25 CAN ids in
`family_world-system-reading.json` have exactly one tagged Coq identifier
in `MRC_world_system_reading.v`.
