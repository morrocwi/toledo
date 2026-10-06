# PROP-FLOOD-08 — NEW DERIVATION / PROPOSAL (not a Toledo theorem)

**Four readouts over a declared drainage node, each with an explicit refusal:**

- a load-to-capacity ratio against the owner's design depth for each declared window, per model,
  worst first, in interval form;
- storage exceedance;
- drawdown time, which is a lower bound at the declared maximum (rated) outflow and only a readout at an effective outflow;
- a capacity-reduction slot.

Version `v1.2` (2026-09-28, after independent review: B4, A1, A8, A9, A10, A12; round 2: R2-A8); the untracked `v0-draft` came first. Tier `Dr`, status `unverified`, code
`weld/M.??.v1`. Registry: `registry/proposals/flood_forecast_load_ratio.json`. Coq:
`coq/canonical/PROP_FLOOD_08_load_ratio_drawdown_exceedance.v`.

## Source and founder framing

- Founder (verbatim, 2026-09-27): "สกัดวิธีคำนวณดู เผื่อจะทำให้เราสกัดความเสี่ยงน้ำท่วมได้จากพยากรณ์อากาศด้วย
  สมการที่สั้นที่สุด".
- Founder: "สกัด ทำความเข้าใจ แล้วยกระดับสมการนี้จากองค์ความรู้ที่เรามีให้ใช้ได้ง่ายระดับโลก".
- Founder: "หาคำที่เหมาะสม เพื่อให้ใช้คำนวณได้จริงระดับโลก".
- Founder: "ทำสมการให้ครบก่อนนะ" (finish the equations first).
- Inputs were relayed notes from an external assistant. They are all RELAYED.
- Founder rulings applied:
  - "Water debt" is derived from PROP-FLOOD-03 and is never a rival equation.
  - There is no compound interest.
  - Capacity reduction is absent until it is fitted from real events.
  - "Rain − 80 mm/day" is a screening heuristic only.
  - Report ranges, per model, worst first, never averaged.
- **Correction folded into v1** (downstream `S51_DEBT_ONSET_AND_BMA_COPING_INDICATOR_2026-09-27.md`
  §1.1, a downstream tracker item on correcting the window pro-rating): the draft's
  `C_H := (H/24)·D_design` was wrong.
  - It gave 80/24 = 3.33 mm at H = 1 h, against the owner's own declared 58.7 mm/h.
  - It also bridged windows, which conversion rule R2 forbids.
  - v1 therefore uses **owner-declared depths per window** and refuses every other window.

## 1. Toledo lookup (MEASURED, this session)

`check --formula` returned `NOT_REGISTERED` for each of:

- `L = P / D_design load ratio`;
- `C_H(U) := D_design(U,H) * A_U only at declared window H`;
- `E_k = max(0, S_k - S_safe)`;
- `T_dd = V_stored / Q_out`.

`find drawdown` returned 0 hits. The following were read and are **not** parents:

- `EQ-015/W.19.v1` (`REGISTERED_SPLIT`, `usable:false` — cited for context only; split into
  `EQ-015/W.55.v1`..`W.59.v1`): `τ^rec` is an input to an urgency vector.
- `R/M.14.v1`: a geometric recession tail. It is complementary to `T_dd`, not a twin.
- `A.5/S.07.v1`: a text-only candidate for the screen recursion, and structurally not a match.

## 2. Genesis compatibility

The gate is VI-A B.2a, the generic conservation ledger `[Dr]`, the same gate 03 and 06 use. Every
object here is a readout **of** that ledger: a ratio, a positive part, a quotient or a factor.

`ZERO_OUTFLOW` is a refusal. It is never `1/0 = ∞`.

## 3. Reuse (parents, by code)

