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

---

## Addendum 2026-09-06 — BBL-193 global step recompute + BBL-192 root-ancestry fixes

Performed against the anchors named in the task: `READOUT_GENESIS_CORE.md` at commit
`082dde893b70c7500c13d463239909c99cf17f0a` (`github.com/morrocwi/readout_genesis`) followed by
`READOUT_GENESIS_UNIVERSAL_TECHNICAL_WHITEPAPER_v1.2.0.md`. Every number below is a direct
count over `registry/genesis_root.json` after the edits described here, re-derived by
re-running the same checks, not restated from the earlier pass.

### What was wrong (confirmed by direct inspection, not by re-trusting the earlier claim)

`step` in the pre-existing file was literally the row's array index (1–296 for the
`parents_0`-derived rows — verified: `step == index+1` for all 296) or `1000 + a
batch-local counter` for the `parents_1`-derived rows (verified: not a fixed offset of the
array index, i.e. genuinely a separate, uncalibrated local counter) — neither is a position
in `READOUT_GENESIS_CORE.md`'s own heading order. This is why 33 "parent step > child
step" conflicts were artefacts of two disjoint arbitrary numberings, not real ordering
violations, exactly as flagged in the task.

### Method

1. Extracted the full `## `/`### ` heading sequence of `READOUT_GENESIS_CORE.md` at the
   anchor commit (`grep -n '^## \|^### '`, 181 headings, Part I → Appendix C in document
   order) and the full `# `/`## ` heading sequence of the whitepaper v1.2.0 (92 real
   headings after dropping 2 non-heading `# canonical_data_sha256` / `# hash_scope` comment
   lines that matched the same grep pattern), and concatenated them into one global ordered
   position list (CORE positions 1–181, whitepaper positions 182–272).
2. Mapped every row's existing `step_label` (already a clean section token — `I.1`, `II.8a`,
   `V.13a`, `VI.1`, `Forced.IV`, `IX.7`, `V-A.3`, `VI-A.B5`, `AppA.9`, `AppB.2`, `weld`,
   `III.Face8`, `III.pre`, …) onto the matching CORE heading's global position, resolving
   every one of the 237 distinct labels used across the 590 rows (0 unresolved). For the
   148 whitepaper-labeled rows (`step_label` only as coarse as `WP.S<n>`), used the row's own
   `section` field instead — which already carries the finer whitepaper subsection number
   (e.g. `8.3 Discrete action`, `18. Maker–Checker epistemic firewall > 18.1 Roles`,
   `23. Reference fixtures > Fixture C — Holonomy`) — matched against the same whitepaper
   heading list; this is a *sharper* read of "section field mapped to the heading sequence"
   than `step_label` alone would give for the whitepaper rows.
3. `Forced.I..XXIV` (all 24 sit under the single `### ⬛ THE FORCED SET — I through XXIV`
   heading, position 5) and `IX.1..IX.42` (all 42 sit under the single `### Walking the
   stream…` heading, position 126) are internally ordered by their own Roman numeral / step
   number as a sub-rank at that position (`position + n/100`), since the heading grep
   cannot see a step-by-step subheading for either list.
4. Within every other shared heading position (e.g. the 33 `V.21`-labeled rows under one
   Standard-Model-DAG heading), rows are ordered by a **stable topological sort restricted
   to parent/child edges inside that same group**, falling back to the row's original
   position in `root_equations` only where no such local edge exists — this is the "ties
   broken by order within the section" rule read as: respect an already-known local
   dependency first, fall back to existing file order only when nothing else is known.
   `step` is then `heading_position + rank/max(1000, 2·group_size)` so ties never cross a
   heading boundary.
5. **Appendix C reprints.** Checked every one of the 71 `EQ-001..EQ-071` rows (all carry
   `section` starting `APPENDIX C (SM DOMAIN EQUATION STREAM)`) against the full 590-code
   set for an alias that is *itself* a separate code elsewhere in the registry (not merely an
   `RG-*.json` cross-reference into Genesis's own internal working files, which are not
   codes in this registry). Only **2 of the 71** qualify: `EQ-008` (aliases include `weld`,
   which is a separate code) and `EQ-021` (aliases include `T1`, a separate code). For both,
   `step := primary.step + 0.5` and `derived_via := "restatement"`; `EQ-021` already carried
   `parents = ["T1"]` (no change needed there). The other 69 Appendix-C rows have no
   separate primary row elsewhere in the 590 — they *are* the sole registry entry for that
   object even though the source text physically reprints them in Appendix C — so their step
   correctly uses their `step_label`'s real Part-I/II/III/V position, unchanged by this rule.

