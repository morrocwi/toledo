# L_R spectral ceiling + floor — a general method, not a one-off fact

Written 2026-09-09. Placed here (not inside any single proposal file) because the founder's own
instruction was explicit: this pattern is important to the whole Genesis/Toledo picture, and
should sit where any reader — human or another AI agent — can find and understand it on its own,
separate from whichever downstream project first needed it.

## The one-sentence method

**For any system whose dynamics are governed by the retained graph-Laplacian operator `L_R` (root
`EQ-008`, `L_R := D_W - W`), a proven UPPER bound on its largest eigenvalue and a proven LOWER
bound on its spectral gap (`λ_2`, the first eigenvalue above the trivial constant-vector kernel)
together give a provable condition-number bound `κ = λ_max/λ_2`, which in turn bounds how fast
that system relaxes, converges, or decays — without fitting anything to data.**

This is a *template*, applicable everywhere `L_R` appears as a root or a parent in Toledo — which,
as of v1.8.0/v1.9, already includes the social-instability telegraph generator (`weld/S.01.v1`),
the URCF turbulence relaxation-inertia law (`weld/P.05.v1`), IDM's own discrete-Laplacian family
(roots `D`, `A2`), and — the reason this document was written today — a proposed geometric-decay
error predictor for iterative 6D pose refinement (`registry/proposals/spectral_decay_predictor.json`,
`PROP-DECAY-01`, external repo `task-conditioned-6d-pose-stop`).

## Status, both halves, stated plainly

| Half | Statement | Toledo code | Status |
|---|---|---|---|
| **Ceiling (proven today)** | `λ ≤ 4 − F_min` (curvature floor, sharper) | `weld/M.40.v1` | **Th_coqc, axiom-free** (`Print Assumptions` = Closed) |
| **Ceiling (proven today, alternate)** | `λ ≤ 2·d_max` (Rayleigh/Gershgorin route) | `weld/M.42.v1` | **Th_coqc, axiom-free** |
| **Floor (cited, NOT yet proven)** | `λ_2 ≥ 4/(nD)` (Mohar/Fiedler diameter floor) | `q_formal/M.07.v1` | **untagged / wrapped_related** — a bare citation, no Coq witness in this repo as of this writing |
| Related, floor's sibling fact | `λ_2 > 0` for a connected graph (existence, not a numeric floor) | `weld/M.43.v1` | **Th_coqc, axiom-free** |

**Read this table honestly, not optimistically:** Toledo currently has a real, machine-checked
CEILING and a real, machine-checked EXISTENCE-of-a-gap fact, but only a *cited* numeric FLOOR. The
method above is only as strong as its weakest half — right now, that is the floor. Any downstream
use of `κ = λ_max/λ_2` (e.g. `PROP-DECAY-01`) inherits that weakness and must say so, not silently
borrow the ceiling's stronger tier for the whole ratio.

## Why the floor is harder than the ceiling (recorded so the next attempt doesn't repeat this)

The three ceiling proofs machine-checked today (`InfoSpectralCeilingSharp.v`, `RDL_SpectralCeiling.v`,
`RDL_GammaSpectral.v`) all use a **single, exact test-vector/witness argument**: take the specific
edge or vector that realizes the extreme case, plug it into the Rayleigh quotient taken
*extensionally as a hypothesis*, and bound that one instance — this needs no general spectral
theory. A numeric LOWER bound on `λ_2` is structurally different: `λ_2` is a *minimum* over every
vector orthogonal to the constants, so proving `λ_2 ≥ c` requires showing **every** such vector has
Rayleigh quotient `≥ c`, not exhibiting one good vector — the classical Mohar (1991) proof does this
via the full min-max (Courant–Fischer) characterization, a strictly heavier piece of spectral
theory than any of today's three ceiling files needed. A same-day attempt to mechanize it
(2026-09-09, in service of `PROP-DECAY-01`) is recorded honestly wherever it lands — see that
proposal file and its own Coq status for the outcome, success or a documented stopping point.

## Where this connects across the ecosystem (why it matters beyond one project)

- **`weld/S.01.v1`** (social-instability telegraph generator) and **`weld/P.05.v1`** (URCF
  turbulence relaxation law) both have the exact functional shape `τ dΦ/dt + L_R Φ = S + η` — the
  SAME ceiling+floor pair would bound how fast either system relaxes toward its fixed point,
  answering "how many ticks until this is close to equilibrium" with a proof, not a simulation.
- **IDM's own number ladder and `A2` fold engine** already carry closed, axiom-free discrete
  calculus (`weld/M.41.v1`'s discrete-Laplacian-stencil precursor) that this ceiling/floor pair
  extends rather than duplicates.
- **`PROP-DECAY-01`** (this session's newest use) treats an ICP normal-equations matrix as an
  `L_R`-type object to bound its own convergence rate — flagged in that proposal as an *analogy*,
  not an established identity, precisely because this document exists to hold the general,
  domain-neutral version of the claim separately from any one domain's borrowed use of it.

## What to do next, in order of value

1. **Attempt the Mohar-bound Coq proof properly** (a real min-max/Courant–Fischer argument, not a
   single-vector shortcut) — this would upgrade the floor from citation to Th_coqc and make the
   whole method load-bearing everywhere it is used, not just at one project's risk.
2. Whenever a new `L_R`-shaped system is registered in Toledo (any reading whose statement has the
   form `τ dΦ/dt + L_R Φ = ...`), add a row to a "known instances" list here (not yet built as a
   generated table — a manual list above, kept honest by hand, until it is worth a script).
3. Never let a downstream proposal (like `PROP-DECAY-01`) restate the ceiling/floor pair inline —
   point back here, so a single correction (e.g. the floor finally getting proven) propagates by
   reference instead of needing to be found and fixed in every borrower.
