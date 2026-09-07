# CANONICAL.json schema — ruled 2026-09-06 (Toledo design meeting, T1)

**Source of truth for this schema:** `docs/MEETING_2026-09-06_toledo_design.md`, decision T1. This
file is the field-by-field reference; the meeting record carries the rationale and the three-proposal
reconciliation that produced it.

## Document shape

```json
{
  "schema_version": "1.0.0",
  "generated_from_commit": "<toledo git sha at build time>",
  "canonical": [ /* array of entries, shape below */ ],
  "raw_to_canonical": { "<record_id>:<label>": "<code>" }
}
```

`raw_to_canonical` keeps the shape `tests/test_registry.py`'s `test_canonical_codes_unique_and_mapped`
already checks: every key in the union of all `eq_*.json` raw equations (`"<record_id>:<label>"`) must
be present, mapped to the code that equation resolved to (T5 dedup mapping).

## Entry shape (one object type at every layer — root, reading, coq_import, rule)

| field | type | required | notes |
|---|---|---|---|
| `id` | string | yes | internal join key, e.g. `CAN-000001`; stable once assigned, independent of `code` |
| `code` | string | yes | exact Toledo code, matches the T2 regex; **no fallback generator** — a missing code is a build-blocking error, never auto-assigned |
| `root` | string | yes | the Layer-0 ancestor this entry ultimately reads; for a root entry itself, `root == code` |
| `layer` | enum | yes | `root` \| `reading` \| `coq_import` \| `rule` |
| `domain` | enum or null | yes | `null` for `layer=="root"`; else one of `E H S W M P C B` (T2 — 8-letter set ruled 2026-09-06, dated addendum in `docs/EQ_CODE_SCHEME.md`) |
| `aliases` | array\<string\> | yes | every other id the same object carries verbatim, `[]` if none |
| `name` | string | yes | |
| `statement` | object | yes | `{"latest": string, "format": "ascii-math"\|"latex"\|"coq"}` |
| `statements_history` | array | yes | append-only `[{v:int, statement:string, date:"YYYY-MM-DD", reason:string, by:string}]`; `statement.latest` must equal the highest-`v` entry (BBL-172, latest formulation wins) |
| `parents` | array | yes | `[{"code": string, "derived_via": "reads"\|"restates"\|"specializes"\|"forcing_step"\|"same_object"}]`; **empty only legal for code `EQ-001`** (T3.4) — never for any other root or reading, regardless of `role` |
| `children` | array\<string\> | yes | **computed** at build time by inverting `parents[]` across the full `canonical[]` array; never hand-authored — a build overwrites any hand-written value and logs the discrepancy to `LINEAGE.jsonl` |
| `origin` | object | yes | `{"source": "genesis"\|"textbook"\|"readout_genesis"\|"readout_universe"\|"information-discrete-math"\|"zero-readout-certifies"\|"finite-readout-acceleration"\|"solver_arc"\|"domain_registry", "repo_anchor": {"repo":string,"commit":string,"path":string}\|null, "record_id": int\|null, "doi": string\|null, "section": string\|null}` |
| `status` | enum | yes | `current` \| `superseded_by` \| `split` \| `not_an_equation` \| `historical` \| `unverified` \| `imprecise_as_stated` (BBL-190; `split`/`not_an_equation` added at N4, dated addendum in `docs/EQ_CODE_SCHEME.md`) |
| `status_note` | string | conditional | required (non-empty) whenever `status != "current"` |
| `superseded_by` | string or null | yes | required non-null iff `status == "superseded_by"`; must reference an existing code, no 2-cycle |
| `owner_year` | string | **key omitted when not applicable** | present only when a confirmed match against the Equation Registry was found (BBL-181 three-state rule): **present** = checked+found, **absent** (not `null`) = not checked/not found, never write `null` for this field |
| `tier` | enum | yes | `Th_coqc` \| `finite_diagnostic` \| `Dr` \| `Open` \| `Definition` \| `Ax` \| `RETRACTED` \| `untagged` |
| `tier_in_genesis_verbatim` | string | yes | the exact source tag string before normalization (the real corpus has 150+ distinct free-text tier strings; this field is the honest-loss mitigation for the small `tier` enum above) |
| `coq` | object | yes | see below |
| `relations` | array | yes | `[{"type": "reads"\|"refines"\|"supersedes"\|"same_form_different_theory"\|"special_case_of", "target": string, "note": string}]` — non-hierarchical cross-links, distinct from `parents` |
| `occurrences` | array | yes | `[{"record_id": int, "doi": string, "label": string, "section": string, "raw_key": string}]`; `raw_key` matches the corresponding `eq_<record_id>.json` label exactly |
| `role` | enum | yes | `root-axiom` \| `domain-gate` \| `tier-rule` \| `other` — **descriptive only**; never a licence to skip the `parents` requirement above |
| `first_assigned` | string | yes | `"YYYY-MM-DD"` |
| `drift_note` | string | **key omitted when not applicable** | added 2026-09-06 (checker fix `44-domain-default-ids-not-resolved`), same three-state convention as `owner_year`: **present** = this entry's placement (parent/relation) is disclosed as weaker than a demonstrated reading — quotes what was checked and why no stronger evidence was found; **absent** = no disclosed weakness. Never write `null`. `HRP-X.<nnn>` rootless codes (T2) additionally **require** this field non-empty (their own drift reason); a non-rootless entry may also carry one when its parent/relation is a disclosed convention rather than a demonstrated reading (see `registry/COLLAPSE.md` sec.5 drift note #2 for the 44 ids that first used this field). |

