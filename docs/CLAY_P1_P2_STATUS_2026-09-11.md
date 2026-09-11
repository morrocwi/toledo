# Clay P1/P2 Status — 2026-09-11

**Role:** Toledo provenance/status note for the shared Clay finite-obstruction programme.  
**Claim effect:** status/provenance only. No Millennium Prize Problem is promoted by this note.

## Governance correction

An earlier attempt to create this status note accidentally wrote directly to `main` because no branch argument was supplied. That file was immediately reverted from `main` before this governed version was created. This branch/PR is the authoritative path for the note.

## P1 — safe shared core

Source repository: `morrocwi/information-discrete-math`.

Merged evidence commit:

`1ddf295ea6fd9c504a10e6296fdea5bb97cf78fd`

Primary formal source:

`formal/IDM_FiniteObstructionSafeCore.v`

Dedicated verification showed Coq 8.20 compilation and `Print Assumptions = Closed under the global context` for the promoted finite kernels. The machine-checked layer includes strict-margin PASS/HOLD logic, finite error composition, finite-chain budget composition, two-step compatibility composition, symmetry transport under explicit invariance, and local-defect checker soundness under an explicit soundness hypothesis.

**Toledo ruling:** these are reusable finite kernels. They do not prove `PROP-FUB-03`, `PROP-FUB-04`, the global/Clay-strength part of `PROP-FUB-05`, `NS-FUB-A1/A2`, or `PNP-FUB-A1`.

## P2 — adversarial negative controls

Source PR: `morrocwi/information-discrete-math#127`.

Audited source head:

`ba02458d2230b23e927dada642d7e39f26eada7c`

Dedicated `clay-negative-controls` CI passed both exact diagnostics and Coq 8.20 negative controls. The formal witnesses include:

- `every_finite_prefix_bounded`;
- `rising_not_globally_bounded`;
- `finite_prefixes_do_not_force_global_boundedness`;
- `unit_step_chain_sum`;
- `local_step_bounds_do_not_give_uniform_chain_bound`;
- `transport_can_fail_without_invariance`;
- `checker_can_accept_without_soundness`.

The exact finite diagnostics additionally verify the black-box single-defect capture obstruction and a harmonic-partial-sum local-step-vs-global-control guard.

## Status consequences

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

## Navier--Stokes consequence

For `NS-FUB-A1`, mere energy/L2 cross-resolution agreement is not an admissible singularity witness by itself. The finite obstruction must be tied to a **regularity-sensitive** quantity or criterion, together with a quantitative all-scale compatibility/tail statement strong enough to support the chosen regularity bridge.

A candidate architecture is therefore:

```text
regularity-sensitive finite observable/norm
+ certified all-refinement Cauchy/tail modulus
+ finite obstruction if the bound/modulus fails
+ proved regularity bridge if the bound/modulus persists
```

The existence and exclusion of such an obstruction remain OPEN.

## P-vs-NP consequence

For `PNP-FUB-A1`, finite defect existence remains separate from efficient capture. Any proposed hitting-support constructor must declare its access model and polynomial resource bound and must fail the non-vacuity audit if it hides SAT, equivalence, MCSP, or exponential enumeration.

## Canonicalization boundary

This note does not assign canonical Toledo codes to `PROP-FUB-*`, `NS-FUB-*`, or `PNP-FUB-*`. Toledo issue #11 remains the canonicalization gate. The new P1 machine-checked identifiers may be considered for later legal Toledo readings only after source pinning and normal registry audit.
