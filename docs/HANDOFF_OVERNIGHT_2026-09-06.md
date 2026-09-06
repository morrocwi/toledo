# HANDOFF — Toledo overnight (2026-09-06 → 07). Read this first if the machine restarted.

## Goal (founder, BBL-183–191)
**Toledo** (https://github.com/morrocwi/toledo; Zenodo concept DOI 10.5281/zenodo.22537318) = the permanent, public, coded
library of EVERY equation in the research corpus with its Th_coqc formalisation — organised Readout-Genesis-first (one equation,
read per domain), each code revealing its root and translation layer, each equation carrying provenance, honest status, and
parent codes back to the Genesis root; findable like a world-class formal/equation library; releases with DOIs. Then Master
Equation River v1.5 (one master equation + canonical registry citing Toledo) and the textbook (Appendix F from Toledo) get
published.

## Definition of done (v1.0.0)
1. `registry/genesis_root.json` — every Genesis equation/named result, codes = Genesis's own ids (EQ-0nn, MQ.08, Forced.XII, Face.n, N2, VI.3, T1, RD4, weld), git commit+blob anchors, tier as Genesis tags it.
2. `registry/CANONICAL.json` — every raw equation of the corpus (textbook 946; Genesis; domain rule registries chem/quantum/relativity/biology; readout_universe; solver-arc stream; health/BIRCA stream in the solver arc) mapped to exactly ONE code `<root>/<D>.<nn>.v<k>` (D ∈ E H S W M P C B), latest formulation as statement, merges only under the φ-criterion (renaming / positive scale / constant substitution), `parents[]` + `derived_via`, `origin{}` + `status` (+note), `owner_year` for imports.
3. `registry/LINEAGE.jsonl` — append-only events per code.
4. `coq/` — imported developments (readout_genesis/formal, readout_universe, information-discrete-math, zero-readout-certifies, finite-readout-acceleration, solver arc canonical files) with anchors + the canonical modules, file name = code; ONE sequential verify pass; every lemma "Closed under the global context" or explicitly listed as `+axioms` with the axiom named.
5. `registry/EQ_LIBRARY.md` + docs site (one page per code, ancestry chain, descendants, search) + printable catalogue PDF.
6. tests pass (`make test`), checker (independent) PASS, tag v1.0.0, GitHub release, Zenodo version (obsoletes the separate Coq record 22518450).
7. Master River v1.5 deposited (new version of 22414412); textbook rebuilt with Appendix F from Toledo; final checker; book 22520849 published; isPartOf back-links; hubs/KG refreshed; memory + this handoff updated.

## Constraints
RAM: ≤3–4 sonnet workers; coqc strictly sequential; check `free -g` (stop if <2 GB, resume from cache). No AI vendor names in anything public. No priority words. Readout-not-truth: counts from files. Public pushes only after leak scan (private repo name of the solver arc must not appear in public files). Founder deposit authorisation stands (BBL-167); founder decides GitHub remotes for other repos.

## Runs (resumable with Workflow({scriptPath, resumeFromRunId}))
- WF-CANON-GENESIS wf_ff807258-9ae — script canonical-equations-genesis-wf_ff807258-9ae.js (cluster → merge/review → collapse → formalise → verify → registry). Outputs in the journal working tree (private) — copied into toledo/registry and toledo/coq at N3/N5.
- Genesis root inventory agent (background) → registry/genesis_root.json + GENESIS_CODE_SCHEME.md (re-instructed: reuse Genesis ids verbatim).
- Book: build/assemble.py (630 pp), run_qa.sh, checker pass1 PASS; book draft deposition 22520849 (reserved DOI, unpublished).

## TODO (in order)
- [ ] N1 collect results of the two runs; regenerate EQ_LIBRARY (scripts/build_eq_library.py)
- [ ] N2 ultracode design meeting for Toledo (schema incl. origin/status/parents; Coq import+naming; docs site; release/CI) → toledo/docs/MEETING_2026-09-06_toledo_design.md
- [ ] N3 relabel: root codes ← Genesis ids; readings `<root>/<D>.<nn>.v1`; parents/derived_via; origin/status; LINEAGE seeded; φ-criterion re-check; orphan check (no parent = BLOCK)
- [ ] N4 inventory + import the other sources (Genesis domain registries 124 rules; readout_universe; solver-arc stream + health Coq; BIRCA); Coq imports with anchors → theorem→code map
- [ ] N5 canonical Coq renamed to code files; one sequential verify over all; ledger
- [ ] N6 EQ_LIBRARY + docs site + catalogue PDF; tests; independent checker; v1.0.0 release; Zenodo version
- [ ] N7 Master River v1.5; book Appendix F; refetch; rebuild; final checker; publish 22520849; back-links; hubs/KG; memory
- Founder decisions still open: excerpt page ranges (Causal Ethics/Causal Agency), reading-paths page, accessibility, BBL-id↔part mapping, whether other repos get GitHub remotes.

## Addendum (BBL-192/193, 2026-09-06 late)
- Root ancestry: MQ.08 and every Genesis result carry `parents[]` from Genesis's own derivation order (E00.1–E00.7 root axioms → δ_R → L_R → F/MQ.08 → trunk → faces …); the Forced Set I–XXIV is the forcing chain.
- Ordering backbone = "Genesis of the Universe, Step by Step" (CORE v3.1). Every code gets `step` (position in that sequence; readings inherit their root's step + a sub-index). Validation: no code positioned before any of its parents; the solver arc, Genesis and readout_universe entries must agree on step order (conflict = BLOCK, recorded, not silently resolved).
- Running: Toledo design meeting wf_065ffe73-039 (toledo-design-meeting-wf_065ffe73-039.js); canonicalisation wf_ff807258-9ae (merge phase).
