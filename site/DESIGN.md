# Toledo public site — design specification

Status: specification for implementation. Supersedes nothing in `mcp/DESIGN.md` (that document
specifies the MCP package); this document specifies **`site/`** — the human-readable GitHub Pages
site at <https://morrocwi.github.io/toledo/> — and the one change to `.github/workflows/toledo-mcp-ci.yml`
that deploys it together with the existing static API under `/v1/`.

Authority for this document: founder instruction BBL-2026-09-07-222. Synthesised from a three-proposal
design review with the grafts listed in that instruction folded in; each graft's origin is named inline
below where it changed something so the reasoning stays traceable.

**One correction made while writing this spec, per this workspace's readout-not-truth discipline:**
one graft asked to adopt a proposal's stated search-ranking weights (exact code=100, code-prefix=60,
name=40, root/domain/tier=25, snippet=10) verbatim. Reading `mcp/toledo_mcp/core.py::_score_entry`
directly (the function `toledo_search`'s own ranking actually calls, confirmed via
`mcp/toledo_mcp/queries.py`'s comment pointing at it) shows different real numbers, and no
root/domain/tier term exists in the code at all. This document states the **verified real weights**
below (Search index format and client script) rather than the proposal's unverified figures — citing an
unread claim as settled is exactly the failure mode this workspace's epistemic rule exists to catch.

## 0. Goals and constraints (restated, binding)

- A human reader understands the site at once; an AI agent can use it immediately (`/agents/`).
- Static only (GitHub Pages). No build-time network calls anywhere in `site/build_site.py`,
  `site/checks/*.py`, or `tests/test_site.py`.
- Every asset is self-hosted except KaTeX, loaded from a CDN with SRI (pinned version, below).
- Reading works with JavaScript disabled; search is a progressive enhancement over the same data.
- Accessible: heading structure, contrast, full keyboard operability, KaTeX `output: 'htmlAndMathml'`.
- Responsive: no fixed-width layouts, one shared stylesheet, works from a phone viewport up.
- Fast: index-shaped pages (home, browse, search, agents, about, every by-root/by-domain/by-tier/
  by-status listing) stay under 200 KB uncompressed HTML.
- Theme-aware: light/dark via CSS custom properties, `prefers-color-scheme`-driven by default.
- Every number on the site is computed at build time from `registry/TOLEDO.json` /
  `registry/CANONICAL.json` / `mcp/dist/static-api`, never typed by a person into a template.
- No priority/comparative marketing words anywhere the generator itself authors prose. No AI vendor/
  model names. No `/home` paths or usernames. Never the private solver-arc repository's name — always
  "solver arc (private)" (already the convention `registry/CANONICAL.json`'s `origin`/`coq.imported_from`
  fields use; the site only ever displays those fields, never re-derives the name).
- `site/build_site.py` and `site/checks/` may read the registry and `mcp/dist/static-api`. They must
  never write to `registry/*.json`, `LINEAGE.jsonl`, `coq/`, `latex/`, or any `mcp/toledo_mcp/*.py`
  file other than reading `export_static.mangle_code` (see §5).

## 1. URL scheme

Two trees share one Pages deployment (layout decision, §8): the human site at the artifact root, the
existing static API unchanged under `/v1/`.

```
/                                   site home
/browse/                            flat, no-JS, Ctrl+F-able directory of every code (universal fallback)
/by-root/<root-slug>/                one page per Layer-0 root: the root row + every reading under it
/by-domain/<letter>/                 one page per domain letter (E H S W M P C B)
/by-tier/<tier-slug>/                one page per populated tier value
/by-status/<status-slug>/            one page per populated status value
/entries/<site-slug>.html            one page per canonical entry + root row (today: 1,559)
/search/                             text-filter UI over a small client-side index (JS-enhanced)
/agents/                             machine-consumption guide: rule, curl/CLI/MCP/Python, JSON-LD
/about/                              licence, citation, honest coverage numbers, policy summary
/assets/toledo.css                   one shared stylesheet
/assets/search.js                    the search-page client script
/data/*.json                         generated data files (§4) — never hand-edited, never templates

/v1/...                              unchanged: mcp/toledo_mcp/export_static.py's own contract
                                      (mcp/docs/STATIC_API.md) — manifest.json, entries/<mangled>.json,
                                      by-root/, by-domain/, search-index.json, counts.json,
                                      verdict-rules.json, plus its own landing index.html at /v1/index.html
```

**Two distinct, deliberately different manglings, named so the difference is never accidental again**
(this is the fix behind the mangling-fix implementation note in §5):

- **`site-slug`** — `code.replace('/', '__').replace('.', '_')` (hyphen **kept**). This is the existing
  `vault/` and `registry/entries/` on-disk convention (`EQ-015/B.01.v1` → `EQ-015__B_01_v1`, hyphen
  intact) — human-facing site URLs reuse it unchanged so the ~1,559 existing generated pages, their
  inbound links from `vault/*.md`, and `registry/entries/*.json` stay addressable without renaming
  anything already on disk.
- **`api-mangled`** — `code.replace('/', '__').replace('.', '_').replace('-', '_')` (hyphen **stripped**),
  `registry/SCHEMA.md`'s own Coq-file-name mangling rule, reused verbatim by
  `mcp/toledo_mcp/export_static.py::mangle_code` for every `/v1/entries/<...>.json` filename
  (`EQ-015/B.01.v1` → `EQ_015__B_01_v1`, hyphen gone).

Verified on this checkout (not assumed): `vault/EQ-015__B_01_v1.md` and
`registry/entries/EQ-015__B_01_v1.json` both keep the hyphen; `mcp/dist/static-api/v1/entries/EQ_015__B_01_v1.json`
does not. Any entry-page link into `/v1/entries/...` must use `api-mangled`, not `site-slug` — see §5.

## 2. Page templates (`site/templates/`, owned by S2)

Plain-text template files with `{{field}}` placeholders, filled by `site/build_site.py` via a small
stdlib-only substitution helper (no Jinja2 — no new dependency, matching the existing stdlib-only
build). One shared `base.tmpl.html` (doctype, `<head>` with the CSS link + theme script + optional
KaTeX tags, header/nav/skip-link, `<main>` slot, footer) that every other template extends by
providing its own inner content:

| Template | Renders | Consumes |
|---|---|---|
| `base.tmpl.html` | shared shell (head, header, nav, footer, skip-link) | site metadata, page title |
| `home.tmpl.html` | `/index.html` | `data/manifest.json` |
| `browse.tmpl.html` | `/browse/index.html` | full compact-entry list, natural code order |
| `listing.tmpl.html` | every `/by-root/`, `/by-domain/`, `/by-tier/`, `/by-status/` page | that axis's compact-entry rows |
| `entry.tmpl.html` | `/entries/<site-slug>.html` | one full `registry/entries/<site-slug>.json` object |
| `search.tmpl.html` | `/search/index.html` | nothing server-rendered but a no-JS notice + `/browse/` link |
| `agents.tmpl.html` | `/agents/index.html` | `data/manifest.json`, `data/tools-table.json` (§6), coverage split (§9) |
| `about.tmpl.html` | `/about/index.html` | `data/manifest.json`, counts, licence/policy summary |

`entry.tmpl.html` section order (fixed, so every entry page is structurally identical for a screen
reader or an agent parsing it): breadcrumb → `<h1>` code → tier/status/coq_status badges → Statement →
**Ancestry** → **Full relations** → Occurrences → Coq → Origin/provenance → embedded JSON-LD → API
footer link.

- **Statement** renders per `statement.format`: `latex` / `latex+ascii` → KaTeX-rendered display math
  (source LaTeX also present as visible text so no-JS/no-KaTeX readers still get the formula, and a
  screen reader gets pre-generated `presentation_mathml` when present, §9); `ascii-math` → the ascii
  text in a `<pre>`; `coq` → the literal Coq declaration in a `<pre><code>` block; `prose` → plain text
  (this is the one entry whose `status` is `not_an_equation`; it is captioned as pointing to prose, per
  `README.md`'s own verdict rule 4, never presented as a formula).
- **Ancestry** (graft, Proposal 2's terminology, chosen because it mirrors the MCP tool split a reader
  or agent already sees documented in `mcp/README.md`) — the **primary parent chain**: walk
  `parents[0]` back to a root, exactly what `toledo_lineage`'s "ancestry chain" returns. This is the
  short, single-path view most readers want first.
- **Full relations** (`<details>`, collapsed by default, keyboard-operable via native `<details>`
  semantics — no custom JS widget) — the **full parents/children/relations DAG**: every entry in
  `parents[]` (not just `[0]`), every computed `children[]`, and `relations[]`/reverse relations —
  exactly what `toledo_ancestors`/`toledo_descendants`/`toledo_neighbours` return. Naming both
  sections after the tool split means a reader who later uses the MCP tools finds the same two-tier
  distinction already familiar.

## 3. Listing pages

`/browse/` and every `/by-root/`, `/by-domain/`, `/by-tier/`, `/by-status/` page are **fully
pre-rendered HTML tables** at build time — no client JS required to read any of them (the "reading
works with JS disabled" constraint applies to these first). Each row: code (linked to its
`/entries/<site-slug>.html`), name (truncated to ~90 chars in the table, full name on the entry page),
tier, domain, status. `/browse/` sorts in natural code order (root, then domain letter, then sequence
number, then revision — the same order `registry/SCHEMA.md`'s code grammar implies and the catalogue
PDF already uses) and is the one universal fallback path a reader (or a machine doing a literal-text
`Ctrl+F`/`grep` over the fetched HTML) can always land on regardless of which axis they know the code
by, per the graft asking for exactly one such flat, no-JS page.

**Perf-budget contingency**, decided now rather than left implicit: at 1,559 rows and a compact
per-row markup, `/browse/` is estimated in the 150–180 KB range — under the 200 KB budget today, but
the budget is enforced by a build-time check (§10), not by the estimate. If a future registry growth
pushes `/browse/` over budget, the specified fallback (do not implement until the check actually
fails) is alphabetical sharding by the code's first character band (`/browse/A-F/`, `/browse/G-M/`, …)
with `/browse/index.html` reduced to the band links — never silently truncating the listing.

## 4. Generated data files (`site/data/`, owned by S1)

Every file here is written by `site/build_site.py` from the registry/`mcp/dist/static-api` read at
build time — never hand-edited, and (matching the API's own honesty convention, `STATIC_API.md`)
never fabricated from a fallback assumption:

| File | Shape | Consumed by |
|---|---|---|
| `data/manifest.json` | `{generated_at, generated_from_commit, registry_release_version, entry_count, counts_by_status, counts_by_domain, counts_by_tier, counts_by_coq_status, mathml_present, mathml_reason_only, statement_format_counts}` — every field read from `registry/CANONICAL.json`'s own `counts{}` plus the two split computations in §9, none hand-typed | home, about, agents templates |
| `data/search-index.json` | array of `{code, name, root, domain, tier, status, coq_status, excerpt}` — `excerpt` = the first ~140 chars of `statement.latest` with LaTeX/ascii-math markup stripped to plain words | `assets/search.js` |
| `data/tools-table.json` | the 19-row `{tool, purpose}` table, **parsed at build time from `mcp/README.md`'s own `## Tools (19)` section** (a small markdown-table-row regex, not hand-copied) | agents template |

`data/tools-table.json` being parsed rather than hand-copied is the structural fix; §10 additionally
tests it, as defense in depth rather than the only safeguard (graft: "so the two can never silently
drift apart").

## 5. The mangling fix — implementation note

**The bug** (verified above, §1): `site/build_site.py`'s own `code_safe()` keeps the hyphen; the
static API's `mangle_code()` strips it. Every place the redesigned site needs to point at a
`/v1/entries/<...>.json` file — the entry page's API footer link, and the `/agents/` runnable example —
must produce the hyphen-stripped form, or the link 404s for any code whose root carries a hyphen
(every `EQ-0nn` root: 40%+ of the registry).

**The fix**, requiring zero edits to `mcp/toledo_mcp/export_static.py` (it already exports the
function `site/` needs):

```python
try:
    from mcp.toledo_mcp.export_static import mangle_code
except ImportError:
    import sys, pathlib
    sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent / "mcp"))
    from toledo_mcp.export_static import mangle_code
```

— the same `sys.path` fallback `export_static.py` itself already uses to be importable both as an
installed package and a bare script. `site/build_site.py`'s existing `code_safe()` function is kept,
renamed `_old_vault_mangle()`, and its **only** remaining job is locating the already-on-disk
`vault/<name>.md` and `registry/entries/<name>.json` input files by their current (hyphen-kept) names
— it must never again be used to construct a `/v1/...` URL. Every `/v1/entries/...` reference in the
generated HTML calls `mangle_code(code)` from the imported function instead.

## 6. `/agents/` page content

- Restates the founder rule verbatim from `README.md`/`mcp/README.md`: every equation is looked up in
  Toledo before use; no agent may use an unregistered equation.
- The reproduced 19-tool table (`data/tools-table.json`, §4) — always structurally identical to
  `mcp/README.md`'s own table, since it is parsed from it.
- `.mcp.json` snippet (verbatim from the repository root's own file) and a one-line CLI install
  (`pip install -e mcp/`).
- A `curl` line: `curl https://morrocwi.github.io/toledo/v1/entries/EQ_015__B_01_v1.json`.
- **The minimal, runnable, stdlib-only Python example** (graft, Proposal 2 — the one piece the prior
  agent-page draft lacked: something an agent can execute unmodified, not just read):

  ```python
  #!/usr/bin/env python3
  """Look up a Toledo code before citing it — the founder rule, enforced client-side."""
  import json
  import urllib.request

  code = "EQ-015/B.01.v1"
  mangled = code.replace("/", "__").replace(".", "_").replace("-", "_")
  url = f"https://morrocwi.github.io/toledo/v1/entries/{mangled}.json"

  with urllib.request.urlopen(url, timeout=10) as resp:
      doc = json.load(resp)

  verdict = doc["verdict"]
  if verdict["usable"]:
      print(f"cite {doc['entry']['code']}: {doc['entry']['name']}")
  else:
      print(f"do not cite ({verdict['verdict']}): {verdict.get('reason', '')}")
      print("call the live MCP server instead — this static copy is eventually consistent")
  ```

- An embedded JSON-LD block (graft, Proposal 1) for a crawler/agent that only parses structured data,
  not prose — `schema.org` `APIReference`/`Dataset` with `potentialAction` entries pointing at
  `/v1/manifest.json`, `/v1/search-index.json`, `.mcp.json`, and the CLI:

  ```json
  {
    "@context": "https://schema.org",
    "@type": "Dataset",
    "name": "Toledo equation registry — static read API",
    "url": "https://morrocwi.github.io/toledo/v1/manifest.json",
    "potentialAction": [
      {"@type": "SearchAction", "target": "https://morrocwi.github.io/toledo/v1/search-index.json"},
      {"@type": "ConsumeAction", "target": "https://morrocwi.github.io/toledo/v1/entries/{mangled_code}.json"}
    ]
  }
  ```

- The honest coverage disclosure line (§9), computed at build time, not typed.
- A link to the static-API contract summary (a paraphrase of `mcp/docs/STATIC_API.md`'s "Should /
  Should not" section — never gate a founder-rule decision on the static export alone; call the live
  MCP server when available).

## 7. CSS token system (`site/assets/toledo.css`)

One stylesheet, system font stack only (no web-font network request — reduces the site to exactly one
external origin, the KaTeX CDN, and only on pages that render math). Tokens on bare `:root`
(light, default), overridden under `@media (prefers-color-scheme: dark)`:

```css
:root {
  color-scheme: light dark;
  --bg: #fbfbf9; --bg-raised: #ffffff; --fg: #1a1a1a; --fg-muted: #55534d;
  --border: #d8d5cc; --link: #1c5fb0; --link-visited: #5b3a9e; --focus-ring: #1c5fb0;
  --code-bg: #f0efe9;
  --pill-tier-bg: #e4e0d4; --pill-status-current: #1e6b3a; --pill-status-caution: #9a5b00;
  --pill-status-bad: #a4292c;
}
@media (prefers-color-scheme: dark) {
  :root {
    --bg: #15171a; --bg-raised: #1c1f23; --fg: #e8e8e6; --fg-muted: #a8a69f;
    --border: #33363b; --link: #8ab4f8; --link-visited: #c58af9; --focus-ring: #8ab4f8;
    --code-bg: #202327;
    --pill-tier-bg: #2a2d31; --pill-status-current: #4fbf72; --pill-status-caution: #d9932f;
    --pill-status-bad: #e0585c;
  }
}
body { background: var(--bg); color: var(--fg); font: 1rem/1.5 -apple-system, "Segoe UI", sans-serif; }
```

Every color token is defined once in a light block and once in a dark block — never only inside the
media query — per this workspace's own theme-aware-page convention, kept here even though this is a
plain static site because the same failure mode (a color with only a dark-mode
definition, invisible in light mode or vice versa) applies equally to any static page.

## 8. Pages workflow change

**Layout decision:** site at the Pages artifact root, static API under `/v1/` — §1's URL scheme is the
concrete answer to "decide the layout".

**Compartmentalization** (graft, Proposal 1's named risk — adopted as a job-boundary mitigation, not
left as a risk note): the human-site build and the static-API export stay two **separate, independently
failing** CI jobs, each uploading its own plain build artifact; a third job merges them into the one
Pages artifact. This is deliberately not a single job, so a broken template cannot silently take the
live `/v1/` API mirror down with it, and a broken static export cannot block the human site from
deploying either.

```yaml
# .github/workflows/toledo-mcp-ci.yml — additions/changes only; test/build-index/leak-scan unchanged.
  build-site:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: "3.12" }
      - run: pip install -e mcp/                      # build_site.py imports mangle_code from it
      - run: python3 site/build_site.py --out site/dist
      - run: python3 -m pytest -q tests/test_site.py
      - run: python3 site/checks/run_all.py site/dist  # a11y + perf + leak/word-scan, §10
      - uses: actions/upload-artifact@v4
        with: { name: site-dist, path: site/dist, retention-days: 1 }

  export-static:                                        # unchanged logic, output now a plain artifact
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: "3.12" }
      - run: pip install -e mcp/
      - run: python3 -m toledo_mcp.export_static --out mcp/dist/static-api
      - uses: actions/upload-artifact@v4
        with: { name: static-api-dist, path: mcp/dist/static-api, retention-days: 1 }

  assemble-pages:
    runs-on: ubuntu-latest
    needs: [build-site, export-static]
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/download-artifact@v4
        with: { name: site-dist, path: merged }
      - uses: actions/download-artifact@v4
        with: { name: static-api-dist, path: merged/v1-src }
      - run: |
          mkdir -p merged/v1
          cp -r merged/v1-src/v1/. merged/v1/
          cp merged/v1-src/index.html merged/v1/index.html   # export_static's own landing page
          rm -rf merged/v1-src
      - uses: actions/upload-pages-artifact@v3
        with: { path: merged }

  deploy-pages:
    needs: assemble-pages                                # was: needs: export-static
    if: github.ref == 'refs/heads/main'
    permissions: { pages: write, id-token: write }
    environment: { name: github-pages, url: "${{ steps.deployment.outputs.page_url }}" }
    runs-on: ubuntu-latest
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
```

No change is needed inside `export_static.py` for this layout: it already writes everything under
`<out>/v1/`, plus its own convenience `index.html` one level up — `assemble-pages` just relocates that
one file to `/v1/index.html` on copy so `/v1/` itself resolves to something on Pages instead of a
directory listing, rather than the site's own `/index.html` being overwritten by it.

## 9. Honest coverage disclosure (computed, not typed)

Per the graft asking to turn the winner's own uncertainty into a published, build-time-generated
disclosure rather than an implementer TODO. Verified directly against `registry/entries/*.json` while
writing this spec (1,559 files, matching the site's own current page count):

- **`presentation_mathml` coverage:** 421 entries carry a real value; 1,138 carry only a
  `presentation_mathml_reason` (no MathML could be generated for that statement). `data/manifest.json`
  exposes both counts as `mathml_present`/`mathml_reason_only`; `/about/` and `/agents/` render them as
  a plain sentence ("421 of 1,559 entries carry pre-generated MathML; the rest fall back to KaTeX's own
  MathML output at render time, or plain text with no JavaScript") rather than a rounded-up "MathML
  supported" claim.
- **`statement.format` split:** `ascii-math` 592 · `latex+ascii` 424 · `latex` 423 · `coq` 119 ·
  `prose` 1 (sums to 1,559). Same treatment: published as a plain-language sentence on `/about/`, not
  hidden.

Both counts are produced by the exact same read `site/build_site.py` already performs to render each
entry page — no second pass, no separate audit script; `data/manifest.json` just also records the two
tallies its own build loop accumulates.

## 10. Tests and checks

**`tests/test_site.py`** (pytest, S4):

- Every code in `registry/CANONICAL.json` (+ every root row) has a corresponding `/entries/<site-slug>.html`
  file, and that file's API footer link resolves to the correct `api-mangled` filename actually present
  under `mcp/dist/static-api/v1/entries/` (a real cross-check against the sibling build output, catching
  exactly the bug in §5 if it ever regresses).
- Every `/by-root/`, `/by-domain/`, `/by-tier/`, `/by-status/` page that should exist (one per value
  actually present in the registry) exists, and no page exists for a value with zero entries.
- `data/tools-table.json` has exactly 19 rows, each `tool` matching `^toledo_[a-z_]+$`, and the parsed
  table is byte-for-byte re-derivable from a fresh read of `mcp/README.md`'s `## Tools (19)` section
  (the drift-can't-happen structural property, asserted rather than assumed).
- `data/manifest.json`'s every count matches an independent recomputation from
  `registry/CANONICAL.json`'s own `counts{}` (never trusting the generator's own arithmetic silently).
- KaTeX is invoked (in the rendered HTML/JS, or the auto-render config literal) with
  `output: 'htmlAndMathml'` explicitly present — not relying on the library default (graft, Proposal 1:
  the one easy-to-miss screen-reader setting named as its own test item, load-bearing because only
  ~27% of entries carry pre-generated `presentation_mathml`, so KaTeX's own MathML output is the
  accessibility fallback for the rest).
- The banned-marketing-word scan (below) runs here too, asserting the verbatim-source exception is
  correctly scoped (a hit inside a `data-verbatim-source` region is reported, not failed; a hit
  anywhere else in generator-authored prose fails the build).

**`site/checks/` (S4, standalone scripts, also runnable locally, not only under pytest):**

- `check_perf_budget.py` — walks `site/dist/`, asserts every page listed in §0 as "index-shaped"
  (home, browse, search, agents, about, every listing page) is under 200 KB; reports the largest 10
  pages either way so a future regression is visible before it fails.
- `check_a11y.py` — per-page: exactly one `<h1>`, no skipped heading level, every `<table>` header
  cell is `<th scope="col">`, every interactive element is a native `<a>`/`<button>`/`<input>`/`<details>`
  (no ARIA-widget reimplementation to audit), `lang="en"` on `<html>` (and `lang="th"` on any inlined
  Thai quoted-source span), a contrast-ratio check of every token pair in §7 against WCAG AA (4.5:1
  text, 3:1 large text) for both the light and dark block.
- `check_banned_words_and_leaks.py` — scoped to `site/dist/` only (a sibling check to
  `mcp/scripts/leak_scan.py`, which stays scoped to `mcp/`; this one is not a copy of it, written fresh
  for the site's own output tree, so neither script silently drifts by editing the other's file): scans
  for a path rooted under the local `/home` hierarchy, the machine's usernames, the banned
  marketing-word list, the private solver-arc repository's real name, and any AI vendor/model name
  (reusing `mcp/scripts/leak_scan.py`'s
  own token machinery rather than a second copy of the list). **The marketing-word exception** (graft,
  Proposal 1): any hit found inside an element the templates mark `data-verbatim-source="true"` (an
  entry's own `name` or `statement` text, an occurrence `label`, a quoted paper title) is reported as a
  named WARNING for founder escalation — the source text is never silently edited — while a hit anywhere
  else (nav copy, `/about/`, `/agents/` prose the generator itself authored) is a hard FAIL. A `/home`
  path, username, the private repo's real name, or an AI vendor/model name is always a hard FAIL
  regardless of region — none of those five carries a legitimate verbatim-quote exception.
- `run_all.py` — runs the three above in sequence, non-zero exit on any hard failure, called from the
  `build-site` CI job (§8).

## 11. Build stream split and file ownership

| Stream | Owns | Scope |
|---|---|---|
| **S1** | `site/build_site.py`, `site/data/` | Reads the registry + `mcp/dist/static-api`; renders every template into `site/dist/`; writes `data/manifest.json`, `data/search-index.json`, `data/tools-table.json`; owns the §5 mangling-fix import and the §9 coverage tallies. |
| **S2** | `site/templates/`, `site/assets/` | The template files (§2), `toledo.css` (§7), `search.js` (§12) — no registry-reading logic; pure presentation and the search-ranking port. |
| **S3** | `.github/workflows/`, `site/agents/` | The CI job changes (§8); the `/agents/` page's own content assembly (§6) where it needs to be treated as a distinct authored surface from the generic templates (its JSON-LD, its Python/curl/CLI snippets) — still rendered through S1's build, but the content is S3's to write and keep current against `mcp/README.md`. |
| **S4** | `tests/test_site.py`, `site/checks/` | Everything in §10. Independent of S1–S3 by construction: it reads `site/dist/` output and the registry directly, never imports `site/build_site.py`'s internals, so it cannot pass merely because it shares assumptions with the generator it is checking. |

## 12. Search index format and client script

**`data/search-index.json`** (§4) — array of compact rows, generated once per build, never re-derived
by the client:

```json
[{"code": "EQ-015/B.01.v1", "name": "Health-stream theorem: setpoint_is_fixed", "root": "EQ-015",
  "domain": "B", "tier": "Th_coqc", "status": "current", "coq_status": "closed",
  "excerpt": "for all alpha, beta, u, dt in Q, beta != 0 implies step(...) = setpoint(...)"}]
```

**`assets/search.js`** — vanilla stdlib JS, no framework, fetched once on `/search/` page load; ranks
with the **verified real weights** ported from `mcp/toledo_mcp/core.py::_score_entry` (read directly
from the source, not assumed from a proposal — see the correction note at the top of this document):

| Match | Weight |
|---|---|
| Query equals `code` exactly | 100 |
| Query equals an alias exactly | 60 |
| Query is a substring of `code` | 40 |
| Query is a substring of an alias | 20 |
| Query is a substring of `name` | 15 |
| Query is a substring of `excerpt` (client-side stand-in for the full `statement.latest` substring match the live server checks) | 10 |
| Query is a substring of the row's own... (no occurrence labels are shipped client-side; this tier is server/API-only) | — |

```js
function score(row, needle) {
  const n = needle.toLowerCase();
  if (!n) return 0;
  let s = 0;
  const code = row.code.toLowerCase();
  if (code === n) s += 100; else if (code.includes(n)) s += 40;
  if (row.name.toLowerCase().includes(n)) s += 15;
  if ((row.excerpt || "").toLowerCase().includes(n)) s += 10;
  return s;
}
```

(The alias tiers are omitted client-side because `search-index.json`'s compact rows do not carry
`aliases` — adding them would grow every row for a rarely-hit tier; a reader who needs alias-aware
search already has the live MCP `toledo_search` tool, and `/agents/` says so.) Results render into a
`<table>` identical in shape to `/browse/`'s, sorted by score descending then natural code order,
capped at 200 rows with a "refine your search" notice beyond that. With JavaScript disabled, `/search/`
shows only the static notice and a link to `/browse/` — no broken control is ever presented.

## 13. Performance budget summary

| Page class | Budget | Basis |
|---|---|---|
| `/`, `/browse/`, `/search/`, `/agents/`, `/about/`, every listing page | < 200 KB uncompressed HTML | founder constraint; enforced by `check_perf_budget.py` |
| `/entries/<slug>.html` | soft target < 50 KB | one equation's worth of content; not a founder-stated hard budget, kept as good practice |
| `assets/toledo.css` | < 6 KB | one stylesheet, system fonts only, no icon font |
| `assets/search.js` | < 4 KB | no framework |
| KaTeX (CDN, entry pages with LaTeX statements only) | not counted against the above — excluded per the founder's own CDN-with-SRI carve-out | loaded only where `statement.format` includes `latex` |

## 14. Accessibility checklist (mirrors `check_a11y.py`)

- [ ] One `<h1>` per page; no skipped heading level.
- [ ] Skip-to-content link as the first focusable element.
- [ ] Every table has `<th scope="col">` headers.
- [ ] Every interactive control is a native element (`<a>`, `<button>`, `<input>`, `<details>`); no
      re-implemented ARIA widget.
- [ ] `lang="en"` on `<html>`; `lang="th"` on any inlined Thai verbatim-source span.
- [ ] Every color token pair (§7) meets WCAG AA contrast in both light and dark.
- [ ] KaTeX rendered with `output: 'htmlAndMathml'` explicit in the config (graft, Proposal 1) —
      never the library default, since only 421/1,559 entries have pre-generated
      `presentation_mathml` to fall back on otherwise.
- [ ] Pre-generated `presentation_mathml` embedded directly for the 421 entries that have it, so a
      screen reader gets real MathML with no JavaScript at all on those pages.
- [ ] Every entry page's raw LaTeX/ascii source text stays visible as ordinary text alongside any
      rendered math — never rendered-math-only.
- [ ] Responsive: `<meta name="viewport">`, no fixed-width containers, `max-width` + fluid layout.
- [ ] Reduced-motion respected (no animation is used, so this is vacuously satisfied — checked anyway).

## 15. Cross-references

- Static API contract: `mcp/docs/STATIC_API.md` (unchanged by this document).
- MCP tool list and founder rule: `mcp/README.md`, `README.md`.
- Registry schema: `registry/SCHEMA.md` (mangling rule, coq_status ladder, code grammar).
- Equation provenance rule: `EQUATION_SOURCE_POLICY.md` (paraphrased, never copied verbatim into
  generator-authored `/about/` prose, to keep that page's own words outside the banned-word/leak scan's
  verbatim-source exception).
- Prior overnight state: `ops/HANDOFF_OVERNIGHT_2026-09-06.md` ("A5: Toledo website on Pages" — this
  document is that item's design).
