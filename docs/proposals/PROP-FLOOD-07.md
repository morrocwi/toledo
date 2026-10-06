# PROP-FLOOD-07 — NEW DERIVATION / PROPOSAL (not a Toledo theorem)

**Flow-state classification (F1–F6) for a connected water-chain edge, with an explicit
`REFUSED`-only-if-no-input rule, plus a generic "inferred" coverage-state primitive with
declared consistency rules (RULE-STALL-01 / RULE-DIR-01).** Version `v1`.

## Source and founder framing

`thailand_flood_kg/docs/FLOW_STALL_TYPOLOGY.md` sec.8 records a candidate F1–F6 typology
("ทำ typology ให้เห็นภูมิทัศน์ แล้วค่าวัดต่างๆ ทำให้เห็นการไหล และการหยุดไหล โดยใช้ข้อมูลน้อยที่สุด"
— make a typology that shows the terrain/landscape, and let the measurements show flow and
stalled-flow, using the least data possible) that a founder-relayed external assistant proposal
supplied, and states explicitly: *"ยังไม่ผ่าน Toledo, ห้ามอ้างเป็นทฤษฎีบท ... งานนี้เพียงร่างข้อความ
ผู้สมัคร (candidate statement) ไว้ให้ทีม Toledo ไปขึ้นทะเบียนต่อ"* (not yet through Toledo, must not be
cited as a theorem; that document only drafted the candidate statement for the Toledo team to
register). This is that registration.

A separate, same-day founder correction ("อย่าลืมว่าไม่มีทางมีข้อมูลพอ แต่ใช้การอนุมานจากข้อมูลที่
แข็งแรงเป็นหลัก" — there is never enough data; use inference from strong-enough data as the main
tool) drives the second half of this proposal: `REFUSED` is the last resort, never the default for
an un-instrumented node/edge, and the same correction is exactly what PROP-FLOOD-06.v5's own
`honest_caveats` deferred to "v6" as a generic **`inferred`** third coverage state. This proposal
implements that primitive **here**, as its own object, so a future PROP-FLOOD-06.v6 can import it
rather than re-derive it — per this repository's own Toledo-first reuse gate
(`EQUATION_SOURCE_POLICY.md` `TG-RFG-01`): a genuinely new primitive gets its own lookup/
Genesis-compatibility pass before derivation, not a silent fold into an unrelated object's next
version bump.

## 1. Toledo lookup (no existing object already classifies flow states)

- **PROP-FLOOD-04** (edge head-gradient direction) gives direction only (`u->v`/`v->u`/
  `UNRESOLVED`/`REFUSED`) — no notion of "free vs. blocked vs. backwater vs. surcharge".
- **PROP-FLOOD-01** (lag-k trend) gives a single node's own `RISING`/`FALLING`/`FLAT` sign — no
  cross-node classification.
- **PROP-FLOOD-05a/b** (burden ledger) classifies which *side* of a control structure is
  burdened/relieved — a different question (who bears load), not whether the *edge itself* is
  flowing freely, delayed, blocked, backwatered, or surcharging.
- No object in `registry/proposals/*.json` combines a gradient reading, a trend reading, a
  control-structure state, and a community report into a single flow-state class. **Gap
  confirmed — PROPOSAL, not REUSE.**

## 2. Genesis compatibility

