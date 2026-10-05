# PROP-FLOOD-10 — Zoom forecast by level (screen → sub-polder → node → point), with verification ledger — NEW DERIVATION / PROPOSAL (not a Toledo theorem)

**Status**: `v2.1` (2026-09-28; v2 after independent review — see §12; v2.1 after round 2), registered in the proposals lane with Coq
(`coq/canonical/PROP_FLOOD_10_zoom_forecast.v`), no independent review yet. Tier Dr, status unverified, code `weld/M.??.v1`.
Registry: `registry/proposals/flood_zoom_forecast.json`. Every term below is either cited by an existing code (REUSE) or
marked as a delta. It remains a PROPOSAL (`EQUATION_SOURCE_POLICY.md`, TG-RFG-01) until the normal review path promotes it.
Founder instruction (verbatim, 2026-09-27): "ทำสมการให้ครบก่อนนะ" — finish the equation set before any 10-day forecast run.

**v1 changes from the draft**: Δ2 (enclosure + nested box) is registered once as **PROP-FLOOD-10a**; Δ1 (edge booking
with delay) as **PROP-FLOOD-09**; the readout is four-state (`AT_THRESHOLD` = classify's `Sz`, degenerate interval exactly
at θ) and the compute gate descends on it; worst-first firing is `hi ≥ θ`; `FEW_EVENTS` also when `N_min` is undeclared;
level-1 PARTIAL is tied to PROP-FLOOD-08's declared 24 h depth (no pro-rating); a conversion-rules decision (§9) and the
§5.1 debt-onset mapping (§10) are added.

## Scope (founder rulings, verbatim)

- "เพื่อไม่ให้ขยาย เอาแค่ที่ กทม ก่อน แล้วอันอื่นค่อยๆ ขยับไปเทส" — **tested on Bangkok only this round; other
  areas are expanded later** (ทดสอบเฉพาะ กทม. รอบนี้ — พื้นที่อื่นขยายทีหลัง).
- "เขียนโน้ตด้วยว่า เอาสัมมากรและ กทม. เป็นตัววัดพยากรณ์ MVP ก่อน ที่เหลือค่อยว่ากัน เป็นเวอร์ชันถัดไป"

> **MVP box.** The forecast MVP is measured ONLY on Sammakorn (node/point) and Bangkok (districts / the 38 BMA
> sub-polders). Everything else (Bangkok vicinity provinces, Hat Yai, Nan, Chiang Mai, the 359 DWR sub-basins
> nationwide, other provinces) is **next version**: listed as TODO rows only, no runs, no page claims. Any request
> that widens scope must be tagged `MVP` or `next-version` before work starts. The equations below are written
> area-generic (any declared unit / any lat-lon) so that the next version needs no new object, only new data.

## Source and interpretation

Founder request (verbatim): "เอาสมการพยากรณ์โลก หลักการน้ำ หลักการความกดอากาศต่างๆ มาอ่านผ่านเลนส์ readout
แล้วมองด้วยจักรวาลทีละเก้าสารสนเทศ แล้วแปลงเป็นเลนส์เรา แล้วสร้างสมการพยากรณ์ของเราเองที่[ยืน]บนพื้นที่ Toledo
แล้วลองพยากรณ์แต่ละระดับดูว่าตรงแค่ไหน ด้วยข้อมูลน้อยที่สุด". Also the queued "zoom forecast" ask.

Interpretation used (OPEN until the founder confirms): "our own equations" = relations derived by us through the
readout / discrete-information lens instead of copied from external models; they still pass the Toledo pipeline
(reuse registered parents, derive only deltas, mark NEW DERIVATION / PROPOSAL). If "our own forecast equation" was
meant as running our own atmospheric stepper, that is out of reach of the data held (no pressure, wind or humidity
fields are archived) and is recorded as OPEN, not attempted.

Step 1–2 reading of world principles (NWP primitive equations, geostrophic balance, Clausius–Clapeyron, CAPE,
pressure tendency and the semidiurnal tide, SST, monsoon trough, MJO/ENSO, water balance, rational method, unit
hydrograph, Muskingum, Saint-Venant, Manning, IDF, ensembles, verification) is in the downstream repository card
`docs/knowledge/READOUT_LENS_FORECAST_PRINCIPLES_2026-09-27.md`. Result carried here: no NWP/hydraulic PDE,
Manning, ln-form Clausius–Clapeyron or return-period fit is used as a parent (continuum or irrational forms; lookups
below). What survives is: finite sums per tick, declared capacities, min/max over sources and paths, three-state
classification, and counting.

