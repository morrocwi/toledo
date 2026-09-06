# Toledo — Equation Library of the Human–AI Readout Programme

**Toledo** — after the Toledo School of Translators, where one text was read across languages —
is the permanent, public, coded registry of every equation in the programme together with its
Coq (`Th_coqc`) formalisation.

Scope: equations and `Th_coqc` only. Registries, codes, lineage, Coq sources, verification.
Papers, books and prose live in their own records; Toledo codes are cited from there, not
duplicated into them.

**Principle (Readout Genesis).** There is one equation; each domain is the same equation read
through that domain's own readout `q_D`. Root codes are Readout Genesis's own identifiers,
reused verbatim, never renumbered. Every other object in the library is a domain reading of a
root, coded `<root>/<D>.<nn>.v<k>`.

## Code grammar

```
^(?P<root>EQ-0\d{2}|[A-Za-z][A-Za-z0-9]*(?:[._-][A-Za-z0-9]+)*)(?:/(?P<domain>[EHSWMPCB])\.(?P<seq>\d{2,4})(?:\.v(?P<rev>[1-9]\d*))?)?$
```

- **Layer 0 — root.** The Genesis object's own id, verbatim: `EQ-0nn` in the Appendix C stream
  (e.g. `EQ-001`, `EQ-015`), or a named result (`weld`, `MQ.08`, `A.5`, `A.8`, `Forced.XII`,
  `Face.10`, `N2`, `VI.3`, `T1`, `RD4`). Never prefixed, never renumbered.
- **Layer 1 — reading.** `<root>/<D>.<nn>.v<k>` — the same root read through domain `D`, the
  `<nn>`-th reading assigned under that root (assigned once, never reused), revision `<k>` of the
  statement. Examples: `weld/M.01.v1`, `EQ-015/H.02.v1`, `A.5/E.02.v1`.
- A code failing this grammar is a schema violation, except a `HRP-X.<nnn>` rootless placeholder
  (target: zero at every release), which must carry a `drift_note` and is build-blocking by
  design.

### The 8 domain letters

| Letter | Domain |
|---|---|
| `E` | epistemic |
| `H` | human–AI |
| `S` | social |
| `W` | world-system |
| `M` | method |
| `P` | physics |
| `C` | chemistry |
| `B` | biology/health (BIRCA health equations are `B` readings of their root) |

### Coq file-name mangling

Coq module names cannot carry `/`, `.` or `-`, and most `EQ-0nn` root codes carry a hyphen, so the
canonical mangling for a Coq file name (never for a docs-site URL, which keeps the code's own
literal characters) is:

```
code.replace('/', '__').replace('.', '_').replace('-', '_')
```

`MQ.08/H.02.v1` → `MQ_08__H_02_v1.v`; `EQ-015/M.01.v1` → `EQ_015__M_01_v1.v`.

## How to find an equation

Every code resolves the same way across five surfaces, all generated from
`registry/CANONICAL.json` + `registry/genesis_root.json` by `scripts/toledo_build.py`
(`make build`):

- **CLI** (`scripts/toledo`, stdlib-only, no network): `find`, `show`, `ancestry`,
  `descendants`, `neighbours`, `by-root`, `by-domain`, `by-record`, `export`.
  ```
  python3 scripts/toledo find "primordial"
  python3 scripts/toledo show EQ-001
  python3 scripts/toledo ancestry weld/M.01.v1
  python3 scripts/toledo by-domain B
  ```
- **Docs site** (`site/`, `make site`) — one static HTML page per code plus `index.html`, with
  its ancestry chain and descendants; open `site/index.html`.
- **Vault** (`vault/`) — one Markdown note per code, for a plain-text/Obsidian-style read.
- **`registry/TOLEDO.json`** — the single generated document the CLI and site both read; never
  read `registry/CANONICAL.json` directly for anything downstream of a build.
