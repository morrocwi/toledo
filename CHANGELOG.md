# Changelog

All notable changes to Toledo are recorded here. Dates are the commit date in this repository;
counts are computed from the files at that point, never carried over from a prior note.

## v1.7.0 — 2026-09-08

Version DOI: 10.5281/zenodo.22652336 (concept 10.5281/zenodo.22537318).

Deposited as a Zenodo version (DOI recorded once minted; concept DOI 10.5281/zenodo.22537318);
GitHub release tag v1.7.0.

Commits `f09a91b` (v1.7 registrar: Equation River), `182a491` (274 IDM readings wrapped in
Toledo-native Coq files and verified closed; presentation MathML extended), `98240c6`/`de25c59`
(executable-equations v0.1 pilot: end-to-end run against the real registry, then independence/gap/
rounding fixes), plus this release-prep pass.

- **Equation River registrations** (`f09a91b`, founder instruction `BBL-2026-09-08-238`): six
  proposals modelling how an equation grows stronger step by step within this workspace's own
  context (think → register in Toledo → Th_coqc → reproducible computation against an outside
  oracle → review → return to the model) were merged as new readings: `weld/M.33.v1` (the rung set
  `S_n(q) ⊆ {R0,…,R6}` with one evidence file per held rung), `weld/M.34.v1` (the strengthening
  law — a rung is added only by a verified evidence file, and withdrawn if that evidence's
  verification later fails), `weld/M.35.v1` (the strength readout is the held rung *set*, never a
  collapsed scalar — a count hides which rung is missing), `EQ-015/H.50.v1` (the return map, the
  evidence flowing back into the source model), `weld/M.36.v1` (stage non-collapse), and
  `EQ-015/M.17.v1` (stages 3–4 realised concretely on `Q`, an outside-oracle-checked computation).
  Canonical registry: **1,273** entries (was 1,267). See README's "Equation River registrations"
  section.
