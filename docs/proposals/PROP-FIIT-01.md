# PROP-FIIT-01 — Ordered-input typed-readout transition (NEW DERIVATION / PROPOSAL)

Date: 2026-10-11 | Tier: Dr + exact algebra in a declared finite-state model | Registry status: UNVERIFIED PROPOSAL; NOT CANONICAL.
Domain: cross-domain informational readouts; food-order effects are a candidate application, not a demonstrated physical bridge.

## 0. Toledo lookup and reuse-first (TG-RFG-01)

- REUSE CAN-003: S_(n+1)=F(S_n,u_n,c_n,T_n), a context-dependent stepper (Dr).
- REUSE CAN-006: domain quotient must commute with dynamics and readout, an admissibility condition, not an automatically proved empirical bridge.
- REUSE CAN-007: future-readout equivalence depends on the declared question, observable, context and horizon.
- REUSE EQ-001/B.07.v1: x'+e'=x+e+j-d, only for compatible ledger units, not the same equation as the two-state probability kernel.
- REUSE EQ-001/B.08.v1: fixed-point definition; do not infer a biological stable equilibrium.
- REUSE EQ-001/C.07.v1: stationary quotient may hide underlying cycles.
- HOLD EQ-001/B.29.v1, B.30.v1: real biological encoding and event-resolved derivation remain OPEN.
- PRIOR implementation (not canonical Toledo): research MVP v6 used dp/dt=k_plus(u)(1-p)-k_minus(u)p, with domain-specific readout admission. This proposal adds only piecewise ordered composition and typed guardrails.

Toledo canonical codes above were looked up in registry/CANONICAL_REGISTRY.json and registry/EQ_LIBRARY.md; no claim that FIIT-01 was previously registered.

## 1. Declared mathematical state and exact phase solution

Let p in [0,1] denote a latent fraction, not a concentration or clinical risk; c denotes declared assay/environment/population context. During one phase j of duration dt_j, k_plus,j and k_minus,j are constant, nonnegative and have units 1/time; dt_j uses the matching time unit.

    dp/dt = k_plus,j (1-p) - k_minus,j p
    lambda_j = k_plus,j + k_minus,j
    p_eq,j = k_plus,j / lambda_j, if lambda_j > 0
    Phi_j(p) = p_eq,j + (p - p_eq,j) exp(-lambda_j dt_j)
    Phi_j(p) = p, if lambda_j = 0.

This is an exact solution of the DECLARED two-state model under constant rates within each phase. It is neither a Toledo-root theorem about chemistry nor proof that a two-state system is adequate for any particular organism.

## 2. The minimal missing derivation: input order can matter

For two phases A and B, using the same durations and rates under a swap:

    p_AB = Phi_B(Phi_A(p0))
    p_BA = Phi_A(Phi_B(p0))
    p_AB - p_BA = (1-exp(-lambda_A dt_A))
                   * (1-exp(-lambda_B dt_B)) * (p_eq,B - p_eq,A).

Proof: each Phi_j is affine, Phi_j(p)=r_j p+(1-r_j)p_eq,j with r_j=exp(-lambda_j dt_j). Compose in both orders, subtract, cancel the common r_A*r_B*p0 term. The equality remains valid if either phase has zero total rate, because its (1-r_j) factor is zero. Hence a nonzero difference REQUIRES both phases active and distinct equilibrium fractions; it need not occur in real meals.

Unlike an aggregate-input equation, this construction retains the intervention tape (A then B vs B then A). It improves explanatory identifiability of order effects in principle but introduces NO calibrated numerical prediction of postprandial glucose or cytokines.

## 3. Measurement/readout is a separate typed map

An entity such as glucose, IL-6, ATP, OGG1 protein, channelrhodopsin or genomic 8-oxoG must enter first as a record:

    I=(physical_entity, quantity, value, unit, assay, specimen,
       population, sampling_time, context, source, calibration_id).

Candidate observation rule (new proposal, not an existing Toledo equation):

    y_(Q,j) = R_(Q,assay,context,j)(q_D(S_j); theta_cal) + eta_j.

Calibrating R is a separate task. No claim that q_D captures all relevant state distinctions, or that eta_j is iid or additive in real assays, follows merely from writing the expression. For IL-6 versus glucose, or genomic 8-oxoG versus circulating 8-oxodG, reuse of one physical readout is FORBIDDEN without a validated bridge.