`readout_genesis` Part V-A, A.13 "Gate 2 — Three-Valued Admissibility" (the same gate
PROP-FLOOD-01/04 already cite): `𝒜(ξ | c, 𝒯) ∈ {1, 0, ⊥}`. This object needed a **fresh** check
(not merely inherited) because it (a) composes two already-Gate-2-compatible sources into one
joint classification, (b) adds two genuinely new inputs (control-fault state, community report),
and (c) introduces a third coverage state (`Inferred`) neither parent's own admissibility mapping
covered. The mapping: `REFUSED(NO_INPUT)` is stronger than `⊥` (no retained distinction available
at all, not merely unresolved); each determinate F1–F5 is Genesis's admitted `1`; **F6 is `⊥` done
honestly** — "record it as unresolved and do not guess" made concrete by additionally stating the
`ruled_out` subset (already-obstructed classes, Genesis's `0`, even while the whole remains `⊥`).
`Inferred` is a bounded admissibility move: it only ever promotes an otherwise-`⊥` component by
**citing** which already-admitted anchors license it, carrying the weakest cited anchor's own
evidence strength forward as `confidence` — never asserting admissibility from nothing.

## 3. Reuse (parents, by code)

- **PROP-FLOOD-04** — `D` is a direct 4-valued collapse of its own 6-row `readout(t)`.
- **PROP-FLOOD-01** — `T` is a direct 4-valued collapse of its own trend readout at the far node;
  also reused a second time as the raw input RULE-STALL-01/RULE-DIR-01 consume at anchor nodes.
- **PROP-FLOOD-05a** — `C`'s vocabulary (`OPEN`/`CLOSED`/`PUMPING`) is reused verbatim; `FAULT` is
  the one new value this proposal adds.
- **`delta_R`** — the whole object is a composition of already-forced retained-difference
  readouts; no new continuum construction is introduced.

## 4. Derive only the missing piece: the classifier + the `inferred` primitive

### 4a. The four collapsed inputs

| symbol | values | source |
|---|---|---|
| `D` | `FORWARD` / `REVERSE` / `UNRESOLVED` / `ABSENT` | PROP-FLOOD-04's readout, collapsed (`ABSENT` = any of its 6 REFUSED reasons) |
| `T` | `FALLING` / `RISING` / `STALLED` / `ABSENT` | PROP-FLOOD-01's trend at the far/receiving node (`STALLED` = persistent FLAT across a declared window) |
| `C` | `OPEN` / `CLOSED` / `PUMPING` / `FAULT` / `ABSENT` | declared control-structure state (`FAULT` new) |
| `M` | `BACKFLOW` / `RISING` / `STEADY` / `FALLING` / `ABSENT` | community report (RELAYED) |

### 4b. The total decision table (10 rows, first match wins)

| row | condition | result | ruled_out |
|---|---|---|---|
| 1 | `D=T=C=M=ABSENT` | `REFUSED(NO_INPUT)` | — |
| 2 | `M=BACKFLOW` | **F5** | {} |
| 3 | `D=REVERSE` | **F4** | {} |
| 4 | `D=FORWARD, T=FALLING, C≠FAULT` | **F1** | {} |
| 5 | `D=FORWARD, T∈{FALLING,RISING}, C=FAULT` | **F6** | {F1,F2} |
| 6 | `D=FORWARD, T=RISING, C≠FAULT` | **F2** | {} |
| 7 | `D=FORWARD, T=STALLED` | **F3** | {} |
| 8 | `D=FORWARD, T=ABSENT` | **F6** | {F4,F5} |
| 9 | `D=UNRESOLVED` | **F6** | {F4} |
| 10 | `D=ABSENT` (not row 1) | **F6** | {} |

Row 7 (F3, blocked) is **deliberately not vetoed by `C=FAULT`** — "gradient without progress" is
itself consistent with a faulted structure, not contradicted by it. Only F1/F2 (free-flow claims)
require the veto, per founder rule 5 verbatim: *"ปั๊ม/ประตูขัดข้อง (fault) → ให้บอกว่า 'ความล้มเหลวของ
โครงสร้างอาจครอบงำสถานการณ์' ห้ามพูดว่า 'ตามทฤษฎีน้ำไหลได้'"* (a faulted structure must never be read as
licensing "in theory water can flow"). This realizes the founder's separate correction directly:
`D=ABSENT` alone (row 10) never refuses the edge as long as `T`, `C`, or `M` carries any real
value — the classifier reaches **F6, not REFUSED**, per that instruction.

### 4c. The generic `inferred_value(A)` primitive

```coq
Inductive coverage3 : Set := Cov_Present | Cov_Absent | Cov_Inferred.
Record inferred_value (A : Set) := mkInferred {
  iv_state : coverage3; iv_value : option A;
  iv_confidence : option strength; iv_anchors : list nat
}.
```

`coverage3_rank : coverage3 -> nat` gives `Absent=0 < Inferred=1 <= Present=2` — the reusable
ordering fact a future PROP-FLOOD-06.v6 needs for its own "inferred → present never lowers the
tier" theorem (`coverage3_promote_never_lowers_rank`, proved here).

### 4d. RULE-STALL-01 / RULE-DIR-01

- **RULE-STALL-01**: far anchor persistently `STALLED` (measured) **and** 0 pumps running
  (measured) **and** community reports "not yet falling" (RELAYED) ⇒ infer the whole intervening
  run `STALLED`; `confidence := min` of the three sources' own strengths (never an average).
- **RULE-DIR-01**: two bounding anchors (measured) agree in direction (both `RISING` or both
  `FALLING`) ⇒ infer the intervening run moves that direction; `confidence := min` of the two
  anchors' strengths. Declared limitation: does not itself check for a hidden control structure
  mid-run — a run known to contain one must be declared `edge_kind=CONTROLLED` and split first.
