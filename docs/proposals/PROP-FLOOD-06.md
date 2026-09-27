# PROP-FLOOD-06 — NEW DERIVATION / PROPOSAL (not a Toledo theorem)

**Area-generic outlet-headroom / drainage-coping tier-ladder indicator, with (lat,lon) unit
resolution, refusal, and a graceful PARTIAL mode for incomplete real-world data.** Version `v6.1`
(a statement-note revision over v6 — see "round-4 review + forecast-input fold-in — v6.1"
immediately below; v6's L5/LR bypass hysteresis, tau_up boundary naming, inferred coverage-state,
LAYER 0 headline simplification, and backtest v2 findings are retained further down, unchanged).

## round-4 review + forecast-input fold-in — v6.1 (statement note, no structural change)

**Independent round-4 review** (`REVIEW_PROP_FLOOD_06_r4.md`, maker≠checker, read-only) verdict:
**READY FOR PR**, one non-blocking SHOULD-FIX against v6, closed here:

### SHOULD-FIX — Layer 0's "ใกล้" constant now tagged OPEN-for-founder-tuning

r4 found that Layer 0's `เกิน`/`ใกล้`/`ไม่เกิน` verdict's `ใกล้` threshold (`>= 0.8·flooded_min`)
was a bare constant in JSON/MD/Coq with no `OPEN-for-founder-tuning` tag, unlike every other
threshold this proposal declares (the `S_H` bands, the `T_act` bands, `p`/`q` hysteresis, the
rise-rate percentage). **Fixed**: the `0.8` constant is now explicitly tagged
`OPEN-for-founder-tuning` in `definitions.layer0` (JSON), this file, and a new Coq comment beside
`layer0_in_vs_capacity`'s `(8#10)` literal — no verdict logic, arithmetic, or proved theorem
changes.

### Forecast-input definitions — grid-cell mean, per-model scenarios, no averaging

**Founder instruction (verbatim, 2026-09-27):** "ต้องรวมเรื่องนี้เข้าไปด้วย เพราะเดี๋ยวจะสับสน"
(this must be folded in, or it will cause confusion) — given in response to a real forecast/gauge
discrepancy observed on 26 Sep 2569. Folded into the forecast-input definitions (`rain_t`'s
forecast component, `forecast_rain_72h`, and any other forecast term feeding `F_H(U)` or a
Layer-0 `IN_H` input):

1. **A model forecast value is a grid-cell MEAN, not a point value** (new `definitions.
   forecast_grid_cell_mean`). The issuing model's own grid cell (approx. 10–25 km per side; the
   per-model resolution is declared in whichever consuming repo's own model census holds it,
   tagged `RELAYED`) is what the forecast number actually describes — point-scale rainfall at a
   specific location may exceed it substantially, and this proposal makes no claim that the two
   should agree. **The one evidence pair this proposal holds** (`MEASURED`, a single observed
   pair, not a general ratio or a scaling factor): 26 Sep 2569, the rainfall-forecast models
   available at that run reported **13–53 mm** for the relevant cell while the nearest gauge
   measured **203 mm** — recorded as an **OPEN point-vs-cell ratio**; no scaling/correction factor
   is declared from this one pair, it is an evidenced caution against reading a forecast term as a
   point prediction, not a derived correction.

2. **Multi-model inputs are NEVER averaged into one number** (new `definitions.
   multi_model_scenarios`). Whenever more than one model/source reports a value for the same
   declared term, the readout carries **every named per-source/per-model value** and derives named
   scenarios: `worst_case` := the source/model whose value drives the term's contribution to
   `S_H(U)`/`IN_H` **higher** (declared per term which direction is "worse" — the maximum for an
   inflow-raising term such as rain or upstream inflow, the minimum for a capacity-raising term
   such as a declared outlet capacity); `best_case` := the opposite extremum; `majority_band` :=
   the band containing the plurality of named sources by count. **The tier/Layer-0 verdict is
   evaluated on `worst_case` FIRST**, with `majority_band` always reported alongside it, never
   substituted for it. Ensemble members already declared under `rain_t`/`forecast_rain_72h`
   (median, max) are restated under this same discipline as **p10/p90 across members**, not a
   mean, where per-member values are available.

3. **A disagreement flag.** `disagreement_flag(term)` fires when `max − min` across the named
   per-source values exceeds a declared band (`OPEN-for-founder-tuning`, no default stated).

**This applies to any multi-source input, not only rainfall** — the same discipline covers dam
releases reported by EGAT vs. HII, and gauge readings reported by an operating agency such as
สนน. vs. HII: per-source values are always shown, contradictions are always surfaced, **never
averaged away**.

**No S_H/T_act/promoter/p/q threshold VALUE is changed by this v6.1 bump. No unit is calibrated by
this registration. No new Coq theorem is added and no existing Coq definition's computed value
changes** — this is a statement-level revision (new/amended `definitions.*` prose in the JSON and
this file, plus one Coq comment tag), not a structural change.

Registry entry: `registry/proposals/flood_outlet_coping.json` (`version: "v6.1"`).
Coq: `coq/canonical/PROP_FLOOD_06_outlet_coping_tier.v` — re-verified via the same documented
scratch-build convention (07-before-06 order), `coqc -q` clean (same pre-existing harmless
comment-terminator warning category), `Print Assumptions` "Closed under the global context" (no
axioms) on every pre-existing theorem, unchanged.

## round-3 review + LAYER 0 — v6, L5/LR bypass hysteresis, inferred inputs, layer-0 headline

**Independent round-3 review** (`REVIEW_PROP_FLOOD_06_r3.md`, maker≠checker, read-only, pinned at
`ebd34071`) found one MUST-FIX and one SHOULD-FIX against v5, both closed by this v6 bump:

### MUST-FIX — L5/LR bypass hysteresis

r3 found that v5's `persisted` treats `T_L5` ("the system is already exceeded") and `T_LR`
(REFUSED) as ordinary points on the same nat-encoded scale, so a genuinely already-exceeded
reading could be delayed by `(p−1)` hours before being *reported* — exactly like any ordinary
band raise, and in direct tension with this proposal's own "more data must never be suppressed"
discipline (the v4 promoter-floor fix, `full_tier_v4_promoter_monotone`).

**Fix — `persisted_v6`.** A raise **into** `T_L5` or `T_LR` now bypasses the `p`-consecutive-
readout gate entirely and is reported immediately, on the very hour it is raw-observed. A
**lowering** — including a lowering **out of** `T_L5`/`T_LR` — is **unchanged**: it still requires
`q` consecutive raw readouts at or below the new level, exactly as v5 already declared. `persisted`
(v5) itself is untouched; `persisted_v6` is a fresh, additive function (same non-destructive-
extension discipline as every prior version bump in this proposal).

Proved in Coq (`coq/canonical/PROP_FLOOD_06_outlet_coping_tier.v`, v6 section):
`persisted_v6_L5_immediate` and `persisted_v6_LR_immediate` (a genuine raise into `T_L5`/`T_LR` is
reported at the same hour it is raw-observed, no `p`-delay), and `persisted_v6_is_some_historical_raw`
(the v5 falsifier-relevant guarantee, kept: persistence — with the bypass — still never fabricates
a tier absent from the raw history at some earlier-or-same hour).

### SHOULD-FIX — the t−τ_up "before the first upstream reading" boundary, named explicitly

r3 also asked that the boundary case where `t − τ_up(U)` predates the upstream series' own first
available reading be named explicitly, rather than left to be implied by inheriting PROP-FLOOD-02's
own REFUSED conditions. This proposal now declares a dedicated three-way case
(`upstream_leading_component`, Coq): `ULC_absent_tau_undeclared` (no declared upstream gauge/τ_up
for `U` at all — the existing, scoped `UPSTREAM_GAUGE_UNDECLARED` refusal code), a **new**, equally
scoped code `UPSTREAM_TAU_UNDECLARED` folded into the same absent state whenever τ_up itself is the
missing piece rather than the gauge, `ULC_absent_before_first_reading` (τ_up **is** declared, but
`t − τ_up` falls before the upstream series' own first observed reading — **absent, never a
fabricated `0`**), or `ULC_value v` (a genuine reading). Both non-value outcomes are proved to be
genuinely disjoint from ever reporting a real value
(`upstream_leading_state_value_iff_in_range_and_declared`): a value is only ever reported when τ_up
**is** declared **and** the shifted index actually falls within the upstream series' observed
range — never silently collapsed into a same-looking `Some 0`.