## 1. Toledo lookup (MEASURED with the registry CLI on this branch)

| query | verdict |
|---|---|
| `check --formula "cell = HIT if F in {Sp} and O = event"` | NOT_REGISTERED |
| `check --formula "lead = t_onset - t_alert"` | NOT_REGISTERED |
| `check --formula "P24 / 80 >= 1"` | NOT_REGISTERED as text (the relation is PROP-FLOOD-08 case (e) on the 24 h window) |
| `check --formula "d = max(0, H - z)"` | NOT_REGISTERED as text (occurrence of 08 `E_k`, see §4 L3) |
| `check --formula "t_arr >= min over paths sum d_e"` | NOT_REGISTERED as text; the algebra is `Z/M.21.v1` + `A2/M.07.v1` (read statements) |
| `find` "forecast verification", "skill score", "false alarm", "hydrostatic", "geostrophic", "rational method", "hydrograph", "return period", "pressure tendency" | 0 hits each |
| `show` `D/M.71.v1`, `weld/E.07.v1`, `EQ-002/M.01.v1`, `Z/M.21.v1`, `R/M.14.v1`, `EQ-001/C.18.v1`, `ChemDomain_ledger/C.24.v1`, `weld/S.13.v1` | REGISTERED_CURRENT each |

The lookup tool matches text, so every parent below was additionally checked by reading its statement in
`registry/CANONICAL.json` (1,344 entries at `generated_from_commit` 9ca306c). The reuse analysis already
done downstream (`docs/knowledge/TOLEDO_HYDRAULICS_DIFFUSION_ZOOM_REUSE_2026-09-27.md` in the flood repository) is
relayed and not repeated; this object adds only what that card did not cover (the per-level forecast inputs, the
compute gate, the source-count guard, and the verification ledger).

## 2. Genesis compatibility

- Gate 2 Three-Valued Admissibility (`𝒞 ∈ {1, 0, ⊥}`; "⊥ … record it as unresolved and do not guess") — every level
  returns a three-state readout; REFUSED is ⊥ of the input, never 0.
- Face 10 Record/Readout — every readout is a record, not the water.
- Face 12 Boundary-Data ("Numbers are measured, not derived from zero") — thresholds (35.1 / 65.1 / 80 / 125.1 /
  250.1 mm per 24 h), design capacity, travel times and datums are boundary data, declared with a source, never derived.
- IV.5 Commuting-Square Bridge Criterion — moving a statement between levels needs a declared transport.
- VI-A B.2a generic conservation ledger [Dr] — Level 1 (via PROP-FLOOD-03).
- II.1 MQ.08 discrete stepper — a numerical weather model is read as someone else's stepper; we read its outputs, we
  do not run it.

## 3. Reuse (parents, by code; statements read)

| role | code(s) | tier |
|---|---|---|
| three-state classification of an interval against a threshold | `D/M.71.v1`–`D/M.76.v1` (exact renaming `v := (lo+hi)/2 − θ`, `floor := (hi−lo)/2`) | Th_coqc |
| resolution monotonicity (coarser can only widen ⊥) | `D/M.77.v1` | Th_coqc |
| count brackets when aggregating units upward | `D/M.79.v1`, `D/M.80.v1` | Th_coqc |
| min / max over sources and over paths | `Z/M.12.v1`–`Z/M.17.v1`, `Z/M.21.v1`, `Z/M.22.v1`, `Z/M.23.v1`, `A2/M.07.v1` | Th_coqc (on ℤ; ℚ via positive scale to the declared resolution grid) |
| clamp / relaxation never increases | `A2/M.24.v1`, `A2/M.25.v1` | Th_coqc |
| recession tail bound | `R/M.14.v1` | Th_coqc |
| discrete FTC (sum of ticks) | `R/M.09.v1`, `A2/M.03.v1` | Th_coqc |
| stationary-but-not-flat ⇒ cut edge or source | `weld/M.43.v1`, `L_R/M.22.v1` | Th_coqc |
| flat readout ≠ no flow | `EQ-001/C.07.v1` | untagged |
| speed/travel time declared, not derived | `EQ-001/P.61.v1`, `EQ-001/P.36.v1` | untagged |
| one-way transport between levels | `weld/E.08.v1` | Definition |
| no point claim from a city readout | `EQ-002/M.01.v1` | Definition |
| weakest-link claim ceiling | `weld/E.07.v1` | Dr |
| no merge across different invariants (datum, outfall, gate state) | `weld/E.06.v1`, `weld/M.64.v1` | Definition / Th_coqc |
| level ladder index; bounded refinement terminates | `weld/M.13.v1`; `EQ-001/C.18.v1` | Definition; Th_coqc |
| trend sign (Δ_k) on a series | PROP-FLOOD-01 | proposal, Dr, unverified |
| water balance per tick | PROP-FLOOD-03 | proposal, Dr, unverified |
| promoter floor, multi-model scenarios (never averaged, worst first), hysteresis p/q, forecast-only tier cap L1, calibration block | PROP-FLOOD-06 v6.1 | proposal, Dr, unverified |
| flow-state / coverage3 | PROP-FLOOD-07 | proposal, Dr, unverified |
| design load ratio `L_H` (per declared window), storage exceedance `E_k` | PROP-FLOOD-08 v1 | proposal, Dr, unverified |
| edge identity with integer delay; inbound debt `D_in` | PROP-FLOOD-09 v1 (Δ1) | proposal, Dr, unverified |
| monotone endpoint enclosure + nested box; `cl` = classify renamed; BOUND_MISSING / NOT_NESTED | PROP-FLOOD-10a v1 (Δ2, registered once, shared with 08) | proposal, Dr, unverified |

