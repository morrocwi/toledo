# Clay NS P2 status — fixed-N extensibility/certificate-failure no-go

**Date:** 2026-09-11  
**Role:** Toledo provenance/status note.  
**Claim effect:** negative bridge audit only; no Millennium Prize Problem conclusion is promoted.

## Source

Repository: `morrocwi/readout-problem-navier-stokes`  
Merged source commit: `72d7672ea1753794e452fd0bb5206dea7be21764`  
Source PR: #39  
Primary statement: `paper/NS_FUB_A1_FIXED_N_EXTENSIBILITY_NO_GO.md`  
Exact calibration: `reproduction/checks/check_ns_fub_a1_fixed_n_energy_extensibility.py`

The final source head passed the dedicated fixed-N extensibility workflow together with H3 witness, H3 tail no-go, completeness, validated-tube, residual-tube, tube-chain, and Clay-governance workflows.

## Non-canonical research statements

### `NS-FUB-A1-FIXEDN-GLOBAL`

For each fixed finite Fourier-Galerkin cutoff with positive viscosity, the finite-dimensional Galerkin trajectory exists for all finite times. The proof is the standard finite-dimensional energy argument:

\[
\frac12\frac{d}{dt}\|u_N\|_2^2 + \nu\|\nabla u_N\|_2^2=0,
\]

combined with finite-dimensional ODE continuation.

**Status:** DERIVED.

### `NS-FUB-A1C-CHAIN-EXIST-Q`

For a fixed finite rational Galerkin ODE, rational initial state, and rational finite target time, the fixed-finite residual-certificate completeness argument yields a finite rational validated trajectory chain covering the interval.

**Status:** DERIVED in the fixed rational finite-data setting; no useful runtime bound is claimed.

### `NS-FUB-A1-CERTFAIL-NOGO`

In that fixed rational finite-data setting, nonexistence of any valid finite trajectory certificate to a finite target time cannot represent a genuine Galerkin dynamical breakdown. Failure/HOLD of a particular integrator, interval scheme, search strategy, or resource budget may reflect algorithmic limitations but not nonexistence of the fixed-N trajectory.

**Status:** DERIVED no-go consequence.

## Exact N=1 implementation calibration

The source checker reconstructs the existing characteristic-zero integer-scaled N=1 quadratic tensor and coordinate energy weights. It verifies coefficient-by-coefficient cancellation of

\[
\sum_i w_i x_i (C B(x,x))_i.
\]

Pinned output includes:

- dimension `52`;
- `2096` nonzero quadratic tensor coefficients;
- `592` cubic energy monomials touched before aggregation;
- `0` non-cancelling cubic monomials;
- scaled viscous diagonal in `[-9,-3]`;
- all viscous energy coefficients strictly negative.

This is an exact implementation calibration, not a machine proof of the all-N theorem.

## P2 ruling

The candidate

```text
fixed-N certificate recursion/extensibility failure
    -> continuum singularity witness
```

is **REFUTED as stated**.

The only potentially useful descendant is a **uniform-in-N** loss of a certified quantity that has a separate proved PDE-regularity meaning. Worsening runtime, conditioning, certificate size, or interval width alone is insufficient.

General `NS-FUB-A1`, `NS-FUB-A2`, and Clay Navier--Stokes regularity remain OPEN.

## Canonicalization

All identifiers above remain non-canonical research identifiers. Toledo issue #11 remains the canonicalization gate. No generated canonical registry output is modified by this note.