### `coq` object

```json
{
  "file": null,
  "identifier": null,
  "assumptions": null,
  "imported_from": null,
  "coq_status": "closed | axioms | build_failed | not_yet_formalised | none",
  "coq_axioms": [],
  "coq_source_redistributed": true
}
```

- `file`: set only when this code has a Toledo-native wrapper under `coq/canonical/<mangled-code>.v`
  (BBL-182: file name = code, via the T2 mangling rule).
- `assumptions`: exactly `"Closed under the global context"`, or a string starting `"+axioms:"` naming
  the axioms — never asserted, always copied from `coq/verify_all.sh`'s own output (T7.9 enforces
  this mechanically).
- `imported_from`: `"<repo>@<commit>:<path>"` for a cited-not-copied source, or the literal string
  `"solver arc (private)@<ref>"` for the private repo — the real repo name must never appear here.
- `coq_status`: derived from the actual `Print Assumptions` classification (T10); a `build_failed` or
  unnamed-axiom result can only push the top-level `status` field toward `unverified`, never invent a
  sixth top-level status value.
- `coq_source_redistributed`: `false` for any code backed by the private solver arc (or a public
  source later found non-MIT-compatible per the open licence-check item) — CI's `verify` job skips
  building/checking any code with this flag `false` (T10) so a public-only clone does not go red on a
  `Require` target it structurally cannot have.
- `identifiers` (optional array, checker addendum 2026-09-06/N4): `[{"file": string, "identifier":
  string}]` — every `coq_map.json` row whose own `codes[]` cites this entry's `code` or `root`, listed
  by evidence (BBL-182 T10 `coq_map.json` is itself evidence-quoted per identifier). Present only when
  at least one such mapped identifier exists; omitted otherwise. This is additional, non-authoritative
  cross-reference data — it does not by itself change `coq_status`.
- `coq_status` gains a seventh value, **`mapped_not_wrapped`** (checker addendum 2026-09-06/N4,
  `scripts/n4_merge.py` step 4b): set when `identifiers` above is non-empty (a `coq_map.json` match
  was found by evidence) but no Toledo-native wrapper file exists yet under `coq/canonical/` for this
  code (i.e. `file` is still `null`) — an honest middle state between `not_yet_formalised` (no evidence
  of any Coq development at all) and `closed`/`axioms` (a Toledo-native wrapper exists and has been
  through `verify.sh`). Never asserted without a `coq_map.json` evidence row backing it; never used to
  push `status` toward anything stronger than `current`/`unverified` per the existing rule above.

## Filesystem-safe mangling (Coq file names only, BBL-182)