- **274 `information-discrete-math` root-extension readings wrapped and closed** (`182a491`):
  `scripts/v17_wrap_idm.py` wrote a Toledo-native `coq/canonical/<code>.v` wrapper for every one of
  the 274 v1.6 IDM readings that had carried the honest `mapped_not_wrapped` middle state since
  their v1.6 introduction (each wrapper restates the already-verified imported `IDM` identifier
  under the entry's own code, `-R ../information-discrete-math IDM` added to
  `coq/canonical/_CoqProject`); `verify.sh` reports **274 identifiers checked, 0 disclosed-axiom, 0
  failed** — all 274 land on `closed`. Registry-wide `coq_status`: `closed` **277 → 551**,
  `mapped_not_wrapped` **274 → 0** (retired a second time, honestly — see README's "The
  `coq_status` ladder"). `coq/canonical/` now carries **1,202** `.v` files (was 928); every one has
  a compiled `.vo`/`.vok` artifact on disk (checked this pass without a fresh full-arc `coqc`
  invocation, per the standing "check only what changed" discipline — `coq/canonical/
  build_report.txt` itself still reads its pre-IDM-wrap **905 ok, 0 failed** and was not re-run).
  See README's "Root registry extension R2" section.
- **Presentation MathML extended to `latex+ascii` statements** (`182a491`): `scripts/
  toledo_build.py`'s presentation-MathML pass, previously scoped to `format: latex` only, now also
  covers `format: latex+ascii`. Canonical (reading) entries with a populated `presentation_mathml`
  field: **447 → 863** (of 1,273 canonical entries; recomputed this pass over freshly built
  `registry/entries/*.json` — `863`, matching the commit's own count exactly). **16** entries
  attempt conversion and fail; each records the real reason in its own `mathml_error` field rather
  than being silently dropped (recomputed this pass — **16**). Root rows are unaffected and remain
  ascii-only (**0** of 610 root-row entries carry `presentation_mathml`) — documented open work, not
  silently left inconsistent with the reading rows.
- **Executable Equations v0.1 — opt-in pilot layer** (`98240c6`, `de25c59`,
  `docs/EXECUTABLE_EQUATIONS_v0_1.md`): a single shared interpreter (a Python-on-`Q` reference
  kernel plus a generated JavaScript twin, `scripts/executable/ir_kernel.py` / `site/static/js/
  _ir_eval.js` + `_qfrac.js`) walks a small per-equation intermediate-representation (IR) file at
  run time — no per-entry source file is ever hand-written or generated. Stated plainly, not
  rounded up: of **841** entries eligible by the status/format gate (`status not in
  {not_an_equation, split}` and `statement.format in {latex, latex+ascii}`), **118** parse with
  real equation structure (an Eq node with at least one side carrying real structure, via `sympy.
  parsing.latex.parse_latex`) — but only **2** IR sidecars exist at all
  (`registry/executable/EQ_001__P_45_v1.json`, `EQ_001__P_63_v1.json`), both `status: "candidate"`,
  `eligibility.reviewed_by: null`, **0** `built`. One of the two, `EQ-001/P.45.v1`, carries a known
  sympy misread disclosed in its own `drift_note`: the unescaped word `Gamma_R` was shattered into
  a product of single letters (`G*a*m*a_{R}*m`), and the statement's second clause (the `t'`
  transform) was dropped from the IR entirely — the extractor kept only the `x'` equation. The
  human-review gate blocks exactly this: neither sidecar is `reviewed_eligible`, so `toledo_eval`
  (the 21st MCP tool, evaluating a reviewed-eligible IR at declared exact-rational inputs via a
  shared `Fraction`-only evaluator) refuses both, fail-closed. No corpus equation has been
  cross-checked end-to-end yet, and the site try-it widget renders on **0** pages by design — a
  widget that is wired but shows nowhere is exactly the honest state of a 0-`reviewed_eligible`,
  0-`built` pilot. `de25c59` additionally: reclassified the Python-vs-JS twin comparison as
  `twin_consistency` rather than `independent_implementation` (both evaluators walk the same IR
  tree extracted once from the same statement by the same pipeline, so agreement caps at R3, not a
  stronger independence class); propagated a filed `EXEC-` Reproduction Card's own result onto
  `registry/executable/INDEX.json`'s new `counts.by_result` breakdown (today: `PASS` 0, `FAIL` 0,
  `ERROR` 0 — no card has been filed yet); fixed a JS-twin rounding bug (`QFrac.roundToPrecision`
  rounded a negative exact tie away from zero instead of matching the Python reference's
  floor-based rule); and added `tests/executable/test_ir_schema.py`. See README's "Executable
  Equations v0.1" section.
- **Reproduction evidence unchanged**: the same three worked cards from v1.6 remain the only ones
  registered — `EQ-045` gauge-algebra dimension check **PASS**, `EQ-068` Higgs-mass prediction
  **FAIL** against the published PDG value, IDM ladder-constants check **PASS**. R5 (independent
  reviewer, `independence_class >= "I2"`) remains unheld for every entry in this registry.
- **Downstream**: the textbook "Written by AI. Still True." Edition 1.2 (10.5281/zenodo.22651765)
  now carries an Appendix G generated from this registry's own `reproduction_card_index.json`/
  `review_report_index.json` and cites Toledo v1.6.0 (the version current when that edition was
  built); recorded here for lineage, not re-verified as part of this pass since it lives in a
  separate repository. All 229 Zenodo concepts across the programme were classified into 9 hubs
  the same day, also outside this repository's own scope.
- **This release-prep pass**: `CITATION.cff`/`.zenodo.json` → 1.7.0 (v1.6.0's version DOI
  10.5281/zenodo.22646681 added to `CITATION.cff`'s citation message, a placeholder recorded for
  1.7.0); `python3 mcp/scripts/sync_version.py` propagated `1.7.0` into `mcp/pyproject.toml` and
  `toledo_mcp/__init__.py`. Regenerated `make build`,
  `python3 site/build_site.py --out site/dist --strict`, `PYTHONPATH=mcp python3 -m
  toledo_mcp.export_static --out mcp/dist/static-api` and `make catalogue` (one `latexmk -pdf`
  run): docs site **2,587** pages (was 2,581 — +6 for the 6 new Equation River entries), catalogue
  PDF **335** pages with its title page reading "Version 1.7.0" (`pdfinfo`/`pdftotext`, read from
  `CITATION.cff` at build time). README's "Honest state", "Equation River registrations", "274
  information-discrete-math readings wrapped and closed", "Presentation MathML extended", and
  "Executable Equations v0.1" sections regenerated with live counts; root README's own tools table
  updated 20 → 21 (`toledo_eval` was already documented in `mcp/README.md` by `98240c6` but never
  carried into the root `README.md`, which still read "The 20 tools" until this pass — fixed here).
- **Adversarial-gate finding, disclosed rather than silently carried forward**: v1.5.0's and
  v1.6.0's own CHANGELOG entries state "**0** `Overfull \hbox` warnings over 20pt
  (`grep -c Overfull latex/catalogue.log`)". Re-run this pass, that exact command produces **no
  output at all** in an interactive shell where `grep` is shadowed by a `ugrep`-based wrapper that
  silently treats this log as a binary file and skips it (`-I`), rather than printing `0` — a false
  reading a prior release-prep pass appears to have taken at face value. Using the real `grep`
  (`/bin/grep -c Overfull latex/catalogue.log`, or `grep -a`) instead: **636** total `Overfull
  \hbox` lines, of which **34** exceed 20pt (largest: 145.7pt, at `EQ-001/B.13.v1`'s printed
  entry). Reproduced identically on a clean v1.6.0 (`66eb48a`) checkout built in a detached
  worktree — this is not a v1.7 regression, it is a pre-existing typesetting gap that the prior
  releases' own verification command never actually measured. Left open, not fixed, by this
  documentation-only pass; the correct command for this check going forward is `grep -a` or
  `/bin/grep`, never the bare `grep` alias some interactive coding-agent shells install.
- `python3 -m pytest -q tests` (repository root): **176 passed, 1 skipped, 3 xfailed**.
- `cd mcp && python3 -m pytest -q`: **222 passed**.

## v1.6.0 — 2026-09-08

Deposited as Zenodo version DOI 10.5281/zenodo.22646681 (concept DOI 10.5281/zenodo.22537318); GitHub release tag v1.6.0.

Deposited as a Zenodo version (DOI recorded once minted; concept DOI 10.5281/zenodo.22537318);
GitHub release tag v1.6.0.

Commits `bf6eb78` (root registry extension R2: information-discrete-math), `4c1e7df`
(`toledo_lint`, 20th MCP tool), `4059ebf` (resistance: R3 respects a linked review's hash-match
verdict), `9ee0672` (Master Equation River v1.6 registrar), `40cfda9`/`0a29e3d`/`8a633c4` (tools
table test reads its expected count from the README heading rather than a hard-coded literal),
`6221010` (private-repository-name redaction in three mirrored files), `6c749dc` (ecosystem page
source), `7d65d04` (resistance ladder: `hash_match`/`verify_outcome` documented, index
regenerated), `78e4c21` (`.gitignore`: registry backups), `e9b95d6` (resistance: IDM ladder
constants Reproduction Card registered), plus this release-prep pass.

- **Root registry extension R2: information-discrete-math** (`bf6eb78`): founder ruling
  2026-09-08 brought `information-discrete-math` (IDM, public, MIT) into the root registry as
  **18** further Layer-0 roots (`delta_R`, `RD1`–`RD9`, `D`, `Z`, `Q`, `R`, `L_R`, `Keystone`,
  `A2`, `A3`), connected to Genesis roots only by 3 quoted textual links (`delta_R`→`EQ-001`,
  `L_R`→`EQ-008`, `Keystone`→`EQ-008`), with **274** readings mapped one-per-identifier onto the
  already-verified 274/274-closed IDM Coq mirror (`coq_status: mapped_not_wrapped`, honestly, not
  borrowed as `closed`). Canonical registry: **1,264** entries after this commit (was 990). IDM's
  own treatise deposited separately: **10.5281/zenodo.22644131**. See README's "Root registry
  extension R2" section.
- **Master Equation River v1.6 registrations** (`9ee0672`): the 24 equations of Master Equation
  River v1.6 (10.5281/zenodo.22644712) checked against this registry under the φ-criterion — **21**
  resolved to existing codes as new occurrences, **3** registered as new readings
  (`EQ-015/E.16.v1`, `EQ-015/M.16.v1`, `weld/H.38.v1`). Canonical registry: **1,267** entries (was
  1,264). See README's "Master Equation River v1.6 registrations" section.
- **Resistance ladder + Reproduction Ledger** (`e9b95d6`, `7d65d04`, `4059ebf`): the per-entry
  `resistance` block (R0–R6 rungs, `scripts/compute_resistance.py`) now correctly withholds R3/R4/R6
  when a linked `glosa repro verify` review's own `hash_match` disclosed a MISMATCH, rather than
  trusting a maker-run's own `run{}` block alone (the defect this closed: `EQ-068`'s own Higgs-mass
  card looked complete on its maker-run fields but its independent re-execution had disclosed a hash
  mismatch); a third Reproduction Card registered (IDM's own π/√2/e finite-series approximants vs.
  an independent `mpmath` oracle, tolerance pre-registered at 25 correct decimal digits with real
  margin below the package's own traced 30-digit working precision — **PASS**), giving root rows `Q`
  and `R` held R0/R1/R3/R4/R6. All three cards cited regardless of outcome — `EQ-045`'s gauge-algebra
  dimension check **PASS**, `EQ-068`'s Higgs-mass prediction **FAIL** (218.00 GeV vs. PDG 125.20
  GeV), the IDM ladder-constants check **PASS** — a disclosed FAIL is exactly as strong R4/R6
  evidence as a PASS, never softened. R5 (independent reviewer, `independence_class >= "I2"`) is
  unheld for every entry in the registry today — no such review exists yet anywhere. See README's
  "Resistance ladder R0–R6 and reproduction evidence" section.
