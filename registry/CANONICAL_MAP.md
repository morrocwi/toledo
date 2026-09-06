# Master Equation River — Canonical Mapping (CANONICAL_MAP.md)

Reconciled from three cluster sets into **253 canonical objects** covering all **946 raw equations** across 40 chapters (`registry/eq_<record_id>.json`). Ordering: root objects first, then domain readings in river order (epistemic → human–AI → social → world-system → method).

_2026-09-06 dedup-review pass: CAN-018 merged into CAN-017 (under-merge fix); CAN-010, CAN-011, CAN-038, and CAN-176 were split per BBL-170 rule 5 (over-merges bundling distinct objects/papers under one id); CAN-039's tier text now discloses its bundled Open/rejected sub-claim. New ids were appended (CAN-201…) rather than renumbering the existing CAN-001…CAN-200 range, to avoid disturbing stable references; see each new/changed entry's own notes for what collapsed into what._

## Counts

- Coq identifiers: 253/253 canonical ids tagged in `coq_canon/LEDGER_*.md` + `coq/MR_Ledger.md` (see each entry's new **Coq:** line; full detail in `registry/CANONICAL_REGISTRY.json`)
- Raw equations: 946
- Canonical objects: 253
- By domain: root=11, epistemic=49, human–AI=74, social=25, world-system=25, method=69
- By tier bucket (normalized for counting only — each entry's exact source tier text is preserved in CANONICAL.json): Th_coqc=1, definition=109, law/non-collapse/identity=63, hypothesis/Open=30, measurement=10, axiom=3, proposition/theorem=18, Dr=2, governance/finite_diagnostic=17

---

## Part 1 — Per canonical id (CAN-001 … CAN-256)

### Domain: root

#### CAN-001 — root-weld
- **Object:** Root weld: retained distinction forces the graph-Laplacian and the context-sensitive stepper (δ_R ⊢ L_R ⊢ F)
- **Root object:** δ_R ⊢ L_R ⊢ F-stepper
- **Tier:** Th_coqc (δ_R⊢L_R only) / Dr (F stepper) / theorem-in-source (MQ.08, Th-5, both explicitly 'forced not chosen' within their own chapter, not independently machine-checked here)
- **Coq:** `CAN_001_degree`, `CAN_001_laplacian`; `CAN_001_sum_neg_distributes`, `CAN_001_laplacian_row_sums_to_neg_degree`; `CAN_001_F` (Variable); `CAN_001_laplacian_stepper_can_move_state` — coq tier: Th_coqc (δ_R⊢L_R half, proved) / Definition + Th_coqc witness (L_R⊢F half — "Dr" in source, not re-derived here) — `coq_canon/MRC_root_spine.v` — assumptions: Closed under the global context (×3)
- **Canonical source:** READOUT_GENESIS_CORE.md 'THE ONE-LINE MASTER EQUATION' + Part I (E00.5–E00.7); Readout Genesis Standalone Synthesis eq.(1),(3),(4),(5) [record 21529456] as the deposited form; Mind as Information Horizon P3, MQ.08, Th-5 [record 19640361] as an independently-named corroborating chapter
- **Notes:** This is THE root spine per BBL-170 rule 1: everything else in group A is a reading of this weld through some domain's q_D. Two independent chapters (21529456, 19640361) state the same weld in different notation — same object, not two objects, per the no-notation-clustering rule. Not restated verbatim in Master River v1.4 (v1.4 cites rg_synthesis only conceptually).
- **Occurrences (7):**
  - `21529456:(1)` — Readout Genesis Standalone Synthesis
  - `21529456:(3)` — Readout Genesis Standalone Synthesis
  - `21529456:(4)` — Readout Genesis Standalone Synthesis
  - `21529456:(5)` — Readout Genesis Standalone Synthesis
  - `19640361:P3` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph
  - `19640361:MQ.08` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph
  - `19640361:Th-5` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph

#### CAN-002 — root-state-tuple
- **Object:** retained root state S_n=(G_n,Λ_n,T_n)
- **Root object:** F-stepper
- **Tier:** definition
- **Coq:** `RootState` (Record); `CAN_002_root_state_tuple_faithful` — coq tier: Definition + Th_coqc witness — `coq_canon/MRC_root_spine.v` — assumptions: Closed under the global context
- **Canonical source:** From Assistance to Human Capability (RG-HCA, 2026-09-06) eq.(1); identical wording in Before Meaning, Before Choice eq.(3)
- **Occurrences (2):**
  - `22498047:(1)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22424434:(3)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-003 — root-stepper
- **Object:** root transition S_{n+1}=F(S_n,u_n,c_n,T_n)
- **Root object:** F-stepper
- **Tier:** Dr
- **Coq:** `CAN_003_F` (Variable); `CAN_003_trajectory`; `CAN_003_stepper_can_move_state`, `CAN_003_trajectory_zero` — coq tier: Definition + Th_coqc witness — `coq_canon/MRC_root_spine.v` — assumptions: Closed under the global context (×2)
- **Canonical source:** READOUT_GENESIS_CORE.md, one-line master equation (MQ.08 stepper); quoted by RG-HCA eq.(2) and Before Meaning, Before Choice eq.(4)
- **Occurrences (2):**
  - `22498047:(2)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22424434:(4)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-004 — constitutional-ordering
- **Object:** Constitutional ordering of epistemic terms
- **Root object:** F-stepper
- **Tier:** law (constitutional ordering rule)
- **Coq:** `CAN_004_Stage` (Inductive, 12 constructors); `CAN_004_index`; `CAN_004_forbidden_order`; `CAN_004_index_injective`, `CAN_004_checking_before_status_before_report` — coq tier: Definition + Th_coqc (×2) — `coq_canon/MRC_root_spine.v` — assumptions: Closed under the global context (×2)
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(9) [record 21529456]; parallels READOUT_GENESIS_CORE.md Part I.2 Root-to-Trunk Progression
- **Relations:** relates-to → CAN-017; relates-to → CAN-031; relates-to → CAN-023; relates-to → CAN-019; relates-to → CAN-013; relates-to → CAN-021; relates-to → CAN-015
- **Notes:** This is the master spine that every later cluster in this whole group (meaning-giving, experience-equation, retention-update, naming-operator, resonance, knowledge-admission…) instantiates one stage of, in order.
- **Occurrences (1):**
  - `21529456:(9)` — Readout Genesis Standalone Synthesis

#### CAN-005 — readout-admission-order
- **Object:** readout-native admission order for semantic categories
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN_005_readout_admission_order` (alias of `CAN_004_index`); `CAN_005_readout_admission_order_stage` (alias of `CAN_004_Stage`) — coq tier: Definition (both aliases — no new proof obligation, reuse-not-redefine, in the CAN-143/CAN-144 alias style) — `coq_canon/MRC_root_spine.v` — assumptions: (no new proof obligation to check — `CAN_004_index_injective`/`CAN_004_checking_before_status_before_report` already cover the underlying object, Closed under the global context)
- **Canonical source:** Before Meaning, Before Choice (2026-09-06) eq.(1)-(2),(49)-(50)
- **Notes:** Directly instances Genesis's Part I.2 Root-to-Trunk Progression (Retention→Structure) applied to the semantic/human domain.
- **Occurrences (4):**
  - `22424434:(1)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(2)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(49)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(50)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-006 — domain-weld
- **Object:** Domain admissibility: a translation q_D commutes with the root dynamics and readout
- **Root object:** domain weld q_D
- **Tier:** definition (admissibility condition)
- **Coq:** `CAN_006_domain_admissible`; `CAN_006_domain_weld_satisfiable_on_pair_projection` — coq tier: Definition + Th_coqc witness — `coq_canon/MRC_root_spine.v` — assumptions: Closed under the global context
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(2),(6),(7) [record 21529456]; matches READOUT_GENESIS_CORE.md's one-line weld's own commuting-square clause
- **Merged from:** domain-weld (group 3)
- **Relations:** relates-to → CAN-001
- **Notes:** Distinct from the root-weld object itself (rule 5): this is the CONDITION a domain must satisfy to be admitted, not the root or a domain reading. Every other cluster below that instantiates a specific q_D (human, epistemic, social, agentic…) is downstream of this condition. [MERGER: combined with the human-AI-scale 'domain-weld' cluster (HCA/MEMK instance) from the third cluster set — same general weld condition q_{D,n+1}∘F_n=F#_{D,n}∘q_{D,n}, occurrences in records 22498047/22424434 added as domain instances of the same root condition.]
- **Occurrences (5):**
  - `21529456:(2)` — Readout Genesis Standalone Synthesis
  - `21529456:(6)` — Readout Genesis Standalone Synthesis
  - `21529456:(7)` — Readout Genesis Standalone Synthesis
  - `22498047:(3)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22424434:(6)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-007 — reader-equivalence
- **Object:** No-early-collapse: two states are equivalent only relative to a declared question/reader/context/horizon
- **Root object:** domain weld q_D
- **Tier:** definition
- **Coq:** `CAN_007_reader_equiv`; `CAN_007_reader_equiv_is_equivalence` — coq tier: Definition + Th_coqc (equivalence-relation proof) — `coq_canon/MRC_root_spine.v` — assumptions: Closed under the global context
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(8) [record 21529456]
- **Relations:** relates-to → CAN-031; relates-to → CAN-034
- **Notes:** Relates to state-sufficiency/invariant-preservation cluster below (same no-early-merge discipline applied specifically to knowledge-domain quotients) and to reader-equivalence instances re-derived independently in From Problem to Hypothesis (x ~_{O_D} y) — see reader-equivalence-epistemic cross-reference inside knowledge-admission notes.
- **Occurrences (2):**
  - `21529456:(8)` — Readout Genesis Standalone Synthesis
  - `22307148:(8)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space

#### CAN-008 — constitutional-noncollapse
- **Object:** root state ≠ candidate domain representation ≠ discovered quotient
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `CAN_008_noncollapse`; `CAN_008_root_candidate_quotient_are_three_things` — coq tier: Definition + Th_coqc witness — `coq_canon/MRC_root_spine.v` — assumptions: Closed under the global context
- **Canonical source:** RG-HCA (2026-09-06) eq.(4); Before Meaning, Before Choice eq.(5)
- **Occurrences (2):**
  - `22498047:(4)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22424434:(5)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-009 — historical-invariance
- **Object:** The historical occurrence itself is not rewritten by later reinterpretation
- **Root object:** decisive record
- **Tier:** law (invariant)
- **Coq:** `CAN_009_extends`; `CAN_009_extension_preserves_past`, `CAN_009_witness_append_preserves_first_event` — coq tier: Definition + Th_coqc (×2) — `coq_canon/MRC_root_spine.v` — assumptions: Closed under the global context (×2)
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(16) [record 21529456]
- **Relations:** relates-to → CAN-023
- **Notes:** Singleton but load-bearing: this is what makes 'decisive record' decisive rather than revisable, and grounds the retention-update cluster's own honesty (retention updates the reader's bindings, never the recorded past).
- **Occurrences (1):**
  - `21529456:(16)` — Readout Genesis Standalone Synthesis

#### CAN-201 — root-readout-gate
- **Object:** The root readout gate itself: a bounded, reader/operator-conditioned map that never returns the source unchanged
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN_201_readout` (Variable) + `CAN_201_readout_ne_state` (Hypothesis); `CAN_201_hypothesis_satisfiable_on_bool` — coq tier: Definition + Th_coqc witness — `coq_canon/MRC_root_spine.v` — assumptions: Closed under the global context
- **Canonical source:** READOUT_GENESIS_CORE.md readout gate R_{Q,O,c}(S)=z≠S; independently restated verbatim in After Labour eq.(2) [record 22481924]
- **Relations:** relates-to → CAN-001; relates-to → CAN-010
- **Notes:** [MERGER dedup-fix: split out of the former CAN-010 'readout-operator' over-merge — that cluster's root_object field described this literal root readout gate as already 'read through the human/epistemic domain', which folds the root itself into a domain reading, contradicting rule 1. This entry restores it to domain='root' alongside CAN-001/002/003/006.]
- **Occurrences (1):**
  - `22481924:(2)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-222 — root-non-collapse-chain
- **Object:** Readout Genesis's own root-level chain of typed non-collapses
- **Root object:** non-collapse
- **Tier:** law (non-collapse); the closing instance (85) is further qualified by the source as 'no-free-governance'
- **Coq:** `CAN_222_root_non_collapse_chain` (alias of `CAN_008_noncollapse`); `CAN_222_root_non_collapse_chain_witness` (alias of `CAN_008_root_candidate_quotient_are_three_things`) — coq tier: Definition + Th_coqc witness (both aliases — no new proof obligation, reuse-not-redefine, in the CAN-143/CAN-144 alias style) — `coq_canon/MRC_root_spine.v` — assumptions: Closed under the global context (alias of an already-closed identifier)
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(10),(12),(21),(24),(26),(35),(48),(70),(85) [record 21529456]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-038 'non-collapse-chain'): the former cluster pooled this paper's own non-collapse pairs together with seven other unrelated papers' non-collapse pairs under one id, keyed only by the shared relation-shape 'X≠Y', contradicting rule 1 (cluster by object+relation, not by relation-pattern alone) and rule 5. Dissolved into one bundled entry per source paper, in the same pattern CAN-137 (Seven Distinctions) and CAN-160 (ten separations) already use for a single paper's own taxonomy. The recurring observation that non-collapse (X≠Y, never silently merged) is a structural pattern across nearly this whole corpus is recorded here only as a cross-reference, not as a clustering key: see root-non-collapse-chain (CAN-201-adjacent), role-separation-principle, representationality-selectivity-noncollapse, affective-semantic-non-collapse-bundle, meaning-giving-non-collapse-bundle, human-lora-adaptation-non-collapse, hypothesis-space-non-collapse-bundle, discovery-topology-non-collapse-bundle.]
- **Occurrences (9):**
  - `21529456:(10)` — Readout Genesis Standalone Synthesis
  - `21529456:(12)` — Readout Genesis Standalone Synthesis
  - `21529456:(21)` — Readout Genesis Standalone Synthesis
  - `21529456:(24)` — Readout Genesis Standalone Synthesis
  - `21529456:(26)` — Readout Genesis Standalone Synthesis
  - `21529456:(35)` — Readout Genesis Standalone Synthesis
  - `21529456:(48)` — Readout Genesis Standalone Synthesis
  - `21529456:(70)` — Readout Genesis Standalone Synthesis
  - `21529456:(85)` — Readout Genesis Standalone Synthesis

### Domain: epistemic

#### CAN-010 — human-readout-instance
- **Object:** The human-domain instance of the readout operator: a subject's readout is conditioned on their history and context
- **Root object:** readout R
- **Tier:** definition; one bundled companion hypothesis explicitly flagged [Open] (22410666:H2, 'Reader dependence' — a guardrail ABOUT this readout instance, not itself established)
- **Coq:** `CAN010_human_readout_instance` (Section `CAN010_HumanReadoutInstance`); `CAN010_H2_reader_dependence_Open` — coq tier: Definition (+ Open H2) — `coq_canon/MRC_epistemic_reading.v` — assumptions: n/a (Definition; Open Prop not proved)
- **Master River v1.4 eq(s):** 1
- **Canonical source:** Meaning Before Naming (MBN-readout) [record 22410666]; Experience Is Meaning-Giving EMG-01 [record 22357744]; Before Meaning, Before Choice eq.(9) [record 22424434, Q_n-extended form]
- **Merged from:** readout-general (group 3), readout-human (group 3)
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge: the former 'readout-operator' cluster bundled at least 6 distinct mathematical objects sharing only the theme 'something readout-related' — the literal Genesis root readout gate, an Access(...) exposure function, an encoder pair, a raw sensor+windowing instrument, a domain taxonomy D_n, and the Mission-domain stepper reading M_A[n] — each now split into its own entry (root-readout-gate, access-exposure-function, encoder-pipeline, windowed-sensor-readout, domain-taxonomy-Dn, mission-stepper-reading, semantic-quotient-reading). This entry is trimmed to keep ONLY the human-domain readout instance r_n=R_H(x_n|H_n,c_n) restated verbatim across independent chapters — the clearest genuine 'one equation, many chapters' case per rule 1.]
- **Occurrences (4):**
  - `22410666:MBN-readout` — Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganization (Standalone Concept Note v1.0 FULL)
  - `22410666:H2` — Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganization (Standalone Concept Note v1.0 FULL)
  - `22357744:EMG-01` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22424434:(9)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-011 — source-provenance-readout
- **Object:** A source label is a readout, not an oracle: what an evaluator receives is itself operator-conditioned
- **Root object:** readout R
- **Tier:** definition / law (non-collapse, m≠ρ)
- **Coq:** `CAN011_R_A`; `CAN011_readout_not_world_witness`; `CAN011_Notion`/`CAN011_non_collapse` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Both theorems: Closed under the global context
- **Canonical source:** Written by AI. Still True., (RA), (m-rho) [record 22301202]; restated verbatim (inherited Readout-Universe notation) in Rigour Without Infrastructure, Sec.1 [record 22307841]
- **Merged from:** readout-lens (group 3)
- **Relations:** relates-to → CAN-165
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge: the former cluster bundled this literal repeated identity together with 15+ distinct named principles/definitions/propositions from two related but separate papers, violating rule 5. Trimmed to keep ONLY the R_A=O_A(W;Π_A)/m(A)≠ρ(A) identity, restated verbatim across 22301202 and 22307841 — the genuine rule-1 'one equation, many chapters' case. 22301202's five named principles (Bridge Burden, No Bare Pedigree, Provenance Relevance Constraint, Friction-not-magic, plus the Residual Provenance Effect diagnostic) are split into their own entries (bridge-burden-principle, no-bare-pedigree-principle, provenance-relevance-constraint, friction-not-magic-principle, residual-provenance-effect). 22301318's (The Readout Condition) much larger and more fully worked formal apparatus (governing maxim, distinction/path units, identification ladder, typed augmentation grammar, E-A-D norms, epistemic overreach/silent lift, essential-dependency defeater routing, two worked audits) is split into 9 further entries — none of these 14 new entries are the same object as this identity under renaming, per rule 5.]
- **Occurrences (3):**
  - `22301202:(RA)` — Written by AI. Still True.
  - `22301202:(m-rho)` — Written by AI. Still True.
  - `22307841:(unnumbered, Sec.1)` — Rigour Without Infrastructure: Three Propositions on Claim-Card Discipline as a Substitute for Institutional Certification

#### CAN-012 — observer-pipeline
- **Object:** The observer as a bounded selection–encoding–translation pipeline
- **Root object:** readout R
- **Tier:** definition (source manuscript's minimal observation pipeline)
- **Coq:** `CAN012_M_A` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: n/a
- **Canonical source:** Knowledge as Stabilized Translation eq.(1) [record 18925129]
- **Merged from:** B-SOC-CANONFORM (group 2)
- **Relations:** relates-to → CAN-010; relates-to → CAN-204
- **Notes:** Relates to readout-operator (a decomposition of the same object into stages) and to Genesis Constraint-First's O_A[n]=Π_A(E[n]) / enc_A(O_A)=T_A(O_A[n]) (same pipeline, split across two equations instead of one composite) — see CAN-204 encoder-pipeline. [MERGER: combined with 'B-SOC-CANONFORM' (Canonical Mediated-Account Formula, record 18943971) from the second cluster set — CROSS-GROUP DUPLICATE explicitly flagged in both source notes: 'M_A(E) = (T_A∘Π_A)(S_A(E))' is the identical formula in both 18925129 and 18943971.]
- **Occurrences (2):**
  - `18925129:(1)` — Knowledge as Stabilized Translation
  - `18943971:Canonical Formula` — The Civilization of Knowledge: Who Has the Authority to Interpret the World

#### CAN-013 — meaning-giving
- **Object:** Meaning-giving: a reader-conditioned significance relation, typed into affective/pragmatic/autobiographical/conceptual/epistemic modes
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN013_meaning_giving` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: n/a
- **Master River v1.4 eq(s):** 2, 3
- **Canonical source:** Master Equation River v1.4 eq.(2)-(3); independently verbatim in Experience Is Meaning-Giving EMG-02/03 and Meaning Before Naming MBN-config; a fuller multi-argument form μ_{i,n}=G_μ(x_{i,n},M,K,Θ,I,S,c_n) in Readout Genesis Standalone Synthesis eq.(13)
- **Notes:** Verbatim-equation duplicate across three chapters — collapsed per rule 1.
- **Occurrences (4):**
  - `21529456:(13)` — Readout Genesis Standalone Synthesis
  - `22410666:MBN-config` — Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganization (Standalone Concept Note v1.0 FULL)
  - `22357744:EMG-02` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-03` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release

#### CAN-014 — meaning-distortion
- **Object:** Approach/aversion/blindness can distort the meaning operator without raising epistemic status
- **Root object:** readout R
- **Tier:** definition / measurement
- **Coq:** `CAN014_distort`; `CAN014_distortion_can_change_meaning`; `CAN014_distortion_preserves_epistemic_mode` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Both theorems: Closed under the global context
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(44)-(46) [record 21529456]
- **Relations:** relates-to → CAN-013; relates-to → CAN-015
- **Notes:** Relates to meaning-giving (perturbs the same operator G_μ) — kept as a distinct object per rule 5 since it is a defect measure, not the base meaning operator itself.
- **Occurrences (3):**
  - `21529456:(44)` — Readout Genesis Standalone Synthesis
  - `21529456:(45)` — Readout Genesis Standalone Synthesis
  - `21529456:(46)` — Readout Genesis Standalone Synthesis

#### CAN-015 — meaning
- **Object:** meaning as significance relation μ_n=Ψ_H(r_n,H_n,c_n,Q_n)
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN015_meaning` (`Notation` alias for `CAN013_meaning_giving`) — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: n/a
- **Master River v1.4 eq(s):** 2
- **Canonical source:** Master Equation River v1.4 eq.(2)
- **Occurrences (2):**
  - `22456564:(1)` — The Dialogue as the Ground of Enlightenment (uplift 2026)
  - `22424434:(10)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-016 — meaning-modes
- **Object:** meaning decomposed into analytic modes
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN016_MeaningModes`; `CAN016_decomposition_faithful` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** Master Equation River v1.4 eq.(3)
- **Occurrences (1):**
  - `22424434:(11)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-017 — experience-equation
- **Object:** Experience as phenomenon-as-meaningfully-read
- **Root object:** readout R
- **Tier:** definition / identity (central compression)
- **Coq:** `CAN017_experience_joint_witness`; `CAN017_experience_joint_witness_on_bool` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Both: Closed under the global context
- **Master River v1.4 eq(s):** 4, 5
- **Canonical source:** Master Equation River v1.4 eq.(4)-(5) [citing Readout Genesis MEMK eq.14 and Experience Is Meaning-Giving]; verbatim in Meaning Before Naming (MBN-experience), Experience Is Meaning-Giving (EMG-04/05), and Readout Genesis Standalone Synthesis eq.(14)
- **Notes:** Human LoRA's dual-aspect refinement (E_n=<E_n^phen,E_n^adapt>, a finite experience-event tuple <X_n,z_n,z̃_n,P_n,u_n,R_{n+1},ΔO_n>) and Mind as Information Horizon's coupling-based E[t]=R(B[t],H[t]) are richer/parallel formalizations of the SAME object, not separate objects (rule 5 relation: 'refines'/'parallels'). [MERGER dedup-fix: CAN-018 'experience' retired and folded in here — its sole occurrence (22424434:(12)-(13), 'Before Meaning, Before Choice') restated the identical formula E_n=Φ_E(x_n,μ_n,γ^μ_n,c_n) and the identical central identity already carried by this cluster, with identical canonical_source (Master River v1.4 eq.(4)-(5)); a 'relates-to' cross-reference was not sufficient distance to justify a separate id per BBL-170 rule 1.]
- **Occurrences (11):**
  - `21529456:(14)` — Readout Genesis Standalone Synthesis
  - `22410666:MBN-experience` — Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganization (Standalone Concept Note v1.0 FULL)
  - `22357744:EMG-04` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-05` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `21425420:(12)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(13)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(15)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(16)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(17)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `22424434:(12)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(13)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-019 — naming-operator
- **Object:** Naming as articulation, optionally recursive, never a precondition of significance
- **Root object:** readout R
- **Tier:** definition / identity (recursive architecture)
- **Coq:** `CAN019_naming_operator` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: n/a
- **Master River v1.4 eq(s):** 6, 6, 7
- **Canonical source:** Master Equation River v1.4 eq.(6)-(7); verbatim in Meaning Before Naming (MBN-naming) and Experience Is Meaning-Giving (EMG-06/07)
- **Relations:** relates-to → CAN-015
- **Notes:** Meaning Before Naming's central thesis (meaning may precede naming) is the founding statement; Experience v2 hardens it into an explicit recursive loop — same object, later paper sharpens it (rule 2: use the sharper/later form as canonical).
- **Occurrences (6):**
  - `22410666:MBN-naming` — Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganization (Standalone Concept Note v1.0 FULL)
  - `22410666:H1` — Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganization (Standalone Concept Note v1.0 FULL)
  - `22410666:H3` — Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganization (Standalone Concept Note v1.0 FULL)
  - `22410666:H5` — Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganization (Standalone Concept Note v1.0 FULL)
  - `22357744:EMG-06` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-07` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release

#### CAN-020 — naming-loop
- **Object:** naming as articulation and restructuring operator
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN020_NamingChainStep`; `CAN020_naming_chain` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** Master Equation River v1.4 eq.(6)-(7)
- **Occurrences (2):**
  - `22424434:(14)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(15)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-021 — resonance
- **Object:** Resonance as external–internal experiential congruence (current definition supersedes an earlier accessibility-diagnostic reading)
- **Root object:** non-collapse
- **Tier:** definition (Dr/Open domain diagnostic, not a validated psychometric scale)
- **Coq:** `CAN021_ResonanceNotion`; `CAN021_resonance_non_collapse` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Master River v1.4 eq(s):** 9, 10, 11
- **Canonical source:** Master Equation River v1.4 eq.(9)-(11), citing Experience Is Meaning-Giving (current, canonical definition)
- **Notes:** Explicit supersession recorded in the source material itself: Meaning Before Naming's ΔA_H(x,c)=A_H^post−A_H^pre accessibility-change diagnostic is the earlier definition, later superseded by Experience v2's congruence definition — both kept here as one cluster with the supersession noted, per rule 2 (canonical = latest formulation) and rule 7 (no priority words, but the supersession is the source's own stated fact, not our ranking).
- **Occurrences (5):**
  - `22357744:EMG-09` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-10` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-11` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-12` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22410666:MBN-resonance-diagnostic` — Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganization (Standalone Concept Note v1.0 FULL)

#### CAN-022 — accumulation-barrier
- **Object:** Accumulation, activation-barrier crossing, and release — a candidate transition topology, not a physical-energy law
- **Root object:** F-stepper
- **Tier:** definition / hypothesis-Open (candidate transition topology, explicitly not universal)
- **Coq:** `CAN022_accum_work`; `CAN022_threshold_crossed`; `CAN022_Open_transition` — coq tier: Definition / Open — `coq_canon/MRC_epistemic_reading.v` — assumptions: `accum_work` bookkeeping: Closed under the global context; `Open_eq18`: n/a (Open Prop)
- **Master River v1.4 eq(s):** 16, 17, 18
- **Canonical source:** Master Equation River v1.4 eq.(16)-(18) [citing Readout Genesis MEMK + Experience Is Meaning-Giving]; verbatim in Experience Is Meaning-Giving EMG-16/17/18
- **Notes:** Explicitly named a rival-model-tested construct: only retained as a distinct object if it beats a continuous rival z_{n+1}=z_n+αW_n^eff+ε_n (EMG-19) on abrupt reorganization/hysteresis signatures.
- **Occurrences (4):**
  - `22357744:EMG-16` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-17` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-18` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-19` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release

#### CAN-023 — retention-update
- **Object:** Retention: only a selected residue of a readout updates the retained state
- **Root object:** L_R
- **Tier:** definition
- **Coq:** `CAN023_retention_can_change_reader` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Master River v1.4 eq(s):** 8, 29
- **Canonical source:** Master Equation River v1.4 eq.(8) [citing Human LoRA + Experience v2]; independently verbatim in Meaning Before Naming (MBN-retention), Experience Is Meaning-Giving (EMG-08, EMG-23), and the more general memory form M_{i,n}=U_M(...) in Readout Genesis Standalone Synthesis eq.(15); further reused unchanged in later uplift-edition chapters
- **Merged from:** retention-update (group 3)
- **Relations:** relates-to → CAN-054
- **Notes:** This is the single most-repeated equation family in the whole scanned corpus besides the readout equation itself (also found verbatim, outside this group's 14 primary records, in records 22456414 and 22456564 — cross-group duplicate, flagged for the canonicaliser handling those chapters). Distinct from, but mechanized by, selective-retention-mechanism below (Human LoRA's low-rank ΔO_n=B_nA_n instantiation) — relation: 'refines/mechanizes'. [MERGER: combined with the human-AI-scale 'retention-update' cluster from the second cluster set — identical object H_{n+1}=U_H(...), non-overlapping occurrences across records 22456414/22456487/22456564/22424434/22481928 confirmed as the cross-group duplicate the original note flagged.]
- **Occurrences (13):**
  - `21529456:(15)` — Readout Genesis Standalone Synthesis
  - `22410666:MBN-retention` — Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganization (Standalone Concept Note v1.0 FULL)
  - `22410666:H4` — Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganization (Standalone Concept Note v1.0 FULL)
  - `22357744:EMG-08` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-23` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `21425420:(14)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `19205869:(3)` — Genesis Constraint-First Alignment Epistemology: Reason, Error, and World-Tracking under Irreducible Mediation
  - `22456414:(2)` — AI–Cognitive Interaction: Activating Youth Potential through Reflective Dialogue and Linguistic Capital (Read Through Retention and the Live-Possibility Envelope) — 2026 Uplift Edition
  - `22456487:unlabeled (5, Reflexive Reconfiguration stage)` — Operational Linguistic Wisdom (uplift 2026)
  - `22456564:unlabeled (§6, Integration bullet)` — The Dialogue as the Ground of Enlightenment (uplift 2026)
  - `22424434:(16)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(17)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22481928:(3)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-024 — history-accessibility
- **Object:** rhythm/momentum/attraction feeding history-shaped semantic accessibility
- **Root object:** readout R
- **Tier:** definition/hypothesis-Open (accessibility law explicitly Open)
- **Coq:** `CAN024_momentum`; `CAN024_Open_momentum_eases_reentry`; `CAN024_accessibility_score`; `CAN024_Open_accessibility_predicts`; `CAN024_rhythm_does_not_determine_accessibility` — coq tier: Definition / Open — `coq_canon/MRC_epistemic_reading.v` — assumptions: eq.15 witness: Closed under the global context; eq.13/14 Open Props: n/a
- **Canonical source:** Master Equation River v1.4 eq.(13)-(15) [problem_to_hypothesis]
- **Occurrences (3):**
  - `22424434:(18)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(19)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(20)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-025 — knowledge-stability
- **Object:** Knowledge as stabilized representation: robust to admissible variation
- **Root object:** tier ledger
- **Tier:** definition (knowledge as stability-achievement)
- **Coq:** `CAN025_stable_under`; `CAN025_stable_under_dec` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: `CAN025_stable_under_dec`: Closed under the global context
- **Canonical source:** Knowledge as Stabilized Translation eq.(2) [record 18925129]; Mind as Information Horizon (13) [record 19640361]
- **Relations:** relates-to → CAN-031
- **Notes:** Relates to knowledge-admission (σ_K(p), K_S^A) as a lighter-weight predecessor of the same stabilization idea.
- **Occurrences (2):**
  - `18925129:(2)` — Knowledge as Stabilized Translation
  - `19640361:(13)` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph

#### CAN-026 — fallibilism-axiom
- **Object:** Total epistemic error is never zero
- **Root object:** non-collapse
- **Tier:** law (axiom of fallibilism) / theorem (decomposition)
- **Coq:** `CAN026_eps_tot`; `CAN026_decomposition_identity`; `CAN026_fallibilism_Open` — coq tier: Th_coqc (decomposition) / Open (universal >0) — `coq_canon/MRC_epistemic_reading.v` — assumptions: `CAN026_decomposition_identity`: Closed under the global context; `CAN026_fallibilism_Open`: n/a (Open Prop, not proved)
- **Canonical source:** Genesis Constraint-First Alignment Epistemology eq.(4) [record 19205869]; Mind as Information Horizon eq.(12) [record 19640361, decomposed/theorem form]
- **Notes:** Two independently-authored chapters state the same non-collapse at different resolutions (bare inequality vs named decomposition) — same object, collapsed per rule 1.
- **Occurrences (2):**
  - `19205869:(4)` — Genesis Constraint-First Alignment Epistemology: Reason, Error, and World-Tracking under Irreducible Mediation
  - `19640361:(12)` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph

#### CAN-027 — alignment-readout
- **Object:** Domain-indexed epistemic alignment and its expected improvement under disciplined reasoning
- **Root object:** readout R
- **Tier:** definition / proposition
- **Coq:** `CAN027_V_A`; `CAN027_expected_improvement_Open` — coq tier: Definition / Open — `coq_canon/MRC_epistemic_reading.v` — assumptions: n/a (Definition; Open Prop not proved)
- **Canonical source:** Genesis Constraint-First Alignment Epistemology eq.(5)-(6) [record 19205869]
- **Relations:** relates-to → CAN-023
- **Notes:** Singleton-chapter cluster; relates to retention-update (M_A[n+1]=U_A(...) is the update feeding this alignment readout).
- **Occurrences (2):**
  - `19205869:(5)` — Genesis Constraint-First Alignment Epistemology: Reason, Error, and World-Tracking under Irreducible Mediation
  - `19205869:(6)` — Genesis Constraint-First Alignment Epistemology: Reason, Error, and World-Tracking under Irreducible Mediation

#### CAN-028 — generative-abundance-law
- **Object:** Under unbounded external generation, production ceases to index internal organization; accumulation gives way to discrimination
- **Root object:** non-collapse
- **Tier:** law
- **Coq:** `CAN028_Regime`; `CAN028_regime_transition_Open` — coq tier: Open — `coq_canon/MRC_epistemic_reading.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** Learning Under Generative Abundance, L1-L2 [record 18711408]
- **Notes:** Not cited anywhere in Master River v1.4's bibliography (confirmed absent from refs.bib per the record's own note field) — a genuinely orphaned chapter within this program, kept as its own small cluster rather than forced into another.
- **Occurrences (2):**
  - `18711408:L1` — Learning Under Generative Abundance: A Structural Law of Epistemic Stabilization
  - `18711408:L2` — Learning Under Generative Abundance: A Structural Law of Epistemic Stabilization

#### CAN-029 — knower-constitution
- **Object:** Possession-Constitution Collapse: a condition on who may possess knowledge is wrongly treated as a condition on what may constitute epistemically significant structure
- **Root object:** none
- **Tier:** definition / hypothesis (HSC, explicitly the rejected collapse) / proposition
- **Coq:** `CAN029_possession_constitution_non_collapse` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** Written by AI. Still True., SC/HSC/Def-1/Def-2/Def-3/Prop-1 [record 22301202]
- **Relations:** shares-noncollapse-with → CAN-222
- **Notes:** root_object left 'none': this belongs more properly to a sibling canonicaliser group covering knowledge/knowerhood status; kept here only because the whole chapter was assigned to this group for full reading. Its Role Separation law (Prin-1) is cross-listed under non-collapse-chain.
- **Occurrences (6):**
  - `22301202:SC` — Written by AI. Still True.
  - `22301202:HSC` — Written by AI. Still True.
  - `22301202:Def-1` — Written by AI. Still True.
  - `22301202:Def-2` — Written by AI. Still True.
  - `22301202:Prop-1` — Written by AI. Still True.
  - `22301202:Def-3` — Written by AI. Still True.

#### CAN-030 — context-indexed-evaluation
- **Object:** context-indexed knower status and weighted alignment profile
- **Root object:** none
- **Tier:** definition (heuristic, not algorithmic decision procedure)
- **Coq:** `CAN030_Profile`; `CAN030_weights_normalized`; `CAN030_V_A_D` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: n/a
- **Canonical source:** When AI Expands Human Potential (2026-03-25) §7
- **Occurrences (2):**
  - `19215748:unlabeled (§7, display 1)` — When AI Expands Human Potential
  - `19215748:unlabeled (§7, display 2)` — When AI Expands Human Potential

#### CAN-031 — knowledge-admission
- **Object:** Knowledge as an auditable bounded status granted to a claim, not inherited from speaker identity
- **Root object:** tier ledger
- **Tier:** definition (admission function) / definition (admission conditions)
- **Coq:** `CAN031_Status`; `CAN031_status_eq_dec`; `CAN031_Admission` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: `CAN031_status_eq_dec`: Closed under the global context
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(22)-(23),(31)-(32),(56)-(62) [record 21529456]; independently paralleled by Mind as Information Horizon's Knowledge Triple K_S^A=(Tr_A,Str_A,Cap_A) and Legitimacy Gate (eq.14-15) and by From Problem to Hypothesis's bounded-knower K_{A,t}(Q,D;O_D,Π_t,R_t)
- **Relations:** shares-noncollapse-with → CAN-222
- **Notes:** Three independently-authored chapters converge on the same object (a claim/knower's status is a bounded, auditable, non-transferable record) at different formal resolutions — collapsed per rule 1, with From Problem to Hypothesis's non-transfer laws (does not transfer across question/domain/time) cross-listed under non-collapse-chain as well.
- **Occurrences (18):**
  - `21529456:Def-1` — Readout Genesis Standalone Synthesis
  - `21529456:(22)` — Readout Genesis Standalone Synthesis
  - `21529456:(23)` — Readout Genesis Standalone Synthesis
  - `21529456:(31)` — Readout Genesis Standalone Synthesis
  - `21529456:(32)` — Readout Genesis Standalone Synthesis
  - `21529456:(56)` — Readout Genesis Standalone Synthesis
  - `21529456:(57)` — Readout Genesis Standalone Synthesis
  - `21529456:(58)` — Readout Genesis Standalone Synthesis
  - `21529456:(59)` — Readout Genesis Standalone Synthesis
  - `21529456:(60)` — Readout Genesis Standalone Synthesis
  - `21529456:(61)` — Readout Genesis Standalone Synthesis
  - `21529456:(62)` — Readout Genesis Standalone Synthesis
  - `19640361:(14)` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph
  - `19640361:(15)` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph
  - `22307148:(39)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(40)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(41)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(42)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space

#### CAN-032 — practical-effectiveness
- **Object:** Practical/operational effectiveness is a separate axis from epistemic status
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN032_Notion`/`CAN032_non_collapse`; `CAN032_status_and_performance_can_diverge` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Both: Closed under the global context
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(25)-(26) [record 21529456]
- **Relations:** shares-noncollapse-with → CAN-222
- **Notes:** Its guarding non-collapse (eq.26) is cross-listed under non-collapse-chain.
- **Occurrences (1):**
  - `21529456:(25)` — Readout Genesis Standalone Synthesis

#### CAN-033 — tier-ledger
- **Object:** A three/four/five-valued gate outcome or provenance label that never silently converts absence-of-evidence into pass or fail
- **Root object:** tier ledger
- **Tier:** definition
- **Coq:** `CAN033_GateOutcome`; `CAN033_Provenance`; `CAN033_gate_eq_dec`; `CAN033_prov_eq_dec`; `CAN033_Ledger` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: both `_eq_dec`: Closed under the global context
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(27) [record 21529456]; From Problem to Hypothesis eq.(9)-(10) [record 22307148]
- **Notes:** Direct match to root_object 'tier ledger' from READOUT_GENESIS_CORE.md's own Th_coqc/finite_diagnostic/Dr/Open discipline, here re-derived independently in the knowledge/hypothesis domain with its own value set — same structural object (never let absence-of-evidence pass silently as success or failure), different label alphabet.
- **Occurrences (3):**
  - `21529456:(27)` — Readout Genesis Standalone Synthesis
  - `22307148:(9)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(10)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space

#### CAN-034 — state-sufficiency
- **Object:** A candidate domain state must be sufficient, and a quotient may not merge states differing on a required future invariant
- **Root object:** domain weld q_D
- **Tier:** definition / law (invariant preservation)
- **Coq:** `CAN034_Sufficiency`; `CAN034_invariant_preserving`; `CAN034_invariant_functional_implies_preserving` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(28)-(29) [record 21529456]
- **Relations:** relates-to → CAN-007
- **Notes:** Same structural pattern as reader-equivalence (root-level), instantiated specifically for knowledge-domain quotients — related, not merged, per rule 5.
- **Occurrences (2):**
  - `21529456:(28)` — Readout Genesis Standalone Synthesis
  - `21529456:(29)` — Readout Genesis Standalone Synthesis

#### CAN-035 — claim-ceiling
- **Object:** The strongest publicly assignable claim tier is bounded by the weakest load-bearing gate
- **Root object:** tier ledger
- **Tier:** identity (claim-ceiling bound) / proposition (with proof)
- **Coq:** `CAN035_claim_ceiling`; `CAN035_claim_ceiling_bound` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(30), Prop-2 [record 21529456]
- **Relations:** relates-to → CAN-031; relates-to → CAN-033
- **Notes:** Directly operationalizes the tier-ledger discipline into a numeric bound; relates to knowledge-admission (the status this bound caps).
- **Occurrences (2):**
  - `21529456:(30)` — Readout Genesis Standalone Synthesis
  - `21529456:Prop-2` — Readout Genesis Standalone Synthesis

#### CAN-036 — knowledge-transport
- **Object:** Local knowledge may only be presented as global through a declared, tolerance-bounded commuting-square transport
- **Root object:** domain weld q_D
- **Tier:** definition (transport condition)
- **Coq:** `CAN036_bridge_error`; `CAN036_transports_within`; `CAN036_identity_transport_zero_error` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: supporting witness: Closed under the global context
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(32)-(34) [record 21529456]; paralleled by From Problem to Hypothesis's transport-with-defect-accounting Def_Q(T), Δ_O, λ^RG (eq.11-14)
- **Relations:** shares-noncollapse-with → CAN-222
- **Notes:** Its guarding non-collapse (Bel_global≠K_global, eq.35) is cross-listed under non-collapse-chain.
- **Occurrences (5):**
  - `21529456:(33)` — Readout Genesis Standalone Synthesis
  - `21529456:(34)` — Readout Genesis Standalone Synthesis
  - `22307148:(11)-(12)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(13)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(14)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space

#### CAN-037 — memk-record-noncollapse
- **Object:** event occurrence ≠ retained record ≠ accessible trace; root retention ≠ belief/meaning/experience/choice
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `CAN037_Notion`; `CAN037_non_collapse` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** Before Meaning, Before Choice (2026-09-06) eq.(8),(42)
- **Occurrences (2):**
  - `22424434:(8)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(42)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-039 — B-EPI-CANDSET
- **Object:** Candidate-Set Formation & Appraisal Loop (Ψ, Appraise, Gate, cycle)
- **Root object:** readout R_{Q,O,c}(S)=z≠S, articulated as an F-stepper loop
- **Tier:** definition (schematic); one definitional-consequence identity (22307564:(3), 'H not in C ⇒ no comparative appraisal') and one non-collapse identity (22308072:(5), 'usable for propagation ≠ true') embedded; one bundled sub-claim is explicitly hypothesis/Open and REJECTED by its own source (22307564:(Q5), 'C_{G,t}=∪C_{A_i,t}?', posed then rejected as insufficient) — kept as a rejected [Open] sub-claim inside the notes, not part of the definitional core, and disclosed here rather than folded into the flat 'definition (schematic)' label.
- **Coq:** `CAN039_CandidateSet`; `CAN039_comparable`; `CAN039_not_in_implies_not_comparable`; `CAN039_Notion`/`CAN039_usable_ne_true` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: both proved facts: Closed under the global context
- **Canonical source:** record 22308072, label (13)-(15) (2026-09-04, the latest and most fully elaborated statement of the loop, extending record 22307564's original 5-step cycle)
- **Notes:** 22307564(3) 'H not in C ⇒ no appraisal' and 22308072(5) 'usable for propagation ≠ true' are both domain instances of readout-not-truth (clearing the gate is not truth). 22308072's (Q5) rejected hypothesis 'C_{G,t}=∪C_{A_i,t}?' is kept inside this cluster as an explicitly rejected [Open] sub-claim, not merged into the definitional core. 22308072(18)-(19) are this paper's own schematic restatement of two sibling papers (Problem-to-Hypothesis, Knowledge-Topology-First-Passage) that belong to a different canonicaliser group's registry files — included here only as this paper's own summary of them, not independently re-clustered.
- **Occurrences (19):**
  - `22307564:(1)` — Before Evidence Can Decide: Candidate-Set Formation, Discovery Routing, and Unconceived Alternatives — Questions for a Pre-Evidential Epistemology of Science
  - `22307564:(2)` — Before Evidence Can Decide: Candidate-Set Formation, Discovery Routing, and Unconceived Alternatives — Questions for a Pre-Evidential Epistemology of Science
  - `22307564:(3)` — Before Evidence Can Decide: Candidate-Set Formation, Discovery Routing, and Unconceived Alternatives — Questions for a Pre-Evidential Epistemology of Science
  - `22307564:(4)` — Before Evidence Can Decide: Candidate-Set Formation, Discovery Routing, and Unconceived Alternatives — Questions for a Pre-Evidential Epistemology of Science
  - `22307564:(5)` — Before Evidence Can Decide: Candidate-Set Formation, Discovery Routing, and Unconceived Alternatives — Questions for a Pre-Evidential Epistemology of Science
  - `22307564:(Q5, unlabeled)` — Before Evidence Can Decide: Candidate-Set Formation, Discovery Routing, and Unconceived Alternatives — Questions for a Pre-Evidential Epistemology of Science
  - `22307564:(6)` — Before Evidence Can Decide: Candidate-Set Formation, Discovery Routing, and Unconceived Alternatives — Questions for a Pre-Evidential Epistemology of Science
  - `22308072:(1)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(2)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(3)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(4)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(5)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(6)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(13)-(15)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(18)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(19)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(20)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(21)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(22)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery

#### CAN-040 — B-EPI-KEPI
- **Object:** Epistemic Multiplication Factor k_epi and frontier-regime classification
- **Root object:** readout R (a scalar summary readout of the candidate-set loop's productivity)
- **Tier:** definition
- **Coq:** `CAN040_Regime`; `CAN040_k_epi`; `CAN040_classify`; `CAN040_classify_contractive_correct` — coq tier: Definition / Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** record 22308072, labels (7)-(10) (2026-09-04, only occurrence)
- **Relations:** relates-to → CAN-039
- **Notes:** Built directly on B-EPI-CANDSET's New_{t+1}=U_{t+1}\(∪_{s≤t}U_s); kept as a distinct object per rule 5 rather than folded into the loop cluster, since it is a separate derived scalar, not the loop itself.
- **Occurrences (4):**
  - `22308072:(7)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(8)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(9)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(10)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery

#### CAN-202 — mission-stepper-reading
- **Object:** The Mission/event-domain reading of the root stepper: an agent's realized readout as a gain on a control signal plus three named noise/error terms
- **Root object:** F-stepper
- **Tier:** definition
- **Coq:** `CAN202_M_A`; `CAN202_decomposition` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** From Problem to Hypothesis eq.(1) [record 22307148]; restated verbatim (inherited from Readout Universe/Lahtee 2026a) in The Standalone Scholar eq.(65) [record 22163849]
- **Relations:** relates-to → CAN-003
- **Notes:** [MERGER dedup-fix: split out of the former CAN-010 'readout-operator' over-merge — this is a distinct domain-level stepper reading, not an instance of the generic readout operator; the review noted its own negation (M_A[n]≠θ(E)) already had a separate home in the non-collapse bundles, evidence this definition itself needed its own entry. See also the mission-stepper non-collapse entries derived from the same two papers.]
- **Occurrences (2):**
  - `22307148:(1)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22163849:(65)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-203 — access-exposure-function
- **Object:** An agent's realized exposure to a source, indexed by outlet/channel/timing/relation/context
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN203_x` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: n/a
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(11) [record 21529456]
- **Relations:** relates-to → CAN-010
- **Notes:** [MERGER dedup-fix: split out of the former CAN-010 'readout-operator' over-merge — an exposure/access function is a distinct object from the readout r_n=R_H(...) itself (access precedes readout), per rule 5.]
- **Occurrences (1):**
  - `21529456:(11)` — Readout Genesis Standalone Synthesis

#### CAN-204 — encoder-pipeline
- **Object:** Selection-then-encoding decomposition of an observation into a translated record
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN204_O_A`; `CAN204_enc_A` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: n/a
- **Canonical source:** Genesis Constraint-First Alignment Epistemology eq.(1)-(2) [record 19205869]
- **Relations:** relates-to → CAN-012
- **Notes:** [MERGER dedup-fix: split out of the former CAN-010 'readout-operator' over-merge — this is the same selection/encoding/translation shape as CAN-012's observer-pipeline (M_A(E)=(T_A∘Π_A)(S_A(E))), split here across two equations instead of one composite; kept as its own entry because this paper states it as two separate steps, not because it is a different object in kind.]
- **Occurrences (2):**
  - `19205869:(1)` — Genesis Constraint-First Alignment Epistemology: Reason, Error, and World-Tracking under Irreducible Mediation
  - `19205869:(2)` — Genesis Constraint-First Alignment Epistemology: Reason, Error, and World-Tracking under Irreducible Mediation

#### CAN-205 — windowed-sensor-readout
- **Object:** A raw noisy sensor reading, smoothed by a finite trailing window into a windowed-average readout
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN205_windowed_avg`; `CAN205_window_of_one_exact` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** Experience Is the Human LoRA eq.(7)-(10) [record 21425420]
- **Relations:** relates-to → CAN-055
- **Notes:** [MERGER dedup-fix: split out of the former CAN-010 'readout-operator' over-merge — kept as ONE entry (not two) because eq.(7)-(8) [raw sensor] and eq.(9)-(10) [windowing] are consecutive steps of a single instrument construction within one paper, not independently recurring objects; per rule 5 they are distinct from both the generic readout operator and from the human r_n=R_H(...) instance.]
- **Occurrences (4):**
  - `21425420:(7)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(8)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(9)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(10)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change

#### CAN-206 — domain-taxonomy-Dn
- **Object:** A named taxonomy of readout-domain sources (first-person, behavioral, neural, world)
- **Root object:** readout R
- **Tier:** measurement
- **Coq:** `CAN206_DomainSource`; `CAN206_source_eq_dec` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: `CAN206_source_eq_dec`: Closed under the global context
- **Canonical source:** Experience Is the Human LoRA eq.(39) [record 21425420]
- **Notes:** [MERGER dedup-fix: split out of the former CAN-010 'readout-operator' over-merge — a domain taxonomy (a set of source-types) is a different kind of object from a readout function, per rule 5.]
- **Occurrences (1):**
  - `21425420:(39)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change

#### CAN-207 — semantic-quotient-reading
- **Object:** The live semantic-field state as a declared quotient of the raw readout stream
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN207_S_A` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: n/a
- **Canonical source:** From Problem to Hypothesis eq.(6) [record 22307148]
- **Relations:** relates-to → CAN-023
- **Notes:** [MERGER dedup-fix: split out of the former CAN-010 'readout-operator' over-merge — a declared-quotient state construction, distinct from the plain readout r_n=R_H(...) instance and from the Mission stepper reading in the same paper.]
- **Occurrences (1):**
  - `22307148:(6)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space

#### CAN-208 — provenance-governing-maxim
- **Object:** The paper's own governing maxim and its operational checklist form
- **Root object:** readout R
- **Tier:** law (governing maxim / governing questions); eq.(26) is a self-referential novelty summary (definition, 'novelty claim' tier), kept here as this cluster's own meta-note rather than a further formal object
- **Coq:** `CAN208_governing_maxim` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: n/a (Prop schema, not proved)
- **Canonical source:** The Readout Condition eq.(1),(27)-(30) [record 22301318]
- **Notes:** [MERGER dedup-fix: split out of the former CAN-011 over-merge. (1) and (30) are the identical maxim restated verbatim intro/conclusion — a legitimate rule-1 merge; (27)-(29) are its own operational question-form, cross-listed here rather than separately. The paper's self-referential novelty summary eq.(26) ('what is actually new': distinction-token audit + source licensing + identification layer + typed provenance DAG + E-A-D norms + defeater routing) is kept here as a meta-claim about the paper's own apparatus rather than a further formal object — eq.(26) names exactly the six sub-apparatuses now split into their own entries below.]
- **Occurrences (6):**
  - `22301318:(1)` — The Readout Condition
  - `22301318:(26)` — The Readout Condition
  - `22301318:(27)` — The Readout Condition
  - `22301318:(28)` — The Readout Condition
  - `22301318:(29)` — The Readout Condition
  - `22301318:(30)` — The Readout Condition

#### CAN-209 — provenance-distinction-and-path
- **Object:** A unit of distinction and its provenance path as a labeled graph
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN209_distinguishes`; `CAN209_D_Phi`; `CAN209_D_Phi_sound`; `CAN209_Path` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: `CAN209_D_Phi_sound`: Closed under the global context
- **Canonical source:** The Readout Condition eq.(3)-(4) [record 22301318]
- **Occurrences (2):**
  - `22301318:(3)` — The Readout Condition
  - `22301318:(4)` — The Readout Condition

#### CAN-217 — residual-provenance-effect
- **Object:** The Residual Provenance Effect: a measurable shift in credence from provenance alone, after relevant pathways are held fixed
- **Root object:** readout R
- **Tier:** definition; measurement (diagnostic, explicitly 'not a psychological law')
- **Coq:** `CAN217_RPE`; `CAN217_RPE_can_be_nonzero` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** Written by AI. Still True., (dCr), Def-4, (RPE) [record 22301202]
- **Occurrences (3):**
  - `22301202:(dCr)` — Written by AI. Still True.
  - `22301202:Def-4` — Written by AI. Still True.
  - `22301202:(RPE)` — Written by AI. Still True.

#### CAN-218 — bridge-burden-principle
- **Object:** Bridge Burden: an inference from source metadata must name its mediating relation or it is pedigree substitution
- **Root object:** readout R
- **Tier:** law (named principle)
- **Coq:** `CAN218_pedigree_substitution`; `CAN218_no_relation_is_substitution` — coq tier: Definition — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** Written by AI. Still True., Prin-2 [record 22301202]
- **Occurrences (1):**
  - `22301202:Prin-2` — Written by AI. Still True.

#### CAN-219 — no-bare-pedigree-principle
- **Object:** No Bare Pedigree: a source label alone is epistemically incomplete reporting
- **Root object:** readout R
- **Tier:** law (named principle)
- **Coq:** `CAN219_SourceReport`; `CAN219_label_underdetermines_report` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** Written by AI. Still True., Prin-3 [record 22301202]
- **Occurrences (1):**
  - `22301202:Prin-3` — Written by AI. Still True.

#### CAN-220 — provenance-relevance-constraint
- **Object:** Provenance may alter epistemic standing only via a specified epistemically relevant condition, never by redescription alone
- **Root object:** readout R
- **Tier:** law (named principle)
- **Coq:** `CAN220_redescription_alone_cannot_change_standing` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** Written by AI. Still True., Prin-4 [record 22301202]
- **Occurrences (1):**
  - `22301202:Prin-4` — Written by AI. Still True.

#### CAN-221 — friction-not-magic-principle
- **Object:** Friction, not magic: institutional certification earns force through reliable epistemic friction, not status alone
- **Root object:** readout R
- **Tier:** law (named principle)
- **Coq:** `CAN221_Friction`; `CAN221_all_false`/`CAN221_has_force`; `CAN221_certified_without_force` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** Written by AI. Still True., Prin-5 [record 22301202]
- **Occurrences (1):**
  - `22301202:Prin-5` — Written by AI. Still True.

#### CAN-223 — role-separation-principle
- **Object:** Role Separation: ten epistemic roles are distinct and must not be identified merely because one agent occupies several
- **Root object:** non-collapse
- **Tier:** law (non-collapse, named principle)
- **Coq:** `CAN223_Role`; `CAN223_code`; `CAN223_role_separation` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** Written by AI. Still True., Prin-1 [record 22301202]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-038 'non-collapse-chain'): the former cluster pooled this paper's own non-collapse pairs together with seven other unrelated papers' non-collapse pairs under one id, keyed only by the shared relation-shape 'X≠Y', contradicting rule 1 (cluster by object+relation, not by relation-pattern alone) and rule 5. Dissolved into one bundled entry per source paper, in the same pattern CAN-137 (Seven Distinctions) and CAN-160 (ten separations) already use for a single paper's own taxonomy. The recurring observation that non-collapse (X≠Y, never silently merged) is a structural pattern across nearly this whole corpus is recorded here only as a cross-reference, not as a clustering key: see root-non-collapse-chain (CAN-201-adjacent), role-separation-principle, representationality-selectivity-noncollapse, affective-semantic-non-collapse-bundle, meaning-giving-non-collapse-bundle, human-lora-adaptation-non-collapse, hypothesis-space-non-collapse-bundle, discovery-topology-non-collapse-bundle.]
- **Occurrences (1):**
  - `22301202:Prin-1` — Written by AI. Still True.

#### CAN-224 — representationality-selectivity-noncollapse
- **Object:** Representationality ≠ Selectivity
- **Root object:** non-collapse
- **Tier:** law (non-collapse)
- **Coq:** `CAN224_Notion`; `CAN224_non_collapse` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** The Readout Condition eq.(2) [record 22301318]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-038 'non-collapse-chain'): the former cluster pooled this paper's own non-collapse pairs together with seven other unrelated papers' non-collapse pairs under one id, keyed only by the shared relation-shape 'X≠Y', contradicting rule 1 (cluster by object+relation, not by relation-pattern alone) and rule 5. Dissolved into one bundled entry per source paper, in the same pattern CAN-137 (Seven Distinctions) and CAN-160 (ten separations) already use for a single paper's own taxonomy. The recurring observation that non-collapse (X≠Y, never silently merged) is a structural pattern across nearly this whole corpus is recorded here only as a cross-reference, not as a clustering key: see root-non-collapse-chain (CAN-201-adjacent), role-separation-principle, representationality-selectivity-noncollapse, affective-semantic-non-collapse-bundle, meaning-giving-non-collapse-bundle, human-lora-adaptation-non-collapse, hypothesis-space-non-collapse-bundle, discovery-topology-non-collapse-bundle.]
- **Occurrences (1):**
  - `22301318:(2)` — The Readout Condition

#### CAN-225 — affective-semantic-non-collapse-bundle
- **Object:** Meaning Before Naming's own family of non-collapse chains guarding affective/semantic reorganization
- **Root object:** non-collapse
- **Tier:** law (non-collapse, §8/§11); the bundled companion H6 ('No automatic improvement') is explicitly [Open] — a guardrail hypothesis, not an established non-collapse
- **Coq:** `CAN225_Notion`; `CAN225_non_collapse`; `CAN225_H6_no_automatic_improvement_Open` — coq tier: Th_coqc (bundle) / Open (H6) — `coq_canon/MRC_epistemic_reading.v` — assumptions: `CAN225_non_collapse`: Closed under the global context; H6: n/a (Open Prop)
- **Canonical source:** Meaning Before Naming §8, §11, H6 [record 22410666]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-038 'non-collapse-chain'): the former cluster pooled this paper's own non-collapse pairs together with seven other unrelated papers' non-collapse pairs under one id, keyed only by the shared relation-shape 'X≠Y', contradicting rule 1 (cluster by object+relation, not by relation-pattern alone) and rule 5. Dissolved into one bundled entry per source paper, in the same pattern CAN-137 (Seven Distinctions) and CAN-160 (ten separations) already use for a single paper's own taxonomy. The recurring observation that non-collapse (X≠Y, never silently merged) is a structural pattern across nearly this whole corpus is recorded here only as a cross-reference, not as a clustering key: see root-non-collapse-chain (CAN-201-adjacent), role-separation-principle, representationality-selectivity-noncollapse, affective-semantic-non-collapse-bundle, meaning-giving-non-collapse-bundle, human-lora-adaptation-non-collapse, hypothesis-space-non-collapse-bundle, discovery-topology-non-collapse-bundle.]
- **Occurrences (3):**
  - `22410666:§8-non-collapse-chain` — Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganization (Standalone Concept Note v1.0 FULL)
  - `22410666:§11-non-collapse-laws` — Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganization (Standalone Concept Note v1.0 FULL)
  - `22410666:H6` — Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganization (Standalone Concept Note v1.0 FULL)

#### CAN-226 — meaning-giving-non-collapse-bundle
- **Object:** Experience Is Meaning-Giving's own family of non-collapse chains across rhythm, release, and reader-relative meaning
- **Root object:** non-collapse
- **Tier:** law
- **Coq:** `CAN226_Notion`; `CAN226_non_collapse` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** Experience Is Meaning-Giving, EMG-15, EMG-20, EMG-27, EMG-29 [record 22357744]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-038 'non-collapse-chain'): the former cluster pooled this paper's own non-collapse pairs together with seven other unrelated papers' non-collapse pairs under one id, keyed only by the shared relation-shape 'X≠Y', contradicting rule 1 (cluster by object+relation, not by relation-pattern alone) and rule 5. Dissolved into one bundled entry per source paper, in the same pattern CAN-137 (Seven Distinctions) and CAN-160 (ten separations) already use for a single paper's own taxonomy. The recurring observation that non-collapse (X≠Y, never silently merged) is a structural pattern across nearly this whole corpus is recorded here only as a cross-reference, not as a clustering key: see root-non-collapse-chain (CAN-201-adjacent), role-separation-principle, representationality-selectivity-noncollapse, affective-semantic-non-collapse-bundle, meaning-giving-non-collapse-bundle, human-lora-adaptation-non-collapse, hypothesis-space-non-collapse-bundle, discovery-topology-non-collapse-bundle.]
- **Occurrences (4):**
  - `22357744:EMG-15` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-20` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-27` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-29` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release

#### CAN-227 — human-lora-adaptation-non-collapse
- **Object:** Successful adaptation ≠ mental health, an identity explicitly rejected by the source
- **Root object:** non-collapse
- **Tier:** law (non-collapse, rejected identity)
- **Coq:** `CAN227_Notion`; `CAN227_non_collapse` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** Experience Is the Human LoRA eq.(35) [record 21425420]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-038 'non-collapse-chain'): the former cluster pooled this paper's own non-collapse pairs together with seven other unrelated papers' non-collapse pairs under one id, keyed only by the shared relation-shape 'X≠Y', contradicting rule 1 (cluster by object+relation, not by relation-pattern alone) and rule 5. Dissolved into one bundled entry per source paper, in the same pattern CAN-137 (Seven Distinctions) and CAN-160 (ten separations) already use for a single paper's own taxonomy. The recurring observation that non-collapse (X≠Y, never silently merged) is a structural pattern across nearly this whole corpus is recorded here only as a cross-reference, not as a clustering key: see root-non-collapse-chain (CAN-201-adjacent), role-separation-principle, representationality-selectivity-noncollapse, affective-semantic-non-collapse-bundle, meaning-giving-non-collapse-bundle, human-lora-adaptation-non-collapse, hypothesis-space-non-collapse-bundle, discovery-topology-non-collapse-bundle.]
- **Occurrences (1):**
  - `21425420:(35)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change

#### CAN-228 — hypothesis-space-non-collapse-bundle
- **Object:** From Problem to Hypothesis's own family of non-collapse identities guarding attraction/momentum/accessibility from being read as warrant or truth
- **Root object:** non-collapse
- **Tier:** identity (non-collapse); eq.(18) is proposition-tier; eq.(30)-(32) are explicitly Dr-qualified
- **Coq:** `CAN228_Notion`; `CAN228_non_collapse` — coq tier: Th_coqc (bundle) / Open (Dr companions) — `coq_canon/MRC_epistemic_reading.v` — assumptions: Closed under the global context
- **Canonical source:** From Problem to Hypothesis eq.(2),(7),(18),(22),(30)-(32),(33),(38),(47),(58) [record 22307148]
- **Relations:** relates-to → CAN-202
- **Notes:** eq.(2) M_A[n]≠θ(E[n]) is the direct negation of the mission-stepper-reading definition (CAN-202) from the same and a sibling paper. [MERGER dedup-fix, review verdict FAIL over-merge (CAN-038 'non-collapse-chain'): the former cluster pooled this paper's own non-collapse pairs together with seven other unrelated papers' non-collapse pairs under one id, keyed only by the shared relation-shape 'X≠Y', contradicting rule 1 (cluster by object+relation, not by relation-pattern alone) and rule 5. Dissolved into one bundled entry per source paper, in the same pattern CAN-137 (Seven Distinctions) and CAN-160 (ten separations) already use for a single paper's own taxonomy. The recurring observation that non-collapse (X≠Y, never silently merged) is a structural pattern across nearly this whole corpus is recorded here only as a cross-reference, not as a clustering key: see root-non-collapse-chain (CAN-201-adjacent), role-separation-principle, representationality-selectivity-noncollapse, affective-semantic-non-collapse-bundle, meaning-giving-non-collapse-bundle, human-lora-adaptation-non-collapse, hypothesis-space-non-collapse-bundle, discovery-topology-non-collapse-bundle.
- **Occurrences (9):**
  - `22307148:(2)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(7)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(18)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(22)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(30)-(32)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(33)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(38)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(47)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(58)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space

#### CAN-229 — discovery-topology-non-collapse-bundle
- **Object:** Knowledge Topology's own non-collapse pair guarding usability and warrant-decrease from truth
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN229_Notion`; `CAN229_usable_ne_true`; `CAN229_falling_TU_does_not_force_rising_warrant` — coq tier: Th_coqc — `coq_canon/MRC_epistemic_reading.v` — assumptions: Both: Closed under the global context
- **Canonical source:** Knowledge Topology and the First Passage to Usable Hypotheses eq.(4),(12) [record 22307561]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-038 'non-collapse-chain'): the former cluster pooled this paper's own non-collapse pairs together with seven other unrelated papers' non-collapse pairs under one id, keyed only by the shared relation-shape 'X≠Y', contradicting rule 1 (cluster by object+relation, not by relation-pattern alone) and rule 5. Dissolved into one bundled entry per source paper, in the same pattern CAN-137 (Seven Distinctions) and CAN-160 (ten separations) already use for a single paper's own taxonomy. The recurring observation that non-collapse (X≠Y, never silently merged) is a structural pattern across nearly this whole corpus is recorded here only as a cross-reference, not as a clustering key: see root-non-collapse-chain (CAN-201-adjacent), role-separation-principle, representationality-selectivity-noncollapse, affective-semantic-non-collapse-bundle, meaning-giving-non-collapse-bundle, human-lora-adaptation-non-collapse, hypothesis-space-non-collapse-bundle, discovery-topology-non-collapse-bundle.]
- **Occurrences (2):**
  - `22307561:(4)` — Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discovery Time and Direction
  - `22307561:(12)` — Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discovery Time and Direction

### Domain: human–AI

#### CAN-041 — pre-prompt-human-state-transport
- **Object:** Language as a bounded transport of a prior human state, not its container
- **Root object:** readout R
- **Tier:** law (named principle) / definition
- **Coq:** `CAN_041_pre_prompt_human_state_transport` (= `MR_Prompt.next_state`) — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Master River v1.4 eq(s):** 27, 28
- **Canonical source:** Master Equation River v1.4 eq.(27)-(30) [Pre-Prompt Human State Principle]; verbatim in Meaning Before Naming (MBN-articulation) and Experience Is Meaning-Giving (EMG-21/22/23/24)
- **Notes:** Master River v1.4 later restates this same transport with a session index (eq.46, DCP) and appends further stages (Topic Entry, Human Return, world-system) that fall outside this group's remit (choice/agency/world-system) — noted here only as a downstream continuation, not claimed into this cluster.
- **Occurrences (4):**
  - `22410666:MBN-articulation` — Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganization (Standalone Concept Note v1.0 FULL)
  - `22357744:EMG-21` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-22` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-24` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release

#### CAN-042 — pre-prompt-transport
- **Object:** pre-prompt human-state transport H_t --L_H--> Q_t, Q_t≠H_t
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN_042_bounded_transport`; `CAN_042_bounded_transport_satisfiable_on_nat` — coq tier: Definition + Th_coqc witness — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Master River v1.4 eq(s):** 27
- **Canonical source:** Master Equation River v1.4 eq.(27),(46) [dialogue_conversion_protocol restatement]
- **Notes:** 22456487's is the organizational reading; 22481928(1) matches DCP's own session-indexed restatement already folded into Master River eq.(46).
- **Occurrences (4):**
  - `22456487:(1)` — Operational Linguistic Wisdom (uplift 2026)
  - `22456564:unlabeled (§6, Framing bullet)` — The Dialogue as the Ground of Enlightenment (uplift 2026)
  - `22424434:(29)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22481928:(1)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-043 — entry-state-anchor
- **Object:** pre-AI entry-state anchor tuple
- **Root object:** none
- **Tier:** definition
- **Coq:** `EntryStateAnchor` (Record), `CAN_043_mk_entry_state_anchor` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** How Humans Should Converse with AI (DCP, 2026-09-06) eq.(12)-(13), superseding Epistemic Fusion/Tunnel v8.1 (2026-09-05) EF-01/02/03
- **Occurrences (5):**
  - `22331922:EF-01` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22331922:EF-02 (Repair 1)` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22331922:EF-03 (Repair 1)` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22481928:(12)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(13)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-044 — DCP-topic-entry
- **Object:** Topic Entry Condition and Problem-First default
- **Root object:** readout R
- **Tier:** definition/law (PFDP itself [Open])
- **Coq:** `CAN_044_TopicEntry`, `CAN_044_Legitimate` (= `MR_TopicEntry`); `CAN_044_Open_ProblemFirst_implication`, `CAN_044_Open_ProblemFirst_ne_ProblemOnly` (Open, un-proved) — coq tier: Definition (eq.47) / Open (eq.48-49) — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** Master Equation River v1.4 eq.(47)-(49) [dialogue_conversion_protocol]
- **Occurrences (6):**
  - `22481928:(4)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(5)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(6)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(7)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:PFDP` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(43)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-045 — B-HAI-PREPROMPT
- **Object:** Pre-Prompt Human State Principle & Live-Field Update Loop
- **Root object:** F-stepper (+ readout R for the bounded export H_t→Q_t)
- **Tier:** identity (27,28,30); definition (29)
- **Coq:** `CAN_045_prompt_coupling_and_update` (= `MR_Prompt.next_state`); `CAN_045_live_weight_may_change_witness` (= `MR_Prompt.eq30_live_weight_may_change`) — coq tier: Definition + Th_coqc witness — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Master River v1.4 eq(s):** 27, 28, 29, 30
- **Canonical source:** Master Equation River v1.4, eq:27–eq:30 (main.tex, 2026-09-06; source paper record 22357788 §13)
- **Relations:** relates-to → CAN-017
- **Notes:** H_{t+1}=U_H(...) is a direct domain reading of the root stepper S_{n+1}=F(S_n,u_n,c_n,T_n) with the AI-conditioned experience playing the role of the control input.
- **Occurrences (4):**
  - `22357788:CBC-11` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-12` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-13` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-14` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems

#### CAN-046 — ai-response-chain
- **Object:** AI response chain and re-entry as encounter
- **Root object:** F-stepper
- **Tier:** definition
- **Coq:** `CAN_046_ai_response_chain` (= `MR_Prompt.ai_turn`) — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** Master Equation River v1.4 eq.(28)-(29)
- **Notes:** 22481928(2) is the DCP session-indexed variant.
- **Occurrences (4):**
  - `22424434:(30)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(32)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(33)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22481928:(2)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-047 — human-AI-session-stepper
- **Object:** finite dialogue state and reciprocal-lineage diagnostic
- **Root object:** F-stepper
- **Tier:** definition (χ_recip explicitly not warrant/truth)
- **Coq:** `CAN_047_dialogue_session_stepper` (= `MR_Prompt.dlg_step`), `CAN_047_chi_recip`; `CAN_047_chi_recip_bounds_witness` — coq tier: Definition + Th_coqc witness — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Master River v1.4 eq(s):** 31
- **Canonical source:** Master Equation River v1.4 eq.(31)-(32) [fusion]
- **Occurrences (5):**
  - `22456564:(2)` — The Dialogue as the Ground of Enlightenment (uplift 2026)
  - `22331922:EF-13` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22331922:EF-14` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22331922:EF-15 (Repair 6)` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22331922:EF-16` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)

#### CAN-048 — agency-conditional-chain
- **Object:** The causal chain from world-state through body, nervous system, sensory interface, internal agency state, policy, and executed output back to world-state
- **Root object:** F-stepper
- **Tier:** definition
- **Coq:** `CAN_048_agency_conditional_chain` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** Mind as Information Horizon eq.(1)-(8) [Causal Body Framework, record 19640361]; Readout Genesis Standalone Synthesis eq.(39)-(43) [conditional chain, record 21529456]
- **Notes:** Two independently-authored chapters give the same object (a staged agentic causal loop) at different granularity — collapsed per rule 1, not treated as two objects.
- **Occurrences (13):**
  - `19640361:(1)` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph
  - `19640361:(2)` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph
  - `19640361:(3)` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph
  - `19640361:(4)` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph
  - `19640361:(5)` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph
  - `19640361:(6)` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph
  - `19640361:(7)` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph
  - `19640361:(8)` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph
  - `21529456:(39)` — Readout Genesis Standalone Synthesis
  - `21529456:(40)` — Readout Genesis Standalone Synthesis
  - `21529456:(41)` — Readout Genesis Standalone Synthesis
  - `21529456:(42)` — Readout Genesis Standalone Synthesis
  - `21529456:(43)` — Readout Genesis Standalone Synthesis

#### CAN-049 — agency-quotient
- **Object:** An epistemic agent is a query-relative quotient of a retained state, not an indivisible substance; identity is compositional lineage
- **Root object:** domain weld q_D
- **Tier:** definition
- **Coq:** `CAN_049_agency_readout`, `CAN_049_is_automorphism`, `CAN_049_Aut` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(36)-(38) [record 21529456]
- **Notes:** Direct instance of root_object domain weld q_D — the agent is literally defined as a quotient map, exactly per BBL-170 rule 1.
- **Occurrences (3):**
  - `21529456:(36)` — Readout Genesis Standalone Synthesis
  - `21529456:(37)` — Readout Genesis Standalone Synthesis
  - `21529456:(38)` — Readout Genesis Standalone Synthesis

#### CAN-050 — self-readout
- **Object:** The self as a typed quotient-readout bundling agency, identity, phenomenality, ownership, coherence, valence, policy, and lineage
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `SelfState` (Record, 10 fields), `CAN_050_mk_self_readout` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(47),(49) [record 21529456]
- **Relations:** shares-noncollapse-with → CAN-222
- **Notes:** Its own non-collapse guard (A_A≠I_A≠Phen_A^str≠P_A^lived≠Own_A≠Coh_A≠Val_A, eq.48) is cross-listed under non-collapse-chain rather than duplicated here.
- **Occurrences (2):**
  - `21529456:(47)` — Readout Genesis Standalone Synthesis
  - `21529456:(49)` — Readout Genesis Standalone Synthesis

#### CAN-051 — horizon-triad
- **Object:** Dynamical, information, and phenomenal horizons — a proposed but only partially-derived weld
- **Root object:** readout R
- **Tier:** definition / hypothesis-Open (the weld itself, bridge IP_K explicitly open)
- **Coq:** `CAN_051_horizon_triad`; `CAN_051_Open_dynamic_to_information_bridge`, `CAN_051_Open_information_to_phenomenal_bridge` (Open, un-proved) — coq tier: Definition + Open — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(50)-(55) [record 21529456]
- **Notes:** Human LoRA's finite horizon H_n⊆V_H[n], |H_n|<∞ (its own §6.2) is a much lighter-weight, independently-formalized construct under the same name — related as 'parallels', not merged, since it lacks the triad structure.
- **Occurrences (7):**
  - `21529456:(50)` — Readout Genesis Standalone Synthesis
  - `21529456:(51)` — Readout Genesis Standalone Synthesis
  - `21529456:(52)` — Readout Genesis Standalone Synthesis
  - `21529456:(53)` — Readout Genesis Standalone Synthesis
  - `21529456:(54)` — Readout Genesis Standalone Synthesis
  - `21529456:(55)` — Readout Genesis Standalone Synthesis
  - `21425420:(31)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change

#### CAN-052 — release-dynamics
- **Object:** Release without destruction: identity-binding can decay to zero while readout stays nonzero
- **Root object:** F-stepper
- **Tier:** definition (sufficient condition)
- **Coq:** `CAN_052_release_step`, `CAN_052_sufficient_release_condition` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(63)-(66) [record 21529456]
- **Notes:** Explicitly guarded: release ≠ death, memory deletion, passivity, or loss of causal agency.
- **Occurrences (4):**
  - `21529456:(63)` — Readout Genesis Standalone Synthesis
  - `21529456:(64)` — Readout Genesis Standalone Synthesis
  - `21529456:(65)` — Readout Genesis Standalone Synthesis
  - `21529456:(66)` — Readout Genesis Standalone Synthesis

#### CAN-053 — meta-readout-governance
- **Object:** Readout-of-readout, finite retention, and a governance state that composes context/lineage access, action formation, interruptibility, and policy revision
- **Root object:** readout R
- **Tier:** definition / law (no-free-governance) / measurement (defect vector, capture margin)
- **Coq:** `CAN_053_second_order_readout`, `CAN_053_governance_bundle`; `CAN_053_Open_no_free_governance` (Open, un-proved) — coq tier: Definition + Open — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(67)-(86) [record 21529456]
- **Relations:** shares-noncollapse-with → CAN-222
- **Notes:** Its guarding non-collapse (R_A^(1)≠Claim≠Identity≠ActionCandidate≠CommittedAction, eq.70) and the no-free-governance law (eq.85) are cross-listed under non-collapse-chain as well, since both are instances of that root pattern applied to this object specifically.
- **Occurrences (18):**
  - `21529456:(67)` — Readout Genesis Standalone Synthesis
  - `21529456:(68)` — Readout Genesis Standalone Synthesis
  - `21529456:(69)` — Readout Genesis Standalone Synthesis
  - `21529456:(71)` — Readout Genesis Standalone Synthesis
  - `21529456:(72)` — Readout Genesis Standalone Synthesis
  - `21529456:(73)` — Readout Genesis Standalone Synthesis
  - `21529456:(74)` — Readout Genesis Standalone Synthesis
  - `21529456:(75)` — Readout Genesis Standalone Synthesis
  - `21529456:(76)` — Readout Genesis Standalone Synthesis
  - `21529456:(77)` — Readout Genesis Standalone Synthesis
  - `21529456:(78)` — Readout Genesis Standalone Synthesis
  - `21529456:(79)` — Readout Genesis Standalone Synthesis
  - `21529456:(80)` — Readout Genesis Standalone Synthesis
  - `21529456:(81)` — Readout Genesis Standalone Synthesis
  - `21529456:(82)` — Readout Genesis Standalone Synthesis
  - `21529456:(83)` — Readout Genesis Standalone Synthesis
  - `21529456:(84)` — Readout Genesis Standalone Synthesis
  - `21529456:(86)` — Readout Genesis Standalone Synthesis

#### CAN-054 — selective-retention-mechanism
- **Object:** Selective retention as a rank-bounded factorized update (Human LoRA)
- **Root object:** L_R
- **Tier:** definition / theorem (rank bounds, proved in-article) / hypothesis-Open (empirical programme)
- **Coq:** `CAN_054_gate_weight_valid`, `CAN_054_retained_update`, `CAN_054_finite_bottleneck`; `CAN_054_finite_bottleneck_satisfiable`; `CAN_054_Open_empirical_programme` (Open, un-proved) — coq tier: Definition + Th_coqc witness + Open — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: Th_coqc component: Closed under the global context (family blanket check, see LEDGER summary); Open component: n/a, not proved by design
- **Canonical source:** Experience Is the Human LoRA eq.(18)-(29), (32)-(48) [record 21425420]
- **Relations:** refines → CAN-023
- **Notes:** Master River v1.4 explicitly does NOT restate this paper's own symbols (its eq.(lowrank)/(gate) are 'Master's own proposal', not this paper's text — per record 21425420's own note field). Relation to retention-update: 'refines/mechanizes' (same object, this is a proposed low-rank operationalization, not a separate root object per rule 5).
- **Occurrences (26):**
  - `21425420:(18)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(19)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(20)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(21)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(22)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(23)-(24)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(25)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(26)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(27)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(28)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(29)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(32)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(33)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(34)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(36)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(37)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(38)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(40)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(41)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(42)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(43)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(44)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(45)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(46)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(47)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(48)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change

#### CAN-055 — human-domain-state-graph
- **Object:** The human-domain retained-difference graph and its discrete spine equation
- **Root object:** L_R
- **Tier:** definition / Dr-interpretive (spine equation explicitly marked 'not a derived biological law')
- **Coq:** `HumanRetainedGraph` (Record), `CAN_055_Dr_spine_equation` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** Experience Is the Human LoRA eq.(1)-(6), (11), (30) [record 21425420]
- **Relations:** relates-to → CAN-001
- **Notes:** Direct human-domain instance of root_object L_R (D_W−W), and eq.(6) is an explicit Dr reading of Genesis's universal spine PDE — cross-links to root-weld.
- **Occurrences (8):**
  - `21425420:(1)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(2)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(3)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(4)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(5)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(6)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(11)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change
  - `21425420:(30)` — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change

#### CAN-056 — B-HAI-SYNERGY
- **Object:** Human-AI Augmentation/Synergy Ratio and chain-reaction hypotheses
- **Root object:** readout R (comparative scalar of usable readout classes) + non-collapse
- **Tier:** definition (finite diagnostic) for (11); identity (non-collapse) for (12); hypothesis [Open] for (16)-(17)
- **Coq:** `CAN_056_synergy_ratio`; `CAN_056_more_output_ne_more_diversity`; `CAN_056_Open_H1_H2` (Open, un-proved) — coq tier: Definition + Th_coqc witness + Open — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: Th_coqc component: Closed under the global context (family blanket check, see LEDGER summary); Open component: n/a, not proved by design
- **Canonical source:** record 22308072, labels (11)-(12) (2026-09-04)
- **Notes:** H1/H2 (16)-(17) are the paper's own falsifiable predictions built on this synergy ratio, kept in the same cluster because they test this object directly rather than a separate one.
- **Occurrences (4):**
  - `22308072:(11)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(12)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(16)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery
  - `22308072:(17)` — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery

#### CAN-057 — live-possibility
- **Object:** live possibility nesting Π^live⊆Π^feas⊆Π^phys
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN_057_Pi_live` (= `MR_Live.Pi_live`); `CAN_057_full_nesting_witness`, `CAN_057_full_nesting_worldsystem_witness` — coq tier: Th_coqc — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Master River v1.4 eq(s):** 21, 55
- **Canonical source:** Master Equation River v1.4 eq.(19),(21) [choice_before_choice]
- **Notes:** 22481924(32) restates the same nesting at world-system scale (Master River eq.55, After Labour eq.32); 22424434(43) is the non-collapse corollary 'feasible ≠ currently live'.
- **Occurrences (4):**
  - `22456414:(1)` — AI–Cognitive Interaction: Activating Youth Potential through Reflective Dialogue and Linguistic Capital (Read Through Retention and the Live-Possibility Envelope) — 2026 Uplift Edition
  - `22424434:(21)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(43)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22481924:(32)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-058 — live-set-weight
- **Object:** practical accessibility weight and operational live set
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN_058_live_field`, `CAN_058_live_ge_threshold` (= `MR_Live`) — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** Master Equation River v1.4 eq.(20)-(21)
- **Occurrences (2):**
  - `22424434:(22)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(23)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-059 — choice-noncollapse-chain
- **Object:** choice as downstream of the live set; enactment/observation non-identity
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `CAN_059_is_valid_choice`; `CAN_059_enactment_may_differ_witness`, `CAN_059_observation_loses_information_witness`, `CAN_059_stage_chain_non_collapse_witness` (= `MR_Live`) — coq tier: Th_coqc — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** Master Equation River v1.4 eq.(22)-(24)
- **Occurrences (3):**
  - `22424434:(24)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(25)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(26)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-060 — corrigible-agency-witnessed
- **Object:** corrigible/effective agency potential over a witnessed set
- **Root object:** readout R
- **Tier:** definition (measurement architecture; empirical claims Open)
- **Coq:** `CAN_060_p_star`; `CAN_060_p_star_upper_bound_witness` (= `MR_Live`) — coq tier: Definition + Th_coqc witness — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** Master Equation River v1.4 eq.(25) [potential_readout, superseding an undeposited feasible-set draft]
- **Occurrences (1):**
  - `22424434:(27)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-061 — live-possibility-dynamics
- **Object:** changing live-field/accessibility profile after AI encounter
- **Root object:** readout R
- **Tier:** definition / hypothesis-Open (dynamic law explicitly Open)
- **Coq:** `CAN_061_live_weight_may_change_witness` (= `MR_Prompt.eq30_...`); `CAN_061_Open_live_field_dynamic` (Open, un-proved) — coq tier: Th_coqc (possibility half) + Open (dynamic law) — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: Th_coqc component: Closed under the global context (family blanket check, see LEDGER summary); Open component: n/a, not proved by design
- **Canonical source:** Before Meaning, Before Choice (2026-09-06) eq.(34); world-system dynamic in After Labour (2026-09-06) eq.(33)
- **Occurrences (2):**
  - `22424434:(34)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22481924:(33)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-062 — K_like-noncollapse
- **Object:** AI output is knowledge-like, not validated knowledge
- **Root object:** non-collapse
- **Tier:** law/definition
- **Coq:** `CAN_062_KnowledgeStatus`, `CAN_062_status_value` (= `MR_Retention`); `CAN_062_non_collapse_witness` — coq tier: Th_coqc — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Master River v1.4 eq(s):** 38
- **Canonical source:** Master Equation River v1.4 eq.(38) [when_ai_expands, fusion]
- **Occurrences (6):**
  - `22456487:(2)` — Operational Linguistic Wisdom (uplift 2026)
  - `22456564:(3)` — The Dialogue as the Ground of Enlightenment (uplift 2026)
  - `22331922:EF-04` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22339909:CTSA-02` — CTSA Human-Return Readout: A Session-Boundary Measurement Architecture for Retained Human Capability After AI (Epistemic Note v9.1 FINAL)
  - `22481924:(4)` — After Labour: Human Position in an AI-Robotic World System
  - `22424434:(31)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-063 — K_like-statemachine
- **Object:** knowledge-like status as a state machine (not a fluency upgrade)
- **Root object:** non-collapse
- **Tier:** law/proposition
- **Coq:** `RepairedStatus` (Inductive), `CAN_063_next_status`, `CAN_063_dangerous_shortcut` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** eq_22331922 (2026-09-05), EF-05/EF-06 (Repair 2)
- **Relations:** relates-to → CAN-179
- **Notes:** Parallels, but is not identical to, the Standalone Scholar knowledge-state ladder K0→K1→K2→K3 (cluster knowledge-state-ladder) — same non-laundering intent, different apparatus.
- **Occurrences (2):**
  - `22331922:EF-05` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22331922:EF-06 (Repair 2)` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)

#### CAN-064 — human-ai-transport
- **Object:** A bounded transport relation must hold between AI-produced and human-produced knowledge objects before either substitutes for the other
- **Root object:** domain weld q_D
- **Tier:** definition (transport condition, Maker-Checker firewall)
- **Coq:** `TransportDefect` (Inductive), `CAN_064_transport_condition` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(88) [record 21529456]
- **Relations:** shares-noncollapse-with → CAN-222
- **Notes:** eq.(87)'s guarding non-collapse (AIOutput≠ClaimIdentity≠Evidence; Evidence≠Inference≠KnowledgeStatus) is cross-listed under non-collapse-chain too. Direct instance of root_object domain weld q_D at the human-AI boundary specifically.
- **Occurrences (2):**
  - `21529456:(88)` — Readout Genesis Standalone Synthesis
  - `21529456:(87)` — Readout Genesis Standalone Synthesis

#### CAN-065 — domain-weld-defect
- **Object:** declared defect vector for a domain weld
- **Root object:** domain weld q_D
- **Tier:** definition
- **Coq:** `CAN_065_domain_weld_defect` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** Before Meaning, Before Choice (2026-09-06) eq.(7); RG-HCA eq.(7) specializes to ε_HCA
- **Occurrences (2):**
  - `22498047:(7)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22424434:(7)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-066 — session-retention-gate
- **Object:** session-end retention gate and unaided return battery
- **Root object:** F-stepper
- **Tier:** definition (Master's own proposal, not v8.1's own text for the low-rank form)
- **Coq:** `CAN_066_candidate_update`, `CAN_066_is_low_rank`, `CAN_066_retention_gate_update`, `CAN_066_RET` (= `MR_Retention`, `MR_Prompt`); `CAN_066_gate_avoids_doubling_witness`, `CAN_066_RET_rearrangement_witness` — coq tier: Th_coqc — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** Master Equation River v1.4 eq.(lowrank),(gate),(33)-(34) [fusion; Master's own correction of an undeposited draft]
- **Occurrences (4):**
  - `22331922:EF-18 (Repair 7)` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22331922:EF-19 (Repair 7)` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22424434:(36)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(37)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-067 — gain-tunnel-functions
- **Object:** gain-side/tunnel-side directional functions and their difference
- **Root object:** none
- **Tier:** proposition
- **Coq:** `CAN_067_Delta_s`, `CAN_067_is_expansion`, `CAN_067_is_tunnel` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** eq_22331922 (2026-09-05), EF-20/21/22/25/26
- **Occurrences (5):**
  - `22331922:EF-20` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22331922:EF-21` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22331922:EF-22 (Repair 8)` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22331922:EF-25` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22331922:EF-26 (Repair 10)` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)

#### CAN-068 — epistemic-fusion-architecture-sequence
- **Object:** revised ten-problem architecture (Epistemic Fusion v8.1)
- **Root object:** none
- **Tier:** proposition
- **Coq:** `CAN_068_epistemic_fusion_sequence` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** eq_22331922 (2026-09-05) §13
- **Occurrences (1):**
  - `22331922:EF-27` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)

