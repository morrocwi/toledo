# LEDGER — family "social-reading"

Coq 8.20.1. Build/verify command used throughout (RAM discipline: one file
at a time, never parallel `coqc`):

```sh
cd research/society-justice-peace/master-river
coqc -Q coq_canon MRC -Q coq MR coq_canon/MRC_social_reading.v
```

Compiled clean: **zero errors, zero warnings**. All 25 ids fit in a single
file (no `_a`/`_b` split needed — comparable in size to
`MRC_epistemic_reading.v`, 49 ids in one file).

Family assignment record: `../registry/family_social-reading.json`.
Assignment method: `domain: "social"` in `../registry/CANONICAL.json` (25
ids, `CAN-115`..`CAN-139`, verbatim from `../registry/COLLAPSE.md`
§"Social domain (25 ids)"). This family is **not** root-spine (the nine
`domain: "root"` spine_ids are family `root-spine`,
`coq_canon/MRC_root_spine.v`/`MRC_master.v`, produced by a different pass)
— per COLLAPSE.md §2, the social reading (CAN-115 B-SOC-LRSTEPPER) "reads
CAN-001 directly and by the same symbol", and CAN-117 (regime translation
operator T_R) "reads CAN-003". Because this family reads the spine rather
than adding to it, **no `MRC_master.v` is produced by this pass** — the
master-equation composition and the `DomainReading`/`weld_holds` apparatus
belong to the root-spine family's own file.

## Reuse of `../coq/MR_*.v`

Of the 25 ids, exactly **three** carry a non-null `in_master_river` field
in CANONICAL.json — CAN-128 (eq.19-24), CAN-132 (eq.25), CAN-134 (eq.26) —
all already formalised, axiom-free, in `../coq/MR_Live.v`. These three are
discharged by `Require Import`-ing `MR.MR_Live` and aliasing its
identifiers under the CAN id, never redefining them.

A fourth id, **CAN-124**, cites the identical `eq.(26)` text
(`L^live_{A,g}=max_{z in J_feas} D_L(L^z_A(g), L^{z0}_A(g))`) in its own
`canonical_source` prose, but its `in_master_river` field in
CANONICAL.json is `null` — **a registry drift, disclosed here, not
silently resolved**: CANONICAL.json's own `in_master_river` bookkeeping
for CAN-124 does not match its own `canonical_source` prose. Since
CAN-124's `canonical_text` is symbol-identical to CAN-134's, it is
aliased to the same already-compiled `MR_Live.live_field_gap` rather than
re-derived, exactly as CAN-134 is.

The remaining **21** ids are standalone (their own `canonical_source`
cites a record id, not a Master River eq. number: Violence as a Special
Case of Instability 18383439, Potential as a Readout 22361830, Causal
Ethics 18444260, Causal Agency 18897585, Readout Genesis Standalone
Synthesis 21529456, From Problem to Hypothesis 22307148, Before Meaning
Before Choice 22424434, How Humans Should Converse with AI 22481928,
Operational Linguistic Wisdom 22456487, Choice Begins Before Choice
22357788) and are freshly formalised in this pass, in the same
Section+Variables/Hypotheses, Q/nat/bool/list/Inductive,
no-Reals/no-classical/no-Admitted/no-top-level-Axiom-or-Parameter
discipline as every other file in this repository.

| CAN id → `MR_*.v` module reused |
|---|
| CAN-124, CAN-128, CAN-132, CAN-134 → `MR_Live` |

## `MRC_social_reading.v` — CAN-115..CAN-139 (25 ids)

