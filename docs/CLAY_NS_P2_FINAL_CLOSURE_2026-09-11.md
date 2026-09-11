# Clay / Navier–Stokes P2 final closure provenance — 2026-09-11

## Status

This note records the final P2 phase ruling from `morrocwi/readout-problem-navier-stokes` after merge

`c25baad7617ce419a012a3b53c9bd40bc6af25b9`.

Source theorem note:

`paper/NS_P2_FINAL_CLOSURE_EQUIVALENCE.md`

Source theorem identifier:

`NS-P2-FINAL-EQUIV`

This is a **provenance/status record**, not a new Toledo theorem and not a Clay solution.

## Final P2 ruling

```text
P2 = CLOSED AS A RESEARCH / REDUCTION PHASE
P2B finite-observation route = CLOSED AS REGULARITY-EQUIVALENT
NS-P2-H3-MARGIN-UNIFORM = RETIRED as an active separate bridge target
NS-P2B-SCALE-CONTRACTION-UNIFORM = REGULARITY-EQUIVALENT existentially
Clay Navier-Stokes global regularity = OPEN
```

## Final equivalence result

For the declared periodic modal/dyadic P2B setup, define

\[
R_j=\frac{(K_{N_j}^2)^{2p/(p-2)}}{\Lambda_j}.
\]

Let `SC(T)` assert the existence of finite nonnegative upper bounds `U_j` and constants `kappa,rho<1`, `B<infinity` such that eventually

\[
R_j\le U_j,
\qquad
U_{j+1}\le \kappa U_j+B\rho^j.
\]

The NS source derives

\[
\boxed{
\text{regularity on }[0,T]
\iff
SC(T)
}
\]

under the declared finite-observation adapter.

The reverse implication uses the published Balakrishna–Biswas finite-observation regularity criterion as an external semantic adapter. The forward implication is direct: regularity gives a cutoff-independent `H1` bound, hence `R_j <= C/Lambda_j`, and dyadic scaling gives an explicit `1/4` contraction.

## Provenance classification

- `NS-P2-FINAL-EQUIV`: `DERIVED` in the NS source note under its declared adapter hypotheses.
- `NS-P2B-EPSC-OBS-LIFT`: supporting derived finite-to-observation lift.
- `NS-P2B-SUBCRITICAL-OBS`: supporting derived reduction to finite observation regularity.
- energy/dissipation-only exponent-slack inference: `REFUTED` by exact critical-spike budget control.
- window-balance + transfer-conservation-only strict contraction inference: `REFUTED` by exact accounting countermodel.
- `NS-P2-H3-MARGIN-UNIFORM`: `RETIRED AS ACTIVE BRIDGE / REGULARITY-LEVEL`.
- `NS-P2B-SCALE-CONTRACTION-UNIFORM`: `REGULARITY-EQUIVALENT existentially / HOLD as a distinct bridge`.
- Clay Navier–Stokes global regularity: `OPEN`.

These research identifiers remain non-canonical unless and until Toledo issue #11 performs canonicalization.

## Non-vacuity consequence

The last P2B existential residual is not weaker than the target regularity statement in the declared adapter. Therefore it must not be promoted as an intermediate Clay bridge merely by restating it in scale-contraction language.

A future constructive finite theorem could still be meaningful if it derives the contraction certificate from genuinely weaker, independently checkable finite information. Such a theorem would be new regularity-level mathematics and belongs in a new direct attack lane rather than reopening P2.

## Issue disposition

NS issue #25 closed `completed` because the P2 research/reduction objective was exhausted and classified.

NS issue #46 closed `not_planned` because the proposed residual is regularity-equivalent as an existential bridge target, not because an NSE triad-level contraction theorem was proved.

## Toledo rule

Toledo records the source status; it does not manufacture closure. The final Clay target remains OPEN.