#### CAN-069 — fusion-non-collapse-bundle
- **Object:** Epistemic Fusion v8.1's twelve revised non-collapse laws
- **Root object:** non-collapse
- **Tier:** law (mixed definitional/empirical per source's own caveat)
- **Coq:** `CAN_069_fluency_ne_baseline`, `CAN_069_explanation_ne_verification`, `CAN_069_resistance_quality_ne_accessibility`, `CAN_069_uncertainty_signal_ne_truth` — coq tier: Th_coqc (×4) — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** eq_22331922 (2026-09-05) §14, NCL-14
- **Relations:** relates-to → CAN-071; relates-to → CAN-074; relates-to → CAN-079
- **Notes:** Several component separations overlap conceptually with assisted-vs-return-noncollapse, outcome-vector-J*, and resistance-quality-accessibility clusters; kept as its own record since the source presents it as one bundled equation.
- **Occurrences (1):**
  - `22331922:NCL-14` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)

#### CAN-070 — equivalence-class-diagnostic
- **Object:** effective candidate count as readout-equivalence classes
- **Root object:** readout R
- **Tier:** measurement
- **Coq:** `CAN_070_D_eff`, `CAN_070_d_s` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** How Humans Should Converse with AI (DCP, 2026-09-06) eq.(18), restating Epistemic Fusion/Tunnel v8.1 EF-07
- **Occurrences (2):**
  - `22331922:EF-07 (Repair 3)` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22481928:(18)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-071 — resistance-quality-accessibility