### Inferred inputs — cov6(U), importing PROP-FLOOD-07 as a PARENT

The founder instruction v5 explicitly deferred ("อย่าลืมว่าไม่มีทางมีข้อมูลพอ แต่ใช้การอนุมานจากข้อมูล
ที่แข็งแรงเป็นหลัก" — there is never enough data; use inference from strong-enough data as the main
tool) is implemented here **by reusing PROP-FLOOD-07's own primitive**, per this repository's
Toledo-first reuse gate: `From MRC Require Import PROP_FLOOD_07_flow_state` brings in
`coverage3` (`Cov_Present`/`Cov_Absent`/`Cov_Inferred`), `strength` (the 5-rung evidence ladder,
`strength_min` never averaging), and `coverage3_rank` (`Absent=0 < Inferred=1 <= Present=2`)
**verbatim, not re-derived** — the exact object PROP-FLOOD-07's own header said a future
PROP-FLOOD-06.v6 should import.

- **cov6(U)** widens every one of v5's 10 `cov5(U)` components from `bool` to `coverage3`: each of
  the 10 is now `present | inferred | absent`, never a fourth silent state.
- **Coverage counting.** `readout_v6` reports `readout_coverage_present_v6` (count of `Cov_Present`,
  0..10) **and** `readout_coverage_inferred_v6` (count of `Cov_Inferred`, 0..10) **separately** — an
  inferred component is counted, but at the lower rank `coverage3_rank` already assigns it, never
  conflated with a direct `present` reading.
