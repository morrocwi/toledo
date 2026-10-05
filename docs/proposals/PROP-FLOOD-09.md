# PROP-FLOOD-09 — NEW DERIVATION / PROPOSAL (not a Toledo theorem)

**One edge value booked in two node ledgers with a declared integer delay, and the inbound
("stacked") debt it induces, with `TAU_UNDECLARED` refusal.** Version `v1.1` (2026-09-28, after independent review: A13, A14). Tier `Dr`,
status `unverified`, code `weld/M.??.v1`. Registry: `registry/proposals/flood_edge_booking_delay.json`.
Coq: `coq/canonical/PROP_FLOOD_09_edge_booking_delay.v`.

## Source

- Founder instruction (verbatim, 2026-09-27): "ทำสมการให้ครบก่อนนะ".
- Founder ruling (verbatim): "โฟกัสที่ กทม. เหมือนเดิม แต่การปล่อยน้ำพวกนี้ ถ้ามันเชื่อมกับลุ่มน้ำ กทม.
  ควรเป็นหนี้ซ้อนด้วย". In English: keep the Bangkok focus, but releases that are linked to the
  Bangkok basin should count as stacked debt too.
- Candidate: the downstream `docs/SYSTEM_EQUATION_SET_METHOD_2026-09-27.md` §2.3 proposed five
  clauses. The downstream reuse card §5 audited them and found four to be composition. The candidate
  is therefore shrunk to **Δ1 only**.

## 1. Toledo lookup (MEASURED)

`check --formula` returned `NOT_REGISTERED` for all three of:

- the booking identity;
- `booked_in(j) = q(j − d)`;
- the `D_in` sum.

`find delay` returned `B.2.Step5`, `EQ-001/P.71`, `MQ08-stepper/M.01` and `WP.S14.Gate4`. They were
read, and none books one value into two ledgers. `find double-entry` returned 0 hits.

**Neighbour, not a parent:** `MQ08-stepper/M.01.v1` — `REGISTERED_UNVERIFIED`, `usable:true`
(status `unverified`; disclose the caveat on every citation). It is a causal-delay graph with
`delay(e)` and a path-sum FTC; it supports path lags as sums of `d_e` but does not state the
two-ledger booking proved here, so it is cited for context only and moved to this proposal's own
`neighbours_not_parents`, not `parents`.

## 2. Genesis compatibility

The gate is VI-A B.2a, the generic conservation ledger `[Dr]`, the same gate 03 and 06 use.

- Δ1 identifies `J_out` of `u` at tick `k` with `J_in` of `v` at tick `k + d_e`, with
  `J_created = 0` on the edge.
- `TAU_UNDECLARED` is Gate-2 ⊥: record it as unresolved and do not guess.

## 3. Composition, not delta (four of the five candidate clauses)

