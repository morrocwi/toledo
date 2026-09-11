# Clay NS-FUB-A1C Finite Certificate Completeness — 2026-09-11

**Source:** `morrocwi/readout-problem-navier-stokes` merge `df022097ea899bacb917238be7a69b40c15e2107` (PR #33).

## Pinned statuses

- `NS-FUB-A1C-COMP-Q`: DERIVED analytically for fixed finite rational polynomial/Galerkin ODEs with rational initial state, rational observation time, rational polynomial observable, and a strict positive margin. Such a margin admits a finite rational residual-centered certificate chain whose exact endpoint box verifies the margin.
- `NS-FUB-A1C-ENUM-Q`: DERIVED. Finite rational certificates are enumerable and their exact verifier terminates, so exhaustive dovetailing eventually finds a PASS certificate whenever the strict fixed-finite margin is true. No useful runtime bound is claimed.
- `NS-FUB-A1C-XQ`: DERIVED only under the existing `A1E` analytic adapters plus an exact-rational finite Galerkin initial-data representation. This is a restricted finite-data consequence, not the general Clay-facing `A1C-X`.

## CI evidence

Final source head `603f65ed0c051ae791dd45e35bbf02a98d6e8233` passed:

- `ns-fub-a1c-completeness`;
- `ns-fub-a1c-residual-tube`;
- `ns-fub-a1c-validated-tube`;
- `ns-fub-a1c-tube-chain`;
- `ns-fub-a1-h3-witness`;
- `Clay Research Governance`.

The exact Fraction-only controls record:

- absolute `x'=1` halfwidth remains `1` under 1/10/100/1000 equal-step refinements;
- residual reference `p(t)=t` has zero residual and endpoint error;
- for `x'=x`, `p(t)=1+t`, `h=1/100`, `r=1/4000`, the exact self-map ratio is `41/100`, contraction is `1/100`, and the certified endpoint lower bound `4039/4000` exceeds threshold `2019/2000` by `1/4000`.

## Open boundary

The following remain OPEN and load-bearing:

- representation/enclosure for the full admissible continuum initial-data class;
- arbitrary-`N` uniformity;
- efficient/adaptive target-time generation with resource control;
- non-vacuous all-scale regularity-sensitive/tail control;
- converse/exclusion bridge needed for global regularity;
- general `NS-FUB-A1C-X` and Clay Navier--Stokes regularity.

Fixed-finite certificate completeness does not imply uniform all-scale regularity.

These identifiers remain non-canonical. Toledo issue #11 remains the canonicalization gate.