- **`confidence` field.** `readout_v6.confidence_v6 : option strength` is the **minimum** (via
  PROP-FLOOD-07's own `strength_min`, never an average) over every `Cov_Inferred` component's own
  declared confidence, among the components actually used (`confidence_v6_of`); `None` when nothing
  is inferred (`confidence_v6_of_none_when_nothing_inferred`, proved).
- **LR narrowed further.** `cov6_all_absent` — and hence `M_LR` — now fires iff `coverage_available_v6`
  (the Present-**or**-Inferred count) is `0`, i.e. iff **nothing is present AND nothing is
  inferable** (`full_tier_v6_LR_iff_nothing_present_or_inferable`, proved as an `iff`). An
  all-absent-but-inferable unit is, by this construction, never `LR`.
- **Monotonicity, extended.** `full_tier_v6_promoter_monotone` proves the general form of "more
  data never lowers the tier": **any** rank-increasing change to `cov6(U)` — in particular
  `inferred → present` — never lowers the reported tier (non-`LR` case), reusing
  PROP-FLOOD-07's own `coverage3_rank` ordering as the licensing fact, exactly as that proposal's
  own header promised. `full_tier_v6_full_ge_partial` (FULL ≥ the PARTIAL tier the same promoters
  give) is re-proved over the widened, coverage3-aware promoter-availability test
  (`promoter_applies_v6`/`promoter_applies_v6_leading`: a promoter's input now counts as available
  whenever its cov6 component is Present **or** Inferred, at whatever rank the inference carries).

`coverage_vector_v5`/`readout_v5`/`full_tier_v5` and every v1–v5 type, definition, and theorem are
**UNCHANGED** by this section — `coverage_vector_v6`/`readout_v6`/`full_tier_v6` are fresh, additive
objects, per this proposal's own non-destructive-extension discipline.

### LAYER 0 — the declared headline simplification: น้ำเข้า / น้ำออก / รับมือได้

**Founder instruction (verbatim, 2026-09-27):** "เอาแบบง่ายๆ ก่อน น้ำเข้า น้ำออก ความสามารถในการ
รับมือ" (start simple: water in, water out, coping capacity) — "ซึ่งค่ารับมือพวกนี้อ่านจากประวัติได้
เรามีประวัติศาสตร์และงานวิจัยเยอะ" (the coping values can be read from history; we have plenty of
history and research). This is registered as a **declared simplification of this same object, not
a new equation** — matching thailand_flood_kg's own read-only reference
(`docs/LAYER0_IN_OUT_CAPACITY.md`, RELAYED: "ไม่มีสมการใหม่ — โมดูลนี้เป็น PROPOSAL-derived
simplification of `PROP-FLOOD-06`").

`readout_layer0 : Q → backflow_state → Q → option Q → layer0_cap_band → layer0_readout` is a
**total function of the same declared inputs** already used elsewhere in this file:

- **`IN_H`** := this proposal's own already-registered `F_H(U)`, **plus an explicit canal-backflow
  term** (`backflow_state ∈ {active, not_active, unknown, likely}` — mirrors
  `compute_backflow_state` in thailand_flood_kg's read-only `tools/layer0/in_out_capacity.py`; an
  `unknown` backflow state contributes `0`, **never** a fabricated m³/s figure, exactly that
  module's own docstring discipline). Present (counted) when a connected canal/basin's surface
  measurably exceeds the unit's own surface (`active`), or a band-comparison declares it `likely`
  (INSTINCT-tagged, per that same source, never converted into a fabricated number here either).
- **`OUT_H`** := `D_H(U) + R_H(U)` — this proposal's own already-registered drainage/outlet terms,
  as an `option Q` (absent when neither resolves — REFUSES only the drain-vs-in verdict below,
  never the whole Layer-0 sentence).
- **`CAPACITY`** := a declared historical band (`layer0_cap_band`: `coped_max` = the largest `IN_H`
  ever observed on a non-flood day, MEASURED-history; `flooded_min` = the smallest `IN_H` ever
  observed on a flood day, MEASURED-history) — the unknown **gap** between them
  (`layer0_gap`) is **reported, never interpolated**.

**Three verdicts, all total:**

- **IN vs CAPACITY** → `เกิน` (`L0V_Exceeds`, `IN_H ≥ flooded_min`) / `ใกล้` (`L0V_Near`,
  `IN_H ≥ 0.8·flooded_min` — **v6.1: the `0.8` constant is `OPEN-for-founder-tuning`**, matching
  every other threshold this proposal declares) / `ไม่เกิน` (`L0V_WithinCapacity`, including the
  declared "no flooded_min evidence yet" convention — a stated convention, not a measured safety
  claim).
- **OUT vs IN** → `ระบายทัน` (`L0D_InTime`, `IN_H ≤ OUT_H`) / `ไม่ทัน` (`L0D_NotInTime`) / `ไม่รู้`
  (`L0D_Unknown`, when `OUT_H` itself does not resolve — REFUSES only this one verdict, "ขาด: OUT"
  still renders the rest of the sentence, per thailand_flood_kg's own rule).

Proved: `readout_layer0_total` (a plain total function, no partial match arm — same argument as
every other top-level function in this file).

**Relation to the full-mode ladder — proved, not asserted.** `layer0_exceeds_implies_full_tier_ge_L3`
proves: **provided** the caller declares this unit's `flooded_min` **as** its own `C_H(U)`/
`min(D_H,R_H)` clearable volume, and `S_H(U)` under that identification (`s·fm == in_h`, avoiding a
bare division), **then** Layer 0's `เกิน` verdict implies the full-mode ladder's tier is at least
`L3` ("ทำตอนนี้ภายในวันนี้") — never silently lower. This is the *exact*, conditional relation Layer 0
licenses; it does **not** claim to hold for an arbitrary, undeclared `flooded_min`/`IN_H` pairing —
that identification is a per-unit declaration/calibration act (see `per_unit_calibration`), not an
automatic consequence of this file. The arithmetic core, `full_tier_ge_L3_when_s_ge_0_9`, holds
unconditionally of `refused`/L5 (both those branches already rank above `L3` on the same scale).

### Backtest v2 findings recorded verbatim (RELAYED, `thailand_flood_kg/docs/BACKTEST_PROP_FLOOD_06_v2.md`)

This proposal did not itself run this backtest; the findings are recorded honestly, unchanged, as
`honest_caveats`, and **no threshold is adopted or retuned by this v6 bump**:

- **Lead time achieved on 3 of 4 previously-lagging units**, at raw and persisted granularity:
  Nan +408h raw / +384h persisted (N.64, a real upstream gauge), Chiang Mai +360h/+336h
  (degraded self-gauge, no confirmed real upstream station), Hat Yai +432h/+408h (degraded
  self-gauge, "expected weak" per the backtest's own brief).
- **But `UPSTREAM_RISE_RATE_EXCEEDS` (the promoter that carries nearly every one of those gains) is
  also the single largest false-alarm source in the whole run: 77 of 97 total promoter firings
  across the backtest are false alarms** at the declared 15% rise-rate threshold (Hat Yai 28
  non-flooded fires vs. 4 hits; Nan 20 vs. 6; Chiang Mai 10 vs. 8, the best ratio of the three).
  No candidate grid value for Nan reaches a declared FA ≤ 20% ceiling; only Chiang Mai's dry-run
  calibration would (thr=0.40, FA=9.5%) — and per this proposal's own falsifier discipline, neither
  may actually be calibrated without a genuinely new observed event.
- **Persistence (p=2/q=3) RAISED both hit rate and false-alarm rate simultaneously at this
  backtest's day-level granularity** — the opposite of the registry's stated "trades lead time for
  FA rate" intent, because promoter firings in this dataset are short sparse spikes and the
  asymmetric `p`-fast/`q`-slow hold sweeps in more days on both sides of the ground-truth label.
  This is a real, reportable falsifier of the **p=2/q=3 defaults at day-granularity with this
  dataset's firing pattern** — it is not evidence against the hysteresis *construction* itself
  (`persisted_is_some_historical_raw`/`persisted_v6_is_some_historical_raw` still hold
  unconditionally; they make no claim about net FA effect at any particular granularity).
- Ayutthaya and Bangkok East (the two units with real v1 lead time already) are **unchanged** —
  Ayutthaya's own leading promoter fired once, on a false alarm, and is not an independent signal
  from its existing `F_H(U)` upstream term; Bangkok East has no declared upstream gauge at all.

**No S_H/T_act/promoter threshold VALUE is changed by this v6 bump.** No unit is calibrated by this
registration.

Registry entry: `registry/proposals/flood_outlet_coping.json` (`version: "v6"`).
Coq: `coq/canonical/PROP_FLOOD_06_outlet_coping_tier.v` — `coqc -q` clean (same 3 pre-existing
harmless comment-terminator warnings, now 7 with the added Thai comment text, all in the same
"quoted Thai punctuation inside a `(* ... *)` comment" category already present since v2/v3);
`Print Assumptions` "Closed under the global context" (no axioms) on every v6 theorem (spot-checked
individually via a scratch build directory, created/compiled/discarded, not committed) as well as
every pre-existing v1–v5 theorem re-checked (unchanged).

## ถึงจะแม่นยำและใช้ได้กับทุกสถานที่ — v5, leading inputs + per-unit calibration + hysteresis

**Founder instruction (verbatim, 2026-09-27):** "ถึงจะแม่นยำและใช้ได้กับทุกสถานที่" — accurate AND
usable everywhere.

**Falsifier that motivated this bump** (`thailand_flood_kg/docs/BACKTEST_PROP_FLOOD_06_v1.md`,
RELAYED — this proposal did not itself run the backtest, only records its findings): v4's
`REFUSED` fix worked as intended (92.5% → 0.9% across the two backtests), but the surviving
readouts still fire **late or not at all** against real ground truth, because every v4 `cov(U)`
component is **IN-UNIT** — it rises together with the flood, not ahead of it:

- **Hat Yai (X.44)** — a real gauge (not GloFAS) never crossed `L3` across **two full real
  events** (2553, 2565).
- **Nan (N.1)** — first warned **−48h** (2 days *after* onset).
- **Chiang Mai (P.1)** — first warned **0h** (simultaneous with onset, not ahead of it).
- **Ayutthaya** — the one unit that *did* get real lead time (+264h, GloFAS-relayed) is exactly
  the unit whose `F_H(U)` is upstream-inflow-dominated by construction — but it also has the
  worst false-alarm rate (51.6%, n=124) and `S_H` ranges that overlap heavily between flooded
  and non-flooded days (`[1.745, 2.977]` flooded vs. up to `2.843` non-flooded).

**Reading**: the *system* (`C_H(U)`/PARTIAL mode) is no longer the bottleneck; the *inputs* are —
every one of them samples the unit itself, so by the time any of them moves, the flood is already
arriving. Fixing this requires a genuinely **upstream, leading** signal, not another IN-UNIT term.

### 1. Three LEADING inputs, widening `cov(U)` to `cov5(U)` (10 components, ≥9 required)

| new component | construction | reused parent |
|---|---|---|
| `upstream_rise_rate` | PROP-FLOOD-01's `Delta_k(t) := h(t) − h(t−k)`, RISING classification, applied to the **declared UPSTREAM gauge's own series**, not `U`'s | **PROP-FLOOD-01** (new parent, added to this proposal's JSON `parents` array — it was previously cited only in MD prose) |
| `basin_rain_accum` | rain accumulated over `A_U`'s **upstream** sub-basin (DWR polygon, not `A_U` itself), 24h and 72h windows, gauges + ERA5/IMERG gap-fill tagged `RELAYED` | generalises `F_H(U)`'s existing `c_U·A_U·rain` shape to the upstream polygon |
| `forecast_rain_72h` | ensemble forecast rain (median **and** max, never collapsed) over the next 72h at the upstream sub-basin | reuses v2's "ensemble = whichever multimodel files are present, logged per-run" declaration |

Each new component is `present`/`stale`/`absent` exactly like the existing 7, checked
independently. `coverage_total` becomes **10** (`coverage_total_v5`, proved `>= 9` and `= 10` in
Coq). A unit with no declared upstream gauge at all reports `upstream_rise_rate` as structurally
absent via a new, narrowly-scoped refusal code — see below — never silently zero.

### 2. Declared travel time `tau_up(U)` and the promoters

A unit's **upstream gauge(s)** and `tau_up(U)` (hours, the lag from the upstream point to `U`)
must be declared per unit — this proposal does **not** invent a national default travel time:

| unit | candidate upstream gauge | status (per `thailand_flood_kg/docs/knowledge/DATA_SWEEP_2026-09-27.md`) |
|---|---|---|
| Nan town | **N.64** (Tha Wang Pha) | **CONFIRMED** present, real discharge history (station 3246) |
| Chiang Mai (P.1) | P.67 / P.75 | **UNCONFIRMED** — no hit anywhere in this repo's own knowledge base; founder's own brief says "if they exist" — this proposal does not assert they do |
| Hat Yai (X.44) | X.90 / X.173 | X.90 **confirmed present** but used only as a *downstream control* station in the backtest — its suitability as an *upstream* leading gauge is itself OPEN, not assumed; X.173 unconfirmed |
| Ayutthaya | C.2 → C.13 | C.2 **UNCONFIRMED**; C.13 is the unit's own already-declared outlet reach, not an upstream input |

`tau_up(U)` itself is **OPEN-until-measured** everywhere — this v5 bump only fills the
*declaration slot* and states which candidate gauge would fill it where one is confirmed to
exist. An undeclared `tau_up`/upstream gauge REFUSES only the leading term for that unit
(`UPSTREAM_GAUGE_UNDECLARED`, new refusal code, scoped — see below), never the whole readout.

Three new promoters (`readout_classes.promoter_table` in the JSON):

| id | fires when | min tier |
|---|---|---|
| `UPSTREAM_RISE_RATE_EXCEEDS` | upstream gauge RISING above a declared rate | `L3` |
| `BASIN_RAIN_ACCUM_EXCEEDS` | 24h/72h upstream-basin rain exceeds a declared threshold | `L2` |
| `FORECAST_RAIN_72H_EXCEEDS` | ensemble forecast (median or max) over 72h exceeds a declared threshold | `L1` (deliberately the lowest — the only genuinely forward, not-yet-observed term, treated as a "watch" signal, not an act-now trigger on its own) |

These compose into the existing `promoter_max` floor exactly like every v3/v4 promoter — no new
mode-selection logic, no change to the FULL/PARTIAL/LR precedence.

### 3. Projected time-to-threshold `T_act_upstream` / `lead_time_h`

**PROP-FLOOD-02 is reused a second time** (its first reuse, `T_act(U)`, stays on `U`'s own
in-unit `F_t`/`C_H` series, unchanged): `T_act_upstream(U) := ` PROP-FLOOD-02's
`T_k := (theta − h(t))·k / Delta_k(t)` construction, with `h(t) := h_up(t − tau_up(U))` (the
upstream series shifted back by the declared travel time) and `theta :=` the upstream gauge's
own declared threshold. Because the input is evaluated `tau_up` hours *before* it would arrive
at `U`, a crossing projected from it is a genuine advance warning — this is the actual mechanism
that produces lead time, not merely a relabeling of `T_act(U)`. Reported as `lead_time_h : option
Q` in the readout record — `None` under PROP-FLOOD-02's own REFUSED conditions (falling,
already-crossed, `NO_READOUT`) or `UPSTREAM_GAUGE_UNDECLARED`, `Some(hours)` otherwise; never a
fabricated constant.

### 4. Per-unit calibration — a declared falsifier procedure, not a fit that claims truth

For a unit with recorded event history: choose this unit's own band edges (`S_H`, `T_act`) and
promoter thresholds from a **finite, predeclared candidate grid** (all `ℚ` — e.g. `S_H` edges
from `{0.1, 0.2, …, 2.0}`, rain thresholds from `{40, 50, …, 150}` mm — the grid is stated *in
advance*, never chosen after seeing which value "worked"), by **maximising hits subject to a
declared max false-alarm-rate ceiling** (e.g. `FA ≤ 15%`, itself declared, not silently picked).
The chosen values plus the **MEASURED-on-backtest** hit/FA/median-lead-time they actually produced
are recorded as that unit's own `calibration` block — **append-only**, dated, versioned (mirrors
this proposal's own `.v<k>` lineage discipline, applied per unit).

**Falsifier discipline (the rule that keeps this honest):** a unit may be **re-calibrated only
when a genuinely NEW observed event** (ground truth not already in the fitting set) becomes
available. Re-running the same grid against the same already-fitted data twice, with no new
event, is **prohibited** — this must be refused/flagged, not silently permitted.

Readout field: `calibrated: yes(n_events, hit, FA, median_lead_h) | no ("ยังไม่สอบเทียบที่นี่")`.
**No unit in this v5 registration has actually been calibrated** — every worked unit (Hat Yai,
Nan, Chiang Mai, Ayutthaya, Bangkok East) reports `calibrated: no`, using the unchanged v1–v4
national-default thresholds. See `registry/proposals/flood_outlet_coping.json`'s new
`per_unit_calibration` block for what is/isn't confirmed per unit and what blocks a real run.

### 5. Hysteresis / persistence — false-alarm control, declared, not free

A promoter/band **raise** takes effect only after it holds for `p` **consecutive** hourly
readouts of the un-persisted (raw) rule (declared default `p = 2`); a **step-down** takes effect
only after `q` consecutive readouts at or below the lower level (declared default `q = 3`). Both
`OPEN-for-founder-tuning`, exactly like the `S_H`/`T_act` band edges.

**This trades lead time for false-alarm rate — explicitly, not silently:** holding `p ≥ 2` delays
every raise by at least `(p−1)` hours relative to the raw rule, which is a real cost against
Nan/Chiang Mai's already-thin-or-negative lead time. Any backtest of this rule **must** report
the lead-time cost and the false-alarm-rate benefit **together**, never one without the other.

Formalised in Coq as `persisted` (a hysteresis state machine over a raw per-hour tier sequence)
with the falsifier-relevant guarantee proved as `persisted_is_some_historical_raw`:
**persistence with `p, q ≥ 1` never reports a tier absent from the raw history** — for every hour
`n`, the persisted tier at `n` equals the *raw* (un-persisted) tier at some hour `m ≤ n`. It can
only **delay** a raise or lowering the raw rule already produced; it can never **fabricate** a
level the raw rule never produced at all.

### 6. Coq — what's new, what's kept

- `coverage_vector_v5` **embeds** v4's `coverage_vector` (`cv5_base`) plus the 3 new bool
  components — v4's own `coverage_vector`/`coverage_present`/`coverage_total`/`cov_all_absent`
  and every theorem about them are **unchanged**, still typecheck, still hold.
- `readout_v5` is a fresh record with the same 7 fields as v4's `readout` plus `calibrated : bool`
  and `lead_time_h : option Q` — v4's `readout` type is likewise **untouched**.
- `full_tier_v5` re-derives, for the widened vector and the concatenated (base + leading)
  promoter list: totality (`full_tier_v5_total`), `coverage_total_v5 = 10` (and `>= 9`,
  `coverage_total_v5_ge_9`), `coverage_present_v5 <= 10`, `LR iff coverage_present_v5 = 0`
  (`full_tier_v5_LR_iff_coverage_present_0`), and the two v4-style monotonicity theorems
  (`full_tier_v5_promoter_monotone`, `full_tier_v5_full_ge_partial`) — same proof pattern as v4,
  extended to the wider list via a generic `promoters_mono_app`/`applies_pairs_mono` helper so the
  concatenated base+leading promoter list is handled uniformly.
- `persisted` / `persisted_is_some_historical_raw` — new, the hysteresis discipline above.
- **All v1–v4 theorems are kept, unmodified, and still hold** — nothing about `full_tier`,
  `full_tier_v3`, or `full_tier_v4` is touched by this section; `coqc -q` clean, `Print
  Assumptions` closed under the global context (no axioms) on every theorem in the file.

**No `S_H`/`T_act`/promoter threshold VALUE from v1–v4 is changed by this v5 bump** — this is a
structural addition (leading inputs, a calibration *procedure*, a hysteresis *rule*), not a
retune. No unit is actually calibrated by this registration.

### v6 TODO from v5 — IMPLEMENTED (see "round-3 review + LAYER 0 — v6" above)

**Founder instruction (verbatim):** "อย่าลืมว่าไม่มีทางมีข้อมูลพอ แต่ใช้การอนุมานจากข้อมูลที่แข็งแรง
เป็นหลัก" — there is never enough data; use inference from strong-enough data as the main tool.

This asked for a **third coverage state**, `inferred` (alongside `present`/`absent`), counted at a
lower rank than `present`, carrying a `confidence : strength` field (the weakest anchor's own
strength), narrowing `LR` further, and a third monotonicity theorem (`inferred → present` never
lowers the tier). **All of this is now implemented** in the v6 section above, by importing
PROP-FLOOD-07's own `coverage3`/`strength`/`coverage3_rank` primitive as a PARENT
(`From MRC Require Import PROP_FLOOD_07_flow_state`) rather than re-deriving it — exactly the
reuse path PROP-FLOOD-07's own registration anticipated. The anchor-consistency INFERENCE RULES
themselves (`RULE-STALL-01`/`RULE-DIR-01`, which actually PRODUCE an `inferred_value`/`coverage3`
from measured anchors for a flow-state edge) remain PROP-FLOOD-07's own object, cited here, not
re-derived — this proposal's cov6(U) consumes the resulting `coverage3` state per component, it
does not re-implement the rules that decide when a component becomes `Cov_Inferred` in the first
place (that per-component wiring, e.g. which anchors license inferring `upstream_rise_rate` as
`Cov_Inferred` for a specific unit, is an application-level/`kb.py`-level decision, out of this
Coq object's own scope, exactly like every other IO-shaped classification in this file).

Registry entry: `registry/proposals/flood_outlet_coping.json`
Coq stub (tier functions, total + decidable, Closed under the global context, no axioms):
`coq/canonical/PROP_FLOOD_06_outlet_coping_tier.v`
Tier: `Dr`. Status: `unverified`. Domain: `M`.
Genesis gate: readout_genesis Part VI-A, B.2a, "A generic conservation ledger" (same gate as
PROP-FLOOD-03).

## depends_on (must be readable in this branch/PR, per Toledo-first reuse gate)

- **PR #59** (MERGED to `origin/main`) — PROP-FLOOD-01/02, `registry/proposals/flood_readout_trend.json`.
- **PR #60** (OPEN as of 2026-09-27, branch `proposals/flood-water-balance`, commit `34089703`) —
  PROP-FLOOD-03, `registry/proposals/flood_water_balance.json` — **merged into this proposal's own
  branch** (`proposals/flood-outlet-coping`) so its statement is physically present and
  independently readable here, per independent-review MUST-FIX #1. Still a separate open PR
  against `main` and must land there (or be otherwise promoted) for the citation to be verifiable
  on `main` itself.
- **PR #62** (OPEN as of 2026-09-27, branch `proposals/flood-burden-ledger`, commit `1578b354`) —
  PROP-FLOOD-05a/b, `registry/proposals/flood_burden_ledger.json` — merged into this branch for the
  same reason as PR #60.

## ข้อมูลเพิ่มไม่เคยลดระดับ — v4, promoters as a floor under every mode + one inseparable readout

**Round-2 independent review (`REVIEW_PROP_FLOOD_06_r2.md`) found two MUST-FIX gaps in v3, both now
closed:**

### MUST-FIX #1 — PARTIAL could silently outrank FULL, undocumented

v3's mode selection was **exclusive**: FULL mode consulted only the `S_H`/`T_act` bands
(`full_tier`), PARTIAL mode consulted only the promoter table — never both. Two promoters encode
raw physical facts independent of the `S_H` arithmetic (`RAIN_24H_EXCEEDS_DESIGN`,
`PUMPS_ZERO_RUNNING_ABOVE_THRESHOLD`). A unit with a **fully resolved** ledger but rain above the
design threshold could report whatever `combined_tier` gave — possibly `L0`/`L1` — while an
otherwise-identical unit merely **missing one input** (hence PARTIAL) on the same rain reading got
`L3` from the promoter. More data could yield a *lower* tier than less data on the same signal.

**Fix — promoters are now a floor under every mode.** The task's own stated order:

1. `band_tier := full_tier`'s `S_H`/`T_act` combined tier **if the ledger resolves** (FULL),
   **else `L0`** (PARTIAL/no-ledger contributes no band term — not a penalty).
2. `promoter_max := ` the maximum tier level over every promoter whose required `cov(U)` component
   is present — **in every mode, not only PARTIAL**.
3. `base_tier := max(band_tier, promoter_max)` — FULL's ledger tier and the promoter floor are
   always combined, never mutually exclusive.
4. The vulnerable-unit `+1` rule applies to `base_tier` identically regardless of mode.
5. `LR` overrides everything, **checked last**, iff `cov(U)` is entirely absent/stale.

This is the founder's rule made precise as an inequality, not just a policy sentence:
**"ข้อมูลเพิ่มไม่เคยลดระดับ"** — more real data never lowers the reported level. Proved in Coq:

- `full_tier_v4_promoter_monotone` — for the same promoter table and the same ledger inputs,
  widening the coverage vector (any `cov` component that was present stays present) never lowers
  the tier, given the unit was not already `LR` (`LR` is a refusal state, not a severity
  comparison, and is excluded from this claim by hypothesis — it still dominates unconditionally,
  just not part of the monotonicity ordering itself).
- `full_tier_v4_full_ge_partial` — for the same promoters and the same non-`LR` coverage, the
  FULL-mode tier is always `>=` the PARTIAL-mode tier the identical promoter inputs would give,
  since FULL only *adds* the band term into the same `max`, it never substitutes for the promoter
  floor.

Concretely (`full_never_drops_below_partial_hatyai` in the `.v` file): the same Hat Yai coverage
and promoter inputs, once with the ledger unresolved (PARTIAL, band `L0`) and once resolved (FULL,
band `L0` from a low `S_H`), now give the **same** `L3` tier — FULL never drops below what PARTIAL
already established from the same real inputs.

### MUST-FIX #2 — coverage_score/mode were not structurally mandatory

v3's Coq return type was a bare `tier_level6`; `mode`/`coverage_score`/`based_on`/`missing` existed
only as JSON/MD prose a consumer could silently drop, reproducing exactly the false "ปกติ" (normal)
reassurance the founder's crisis-usability instruction was meant to prevent.

**Fix — one inseparable `readout` record.** The Coq return type of the top-level function
(`full_tier_v4`) is now:

```coq
Record readout := {
  tier                     : tier_level6;
  mode                     : mode3;              (* FULL | PARTIAL | LR *)
  readout_coverage_present : nat;                 (* 0..7 *)
  readout_coverage_total   : nat;                 (* always 7 *)
  based_on                 : list input_kind;
  missing                  : list input_kind;
  promoters_fired          : list promoter_id
}.
```

Proved: `readout_eq_dec` (decidable equality), `full_tier_v4_coverage_total_is_7` (coverage_total
is 7 by construction — a 7-field `coverage_vector` record, not a runtime list length),
`full_tier_v4_coverage_present_le_7` (coverage_present never exceeds 7, since it is a sum of 7
booleans), and `full_tier_v4_LR_iff_coverage_present_0` (the record's own `mode` field is `LR` iff
`coverage_present = 0`).

**Consumer contract (mandatory, not optional):** any UI or downstream consumer of this object's
readout **MUST render `tier` together with `mode` and `coverage`** — never `tier` alone. FloodConnect's
own UI copy already states this: **"ระดับ Lk · ข้อมูล n/7 · อิงจาก …"** (Level Lk · data n/7 · based
on …). A consumer that surfaces only `tier: L0` at `coverage_present: 1` reproduces the exact false
`ปกติ` reassurance this whole PARTIAL-mode machinery exists to prevent — that is a protocol
violation of this schema, not a permitted simplification.

## ใช้ได้แม้ข้อมูลไม่ครบ — v3, the graceful-partial-readout rule

**Founder instruction (verbatim, 2026-09-27):** "ทำทั้งหมดให้ระดับโลก แต่พอใช้ได้แม้ข้อมูลไม่ครบ
อย่าลืมว่าระบบนี้ออกมาสำหรับวิกฤต บางอย่างมันอาจไม่สมบูรณ์ ขอแค่ข้อมูลจริงแม้เล็กที่สุดในบางสถานการณ์
ก็ยังดี" — build it world-class, but make it usable even when data is incomplete; this system exists
for a crisis, something being imperfect is fine, even the smallest real datum in some situations is
still worth something.

This came directly out of a read-only falsifier backtest run against this proposal in a sibling repo
(`thailand_flood_kg/docs/BACKTEST_PROP_FLOOD_06_v0.md`, RELAYED — this proposal did not conduct that
backtest itself, only records its findings): across 1676 simulated readout rows, **92.5% were
REFUSED**, and the founder's own flagged priority case (Hat Yai) was refused on almost every day
because the free global GloFAS grid cannot resolve its local canal. The backtest also found a real
self-contradiction in this proposal's v1/v2 text (§"the no-pump contradiction" below). v3 fixes both:

1. **The no-pump contradiction is fixed.** v1/v2's literal `min(D_H(U), R_H(U))` forced `D_H=0`
   (`NO_PUMPS_IN_UNIT`) to always win the `min`, so any river-only town with no pumps (Ayutthaya,
   and by the same shape Nan, Chiang Mai) was refused or zeroed out even when its outlet headroom
   `R_H` resolved perfectly well — directly contradicting this proposal's own worked-instantiation
   table, which said Ayutthaya should reduce to `S_H = F_H/R_H`. **`C_H(U)`** replaces the literal
   `min` with a total case split (see "Clearable volume `C_H(U)`" below) that resolves this exactly
   as the proposal's own example already implied.
2. **A graceful PARTIAL mode is added.** Previously, ANY missing/unknown input (an outlet's
   capacity, a pump's state, an upstream gauge) refused the WHOLE unit's readout (`LR`), even when
   other real inputs — a rain gauge, a canal-level reading — were present and informative on their
   own. Per the founder's rule, refusal (`LR`) is now reserved for when **no real input exists at
   all**. Whenever at least one input is present, the ladder now returns a **`PARTIAL`** tier built
   from whichever local/Thai promoters (see the promoter table below) are computable from what IS
   available — never a silent guess, always tagged with exactly which inputs were used
   (`based_on`) and which were not (`missing`), plus a plain coverage count.

### Coverage vector `cov(U)`

A 7-component vector, each component independently `present` / `stale` / `absent`:
`(rain_obs, rain_fcst, canal_level_vs_lines, river_flow_vs_cap, dam_release, pumps_state,
upstream_inflow)`. `present` = a reading exists within its declared staleness window (3h live /
24h forecast, unchanged from v2's unit-resolution defaults); `stale` = past that window; `absent` =
no reading. This is checked independently of whether the full `S_H/T_act` ledger happens to resolve.

### Clearable volume `C_H(U)` (replaces the literal `min(D_H,R_H)`)

- `NO_PUMPS_IN_UNIT` (no pumps declared) **and** `R_H` resolves → `C_H(U) := R_H(U)`,
  `terms_present := {R}` — the pump term is structurally *absent*, not zero-and-binding.
- Pumps declared, but every outlet is `OUTLET_CAPACITY_UNKNOWN` → `C_H(U) := D_H(U)`,
  `terms_present := {D}` — a **partial flag** on the readout, not a whole-unit refusal: `D_H`
  alone is still a real, usable number.
- Both resolve → `C_H(U) := min(D_H(U), R_H(U))`, `terms_present := {R, D}` — unchanged from v1/v2.
- Neither resolves (no pumps AND no known outlet capacity) → `REFUSED (OUTLET_CAPACITY_UNKNOWN)` —
  genuinely nothing to compute from, unlike the first case above.

Every `S_H(U)` readout now reports `terms_present` alongside the ratio so a reader can see which
physical constraint (river outlet, pump station, or both) the number actually reflects.

### Mode: `FULL` / `PARTIAL` / `LR`

Precedence, replacing v2's flat LR/L5/band order:

1. **`LR`** iff `cov(U)` is entirely absent or entirely stale-beyond-window across all 7
   components — genuinely zero usable real input of any kind. (Narrower than v2's refusal-code
   list: one missing input no longer refuses the whole unit by itself if another `cov(U)` component
   is present — see `PARTIAL` below.)
2. **`FULL`** iff the whole ledger resolves (`C_H(U)` resolves, `F_H(U)` resolves) — proceeds
   exactly as v2's `full_tier` over `(S_H, T_act)`, now reading `C_H(U)` in place of the old literal
   `min`.
3. **`PARTIAL`** otherwise, whenever at least one `cov(U)` component is present: `tier(U) := ` the
   **maximum** tier level over every promoter in the table below whose required `cov(U)` component
   is present (an absent/stale-input promoter is *excluded* from the max, not treated as
   non-firing-with-a-value). If no promoter's input is present-and-triggering, `tier(U) := L0` — a
   genuine "nothing fired on what we do have" readout, not `LR`.

Every `PARTIAL` readout carries: `mode: "PARTIAL"`, `based_on: [...]`, `missing: [...]`, and
`coverage_score := |present components| / 7` (a plain **MEASURED** count, never a probability).

### Promoter table (Thai/local triggers, adopted `RELAYED-derived-convention` from
`thailand_flood_kg/docs/knowledge/TIER_THRESHOLDS_RATIONALE.md`)

| id | fires when | min tier | source |
|---|---|---|---|
| `RAIN_24H_EXCEEDS_DESIGN` | `rain_24h_mm > 80` | `L3` | BMA as-built drainage design capacity (`docs/CAPACITY.md` §1, VERIFIED there) |
| `CANAL_AT_WARNING_LINE` | canal level ≥ warning line, < critical line | `L2` | `sources/registry.yaml` canal feed (MEASURED there) |
| `CANAL_AT_CRITICAL_LINE` | canal level ≥ critical line | `L4` | same feed |
| `CANAL_AT_BANK_LEVEL` | canal level ≥ bank level | `L5` | same feed — no remaining headroom by definition |
| `DAM_RELEASE_ABOVE_SPILL_THRESHOLD` | dam release ≥ declared spill threshold | `L3` (downstream units only) | this proposal's own construction, generalising PROP-FLOOD-03's upstream-edge discipline |
| `PUMPS_ZERO_RUNNING_ABOVE_THRESHOLD` | 0 pumps running AND level ≥ critical line | `L5` | rationale doc §3.6 |
| `VULNERABLE_UNIT_PROMOTION` | unit declares high vulnerable-population share AND (`T_act ≤ 48h` in FULL, or PARTIAL tier already ≥ `L2`) | promote the already-computed tier by ≥ 1 level (never a standalone trigger) | rationale doc §3.2 / P7, **INSTINCT** — qualitative evidence only, no measured "how much longer" number |

**All threshold VALUES here (80mm, the S_H/T_act bands, etc.) remain exactly what v1/v2 already
declared, OPEN-for-founder-tuning — this v3 bump adopts the promoter *structure*, it does not
silently retune any number.**

### Worked example: Hat Yai, PARTIAL, with only a rain gauge and a canal-level reading

Only `rain_obs` (rain_24h = 92mm, present) and `canal_level_vs_lines` (at warning line, present)
are available — no outlet capacity, no pump state, no upstream inflow (exactly the GloFAS gap the
backtest found for this unit). The full ledger does not resolve, so mode falls to `PARTIAL`, not
`LR`:

- `RAIN_24H_EXCEEDS_DESIGN` fires (92 > 80) → `L3`.
- `CANAL_AT_WARNING_LINE` fires → `L2`.
- Every other promoter's input is absent → excluded from the max.
- **Result: `mode: PARTIAL`, `tier: L3`, `based_on: [rain_obs, canal_level_vs_lines]`,
  `missing: [rain_fcst, river_flow_vs_cap, dam_release, pumps_state, upstream_inflow]`,
  `coverage_score: 2/7`.**

This is the founder's rule made concrete: two real inputs, honestly labeled, still produce a
usable `L3` ("ทำตอนนี้ภายในวันนี้") instead of the `LR` that the v2 backtest returned on
essentially every one of Hat Yai's ~83 unit-days.

### Backtest findings recorded verbatim (RELAYED, `thailand_flood_kg/docs/BACKTEST_PROP_FLOOD_06_v0.md`)

- 92.5% (1550/1676) of simulated rows REFUSED (640 `MISSING_INPUT`, 502
  `ZERO_CAPACITY_NONZERO_INFLOW` — the same no-pump contradiction `C_H(U)` fixes, 408
  `OUTLET_CAPACITY_UNKNOWN`).
- Of the 126 non-REFUSED rows, all were `BANGKOK_EAST`: confusion matrix 0 act&flooded, 0 act&not,
  **56 time&flooded (miss), 70 time&not** — a **100.0% miss rate, n=126**, at the current v1/v2
  S_H/T_act bands.
- **OPEN calibration note, not a silent tune:** the backtest also reports `S_H` on flooded days as
  `[min=0.00 max=0.00 n=56]` and on non-flooded days as `[min=0.00 max=0.00 n=70]` — `S_H` was
  degenerate (exactly 0) for *both* classes in this scenario, so the 100% miss rate is **not**
  evidence that any specific band shift (e.g. lowering the `L3` threshold below `0.9`) would have
  caught those days — no boundary in `(0, +inf)` separates two classes that are both stuck at
  `0.00`. The miss is a `C_H(U)`/input-resolution problem (the same contradiction fixed above for
  Bangkok-East-shaped units with partial pump declarations), not a threshold-placement problem.
  This is left as an item for re-running the backtest against v3's `C_H(U)` definition — **no S_H
  or T_act band value is changed by this v3 bump.**

## v4 amendments (per independent review round 2, `REVIEW_PROP_FLOOD_06_r2.md`)

1. **Promoters are now a floor under every mode** — `readout_classes.mode`'s FULL branch is no
   longer exclusive of the promoter table; `full_tier_v4` computes
   `max(band_tier, promoter_max)` in both FULL and PARTIAL, then the vulnerable-unit `+1` rule,
   then `LR` overrides last. See "ข้อมูลเพิ่มไม่เคยลดระดับ — v4" above.
2. **Monotonicity proved in Coq** — `full_tier_v4_promoter_monotone` (adding a present promoter
   input never lowers the tier, non-`LR` case) and `full_tier_v4_full_ge_partial` (FULL `>=` the
   PARTIAL tier the same promoter inputs would give).
3. **The Coq return type is now the `readout` record** (`tier`, `mode`, `coverage_present`,
   `coverage_total`, `based_on`, `missing`, `promoters_fired`), replacing v3's bare `tier_level6` —
   see `readout_classes.readout_schema` in the JSON and the MUST-FIX #2 section above.
4. **No S_H/T_act band value, promoter threshold, or coverage-vector semantics is changed by this
   pass** — this is a mode-selection and return-type fix only, exactly as v3 changed only
   `C_H(U)`/mode without retuning any threshold.

## v2 amendments (per independent review, `REVIEW_PROP_FLOOD_06.md`)

1. **Parent chain** — PROP-FLOOD-03 and PROP-FLOOD-05a/b are now physically present in this
   branch's registry (merged, see depends_on above); PROP-FLOOD-01/02 arrive via the rebase onto
   `origin/main`.
2. **Coq band-edge fix** — `s_band`'s four thresholds (0.3/0.6/0.9/1.2) now close the **upper**
   band, matching the JSON/MD exactly (v1's Coq had them inverted).
3. **Tier-ladder totality** — the L5-vs-"`S_H:=0`, OK" ambiguity is resolved: L5's zero-capacity
   disjunct is now gated on `F_H(U) > 0`; the former `ZERO_CAPACITY_NONZERO_INFLOW` refusal code is
   **removed** (that case is now the L5 tier, not a refusal — "the system is already exceeded" is a
   valid resident-facing readout, not a non-evaluable input state). Formalised as a single total
   function `full_tier` over `(refused, D_H, R_H, F_H, S_H, T_act)`.
4. **`g_U(t)` no longer silently defaults to 1** — undeclared is now `REFUSED (DERATING_UNDECLARED)`;
   a unit wanting `g_U(t)=1` (e.g. Bangkok) declares it explicitly, tagged OPEN.
5. **Unit-resolution defaults declared** — CRS `EPSG:4326`; nearest-`k=3` gauges within 10 km else
   `NO_GAUGE_IN_UNIT`; staleness windows 3 h (live) / 24 h (forecast); "the ensemble" = whichever
   multimodel forecast files are actually present at evaluation time, logged per-run; tie-break =
   smallest `asset_id`.

> No markdown one-pager precedent exists for PROP-FLOOD-01..05 in this repository (they were
> registered as JSON only, no `docs/` file); this file is placed under `docs/proposals/` as the
> most natural location and should be treated as this proposal's own convention, not a
> continuation of an existing one.

## Founder request (verbatim, translated context preserved)

> "แสดงว่าเราทำตัวชี้วัดได้เลยว่า อย่างแรก เจ้าพระยาเคลียร์ได้เท่าไหร่ และระบบคลองการสูบเคลียร์น้ำได้เท่าไหร่
> แล้วเมื่อมีเมฆฝนก็ประเมินได้เลยว่าจะรับมือได้หรือวิกฤตไหม" → "พัฒนาเป็นสมการให้หน่อยนะ"
> — then, three follow-on rulings the same session: (1) area-generic, not Bangkok-only; (2) a
> ≥5-level tier ladder carrying time-to-act, not severity alone; (3) resolvable from any
> (lat, lon) in Thailand.

## What this reuses (PARENTS, by code — read, not keyword-matched)

- **`delta_R`** (readout_genesis root primitive, Th_coqc) — the per-outlet headroom margin
  `Q_cap,o − Q_o,now` is an instance of the retained-difference primitive, not a continuum
  derivative.
- **`PROP-FLOOD-03`** (finite water-balance ledger) — supplies the rainfall-runoff term shape
  (`c·A·rain`), the `UNDECLARED_AREA`/`UNDECLARED_EDGE`/`MISSING_INPUT`/`STALE_INPUT` refusal
  codes verbatim, and the Genesis-gate mapping this proposal reuses unmodified.
- **`PROP-FLOOD-02`** (time-to-threshold by linear extension) — `T_act(U)` is a direct
  instantiation of PROP-FLOOD-02's construction with a *time-varying* threshold
  `theta(t) := min(D_t, R_t)` in place of a fixed `theta`; its REFUSED-as-non-value discipline
  is also the precedent for this proposal's refusal codes (v1 additionally cited it for the now-
  removed `ZERO_CAPACITY_NONZERO_INFLOW` code — see "v2 amendments").
- **`PROP-FLOOD-05a`** (control-structure burden readout) — precedent for a second, declared
  boolean classification layered on the primary quantity (`binding(U)`/`binding(o)` here,
  `HIGHER_SIDE`/`LOWER_SIDE` there).
- **`EQ-001/C.01.v1`** (generic ledger, via PROP-FLOOD-03) — the open-node conservation-ledger
  identity this whole object is a horizon-aggregated, multi-outlet/multi-pump instance of.

## The four (now more) readout definitions, in plain text

1. **River/outlet headroom** `R_H(U)`: sum, over every declared outlet of unit `U`, of
   `max(0, Q_cap,o − Q_o,now) × H×3600` (m³) — how much more the outlet(s) could still convey
   over the next `H` hours at today's margin. `Q_cap,o` is a **DECLARED** constant (e.g.
   3,000–3,100 m³/s for the Bangkok Chao Phraya reach, tagged **RELAYED**); `Q_o,now` is the
   latest gauge reading.
2. **Drainage clearable volume** `D_H(U)`: sum over the horizon's hours of
   `(running pump capacity in U) × 3600 × g_U(t)`, `g_U(t) ∈ (0,1]` a gravity/tide derating
   factor (`=1` unless a tidal/derating condition is declared; **OPEN** default, flagged).
   `D_H(U) := 0` when `U` has no pumps declared — not a refusal, the `NO_PUMPS_IN_UNIT` case.
3. **Forecast inflow volume** `F_H(U)`: `c_U·A_U·Σ rain_t` (rainfall-runoff, `c_U` declared or
   reported as the bound pair `[0.5, 1]`) **plus** `Σ Q_in,up(t)×3600` (declared upstream-edge
   inflow — the dominant term for a river-only mainstem town, ~0 for Bangkok/a village with no
   upstream edge).
4. **The indicator** `S_H(U) := F_H(U) / min(D_H(U), R_H(U))` — severity, a finite ℚ ratio.
5. **`T_act(U)`** (new, per founder's second ruling): the smallest hour `t ≤ H` at which
   cumulative forecast inflow reaches the unit's clearable volume so far — "how long until this
   unit runs out of capacity". Reported as the string `">H"` when no crossing occurs within the
   horizon (a determinate, non-refused outcome, not an extrapolation).
6. **Binding term**: `binding(U) ∈ {OUTLET, PUMP}` = whichever of `R_H`, `D_H` is smaller;
   per-outlet `binding(o)` flags which specific outlet is the constraint when `U` has more than
   one.
7. **Tier ladder** (replaces a bare 3-band severity convention, per founder's second ruling —
   combines severity `S_H` **and** urgency `T_act`, the higher of the two governs):

   | Level | S_H band (closed-lower on the upper band) | T_act band | Meaning (FloodConnect wording, not part of this proposal) |
   |---|---|---|---|
   | L0 | `< 0.3` | `> H` | ปกติ |
   | L1 | `0.3 ≤ S_H < 0.6` | `> 48h` | เฝ้าดู |
   | L2 | `0.6 ≤ S_H < 0.9` | `24h < T_act ≤ 48h` | เตรียมตัวได้ ยังมีเวลา |
   | L3 | `0.9 ≤ S_H < 1.2` | `6h < T_act ≤ 24h` | ทำตอนนี้ภายในวันนี้ |
   | L4 | `≥ 1.2` | `≤ 6h` | เร่งด่วนเดี๋ยวนี้ |
   | L5 | *(pre-check, not a band)* | `min(D_H,R_H)=0` **and** `F_H(U) > 0`, or gauged level already above declared threshold | เกินระบบแล้ว |
   | LR | — | — | REFUSED — dominates every numeric level |

   **All five numeric thresholds (0.3/0.6/0.9/1.2 on S_H; 6h/24h/48h on T_act) are declared
   here as a proposed convention and are explicitly marked OPEN-for-founder-tuning** — they are
   not derived from data.

   **Precedence (v2, total and unambiguous — resolves independent-review MUST-FIX #4):**
   (i) `LR` if any refusal code fired; (ii) else `L5` if `min(D_H,R_H)=0 AND F_H(U)>0`, or the
   gauged level is already above threshold; (iii) else the ordinary band rule above, which also
   correctly covers `min(D_H,R_H)=0 AND F_H(U)=0` (the caller sets `S_H(U):=0`, landing in `L0`).
   `L5`'s first disjunct is deliberately identical to, and replaces, the former
   `ZERO_CAPACITY_NONZERO_INFLOW` refusal code — that condition is now a **tier**, not a refusal.
   Formalised in Coq as the single total function `full_tier (refused, D_H, R_H, F_H, S_H, T_act)`.

8. **Unit resolution from `(lat, lon)`** (per founder's third ruling): `U` need not be
   hand-declared. Given any point in Thailand:
   - `A_U` ← the basin/sub-basin polygon containing the point (**VERIFIED**, if a polygon layer
     exists) — if only the 22 basin *nodes* exist with no polygons, **REFUSED
     (`UNIT_POLYGON_MISSING`)**, unless a declared fallback radius-`r` circle is explicitly
     opted into (**INSTINCT**, `r` stated, never silently substituted).
   - `O_U` ← downstream reach(es) reached by walking declared WATER edges from the nearest
     reach/canal node (HydroRIVERS, **RELAYED**); `Q_cap,o` from the capacity ledger if present,
     else that outlet's headroom term is **REFUSED (`OUTLET_CAPACITY_UNKNOWN`)**.
   - `P_U` ← `pump_station` assets inside `A_U`, running state from the latest readout; empty is
     the valid **`NO_PUMPS_IN_UNIT`** case, not an error.
   - rain ← official gauges inside `A_U` (or nearest-`k`, flagged) + ensemble forecast at the
     point; none available → **REFUSED (`NO_GAUGE_IN_UNIT`)**.
   - upstream inflow ← the gauge on the reach entering `A_U`, if declared; else the term is `0`
     under the same `UNDECLARED_EDGE` discipline PROP-FLOOD-03 already states.
   - Every resolved input is reported with its evidence tag — **VERIFIED** / **RELAYED** /
     **INSTINCT**. A required resolved input with none of these tags (i.e. actually missing)
     REFUSES the whole tier readout; it is never silently degraded to a lower-confidence number.
   - This is the specification `kb.py coping --at lat,lon` will later implement in FloodConnect.

## Refusal codes (fixed precedence order) — v2

1. `UNIT_NOT_DECLARED` / `UNIT_POLYGON_MISSING` — the tuple, or its (lat,lon) resolution,
   cannot even be formed.
2. `OUTLET_CAPACITY_UNKNOWN` / `NO_GAUGE_IN_UNIT` — the tuple resolved, but a specific resolved
   input has no value.
3. `MISSING_INPUT` / `STALE_INPUT` / `DERATING_UNDECLARED` — a declared input exists but its
   current reading is absent/stale, or `g_U(t)` has not been declared at all (v2: no longer a
   silent default of 1 — see below).
4. `UNDECLARED_AREA` / `UNDECLARED_EDGE` — reused verbatim from PROP-FLOOD-03.

`NO_PUMPS_IN_UNIT` is explicitly **not** a refusal code — it is the valid `D_H(U):=0` case.
`ZERO_CAPACITY_NONZERO_INFLOW` is **removed** in v2 — the degenerate ratio case
(`min(D_H,R_H)=0` while `F_H>0`) is now the `L5` tier (see the tier-ladder table above), not a
refusal, per independent-review MUST-FIX #4's recommended resolution.

## `g_U(t)` — no silent default (v2)

`g_U(t)` (gravity/tide derating factor) undeclared is **`REFUSED (DERATING_UNDECLARED)`**, not a
silent default of 1. A unit that wants `g_U(t)=1` (e.g. Bangkok's tidal outlet) must declare it
explicitly, tagged **OPEN** (no measured tide-interaction curve backs the declared 1). This closes
v1's stated exception to this proposal's own "never silently degrade" discipline (independent
review §3/SHOULD-FIX).

## Unit-resolution declared defaults (v2, independent-review SHOULD-FIX #9)

- **CRS**: `EPSG:4326` (WGS84 geographic) by default; a unit may declare another CRS explicitly.
- **Nearest-gauge/reach tie-break**: geodesic (great-circle) distance, not network distance along
  the water graph (network distance is a stronger, not-yet-declared future refinement, OPEN).
- **`k` in "nearest-k gauges"**: `k = 3` within a 10 km radius by default, else `NO_GAUGE_IN_UNIT`.
- **Final tie-break** (exact ties after distance): smallest declared `asset_id`.
- **Staleness windows**: 3 hours for live/gauged inputs (`Q_o,now`, pump running-state, gauge
  levels); 24 hours for forecast inputs (`rain_t`, `Q_in,up(t)` forecasts).
- **"The ensemble"**: whichever multimodel rainfall-forecast files are actually present at
  evaluation time — no fixed model list; the models actually used **must be logged** in that
  evaluation's own readout.

## Three worked instantiations (generality check, per founder's second ruling)

| Unit | Outlet(s) | Pumps | Tide term | Dominant `F_H` term | Typical binding |
|---|---|---|---|---|---|
| Bangkok east zone | Chao Phraya reach → pumps → Gulf | BMA pumping stations | applies | rainfall-runoff | PUMP (short intense rain) or OUTLET (joint river-flood event) |
| หมู่บ้านสัมมากร | คลองบ้านม้า / retention basin | ST./SPS pumps | — (non-tidal) | rainfall-runoff | PUMP (ordinary village case) |
| อยุธยา (provincial mainstem town) | Chao Phraya mainstem | none declared → `D_H:=0` | — | upstream inflow `Q_in,up` | OUTLET always (`min(D_H,R_H)=R_H`) |

## Falsifier

A systematic mismatch between declared tier and observed outcome across repeated real
instantiations — e.g. multiple units reading L0/L1 that in fact flooded within the horizon, or
multiple units reading L4 that did not flood — falsifies the *tier convention's calibration*
(not the arithmetic, which is definitionally true given its inputs). Separately, any observed
conveyed flow at a declared outlet exceeding its declared `Q_cap,o` falsifies that constant and
requires re-tagging it, never silently raising it.

## What is OPEN / not sourced yet

- All tier-ladder thresholds (`0.3/0.6/0.9/1.2`, `6h/24h/48h`) — explicitly OPEN-for-founder-tuning.
- `c_U` (runoff coefficient) when undeclared — reported only as the bound pair `[0.5, 1]`.
- `g_U(t)` when a unit HAS declared it as `1` (e.g. Bangkok) — the value itself is OPEN (no
  measured tide-interaction curve backs it); an UNdeclared `g_U(t)` is REFUSED, v2, not OPEN.
- The radius-`r` INSTINCT fallback for `A_U` — no default `r`; must be stated by whoever opts in.
- `Q_cap,o` for any reach beyond the already-tagged Bangkok Chao Phraya figure — needs its own
  sourced declaration per unit, never a copied number.
- The "gauged level already above declared flood threshold" disjunct of `L5` — IO-shaped, not
  formalised in Coq (see the .v file's header).
- The network-distance (vs. geodesic) tie-break refinement for nearest-gauge/reach resolution.