| Clause | Covered by |
|---|---|
| (ii) `abs(Q_e) ≤ cap_e` | `EQ-001/C.04.v1` admissibility, `A2/M.24–25.v1` clamp, and the PROP-FLOOD-03 `Q_out` rule. An undeclared `cap_e` gives `CAPACITY_UNDECLARED` for that edge. |
| (iii) sign agrees with PROP-FLOOD-04 | `D/M.71–76.v1` ∘ PROP-FLOOD-04 (PR #61, **not on this branch**; re-check when it lands) |
| (iv) storage-free junction | PROP-FLOOD-03 with `S ≡ 0` |
| (v) outfall boundary | PROP-FLOOD-06 `R_H`/`g_U` and the 03 `gate_flag` tide-lock. Stage is declared boundary data. |
| interior edges cancel on summation | `A2/M.11.v1` (re-proved on ℚ as `qsum_add`) and `EQ-001/C.01.v1`. With a delay, the window must be extended by `d_e`. |

## 4. The delta (Δ1)

```text
Declared edge e = (u, v), declared delay d_e ∈ ℕ ticks (declared or measured — EQ-001/P.61.v1), q(k) := Q_e(k)·τ.
booked_out(k) = q(k)                                   summand of Q_out,u(k)·τ
booked_in(j)  = q(j − d_e) if j ≥ d_e, else 0          summand of Q_in,v(j)·τ
⇒  Σ_{j < t+d_e} booked_in(j) = Σ_{k < t} booked_out(k)          (conservation across the two ledgers)

D_in(b; k_now, H) := Σ_{e=(s→b)} Σ_{k ≤ k_now, k_now < k + d_e ≤ k_now + H} q_e(k)
REFUSED TAU_UNDECLARED  iff some inbound edge has no declared d_e   (never read as 0; inbound term only)
REFUSED INPUT_ABSENT    (v1.1) if all delays are declared but some inbound edge has no flow readout (never 0)
q ≥ 0 in each edge's DECLARED orientation; a reverse flow is its own declared edge
```

Proved properties of `D_in`:

- It is causal: it depends only on `k ≤ k_now`. It is a booked quantity, not a forecast.
- It is non-negative when every flow is non-negative.
- It is 0 when `d_e = 0`.
- It saturates at `H = d_e`, where it equals the whole in-transit volume.
- It is monotone in `H`.

`D_in` enters PROP-FLOOD-03 as `Q_in` of the receiving node, and PROP-FLOOD-06 as `Q_in,up`/`tau_up`.
It is reported beside the rain term, never merged with it.

## 5. Coq (MEASURED 2026-09-28)

The file compiles with `coqc -q` clean. `Print Assumptions` returns **Closed** for all 20 items (v1.1).

| Group | Items |
|---|---|
| Booking identity | `booking_same_value`, `booked_in_before_delay` |
| Conservation | `booking_conserves`, `two_ledger_balance` (over shifted windows: ticks `0..t+d−1` into v vs `0..t−1` out of u) |
| Inbound debt `D_in` | `d_in_causal`, `d_in_nonneg`, `d_in_zero_delay`, `d_in_saturates`, `d_in_monotone_H` |
| Refusal | `book_refused_iff`, `undeclared_is_not_zero_delay`, `d_in_node_refused_iff`, `d_in_node_nonneg`; v1.1 `d_in_node_full_tau_iff`, `d_in_node_full_input_absent` |
| Sum helpers | `qsum_S`, `qsum_zero`, `qsum_ext`, `qsum_add`, `qsum_nonneg` |

## What this is NOT

- **Not a routing model.** It is a pure integer delay: no attenuation and no storage on the edge. An
  edge that stores water must be declared as a node.
- **No flow magnitude.** `w_e` and `cap_e` are undeclared everywhere downstream, and the saturating
  edge-flow law is not opened.
- **No decomposition of river stage** into upstream inflow versus tide.
- **No link asserted for undeclared edges.** For example, Mae Klong releases are not booked into
  Bangkok units (downstream, INSTINCT).
- **Zero delay is never a default.**

## Honest caveats

- No Bangkok-linked edge has a declared `d_e` yet. The HII chart labels ("6 ชม.", "20 ชม.", "1 วัน",
  "2 วัน", "2.5 วัน", "3 วัน") are not mapped to node pairs. As a result `D_in` is
  `REFUSED TAU_UNDECLARED` for every Bangkok unit today.
- The downstream 24–27 Sep 2569 replay holds upstream magnitudes (C.13 690→1,850 m³/s; Sam Khok
  615→1,748 m³/s) but books none of them.
- The rule for rounding a measured non-integer lag to whole ticks is OPEN.

## Falsifier

Suppose every incident `Q_e` is measured at a declared storage-free junction. A persistent imbalance
larger than `ε_Q` across at least 3 independent events falsifies the declared edge set or delays. The
first suspect is an undeclared edge or hidden storage.

A measured arrival that is systematically earlier or later than `d_e` falsifies that `d_e`.

## OPEN

- `d_e` for C.13 → C.29 → Bangkok and for the eastern field-water edges.
- The rounding rule.
- The registered form of PROP-FLOOD-04.
