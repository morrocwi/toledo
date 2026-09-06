# S3 merge log — genesis_root.parents_0/_1 → genesis_root.json

Performed by the checker (BBL-195 checker pass), 2026-09-06. Readout-not-truth: every
number below is a direct count over the files at the anchors listed, not a restatement of
a prior claim.

## Anchors (pre-merge inputs, commit `8c56b14e62d2ff89a9d0916333716c4920671d91`)
- `registry/genesis_root.json` (pre-merge, 590 `root_equations`, no `parents` field yet) — blob `1799540ba759c1630bedefa4ea9d829d41ba6d8b`
- `registry/genesis_root.parents_0.json` (296 codes, `step` 1–296) — blob `f372d8e27eae3364613237a650095b5a96bf4233`
- `registry/genesis_root.parents_1.json` (296 codes, `step` 1000–1295) — blob `e9b42066b27552d563e1bb65a5e78dfe447e3541`
- `registry/genesis_root.parents_0_conflicts.json` (33 entries, pre-existing partial step-order check on parents_0 alone) — blob `6d607d5113b10a41b4590ed75cd9f4b339ce0323`

## What was done
`registry/genesis_root.json`'s 590 `root_equations` entries each got `parents`,
`derived_via`, `step`, `step_label` attached from the union of `parents_0.json` (296 keys)
and `parents_1.json` (296 keys). Union = 590 distinct codes, matching `root_equations`
exactly (0 missing, 0 extra). Re-serialized with `indent=2` (source file used `indent=1`);
diff is formatting + the 4 new fields per entry, no other content touched — confirmed by
inspecting the diff (no entries removed/reordered content-wise).

## Overlap / unresolved conflicts (recorded, not silently resolved — BBL-193)
`parents_0.json` and `parents_1.json` share exactly 2 keys with **different** parent data:

| code | chosen (`parents_0`) | alternate (`parents_1`), NOT applied |
|---|---|---|
| `L5` | parents `[L4, B.5]`, derived_via `definition`, step 295 | parents `[L4]`, derived_via `composition`, step 1000 |
| `Re_ep` | parents `[N3, N5]`, derived_via `composition`, step 296 | parents `[SpinePDE, RTPEOperatorSplit]`, derived_via `domain_reading`, step 1001 |

Policy applied: `parents_0`'s value is the one written into `genesis_root.json` (kept in
its own real 1–296 step scale, see below); the `parents_1` alternative is preserved
verbatim on the entry under `merge_conflict_unresolved.alternate_value` rather than
discarded. **This is an open item for a human/maker decision** — the two batches disagree
on whether `L5`'s parent set includes `B.5` and on whether `Re_ep` derives by
`composition` of `N3`/`N5` or by `domain_reading` of `SpinePDE`/`RTPEOperatorSplit`. Not
resolved by this checker pass.

## Step-numbering scale mismatch (flagged, not fixed)
`parents_0.json` numbers its 296 codes 1–296 (this looks like true position in the
Genesis Step-by-Step order — matches the `step_label` Part/section tags in ascending
order). `parents_1.json` numbers its 296 codes 1000–1295 — an offset **batch-local**
counter, not a position in the same global sequence (its `step_label`s span the same
range of Parts/sections as `parents_0`'s, e.g. both contain `step_label: "VI.2"`/`"VI.3"`
entries at very different `step` integers). **126 parent references cross from a
`parents_1` code to a `parents_0` code** (e.g. `step1`→`EQ-001`, `WP.S14.Gate1`→`Gate1`);
**zero** references go the other way (`parents_0`→`parents_1`).

Consequence for the step-order check below: because every `parents_1` step (≥1000) is
larger than every `parents_0` step (≤296) by construction, a `parents_1`-child →
`parents_0`-parent edge can never trigger a "parent step > child step" violation — not
because the ordering is verified, but because the two scales don't overlap. **The 0
cross-batch violations reported below are not evidence that cross-batch ordering is
correct** — the check is not meaningful until the two scales are unified into one global
position sequence (a follow-up for whoever owns S3, not performed here: renumbering the
step field is a content decision, not a formatting one).

## Verification results

**Orphans** — codes with an empty `parents` list: `EQ-001`, `EQ-005`, `EQ-006` (3 total).
All three are Genesis's own declared root-axiom primitives (`role: "root-axiom"`,
`derived_via: "definition"`, tier `Ax`) — `E00.1` (per BBL-191/192, the designated root),
plus `E00.5` and `E00.6`, which Genesis's own text also states as independently declared
axioms rather than forced from a prior one (`EQ-002`/`EQ-003`/`EQ-004`/`EQ-007`, the other
E00.x, all carry `>=1` parent). **0 undeclared orphans.**

**Dangling parent references** — every parent named by every one of the 590 codes
resolves to another code in the same 590-code set. **0 dangling references.**

**Cycles** — DFS over the full 590-node parent graph found **2 real cycles**:
1. `EQ-029 → bR_Ledger_r_B → EQ-029` (`EQ-029.parents = [bR_Ledger_r_B]`;
   `bR_Ledger_r_B.parents = [EQ-029]` — direct mutual cycle, both from `parents_0.json`).
