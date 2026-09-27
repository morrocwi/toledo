# PROP-FLOOD-06 — NEW DERIVATION / PROPOSAL (not a Toledo theorem)

**Area-generic outlet-headroom / drainage-coping tier-ladder indicator, with (lat,lon) unit
resolution and refusal.**

Registry entry: `registry/proposals/flood_outlet_coping.json`
Coq stub (tier function only, total + decidable, Closed under the global context, no axioms):
`coq/canonical/PROP_FLOOD_06_outlet_coping_tier.v`
Tier: `Dr`. Status: `unverified`. Domain: `M`.
Genesis gate: readout_genesis Part VI-A, B.2a, "A generic conservation ledger" (same gate as
PROP-FLOOD-03).

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
  is also the precedent for this proposal's `ZERO_CAPACITY_NONZERO_INFLOW` code.
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

   | Level | S_H band | T_act band | Meaning (FloodConnect wording, not part of this proposal) |
   |---|---|---|---|
   | L0 | `< 0.3` | `> H` | ปกติ |
   | L1 | `0.3–0.6` | `> 48h` | เฝ้าดู |
   | L2 | `0.6–0.9` | `24h < T_act ≤ 48h` | เตรียมตัวได้ ยังมีเวลา |
   | L3 | `0.9–1.2` | `6h < T_act ≤ 24h` | ทำตอนนี้ภายในวันนี้ |
   | L4 | `≥ 1.2` | `≤ 6h` | เร่งด่วนเดี๋ยวนี้ |
   | L5 | *(pre-check, not a band)* | capacity already 0 **and** pumps not running, or level already above threshold | เกินระบบแล้ว |
   | LR | — | — | REFUSED — dominates every numeric level |

   **All five numeric thresholds (0.3/0.6/0.9/1.2 on S_H; 6h/24h/48h on T_act) are declared
   here as a proposed convention and are explicitly marked OPEN-for-founder-tuning** — they are
   not derived from data. L5 is checked *before* the ratio bands (the ratio construction
   presumes some capacity remains). LR always outranks L0..L5.

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

## Refusal codes (fixed precedence order)

1. `UNIT_NOT_DECLARED` / `UNIT_POLYGON_MISSING` — the tuple, or its (lat,lon) resolution,
   cannot even be formed.
2. `OUTLET_CAPACITY_UNKNOWN` / `NO_GAUGE_IN_UNIT` — the tuple resolved, but a specific resolved
   input has no value.
3. `MISSING_INPUT` / `STALE_INPUT` — a declared input exists but its current reading is
   absent/stale.
4. `UNDECLARED_AREA` / `UNDECLARED_EDGE` — reused verbatim from PROP-FLOOD-03.
5. `ZERO_CAPACITY_NONZERO_INFLOW` — the degenerate ratio case (`min(D_H,R_H)=0` while `F_H>0`);
   checked last, since it needs every upstream value to have already resolved.

`NO_PUMPS_IN_UNIT` is explicitly **not** a refusal code — it is the valid `D_H(U):=0` case.

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
- `g_U(t)` derating factor when no tide/gravity condition is declared — OPEN default `1`, flagged.
- The radius-`r` INSTINCT fallback for `A_U` — no default `r`; must be stated by whoever opts in.
- `Q_cap,o` for any reach beyond the already-tagged Bangkok Chao Phraya figure — needs its own
  sourced declaration per unit, never a copied number.
