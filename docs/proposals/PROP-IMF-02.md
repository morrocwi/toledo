# PROP-IMF-02 — Type-gated positive two-pool inflammatory readout (NEW DERIVATION / PROPOSAL)

**2026-10-12. Tier: exact algebra in a declared model / finite_diagnostic retrospective calculation / Open empirical bridge.**
**NOT a canonical Toledo theorem, universal inflammation law, or clinical device.**

## Reuse-first source gate (TG-RFG-01)
- Reuse CAN-003 / root-stepper: retained dynamics depend on state, input, context, tape.
- Reuse CAN-006 / domain-weld: the quotient/readout map must commute with the relevant dynamics; this is an **admission obligation**, not automatically established for a cytokine concentration.
- Reuse CAN-007 / reader-equivalence: future observable equivalence is question-, context- and horizon-dependent.
- Reuse EQ-001/B.07 (repair/resource ledger) only in its own typed state. Do **not** claim its conservation theorem yields cytokine kinetics.
- Reuse EQ-001/C.07: a fixed quotient can hide source-state changes.
- EQ-001/B.29 and B.30 remain **OPEN**: no calibrated root-state-to-protein bridge or measured event-resolved derivation.
- PROP-FIIT-01 on [Toledo PR #67](https://github.com/morrocwi/toledo/pull/67) retains ordered input; it is a sibling DRAFT, not a parent from the canonical registry.
- No new universal kernel or new H6 disease formula is introduced here. **Only missing application readout** is proposed.

## The one new declared readout
At post-anchor time t>t_a, let b be a concentration baseline, a>b an observed post-stimulus anchor, and rates gamma_1,gamma_2>0 in hours^-1. With w in [0,1], and time in hours:

    f(t;t_a) = w*exp[-gamma_1*(t-t_a)] + (1-w)*exp[-gamma_2*(t-t_a)]
    y_hat(t) = b + (a-b)*f(t;t_a)

This is exactly the solution of two independent linear decay states X_1, X_2 with X_1(t_a)=w(a-b), X_2(t_a)=(1-w)(a-b), X'_i=-gamma_i X_i, read out as b+X_1+X_2. This **does not imply** real IL-6/TNF/IL-10 has two physically distinct compartments. If w=1 or gamma_1=gamma_2, the curve reduces to the single-rate form; adding a physical mechanism requires independent assay evidence.

## Typed information-first protocol
Readout record requires: protein identifier (UniProt), analyte, value, physical unit, time, specimen, assay, cohort, intervention/context, source and data_level. The domain application refuses any cross-modal RNA-to-protein inference, unknown concentration units, unmatched intervention, and incompatible cohorts unless validated conversion is supplied.

**Time-of-knowledge firewall:** (b, a, t_a, t_target, protein_id, frozen gamma parameters) are the only inputs to forecasting. The measured y(t_target) is visible **only to the scorer after forecast() has run**; contemporary parallel-control readouts at t_target cannot enter unconditional prediction.

## Observations, numerical score, and claim ceiling
- Model frozen on Talwar et al. (2006) PMID 16403844, no external test target fitted.
- Kullmann et al. (2013), PMID 23547245: baseline -0.25h, anchor 3h, targets 6h and 24h; three cytokines, group means.
- Six marker-time pairs, normalized MAE as fraction of anchor excursion: two-pool 21.352459%; one-rate 22.313609%; return-to-baseline 23.372589%. NOT MAPE, NOT blind, NOT clinical. This comparison was selected after previous inspection; a new fully independent trial is mandatory for admission.
- Historical mixed Skarke (2015) dataset 0h / 1h readout error is excluded from the strict benchmark.
- Previously reported v9 conditional control-corrected 13.48% depends on saline(t_target) observed at the test time. It is a conditional retrospective readout and must NOT displace the unconditional two-pool comparator.

**Sibling implementation (non-normative):** [birca_admin_5.0 PR #18](https://github.com/morrocwi/birca_admin_5.0/pull/18). It houses offline typed checks, frozen parameters, real published group-mean readouts and executable tests. The adapter must NEVER register as SPINE_EQUATION_DERIVED or enter clinical/drug recommendation paths until an independent biological bridge and human review. Its local safety rule excludes novel molecules, SMILES, synthesis and dosing.

## Seven Genesis compatibility checks
1. No-Free-Domain-Law: pass as an explicitly declared candidate, not a law derived from retention.
2. Three-valued admission: pass as a typed runtime design; absent/mismatched evidence produces HOLD.
3. Context-indexed law: pass; observed protein measurement context explicitly tagged.
4. State sufficiency: **UNRESOLVED**; two pools may not capture production/delay/negative undershoot.
5. Invariant completion: **UNRESOLVED**; equal observed tails need not imply equal hidden inflammatory states.
6. Query-relative symmetry: conditional; do not identify different proteins or assays as interchangeable.
7. Calibration firewall: **UNRESOLVED**; legacy Talwar fit and Kullmann retrospective transport do not validate the Toledo root-to-physiology weld.

Overall **PROPOSAL** / **HOLD for empirical root-to-biology promotion**. No change to canonical Toledo registry, equation identity, theorem or Coq. New clinical or mechanistic interpretation requires locked preregistered independent data, an uncertainty analysis, and reviewers.

**Version pins (checked 2026-10-12):** Toledo main f718f576bcef3b0d41f58bcd2b02f6b99667ba38; paired birca_admin PR #18.

Sources: https://pubmed.ncbi.nlm.nih.gov/16403844/ ; https://pubmed.ncbi.nlm.nih.gov/23547245/ ; https://github.com/morrocwi/toledo/blob/main/EQUATION_SOURCE_POLICY.md


## Companion implementation — four information lanes (2026-10-12)

The linked [birca_admin_5.0 draft PR #18](https://github.com/morrocwi/birca_admin_5.0/pull/18) now implements four **noncanonical, nonclinical** lanes in admin/research:

1. **Information Engine**: 4-state p/q/x/e HYPOTHESIS simulation with a typed discrete Toledo B.07-compatible resource ledger. These states are dimensionless abstract variables, NOT measured cellular IL-6, tissue repair capacity or ATP.
2. **Disease Specialization**: experimental LPS/endotoxemia, seborrheic dermatitis (earlier H6 dandruff hypothesis), and meal-order/postprandial contexts. Domain-to-measurement bridge is explicitly HOLD under B.29/B.30, not an automatic equation registration.
3. **Evidence & Calibration**: typed metadata import for PubMed table records, GEO transcriptomics references (GSE3026) and laboratory CSV. The optional live citation metadata check uses existing BIRCA PubMed code. GEO accession records are NOT equated with cytokine concentration measurements.
4. **Prediction Benchmark**: frozen Talwar->Kullmann retrospective group-mean cytokine tail (6 targets; positive two-pool 21.352459% normalized error; first-order 22.313609%) and a new study-disjoint CSV scorer. Performance was previously inspected and is NOT blind or clinically verified. Earlier Skarke baseline time mislabelling stays HOLD.

The four lanes are **an IMPLEMENTATION / observation extension of this proposal**, not another root system. The only authoritative Toledo mathematical parents remain the canonical CAN-003/CAN-006/CAN-007 and typed B.07/C.07 where applicable. FIIT-01 (PR #67) remains a separately reviewed proposal. No canonical registration, Coq theorem, universal inflammation law, disease causation or molecule-creation claim is added.

Mandatory upgrade gate: reproduce full GitHub CI, validate sample- and assay-level provenance, compare with independent clinical/laboratory cohorts and competing baselines, and close the B.29/B.30 biology readout joins. **Software PASS never changes those OPEN states.**