- **`toledo_lint`, the 20th MCP tool** (`4c1e7df`): a continuum-injection lint over a statement's
  own text (LaTeX/ascii-math/prose), checked against the `information-discrete-math` skill's
  contaminated-concept table (**15** rules); warns, never blocks — `verdict` is `"clean"` or
  `"continuum_injection_warned"`. See README's "toledo_lint" section.
- **Website: `/ecosystem/`** (`6c749dc`, this release-prep pass): `site/content/ecosystem.md` — how
  Toledo relates to the other public repositories in the programme — wired into the built site as
  `/ecosystem/`, added to the site nav. Its one Mermaid flowchart renders client-side (CDN+SRI, the
  same carve-out KaTeX already uses; `mmdc`/mermaid-cli is not installed on this machine to
  pre-render an SVG at build time instead — checked). A merge-garbled paragraph and a stale "19
  tools" figure in that page's own text were fixed while wiring it. Docs site now **2,581**
  generated pages (was 2,240). See README's "Website" section.
- **Private-repository-name redaction** (`6221010`): the solver-arc private repository's real name,
  found in three mirrored files, replaced with the standing convention `"solver arc (private)"` —
  proof content unchanged, only the name.
- **Second leak caught while wiring `/ecosystem/`** (this release-prep pass): `site/content/ecosystem.md`'s
  own "Public interfaces" table described the private solver-arc repository a second time, under a
  different, inconsistent identity (`solver-arc-private`, with an unredacted directory-name-shaped
  path prefix, `solver-arc-private_universal/...`) than the correctly-redacted `solver arc
  (private)` node the same file's own Mermaid diagram already used for the same repository. Fixed:
  the orphan duplicate node removed, the table rows renamed to `solver arc (private)` with the path
  column marked withheld per BBL-198. `mcp/scripts/leak_scan.py` was run against the file (0
  findings for every category it can check without a local denylist) — its `private_repo_name`
  category still needs a real `--denylist-file`/`TOLEDO_LEAK_SCAN_DENYLIST_FILE` supplying the
  actual name to close out, which this release-prep pass does not have access to; disclosed as an
  open gate, not silently treated as a clean scan.
