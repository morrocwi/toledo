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

This repository's own equation-provenance rule is stated in full in
`EQUATION_SOURCE_POLICY.md`: this registry is the sole authoritative source for an existing
Toledo equation; a needed equation absent here is inspected for first, derived only if genuinely
absent, and any new derivation is labelled as a proposal, never presented as an existing entry.

## Finding and checking equations: the Toledo MCP server and CLI

**Founder ruling, 2026-09-07: every equation must be looked up in Toledo before it is used. No
AI agent may use an unregistered equation.** `mcp/` packages a Model Context Protocol (MCP) server
and a companion `toledo` command-line client that put this registry in front of any AI agent that
needs to check a formula before citing or building on it — a lookup gate, not a second copy of the
registry: it reads `registry/CANONICAL.json`, `registry/genesis_root.json` and
`registry/LINEAGE.jsonl` through its own cache and index, and its only write path
(`toledo_register_proposal`) drops a file under `mcp/proposals/` for a human registrar to review;
it never edits `registry/CANONICAL.json`, `registry/genesis_root.json`, `registry/LINEAGE.jsonl`,
`coq/`, or `latex/`.

The rule in practice: call `toledo_check` (or read the `verdict` block a code lookup already
attaches) before stating, citing, or building on a formula. `verdict.usable == true` — cite the
matched code. A superseded/split code — use the redirect it names. A code that only points to
prose — do not present it as a formula. A candidate/ambiguous match — get it confirmed, or
escalate to a human; do not guess. `NOT_REGISTERED` — call `toledo_register_proposal` and wait for
a human registrar to merge it before using the formula; this server never merges a proposal into
the registry itself. Full detail: `mcp/README.md`'s "The rule this server exists to enforce".

### The 20 tools

| Tool | Purpose |
|---|---|
| `toledo_search` | Ranked/filtered text search (root, domain, tier, status, coq_status), JSON or TOON output, per-row verdict. |
| `toledo_get` | The full entry plus its verdict, for one exact code. |
| `toledo_status` | Compact tier/status/coq_status/superseded_by plus verdict for one code. |
| `toledo_check` | The founder-rule gate: pass a formula or a code and get back a verdict. |
| `toledo_lineage` | Ancestry chain, direct children, and every lineage event for one code. |
| `toledo_ancestors` | The full parent DAG, not just the single primary-parent chain. |
| `toledo_descendants` | The full child DAG. |
| `toledo_neighbours` | Parents, children, relations and reverse relations, each with its own verdict. |
| `toledo_by_root` | Every reading of a given Layer-0 root. |
| `toledo_by_domain` | Every entry in a given domain letter (E H S W M P C B). |
| `toledo_by_record` | Every code citing a given Zenodo record id or DOI. |
| `toledo_by_raw_key` | Exact `<record_id>:<label>` occurrence-key lookup. |
| `toledo_lineage_window` | Paginated, filtered browse of the whole lineage log. |
| `toledo_counts` | Live aggregate counts, cross-checkable against `registry/CANONICAL.json`'s own `counts{}`. |
| `toledo_index_status` | Index freshness, schema-version compatibility, and the registry release version. |
| `toledo_show_verdict_rules` | Introspect the verdict decision table as data, rather than trusting a description of it. |
| `toledo_register_proposal` | The only write path — one human-reviewed proposal file under `mcp/proposals/`. |
| `toledo_list_proposals` | Browse the proposal queue, optionally filtered by status. |
| `toledo_proposal_status` | One proposal's current lifecycle state. |
| `toledo_lint` | Continuum-injection lint over a statement (LaTeX/ascii/prose) against the `information-discrete-math` skill's contaminated-concept table; warns, never blocks — `verdict` is `"clean"` or `"continuum_injection_warned"`. |

### Install

For a coding agent that reads a project-level MCP config file, this repository's own root
`.mcp.json` is already present and picked up automatically when the working directory is this
repository:

```json
{
  "mcpServers": {
    "toledo": {
      "command": "python3",
      "args": ["mcp/toledo_mcp/server.py"]
    }
  }
}
```

Any other stdio-capable MCP client needs the same `command`/`args` object under whatever key its
own settings file uses for a list of stdio servers (commonly `mcpServers`, sometimes
`mcp_servers`, sometimes a per-server file) — the shape is identical; only the surrounding
key/file convention differs. If that client resolves paths relative to a different working
directory, point `args` at the absolute path to `mcp/toledo_mcp/server.py`, or set the
`TOLEDO_ROOT` environment variable to this repository's root. Full detail, including the plain
"run it as a subprocess" path for a client with no native MCP support: `mcp/README.md`'s "Wiring
it into an agent".

### The `toledo` CLI

`pip install -e mcp/` installs a `toledo` console script (`toledo find`, `show`, `ancestry`,
`descendants`, `neighbours`, `by-root`, `by-domain`, `by-record`, `export`, plus the
verdict-aware `check`, `status`, `proposals list/show`, `register-proposal`, `index-status`,
`show-verdict-rules`) answering from this package's cached, indexed layer rather than a fresh
`registry/TOLEDO.json` read each time. It is a separate, MCP-package-owned CLI; `scripts/toledo`
itself (used above, in "How to find an equation") is untouched and remains the registry-owning
lane's own build-verification tool.

### Static read API (no MCP client needed)

A caller with no MCP/stdio access reads the same registry as a periodic, eventually-consistent
JSON mirror published on GitHub Pages: **<https://morrocwi.github.io/toledo/>**. It is served from
this repository's own CI workflow (`.github/workflows/toledo-mcp-ci.yml`), which rebuilds and
republishes it on every push to `main` that touches `mcp/**` or `registry/**`; a release commit that changes only documentation does not trigger it, so the mirror can lag until the next such push. Locally, the same mirror is produced by:

```
python3 -m toledo_mcp.export_static --out mcp/dist/static-api
```

