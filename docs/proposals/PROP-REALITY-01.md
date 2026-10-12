# PROP-REALITY-01 — Toledo Reality Bridge v1

**2026-10-12. NONCANONICAL RESEARCH PROPOSAL / biological observation bridges OPEN.**

Authoritative information ontology: readout_universe RD1–RD9, particularly RD4 append-only retained distinction, Omega_all translator, and Quantity Doctrine. Single mathematics: Toledo CAN-003 F stepper, CAN-006/007/009/034, with biological EQ-001/B.29 and B.30 OPEN. This document registers no new universal law and does not claim that physical clocks are scientifically disproven.

## One-way informational order, no implicit physical clock

    H[n+1] = Append(H[n], event[n])
    Z[n+1] = F_domain(Z[n],event[n],Access_Q,c(H[n]);theta_step)
    r_Q[n] = Pi_Q,c(Z[n],H[n])
    t_lab = C_assay,protocol(n)       # separate partial observer mapping
    Y_assay[n] = G_assay,specimen(r_Q[n]) + noise

Here n is ordered retention step, not an hour. External lab timestamps DO NOT determine latent step counts, even if experiment samples are at 3h/6h/24h. Unknown step-to-clock correspondence is HOLD. Unknown native readout-to-assay encoder is HOLD. Fine/coarse event repetition is not established as an equivalent history, so refinement covariance remains OPEN. Numeric rates in legacy hour-based v11 toy do not become native laws.

## Companion executable research implementation

[BIRCA Admin Reality Bridge draft PR #21](https://github.com/morrocwi/birca_admin_5.0/pull/21), stacked on #20, #19, #18, contains:
1. reality_step_identification.py — latent-step unidentifiability and event repetition counterexamples. No invented 0.5h/step rate.
2. reality_assay_bridge.py — typed assay, specimen, analyte/probe and units for RNA/array, chromatin, protein pg/mL, TEER and TEWL; calibration permitted only with independently identified step/readout anchors, training-only and donor-disjoint testing.
3. reality_geo_matrix.py — real public GEO sample/probe matrix provenance, parser, donor-disjoint benchmark and posthoc LODO sensitivity.
4. reality_bridge_v1.py — explicit CLI and fail-closed source download; docs, fixed manifest, regression tests, frozen result evidence and GitHub Actions.

## What the REAL DATA say, and what they DO NOT

Source [GSE22248](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE22248) and [PMID 21576504](https://pubmed.ncbi.nlm.nih.gov/21576504/): human PBMC single/double LPS transcriptomics, GPL6883, 4 donors, 12 arrays, 24,526 probes. Four biological donors, NOT 24,526 independent humans. Processed array probe VALUE is not plasma IL-6 concentration. Fixed split trains donors 21/46/86 and evaluates donor 92. Outcome: observed LPS/LPS-minus-LPS transcript intensity contrast at matched endpoints.

Real [GH Actions run 38261519903](https://github.com/morrocwi/birca_admin_5.0/actions/runs/38261519903) downloaded 1,483,357 bytes with SHA256 cb2053d2a7f776cbc654bf2d26d69fad4122d99c0bd41617d42f9090a3e8d268. MAE on donor 92:
- TRAIN mean contrast **0.1427286875**, RMSE 0.2033399421
- TRAIN median contrast **0.1454242031**, RMSE 0.2042172925
- ZERO no-history contrast **0.1936299287**, RMSE 0.3486991132

Mean training contrast error is 26.29% lower than zero contrast. This is **an empirical basic statistical estimator, NOT a prediction made from Toledo's native F**. It is NOT a blind prospective result, a protein result or clinical accuracy. The endogenous memory mechanism is not established: donor effects and LPS exposure/timing may account for observed differences. Leave-one-donor-out posthoc MAE across four folds is pooled 0.14474376 versus zero 0.17790865, still not external verification.

## Explicit four questions and adverse limits

- Q1 inflammation persists despite observed stimulus stop: HOLD, no verified protein postwashout longitudinal measurements.
- Q2 history modifies rechallenge response: actual RNA endpoint contrasts measurable; native Toledo step and assay-readout mapping HOLD.
- Q3 cytokine quiet yet barrier remains impaired: HOLD, no paired cytokine+TEER/TEWL outcomes.
- Q4 truly recovered under repeat challenge: HOLD, no longitudinal functional assay and calibrated threshold.
All previously reported v9 and v10 failures and legacy v11 synthetic 20/20 remain preserved. None converts to biological validation. Root-to-biochemistry EQ-001/B.29/B.30 remains OPEN.

Promotion requires a justified latent-step identification or equivalence model; independently calibrated, assay-specific mappings; sample/time/assay controls; participant-disjoint TRAIN and locked TEST; residual distribution, uncertainty and out-of-study competitors. Keep PR DRAFT pending CI and review. No drug design, SMILES, synthesis, dosing or medical treatment advice.


## Extension 2026-10-13: falsification screen for protocol-event proxy only

Companion [BIRCA #21](https://github.com/morrocwi/birca_admin_5.0/pull/21) now includes an observed-LPS-administration **event-index** stress test built directly on the existing `step_native_imf.replay` implementation. It does not change CAN-003 or claim that the number of biological retained distinctions between assays equals the number of LPS additions. No hour-to-step conversion is assumed.

A frozen candidate `F` signal readout over zero/one/two *observed intervention events* defines `R_F=(r_2-r_1)/(r_1-r_0)`. A probe-specific first-response slope is fitted using only TRAIN donors' untreated and once-LPS RNA; the outcome tested is heldout donor twice-minus-once LPS RNA. Comparators using exactly the same training condition information are memory-trace-ablated F, linear continuation, and zero contrast. Numeric findings are to be reported in the BIRCA CI run, including failures. The prior v1 mean double-minus-single predictor has access to TRAIN double-LPS samples and is **not an equivalent-information competitor**.

This diagnostic is retrospective on public data. The probe-specific slope is a fitted experimental reader rather than a derived native Toledo assay map. Training or evaluation success cannot independently identify unobserved informational step counts, endogenous immune memory, a causal cellular mechanism, or an invariant physical-time translation. All EQ-001/B.29/B.30 admission gates therefore remain **HOLD/OPEN**. Preserve the negative evidence and keep both PRs DRAFT.