`code.replace('/', '__').replace('.', '_').replace('-', '_')` — e.g. `MQ.08/H.02.v1` →
`MQ_08__H_02_v1.v`; `EQ-015/M.01.v1` → `EQ_015__M_01_v1.v` (the `-` replacement, needed because a Coq
module identifier cannot contain a hyphen and most `EQ-0nn` root codes carry one, was implemented
consistently in every mangling script from the start — `scripts/bbl182_split_coq.py`,
`scripts/n4_coq_split.py`, `scripts/n4_coq_verify_update.py`, `scripts/n4_merge.py` — but was missing
from this line until the N4 checker (I2) caught the doc/implementation mismatch, 2026-09-06). This
mangling is **Coq-filename-only**; the docs-site URL path (`site/<code>/index.html`) uses the code's
own literal characters (`/`, `.` and `-` are all valid in a URL path segment) and is unrelated to this
rule.

## Code grammar

```
^(?P<root>EQ-0\d{2}|[A-Za-z][A-Za-z0-9]*(?:[._-][A-Za-z0-9]+)*)(?:/(?P<domain>[EHSWMPCB])\.(?P<seq>\d{2,4})(?:\.v(?P<rev>[1-9]\d*))?)?$
```

A code failing this pattern (other than a `HRP-X.<nnn>` rootless placeholder, which must carry a
`drift_note` and is build-blocking by design, target zero) is a schema violation.

## Validated by

`tests/test_registry.py`, extended per `docs/MEETING_2026-09-06_toledo_design.md` T7: `test_no_orphans`,
`test_no_unresolved_raw_above_threshold`, `test_no_cycles`, `test_duplicate_codes`,
`test_forced_chain_intact`, `test_merge_has_phi_evidence`, `test_status_consistency`,
`test_code_grammar`, `test_coq_assumptions_honest` — in addition to the 3 existing tests
(`test_raw_inventory_loads`, `test_canonical_codes_unique_and_mapped`, `test_lineage_shape`).

## Addendum 2026-09-07 (v1.1 checker) — coq_status values and tier_evidence
- `coq.coq_status` now also takes: `definition` (a typed Definition/Record in a finite model, no theorem — `assumptions` is null), `open_prop` (an Open/Dr hypothesis stated as `Definition …_hyp : Prop`, unproved — `assumptions` null), `wrapped_related` (a Toledo-named wrapper that aliases an imported identifier which the entry's statement only reads or specialises; not a closure of the entry's own statement), `not_formalisable` (no formal content in the source; reason recorded in `tier_evidence`). `closed` is reserved for entries whose own file carries at least one Theorem/Lemma/Corollary/Example/Remark reported "Closed under the global context" by verify.sh; 214 pre-v1.1 entries that were pure Definitions were reclassified from `closed` to `definition` on 2026-09-07 (LINEAGE events).
- `tier_evidence` {quote, source, line, commit} accompanies any tier set or changed after the initial import; a tier is never raised above the source's own tag. Where a source tags a reading Th_coqc but no Coq identifier for it is located, the tier is kept as the source states and `status` is `unverified` with a `status_note`.

## Addendum 2026-09-07 (v1.2 lane S) — `statement.format` value `latex+ascii`
- `statement.format` now also takes `"latex+ascii"` (`scripts/v12_S.py` task (c), 424 entries, BBL-208/210). When set: `statement.ascii` holds the verbatim pre-existing ascii-math text (unchanged from what `statement.latest` held before the conversion) and `statement.latex` holds a mechanical, symbol-for-symbol LaTeX rendering of that same ascii text — no content added or changed, only re-expressed. `statement.latest` is left **unchanged** as the ascii-math text for this format value, i.e. `latest` is not itself LaTeX; `latest`/`ascii` stay identical to each other, `latex` is the derived rendering.
- `statement.latex` is mechanically generated (unicode/ASCII math operators and Greek letters mapped to LaTeX macros, multi-char sub/superscripts and parenthesized sub/superscripts braced as one unit, English word-runs wrapped in `\text{}`) and is **not** independently re-derived evidence — it carries no tier weight of its own beyond the `ascii`/`latest` text it renders. A rendering the converter cannot produce with confidence is still emitted best-effort but is listed in `ops/v12_S_ascii_to_latex_review.md` for manual review; being listed there does not by itself change `status` or `tier`.

