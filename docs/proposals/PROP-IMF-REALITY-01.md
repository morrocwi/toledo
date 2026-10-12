# PROP-IMF-REALITY-01 — Step-native reality bridge and biochemical readout admission

**2026-10-12 · NEW DOMAIN PROPOSAL · status OPEN · no canonical or clinical promotion.**

Primary information ontology: Readout Universe RD1–RD9 (RD2/RD3 successor, RD4 retained distinction), AP7 append-only record, Doctrine of Quantity (quantity is a finite question-indexed readout), Omega_all translation first. Domain ontology: Readout Genesis. Mathematical source remains Toledo **CAN-003 F-stepper** (CAN-006 domain quotient and CAN-007/034 readout sufficiency obligations, CAN-009 record invariance). No second universal physical/biochemical mother equation. Biological joins EQ-001/B.29 and EQ-001/B.30 remain **OPEN**.

## One primitive and two independently identified observers

Native state:

    H_(n+1) = Append(H_n, rho_n)
    Z_(n+1) = F_step(Z_n, rho_n, c_n, Access(H_n); theta_step)
    r_(Q,n) = Pi_(Q,c)(Z_n,H_n)

Here n counts retained transitions, not physical seconds/hours. theta_step is a family of dimensionless per-transition update weights, NOT an SI clock rate nor known biology. The information tape records events, not a laboratory timestamp ontology.

Observation of *laboratory clock* is a separate question:

    t_lab(j) = Clock_(instrument, protocol)(n_j) [hours]

Observation of *biochemical assay* is another separate question:

    y_(feature,j) = Encode_(modality,assay,specimen,feature)(r_(Q,n_j)) + eps_j

A measured clock anchor cannot independently determine the count n_j of invisible transitions. A measured cytokine pg/mL cannot be equated with a gene-expression array VALUE, epigenomic peak count, TEER or TEWL. If step index or assay reader is unidentified, computation must return HOLD rather than invent a step/hour factor.

## Identifiability falsifier before fitting kinetics

If a two-point observer schedule contains 0 and 4 measured laboratory hours, candidate invisible step counts 4, 8 and 16 are all compatible with the time labels alone. They do not correspond to unique latent histories without independent event/assay witnesses. Therefore:

    identify_steps([0h,4h], [4,8,16]) -> HOLD_STEP_COUNT_NONIDENTIFIABLE

Matching a time series by freely choosing step counts after seeing held-out outcomes is invalid model selection and must be stopped. A preidentified sample-to-native-step bridge can be registered only with independently evidenced protocol provenance and uncertainty.

## Step refinement: uncertainty is not an invitation to change ontology

Construct an explicit event tape and compare the final question-indexed readout after replaying it under the present step rules with a tape in which events are repeated twice. Existing per-transition weights may produce different results: this is a reproducible **step-granularity sensitivity** result (FAIL_REFINEMENT_COVARIANCE), not a proof that two physically equivalent experiments must give the same outcomes. A scientifically useful refinement law must first say which split events constitute the same informational history and how the rule parameters transport under that equivalence. This is a mandatory OPEN next mathematical gate before broad physical mapping.

## Biochemical reader is a typed empirical adapter, not a molecular proof

Experimental data record must include source accession, donor and unique subject/sample, assay identifier, modality, analyte/probe ID, value, unit, specimen, observer timestamp, and—when demonstrably identified—the corresponding native retained step.

The companion BIRCA readout engine can fit a candidate affine encoder ONLY on TRAIN pairs with preidentified step states and matching assay units from distinct donors. No mixed RNA-to-protein conversion, no post-target information, no extrapolation between incompatible assays. Unlike the information-step source language, a fitted empirical readout curve requires external physical data. It is not a root theorem. Empirical time-based first-order decay benchmarks belong to the observer/readout layer only.

## First actual public dataset / scope ceiling

