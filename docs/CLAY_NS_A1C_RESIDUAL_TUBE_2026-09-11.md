# Clay NS-FUB-A1C Residual-Tube Status — 2026-09-11

**Role:** provenance/status note for the residual-centered finite localization layer in the Navier--Stokes Clay programme.  
**Claim effect:** status/provenance only. No Millennium Prize Problem is promoted by this note.

## Source

Repository: `morrocwi/readout-problem-navier-stokes`  
Merged evidence commit: `8c47a6cc476d96f766d4ef6273d5a05c1b955980`  
Source PR: `#32`  
Primary note: `paper/NS_FUB_A1C_RESIDUAL_TUBE.md`  
Executable: `reproduction/checks/check_ns_fub_a1c_n1_residual_tube.py`

Final source head before merge: `eb51830c9ceab689b5737431847e9d59eacaa965`.

All five relevant workflows passed on that final head:

- `ns-fub-a1c-residual-tube`;
- `ns-fub-a1c-validated-tube`;
- `ns-fub-a1c-tube-chain`;
- `ns-fub-a1-h3-witness`;
- `Clay Research Governance`.

## Negative control: absolute tubes are not localization-complete

For the scalar ODE

`x' = 1, x(0)=0`,

absolute symmetric propagation

`I_{m+1}=I_m+[-h,h]`

has final halfwidth `T` after any equal-step refinement with `T=n h`. The executable records halfwidth `1` for `1`, `10`, `100`, and `1000` steps at `T=1`.

Hence widening or failure of that absolute certificate class is not a dynamical obstruction and cannot be promoted to a Navier--Stokes singularity witness.

The exact reference path `p(t)=t` instead has zero residual and zero endpoint error.

## Residual-centered finite certificate

For a rational reference path `p(t)=a+t v`, exact finite arithmetic bounds

`R >= sup ||F(p(t)+e)-v||_inf`

on a rational error tube `||e||_inf <= r`, together with

`L >= sup ||DF||_inf`

on the same tube.

The fail-closed gates are

`h R <= r`,

`h L < 1`.

Under these inequalities the Picard error map is a self-map and contraction, so the exact finite Galerkin trajectory lies in the tube and the endpoint lies in `p(h)+[-r,r]^d`.

## Pinned N=1 calibration

The merged calibration uses the existing exact `N=1`, 52-dimensional Galerkin tensor with `C=600`, 2096 nonzero integer coefficients and exact induced infinity row-sum bound `36000`.

The executable selects

`h = 1/100000`,

`r = 1/1000000`,

with exact bounds

`R = 71173612529767 / 2400000000000000`,

`L = 1255078827 / 5000000`.

Therefore

`h R / r = 71173612529767 / 240000000000000 < 1/2`,

and

`h L = 1255078827 / 500000000000 < 1/2`.

The endpoint enclosure is then converted to Fourier coefficient rectangles and the exact `NS-FUB-A1V` H3 checker returns PASS for the calibration threshold `B=1`.

At the same `h`, the residual endpoint radius is roughly 1130 times narrower than the prior absolute enclosure. This is a fixed-N localization improvement, not a singularity result.

## Status

### `NS-FUB-A1C-RV`

Residual-centered finite tube verification under supplied exact bounds.

**Status:** implication DERIVED from standard finite-dimensional Banach contraction theory; pinned N=1 executable PASS.

### `NS-FUB-A1C-RG1`

Pinned N=1 finite search over a declared rational step-size list for an affine residual certificate.

**Status:** executable PASS.

### `NS-FUB-A1C-G`

Adaptive generator reaching arbitrary declared finite target times with sufficiently sharp endpoint localization, for arbitrary admissible finite cutoffs, with a termination/resource theorem.

**Status:** OPEN.

### `NS-FUB-A1C-X`

Finite-time singularity implies a constructible validated A1V exceedance certificate.

**Status:** OPEN in the general Clay-facing form.

## Next load-bearing theorem

The next mathematical target is finite certificate completeness/localization:

> for a fixed finite Galerkin ODE existing on a compact finite interval, if a finite-time observable has a strict positive margin, then some finite rational residual-centered certificate chain validates that margin.

This theorem must separate certificate existence from efficient automatic construction, arbitrary-N uniformity, and the representation of continuum initial data.

## Canonicalization boundary

`NS-FUB-A1C-RV`, `NS-FUB-A1C-RG1`, `NS-FUB-A1C-G`, and `NS-FUB-A1C-X` remain non-canonical research identifiers. Toledo issue #11 remains the canonicalization gate.