- **Object:** epistemic resistance quality vs its accessibility
- **Root object:** non-collapse
- **Tier:** proposition/law
- **Coq:** `CAN_071_R_ep`, `CAN_071_U_R`, `CAN_071_R_ex`; `CAN_071_quality_ne_accessibility` — coq tier: Definition + Th_coqc witness — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** eq_22331922 (2026-09-05) EF-08/09/10 (Repair 4)
- **Occurrences (3):**
  - `22331922:EF-08 (Repair 4)` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22331922:EF-09 (Repair 4)` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22331922:EF-10` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)

#### CAN-072 — calibration-audit
- **Object:** pre/post confidence-warrant calibration audit
- **Root object:** tier ledger
- **Tier:** measurement
- **Coq:** `CalibrationRecord` (Record), `CAN_072_calibration_error` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** eq_22331922 (2026-09-05) EF-11/12 (Repair 5)
- **Occurrences (2):**
  - `22331922:EF-11 (Repair 5)` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22331922:EF-12 (Repair 5)` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)

#### CAN-073 — ctsa-bridge
- **Object:** Retained experiential reorganization as a layer beneath, not identical to, later demonstrable capability
- **Root object:** none
- **Tier:** hypothesis/Open
- **Coq:** `CAN_073_Open_ctsa_bridge` (Open, un-proved) — coq tier: Open — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** Experience Is Meaning-Giving eq.(EMG-25)-(EMG-26) [record 22357744]
- **Notes:** Flagged as a boundary object: it names CTSA's Human Return construct (H_return/R_H, master eq.41-42) which belongs to a different canonicaliser group's remit (choice/agency/human-AI outcome), so root_object is left 'none' rather than forced onto this group's spine.
- **Occurrences (2):**
  - `22357744:EMG-25` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-26` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release

#### CAN-074 — assisted-vs-return-noncollapse
- **Object:** assisted-performance gain does not entail Human Return gain
- **Root object:** non-collapse
- **Tier:** law/definition
- **Coq:** `CAN_074_assisted_gain_does_not_imply_return_gain` — coq tier: Th_coqc — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** How Humans Should Converse with AI (DCP, 2026-09-06) eq.(27), restating The Dialogue as the Ground of Enlightenment (2026-09-06) eq.(4) and RG-HCA (2026-09-06) eq.(25)
- **Occurrences (4):**
  - `22456564:(4)` — The Dialogue as the Ground of Enlightenment (uplift 2026)
  - `22481928:(27)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22498047:(25)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22424434:(40)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-075 — exposure-retention-improvement-noncollapse
- **Object:** Exposure ≠ Retention ≠ Improvement
- **Root object:** non-collapse
- **Tier:** definition/law
- **Coq:** `CAN_075_EndChainNotion` (= `MR_Retention`); `CAN_075_exposure_retention_improvement_non_collapse` — coq tier: Th_coqc — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** Master Equation River v1.4 eq.(42) [ctsa]
- **Occurrences (2):**
  - `22331922:EF-17` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22424434:(39)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-076 — human-return-CTSA6
- **Object:** Human Return audit tuple, six-field (CTSA v9.1)
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `CAN_076_HReturn`, `CAN_076_mk_h_return` (= `MR_Retention.HReturn`) — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** Master Equation River v1.4 eq.(41) [ctsa]
- **Relations:** refines → CAN-077
- **Notes:** Distinct object from the four-field ⟨C,T,S,A⟩ tuple (cluster human-return-CTSA4); related as 'refines'/parallels per founder rule 5 (Master River itself keeps them under different names).
- **Occurrences (3):**
  - `22339909:CTSA-04` — CTSA Human-Return Readout: A Session-Boundary Measurement Architecture for Retained Human Capability After AI (Epistemic Note v9.1 FINAL)
  - `22424434:(38)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22339909:CTSA-01` — CTSA Human-Return Readout: A Session-Boundary Measurement Architecture for Retained Human Capability After AI (Epistemic Note v9.1 FINAL)

#### CAN-077 — human-return-CTSA4
- **Object:** Human Return tuple, four-field ⟨C,T,S,A⟩
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `ReturnCTSA4` (Record), `CAN_077_mk_human_return_ctsa4` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_a.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** How Humans Should Converse with AI (DCP, 2026-09-06) eq.(25), cited by RG-HCA (2026-09-06) eq.(24)
- **Notes:** Not asserted identical to the six-field CTSA tuple; Master River v1.4 keeps the two pairs of equations separate rather than merging them (founder rule 5).
- **Occurrences (2):**
  - `22481928:(25)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22498047:(24)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)

#### CAN-078 — D-R-A-constitutive
- **Object:** Difference, Resistance, Agency constitutive necessities
- **Root object:** non-collapse
- **Tier:** definition/hypothesis-Open
- **Coq:** `CAN_078_Open_dra_constitutive` (Open, un-proved) — coq tier: Open — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** Before Meaning, Before Choice (2026-09-06) eq.(35), reformulating Epistemic Fusion/Tunnel v8.1 CN-1 and The Dialogue as the Ground of Enlightenment eq.(5)
- **Occurrences (4):**
  - `22456487:unlabeled (§5.2, AVRH)` — Operational Linguistic Wisdom (uplift 2026)
  - `22456564:(5)` — The Dialogue as the Ground of Enlightenment (uplift 2026)
  - `22331922:CN-1` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22424434:(35)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-079 — outcome-vector-J*
- **Object:** three-axis human-AI outcome vector (augmentation, synergy, return)
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `CAN_079_AUG`, `CAN_079_SYN` (= `MR_Retention`); `CAN_079_aug_syn_non_collapse_witness` — coq tier: Th_coqc — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** Master Equation River v1.4 eq.(40) [when_ai_expands, fusion]
- **Occurrences (2):**
  - `22331922:EF-23` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)
  - `22331922:EF-24 (Repair 9)` — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)

