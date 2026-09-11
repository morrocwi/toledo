# Clay P1/P2 Status — 2026-09-11

**Role:** Toledo provenance/status note for the shared Clay finite-obstruction programme.  
**Claim effect:** status/provenance only. No Millennium Prize Problem is promoted by this note.

## Governance correction

An earlier attempt to create this status note accidentally wrote directly to `main` because no branch argument was supplied. That file was immediately reverted from `main` before the governed version was created. Governed Toledo PR #12 is the authoritative insertion path.

## P1 — safe shared core

Source repository: `morrocwi/information-discrete-math`.

Merged evidence commit:

`1ddf295ea6fd9c504a10e6296fdea5bb97cf78fd`

Primary formal source:

`formal/IDM_FiniteObstructionSafeCore.v`

Dedicated verification showed Coq 8.20 compilation and `Print Assumptions = Closed under the global context` for the promoted finite kernels. The machine-checked layer includes strict-margin PASS/HOLD logic, finite error composition, finite-chain budget composition, two-step compatibility composition, symmetry transport under explicit invariance, and local-defect checker soundness under an explicit soundness hypothesis.

**Toledo ruling:** these are reusable finite kernels. They do not prove `PROP-FUB-03`, `PROP-FUB-04`, the global/Clay-strength part of `PROP-FUB-05`, `NS-FUB-A1/A2`, or `PNP-FUB-A1`.

## P2 — adversarial negative controls

Source repository: `morrocwi/information-discrete-math`.

Merged evidence commit:

`b37b9be5a0ace54f90f9b643e4fcd77a6bf83bc5`

Source PR/issue:

- `morrocwi/information-discrete-math#127`
- `morrocwi/information-discrete-math#126` — closed completed

Dedicated `clay-negative-controls` CI and repo-wide verification passed. The Coq 8.20 formal witnesses include:

- `every_finite_prefix_bounded`;
- `rising_not_globally_bounded`;
- `finite_prefixes_do_not_force_global_boundedness`;
- `unit_step_chain_sum`;
- `local_step_bounds_do_not_give_uniform_chain_bound`;
- `transport_can_fail_without_invariance`;
- `checker_can_accept_without_soundness`.

The exact finite diagnostics additionally verify the black-box single-defect capture obstruction and a harmonic-partial-sum local-step-vs-global-control guard.

## Status consequences of P2

The following **naive forms are REFUTED**, while the strengthened proposal families remain OPEN.

### Naive FUB-03

Refuted form:

`arbitrary global failure -> natural finite-prefix failure`

Counterexample class: globally unbounded sequence with every finite prefix bounded.

Required repair: a domain-specific finite-detectability / safety / finite-separation hypothesis.

### Naive FUB-04

Refuted form:

`existence of a finite defect -> generic efficient capture`

Counterexample model: an unstructured black-box universe of size `2^n` containing a single unknown defect. A `k`-probe support can miss it whenever `k < 2^n`; uniform hit probability is `k/2^n`.

Required repair: explicit access model, exploitable structure, polynomial constructor/sampler, non-negligible certified capture margin, and oracle/enumeration guards.

### Naive FUB-05

Refuted form:

`adjacent/local compatibility error -> 0 -> global compatible object/control`

Counterexample class: harmonic partial sums have adjacent increments tending to zero while cumulative drift is unbounded.

Required repair: an all-refinement Cauchy modulus, summable tail envelope, or an equivalent uniform all-scale control theorem.

## Navier--Stokes consequence and NS-FUB-A1 refinement

Source repository: `morrocwi/readout-problem-navier-stokes`.

Merged evidence commit:

`838303844c0baa529af15d76c38cdf2917772183`

Primary source:

`paper/NS_FUB_A1_H3_FINITE_WITNESS.md`

The old umbrella target

`FiniteTimeSingularity -> exists finite certified PDE-relevant failure`

has been split into three non-canonical research sub-identifiers so existence, verification, and constructive capture are not conflated.

### `NS-FUB-A1E` — existential regularity-sensitive bridge

For a maximal smooth/strong periodic 3D Navier--Stokes solution, under explicitly declared classical adapters:

1. an `H^3` continuation criterion; and
2. compact-interval `H^3` convergence of the standard divergence-free Fourier-Galerkin approximations below the putative singular time,

failure of strong continuation at finite `T*` implies:

\[
\forall B<\infty\;\exists N<\infty\;\exists q\in\mathbb Q,\ 0\le q<T_*:
\|u_N(q)\|_{H^3}>B.
\]

**Status:** `DERIVED` under the explicitly imported analytic adapters. This does not exclude singularities.

### `NS-FUB-A1V` — finite exact verifier

The NS repository contains an exact-rational interval checker for a finite Galerkin `H^3` exceedance certificate:

`reproduction/checks/check_ns_fub_a1_h3_certificate.py`

It computes a rational lower bound on the finite weighted Fourier sum and returns PASS only if that lower bound is strictly above `B^2`.

Dedicated `ns-fub-a1-h3-witness` CI passed at the merged source PR.

**Status:** finite exact verifier PASS. The checker does not establish that the supplied intervals enclose the true finite trajectory; enclosure validity is an adapter obligation.

### `NS-FUB-A1C` — constructive validated capture

Target:

`FiniteTimeSingularity -> constructible machine-checkable A1V certificate`.

This requires a validated finite-dynamics/data adapter producing rigorous rational coefficient enclosures from the declared initial-data representation with sufficient strict margin.

**Status:** OPEN.

### NS non-vacuity boundary

Mere energy/L2 cross-resolution agreement is not an admissible singularity witness by itself. Adjacent/local compatibility is insufficient after P2. Reader conditioning failure is also insufficient unless separately connected to a PDE regularity criterion.

A useful next mechanism must provide a regularity-sensitive finite quantity together with an all-refinement Cauchy/tail modulus or equivalent uniform scale control.

A uniform all-`N` `H^3` bound is a valid bridge template, but proving that bound may simply restate the Clay-strength difficulty. It remains on HOLD until a new finite mechanism proves the antecedent without assuming global regularity.

## P-vs-NP consequence

For `PNP-FUB-A1`, finite defect existence remains separate from efficient capture. Any proposed hitting-support constructor must declare its access model and polynomial resource bound and must fail the non-vacuity audit if it hides SAT, equivalence, MCSP, or exponential enumeration.

## Canonicalization boundary

This note does not assign canonical Toledo codes to `PROP-FUB-*`, `NS-FUB-*`, `NS-FUB-A1E/A1V/A1C`, or `PNP-FUB-*`. Toledo issue #11 remains the canonicalization gate. New machine-checked or exact finite identifiers may be considered for later legal Toledo readings only after source pinning and normal registry audit.