### Cycle breaks (BBL-193: "conflict = BLOCK, recorded, not silently resolved")

Edge direction convention used below: `X.parents` containing `Y` is written `X → Y` (the
direction the JSON field itself stores, child listing parent). A derivation runs forward in
the document, so a valid `X → Y` edge should point from a **later** document position `X`
back to an **earlier** one `Y` (a later-appearing object citing an earlier-established one).
An edge that instead points from an **earlier** position to a **later** one is backward and
is the artefact to delete.

1. **`EQ-029 ↔ bR_Ledger_r_B`** (mutual, direct 2-cycle). `EQ-029` (array position 28) →
   `bR_Ledger_r_B` (array position 190): earlier → later, backward, **removed**.
   `bR_Ledger_r_B → EQ-029`: later → earlier, valid, **kept**. Reason: `EQ-029` had exactly
   one parent (`bR_Ledger_r_B`); removing it makes `EQ-029` a new orphan (recorded below,
   not silently re-parented — no replacement edge is fabricated).
2. **`EQ-030 → SM_DAG → EQ-042 → EQ-041 → EQ-040 → EQ-039 → EQ-038 → EQ-037 → EQ-036 →
   EQ-030`** (9-node cycle). Every link `EQ-036→EQ-030`, `EQ-037→EQ-036`, …, `EQ-042→EQ-041`,
   `SM_DAG→…,EQ-042` is later → earlier (valid, kept). Only `EQ-030 → SM_DAG` (array
   position 29 → 211, earlier → later) is backward, **removed**. `EQ-030` had exactly one
   parent (`SM_DAG`); removing it makes `EQ-030` a new orphan (recorded below).
3. **New cycle avoided (`EQ-008 ↔ weld`), induced by rule 5 above, caught before writing the
   final file.** `weld` already carried `parents = ["EQ-008", "MQ08-stepper"]` (a pre-existing,
   undated edge). Applying rule 5's Appendix-C restatement mechanically to `EQ-008` (whose
   alias names `weld`) would add `EQ-008 → weld`, which together with the pre-existing
   `weld → EQ-008` is a direct 2-cycle, and combined with `MQ08-stepper.parents = ["EQ-008"]`
   also closes the 3-cycle `EQ-008 → weld → MQ08-stepper → EQ-008`. Resolution: `weld`
   (document position 4) cannot legitimately have `EQ-008` (document position ~10, the
   root-axiom reprint block) as a forward-pointing-then-reversed parent once `EQ-008` is
   correctly understood as textually *after* `weld` (`weld` is `## ⬛ THE ONE-LINE MASTER
   EQUATION`, the book's own front-matter identity that Appendix C's `EQ-008` explicitly
   reprints — the `section` field literally says "also THE ONE-LINE MASTER EQUATION — the
   weld"). So `EQ-008` was removed from `weld.parents` (`weld.parents` is now
   `["MQ08-stepper"]` only), and the new `EQ-008 → weld` restatement edge from rule 5 was
   **not added** for this one pair (`EQ-008` keeps only its real forcing parents `EQ-005`,
   `EQ-006`, `EQ-007`; `derived_via` stays `"forcing"`, not `"restatement"`, for this row).
   `EQ-008.step` is still set to `weld.step + 0.5` per rule 5, so the ordering guarantee the
   rule exists for (the reprint never precedes its origin) holds without the extra edge.
   This is flagged here explicitly as a documented exception to rule 5, not a silent
   deviation.

Verified after all three fixes: 0 cycles (full DFS over all 590 nodes; a Kahn's-algorithm
topological sort also visits all 590 nodes, confirming a DAG).

### L5 / Re_ep reconciliation (quoted-source evidence, per the task's instruction)