- **JSON-LD entries** (`registry/entries/`) — one linked-data document per code.
- **Graph** (`graph/toledo_graph.json`, `graph/toledo.graphml`, `graph/toledo.ttl`) — the full
  parent/child/relation graph in JSON, GraphML (Gephi/yEd) and Turtle (RDF) form.
- **`registry/EQ_LIBRARY.md`** (`make library`) — one generated table row per canonical object.
- **Printable catalogue** (`latex/catalogue.pdf`, `make catalogue`) — every entry as one PDF.

## Lineage, status and origin

- **Lineage** (`registry/LINEAGE.jsonl`) — an append-only log, one line per event
  (`assigned | revised | retired | merged | split | occurrence_added`) per code. A retired code
  stays in the file forever, pointing at its successor; nothing is silently edited.
- **`status`** on a `CANONICAL.json` entry:
  - `current` — the live, citable form.
  - `superseded_by` — retired in favour of another code (`superseded_by` names it).
  - `split` — a bundled record that turned out to name more than one distinct object; retired in
    favour of its `children[]` (each child is its own coded reading).
  - `not_an_equation` — the record's only occurrence is prose (a claim, a definition, a
    proposition) with no operator; kept as a pointer to its source, never coded as a formula.
  - `unverified` — coded, but not yet checked against a Coq development.
  - `historical` / `imprecise_as_stated` — carried for record-keeping; `status_note` says why.
- **`origin`** records where an entry came from: `source` (one of `genesis`, `textbook`,
  `readout_genesis`, `readout_universe`, `information-discrete-math`,
  `zero-readout-certifies`, `finite-readout-acceleration`, `solver_arc`, `domain_registry`), a
  `repo_anchor` (`repo`, `commit`, `path`) where the source is a git repository, and the deposited
  `record_id`/`doi`/`section` where it is a Zenodo chapter. An entry backed by the private
  solver-arc repository never names that repository — it is written as `"solver arc (private)"`
  with a commit reference, per BBL-198.
- **`children[]`** is always computed at build time by inverting every entry's `parents[]` — a
  hand-written value is discarded and logged, never trusted.

## Honest state — computed 2026-09-07

Every number below was read from the files in this repository by the command shown; none is
carried over from an earlier note.

**Canonical registry** (`python3 -c "import json; d=json.load(open('registry/CANONICAL.json'));
print(len(d['canonical']))"` and the same script tallying `status`/`domain`/`tier`/`coq.coq_status`):

- **793** canonical entries, mapped from **946** raw equations across **40** deposited chapters
  (`registry/EQ_LIBRARY.md`, `make library`); **1,069** raw occurrence keys resolved.
- **Status:** `current` 697 · `unverified` 57 · `split` 30 · `not_an_equation` 9.
- **Domain:** P 187 · S 136 · M 115 · W 84 · H 77 · B 75 · E 60 · C 59.
- **Tier:** `untagged` 332 · `Definition` 314 · `finite_diagnostic` 47 · `Dr` 41 · `Open` 37 ·
  `Th_coqc` 14 · `Ax` 8. (`Th_coqc` certifies that a lemma is closed under the stated finite
  model's global context — an internal-consistency check, never an empirical or physical truth
  claim; `untagged` means the source gave no tier at all, stated as such rather than guessed.)
- **Coq status:** `closed` 337 · `mapped_not_wrapped` 210 (a `coq_map.json` evidence match exists
  but no Toledo-native wrapper file yet) · `not_yet_formalised` 246 (no Coq evidence of any kind
  yet — stated as open, not implied proved).

**Genesis root layer** (`registry/genesis_root.json`, git-anchored to
`morrocwi/readout_genesis@082dde8`): **590** root rows. Of these, **282** carry a normalised
`tier` (added by the tier sidecar, each with a quoted source line): `Definition` 101 ·
`untagged` 95 · `finite_diagnostic` 41 · `Th_coqc` 26 · `Dr` 16 · `Ax` 2 · `Open` 1. The remaining
308 rows carry only their exact free-text `tier_in_genesis` string (the corpus uses 150+ distinct
tier strings; normalising all of them is open work, listed below).