Fail-closed outcomes are: ADMITTED_TYPED_ONLY (metadata compatible, empirical fit unproved), HOLD_MISSING, HOLD_UNITS, HOLD_ASSAY, HOLD_CONTEXT, HOLD_UNIDENTIFIED, and HOLD_UNCALIBRATED. Distinguish unknown evidence from verified impossibility. A calibration_id label is not itself a certificate that calibration has occurred.

## 4. Empirical food-order anchor; NOT fitted data

- Shukla et al., BMJ Open Diabetes Research & Care 2017; PMID 28989726; n=16 adults with type 2 diabetes, randomized three-sequence crossover, 0–180 min sampling.
- Same meal, carbohydrate first vs last: published glucose incremental AUC 6703.5 vs 3124.7 mg/dL*min (approximately 53.4% lower with carbohydrate last); glucose peaks 75.0 vs 34.7 mg/dL. These are OBSERVED group summaries, not model predictions.
- Shukla et al., Diabetes Obes Metab 2019; PMID 30101510; prediabetes n=15, iAUC 38.8% lower for protein/vegetables first than carbohydrate first. Distinct population: do NOT fit one rate from another without independent evaluation.
- Emerson et al., Adv Nutr 2017; PMID 28298267 systematic review 47 papers: IL-6 was the only studied marker consistently changing after high-fat meals on reviewed timescale; averaged about 1.4 to 2.9 pg/mL with peak around 6h. Reviews are NOT event-resolved single-person kinetic traces; no calibrated glucose->IL-6 equation.

These empirical readouts motivate retention of input order and channel-specific observation operators. They DO NOT calibrate k_plus, k_minus, theta_cal, latency, or assay sensitivity.

## 5. Genesis seven-gate compatibility review

1. No-Free-Domain-Law: PASS (formal construction only; any food-law calibration explicitly OPEN).
2. Three-Valued Admissibility: PASS structurally (typed/admitted, HOLD unknown, obstructed measurement mismatch).
3. Context-Indexed Law: PASS (parameters, phases and measurement mapping tagged by context).
4. State-Sufficiency: UNRESOLVED (two-state p may hide meaningful memory and delays); HOLD empirical bridge.
5. Invariant-Completion: UNRESOLVED for biology; do not claim p sufficient for IL-6/CRP/insulin simultaneously.
6. Query-Relative Symmetry: PASS conditionally (swapping A/B is NOT quotiented out when readout changes).
7. Calibration Firewall: UNRESOLVED; mathematical exactness only, no independent calibration certificate.

Overall: COMPATIBLE AS A DECLARED MODEL PROPOSAL; HOLD for real-biological predictive validation. No physical law is inferred from the Genesis ontology.

## 6. Falsifiable protocol and claim ceiling

Preregister rates/parameterization and readout map BEFORE accessing whole-study blind holdouts. Compare an order-aware model to a matched aggregate-only baseline and a mechanistic glucose model; use crossover participant-level split, preserve time and assay, and report mean absolute error with bootstrap intervals and subgroup failures. Repeat on independent cohort/lab. Do not use glucose AUC as evidence of reduced inflammatory IL-6; score independently. If model fails an instrument or population transfer, output HOLD without discarding the measured failure.

Frozen previous research MVP v6: 31 legacy rows (13 provisional, 14 diagnostic, 4 HOLD), no blind validation and no prediction improvement claimed by this proposal. Demonstration rates are illustrative model assumptions, never fitted to the 2017 food paper.

## 7. Registration & promotion

Status: NEW DERIVATION / PROPOSAL; no new canonical code is assigned. Human registrar must review equivalence, parents, provenance and calibration evidence. No modification of registry/CANONICAL.json, Coq canonical proofs, or other Toledo registered objects.

Upstream pins checked on 2026-10-11:
- Toledo f718f576bcef3b0d41f58bcd2b02f6b99667ba38
- Readout Genesis 1a8cb0fb739d51803399a0da7519fb4f565f1376
- Readout Universe eafbf2e4ada7f6cd61a7d85b5203368af0d46a65

Sources: https://pubmed.ncbi.nlm.nih.gov/28989726/ ; https://pubmed.ncbi.nlm.nih.gov/30101510/ ; https://pubmed.ncbi.nlm.nih.gov/28298267/ ; https://github.com/morrocwi/toledo/blob/main/EQUATION_SOURCE_POLICY.md .