- **`L5`** — kept the `parents_0` record `parents = ["L4", "B.5"]`, `derived_via =
  "definition"`. Evidence: `READOUT_GENESIS_CORE.md` VI.2 defines `L5 GOVERNANCE` as
  `readout-not-truth · bounded-judge · machinic_core`, and its own prose gloss says "L5 —
  governance. `readout-not-truth · bounded-judge · machinic_core`. This is the top rung…".
  "bounded-judge" textually corresponds to Part VI-A's `### B.5 The Maker–Checker Epistemic
  Firewall` — the book's only defined "bounded", role-separated judging mechanism (`B.2`'s
  discussion explicitly frames Maker–Checker as asking "was the party running the gate…"
  i.e. a bounded judge). No text was found tying `L5` to `B.5`'s absence; the `parents_1`
  alternate `[L4]` (`derived_via: "composition"`) simply drops `B.5` with no textual
  counter-evidence located against including it. `B.5` is therefore the better-quoted
  candidate and is kept alongside `L4`.
- **`Re_ep`** — switched to the `parents_1` record `parents = ["SpinePDE",
  "RTPEOperatorSplit"]`, `derived_via = "domain_reading"` (was `parents_0`'s `["N3", "N5"]`,
  `"composition"`). Evidence: `READOUT_GENESIS_CORE.md` VI.3 defines `Re_ep = epistemic
  Reynolds (spread = contestedness / turbulence)` and its own prose says: "`Re_ep` is the
  diagnostic number that flags this condition cheaply, on CPU, before any large model is
  invoked — precisely the way the RTPE layer flags physical turbulence via `τ_R` without
  needing to resolve the full nonlinear cascade." RTPE is VI.1's Layer 2
  (`τ_R İ_R + L_R I_R = S_R + η_R`, the `M→0, V→0` limit of the spine PDE / `SpinePDE`) — i.e.
  `Re_ep` is explicitly analogised to, and reads off, the `SpinePDE`/`RTPEOperatorSplit`
  turbulence-relaxation split. The same passage instead ties the *other two* scalars
  explicitly elsewhere — "`F_ep` (obstruction depth) is the epistemic reading of `N3`" and
  "`k_ep` (consistency coupling) is the epistemic reading of `N2`" — never citing `N3` or
  `N5` for `Re_ep` itself. `N5` ("invariants … anomaly ratios, `2/α²`, `π`, `φ`") is not
  mentioned anywhere near `Re_ep`. So `parents_0`'s `["N3", "N5"]` has no direct textual
  support for `Re_ep` specifically, while `["SpinePDE", "RTPEOperatorSplit"]` does.

### Remaining `step ≥ max(parent step)` violations (recorded, not silently resolved)

After the fixes above, 26 violations remain (down from the 33 pre-existing artefacts, which
are void under the corrected numbering, and down from an interim 35–36 seen mid-recompute
before the intra-section topological tie-break pass below). Every one of the 26 is a
genuine cross-section forward reference — the parent's heading sits at a strictly later
global document position than the child's — not a same-section tie-break artefact (those
were eliminated by ordering same-heading rows via a local topological sort over any
in-group parent/child edges before falling back to file order). Grouped by root cause, with
quoted source lines:

**(a) `THE FORCED SET` (position 5) is a compiled results-summary that predates its own
detailed derivations later in the book — 19 violations, all `Forced.*` rows citing parents
in Part II/III/IV/V (positions 17–71):**
`Forced.I→EQ-001`, `Forced.IV→MQ08-stepper`, `Forced.V→LivingGeometry`,
`Forced.VI→ResidualsAndPotential`, `Forced.IX→EQ-007`, `Forced.XI→EQ-005`,
`Forced.XI→BridgeFormula.MassReadout`, `Forced.XII→Face.8.MetricReadout`,
`Forced.XIII→Face.3.Dispersion`, `Forced.XIV→GaugeFaces`, `Forced.XV→TermTier-gradV`,
`Forced.XVI→Face.8.MetricReadout`, `Forced.XVII→ResidualsAndPotential`,
`Forced.XVIII→Face.3.Dispersion`, `Forced.XIX→DRLAction`, `Forced.XX→GaugeFaces`,
`Forced.XXIII→ModeEquation`, `Forced.XXIV→EQ-042`. Quoted source (CORE.md, immediately under
the Forced Set heading): *"Every result below is necessity-tier: general facts about `F`/the
spine itself… **I** is the original Forcing Ledger citation (predates both verification
rounds); **II–XVI** are round 1's 15 independently re-compiled/coqchk'd confirmations,
2026-07-23; **XVII–XXIV** are round 2's 8 new confirmations…"* — the section is explicitly a
retrospective compilation citing results whose full derivation lives later in the document;
by document *position* the citation necessarily precedes the cited material even though the
logical (forcing) direction is sound.

**(b) `weld` (position 4, the book's own front-matter one-line master equation) forward-cites
`MQ08-stepper`/`τ_c = M/D` at II.1 (position 17) inside its own forcing-ledger table — 1
violation:** `weld→MQ08-stepper`. Quoted source (CORE.md, the weld section's own forcing
ledger table): *"`τ_c = M/D` | forced relation (a readout, not a dial) | ratio fixed by the
two forced coefficients | **II.1**; value is a measured memory time"* and *"The spine PDE …
(Part II) is a coarse-grain readout of `F`, not the root."* — `weld` is deliberately written
as the book's compressed opening statement and cites Part II material by section number
before Part II is formally reached.

**(c) Part III (`Twelve Faces`, positions 28–39) threads forward to Part V material
(`V.13`/`V.13a`, positions 61–62) — 2 violations:** `Face.1.Decomposition→T1`,
`Face.10.bRLedger→EQ-029`. Quoted source (CORE.md, Face 1): *"Threading the 2026-07-21
correction — the Scalar-Eigenmode Reduction Error… The 2026-07-21 finding proposes — `[Dr]`,
**pending test T1, not yet proven** — that this coupling decomposes cleanly as `L_R = L_R^(+)
+ L_R^(−)`…"* — Face 1 explicitly names and forward-references `T1` (formalised in V.13a) as
an open, pending item; the book's own "Threading the 2026-07-21 …" subheadings recur across
multiple Faces precisely to carry a cross-Part finding back and forth, by design.

**(d) `EQ-018/EQ-022/EQ-023/EQ-024/EQ-025/EQ-026` (Appendix C, `II.8a`) → objects the local
topological tie-break could not resolve because the cited object is not itself `II.8a`-labeled
— 1 violation survives after the tie-break pass:** `EQ-026→Face.10.StrictGap` (`III.Face10`,
position 37, later than `II.8a`'s position 25). `EQ-026`'s own alias is
`FaceTenReadoutChain`, i.e. it is Appendix C's reprint of material whose primary home is Face
10, not II.8a — its `step_label` reflects the wrong home section (an artefact this pass did
not correct, since fixing it would mean re-deriving a `step_label`, out of scope: "do not
touch statements or codes" and the task names only the `EQ-008`/`EQ-021` fix pattern for
Appendix C rows with a *coded-elsewhere* alias, and `Face.10.StrictGap`/`FaceTenReadoutChain`
are two different codes, not a duplicate pair).

**(e) Manual-override side effects of rule 5 (Appendix-C restatement `step = primary + 0.5`)
— 4 violations, unavoidable given the rule as specified:**
`EQ-008→EQ-005`, `EQ-008→EQ-006`, `EQ-008→EQ-007` (all `I.1`): `EQ-008` was pulled forward to
`weld.step + 0.5 = 4.5`, ahead of its *other*, real forcing parents `EQ-005/006/007` which
remain at their natural `I.1` position (~10.0). `EQ-008` genuinely has two roles — Appendix-C
reprint of `weld` **and** a forced child of `EQ-005/006/007` — and rule 5 only lets it satisfy
one of the two ordering constraints; both parents were kept (no edge deleted here, since
neither is a cycle), the resulting violation is recorded rather than silently fixed by
inventing a third step value. `EQ-035→EQ-021` (`V.13a`): `EQ-021` was pulled forward to
`T1.step + 0.5 = 62.5`, ahead of its sibling `EQ-035` which cites it as a parent and remains
at the group's natural position (~62.0).

### Summary (this addendum)

| check | result |
|---|---|
| rows | 590 |
| rows with ≥1 parent | 585 |
| primitives / orphans (0 parents) | 5 total — `EQ-001` (T3.4's sole legal root axiom), `EQ-005`/`EQ-006` (Genesis's own declared independent root axioms, unchanged from the pre-existing pass), plus `EQ-029` and `EQ-030` (newly orphaned by the two cycle-break edge removals above — not re-parented, no edge fabricated) |
| dangling parent refs | 0 |
| cycles | 0 (2 pre-existing cycles broken by removing 1 edge each; 1 further cycle that mechanical rule application would have introduced was caught before being written and avoided by skipping that one restatement edge, §"Cycle breaks" item 3) |
| topological sort | visits all 590 nodes — confirmed DAG |
| step ≥ max(parent step) violations | 26 remaining, all genuine cross-section forward references quoted above (down from 33 artefacts under the old row-index numbering, which are void) |