- **`_CoqProject`/tools-table test hardening** (`8a633c4`, `0a29e3d`, `40cfda9`): the MCP tools-table
  test now reads its expected tool count directly from `README.md`'s own `## Tools (N)` heading text
  rather than a hard-coded literal, so a future tool-count change cannot silently drift the two
  apart without the test itself changing.
- **Catalogue Unicode fallback fix** (this release-prep pass): the v1.6 registry additions'
  `⨁ ⊟ ⊤ ↪` characters (from IDM's FOLD/DECISION/injection statements) had no mapping in
  `latex/unicode_pdf_fallback.sty`, so `pdflatex` silently dropped them from the printed statement
  text; mapped to `\bigoplus`/`\boxminus`/`\top`/`\hookrightarrow` (`amssymb` added for
  `\boxminus`). `make catalogue` now completes with 0 `latexmk` errors (was failing on this before
  the fix).
- **Accessibility fix** (this release-prep pass): the per-entry Resistance Ladder badge block used
  a `role="group"` `<div>`, which `site/checks/check_a11y.py`'s own rule ("no re-implemented ARIA
  widget: only native interactive elements") correctly flags on every one of the 2,581 pages that
  carry it. Replaced with a native `<fieldset>`/visually-hidden `<legend>` — `site/checks/run_all.py`
  now reports 0 hard failures (97 pre-existing, verbatim-source-scoped marketing-word warnings).
- **This release-prep pass**: `CITATION.cff`/`.zenodo.json` → 1.6.0 (v1.5.0's version DOI
  10.5281/zenodo.22642109 added to `CITATION.cff`'s citation message, a placeholder recorded for
  1.6.0); `python3 mcp/scripts/sync_version.py` propagated `1.6.0` into `mcp/pyproject.toml` and
  `toledo_mcp/__init__.py`. Regenerated `make build`,
  `python3 site/build_site.py --out site/dist --strict`, `python3 scripts/build_eq_library.py`,
  `python3 -m toledo_mcp.export_static --out mcp/dist/static-api` and `make catalogue` (one
  `latexmk -pdf` run): docs site **2,581** pages, catalogue PDF **334** pages with its title page
  reading "Version 1.6.0" (`pdfinfo`), **0** `Overfull \hbox` warnings over 20pt
  (`grep -c Overfull latex/catalogue.log` — same as v1.5, reproduced on the built log and on a
  clean rebuild in a detached worktree). README's "Honest state", "Root registry
  extension R2", "Master Equation River v1.6 registrations", "Resistance ladder R0–R6 and
  reproduction evidence", "toledo_lint", "Website" and "What is not done" sections regenerated with
  live counts.
- `python3 -m pytest -q tests` (repository root):
  ```
  .................................................x....x.x............... [ 90%]
  .....s..                                                                 [100%]
  76 passed, 1 skipped, 3 xfailed, 1 warning in 4.56s
  ```
  `cd mcp && python3 -m pytest -q`:
  ```
  ........................................................................ [ 32%]
  ........................................................................ [ 64%]
  ........................................................................ [ 97%]
  ......                                                                   [100%]
  222 passed in 11.45s
  ```

## v1.5.0 — 2026-09-08

Deposited as Zenodo version DOI 10.5281/zenodo.22642109 (concept DOI 10.5281/zenodo.22537318); GitHub release tag v1.5.0.

Deposited as a Zenodo version (DOI recorded once minted; concept DOI 10.5281/zenodo.22537318);
GitHub release tag v1.5.0.

Commits `80d28a5` (v1.5 debt pass: registry, Coq coverage, Tunnel v2.1 registrar merge),
`f1b29bb` (v1.5 debt pass: Makefile index target, benchmark script, SCHEMA addendum),
`f776f74` (site: presentable human-readable public site, S1–S4), `0be5efc` (site: jargon/MathML/CI
fixes), plus this release-prep pass.

- **Recursive Epistemic Tunnel v2.1 merged** (`80d28a5`): the deposited paper "The Recursive
  Epistemic Tunnel" v2.1 (10.5281/zenodo.22639311, concept 10.5281/zenodo.22639309) contributed
  **23** new coded readings (`RET-N01`–`RET-N23`, under `EQ-015`, `EQ-002`, `weld`, `A.5`, `A.8`)
  and **23** occurrences added to existing codes. Canonical registry: **990** entries (was 967).
  See README's "Recursive Epistemic Tunnel v2.1 registrations" section for the full code table.
- **Registry debt pass** (`80d28a5`, `f1b29bb`): closed out DEBT #42–#49
  (`ops/TODOLIST_snapshot_2026-09-07.md`) with a real, computed disposition for each — the 52
  `status: unverified` entries re-checked at source and honestly kept unverified; **95** genesis-root
  rows and **10** canonical entries newly tier-tagged with a quoted source line (111 tier values
  quoted in total per the commit's own count, 2 composite tags reverted); all 210 `wrapped_related`
  entries examined for a derivable independent closure, 0 qualified, each kept with its own
  recorded reason; **119** `Theta`/`CMC` entries gained a Toledo-native Coq wrapper file each (116
  land on `closed`, 3 on a new `axioms` coq_status rung — see README's "The coq_status ladder"); a
  further **78** Coq files written for the Effort v0.3, Economics of Expertise v1.0.1, Core
  Epistemic Structure and Tunnel v2.1 readings; `_CoqProject` now lists 928 `.v` files, all with a
  compiled `.vo`/`.vok` artifact; `registry/cmc_connection_report.md` re-confirmed CMC has no
  evidenced Genesis-root connection and drafted a candidate sentence for the founder; catalogue
  entry-name typesetting and Overfull-hbox fixes (0 over 20pt this pass, down from 38); an MCP
  cold-start defect fixed so a shipped `mcp/state/index.sqlite3` is reused instead of rebuilt on
  every process start (`mcp/scripts/build_index.py`, wired into `make build` and CI). See README's
  "Debt pass (v1.5)" section for the full per-item accounting.
- **Public documentation site** (`f776f74`, `0be5efc`): a new human-readable GitHub Pages site at
  <https://morrocwi.github.io/toledo/>, built by `site/build_site.py` and sharing one Pages
  deployment with the existing static API under `/v1/`; **2,240** pages this pass (home, `/browse/`,
  `/by-root/`, `/by-domain/`, `/by-tier/`, `/by-status/`, `/entries/`, `/search/`, `/agents/`,
  `/about/`). See README's "Website" section.
- **Provenance note** (this release-prep pass, DEBT #51): the `readout_genesis` import anchor
  (`082dde893b70c7500c13d463239909c99cf17f0a`) is a local revision not present on that repository's
  public GitHub remote (public head `04cde19be2c885a11b42597b1cdb60fb5b7ca1bb`, checked this pass);
  recorded in `coq/readout_genesis/PROVENANCE.json`'s `anchor_publication_note` and README's
  "Provenance note: readout_genesis anchor" section. Publication of those commits is left to the
  founder.
- **This release-prep pass**: `CITATION.cff`/`.zenodo.json` → 1.5.0 (v1.4.0's version DOI
  10.5281/zenodo.22637913 added to `CITATION.cff`'s citation message, a placeholder recorded for
  1.5.0); `python3 mcp/scripts/sync_version.py` propagated `1.5.0` into `mcp/pyproject.toml` and
  `toledo_mcp/__init__.py` (both reported "updated"). Regenerated `make build`,
  `python3 site/build_site.py --out site/dist --strict`, `python3 scripts/build_eq_library.py`,
  `python3 -m toledo_mcp.export_static --out mcp/dist/static-api` and `make catalogue` (one
  `latexmk -pdf` run): docs site **2,240** pages, catalogue PDF **291** pages with its title page
  reading "Version 1.5.0" (`pdfinfo`), **0** `Overfull \hbox` warnings over 20pt (`grep` count
  against `latex/catalogue.log`). README's "Honest state", "Debt pass (v1.5)", "Recursive
  Epistemic Tunnel v2.1 registrations", "Website", "Provenance note: readout_genesis anchor" and
  "What is not done" sections regenerated with live counts.
- `python3 -m pytest -q tests` (repository root):
  ```
  ............................x....x.x...................                 [100%]
  52 passed, 3 xfailed, 1 warning in 4.02s
  ```
  `cd mcp && python3 -m pytest -q`:
  ```
  ........................................................................ [ 33%]
  ........................................................................ [ 66%]
  ......................................................................   [100%]
  216 passed in 10.20s
  ```

## v1.4.0 — 2026-09-07

Deposited as Zenodo version DOI 10.5281/zenodo.22637913 (concept DOI 10.5281/zenodo.22537318); GitHub release tag v1.4.0.

Deposited as Zenodo version DOI (recorded once minted; concept DOI 10.5281/zenodo.22537318);
GitHub release tag v1.4.0.

Commit `15f74fc` (Economics of Expertise + Core Epistemic Structure registrar merge), plus three
v1.3.0 follow-ups landed after that tag (`d03e6c6`, `3c1d749`, `48b2382`), plus this release-prep
pass.

- **Economics of Expertise v1.0.1 + Core Epistemic Structure merged** (`15f74fc`): the deposited
  paper "The Economics of Expertise in the Age of Generative AI" v1.0.1
  (10.5281/zenodo.22636999, concept 10.5281/zenodo.22636987) contributed **16** new coded
  readings under the `weld` root it names (`weld/H.22.v1`–`weld/H.29.v1`,
  `weld/W.03.v1`–`weld/W.10.v1`) and **7** occurrences added to existing codes (`weld/M.02.v1`,
  `EQ-015/H.10.v1`, `EQ-015/H.17.v1`, `A.5/H.08.v1` ×2, `EQ-015/M.10.v1`, `weld/E.03.v1` — the
  last carrying a `status_note` disclosing that its manuscript ledger row maps to an earlier
  formulation of that code's statement, not its current text). Separately, founder ruling
  BBL-2026-09-07-217 registered a five-part Core Epistemic Structure as **5** further `weld`
  readings (`weld/H.30.v1`–`weld/H.34.v1`: the structure itself, the AI model set, the empty
  interactional-expert convention, the three-way non-collapse rule, and the experience-holder
  decomposition). 21 new entries total (16 + 5); canonical registry: **967** entries (was 946).
  See README's "Economics of Expertise v1.0.1 registrations", "Core Epistemic Structure", and
  "Honest state" sections for the full computed count set.
- **v1.3.0 follow-ups** (landed after the v1.3.0 tag, shipping in this release): static API
  export's index/landing page was not counted in its own JSON file list (`d03e6c6`); the static
  API export gained a landing page at the export root so the GitHub Pages URL itself answers
  (`48b2382`); the CI leak-scan's username pattern was corrected to ignore generic CI account
  names such as `runner` as a false positive, with a `TOLEDO_LEAK_SCAN_USERNAME` override added
  (`3c1d749`).
- **This release-prep pass**: `CITATION.cff`/`.zenodo.json` → 1.4.0 (v1.3.0's version DOI
  10.5281/zenodo.22635896 added to `CITATION.cff`'s citation message, a placeholder recorded for
  1.4.0); `python3 mcp/scripts/sync_version.py` propagated `1.4.0` into `mcp/pyproject.toml` and
  `toledo_mcp/__init__.py` (both reported "updated"). Regenerated `make build`,
  `python3 site/build_site.py`, `python3 scripts/build_eq_library.py`,
  `python3 -m toledo_mcp.export_static --out mcp/dist/static-api` (2,163 files) and `make
  catalogue` (one `latexmk -pdf` run): docs site **1,559** pages (967 canonical + 592 root rows),
  catalogue PDF **286** pages with its title page reading "Version 1.4.0" (`pdfinfo`). README's
  "Honest state" and "What is not done" sections regenerated with live counts.
- `python3 -m pytest -q tests` (repository root):
  ```
  ............................x....x.x                                     [100%]
  33 passed, 3 xfailed, 1 warning in 2.17s
  ```
  `cd mcp && python3 -m pytest -q`:
  ```
  ........................................................................ [ 33%]
  ........................................................................ [ 67%]
  ......................................................................   [100%]
  214 passed in 9.81s
  ```

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