(run from this repository's root; `mcp/dist/` is gitignored and never committed by hand). Full
contract: `mcp/docs/STATIC_API.md`.

### Measured latency

From `mcp/BENCHMARKS.md`'s 2026-09-07 integration-pass run, against the real registry, warm
cache, 1,000 queries: **p50 4.51 ms · p95 7.25 ms · p99 7.55 ms · mean 4.77 ms · max 8.18 ms**;
a cold index rebuild (5 runs) costs a median **199.3 ms**. `mcp/BENCHMARKS.md` discloses these as
indicative of that one run, not a guaranteed SLA — re-run `python3 benchmarks/bench_index.py`
(from `mcp/`) for a current number before citing one elsewhere.

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

## Honest state — computed 2026-09-08 (v1.6)

Every number below was read from the files in this repository by the command shown; none is
carried over from an earlier note. This section supersedes the v1.5 counts below it in
`CHANGELOG.md` — v1.6 adds two independent things: a root registry extension (**R2**) bringing
`information-discrete-math` in as **18** further Layer-0 roots with **274** readings under them
(see "Root registry extension R2" below), and **24** Master Equation River v1.6 registrations
(**21** existing-code occurrences plus **3** new codes; see "Master Equation River v1.6
registrations" below). It also ships a per-entry Resistance Ladder + Reproduction Ledger (see
"Resistance ladder R0–R6 and reproduction evidence" below) and a 20th MCP tool, `toledo_lint` (see
"toledo_lint" below). No `coqc` full-arc re-verify was invoked by this release-prep pass itself;
the 274 IDM readings carry the honest `mapped_not_wrapped` coq_status (an evidence-backed match
against an already-verified imported identifier, no Toledo-native wrapper file written yet for
them) — the same rung the v1.2 Theta/CMC readings held before their own wrapper pass, reintroduced
here rather than fabricating a closure that was not done.

**Canonical registry** (`registry/CANONICAL.json`'s own live `counts{}` field, cross-checked by
`python3 -c "import json,collections; d=json.load(open('registry/CANONICAL.json'));
c=d['canonical']; print(len(c)); print(collections.Counter(e['status'] for e in c));
print(collections.Counter(e['domain'] for e in c)); print(collections.Counter(e['tier'] for e in
c)); print(collections.Counter(e['coq']['coq_status'] for e in c))"` — both agree):

- **1,267** canonical entries: **990** at v1.5 plus **274** v1.6 readings from the
  `information-discrete-math` root extension (R2) plus **3** v1.6 Master Equation River v1.6 new
  codes. (990+274+3=1,267, matching `registry/CANONICAL.json`'s own `counts{}.entries` exactly.)
- **Status:** `current` 1,176 · `unverified` 52 · `split` 30 · `not_an_equation` 9.
- **Domain:** M 407 · P 313 · S 136 · H 122 · W 93 · B 75 · E 62 · C 59.
- **Tier:** `Th_coqc` 413 · `Definition` 431 · `Dr` 79 · `Ax` 12 · `finite_diagnostic` 46 ·
  `Open` 41 · `untagged` 245. (`Th_coqc` certifies that a lemma is closed under the stated finite
  model's global context — an internal-consistency check, never an empirical or physical truth
  claim; `untagged` means the source gave no tier at all, stated as such rather than guessed.)
- **Coq status:** `closed` 277 · `definition` 381 · `wrapped_related` 210 · `mapped_not_wrapped`
  274 · `not_formalisable` 70 · `open_prop` 52 · `axioms` 3. See "The coq_status ladder"
  immediately below for what each of these means. `mapped_not_wrapped` reappears at v1.6 — it was
  retired at v1.5 once the 119 v1.2 Theta/CMC readings gained wrapper files, and is reintroduced
  here by the 274 new IDM readings, which carry it honestly rather than borrowing `closed` from
  the already-verified 274/274 IDM Coq mirror they are read from.

### The coq_status ladder (`closed` → `axioms` → `definition` → `wrapped_related` → `open_prop` → `not_formalisable`)

Every canonical entry's `coq.coq_status` field is one honest position on this ladder, never a
rounded-up claim:

- **`closed`** — the entry's own Toledo-native file (`coq/canonical/<code>.v`) states at least one
  Theorem/Lemma/Corollary/Example/Remark that `verify.sh` reports "Closed under the global
  context" for the entry's *own* statement. This is the only status that certifies an
  unconditional proof.
- **`axioms`** (new at v1.5) — the entry's own Toledo-native file closes a Theorem/Lemma under the
  stated finite model, but `coqc`'s own `Print Assumptions` output names one or more axioms rather
  than reporting "Closed under the global context"; the entry's `coq.assumptions` field carries the
  literal `+axioms: <name : statement>, ...` string `coqc` produced, so the reader sees exactly
  what is assumed rather than a rounded-up "closed". Distinct from `closed` precisely because
  something beyond the finite model itself is assumed. All **3** entries at this status today are
  `CMC` readings (see "Debt pass (v1.5)" below).
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

`mapped_not_wrapped` — an evidence-backed match against an imported Coq identifier exists
(`registry/coq_map.json`) but no Toledo-native wrapper file has been written yet — was retired at
v1.5 (the 119 entries that carried it, the v1.2 Theta/CMC root-extension readings, all gained a
Toledo-native wrapper file that pass and moved to `closed`/`axioms`; see "Debt pass (v1.5)" below)
and **reappears at v1.6**: the 274 new `information-discrete-math` root-extension readings (R2)
carry it, honestly, for the same reason the Theta/CMC readings once did — see "Root registry
extension R2" below.

**The 2026-09-07 reclassification.** v1.0.0 reported `closed` 337. On inspection during v1.1, 214
of those 337 entries turned out to carry only a Coq `Definition`, not a proved Theorem/Lemma —
**v1.0.0 over-counted closure**: a `Definition` was being counted as "closed" alongside genuine
proved lemmas, which conflates "we wrote a formal type" with "we proved something under it". v1.1
corrects this: those 214 entries were moved from `closed` to `definition` (each move is a `LINEAGE.jsonl` event),
leaving `closed` at **161** — the count of canonical entries that actually carried a verified
theorem in their own Toledo-native file at v1.1–v1.4. v1.5 raises this to **277** by giving the 119
Theta/CMC entries their own wrapper files (116 land on `closed`, 3 on the new `axioms` rung); see
"Debt pass (v1.5)" for that pass's own Coq evidence. The v1.1–v1.4 figure of **207/207** identifiers
`verify.sh` reported "Closed under the global context" across all of `coq/canonical/` (an
"identifier closed" tally, which can differ from a "canonical entry `coq_status`" tally because one
file can carry more than one closed identifier) was not re-measured by a fresh full-arc `verify.sh`
pass at v1.5 (no `coqc` was invoked by this release-prep pass, per its own build constraint) — the
119 new files' own per-identifier evidence is each entry's own `coq.assumptions` field, written by
the debt pass's own `coqc` runs and read, not re-run, here. Readers of the v1.0.0 record should
treat its `closed` 337 figure as superseded by the v1.1 correction, not as a second, still-valid
number.

**Genesis root layer** (`registry/genesis_root.json`, git-anchored to
`morrocwi/readout_genesis@082dde8` for the 590 Genesis-document rows, the 2 root-extension rows
added at v1.2 per the R1 addendum below, plus **18** further root-extension rows added at v1.6 per
the R2 addendum below): **610** root rows (592 + 18). Of these, still only **377** carry a
normalised `tier` (added by the v1.2/v1.5 tier sidecar passes, each with a quoted source line):
`Definition` 101 · `untagged` 95 · `finite_diagnostic` 68 · `Th_coqc` 51 · `Dr` 43 · `Ax` 13 ·
`RETRACTED` 3 · `Open` 3 — unchanged at v1.6 (no new normalisation pass ran this release). The
remaining **233** rows (377+233=610 — 215 carried over from v1.5, plus the 18 new R2 rows) still
carry only their exact free-text `tier_in_genesis` string (each R2 row's own string is IDM's own
verbatim tier tag, e.g. `Ax`, `Th_coqc`, `"Dr → Th_coqc realization"` for `delta_R`; the corpus
overall uses 150+ distinct tier strings; normalising the rest is open work, listed below).

**Coq — imported developments** (`coq/<source>/verify_report.json`, one sequential build+`Print
Assumptions` pass per source; these reports predate this release-prep pass and were read, not
re-run, here — no `coqc` was invoked during this pass, per this release's build constraints):

| Source | Theorems | Closed | Named axioms | Build failures |
|---|---:|---:|---:|---:|
| readout_genesis | 356 | 356 | 0 | 0 |
| information-discrete-math | 274 | 274 | 0 | 0 |
| readout_universe | 997 | 947 | 50 (`Coq.Reals`/`Classical`, named) | 0 |
| zero-readout-certifies | 42 | 42 | 0 | 0 |
| finite-readout-acceleration | 6 | 6 | 0 | 0 |
| solver arc (private) | 1,614 | 1,500 | 114 (named) | 0 |
| **Total** | **3,289** | **3,125** | **164** | **0** |

**Coq — Toledo-native canonical wrappers** (`coq/canonical/`). `_CoqProject` lists **928** `.v`
files (up from 725 at v1.1–v1.4: +119 Theta/CMC wrappers, +34 Effort, +16 Economics of Expertise,
+5 Core Epistemic Structure, +23 Tunnel v2.1, +6 non-wrapper helper files — see "Debt pass (v1.5)"
for the per-stream file counts and what the 6 are). `build_report.txt` itself records **905 ok, 0 failed (of 905)** —
its text predates the 23 Tunnel v2.1 files' addition to `_CoqProject`; this release-prep pass
cross-checked the remaining 23 the honest way available without invoking `coqc` again: every one
of the 928 `_CoqProject` files has a compiled `.vo`/`.vok` artifact on disk, 0 missing (`python3 -c`
existence check, this pass). `verify_report.txt` itself reads **"0 identifiers checked, 0
disclosed-axiom (registered), 0 failed"** — this is the debt pass's own scoped re-verify of only
the 23 new Tunnel v2.1 files (the "check only what changed" discipline, not a full-arc re-audit),
and 0 is the *correct* result for that scope: all 23 of those files carry `coq_status`
`definition`/`open_prop` (8/15) — a `Definition`, never a Theorem/Lemma/Corollary/Example/Remark —
so `verify.sh`'s own identifier loop correctly finds nothing to `Print Assumptions` on among them.
The last full-arc verify pass on record for the pre-v1.5 tree remains v1.1.0's **207/207**
identifiers "Closed under the global context" (see the reclassification note above); this release
did not re-run that full pass (no `coqc`, per this release's build constraint), so it is quoted as
last measured, not re-certified at v1.5.

**Docs site / catalogue** (`make build && python3 site/build_site.py --out site/dist --strict`,
`make catalogue`, this pass): site **2,581** generated pages (1,267 canonical entries + 610 root
rows plus index/browse/by-root/by-domain/by-tier/by-status/search/agents/about/**ecosystem** pages
— see "Website" below); printable catalogue PDF **334** pages, title page reading "Version 1.6.0"
(`pdfinfo latex/catalogue.pdf`, one `latexmk -pdf` run), **0** `Overfull \hbox` warnings over
20pt in `latex/catalogue.log` (`grep -c Overfull latex/catalogue.log`, this pass, reproduced twice:
once on the already-built log in the working tree and once from a fully clean rebuild in a
detached worktree with the pending diff applied — same as v1.5).
Fixing this pass, not carried from an earlier release: four Unicode characters the v1.6 registry
additions introduced (`⨁ ⊟ ⊤ ↪`, from the `information-discrete-math` root extension's FOLD/
DECISION/injection statements) had no mapping in `latex/unicode_pdf_fallback.sty`, so `pdflatex`
silently dropped them from the printed statement text; all four are now mapped
(`\bigoplus`/`\boxminus`/`\top`/`\hookrightarrow` — `\bigoplus`/`\top`/`\hookrightarrow` are
LaTeX-kernel primitives, `amssymb` was added for `\boxminus` specifically). The catalogue is
typeset by plain
`pdflatex`; `latex/unicode_pdf_fallback.sty` maps the corpus's literal math-notation Unicode to
standard LaTeX constructs, and `scripts/latex_pdf_safe.py` replaces contiguous Thai/Cyrillic
quoted-text runs with a disclosed placeholder pointing back at the JSON/site entry — the
registries, JSON-LD entries and site carry the exact source text unmodified; only this print
artifact substitutes.

### Root registry extension R1 (Theta, CMC) — founder ruling BBL-2026-09-07-207

Founder ruling 2026-09-07 ("โปรแกรม Theta และ CMC ขยายรากให้จบ ให้ต่อกัน", relayed in
`ops/HANDOFF_OVERNIGHT_2026-09-06.md`): extend the root registry with two further root rows,
sourced outside the two anchored Genesis documents, using each source's own identifiers verbatim.
`scripts/v12_R.py` (Toledo v1.2 Lane R) applied this; full detail in `registry/GENESIS_CODE_SCHEME.md`'s
own "Root registry extension R1" addendum and `docs/EQ_CODE_SCHEME.md`.

- **`Theta`** — the living/relational-geometry root state, code taken verbatim from the source's
  own usage. Anchor: public repo `readout_genesis`, commit `082dde893b70c7500c13d463239909c99cf17f0a`,
  `formal/InfoThetaEdgeCensus_attempt.v` (+ 8 sibling files). **Connected** to Genesis roots
  `EQ-008` and `EQ-022` — `genesis_root.json`'s `Theta` row carries a quoted evidence line for each
  link (its admissible-operator census reuses `EQ-008`'s forced characterization as a definition;
  its `Theta_n` state variable is the same object named inside `EQ-022`'s own reader/record
  equation). 86 equations/theorems from the imported files were added as `Theta/P.nn.v1` /
  `Theta/M.nn.v1` readings, `coq_status` `mapped_not_wrapped` at v1.2 — each gained its own
  Toledo-native Coq wrapper file at v1.5 and moved to `closed`/`axioms` (see "Debt pass (v1.5)"
  above).
- **`CMC`** (Causal-Memory Closure) — code is the abbreviation the source files use throughout
  (`CMC_TargetClass`, `cmc_bridge_axiom`). Anchor: "solver arc (private)", commit
  `961151db33b0491cba8fabade69f594238d33f84`, `formal/CMC_TargetClass_Definitions.v` (+ 5 sibling
  files). **CMC has no evidenced connection to a Genesis root today** — `registry/root_candidates_report.md`
  checked directly for a stated link to `EQ-005`/`EQ-006`/`EQ-007` and found none stated explicitly
  in any source text, so the `CMC` row's `parents`/`relations` are both `[]`, with a
  `relations_note` quoting that finding rather than asserting a link. 33 equations/theorems were
  added as `CMC/P.nn.v1` / `CMC/M.nn.v1` readings, `coq_status` `mapped_not_wrapped` at v1.2 —
  each gained its own Toledo-native Coq wrapper file at v1.5 and moved to `closed`/`axioms` (see
  "Debt pass (v1.5)" above).

Both rows carry `role: "root-extension"` (distinct from `role: "root-axiom"`) and a `step: null`
with a `step_note`: neither root is given an invented position in `READOUT_GENESIS_CORE.md`'s own
step ordering — both are downstream of that document, not part of it.

### Statement completion (v1.2 Lane S)

`scripts/v12_S.py` completed statement formatting and content across three tasks
(`registry/LINEAGE.jsonl` events, `v1.2 lane S`):

- **424** entries gained `statement.format = "latex+ascii"`: `statement.ascii` keeps the
  pre-existing ascii-math text unchanged, `statement.latex` is a mechanical, symbol-for-symbol
  LaTeX rendering of that same text (no content added or changed) — see `registry/SCHEMA.md`'s own
  2026-09-07 addendum for the exact rule. A rendering the converter could not produce with
  confidence is still emitted best-effort and listed in `ops/v12_S_ascii_to_latex_review.md` for
  manual review.
- **9** entries (`EQ-015/B.01.v1`–`EQ-015/B.09.v1`) had a process-note placeholder statement
  replaced by the source's own theorem statement, once located and transcribed (`statements_history`
  records both versions); these 9 also moved `status` from `unverified` to `current`.
- **52** entries remain `status: unverified`, each with a non-empty `status_note` naming why (most
  cite a `readout_genesis` rule-registry entry tagged `PROPOSED_INTERNAL`/`YELLOW_BRIDGE_PARTIAL` in
  its own source, carried here as stated rather than upgraded).

### Catalogue redesign (v1.2, founder ruling BBL-208)

The v1.1.0 catalogue PDF was not presentable (tables broken, raw ASCII statements only,
string-sorted codes, no real contents). `latex/catalogue.tex` was rebuilt from scratch:

- **A4** page size, a **title page** (name, version read from `CITATION.cff`, concept DOI,
  generation date, licence, a "how to read this catalogue" key explaining code layers, tiers and
  `coq_status`).
- A **table of contents** to Part (one per root, in natural code order) and Section depth.
- **One block per entry** — code, name, a tier/status/`coq_status` line, the statement (LaTeX
  typeset in display math when `statement.format` includes `latex`; the source's own ASCII-math or
  Coq text in a wrapped monospace block otherwise; plain prose where the source states none),
  parents by code, and occurrences — instead of the fixed-width tables that overflowed in v1.1.0.
- **Natural code order** throughout (root, then domain letter, then sequence number) rather than
  v1.1.0's plain string sort, plus a **code index** at the end (`\makeindex`).

### Effort v0.3 registrations (v1.3)

The deposited paper "Effort Across Stochastic, Controlled, and Adaptive Worlds" v0.3 (15 pp.,
dated 7 September 2026) cited 11 existing Toledo codes and proposed 34 further equations of its
own. Per `EQUATION_SOURCE_POLICY.md`'s required procedure, each of the 34 was checked against this
registry under the φ-criterion before registration; none was found structurally equivalent (by
renaming, positive scale, or constant substitution) to an existing entry, so all 34 were registered
as new readings, `origin.doi` = **10.5281/zenodo.22622206** (concept DOI
10.5281/zenodo.22622205), `LINEAGE.jsonl` `assigned` events, under the three roots the paper itself
names:

- **`weld`** — 28 readings: `weld/E.11.v1` (1); `weld/H.13.v1`–`weld/H.21.v1` (9);
  `weld/M.15.v1`–`weld/M.32.v1` (18).
- **`EQ-015`** — 2 readings: `EQ-015/H.38.v1`, `EQ-015/H.39.v1`.
- **`A.5`** — 4 readings: `A.5/H.20.v1`–`A.5/H.23.v1`.

(28 + 2 + 4 = 34; see `registry/proposals/effort_v0_3.merged.json` for the exact
proposal-id → code map.) Founder instruction: register in Toledo, deposit on Zenodo — **not** into
the textbook. Deposited separately as its own Zenodo record (publication/preprint, `isPartOf` the
programme hub 10.5281/zenodo.22308201, `references` this registry's concept DOI
10.5281/zenodo.22537318); merged into `registry/CANONICAL.json` only after the v1.2.0 tag, per this
repository's own rule that a release-prep pass must never see a moving registry.

### Economics of Expertise v1.0.1 registrations (v1.4)

The deposited paper "The Economics of Expertise in the Age of Generative AI" v1.0.1
(10.5281/zenodo.22636999, concept DOI 10.5281/zenodo.22636987) cited existing Toledo codes and
proposed further equations of its own. Per `EQUATION_SOURCE_POLICY.md`'s required procedure, each
proposed equation was checked against this registry under the φ-criterion before registration:

- **16 new readings**, all under the `weld` root the paper itself names — `origin.doi` =
  **10.5281/zenodo.22636999**, `LINEAGE.jsonl` `assigned` events:
  - `weld/H.22.v1`–`weld/H.29.v1` (8) — the load-bearing non-collapses, the three ideal-type
    expertise states, the expertise-state transition probability, the interactional-compression
    and contributory-persistence hypotheses, the Core Epistemic Registration object, and the
    live-problem coupled epistemic system research architecture.
  - `weld/W.03.v1`–`weld/W.10.v1` (8) — the candidate-validation workload, validation capacity,
    the candidate-validation backlog recursion and its steady state, the AI-induced epistemic
    scarcity shift condition, validated-output value, the shadow-value Lagrangian, and the
    university Pareto-efficient portfolio objective.
- **7 occurrences added to existing codes** (no new entries; each an `occurrence_added`
  `LINEAGE.jsonl` event citing the DOI): `weld/M.02.v1` (eq. 1), `EQ-015/H.10.v1` (eq. 2),
  `A.5/H.08.v1` (eq. 3 and eq. 27 — two occurrences on the same code), `EQ-015/H.17.v1` (eq. 26),
  `EQ-015/M.10.v1` (eq. 30), and `weld/E.03.v1` (eq. 6) — the last carries a `status_note`
  recording that the manuscript's own ledger row for eq. 6 maps to `weld/E.03.v1` under an
  *earlier* formulation of that code's statement (the raw record `eq_19640361.json`'s
  `K_S^A = (Tr_A, Str_A, Cap_A)` triple); `weld/E.03.v1`'s own `statement.latest` has since been
  revised (BBL-172, latest-formulation-wins) to a more elaborate admission-status formula, so this
  is the same admitted object read at an earlier stage of its own history, not a verbatim string
  match against the code's current text — recorded plainly rather than silently reconciled.

(8 + 8 = 16; see `registry/proposals/economics_of_expertise_v1_0.merged.json` for the exact
raw-key → code map.) Deposited separately as its own Zenodo record; merged into
`registry/CANONICAL.json` for this v1.4.0 release.

### Core Epistemic Structure (founder ruling 2026-09-07)

Founder ruling BBL-2026-09-07-217 fixes a five-part Core Epistemic Structure as the default
epistemic-registration block for every draft going forward; the ruling was applied in the
Economics of Expertise manuscript v1.0.1 above. Registered as **5** new `weld` readings, each
entry's `origin.source` naming Blackbox Log BBL-2026-09-07-217 (the founder ruling) and its
application in that manuscript:

- **`weld/H.30.v1`** — Core Epistemic Structure of a project.
- **`weld/H.31.v1`** — AI model set of a project.
- **`weld/H.32.v1`** — Interactional-expert slot empty when the role is unheld.
- **`weld/H.33.v1`** — Non-collapse: experience-based expertise, interactional expertise, and AI
  model are distinct.
- **`weld/H.34.v1`** — Experience-holder decomposition (lived experience, selection,
  interpretation).

(See `registry/proposals/core_epistemic_structure.merged.json` for the exact proposal-id → code
map.) The glosa methodology's card P20 (the mandatory Core Epistemic Structure block on every
draft) requires its formal object to be "registered in Toledo as a coded reading; cite its code
once assigned" — these five codes are that assignment; citing them into P20's own card text is
tracked in the glosa repository, not here.

### Debt pass (v1.5)

`ops/HANDOFF_OVERNIGHT_2026-09-06.md` and `ops/TODOLIST_snapshot_2026-09-07.md` listed eight open
registry debts against v1.4.1 (DEBT #42–#49). This section states, per item, what this pass
actually resolved and what honestly remains — no item below is marked closed unless a computed
number backs it.

- **DEBT #42 — 52 `unverified` entries.** Each was re-checked directly against its own cited
  source this pass; none of the 52 had a source identifier surface that the earlier pass had
  missed, so all 52 **stay `status: unverified`**, each keeping its existing dated `status_note`
  naming what is missing. `registry/CANONICAL.json`'s own `counts{}.by_status.unverified` is **52**
  at v1.5 — unchanged from v1.4, confirming no entry was silently upgraded.
- **DEBT #43 — untagged tiers.** **95** previously-`untagged` `registry/genesis_root.json` rows and
  **10** previously-`untagged` `registry/CANONICAL.json` entries (`EQ-009/E.03.v1` → `Open`;
  `EQ-015/B.01.v1`–`EQ-015/B.09.v1` → `Th_coqc`) gained a normalised tier with a quoted source
  line this pass — computed by diffing both files against the v1.4.0 release tag (commit
  `6579cf7`). Commit `80d28a5`'s own message states the pass's full self-reported total as **111**
  tier values quoted from source (**2** composite/ambiguous tag strings reverted rather than kept
  as invented single tags) — a few beyond the 105 value-changes this pass independently
  re-diffed are quote-only additions to entries whose tier value was already correct, not
  re-derived here beyond the commit record. **245** canonical entries and **215** genesis-root rows
  still carry no normalised tier (down from 255 and 310 respectively) — never invented, per this
  registry's own tiering rule.
- **DEBT #44 — 210 `wrapped_related` entries.** Each was examined this pass for whether its own
  statement is independently derivable as a Theorem in its own Toledo-native file rather than only
  aliasing an imported one; **0** qualified. All 210 are kept `wrapped_related`, each with its own
  per-entry reason recorded (per commit `80d28a5`'s message) — `registry/CANONICAL.json`'s own
  `counts{}.by_coq_status.wrapped_related` reads **210**, unchanged from v1.4, confirming no entry
  was moved without a real independent closure behind it.
- **DEBT #45 — Coq coverage for entries with no file.** **119** `Theta`/`CMC` entries (86 + 33,
  the full v1.2 root-extension set) each gained a Toledo-native `coq/canonical/<code>.v` wrapper
  file this pass: **116** land on `coq_status` `closed` ("Closed under the global context", each
  entry's own `coq.assumptions` field carries that literal string) and **3** on the new `axioms`
  rung (`CMC/M.01.v1`, `CMC/M.02.v1`, `CMC/M.18.v1` — each entry's `coq.assumptions` field names
  the actual `coqc`-disclosed axioms, e.g. `cmc_retention_lemma_obligation`); see "The coq_status
  ladder" above. A further **78** Toledo-native Coq files were written for the Effort v0.3 (34),
  Economics of Expertise v1.0.1 (16), Core Epistemic Structure (5) and Tunnel v2.1 (23) readings —
  computed by grouping `registry/CANONICAL.json` entries by their `origin` field and counting
  distinct `coq.file` values per group (34+16+5+23=78). `_CoqProject` now lists **928** `.v` files
  in total: the pre-v1.5 725, plus these 197 (119+78) per-entry wrapper files, plus **6** further
  files this pass added that are not any one entry's own wrapper (5 raw-source mirrors of the
  `CMC_*.v` files under a `_cmc_mirror_` prefix, kept so the imported identifiers they define are
  directly `Require`-able, plus one shared `_hrp_verdict_vocab.v` helper) — 725+197+6=928, verified
  by diffing `coq/canonical/`'s file list against the v1.4.0 release tag, this pass. Every one of
  the 928 has a compiled `.vo`/`.vok` artifact on disk (checked this pass, 0 missing) — see "The
  coq_status ladder" above for what `build_report.txt`/`verify_report.txt` do and do not cover.
- **DEBT #46 — CMC's connection to a Genesis root.** `registry/cmc_connection_report.md` (this
  pass) re-ran the search directly over the full text of all six `CMC_*.v` files (not only their
  headers) plus every CMC-adjacent document in this tree and every already-imported public
  repository: **no sentence states a CMC-to-Genesis-root connection anywhere**. This confirms,
  rather than overturns, `registry/root_candidates_report.md`'s existing finding. The report drafts
  one candidate sentence — a structural resemblance between `CMC_TargetClass_Definitions.v`'s
  `TransportReadout` fields (`retained_diffusive`, `intrinsic_finite_speed`) and Genesis roots
  `EQ-005`/`EQ-006` — explicitly as a proposal for the founder to confirm, reject, or have restated,
  never as a sourced finding. `registry/genesis_root.json`'s `CMC` row keeps `parents: []`,
  `relations: []`, unchanged.
- **DEBT #47 — Core Epistemic Structure block for existing documents.** Tracked as before: applies
  only to templates/files declaring `ces: required`; existing programme documents (Genesis,
  Universe, glosa paper, textbook front matter) get the block at each one's own next version, never
  a retro-edit of a deposited record. No change to this policy at v1.5.
- **DEBT #48 — catalogue typesetting, overfull boxes, MCP cold start.** Entry names carrying raw
  ASCII math notation (e.g. `s^L_t`, `Gamma_t`, `q^min_t`) now typeset with real superscripts,
  subscripts and Greek letters in the printed catalogue — spot-checked this pass
  (`pdftotext catalogue.pdf -`): "Labour income share s^L_t" renders as "Labour income share sL",
  "Effective claim Gamma_t" as "Effective claim Γt", "Minimum sufficient q^min_t" as "Minimum
  sufficient qtmin" (plain-text extraction linearises the sub/superscripts, but the literal caret
  and underscore characters are gone). `latex/catalogue.log`
  (this pass's `make catalogue` run) carries **0** `Overfull \hbox` warnings over 20pt (`grep`
  count), down from the 38 named in the DEBT item. The MCP server's cold-start rebuild-on-every-run
  defect (root cause: `RegistryCache.ensure_fresh()` called `index.build_index()` unconditionally,
  ignoring an already-fresh on-disk index) is fixed and tested (`mcp/BENCHMARKS.md`'s 2026-09-07
  "MCP cold-start prebuilt index" entry); `make build` now also runs `mcp/scripts/build_index.py`,
  so a release ships `mcp/state/index.sqlite3` prebuilt rather than rebuilding it on first use.
- **DEBT #49 — glosa KG-hook allowlist.** Resolved in the glosa repository (commit `c16f5bd`, per
  `ops/HANDOFF_OVERNIGHT_2026-09-06.md`), not this one — noted here only for completeness since it
  shared the same debt list.

### Recursive Epistemic Tunnel v2.1 registrations

The deposited paper "The Recursive Epistemic Tunnel" v2.1 (10.5281/zenodo.22639311, concept DOI
10.5281/zenodo.22639309) cited existing Toledo codes and proposed further equations of its own. Per
`EQUATION_SOURCE_POLICY.md`'s required procedure, each proposed equation was checked against this
registry under the φ-criterion before registration:

- **23 new readings** (`RET-N01`–`RET-N23` in the manuscript's own registrar numbering), all under
  existing roots — `origin.doi` = **10.5281/zenodo.22639311**, `LINEAGE.jsonl` `assigned` events:

  | Reading | Code | Name |
  |---|---|---|
  | RET-N01 | `EQ-015/H.40.v1` | Recursive epistemic network state |
  | RET-N02 | `EQ-002/H.05.v1` | Agent-level network readout |
  | RET-N03 | `EQ-002/H.06.v1` | Readout-of-readout recursion |
  | RET-N04 | `EQ-015/H.41.v1` | Recursive Epistemic Reflection (RER) minimal cycle |
  | RET-N05 | `weld/H.35.v1` | Agent-count / provenance-route-count non-collapse |
  | RET-N06 | `weld/H.36.v1` | Agreeing agents does not entail independent epistemic routes (network Epistemic Mirror Effect) |
  | RET-N07 | `A.8/M.20.v1` | Typed provenance DAG |
  | RET-N08 | `EQ-015/H.42.v1` | RET diagnostic state vector |
  | RET-N09 | `weld/H.37.v1` | Evidence-driven convergence regime |
  | RET-N10 | `EQ-015/H.43.v1` | Tunnel-contraction regime |
  | RET-N11 | `EQ-015/H.44.v1` | Recursive Epistemic Tunnel (RET) |
  | RET-N12 | `EQ-015/H.45.v1` | Collective Epistemic Hallucination (CEH) status-inflation chain |
  | RET-N13 | `EQ-015/H.46.v1` | Multi-model consensus readout |
  | RET-N14 | `EQ-015/H.47.v1` | Consensus does not entail validation |
  | RET-N15 | `A.5/H.24.v1` | Agent accuracy gain does not entail network corrigibility gain |
  | RET-N16 | `A.8/M.21.v1` | AI-Independent Consequence Requirement |
  | RET-N17 | `A.8/M.22.v1` | AI-Off World-Closure (AOWC) cycle |
  | RET-N18 | `A.8/M.23.v1` | AOWC gate conditions |
  | RET-N19 | `A.8/M.24.v1` | AI-off software closure application |
  | RET-N20 | `EQ-002/M.04.v1` | Simulation success does not entail world validation |
  | RET-N21 | `EQ-015/H.48.v1` | RET network stop rule |
  | RET-N22 | `EQ-015/H.49.v1` | Session reset does not entail epistemic reset |
  | RET-N23 | `weld/W.11.v1` | Effective independent validation capacity |

- **23 occurrences added to existing codes** (no new entries; each an `occurrence_added`
  `LINEAGE.jsonl` event citing the DOI), on `EQ-015/M.01.v1`, `EQ-015/M.02.v1`, `weld/M.02.v1`,
  `weld/M.03.v1`, `A.8/M.01.v1`, `EQ-015/E.03.v1`, `EQ-015/E.08.v1`, `weld/E.03.v1`,
  `A.5/H.01.v1`, `EQ-015/H.04.v1`, `EQ-015/H.05.v1`, `EQ-015/H.10.v1`, `EQ-015/H.11.v1`,
  `weld/H.07.v1`, `weld/H.08.v1`, `EQ-015/H.14.v1`, `A.5/H.08.v1`, `EQ-015/H.16.v1`,
  `EQ-015/H.18.v1`, `EQ-015/H.23.v1`, `EQ-015/H.24.v1`, `A.8/M.02.v1`, `EQ-002/M.03.v1` — see
  `registry/proposals/recursive_epistemic_tunnel_v2_0.merged.json` for the exact
  proposal-id/occurrence-id → code map (23 `OCC-CAN-*` occurrence keys, 23 `PROP-RET-*` new-reading
  keys, one-to-one with the table above and this list).

(23 + 23 confirmed by counting the merged proposal file's own keys.) Deposited separately as its
own Zenodo record (10.5281/zenodo.22639311, concept 10.5281/zenodo.22639309); merged into
`registry/CANONICAL.json` for this v1.5.0 release. The manuscript's own independent adversarial
review found 4 must-fix items against its v2.0 draft (a tier stated as `Dr` where the registry
records `Definition`; internal-programme references cited without a DOI/version; two occurrences
listed as used but never actually invoked in the text; one restated code missing a "(reading)"
flag) — these were fixed in the v2.1 manuscript this registration cites, not carried into Toledo's
own registry as open items.

### Root registry extension R2: Information Discrete Mathematics

Founder ruling 2026-09-08 ("เอา idm เอาเข้า toledo ก่อน และใน idm ให้อัพเดทรหัสสมการให้ตรงกับ
toledo, ultracode", relayed in `ops/HANDOFF_OVERNIGHT_2026-09-06.md`): bring
`information-discrete-math` (IDM, public, MIT, commit `147fc92671f35eb102405fec913eb361dc41f966`)
into the root registry, using the same no-invented-numbering mechanism R1 already established,
before updating the IDM repository itself to carry the codes Toledo assigns it.
`scripts/v16_idm_merge.py` applied the Toledo-side half; full detail in
`registry/GENESIS_CODE_SCHEME.md`'s own "Root registry extension R2" addendum.

- **18 roots added**, every one of IDM's own Layer-0 objects, code = IDM's own verbatim id, never
  re-prefixed: `delta_R` (the primitive — a retained difference exists), `RD1`–`RD9` (the nine
  Axioms of Retained Difference), `D` (the naturals), `Z` (the integers), `Q` (the rationals), `R`
  (the reals — the continuum as a readout), `L_R` (the relation graph / `L_R = D_W − W`),
  `Keystone` (`B(Φ,Φ) = I(Φ)`), `A2` (FOLD, the generic accumulation engine), `A3` (DECISION, the
  witness-search engine).
- **Connection to Genesis, by quote only — never guessed:** exactly **3** quoted textual links
  were found (`registry/GENESIS_CODE_SCHEME.md`'s own `phi_check`, `genesis_relations_asserted: 3`)
  — `delta_R` → `EQ-001` (both a claim that a primordial retained difference exists, quoted both
  sides),
  `L_R` → `EQ-008` and `Keystone` → `EQ-008` (both state the identical `L_R = D_W − W` object,
  quoted both sides). The other 15 roots (`RD1`–`RD9`, `D`, `Z`, `Q`, `R`, `A2`, `A3`) carry
  `parents: []` with a non-empty `relations_note` recording the check and its honest non-finding —
  the same disclosed-non-finding convention `CMC`'s row already uses under R1.
- **274 readings added** under these 10 code-bearing roots (`RD1`, `RD2`, `RD4`–`RD9` carry no
  readings of their own — every mirrored Coq identifier citing an `RD*` axiom directly resolves to the root `D`
  it generates): `R` 40 · `D` 80 · `Z` 23 · `L_R` 28 · `delta_R` 11 · `Q` 19 · `Keystone` 30 ·
  `RD3` 1 · `A2` 28 · `A3` 14 = 274, one per identifier in the 274/274-closed
  `coq/information-discrete-math/verify_report.json` mirror already imported at v1.0.0,
  `<root>/<D>.<nn>.v1` grammar, `coq_status: mapped_not_wrapped` (the same honest middle state R1's
  119 Theta/CMC readings held before their own wrapper pass — wrapping these into
  `coq/canonical/` files is left to a later release).
- The treatise itself — `information-discrete-math/textbook/INFORMATION_DISCRETE_MATHEMATICS.md`
  — is deposited separately: **10.5281/zenodo.22644131**. IDM's own repository (v1.6.0) was then
  updated to carry the Toledo codes this merge assigned it, per the founder's own second half of
  the ruling above.

### Master Equation River v1.6 registrations

Master Equation River v1.6 (10.5281/zenodo.22644712, a new version of the concept record
10.5281/zenodo.22414412) cites Toledo codes for its own equation set. Per
`EQUATION_SOURCE_POLICY.md`'s required procedure, its 24 equations were checked against this
registry under the φ-criterion before registration: **21** resolved to existing codes as new
occurrences (`registry/proposals/master_river_v1_6.merged.json`'s `eq_to_code` map — e.g. `eq.15` →
`EQ-015/M.08.v1`, `eq.44` → `EQ-015/M.03.v1`, `eq.79` → `weld/M.02.v1`), and **3** did not match any
existing statement under that criterion and were registered as new readings:
`EQ-015/E.16.v1`, `EQ-015/M.16.v1`, `weld/H.38.v1` (`LINEAGE.jsonl` `assigned` events, `by:
"toledo-v1.6-mr"`). No entry was merged speculatively — a same-target-code cluster (`eq.47`–`eq.49`,
all resolving to `A.5/H.02.v1`) is recorded in the merge file's own
`_open_definition_tier_mismatches` list for a human registrar to confirm the tier, not silently
accepted.

### Resistance ladder R0–R6 and reproduction evidence

Founder ruling `BBL-2026-09-07-229`: a per-object resistance readout showing **which** resistance
steps exist — never one number that hides the missing step. `scripts/compute_resistance.py`
computes, and is the only script permitted to write, a `resistance` block on every canonical entry
and root row, propagated unchanged into the site, the JSON-LD entries and the static API (never
recomputed downstream). Seven fixed rungs, each `{held, evidence[], reason?}`:

- **R0** — stated only (the entry's own `statement.latest`).
- **R1** — a pre-registered falsifier or claim boundary exists for it.
- **R2** — Coq-closed (`coq.coq_status == "closed"` — no looser value ever holds this rung).
- **R3** — a reproducible run exists: hash-frozen, `ai_at_runtime == 0`.
- **R4** — an external oracle (a published value, an independent implementation, or a public
  dataset) checked it, within a declared tolerance.
- **R5** — an independent reviewer (`independence_class >= "I2"`) or interactional-expert record
  reviewed it.
- **R6** — an AI-Off World-Closure outcome: reproducible even with the recursion loop switched off.

`held: true` on R3/R4/R6 never means the underlying check *passed* — it means the check
*happened, honestly*; a card whose own result is `FAIL` still holds those rungs. Evidence comes
from three optional citation-index files (`registry/reproduction_card_index.json`,
`registry/review_report_index.json`, `registry/claim_card_index.json`) — each a **citation** to the
real Reproduction Card / review report living in the `glosa` repository, populated by
`scripts/register_reproduction_evidence.py`, never hand-edited. The three worked cards registered
so far,
cited regardless of outcome (a disclosed `FAIL` is exactly as strong R4/R6 evidence as a `PASS`,
never softened):

| Card | Claim | Result |
|---|---|---|
| `EQ-045` | dim(u(1)) + dim(su(2)) + dim(su(3)) = 12, checked against a from-scratch stdlib computation of the general closed-form Lie-algebra dimension formulas | **PASS** — 1 + 3 + 8 = 12 exactly |
| `EQ-068` | The RD-to-GeV fit `Λ_RD_to_GeV = 246/v_native` predicts the Higgs boson mass, checked against the PDG Review of Particle Physics value | **FAIL** — predicted 218.00 GeV vs. PDG 125.20 GeV (74.13% relative error), disclosed exactly as measured, not softened |
| IDM ladder constants (`Q`, `R`) | IDM's own finite-series/Newton readouts of π, √2, e agree with an independent `mpmath` oracle to ≥25 correct decimal digits | **PASS** — traced to the package's own actual 30-digit working precision, tolerance set with margin below that, not tuned to the run's own output |

**R5 today: unheld for every entry.** No review report at `independence_class >= "I2"` exists yet
for any code in this registry — the rung is disclosed as not-yet-held everywhere, never filled with
a self-run or a same-agent check standing in for an independent one.

### toledo_lint

The MCP server's 20th tool (`mcp/toledo_mcp/lint.py`), added this release: a continuum-injection
lint over a statement's own text (LaTeX, ascii-math, or prose), checked against the
`information-discrete-math` skill's contaminated-concept → discrete-replacement table (**15**
rules — `len(lint.RULES)`, e.g. flagging an unguarded continuum limit, a bare "smooth function", a
point of zero size, or a continuum angle/degree). It **warns, it never blocks**: `verdict` is
`"clean"` or `"continuum_injection_warned"`, each finding naming the matched rule and, where the
statement resolves to a known code, that code — a lint finding is a flag for a human reviewer to
read, not a gate that stops a build or a registration.

### Website

The public, human-readable documentation site at **<https://morrocwi.github.io/toledo/>** is built
by `python3 site/build_site.py --out site/dist --strict` (this pass: **2,581** pages — home,
`/browse/` a flat no-JS directory of every code, one page per Layer-0 root (`/by-root/`), one page
per domain letter (`/by-domain/`), one page per populated tier (`/by-tier/`) and status
(`/by-status/`), one page per canonical entry/root row (`/entries/`), `/search/`, `/agents/`,
`/about/`, and (new at v1.6) `/ecosystem/` — how Toledo relates to the other public repositories in
the programme, rendered from `site/content/ecosystem.md`, its one Mermaid flowchart rendered
client-side (CDN+SRI, the same carve-out KaTeX already uses; no `mermaid-cli` is installed on this
machine to pre-render an SVG at build time instead)), sharing one GitHub Pages deployment with the
existing static API at `/v1/` (`mcp/docs/STATIC_API.md`).

- **A human reader** starts at `/` or `/browse/` and follows a code to its `/entries/<code>.html`
  page — statement, tier/status/`coq_status`, parents, occurrences, ancestry — or filters by
  `/by-root/`, `/by-domain/`, `/by-tier/`, `/by-status/`.
- **An AI agent** goes straight to `/agents/`: the founder rule restated verbatim (every equation
  is looked up in Toledo before use; no agent may use an unregistered equation), the 20-tool table
  reproduced from `mcp/README.md`, the `.mcp.json` snippet, a `curl` line against `/v1/`, a minimal
  runnable stdlib-only Python lookup example, and an embedded JSON-LD `Dataset`/`APIReference`
  block for a crawler that only parses structured data.
- **The status glossary** — what `current`, `superseded_by`, `split`, `not_an_equation`,
  `unverified`, `historical`/`imprecise_as_stated` each mean, and the `coq_status` ladder above —
  is published on `/about/`, computed at build time from the registry, never hand-typed.
- **CI deploy**: `.github/workflows/toledo-mcp-ci.yml` builds the human site and the static API as
  two separate, independently-failing jobs (a broken template cannot take the live `/v1/` mirror
  down with it, and vice versa), then a third job merges both into the one Pages artifact, on every
  push to `main` that touches `mcp/**` or `registry/**` — a documentation-only commit does not
  trigger a redeploy, so the live site can lag until the next such push. Full specification:
  `site/DESIGN.md`.

### Provenance note: readout_genesis anchor

DEBT #51. This registry's `readout_genesis` import (`coq/readout_genesis/PROVENANCE.json`) is
anchored to commit `082dde893b70c7500c13d463239909c99cf17f0a` of the local `readout_genesis`
working tree. Checked this pass (`git ls-remote https://github.com/morrocwi/readout_genesis.git
HEAD`): that commit is **not** present on the repository's public GitHub remote — the public
branch head there is `04cde19be2c885a11b42597b1cdb60fb5b7ca1bb`. A public, third-party reader can
therefore verify the files this Toledo release imports only up to that public head; the difference
between the public head and this import's local anchor is three local, unpushed commits, the
substantive one being the Face XI closure ("Face XI closed as an iff: shared readout forces shared
tau_c"). Whether and when to push those commits to the public remote is the founder's decision, not
this registry's — this note records the honest gap between "anchored to" and "publicly verifiable
up to" without resolving it. The same note is recorded, dated, in
`coq/readout_genesis/PROVENANCE.json`'s own `anchor_publication_note` field.

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

**Theta and CMC (action taken at v1.2).** `registry/root_candidates_report.md` had flagged these two
bodies of work as candidate Layer-0 roots at v1.1 but added no row for either, pending a founder
decision. That decision came 2026-09-07 (BBL-2026-09-07-207) — see "Root registry extension R1"
above for the two rows now added, their anchors, and the connection evidence (`Theta` links to
`EQ-008`/`EQ-022`; `CMC` has no evidenced connection to a Genesis root and its row says so plainly
rather than asserting one). The v1.5 debt pass re-ran this same search for `CMC` directly, over the
full body of every source file rather than only headers, and reached the identical zero result —
see "Debt pass (v1.5)" above and `registry/cmc_connection_report.md`.

## What is not done (v1.6 carry-overs)

Honestly disclosed, not hidden in a rounded-up claim:

- **274** `mapped_not_wrapped` Coq readings (the new v1.6 `information-discrete-math` root
  extension, R2) have an evidence-backed match against an already-verified imported identifier but
  no Toledo-native wrapper file yet — the same real gap the 119 v1.2 Theta/CMC readings once held,
  reintroduced here rather than left unregistered; wrapping them is future work, not attempted this
  pass (see "Root registry extension R2" above).
- **210** `wrapped_related` Coq wrappers alias an imported identifier rather than independently
  closing their own entry's statement (see "The coq_status ladder" above) — a real gap between
  "a Toledo file exists for this" and "this entry's own claim is proved". Unchanged since v1.5's own
  examination found none of the 210 had a derivable independent closure.
- **70** canonical entries are `not_formalisable` (no formal content located in the source; reason
  recorded per-entry in `tier_evidence`) and **52** are `open_prop` (stated as an unproved `Prop`,
  by design), unchanged since v1.5 — each carried as open exactly as the source states it, not
  forced to a stronger tier.
- **52** canonical entries remain `status: unverified`, each with a status note naming why (see
  "Statement completion" above), unchanged since v1.5's own re-check (DEBT #42) found no new
  evidence to resolve any of them.
- `RD1`–`RD9` remains evidence-checked as a distinct object from the Genesis root axioms (see the
  finding above), not an omitted alias — no code has been invented for it. IDM's own claim that its
  `RD1`–`RD9` are "the exact same" object as that checked mirror is recorded and transfers the
  finding (see "Root registry extension R2" above); it is not a second, independent re-check.
- **245** canonical entries still carry tier `untagged` (no tier was stated in their source at
  all) — unchanged since v1.5 (this pass tagged no new entries).
- **233** genesis-root rows still carry only their free-text `tier_in_genesis` string, not a
  normalised `tier` — up from 215 at v1.5 by exactly the 18 new R2 rows, none of which was
  normalised this pass (each keeps IDM's own verbatim tier tag as its free-text string).
- **CMC has no evidenced connection to a Genesis root** (DEBT #46) — unchanged since v1.5; a
  candidate structural-resemblance sentence is still drafted in `registry/cmc_connection_report.md`
  for the founder to confirm, reject, or restate, not asserted as a finding.
- The `readout_genesis` import anchor is a local revision not present on that repository's public
  GitHub remote (DEBT #51) — see "Provenance note: readout_genesis anchor" above. Whether and when
  to publish those commits is the founder's decision, not resolved by this release. The public
  `information-discrete-math` repository was found, during the R2 root-extension work, to carry
  the same private-repository name in 6 files (unrelated to the anchor gap above) — scrubbed in the
  same commit that landed R2's own Toledo codes into that repository; its git history still carries
  it, the same founder decision as the anchor gap.
- **R5 (independent reviewer) is unheld for every entry in this registry** — no review report at
  `independence_class >= "I2"` exists yet anywhere (see "Resistance ladder" above). This is the
  Ladder's own honest starting state, not a regression.
- Citing `weld/H.30.v1`–`weld/H.34.v1` into glosa card P20's own text is tracked in the glosa
  repository, not here (see "Core Epistemic Structure" above).
- The 210 v1.2 Theta/CMC readings' own wrapper files, and the 246 not-yet-formalised entries from
  earlier releases, remain exactly as disclosed in their own release notes above; this release did
  not revisit them.
- `mcp/scripts/leak_scan.py`'s `private_repo_name` category was run against every file changed this
  release but without a `--denylist-file`/`TOLEDO_LEAK_SCAN_DENYLIST_FILE` (this release-prep pass
  has no access to the actual private-repository name to supply as one) — it reported 0 findings
  for every other category, and this one category is disclosed as not-yet-run, not a clean result,
  per the script's own warning. A structural, name-independent check did catch and fix one real
  instance this pass (`site/content/ecosystem.md`'s duplicate, unredacted description of the same
  private repository — see the CHANGELOG's v1.6.0 entry), but that does not substitute for the
  denylist-backed scan closing this category out.

## Citation

Cite the Zenodo concept DOI, which always resolves to the latest release:
**10.5281/zenodo.22537318**. Or cite the specific version you used — see `CITATION.cff` and
`.zenodo.json`. Source: <https://github.com/morrocwi/toledo>.

## Licence

- **Registries, docs, generated views** (`registry/`, `docs/`, `graph/`, `vault/`,
  `registry/EQ_LIBRARY.md`): **CC BY 4.0**.
- **Coq sources and scripts** (`coq/canonical/`, `coq/master-river/`, `mcp/`, `scripts/`): **MIT**.
- **Imported Coq developments** (`coq/<source>/`) keep their own upstream licence — see each
  source's `LICENSE.upstream` file and its `PROVENANCE.json` for the exact commit copied
  (`coq/readout_genesis/LICENSE.upstream` records that the upstream repository carries no licence
  file; that import rests on the author's own same-author import policy, stated there). The
  private solver-arc import is the one exception: its sources are copied in under an explicit MIT
  grant (BBL-198, `coq/solver-arc/LICENSE_NOTE.md`) rather than an upstream licence file, and its
  repository name is never written — only `"solver arc (private)"` plus a commit reference.
- **MCP server, CLI and static-API package** (`mcp/`, i.e. `toledo_mcp/`, `mcp/scripts/`,
  `mcp/tests/`): **MIT** (see `mcp/pyproject.toml`).

An AI assistant assisted under the author's direction; no AI system is an author or contributor.

Author: Yaoharee Lahtee (Open Civil Science Initiative).
