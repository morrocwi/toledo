# Changelog

All notable changes to Toledo are recorded here. Dates are the commit date in this repository;
counts are computed from the files at that point, never carried over from a prior note.

## v1.3.0 — 2026-09-07

Deposited as Zenodo version DOI 10.5281/zenodo.22635896 (concept DOI 10.5281/zenodo.22537318); GitHub release tag v1.3.0.

Deposited as a Zenodo version (DOI recorded once minted; concept DOI 10.5281/zenodo.22537318);
GitHub release tag v1.3.0.

Commits `b7ef663` (Effort v0.3 registrar merge), `6257c72` (Toledo MCP server and search core),
`ef0b5b2` (leak-scan follow-up) plus this release-prep pass.

- **Effort v0.3 merged** (`b7ef663`): 34 new coded readings from the deposited paper "Effort
  Across Stochastic, Controlled, and Adaptive Worlds" v0.3 (10.5281/zenodo.22622206, concept
  10.5281/zenodo.22622205) — registered under `weld` (28: `weld/E.11.v1`,
  `weld/H.13.v1`–`weld/H.21.v1`, `weld/M.15.v1`–`weld/M.32.v1`), `EQ-015` (2:
  `EQ-015/H.38.v1`–`EQ-015/H.39.v1`) and `A.5` (4: `A.5/H.20.v1`–`A.5/H.23.v1`) — the three roots
  the paper itself names. A φ-criterion check against the then-912-entry registry found zero
  equivalent existing entries, so all 34 are new readings, not merges; each carries a
  `LINEAGE.jsonl` `assigned` event with the DOI as origin. Of the 34, 18 carry `coq_status`
  `definition` and 16 carry `open_prop` (an honest restatement of what the source paper itself
  states, no Coq wrapper file written for them). Canonical registry: **946** entries (was 912).
  See README's "Effort v0.3 registrations" and "Honest state" sections for the full computed
  count set.
- **Toledo MCP server and CLI shipped** (`6257c72`): `mcp/` — a stdio Model Context Protocol
  server exposing 19 tools (`toledo_search`, `toledo_get`, `toledo_status`, `toledo_check`,
  `toledo_lineage`, `toledo_ancestors`, `toledo_descendants`, `toledo_neighbours`,
  `toledo_by_root`, `toledo_by_domain`, `toledo_by_record`, `toledo_by_raw_key`,
  `toledo_lineage_window`, `toledo_counts`, `toledo_index_status`, `toledo_show_verdict_rules`,
  `toledo_register_proposal`, `toledo_list_proposals`, `toledo_proposal_status`) that enforces the
  founder rule "every equation must be looked up in Toledo before it is used; no AI agent may use
  an unregistered equation" at the tool layer — a `{"ok","data","error"}` envelope and a per-row
  verdict on every tool that returns a citable entry, a SQLite/FTS5 search index with a
  regex-query guard and self-heal on corruption, and a single write path
  (`toledo_register_proposal`, under `mcp/proposals/`) that never touches
  `registry/CANONICAL.json`, `registry/genesis_root.json`, `registry/LINEAGE.jsonl`, `coq/`, or
  `latex/`. Also ships a `toledo` console-script CLI, a static JSON export for GitHub Pages
  (`python3 -m toledo_mcp.export_static`), packaging (`mcp/pyproject.toml`), a CI workflow
  (`.github/workflows/toledo-mcp-ci.yml`), 214 passing tests, and a dated benchmark run
  (`mcp/BENCHMARKS.md`). Reviewed under four independent lenses; every block raised was fixed
  before landing — see `mcp/docs/CHANGELOG.md` for the dated, itemised record of each fix.
- **Leak-scan follow-up** (`ef0b5b2`): `mcp/scripts/leak_scan.py`'s own comment, describing the
  home-directory-prefix pattern it checks for, was rephrased to avoid spelling that pattern
  literally — a documentation-only change, made so the module documenting the check does not
  itself trip the check it documents; no functional code changed.