- **RULE-COMMUNITY-01** is *not* formalised as a third `inferred_value` producer — it is already
  the `M` input, a first-class RELAYED input the decision table itself consults (rows 2/5/8/9/10).
  Stated explicitly so this typology term is not silently dropped.

## 5. Coq — totality, decidability, refusal characterisation, and the honest monotonicity finding

`coq/canonical/PROP_FLOOD_07_flow_state.v` — `coqc -q` clean (only the same harmless pre-existing
Thai-quotation-mark comment-terminator warning already present in `PROP_FLOOD_06_outlet_coping_tier.v`),
`Print Assumptions` **"Closed under the global context"** (no axioms) on all 25 theorems.

- **Totality**: `classify_total` (trivial existence); Coq's own exhaustive pattern match over
  finite inductive types checks totality mechanically.
- **Decidable equality**: `flow_class6_eq_dec`, `flow_result_eq_dec` (plus `dh_state_eq_dec`,
  `tr_state_eq_dec`, `ctrl_state_eq_dec`, `comm_state_eq_dec`, `strength_eq_dec`,
  `coverage3_eq_dec`, `trend3_eq_dec`).
- **`REFUSED` iff all absent**: `refused_iff_all_absent` — `classify fi = Refused <-> any_present
  fi = false`, an `iff`, exactly as asked.
- **F6 whenever any input present and no full match**: a direct corollary,
  `classify_never_refused_when_present`.
- **Monotonicity of the ruled-out set — weakened, honestly**: the **unrestricted** claim ("adding
  inputs never un-rules something ruled out") is **FALSE** for this classifier, because two rows
  are genuine *overrides* that can retract a previously-asserted class: `M=BACKFLOW` (row 2) can
  force F5 over an already-asserted F1/F2/F3/F4, and `C=FAULT` (row 5) can downgrade an
  already-asserted F1/F2 to F6, whose `ruled_out` set then newly contains that very class. This
  is demonstrated as an explicit Coq counterexample, `monotonicity_fails_on_fault_veto`: a forward
  gradient + falling trend with no control declared gives **F1** (`ruled_out = {F2,F3,F4,F5}`,
  F1 itself asserted, not ruled out); learning the *same* edge's control is `FAULT` gives **F6**
  (`ruled_out = {F1,F2}`) — F1 is now ruled out, a real retraction. Per this repository's own
  `AGENTS.md` ("Record counterexamples, retractions, ... as first-class provenance") and this
  task's own instruction to weaken and say so rather than force an unprovable claim, the theorem
  actually proved, `flow_ruled_out_monotone`, is **restricted**: it holds whenever `M` stays
  `≠ BACKFLOW` and `C` stays `≠ FAULT` on both sides of the comparison — i.e., revealing only `D`
  or `T` information (never a value change, only Absent→known) never un-rules a previously
  ruled-out class. `any_present_mono` is the supporting lemma (revealing more inputs never turns a
  non-`REFUSED` edge into a `REFUSED` one).
- 8 worked `Example`s spot-check the decision table against the JSON row-by-row (all-absent
  refusal, backflow dominance, free flow, blocked-despite-gradient, blocked-survives-fault,
  fault-vetoes-free-flow, `D`-absent-still-F6, plus the two inference rules firing).

## What this is NOT

No hydraulic/discharge model beyond what PROP-FLOOD-01/04 already assert. No claim that
RULE-STALL-01/RULE-DIR-01 are physically reliable in general — they are declared consistency
conventions (INSTINCT-rule), falsifiable per the falsifier clause below, not proved sound. No claim
that the `M=BACKFLOW`-dominates / `C=FAULT`-vetoes precedence choice is itself correct — an open
calibration question for whoever operationalises this object. Not wired into
`thailand_flood_kg/tools/flowmap/flow_stall.py`'s actual runtime — that module's own docstring
already states its F1–F6 appendix "must not be used on the public web page until registered"; this
registration is the Toledo-side artifact that calls for, not a claim the runtime now calls it.

## Falsifier

A systematic mismatch between a classified F1/F2 edge and a later-confirmed non-draining outcome
(or the reverse: F3/F4 later shown flowing freely with the structure open and no fault) falsifies
the classifier's own case-table assignment for that input combination, not PROP-FLOOD-01/04's
arithmetic. A confirmed case where RULE-STALL-01/RULE-DIR-01 fires and the later-measured true
value contradicts the inferred one falsifies that specific rule's reliability and must be recorded
as a first-class counterexample before reuse on the same class of run.

Registry entry: `registry/proposals/flood_flow_state.json`
Coq: `coq/canonical/PROP_FLOOD_07_flow_state.v`
Tier: `Dr`. Status: `unverified`. Domain: `M`.