#### CAN-080 — ctsa-non-collapse-bundle
- **Object:** CTSA v9.1's nine preserved non-collapse laws
- **Root object:** non-collapse
- **Tier:** law
- **Coq:** `CAN_080_fluency_ne_baseline`, `CAN_080_explanation_ne_verification`, `CAN_080_output_count_ne_epistemic_diversity`, `CAN_080_exposure_ne_retention_ne_improvement`, `CAN_080_trust_ne_calibrated_trust` — coq tier: Th_coqc (×5) — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** eq_22339909 (2026-09-05) §10, NCL-10
- **Occurrences (1):**
  - `22339909:NCL-10` — CTSA Human-Return Readout: A Session-Boundary Measurement Architecture for Retained Human Capability After AI (Epistemic Note v9.1 FINAL)

#### CAN-081 — ctsa-hypotheses
- **Object:** CTSA v9.1's Open hypotheses on incremental validity, dissociation, and regulation
- **Root object:** none
- **Tier:** hypothesis/Open
- **Coq:** `CAN_081_Open_hypotheses` (Open, un-proved) — coq tier: Open — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** eq_22339909 (2026-09-05) §12
- **Occurrences (6):**
  - `22339909:H1` — CTSA Human-Return Readout: A Session-Boundary Measurement Architecture for Retained Human Capability After AI (Epistemic Note v9.1 FINAL)
  - `22339909:H2` — CTSA Human-Return Readout: A Session-Boundary Measurement Architecture for Retained Human Capability After AI (Epistemic Note v9.1 FINAL)
  - `22339909:H3` — CTSA Human-Return Readout: A Session-Boundary Measurement Architecture for Retained Human Capability After AI (Epistemic Note v9.1 FINAL)
  - `22339909:H4` — CTSA Human-Return Readout: A Session-Boundary Measurement Architecture for Retained Human Capability After AI (Epistemic Note v9.1 FINAL)
  - `22339909:H5` — CTSA Human-Return Readout: A Session-Boundary Measurement Architecture for Retained Human Capability After AI (Epistemic Note v9.1 FINAL)
  - `22339909:H6` — CTSA Human-Return Readout: A Session-Boundary Measurement Architecture for Retained Human Capability After AI (Epistemic Note v9.1 FINAL)

#### CAN-082 — DCP-deployment-triage
- **Object:** deployment/triage policy across DCP-Lite, DCP-Standard, DCP-Critical
- **Root object:** decisive record
- **Tier:** definition/hypothesis-Open (AFP itself Open)
- **Coq:** `CAN_082_deployment_policy`, `DCPLiteStage` (Inductive), `CAN_082_lite_next` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** eq_22481928 (2026-09-06) eq.(8)-(10),(35), AFP
- **Occurrences (5):**
  - `22481928:(8)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(9)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:AFP` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(10)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(35)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-083 — DCP-protocol-stages
- **Object:** canonical eight-stage Dialogue Conversion Protocol
- **Root object:** F-stepper
- **Tier:** definition/law
- **Coq:** `DCPStage` (Inductive, 8 ctors), `CAN_083_stage_next`, `CAN_083_oppose_ne_manufacture` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** eq_22481928 (2026-09-06) eq.(11),(14)-(17),(45)
- **Occurrences (6):**
  - `22481928:(11)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(14)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(15)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(16)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(17)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(45)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-084 — DCP-verify-stage
- **Object:** the Verify stage: load-bearing claims and independent routes
- **Root object:** tier ledger
- **Tier:** definition/law
- **Coq:** `StakesKind`, `VerifyMethod` (Inductive), `CAN_084_high_stakes` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** eq_22481928 (2026-09-06) eq.(19)-(21)
- **Occurrences (3):**
  - `22481928:(19)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(20)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(21)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-085 — DCP-integrate-stage
- **Object:** the Integrate stage record
- **Root object:** tier ledger
- **Tier:** definition
- **Coq:** `IntegrationRec` (Record), `CAN_085_mk_integration_record` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** eq_22481928 (2026-09-06) eq.(22)
- **Occurrences (1):**
  - `22481928:(22)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-086 — DCP-remove-stage
- **Object:** Reset vs Removal
- **Root object:** none
- **Tier:** definition
- **Coq:** `CAN_086_is_reset`, `CAN_086_is_removal` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** eq_22481928 (2026-09-06) eq.(23)-(24)
- **Occurrences (2):**
  - `22481928:(23)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(24)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-087 — DCP-return-conversion-vector
- **Object:** session-level Human Return conversion vector and sampling frequency
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `ReturnConversionVector` (Record), `CAN_087_F_return` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** eq_22481928 (2026-09-06) eq.(26),(28)
- **Occurrences (2):**
  - `22481928:(26)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(28)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-088 — DCP-return-action-feedback
- **Object:** Human Return closed through action and world feedback
- **Root object:** F-stepper
- **Tier:** definition (World-closure proposition itself [Open])
- **Coq:** `CAN_088_world_closure` (= `MR_TopicEntry.dcp_closure_50`), `CAN_088_CycleStage`/`CAN_088_cycle_next` (= `MR_TopicEntry`) — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Master River v1.4 eq(s):** 74
- **Canonical source:** Master Equation River v1.4 eq.(50)-(51) [dialogue_conversion_protocol]
- **Notes:** 22498047(27) is RG-HCA's own restatement of the same world-closure step over its candidate HCA state Z_HCA (Master River eq.74).
- **Occurrences (5):**
  - `22481928:(29)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(30)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:WCP` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(44)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22498047:(27)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)

#### CAN-089 — DCP-expand-contract
- **Object:** Expansion and Contraction as alternating modes
- **Root object:** none
- **Tier:** definition
- **Coq:** `CAN_089_is_expansion`, `CAN_089_is_contraction` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** eq_22481928 (2026-09-06) eq.(31)-(34)
- **Occurrences (2):**
  - `22481928:(31)-(32)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(33)-(34)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-090 — DCP-open-propositions
- **Object:** DCP's remaining Open propositions (conversion, deployment, agenda)
- **Root object:** none
- **Tier:** hypothesis/Open
- **Coq:** `CAN_090_Open_dcp_propositions` (Open, un-proved) — coq tier: Open — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** eq_22481928 (2026-09-06) §14
- **Occurrences (3):**
  - `22481928:DCPp` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:DEPp` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:AgP` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-091 — DCP-hypotheses
- **Object:** DCP's ten primary empirical hypotheses
- **Root object:** none
- **Tier:** hypothesis/Open
- **Coq:** `CAN_091_Open_hypotheses` (Open, un-proved) — coq tier: Open — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** eq_22481928 (2026-09-06) §15.2
- **Occurrences (10):**
  - `22481928:H1` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:H2` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:H3` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:H4` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:H5` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:H6` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:H7` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:H8` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:H9` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:H10` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-092 — DCP-closing-questions
- **Object:** four decisive practical questions closing the paper
- **Root object:** none
- **Tier:** proposition
- **Coq:** `ClosingQuestion` (Inductive) — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** eq_22481928 (2026-09-06) §18
- **Occurrences (1):**
  - `22481928:(46)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-093 — event-translation-core
- **Object:** event, event-specific context, and translation-as-readout
- **Root object:** readout R
- **Tier:** definition/proposition
- **Coq:** `EventContext` (Record), `CAN_093_interpretation`; `CAN_093_interpretation_ne_event_witness` — coq tier: Definition + Th_coqc witness — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** AI, Translation, and Access to Event-Specific Context (2026-02-07) §3.1-3.3, 4.1, 4.5, 4.6
- **Occurrences (7):**
  - `18517054:Def-1` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation
  - `18517054:Def-2` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation
  - `18517054:Def-3` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation
  - `18517054:Prop-1` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation
  - `18517054:Eq-unifying` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation
  - `18517054:Eq-epoch3` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation
  - `18517054:Prop-4` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation

#### CAN-094 — self-context-agency
- **Object:** human agency, self-context, and external context-frame dominance
- **Root object:** non-collapse
- **Tier:** definition/proposition
- **Coq:** `ContextS` (Record), `CAN_094_is_agency` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** AI, Translation, and Access to Event-Specific Context (2026-02-07) §3.4-3.5, §7
- **Occurrences (7):**
  - `18517054:Def-4` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation
  - `18517054:Def-5` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation
  - `18517054:Def-6` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation
  - `18517054:Prop-2` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation
  - `18517054:Prop-5 (B1)` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation
  - `18517054:(2)` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation
  - `18517054:(3)` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation

#### CAN-095 — grounding-embodiment
- **Object:** referential grounding, experiential grounding, and embodiment kept distinct
- **Root object:** none
- **Tier:** definition/hypothesis-Open
- **Coq:** `CAN_095_referential_ne_embodiment`; `CAN_095_experiential_grounding` — coq tier: Th_coqc — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** AI, Translation, and Access to Event-Specific Context (2026-02-07) §3.6
- **Occurrences (2):**
  - `18517054:Def-7` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation
  - `18517054:Prop-3` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation

#### CAN-096 — interaction-efficiency
- **Object:** interaction efficiency as a qualitative construct
- **Root object:** none
- **Tier:** definition
- **Coq:** `CAN_096_interaction_efficiency` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** AI, Translation, and Access to Event-Specific Context (2026-02-07) §3.7
- **Occurrences (1):**
  - `18517054:(1)` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation

#### CAN-097 — ai-mediation-hypotheses
- **Object:** context-access amplification, bounded expansion, and architectural doorway hypotheses
- **Root object:** none
- **Tier:** hypothesis/Open
- **Coq:** `CAN_097_Open_hypotheses` (Open, un-proved) — coq tier: Open — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** AI, Translation, and Access to Event-Specific Context (2026-02-07) §6.2-6.4
- **Occurrences (3):**
  - `18517054:Finding-1 (H1)` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation
  - `18517054:Finding-2 (H3)` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation
  - `18517054:Finding-3 (H4)` — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation

#### CAN-098 — HCA-native-river
- **Object:** RG-HCA's own proactive-capability pipeline
- **Root object:** F-stepper
- **Tier:** definition
- **Coq:** `CAN_098_hca_native_river` (= `MR_HCA.hca_river_67`) — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Master River v1.4 eq(s):** 67
- **Canonical source:** Master Equation River v1.4 eq.(67) [rg_hca]
- **Notes:** The Human Capability Advancement Principle is the governing [Open] principle bounding this river: proactivity must remain subordinate to human-owned ends.
- **Occurrences (2):**
  - `22498047:(5)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:Human Capability Advancement Principle` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)

#### CAN-099 — HCA-candidate-state
- **Object:** candidate HCA domain state tuple
- **Root object:** none
- **Tier:** definition
- **Coq:** `HCACandidateState` (Record, 8 fields), `CAN_099_mk_hca_candidate_state` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** RG-HCA (2026-09-06) eq.(6)
- **Occurrences (1):**
  - `22498047:(6)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)

#### CAN-100 — life-capital-context
- **Object:** Life-Capital Context Vector
- **Root object:** none
- **Tier:** definition
- **Coq:** `CAN_100_LifeCapitalContext`, `CAN_100_mk_life_capital_context` (= `MR_HCA`) — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Master River v1.4 eq(s):** 68
- **Canonical source:** Master Equation River v1.4 eq.(68) [rg_hca]
- **Occurrences (1):**
  - `22498047:(8)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)

#### CAN-101 — capability-conversion-noncollapse
- **Object:** resources ≠ access ≠ capability ≠ realized opportunity
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `CAN_101_resources_ne_access`, `CAN_101_access_ne_capability`, `CAN_101_capability_ne_realized_opportunity`, `CAN_101_access_ne_control` — coq tier: Th_coqc (×4) — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** RG-HCA (2026-09-06) eq.(9)-(11)
- **Occurrences (3):**
  - `22498047:(9)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(10)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(11)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)

#### CAN-102 — barrier-readout
- **Object:** typed barrier ledger and Observed-Difficulty non-collapse
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN_102_BarrierType`, `CAN_102_BarrierLedger` (= `MR_HCA`); `CAN_102_observed_difficulty_ne_skill_deficit_witness` — coq tier: Th_coqc — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Master River v1.4 eq(s):** 69, 70
- **Canonical source:** Master Equation River v1.4 eq.(69)-(70) [rg_hca]
- **Occurrences (2):**
  - `22498047:(12)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(13)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)

#### CAN-103 — candidate-vs-endorsed-routes
- **Object:** candidate vs endorsed advancement routes
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `CAN_103_C_live` (= `MR_HCA.C_live`); `CAN_103_C_live_subset_witness`, `CAN_103_proactive_ne_ownership_witness`, `CAN_103_capability_ne_ai_authority_witness`, `CAN_103_scaffolding_ne_control_witness` — coq tier: Th_coqc — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Master River v1.4 eq(s):** 71, 72
- **Canonical source:** Master Equation River v1.4 eq.(71)-(72) [rg_hca]
- **Occurrences (5):**
  - `22498047:(15)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(16)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(17)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(18)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(19)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)

#### CAN-104 — scaffold-fading
- **Object:** adaptive scaffolding fading rule
- **Root object:** decisive record
- **Tier:** hypothesis/Open
- **Coq:** `CAN_104_hca_ddiff` (= `MR_HCA`); `CAN_104_Open_scaffold_fading` (= `MR_HCA.Open_eq73`, Open, un-proved) — coq tier: Open — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Open Prop, not proved by design)
- **Master River v1.4 eq(s):** 73
- **Canonical source:** Master Equation River v1.4 eq.(73) [rg_hca]
- **Occurrences (3):**
  - `22498047:(22)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(23)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(26)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)

#### CAN-105 — opportunity-conversion
- **Object:** world-side opportunity readout and its non-collapses
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN_105_omega_real` (= `MR_HCA.omega_real_75`); `CAN_105_credential_ne_capability_witness`, `CAN_105_legibility_ne_worth_witness` — coq tier: Th_coqc — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Master River v1.4 eq(s):** 75, 76
- **Canonical source:** Master Equation River v1.4 eq.(75)-(76) [rg_hca]
- **Occurrences (4):**
  - `22498047:(28)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(29)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(30)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(31)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)

#### CAN-106 — net-advancement-record
- **Object:** net HCA advancement record and conditional estimand
- **Root object:** tier ledger
- **Tier:** definition/measurement
- **Coq:** `CAN_106_NetAdvancementRecord`, `CAN_106_ATE_HCA` (= `MR_HCA`) — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Master River v1.4 eq(s):** 77, 78
- **Canonical source:** Master Equation River v1.4 eq.(77)-(78) [rg_hca]
- **Occurrences (2):**
  - `22498047:(36)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(37)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)

#### CAN-107 — HCA-worked-scenario
- **Object:** three-children worked-scenario causal warning and pathway
- **Root object:** none
- **Tier:** definition/proposition
- **Coq:** `CAN_107_raw_difference_ne_effect_hca` — coq tier: Th_coqc — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** RG-HCA (2026-09-06) §14
- **Occurrences (2):**
  - `22498047:(32)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(33)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)

#### CAN-108 — HCA-governance-bundle
- **Object:** child and adult governance minimum bundles
- **Root object:** none
- **Tier:** definition
- **Coq:** `CAN_108_adult_governance`, `CAN_108_child_governance` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** RG-HCA (2026-09-06) §15
- **Occurrences (2):**
  - `22498047:(34)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(35)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)

#### CAN-109 — before-meaning-hypotheses
- **Object:** Before Meaning, Before Choice minimal empirical predictions H1-H6
- **Root object:** none
- **Tier:** hypothesis/Open
- **Coq:** `CAN_109_Open_hypotheses` (Open, un-proved) — coq tier: Open — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** Before Meaning, Before Choice (2026-09-06) §17.2
- **Occurrences (6):**
  - `22424434:H1` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:H2` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:H3` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:H4` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:H5` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:H6` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-110 — rival-model-ladder-prechoice
- **Object:** pre-choice rival-model comparison ladder M0-M4
- **Root object:** none
- **Tier:** definition
- **Coq:** `RivalModel` (Inductive, 5 ctors), `CAN_110_ladder_index` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** Before Meaning, Before Choice (2026-09-06) §17.1
- **Occurrences (5):**
  - `22424434:(44)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(45)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(46)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(47)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return
  - `22424434:(48)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-111 — human-ai-attribution
- **Object:** Each pipeline operator stage is attributed to human, AI, or joint control
- **Root object:** none
- **Tier:** definition
- **Coq:** `AttributionLabel`, `OriginObject` (Inductive), `CAN_111_attribution` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** From Problem to Hypothesis eq.(55)-(57) [record 22307148]
- **Notes:** root_object left 'none': this is an operational bookkeeping device over the pipeline's stages, not a reading of the root through a domain.
- **Occurrences (3):**
  - `22307148:(55)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(56)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(57)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space

#### CAN-112 — decisive-record-argmax
- **Object:** decisive-record policy in argmax/argmin form
- **Root object:** decisive record
- **Tier:** hypothesis/Open (definitions of the optimization objective; not validated policies)
- **Coq:** `CAN_112_is_argmax`; `CAN_112_Open_is_argmin` (Open, un-proved) — coq tier: Definition + Open — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** RG-HCA (2026-09-06) eq.(14),(20); How Humans Should Converse with AI eq.(40)-(42)
- **Notes:** 22163849's a*_f and P* are the Standalone Scholar's own instances of the same decisive-record form, applied to artifact/proposition selection.
- **Occurrences (7):**
  - `22498047:(14)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(20)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22498047:(21)` — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)
  - `22481928:(40)-(41)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(42)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22163849:(81)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(92)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-113 — CTSA-taxonomy
- **Object:** CTSA class-workflow relation and session-boundary architecture
- **Root object:** none
- **Tier:** proposition
- **Coq:** `CTSAStage` (Inductive, 5 ctors), `CAN_113_stage_next` — coq tier: Definition — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** eq_22339909 (2026-09-05) CTSA-03, CTSA-05
- **Occurrences (2):**
  - `22339909:CTSA-03` — CTSA Human-Return Readout: A Session-Boundary Measurement Architecture for Retained Human Capability After AI (Epistemic Note v9.1 FINAL)
  - `22339909:CTSA-05` — CTSA Human-Return Readout: A Session-Boundary Measurement Architecture for Retained Human Capability After AI (Epistemic Note v9.1 FINAL)

#### CAN-114 — dialogue-open-predictions
- **Object:** Digital Yonisomanasīkāra minimal empirical predictions
- **Root object:** none
- **Tier:** hypothesis/Open
- **Coq:** `CAN_114_Open_predictions` (Open, un-proved) — coq tier: Open — `coq_canon/MRC_human_ai_reading_b.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** The Dialogue as the Ground of Enlightenment (2026-09-06) §6.2
- **Occurrences (2):**
  - `22456564:P1` — The Dialogue as the Ground of Enlightenment (uplift 2026)
  - `22456564:P2` — The Dialogue as the Ground of Enlightenment (uplift 2026)

### Domain: social

#### CAN-115 — B-SOC-LRSTEPPER
- **Object:** Finite-Memory Laplacian/Telegraph Generator as the Social-Instability/Peace Spine
- **Root object:** L_R = D_W − W / F-stepper
- **Tier:** definition (PAR-stepper); theorem [paper-internal, not Coq-verified] (L1-L4, and the earlier No-Go Theorem)
- **Coq:** `CAN_115_degree`, `CAN_115_L_R`, `CAN_115_A`, `CAN_115_step`; `CAN_115_par_stepper_moves_state` (Th_coqc witness); `CAN_115_L1_invariance_recurrence`..`CAN_115_L4_mutation` (abstract `Prop` Variables, un-proved) — coq tier: Definition (PAR-stepper, + Th_coqc witness) / Open (L1-L4) — `coq_canon/MRC_social_reading.v` — assumptions: CAN_115_par_stepper_moves_state: Closed under the global context
- **Canonical source:** record 22361830, labels PAR-stepper/L1-L4 (2026-09-05 §5 — explicitly named as 'the programme's core forces'; cites record 18383439 by title as its precursor)
- **Notes:** The strongest direct root-object hit in this group's corpus: 22361830 explicitly writes L_R=D_W−W, the exact notation Genesis's root E00.7 introduces. It converges with, and is explicitly cited as building on, record 18383439 (dated 2026-01-27, eight months earlier), which independently derives structurally the same object under different names: τ∂_tj+j=−D∇s (telegraph flux), ∂_ts=−∇·j−Γ(s)+S_env (continuity), ∂_ts=L_τs (linearized generator) — the same finite-causal-memory dissipative generator, unnamed as L_R there. 18383439's 'No-Go for Elimination by Suppression' Theorem is the more general foundational result (no bounded force-based/amplitude-only intervention can reach a globally violence-free absorbing state under sustained load); 22361830's L1-L4 sharpen this into four precise quantitative lemmas (fixed-point invariance, cost lower bound, operator-change escape route, mutation-to-neighbour). Per rule 5, these are related as 'parallels, later sharpened by' rather than merged as identical, since 18383439 is not verbatim-restated. 18383439's two-node model (7)-(8) (generator L=[[−α,ε],[ε,−β]], eigenvalues λ±) is the minimal constructive instance demonstrating L4's mutation/recurrence claim before it was proved in general form. 18383439's (9)-(12) (Γ↑, S_env↓, L_ij↓, τ↓) name the four real-world interventions (restorative justice, inequality reduction, community firewalls, truth-reconciliation) that correspond to the four distinct classes of operator-level change the lemmas distinguish. Neither paper is restated in Master River v1.4 (confirmed absent from main.tex/refs.bib per each record's own note).
- **Occurrences (18):**
  - `18383439:(1)` — Violence as a Special Case of Instability in Finite-Memory Causal Systems
  - `18383439:(2)` — Violence as a Special Case of Instability in Finite-Memory Causal Systems
  - `18383439:(3)` — Violence as a Special Case of Instability in Finite-Memory Causal Systems
  - `18383439:(4)` — Violence as a Special Case of Instability in Finite-Memory Causal Systems
  - `18383439:(5)` — Violence as a Special Case of Instability in Finite-Memory Causal Systems
  - `18383439:(6)` — Violence as a Special Case of Instability in Finite-Memory Causal Systems
  - `18383439:Theorem (No-Go for Elimination by Suppression)` — Violence as a Special Case of Instability in Finite-Memory Causal Systems
  - `18383439:(7)` — Violence as a Special Case of Instability in Finite-Memory Causal Systems
  - `18383439:(8)` — Violence as a Special Case of Instability in Finite-Memory Causal Systems
  - `18383439:(9)` — Violence as a Special Case of Instability in Finite-Memory Causal Systems
  - `18383439:(10)` — Violence as a Special Case of Instability in Finite-Memory Causal Systems
  - `18383439:(11)` — Violence as a Special Case of Instability in Finite-Memory Causal Systems
  - `18383439:(12)` — Violence as a Special Case of Instability in Finite-Memory Causal Systems
  - `22361830:PAR-stepper` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:L1` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:L2` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:L3` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:L4` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace

#### CAN-116 — B-SOC-ETHAXIOM
- **Object:** Manifested-Record & Agency-as-Substructure Axioms (Reality-as-Record, Agency-as-Choice, Collective)
- **Root object:** decisive record (+ non-collapse: agency ⊆ record, not identical to it)
- **Tier:** axiom
- **Coq:** `CAN_116_ManifestedRecord`, `CAN_116_is_agency`, `CAN_116_is_collective`; `CAN_116_axioms_satisfiable` — coq tier: Definition + Th_coqc witness — `coq_canon/MRC_social_reading.v` — assumptions: CAN_116_axioms_satisfiable: Closed under the global context
- **Canonical source:** record 18444260, labels CE-01–CE-04 (2026-01-31, the paper's own locked axioms — no later restatement found)
- **Notes:** CE-01's explicit statement — 'CE reasons only over this record, not over an ontic or complete reality' — is an independent convergence with Genesis's own readout-not-truth doctrine and root axiom E00.1/E00.2, reached from an entirely separate ethics-authored source; flagged as a convergence, not claimed as derived from Genesis.
- **Occurrences (4):**
  - `18444260:CE-01` — Causal Ethics
  - `18444260:CE-02` — Causal Ethics
  - `18444260:CE-03` — Causal Ethics
  - `18444260:CE-04` — Causal Ethics

#### CAN-117 — B-SOC-REGIME
- **Object:** Regime Structure & Update Laws (translation operator T_R, interaction operator I_R)
- **Root object:** F-stepper / domain weld q_D
- **Tier:** axiom (CE-05); law/update-law (CE-06, CE-07); definition (CE-08, the 'etic' minimal layer)
- **Coq:** `CAN_117_Regime` (Record), `CAN_117_record_updates`, `CAN_117_agency_updates`, `CAN_117_Etic`; `CAN_117_etic_satisfiable` — coq tier: Definition + Th_coqc witness — `coq_canon/MRC_social_reading.v` — assumptions: CAN_117_etic_satisfiable: Closed under the global context
- **Canonical source:** record 18444260, labels CE-05–CE-08 (2026-01-31, only occurrence)
- **Relations:** relates-to → CAN-115
- **Notes:** One of the two cleanest direct root-object hits in this group's ethics material, alongside B-SOC-LRSTEPPER: the paper's own 'update law' terminology and the F(M) shape match Genesis's stepper vocabulary independently.
- **Occurrences (4):**
  - `18444260:CE-05` — Causal Ethics
  - `18444260:CE-06` — Causal Ethics
  - `18444260:CE-07` — Causal Ethics
  - `18444260:CE-08` — Causal Ethics

#### CAN-118 — B-SOC-ETHLOAD
- **Object:** Ethical Load, Causal Memory & Spectral Margin — the Causal Ethics Inequality (locked core definition)
- **Root object:** L_R (τ_c and Δ_spec as forced stability parameters of the F/L_R system, read as ethics-admissibility tests)
- **Tier:** definition (author-labelled 'final'/locked)
- **Coq:** `CAN_118_non_increasing`, `CAN_118_Ethical`; `CAN_118_ethical_satisfiable` — coq tier: Definition + Th_coqc witness — `coq_canon/MRC_social_reading.v` — assumptions: CAN_118_ethical_satisfiable: Closed under the global context
- **Canonical source:** record 18444260, label CE-12 (2026-01-31, the book's own locked core definition — no later restatement)
- **Relations:** relates-to → CAN-135
- **Notes:** CE-10's τ_c'(R)>0 is the sharpest direct instantiation, anywhere in this group, of a specific named Genesis root axiom (E00.5) reused verbatim by symbol in an independently-authored ethics book. Δ_spec here is a different formal object from Δspec in B-SOC-CORRIG (record 22361830) — same symbol, different papers, not merged (rule 1).
- **Occurrences (6):**
  - `18444260:CE-09` — Causal Ethics
  - `18444260:CE-10` — Causal Ethics
  - `18444260:CE-11` — Causal Ethics
  - `18444260:CE-12` — Causal Ethics
  - `18444260:CE-13` — Causal Ethics
  - `18444260:CE-19` — Causal Ethics

#### CAN-119 — B-SOC-COLCONF
- **Object:** Collective/Individual Conflict, Spectral Survival, and Structural Injustice
- **Root object:** non-collapse (+ readout R for spectral projection as survival/disappearance test)
- **Tier:** definition
- **Coq:** `CAN_119_min_margin`, `CAN_119_Eth_col`, `CAN_119_Conf_ind_to_col`, `CAN_119_Conf_col_to_ind`, `CAN_119_structural_injustice`; `CAN_119_structural_injustice_satisfiable` — coq tier: Definition + Th_coqc witness — `coq_canon/MRC_social_reading.v` — assumptions: CAN_119_structural_injustice_satisfiable: Closed under the global context
- **Canonical source:** record 18444260, labels CE-21, CE-22, CE-23 as the synthetic anchors (2026-01-31, only occurrence)
- **Relations:** parallels → CAN-134
- **Notes:** CE-30's structural-injustice definition (burden-asymmetry, no intent required) parallels this group's B-SOC-RECOVLIVE/D6(NC-79) non-collapse discipline: diagnosing an asymmetry is separate from attributing responsibility for it.
- **Occurrences (11):**
  - `18444260:CE-14` — Causal Ethics
  - `18444260:CE-15` — Causal Ethics
  - `18444260:CE-16` — Causal Ethics
  - `18444260:CE-17` — Causal Ethics
  - `18444260:CE-18` — Causal Ethics
  - `18444260:CE-20` — Causal Ethics
  - `18444260:CE-21` — Causal Ethics
  - `18444260:CE-22` — Causal Ethics
  - `18444260:CE-23` — Causal Ethics
  - `18444260:CE-24` — Causal Ethics
  - `18444260:CE-30` — Causal Ethics

#### CAN-120 — B-SOC-MORALCOST
- **Object:** Moral Cost Functional, Responsibility, Karma, Cost–Survival Link, and Tragic Regimes
- **Root object:** tier ledger (accumulated retained-cost accounting) + non-collapse (the choice-gate)
- **Tier:** definition (CE-25,26,27,28,29,31,33,34, choice-gate, Tragic, Tragic-min); theorem [paper-internal, not Coq-verified] (CE-32)
- **Coq:** `CAN_120_moral_cost`, `CAN_120_Responsibility`, `CAN_120_choice_gate`, `CAN_120_Tragic`; `CAN_120_choice_gate_satisfiable`, `CAN_120_tragic_satisfiable`; `CAN_120_cost_survival_link` (abstract `Prop`, un-proved) — coq tier: Definition + Th_coqc witnesses (CE-25..31,33,34, gate, Tragic) / Open (CE-32) — `coq_canon/MRC_social_reading.v` — assumptions: CAN_120_choice_gate_satisfiable: Closed under the global context; CAN_120_tragic_satisfiable: Closed under the global context
- **Canonical source:** record 18444260, labels CE-27 (moral cost functional, the master integral) and CE-32 (Cost–Survival Link theorem) as anchors (2026-01-31, only occurrence)
- **Notes:** CE-32's Cost–Survival Link is this domain's own local analogue of a decay/stability theorem in the spirit of Genesis's RDL_SpineStability.energy_strict_decay, but independently proved within CE's own axiom set — a parallel, not a shared proof; tier is left as the paper's own 'theorem' label, never upgraded toward Th_coqc since it is not Coq-verified.
- **Occurrences (12):**
  - `18444260:CE-25` — Causal Ethics
  - `18444260:CE-26` — Causal Ethics
  - `18444260:CE-27` — Causal Ethics
  - `18444260:CE-28` — Causal Ethics
  - `18444260:CE-29` — Causal Ethics
  - `18444260:CE-31` — Causal Ethics
  - `18444260:CE-32` — Causal Ethics
  - `18444260:CE-33` — Causal Ethics
  - `18444260:CE-34` — Causal Ethics
  - `18444260:(CE-choice gate)` — Causal Ethics
  - `18444260:(Tragic)` — Causal Ethics
  - `18444260:(Tragic-min)` — Causal Ethics

#### CAN-121 — B-SOC-AGENCYHIER
- **Object:** Persistence-Control Agency Hierarchy (constrained dynamical system through reflective meta-regulation)
- **Root object:** F-stepper
- **Tier:** definition
- **Coq:** `CAN_121_ProtoAgency`, `CAN_121_StateConstraintCoupling`, `CAN_121_L3_history`, `CAN_121_L4_predictive`, `CAN_121_L5_meta`; `CAN_121_hierarchy_levels_satisfiable` — coq tier: Definition + Th_coqc witness — `coq_canon/MRC_social_reading.v` — assumptions: CAN_121_hierarchy_levels_satisfiable: Closed under the global context
- **Canonical source:** record 18897585, labels Def-1 through L5 (2026-03-07, only occurrence)
- **Notes:** A textbook confirmation of founder rule 1 ('one equation, read at different orders, is a reading not a new equation'): all five levels are the SAME generator-family read at increasing informational scope, up to L5 applying a stepper to the stepper's own generating rule (q_D∘F, one level up). The paper's own scope (biological, institutional, and artificial adaptive systems generally) is broader than the 'social' tag reflects; kept under social per this chapter's placement in the source manifest's 'Society, Power, Justice' part.
- **Occurrences (10):**
  - `18897585:Def-1` — Causal Agency: A Persistence–Control Theory of Adaptive Systems
  - `18897585:Def-2` — Causal Agency: A Persistence–Control Theory of Adaptive Systems
  - `18897585:Persistence-Regulation-Condition` — Causal Agency: A Persistence–Control Theory of Adaptive Systems
  - `18897585:Constraint-Evolution` — Causal Agency: A Persistence–Control Theory of Adaptive Systems
  - `18897585:State-Constraint-Coupling` — Causal Agency: A Persistence–Control Theory of Adaptive Systems
  - `18897585:Def-3 (Agency-Condition)` — Causal Agency: A Persistence–Control Theory of Adaptive Systems
  - `18897585:Proto-Agency-Condition` — Causal Agency: A Persistence–Control Theory of Adaptive Systems
  - `18897585:L3-Constraint-Evolution-History` — Causal Agency: A Persistence–Control Theory of Adaptive Systems
  - `18897585:L4-Constraint-Evolution-Predictive` — Causal Agency: A Persistence–Control Theory of Adaptive Systems
  - `18897585:L5-Meta-Regulation` — Causal Agency: A Persistence–Control Theory of Adaptive Systems

#### CAN-122 — belief-relation
- **Object:** Belief is a conditioned relation between an agent and a proposition, not the proposition itself; belief scale never self-promotes to epistemic status
- **Root object:** none
- **Tier:** definition / proposition (with proof)
- **Coq:** `CAN_122_BeliefVector` (Record, 7 `Q` fields), `CAN_122_Bel`, `CAN_122_update`, `CAN_122_group_belief`, `CAN_122_sigma_K`; `CAN_122_belief_scale_nonpromotion` — coq tier: Definition + Th_coqc (proved) — `coq_canon/MRC_social_reading.v` — assumptions: CAN_122_belief_scale_nonpromotion: Closed under the global context
- **Canonical source:** Readout Genesis Standalone Synthesis eq.(17)-(20), Prop-1 [record 21529456]
- **Relations:** shares-noncollapse-with → CAN-222
- **Notes:** root_object left 'none' since belief is a domain construct downstream of the spine, not itself one of the eight named Genesis root objects; its guarding non-collapse (BeliefStrength≠Distribution≠Auth≠Pow≠Val_E, eq.21) is cross-listed under non-collapse-chain.
- **Occurrences (5):**
  - `21529456:(17)` — Readout Genesis Standalone Synthesis
  - `21529456:(18)` — Readout Genesis Standalone Synthesis
  - `21529456:(19)` — Readout Genesis Standalone Synthesis
  - `21529456:(20)` — Readout Genesis Standalone Synthesis
  - `21529456:Prop-1` — Readout Genesis Standalone Synthesis

#### CAN-123 — collective-readout
- **Object:** A group's retained state and semantic readout, without positing a group mind
- **Root object:** domain weld q_D
- **Tier:** definition
- **Coq:** `CAN_123_GroupState` (Record), `CAN_123_group_readout`, `CAN_123_memory_update`; `CAN_123_memory_update_zero_signal` — coq tier: Definition + Th_coqc — `coq_canon/MRC_social_reading.v` — assumptions: CAN_123_memory_update_zero_signal: Closed under the global context
- **Canonical source:** From Problem to Hypothesis eq.(43)-(47) [record 22307148]
- **Relations:** shares-noncollapse-with → CAN-222
- **Notes:** Its non-collapse guard (institutional attraction/momentum ⇏ warrant/truth, eq.47) is cross-listed under non-collapse-chain. Direct social-domain reading of root_object domain weld q_D.
- **Occurrences (4):**
  - `22307148:(43)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(44)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(45)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(46)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space

#### CAN-124 — power-live-gap
- **Object:** recoverable live-field gap / power before choice
- **Root object:** readout R
- **Tier:** proposition
- **Coq:** `CAN_124_power_live_gap` (= `MR_Live.live_field_gap`, aliased) — coq tier: Th_coqc (reused) — `coq_canon/MRC_social_reading.v` — assumptions: CAN_124_power_live_gap: Closed under the global context
- **Canonical source:** Master Equation River v1.4 eq.(26) [choice_before_choice]
- **Occurrences (1):**
  - `22424434:(28)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-125 — DCP-relational-route
- **Object:** recommended route for personal/relational dialogue
- **Root object:** none
- **Tier:** definition
- **Coq:** `CAN_125_DCPStage` (Inductive, 5 ctors), `CAN_125_index`; `CAN_125_index_injective`, `CAN_125_route_is_strictly_ordered` — coq tier: Th_coqc — `coq_canon/MRC_social_reading.v` — assumptions: CAN_125_index_injective: Closed under the global context; CAN_125_route_is_strictly_ordered: Closed under the global context
- **Canonical source:** eq_22481928 (2026-09-06) eq.(36)
- **Occurrences (1):**
  - `22481928:(36)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-126 — OLW-falsifier
- **Object:** organizational retention falsifier condition
- **Root object:** non-collapse
- **Tier:** hypothesis/Open
- **Coq:** `CAN_126_falsifier_condition` (abstract `Prop`, un-proved) — coq tier: Open — `coq_canon/MRC_social_reading.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** Operational Linguistic Wisdom (2026-09-06) §2
- **Occurrences (1):**
  - `22456487:unlabeled (§2, falsifier condition)` — Operational Linguistic Wisdom (uplift 2026)

#### CAN-127 — OLW-propositions
- **Object:** Operational Linguistic Wisdom's eight Open propositions
- **Root object:** none
- **Tier:** hypothesis/Open
- **Coq:** `CAN_127_OLWProposition` (Inductive, 8 ctors), `CAN_127_holds` (abstract, Section-discharged) — coq tier: Open — `coq_canon/MRC_social_reading.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** Operational Linguistic Wisdom (2026-09-06) §7
- **Occurrences (8):**
  - `22456487:P1` — Operational Linguistic Wisdom (uplift 2026)
  - `22456487:P2` — Operational Linguistic Wisdom (uplift 2026)
  - `22456487:P3` — Operational Linguistic Wisdom (uplift 2026)
  - `22456487:P4` — Operational Linguistic Wisdom (uplift 2026)
  - `22456487:P5` — Operational Linguistic Wisdom (uplift 2026)
  - `22456487:P6` — Operational Linguistic Wisdom (uplift 2026)
  - `22456487:P7` — Operational Linguistic Wisdom (uplift 2026)
  - `22456487:P8` — Operational Linguistic Wisdom (uplift 2026)

#### CAN-128 — B-SOC-LIVEPOSS
- **Object:** Six-Level Live-Possibility Non-Collapse Chain (possible⊇feasible⊇live⊇chosen⊇enacted⊇observed)
- **Root object:** non-collapse (+ readout R for the threshold-defined live set and the lossy observed record)
- **Tier:** definition
- **Coq:** `CAN_128_Pi_live`, `CAN_128_live_field`, `CAN_128_is_valid_choice`, `CAN_128_live_full_nesting`, `CAN_128_enactment_may_differ_from_choice`, `CAN_128_observation_loses_information`, `CAN_128_six_level_non_collapse` (all = `MR_Live.*`, aliased) — coq tier: Th_coqc (reused) — `coq_canon/MRC_social_reading.v` — assumptions: CAN_128_live_full_nesting: Closed under the global context; CAN_128_enactment_may_differ_from_choice: Closed under the global context; CAN_128_observation_loses_information: Closed under the global context; CAN_128_six_level_non_collapse: Closed under the global context
- **Master River v1.4 eq(s):** 19, 20, 21, 22, 23, 24
- **Canonical source:** Master Equation River v1.4, eq:19–eq:24 (main.tex, 2026-09-06 — the latest formulation; source paper record 22357788 §6 'Six Levels That Must Not Collapse')
- **Relations:** relates-to → CAN-132
- **Notes:** CBC-09 (Π^live_{A,t}(g)⊆Π^feas_A(g;h,z,T,B)) is the same nesting relation applied specifically as a pre-choice restriction on the potential envelope's policy set — kept here rather than duplicated into B-SOC-POTENTIAL, and cross-referenced there. A record with the same title-adjacent content but assigned to a different canonicaliser group, 'Before Meaning, Before Choice' (record 22424434, eqs (21)-(26)), restates this identical nesting/non-collapse chain nearly verbatim — flagged for the aggregation pass, not independently clustered here since 22424434 is outside this group's registry scope.
- **Occurrences (7):**
  - `22357788:CBC-01` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-05` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-06` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-02` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-03` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-04` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-09` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems

#### CAN-129 — B-SOC-NCLIST
- **Object:** Non-Collapse Constitutive List (the 17 role-separations the live-possibility architecture depends on)
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `CAN_129_NCItem` (Inductive, 17 ctors), `CAN_129_index`; `CAN_129_index_injective` — coq tier: Th_coqc — `coq_canon/MRC_social_reading.v` — assumptions: CAN_129_index_injective: Closed under the global context
- **Canonical source:** record 22357788, label CBC-16 (2026-09-05, §15 — supersedes/subsumes CBC-07 and CBC-15 as two of its 17 items)
- **Relations:** relates-to → CAN-128; relates-to → CAN-015
- **Notes:** CBC-07 ('Resonance≠Consent, Resonance≠Truth') and CBC-15 ('more live accessibility≠better agency; more fluent choice≠better choice') are each individually-stated instances that CBC-16's own fuller list restates as line items — the paper's own meaning_note flags this overlap with the six-level chain (B-SOC-LIVEPOSS) as thematic, not identical.
- **Occurrences (3):**
  - `22357788:CBC-16` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-07` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-15` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems

#### CAN-130 — B-SOC-MEANPROP
- **Object:** Meaning-Shaped Practical Possibility: five core propositions (P1-P5)
- **Root object:** readout R (meaning-relation as what determines whether an option enters the domain readout at all)
- **Tier:** proposition
- **Coq:** `CAN_130_MeanPropItem` (Inductive, 5 ctors), `CAN_130_holds` (abstract, Section-discharged) — coq tier: Open — `coq_canon/MRC_social_reading.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** record 22357788, labels CBC-P1–CBC-P5 (2026-09-05 §5, only occurrence)
- **Relations:** relates-to → CAN-128; relates-to → CAN-015
- **Notes:** Prose propositions, not formal equations; tagged readout R only loosely — they motivate why B-SOC-LIVEPOSS's threshold τ_live is meaning-dependent, not a universal constant.
- **Occurrences (5):**
  - `22357788:CBC-P1` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-P2` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-P3` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-P4` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-P5` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems

#### CAN-131 — B-SOC-LIVEHYP
- **Object:** Live-Field Empirical Programme: eight falsifiable hypotheses (H1-H8)
- **Root object:** none
- **Tier:** hypothesis/Open
- **Coq:** `CAN_131_LiveHyp` (Inductive, 8 ctors), `CAN_131_holds` (abstract, Section-discharged) — coq tier: Open — `coq_canon/MRC_social_reading.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** record 22357788, labels CBC-H1–CBC-H8 (2026-09-05 §16, only occurrence)
- **Notes:** Kept as one cluster (an empirical programme, not a single object) rather than eight singletons, per the collapse instruction; none is claimed as forced from the Genesis root.
- **Occurrences (8):**
  - `22357788:CBC-H1` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-H2` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-H3` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-H4` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-H5` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-H6` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-H7` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22357788:CBC-H8` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems

#### CAN-132 — B-SOC-POTENTIAL
- **Object:** Potential as a Witnessed Readout (corrigible agency potential p*, over the witnessed set)
- **Root object:** readout R_{Q,O,c}(S)=z≠S
- **Tier:** definition
- **Coq:** `CAN_132_p_star`, `CAN_132_p_star_upper_bound` (= `MR_Live.*`, aliased) — coq tier: Th_coqc (reused) — `coq_canon/MRC_social_reading.v` — assumptions: CAN_132_p_star_upper_bound: Closed under the global context
- **Master River v1.4 eq(s):** 25
- **Canonical source:** Master Equation River v1.4, eq:25 (main.tex, 2026-09-06) = record 22361830 labels (1)-(3)+unnumbered (2026-09-05, version 2 'tier-raising pass')
- **Relations:** relates-to → CAN-137
- **Notes:** CBC-08 (record 22357788, older feasible-set form p*_{A,g}=max_{π∈Π^feas_A(g)}Pr(...)) is the superseded formulation; Master River's own FixBox states v1.0 used exactly this Π^feas form, since replaced by the witnessed-set Π^wit form here — the central claim (D2, cluster B-SOC-SEVENDIST) is that a supremum over a set with no record is not a readout. Kept as one cluster per rule 2 (canonical=latest) rather than two, with the older form explicitly marked superseded, not deleted.
- **Occurrences (5):**
  - `22357788:CBC-08` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems
  - `22361830:(1)` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:(2)` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:(3)` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:unnumbered` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace

#### CAN-133 — B-SOC-RECOVENV
- **Object:** Recoverable Envelope Gap (Layer-2 potential minus Layer-1, on the probability envelope)
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN_133_p_star2`, `CAN_133_recoverable_gap`; `CAN_133_recoverable_gap_nonneg` — coq tier: Th_coqc — `coq_canon/MRC_social_reading.v` — assumptions: CAN_133_recoverable_gap_nonneg: Closed under the global context
- **Canonical source:** record 22361830, labels (4)-(5) (2026-09-05, only occurrence — not restated in Master River v1.4)
- **Relations:** relates-to → CAN-134; relates-to → CAN-137
- **Notes:** Parallels but is NOT the same object as B-SOC-RECOVLIVE ('recoverable live-field gap', a distance on the policy field, not a probability-envelope difference) — per founder rule 5 the two 'recoverable gap' objects are kept distinct rather than merged, since they measure different latents (achievable probability vs. achievable policy-field distance) even though both are named 'recoverable gap' in their source papers. D3/D7 in B-SOC-SEVENDIST are the formal non-collapse statements distinguishing Layer-1 from Layer-2 and recoverable gap from accumulated loss for this object.
- **Occurrences (2):**
  - `22361830:(4)` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:(5)` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace

#### CAN-134 — B-SOC-RECOVLIVE
- **Object:** Recoverable Live-Field Gap (distance-based, on the possibility field)
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN_134_live_field_gap` (= `MR_Live.live_field_gap`, aliased); `CAN_134_gap_nonneg` (fresh Th_coqc) — coq tier: Th_coqc (reused + fresh witness) — `coq_canon/MRC_social_reading.v` — assumptions: CAN_134_gap_nonneg: Closed under the global context; CAN_134_live_field_gap: Closed under the global context
- **Master River v1.4 eq(s):** 26
- **Canonical source:** Master Equation River v1.4, eq:26 (main.tex, 2026-09-06) = record 22357788, label CBC-10 (2026-09-05 §11)
- **Relations:** parallels → CAN-137
- **Notes:** Master River's own commentary (NC-79) states this gap is diagnosis-only: calling it structural deprivation/violence still requires a feasible counterfactual and an independent normative loss, and identifying who is responsible is a separate act from diagnosing the narrowing — this is directly the same non-collapse move as D6/NC-79 in B-SOC-SEVENDIST. Thematically parallels the qualitative 'violence as possibility compression' framing of record 18925131 (Causal Grammar of Structured Coexistence), which has no formal equations of its own (root_object: none; prose typology only, not independently clustered).
- **Occurrences (1):**
  - `22357788:CBC-10` — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems

#### CAN-135 — B-SOC-CORRIG
- **Object:** Corrigibility / Spectral-Support Readout Condition
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN_135_Channel` (Inductive), `CAN_135_corrigible`; `CAN_135_corrigible_satisfiable` — coq tier: Th_coqc — `coq_canon/MRC_social_reading.v` — assumptions: CAN_135_corrigible_satisfiable: Closed under the global context
- **Canonical source:** record 22361830, label (6) (2026-09-05, only occurrence)
- **Relations:** relates-to → CAN-118; relates-to → CAN-015
- **Notes:** Uses the symbol Δspec also used, with a different formal meaning, in Causal Ethics' Δ_spec(R)>0 spectral stability margin (B-SOC-ETHLOAD, record 18444260 CE-11) — same symbol, different declared object in a different paper; per rule 1 ('cluster by object+relation, never by notation') these are NOT merged, only flagged as a naming collision for the aggregation pass.
- **Occurrences (1):**
  - `22361830:(6)` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace

#### CAN-136 — B-SOC-PSEUDOPEACE
- **Object:** Pseudo-Peace Gate-Collapse Signature
- **Root object:** non-collapse
- **Tier:** definition; falsifiable proposition P-A tests it, tier hypothesis/Open
- **Coq:** `CAN_136_Observation`, `CAN_136_ChannelStatus` (Inductive), `CAN_136_pseudo_peace_signature`; `CAN_136_pseudo_peace_satisfiable`; `CAN_136_P_A_falsification_test` (abstract `Prop`, un-proved) — coq tier: Definition + Th_coqc witness / Open (P-A) — `coq_canon/MRC_social_reading.v` — assumptions: CAN_136_pseudo_peace_satisfiable: Closed under the global context
- **Canonical source:** record 22361830, label (7) (2026-09-05, only occurrence)
- **Notes:** Direct social-domain instance of readout-not-truth: the evaluator's calm readout is explicitly not accepted as evidence of low compression unless the potential and feedback-channel readouts are checked independently.
- **Occurrences (2):**
  - `22361830:(7)` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:P-A` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace

#### CAN-137 — B-SOC-SEVENDIST
- **Object:** Seven Distinctions Anatomy of 'Potential' (D1-D7)
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `CAN_137_Distinction` (Inductive, 7 ctors), `CAN_137_index`; `CAN_137_index_injective` — coq tier: Th_coqc — `coq_canon/MRC_social_reading.v` — assumptions: CAN_137_index_injective: Closed under the global context
- **Canonical source:** record 22361830, labels D1-D7 (2026-09-05 §3, only occurrence)
- **Relations:** relates-to → CAN-132; relates-to → CAN-134; relates-to → CAN-133; relates-to → CAN-138
- **Notes:** D2 is the formal justification for B-SOC-POTENTIAL's move from a declared/feasible set to the witnessed set (Master River's FixBox on eq:25). D3 is the definitional split behind B-SOC-POTENTIAL vs B-SOC-RECOVENV's layer-1/layer-2 distinction, tested by proposition P-D (B-SOC-FALSIF). D6 (NC-79) and D7 are the same non-collapse content Master River's own prose repeats verbatim around eq:26 (B-SOC-RECOVLIVE).
- **Occurrences (7):**
  - `22361830:D1 (NC-78)` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:D2` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:D3` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:D4` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:D5` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:D6 (NC-79)` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:D7` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace

#### CAN-138 — B-SOC-FALSIF
- **Object:** Falsifiable Propositions Testing the Potential-Readout Architecture (P-B, P-C, P-D)
- **Root object:** none
- **Tier:** hypothesis/Open
- **Coq:** `CAN_138_Falsif` (Inductive, 3 ctors), `CAN_138_holds` (abstract, Section-discharged) — coq tier: Open — `coq_canon/MRC_social_reading.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** record 22361830, labels P-B–P-D (2026-09-05 §8, only occurrence)
- **Relations:** relates-to → CAN-136
- **Notes:** P-A (the pseudo-peace falsification test) is kept with B-SOC-PSEUDOPEACE instead, since it tests that specific signature directly.
- **Occurrences (3):**
  - `22361830:P-B` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:P-C` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace
  - `22361830:P-D` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace

#### CAN-139 — B-SOC-IDCERT
- **Object:** Identifiability Certificate (exact non-identifiability worked example)
- **Root object:** readout R
- **Tier:** measurement
- **Coq:** `CAN_139_identifiability_certificate` — coq tier: Th_coqc (fully computed on `Q`) — `coq_canon/MRC_social_reading.v` — assumptions: CAN_139_identifiability_certificate: Closed under the global context
- **Canonical source:** record 22361830, label PAR-cert (2026-09-05 §4.5, only occurrence)
- **Notes:** The single sharpest, most concrete instance in this group's corpus of Genesis's own readout-not-truth discipline stated as a checkable numeric fact rather than a slogan.
- **Occurrences (1):**
  - `22361830:PAR-cert` — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace

### Domain: world-system

#### CAN-140 — labour-claim-chain
- **Object:** industrial and post-labour claim chains
- **Root object:** none
- **Tier:** definition
- **Coq:** `LabourClaimStage` (Inductive, 5 ctors), `CAN_140_labour_claim_next` — coq tier: Definition — `coq_canon/MRC_world_system_reading.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** After Labour (2026-09-06) §1, §21
- **Occurrences (2):**
  - `22481924:(1)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(51)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-141 — epistemic-firewall-validation
- **Object:** minimal epistemic firewall for machine candidate generation
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `CAN_141_Z_next`, `CAN_141_valid_validation_rate` — coq tier: Definition — `coq_canon/MRC_world_system_reading.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** After Labour (2026-09-06) eq.(3)
- **Occurrences (1):**
  - `22481924:(3)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-142 — machine-capacity-block
- **Object:** embodied automation and machine productive-capacity block
- **Root object:** none
- **Tier:** definition/identity
- **Coq:** `CAN_142_B_RB`, `CAN_142_M_index`, `CAN_142_rho_CES`, `CAN_142_labour_share`; `CAN_142_B_RB_identity` — coq tier: Definition + Th_coqc (trivial identity) — `coq_canon/MRC_world_system_reading.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** After Labour (2026-09-06) eq.(5)-(7),(9)-(10)
- **Occurrences (5):**
  - `22481924:(5)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(6)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(7)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(9)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(10)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-143 — labour-centrality
- **Object:** four-dimensional labour centrality
- **Root object:** none
- **Tier:** definition
- **Coq:** `CAN_143_LabourCentrality`, `CAN_143_mk_labour_centrality` (= `MR_WorldSystem`) — coq tier: Definition — `coq_canon/MRC_world_system_reading.v` — assumptions: n/a (Definition, not a proof obligation)
- **Master River v1.4 eq(s):** 53
- **Canonical source:** Master Equation River v1.4 eq.(53) [after_labour]
- **Occurrences (2):**
  - `22481924:(8)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:Labour-Decentering Proposition` — After Labour: Human Position in an AI-Robotic World System

#### CAN-144 — claim-constitution
- **Object:** the claim constitution: from wages to citizen claims
- **Root object:** none
- **Tier:** definition/identity
- **Coq:** `CAN_144_q_min`, `CAN_144_citizen_claim_threshold_identity` (= `MR_WorldSystem`); `CAN_144_convex_combine`, `CAN_144_convex_combine_identity`, `CAN_144_q_t`, `CAN_144_Gamma_t` — coq tier: Th_coqc — `coq_canon/MRC_world_system_reading.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Master River v1.4 eq(s):** 54
- **Canonical source:** Master Equation River v1.4 eq.(54) [after_labour]
- **Occurrences (5):**
  - `22481924:(11)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(12)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(13)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(14)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(15)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-145 — demand-realization
- **Object:** aggregate demand, realization, and profit-wealth feedback
- **Root object:** none
- **Tier:** definition/identity
- **Coq:** `CAN_145_AD`, `CAN_145_chi_dem`, `CAN_145_Pi_M`; `CAN_145_chi_dem_le_one` — coq tier: Th_coqc — `coq_canon/MRC_world_system_reading.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** After Labour (2026-09-06) eq.(22)-(25),(55)
- **Occurrences (5):**
  - `22481924:(22)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(23)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(24)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(25)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(55)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-146 — ownership-accumulation
- **Object:** ownership stock accumulation and its non-collapse from redistribution
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `CAN_146_ownership_accumulate`, `CAN_146_ownership_share`; `CAN_146_redistribution_not_ownership_reproduction` — coq tier: Th_coqc — `coq_canon/MRC_world_system_reading.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** After Labour (2026-09-06) eq.(16)-(18)
- **Occurrences (3):**
  - `22481924:(16)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(17)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(18)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-147 — scarce-asset-rent
- **Object:** scarce-asset rent burden and effective material claim
- **Root object:** non-collapse
- **Tier:** definition/identity
- **Coq:** `CAN_147_B_scarce`, `CAN_147_Gamma_eff`; `CAN_147_abundance_not_low_burden_not_freedom` — coq tier: Th_coqc — `coq_canon/MRC_world_system_reading.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** After Labour (2026-09-06) eq.(19)-(21)
- **Occurrences (3):**
  - `22481924:(19)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(20)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(21)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-148 — conversion-gates
- **Object:** conversion-gate control, credible exit, and dependency exposure
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `CAN_148_G_conv`, `CAN_148_Dependency`; `CAN_148_concentration_not_dependency` — coq tier: Th_coqc — `coq_canon/MRC_world_system_reading.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** After Labour (2026-09-06) eq.(26)-(29),(53)
- **Occurrences (5):**
  - `22481924:(26)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(27)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(28)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(29)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(53)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-149 — relational-class-position
- **Object:** relational class position vector
- **Root object:** none
- **Tier:** definition
- **Coq:** `RelationalClassPosition` (Record, 7 fields), `CAN_149_mk_relational_class_position` — coq tier: Definition — `coq_canon/MRC_world_system_reading.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** After Labour (2026-09-06) eq.(30)
- **Occurrences (1):**
  - `22481924:(30)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-150 — pe-to-human-bridge
- **Object:** the political-economy-to-human bridge mechanism
- **Root object:** none
- **Tier:** definition
- **Coq:** `CAN_150_pe_to_human_bridge` — coq tier: Definition — `coq_canon/MRC_world_system_reading.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** After Labour (2026-09-06) eq.(31)
- **Occurrences (1):**
  - `22481924:(31)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-151 — human-systemic-position
- **Object:** Human Systemic Position typed audit index
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `CAN_151_P_H_index`, `CAN_151_output_rise_not_position_rise` (= `MR_WorldSystem`) — coq tier: Th_coqc — `coq_canon/MRC_world_system_reading.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Master River v1.4 eq(s):** 58, 59
- **Canonical source:** Master Equation River v1.4 eq.(58)-(59) [after_labour]
- **Occurrences (6):**
  - `22481924:(40)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(41)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(42)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(43)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(44)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(57)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-152 — social-role-standing
- **Object:** recognized social role/standing dynamic and time-budget identity
- **Root object:** none
- **Tier:** definition/identity
- **Coq:** `CAN_152_S_H_next`, `CAN_152_time_budget_valid`; `CAN_152_time_budget_satisfiable` — coq tier: Th_coqc — `coq_canon/MRC_world_system_reading.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** After Labour (2026-09-06) eq.(36)-(37)
- **Occurrences (2):**
  - `22481924:(36)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(37)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-153 — social-reproduction
- **Object:** social reproduction dynamic and its non-collapse from productive necessity
- **Root object:** non-collapse
- **Tier:** definition/hypothesis-Open (dynamic sign explicitly left open)
- **Coq:** `CAN_153_H_cap_next`; `CAN_153_Open_dynamic_sign` (Open, un-proved); `CAN_153_productive_not_social_necessity_witness` (= generic) — coq tier: Th_coqc + Open — `coq_canon/MRC_world_system_reading.v` — assumptions: Th_coqc component: Closed under the global context (family blanket check, see LEDGER summary); Open component: n/a, not proved by design
- **Canonical source:** After Labour (2026-09-06) eq.(38)-(39),(56)
- **Occurrences (3):**
  - `22481924:(38)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(39)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(56)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-154 — power-channels
- **Object:** three-channel power vector and recursive political-economy loops
- **Root object:** non-collapse
- **Tier:** definition/hypothesis-Open
- **Coq:** `PowerVector`, `CAN_154_mk_power_vector`; `CAN_154_Open_not_predetermined` (Open, un-proved); `CAN_154_channel_noncollapse_witness` (= generic) — coq tier: Th_coqc + Open — `coq_canon/MRC_world_system_reading.v` — assumptions: Th_coqc component: Closed under the global context (family blanket check, see LEDGER summary); Open component: n/a, not proved by design
- **Canonical source:** After Labour (2026-09-06) eq.(45)-(50)
- **Occurrences (6):**
  - `22481924:(45)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(46)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(47)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(48)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(49)` — After Labour: Human Position in an AI-Robotic World System
  - `22481924:(50)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-155 — early-warning-diagnostic
- **Object:** normalized decoupling-pressure early-warning diagnostic
- **Root object:** none
- **Tier:** measurement
- **Coq:** `CAN_155_Omega` — coq tier: Definition — `coq_canon/MRC_world_system_reading.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** After Labour (2026-09-06) eq.(52)
- **Occurrences (1):**
  - `22481924:(52)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-156 — after-labour-river-summary
- **Object:** After Labour's own standalone river summary
- **Root object:** none
- **Tier:** definition
- **Coq:** `AfterLabourRiverStage` (Inductive, 22 ctors), `CAN_156_after_labour_river_next` — coq tier: Definition — `coq_canon/MRC_world_system_reading.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** After Labour (2026-09-06) eq.(54)
- **Occurrences (1):**
  - `22481924:(54)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-157 — corrigible-agency-worldsystem
- **Object:** corrigible agency envelope at world-system scale
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN_157_corrigible_agency_ws`, `CAN_157_corrigible_agency_ws_upper_bound` (= `MR_WorldSystem`) — coq tier: Th_coqc — `coq_canon/MRC_world_system_reading.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Master River v1.4 eq(s):** 56
- **Canonical source:** Master Equation River v1.4 eq.(56) [after_labour eq.34]
- **Relations:** relates-to → CAN-060
- **Notes:** Parallels, not identical to, corrigible-agency-witnessed (eq.25) — Master River explicitly notes this is a different set.
- **Occurrences (1):**
  - `22481924:(34)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-158 — human-return-worldsystem
- **Object:** Human Return tuple at world-system scale
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `CAN_158_ReturnProfileWS`, `CAN_158_mk_return_profile_ws` (= `MR_WorldSystem`) — coq tier: Definition — `coq_canon/MRC_world_system_reading.v` — assumptions: n/a (Definition, not a proof obligation)
- **Master River v1.4 eq(s):** 57
- **Canonical source:** Master Equation River v1.4 eq.(57) [after_labour eq.35]
- **Relations:** relates-to → CAN-077
- **Notes:** Parallels human-return-CTSA4/CTSA6 but After Labour explicitly does not assert instrument identity (founder rule 5: distinct objects, related).
- **Occurrences (1):**
  - `22481924:(35)` — After Labour: Human Position in an AI-Robotic World System

#### CAN-159 — human-conversion-vector
- **Object:** Human Conversion Vector and elasticity
- **Root object:** non-collapse
- **Tier:** definition (elasticities/thresholds require per-study declaration)
- **Coq:** `CAN_159_machine_expansion_not_human_expansion`, `CAN_159_HumanConversionVector`, `CAN_159_mk_human_conversion_vector`, `CAN_159_eta_HC` (= `MR_WorldSystem`) — coq tier: Th_coqc — `coq_canon/MRC_world_system_reading.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Master River v1.4 eq(s):** 60, 61, 62
- **Canonical source:** Master Equation River v1.4 eq.(60)-(62) [human_conversion_imperative]
- **Occurrences (7):**
  - `22481926:(1)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(11)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(12)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(13)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:Proposition 1` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(25)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(26)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World

#### CAN-160 — conversion-noncollapse-bundle
- **Object:** Human Conversion Imperative's ten non-collapse separations
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `CAN_160_separation`; `CAN_160_all_separations_satisfiable` (= generic, ∀-quantified) — coq tier: Th_coqc — `coq_canon/MRC_world_system_reading.v` — assumptions: Closed under the global context (family blanket check, see LEDGER summary)
- **Canonical source:** The Human Conversion Imperative (2026-09-06) §4
- **Relations:** parallels → CAN-074; relates-to → CAN-151; relates-to → CAN-146; relates-to → CAN-153; parallels → CAN-062; relates-to → CAN-079; relates-to → CAN-057; relates-to → CAN-148
- **Notes:** Each separation parallels an existing shared cluster (K_like-noncollapse, assisted-vs-return-noncollapse, outcome-vector-J*, live-possibility, conversion-gates, ownership-accumulation, human-systemic-position, social-reproduction) restated in HCI's own framing; kept as HCI's own bundled record.
- **Occurrences (9):**
  - `22481926:(2)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(3)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(4)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(5)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(6)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(7)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(8)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(9)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(10)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World

#### CAN-161 — epistemic-conversion-mechanism
- **Object:** high- vs low-conversion interaction forms
- **Root object:** F-stepper
- **Tier:** definition/hypothesis-Open (Proposition 2 Open)
- **Coq:** `HighConversionStage`/`CAN_161_high_conversion_next`, `LowConversionStage`/`CAN_161_low_conversion_next`; `CAN_161_Open_proposition2_max_assistance_max_conversion` (Open, un-proved) — coq tier: Definition + Open — `coq_canon/MRC_world_system_reading.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** The Human Conversion Imperative (2026-09-06) §6, §15
- **Occurrences (4):**
  - `22481926:(14)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(15)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:Proposition 2` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(24)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World

#### CAN-162 — bad-mode-state
- **Object:** Bad-Mode State Vector
- **Root object:** none
- **Tier:** definition
- **Coq:** `BadModeState` (Record, 9 fields), `CAN_162_mk_bad_mode_state` — coq tier: Definition — `coq_canon/MRC_world_system_reading.v` — assumptions: n/a (Definition, not a proof obligation)
- **Canonical source:** The Human Conversion Imperative (2026-09-06) §7
- **Occurrences (1):**
  - `22481926:(16)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World

#### CAN-163 — reversibility-window-urgency
- **Object:** Reversibility Window and Urgency Vector
- **Root object:** none
- **Tier:** definition (Reversibility Principle itself [Open])
- **Coq:** `CAN_163_reversibility_window`, `CAN_163_in_reversibility_window`, `CAN_163_urgency_term` (= `MR_WorldSystem`); `CAN_163_Open_reversibility_principle` (Open, un-proved) — coq tier: Definition + Open — `coq_canon/MRC_world_system_reading.v` — assumptions: n/a (Open Prop, not proved by design)
- **Master River v1.4 eq(s):** 63, 64
- **Canonical source:** Master Equation River v1.4 eq.(63)-(64) [human_conversion_imperative]
- **Occurrences (6):**
  - `22481926:(17)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:Proposition 3` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(18)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(19)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(20)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(21)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World

#### CAN-164 — distributional-conversion
- **Object:** distributional readouts of conversion
- **Root object:** readout R
- **Tier:** definition (Proposition 4 Open)
- **Coq:** `CAN_164_I_H`; `CAN_164_Open_proposition4_broad_expansion` (Open, un-proved) — coq tier: Definition + Open — `coq_canon/MRC_world_system_reading.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** The Human Conversion Imperative (2026-09-06) §10
- **Occurrences (3):**
  - `22481926:(22)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:(23)` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World
  - `22481926:Proposition 4` — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World

### Domain: method

#### CAN-165 — readout-factorization-admissibility
- **Object:** When may a downstream distinction be credited to a given readout: fiber constancy, factorization, and stochastic composition
- **Root object:** readout R
- **Tier:** proposition (with proof, e.g. Factorization Theorem) / definition
- **Coq:** `CAN165_admissible`; `CAN165_g_of`; `CAN165_factorization_thm`; `CAN165_data_processing_inequality_Open`; `CAN165_source_relation_may_differ_from_model` — coq tier: Th_coqc / Open — `coq_canon/MRC_method_reading_a.v` — assumptions: `mr_factorization_thm`, `CAN165_source_relation_may_differ_from_model`: Closed under the global context; Open Prop not proved
- **Canonical source:** The Readout Condition eq.(5)-(9), Prop-1, Princ-4, Prop-2, (10)-(14), (19)-(22), (31)-(32) [record 22301318]
- **Relations:** relates-to → CAN-011; relates-to → CAN-010
- **Notes:** Singleton-chapter cluster (no cross-paper duplicate found in this group's scan). Relates to readout-operator (same root object, this is its composability machinery) and to source-provenance-readout (same paper, parallel apparatus).
- **Occurrences (20):**
  - `22301318:(5)` — The Readout Condition
  - `22301318:(6)` — The Readout Condition
  - `22301318:Def-1` — The Readout Condition
  - `22301318:(7)` — The Readout Condition
  - `22301318:Prop-1` — The Readout Condition
  - `22301318:Princ-4` — The Readout Condition
  - `22301318:(8)` — The Readout Condition
  - `22301318:(9)` — The Readout Condition
  - `22301318:Prop-2` — The Readout Condition
  - `22301318:(10)` — The Readout Condition
  - `22301318:(11)` — The Readout Condition
  - `22301318:(12)` — The Readout Condition
  - `22301318:(13)` — The Readout Condition
  - `22301318:(14)` — The Readout Condition
  - `22301318:(19)` — The Readout Condition
  - `22301318:(20)` — The Readout Condition
  - `22301318:(21)` — The Readout Condition
  - `22301318:(22)` — The Readout Condition
  - `22301318:(31)` — The Readout Condition
  - `22301318:(32)` — The Readout Condition

#### CAN-166 — rival-model-ladder-experience
- **Object:** A preregistered rival-model ladder any readout-retention theory must beat
- **Root object:** tier ledger
- **Tier:** hypothesis/Open
- **Coq:** `CAN166_RivalModel`; `CAN166_must_beat_ladder_Open` — coq tier: Definition / Open — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a (Definition; Open Prop not proved)
- **Canonical source:** Experience Is Meaning-Giving eq.(EMG-28) [record 22357744]
- **Relations:** relates-to → CAN-031; relates-to → CAN-033
- **Notes:** Relates to knowledge-admission's warrant/evidentiary-standard machinery and to tier-ledger's provenance-labeling discipline.
- **Occurrences (1):**
  - `22357744:EMG-28` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release

#### CAN-167 — problem-formation
- **Object:** A problem is a retained residual requiring explanation, repair, or decision; a question selects a contrast from it
- **Root object:** F-stepper
- **Tier:** definition
- **Coq:** `CAN167_residual`; `CAN167_cost`; `CAN167_problem`; `CAN167_question_selects` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a
- **Canonical source:** From Problem to Hypothesis eq.(3)-(5) [record 22307148]
- **Relations:** relates-to → CAN-168; relates-to → CAN-169
- **Notes:** Feeds directly into discovery-accessibility and discovery-first-passage below.
- **Occurrences (3):**
  - `22307148:(3)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(4)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(5)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space

#### CAN-168 — discovery-accessibility
- **Object:** Reachability is not accessibility: a weighted, history-shaped access kernel over the semantic/hypothesis graph, distinct from bare graph reachability
- **Root object:** F-stepper
- **Tier:** definition / proposition (non-collapse) / measurement (candidate signature)
- **Coq:** `CAN168_path_prob`; `CAN168_reachable`; `CAN168_high`; `CAN168_positive_but_not_high` — coq tier: Definition / Th_coqc — `coq_canon/MRC_method_reading_a.v` — assumptions: `CAN168_positive_but_not_high`: Closed under the global context
- **Canonical source:** From Problem to Hypothesis eq.(15)-(18), (23)-(26) [record 22307148]
- **Relations:** shares-noncollapse-with → CAN-222
- **Notes:** Its non-collapse guard (eq.18, reachable≠accessible) is cross-listed under non-collapse-chain.
- **Occurrences (10):**
  - `22307148:(15)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(16)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(17)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(23)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(24)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(25)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(26)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(27)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(28)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(29)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space

#### CAN-169 — discovery-first-passage
- **Object:** Discovery time and direction as a first-passage stopping time over a readout-discriminable hypothesis space
- **Root object:** F-stepper
- **Tier:** definition / hypothesis-Open (central proposal H1/H2)
- **Coq:** `CAN169_first_hit`; `CAN169_tau_U_bounded`; `CAN169_tau_U_unbounded_Open`; `CAN169_usable_ne_actually_true` — coq tier: Definition / Open — `coq_canon/MRC_method_reading_a.v` — assumptions: `CAN169_usable_ne_actually_true`: Closed under the global context; unbounded Open Prop not proved
- **Canonical source:** Knowledge Topology and the First Passage to Usable Hypotheses, full apparatus [record 22307561]; the readout-discriminable hypothesis space H^disc it presupposes is defined in From Problem to Hypothesis eq.(34)-(37),(52)-(54)
- **Relations:** shares-noncollapse-with → CAN-222
- **Notes:** Cross-group duplicate confirmed by skim outside this group's 14 primary records: eq.(14) of record 22307561 (G^K ⇒ (L(τ_U), π^first)) is quoted verbatim as eq.(19) in record 22308072 ('The Epistemic Chain Reaction'), and eq.(4) of 22307561 reappears as eq.(4) in 22308066 ('State of Evidence for the Readout Hypothesis-Generation Programme') — flagged for whichever canonicaliser group owns those two chapters. Its non-collapse guard (usable≠true, T_U↓⇏W(H)↑⇏truth) is cross-listed under non-collapse-chain.
- **Occurrences (19):**
  - `22307561:(1)` — Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discovery Time and Direction
  - `22307561:(2)-(3)` — Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discovery Time and Direction
  - `22307561:(5)` — Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discovery Time and Direction
  - `22307561:(6)` — Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discovery Time and Direction
  - `22307561:(7)` — Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discovery Time and Direction
  - `22307561:(8)` — Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discovery Time and Direction
  - `22307561:H1` — Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discovery Time and Direction
  - `22307561:H2` — Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discovery Time and Direction
  - `22307561:(9)` — Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discovery Time and Direction
  - `22307561:(10)` — Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discovery Time and Direction
  - `22307561:(11)` — Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discovery Time and Direction
  - `22307561:(13)` — Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discovery Time and Direction
  - `22307561:(14)` — Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discovery Time and Direction
  - `22307148:(34)-(35)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(36)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(37)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(52)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(53)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(54)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space

#### CAN-170 — discriminating-action-loop
- **Object:** A discriminating action, its returned record, and the revision it drives
- **Root object:** F-stepper
- **Tier:** definition
- **Coq:** `CAN170_discriminating`; `CAN170_local_residual` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a
- **Canonical source:** From Problem to Hypothesis eq.(48)-(51) [record 22307148]
- **Relations:** relates-to → CAN-053
- **Notes:** Parallels Readout Genesis Standalone Synthesis's interruptibility/repair apparatus (eq.73-79, filed under meta-readout-governance) as an independently-formalized instance of the same 'act, observe, revise' pattern — relation: 'parallels'.
- **Occurrences (4):**
  - `22307148:(48)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(49)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(50)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(51)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space

#### CAN-171 — provenance-ledger
- **Object:** per-transition provenance/tier/defect/reader/falsifier ledger
- **Root object:** tier ledger
- **Tier:** definition
- **Coq:** `CAN171_LedgerEntry` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a
- **Canonical source:** Before Meaning, Before Choice (2026-09-06) eq.(41), restating Operational Linguistic Wisdom (2026-09-06) §5.1
- **Occurrences (2):**
  - `22456487:unlabeled (§5.1, provenance ledger)` — Operational Linguistic Wisdom (uplift 2026)
  - `22424434:(41)` — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

#### CAN-172 — DCP-status-categories
- **Object:** provenance-ledger status categories
- **Root object:** tier ledger
- **Tier:** definition
- **Coq:** `CAN172_Status` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a
- **Canonical source:** eq_22481928 (2026-09-06) eq.(39)
- **Relations:** relates-to → CAN-171
- **Notes:** Relates to (does not merge with) the provenance-ledger cluster's Λ(e_i) tuple — a coarser categorical version of the same discipline.
- **Occurrences (1):**
  - `22481928:(39)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-173 — credit-provenance-goodhart
- **Object:** Provenance Relevance Constraint and gated valid credit
- **Root object:** tier ledger
- **Tier:** governance definition
- **Coq:** `CAN173_valid_term`; `CAN173_C_valid`; `CAN173_C_raw`; `CAN173_term_le`; `CAN173_valid_le_raw` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_a.v` — assumptions: Both lemmas: Closed under the global context
- **Canonical source:** The Standalone Scholar (2026-08-29) §10
- **Occurrences (2):**
  - `22163849:(49)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(50)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-174 — tier-ledger-invariant
- **Object:** ClaimStrength ≤ EvidenceStrength invariant
- **Root object:** tier ledger
- **Tier:** governance definition
- **Coq:** `CAN174_invariant`; `CAN174_invariant_refl` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: `CAN174_invariant_refl`: Closed under the global context
- **Canonical source:** The Standalone Scholar (2026-08-29) §14
- **Relations:** relates-to → CAN-033
- **Notes:** This is the Standalone Scholar's own explicit statement of the tier-ledger root object's governing rule (definition/Dr/Open/finite_diagnostic/fit_calibrated/machine-checked tiers), consistent with founder rule 4.
- **Occurrences (1):**
  - `22163849:(68)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-175 — k2-procurement
- **Object:** K2 procurement cost and yield heuristics
- **Root object:** decisive record
- **Tier:** governance definition
- **Coq:** `CAN175_cost_k2`; `CAN175_expected_yield`; `CAN175_effective_k2` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a
- **Canonical source:** The Standalone Scholar (2026-08-29) Appendix D
- **Occurrences (3):**
  - `22163849:(111)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(112)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(113)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-177 — theorizing-pipeline
- **Object:** conceptual-theorizing and practice-research engine pipelines
- **Root object:** none
- **Tier:** definition
- **Coq:** `CAN177_TheoryStage`; `CAN177_EngineAStage`; `CAN177_EngineBStage`; `CAN177_bridge`; `CAN177_bridge_iff` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: `CAN177_bridge_iff`: Closed under the global context
- **Canonical source:** The Standalone Scholar (2026-08-29) §2.2, §3.2, §22
- **Occurrences (5):**
  - `22163849:(2)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(6)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(7)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(8)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(93)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-178 — scholarly-capital-bookkeeping
- **Object:** institutional starting capital, earned credit, and positional-capital bookkeeping
- **Root object:** none
- **Tier:** definition (bookkeeping/conceptual, not psychometric)
- **Coq:** `CAN178_K0_start`; `CAN178_E_t`; `CAN178_PosCap`; `CAN178_NetPractice` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a
- **Canonical source:** The Standalone Scholar (2026-08-29) §3.1, §3.3, Appendix H
- **Occurrences (4):**
  - `22163849:(4)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(5)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(10)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(124)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-179 — knowledge-state-ladder
- **Object:** K0-K3 knowledge-state staging
- **Root object:** non-collapse
- **Tier:** definition
- **Coq:** `CAN179_KState`; `CAN179_code`; `CAN179_lt`; `CAN179_ladder_strictly_increasing` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_a.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar (2026-08-29) §4, Appendix B.1
- **Relations:** relates-to → CAN-063
- **Notes:** Parallels, but is not identical to, the K_like-statemachine cluster's K_like→K_checked→K_supported→K_validated chain.
- **Occurrences (3):**
  - `22163849:(13)-(16)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(17)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(97)-(100)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-180 — epistemic-isolation-constraint
- **Object:** the Epistemic Isolation Constraint
- **Root object:** none
- **Tier:** finite_diagnostic / governance definition
- **Coq:** `CAN180_EIC`; `CAN180_EIC_implies_Open` — coq tier: Definition / Open — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a (Open Prop not proved)
- **Canonical source:** The Standalone Scholar (2026-08-29) §5.1
- **Occurrences (3):**
  - `22163849:(19)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(20)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(21)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-181 — bottleneck-inversion
- **Object:** bottleneck inversion and epistemic debt
- **Root object:** none
- **Tier:** governance definition
- **Coq:** `CAN181_Lambda`; `CAN181_Lambda_le_each`; `CAN181_Vc`; `CAN181_De`; `CAN181_velocity_constraint` — coq tier: Th_coqc / Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: `mr_qmin_fold_le`: Closed under the global context
- **Canonical source:** The Standalone Scholar (2026-08-29) §5.2
- **Occurrences (4):**
  - `22163849:(22)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(23)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(24)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(25)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-182 — dvp-protocol
- **Object:** the Decorrelated Verification Protocol
- **Root object:** none
- **Tier:** governance definition
- **Coq:** `CAN182_Outcome`; `CAN182_decision` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a
- **Canonical source:** The Standalone Scholar (2026-08-29) §6.1, §6.3, Appendix B.4
- **Occurrences (3):**
  - `22163849:(27)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(30)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(105)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-183 — programme-legibility
- **Object:** programme legibility and its coherence multiplier
- **Root object:** none
- **Tier:** governance definition
- **Coq:** `CAN183_Coh_effective`; `CAN183_effective_le_latent` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: `CAN183_effective_le_latent`: Closed under the global context
- **Canonical source:** The Standalone Scholar (2026-08-29) §8
- **Occurrences (3):**
  - `22163849:(34)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(35)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(36)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-184 — recognition-conversion
- **Object:** association-strength recognition conversion
- **Root object:** none
- **Tier:** governance definition
- **Coq:** `CAN184_monotone_increase_Open`; `CAN184_PaperRole` — coq tier: Definition / Open — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a (Open Prop not proved)
- **Canonical source:** The Standalone Scholar (2026-08-29) §8.1
- **Occurrences (3):**
  - `22163849:(37)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(38)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(39)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-185 — credit-velocity-governance
- **Object:** scholarly credit velocity, stock pressure, and gradient discipline
- **Root object:** decisive record
- **Tier:** governance definition (deliberately heuristic, not precision instruments)
- **Coq:** `CAN185_chi`; `CAN185_B`; `CAN185_B_bounded_by_mint`; `CAN185_VC`; `CAN185_priority` — coq tier: Definition / Th_coqc — `coq_canon/MRC_method_reading_a.v` — assumptions: `CAN185_B_bounded_by_mint`: Closed under the global context
- **Canonical source:** The Standalone Scholar (2026-08-29) §9.1-9.3, §11, §21, Appendix E.1
- **Occurrences (17):**
  - `22163849:(40)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(41)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(42)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(43)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(45)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(46)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(51)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(52)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(53)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(54)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(55)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(90)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(91)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(114)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(115)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(116)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(117)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-186 — concept-cluster-compounding
- **Object:** concept-cluster compounding and leverage
- **Root object:** none
- **Tier:** governance definition
- **Coq:** `CAN186_CompoundingStage`; `CAN186_credit_leverage`; `CAN186_PC_superseded` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a
- **Canonical source:** The Standalone Scholar (2026-08-29) §9.4, Appendix C.1
- **Occurrences (3):**
  - `22163849:(47)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(48)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(110)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-187 — reactor-criticality-analogy
- **Object:** reactor-control criticality analogy for scholarly output
- **Root object:** none
- **Tier:** definition (diagnostic analogy, explicitly not a physical law)
- **Coq:** `CAN187_k_t`; `CAN187_beta_D`; `CAN187_increase_mint_rate`; `CAN187_rho_R`; `CAN187_X_t`; `CAN187_BR_t` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a
- **Canonical source:** The Standalone Scholar (2026-08-29) §12-12.2
- **Occurrences (6):**
  - `22163849:(56)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(57)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(58)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(59)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(61)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(62)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-188 — legitimacy-circulation-loop
- **Object:** the Legitimacy Circulation Loop
- **Root object:** none
- **Tier:** definition
- **Coq:** `CAN188_LoopStage`; `CAN188_step`; `CAN188_iter`; `CAN188_loop_returns` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_a.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar (2026-08-29) §13
- **Occurrences (1):**
  - `22163849:(64)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-189 — residual-model
- **Object:** a simple residual model of unresolved tension
- **Root object:** none
- **Tier:** definition/Dr
- **Coq:** `CAN189_r`; `CAN189_V` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a
- **Canonical source:** The Standalone Scholar (2026-08-29) §14
- **Occurrences (1):**
  - `22163849:(67)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-190 — geographic-coverage
- **Object:** global-Thai dual-track and geographic distribution audit
- **Root object:** none
- **Tier:** definition/Dr / governance definition
- **Coq:** `mr_list_non_containment_witness`; `CAN190_not_subset`; `CAN190_not_subset_witness`; `CAN190_S_G`; `CAN190_ConversionPlan` — coq tier: Th_coqc / Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: `mr_list_non_containment_witness`: Closed under the global context
- **Canonical source:** The Standalone Scholar (2026-08-29) §15-16, Appendix I
- **Occurrences (9):**
  - `22163849:(69)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(71)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(72)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(75)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(76)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(78)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(79)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(80)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(129)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-191 — integrity-firewall
- **Object:** citation, revision, and emergency-shutdown integrity firewall
- **Root object:** none
- **Tier:** definition/governance definition
- **Coq:** `CAN191_FirewallStage`; `CAN191_scram` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a
- **Canonical source:** The Standalone Scholar (2026-08-29) §18.1, §18.3, §20
- **Occurrences (3):**
  - `22163849:(82)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(83)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(88)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-192 — human-mastery-gate
- **Object:** the Human Mastery Gate heuristic
- **Root object:** none
- **Tier:** definition (governance heuristic)
- **Coq:** `CAN192_H_g` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a
- **Canonical source:** The Standalone Scholar (2026-08-29) §19
- **Occurrences (1):**
  - `22163849:(85)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-193 — standalone-scholar-architecture
- **Object:** the integrated architecture and its endpoint constructs
- **Root object:** none
- **Tier:** definition
- **Coq:** `CAN193_ArchStage`; `CAN193_EpistemicPosition`; `CAN193_CrediblePath` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a
- **Canonical source:** The Standalone Scholar (2026-08-29) §21, §24
- **Occurrences (3):**
  - `22163849:(89)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(94)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(95)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-194 — feasibility-budget
- **Object:** material feasibility and portfolio capacity constraints
- **Root object:** none
- **Tier:** governance definition (local heuristic guardrails)
- **Coq:** `CAN194_B_year`; `CAN194_B_year_total`; `CAN194_component_le_total`; `CAN194_portfolio_shrink`; `CAN194_wip_bound`; `CAN194_priority` — coq tier: Definition / Th_coqc — `coq_canon/MRC_method_reading_a.v` — assumptions: `CAN194_component_le_total`: Closed under the global context
- **Canonical source:** The Standalone Scholar (2026-08-29) Appendix C, Appendix E.2-E.3
- **Occurrences (5):**
  - `22163849:(106)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(109)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(118)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(119)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(120)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-195 — discovery-justification-separation
- **Object:** discovery-justification separation for embedded practice
- **Root object:** non-collapse
- **Tier:** definition/governance definition
- **Coq:** `CAN195_scope_constraint`; `CAN195_Pipeline` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a
- **Canonical source:** The Standalone Scholar (2026-08-29) Appendix H.1
- **Occurrences (3):**
  - `22163849:(125)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(126)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(128)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-196 — evidence-registry-noncollapse
- **Object:** the evidence-registry non-collapse chain (reachability, speed, volume vs warrant/truth)
- **Root object:** non-collapse
- **Tier:** identity (non-collapse); one entry OBSERVED/MODERATE evidence-supported
- **Coq:** `CAN196_EvidenceNotion`; `CAN196_neighboring_ne_formal`; `CAN196_formal_ne_truth`; `CAN196_reachability_ne_accessibility`; `CAN196_speed_ne_quality`; `CAN196_volume_ne_diversity`; `CAN196_attraction_chain` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_a.v` — assumptions: All six: Closed under the global context
- **Canonical source:** State of Evidence for the Readout Hypothesis-Generation Programme (2026-09-04) §1, §3.4, §4
- **Occurrences (6):**
  - `22308066:(unnumbered, Sec.1)` — State of Evidence for the Readout Hypothesis-Generation Programme
  - `22308066:(1)` — State of Evidence for the Readout Hypothesis-Generation Programme
  - `22308066:(2)` — State of Evidence for the Readout Hypothesis-Generation Programme
  - `22308066:(3)` — State of Evidence for the Readout Hypothesis-Generation Programme
  - `22308066:(unnumbered, Sec.4)` — State of Evidence for the Readout Hypothesis-Generation Programme
  - `22308066:(unnumbered, Sec.3.4)` — State of Evidence for the Readout Hypothesis-Generation Programme

#### CAN-197 — knowledge-topology-firstpassage
- **Object:** knowledge-topology first-passage-time hypothesis
- **Root object:** none
- **Tier:** hypothesis/Open
- **Coq:** `CAN197_topology_sensitivity_Open` — coq tier: Open — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a (Open Prop, not proved by design)
- **Canonical source:** State of Evidence for the Readout Hypothesis-Generation Programme (2026-09-04) §3.6/5.2
- **Occurrences (1):**
  - `22308066:(4)` — State of Evidence for the Readout Hypothesis-Generation Programme

#### CAN-198 — rhythm-momentum-accessibility
- **Object:** Rhythm, recent-path momentum, and history-shaped accessibility are parallel descriptors, not a derivation chain
- **Root object:** F-stepper
- **Tier:** definition / hypothesis-Open (the history-shaped update law itself)
- **Coq:** `CAN198_momentum`; `CAN198_Open_momentum`; `CAN198_accessibility_score`; `CAN198_Open_accessibility`; `CAN198_rhythm_does_not_determine_accessibility`; `CAN198_kappa_genuinely_varies` — coq tier: Th_coqc / Open — `coq_canon/MRC_method_reading_a.v` — assumptions: The two eq.15 theorems: Closed under the global context; `Open_eq13`/`Open_eq14` aliases: n/a (Open, inherited unchanged)
- **Master River v1.4 eq(s):** 12, 13, 13, 14
- **Canonical source:** Master Equation River v1.4 eq.(12)-(15) [the 'canonical correction' explicitly blocking Rhythm⇒Momentum]; momentum equation independently verbatim in From Problem to Hypothesis eq.(20)-(21) and Experience Is Meaning-Giving EMG-13/14
- **Notes:** The semantic-momentum equation m_{t+1}(e)=ρm_t(e)+1[e_t=e] is verbatim-identical across two independently-authored chapters (From Problem to Hypothesis and Experience Is Meaning-Giving) — a clean rule-1 case.
- **Occurrences (5):**
  - `22357744:EMG-13` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22357744:EMG-14` — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release
  - `22307148:(19)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(20)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space
  - `22307148:(21)` — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space

#### CAN-199 — mind-body-coupling
- **Object:** Experience arises from coupled brain-body and mind-core dynamics, neither alone
- **Root object:** F-stepper
- **Tier:** definition (Dr) / Core Result (Dr)
- **Coq:** `CAN199_B`; `CAN199_H`; `CAN199_E` — coq tier: Definition — `coq_canon/MRC_method_reading_a.v` — assumptions: n/a
- **Canonical source:** Mind as Information Horizon eq.(9)-(11) [record 19640361]
- **Relations:** relates-to → CAN-017
- **Notes:** Parallels experience-equation's E_n=Φ_E(x_n,μ_n,γ^μ_n,c_n) as an independently-formalized reading of the same object from a different sub-programme (coupling-based rather than readout-chain-based) — relation: 'parallels'.
- **Occurrences (3):**
  - `19640361:(9)` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph
  - `19640361:(10)` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph
  - `19640361:(11)` — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph

#### CAN-200 — DCP-burden-vector
- **Object:** protocol usability-burden vector
- **Root object:** none
- **Tier:** definition/law
- **Coq:** `CAN200_Burden`; `CAN200_OptimalOrAdoptable`; `CAN200_optimal_ne_adoptable` — coq tier: Definition / Th_coqc — `coq_canon/MRC_method_reading_a.v` — assumptions: `CAN200_optimal_ne_adoptable`: Closed under the global context
- **Canonical source:** eq_22481928 (2026-09-06) eq.(37)-(38)
- **Occurrences (2):**
  - `22481928:(37)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)
  - `22481928:(38)` — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

#### CAN-210 — identification-ladder
- **Object:** A nested ladder of admissible identification sets and the audit that locates a distinction on it
- **Root object:** readout R
- **Tier:** definition (identification-ladder audit)
- **Coq:** `CAN210_first_false`; `CAN210_level`; `CAN210_level_correct` — coq tier: Definition / Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: `CAN210_level_correct`: Closed under the global context
- **Canonical source:** The Readout Condition eq.(15)-(16) [record 22301318]
- **Occurrences (2):**
  - `22301318:(15)` — The Readout Condition
  - `22301318:(16)` — The Readout Condition

#### CAN-211 — typed-augmentation-grammar
- **Object:** The paper's own four-part taxonomy of ways an epistemic basis can be augmented
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN211_AugmentationKind`; `CAN211_kinds_pairwise_distinct`; `CAN211_access_aug`; `CAN211_contrast_aug`; `CAN211_decision_policy_aug` — coq tier: Definition — `coq_canon/MRC_method_reading_b.v` — assumptions: `CAN211_kinds_pairwise_distinct`: Closed under the global context
- **Canonical source:** The Readout Condition §5.1, Def-2..Def-5 [record 22301318]
- **Relations:** parallels → CAN-137; parallels → CAN-160
- **Occurrences (4):**
  - `22301318:Def-2` — The Readout Condition
  - `22301318:Def-3` — The Readout Condition
  - `22301318:Def-4` — The Readout Condition
  - `22301318:Def-5` — The Readout Condition

#### CAN-212 — ead-provenance-norms
- **Object:** The Existence-Attribution-Disclosure norms governing when provenance is adequate
- **Root object:** readout R
- **Tier:** law (named principle triad)
- **Coq:** `CAN212_adequate`; `CAN212_adequate_intro` — coq tier: Definition / Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: `CAN212_adequate_intro`: Closed under the global context
- **Canonical source:** The Readout Condition §5.3, Princ-7..Princ-9 [record 22301318]
- **Occurrences (3):**
  - `22301318:Princ-7` — The Readout Condition
  - `22301318:Princ-8` — The Readout Condition
  - `22301318:Princ-9` — The Readout Condition

#### CAN-213 — epistemic-overreach-and-silent-lift
- **Object:** Two named failure modes of provenance licensing: overreach in general, and its silent-omission special case
- **Root object:** readout R
- **Tier:** definition
- **Coq:** `CAN213_overreach`; `CAN213_silent_lift`; `CAN213_silent_lift_is_overreach` — coq tier: Definition / Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: `CAN213_silent_lift_is_overreach`: Closed under the global context
- **Canonical source:** The Readout Condition §5.4, Def-6..Def-7 [record 22301318]
- **Occurrences (2):**
  - `22301318:Def-6` — The Readout Condition
  - `22301318:Def-7` — The Readout Condition

#### CAN-214 — essential-dependency-defeater-routing
- **Object:** The essential-dependency-set of a distinction, its defeater-partition, and the misrouted-defeat corollary
- **Root object:** readout R
- **Tier:** definition / proposition (with proof) / corollary
- **Coq:** `CAN214_intersect`; `CAN214_Ess`; `CAN214_misrouted_defeat` — coq tier: Definition / Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: `CAN214_misrouted_defeat`: Closed under the global context
- **Canonical source:** The Readout Condition §5.5, eq.(17)-(18), Cor-1 [record 22301318]
- **Occurrences (3):**
  - `22301318:(17)` — The Readout Condition
  - `22301318:(18)` — The Readout Condition
  - `22301318:Cor-1` — The Readout Condition

#### CAN-215 — worked-audit-diagnostic-test
- **Object:** A worked base-rate audit example (a positive diagnostic test) illustrating the apparatus
- **Root object:** readout R
- **Tier:** measurement (worked example) / definition (diagram)
- **Coq:** `CAN215_p_D_given_pos`; `CAN215_bayes_value` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Readout Condition §8.1, eq.(23)-(24) [record 22301318]
- **Occurrences (2):**
  - `22301318:(23)` — The Readout Condition
  - `22301318:(24)` — The Readout Condition

#### CAN-216 — retained-record-contamination-route
- **Object:** A worked audit of AI-assisted inference showing a hidden extra access route via a retained record
- **Root object:** readout R
- **Tier:** identity (worked example) / proposition
- **Coq:** `mrb_no_factorization_when_fiber_varies`; `CAN216_worked_no_factorization` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Readout Condition §8.2, eq.(25), Prop-4 [record 22301318]
- **Occurrences (2):**
  - `22301318:(25)` — The Readout Condition
  - `22301318:Prop-4` — The Readout Condition

#### CAN-230 — credit-not-epistemic-value
- **Object:** Credit ≠ EpistemicValue
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN2xx_MethodNotion`; `CAN230_credit_not_epistemic_value` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(1) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(1)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-231 — friction-not-fellowship
- **Object:** Friction ≠ Fellowship
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN231_friction_not_fellowship` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(3) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(3)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-232 — self-experience-not-general-evidence
- **Object:** SelfExperience ≠ GeneralEvidence
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN232_self_experience_not_general_evidence` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(9) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(9)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-233 — positional-access-not-population-authority
- **Object:** PositionalAccess ≠ PopulationAuthority
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN233_positional_access_not_population_authority` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(11) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(11)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-234 — community-trust-not-representativeness
- **Object:** CommunityTrust ≠ Representativeness
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN234_community_trust_not_representativeness` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(12) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(12)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-235 — dvp-not-k2
- **Object:** DVP =/=> K2
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN235_dvp_not_k2` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(18),(101); restated verbatim as disclaimer D-DVP-NOT-K2 in Rigour Without Infrastructure §8.1 [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (3):**
  - `22163849:(18)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(101)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22307841:(unnumbered, Sec.8.1, disclaimer D-DVP-NOT-K2)` — Rigour Without Infrastructure: Three Propositions on Claim-Card Discipline as a Substitute for Institutional Certification

#### CAN-236 — many-models-not-independence
- **Object:** ManyModels =/=> Independence
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN236_many_models_not_independence` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(26) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(26)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-237 — mechanical-not-semantic-validity
- **Object:** MechanicalValidity ≠ SemanticValidity
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN237_mechanical_not_semantic_validity` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(28),(102); restated verbatim in Rigour Without Infrastructure §3.3 [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (3):**
  - `22163849:(28)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(102)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22307841:(unnumbered, Sec.3.3)` — Rigour Without Infrastructure: Three Propositions on Claim-Card Discipline as a Substitute for Institutional Certification

#### CAN-238 — source-existence-not-claim-support
- **Object:** SourceExistence ≠ ClaimSupport
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN238_source_existence_not_claim_support` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(29),(103) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (2):**
  - `22163849:(29)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(103)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-239 — friendship-not-independent-evidence
- **Object:** Friendship ≠ IndependentEvidence
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN239_friendship_not_independent_evidence` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(31) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(31)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-240 — correspondence-not-peer-review
- **Object:** Correspondence ≠ PeerReview
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN240_correspondence_not_peer_review` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(32) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(32)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-241 — intellectual-affinity-not-truth
- **Object:** IntellectualAffinity ≠ Truth
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN241_intellectual_affinity_not_truth` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(33) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(33)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-242 — activation-action-not-credit-event
- **Object:** ActivationAction ≠ CreditEvent
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN242_activation_action_not_credit_event` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(44) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(44)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-243 — rawspeed-not-vc
- **Object:** RawSpeed↓ =/=> V_C↓
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN243_rawspeed_not_vc` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(60) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(60)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-244 — lh-lv-not-truth
- **Object:** L_H ≠ Truth, L_V ≠ Truth
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN244_lh_lv_not_truth` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(63) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(63)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-245 — mission-stepper-not-theta
- **Object:** M_A[n] ≠ θ(E)
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN245_mission_stepper_not_theta` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(66) [record 22163849]
- **Relations:** relates-to → CAN-202; parallels → CAN-228
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(66)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-246 — multiai-consensus-not-geographic-completeness
- **Object:** MultiAIConsensus =/=> GeographicCompleteness
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN246_multiai_consensus_not_geographic_completeness` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(70),(131) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (2):**
  - `22163849:(70)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(131)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-247 — doubleblind-bonus-not-requirement
- **Object:** DoubleBlind = Bonus ≠ Requirement
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN247_doubleblind_bonus_not_requirement` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(73)-(74) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(73)-(74)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-248 — k2global-not-k2thai
- **Object:** K2,Global ≠ K2,Thai
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN248_k2global_not_k2thai` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(77),(130) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (2):**
  - `22163849:(77)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(130)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-249 — interventioncreator-not-soleevaluator
- **Object:** InterventionCreator ≠ SoleEvaluator
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN249_interventioncreator_not_soleevaluator` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(86),(127) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (2):**
  - `22163849:(86)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22163849:(127)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-250 — practiceexperience-not-populationevidence
- **Object:** PracticeExperience ≠ PopulationEvidence
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN250_practiceexperience_not_populationevidence` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(87) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(87)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-251 — at-not-ctscholarly
- **Object:** A_t ≠ C_t^scholarly
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN251_at_not_ctscholarly` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(84) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(84)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-252 — mattention-not-mtruth-mk2
- **Object:** M_attention ≠ M_truth ≠ M_K2
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN252_mattention_not_mtruth_mk2` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(96) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(96)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-253 — nohuman-not-researchstop
- **Object:** NoHumanAvailable =/=> ResearchStop
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN253_nohuman_not_researchstop` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(104) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(104)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-254 — prestige-not-apc-approval
- **Object:** Prestige =/=> APCApproval
- **Root object:** non-collapse
- **Tier:** governance definition
- **Coq:** `CAN254_prestige_not_apc_approval`; `CAN254_approval_requires` — coq tier: Definition — `coq_canon/MRC_method_reading_b.v` — assumptions: `CAN254_prestige_not_apc_approval`: Closed under the global context; `approval_requires` is a Definition, not proved
- **Canonical source:** The Standalone Scholar, eq.(107)-(108) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(107)-(108)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-255 — disclosurepenalty-not-concealment
- **Object:** DisclosurePenalty =/=> Concealment
- **Root object:** non-collapse
- **Tier:** governance definition
- **Coq:** `CAN255_disclosurepenalty_not_concealment`; `CAN255_penalty_requires` — coq tier: Definition — `coq_canon/MRC_method_reading_b.v` — assumptions: `CAN255_disclosurepenalty_not_concealment`: Closed under the global context; `penalty_requires` is a Definition, not proved
- **Canonical source:** The Standalone Scholar, eq.(121)-(122) [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (1):**
  - `22163849:(121)-(122)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

#### CAN-256 — aicontribution-not-epistemicresponsibility
- **Object:** AIContribution ≠ EpistemicResponsibility
- **Root object:** non-collapse
- **Tier:** identity (non-collapse)
- **Coq:** `CAN256_aicontribution_not_epistemicresponsibility` — coq tier: Th_coqc — `coq_canon/MRC_method_reading_b.v` — assumptions: Closed under the global context
- **Canonical source:** The Standalone Scholar, eq.(123); restated verbatim as disclaimer D-AUTHORSHIP in Rigour Without Infrastructure §9/Appendix [record 22163849]
- **Notes:** [MERGER dedup-fix, review verdict FAIL over-merge (CAN-176 'standalone-scholar-noncollapse-bundle'): the former cluster bundled ~30 unrelated concept-pair non-collapse identities from The Standalone Scholar's scattered sections into one id and one canonical_text string; unlike CAN-137/CAN-160 (each a paper's own explicitly named single taxonomy), this list was not presented by its source as one designed object, so rule 5 requires a separate id per distinct pair. Split here; only literal repeats of the identical pair (within the paper, or restated in Rigour Without Infrastructure) are kept merged.]
- **Occurrences (2):**
  - `22163849:(123)` — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship
  - `22307841:(unnumbered, Sec.9 / Appendix disclaimer D-AUTHORSHIP)` — Rigour Without Infrastructure: Three Propositions on Claim-Card Discipline as a Substitute for Institutional Certification