- **This release-prep pass**: `CITATION.cff`/`.zenodo.json` → 1.3.0 (v1.2.0's version DOI
  10.5281/zenodo.22627177 added to `CITATION.cff`'s citation message, a placeholder recorded for
  1.3.0); `python3 mcp/scripts/sync_version.py` propagated `1.3.0` into `mcp/pyproject.toml` and
  `toledo_mcp/__init__.py` (both reported "updated"). Regenerated `make build`,
  `python3 site/build_site.py`, `python3 scripts/build_eq_library.py`,
  `python3 -m toledo_mcp.export_static --out mcp/dist/static-api` (2,142 files) and `make
  catalogue` (one `latexmk -pdf` run): docs site **1,538** pages (946 canonical + 592 root rows),
  catalogue PDF **283** pages with its title page reading "Version 1.3.0" (`pdfinfo`). README's
  "Honest state" and "What is not done" sections regenerated with live counts, and a new "Finding
  and checking equations: the Toledo MCP server and CLI" section added, documenting the 19 tools,
  install (`.mcp.json` plus the generic stdio config), the `toledo` CLI, the static read API
  (<https://morrocwi.github.io/toledo/>, served from CI, may lag a release by minutes), and the
  measured latency from `mcp/BENCHMARKS.md`'s 2026-09-07 run (p50 4.51 ms / p95 7.25 ms over 1,000
  queries).
- `python3 -m pytest -q tests` (repository root):
  ```
  ............................x....x.x                                     [100%]
  33 passed, 3 xfailed, 1 warning in 2.24s
  ```
  `cd mcp && python3 -m pytest -q`:
  ```
  ........................................................................ [ 33%]
  ........................................................................ [ 67%]
  ......................................................................   [100%]
  214 passed in 10.32s
  ```

## v1.2.0 — 2026-09-07

Deposited as Zenodo version DOI 10.5281/zenodo.22627177 (concept DOI 10.5281/zenodo.22537318); GitHub release tag v1.2.0.

Commits `d1057fb` (v1.2 lanes) and `872018f` (gitignore: latex index artefacts) plus this
release-prep pass. Founder rulings BBL-2026-09-07-207 and BBL-208 (`ops/HANDOFF_OVERNIGHT_2026-09-06.md`,
"2026-09-07 09:10").

- **Root registry extension R1** (`d1057fb`, BBL-2026-09-07-207): the root registry gains two
  rows sourced outside the two anchored Genesis documents, using each source's own identifiers
  verbatim — `Theta` (living/relational-geometry root state, public `readout_genesis` anchor,
  connected to Genesis roots `EQ-008` and `EQ-022` with quoted evidence) and `CMC` (Causal-Memory
  Closure, "solver arc (private)" anchor, no evidenced connection to a Genesis root — stated as
  such, not asserted). 592 root rows total (was 590). 119 equations/theorems from the imported
  files were added as `Theta/<D>.nn.v1` / `CMC/<D>.nn.v1` readings, `coq_status`
  `mapped_not_wrapped` — see README's "Root registry extension R1" and `registry/GENESIS_CODE_SCHEME.md`'s
  own addendum.