Rejected as parents (read, not a match): `weld/S.13.v1` continuity equation (continuum ∂t/∇), `ChemDomain_ledger/C.24.v1`
Clausius–Clapeyron (ln form), `EQ-015/P.60.v1` Bernoulli (name only), `EQ-015/P.61.v1` duct continuity (not a
network ledger).

## 4. The equation set by zoom level (compact)

Notation: unit `u` at level ℓ ∈ {0,1,2,3}, parent unit `π(u)`; integer tick `k` (hours) or day `n`; issue time `t_i`,
target window `W`, horizon `h := start(W) − t_i` (integer, rounded down); sources `m ∈ M_u` (models or gauges);
threshold ladder `Θ = {35.1, 65.1, 80, 125.1, 250.1}` mm/24 h (boundary data from the downstream crosswalk
`sources/rain_alert_thresholds_crosswalk.yaml` `unified_ladder`; 80 = BMA design capacity, strictest for BMA units).
All quantities in ℚ. `cl(lo, hi; θ) := classify((hi−lo)/2, (lo+hi)/2 − θ) ∈ {ROBUST=Sp, AT_THRESHOLD=Sz, POSSIBLE=⊥, BELOW=Sm}` (PROP-FLOOD-10a); `lo = θ < hi` is POSSIBLE (declared, conservative).

### Common rules (apply at every level)

- **C1 interval, worst first** — `I_u = [lo, hi] := [min_m x_m, max_m x_m]`; `hi` reported first; never a mean.
  *REUSE* 06 v6.1 `multi_model_scenarios` + `Z/M.12–17`.
- **C2 three-state** — `state_u := cl(I_u; θ)`. *REUSE* `D/M.71–76` (renaming).
- **C3 source-count guard** — sources are **named**; `|M_u|` is the number of distinct names and a repeated name is
  `REFUSED DUPLICATE_SOURCE` (two copies of one reading never count as two sources) — at every level, ladder children
  included. If `|M_u| = 1` the interval is degenerate and its true width is unknown. Then
  `floor := ε_src` (declared per source class); if `ε_src` is undeclared, the strict state is POSSIBLE (it can be
  neither ROBUST nor BELOW) and the raw comparison `x ≥ θ` is printed beside it with `spread: UNKNOWN_SINGLE_SOURCE`.
  **DELTA Δ10.2 — NEW DERIVATION / PROPOSAL — not yet in Toledo.**
- **C4 refinement consistency** — child interval must be nested in the parent interval on shared variables
  (PROP-FLOOD-10a); if `state_child` and `state_parent` are both determinate and opposite (Sp vs Sm), both are kept
  and a contradiction row is written; neither overwrites the other (for genuinely nested inputs this is impossible —
  `nested_no_flip` — so such a row locates an input or nesting-declaration error). Non-nested partitions (e.g. Bangkok districts vs the
  38 sub-polders, which cut across each other) ⇒ `REFUSED NOT_NESTED` for strict refinement, cross-partition readout
  only. *REUSE* `D/M.77`, `weld/E.06`, `weld/E.08` + **PROP-FLOOD-10a** (nested determinate parent is inherited, never flipped).