---

## Part 2 — Per chapter: which equation maps to which CAN id

### 17280546 — The Language Bridge

_(no displayed equations in this chapter)_

### 18383439 — Violence as a Special Case of Instability in Finite-Memory Causal Systems

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-115 | B-SOC-LRSTEPPER |
| (2) | CAN-115 | B-SOC-LRSTEPPER |
| (3) | CAN-115 | B-SOC-LRSTEPPER |
| (4) | CAN-115 | B-SOC-LRSTEPPER |
| (5) | CAN-115 | B-SOC-LRSTEPPER |
| (6) | CAN-115 | B-SOC-LRSTEPPER |
| Theorem (No-Go for Elimination by Suppression) | CAN-115 | B-SOC-LRSTEPPER |
| (7) | CAN-115 | B-SOC-LRSTEPPER |
| (8) | CAN-115 | B-SOC-LRSTEPPER |
| (9) | CAN-115 | B-SOC-LRSTEPPER |
| (10) | CAN-115 | B-SOC-LRSTEPPER |
| (11) | CAN-115 | B-SOC-LRSTEPPER |
| (12) | CAN-115 | B-SOC-LRSTEPPER |

### 18444260 — Causal Ethics

| label | → CAN id | canonical key |
|---|---|---|
| CE-01 | CAN-116 | B-SOC-ETHAXIOM |
| CE-02 | CAN-116 | B-SOC-ETHAXIOM |
| CE-03 | CAN-116 | B-SOC-ETHAXIOM |
| CE-04 | CAN-116 | B-SOC-ETHAXIOM |
| CE-05 | CAN-117 | B-SOC-REGIME |
| CE-06 | CAN-117 | B-SOC-REGIME |
| CE-07 | CAN-117 | B-SOC-REGIME |
| CE-08 | CAN-117 | B-SOC-REGIME |
| CE-09 | CAN-118 | B-SOC-ETHLOAD |
| CE-10 | CAN-118 | B-SOC-ETHLOAD |
| CE-11 | CAN-118 | B-SOC-ETHLOAD |
| CE-12 | CAN-118 | B-SOC-ETHLOAD |
| CE-13 | CAN-118 | B-SOC-ETHLOAD |
| CE-14 | CAN-119 | B-SOC-COLCONF |
| CE-15 | CAN-119 | B-SOC-COLCONF |
| CE-16 | CAN-119 | B-SOC-COLCONF |
| CE-17 | CAN-119 | B-SOC-COLCONF |
| CE-18 | CAN-119 | B-SOC-COLCONF |
| CE-19 | CAN-118 | B-SOC-ETHLOAD |
| CE-20 | CAN-119 | B-SOC-COLCONF |
| CE-21 | CAN-119 | B-SOC-COLCONF |
| CE-22 | CAN-119 | B-SOC-COLCONF |
| CE-23 | CAN-119 | B-SOC-COLCONF |
| CE-24 | CAN-119 | B-SOC-COLCONF |
| CE-25 | CAN-120 | B-SOC-MORALCOST |
| CE-26 | CAN-120 | B-SOC-MORALCOST |
| CE-27 | CAN-120 | B-SOC-MORALCOST |
| CE-28 | CAN-120 | B-SOC-MORALCOST |
| CE-29 | CAN-120 | B-SOC-MORALCOST |
| CE-30 | CAN-119 | B-SOC-COLCONF |
| CE-31 | CAN-120 | B-SOC-MORALCOST |
| CE-32 | CAN-120 | B-SOC-MORALCOST |
| CE-33 | CAN-120 | B-SOC-MORALCOST |
| CE-34 | CAN-120 | B-SOC-MORALCOST |
| (CE-choice gate) | CAN-120 | B-SOC-MORALCOST |
| (Tragic) | CAN-120 | B-SOC-MORALCOST |
| (Tragic-min) | CAN-120 | B-SOC-MORALCOST |

