# PROP-FLOOD-11 — NEW DERIVATION / PROPOSAL (not a Toledo theorem)

**Acceleration-aware time-to-bank-level: how fast the water is rising, whether that is speeding
up, and when — if that keeps up — it reaches the bank.** Version `3` (2026-10-05). Tier
`Dr`, status `unverified`, code `weld/M.??.v1` (proposals lane). Registry record:
`registry/proposals/flood_acceleration_eta.json`. Coq: `coq/canonical/PROP_FLOOD_11_acceleration_eta.v`.

This is the primary object the founder asked for: a riverside person already watches how fast the
water is rising. Flooding means water over the bank first. This formalises exactly that — whether
the water is already over the bank, the rate of rise, whether the rise is itself speeding up, and
when (if it keeps up) that reaches the bank — as a finite, discrete, refusal-aware readout.
PROP-FLOOD-12 (an overview rain scenario) is a separate, secondary object; this one must stand on
its own.

This version (v3) is revised after independent review. See the registry record's
`version_history` for the full before/after.

## Source

Founder request (verbatim, raw, typos included, 2026-10-05): "ดูความเร่งของบึง
ว่าจะล้นตลิ่งเมื่อไหร่ได้ และ สามารถ ไปดูภาพรวมแล้วจำลองการคำนวนว่าจะล้นตลิ่งเมื่อไหร่ได้
จงพัทำให้เป็น ระบบคิดสกิลหลังกของเอไอที่ต่อเข้ากับระบบที่ทำทั้งหมด" (in English: watch the pond's
acceleration to tell when it will overflow its bank, and also look at the overview and simulate
when it will overflow its bank; make this the core thinking skill for AIs, connected to the whole
system this is built with). Same-day founder follow-up (verbatim, raw, typos included): "เพราะในชีวิตจริง
คนริมน้ำก็จะดูว่าน้ำขึ้นเร็วแค่ไหนอยู่แล้ว และ น้ำท่วาม คือน้ำล้นตลิ่งเป็นเรื่องแรก" (in English: because
in real life, people by the water already watch how fast the water is rising, and flooding — the
water going over the bank — is the first thing) then (verbatim): "โฟกัสที่มัน" (focus on that). This
made PROP-FLOOD-11 the primary deliverable, finished completely (Coq, validators, clean commit)
before PROP-FLOOD-12.

Context: an earlier backtest of PROP-FLOOD-03 (water balance) found it refused everywhere because
its initial storage `S0` is undeclared. An OBSERVED level — a pond/canal gauge reading `h(t)` —
removes the need for `S0`. PROP-FLOOD-11 runs entirely off that observed series.

**Precondition:** `h(t)`, the current retained sample, is a precondition of this whole
construction, not a `NO_READOUT` case — without a current retained sample there is no readout at
all. Every outcome below (`ALREADY_AT_BANK`, `EtaOk`, every refusal) presupposes `h(t)` exists.
`NO_READOUT` covers only a missing `h(t−k)` or `h(t−2k)` — i.e. `Δ_k(t)` or `Δ_k(t−k)` itself
undefined — never a missing `h(t)`.

## 1. Toledo lookup (MEASURED, `toledo` CLI)

- `toledo show weld/M.41.v1` → `REGISTERED_CURRENT`, `Th_coqc`: "Dirichlet energy PSD/gauge
  invariance for a weighted graph ... discrete second-difference IS the discrete negative
  Laplacian." Read in full. Same `[1,-2,1]` stencil shape as this object's `D2_k`, but a spatial
  weighted-graph energy functional, not a time-tick series extrapolated to a threshold — a
  **sibling**, not a parent. No statement of this object is reused.
- `toledo find "WP.S8"` → `WP.S8.SecondDifference`, `REGISTERED_CURRENT`: `delta_t^2 X_n =
  (X_{n+1} - 2 X_n + X_{n-1}) / Delta t^2`. This is the lag-1, continuum-normalised second time
  difference — the direct **parent** this proposal generalises to lag `k`, dropping the `/Delta
  t^2` continuum normalisation (no derivative, no limit, per information-discrete-math).
- `toledo find "acceleration"` → four physics-domain hits (`EQ-015/P.92.v1` Atwood machine,
  `EQ-001/P.74.v1` MOND-like scale, `Gateway.SemanticLanes` Unruh lane, `Guard13` semantic-lane
  type-checker). All read; none is a scalar tick-series second difference with a horizon search.
- `toledo find "second difference"` → `XXI` (discrete Riemann curvature) and `step32` (mixed
  second differences in a domain-discovery engine), both root-layer, neither a time-series ETA
  construction.
- No existing object computes a least-`n` horizon search over a quadratic persistence
  extrapolation with a named, precedence-ordered refusal set, or has an `ALREADY_AT_BANK` outcome.
  Gap confirmed by reading statements, not keywords.

## 2. Genesis compatibility

`readout_genesis` Part V-A, A.13 (the ternary admissibility certificate, the same gate PROP-FLOOD-02
cites for its own `REFUSED` branch):

