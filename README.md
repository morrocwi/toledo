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

## Honest state — computed 2026-09-07 (v1.1)

Every number below was read from the files in this repository by the command shown; none is
carried over from an earlier note. This section supersedes the v1.0.0 counts below it in
`CHANGELOG.md` — the coq-status figures in particular changed under the v1.1 reclassification
described in "The coq_status ladder" subsection just below.

**Canonical registry** (`registry/CANONICAL.json`'s own live `counts{}` field, cross-checked by
`python3 -c "import json,collections; d=json.load(open('registry/CANONICAL.json'));
c=d['canonical']; print(len(c)); print(collections.Counter(e['status'] for e in c));
print(collections.Counter(e['domain'] for e in c)); print(collections.Counter(e['tier'] for e in
c)); print(collections.Counter(e['coq']['coq_status'] for e in c))"` — both agree):

- **793** canonical entries, mapped from **946** raw equations across **40** deposited chapters
  (`registry/EQ_LIBRARY.md`, `make library`); **1,069** raw occurrence keys resolved.
- **Status:** `current` 693 · `unverified` 61 · `split` 30 · `not_an_equation` 9.
- **Domain:** P 187 · S 136 · M 115 · W 84 · H 77 · B 75 · E 60 · C 59.
- **Tier:** `untagged` 255 · `Definition` 389 · `finite_diagnostic` 46 · `Dr` 43 · `Open` 37 ·
  `Th_coqc` 14 · `Ax` 9. (`Th_coqc` certifies that a lemma is closed under the stated finite
  model's global context — an internal-consistency check, never an empirical or physical truth
  claim; `untagged` means the source gave no tier at all, stated as such rather than guessed.)
- **Coq status:** `closed` 161 · `definition` 339 · `wrapped_related` 210 · `open_prop` 13 ·
  `not_formalisable` 70. See "The coq_status ladder" immediately below for what each of these
  means and why the `closed` count fell from v1.0.0's 337.

### The coq_status ladder (`closed` → `definition` → `wrapped_related` → `open_prop` → `not_formalisable`)

Every canonical entry's `coq.coq_status` field is one honest position on this ladder, never a
rounded-up claim:

- **`closed`** — the entry's own Toledo-native file (`coq/canonical/<code>.v`) states at least one
  Theorem/Lemma/Corollary/Example/Remark that `verify.sh` reports "Closed under the global
  context" for the entry's *own* statement. This is the only status that certifies a proof.
- **`definition`** — the entry's own file states a typed `Definition`/`Record` in a finite model,
  with no theorem attached; there is nothing here to be "closed" or "open" — it is a formal
  restatement, not a claim.
- **`wrapped_related`** — a Toledo-named wrapper file exists and builds, but it only aliases or
  specialises an identifier imported from another repository; it does not independently close the
  entry's own statement. This is the status the 210 v1.0.0 `mapped_not_wrapped` entries moved to
  in v1.1 once their wrapper files were written (task A of the v1.1 scope) — writing the wrapper
  did not manufacture a proof of the entry's own statement, so `wrapped_related`, not `closed`, is
  the honest label.
- **`open_prop`** — an Open/Dr hypothesis stated as an unproved `Definition …_hyp : Prop`, carried
  forward exactly as open, never forced to a proof.
- **`not_formalisable`** — no formal content exists in the source for this entry; the reason is
  recorded per-entry in `tier_evidence`, not asserted without it.

**The 2026-09-07 reclassification.** v1.0.0 reported `closed` 337. On inspection during v1.1, 214
of those 337 entries turned out to carry only a Coq `Definition`, not a proved Theorem/Lemma —
**v1.0.0 over-counted closure**: a `Definition` was being counted as "closed" alongside genuine
proved lemmas, which conflates "we wrote a formal type" with "we proved something under it". v1.1
corrects this: those 214 entries were moved from `closed` to `definition` (each move is a `LINEAGE.jsonl` event),
leaving `closed` at **161** — the count of canonical entries that actually carry a verified
theorem in their own Toledo-native file. This is a different count from, but consistent in kind
with, the **207/207** identifiers `verify.sh` reports "Closed under the global context" across all
of `coq/canonical/` in this release (see the Coq table below) — an "identifier closed" tally can
differ from a "canonical entry `coq_status`" tally because one file can carry more than one closed
identifier, or an identifier belonging to a non-`closed`-status entry (e.g. a helper lemma inside
a `wrapped_related` file). Readers of the v1.0.0 record should treat its `closed` 337 figure as
superseded by this correction, not as a second, still-valid number.

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
`verify_report.txt`, one sequential build+verify pass): **725** files, build **725/725 OK**;
verify **207/207** identifiers "Closed under the global context", 0 failed. (v1.0.0 had 339 files,
339/339 build, 162/162 verified; the growth is the 210 v1.1 `wrapped_related` wrapper files plus
the files written for the resolved `not_yet_formalised` entries, task A/B of the v1.1 scope.)

