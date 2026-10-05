# PROP-FLOOD-10a — NEW DERIVATION / PROPOSAL (not a Toledo theorem)

**Monotone endpoint enclosure over a declared finite box on ℚ, its per-tick iterated form, and the
nested-box condition, with fail-closed bounds.** Version `v1.1` (2026-09-28; v1.1 after independent review, advisories A1, A2, A12). Tier `Dr`, status
`unverified`, code `weld/M.??.v1` (proposals lane). Registry record:
`registry/proposals/flood_interval_enclosure.json`. Coq: `coq/canonical/PROP_FLOOD_10_enclosure_nested_box.v`.

This is "Δ2" of the FloodConnect reuse card. It is **domain-generic**: nothing in it mentions water.
It is registered **once**, here. PROP-FLOOD-08 uses it directly for `E_k` (`excess_sigma_monotone`); the
interval form of `L` is the **same form, proved directly** in 08 (`load_ratio_enclosure`), not a corollary.
PROP-FLOOD-10 uses `cl`, `refine_check` and `excess` directly (zoom levels 0–3). Neither registers a second
enclosure object.

## Source

- Founder instruction (verbatim, 2026-09-27): "ทำสมการให้ครบก่อนนะ" (finish the equation set first),
  given before any 10-day forecast run.
- The downstream reuse card (FloodConnect, `morrocwi/floodconnect`,
  `docs/knowledge/TOLEDO_HYDRAULICS_DIFFUSION_ZOOM_REUSE_2026-09-27.md` §4.1, §6.2 Δ2) found the same
  enclosure requested twice: by the PROP-FLOOD-08 draft (§4.4, HOLD) and by the zoom draft. It asked
  for one registration.

## 1. Toledo lookup (MEASURED, `mcp/`)

- `check --formula "f(box) subset [f(x_lo), f(x_hi)] monotone endpoint enclosure"` returned `NOT_REGISTERED`.
- `check --formula "cl(lo,hi;theta) := classify((hi-lo)/2, (lo+hi)/2 - theta)"` returned `NOT_REGISTERED`,
  because the checker matches text. The statement read below is the actual reuse.
- `find enclosure` returned 0 hits. The following candidates were read and none matches:
  - `find endpoint`: `EQ-015/M.07`, `EQ-015/H.52`, `L_R/M.01` (handshake), `WP.S24.DomainCard`.
  - `find squeeze`: `R/P.02.v1`, an integer square-root bracket.
  - `find interval`: `A.5/S.05.v1` (viable-region membership).

## 2. Genesis compatibility

`readout_genesis` A.13 Gate 2, Three-Valued Admissibility (READOUT_GENESIS_CORE.md line 3775 at local
`6f2cb06`, VERIFIED by grep):

- `POSSIBLE` is ⊥ of the interval: the instrument cannot decide which side of θ the value lies on.
  It is not the obstruction value `0`.
- A missing bound is recorded as unresolved: REFUSED for that layer only. It is never replaced by an
  infinity, and ℚ has none.

## 3. Reuse (parents, by code; statements read)

| Code | Role |
|---|---|
| `D/M.71.v1`–`D/M.76.v1` | `classify` is imported from the IDM mirror, not restated. `cl(lo,hi;θ) := classify((hi−lo)/2, (lo+hi)/2 − θ)` is an exact renaming. |
| `D/M.77.v1` | Same-centre special case: a wider floor at the same `v`. The nested-box theorem generalises it (see §4). |
| `R/M.30.v1` | Monotone product brick (IDM statement; the Coq file uses the stdlib form). |

Neighbours, not parents (v1.1): `R/M.25.v1` (a specific quadratic step, not a general brick) and `Z/M.15–17.v1`,
`Z/M.22.v1` (max-plus context on ℤ; the proofs use the stdlib `Qmax` lemmas).
| `A2/M.12–14.v1` | fold-max: the worst source bounds every source and is attained. |

## 4. The delta

All quantities are finite rationals. There is no limit and no `±∞`.

