# HRP Equation Library — Human–AI Readout Programme

The permanent, coded registry of every equation in the programme, with its Coq formalisation, in one place.

- **Principle (Readout Genesis):** there is one equation; each domain is the same equation read through that domain's
  readout `q_D`. Root codes are Readout Genesis's own identifiers (Appendix C `EQ-001…` and named ids `MQ.08`, `Forced.XII`,
  `Face.10`, `N2`, `VI.3`, `T1`, `RD4`, `weld`), never renumbered. Domain readings are coded `<root>/<D>.<nn>.v<k>`.
- **Layout**
  - `registry/genesis_root.json` — root layer (git-anchored to `morrocwi/readout_genesis`).
  - `registry/CANONICAL.json` — every distinct equation object of the programme (latest formulation; occurrences mapped; sources never edited).
  - `registry/eq_<record_id>.json` — raw inventory per deposited chapter (Zenodo record id).
  - `registry/LINEAGE.jsonl` — append-only lineage per code (assigned / revised / retired / merged / split / occurrence_added).
  - `registry/EQ_LIBRARY.md` — generated status view (`scripts/build_eq_library.py`).
  - `coq/` — Coq 8.20 modules; file name = code (`MQ_08.v`, `MQ_08__H_02.v`); `verify.sh` runs `Print Assumptions` on every lemma.
  - `docs/EQ_CODE_SCHEME.md` — the code scheme and merge rule (builds on existing systems: Genesis Appendix C, the
    `research_universal_solver` Equation Registry (owner/year at first use) and Equivalence Registry φ-criterion, the Genesis
    Domain Registration Standard).
- **Tiers:** `Th_coqc` (lemma closed under the global context on a stated finite model — internal consistency, never empirical
  truth) · `Definition` · `Open` (stated as a Prop, not proved). Nothing here raises a paper's own tier.
- **Releases:** each tagged release is deposited as a version under one Zenodo concept DOI (see `CITATION.cff`).
- **Discipline:** finite/discrete models only; no `Coq.Reals`, no classical axioms, no `Admitted`, no top-level `Axiom`/`Parameter`.

Author: Yaoharee Lahtee (Open Civil Science Initiative). Licence: CC BY 4.0 (registries, docs) and MIT (Coq sources, scripts).
An AI assistant assisted under the author's direction; no AI system is an author or contributor.