- **C5 compute gate** (stated once; identical in JSON and Coq `descend`) — evaluate a child of `u` iff
  `state_u ∈ {ROBUST, AT_THRESHOLD, POSSIBLE}`, or `u` is REFUSED **for any reason** *and* the child has its own inputs
  (a child never inherits a refusal or a verdict); BELOW at the parent stops descent for that window. Every evaluated
  child carries the strict-refinement check against its parent (10a `refine_check`: `NOT_NESTED`, `BOUND_ORDER`, or
  `BOUND_MISSING` when either has no bounds); only a passed check licenses "child keeps the parent's determinate side"
  (`checked_child_keeps_parent_side`). Refinement is bounded by a declared cell ceiling `N_cells`, so it terminates
  (`EQ-001/C.18`). **DELTA Δ10.1 (policy) — NEW DERIVATION / PROPOSAL — not yet in Toledo.**
- **C6 claim ceilings** — tier of any zoomed statement ≤ weakest link (`weld/E.07`); a city/screen readout never
  licenses a point statement (`EQ-002/M.01`); a forecast-only readout never lifts a tier above L1 (06).
- **C7 upward aggregation** — number of flooded children lies in `[certain, certain + unresolved]` (`D/M.79–80`);
  never a percentage without its bracket.

### Level 0 — screen (Bangkok units: DWR sub-basin 1002; 1302/1507/1510 bbox-overlap only, polygon OPEN; 50 districts)

```
P^m_24(u; t_i, W)  := forecast rain sum over the 24 ticks of W, model m, grid point(s) of u      [readout]
I0(u; h)           := [min_m P^m_24, max_m P^m_24]                                                 C1
S0_j(u; h)         := cl(I0; θ_j),  θ_j ∈ Θ                                                        C2, C3
rung0_strict(u; h) := max{ j : S0_j = ROBUST }                                                 strict
rung0_wf(u; h)     := max{ j : I0 not REFUSED ∧ hi(I0) ≥ θ_j }                                    worst-first
                      (= Coq `fires WORST_FIRST`; under C3 hi is the raw single value, so a forced POSSIBLE
                       never fires a rung by itself)
tier0              := max(rung0_{strict|wf} mapped to L0..L3 (both reported), promoter floors), capped at L1 if forecast-only  06
```

At `θ = 80`: `S0 = ROBUST ⇔ lo/80 > 1 ⇔ L_24` strictly above 1 for every model, with `D_design(U, 24) = 80` declared (PROP-FLOOD-08 case (e), 24 h window only).
Data-only candidate promoters (no equation; declared readouts): TMD / TMD-HII category or colour for the area
(RELAYED issuer readout; scope `regional_class`, never substituted for a node lead); GloFAS return period
(**REFUSED `THRESHOLD_TABLE_ABSENT`** — no return-period table held); `PRESSURE_DROP_24H` on
`Δ_24 p` (PROP-FLOOD-01 Δ_k on a pressure series; the lag-24 difference cancels any exact 12 h/24 h periodic part,
a finite identity) — **candidate, not yet in Toledo, REFUSED `INPUT_ABSENT`** (no pressure series archived).

**Minimal input set (L0)**: per-model 24 h forecast rain at the unit's grid point(s) for the target day, from ≥ 2
models (1 model allowed but flagged by C3); the ladder Θ. Nothing else is required to resolve the three-state answer.

### Level 1 — sub-polder / district balance (east side first: sub-polders 4, 9, 14, 20, 21, 24, 25, 26, 27)

```
FULL (PROP-FLOOD-03 at box endpoints, enclosure Δ2):
  S_b(k+1) ∈ [ S_lo + P_lo·A_b·c_lo + Q_in,lo·τ − Q_out,hi·τ ,  S_hi + P_hi·A_b·c_hi + Q_in,hi·τ − Q_out,lo·τ ]   03 + 10a
  S1(b)    := cl([S_lo, S_hi]; S_safe)        ROBUST ⇔ S_safe < S_lo · BELOW ⇔ S_hi < S_safe       10a
  E_b(k)   ∈ [ max(0, S_lo − S_safe), max(0, S_hi − S_safe) ]   reported beside S1 as the SIZE of the excess
  (v2: the v1 readout cl(E_b; 0) could never be BELOW because E_b ≥ 0 — it always fired and always descended)
PARTIAL (what current data allows):
  I1(b) := [min_g P^g_24, max_g P^g_24] over gauges g in b (observed) or models (forecast)       C1
  S1(b) := cl(I1(b); D_design(b, 24))   = cl on L_24 vs 1, 24 h window only (80 mm, BMA)       08 (e)
upward: flooded children of the parent ∈ [certain, certain + unresolved]                        C7
```

REFUSED codes (reused from 03/06/08): `MISSING_INPUT(storage_state)`, `SAFE_STORAGE_UNDECLARED`,
`UNDECLARED_AREA`, `ZERO_OUTFLOW` (not "infinite drain time"), plus `NOT_NESTED`, `UNIT_POLYGON_MISSING`
(the 38 sub-polders have areas and district lists in the BMA plan 2569, but no polygons).