[GSE22248](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE22248) (PMID 21576504) contains **12 Illumina HumanRef-8 v3.0 microarray PBMC samples** (four human donors, each untreated/LPS once/LPS twice). Verified accession identifiers: donor 21 GSM553736–738; donor 46 GSM553739–741; donor 86 GSM553742–744; donor 92 GSM553745–747. BIRCA research [PR #21](https://github.com/morrocwi/birca_admin_5.0/pull/21) freezes 21/46/86 for TRAIN and 92 for held-out TEST. The exact GEO processed matrix bytes are SHA256-logged when available. The built-in empirical comparison predicts donor-92 DOUBLE-LPS MINUS SINGLE-LPS quantile-normalized probe-value contrast using only training-donor mean or median contrast, versus zero-contrast/no-history baseline.

**This test is NOT Toledo Step-Native biological prediction.** It is a descriptive cross-donor, same-endpoint RNA array effect comparison. It cannot identify invisible information steps from sparse lab observation, cannot produce IL-6 pg/mL, and cannot prove genuine trained immunity kinetics or individual clinical prognosis. The test donor count is ONE and array probes are correlated, not independent human patients. The donor split was chosen after accession metadata were public; not blind external validation.

## Four target phenomena — unpassed REALITY gates

1. **Signal persistence after external input ends:** matched protein/assay samples and source removal control required. In-silico echo is only a domain posit.
2. **Relapse/training/tolerance:** step-aligned monocyte priming/washout/rechallenge with measured independent readout. GSE22248 may show an RNA history contrast but cannot measure native step count.
3. **Marker quiet while tissue not healed:** paired protein plus TEER/TEWL or measured barrier function in same system; two toy channels are not quantitative evidence.
4. **Functional recovery vs apparent:** held-out prospective multi-endpoint outcomes and approved challenge-equivalence protocol; no toy threshold carries clinical authority.

## Release criteria

1. Reproduce software gate and negative step-identifiability witness across circumstances.
2. Identify event-refinement/composition and explicitly test granularity covariance.
3. Verify assay provenance/unit/modality/instrument, independent step-clock inference.
4. Lock train/test donors/studies and biological readout encoder before testing unseen measurements; compare without-memory/simple kinetic/statistical competitors.
5. Report measured error, uncertainty and every adverse/HOLD case without overwriting earlier results.
6. Complete independent Toledo B.29/B.30 validation and biological/clinical expert review before any physiological accuracy claim.

Tier: RD ontology is founder-stated source; algebra in posited F is finite_diagnostic; physical biochemical truth OPEN. This proposal does not claim that primitive time does not exist in physics; it maintains a **step-first modeling commitment** from which physical clock comparisons are downstream readouts.


## Empirical audit update, 2026-10-12 — actual GEO reached, native Toledo still HOLD

Companion [BIRCA PR #21](https://github.com/morrocwi/birca_admin_5.0/pull/21) executed [Actions run 38261519903](https://github.com/morrocwi/birca_admin_5.0/actions/runs/38261519903) and downloaded the real GSE22248 processed series matrix, 1,483,357 bytes, SHA256 cb2053d2a7f776cbc654bf2d26d69fad4122d99c0bd41617d42f9090a3e8d268. Verified 12 PBMC samples / 4 donors / 24,526 Illumina array probe signals.

Three training donor means predict the *same endpoint double-LPS minus single-LPS probe-value contrast* on heldout donor 92 with MAE **0.14272869** vs a zero-contrast empirical baseline **0.19362993**, in normalized-array signal units. Training median MAE **0.14542420**. Retrospective donor-rotation mean of 4 MAEs: pooled 0.14474376 vs zero 0.17790865; heldout-donor MAEs vary 0.13312–0.16199. [Full per-probe audit artifact](https://github.com/morrocwi/birca_admin_5.0/actions/runs/38261519903/artifacts/11752686404).

These results show transferable average transcript-contrast information across a small number of donors; they **do not evaluate F_step or its endogenous train/tolerize memory coefficients**. Transcript effect is not a cytokine pg/mL; possible confounds include cumulative LPS, culture time, donor/batch effects; four donors are the independent units; rotation is NOT an independent clinical cohort. The native step index is not identified by the 4-hour assay stamp, so the supposed step-native Toledo clinical MAE remains undefined. **B.29/B.30 and temporal refinement remain OPEN.** It would violate source-honesty governance to call the 26.29% improvement over zero contrast a Toledo predictive advantage.
