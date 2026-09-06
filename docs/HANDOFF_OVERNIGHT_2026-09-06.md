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

## Licence authorisation (BBL-198, DEC-toledo-solver-arc-copy-2026-0906)
The owner authorises copying the private solver arc's Coq sources (canonical files incl. the health stream) into Toledo under MIT, with provenance "solver arc (private)" + commit + blob. T9 is resolved: copy is permitted; the private repository's name still never appears in public files.

## Running now (late evening 2026-09-06)
- S1 canonicalisation wf_ff807258-9ae — registry phase (200 canonical from 946 raw; dedup review result pending in the run record).
- S3-fix agent: recompute global `step` from Genesis document order; break the two cycles forward-in-document; reconcile L5/Re_ep; report remaining violations with quoted source.
- S7 wf_dade1d64-efa (toledo-s7-coq-import-wf_dade1d64-efa.js): copy 6 Coq sources into coq/<source>/ with PROVENANCE.json, build one at a time (2 sources concurrently max), Print Assumptions on all 3,289 theorems, verify_report.json per source, then registry/coq_map.json (theorem→code with evidence).
- Generators agent: scripts/toledo_build.py (entries JSON-LD, TOLEDO.json, graph json/graphml/ttl, MathML, vault, site index), scripts/toledo CLI, site/build_site.py, latex/toledo.sty + catalogue skeleton, tests/test_build.py, Makefile targets.
- Next after these: N3 relabel workflow (codes ← Genesis ids; readings <root>/<D>.<nn>.v1 with parents/origin/status/step per SCHEMA.md; LINEAGE seeded; φ re-check; orphan check) → build → checker → v1.0.0.

## S7 done (wf_dade1d64-efa)
Imports verified fresh on this machine: readout_genesis 356/356 Closed; information-discrete-math 274/274; readout_universe 947/997 (50 lemmas carry named stdlib axioms via Reals/Classical — recorded, not called axiom-free); zero-readout-certifies 42/42; finite-readout-acceleration 6/6; solver arc (private) 50 canonical files, 1500/1614 Closed, 114 axiom-carrying (named). Total 3,289 theorems: 3,125 Closed, 164 with named axioms, 0 build failures. coq_map.json: 171 identifiers mapped to codes by explicit evidence (+163 Master River), 3,281 unmapped listed with hints (mapping to codes continues in N3/N6; never guessed). Upstream verbatim texts that name a sibling private repo were left byte-identical (public sources) and noted in PROVENANCE.

## Canonicalisation done (wf_ff807258-9ae) → N3 running (wf_76de0086-c80, toledo-n3-relabel-wf_76de0086-c80.js)
946 raw → 253 canonical (dedup review: one remaining over-merge CAN-054 to split in N3); COLLAPSE.md: 9-element root spine + single master equation + reading table (44 placeholder placements listed); coq_canon: 9 modules, 161 lemmas Closed, 253/253 covered, master_equation composition theorem Closed. Copied into toledo/registry and toledo/coq/canonical (pre-N3 state). N3 = registrar (codes/parents/origin/status/step/φ relations/LINEAGE) → Coq rename to code files → independent checker (fix loop ≤2).

## Update 22:30 — swarm-2 done, N3 in its second stage
- swarm-2 (run wf_444db7c2-921, 4 streams + checker, sonnet) wrote proposal files that must be MERGED into CANONICAL only after N3 finishes:
  `registry/coq_map.N3.json` (999/3,452 identifiers mapped by quoted evidence; MR.N labels dropped from `codes` to avoid fake roots),
  `registry/readings_genesis_domains.json` (124 domain rules as C/P/B readings of EQ-001, nn="??" + proposed_after chain),
  `registry/readings_universe_solver.json` (246 entries + mirrors[] for the Appendix C copies),
  `registry/genesis_tiers.sidecar.json` (282 untagged root rows: Definition 101 / untagged 95 / finite_diagnostic 41 / Th_coqc 26 / Dr 16 / Ax 2 / Open 1, each with quote+line, anchored to a readout_genesis commit).
  Checker verdict was FAIL on 5 mechanical blocks (B1–B5); all five fixed in place, leak scan 0. Commit b29753f.
- Founder ruling 22:20 (Thai chat): bundled social/world rows are to be SPLIT, but only formula members get codes; prose propositions become pointers
  (status not_an_equation). Proposal: `registry/split_proposal_SW.json` — 11 single / 19 bundle / 11 mixed / 9 prose; 170 proposed children, 49 excluded
  members; data-integrity flags: weld/S.06.v1 statement duplicates EQ-015/S.08.v1's formula; A.5/W.03.v1 says ten separations but maps 9.
- N3 (wf_76de0086-c80): registrar stage finished (scripts/n3_relabel.py, CANONICAL.json relabelled, CANONICAL.pre-N3.json kept, LINEAGE.jsonl);
  finding: weld ≠ EQ-008 under φ (weld is a 3-clause composite), so CAN-001 is a reading of weld, no merge. Second-stage agent running (Coq rename/checker).
- NEXT after N3 notification: merge order = (1) split_proposal_SW (retire→split, LINEAGE events) → (2) readings_* with final nn assigned per (root,domain) →
  (3) tier sidecar into genesis_root rows → (4) coq_map.N3 → then N5 sequential verify, N6 build/tests/checker/v1.0.0, N7.

## Update 22:50 — N3 committed (559788c), N4 merge launched
- N3 result: 255 coded objects, roots weld / EQ-015 / EQ-002 / A.5 / A.8; CAN-054 split into EQ-015/H.06, H.36, H.37; Coq 255 files named by code, sequential build 255/255, verify 161/161 closed; checker PASS (2 disclosed xfails). weld ≠ EQ-008 under φ (composite vs middle clause) — no merge.
- N4 merge run: wf_13b05a40-9c2, script toledo-n4-merge-wf_13b05a40-9c2.js. Stages: registrar (scripts/n4_merge.py: S/W split → readings with final nn → tier sidecar → coq_map) → Coq splitter (bundle .v → per-child files, sequential build+verify) → independent checker (+1 fix round).
  Resume: Workflow({scriptPath, resumeFromRunId:'wf_13b05a40-9c2'}). On PASS: commit, then N5/N6 (build all outputs, catalogue PDF, tag v1.0.0, GitHub release, Zenodo version under concept 22537318), then N7.
