# Turbulence / Navier-Stokes / Fluid-Dynamics Knowledge Ledger — 2026-09-08

Preservation + honesty pass, founder-requested. Every claim below is tiered under the
`information-discrete-math` tier language: **Th_coqc** (machine-checked, axiom-free over ℚ, verified
by me in this pass) / **finite_diagnostic** (measured, code run, no proof) / **Dr** (stated-not-proved,
a stance or narrative) / **Open** (needs the continuum / not yet proved). A tier I did not personally
verify is marked "own-stated" and reported as such, not upgraded.

This ledger does **not** write to `toledo/registry/CANONICAL.json` or `genesis_root.json` (a separate
workflow holds that write lock) — Toledo attachment points below are cited read-only, from the
existing `registry/proposals/urcf_turbulence.json` (already written by a prior pass) and the
canonical registry/genesis files.

---

## 1. URCF-RTPE Turbulence Relaxation-Inertia + Direct LP Closure (v2.2, standalone proof pack)

**Location:** `Downloads/URCF_RTPE_TURBULENCE_RELAXATION_INERTIA_DIRECT_LP_CLOSURE_v2_2_STANDALONE_PROOF_PACK.yaml`
(and its byte-identical duplicate `Downloads/URCF_RTPE_TURBULENCE_RELAXATION_INERTIA_DIRECT_LP_CLOSURE_v2_2_STANDALONE_PROOF_PACK(1).yaml`
— confirmed identical, md5 `f67e15a48bd2842841d2c075f2d10644` on both; only one was read).

**What it claims (verbatim, key equation):**
> `short_latex: tau_R dI_R/dt + L_R I_R = S_R + eta_R` — "relaxation-inertia turbulence equation",
> `EQ-URCF-TURB-004`, tier `T1/T3_protocol`.

Second layer, a Littlewood-Paley/Navier-Stokes cascade-obstruction audit anchored on the standard
incompressible-NS equations `∂_t u+(u·∇)u=−∇p+ν∆u`, `∇·u=0`, decomposing the nonlinear cascade work
per dyadic shell into raw/coherent/effective/hidden/transport/pressure/incoherent/nonalignment/
high-frequency/paraproduct components, culminating in the residual identity:
> `H_q^{rem,v2}=[H_q^{hid}-C_q^{tr}-C_q^p-C_q^{inc}-C_q^{nonalign}-C_q^{hf}-C_q^{para}]_+`

**Own stated tier/caveats (verbatim):**
> "not an unconditional proof of the 3D Navier-Stokes Millennium problem"; "not a replacement for
> DNS/LES/RANS solvers"; "not empirical validation until tested on external DNS/experimental
> datasets"; "not a universal theorem until continuum-scale analytic estimates are proved."
Its own reported numerical result: `v2_sup_theta_rem: 0.0`, `v2_sum_H_rem: 0.0` on a **finite
synthetic test class only** — grids {16,24,32}, ν∈{0.1,0.01,0.001}, 7 hand-picked flow cases
(Taylor-Green, ABC, random-smooth, adversarial triads, high-freq projected random, helical
counterflow, triad phase-locked). Its own `proof_09_claim_boundary_lemma` explicitly forbids the
wording "solved Navier-Stokes", "proved global regularity", "universal turbulence closure", "all
residuals vanish in general."

**My independently-verified tier: `finite_diagnostic` at best, `Dr` for the surrounding derivation
chain.** I did not re-run the numerical harness myself (no code was supplied with the YAML — it is a
specification/proof-pack document, not an executable), so the `v2_sup_theta_rem=0` numbers are
**relayed from the source's own run log, not independently reproduced by me** — report this as
unverified-by-me, not as confirmed. The semigroup-stability derivation (`proof_02`) and the
scale-decomposition identities (`proof_04`, `proof_06`) are algebraically straightforward under their
stated linear-operator assumptions; I did not encode them in Coq myself this pass, so they remain
`Dr` (a written derivation I read and find internally consistent, not machine-checked). The
`continuum_theorem_target` (uniform residual-storage bound `Σ_q H_q^{rem,v2} ≤ K(1+E_m)`) is
explicitly `OPEN` by the source's own final ruling, and I found no evidence anywhere in the workspace
that this bound has since been proved.

