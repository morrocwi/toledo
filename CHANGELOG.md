# Changelog

All notable changes to Toledo are recorded here. Dates are the commit date in this repository;
counts are computed from the files at that point, never carried over from a prior note.

## v1.0.0 — 2026-09-07

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