```text
Box B = Π_{i<n} [lo_i, hi_i] (declared), sign pattern σ_i ∈ {+,−} (declared),
f non-decreasing on I+, non-increasing on I−.
x^{lo*}_i := lo_i (i ∈ I+), hi_i (i ∈ I−);   x^{hi*} := the reverse.

(1) enclosure     ∀x ∈ B:  f(x^{lo*}) ≤ f(x) ≤ f(x^{hi*}),   both corners ∈ B (tight)
(2) iterated      D_{t+1} = g(D_t, u_t), g ↑ in D, σ-monotone in u, u_t ∈ B_t, D^lo_0 ≤ D_0 ≤ D^hi_0
                  ⇒ D^lo_t ≤ D_t ≤ D^hi_t for every tick t (corner runs)
(3) nested box    B_c ⊑ B_p (lo^p ≤ lo^c ≤ hi^c ≤ hi^p on shared coordinates)
                  ⇒ [f(x^{lo*}_c), f(x^{hi*}_c)] ⊆ [f(x^{lo*}_p), f(x^{hi*}_p)]
(4) three-state   cl = Sp ⇔ θ < lo (ROBUST) · Sm ⇔ hi < θ (BELOW) · Sz ⇔ lo = hi = θ (AT_THRESHOLD)
                  · Sbot ⇔ lo ≤ θ ≤ hi, lo ≠ hi (POSSIBLE);  lo = θ < hi is POSSIBLE (declared, conservative)
(5) nested states a nested child inherits a ROBUST/BELOW parent and can never flip it;
                  without nesting it can (counterexample `not_nested_can_flip`)
(6) fail-closed   undeclared endpoint → REFUSED BOUND_MISSING (that layer only);
                  lo > hi in either layer → BOUND_ORDER (checked first); non-nested strict refinement → NOT_NESTED
(7) box-restricted (v1.1) f monotone only between points of B (e.g. products on the non-negative orthant):
                  the same enclosure holds for a well-formed box (enclosure_sound_box)
```

The monotone instances proved in the Coq file, so downstream users do not re-derive them:

- `excess(s, r) = max(0, s − r)`. This covers PROP-FLOOD-08 `E_k` and PROP-FLOOD-10 point depth.
- The screening step `max(0, D + P − C)`. It is proved monotone here but stays a heuristic.
- The PROP-FLOOD-03 step on a non-negative box.

## 5. Coq (MEASURED 2026-09-28)

The file compiles with `coqc -q -Q . MRC -R ../information-discrete-math IDM` in a scratch build.
`Print Assumptions` returns **Closed under the global context** for all 29 items (v1.1):

- The core results: `enclosure_sound`, `corners_in_box`, `iterated_enclosure` and `nested_enclosure`.
- The three-state readout: `cl_plus_iff`, `cl_minus_iff`, `cl_zero_iff`, `cl_bot_iff`,
  `cl_plus_sound_members` and `cl_minus_sound_members`.
- The nested-box readout: `nested_preserves_plus`, `nested_preserves_minus`, `nested_no_flip` and
  the counterexample `not_nested_can_flip`.
- The monotone instances: `excess_sigma_monotone`, `excess_nonneg`, `screen_step_mono_D`,
  `screen_step_sigma` and `wb_step_enclosure`.
- The fail-closed bounds: `declared_interval_missing_iff`, `declared_interval_ok_wf`,
  `refine_check_ok_nested` and `refine_check_refuses_non_nested`.
- v1.1: `enclosure_sound_box`, `sigma_monotone_box`, `refine_check_bound_order`, `checked_refinement_no_flip`.
- Helpers: `corner_lo_below` and `corner_hi_above`.

## What this is NOT

- **Not a probabilistic interval.** The range is guaranteed only for inputs inside the declared box.
- **Not valid for non-monotone maps.** Each use must prove its own sign pattern. The Coq theorem takes
  monotonicity as a hypothesis.
- **The screen's monotonicity is not an endorsement.** `max(0, D + P − C)` being monotone does not
  make it a storage readout.

## Falsifier

A point inside a declared box whose image falls outside `[f(lo*), f(hi*)]` would falsify the
enclosure. The proof excludes this under the stated hypotheses, so a violation means one of three
declarations is wrong: the box, the sign pattern, or the claim that the map is monotone.

A determinate child that is opposite to its determinate nested parent, with no input error, falsifies
the nesting declaration.

## OPEN

None specific to the mathematics. The downstream thresholds, boxes and datums are OPEN where their
own objects say so.