**Coq — imported developments** (`coq/<source>/verify_report.json`, one sequential build+`Print
Assumptions` pass per source, run fresh on this machine):

| Source | Theorems | Closed | Named axioms | Build failures |
|---|---:|---:|---:|---:|
| readout_genesis | 356 | 356 | 0 | 0 |
| information-discrete-math | 274 | 274 | 0 | 0 |
| readout_universe | 997 | 947 | 50 (`Coq.Reals`/`Classical`, named) | 0 |
| zero-readout-certifies | 42 | 42 | 0 | 0 |
| finite-readout-acceleration | 6 | 6 | 0 | 0 |
| solver arc (private) | 1,614 | 1,500 | 114 (named) | 0 |
| **Total** | **3,289** | **3,125** | **164** | **0** |

**Coq — Toledo-native canonical wrappers** (`coq/canonical/`, `build_report.txt` +
`verify_report.txt`, one sequential build+verify pass): **339** files, build **339/339 OK**;
verify **162/162** identifiers "Closed under the global context", 0 failed.

**Docs site / catalogue** (`make site`, `make catalogue`): site **1,383** generated entry pages
plus one index; printable catalogue PDF **126** pages (`pdfinfo latex/catalogue.pdf`). The
catalogue is typeset by plain `pdflatex`; `latex/unicode_pdf_fallback.sty` maps the corpus's
literal math-notation Unicode to standard LaTeX constructs, and
`scripts/latex_pdf_safe.py` replaces contiguous Thai/Cyrillic quoted-text runs with a disclosed
placeholder pointing back at the JSON/site entry — the registries, JSON-LD entries and site
carry the exact source text unmodified; only this print artifact substitutes.

## What is not done (v1.1 carry-overs)

Honestly disclosed, not hidden in a rounded-up claim:

- **210** `mapped_not_wrapped` Coq identifiers have evidence of a matching development but no
  Toledo-native wrapper file yet.
- **246** canonical entries are `not_yet_formalised` — no Coq development has been located for
  them at all.
- The Genesis named roots `RD1`–`RD9`, `Theta`, and `CMC` are not yet present in
  `genesis_root.json` — no code has been invented for them in their absence.
- **332** canonical entries carry tier `untagged` (no tier was stated in their source at all).
- **308** genesis-root rows still carry only their free-text `tier_in_genesis` string, not a
  normalised `tier`.
- Master Equation River v1.5 and the textbook's Appendix F (both meant to cite Toledo codes) are
  tracked separately and are not part of this release.

## Citation

Cite the Zenodo concept DOI, which always resolves to the latest release:
**10.5281/zenodo.22537318**. Or cite the specific version you used — see `CITATION.cff` and
`.zenodo.json`. Source: <https://github.com/morrocwi/toledo>.

## Licence

- **Registries, docs, generated views** (`registry/`, `docs/`, `graph/`, `vault/`,
  `registry/EQ_LIBRARY.md`): **CC BY 4.0**.
- **Coq sources and scripts** (`coq/canonical/`, `scripts/`): **MIT**.
- **Imported Coq developments** (`coq/<source>/`) keep their own upstream licence — see each
  source's `LICENSE.upstream` file and its `PROVENANCE.json` for the exact commit copied
  (`coq/readout_genesis/LICENSE.upstream` records that the upstream repository carries no licence
  file; that import rests on the author's own same-author import policy, stated there). The
  private solver-arc import is the one exception: its sources are copied in under an explicit MIT
  grant (BBL-198, `coq/solver-arc/LICENSE_NOTE.md`) rather than an upstream licence file, and its
  repository name is never written — only `"solver arc (private)"` plus a commit reference.

An AI assistant assisted under the author's direction; no AI system is an author or contributor.

Author: Yaoharee Lahtee (Open Civil Science Initiative).