**Docs site / catalogue** (`make site`, `make catalogue`): site **1,383** generated entry pages
plus one index; printable catalogue PDF **126** pages (`pdfinfo latex/catalogue.pdf`). The
catalogue is typeset by plain `pdflatex`; `latex/unicode_pdf_fallback.sty` maps the corpus's
literal math-notation Unicode to standard LaTeX constructs, and
`scripts/latex_pdf_safe.py` replaces contiguous Thai/Cyrillic quoted-text runs with a disclosed
placeholder pointing back at the JSON/site entry — the registries, JSON-LD entries and site
carry the exact source text unmodified; only this print artifact substitutes.

## Root-candidate evidence: RD1–RD9, Theta, CMC

**RD1–RD9 vs. the Genesis root axioms (finding, not a code change).** The founder's own shorthand
`RD1`–`RD9` is real and machine-checked — found verbatim in `coq/solver-arc/formal/RD.v` and its
byte-identical public mirror `coq/readout_universe/evidence/RD.v` — but v1.1 evidence-checked all
nine of them against Genesis's `E00.1`–`E00.7` root axioms (`EQ-001`…`EQ-008` in this registry)
under the Toledo φ-equivalence criterion (a renaming, fixed positive scale, or fixed constant
substitution — no limits, no approximations) and found **zero** confirmed same-object pairs
(`registry/rd_root_map.json`). RD1–RD9 name a from-scratch Peano-style natural-number construction
(`Inductive D : Type := zero | succ`, with `add`/`mul` built on it) — a different mathematical
object from Genesis's physical/epistemic root axioms. No alias was added to any `genesis_root.json`
row and no `coq_map.json` code was changed, since the criterion found no pairs to merge; Genesis's
own `E00.1`–`E00.7` identifiers remain the sole codes for those axioms.

**Theta and CMC (recommendation, not action).** Two further bodies of work read, on inspection, as
candidate Layer-0 roots but carry no `genesis_root.json` row today (`registry/root_candidates_report.md`):
`Theta` (a living/relational-geometry state a 2026-08-08 founder ruling elevates "to a NEW ROOT
alongside reader Phi / record Psi / retained difference delta_R", per the header comment of
`coq/readout_genesis/formal/InfoThetaEdgeCensus_attempt.v` and eight sibling `InfoTheta*_attempt.v`
files, public, `github.com/morrocwi/readout_genesis@082dde8`); and `CMC` (Causal-Memory Closure, a
named bridge-theorem programme with one disclosed axiom, `coq/solver-arc/formal/CMC_*.v`, six
files, 33 theorems/definitions, currently unmapped to any Toledo code and with **no public git
anchor at all** — it exists only in the private solver arc). Neither elevation is stated inside
`READOUT_GENESIS_CORE.md` or the anchored whitepaper themselves, so this registry build cannot add
either as a root without either a newer Genesis document snapshot or an explicit founder decision
to source the row from the `.v`-header citations alone. No row, alias, or code was added for
either; the report recommends a future root-registry extension and stops there — the decision is
the founder's.

## What is not done (v1.1 carry-overs)

Honestly disclosed, not hidden in a rounded-up claim:

- **210** `wrapped_related` Coq wrappers alias an imported identifier rather than independently
  closing their own entry's statement (see "The coq_status ladder" above) — a real gap between
  "a Toledo file exists for this" and "this entry's own claim is proved".
- **70** canonical entries are `not_formalisable` (no formal content located in the source; reason
  recorded per-entry in `tier_evidence`) and **13** are `open_prop` (stated as an unproved `Prop`,
  by design).
- The Genesis named roots `RD1`–`RD9`, `Theta`, and `CMC` are still not present in
  `genesis_root.json`. v1.1 evidence-checked `RD1`–`RD9` against the existing root axioms and found
  them a distinct object (see the section above) rather than an omitted alias; `Theta` and `CMC`
  remain open root-registry candidates pending a founder decision (`registry/root_candidates_report.md`).
  No code has been invented for any of the three in their absence.
- **255** canonical entries still carry tier `untagged` (no tier was stated in their source at
  all) — down from 332 at v1.0.0 after this release's tier-evidence quoting pass.
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