**Minimal input set (L1 PARTIAL)**: ≥ 2 rain readings (gauges or models) inside the unit for the same 24 h window;
`D_design(U, 24) = 80 mm` (BMA plan 2569 p.63, VERIFIED downstream); any other window uses its own declared depth or is REFUSED `DESIGN_DEPTH_UNDECLARED`. **FULL adds**: `A_b` (held for the 38 sub-polders), `c_b` bound pair,
`S_b(0)`, running pumps × rated capacity, `S_safe` — the last three are absent everywhere today.

### Level 2 — node / canal propagation (Saen Saep – Prawet – Lat Phrao – Ban Ma chain)

```
state_v(k)     := cl([Δ_k h_v − ε, Δ_k h_v + ε]; 0)       trend sign, PROP-FLOOD-01 + D/M.71–76
line_v(k)      := canal level vs its own warning/critical line   06 promoters CANAL_AT_WARNING/CRITICAL
t_arr(v)       ≥ min over ALL declared paths p from source s of Σ_{e∈p} d_e    Z/M.21, A2/M.07 (ℤ ticks)
d_e            := declared or measured integer delay only (EQ-001/P.61); ANY undeclared d_e on ANY declared path
                  ⇒ REFUSED TAU_UNDECLARED for the whole bound (a path is never dropped: dropping it silently treats it
                  as never arriving — a non-readout — and the undeclared path may be the fastest); no declared path ⇒ REFUSED MISSING_INPUT
edge identity  : Q_e(k) counted in Q_out,u(k) and Q_in,v(k + d_e)          PROP-FLOOD-09 (Δ1)
recession      : remaining fall ≤ t_N/(1−ρ) for a measured envelope ρ < 1   R/M.14
cut-edge flag  : stationary with |h_u − h_v| > ε across an open edge ⇒ edge cut or source    weld/M.43 (contrapositive)
```

No flow magnitude is asserted (w_e, cap_e undeclared — REFUSED, downstream reuse card §2.1).
**Minimal input set (L2)**: level series at the upstream and downstream station on one datum with their own lines,
and the declared `d_e` of each edge on the path.

### Level 3 — point depth (Sammakorn; flood_road points in Bang Kapi)

```
d_p ∈ [ max(0, H_lo − z_hi), max(0, H_hi − z_lo) ]        08 E_k's `excess` (metres over one datum), enclosure proved
     reversed endpoints (H_hi < H_lo or z_hi < z_lo) ⇒ REFUSED BOUND_ORDER
S3(p) := cl(d_p; θ_depth)       θ_depth declared (e.g. 0.10 m road threshold of the event ledger rule)
REFUSED DATUM_UNDECLARED if H and z are not on one declared datum; Z_MISSING; STALE_INPUT
```

A road-depth telemetry reading is itself the observed point readout; Level 3 *forecast* needs H forecast at the
nearest node (Level 2) and z on the same datum. **Minimal input set (L3)**: `H` at the nearest node and `z_p`, both on
one declared datum, plus `θ_depth`.

### Inbound (stacked) debt — Bangkok-linked releases booked now (L1 / L2 boundary term)

Founder ruling (verbatim): "โฟกัสที่ กทม. เหมือนเดิม แต่การปล่อยน้ำพวกนี้ ถ้ามันเชื่อมกับลุ่มน้ำ กทม. ควรเป็นหนี้ซ้อนด้วย".
**No new object here**: this is PROP-FLOOD-09 (Δ1) — one edge value
`Q_e` booked in two node ledgers with a declared integer delay `d_e` — applied to edges that enter Bangkok units.

```
booking (Δ1):   Q_e(k) is a summand of Q_out,s(k) and of Q_in,b(k + d_e)                     PROP-FLOOD-09
stacked debt:   D_in(b; k_now, H) := Σ_{e=(s→b)} Σ_{k: k ≤ k_now, k_now < k + d_e ≤ k_now + H} Q_e(k)·τ
                = inflow already released/measured upstream that will arrive at b within the horizon H   03 Q_in, A2/M.11, R/M.09
d_e             declared or measured only (EQ-001/P.61); undeclared ⇒ REFUSED TAU_UNDECLARED (never 0, never guessed)
```

`D_in` enters PROP-FLOOD-03 as the `Q_in` term of the receiving unit and PROP-FLOOD-06 as `Q_in,up` / `tau_up`; it is
reported beside, never merged into, the rain term. Two effects are kept separate:

