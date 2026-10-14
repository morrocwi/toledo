# PROP-TCM-BIRCA-01 — How Toledo reads Chinese medicine (knowledge translation, not prediction)

**Date:** 2026-10-14  
**Status:** [NEW DERIVATION/PROPOSAL], DRAFT, **BIOLOGICAL WELD HOLD**, no clinical authorization.  
**Purpose:** Read and connect Chinese-medicine knowledge through information/metadata; **not** to predict any person's health, personality, qi or response.  
**Evidence policy:** PubMed ONLY for biological evidence; no GEO or synthetic patient data in this trial.  
**Dependencies:** [TCM standalone research reference](../external_references/TCM_Qi_Acupoint_Information_Equation_v1.0.md) (copied as a **noncanonical** document); Genesis v5.1 Life tuple (external, non-Toledo canonical anchor).


## Repository installation and downstream adapter (2026-10-14)

This proposal is **uploaded as a DRAFT knowledge-translation crosswalk**, and both repository links are explicitly paired:

- **Toledo upstream:** this proposal, plus the full [TCM 361-point standalone reference snapshot](../external_references/TCM_Qi_Acupoint_Information_Equation_v1.0.md) kept under `docs/external_references/` as **noncanonical research material**, not new registered Toledo equations.
- **BIRCA Admin downstream:** [non-predictive reading contract](https://github.com/morrocwi/birca_admin_5.0/blob/research/tcm-knowledge-readout-20261014/docs/TCM_TOLEDO_KNOWLEDGE_READOUT_BRIDGE_V1.md), [typed JSON Schema](https://github.com/morrocwi/birca_admin_5.0/blob/research/tcm-knowledge-readout-20261014/docs/contracts/tcm_toledo_birca_semantic_bridge_v1.json), and [companion draft PR #22](https://github.com/morrocwi/birca_admin_5.0/pull/22).

**Directed dependency:** `TCM historical/atlas sources → Toledo noncanonical semantic crosswalk → BIRCA contextual reader`. BIRCA does not issue, modify or validate Toledo mathematical claims. No runtime integration has been performed. All biological mechanism or quantitative prediction obligations remain **HOLD**.

## Follow-up: Yintang → lower dantian, specifically an **attention** path (2026-10-14)

See **[PROP-TCM-ATTENTION-01](PROP-TCM-ATTENTION-01.md)** for traced Chinese text and a modern gentle, non-forced self-acupressure/awareness sequence. **This is NOT a physical Qi-transport equation and NOT a personal prediction.**

- `印堂 EX-HN3` is an **extra point, outside WHO 361**: retain `361_standard_points` separately from `extra_points`.
- `下丹田` is a traditional lower-abdomen attention region, not one invariant point: `CV6 氣海` is 1.5 cun below navel; `CV5 石門` is 2 cun and has classical alias `丹田` in 《針灸大成》; `CV4 關元` is 3 cun below.
- A reported sensation `"brow swirling"` is a *subjective self-report*, not measured upper-dantian excess or trapped Qi.
- A route `Yintang → relaxed torso → lower abdomen` is encoded as `attention_sequence` only: it cannot silently become an anatomical channel edge, biological coupling or CAN-006 weld.
- The modern light-touch Yintang self-care instructions are **separate** from the ancient textual witnesses and from PubMed-indexed clinical evidence.
- Record observed ratings only if genuinely supplied; do not invent numerical relief. No claimed improvement in anger, hunger, libido or any individual patient.

## 2026-10-14 — QiHua information TRANSFORMATION and ten-condition comparison

**[PROP-TCM-QIHUA-10CASE-01.md](PROP-TCM-QIHUA-10CASE-01.md)** archives the user's corrected definition **ชี่ = การแปรเปลี่ยนสารสนเทศ, ไม่ใช่การเคลื่อนไหว**, while preserving the classical polysemy of 氣 and the distinct term 氣化. The proposed operator is a **noncanonical, observer/source-indexed interpretation of CAN-003 informational state change**, not a literal transport of Qi or a new proven biological equation.

Ten disease categories and candidate point-code sets were retrospectively aligned by hand (10/10 *listed*), with no blinded predictions, no primary-source check for each case, no validated point effects, no human numerical assay and **no clinical accuracy**. The status is **DESCRIPTIVE_DRAFT / BLIND_TEST_NOT_RUN / BIOLOGICAL_WELD_HOLD**.

**BIRCA ADMIN (not `morrocwi/birca`) companion**: [ten-condition research handoff](https://github.com/morrocwi/birca_admin_5.0/blob/research/tcm-knowledge-readout-20261014/docs/TCM_QIHUA_10_CONDITION_READOUT_AUDIT_V1.md) and [machine-readable 10-case register](https://github.com/morrocwi/birca_admin_5.0/blob/research/tcm-knowledge-readout-20261014/docs/contracts/tcm_qihua_10_conditions_v1.json). Do not interpret the five analogy classes as TCM diagnoses or prescriptions.

## Primary purpose / จุดประสงค์หลัก: READ TCM, not predict a person

**ภาษาไทย:** เอกสารนี้ลงทะเบียนวิธีที่ Toledo **อ่าน/แปล/เชื่อมองค์ความรู้แพทย์แผนจีน** กับสมการชีวิตและกรอบสุขภาพของ BIRCA Admin อย่างมีขอบเขต ไม่ได้พยากรณ์อาการของผู้เขียน ไม่ได้วินิจฉัยภาวะชี่ติดขัด และไม่ได้อ้างประสิทธิผลของการฝังเข็ม

**English:** This is a **knowledge-representation and translation crosswalk**, not a fitted biophysical model. Its outputs answer:
1. What does a traditional Chinese medical term or point mean *within its source tradition*?
2. How is that term represented as typed labels, relations, locations and provenance in an information graph?
3. Which existing Toledo/BIRCA concept can read that representation **without changing its meaning or claim tier**?
4. Is there an explicitly sourced PubMed study of a matching point/protocol/measurement? If absent, leave that evidence slot **null/HOLD**.

It does **not** answer: "which meridian is blocked in this person", "which point will cure them", "what will their TNF/IL-6 be", or "what their sexual personality means physiologically".

### 1. Layers: translation is not a biological weld

| Layer | Knowledge or readout | What is retained | What is NOT claimed |
| --- | --- | --- | --- |
| T0 traditional source | Huangdi Neijing / later TCM text | original Chinese wording, edition/location, interpretation and disagreement | an accepted modern causal mechanism |
| T1 clinical language | 陰陽 yin–yang, 氣 qi, 血 blood, 津液 fluids, 精 jing, 神 shen, 臟腑 zang-fu, patterns 證 | source-specific conceptual relationships | modern biochemical quantities with same names |
| T2 body-point atlas | WHO-style point code + named channel + later verified anatomy | addressable code, point name, anatomical landmark **only if independently documented** | physical tubes for qi; nerve/organ identity |
| T3 information graph | typed nodes and source-backed directed/undirected relations | attribution: "term A associated-with term B according to source X" | transfer of causal or anatomical proof |
| T4 Toledo reading | CAN-003 retained state, CAN-201 readout-not-state, CAN-006 dynamic weld **open** | step-based information and separation between state and description | identified native steps for the human body |
| T5 BIRCA Admin | typed disease/health lanes; study-specific assays | compatibility of metadata, units, intervention context, citation, gates | individual diagnosis or drug/acupoint efficacy |
| T6 PubMed context | primary article, exposure, comparator, population, modality, outcome | what the *specific authors actually measured/reported* | pooled coefficients, point-specific effect if multiple points used |
| T7 Life layer | external Genesis v5.1 annotation: life/memory/adaptation readouts | conceptual lineage and causal-step vocabulary | fitted life/health forecast |

Traditional "Liver" 肝 / "Kidney" 腎 / "Spleen" 脾 are **zang-fu functional categories**, not automatically identical to the anatomical liver, kidney and spleen. Likewise "heat", "wind", "stagnation", "deficiency", five phases 五行 and meridians 經絡 remain *traditional descriptive categories* unless an independently measured bridge is admitted. Pattern labels are not diagnostic conclusions drawn from personality traits.

### 2. What a formal reading record contains (minimal semantic contract)

~~~text
TCM_KNOWLEDGE_RECORD:
  term_id
  chinese_original
  romanization_and_translations[]
  source_edition_and_location
  exact_quote_or_traceable_paraphrase
  conceptual_level: [theory | pattern | sign | intervention | point | channel]
  traditional_relations[]: {predicate, target_term, source, interpretation_tier}
  WHO_point_code_if_applicable: null | code
  anatomical_landmark_source: null | atlas_citation
  evidence_status: [source_pending | source_verified | interpretation_contested]
  prohibited_inference: ["point-code implies organ effect", "pattern implies disease"]

BIOLOGICAL_STUDY_RECORD:
  pubmed_id
  species_and_population
  point_or_protocol_set[]
  stimulation_method_and_dose_as_published
  comparison_or_sham
  outcome_assay_type
  measurement_unit
  observed_time_in_study
  author_reported_result
  reported_uncertainty
  evidence_status: [missing | publication_reported | independently_checked]
  native_toledo_step_index: null
~~~

The **connection** is a documented relation between records (shared *coded point*, *study protocol*, *traditional naming*, or *research question*), not an assumption that two latents are equal. Missing observations are null, not zero. One point used in a multi-point trial is NOT a uniquely estimated point effect.

### 3. Demonstration of HOW a term is read (no subject prediction)

| Traditional entry | TCM-internal interpretation | Toledo knowledge readout | BIRCA readout boundary |
| --- | --- | --- | --- |
| 思則氣結 (classical passage, source edition to verify) | worry/rumination **described** as binding qi | textual relation: thought/rumination ↔ qi-binding, with source and certainty; NOT a numeric measured blocked flow | no cytokine value, no personal implication; HOLD |
| 肝氣鬱結 (pattern) | zang-fu *Liver qi constraint* in the TCM classification | typed pattern node with stated reported signs; no diagnosis inferred | no anatomical hepatic disease equivalence; HOLD |
| LR3 太衝 | point label linked to the Liver channel in the atlas | point-code node and channel edge; geographical/anatomic coordinates only from checked atlas | no biomarker or efficacy from a label alone; HOLD |
| BL23 腎俞 | named point with traditional channel membership | can link to a PubMed-indexed **study** record about BL23, retaining sham, population and assay | study-level report, **not** portable causal parameter or health forecast |
| 精 / 神 / 氣 | distinct traditional constructs (jing, shen, qi) | separately typed nodes: no renaming as hormones, brain activity, or calories | conversion to laboratory units is not licensed |

### 4. Explicit joining logic (metadata-level only)

~~~text
TCM_SOURCE --cites--> TCM_CONCEPT
TCM_CONCEPT --traditionally-associated-with--> TCM_PATTERN
TCM_POINT --member-of-according-to-atlas--> TCM_CHANNEL
TCM_POINT --occurs-in--> INTERVENTION_PROTOCOL
INTERVENTION_PROTOCOL --studied-in--> PUBMED_ARTICLE
PUBMED_ARTICLE --reports--> MEASUREMENT
MEASUREMENT --has-modality/units/clock/context--> TYPED_METADATA
TCM_KNOWLEDGE_RECORD --annotates--> TOLEDO_READOUT_SCHEMA
TYPED_METADATA --eligible-for-evidence-check--> BIRCA_STUDY_LEDGER
~~~

A join exists *only if its source, point code, exact intervention protocol, population and assay context survive reconciliation*. An edge is **source attribution**, NOT transitive biological causation. In particular,
- semantic_link(TCM, BIO) **does not imply** CAN-006 commutation;
- code_sequence_edge(point_i, point_j) **does not imply** anatomical conduction;
- TCM "qi" **does not imply** measurable fluid, electromagnetic field, neurotransmitter or energy;
- publication_exists **does not imply** treatment works;
- person's narrative/personality **does not imply** latent pattern diagnosis.

### 5. Toledo/Genesis rules retained unchanged

**CAN-003:** native retained step n is not assumed equal to seconds/hours or the number of acupuncture visits. A clinic observation time is a typed protocol field, not n.

**CAN-201:** readout != state. An encoded traditional concept, a laboratory cytokine, and the root retained state cannot be collapsed into one object.

**CAN-006 / CAN-165:** to upgrade a semantic relation to a dynamic/forecast bridge, independent evidence must identify a compatible state-to-assay map and satisfy the required domain/factorization gates; these are explicitly **HOLD**, not "verified by mapping".

**EQ-001/B.29–B.30:** remain **OPEN**. This proposal does not close the real biological encoder or domain-weld problem.

**External Genesis Life v5.1:** permits a conceptual index of memory/life events, with labels attributed to their source, but imports NO second mathematical authority into Toledo. Equations stored only in external TCM documentation remain *external proposals*, not Toledo canonical codes.

### 6. Non-prediction acceptance tests for this crosswalk

A knowledge-reading record can pass at the **semantic** level if it:
- retains traditional original wording, translation ambiguity and source attribution;
- distinguishes organ language from modern anatomical and molecular constructs;
- distinguishes point identifier from experimentally verified coordinates and exposure;
- distinguishes human-study citations from biological effect estimates;
- preserves unknown fields, provenance and uncertainty without filling data;
- uses causal-step language without assuming a clock conversion;
- never generates individual health, mood, desire, "qi blockage", intervention or personality forecasts.

**Output contract:** `SEMANTIC_MAP_READY` may coexist with `BIOLOGICAL_WELD_HOLD` and `PERSONAL_PREDICTION_NOT_IN_SCOPE`. Structural code checks or syntactic mapping are **not** biological validation. This document's acceptance is therefore about intelligible reading and traceability, not prediction accuracy.

---

## Reuse-first / canonical Toledo parents

The Toledo registry (not external Genesis notation) governs the equations:

| Canonical id | Toledo code | Reused meaning |
| --- | --- | --- |
| CAN-003 | `EQ-015/M.02.v1` | `S[n+1]=F(S[n],u[n],c[n],T[n])` native retained-step law |
| CAN-006 | `weld/M.02.v1` | `q_D∘F = F_D∘q_D` admissible domain-weld obligation |
| CAN-007 | `weld/M.03.v1` | finite-horizon observational equivalence |
| CAN-165 | `EQ-002/M.01.v1` | prediction/readout factorization requirement |
| CAN-201 | `EQ-002/M.03.v1` | partial readout distinct from full state |
| CAN-023 | `EQ-015/E.08.v1` | human memory record as retained readout |
| RGD-BIOLOGY-007 | `EQ-001/B.07.v1` | abstract integrity/reserve ledger, **not** clinical Qi |
| RGD-BIOLOGY-029/030 | `EQ-001/B.29.v1`, `EQ-001/B.30.v1` | real biological encoder & causal weld **OPEN** |

Nothing here changes root F, constructs a human-to-step clock, or claims a Coq proof for Qi.

## Optional research-only point–protocol–assay relation [NEW DERIVATION/PROPOSAL]

Beyond the primary semantic mapping, the following **optional research-only** relation indexes publications. It is not needed to read TCM and is not a physics-of-Qi equation:

```text
TCM_POINT_ASSAY_RELATION:
  (WHO_point_code,
   intervention_protocol,
   intervention_comparator,
   population_and_context,
   assay_name,
   assay_modality,
   measurement_unit,
   laboratory_observation_time,
   PubMed_ID,
   article_reported_result,
   provenance_status)
```

Typed projections `q_TCM(S_n)`, `q_BIO(S_n)` and the **external** Life annotation `Λ_life(n)` can coexist as **different readouts** of CAN-003 without being identical, complete or invertible. The proposed annotation `(Λ_life(n),q_TCM(S_n),q_BIO(S_n),provenance,status)` is not a new mother equation.

The claimed quantitative equation `q_BIO(F(S_n)) = F_BIO(q_BIO(S_n))` is **NOT satisfied by registration alone**; it is an unfulfilled CAN-006 test obligation. Likewise, point-label graph membership does NOT imply functional nerve, blood-flow or Qi conduits.

## Prior local structural audit (not a biological simulation; not re-run for this semantic revision)

The local artifact `TCM_Qi_Acupoint_Information_Equation_v1.0.md` contains 361 labelled point IDs, 14 canonical channel groups and 347 code-sequence edges (361 - 14). An executed offline parser + SymPy algebra audit gave **17/17 structural PASS**, explicitly restricted to source-list consistency, graph identity, retained-step telegraph algebra, type separation, and fail-closed status. This is **not 17 validated physiological hypotheses** and does not establish WHO exact atlas coordinates. The precise local script and machine-readable audit are separate downloadable handoff artifacts, not currently executed in Toledo CI.

### Real human PubMed-only point+biochemical studies

- [PMID 21438784](https://pubmed.ncbi.nlm.nih.gov/21438784/): 90 healthy volunteers; GV14, LI11, ST36, SP6 and sham; **no significant TNF-alpha change** in any point group (author abstract).
- [PMID 37542799](https://pubmed.ncbi.nlm.nih.gov/37542799/): sham-controlled phase 1 BL23; 16 adults; study-reported cytokine differences, limited sample.
- [PMID 20496732](https://pubmed.ncbi.nlm.nih.gov/20496732/): combined-point depression study, IL-1beta/IL-6 biomarkers; not an individual point coefficient.
- [PMID 36948325](https://pubmed.ncbi.nlm.nih.gov/36948325/): crossover point-protocol comparisons; no statistically decisive protocol difference for several cytokines as reported.

Existing BIRCA [PROP-REALITY-03](./PROP-REALITY-03-PUBMED-ONLY.md) addresses **LPS tolerance**, not acupoint exposure. LPS-derived cytokine percentages are NOT acupuncture effects and must not be pooled as a readout coefficient.

## Gate register

| Claim | Result | Reason |
| --- | --- | --- |
| TCM code namespace and chain graph | PASS_STRUCTURE | code labels and algebra, not exact atlas coordinates |
| Symmetric nonnegative graph Laplacian PSD identity | PASS_MATH_CONDITIONAL | `xᵀLx=Σ_e w_e(x_i-x_j)²≥0` |
| Telegraph energy derivative | PASS_MATH_CONDITIONAL | `E'=-||q'||²+<q',f>`; monotonicity ONLY if `f=0` |
| Biological source existence | PUBMED_STUDY_LEVEL | human articles have point and biomarker metadata |
| Native retained-step assay encoder | HOLD | unknown independent step-to-assay calibration |
| Sufficiency/kernel condition | HOLD | no source provides subject-level factorization test |
| TCM latent Qi value or blockage site | HOLD | no identified measurement operator |
| BIRCA B.29/B.30 | OPEN/HOLD | existing Toledo biology is unclosed |
| Individual clinical prediction or treatment | REJECT_AS_DERIVED_CLAIM | experiment is an ontology bridge, not a clinical trial |

**Known source notation defect:** original TCM `EQ-QI-04` uses an ambiguous `B u_s` near incidence `B`, while `EQ-QI-03` uses input operator `B_u`; require shape/notation repair before any numerical use.

**Next rigorous test:** PubMed-only paper with explicit point(s), intervention/sham, typed participant- or arm-level longitudinal assay observations, native step witness, and sufficient raw or article-published paired data; otherwise HOLD. Human/clinical safety review required for any application.

**Provenance:** Toledo `EQUATION_SOURCE_POLICY.md` (TG-RFG-01), `registry/EQ_LIBRARY.md`; `morrocwi/readout_genesis` ontology; `morrocwi/readout_universe` epistemology; `morrocwi/birca_admin_5.0` PubMed evidence boundary.