**Toledo/IDM/Genesis attachment:** Registered (read-only, not re-proposed by me) at
`toledo/registry/proposals/urcf_turbulence.json` → `PROP-URCF-01`, attaching `EQ-URCF-TURB-004` as an
`instance_of` both `weld/S.01.v1` (Finite-Memory Laplacian/Telegraph Generator — same first-order
retained-response law `dI/dt + (L_R+Γ)I = J` applied to a new domain state) and `root/EQ-008`
(`L_R := D_W − W`, the canonical retained graph-Laplacian operator). I cross-checked this proposal
against the source YAML directly: **no discrepancy found** — the proposal's `weld/S.01.v1` structural
match and the `root/EQ-008` L_R definition match ("graph Laplacian / scale Laplacian / linearized
restoration operator / positive operator, positive semidefinite, zero-mode policy declared") are both
accurate paraphrases of the source's own `symbols.L_R` block. The proposal's `does_not_resolve`
field correctly flags that this equation's own assumption set fixes `L_R` **time-independent**
(`solution_form_linear_time_invariant`), so it is honestly the *easier* linear sub-case of Genesis
root gap `T2` ("endogenous state-dependent L_R[I_R]"), not an attempted resolution of it.

**What would make this stronger:** (1) supply the actual numerical harness code so the
`v2_sup_theta_rem=0` claim can be independently re-run, not merely relayed; (2) encode
`proof_02_semigroup_stability` (Duhamel/contraction-semigroup argument) as a Coq lemma over a
finite-dimensional rational state space — this is the one sub-result in the pack most amenable to a
`Th_coqc` upgrade without needing `Coq.Reals`; (3) run the component-ablation matrix already specified
in `proof_10` to rule out the reviewer-anticipated risk that `C_hf`/`C_para` over-absorb by
construction.

---

## 2. URS-RDT Master v0.11 — Turbulence-Integrated Multimode Operator (living-geometry canonical form)

**Location:** `Downloads/URS_RDT_MASTER_v0_11_TURBULENCE_INTEGRATED.md` and the matching
`Downloads/URS_RDT_MASTER_v0_11_TURBULENCE_INTEGRATED.yaml`.

**What it claims (verbatim):** it embeds §9 "Turbulence retained-state layer" inside a larger
generalized-operator architecture. Canonical turbulence equation, restated from source (1) above as a
retained-distinction-native object:
> `\tau_R\delta_t I_{R,n}+\mathcal L_R[I_{R,n},\Theta_n]I_{R,n}=S_{R,n}+\eta_{R,n}`
with the operator itself now decomposed as
`L_R[I,Θ]I = L_R^(+)[Θ]I + L_R^(-)[Θ]I + N_R[I;Θ]` (symmetric restoration + skew rotation + a
nonlinear transfer term that "must be classified rather than hidden in the residual").

**Own stated tier/caveats (verbatim):** section 0 explicitly lists what is "not claimed by this
document," including "an unconditional solution of three-dimensional Navier-Stokes," "universal
turbulence closure," and "external empirical validation of the turbulence layer." §9 itself states:
> "The proof that RTPE is an exact reduction of the complete DRL–Telegraph architecture is currently
> open; the existing RTPE derivation is conditional on a retained state, positive relaxation time and
> a lowest-sufficient restoration law."
§10 explicitly demotes the LP/NS cascade layer to "a separate LP/NS cascade audit that acts as a
checker, not as a native derivation," and states "A zero residual on finite synthetic grids is a
protocol result, not a continuum theorem."

**My independently-verified tier: `Dr`.** This is architecture-and-notation work (a generalization
from scalar to multimode/living-geometry operators), not a numerical or machine-checked result in
itself; it is honest about that (§19 "Academic status" lists the turbulence-layer items explicitly
under "Proposed/open": "exact derivation of RTPE from the full DRL–Telegraph architecture,"
"continuum-uniform turbulence residual bound," "external DNS/experimental validation"). I found no
computation or proof artifact anywhere in the workspace that closes any of these open items for the
*endogenous, state-dependent* `L_R[I,Θ]` case — only the linear, `Θ`-fixed sub-case (source 1) has any
numerical or Toledo-registered support.

**Toledo/IDM/Genesis attachment:** This document is itself the clearest workspace-internal statement
of Genesis root gap **`root/T2`** — "T2 — endogenous state-dependent L_R[I_R] (remaining open
two-field-wall gap)" in `toledo/registry/genesis_root.json` (`tier_in_genesis: "[Open] (general case);
domain-specific instance in V.19 biology is [CLOSED]"`). §9's `L_R[I,Θ]` (operator depends on the
state/geometry it acts on) is exactly the general nonlinear case Genesis T2 names as still open; no
turbulence-specific closure of T2 exists anywhere in this sweep.

**What would make this stronger:** derive and machine-check the "moving-basis identity"
(`ΔΦ_n = V_{n+1}Δφ_n + (V_{n+1}−V_n)φ_n`, §6) for a small finite graph where `Θ_n` evolves by an
explicit rule — this is the smallest concrete instance of the T2 gap and could plausibly be encoded
in Coq over ℚ without needing the continuum.

---

## 3. Coq (.v) strengthening — graph-Laplacian `L_R` spectral facts

Four `.v` files were compiled, one at a time, in an isolated scratch directory
(`/tmp/.../scratchpad/coqwork`), each with `coqc -q <file>.v`, followed by reading each file's own
`Print Assumptions` output (these files embed their own `Print Assumptions` calls at the bottom —
no separate harness was needed). RAM was checked before compiling (`free -g`: ~1 GB free / 4 GB
buff-cache / 14 GB total, no `toledo/docs/RAM_LOW` flag present) and only one `coqc` process ran at a
time.