### 18517054 — AI, Translation, and Access to Event-Specific Context: A Conceptual Review and Theory Proposal on Human Agency under AI Mediation

| label | → CAN id | canonical key |
|---|---|---|
| Def-1 | CAN-093 | event-translation-core |
| Def-2 | CAN-093 | event-translation-core |
| Def-3 | CAN-093 | event-translation-core |
| Prop-1 | CAN-093 | event-translation-core |
| Def-4 | CAN-094 | self-context-agency |
| Def-5 | CAN-094 | self-context-agency |
| Def-6 | CAN-094 | self-context-agency |
| Prop-2 | CAN-094 | self-context-agency |
| Def-7 | CAN-095 | grounding-embodiment |
| Prop-3 | CAN-095 | grounding-embodiment |
| (1) | CAN-096 | interaction-efficiency |
| Eq-unifying | CAN-093 | event-translation-core |
| Eq-epoch3 | CAN-093 | event-translation-core |
| Prop-4 | CAN-093 | event-translation-core |
| Finding-1 (H1) | CAN-097 | ai-mediation-hypotheses |
| Finding-2 (H3) | CAN-097 | ai-mediation-hypotheses |
| Finding-3 (H4) | CAN-097 | ai-mediation-hypotheses |
| Prop-5 (B1) | CAN-094 | self-context-agency |
| (2) | CAN-094 | self-context-agency |
| (3) | CAN-094 | self-context-agency |

### 18711408 — Learning Under Generative Abundance: A Structural Law of Epistemic Stabilization

| label | → CAN id | canonical key |
|---|---|---|
| L1 | CAN-028 | generative-abundance-law |
| L2 | CAN-028 | generative-abundance-law |

### 18897585 — Causal Agency: A Persistence–Control Theory of Adaptive Systems

| label | → CAN id | canonical key |
|---|---|---|
| Def-1 | CAN-121 | B-SOC-AGENCYHIER |
| Def-2 | CAN-121 | B-SOC-AGENCYHIER |
| Persistence-Regulation-Condition | CAN-121 | B-SOC-AGENCYHIER |
| Constraint-Evolution | CAN-121 | B-SOC-AGENCYHIER |
| State-Constraint-Coupling | CAN-121 | B-SOC-AGENCYHIER |
| Def-3 (Agency-Condition) | CAN-121 | B-SOC-AGENCYHIER |
| Proto-Agency-Condition | CAN-121 | B-SOC-AGENCYHIER |
| L3-Constraint-Evolution-History | CAN-121 | B-SOC-AGENCYHIER |
| L4-Constraint-Evolution-Predictive | CAN-121 | B-SOC-AGENCYHIER |
| L5-Meta-Regulation | CAN-121 | B-SOC-AGENCYHIER |

### 18925129 — Knowledge as Stabilized Translation

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-012 | observer-pipeline |
| (2) | CAN-025 | knowledge-stability |

### 18925131 — The Causal Grammar of Structured Coexistence: Conflict, Violence, Repair, and Non-Suppressive Peace

_(no displayed equations in this chapter)_

### 18943971 — The Civilization of Knowledge: Who Has the Authority to Interpret the World

| label | → CAN id | canonical key |
|---|---|---|
| Canonical Formula | CAN-012 | observer-pipeline |

### 19176260 — The Architecture of Mediated Agency: Beyond the Misframing of Free Will and Truth

_(no displayed equations in this chapter)_

### 19205869 — Genesis Constraint-First Alignment Epistemology: Reason, Error, and World-Tracking under Irreducible Mediation

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-204 | encoder-pipeline |
| (2) | CAN-204 | encoder-pipeline |
| (3) | CAN-023 | retention-update |
| (4) | CAN-026 | fallibilism-axiom |
| (5) | CAN-027 | alignment-readout |
| (6) | CAN-027 | alignment-readout |

### 19215748 — When AI Expands Human Potential

| label | → CAN id | canonical key |
|---|---|---|
| unlabeled (§7, display 1) | CAN-030 | context-indexed-evaluation |
| unlabeled (§7, display 2) | CAN-030 | context-indexed-evaluation |

### 19640361 — Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Discrete Causal Graph

| label | → CAN id | canonical key |
|---|---|---|
| P3 | CAN-001 | root-weld |
| MQ.08 | CAN-001 | root-weld |
| Th-5 | CAN-001 | root-weld |
| (1) | CAN-048 | agency-conditional-chain |
| (2) | CAN-048 | agency-conditional-chain |
| (3) | CAN-048 | agency-conditional-chain |
| (4) | CAN-048 | agency-conditional-chain |
| (5) | CAN-048 | agency-conditional-chain |
| (6) | CAN-048 | agency-conditional-chain |
| (7) | CAN-048 | agency-conditional-chain |
| (8) | CAN-048 | agency-conditional-chain |
| (9) | CAN-199 | mind-body-coupling |
| (10) | CAN-199 | mind-body-coupling |
| (11) | CAN-199 | mind-body-coupling |
| (12) | CAN-026 | fallibilism-axiom |
| (13) | CAN-025 | knowledge-stability |
| (14) | CAN-031 | knowledge-admission |
| (15) | CAN-031 | knowledge-admission |

### 21425420 — Experience Is the Human LoRA: A Readout-Retention Theory of Selective Model Change

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-055 | human-domain-state-graph |
| (2) | CAN-055 | human-domain-state-graph |
| (3) | CAN-055 | human-domain-state-graph |
| (4) | CAN-055 | human-domain-state-graph |
| (5) | CAN-055 | human-domain-state-graph |
| (6) | CAN-055 | human-domain-state-graph |
| (7) | CAN-205 | windowed-sensor-readout |
| (8) | CAN-205 | windowed-sensor-readout |
| (9) | CAN-205 | windowed-sensor-readout |
| (10) | CAN-205 | windowed-sensor-readout |
| (11) | CAN-055 | human-domain-state-graph |
| (12) | CAN-017 | experience-equation |
| (13) | CAN-017 | experience-equation |
| (14) | CAN-023 | retention-update |
| (15) | CAN-017 | experience-equation |
| (16) | CAN-017 | experience-equation |
| (17) | CAN-017 | experience-equation |
| (18) | CAN-054 | selective-retention-mechanism |
| (19) | CAN-054 | selective-retention-mechanism |
| (20) | CAN-054 | selective-retention-mechanism |
| (21) | CAN-054 | selective-retention-mechanism |
| (22) | CAN-054 | selective-retention-mechanism |
| (23)-(24) | CAN-054 | selective-retention-mechanism |
| (25) | CAN-054 | selective-retention-mechanism |
| (26) | CAN-054 | selective-retention-mechanism |
| (27) | CAN-054 | selective-retention-mechanism |
| (28) | CAN-054 | selective-retention-mechanism |
| (29) | CAN-054 | selective-retention-mechanism |
| (30) | CAN-055 | human-domain-state-graph |
| (31) | CAN-051 | horizon-triad |
| (32) | CAN-054 | selective-retention-mechanism |
| (33) | CAN-054 | selective-retention-mechanism |
| (34) | CAN-054 | selective-retention-mechanism |
| (35) | CAN-227 | human-lora-adaptation-non-collapse |
| (36) | CAN-054 | selective-retention-mechanism |
| (37) | CAN-054 | selective-retention-mechanism |
| (38) | CAN-054 | selective-retention-mechanism |
| (39) | CAN-206 | domain-taxonomy-Dn |
| (40) | CAN-054 | selective-retention-mechanism |
| (41) | CAN-054 | selective-retention-mechanism |
| (42) | CAN-054 | selective-retention-mechanism |
| (43) | CAN-054 | selective-retention-mechanism |
| (44) | CAN-054 | selective-retention-mechanism |
| (45) | CAN-054 | selective-retention-mechanism |
| (46) | CAN-054 | selective-retention-mechanism |
| (47) | CAN-054 | selective-retention-mechanism |
| (48) | CAN-054 | selective-retention-mechanism |

### 21529456 — Readout Genesis Standalone Synthesis

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-001 | root-weld |
| (2) | CAN-006 | domain-weld |
| (3) | CAN-001 | root-weld |
| (4) | CAN-001 | root-weld |
| (5) | CAN-001 | root-weld |
| (6) | CAN-006 | domain-weld |
| (7) | CAN-006 | domain-weld |
| (8) | CAN-007 | reader-equivalence |
| (9) | CAN-004 | constitutional-ordering |
| (10) | CAN-222 | root-non-collapse-chain |
| (11) | CAN-203 | access-exposure-function |
| (12) | CAN-222 | root-non-collapse-chain |
| (13) | CAN-013 | meaning-giving |
| (14) | CAN-017 | experience-equation |
| (15) | CAN-023 | retention-update |
| (16) | CAN-009 | historical-invariance |
| (17) | CAN-122 | belief-relation |
| (18) | CAN-122 | belief-relation |
| (19) | CAN-122 | belief-relation |
| (20) | CAN-122 | belief-relation |
| (21) | CAN-222 | root-non-collapse-chain |
| Prop-1 | CAN-122 | belief-relation |
| Def-1 | CAN-031 | knowledge-admission |
| (22) | CAN-031 | knowledge-admission |
| (23) | CAN-031 | knowledge-admission |
| (24) | CAN-222 | root-non-collapse-chain |
| (25) | CAN-032 | practical-effectiveness |
| (26) | CAN-222 | root-non-collapse-chain |
| (27) | CAN-033 | tier-ledger |
| (28) | CAN-034 | state-sufficiency |
| (29) | CAN-034 | state-sufficiency |
| (30) | CAN-035 | claim-ceiling |
| Prop-2 | CAN-035 | claim-ceiling |
| (31) | CAN-031 | knowledge-admission |
| (32) | CAN-031 | knowledge-admission |
| (33) | CAN-036 | knowledge-transport |
| (34) | CAN-036 | knowledge-transport |
| (35) | CAN-222 | root-non-collapse-chain |
| (36) | CAN-049 | agency-quotient |
| (37) | CAN-049 | agency-quotient |
| (38) | CAN-049 | agency-quotient |
| (39) | CAN-048 | agency-conditional-chain |
| (40) | CAN-048 | agency-conditional-chain |
| (41) | CAN-048 | agency-conditional-chain |
| (42) | CAN-048 | agency-conditional-chain |
| (43) | CAN-048 | agency-conditional-chain |
| (44) | CAN-014 | meaning-distortion |
| (45) | CAN-014 | meaning-distortion |
| (46) | CAN-014 | meaning-distortion |
| (47) | CAN-050 | self-readout |
| (48) | CAN-222 | root-non-collapse-chain |
| (49) | CAN-050 | self-readout |
| (50) | CAN-051 | horizon-triad |
| (51) | CAN-051 | horizon-triad |
| (52) | CAN-051 | horizon-triad |
| (53) | CAN-051 | horizon-triad |
| (54) | CAN-051 | horizon-triad |
| (55) | CAN-051 | horizon-triad |
| (56) | CAN-031 | knowledge-admission |
| (57) | CAN-031 | knowledge-admission |
| (58) | CAN-031 | knowledge-admission |
| (59) | CAN-031 | knowledge-admission |
| (60) | CAN-031 | knowledge-admission |
| (61) | CAN-031 | knowledge-admission |
| (62) | CAN-031 | knowledge-admission |
| (63) | CAN-052 | release-dynamics |
| (64) | CAN-052 | release-dynamics |
| (65) | CAN-052 | release-dynamics |
| (66) | CAN-052 | release-dynamics |
| (67) | CAN-053 | meta-readout-governance |
| (68) | CAN-053 | meta-readout-governance |
| (69) | CAN-053 | meta-readout-governance |
| (70) | CAN-222 | root-non-collapse-chain |
| (71) | CAN-053 | meta-readout-governance |
| (72) | CAN-053 | meta-readout-governance |
| (73) | CAN-053 | meta-readout-governance |
| (74) | CAN-053 | meta-readout-governance |
| (75) | CAN-053 | meta-readout-governance |
| (76) | CAN-053 | meta-readout-governance |
| (77) | CAN-053 | meta-readout-governance |
| (78) | CAN-053 | meta-readout-governance |
| (79) | CAN-053 | meta-readout-governance |
| (80) | CAN-053 | meta-readout-governance |
| (81) | CAN-053 | meta-readout-governance |
| (82) | CAN-053 | meta-readout-governance |
| (83) | CAN-053 | meta-readout-governance |
| (84) | CAN-053 | meta-readout-governance |
| (85) | CAN-222 | root-non-collapse-chain |
| (86) | CAN-053 | meta-readout-governance |
| (87) | CAN-064 | human-ai-transport |
| (88) | CAN-064 | human-ai-transport |

### 22163849 — The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-230 | credit-not-epistemic-value |
| (2) | CAN-177 | theorizing-pipeline |
| (3) | CAN-231 | friction-not-fellowship |
| (4) | CAN-178 | scholarly-capital-bookkeeping |
| (5) | CAN-178 | scholarly-capital-bookkeeping |
| (6) | CAN-177 | theorizing-pipeline |
| (7) | CAN-177 | theorizing-pipeline |
| (8) | CAN-177 | theorizing-pipeline |
| (9) | CAN-232 | self-experience-not-general-evidence |
| (10) | CAN-178 | scholarly-capital-bookkeeping |
| (11) | CAN-233 | positional-access-not-population-authority |
| (12) | CAN-234 | community-trust-not-representativeness |
| (13)-(16) | CAN-179 | knowledge-state-ladder |
| (17) | CAN-179 | knowledge-state-ladder |
| (18) | CAN-235 | dvp-not-k2 |
| (19) | CAN-180 | epistemic-isolation-constraint |
| (20) | CAN-180 | epistemic-isolation-constraint |
| (21) | CAN-180 | epistemic-isolation-constraint |
| (22) | CAN-181 | bottleneck-inversion |
| (23) | CAN-181 | bottleneck-inversion |
| (24) | CAN-181 | bottleneck-inversion |
| (25) | CAN-181 | bottleneck-inversion |
| (26) | CAN-236 | many-models-not-independence |
| (27) | CAN-182 | dvp-protocol |
| (28) | CAN-237 | mechanical-not-semantic-validity |
| (29) | CAN-238 | source-existence-not-claim-support |
| (30) | CAN-182 | dvp-protocol |
| (31) | CAN-239 | friendship-not-independent-evidence |
| (32) | CAN-240 | correspondence-not-peer-review |
| (33) | CAN-241 | intellectual-affinity-not-truth |
| (34) | CAN-183 | programme-legibility |
| (35) | CAN-183 | programme-legibility |
| (36) | CAN-183 | programme-legibility |
| (37) | CAN-184 | recognition-conversion |
| (38) | CAN-184 | recognition-conversion |
| (39) | CAN-184 | recognition-conversion |
| (40) | CAN-185 | credit-velocity-governance |
| (41) | CAN-185 | credit-velocity-governance |
| (42) | CAN-185 | credit-velocity-governance |
| (43) | CAN-185 | credit-velocity-governance |
| (44) | CAN-242 | activation-action-not-credit-event |
| (45) | CAN-185 | credit-velocity-governance |
| (46) | CAN-185 | credit-velocity-governance |
| (47) | CAN-186 | concept-cluster-compounding |
| (48) | CAN-186 | concept-cluster-compounding |
| (49) | CAN-173 | credit-provenance-goodhart |
| (50) | CAN-173 | credit-provenance-goodhart |
| (51) | CAN-185 | credit-velocity-governance |
| (52) | CAN-185 | credit-velocity-governance |
| (53) | CAN-185 | credit-velocity-governance |
| (54) | CAN-185 | credit-velocity-governance |
| (55) | CAN-185 | credit-velocity-governance |
| (56) | CAN-187 | reactor-criticality-analogy |
| (57) | CAN-187 | reactor-criticality-analogy |
| (58) | CAN-187 | reactor-criticality-analogy |
| (59) | CAN-187 | reactor-criticality-analogy |
| (60) | CAN-243 | rawspeed-not-vc |
| (61) | CAN-187 | reactor-criticality-analogy |
| (62) | CAN-187 | reactor-criticality-analogy |
| (63) | CAN-244 | lh-lv-not-truth |
| (64) | CAN-188 | legitimacy-circulation-loop |
| (65) | CAN-202 | mission-stepper-reading |
| (66) | CAN-245 | mission-stepper-not-theta |
| (67) | CAN-189 | residual-model |
| (68) | CAN-174 | tier-ledger-invariant |
| (69) | CAN-190 | geographic-coverage |
| (70) | CAN-246 | multiai-consensus-not-geographic-completeness |
| (71) | CAN-190 | geographic-coverage |
| (72) | CAN-190 | geographic-coverage |
| (73)-(74) | CAN-247 | doubleblind-bonus-not-requirement |
| (75) | CAN-190 | geographic-coverage |
| (76) | CAN-190 | geographic-coverage |
| (77) | CAN-248 | k2global-not-k2thai |
| (78) | CAN-190 | geographic-coverage |
| (79) | CAN-190 | geographic-coverage |
| (80) | CAN-190 | geographic-coverage |
| (81) | CAN-112 | decisive-record-argmax |
| (82) | CAN-191 | integrity-firewall |
| (83) | CAN-191 | integrity-firewall |
| (84) | CAN-251 | at-not-ctscholarly |
| (85) | CAN-192 | human-mastery-gate |
| (86) | CAN-249 | interventioncreator-not-soleevaluator |
| (87) | CAN-250 | practiceexperience-not-populationevidence |
| (88) | CAN-191 | integrity-firewall |
| (89) | CAN-193 | standalone-scholar-architecture |
| (90) | CAN-185 | credit-velocity-governance |
| (91) | CAN-185 | credit-velocity-governance |
| (92) | CAN-112 | decisive-record-argmax |
| (93) | CAN-177 | theorizing-pipeline |
| (94) | CAN-193 | standalone-scholar-architecture |
| (95) | CAN-193 | standalone-scholar-architecture |
| (96) | CAN-252 | mattention-not-mtruth-mk2 |
| (97)-(100) | CAN-179 | knowledge-state-ladder |
| (101) | CAN-235 | dvp-not-k2 |
| (102) | CAN-237 | mechanical-not-semantic-validity |
| (103) | CAN-238 | source-existence-not-claim-support |
| (104) | CAN-253 | nohuman-not-researchstop |
| (105) | CAN-182 | dvp-protocol |
| (106) | CAN-194 | feasibility-budget |
| (107)-(108) | CAN-254 | prestige-not-apc-approval |
| (109) | CAN-194 | feasibility-budget |
| (110) | CAN-186 | concept-cluster-compounding |
| (111) | CAN-175 | k2-procurement |
| (112) | CAN-175 | k2-procurement |
| (113) | CAN-175 | k2-procurement |
| (114) | CAN-185 | credit-velocity-governance |
| (115) | CAN-185 | credit-velocity-governance |
| (116) | CAN-185 | credit-velocity-governance |
| (117) | CAN-185 | credit-velocity-governance |
| (118) | CAN-194 | feasibility-budget |
| (119) | CAN-194 | feasibility-budget |
| (120) | CAN-194 | feasibility-budget |
| (121)-(122) | CAN-255 | disclosurepenalty-not-concealment |
| (123) | CAN-256 | aicontribution-not-epistemicresponsibility |
| (124) | CAN-178 | scholarly-capital-bookkeeping |
| (125) | CAN-195 | discovery-justification-separation |
| (126) | CAN-195 | discovery-justification-separation |
| (127) | CAN-249 | interventioncreator-not-soleevaluator |
| (128) | CAN-195 | discovery-justification-separation |
| (129) | CAN-190 | geographic-coverage |
| (130) | CAN-248 | k2global-not-k2thai |
| (131) | CAN-246 | multiai-consensus-not-geographic-completeness |

### 22301202 — Written by AI. Still True.

| label | → CAN id | canonical key |
|---|---|---|
| SC | CAN-029 | knower-constitution |
| HSC | CAN-029 | knower-constitution |
| Def-1 | CAN-029 | knower-constitution |
| Def-2 | CAN-029 | knower-constitution |
| Prin-1 | CAN-223 | role-separation-principle |
| Prop-1 | CAN-029 | knower-constitution |
| (RA) | CAN-011 | source-provenance-readout |
| (m-rho) | CAN-011 | source-provenance-readout |
| Prin-2 | CAN-218 | bridge-burden-principle |
| Prin-3 | CAN-219 | no-bare-pedigree-principle |
| (dCr) | CAN-217 | residual-provenance-effect |
| (RPE) | CAN-217 | residual-provenance-effect |
| Def-4 | CAN-217 | residual-provenance-effect |
| Prin-4 | CAN-220 | provenance-relevance-constraint |
| Def-3 | CAN-029 | knower-constitution |
| Prin-5 | CAN-221 | friction-not-magic-principle |

### 22301318 — The Readout Condition

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-208 | provenance-governing-maxim |
| (2) | CAN-224 | representationality-selectivity-noncollapse |
| (3) | CAN-209 | provenance-distinction-and-path |
| (4) | CAN-209 | provenance-distinction-and-path |
| (5) | CAN-165 | readout-factorization-admissibility |
| (6) | CAN-165 | readout-factorization-admissibility |
| Def-1 | CAN-165 | readout-factorization-admissibility |
| (7) | CAN-165 | readout-factorization-admissibility |
| Prop-1 | CAN-165 | readout-factorization-admissibility |
| Princ-4 | CAN-165 | readout-factorization-admissibility |
| (8) | CAN-165 | readout-factorization-admissibility |
| (9) | CAN-165 | readout-factorization-admissibility |
| Prop-2 | CAN-165 | readout-factorization-admissibility |
| (10) | CAN-165 | readout-factorization-admissibility |
| (11) | CAN-165 | readout-factorization-admissibility |
| (12) | CAN-165 | readout-factorization-admissibility |
| (13) | CAN-165 | readout-factorization-admissibility |
| (14) | CAN-165 | readout-factorization-admissibility |
| (15) | CAN-210 | identification-ladder |
| (16) | CAN-210 | identification-ladder |
| Def-2 | CAN-211 | typed-augmentation-grammar |
| Def-3 | CAN-211 | typed-augmentation-grammar |
| Def-4 | CAN-211 | typed-augmentation-grammar |
| Def-5 | CAN-211 | typed-augmentation-grammar |
| Princ-7 | CAN-212 | ead-provenance-norms |
| Princ-8 | CAN-212 | ead-provenance-norms |
| Princ-9 | CAN-212 | ead-provenance-norms |
| Def-6 | CAN-213 | epistemic-overreach-and-silent-lift |
| Def-7 | CAN-213 | epistemic-overreach-and-silent-lift |
| (17) | CAN-214 | essential-dependency-defeater-routing |
| (18) | CAN-214 | essential-dependency-defeater-routing |
| Cor-1 | CAN-214 | essential-dependency-defeater-routing |
| (19) | CAN-165 | readout-factorization-admissibility |
| (20) | CAN-165 | readout-factorization-admissibility |
| (21) | CAN-165 | readout-factorization-admissibility |
| (22) | CAN-165 | readout-factorization-admissibility |
| (23) | CAN-215 | worked-audit-diagnostic-test |
| (24) | CAN-215 | worked-audit-diagnostic-test |
| (25) | CAN-216 | retained-record-contamination-route |
| Prop-4 | CAN-216 | retained-record-contamination-route |
| (26) | CAN-208 | provenance-governing-maxim |
| (27) | CAN-208 | provenance-governing-maxim |
| (28) | CAN-208 | provenance-governing-maxim |
| (29) | CAN-208 | provenance-governing-maxim |
| (30) | CAN-208 | provenance-governing-maxim |
| (31) | CAN-165 | readout-factorization-admissibility |
| (32) | CAN-165 | readout-factorization-admissibility |