## Addendum 2026-09-07 (v1.2 release-prep, gate B2) — root-layer `coq_status` values `root_layer_unwired` and (for a root's own row) `axioms`

`registry/genesis_root.json` root rows are not stored in `registry/CANONICAL.json` — `scripts/toledo_build.py`'s `genesis_row_to_canonical()` synthesizes a CANONICAL-shaped entry for each one at build time (`layer: "root"`). Before this addendum that synthesis hardcoded `coq_status: "not_yet_formalised"` for every one of the ~590 root rows regardless of what the row's own `statement` already discloses — the same string the reading-layer ladder above retired at v1.1, so a reader hitting it in the printed catalogue could reasonably mistake a merely-unwired root for a regression. Fixed:

- The synthesized default for a root row with no further Coq evidence in its own `statement` is now **`root_layer_unwired`** — deliberately distinct from every reading-layer value above (`closed`/`definition`/`wrapped_related`/`mapped_not_wrapped`/`open_prop`/`not_formalisable`) and from the retired `not_yet_formalised`. It means exactly the same thing `not_yet_formalised` used to mean for a root row and nothing more: Coq wiring for the root layer is a separate, not-yet-done stream (N5) from the 912 canonical readings' resolved ladder — never itself evidence of `closed`/`wrapped_related`/`mapped_not_wrapped`, which each require their own coq_map.json/wrapper-file backing.
- A root row whose own `statement` is a literal Coq `Axiom <name> : <Type>.` declaration (matched by `scripts/toledo_build.py`'s `ROOT_AXIOM_STATEMENT_RE`; today only `CMC`, whose statement is `Axiom cmc_bridge_axiom : CMC_Bridge_Obligation.`, quoted verbatim from `"solver arc (private)", formal/CMC_TargetClass_Definitions.v`) instead gets `coq_status: "axioms"` (the base enum value from this file's opening schema block) with `identifier` set to the disclosed axiom's own name and `imported_from` quoting the row's own `section` field — never asserted without that literal statement match, and never pushed to `closed`/`wrapped_related`/`mapped_not_wrapped` without the coq_map.json/wrapper-file evidence those require.

## Addendum 2026-09-07 (v1.5 lane D, catalogue names) — `name_latex`

- `name_latex` | string | **key omitted when not applicable** (same three-state convention as `owner_year`/`drift_note` above): present only on an entry whose `name` carries ASCII sub/superscript notation the mechanical converter in `scripts/v15_D.py` could render with confidence (e.g. `"Labour income share s^L_t"` → `name_latex: "Labour income share $s^{L}_{t}$"`); absent otherwise. `name` itself is **never** changed by this field — `name_latex` is purely a display rendering of the same characters, computed deterministically from `name` (idempotent re-run produces the identical string) plus, where relevant, `statement.format` (an entry whose statement is a literal Coq declaration, `format=="coq"`, is out of scope — its `name` is a bare Coq identifier, not notation, and is left untouched with no `name_latex`).
- Deliberately conservative: a name containing a backtick-quoted formula span, a name introduced by the literal phrase `"theorem: "` (a bare-identifier label used by this corpus's health-stream readings), or a matched token that would require chaining two sub/superscript groups of the same kind onto one atom (invalid LaTeX, "Double subscript") is left as literal text for that portion rather than guessed — see `scripts/v15_D.py`'s own inline documentation for the three filters and the two real defects (a mixed backtick/math rendering; a decimal exponent silently truncated, `M^0.75` → `(M^0).75`) direct inspection of the first, unfiltered pass over the real registry found before these filters were added.
- Consumed by `scripts/toledo_build.py`: the printable catalogue's `\section`/`\subsubsection*` headings use `name_latex` (wrapped in `\texorpdfstring{}{}` so hyperref's PDF bookmark/search string still gets the plain `name`) when present, falling back to the existing plain-text heading path otherwise; the generated vault Markdown heading (`vault_markdown()`, consumed by `site/build_site.py` and Obsidian) does the same, since bare `$...$` is valid Markdown-embedded LaTeX in both renderers' own conventions.
- 80 of 967 entries carry `name_latex` as of this addendum (`ops/v15_D_name_latex_review.md`: 0 flagged ambiguous).
