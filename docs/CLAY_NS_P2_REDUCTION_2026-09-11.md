# Clay NS P2 status — finite-to-continuum reduction closure

**Date:** 2026-09-11  
**Role:** Toledo provenance/status note.  
**Claim effect:** P2 reduction closure only; the Navier--Stokes Millennium problem remains OPEN.

## Source

Repository: `morrocwi/readout-problem-navier-stokes`  
Merged source commit: `83e966df251e548fd9574d9553d7f4bf5551877b`  
Source PR: #42  
Primary reduction: `paper/NS_P2_FINITE_TO_CONTINUUM_CLOSURE.md`  
Supporting files:

- `paper/NS_FUB_A1_STOKES_NONLINEAR_TAIL_SPLIT.md`
- `paper/NS_CONTINUUM_ADAPTER_HIGH_HIGH_ABSORPTION.md`
- `reproduction/checks/check_ns_p2_h3_margin_interface.py`
- `reproduction/checks/check_ns_p2_geometric_tail_lift.py`
- `reproduction/checks/check_ns_high_high_absorption_adapter.py`

The final source head passed 10/10 relevant workflows, including the dedicated `ns-p2-h3-margin`, High--High adapter audit interface, Clay governance, H3 witness/tail no-go, fixed-N extensibility, completeness, validated/residual tubes, and tube-chain regressions.

## Clay endpoint

The current lane targets the unforced periodic positive-viscosity branch: arbitrary smooth periodic divergence-free initial data, `f=0`, and smooth periodic solutions for all finite times.

The source explicitly separates finite-native work from the final continuum semantic adapter.

## Derived supporting statements

### `NS-FUB-A1-STOKES-H3-TAIL`

Positive-time Stokes damping gives an explicit high-frequency `H^3` tail envelope with squared multiplier bounded by

\[
\frac{192}{(2\nu\tau)^4(N+1)^2}.
\]

**Status:** DERIVED.

### `NS-FUB-A1-OLD-DUHAMEL-H3-TAIL`

For tensor forcing history separated from the endpoint by a positive lag `delta`, the squared `L^1_tL^2_x -> H^3` tail multiplier is bounded by

\[
\frac{960}{(2\nu\delta)^5(N+1)^2}.
\]

**Status:** DERIVED under the declared finite forcing-mass hypothesis.

### `NS-P2-HH-GEOM-LIFT`

For `H^3` dyadic weight `64^j`, if a finite prefix of a nonnegative shell defect is certified and the true tail satisfies

\[
d_j(t)\le A q^j(1+X_3(t)),\qquad 64q<1,
\]

then the weighted tail has the exact geometric bound

\[
\sum_{j>J}64^jd_j(t)
\le
A\frac{(64q)^{J+1}}{1-64q}(1+X_3(t)).
\]

**Status:** DERIVED; exact rational calibration PASS. This is supporting translation arithmetic, not the global NS theorem.

## Main adapter-neutral reduction

For finite Fourier-Galerkin solutions define

\[
X_N=\|u_N\|_{H^3}^2,
\qquad
\mathcal D_N=\nu\|\nabla\Lambda^3u_N\|_2^2,
\]

and nonlinear production `P_N` by

\[
\frac12X_N'+\mathcal D_N=\mathcal P_N.
\]

### `NS-P2-H3-MARGIN`

If there are cutoff-independent constants

\[
0\le\theta<1,
\qquad C_T<\infty,
\]

such that on `[0,T]`

\[
\mathcal P_N(t)
\le
\theta\mathcal D_N(t)+C_T(1+X_N(t))
\]

for every finite cutoff `N`, then

\[
X_N'(t)\le2C_T(1+X_N(t))
\]

and Gronwall yields a cutoff-independent finite-time `H^3` bound. Standard Galerkin/strong-solution continuation is then the remaining semantic adapter.

**Status:** DERIVED reduction.

The exact finite margin checker is PASS as an arithmetic interface only. Enclosure soundness, all-time coverage, and cutoff-independent constants are not supplied by the checker.

## Single main residual lemma

### `NS-P2-H3-MARGIN-UNIFORM`

For every admissible smooth periodic unforced datum and every finite `T`, construct from finite/checkable information constants `theta<1` and `C_T<infinity`, independent of cutoff, together with a sound finite/uniform certificate mechanism proving

\[
\mathcal P_N(t)
\le
\theta\mathcal D_N(t)+C_T(1+X_N(t))
\]

for all cutoffs and all `t in [0,T]`, without assuming the desired global `H^3` bound or an equivalent regularity oracle.

**Status:** OPEN / load-bearing.

This is the sole main residual theorem identified by the P2 reduction. Proving it non-vacuously would close the P2 bridge; it is not proved by the merged work.

## External High--High preprint audit

The tracked High--High conditional-regularity preprint was independently audited and is **HOLD as a final semantic adapter**. The source branch records three load-bearing concerns:

1. its theorem statement permits `eta in (0,1)` while the displayed proof requires `eta < 3 c0/4`; a conservative direct mapping under its displayed normalization gives `eta<3/4`;
2. the appendix displays a cubic `H^s` contribution before the main argument later uses a linear Gronwall inequality without a displayed step eliminating that cubic term;
3. a modeled remainder `rho_j ~ 2^{-2sj}||u||_{H^s}^2` does not by itself give an infinite weighted shell sum.

Therefore no P2 or Clay conclusion depends on this preprint. High--High absorption remains only a candidate supporting route to the adapter-neutral margin theorem.

## Phase ruling

```text
P2 = CLOSED AS A REDUCTION
NS-P2-H3-MARGIN-UNIFORM = OPEN / HOLD frontier
Clay Navier--Stokes global regularity = OPEN
```

The programme should not return to larger fixed cutoffs, more fixed-N integration steps, energy-only tail control, adjacent compatibility, or reader-conditioning failure as substitutes for the uniform theorem.

## Canonicalization

All identifiers above remain non-canonical research identifiers until Toledo issue #11 completes the canonical audit. No generated canonical registry output is edited by this note.