- **Statement completion** (`d1057fb`): 424 entries gained `statement.format = "latex+ascii"`
  (a mechanical, symbol-for-symbol LaTeX rendering alongside the pre-existing ascii-math text, no
  content changed — `registry/SCHEMA.md`'s 2026-09-07 addendum); 9 entries
  (`EQ-015/B.01.v1`–`EQ-015/B.09.v1`) had a process-note placeholder statement replaced by the
  source's own theorem statement, once located and transcribed, moving `status` from `unverified`
  to `current`; 52 entries remain `unverified`, each with a status note.
- **Catalogue redesign** (`d1057fb`, BBL-208): `latex/catalogue.tex` rebuilt — A4, a title page
  reading the version from `CITATION.cff`, a table of contents by root/part, one block per entry
  (code, name, tier/status/`coq_status` line, statement in display math or wrapped monospace as
  appropriate, parents by code, occurrences), natural code order throughout, and a code index —
  replacing v1.1.0's broken fixed-width tables and string sort. Printable PDF: 278 pages
  (`pdfinfo`).
- **912** canonical entries total (was 793); coq_status gains `mapped_not_wrapped` at count 119.
  See README's "Honest state" section for the full computed count set.
- `.gitignore`/`Makefile` (`872018f`): latex index build artefacts excluded from version control.
- **Release-prep fixes (this pass)**: three bugs found by direct parse of the shipped files, fixed
  before tagging. (B1) `scripts/build_eq_library.py` read the retired field names `root_object`/
  `canonical_text` and a `coq/canonical/LEDGER_*.md` glob that no longer matches anything (superseded
  by per-code Coq files at N3) — `registry/EQ_LIBRARY.md`'s 935-row canonical table was rendering
  blank `Root object`/`Canonical statement`/`Coq` cells on 912/913/932 rows and a hardcoded
  "Coq identifiers (canonical set): 0" header; fixed to read each entry's own `root`,
  `statement.latest` and `coq.coq_status`/`coq.identifier` per `registry/SCHEMA.md`, re-run:
  0 blank cells across all 912 rows, header now 835. (B2) `scripts/toledo_build.py`'s
  `genesis_row_to_canonical()` hardcoded `coq_status: "not_yet_formalised"` for every synthesized
  root row (~590, including this release's own `CMC` root, whose `statement` already quotes its
  source's literal `Axiom cmc_bridge_axiom : CMC_Bridge_Obligation.` line) — a value the README's
  own coq_status ladder retired at the reading layer, so a reader hitting it in the printed
  catalogue could reasonably read it as a regression; renamed the synthesized default to
  `root_layer_unwired` (a distinct, root-layer-only value, `registry/SCHEMA.md` addendum below) and
  special-cased any root row whose own statement is a literal Coq `Axiom` declaration (currently
  only `CMC`) to disclose that axiom's name directly instead. (B3) `registry/CANONICAL.json`'s
  `generated_from_commit` was still `9ca306c`, an early N3-stage commit 11 commits behind this
  release's HEAD — `registry/CANONICAL.json` is owned by the v1.2 lane run and stays untouched by
  this pass, so `scripts/stamp_release_commit.py` (new) is written to re-stamp it at tag time, with
  `tests/test_registry.py::test_generated_from_commit_not_stale` added (disclosed `xfail` until that
  stamping step runs). `python3 -m pytest -q tests` (excluding `tests/test_mcp.py`, owned by the
  separate MCP run): 21 passed, 3 disclosed xfailed, 0 failed.

## v1.1.0 — 2026-09-07

Deposited as Zenodo version DOI 10.5281/zenodo.22574017 (concept DOI 10.5281/zenodo.22537318); GitHub release tag v1.1.0.

Commit `462ff2b` (v1.1 lanes) plus this release-prep pass. Corrects a v1.0.0 counting error and
closes most of v1.0.0's disclosed carry-overs; no `registry/CANONICAL.json`, `LINEAGE.jsonl`,
`genesis_root.json`, or `coq/` file outside `coq/canonical/` was touched by the release-prep pass
itself (those were already updated by `462ff2b` and are frozen for this release).

- **Correction of the v1.0.0 closure count** (`462ff2b`): 214 of v1.0.0's 337 `closed` entries
  carried only a Coq `Definition`, not a proved Theorem/Lemma — **v1.0.0 over-counted closure**.
  Each of the 214 is reclassified `closed` → `definition` (`LINEAGE.jsonl` events), leaving
  `closed` at a corrected **161**. See README's "The coq_status ladder" for the full explanation.
- **210 `mapped_not_wrapped` entries wrapped** (`462ff2b`, v1.1 task A): every one gets a
  Toledo-native `coq/canonical/<code>.v` wrapper that `Require`s the imported identifier(s) and
  restates the entry's statement as a named lemma/definition proved from them (no
  `Admitted`/`Axiom`). Because the wrapper only aliases or specialises the imported identifier
  rather than independently closing the entry's own statement, these are honestly labelled
  `wrapped_related`, not `closed`.
- **246 `not_yet_formalised` entries resolved** (`462ff2b`, v1.1 task B): each is now one of
  `definition` (a typed Definition in a finite model), `closed` (proved), `open_prop` (an Open
  hypothesis stated as an unproved `Prop`), or `not_formalisable` (no formal content in the
  source, reason recorded in `tier_evidence`) — never forced toward a proof that does not exist.
- **RD1–RD9 vs. Genesis roots evidence map** (`462ff2b`, v1.1 task C): all nine of the founder's
  `RD1`–`RD9` identifiers (`coq/solver-arc/formal/RD.v`, public mirror
  `coq/readout_universe/evidence/RD.v`) checked against Genesis's `E00.1`–`E00.7` root axioms
  under the φ-equivalence criterion — **0 confirmed same-object pairs**; RD1–RD9 names a
  from-scratch Peano-style natural-number construction, a distinct object. No alias added, no
  code invented (`registry/rd_root_map.json`).
- **Theta / CMC root-candidate report** (`462ff2b`, v1.1 task C): documented as candidate Layer-0
  roots with no `genesis_root.json` row today — `Theta` publicly anchored
  (`github.com/morrocwi/readout_genesis@082dde8`), `CMC` with no public anchor at all (private
  solver-arc only) — recommended for a future founder root-registry decision, no row/code added
  (`registry/root_candidates_report.md`).
- **Tier-evidence quoting**: canonical `untagged` tier fell from 332 to 255 as entries received
  quoted tier evidence during the v1.1 lanes.
- **Coq — Toledo-native canonical wrappers** (this release-prep pass, sequential
  build+verify, one coqc process at a time): 725 files, build 725/725 OK; verify 207/207
  identifiers "Closed under the global context", 0 failed (up from v1.0.0's 339 files, 162/162
  verified — the growth is the 210 wrapper files plus the files written for the resolved
  `not_yet_formalised` entries).
- **Release build (this pass)**: `make build` (1,383 generated entries), `make site` (1,383 docs
  pages + index), `scripts/build_eq_library.py` regenerated `registry/EQ_LIBRARY.md` (946 raw
  equations, 40 chapters, canonical 793), `make catalogue` produced a 126-page PDF.
  `python3 -m pytest -q tests`: 20 passed, 2 disclosed xfailed, 0 failed.
- **Documentation**: README.md's Honest-state section updated to the live `CANONICAL.json`
  `counts{}` (793 entries; status current 693 / unverified 61 / split 30 / not_an_equation 9;
  domain unchanged from v1.0.0; tier untagged 255 / Definition 389 / finite_diagnostic 46 / Dr 43
  / Open 37 / Th_coqc 14 / Ax 9; coq_status closed 161 / definition 339 / wrapped_related 210 /
  open_prop 13 / not_formalisable 70); a new "coq_status ladder" subsection explains
  `closed → definition → wrapped_related → open_prop → not_formalisable` and the v1.0.0 closure
  correction plainly; a new root-candidate section covers the RD1–RD9 finding and the Theta/CMC
  note; "What is not done" updated to the current carry-overs. `CITATION.cff` and `.zenodo.json`
  updated to v1.1.0 (date 2026-09-07); `.zenodo.json` description updated to match.
- **Known carry-overs for v1.2** (not blockers): 210 `wrapped_related` wrappers remain aliases,
  not independent closures, of their entry's own statement; 255 canonical entries and 308
  genesis-root rows still carry no normalised tier; `RD1`–`RD9`, `Theta`, `CMC` still have no
  `genesis_root.json` row (a founder decision, not a build gap, for the latter two); Master
  Equation River v1.5 and the textbook's Appendix F are tracked separately.

## v1.0.0 — 2026-09-07

Deposited as Zenodo version DOI 10.5281/zenodo.22548770 (concept DOI 10.5281/zenodo.22537318); GitHub release tag v1.0.0.

Full equation library: root layer, canonicalised readings, imported and native Coq, generated
views, and a printable catalogue.

- **Root layer** (`b41b2aa`): `registry/genesis_root.json` — 590 rows anchored to
  `morrocwi/readout_genesis@082dde8`, codes reused verbatim from Genesis.
- **Coq imports** (`4a2559a`, S7): six sources copied in as read-only mirrors with
  `PROVENANCE.json` anchors and one independent `Print Assumptions` pass each — readout_genesis
  356/356 closed, information-discrete-math 274/274, readout_universe 947/997 (50 named
  `Reals`/`Classical` axioms), zero-readout-certifies 42/42, finite-readout-acceleration 6/6,
  solver arc (private) 1,500/1,614 (114 named axioms) — 3,289 theorems total, 0 build failures.
- **Canonicalisation** (`b5fd4ad` → `68a34e4` → `b29753f` → `f3f509e`): 946 raw equations reduced
  to 253 canonical objects under the φ-equivalence criterion; global `step` ordering reconciled
  against Genesis's own document order, two forward-reference cycles broken; a 9-module,
  161-lemma Coq companion (`coq_canon`) built and verified.
- **N3 relabel** (`559788c`): every canonical object recoded `<root>/<D>.<nn>.v1` under its Genesis
  root (`weld`, `EQ-015`, `EQ-002`, `A.5`, `A.8`); 255 objects, `LINEAGE.jsonl` seeded (256
  events); Coq files renamed to their codes (255/255 build, 161/161 verified); independent
  checker PASS.
- **N4 merge** (`988141d`): social/world-system bundles split per founder ruling — 30 retired in
  favour of 170 coded children, 9 pure-prose rows repointed to status `not_an_equation`; 124
  Genesis domain rules and 246 readout_universe/solver-arc entries added as coded readings; the
  Genesis tier sidecar applied to 282 root rows, each with a quoted source line; `coq_map.json`
  merged (349 entries `mapped_not_wrapped`); bundle Coq files split into per-child files (339
  files total, 339/339 build, 162/162 verified); registry now 793 canonical entries; independent
  checker PASS after one fix round.
- **Release build (this pass)**: `make build` (1,383 generated entries), `make site` (1,383 docs
  pages + index), `scripts/build_eq_library.py` regenerated `registry/EQ_LIBRARY.md`, `make
  catalogue` produced a 126-page PDF. The catalogue build required two release-engineering
  additions not present at N6 time: `latex/unicode_pdf_fallback.sty` (maps the corpus's literal
  math-notation Unicode to standard LaTeX constructs so plain `pdflatex` can typeset it) and
  `scripts/latex_pdf_safe.py` (replaces contiguous Thai/Cyrillic quoted-text runs — natural
  language, not notation — with a disclosed placeholder in the print artifact only; every other
  generated view keeps the exact source text). `python3 -m pytest -q tests`: 20 passed, 2
  disclosed xfailed, 0 failed.
- **Documentation**: README.md rewritten for v1.0.0 with a computed honest-state table; a dated
  addendum to `docs/EQ_CODE_SCHEME.md` formalising the 8-letter domain set and the `split` /
  `not_an_equation` statuses introduced at N4; `CITATION.cff` and `.zenodo.json` updated to
  v1.0.0 (creator Yaoharee Lahtee, Open Civil Science Initiative; no AI name as author or
  contributor).
- **Known carry-overs for v1.1** (not blockers): 210 `mapped_not_wrapped` Coq identifiers still
  need a Toledo-native wrapper file; 246 canonical entries are `not_yet_formalised`; the Genesis
  named roots `RD1`–`RD9`, `Theta`, `CMC` have no code yet; 332 canonical entries and 308
  genesis-root rows carry no normalised tier.

## v0.1.0 — 2026-09-06 (`a6312de`, tag `v0.1.0`)

Initial public skeleton.

- Raw inventory of 946 equations across 40 deposited chapters (`f5d1cac`).
- Code scheme drafted: root codes reused from Readout Genesis, domain readings
  `<root>/<D>.<nn>.v<k>` (initially 5 letters `E H S W M`, extended to the current 8-letter set
  `E H S W M P C B` the same day, `7c2c1c1`).
- Master Equation River Coq set (equations 1–79, 45 lemmas closed).
- Repository renamed to Toledo, scoped to equations + `Th_coqc` only (`782af06`).
- Public-readiness pass: private repository names scrubbed from every file, the raw-inventory
  manifest copied into `registry/`, the library generator made self-contained (`156394f`).
- Cited under Zenodo concept DOI `10.5281/zenodo.22537318` (v0.1.0 version DOI
  `10.5281/zenodo.22537319`) (`4beef6d`).