| CAN id | key | Coq identifier(s) | tier (this file) | tier (CANONICAL.json's own words) |
|---|---|---|---|---|
| CAN-115 | B-SOC-LRSTEPPER | `CAN_115_degree`, `CAN_115_L_R`, `CAN_115_A`, `CAN_115_step`; `CAN_115_par_stepper_moves_state` (Th_coqc witness); `CAN_115_L1_invariance_recurrence`..`CAN_115_L4_mutation` (abstract `Prop` Variables, un-proved) | Definition (PAR-stepper, + Th_coqc witness) / Open (L1-L4) | definition (PAR-stepper); theorem [paper-internal, not Coq-verified] (L1-L4) |
| CAN-116 | B-SOC-ETHAXIOM | `CAN_116_ManifestedRecord`, `CAN_116_is_agency`, `CAN_116_is_collective`; `CAN_116_axioms_satisfiable` | Definition + Th_coqc witness | axiom |
| CAN-117 | B-SOC-REGIME | `CAN_117_Regime` (Record), `CAN_117_record_updates`, `CAN_117_agency_updates`, `CAN_117_Etic`; `CAN_117_etic_satisfiable` | Definition + Th_coqc witness | axiom (CE-05); law/update-law (CE-06,07); definition (CE-08) |
| CAN-118 | B-SOC-ETHLOAD | `CAN_118_non_increasing`, `CAN_118_Ethical`; `CAN_118_ethical_satisfiable` | Definition + Th_coqc witness | definition (author-labelled 'final'/locked) |
| CAN-119 | B-SOC-COLCONF | `CAN_119_min_margin`, `CAN_119_Eth_col`, `CAN_119_Conf_ind_to_col`, `CAN_119_Conf_col_to_ind`, `CAN_119_structural_injustice`; `CAN_119_structural_injustice_satisfiable` | Definition + Th_coqc witness | definition |
| CAN-120 | B-SOC-MORALCOST | `CAN_120_moral_cost`, `CAN_120_Responsibility`, `CAN_120_choice_gate`, `CAN_120_Tragic`; `CAN_120_choice_gate_satisfiable`, `CAN_120_tragic_satisfiable`; `CAN_120_cost_survival_link` (abstract `Prop`, un-proved) | Definition + Th_coqc witnesses (CE-25..31,33,34, gate, Tragic) / Open (CE-32) | definition (...); theorem [paper-internal, not Coq-verified] (CE-32) |
| CAN-121 | B-SOC-AGENCYHIER | `CAN_121_ProtoAgency`, `CAN_121_StateConstraintCoupling`, `CAN_121_L3_history`, `CAN_121_L4_predictive`, `CAN_121_L5_meta`; `CAN_121_hierarchy_levels_satisfiable` | Definition + Th_coqc witness | definition |
| CAN-122 | belief-relation | `CAN_122_BeliefVector` (Record, 7 `Q` fields), `CAN_122_Bel`, `CAN_122_update`, `CAN_122_group_belief`, `CAN_122_sigma_K`; `CAN_122_belief_scale_nonpromotion` | Definition + Th_coqc (proved) | definition / proposition (with proof) |
| CAN-123 | collective-readout | `CAN_123_GroupState` (Record), `CAN_123_group_readout`, `CAN_123_memory_update`; `CAN_123_memory_update_zero_signal` | Definition + Th_coqc | definition |
| CAN-124 | power-live-gap | `CAN_124_power_live_gap` (= `MR_Live.live_field_gap`, aliased) | Th_coqc (reused) | proposition |
| CAN-125 | DCP-relational-route | `CAN_125_DCPStage` (Inductive, 5 ctors), `CAN_125_index`; `CAN_125_index_injective`, `CAN_125_route_is_strictly_ordered` | Th_coqc | definition |
| CAN-126 | OLW-falsifier | `CAN_126_falsifier_condition` (abstract `Prop`, un-proved) | Open | hypothesis/Open |
| CAN-127 | OLW-propositions | `CAN_127_OLWProposition` (Inductive, 8 ctors), `CAN_127_holds` (abstract, Section-discharged) | Open | hypothesis/Open |
| CAN-128 | B-SOC-LIVEPOSS | `CAN_128_Pi_live`, `CAN_128_live_field`, `CAN_128_is_valid_choice`, `CAN_128_live_full_nesting`, `CAN_128_enactment_may_differ_from_choice`, `CAN_128_observation_loses_information`, `CAN_128_six_level_non_collapse` (all = `MR_Live.*`, aliased) | Th_coqc (reused) | definition |
| CAN-129 | B-SOC-NCLIST | `CAN_129_NCItem` (Inductive, 17 ctors), `CAN_129_index`; `CAN_129_index_injective` | Th_coqc | definition |
| CAN-130 | B-SOC-MEANPROP | `CAN_130_MeanPropItem` (Inductive, 5 ctors), `CAN_130_holds` (abstract, Section-discharged) | Open | proposition |
| CAN-131 | B-SOC-LIVEHYP | `CAN_131_LiveHyp` (Inductive, 8 ctors), `CAN_131_holds` (abstract, Section-discharged) | Open | hypothesis/Open |
| CAN-132 | B-SOC-POTENTIAL | `CAN_132_p_star`, `CAN_132_p_star_upper_bound` (= `MR_Live.*`, aliased) | Th_coqc (reused) | definition |
| CAN-133 | B-SOC-RECOVENV | `CAN_133_p_star2`, `CAN_133_recoverable_gap`; `CAN_133_recoverable_gap_nonneg` | Th_coqc | definition |
| CAN-134 | B-SOC-RECOVLIVE | `CAN_134_live_field_gap` (= `MR_Live.live_field_gap`, aliased); `CAN_134_gap_nonneg` (fresh Th_coqc) | Th_coqc (reused + fresh witness) | definition |
| CAN-135 | B-SOC-CORRIG | `CAN_135_Channel` (Inductive), `CAN_135_corrigible`; `CAN_135_corrigible_satisfiable` | Th_coqc | definition |
| CAN-136 | B-SOC-PSEUDOPEACE | `CAN_136_Observation`, `CAN_136_ChannelStatus` (Inductive), `CAN_136_pseudo_peace_signature`; `CAN_136_pseudo_peace_satisfiable`; `CAN_136_P_A_falsification_test` (abstract `Prop`, un-proved) | Definition + Th_coqc witness / Open (P-A) | definition; falsifiable proposition P-A [Open] |
| CAN-137 | B-SOC-SEVENDIST | `CAN_137_Distinction` (Inductive, 7 ctors), `CAN_137_index`; `CAN_137_index_injective` | Th_coqc | definition |
| CAN-138 | B-SOC-FALSIF | `CAN_138_Falsif` (Inductive, 3 ctors), `CAN_138_holds` (abstract, Section-discharged) | Open | hypothesis/Open |
| CAN-139 | B-SOC-IDCERT | `CAN_139_identifiability_certificate` | Th_coqc (fully computed on `Q`) | measurement |

Total identifiers carrying a `(* CAN-nnn — ... *)` tag: **25** (one per CAN
id, as required — none upgraded past what its own proof/typing earns; the
five ids CANONICAL.json itself tags `hypothesis/Open` (CAN-126, 127, 130,
131, 138) and the two `theorem [paper-internal, not Coq-verified]`
components (CAN-115's L1-L4, CAN-120's CE-32 Cost-Survival Link) are all
typed as abstract, Section-discharged `Prop`-valued `Variable`s or
`Definition`s and deliberately left un-proved — no `Lemma`/`Theorem`, no
`Admitted` — per the house rule "never upgrade (Open -> Prop, no proof)").

## `Print Assumptions` — every proof obligation

26 `Print Assumptions` checks were run via a scratch file
(`Require Import MRC.MRC_social_reading.` then one `Print Assumptions`
per identifier — 19 freshly proved in this file plus 7 reused aliases
re-verified through the alias): **all 26 report "Closed under the global
context"** — zero axioms, zero unresolved `Admitted`s, in either this
file or the `MR_Live.v` module it reuses.

```
Print Assumptions CAN_115_par_stepper_moves_state.        Closed under the global context
Print Assumptions CAN_116_axioms_satisfiable.              Closed under the global context
Print Assumptions CAN_117_etic_satisfiable.                Closed under the global context
Print Assumptions CAN_118_ethical_satisfiable.              Closed under the global context
Print Assumptions CAN_119_structural_injustice_satisfiable. Closed under the global context
Print Assumptions CAN_120_choice_gate_satisfiable.          Closed under the global context
Print Assumptions CAN_120_tragic_satisfiable.               Closed under the global context
Print Assumptions CAN_121_hierarchy_levels_satisfiable.     Closed under the global context
Print Assumptions CAN_122_belief_scale_nonpromotion.        Closed under the global context
Print Assumptions CAN_123_memory_update_zero_signal.        Closed under the global context
Print Assumptions CAN_125_index_injective.                  Closed under the global context
Print Assumptions CAN_125_route_is_strictly_ordered.        Closed under the global context
Print Assumptions CAN_129_index_injective.                  Closed under the global context
Print Assumptions CAN_133_recoverable_gap_nonneg.           Closed under the global context
Print Assumptions CAN_134_gap_nonneg.                       Closed under the global context
Print Assumptions CAN_135_corrigible_satisfiable.           Closed under the global context
Print Assumptions CAN_136_pseudo_peace_satisfiable.         Closed under the global context
Print Assumptions CAN_137_index_injective.                  Closed under the global context
Print Assumptions CAN_139_identifiability_certificate.      Closed under the global context
Print Assumptions CAN_124_power_live_gap.                   Closed under the global context
Print Assumptions CAN_128_live_full_nesting.                Closed under the global context
Print Assumptions CAN_128_enactment_may_differ_from_choice. Closed under the global context
Print Assumptions CAN_128_observation_loses_information.    Closed under the global context
Print Assumptions CAN_128_six_level_non_collapse.           Closed under the global context
Print Assumptions CAN_132_p_star_upper_bound.               Closed under the global context
Print Assumptions CAN_134_live_field_gap.                   Closed under the global context
```

## Notable modelling decisions (disclosed, not hidden)

- **CAN-115 (PAR-stepper)**: `A := L_R + Γ` and the Euler-step recurrence
  `s[n+1]=s[n]+dt(-A s[n]+J)` are typed on a finite `list nat` vertex set
  and `Q`-valued weights/rates, exactly `MRC_root_spine.v`'s `CAN-001`
  graph-Laplacian construction specialised with its own identifiers (a
  domain reading, not a re-export of `CAN_001_*`). The paper's own L1-L4
  lemmas and the earlier No-Go Theorem (record 18383439) are about
  infinite-horizon/fixed-point behaviour of a continuum-flavoured
  dynamical system; typing them as machine-checked Coq theorems on this
  finite model would require restating them as different (weaker or
  differently-scoped) claims than the paper's own, so per the house rule
  they are left as abstract Section-discharged `Prop` Variables — Open,
  not silently reinterpreted into something narrower and then "proved".
- **CAN-116/117 (Causal Ethics axioms/regime)**: "manifested record" is
  modelled as a finite `list Event` and "agency as sub-structure" as list
  inclusion (`incl`) — a genuinely finite, decidable discrete replacement
  for an otherwise-abstract "subset of reality" relation.
- **CAN-119's "structural injustice" (`≫`, "grossly greater")**: discretely
  replaced as "strictly greater by at least a declared positive margin
  `eps`", never an informal "much greater than".
- **CAN-120's moral-cost integral** `∫_{t1}^{t2}(...)dt'` is a finite
  `fold_right Qplus` over `List.seq t1 (t2-t1)` — a genuine finite sum,
  never a continuum integral.
- **CAN-121's Level 5 meta-regulation** (`G_{t+1}=M(G_t)`) is witnessed on
  a `bool`/`bool` model where `M` flips the rule's own output — the
  cleanest possible non-trivial instance of "a stepper applied to the
  stepper's own generating rule, one level up" (q_D∘F at the next order).
- **CAN-124/CAN-134 symbol collision, and CAN-118/CAN-135's `Δ_spec`
  collision**: both disclosed per CANONICAL.json's own notes rather than
  silently merged or silently kept ambiguous — CAN-124 is aliased to
  CAN-134's already-proved object (registry drift noted above); CAN-118's
  `Delta_spec` (spectral stability margin, Causal Ethics) and CAN-135's
  `Delta_spec`/`Δspec` (corrigibility/repair-channel condition, Potential
  as a Readout) are kept as two independent Coq objects
  (`CAN_118_EthLoad`'s `Delta_spec : Q` Variable vs. `CAN_135_corrigible`'s
  `channel`/`repair_rate`-based Prop) — same source symbol, different
  papers, never unified.
- **CAN-139 (identifiability certificate)** is the one id in this family
  proved by direct rational-arithmetic computation (`lra` on `Q`
  literals) rather than by a Section/Variable witness pattern — the
  paper's own worked numeric example translates verbatim into an exactly
  checkable Coq fact.

## Could not formalise as a further-upgraded claim (honest list)

None of the 25 ids were left out of the file entirely — every CAN id in
this family has at least a `Definition`-tier Coq identifier carrying its
required tag comment. The following components are present only as
**Open** (abstract, un-proved `Prop`), matching CANONICAL.json's own
"hypothesis/Open" or "theorem [paper-internal, not Coq-verified]" tier,
and are the honest boundary of what this pass formalises further:

- CAN-115's L1 (invariance/recurrence), L2 (the bill), L3 (operator
  change), L4 (mutation) — paper-internal theorems (record 22361830 /
  18383439), not independently machine-checked.
- CAN-120's CE-32 Cost-Survival Link — a continuum/infinite-limit
  theorem, not independently machine-checked and not restated on a
  discrete carrier here.
- CAN-126 (OLW-falsifier), CAN-127 (OLW-propositions P1-P8), CAN-130
  (B-SOC-MEANPROP P1-P5), CAN-131 (B-SOC-LIVEHYP H1-H8), CAN-138
  (B-SOC-FALSIF P-B/P-C/P-D) — CANONICAL.json's own `hypothesis/Open` or
  prose-proposition tier; each typed as an enumeration plus an abstract
  Section-discharged holds-predicate, never asserted true, false, or
  proved.
- CAN-136's P-A falsification test — CANONICAL.json's own
  `hypothesis/Open` component of an otherwise-Definition-tier id.

No CAN id was skipped outright.
