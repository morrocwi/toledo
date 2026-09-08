# Toledo Internal-Consistency Specification v0.1 (IC ladder)

Status: architecture specification for the equation-clearing team. Written 2026-09-08 against
checkout `270c2af` (`registry/CANONICAL.json` `generated_from_commit`
`9ca306cf3bc9e6efe4ee5456ee6449abae0cb42a`, `schema_version 1.0.0`). Base design:
`ops/clearing/proposal_3.md` (selected), with the grafts the judges requested from
`ops/clearing/proposal_1.md` and `ops/clearing/proposal_2.md` folded in and marked `[P1]` / `[P2]`
where they change the base.

Founder instruction (2026-09-08, verbatim): "ultracode ตั้งทีมชำระสมการด้วย เพื่อให้ telodo
เป็นระบบสมการที่แข็งแกร่ง และแยกความแม่นยำในตัวเองอย่างน้อยที่สุดต้องสอดคล้องภายในในตัวเองอย่างเป็นระบบ"
— set up an equation-clearing team so Toledo is a strong equation system, and separate its
internal precision: at minimum it must be systematically self-consistent.

Every count in this document was produced by a command run in this checkout on 2026-09-08
(Appendix A). They describe this checkout, not a permanent state; the grader re-reads them on
every run and the spec never becomes the source of a number.

---

## 0. Scope and the two ladders

