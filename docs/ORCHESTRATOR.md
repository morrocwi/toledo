# Toledo overnight orchestrator (chair: the main session; workers: sonnet agents via ultracode workflows)

## Budgets (BBL-188/194)
- Agents: up to 8 concurrent (API-side; light on RAM). Local heavy processes: coqc ≤ 2 concurrent machine-wide, pdflatex ≤ 1, no `make -j`.
- Watchdog: `scripts/ram_watchdog.sh` logs `free -g` every 60 s to `docs/ram_watchdog.log`; if available RAM < 1.5 GB it writes `docs/RAM_LOW` — every worker must check that file before launching coqc/pdflatex and wait while it exists.
- Every workflow run id is recorded in `docs/HANDOFF_OVERNIGHT_2026-09-06.md`; resume with the saved script + run id; never restart from scratch.

## Streams (parallel where independent)
| Stream | Input | Output | Gate |
|---|---|---|---|
| S1 canonicalise (running wf_ff807258-9ae) | registry/eq_*.json | registry/CANONICAL.json, COLLAPSE.md, coq_canon | dedup review PASS; orphan check |
| S2 design meeting (running wf_065ffe73-039) | handoff, rulings | docs/MEETING_2026-09-06_toledo_design.md, registry/SCHEMA.md | judges |
| S3 root ancestry + step | registry/genesis_root.json, Genesis CORE order | genesis_root.json + parents/derived_via/step | no orphan roots except E00.1; no child before parent |
| S4 other-source inventory | Genesis domains/*/RULE_REGISTRY*.json (124), readout_universe (EQUATION_FI.md, SM stream), solver-arc stream + health Coq (private, names scrubbed) | registry/src_<source>.json | counts from files |
| S5 Coq import manifest | source repos' .v files + their own build files | registry/coq_imports.json (repo, commit, blob, theorems, claimed status) | no compile yet |
| S6 relabel + merge into SCHEMA (after S1,S2,S3) | all above | registry/TOLEDO.json (single source of truth) + LINEAGE.jsonl | tests pass |
| S7 Coq import + sequential verify (after S5,S6) | coq_imports.json | coq/<source>/, verify reports, theorem→code map | Print Assumptions per lemma |
| S8 docs site + catalogue + EQ_LIBRARY (after S6) | TOLEDO.json | docs/site/, docs/catalogue.pdf | builds; links resolve |
| S9 checker + release v1.0.0 (after S7,S8) | repo | tag, GitHub release, Zenodo version | independent checker PASS |
| S10 Master River v1.5 + textbook (after S9) | Toledo DOI | deposits | final checker |

## Chair loop
On every notification: read result → update handoff (run ids, counts) → regenerate EQ_LIBRARY → commit/push (public repo: leak scan first) → launch the next unblocked stream(s) up to the budget.

## Retrieval + graph (BBL-196) — added to S8
- Storage: one JSON per code in `registry/entries/<code>.json` (LaTeX statement + metadata; Coq linked, not embedded); `TOLEDO.json` and `graph/toledo_graph.json` (nodes = codes; typed edges: parent, reads, refines, supersedes, same_form_different_theory, special_case_of, occurrence→record) are GENERATED at build; also `graph/toledo.graphml` for graph tools.
- CLI `scripts/toledo` (python, no deps): `find <text|regex>` (statement/plain/object/occurrence), `show <code>`, `ancestry <code>` (chain to the Genesis root), `descendants <code>`, `neighbours <code> [--type]`, `by-root <root>`, `by-domain <D>`, `by-record <zenodo id>`, `export --format json|graphml|md`.
- Obsidian vault export `vault/<code>.md` with `[[wikilinks]]` for every edge (the founder's research vault convention) so relations are clickable; static site = the same pages rendered.
- Search index: `docs/site/index.json` (code, statement_plain, object, root, domain, tier, occurrences) + one-file client-side search.
