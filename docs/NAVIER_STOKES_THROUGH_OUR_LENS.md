# The Clay Millennium Navier–Stokes problem, read through the discrete/readout lens

Written 2026-09-09. Source: C. L. Fefferman, "Existence and Smoothness of the Navier–Stokes
Equation" (the official Clay Mathematics Institute problem statement), read in full from
`~/Downloads/navierstokes.pdf`. **This document does not solve, attempt to solve, or claim
progress on the Clay problem.** It extracts what the problem's own known content implies for
`docs/L_R_SPECTRAL_CEILING_AND_FLOOR.md`'s ceiling/floor pair, translated into this workspace's
own discrete, readout-first framework (`information-discrete-math`). Tier: **Dr** throughout — a
reading/synthesis, not a new theorem.

## What the problem actually asks, stripped of continuum framing

Fefferman's statement asks for one of four things about the continuum PDE
`∂u/∂t + (u·∇)u = ν∆u − ∇p + f`, `div u = 0` on `ℝ³`: global smooth existence (A/B), or a
breakdown/blowup example (C/D). Every one of these four options is stated **only** in terms of
`C^∞(ℝ³ × [0,∞))` functions on a literal continuum — i.e., the question is posed entirely inside
what this workspace's own discipline calls a **non-readout**: `ℝ`-completeness (I1) and infinite
spatial/temporal divisibility (I2) are both assumed from the first line, never derived. Through our
lens this does not make the problem meaningless — the continuum is a real, useful *readout limit* —
but it does mean the problem is, by construction, a question about a limit, not about anything any
finite instrument or finite graph could ever exhibit directly.

## The one fact that matters for us: what "blowup" actually is

Blowup means the velocity `u` (equivalently the vorticity `ω = curl u`) becomes **unbounded** in
finite time — literally `Z1`/`I4` in this workspace's non-readout vocabulary (a value reaching
actual `+∞`). The sharpest known criterion (Beale–Kato–Majda, quoted in the source, page 3) is:

```
blowup at time T  <=>  ∫_0^T [ sup_x |ω(x,t)| ] dt = ∞
```

i.e., blowup is exactly the point where the *local curvature/rotation* of the velocity field
(vorticity) escapes every finite bound, accumulated over time. This is the continuum shadow of
**exactly the object our own ceiling theorem bounds**: `weld/M.40.v1` (Anderson–Morley sharp
curvature ceiling) proves, unconditionally and machine-checked, that on *any finite* weighted
graph, `λ ≤ 4 − F_min` — the local curvature/spectral ceiling is **always finite**, by
construction, with no continuum limit involved. There is no discrete analogue of "blowup": a
finite graph's Laplacian spectrum cannot escape to infinity, full stop.

## What this dissolves, and what it does not

**Dissolves (Dr-tier reading, not a new proof):** the Millennium Problem's difficulty is precisely
the question of whether the discrete ceiling (`λ ≤ 4 − F_min`, proven today for any finite graph)
stays **uniform** as the graph is refined toward the continuum (mesh size `h→0`, node count
`n→∞`) — i.e., whether `F_min` (the discrete curvature floor) stays bounded below independent of
resolution. Fefferman's own summary ("standard methods appear inadequate... we probably need some
deep, new ideas") is, read through our lens, a statement that **no one has shown `F_min` stays
uniform in the `I2` limit** — which is exactly the kind of claim `information-discrete-math`
predicts will be hard, since it is a claim about behavior *at* a non-readout limit, not about any
finite readout. This does not solve the problem; it renames the open difficulty in our own
vocabulary and shows why the problem's own literature already lives at the boundary this
workspace's discipline flags by design (see `information-discrete-math`'s pre-write checklist,
item 3: "diagnose which infinity was injected... don't defer to the non-readout").

**Does NOT dissolve:** whether the true continuum Navier–Stokes solution blows up. That question
is about the actual `I1`/`I2` limit object, which this workspace's stance treats as a real
boundary, never reached — we neither claim it resolves to smooth existence nor to blowup. Anyone
citing this document as progress on the Clay problem is misusing it.

## The concrete, useful consequence for PROP-DECAY-01 (this session's actual work)

`docs/L_R_SPECTRAL_CEILING_AND_FLOOR.md`'s floor half, `q_formal/M.07.v1`
(`λ₂ ≥ 4/(nD)`, Mohar/Fiedler), makes the SAME point in the opposite direction, quantitatively: as
a correspondence graph grows (`n` and/or diameter `D` increase — exactly what happens as an ICP
correspondence graph is refined, or as a discretization mesh is refined toward the continuum), the
proven **floor** on the spectral gap shrinks toward zero (`4/(nD) → 0`). Combined with the ceiling
(`λ_max ≤ 4 − F_min`, bounded), the condition number bound

```
κ ≤ (4 − F_min) / (4/(nD)) = O(nD)
```

is **not** uniform — it *grows* with graph size, by construction of our own two proven/cited
bounds, not by assumption. This is the discrete-native, honest reason to expect Fefferman's exact
difficulty (regularity control degrading as resolution refines) to show up as `PROP-DECAY-01`'s
own condition-number-bounded decay predictor being applied to a real ICP correspondence graph: as
the number of correspondences grows (denser depth data, more iterations, finer registration), the
provable contraction-rate bound `ρ_k ≤ (κ_k−1)/(κ_k+1)` should be expected to get **worse** (closer
to 1, slower contraction), not stay fixed — a real, calibratable expectation, not a defect to be
engineered away, since it is now traceable to the same phenomenon Fefferman's own problem statement
is about.

**Action taken:** this expectation has been added as an explicit, honest caveat to
`registry/proposals/spectral_decay_predictor.json` (`PROP-DECAY-01`) — see that file's
`honest_caveats` list, updated 2026-09-09, so a reader of that proposal is told to expect `κ_k` to
scale with correspondence-graph size, not to be surprised if it does.

## What would actually strengthen this reading (not done here)

A real (not Dr-tier) version of this reading would need: (1) a Coq-verified floor `F_min` for a
*specific, named* family of graphs relevant to fluid discretizations (e.g. regular lattice
discretizations of a domain), showing whether `F_min` degrades with mesh refinement or not — this
workspace has not attempted that; (2) the actual Mohar-bound Coq proof itself, still open per
`docs/L_R_SPECTRAL_CEILING_AND_FLOOR.md`'s own status table. Both are real, harder, and separate
next steps from anything claimed here.
