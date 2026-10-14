# PROP-TCM-BIRCA-01 — Point–protocol–assay information readout bridge

**Date:** 2026-10-14  
**Status:** [NEW DERIVATION/PROPOSAL], DRAFT, **BIOLOGICAL WELD HOLD**, no clinical authorization.  
**Evidence policy:** PubMed ONLY for biological evidence; no GEO or synthetic patient data in this trial.  
**Dependencies:** TCM_Qi_Acupoint_Information_Equation_v1.0.md (external research artifact); Genesis v5.1 Life tuple (external, non-Toledo canonical anchor).

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

## The minimal new object [NEW DERIVATION/PROPOSAL]

Define a typed, provenance-preserving **relation**, not a physics-of-Qi equation:

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

## Structural audit actually run (not a biological simulation)

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