**Internal consistency (IC)** is the registry agreeing with *itself*: fields with the schema,
fields with each other, statements with the Coq files they point to, edges with the statements
they connect, symbols with one declared sense, documentation with the values the data actually
uses. It is orthogonal to the **resistance ladder R0–R6** (README "Resistance ladder R0–R6 and
reproduction evidence"; `registry/SCHEMA.md`, "Addendum 2026-09-08 (S3, Resistance Ladder +
Reproduction Ledger)"), which is evidence against the world. An entry can be IC-3 and R0; an entry
can be R4 and IC-0. Neither ladder collapses into the other and neither is ever rendered as one
number. No file named `RESISTANCE_LADDER*.md` exists in this checkout (`find` returns nothing);
the README section and the SCHEMA addendum are the citable definitions.

Three states that must never be confused, per entry and per dimension:

1. **not checked** — no grader has run this dimension on this entry at this commit;
2. **checked, finding open** — a grader ran and found a named disagreement;
3. **checked, consistent to rung k** — every dimension at rungs 1..k passed; reader-only cells
   above k are recorded as `needs_reader`, never as `pass`.

---

## 1. The consistency ladder

| Grade | Meaning | Evidence that earns it | Who can award it |
|---|---|---|---|
| **IC-0** | Not checked, or the record is older than the entry's last LINEAGE event. | none (default) | nobody |
| **IC-1 shape-consistent** | Every mechanical structural cell passes: `schema`, `structure`, `tier` (mechanical half), `lineage` (mechanical half). | sidecar with those cells `pass`, `grader_commit == HEAD`, no `block`-severity finding on the entry | grader |
| **IC-2 text-consistent** | IC-1 plus every deterministic text cell passes: `symbols` (mechanical half), `coq` (mechanical half), `duplicates` (mechanical half, including the structural fingerprint). | as above plus fingerprint status `parsed` or the entry's unparsed status disclosed (an `unparsed` entry cannot hold IC-2) | grader (one `coqc` at a time for `coq`) |
| **IC-3 reader-cleared** | IC-2 plus every reader cell of this entry cleared by an independent reader **and** countersigned by a second reader of a different role `[P2 C5]`. | `ops/clearing/clearances.jsonl` rows for every `needs_reader` cell, each with a quote, `reviewer_role`, `independence_check`, and a `countersign` row with `countersigner_role != reviewer_role`; none `stale` (§6.3) | readers; the grader only verifies the rows |
| **IC-F** (flag, not a rung) | Checked; at least one finding open. `grade` stays at the highest rung whose cells all pass; `blocked_at` names the lowest failing `{rung, dimension, finding_id}`. | the finding record | grader or reader |

Rules:

- A rung is earned only by *all* its cells passing. A cell recorded `pass` with
  `evidence.not_applicable` (reason string) counts as pass (e.g. `symbols.dimension` on a
  non-physical statement).
- No rung is ever earned by a `needs_reader` or `not_checked` cell. IC-2 is the ceiling a script
  can award. IC-3 needs clearance rows and a countersign; it is never inferred.
- Any LINEAGE event on a code (`assigned | revised | retired | merged | split | occurrence_added |
  status_changed`) after `grader_commit` resets the code to IC-0 on the next run; clearance rows
  older than the last `revised` event on the code are `stale` (§6.3) and drop the cell back to
  `needs_reader`.
- No corpus-level sentence is a claim about ungraded entries. The README may say "IC-2: n of
  1,273 readings; IC-3: m; not checked: k" — never "Toledo is self-consistent". Readings and root
  rows are reported in **separate histograms** `[P1 §6]` (root rows are thinner: today 233 of 610
  root rows carry only a free-text `tier_in_genesis` and no normalised `tier`).

---

## 2. The seven audit dimensions

Seven dimensions, one auditor each. Each dimension has **cells**; a cell is `M` (mechanical: a
deterministic function of the files in the checkout and, for `coq`, of `coqc`'s printed output),
`R` (reader: requires reading a source and judging meaning), or `M→R` (the script computes
candidates, a reader decides). Each cell states its rung and its exact pass rule. "Today" figures
are from Appendix A.

Dimension keys (the JSON keys used everywhere): `schema`, `structure`, `tier`, `symbols`, `coq`,
`duplicates`, `lineage`.

### 2.1 `schema` — documentation ⇄ data agreement (M, rung 1)

Inputs: `registry/CANONICAL.json`, `registry/genesis_root.json`, `registry/LINEAGE.jsonl`,
`registry/SCHEMA.md` (enum tables parsed from the file), `README.md` (LINEAGE event kinds, status
list), `docs/EQ_CODE_SCHEME.md`.

| cell | pass rule |
|---|---|
| `schema.enum_values` | every value of `layer`, `domain`, `status`, `tier`, `coq.coq_status`, `statement.format`, `origin.source`, `parents[].derived_via`, `relations[].type`, `role` is listed in SCHEMA.md or in a dated SCHEMA addendum. Today off-enum: `derived_via` `split` 170, `refines` 29, `special_case_of` 1; `relations.type` `relates-to` 75, `shares-noncollapse-with` 11, `parallels` 7; `statement.format` `prose` 1; `origin.source` free-text values (P3 D1: 84 entries). |
| `schema.lineage_kinds` | every `event` in LINEAGE.jsonl is in README's list. Today: `status_changed` (9 events) is used but not listed. |
| `schema.required_fields` | every documented required field present with the documented type; three-state fields (`owner_year`, `drift_note`, `name_latex`) are never `null`. |
| `schema.counts` | `counts{}` equals a fresh recount. |
| `schema.root_edge_kind` | every root-layer `parents` edge carries a `derived_via`. Today: all 767 root edges are bare strings ⇒ finding, class D (needs ruling R-2). |

**Class A vs class B decision — the rule of least mechanism `[P2 §4.1]`:** for an off-enum value,
if a LINEAGE event on the code already explains the value (e.g. the 170 `split` edges are
explained by the 31 `split` events of the N4 split pass), the fix is a dated SCHEMA addendum
admitting the value (class A, no LINEAGE event). If no event explains it, the fix is a LINEAGE
`revised` event that either renames the value onto the enum or admits it with a quoted reason
(class B). The auditor records which branch applies in `proposed_fix.rationale`.

### 2.2 `structure` — referential and structural integrity (M, rung 1)

| cell | pass rule |
|---|---|
| `structure.parents_resolve` | every `parents[].code` resolves to a canonical entry or a root row. Today 0 violations. |
| `structure.code_root` | code prefix before `/` equals `root`. Today 0. |
| `structure.children_inverse` | `children[]` equals the inversion of `parents[]`. Today 0. |
| `structure.history_top` | `statement.latest` equals the highest-`v` `statements_history` row. Today 0. |
| `structure.status_note` | `status != current` ⇒ non-empty `status_note`; `superseded_by` resolves, no 2-cycle; `split` ⇒ `split_children` present and each child carries a `split` edge back. Today 0. |
| `structure.coq_file_present` | `coq.file` set ⇒ file exists on disk; `coq.identifier` set ⇒ the identifier text occurs in that file. Today 0 missing files (1,194 set). |
| `structure.r2_iff_closed` | `resistance.rungs.R2.held ⇔ coq.coq_status == closed`. Today 0. |
| `structure.occurrence_map` | every `occurrences[].raw_key` maps in `raw_to_canonical` to this code **or to one of this code's own `split_children`** (the convention in the data: all 153 cross-maps are that case). Encode explicitly or 153 false findings result. Info row, not a finding: 157 codes carry zero occurrences. |
| `structure.alias_collision` | no alias equals another code. Today 0. |
| `structure.primary_root` `[P1 D2.3]` | exactly one parent whose code prefix equals the entry's own `root`. Today, by the probe in Appendix A: 193 readings have a count ≠ 1 under this literal rule and 16 readings have at least one cross-root parent (the judges' brief cites 20 — a different counting; the grader's own count is the number). Until the founder states the rule, every such entry is recorded with finding `status: needs_ruling`, severity `warn`, not `block`. |
| `structure.first_assigned_order` `[P2 D6]` | when child and parent are both `.v1`, `child.first_assigned >= parent.first_assigned`. Today 0 violations. |
| `structure.closed_reported` `[P1 D3.5]` | `coq.coq_status == closed` ⇒ the entry's own wrapper theorem appears as `PASS <mangled-module>.<theorem> -- Closed under the global context` in the last recorded `coq/canonical/verify_report.txt`. Otherwise finding `closed-unreported`. Today the recorded report is the scoped v1.7 run (276 lines, 274 PASS rows) while 551 entries are `closed`, so at least 277 entries are `closed-unreported` on day one; the fix is one full-arc `verify.sh` run recorded before the release commit (class A: regenerated evidence), never a per-edit re-run. Note: the identifier to match is the Theorem name in the entry's own file, **not** `coq.identifier` (which for `restates` wrappers names the imported identifier — matching on it reports all 551 as unreported, a probe artefact). |

### 2.3 `tier` — tier / status / coq_status honesty (M→R; mechanical rung 1, reader rung 3)

Inputs: the compatibility table (Appendix B, from P3 Appendix B) plus the status overlay.

| cell | pass rule |
|---|---|
| `tier.cell_table` (M) | the triple (`tier`, `status`, `coq.coq_status`) is not a `finding` cell of Appendix B. Today: `Th_coqc × not_formalisable` 8; `Th_coqc × wrapped_related` 9. A `finding` cell whose `status` is `unverified` with a dated `status_note` is `ok` (already disclosed). |
| `tier.unverified_not_closed` (M) `[P2 D7]` | `status == unverified ⇒ coq_status != closed`. Today **7** entries violate it. Explicit finding, class B or D: either the status note is stale (move to `current`, `status_changed` event) or `closed` is over-claimed — the auditor lists the 7 with their `status_note` text and parks the item in `RULINGS_REQUESTED.md`. |
| `tier.witness_not_statement` (M→R) | for `reader` cells (`Definition`/`Dr × closed`, today 93; `Ax × closed` 2; `untagged × closed` 42) the reader answers with a quote: "is the identifier reported closed the entry's own statement or a supporting witness?". Candidate list generated mechanically `[P1 D4.4]`: wrapper files whose header carries a `Witness` tag (58 of 1,202 files today), theorem names matching `_zero_signal`, `_identity`, `_witness`, `_faithful` (3 entry names match today), placed at the head of the R-3 reader queue. |
| `tier.tier_evidence` (M) | a `tier` set or changed after initial import carries `tier_evidence {quote, source, line, commit}` (SCHEMA v1.1 addendum). |

### 2.4 `symbols` — symbol spelling, sense, reserved symbols, dimension (M→R, rung 2; sense rung 3)

Inputs: `statement.latest` / `statement.ascii` / `statement.latex` per format; reader glossary rows
`ops/clearing/glossary/<mangled root>.json`; unit declarations `ops/clearing/units.json`.

| cell | pass rule |
|---|---|
| `symbols.spelling` (M) | within one (root, domain) group every normalised symbol (Greek ASCII↔Unicode, `_{x}`/`_x`, `^{x}`/`^x`, `\text{}` stripped) has one spelling. P3's probe: 20 groups mix spellings today. Fix class B (LINEAGE `revised`, no `.v` bump under proposed R-1). |
| `symbols.registry` (M) `[P1 D6.2]` | the grader writes `ops/clearing/symbols/<mangled root>.json`: `{root, generated_at_commit, symbols: {normalised: {spellings: [...], codes: [...], domains: [...], kind: "variable|constant|operator|relation|unknown", arity: int|null}}}` — a readout, never hand-edited. |
| `symbols.reserved` (M) `[P1 D6.3]` | the reserved programme symbols `δ_R, L_R, D_W, W, q_D, F, Φ, λ_c, Θ` carry one `kind` and one `arity` corpus-wide (across roots). A second kind/arity ⇒ finding, class D (definition-of-a-symbol ruling). Every other symbol is per (root, domain). |
| `symbols.sense` (R) `[P2 §3.2]` | every symbol token of the entry resolves to exactly one glossary row `{symbol, root, domain|"*", sense, dimension|null, first_defined_in, aliases, note, signed: {reviewer_role, date, commit}}` for its (root, domain); two rows with the same symbol and domain and different `sense` ⇒ finding. A row whose `first_defined_in` code has a LINEAGE `revised` event after `signed.commit` is flagged `stale` by the grader and the cell returns to `needs_reader`. |
| `symbols.dimension` (M with a declaration) | for a code declared in `units.json` as `{symbol → exponent vector over (M, L, T, Θ, N, I, J)}` (integers or `"p/q"` strings, no floats), both sides of every relation carry equal vectors and transcendental arguments are dimensionless. Declared `non_physical`/`dimensionless` or outside the physical scope (the 123 `domain_registry` named-law entries plus any reader-declared entry) ⇒ `pass` with `evidence.not_applicable`. The grader never invents units. |
| `symbols.contradiction_candidates` (M→R) | candidates for cross-entry contradiction from the symbol table: (a) same normalised LHS defined (`:=`/`=`) with different RHS in one (root, domain); (b) `X ≠ Y` / `\not\equiv` in one entry and `X = Y` in another for the same normalised pair. The verdict is a reader row (`no_contradiction` with reason / `contradiction` / `same_object_unlinked` → routes to `duplicates`). |

### 2.5 `coq` — statement ⇄ Coq file agreement (M rung 2; R rung 3)

One `coqc` at a time; check `docs/RAM_LOW` before every launch; if it exists the cell is
`not_checked` with `evidence.reason: "RAM_LOW"`. No full-arc `verify.sh` inside the loop.

| cell | pass rule |
|---|---|
| `coq.identifier_present` (M) | `coq.identifier` occurs in `coq.file`; header `parents:` list equals `parents[].code`. |
| `coq.forbidden` (M) | no `Coq.Reals`, `Classical`, `Admitted`, `Axiom` in a Toledo-native wrapper (the existing rule). |
| `coq.restates_shape` (M) `[P1 D4.2]` | for `statement.format == coq` (393 entries) and a `restates` wrapper: the wrapper Theorem's type is `ltac:(let t := type of X in exact t)` (or textual copy) with `X == coq.identifier`, and its proof is `exact X` — then `statement.latest` must equal X's own declaration text modulo whitespace, read from the imported source file named by `coq.imported_from`. No `coqc` needed. Today 365 of the 393 use the `type of` shape, so the scratch-`coqc` path is needed for at most 28 + non-shape cases. |
| `coq.type_matches` (M, scratch `coqc`) | fallback for a `coq`-format entry not in the `restates_shape` case: `Check @<wrapper_theorem>.` in a scratch file, compare the printed type to `statement.latest` modulo whitespace and notation scope. |
| `coq.header_quotes` (M, non-`coq` formats, 801 entries with a file) | wrapper header quotes `statement.latest` verbatim or names its `id`; every free symbol of the statement appears as a Variable/Parameter/Definition name or in the header mapping comment. |
| `coq.encodes_structure` (R) | "does the Definition/Prop encode the operator structure of the statement, not merely its symbol list?" — quote the line that does. |

### 2.6 `duplicates` — hidden duplicates and pairwise contradictions (M→R, rung 2; verdict rung 3)

Candidate methods, each a sub-cell:

| method | pass rule |
|---|---|
| `duplicates.exact` (a) | no other `current` code has whitespace-stripped identical `statement.latest`. Today 3 groups: `EQ-001/P.02.v1`+`EQ-001/B.02.v1`; `Keystone/P.01.v1`+`P.16.v1`+`M.04.v1`; `Keystone/P.17.v1`+`M.05.v1`. |
| `duplicates.normalised` (b) | same after `symbols` normalisation. |
| `duplicates.identifier` (c) | same `coq.identifier` + same `root` ⇒ group. |
| `duplicates.fingerprint` (e) `[P1 §3.4]` — **replaces token-set Jaccard** | structural fingerprint: strongest text (`coq` if format is coq, else `ascii`, else `latex`) → tokens (identifier+sub/superscript as one atom; `\text{}`/English runs to a side list) → operator tree per clause → α-rename variables in order of appearance (`x1, x2, …`), numeric literals → `c_k` (literal recorded), drop a leading positive scalar factor on each side of a relation, sort children of commutative operators → `sha256` of the canonical serialisation. Equal fingerprints ⇒ φ-equivalent under README's criterion (renaming, positive scale, constant substitution). The parser refusing a statement is finding class `unparsed` (severity `info`), never a pass; the **unparsed fraction is reported as a number** in `INDEX.json` and is the honest ceiling on IC-2 text coverage. |
| `duplicates.identical_name` (f) `[P2 D4]` | groups of `current` entries with byte-identical `name` (P2 reported 6; the Appendix A probe counts 5 today — the grader's count is the number) — reader-only candidates. |
| `duplicates.linked` (pass condition) | an entry in any (a)/(b)/(c)/(e) group passes only if the group is already linked by a `same_object`/`restates` edge or a `merged` LINEAGE event with `phi_criterion_evidence`. Cross-root fingerprint matches are listed, never auto-merged (may be a legitimate `same_form_different_theory`). |
| `duplicates.contradiction` (R) | the reader verdict on `symbols.contradiction_candidates` pairs touching this entry (`no_contradiction`/`contradiction`/`same_object_unlinked`). |

### 2.7 `lineage` — derivability of every declared edge (M rung 1; R rung 3)

Shape test per `derived_via`, using fingerprints from `duplicates` `[P1 D8]`:

| edge kind | mechanical shape test |
|---|---|
| `restates` / `same_object` | child fingerprint == parent fingerprint (else `needs_reader`). Today: 27 reading→reading `restates` edges, 0 with identical text. |
| `specializes` / `special_case_of` | child fingerprint is a **substitution instance** of the parent's (unification over the symbol table), not merely symbol-subset `[P1 D8.3]`. |
| `split` | parent `status == split`, child in `split_children`, child carries the `split` edge back, and the **union of the children's fingerprints covers the parent's** `[P1 D8.4]` (170 edges, 30 split entries). |
| `refines` | no semantics documented anywhere ⇒ `needs_ruling` until R-5 defines it (29 edges). |
| `reads` from a reading | free-symbol intersection non-empty (else `needs_reader`). |
| `reads` from a root | always a reader row, sampled: every edge on an entry with another open finding plus a fixed-seed 10 % per root; coverage stated as "cleared edges / total edges". |
| root-layer edge (no `derived_via`) | `needs_reader`, never `pass`, until R-2 (767 edges). |

Reader cell `lineage.quote`: "quote the sentence in the child's source that shows it
reads/restates/specialises the parent" — the evidence standard `registry/GENESIS_CODE_SCHEME.md`
already demands for root connections.

---

## 3. Finding record format

Every finding, mechanical or reader-raised, is one JSON object:

```json
{
  "id": "structure.closed_reported#3f9a2c1d",
  "codes": ["EQ-015/M.01.v1"],
  "severity": "block",
  "claim": "coq_status is closed but no PASS row for EQ_015__M_01_v1.<theorem> exists in the last recorded coq/canonical/verify_report.txt",
  "evidence": {
    "command": "python3 scripts/ic_grader.py --dimension structure --cell closed_reported --code EQ-015/M.01.v1",
    "observed": "report rows matching module EQ_015__M_01_v1: 0",
    "expected": "at least one 'PASS EQ_015__M_01_v1.<theorem> -- Closed under the global context' row",
    "files": ["registry/CANONICAL.json", "coq/canonical/verify_report.txt"],
    "rule": "docs/CONSISTENCY_SPEC_v0_1.md sec.2.2 structure.closed_reported"
  },
  "proposed_fix": {
    "class": "A",
    "action": "record a full-arc verify.sh report before the release commit",
    "rationale": "evidence regeneration; no content field changes",
    "ruling_ref": null
  },
  "mechanical": true,
  "dimension": "structure",
  "status": "open"
}
```

- `id` = `<dimension>.<cell>#<leading 8 hex of sha256(cell + "\n" + "\n".join(sorted(codes)) + "\n" + observed)>` — deterministic, so the same finding has the same id on every run and disappears from the diff when fixed. Never date-based.
- `severity` ∈ `block` (denies the rung the cell belongs to) | `warn` (recorded, does not deny a rung — used for `needs_ruling` items) | `info` (readout only, e.g. zero-occurrence codes, `unparsed`).
- `evidence` **always** carries `command`, `observed`, `expected` `[P1 §3.2]`; reader findings add `quote` and `source`.
- `proposed_fix.class` ∈ `A | B | C | D` (§5); class D findings carry `status: needs_ruling` and `ruling_ref` once a ruling id exists.
- `mechanical` is `true` iff two people running the command on the same commit get the same `observed`.
- `status` ∈ `open | fixed | accepted | ruled | needs_ruling | unparsed | stale`.

**Determinism:** every findings file and every sidecar is written with `sort_keys=True`,
`indent=1`, `ensure_ascii=False`, findings sorted by `id`, codes sorted; the only timestamp is in
the file header (`computed_at`). Two runs on one commit are byte-identical; a fix shows as a diff
between commits.

---

## 4. Sidecar layout (the registry-side readout)

Per R-4 the grade is **not** written into `registry/CANONICAL.json` or `registry/genesis_root.json`.
It lives in a sidecar directory the grader alone writes (same discipline as
`registry/executable/`):

```
registry/consistency/
  INDEX.json
  <mangled code>.json        e.g. EQ_015__M_01_v1.json, EQ_001.json (root rows too)
```

`<mangled code>` uses the SCHEMA.md Coq mangling rule (`/`→`__`, `.`→`_`, `-`→`_`).

Per-code sidecar:

```json
{
  "code": "EQ-015/M.01.v1",
  "layer": "reading",
  "grade": "IC-1",
  "flag": "IC-F",
  "blocked_at": {"rung": "IC-2", "dimension": "duplicates", "finding": "duplicates.exact#8b1c0e44"},
  "dimensions": {
    "schema":     {"status": "pass",         "evidence": {"cells": {"enum_values": "pass", "lineage_kinds": "pass", "required_fields": "pass", "counts": "pass", "root_edge_kind": "pass"}}},
    "structure":  {"status": "pass",         "evidence": {"cells": {"...": "pass"}}},
    "tier":       {"status": "needs_reader", "evidence": {"cells": {"cell_table": "pass", "unverified_not_closed": "pass", "witness_not_statement": "needs_reader", "tier_evidence": "pass"}, "queue": ["tier.witness_not_statement#EQ_015__M_01_v1"]}},
    "symbols":    {"status": "pass",         "evidence": {"cells": {"spelling": "pass", "reserved": "pass", "sense": "needs_reader", "dimension": "pass"}, "not_applicable": {"dimension": "non_physical (default; not in units.json)"}}},
    "coq":        {"status": "pass",         "evidence": {"cells": {"restates_shape": "pass"}, "coqc": "not needed (restates shape)"}},
    "duplicates": {"status": "fail",         "evidence": {"cells": {"exact": "fail", "fingerprint": "parsed"}, "findings": ["duplicates.exact#8b1c0e44"]}},
    "lineage":    {"status": "needs_reader", "evidence": {"cells": {"reads_root": "needs_reader"}, "edges_total": 1, "edges_cleared": 0}}
  },
  "findings": ["duplicates.exact#8b1c0e44"],
  "clearances": [],
  "computed_at": "2026-09-08",
  "grader_commit": "270c2af…",
  "last_lineage_event": {"event": "revised", "date": "2026-09-07", "by": "toledo-v1.7-wrap"}
}
```

- `dimensions.<key>.status` ∈ exactly `pass | fail | not_checked | needs_reader`. A cell that
  cannot run (`coqc` unavailable, `docs/RAM_LOW` present) is `not_checked` with
  `evidence.reason`; a not-applicable cell is `pass` with `evidence.not_applicable`. A dimension
  is `fail` if any cell fails, else `needs_reader` if any cell needs a reader, else `not_checked`
  if any cell did not run, else `pass`.
- `grade` is derived from `dimensions` by §1; the sidecar never carries a score, percentage or
  total.
- `computed_at` is a date; the full timestamp lives only in `INDEX.json`'s header.

`registry/consistency/INDEX.json`:

```json
{
  "schema_version": "consistency-index-0.1",
  "computed_at": "2026-09-08T00:00:00Z",
  "grader_commit": "270c2af…",
  "registry_commit": "9ca306c…",
  "histogram": {
    "readings": {"IC-0": 0, "IC-1": 0, "IC-2": 0, "IC-3": 0, "IC-F": 0, "total": 1273},
    "roots":    {"IC-0": 0, "IC-1": 0, "IC-2": 0, "IC-3": 0, "IC-F": 0, "total": 610}
  },
  "by_dimension": {"schema": {"pass": 0, "fail": 0, "not_checked": 0, "needs_reader": 0}, "...": {}},
  "fingerprint": {"parsed": 0, "unparsed": 0, "unparsed_fraction": "0/1273"},
  "reader_coverage": {"root_reads_edges_total": 767, "root_reads_edges_cleared": 0},
  "findings_open_by_class": {"A": 0, "B": 0, "C": 0, "D": 0},
  "entries": [{"code": "…", "grade": "IC-1", "flag": null, "sidecar": "registry/consistency/EQ_015__M_01_v1.json"}]
}
```

Root rows are graded on `schema`, `structure`, `tier` (mechanical half), `duplicates` (a)/(b)/(e)
and `lineage` only (no Coq file of their own); `coq` and `symbols.dimension` are `pass` with
`evidence.not_applicable: "root row"`.

---

## 5. Fix policy

**Mechanical fixes go through exactly one idempotent script, `scripts/v18_clearing_fixes.py`.**
Auditors never edit `registry/CANONICAL.json`, `registry/genesis_root.json`,
`registry/LINEAGE.jsonl`, any `coq/` file or any deposited source. The script:

- takes `--finding <id>` (or `--class A`) and `--dry-run`; prints the exact field diff and the
  LINEAGE event it will append; is idempotent (a second run on the same finding is a no-op and
  says so);
- **appends** LINEAGE events, never edits or reorders existing lines; every event's `reason`
  cites the finding id and this spec's section; `by` is a role string (`registrar`), never a
  person or vendor name;
- refuses any statement-text change without a `revised` event **and** a `statements_history` row
  (**statement changes are never silent**); refuses any class C/D change without the
  `ruling_ref` / `phi_criterion_evidence` the class requires;
- is run only by the registrar lane, after an auditor's finding file has been reviewed by a
  second role (maker-checker; the auditor who found it does not run the fix on it).

| Class | What | Ledger |
|---|---|---|
| **A — documentation / computed** | dated SCHEMA/README addenda admitting values the data already uses (with counts and earliest-use commit); regenerating `children[]`, `counts{}`, `resistance`, `verify_report.txt`, the `registry/consistency/` sidecars. Never touches a content field. | no LINEAGE event; commit message cites finding ids |
| **B — content-neutral edits** | symbol-spelling unification (`symbols.spelling`); wrapper header fixes; `status` moves SCHEMA already prescribes (`Th_coqc × wrapped_related` ⇒ `unverified` + note). | `revised` / `status_changed` event citing the finding; history row; **no `.v` bump** for pure notation only once R-1 is ruled — until then, class B statement edits wait |
| **C — identity / lineage** | merging duplicates; adding, retyping or removing a `parents[]` edge; `same_object` links; retiring a code. | `merged`/`revised`/`retired` with `phi_criterion_evidence` or the quoted source sentence; needs a reader clearance row beforehand |
| **D — founder-only rulings** | the meaning of any ladder word (`closed`, `Th_coqc`, `definition`); raising any `tier`; any root-layer `parents` change; R-1..R-5; the D8 unit conventions; the 93 `Definition`/`Dr × closed` cells; the 7 `unverified × closed` entries; the primary-root rule; reserved-symbol kinds; cross-domain identical-statement policy; anything touching a deposited source. | finding `status: needs_ruling` until a BBL/DECISIONS row exists; then `ruled` with `ruling_ref`; the LINEAGE event names the ruling id |

**Founder ruling packet — `ops/clearing/RULINGS_REQUESTED.md`, shipped day one** `[P2 §4.3]`,
regenerated by `scripts/ic_grader.py --rulings` from every class-D finding plus the fixed items:
R-1 (no `.v` bump for pure notation), R-2 (root-layer `derived_via`, incl. a `document_order`
value), R-3 (`Definition`/`Dr × closed`: witness vs statement), R-4 (adopt the IC ladder as a
sidecar; promote to a SCHEMA field only after one independent re-derivation), R-5 (`refines`
semantics), plus P2's items: (a) admit-or-rename the off-enum `derived_via`/`relations` values,
(b) the 7 `unverified × closed` entries, (c) `Keystone/P.01.v1` = `Keystone/P.16.v1` (same root,
same domain) merge, (d) cross-domain identical-statement policy (`EQ-001/P.02.v1` vs `B.02.v1`),
(e) the primary-root rule and its today-count. A class-D finding is parked visibly there; the
clearing team never accepts one on its own.

---

## 6. Readers, clearances, countersign, staleness

### 6.1 Roles only `[P2 §3.1]`

Every human or agent identity in `ops/clearing/` is a **role**: `registrar`, `reader-A`,
`reader-B`, `AI assistant`, `founder`. No personal name, vendor name, model name, session id or
path ever enters a clearance, finding, glossary row, or ruling packet. The grader rejects any
row whose `reviewer_role`/`countersigner_role` is outside that enum.

### 6.2 Clearance rows — `ops/clearing/clearances.jsonl` (append-only, readers write, grader reads)

```json
{"code": "EQ-015/M.01.v1", "dimension": "tier", "cell": "witness_not_statement", "edge": null,
 "verdict": "witness", "quote": "Witness (tier: Th_coqc) … CAN_002_root_state_tuple_faithful",
 "source": "coq/canonical/EQ_015__M_01_v1.v:12", "reviewer_role": "reader-A",
 "independence_check": {"lineage_by_set": ["toledo-n4-merge", "toledo-v1.1-checker"], "reader_in_set": false},
 "commit": "270c2af…", "date": "2026-09-08", "kind": "clearance"}
{"code": "EQ-015/M.01.v1", "dimension": "tier", "cell": "witness_not_statement",
 "countersigner_role": "reader-B", "agrees": true, "note": "", "commit": "270c2af…",
 "date": "2026-09-08", "kind": "countersign"}
```

IC-3 on an entry requires, for every `needs_reader` cell: one `clearance` row whose
`reviewer_role` is not in the code's LINEAGE `by` set, **and** one `countersign` row with
`countersigner_role != reviewer_role` `[P2 C5]`. Same-role self-approval is not a check.

### 6.3 Staleness (grader function, not trust) `[P2 §3.1]`

A clearance, countersign, or glossary row whose `commit` predates the entry's last LINEAGE
`revised`/`split`/`merged`/`status_changed` event is `stale`: the cell drops to `needs_reader`,
the row is kept (never deleted), and a `warn` finding `stale-clearance` names it.

### 6.4 Reader queue

`ops/clearing/READER_QUEUE.md` is generated (`scripts/ic_grader.py --queue`): one row per
`needs_reader` cell, grouped by dimension then root, with the question, the source location,
and the priority order: (1) the 3 `duplicates.exact` groups, (2) the 27 `restates` edges,
(3) `tier.witness_not_statement` candidates (Witness-tagged / name-pattern ahead of the rest), (4) sampled
root `reads` edges.

---

## 7. How the grade surfaces

Never as a scalar, never as a warrant, never merged with R0–R6. Read-side consumers propagate
the sidecar verbatim, exactly as they already do for `resistance`:

| surface | what is shown |
|---|---|
| site entry page (`site/build_site.py`, beside the resistance badge row) | "Internal consistency: **IC-k** (checked `<date>`, commit `<sha>`)" or "not checked"; the IC-F flag with `blocked_at`; a list of open finding ids linking to `ops/clearing/findings_<dimension>.json`; the seven dimension statuses as four-state badges (`pass`/`fail`/`not checked`/`needs reader`). |
| `/browse/` (`build_browse_context`) | one column `IC` with the grade string (`IC-0`…`IC-3`, `+F` suffix when flagged); sortable; no colour scale implying a score. |
| `site/index.json` | two fields `consistency_grade`, `consistency_flag` (compact projection like `resistance_rungs_held`). |
| MCP static export (`mcp/toledo_mcp/export_static.py`) | `/v1/entries/<code>.json` gains `consistency` = the sidecar verbatim; `/v1/consistency-summary.json` = `INDEX.json`'s `histogram`, `by_dimension`, `fingerprint`, `reader_coverage` (readings and roots separate). |
| README "Honest state" | one paragraph per release: the two histograms, the unparsed fraction, open findings by class, and the sentence "IC-3 is held by N entries; every other entry is IC-≤2 or has an open finding listed in `ops/clearing/`." |
| `toledo_lint` / MCP verdicts | untouched — IC is a readout of the registry, not a verdict about a statement. |

---

## 8. Regression guard — promote green checks to pytest `[P1 §3.8]`

Every mechanical cell that is clean today becomes a pytest so green cannot silently regress:
`structure.parents_resolve`, `structure.code_root`, `structure.children_inverse`,
`structure.history_top`, `structure.status_note`, `structure.coq_file_present` (file **and**
identifier), `structure.r2_iff_closed`, `structure.occurrence_map` (153 cross-maps all to own
split child), `structure.alias_collision`, `structure.first_assigned_order`, `tier.cell_table`
restricted to cells already at 0, and `duplicates.linked` for exact groups (asserting today's
three groups are the only ones, so a fourth cannot appear unnoticed). Each auditor delivers the
test as `tests/test_ic_<dimension>.py`; the registrar promotes it into `tests/test_registry.py`
(single-writer file) at merge, one commit, `pytest tests/test_registry.py -q` run once before
that commit, not per edit.

---

## 9. Grader and constraints

- `scripts/ic_grader.py` — read-only over `registry/*.json`, `registry/LINEAGE.jsonl`,
  `registry/SCHEMA.md`, `README.md`, `coq/canonical/*.v`, `coq/canonical/verify_report.txt`,
  `ops/clearing/{clearances.jsonl,glossary/,units.json}`. Writes only `registry/consistency/`,
  `ops/clearing/findings_<dimension>.json`, `ops/clearing/symbols/`, `ops/clearing/READER_QUEUE.md`,
  `ops/clearing/RULINGS_REQUESTED.md`. Exits non-zero if it would write anywhere else. Dimension
  modules live in `scripts/ic_dims/<dimension>.py`, one per auditor, each exposing
  `run(registry, ctx) -> list[Finding]` and `cells() -> list[str]`.
- Refuses to run the `coq` dimension if `docs/RAM_LOW` exists; one `coqc` at a time; scratch files
  under the session scratch directory, never under `coq/`.
- Never touches `ops/causal_sweep/` (another lane).
- Never emits a scalar corpus score.
- Maker-checker on the grader itself: before its counts are cited in the README, a second role
  re-derives `schema`, `tier` and `duplicates` counts with independent code; a disagreement is a
  finding on the grader (`grader.disagreement#…`).
- Publish gate: nothing under `ops/clearing/` or `registry/consistency/` is pushed to the public
  remote before an adversarial review that includes the leak scan (`mcp/scripts/leak_scan.py`)
  over every new file — roles-only identity (§6.1) is what makes that scan expected-clean.

---

## 10. Work split — seven auditors, one dimension each

Common contract for every auditor:

- **May write only:** `ops/clearing/findings_<dimension>.json`, `scripts/ic_dims/<dimension>.py`,
  `tests/test_ic_<dimension>.py`, and `ops/clearing/probes/<dimension>/` (the exact reproduce
  scripts the findings cite). Nothing else — not the registry, not `coq/`, not another auditor's
  files, not `ops/causal_sweep/`.
- Findings file shape: `{"header": {"dimension", "computed_at", "grader_commit",
  "registry_commit", "spec": "docs/CONSISTENCY_SPEC_v0_1.md sec.2.<n>", "cells_run": [...],
  "cells_not_run": {cell: reason}}, "findings": [ ... sorted by id ... ]}` — sorted keys,
  timestamp only in the header.
- Every number in the file comes from the cited command. Class D findings are written with
  `status: needs_ruling`, never resolved by the auditor.
- No vendor/model names, no home paths, no usernames, no private repository names.

| # | dimension key | auditor deliverable (day one) | expected initial readout (to be re-read from the run) |
|---|---|---|---|
| 1 | `schema` | enum/kind/required-field/counts/root-edge-kind cells; the class A vs B decision per off-enum value; initial draft of `RULINGS_REQUESTED.md` items (a) and R-2 | ~8 corpus-wide findings (370 off-enum `derived_via` edges, 93 off-enum relation rows, 1 `prose`, 84 free-text `origin.source`, `status_changed` kind, 767 kind-less root edges) |
| 2 | `structure` | all cells of §2.2 incl. `primary_root` (needs_ruling), `first_assigned_order`, `closed_reported` (theorem-name matching against `verify_report.txt`); the promoted pytest set | 0 on the ten legacy cells; ≥277 `closed-unreported` against the scoped v1.7 report; 193 / 16 primary-root rows as `warn` |
| 3 | `tier` | Appendix B table encoded; `unverified_not_closed`; witness candidate list (Witness tag, name patterns); reader-queue rows for the 93+2+42 reader cells | 17 `block` findings (8 + 9), 7 `unverified × closed`, 137 reader rows |
| 4 | `symbols` | normaliser; per-root symbol registries `ops/clearing/symbols/<root>.json`; reserved-symbol kind/arity check; initial `units.json` for the 17 `C` named-law entries; contradiction-candidate list; the glossary row schema and an empty `ops/clearing/glossary/` seed | 20 mixed-spelling groups; reserved-symbol conflicts unknown until run |
| 5 | `coq` | `restates_shape` recogniser (365 of 393 today); scratch-`coqc` fallback (sequential, RAM_LOW-guarded); header-quote and forbidden-import checks for the 801 non-`coq`-format files | not yet computed corpus-wide; ≤ 28 + non-shape scratch compiles |
| 6 | `duplicates` | fingerprint implementation (§2.6 (e)) with the unparsed fraction reported; exact/normalised/identifier/identical-name groups; the `linked` pass condition; cross-root list | 3 exact groups; 5 identical-name groups; unparsed fraction unknown until run |
| 7 | `lineage` | per-`derived_via` shape tests using the `duplicates` fingerprint API (restates equality, substitution instance, split union coverage); root-edge `needs_reader` rows; the 10 % fixed-seed sampling plan; stale-clearance check | 27 `restates` reader rows; 170 split edges tested; 29 `refines` as `needs_ruling`; 767 root edges as `needs_reader` |

Integration order: 1 → 2 → 3 → 6 → 7 → 4 → 5 (6 before 7 because `lineage` consumes the
fingerprint API; 4 and 5 are the slowest and touch the fewest rungs). The registrar merges the
seven findings files into `registry/consistency/` by running `scripts/ic_grader.py --all` once,
generates `READER_QUEUE.md` and `RULINGS_REQUESTED.md`, and hands the independent re-derivation
(§9) to a role that authored none of the seven modules.

---

## Appendix A — commands behind the numbers (run 2026-09-08, checkout `270c2af`)

All stdlib Python 3 over `registry/CANONICAL.json`, `registry/genesis_root.json`,
`registry/LINEAGE.jsonl`, `coq/canonical/verify_report.txt`, `coq/canonical/*.v`:

- entries 1,273; root rows 610; `statement.format`: latex 455, latex+ascii 424, coq 393, prose 1.
- `derived_via`: reads 1256, split 170, restates 32, refines 29, specializes 5, special_case_of 1.
- `relations[].type`: relates-to 75, reads 36, shares-noncollapse-with 11,
  same_form_different_theory 10, parallels 7, refines 3.
- LINEAGE: 3,844 events — revised 2673, assigned 925, occurrence_added 195, split 31, retired 9,
  status_changed 9, merged 2 (`phi_criterion_evidence` on 2).
- `status == unverified and coq_status == closed`: 7.
- readings with ≠ 1 parent under own root: 193; readings with ≥ 1 cross-root parent: 16.
- identical-`name` groups among `current` entries: 5.
- root rows without a normalised `tier`: 233 of 610; root parent edges: 767, all bare strings.
- child `.v1` with `first_assigned` before its `.v1` parent: 0.
- exact whitespace-stripped duplicate statement groups among `current`: 3 (listed in §2.6).
- `Th_coqc × not_formalisable` 8; `Th_coqc × wrapped_related` 9; `Definition`/`Dr × closed` 93.
- `coq.file` set 1,194, missing on disk 0; `coq.identifier` set 1,187; wrapper files 1,202.
- `coq_status == closed` 551; `verify_report.txt` 276 lines, 274 `PASS … Closed under the global
  context` rows (the scoped v1.7 IDM run).
- `coq`-format entries with a file 393, of which 365 contain the `type of` wrapper shape.
- wrapper files containing the token `Witness`: 58 of 1,202; entry names matching
  `_zero_signal|_identity`: 3.
- `find . -iname "*RESISTANCE_LADDER*"` (excluding `.git`): no result.
- `docs/RAM_LOW`: absent at write time.

Numbers quoted from `ops/clearing/proposal_3.md` and not re-run here (20 mixed-spelling groups,
27 `restates` edges with 0 text-identical, 153 occurrence cross-maps, 157 zero-occurrence codes,
84 free-text `origin.source`, 123 named-law entries) are attributed to that proposal's Appendix A
and are re-read by the grader on its initial run.

## Appendix B — `tier` compatibility table (initial; class-D ruling R-3 may change cells)

| tier \ coq_status | closed | axioms | definition | wrapped_related | open_prop | not_formalisable |
|---|---|---|---|---|---|---|
| Th_coqc | ok | reader | finding | **finding** | finding | **finding** |
| Definition | reader | reader | ok | reader | finding | reader |
| Dr / Open | reader | reader | ok | reader | ok | ok |
| finite_diagnostic | reader | reader | ok | reader | reader | reader |
| Ax | reader | ok | reader | reader | finding | reader |
| untagged | reader | reader | ok | ok | ok | ok |

Status overlay: a `finding` cell with `status: current` is a finding; the same cell with
`status: unverified` and a dated `status_note` is `ok`; and, in the other direction,
`status: unverified` with `coq_status: closed` is always a finding (`tier.unverified_not_closed`).
`mapped_not_wrapped` and `root_layer_unwired` are `ok` in every row (honest middle states by
definition).