### 3a. `Downloads/InfoSpectralCeilingSharp.v`
**Claims (header, verbatim):** "For any exact node pair (lam, x) ... there is an edge (u,v) of E with
`Qabs lam <= deg u + deg v`. Corollary, under a curvature floor ... `lam <= 4 - Fmin` the SHARP
curvature ceiling." Equation ownership note: "the inequality is Anderson–Morley's (Linear Multilinear
Algebra 18:141–145, 1985; registered). New here: the machine-checked witness-form proof over Q."
**Compiled:** yes, `coqc -q` exit 0. **`Print Assumptions`** on all 6 top-level lemmas/theorems/
corollaries (`esum_abs_triangle`, `exists_max_edge`, `acontrib_bound`, `pair_term_bound`,
`anderson_morley_witness`, `sharp_curvature_ceiling`): **all six print `Closed under the global
context`** — axiom-free.
**Verified tier: `Th_coqc`** for the literal Coq statement (a rational-arithmetic graph-Laplacian
spectral-ceiling inequality). This is **not itself a turbulence/NS result** — it is a general
graph-Laplacian bound of the kind the `L_R` operator (shared by the URCF turbulence equation, `weld/
S.01.v1`, and `root/EQ-008`) would need as a building block if a turbulence-specific spectral-gap
argument were ever built on top of it. Read the Coq statement itself and confirmed it matches only
the narrow claim above (a degree/curvature bound on an exact eigenpair) — it says nothing about
turbulence, cascades, or Navier-Stokes, and must not be cited as turbulence evidence beyond "this is
the kind of `L_R` spectral fact the turbulence layer's `L_R` positive-semidefinite assumption would
lean on."

### 3b. `Downloads/RDL_GammaSpectral.v`
**Claims (header, verbatim):** "Γ : Dirichlet energy of a weighted graph ... energy_nonneg : nonneg
weights ⇒ energy ≥ 0 (L_R PSD, Fiedler)"; also the discrete-continuum precursor
(`laplacian_stencil`, `secondDiff_quadratic`, `secondDiff_readout_invariant`).
**Compiled:** yes. **`Print Assumptions`** on all 5 top-level theorems (`energy_nonneg`,
`energy_edge_gauge`, `laplacian_stencil`, `secondDiff_quadratic`, `secondDiff_readout_invariant`):
**all five `Closed under the global context`** — axiom-free.
**Verified tier: `Th_coqc`.** This directly proves the graph-Laplacian energy is non-negative
(positive-semidefiniteness of `L_R`, one of the two structural properties the URCF turbulence
equation's `L_R` symbol *declares as a required constraint* but does not itself prove). Read the
statement: it is exactly the PSD fact, over ℚ, for a generic weighted graph — it does not depend on
or reference the turbulence equation, so citing it for turbulence requires the same instantiation
step the Toledo proposal already performs (turbulence's `L_R` is asserted, not derived, to be an
instance of this general graph-Laplacian object).

### 3c. `Downloads/RDL_SpectralCeiling.v`
**Claims (header, verbatim):** "SPECTRAL CEILING of the graph quadratic form from the DEGREE BOUND
... `form_degree_bound: x^T L x <= 2*dmax*||x||^2`" plus a Rayleigh-quotient ceiling
(`rayleigh_ceiling: lam <= 2*dmax`) and a `step_ratio_window` numerical-stability corollary "the
dimensionless step ratio lands in the boundedness window."
**Compiled:** yes. **`Print Assumptions`** on all 6 top-level theorems (`deg_node_swap`,
`form_degree_bound`, `rayleigh_nonneg`, `rayleigh_ceiling`, `mode_product_ceiling`,
`step_ratio_window`): **all six `Closed under the global context`** — axiom-free.
**Verified tier: `Th_coqc`.** Same scope caveat as 3a/3b: a general graph-Laplacian spectral-ceiling
fact, not a turbulence-specific result; the `step_ratio_window` corollary is closer to a numerical
CFL-type stability bound than to anything in the URCF turbulence cascade audit.

### 3d. `Downloads/URCF_RD_All.v` (273 KB omnibus file, 377 lemma/theorem declarations, 215
`Print Assumptions` calls embedded)
**Compiled:** yes, `coqc -q` exit 0 (single run, ~single-digit-second compile, no memory issue).
**`Print Assumptions` results:** of the printed blocks, **212 report `Closed under the global
context`**; exactly **2 report a non-empty axiom set** — both are `Con_PA_classical` /
`RD.Con_PA_classical` lemmas (consistency-of-Peano-Arithmetic-style results that legitimately need
`Classical_Prop.classic` / excluded middle) — **unrelated to the turbulence/graph material**.
**The turbulence-relevant module inside this file is `Module Graph` (originally `RDL_Graph.v`).**
Its own header states, verbatim:
> "In the URCF frame this IS the retained order `D` plus the geometry operator `L_R = D_W − W`. Here
> we mechanize the symmetric-weight graph-Laplacian spectral facts that BOTH the URCF turbulence
> (RTPE) and DHRG proof packs *assume* as a premise (Δ_spec = λ₂ > 0)."
Its listed verified results (verbatim): `energy_nonneg` (L_R is PSD), `energy_const` (constants ∈
kernel), `energy_zero_edge`, and **`kernel_connected`** — "connected V ⇒ (energy V x == 0 ⇒ x constant
on V) = algebraic connectivity / Fiedler, KERNEL form: ker L_R = constants ⇔ the graph is connected.
(⇒ the assumed λ₂ > 0 premise is now a theorem.)" `Print Assumptions Graph.kernel_connected` in this
run printed **`Closed under the global context`** — axiom-free.
**Verified tier: `Th_coqc`** for `Graph.kernel_connected` and the other `Graph.*` lemmas listed above.
**This is, in this whole sweep, the single strongest piece of machine-checked evidence that touches
the turbulence equation's own stated assumptions**: the URCF-RTPE turbulence pack (source 1) *lists*
"positive semidefinite" and a declared "zero-mode policy" as *required, asserted* properties of its
`L_R` symbol, without proving them; `Graph.kernel_connected` is an axiom-free, machine-checked proof
that for a connected weighted graph, the kernel of `L_R = D_W − W` is exactly the constants — i.e. the
zero-mode is fully characterized (not merely assumed) once "the retained graph is connected" is
established as a hypothesis. **Scope honesty:** this proves a *general graph-Laplacian* fact — it does
not itself say anything about turbulence, cascades, dyadic shells, or Navier-Stokes; it discharges one
specific, named premise (`λ₂ > 0`, i.e. positive spectral gap on a connected graph) that the turbulence
pack's `L_R` assumes but never proves for itself. Citing it as "turbulence proof" would overclaim; citing
it as "the λ₂>0 zero-mode premise the RTPE `L_R` needs is a proved theorem for connected graphs, not an
unproved assumption" is the accurate, narrower claim.