- **(a) river reach → stage at the Bangkok outfalls.** Inflow raises Chao Phraya stage; that reduces gravity outflow
  and pump effectiveness at the outfalls (PROP-FLOOD-03 gate-closed branch `Q_out := 0` for gravity; PROP-FLOOD-06
  derating `g_U(t)`). Readout: `cl([H_river − ε, H_river + ε]; +2.00)` on the MSL (ม.รทก.) datum only — +2.00 ม.รทก.
  is the BMA plan 2569 line "ในกรณีที่ระดับน้ำในแม่น้ำเจ้าพระยาที่สูงเกินกว่า +2.00 ม.รทก. ตามที่คาดหมายไว้อาจทำให้
  การป้องกันน้ำท่วมไม่ได้ผล…" (VERIFIED downstream, boundary data). A reading on a station-local datum is REFUSED
  DATUM_UNDECLARED against this line. Reach headroom may be read with 06 `R_H = max(0, Q_cap − Q_now)`; no
  decomposition of stage into inflow vs tide is asserted (no routing).
- **(b) east field water (น้ำทุ่ง) outside the King's dyke → pulled west through Saen Saep / Prawet.** `Q_e` at the
  eastern boundary nodes (Nong Chok side) feeds the L2 chain. No discharge feed exists ⇒ REFUSED INPUT_ABSENT.

Bangkok-linked sources (declared list): Chao Phraya dam C.13 release; C.2 Nakhon Sawan, C.29 / Sam Khok / Bang Sai
discharge; Pasak (Rama VI barrage) release; Bhumibol and Sirikit releases (upstream of C.2); eastern field water.
**Excluded — NOT linked**: Mae Klong releases (RID Region 13) drain to the Gulf at Samut Songkhram, not into Bangkok
polders (INSTINCT). Evidence that would establish a link: a declared transfer through Tha Chin / Damnoen Saduak
canals toward west Bangkok with measured discharge or a rise at west-side Bangkok gauges lagging the release.

### Verification ledger (applies to every level) — **DELTA Δ10.3 — NEW DERIVATION / PROPOSAL**

```
F(u, W, h) := state issued at t_i = start(W) − h    ∈ {ROBUST, AT_THRESHOLD, POSSIBLE, BELOW, REFUSED}
O(u, W)    := observed truth                         ∈ {EVENT, NO_EVENT, UNRESOLVED}
cell := HIT          if F fires and O = EVENT
        MISS         if F does not fire and O = EVENT
        FALSE_ALARM  if F fires and O = NO_EVENT
        CORRECT_NEG  if F does not fire and O = NO_EVENT
        UNRESOLVED   if O = UNRESOLVED or F = REFUSED            (never counted as CORRECT_NEG)
  with "fires" declared twice and both reported: strict := state = ROBUST;
  worst-first := hi ≥ θ (equals ROBUST-or-POSSIBLE for a non-degenerate interval, and the raw comparison under C3)
lead(u, W) := t_onset − t_first_persisted_alert   (integer ticks; persisted = hysteresis p of 06)
  t_onset left-censored (before the collector's first fetch) ⇒ lead is reported as a bound, never a point
skill claim := REFUSED FEW_EVENTS when N_min is undeclared or the count of independent events n_ind < N_min;
  cells are listed per event and never averaged across events
```

Parents: `D/M.71–76` (both F and O are three-state readouts), `D/M.79–80` (counts with unresolved bracket),
06 hysteresis and calibration block (the ledger is what 06 `calibration_procedure` consumes), `delta_R` for the
lead difference. The delta is the pairing rule itself (a 5-cell product of two three-state readouts with UNRESOLVED
kept separate) and the FEW_EVENTS refusal.

## 5. Monotonicity (machine-checked where marked; see §11)

Machine-checked: the worst `hi` bounds every source and is attained, `lo` likewise; a checked nested child never
flips a determinate parent (`nested_no_flip`, `checked_child_keeps_parent_side`); the level-3 interval encloses the
true depth; the L1 FULL box endpoints (`wb_step_enclosure`).
Stated, **not** machine-checked: `S0` moves up the ladder when a source value rises; adding a source never flips
Sp↔Sm; the `t_arr` lower bound is non-increasing when an edge delay decreases (`A2/M.24`).

## 6. What this is NOT

Not a numerical weather model; not a hydraulic model (no routing, no Saint-Venant, no Manning); no flow magnitude;
no hourly intensity inferred from a 24 h total; no point depth without one datum; no skill claim from one event; no
statement about any area outside the declared units.