> "δ_R ⇒ 𝔖_n →[E_α] 𝔃_α^cand →[Suff_{α,L}] 𝔃_α →[𝒞∈{1,0,⊥}] Adm_n" and "【Unresolved is not obstructed,
> and neither one is impossible】" (READOUT_GENESIS_CORE.md, Part V-A, A.13; bracket matches the
> source's own `【…】` glyph)

`EtaAtBank` and `EtaRefused` together make the certificate's three branches explicit and total:
`EtaAtBank` is the resolved, positive `1`-branch, reached without ever needing a retained
difference. `EtaRefused` is the `⊥`/`0` branch, split six ways (`NO_READOUT`,
`PUMP_STATE_CHANGED`, `PUMP_STATE_UNDECLARED`, `SPARSE_SERIES`, `NO_RISE`,
`NOT_WITHIN_HORIZON`) rather than collapsed into one undifferentiated `REFUSED` — never a silently
dropped case, never a fabricated number. The pump reasons specifically guard the
persistence-extrapolation assumption itself: extrapolating two retained differences forward is a
readout, never a claim about what the pond will actually do.

## 3. Reuse (parents, by code; statements read)

| Code | `derived_via` | Role |
|---|---|---|
| `PROP-FLOOD-01` | `instance_of` | `D2_k(t) := Δ_k(t) − Δ_k(t−k)` applies PROP-FLOOD-01's own retained difference to its own output one lag back. `NO_RISE` reuses PROP-FLOOD-01's resolution gate `ε` unmodified. |
| `PROP-FLOOD-02` | `extended` | At `D2_k(t) = 0`, this object's level reduces exactly to PROP-FLOOD-02's linear extension (proved: `eta_D2_zero_matches_linear`, and at the wrapper level `eta_readout_D2_zero_matches_T_k`, given `gap ≤ max_gap` and `pump` `UNCHANGED`). **Explicit map** from PROP-FLOOD-02's outcomes to this object's: 02 `UNRESOLVED` → `NO_RISE`; 02 `NOT_APPLICABLE` (falling) → `NO_RISE`; 02 `NOT_APPLICABLE` (`h ≥ θ`) → `EtaAtBank`; 02 `NOT_APPLICABLE` (`NO_READOUT` input) → `NO_READOUT`. **Added outright**, no PROP-FLOOD-02 counterpart: `PUMP_STATE_CHANGED`, `PUMP_STATE_UNDECLARED`, `SPARSE_SERIES`, `NOT_WITHIN_HORIZON`. |
| `WP.S8.SecondDifference` | `generalises` | Lag-1, continuum-normalised parent; this object generalises it to lag `k` and drops the `/Δt²` normalisation. |
| `PROP-FLOOD-10a` | `reuses` | `enclosure_sound` is applied UNCHANGED to the (Δ,D2) level map for the interval-enclosure theorem — not re-derived. PROP-FLOOD-10a is itself an **open proposal (PR #64)**; its Coq file was **imported and compiled** directly. |

Neighbours, not parents: `PROP-FLOOD-03` — no statement of PROP-FLOOD-03 is reused.
`weld/M.41.v1` — same `[1,-2,1]` stencil shape, spatial-graph domain, not a parent.

## 4. The delta — in the riverside person's own terms

All quantities are finite rationals at declared ticks. There is no limit, no derivative, no `h→0`.
`h(t)` is a precondition throughout (see above) — every line below presupposes it is retained.

```text
Is it already over the bank?  ALREADY_AT_BANK  iff  theta <= h(t)   -- checked FIRST; a real answer, not a refusal

How fast is it rising?        Delta_k(t)  := h(t) - h(t-k)                     (PROP-FLOOD-01)
Is that speeding up?          D2_k(t)     := Delta_k(t) - Delta_k(t-k)         (this object, Delta of PROP-FLOOD-01's own output)
If that keeps up, where       L(n) := h(t) + n*Delta_k(t) + n(n+1)/2 * D2_k(t)  n = 0,1,2,... k-tick strides forward
  will it be in n strides?
When does it reach the bank?  ETA (strides) := least n in [1, N_max] with L(n) >= theta
                               ETA (ticks)   := n * k                           (theta = agency min_bank/overbank, or critical)
```

Refusal precedence (fixed order, first match wins):

```text
ALREADY_AT_BANK  (not a refusal)
  > NO_READOUT                 -- h(t-k) or h(t-2k) is missing (h(t) itself is a precondition, never a NO_READOUT case)
  > PUMP_STATE_CHANGED          -- the declared pump/gate state changed inside the window
  > PUMP_STATE_UNDECLARED       -- the pump/gate state was never declared (never silently read as unchanged)
  > SPARSE_SERIES               -- the sample spacing exceeds a declared maximum
  > NO_RISE                     -- the water is not rising faster than the sensor's own resolution
  > NOT_WITHIN_HORIZON          -- nothing in the declared search window [1, N_max] reaches the bank
```

The pump flag is 3-way — `CHANGED` / `UNCHANGED` / `UNDECLARED`, never a bare bool — and its
declared window is the retained samples `[t−2k, t]` (used to compute `Delta_k(t)`/`Delta_k(t−k)`)
**plus** any change declared on the operator's own schedule for the forward extrapolation window
`(t, t+N_max·k]`. The same wording is used here, in the registry JSON, and in the Coq comments.

## 5. Coq (MEASURED 2026-10-05)

Scratch build in a scratch directory outside the repository (nothing committed; no `.vo` anywhere
in the tree): `coqc -q -R IDM IDM IDM/formal/IDM_ReadoutMinimality.v`, then
`IDM_ResolvedCount.v`, then `coqc -q -Q . MRC -R IDM IDM PROP_FLOOD_10_enclosure_nested_box.v`,
then the same for `PROP_FLOOD_11_acceleration_eta.v`. `coqc -q` is clean on both files. `Print
Assumptions` returns **Closed under the global context** for all **32** items:

- Embedding/arithmetic helpers: `Qnat_nonneg`, `Qnat_S`, `Qnat_le_mono`, `tri_nonneg`.
- The level and its monotonicity: `level_D2_zero`, `level_mono_D2`, `level_mono_joint`.
- The horizon search, soundness and no-smaller-`n`: `search_sound`, `search_none_horizon`.
- The D2=0 reduction to PROP-FLOOD-02: `eta_D2_zero_matches_linear`.
- Monotonicity in D2 (and jointly in Δ,D2): `eta_search_mono_joint`, `eta_search_mono_D2`.
- Qeq-congruence and horizon bounds needed below: `level_qeq_D2`, `search_qeq`, `eta_search_qeq`,
  `search_upper_bound`, `eta_search_upper_bound`.
- `search_succeeds_by`, and the corollary `eta_search_mono_joint_some_propagates` (a slower case
  that already finds `Some` within the horizon forces a faster case to also find `Some`, at or
  before the same stride).
- The interval-enclosure form, reusing PROP-FLOOD-10a's `enclosure_sound` directly: `level_vec_sigma_monotone`,
  `level_box_enclosure`, `eta_interval_enclosure`.
- `eta_readout_at_bank_iff` — `EtaAtBank` iff `theta ≤ h0`.
- `eta_readout_no_readout_iff` — `NO_READOUT` iff a retained difference is itself `None`.
- `eta_readout_ok_sound` — carries `h0 < theta` explicitly.
- `eta_readout_D2_zero_matches_T_k` — at `D2=0`, with `gap ≤ max_gap` and `pump` `UNCHANGED`,
  `eta_readout` returns `EtaOk n` **exactly when** PROP-FLOOD-02's own `T_k`-defined-ness condition
  (`ε < Δ_k(t) ∧ h(t) < θ`) holds and the linear search succeeds.
- Per-reason cause lemmas — `eta_readout_pump_changed_iff`, `eta_readout_pump_undeclared_iff`,
  `eta_readout_sparse_iff`, `eta_readout_no_rise_iff`, `eta_readout_horizon_iff` (linked directly
  to `search_none_horizon` via the corollary `eta_readout_horizon_none_horizon`).

No axioms, no `Admitted`.

## What this is NOT

- **Not a physical forecast.** It extrapolates the two most recently retained differences forward,
  assuming they hold. That assumption is stated, never hidden, and the whole point of
  `PUMP_STATE_CHANGED`/`PUMP_STATE_UNDECLARED` is that this assumption is known to break, or may be
  unknown to hold at all.
- **Not PROP-FLOOD-03's water balance.** No rainfall-runoff, routing or storage-capacity content is
  asserted, and no statement of PROP-FLOOD-03 is reused. It needs no initial storage `S0` because
  it runs off an observed level series.
- **Not a single confident number when refused, and not a refusal when the bank is already
  reached.** `ALREADY_AT_BANK` is a real, positive answer, checked before `h0=5, θ=4` or any other
  case can fall through to a stride-1 `EtaOk` and bury the case the founder most needs flagged.
  Every refusal reason is a named, determinate outcome in a fixed precedence; none is ever
  silently averaged into a produced ETA.

## Falsifier

A declared `(h0, Delta_now, Delta_prev, θ, N_max)` whose returned `EtaOk n` does not actually
satisfy `L(n) ≥ θ`, or for which some smaller `m` (`1 ≤ m < n`) already does, falsifies
`search_sound`. A `θ ≤ h0` case that does **not** return `EtaAtBank`, or an `EtaAtBank` return with
`θ > h0`, falsifies `eta_readout_at_bank_iff`. A case with `D2b ≥ D2a` whose returned `n_b` is
strictly greater than `n_a` falsifies the monotonicity theorems.

## OPEN

- Converting the ETA readout into an actionable warning (what to tell a resident, how far ahead is
  "enough" notice) is a separate decision this object does not make.
- Calibrating a sensible default `N_max` and the resolution/spacing constants `ε`/`max_gap` against
  real pond/canal gauge data is not yet done; this is a design-stage proposal.
- PROP-FLOOD-12 (the overview rain-driven scenario) is the secondary object this proposal composes
  with but does not require; not started this round.
