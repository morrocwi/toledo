# Clay NS-FUB-A1C Tube-Chain Status — 2026-09-11

**Role:** Toledo provenance/status note.  
**Claim boundary:** fixed-`N=1`, four-step finite chain only; no Clay conclusion.

## Source

Repository: `morrocwi/readout-problem-navier-stokes`  
Merged commit: `df06f2718ed5bdd7549b0d8d6c4b90827036de60`  
Source PR: `#30`  
Primary note: `paper/NS_FUB_A1C_TUBE_CHAIN.md`  
Executable checker: `reproduction/checks/check_ns_fub_a1c_n1_tube_chain.py`

## Result

The fixed-`N=1` validated finite trajectory enclosure has been composed across four rational time intervals without replacing uncertain endpoints by exact states.

Each link verifies:

\[
I_m\subset X_m,
\qquad
I_m+[0,h_m]F(X_m)\subset X_m,
\qquad
h_mL_m<1,
\]

and emits a rational endpoint enclosure `I_{m+1}`. Finite induction therefore composes the per-link trajectory guarantees.

Dedicated final-head CI passed the tube-chain checker, the single-tube checker, the `H^3` verifier and Clay governance.

Pinned four-step outgoing maximum halfwidths:

```text
step 1: 1/2000
step 2: 1/800
step 3: 19/8000
step 4: 13/3200
```

The final rational box retained an exact positive `H^3 > 1` A1V calibration certificate. The threshold `1` has no singularity significance.

## Toledo status

### `NS-FUB-A1C-CV`

Finite chain verification from already-supplied valid links: **DERIVED** by finite induction plus the per-link contraction theorem. The pinned four-step chain is executable **PASS**.

### `NS-FUB-A1C-G1`

Fixed-`N=1`, fixed-four-step automatic chain constructor: executable **PASS** at the pinned source commit.

### `NS-FUB-A1C-G`

General/adaptive generator that reaches an arbitrary declared finite target time or returns a mathematically meaningful obstruction, with an appropriate termination/resource theorem and arbitrary admissible finite cutoff: **OPEN**.

### `NS-FUB-A1C-X`

Finite-time singularity implies a constructible validated A1V exceedance certificate: **OPEN**.

## Bottleneck update

Finite composition of validated trajectory tubes is no longer the principal logical gap. The next load-bearing problem is an all-finite target-time/localization theorem: prove that an adaptive finite procedure either continues to the requested finite time with sufficiently sharp regularity-sensitive enclosures or emits an obstruction whose PDE relevance is independently established.

Failure of a particular interval algorithm is not automatically a singularity witness; numerical/interval overestimation must not be promoted to PDE failure.

## Canonicalization

These are non-canonical research sub-identifiers. No Toledo canonical code is assigned by this note. Issue #11 remains the canonicalization gate.