## 7. Falsifier

(1) Across replayed real events for a unit class, the strict L0/L1 state is ROBUST repeatedly where the truth is
NO_EVENT, or BELOW repeatedly where the truth is EVENT ⇒ the ladder edge is falsified for that class (not the
arithmetic). (2) A child state determinately opposite to a nested parent state without an input error ⇒ the nesting
declaration or an input is wrong. (3) An observed arrival earlier than the min-plus lower bound ⇒ a declared `d_e` is
wrong, or there is an undeclared faster path (an edge missing from the declared graph). The first real replay (Bangkok, 24–27 Sep 2569) is in the flood repository
`docs/experiments/2026-09-27-zoom-forecast-real-backtest.md` — one meteorological event; below any N_min, so it
tests the plumbing and records cells, it does not calibrate.

## 8. Tier and status

Tier Dr; status unverified; Coq `coq/canonical/PROP_FLOOD_10_zoom_forecast.v`; deltas Δ10.1 (compute gate), Δ10.2
(source-count guard), Δ10.3 (verification ledger); depends on PROP-FLOOD-09 (Δ1, also carries the inbound stacked-debt
term) and PROP-FLOOD-10a (Δ2), both registered on this branch in the same set.

## OPEN

- Founder: confirm the interpretation of "our own equations" and of "ทีละเก้าสารสนเทศ".
- `N_min` for FEW_EVENTS (downstream proposes 10); `ε_src` per source class; `N_cells` ceiling.
- Polygons for the 38 BMA sub-polders; polygon test for DWR 1302/1507/1510 against Bangkok.
- Datum of every BMA canal station; ground elevation at Sammakorn on the same datum.
- Declared `d_e` for C.13 → C.29 → Bangkok and for the east field-water edges: the HII basin chart labels
  ("6 ชม.", "20 ชม.", "1 วัน", "2 วัน", "2.5 วัน", "3 วัน") are not yet mapped to node pairs — RELAYED-declared once mapped.

## 9. Conversion rules R1–R11 — decision (no object registered)

The downstream crosswalk (`sources/rain_alert_thresholds_crosswalk.yaml`) carries eleven conversion rules. None is
registered as a Toledo object:

| rule | decision |
|---|---|
| R1 depth = intensity × duration, same window | unit (dimensional) identity; never bridges windows |
| R2 cross-duration via IDF same-T match | **empirical table lookup** — the IDF table is data, never a theorem; its only formal consequence is PROP-FLOOD-08's per-window declared depth with `DESIGN_DEPTH_UNDECLARED` (80 mm/24 h and 58.7 mm/h are not a same-T pair) |
| R3 day-boundary shift by re-summation | finite re-summation (sums of `R/M.09`, `A2/M.11`); refused without the hourly series |
| R4 margin H − line, same station/datum | `delta_R` instance; with `max(0,·)` it is 08 `E_k`'s same-datum excess |
| R5 / R6 ratios with a declared same-reach denominator | instances of the 06 layer-0 / 08 ratio pattern |
| R7 category → declared [lower, upper], open top refused | input side of PROP-FLOOD-10a (`BOUND_MISSING`, never ∞) |
| R8 per model, worst first, never averaged | PROP-FLOOD-06 v6.1 `multi_model_scenarios` |
| R9 / R11 categorical flag → rung by name | categorical lookup tables (founder-adoptable mappings) |
| R10 return period → rung, same reach only | same-location lookup; `THRESHOLD_TABLE_ABSENT` today |

## 10. §5.1 debt-onset mapping (BMA plan 2569) — mapping only

From the downstream card `docs/knowledge/S51_DEBT_ONSET_AND_BMA_COPING_INDICATOR_2026-09-27.md`: new debt = PROP-FLOOD-08
`L_1 = i_1h/58.7` and, separately, `L_24 = P_24/80` (levels 0/1; three-state vs 1); carried debt = 08 `E_k` at level 1
FULL (REFUSED today); stacked debt = PROP-FLOOD-09 `D_in` beside the level-1 rain state (period 3; REFUSED today);
repayment slowdown = river stage vs +1.80 / +2.00 m MSL as a derating flag (03 gate-closed, 06 `g_U`), MSL datum only.
The plan's own period-2 "normal" band 60–90 mm/h gives `L_1 ∈ [1.02, 1.53]` — ROBUST above 1 (08 Coq Example). The
downstream replay of three independent event groups (24–27 Sep 2569, 14 Sep 2568, Oct–Nov 2554) uses this object's
five-cell ledger and ends **REFUSED FEW_EVENTS on every axis** (3 < proposed `N_min` = 10) — relayed from that card,
not re-run here.