### 22307148 — From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Discriminable Hypothesis Space

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-202 | mission-stepper-reading |
| (2) | CAN-228 | hypothesis-space-non-collapse-bundle |
| (3) | CAN-167 | problem-formation |
| (4) | CAN-167 | problem-formation |
| (5) | CAN-167 | problem-formation |
| (6) | CAN-207 | semantic-quotient-reading |
| (7) | CAN-228 | hypothesis-space-non-collapse-bundle |
| (8) | CAN-007 | reader-equivalence |
| (9) | CAN-033 | tier-ledger |
| (10) | CAN-033 | tier-ledger |
| (11)-(12) | CAN-036 | knowledge-transport |
| (13) | CAN-036 | knowledge-transport |
| (14) | CAN-036 | knowledge-transport |
| (15) | CAN-168 | discovery-accessibility |
| (16) | CAN-168 | discovery-accessibility |
| (17) | CAN-168 | discovery-accessibility |
| (18) | CAN-228 | hypothesis-space-non-collapse-bundle |
| (19) | CAN-198 | rhythm-momentum-accessibility |
| (20) | CAN-198 | rhythm-momentum-accessibility |
| (21) | CAN-198 | rhythm-momentum-accessibility |
| (22) | CAN-228 | hypothesis-space-non-collapse-bundle |
| (23) | CAN-168 | discovery-accessibility |
| (24) | CAN-168 | discovery-accessibility |
| (25) | CAN-168 | discovery-accessibility |
| (26) | CAN-168 | discovery-accessibility |
| (27) | CAN-168 | discovery-accessibility |
| (28) | CAN-168 | discovery-accessibility |
| (29) | CAN-168 | discovery-accessibility |
| (30)-(32) | CAN-228 | hypothesis-space-non-collapse-bundle |
| (33) | CAN-228 | hypothesis-space-non-collapse-bundle |
| (34)-(35) | CAN-169 | discovery-first-passage |
| (36) | CAN-169 | discovery-first-passage |
| (37) | CAN-169 | discovery-first-passage |
| (38) | CAN-228 | hypothesis-space-non-collapse-bundle |
| (39) | CAN-031 | knowledge-admission |
| (40) | CAN-031 | knowledge-admission |
| (41) | CAN-031 | knowledge-admission |
| (42) | CAN-031 | knowledge-admission |
| (43) | CAN-123 | collective-readout |
| (44) | CAN-123 | collective-readout |
| (45) | CAN-123 | collective-readout |
| (46) | CAN-123 | collective-readout |
| (47) | CAN-228 | hypothesis-space-non-collapse-bundle |
| (48) | CAN-170 | discriminating-action-loop |
| (49) | CAN-170 | discriminating-action-loop |
| (50) | CAN-170 | discriminating-action-loop |
| (51) | CAN-170 | discriminating-action-loop |
| (52) | CAN-169 | discovery-first-passage |
| (53) | CAN-169 | discovery-first-passage |
| (54) | CAN-169 | discovery-first-passage |
| (55) | CAN-111 | human-ai-attribution |
| (56) | CAN-111 | human-ai-attribution |
| (57) | CAN-111 | human-ai-attribution |
| (58) | CAN-228 | hypothesis-space-non-collapse-bundle |

### 22307561 — Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discovery Time and Direction

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-169 | discovery-first-passage |
| (2)-(3) | CAN-169 | discovery-first-passage |
| (4) | CAN-229 | discovery-topology-non-collapse-bundle |
| (5) | CAN-169 | discovery-first-passage |
| (6) | CAN-169 | discovery-first-passage |
| (7) | CAN-169 | discovery-first-passage |
| (8) | CAN-169 | discovery-first-passage |
| H1 | CAN-169 | discovery-first-passage |
| (9) | CAN-169 | discovery-first-passage |
| H2 | CAN-169 | discovery-first-passage |
| (10) | CAN-169 | discovery-first-passage |
| (11) | CAN-169 | discovery-first-passage |
| (12) | CAN-229 | discovery-topology-non-collapse-bundle |
| (13) | CAN-169 | discovery-first-passage |
| (14) | CAN-169 | discovery-first-passage |

### 22307564 — Before Evidence Can Decide: Candidate-Set Formation, Discovery Routing, and Unconceived Alternatives — Questions for a Pre-Evidential Epistemology of Science

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-039 | B-EPI-CANDSET |
| (2) | CAN-039 | B-EPI-CANDSET |
| (3) | CAN-039 | B-EPI-CANDSET |
| (4) | CAN-039 | B-EPI-CANDSET |
| (5) | CAN-039 | B-EPI-CANDSET |
| (Q5, unlabeled) | CAN-039 | B-EPI-CANDSET |
| (6) | CAN-039 | B-EPI-CANDSET |

### 22307841 — Rigour Without Infrastructure: Three Propositions on Claim-Card Discipline as a Substitute for Institutional Certification

| label | → CAN id | canonical key |
|---|---|---|
| (unnumbered, Sec.1) | CAN-011 | source-provenance-readout |
| (unnumbered, Sec.3.3) | CAN-237 | mechanical-not-semantic-validity |
| (unnumbered, Sec.8.1, disclaimer D-DVP-NOT-K2) | CAN-235 | dvp-not-k2 |
| (unnumbered, Sec.9 / Appendix disclaimer D-AUTHORSHIP) | CAN-256 | aicontribution-not-epistemicresponsibility |

### 22308066 — State of Evidence for the Readout Hypothesis-Generation Programme

| label | → CAN id | canonical key |
|---|---|---|
| (unnumbered, Sec.1) | CAN-196 | evidence-registry-noncollapse |
| (1) | CAN-196 | evidence-registry-noncollapse |
| (2) | CAN-196 | evidence-registry-noncollapse |
| (3) | CAN-196 | evidence-registry-noncollapse |
| (unnumbered, Sec.4) | CAN-196 | evidence-registry-noncollapse |
| (unnumbered, Sec.3.4) | CAN-196 | evidence-registry-noncollapse |
| (4) | CAN-197 | knowledge-topology-firstpassage |

### 22308072 — The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguishable Hypotheses — A Controlled Amplification Architecture for Scientific Discovery

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-039 | B-EPI-CANDSET |
| (2) | CAN-039 | B-EPI-CANDSET |
| (3) | CAN-039 | B-EPI-CANDSET |
| (4) | CAN-039 | B-EPI-CANDSET |
| (5) | CAN-039 | B-EPI-CANDSET |
| (6) | CAN-039 | B-EPI-CANDSET |
| (7) | CAN-040 | B-EPI-KEPI |
| (8) | CAN-040 | B-EPI-KEPI |
| (9) | CAN-040 | B-EPI-KEPI |
| (10) | CAN-040 | B-EPI-KEPI |
| (11) | CAN-056 | B-HAI-SYNERGY |
| (12) | CAN-056 | B-HAI-SYNERGY |
| (13)-(15) | CAN-039 | B-EPI-CANDSET |
| (16) | CAN-056 | B-HAI-SYNERGY |
| (17) | CAN-056 | B-HAI-SYNERGY |
| (18) | CAN-039 | B-EPI-CANDSET |
| (19) | CAN-039 | B-EPI-CANDSET |
| (20) | CAN-039 | B-EPI-CANDSET |
| (21) | CAN-039 | B-EPI-CANDSET |
| (22) | CAN-039 | B-EPI-CANDSET |

### 22331922 — Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrained, Problem-First Architecture of Human-AI Collaboration (Epistemic Note v8.1)

| label | → CAN id | canonical key |
|---|---|---|
| CN-1 | CAN-078 | D-R-A-constitutive |
| EF-01 | CAN-043 | entry-state-anchor |
| EF-02 (Repair 1) | CAN-043 | entry-state-anchor |
| EF-03 (Repair 1) | CAN-043 | entry-state-anchor |
| EF-04 | CAN-062 | K_like-noncollapse |
| EF-05 | CAN-063 | K_like-statemachine |
| EF-06 (Repair 2) | CAN-063 | K_like-statemachine |
| EF-07 (Repair 3) | CAN-070 | equivalence-class-diagnostic |
| EF-08 (Repair 4) | CAN-071 | resistance-quality-accessibility |
| EF-09 (Repair 4) | CAN-071 | resistance-quality-accessibility |
| EF-10 | CAN-071 | resistance-quality-accessibility |
| EF-11 (Repair 5) | CAN-072 | calibration-audit |
| EF-12 (Repair 5) | CAN-072 | calibration-audit |
| EF-13 | CAN-047 | human-AI-session-stepper |
| EF-14 | CAN-047 | human-AI-session-stepper |
| EF-15 (Repair 6) | CAN-047 | human-AI-session-stepper |
| EF-16 | CAN-047 | human-AI-session-stepper |
| EF-17 | CAN-075 | exposure-retention-improvement-noncollapse |
| EF-18 (Repair 7) | CAN-066 | session-retention-gate |
| EF-19 (Repair 7) | CAN-066 | session-retention-gate |
| EF-20 | CAN-067 | gain-tunnel-functions |
| EF-21 | CAN-067 | gain-tunnel-functions |
| EF-22 (Repair 8) | CAN-067 | gain-tunnel-functions |
| EF-23 | CAN-079 | outcome-vector-J* |
| EF-24 (Repair 9) | CAN-079 | outcome-vector-J* |
| EF-25 | CAN-067 | gain-tunnel-functions |
| EF-26 (Repair 10) | CAN-067 | gain-tunnel-functions |
| EF-27 | CAN-068 | epistemic-fusion-architecture-sequence |
| NCL-14 | CAN-069 | fusion-non-collapse-bundle |

### 22339909 — CTSA Human-Return Readout: A Session-Boundary Measurement Architecture for Retained Human Capability After AI (Epistemic Note v9.1 FINAL)

| label | → CAN id | canonical key |
|---|---|---|
| CTSA-01 | CAN-076 | human-return-CTSA6 |
| CTSA-02 | CAN-062 | K_like-noncollapse |
| CTSA-03 | CAN-113 | CTSA-taxonomy |
| CTSA-04 | CAN-076 | human-return-CTSA6 |
| CTSA-05 | CAN-113 | CTSA-taxonomy |
| NCL-10 | CAN-080 | ctsa-non-collapse-bundle |
| H1 | CAN-081 | ctsa-hypotheses |
| H2 | CAN-081 | ctsa-hypotheses |
| H3 | CAN-081 | ctsa-hypotheses |
| H4 | CAN-081 | ctsa-hypotheses |
| H5 | CAN-081 | ctsa-hypotheses |
| H6 | CAN-081 | ctsa-hypotheses |

### 22340255 — Uplift Note 2026-09-05 -- 25 proposals from the Epistemic Fusion papers to glosa: what was wrong, what was fixed, what stands

_(no displayed equations in this chapter)_

### 22341297 — Human Learning as Epistemic Architecture: A Method for Word Mapping, Life-Concept Graphs, Constraint Testing, and Corrigible Agency in the AI Age

_(no displayed equations in this chapter)_

### 22357744 — Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonance, Rhythm, Accumulation, and Transformative Release

| label | → CAN id | canonical key |
|---|---|---|
| EMG-01 | CAN-010 | human-readout-instance |
| EMG-02 | CAN-013 | meaning-giving |
| EMG-03 | CAN-013 | meaning-giving |
| EMG-04 | CAN-017 | experience-equation |
| EMG-05 | CAN-017 | experience-equation |
| EMG-06 | CAN-019 | naming-operator |
| EMG-07 | CAN-019 | naming-operator |
| EMG-08 | CAN-023 | retention-update |
| EMG-09 | CAN-021 | resonance |
| EMG-10 | CAN-021 | resonance |
| EMG-11 | CAN-021 | resonance |
| EMG-12 | CAN-021 | resonance |
| EMG-13 | CAN-198 | rhythm-momentum-accessibility |
| EMG-14 | CAN-198 | rhythm-momentum-accessibility |
| EMG-15 | CAN-226 | meaning-giving-non-collapse-bundle |
| EMG-16 | CAN-022 | accumulation-barrier |
| EMG-17 | CAN-022 | accumulation-barrier |
| EMG-18 | CAN-022 | accumulation-barrier |
| EMG-19 | CAN-022 | accumulation-barrier |
| EMG-20 | CAN-226 | meaning-giving-non-collapse-bundle |
| EMG-21 | CAN-041 | pre-prompt-human-state-transport |
| EMG-22 | CAN-041 | pre-prompt-human-state-transport |
| EMG-23 | CAN-023 | retention-update |
| EMG-24 | CAN-041 | pre-prompt-human-state-transport |
| EMG-25 | CAN-073 | ctsa-bridge |
| EMG-26 | CAN-073 | ctsa-bridge |
| EMG-27 | CAN-226 | meaning-giving-non-collapse-bundle |
| EMG-28 | CAN-166 | rival-model-ladder-experience |
| EMG-29 | CAN-226 | meaning-giving-non-collapse-bundle |

### 22357788 — Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective Agency in Human-AI Systems

| label | → CAN id | canonical key |
|---|---|---|
| CBC-01 | CAN-128 | B-SOC-LIVEPOSS |
| CBC-02 | CAN-128 | B-SOC-LIVEPOSS |
| CBC-03 | CAN-128 | B-SOC-LIVEPOSS |
| CBC-04 | CAN-128 | B-SOC-LIVEPOSS |
| CBC-05 | CAN-128 | B-SOC-LIVEPOSS |
| CBC-06 | CAN-128 | B-SOC-LIVEPOSS |
| CBC-07 | CAN-129 | B-SOC-NCLIST |
| CBC-08 | CAN-132 | B-SOC-POTENTIAL |
| CBC-09 | CAN-128 | B-SOC-LIVEPOSS |
| CBC-10 | CAN-134 | B-SOC-RECOVLIVE |
| CBC-11 | CAN-045 | B-HAI-PREPROMPT |
| CBC-12 | CAN-045 | B-HAI-PREPROMPT |
| CBC-13 | CAN-045 | B-HAI-PREPROMPT |
| CBC-14 | CAN-045 | B-HAI-PREPROMPT |
| CBC-15 | CAN-129 | B-SOC-NCLIST |
| CBC-16 | CAN-129 | B-SOC-NCLIST |
| CBC-P1 | CAN-130 | B-SOC-MEANPROP |
| CBC-P2 | CAN-130 | B-SOC-MEANPROP |
| CBC-P3 | CAN-130 | B-SOC-MEANPROP |
| CBC-P4 | CAN-130 | B-SOC-MEANPROP |
| CBC-P5 | CAN-130 | B-SOC-MEANPROP |
| CBC-H1 | CAN-131 | B-SOC-LIVEHYP |
| CBC-H2 | CAN-131 | B-SOC-LIVEHYP |
| CBC-H3 | CAN-131 | B-SOC-LIVEHYP |
| CBC-H4 | CAN-131 | B-SOC-LIVEHYP |
| CBC-H5 | CAN-131 | B-SOC-LIVEHYP |
| CBC-H6 | CAN-131 | B-SOC-LIVEHYP |
| CBC-H7 | CAN-131 | B-SOC-LIVEHYP |
| CBC-H8 | CAN-131 | B-SOC-LIVEHYP |

### 22361830 — Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseudo-Peace

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-132 | B-SOC-POTENTIAL |
| (2) | CAN-132 | B-SOC-POTENTIAL |
| (3) | CAN-132 | B-SOC-POTENTIAL |
| unnumbered | CAN-132 | B-SOC-POTENTIAL |
| (4) | CAN-133 | B-SOC-RECOVENV |
| (5) | CAN-133 | B-SOC-RECOVENV |
| (6) | CAN-135 | B-SOC-CORRIG |
| (7) | CAN-136 | B-SOC-PSEUDOPEACE |
| PAR-stepper | CAN-115 | B-SOC-LRSTEPPER |
| L1 | CAN-115 | B-SOC-LRSTEPPER |
| L2 | CAN-115 | B-SOC-LRSTEPPER |
| L3 | CAN-115 | B-SOC-LRSTEPPER |
| L4 | CAN-115 | B-SOC-LRSTEPPER |
| D1 (NC-78) | CAN-137 | B-SOC-SEVENDIST |
| D2 | CAN-137 | B-SOC-SEVENDIST |
| D3 | CAN-137 | B-SOC-SEVENDIST |
| D4 | CAN-137 | B-SOC-SEVENDIST |
| D5 | CAN-137 | B-SOC-SEVENDIST |
| D6 (NC-79) | CAN-137 | B-SOC-SEVENDIST |
| D7 | CAN-137 | B-SOC-SEVENDIST |
| P-A | CAN-136 | B-SOC-PSEUDOPEACE |
| P-B | CAN-138 | B-SOC-FALSIF |
| P-C | CAN-138 | B-SOC-FALSIF |
| P-D | CAN-138 | B-SOC-FALSIF |
| PAR-cert | CAN-139 | B-SOC-IDCERT |

### 22410666 — Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganization (Standalone Concept Note v1.0 FULL)

| label | → CAN id | canonical key |
|---|---|---|
| MBN-readout | CAN-010 | human-readout-instance |
| MBN-config | CAN-013 | meaning-giving |
| MBN-experience | CAN-017 | experience-equation |
| MBN-retention | CAN-023 | retention-update |
| MBN-naming | CAN-019 | naming-operator |
| MBN-resonance-diagnostic | CAN-021 | resonance |
| MBN-articulation | CAN-041 | pre-prompt-human-state-transport |
| §8-non-collapse-chain | CAN-225 | affective-semantic-non-collapse-bundle |
| §11-non-collapse-laws | CAN-225 | affective-semantic-non-collapse-bundle |
| H1 | CAN-019 | naming-operator |
| H2 | CAN-010 | human-readout-instance |
| H3 | CAN-019 | naming-operator |
| H4 | CAN-023 | retention-update |
| H5 | CAN-019 | naming-operator |
| H6 | CAN-225 | affective-semantic-non-collapse-bundle |

### 22424434 — Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility, Agency, and Human-AI Return

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-005 | readout-admission-order |
| (2) | CAN-005 | readout-admission-order |
| (3) | CAN-002 | root-state-tuple |
| (4) | CAN-003 | root-stepper |
| (5) | CAN-008 | constitutional-noncollapse |
| (6) | CAN-006 | domain-weld |
| (7) | CAN-065 | domain-weld-defect |
| (8) | CAN-037 | memk-record-noncollapse |
| (9) | CAN-010 | human-readout-instance |
| (10) | CAN-015 | meaning |
| (11) | CAN-016 | meaning-modes |
| (12) | CAN-017 | experience-equation |
| (13) | CAN-017 | experience-equation |
| (14) | CAN-020 | naming-loop |
| (15) | CAN-020 | naming-loop |
| (16) | CAN-023 | retention-update |
| (17) | CAN-023 | retention-update |
| (18) | CAN-024 | history-accessibility |
| (19) | CAN-024 | history-accessibility |
| (20) | CAN-024 | history-accessibility |
| (21) | CAN-057 | live-possibility |
| (22) | CAN-058 | live-set-weight |
| (23) | CAN-058 | live-set-weight |
| (24) | CAN-059 | choice-noncollapse-chain |
| (25) | CAN-059 | choice-noncollapse-chain |
| (26) | CAN-059 | choice-noncollapse-chain |
| (27) | CAN-060 | corrigible-agency-witnessed |
| (28) | CAN-124 | power-live-gap |
| (29) | CAN-042 | pre-prompt-transport |
| (30) | CAN-046 | ai-response-chain |
| (31) | CAN-062 | K_like-noncollapse |
| (32) | CAN-046 | ai-response-chain |
| (33) | CAN-046 | ai-response-chain |
| (34) | CAN-061 | live-possibility-dynamics |
| (35) | CAN-078 | D-R-A-constitutive |
| (36) | CAN-066 | session-retention-gate |
| (37) | CAN-066 | session-retention-gate |
| (38) | CAN-076 | human-return-CTSA6 |
| (39) | CAN-075 | exposure-retention-improvement-noncollapse |
| (40) | CAN-074 | assisted-vs-return-noncollapse |
| (41) | CAN-171 | provenance-ledger |
| (42) | CAN-037 | memk-record-noncollapse |
| (43) | CAN-057 | live-possibility |
| (44) | CAN-110 | rival-model-ladder-prechoice |
| (45) | CAN-110 | rival-model-ladder-prechoice |
| (46) | CAN-110 | rival-model-ladder-prechoice |
| (47) | CAN-110 | rival-model-ladder-prechoice |
| (48) | CAN-110 | rival-model-ladder-prechoice |
| (49) | CAN-005 | readout-admission-order |
| (50) | CAN-005 | readout-admission-order |
| H1 | CAN-109 | before-meaning-hypotheses |
| H2 | CAN-109 | before-meaning-hypotheses |
| H3 | CAN-109 | before-meaning-hypotheses |
| H4 | CAN-109 | before-meaning-hypotheses |
| H5 | CAN-109 | before-meaning-hypotheses |
| H6 | CAN-109 | before-meaning-hypotheses |

### 22456414 — AI–Cognitive Interaction: Activating Youth Potential through Reflective Dialogue and Linguistic Capital (Read Through Retention and the Live-Possibility Envelope) — 2026 Uplift Edition

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-057 | live-possibility |
| (2) | CAN-023 | retention-update |

### 22456487 — Operational Linguistic Wisdom (uplift 2026)

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-042 | pre-prompt-transport |
| (2) | CAN-062 | K_like-noncollapse |
| unlabeled (5, Reflexive Reconfiguration stage) | CAN-023 | retention-update |
| unlabeled (§2, falsifier condition) | CAN-126 | OLW-falsifier |
| unlabeled (§5.1, provenance ledger) | CAN-171 | provenance-ledger |
| unlabeled (§5.2, AVRH) | CAN-078 | D-R-A-constitutive |
| P1 | CAN-127 | OLW-propositions |
| P2 | CAN-127 | OLW-propositions |
| P3 | CAN-127 | OLW-propositions |
| P4 | CAN-127 | OLW-propositions |
| P5 | CAN-127 | OLW-propositions |
| P6 | CAN-127 | OLW-propositions |
| P7 | CAN-127 | OLW-propositions |
| P8 | CAN-127 | OLW-propositions |

### 22456564 — The Dialogue as the Ground of Enlightenment (uplift 2026)

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-015 | meaning |
| (2) | CAN-047 | human-AI-session-stepper |
| (3) | CAN-062 | K_like-noncollapse |
| (4) | CAN-074 | assisted-vs-return-noncollapse |
| (5) | CAN-078 | D-R-A-constitutive |
| unlabeled (§6, Framing bullet) | CAN-042 | pre-prompt-transport |
| unlabeled (§6, Integration bullet) | CAN-023 | retention-update |
| P1 | CAN-114 | dialogue-open-predictions |
| P2 | CAN-114 | dialogue-open-predictions |

### 22481924 — After Labour: Human Position in an AI-Robotic World System

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-140 | labour-claim-chain |
| (2) | CAN-201 | root-readout-gate |
| (3) | CAN-141 | epistemic-firewall-validation |
| (4) | CAN-062 | K_like-noncollapse |
| (5) | CAN-142 | machine-capacity-block |
| (6) | CAN-142 | machine-capacity-block |
| (7) | CAN-142 | machine-capacity-block |
| (8) | CAN-143 | labour-centrality |
| Labour-Decentering Proposition | CAN-143 | labour-centrality |
| (9) | CAN-142 | machine-capacity-block |
| (10) | CAN-142 | machine-capacity-block |
| (11) | CAN-144 | claim-constitution |
| (12) | CAN-144 | claim-constitution |
| (13) | CAN-144 | claim-constitution |
| (14) | CAN-144 | claim-constitution |
| (15) | CAN-144 | claim-constitution |
| (16) | CAN-146 | ownership-accumulation |
| (17) | CAN-146 | ownership-accumulation |
| (18) | CAN-146 | ownership-accumulation |
| (19) | CAN-147 | scarce-asset-rent |
| (20) | CAN-147 | scarce-asset-rent |
| (21) | CAN-147 | scarce-asset-rent |
| (22) | CAN-145 | demand-realization |
| (23) | CAN-145 | demand-realization |
| (24) | CAN-145 | demand-realization |
| (25) | CAN-145 | demand-realization |
| (26) | CAN-148 | conversion-gates |
| (27) | CAN-148 | conversion-gates |
| (28) | CAN-148 | conversion-gates |
| (29) | CAN-148 | conversion-gates |
| (30) | CAN-149 | relational-class-position |
| (31) | CAN-150 | pe-to-human-bridge |
| (32) | CAN-057 | live-possibility |
| (33) | CAN-061 | live-possibility-dynamics |
| (34) | CAN-157 | corrigible-agency-worldsystem |
| (35) | CAN-158 | human-return-worldsystem |
| (36) | CAN-152 | social-role-standing |
| (37) | CAN-152 | social-role-standing |
| (38) | CAN-153 | social-reproduction |
| (39) | CAN-153 | social-reproduction |
| (40) | CAN-151 | human-systemic-position |
| (41) | CAN-151 | human-systemic-position |
| (42) | CAN-151 | human-systemic-position |
| (43) | CAN-151 | human-systemic-position |
| (44) | CAN-151 | human-systemic-position |
| (45) | CAN-154 | power-channels |
| (46) | CAN-154 | power-channels |
| (47) | CAN-154 | power-channels |
| (48) | CAN-154 | power-channels |
| (49) | CAN-154 | power-channels |
| (50) | CAN-154 | power-channels |
| (51) | CAN-140 | labour-claim-chain |
| (52) | CAN-155 | early-warning-diagnostic |
| (53) | CAN-148 | conversion-gates |
| (54) | CAN-156 | after-labour-river-summary |
| (55) | CAN-145 | demand-realization |
| (56) | CAN-153 | social-reproduction |
| (57) | CAN-151 | human-systemic-position |

### 22481926 — The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibility Window in an AI-Robotic World

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-159 | human-conversion-vector |
| (2) | CAN-160 | conversion-noncollapse-bundle |
| (3) | CAN-160 | conversion-noncollapse-bundle |
| (4) | CAN-160 | conversion-noncollapse-bundle |
| (5) | CAN-160 | conversion-noncollapse-bundle |
| (6) | CAN-160 | conversion-noncollapse-bundle |
| (7) | CAN-160 | conversion-noncollapse-bundle |
| (8) | CAN-160 | conversion-noncollapse-bundle |
| (9) | CAN-160 | conversion-noncollapse-bundle |
| (10) | CAN-160 | conversion-noncollapse-bundle |
| (11) | CAN-159 | human-conversion-vector |
| (12) | CAN-159 | human-conversion-vector |
| (13) | CAN-159 | human-conversion-vector |
| Proposition 1 | CAN-159 | human-conversion-vector |
| (14) | CAN-161 | epistemic-conversion-mechanism |
| (15) | CAN-161 | epistemic-conversion-mechanism |
| Proposition 2 | CAN-161 | epistemic-conversion-mechanism |
| (16) | CAN-162 | bad-mode-state |
| (17) | CAN-163 | reversibility-window-urgency |
| Proposition 3 | CAN-163 | reversibility-window-urgency |
| (18) | CAN-163 | reversibility-window-urgency |
| (19) | CAN-163 | reversibility-window-urgency |
| (20) | CAN-163 | reversibility-window-urgency |
| (21) | CAN-163 | reversibility-window-urgency |
| (22) | CAN-164 | distributional-conversion |
| (23) | CAN-164 | distributional-conversion |
| Proposition 4 | CAN-164 | distributional-conversion |
| (24) | CAN-161 | epistemic-conversion-mechanism |
| (25) | CAN-159 | human-conversion-vector |
| (26) | CAN-159 | human-conversion-vector |

### 22481928 — How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol for Durable Human Capability (v1.3 glosa-checked)

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-042 | pre-prompt-transport |
| (2) | CAN-046 | ai-response-chain |
| (3) | CAN-023 | retention-update |
| (4) | CAN-044 | DCP-topic-entry |
| (5) | CAN-044 | DCP-topic-entry |
| (6) | CAN-044 | DCP-topic-entry |
| (7) | CAN-044 | DCP-topic-entry |
| PFDP | CAN-044 | DCP-topic-entry |
| (8) | CAN-082 | DCP-deployment-triage |
| (9) | CAN-082 | DCP-deployment-triage |
| AFP | CAN-082 | DCP-deployment-triage |
| (10) | CAN-082 | DCP-deployment-triage |
| (11) | CAN-083 | DCP-protocol-stages |
| (12) | CAN-043 | entry-state-anchor |
| (13) | CAN-043 | entry-state-anchor |
| (14) | CAN-083 | DCP-protocol-stages |
| (15) | CAN-083 | DCP-protocol-stages |
| (16) | CAN-083 | DCP-protocol-stages |
| (17) | CAN-083 | DCP-protocol-stages |
| (18) | CAN-070 | equivalence-class-diagnostic |
| (19) | CAN-084 | DCP-verify-stage |
| (20) | CAN-084 | DCP-verify-stage |
| (21) | CAN-084 | DCP-verify-stage |
| (22) | CAN-085 | DCP-integrate-stage |
| (23) | CAN-086 | DCP-remove-stage |
| (24) | CAN-086 | DCP-remove-stage |
| (25) | CAN-077 | human-return-CTSA4 |
| (26) | CAN-087 | DCP-return-conversion-vector |
| (27) | CAN-074 | assisted-vs-return-noncollapse |
| (28) | CAN-087 | DCP-return-conversion-vector |
| (29) | CAN-088 | DCP-return-action-feedback |
| (30) | CAN-088 | DCP-return-action-feedback |
| WCP | CAN-088 | DCP-return-action-feedback |
| (31)-(32) | CAN-089 | DCP-expand-contract |
| (33)-(34) | CAN-089 | DCP-expand-contract |
| (35) | CAN-082 | DCP-deployment-triage |
| (36) | CAN-125 | DCP-relational-route |
| (37) | CAN-200 | DCP-burden-vector |
| (38) | CAN-200 | DCP-burden-vector |
| (39) | CAN-172 | DCP-status-categories |
| (40)-(41) | CAN-112 | decisive-record-argmax |
| (42) | CAN-112 | decisive-record-argmax |
| DCPp | CAN-090 | DCP-open-propositions |
| DEPp | CAN-090 | DCP-open-propositions |
| AgP | CAN-090 | DCP-open-propositions |
| H1 | CAN-091 | DCP-hypotheses |
| H2 | CAN-091 | DCP-hypotheses |
| H3 | CAN-091 | DCP-hypotheses |
| H4 | CAN-091 | DCP-hypotheses |
| H5 | CAN-091 | DCP-hypotheses |
| H6 | CAN-091 | DCP-hypotheses |
| H7 | CAN-091 | DCP-hypotheses |
| H8 | CAN-091 | DCP-hypotheses |
| H9 | CAN-091 | DCP-hypotheses |
| H10 | CAN-091 | DCP-hypotheses |
| (43) | CAN-044 | DCP-topic-entry |
| (44) | CAN-088 | DCP-return-action-feedback |
| (45) | CAN-083 | DCP-protocol-stages |
| (46) | CAN-092 | DCP-closing-questions |

### 22498047 — From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Unequal Life Conditions, and Opportunity Conversion (RG-HCA)

| label | → CAN id | canonical key |
|---|---|---|
| (1) | CAN-002 | root-state-tuple |
| (2) | CAN-003 | root-stepper |
| (3) | CAN-006 | domain-weld |
| (4) | CAN-008 | constitutional-noncollapse |
| (5) | CAN-098 | HCA-native-river |
| (6) | CAN-099 | HCA-candidate-state |
| (7) | CAN-065 | domain-weld-defect |
| (8) | CAN-100 | life-capital-context |
| (9) | CAN-101 | capability-conversion-noncollapse |
| (10) | CAN-101 | capability-conversion-noncollapse |
| (11) | CAN-101 | capability-conversion-noncollapse |
| (12) | CAN-102 | barrier-readout |
| (13) | CAN-102 | barrier-readout |
| (14) | CAN-112 | decisive-record-argmax |
| (15) | CAN-103 | candidate-vs-endorsed-routes |
| (16) | CAN-103 | candidate-vs-endorsed-routes |
| (17) | CAN-103 | candidate-vs-endorsed-routes |
| (18) | CAN-103 | candidate-vs-endorsed-routes |
| (19) | CAN-103 | candidate-vs-endorsed-routes |
| (20) | CAN-112 | decisive-record-argmax |
| (21) | CAN-112 | decisive-record-argmax |
| Human Capability Advancement Principle | CAN-098 | HCA-native-river |
| (22) | CAN-104 | scaffold-fading |
| (23) | CAN-104 | scaffold-fading |
| (24) | CAN-077 | human-return-CTSA4 |
| (25) | CAN-074 | assisted-vs-return-noncollapse |
| (26) | CAN-104 | scaffold-fading |
| (27) | CAN-088 | DCP-return-action-feedback |
| (28) | CAN-105 | opportunity-conversion |
| (29) | CAN-105 | opportunity-conversion |
| (30) | CAN-105 | opportunity-conversion |
| (31) | CAN-105 | opportunity-conversion |
| (32) | CAN-107 | HCA-worked-scenario |
| (33) | CAN-107 | HCA-worked-scenario |
| (34) | CAN-108 | HCA-governance-bundle |
| (35) | CAN-108 | HCA-governance-bundle |
| (36) | CAN-106 | net-advancement-record |
| (37) | CAN-106 | net-advancement-record |