| Code | How it is reused |
|---|---|
| `delta_R` | `S_k − S_safe`, `H − z` and `C_H − F_H` are retained differences |
| PROP-FLOOD-03 | Supplies the state `S_k`, the `Q_out` rule and its five refusal codes. The codes are reused verbatim and checked first. |
| PROP-FLOOD-06 v6.1 | `L` is a **sibling** ratio to `S_H = F_H/C_H`, not `S_H` itself and not a new case of 06's case split (a)–(d) — 06 is not amended by this registration (stays `v6.1`). `L`'s numerator is 06's rain term (`c_U·P^m_H`) plus the carried storage exceedance `E_k`; `Q_in,up` is reported separately via PROP-FLOOD-09's `D_in`, never folded in. `L`'s denominator is `D_design(U,H)` directly (mm, same unit as the numerator). This proposal also states its own design-capacity term `C_des_H(U) := D_design(U,H)·A_U`, defined only inside 08 (08-local; not `L`'s denominator, in place of — not a rename of — 06's `C_H`). Also reused as terms, not as the same object: the `c_U` bound pair, `multi_model_scenarios`, `forecast_grid_cell_mean`, `g_U(t)`, the running-pump count and `calibration_procedure`. |
| PROP-FLOOD-10a | `E_k` monotonicity **is** 10a `excess_sigma_monotone`. The interval form of `L` is a **direct proof in the same form** as the 10a enclosure, not a corollary (10a's global monotonicity does not cover products on the non-negative orthant). The verdict against 1 is `cl` (D/M.71–76). |
| `A2/M.12–14.v1` | fold-max on ℤ: the worst bounds every element and is attained. The ℚ analogues are proved directly here. |

Neighbour, not a parent: `EQ-015/H.51.v1` (a continuum barrier certificate `dL/dt = f(L,C,u)`, not a per-window ratio).

## 4. The deltas

All quantities are rationals; there is no continuum.

### 4.1 Design capacity `C_des_H(U)` (08-local), DESIGN_DECLARED per window, and the load ratio

```text
D_design(U, H): owner-declared depth for EXACTLY window H (finite table, source-tagged)
   Bangkok, BMA drainage plan 2569 p.63 (VERIFIED downstream):  1 h → 58.7 mm ;  24 h → 80 mm
C_des_H(U) := D_design(U, H) · A_U            only at a declared window   (08-local; in place of
                                               06's C_H, not a case of 06)
         otherwise REFUSED DESIGN_DEPTH_UNDECLARED        (no pro-rating, no bridging)
L^m_H(U) := ( c_U · P^m_H(U) + κ · E_k(U)/A_U ) / D_design(U, H)     per named model m
   κ = 1000 mm/m with E_k in m³ and A_U in m²  (equivalently E_k[m³] / A_U[km²] × 10⁻³ mm)
L_H := max_m L^m_H   (worst first; attained; never averaged)
interval: [L(lower corner), L(upper corner)] via PROP-FLOOD-10a  (↑ in P, c, E; ↓ in D_design)
```

The two Bangkok numbers were declared separately. The downstream R2 check found that at return
period T = 2 y the 1 h depth is 58.7 mm but the 24 h depth is 93.6 mm, not 80. The two numbers are
therefore never converted into each other.

Other details of the ratio:

- A missing `E_k` gives the rain-only ratio. It is reported as a **minimum**, which is proved.
- `c_U` is 1 (the upper end of 06's pair) unless measured.
- The following are **renamings** of `L`: the relayed "water DSR" `(P+D)/C_eff`, the "rain-load
  ratio" `P_24/80`, and the standard utilisation or load-to-capacity ratio.
- The relayed "multi-day envelope" `P_n/(n·80)` is **withdrawn** because it pro-rates across
  windows. Evaluate `L_24` day by day, and carry storage through `E_k`.

### 4.2 Storage exceedance

```text
E_k(U) := max(0, S_k(U) − S_safe(U))       one declared unit/datum
REFUSED: PROP-FLOOD-03 codes first (NEGATIVE_STORAGE is never clipped to 0),
         then SAFE_STORAGE_UNDECLARED (reference undeclared), DATUM_UNDECLARED (not one unit/datum)
```

**Sign warning** (kept on purpose): "storage deficit" in international usage means *available*
storage, which has the opposite sign. `E_k = 0` whenever room is available. `E_k = 0` means "no
exceedance", not "safe". The public label "water debt" applies to `E_k` only.

PROP-FLOOD-10 level-3 point depth `max(0, H − z)` is an **occurrence** of this object, on a length
unit and with the same-datum rule.

### 4.3 Drawdown time

```text
T_dd(U) := V_stored(U) / Q_out(U)      seconds (also h, d)
   Q_out = declared maximum (rated) outflow over the horizon  → a LOWER bound on real drawdown
   Q_out = effective (current) outflow                          → a readout, NOT a bound
REFUSED: MISSING_INPUT (V undeclared), NEGATIVE_STORAGE (V < 0), ZERO_OUTFLOW (Q_out ≤ 0; a non-value)
```

It is proved (`drawdown_is_lower_bound`) that, with any non-negative inflow and an outflow never
above `Q_out` at every tick, storage cannot reach 0 before tick `k` with `k·τ ≥ T_dd`. That hypothesis
holds for a declared maximum (rated) outflow, not for the current effective outflow, which can rise
later (more pumps, a gate opening). So only `T_dd` at rated outflow is a bound; `T_dd` at effective
outflow is a readout. `drawdown_rated_le_effective` shows `T_dd(rated) ≤ T_dd(effective)`.

### 4.4 Capacity reduction

```text
C_eff = C_0 · η,   η = g_U(t) · (running-pump fraction) · η_canal,   η_canal ABSENT until fitted (no default 1)
fitted η outside (0,1] → REFUSED ETA_OUT_OF_RANGE (never the same readout as ABSENT)
```

`L` at rated capacity is a proved lower bound for every `η ∈ (0,1]`. There is no compound-interest
factor.

## 5. §5.1 debt-onset mapping (BMA plan 2569; mapping only, no new object)

| Plan period (p.22) | New debt (this object) | Carried | Stacked | Repayment slowdown |
|---|---|---|---|---|
| 1 May–Jul, normal 10–60 mm/h | `L_1 ∈ [0.17, 1.02]` → POSSIBLE | `E_k` (REFUSED) | not stated | stage ~+1.20 |
| 2 Aug–Oct, normal 60–90 mm/h | `L_1 ∈ [1.02, 1.53]` → **ROBUST above 1** | `E_k` multi-day (REFUSED) | not stated | +1.50…+1.80 ⊥; above +1.80: 06 `g_U` derating; +2.00 = plan's "may fail" line |
| 3 Oct–Dec, >90 mm/h early Oct | `L_1` > 1.53 → ROBUST | `E_k` (REFUSED) | PROP-FLOOD-09 `D_in` (REFUSED today) | as above; C.29B > 3,500 m³/s |

The plan's own "normal" band for period 2 already exceeds its declared 1 h depth. This is Coq
`Example bma_p2_normal_band_exceeds_1h_capacity`, a mapping fact rather than a new object. It holds for
`c_U = 1` and rain only (`E_k = 0`), as written.

October sits in both period 2 and period 3. Evaluate both and report the worse first.

## 6. Coq (MEASURED 2026-09-28)

`coqc -q` is clean. `Print Assumptions` returns **Closed** for all 40 items (v1.2). Key items:

- **Capacity only at declared windows:** `design_depth_only_at_declared_window` and
  `design_depth_refused_when_window_undeclared`.
- **Declared-table examples:** `bma_1h_declared`, `bma_24h_declared` and `bma_3h_refused`.
- **The retired pro-rating:** `draft_prorating_contradicts_owner`.
- **Load ratio:** `rain_only_is_lower_bound`, `load_ratio_enclosure`, and the guarded entry point
  `load_ratio_checked_ok` / `load_ratio_checked_refuses_undeclared_window` (v1.1).
- **Guards (v1.1):** `exceedance_refuses_negative_numeric` (a numeric negative state is refused, never clipped)
  and, v1.2, `eta_total_in_range`, `eta_out_of_range_refused`, `eta_absent_is_not_refused`: η has three distinct
  outcomes — a value in (0,1], ABSENT (not yet fitted), or REFUSED `ETA_OUT_OF_RANGE` (fitted but outside (0,1]).
- **Worst first:** `worst_bounds_every_model`, `worst_is_attained` and
  `worst_refused_only_when_no_model`.
- **Capacity reduction:** `rated_ratio_is_lower_bound` and `eta_absent_without_fit`.
- **Storage exceedance:** `exceedance_*`, including the sign-warning lemma
  `exceedance_zero_when_room_available` and `exceedance_never_clips_negative_ledger`.
- **Drawdown:** `drawdown_zero_outflow_refused`, `drawdown_missing_refused`, `drawdown_ok_iff`,
  `drawdown_rated_le_effective`, `stored_lower` and `drawdown_is_lower_bound`.

## What this is NOT (explicit non-claims)

- **No windows are pro-rated.** No hourly intensity is inferred from a 24 h total, and no 24 h depth
  from an hourly one. The only relation is `0 ≤ P_1h ≤ P_24`, a bound, which almost always reads
  POSSIBLE.
- **No point depth without one datum.**
- **No forecast-skill claim.** A forecast-only `L ≈ 0.66` missed an observed `L_24 = 2.54` on
  26 Sep 2569. A forecast-only `L` never lifts a tier above L1 (06).
- **No routing, Saint-Venant solve, rating curve, or rainfall–runoff model beyond `c_U`.**
- **The screen `max(0, D + P − 80)` is a heuristic.**
- **No compound interest.**

## Falsifier

1. Replayed independent events for a unit class may show systematic mismatch per declared window:
   `L ≥ 1` repeatedly without flooding, or `L < 1` repeatedly with flooding. That falsifies
   `D_design(U,H)` as the effective capacity for that window and class, not the arithmetic. The fix
   is 06 calibration, never pro-rating another window.
2. A drain-down observed faster than `T_dd` at rated outflow falsifies `V_stored` or the outlet set.
   The first candidate is `UNDECLARED_EDGE`.
3. A measured `η = 1` under full canals across at least 3 events retires `η_canal` for that class.

## Honest caveats and OPEN

- Declared depths exist only for the Bangkok system, and only for 1 h and 24 h. Use at a village node
  is a scope borrow, tagged RELAYED-scope.
- Gauge `L_1` is UNRESOLVED for every event held, because the downstream collector does not yet store
  `rain_1h` (an open downstream data-collection gap). ERA5 cell means never reach 58.7 mm/h in
  21.7 years (downstream MEASURED).
- 0 of 57 ponds have a stage–storage relation, so `E_k` and pond `T_dd` are REFUSED everywhere.
  At Sammakorn the refusal is `SAFE_STORAGE_UNDECLARED` plus missing stage–storage, and the datum is
  OPEN.
- OPEN: whether 1,200 m³/s is city-wide or east-bank rated outflow.
- OPEN: founder wording for "level of service".
- OPEN: declared depths for 2, 3, 6 and 12 h.

## OPEN — founder decision

- Wording "level of service" for `D_design(U,H)`.
- `N_min` for any skill statement (downstream proposes 10).