**What would make this stronger:** an explicit lemma connecting the *specific* `L_R` instance used by
`EQ-URCF-TURB-004` (a scale/dyadic-shell Laplacian on turbulence spectral modes) to the *general*
`Graph.kernel_connected` graph object — i.e. show the turbulence `L_R`'s underlying graph is connected
under its own stated domain/boundary conditions, then the zero-mode characterization transfers for free.

---

## 4. `Downloads/coq_fixed/unified_spine_blowup_control.py` — NOT a Coq file (a Python diagnostic script)

Despite its name and location (inside a `coq_fixed/` folder), this is a plain Python 3 script, not
Coq. **What it actually is:** a small numerical diagnostic (`numpy` only) that integrates a
one-dimensional discretized version of the PGFT unified-spine PDE
`M Φ'' + D Φ' + K L_R Φ + g Φ³ = J` (its own docstring's Eq.49) on a periodic ring, sweeping the
damping coefficient `D` and checking whether the total energy blows up. Its own header states:
> "Claim tier: finite_diagnostic (code units). NOT a proof of Navier-Stokes regularity."
and its printed conclusion (verbatim, from its own `print` statements) states the smoother
(`D Φ' + K L_R Φ`) and turbulence-like forcing (`g Φ³ + J`) form "a coupled control pair" where
"Enough damping D => energy bounded (no blow-up); D=0 => energy can grow without bound (blow-up)"
and explicitly: "this is NOT a different spine — it is the FULL spine (PGFT Eq.49); the first-order
RTPE spine (Eq.60) is its memoryless/linear LIMIT."
**Verified tier: `finite_diagnostic`.** I read the script (did not need to run it to classify it — it
is transparent numpy code, ~60 lines, and its own printed conclusions are already quoted above as
comments the script itself emits) — this is a toy 1-D ODE energy-balance demonstration, not a PDE
solver, not turbulence, not Navier-Stokes; it demonstrates a qualitative damping-vs-forcing
energy-boundedness relationship on a single scalar field, useful only as an intuition pump for why the
URCF-RTPE `L_R` (restoring) term and a nonlinear forcing term trade off.
**Toledo attachment:** none — this is un-registered scratch code, correctly self-labeled
`finite_diagnostic` and explicitly disclaiming any NS proof.
**What would make this stronger:** re-run on the actual dyadic-shell state space used by
`EQ-URCF-TURB-004` rather than a single scalar field on a ring, so the diagnostic speaks to the real
multimode `I_R`, not a toy analogy.

---

## 5. `Downloads/retained_spectral_credibility_all.zip` — unzipped, checked, NOT turbulence-relevant

Unzipped to scratch (three nested platform zips: `credibility-ubuntu-py312`,
`credibility-ubuntu-py311-jax`, `credibility-macos-py311`). Each contains one JSON CI-style
"credibility report" (`adversarial`, `baseline`, `cold_start`, `environment`, `gates`, `scaling`,
`schema`, `scope_note`, `simulation`, `verdict` fields; verdict = `ACCEPT` on all three platforms).
No `.v` files found inside. **Grep for "turbulen|navier|stokes" across all three JSONs: zero
matches.** Its own `scope_note` (verbatim): "ACCEPT supports reproducibility and correctness for the
declared and adversarial one-dimensional finite-diagnostic suite. Scaling data is reported across k
and N; it does not imply universal solver dominance." This is a cross-platform reproducibility report
for a *different* (1-D, general spectral-credibility) diagnostic suite, unrelated to turbulence/NS —
noted here only to confirm it was checked and correctly excluded, per the task's request to open every
candidate and judge relevance.

---

## 6. `toledo` (this repo) — `ANSE.ASIA/cpg/cpg_solver` Navier-Stokes 2D flagship solver

**Location:** `ANSE.ASIA/cpg/cpg_solver/cpg_solver/solvers/navier_stokes_2d.py`,
`ANSE.ASIA/cpg/cpg_solver/cpg_solver/registry/solver_cards/navier_stokes_2d.card.yaml`,
`ANSE.ASIA/cpg/cpg_solver/tests/test_navier_stokes_2d.py`.

**What it is:** a pseudo-spectral vorticity-streamfunction 2-D incompressible Navier-Stokes solver
(periodic `[0,2π)²`, RK4, 2/3-dealiased), verified against the exact closed-form **Taylor-Green
vortex** solution (`u=-cos x sin y e^{-2νt}`, decaying at the exact rate `e^{-4νt}`) — this is a
*laminar decaying-vortex* verification case, explicitly not a turbulence claim.

**Tests run this pass:** `pytest tests/test_navier_stokes_2d.py -v` → **4 passed, 0 failed**
(`test_matches_exact_to_spectral_precision`, `test_kinetic_energy_decays_as_exp_minus_4_nu_t`,
`test_decay_rate_changes_with_viscosity`, `test_failcloses_on_bad_inputs`).

**Its own `honest_report` string (verbatim, from the code):**
> "pseudo-spectral (vorticity-streamfunction, RK4) approximation of 2D incompressible Navier-Stokes —
> Taylor-Green vortex; n={n}, nt={nt}; vorticity nRMSE={nrmse:.3e} vs exact; energy-decay
> error={energy_decay_error:.3e}. NOT a proof, NOT a DNS/CFD replacement, NOT a turbulence claim."

**The solver card's own claim boundary (verbatim, `navier_stokes_2d.card.yaml`):**
`claim_tier: benchmark_candidate`; `forbidden_use: [proof_of_navier_stokes, proof_of_turbulence,
cfd_or_dns_replacement, "claim of resolving turbulence or a physical flow without a passed reference
benchmark"]`.

**Verified tier: `finite_diagnostic`** (a passing, executed, reproducible pytest suite against a
closed-form exact solution — genuinely the strongest *empirically-checked* fluid-dynamics artifact in
this whole sweep, but it verifies **laminar decay**, not turbulence, and is explicit about that scope).
**Toledo/IDM/Genesis attachment:** none found — this solver card is registered in `cpg_solver`'s own
registry, not in Toledo's equation registry; no cross-reference to `root/EQ-008` or `weld/S.01.v1` was
found in the card or code.
**What would make this stronger:** register the Taylor-Green exact solution and the solver's verified
error bound as a Toledo occurrence of the standard NS equation (which itself is presumably already a
Toledo-eligible object — not checked for a canonical code in this pass, out of scope of the assigned
sources); extend the same pytest-verified pattern to a genuinely turbulent (not laminar-decaying) test
case if one is ever added.

---

## 7. `research_universal_solver` — proprietary, LICENSE read first, described only from public README text

**LICENSE (`ANSE.ASIA/research_universal_solver/LICENSE`, read in full):** "PROPRIETARY LICENSE — ALL
RIGHTS RESERVED... NO PERMISSION IS GRANTED to any person or entity to use, copy, modify, merge,
publish, distribute, sublicense, sell, or otherwise exploit the Work." Per the task's own
instruction, I did **not** run `scripts/test_graph_navier_stokes.py`, and I quote only short excerpts
below (its own docstring header, and the README's own public-facing lines) — no large source block is
reproduced.

**`scripts/test_graph_navier_stokes.py` (docstring only, not run):** its own header states it is a
"FLUID domain: 2-D incompressible Navier–Stokes (vorticity form) on the graph, vs exponax (APEBench
spectral reference)," comparing a graph-Laplacian-eigenbasis discretization against a third-party
spectral reference library (`exponax`) "at SHORT time (before chaotic divergence makes pointwise
comparison moot)." This self-description already concedes the comparison is only valid pre-chaos —
i.e. this is explicitly not a turbulence-regime claim either.