## 11. Coq (MEASURED 2026-09-28)

`coqc -q -Q . MRC -R ../information-discrete-math IDM` (scratch build, after 10a/08/09) clean; `Print Assumptions`
**Closed under the global context** for all 46 items (v2.1):

- Δ10.2 guard: `zoom_no_source_refused`, `single_source_never_determinate`, `degenerate_interval_always_determinate`
  (why the guard is needed), `multi_source_robust_sound`, `multi_source_below_sound`; source interval
  `best_bounds_every_source`, `best_none_iff`, `source_interval_encloses`, `best_le_worst`.
- Δ10.1 gate: `gate_below_stops`, `child_independent_of_parent_verdict`, `child_does_not_inherit_refusal`,
  `refused_parent_without_child_inputs_stops`, `evaluated_cells_bounded`.
- Δ10.3 ledger: `unresolved_never_correct_negative`, `refused_forecast_never_correct_negative`,
  `correct_negative_sound`, `cell_unresolved_iff`, `strict_implies_worst_first`, `ledger_partition`,
  `correct_negatives_bounded`, `censored_lead_is_upper_bound`, `skill_claim_refused_iff`.
- Level 3 / inbound: `point_depth_enclosure`, `point_depth_refused_without_datum`, `point_depth_refuses_reversed`,
  `inbound_refusal_leaves_rain_state` (inbound term = 09 `d_in_node_full`).
- v2 additions: named sources `zoom_duplicate_refused`, `same_reading_twice_refused`; no placeholder bounds
  `refused_has_no_bounds`, `bounds_present_unless_refused`, `flagged_is_possible`, `unflagged_state_is_cl`; ladder
  nesting `checked_child_keeps_parent_side`; Level-1 FULL `l1_full_below_reachable`, `l1_full_below_means_no_excess`,
  `l1_full_robust_iff_certain_excess`, `l1_full_refused_without_safe`; Level-2 `path_delay_none_iff`,
  `arrival_refused_iff_undeclared_edge`, `arrival_bound_sound`, `undeclared_faster_path_refuses`;
  `strict_implies_worst_first` now holds for every zoom readout (any declared spread).
- v2.1 (round 2, R2-A11): ladder children are named sources routed through `zoom_state` — `zoom_state_nodup`,
  `ladder_child_is_zoom_state`, `ladder_child_duplicate_refused`, `zoom_vals_nonempty_not_missing`.

## 12. v2 changes after independent review (maker ≠ checker)

B1 level-0 worst-first rung `max{j : not refused ∧ hi ≥ θ_j}`; B2 Level-1 FULL `cl([S_lo,S_hi]; S_safe)` with `E_b` as a
magnitude; B3 Level-2 whole-bound refusal on any undeclared delay; A2 refinement check in the ladder and `BOUND_ORDER`
for reversed endpoints; A3 C5 stated once; A4 `strict_implies_worst_first` for every readout; A7 refused readouts
carry no bounds; A11 named sources / `DUPLICATE_SOURCE`; A15 checked vs stated monotonicity separated.

## Founder decisions

- **A6 — decided 2026-09-28** (founder, verbatim: "เอาเลย", accepting the recommendation). The question was:
  agency class edges (35.1 / 65.1 / 125.1 / 250.1 mm at 0.1 mm resolution) are closed at the lower edge, while strict
  ROBUST needs `lo > θ`. The decision:
  - the agency's inclusive lower edge (reached at `≥`) is a **zoom-focus trigger** only, so AT_THRESHOLD or POSSIBLE at
    that edge descends (C5, unchanged);
  - the **public rung stays strict**: ROBUST needs `lo > θ` at every rung, class edge or capacity;
  - the **agency class label** (inclusive) is shown **beside** our rung as a reporting field, never as our rung;
  - 80 mm stays a capacity.

  No change to any statement, to `cl`, to `zoom_state` or to Coq. This is recorded in the JSON `decided_founder_decisions`
  and as a LINEAGE event. First use: the downstream trial forward run
  `docs/experiments/2026-09-28-bangkok-10day-forward-forecast.md` in the flood repository (not a page claim).

## OPEN — founder decision

- **A5** — under STRICT, a POSSIBLE (undecided) forecast with NO_EVENT currently counts as CORRECT_NEG (not refused,
  not fired). Keep, count undecided forecasts separately, or report CORRECT_NEG as a bracket `[certain, certain + undecided]`?
- `N_min` (downstream proposes 10); `ε_src` per source class; `N_cells` ceiling; wording "level of service".
