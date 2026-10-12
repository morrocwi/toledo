# PROP-IMF-STEP-01 — retention-step primitive and observer-clock translation firewall

**2026-10-12 · foundational modelling correction · NEW DOMAIN PROPOSAL / Dr and finite software witnesses.**
**NO NEW MASTER EQUATION; the only root F remains canonical CAN-003.** Builds on readout_universe RD2–RD4, RD6–RD9, Omega_all Translation Protocol and Quantity Doctrine; readout_genesis; and prior domain PROP-IMF-MEM-01 / PROP-IMF-MULTI-01. Biological encoder EQ-001/B.29 and event-data weld B.30 are OPEN.

## Problem corrected

The preceding IMF domain demonstration took a scalar called dt_h as a direct input to a biological-like transition F and declared memory_tau_h, even though the source universe posits **retained-transition order** as fundamental, not an ontic laboratory clock. That was a borrowed continuous-time convenience translated *too early*. Hour is a measurement readout and cannot define the retained-DNA successor.

**Precise source quote, Readout Universe INFORMATION_DNA.md §How to see:** Time = the retention order itself (RD3+RD4): direction without a posited clock.

## Mandatory one-way dictionary

1. Root index n := finite successor count in retained tape; **not** seconds, hours, or elapsed SI time.
2. Typed event rho_n := finite distinguished input/context/query record accessible to observer; no guessed timestamps embedded in the root.
3. History H_(n+1) := H_n CONCAT rho_n. Exact tuple-append injectivity is a declared software witness to RD4, not a theorem that cells keep infinitely many events.
4. Access M_(Q,c,n) := QueryAccess_(Q,c)(H_n); finite, lossy and context-sensitive; not equal to the full record.
5. F-domain:

    Z_(n+1) = F_IMF(Z_n, u_n, c_n, M_(Q,c,n); theta_STEP)
    R_(Q,n) = Pi_(Q,c)(Z_n, H_n) + eta_(Q,n)

Here theta_STEP contains **dimensionless per-retained-step coefficients**; it cannot be silently identified with hour^-1 biochemical rate constants. The numeric constants from earlier half-hour demonstration are merely synthetic, not experimentally calibrated.

6. Laboratory observer translation, only AFTER native F:

    C_(assay,protocol): n_sample -> t_lab_observed [hours]
    Y_(assay,n) = K_(assay,specimen,Q)(R_(Q,n)) + eta_(assay,n)

This observer map must carry source, protocol, assay identity, specimen, and finite uncertainty. It is partial unless calibrated: unknown index↔hour relationship produces HOLD_UNCALIBRATED_STEP_TO_ASSAY_TIME and never a guessed 0.5-hour-per-step factor. An instrument's measured duration is useful evidence in the translation layer, **not a primitive of the root ontology**.

## Operational finite witness (BIRCA only)

Companion BIRCA PR #20 includes an **additional step-native F candidate** at admin/research/step_native_imf.py. Its advance(state,event) accepts no dt, time_h, or measured clock; the state contains (activation, resolution, closure, barrier, bounded resource, signal, accessible signatures, an append-only ordered event record). Update maps use finite dimensionless blends and retention coefficients (software floating-point approximations only; no new Coq proof over rational numbers).

The separate observer reader at admin/research/observer_clock_bridge.py accepts finite explicit SampleClock anchors. Counterexample: an identical native state after n=6 steps can be labeled 3 laboratory hours in observer protocol A, or 12 laboratory hours in observer protocol B, with zero alteration of the native state. Both mappings are **illustrations, not data-derived calibration**. The observer clock cannot infer the timing or number of latent steps between sparse measurements.

Native tape and active memory must be replay-equivalent, with missing/tampered record = HOLD, not a fabricated biological memory. Testing protects separation, monotonic observed-clock mapping, source metadata, absent points and non-equivalence of a named biomarker to the signal_proxy.

## Reconcile old and new evidence WITHOUT rewriting history

Older domain proposal PROP-IMF-MULTI-01 has a numerical study with dt_h=0.25,0.5,1 and 18 scenarios, 20 hand-chosen directional criteria. Its original code/results are retained as a **legacy CLOCK-PARAMETERIZED TOY DEMONSTRATION**, not the ontologically primitive F. Those 20/20 outputs do not transfer automatically to the new step-native F; there is NO new biological success rate.

**Unresolved granularity/identifiability gate (critical):** when a researcher assigns 3h of laboratory time to six abstract retained steps or twelve retained steps, parameter transport and composition law must be independently justified. Same clock duration does not entail same number of native steps. The discrete domain candidate is not established as independent of step refinement, unlike a complete native dynamics theory. This is an explicit falsifier / HOLD gate.

The old v9 adverse ledger, past PubMed 23-point first-order advantage, and B.29/B.30 open bridges stay untouched. Do not promote this observer separation into a scientific demonstration that external time does not exist. It is a stipulated information-first modelling choice followed by typed empirical translations.

## Lab test design after this correction

Raw measurements at measured clock hours (0,3,6,24) remain observer data only. Before a model makes numerical statements about those readouts, register:
- a candidate F-domain and allowed primitive step resolution;
- a protocol-specific n↔t_lab bridge or an explicit model for unobserved latent transitions;
- a biochemical/physics readout bridge to measured analyte, specimen and assay units;
- training/holdout split by participant or study, uncertainty and simple rate/memory-free comparators;
- the exact failure/HOLD list, including any conflicting clock calibration.

No such identification is complete for Toledo IMF. **Status PROPOSAL; biological predictive accuracy unknown.**