**README.md (public-facing text of this private repo, quoted as permitted):**
> "Worked example: the four turbulence bricks (`InfoGlobalLaminarReadout` / `InfoDiffusionMaxPrinciple`
> / `InfoMonotoneMaxPrinciple` / `InfoSkewNotMonotone`) + predictions P1–P3."
and, on its general tier discipline:
> "Tiers (never collapse): `Th_coqc` (axiom-free ℚ, `Print Assumptions` Closed) · `finite_diagnostic`
> (measured) · `Dr` (stance) · `Open/+reals` (needs infinity). Never solve the continuum — diagnose it
> as a non-readout and predict the readout."

**Verified tier: not independently verified by me this pass** — I did not compile the repo's internal
`.v` files (respecting the license and the task's instruction not to run/copy its code); the repo's
own internal docs (not quoted at length here, per license) list `InfoGlobalLaminarReadout_attempt.v`
and `InfoMonotoneMaxPrinciple_attempt.v` as **self-reported** `Th_coqc` in the repo's own internal
index — this is the **repo's own claim about itself**, not something I compiled or checked in this
pass, and must be reported as such (own-stated, not independently verified here).

**Toledo attachment:** none checked/attached in this pass — out of scope given the license
restriction and the task's instruction to describe only the public README text.

**What would make this stronger:** if the founder authorizes a future in-repo pass (respecting the
proprietary license as an internal-only exercise), independently re-run `Print Assumptions` on
`InfoGlobalLaminarReadout_attempt.v` and `InfoMonotoneMaxPrinciple_attempt.v` rather than relaying the
repo's own self-reported index tier.

---

## 8. Toledo registry cross-references (read-only, no writes made)

- **`root/EQ-008`** (`toledo/registry/genesis_root.json`): "Retained graph-Laplacian operator L_R" —
  `L_R := D_W − W`. `tier_in_genesis: "Ax/Th"`. This is the canonical attachment point for every `L_R`
  appearing in sources 1–3 and 6 above.
- **`root/T2`** (`toledo/registry/genesis_root.json`): "T2 — endogenous state-dependent L_R[I_R]
  (remaining open two-field-wall gap)." Statement (verbatim): "What remains open is the harder,
  nonlinear case: endogenous state-dependent L_R[I_R], where the operator itself depends on the state
  it is acting on... the general nonlinear case is not handled." `tier_in_genesis: "[Open] (general
  case); domain-specific instance in V.19 biology is [CLOSED]"`. This is the exact gap source 2's
  living-geometry `L_R[I,Θ]` operator sits on top of, still open for turbulence.
- **`weld/S.01.v1`** (`toledo/registry/CANONICAL.json`): "Finite-Memory Laplacian/Telegraph Generator
  as the Social-Instability/Peace Spine" — `L_R = D_W − W; A := L_R + Γ; s[n+1] = s[n] +
  dt(−A s[n] + J)`. Same first-order retained-response functional form as `EQ-URCF-TURB-004`, applied
  to a different (social-instability) domain state. (Note found in registry history: this code was
  recently N4-split by founder ruling 2026-09-06 because two distinct mathematical objects had been
  bundled under it — the split does not affect the turbulence-proposal's citation, which references
  only the shared functional-form fact, not the split content.)
- **`toledo/registry/proposals/urcf_turbulence.json`** (`PROP-URCF-01`, already written by a prior
  pass, not re-proposed here): registers `EQ-URCF-TURB-004` as `instance_of` both `weld/S.01.v1` and
  `root/EQ-008`, with `does_not_resolve.genesis_root_gap: "T2"`. **Cross-checked against source 1
  directly in this pass: no discrepancy found.** `resistance_evidence.rungs_held: "none yet"` — this
  proposal itself is honest that no Toledo resistance rung (R0–R6) has been earned yet.

---

## 9. Zenodo-record equation extraction — `toledo/ops/causal_sweep` (records 18164015, 18105213)

**Location:** `toledo/ops/causal_sweep/candidates_part2.json`, `judged_part2.json`,
`toledo/ops/causal_sweep/txt/18105213.txt`, `toledo/ops/causal_sweep/txt/18164015.txt`.

### 9a. Zenodo 18164015 — "Causal Calculus: Primitive Aggregation under Finite Causal Access"
Extracted candidate equation, `eq_label: "Causal Navier-Stokes"` (verbatim `statement_ascii`):
> `(u_n - u_{n-1})/eps_t + div_c(u_{n-1} tensor u_{n-1}) = -(1/rho)*grad_c p_n + nu*Laplacian_c
> u_{n-1} + f_{n-1}, div_c u_n = 0`
— "discrete causal Navier-Stokes equations (effective, implicit time stepping)." `tier_as_stated:
"unstated"`. This is a **definitional discretization** of the standard incompressible NS equations
using the paper's own causal-calculus discrete-difference operators — not a new theorem, not a
regularity result, just a restated finite-difference form of NS with the paper's causal-operator
notation substituted in.
**My verified tier: `Dr`** — it is a stated definition, algebraically a direct transcription of
standard NS with an implicit-Euler time discretization; no proof or numerical verification of this
specific equation is present in the extracted material.

### 9b. Zenodo 18105213 — "Note: Causal State History as a Structural Constraint on Three Problems in
Mathematical Physics (Discussion Route)" — full text read (`txt/18105213.txt`).

**Full statement of "Theorem 2" (verbatim from the extracted full text):**
> "Theorem 2 (History-aware flux closure with constants (conditional route)). If
> `∫₀ᵀ Σ_λ λ Φ_λ(t) dt ≤ C₀ ∫₀ᵀ∫₀ᵗ K(t−s) ν‖∇u(s)‖²_{L2} ds dt`
> with `κ=‖K‖_{L1}` and `C₀κ ≤ θ < 1`, then for any critical norm `‖u‖_{X_crit}`,
> `sup_{t∈[0,T]} ‖u(t)‖²_{X_crit} ≤ (1/(1−θ))(‖u₀‖²_{X_crit} + C₁ν⁻¹‖u₀‖²_{L2})`,
> with explicit C₁ depending on localization and Littlewood–Paley constants; hence no finite-time
> blow-up."

**Hypotheses (verbatim, from the same document):**
- `Assumption 2 (Admissible kernels with constants)`: `K ∈ L¹(ℝ₊)`, `κ:=‖K‖_{L1} < ∞` (examples given:
  exponential and power-law kernels).
- The flux-closure inequality itself (the premise of Theorem 2, `Σ_λ ∫ λΦ_λ(t)dt ≤ C₀∫∫K(t−s)ν‖∇u‖²ds dt`)
  is a **hypothesis of the theorem, not something proved in this note.**

**The paper's own honesty caveats (verbatim, critical to preserve):**
> "Remark 3 (Navier–Stokes: intuition). History-weighted flux balances provide an effective way to
> encode that dissipation remembers past strain. If a suitable flux inequality holds, critical norms
> stay bounded; **the inequality itself is the hard part and is not proved here.**"
> "Remark 1 (Informal scope). This manuscript is a discussion-only note for colleagues. It introduces
> no new physical entities, no phenomenology, and no claims resolving open problems. All
> domain-specific statements are conditional implication routes meant to clarify admissibility
> constraints and align intuition."
> Abstract: "We sketch three conditional routes ... not as results, but as intuition pumps ... No open
> problem is claimed to be solved."
> Closing note: "The value of this note is conversational. Its purpose is to align intuition across
> domains using a shared structural language, not to advance or replace existing proofs."

**My independently-verified tier: `Dr`, exactly as the source itself states — a conditional
implication ("IF the flux-closure inequality holds, THEN no blow-up"), explicitly not a proof of the
antecedent, explicitly self-labeled non-claim by its own author.** This is, honestly, the single most
disciplined self-labeling found anywhere in this sweep: the author states up front, three separate
times in three different sections, that the hard step (the flux-closure premise) is unproved and that
the note does not claim to resolve the 3D Navier-Stokes global-regularity problem. No independent
verification beyond reading the full text was possible or attempted (there is no code, no numerical
harness, and no Coq artifact associated with this record in the workspace).

**Toledo relation:** per `judged_part2.json`, this record's full axiom/theorem set was judged
`"new_branch"`, attached as `specialises` of `weld/M.01.v1` (Toledo's root recursion
`S_{n+1}=F(S_n,u_n,c_n,T_n)`) — the judged verdict is itself a prior pass's read-only classification,
consistent with what I found on independent re-reading of the full text.

**What would make this stronger:** the note's own honest answer is the right one — prove the
flux-closure premise (Assumption 2 + the inequality it feeds) for a genuine class of admissible
kernels `K`, or drop the Navier-Stokes conditional route entirely; as it stands this is exactly the
same open premise (a uniform residual/flux storage bound) that source 1's `continuum_theorem_target`
and source 2's T2 gap both independently name as the missing piece — three separate documents in this
workspace converge on the same open analytic gap from three different notations.

---

## 10. Peripheral mentions across the workspace (checked, confirmed not dedicated turbulence content)

A broad `grep -lir` sweep of `Downloads/*.md`, `*.yaml`, `*.txt`, `*.tex` for
`turbulen|navier|stokes|vorticity|cascade|reynolds|incompressib|fluid` returned ~45 files; all but
the ones detailed above were read enough to confirm they belong to unrelated, larger programs and
mention turbulence/fluids/NS only as a passing example or forbidden-overclaim item, never as their own
subject:

- `PGFT_Roots_of_Mathematics_and_Geometry_RAG.md` — lists the standard incompressible-NS equation
  `∂_t u+(u·∇)u=−∇p+ν∆u+f, ∇·u=0` as one of six example "native force forms" (gravity/EM/weak/strong/
  fluid/thermal/elastic/control) in a much larger cross-domain force-registry program; no turbulence
  content beyond the bare equation as an example.
- `info_physics_spectrum_ai_engineer_operator_ultimate_standalone_v2_2.md` and
  `info_physics_spectrum_ai_engineer_operator_runtime_grade_v2_3.md` — a general engineering-physics
  domain card system; "Reynolds number," "fluid_headloss," and a `turbulence` fiber-label appear only
  as generic domain-coverage examples inside a much larger engineering-physics program; both files
  explicitly warn "Never overclaim full GR/QFT/SM/Navier-Stokes/global theory/constant derivation."
- `info_physics_ai_workspace_readout_operator_theory_standalone_v2_4.yaml` (and its duplicate) — one
  line, a forbidden-claims list including "claiming full GR/QFT/SM/Navier-Stokes proof."
- `RIG.txt` §10.3 "Spectrum Turbulence Guard" and `DHRG_DIRECTIONAL_RESONANCE_SPECTRAL_PROOF_PACK_v2_0.yaml`
  — both use "turbulence" as a metaphor/gate name for a signal-quality diagnostic (high-frequency
  residual ratio vs. a threshold), unrelated to fluid dynamics; a generic statistical-quality gate
  borrowed the word, not the physics.
- `INFORMATION_CHEMISTRY_v0_6_STANDALONE/.../INFORMATION_CHEMISTRY_CANON_v0_6_STANDALONE.yaml` —
  contains its own explicit `turbulence_ruling` (verbatim): "A second-order recurrence can encode
  inertia or relaxation, but turbulence additionally requires checked nonlinear transfer, multiscale
  transport, boundary conditions, closure, and observables. The static v0.6 calculation neither infers
  nor tests a turbulence closure." — a disclaimer, not a claim; correctly self-limiting.
- `readout_alphabet_note.tex` — cites turbulence once as an example of "the compressible tail of
  science" excluded from its own closed-form-law corpus by construction; no turbulence content itself.
- `READOUT_GENESIS_UNIVERSAL_TECHNICAL_WHITEPAPER_v1.2_EN.yaml.pseudo.dag.md` — one DAG-node label
  `turbulence_domain_interpretations`, no expanded content found under it in this sweep.
- `INDEX.md` — a bare wiki-link to source 1 above, no independent content.

**Files explicitly checked per the task's candidate list and found to contain zero turbulence/NS/
fluid content (verified by `grep`, and for the PDFs by `pdftotext | grep`):**
`Downloads/URCF_PGFT_Crosswalk_Addendum.pdf` / `.tex`, `Downloads/EASM_SPINE_ARCHITECTURE.md`,
`Downloads/Information_Semantics_of_Arithmetic_URCF.md`, `Downloads/ONE_SPINE_final.pdf`,
`Downloads/URCF_Verified_Foundations_and_Reproducible_Computation.pdf` (and its `-1` duplicate). These
belong to a larger, unrelated "unified spine" / force-registry research program and were confirmed,
not assumed, to be off-topic for this sweep.

---

## Summary table (tier discipline recap)

| Object | Own-stated tier | My verified tier |
|---|---|---|
| `EQ-URCF-TURB-004` (relaxation-inertia law) | T1/T3_protocol | Dr (derivation), finite_diagnostic (relayed numbers, not rerun by me) |
| NS cascade-audit residual (`H_q^{rem,v2}=0`) | PASS_WITH_LIMITS / T3_protocol_internal | finite_diagnostic, unverified-by-me (no harness code supplied) |
| URS-RDT v0.11 living-geometry `L_R[I,Θ]` | conditional / mostly Open | Dr |
| `InfoSpectralCeilingSharp.v` | Th_coqc (self-expected) | **Th_coqc — confirmed, axiom-free** |
| `RDL_GammaSpectral.v` | Th_coqc (self-expected) | **Th_coqc — confirmed, axiom-free** |
| `RDL_SpectralCeiling.v` | Th_coqc (self-expected, "candidate") | **Th_coqc — confirmed, axiom-free** |
| `URCF_RD_All.v` — `Graph.kernel_connected` (λ₂>0 discharge) | Th_coqc (comment claims it) | **Th_coqc — confirmed, axiom-free** (strongest result in this sweep) |
| `URCF_RD_All.v` — `Con_PA_classical` lemmas | n/a | uses `Classical_Prop.classic` (not axiom-free; unrelated to turbulence) |
| `unified_spine_blowup_control.py` | finite_diagnostic (self-stated) | finite_diagnostic — confirmed (toy 1-D script, read not needing rerun) |
| `retained_spectral_credibility_all.zip` | ACCEPT (self-stated, unrelated suite) | not turbulence-relevant |
| `cpg_solver` `navier_stokes_2d.py` (Taylor-Green) | benchmark_candidate (self-stated) | **finite_diagnostic — confirmed, 4/4 pytest pass, laminar decay only** |
| `research_universal_solver` turbulence bricks | Th_coqc (repo's own internal index; not quoted at length, license) | not independently verified this pass |
| Zenodo 18164015 "Causal Navier-Stokes" | unstated | Dr (definitional discretization only) |
| Zenodo 18105213 Theorem 2 (flux closure, no-blow-up) | "conditional route," explicitly not proved | Dr — confirmed, self-honest |