2. `EQ-030 → SM_DAG → EQ-042 → EQ-041 → EQ-040 → EQ-039 → EQ-038 → EQ-037 → EQ-036 →
   EQ-030` (9-node cycle: `EQ-036..EQ-042` form a `specialisation`/`definition` chain
   that closes back onto `EQ-030` via `SM_DAG`; all 9 nodes are `parents_0.json` codes).

Both are genuine data errors in `parents_0.json`'s parent assignments, not an artifact of
the merge (verified by reading each node's `parents` field directly, see above) — **BLOCK**.

**Step order (`step >= every parent's step`)** — 33 violations, all **within**
`parents_0.json` (same-batch; the pre-existing `genesis_root.parents_0_conflicts.json`
lists exactly these 33 and was independently re-derived here, confirming that file). 0
violations were found crossing the batch boundary, but per the scale-mismatch note above
that null result is not informative. Full same-batch list (parent's document position is
later than the child that cites it — i.e. by document order the child appears to use a
concept indexed at a higher step number than itself):

```
EQ-015 (step 15, II.3) has parent SpinePDE (step 103, II.3)
EQ-016 (step 16, II.7) has parent ModeEquation (step 113, II.7)
EQ-017 (step 17, II.8) has parent SpinePDE (step 103, II.3)
EQ-017 (step 17, II.8) has parent Telegraph (step 101, II.2)
EQ-018 (step 18, II.8a) has parent LivingGeometry (step 115, II.8a)
EQ-021 (step 21, V.13a) has parent T1 (step 194, V.13a)
EQ-022 (step 22, II.8a) has parent ReaderRecordEqs (step 120, II.8a)
EQ-023 (step 23, II.8a) has parent ResidualsAndPotential (step 121, II.8a)
EQ-024 (step 24, II.8a) has parent GaussJordanStepper (step 122, II.8a)
EQ-025 (step 25, II.8a) has parent GaussJordanStepper (step 122, II.8a)
EQ-026 (step 26, II.8a) has parent Face.10.StrictGap (step 146, III.Face10)
EQ-029 (step 29, V.13) has parent bR_Ledger_r_B (step 191, V.13)
EQ-030 (step 30, V.21) has parent SM_DAG (step 212, V.21)
EQ-044 (step 44, V.22) has parent UnifiedForce_action (step 213, V.22)
EQ-060 (step 60, V.21) has parent ModeEquation (step 113, II.7)
EQ-061 (step 61, V.21) has parent GaussJordanStepper (step 122, II.8a)
EQ-063 (step 63, IV.1) has parent BridgeFormula.MassReadout (step 153, IV.1)
weld (step 72, weld) has parent MQ08-stepper (step 99, II.1)
IV (step 76, Forced.IV) has parent MQ08-stepper (step 99, II.1)
V (step 77, Forced.V) has parent LivingGeometry (step 115, II.8a)
VI (step 78, Forced.VI) has parent ResidualsAndPotential (step 121, II.8a)
XI (step 83, Forced.XI) has parent BridgeFormula.MassReadout (step 153, IV.1)
XII (step 84, Forced.XII) has parent Face.8.MetricReadout (step 142, III.Face8)
XIII (step 85, Forced.XIII) has parent Face.3.Dispersion (step 132, III.Face3)
XIV (step 86, Forced.XIV) has parent GaugeFaces (step 104, II.4)
XV (step 87, Forced.XV) has parent TermTier-gradV (step 110, II.6)
XVI (step 88, Forced.XVI) has parent Face.8.MetricReadout (step 142, III.Face8)
XVII (step 89, Forced.XVII) has parent ResidualsAndPotential (step 121, II.8a)
XVIII (step 90, Forced.XVIII) has parent Face.3.Dispersion (step 132, III.Face3)
XIX (step 91, Forced.XIX) has parent DRLAction (step 118, II.8a)
XX (step 92, Forced.XX) has parent GaugeFaces (step 104, II.4)
XXIII (step 95, Forced.XXIII) has parent ModeEquation (step 113, II.7)
Face.1.Decomposition (step 128, III.Face1) has parent T1 (step 194, V.13a)
```

Per BBL-193 ("conflict = BLOCK, recorded, not silently resolved") these 33 are recorded
here, not corrected — correcting them would mean either renumbering `step` to reflect
logical/derivation order (a content decision for S3) or re-deriving the parent list,
neither of which this checker pass performs.

## Summary
| check | result |
|---|---|
| merge coverage | 590/590 codes attached, 0 missing, 0 extra |
| unresolved merge conflicts | 2 (`L5`, `Re_ep`) — recorded on-entry, not resolved |
| orphans (excl. declared primitives) | 0 |
| declared primitives | 3 (`EQ-001`, `EQ-005`, `EQ-006`) |
| dangling parent refs | 0 |
| cycles | **2 — BLOCK** |
| step-order violations (same-batch, real) | 33 — recorded, BLOCK-worthy per BBL-193 |
| step-order violations (cross-batch) | 0 reported, but check is not meaningful (scale mismatch) — flagged |
