# Template contract (stream S2 → S1)

Owned by S2 (`site/templates/`, `site/assets/`), per `site/DESIGN.md` §11. This file is the
placeholder/class-name contract `site/build_site.py` (S1) needs to fill these templates in; it is
documentation, not a page — the build script must not treat it as a template to render.

## Substitution model

Every `*.tmpl.html` file is plain text with `{{name}}` placeholders, filled by a small stdlib-only
`str.replace` helper — no Jinja2, no loops inside a template. Any place a template would need a
loop (a table's rows, a list of links, a details block's inner DAG), the template instead declares
**one placeholder for the whole pre-rendered HTML fragment**, and `build_site.py` builds that
fragment in Python and substitutes it as one string. This keeps every template a static, readable
document and keeps all registry-reading/looping logic in `build_site.py`, per the stream split.

`base.tmpl.html` is the only template with `<!doctype>`/`<html>`/`<head>`/`<body>`. Every other
template file is a **fragment only** (no outer document tags) — render it first, then substitute
the result into `base.tmpl.html`'s `{{content}}` placeholder, then fill `base.tmpl.html`'s own
placeholders (`{{title}}`, `{{description}}`, `{{root}}`, `{{page_class}}`, `{{katex_head}}`,
`{{katex_scripts}}`) for that specific page.

## `{{root}}` — the one placeholder every template shares, and why it must be relative

**This site is served under a project subpath**, `https://morrocwi.github.io/toledo/`, not at a
domain root. An `href="/assets/toledo.css"` written literally in generated HTML resolves against
the origin's root (`https://morrocwi.github.io/assets/toledo.css`) and 404s — a real, classic
GitHub Pages project-page bug, not a hypothetical one (verified: this repository carries no
`CNAME` file, so there is no custom domain putting the site at an origin root). `site/DESIGN.md`
§1's URL-scheme notation (`/assets/toledo.css`, `/browse/`, …) is **site-root-relative shorthand**
for the reader, not a literal instruction to emit root-absolute `href`/`src` attributes.

Every template in this directory therefore prefixes every internal link, stylesheet, and script
with `{{root}}` — a placeholder `build_site.py` fills with the correct number of `..` segments to
reach the site root from the page currently being written (`"."` for `/index.html`, `".."` for a
page one directory deep such as `/browse/index.html` or the flat file `/entries/<slug>.html`,
`"../.."` for two directories deep such as `/by-root/<root>/index.html`, etc.). This makes the
templates correct under a project subpath, a domain root, or a future custom domain alike — never
hand-typing the `/toledo/` prefix anywhere.

`assets/search.js` is the one exception: it is only ever loaded from the fixed one-level-deep
`/search/index.html`, so it fetches `../data/search-index.json` as a literal relative path inside
the script rather than needing a build-time-injected prefix.

## Placeholder-name collision guard

`{{root}}` is reserved, everywhere, for the site-root-relative prefix above. `entry.tmpl.html`
needs to display the entry's own Layer-0 root **code** (a `registry/CANONICAL.json` field also
named `root`) — that is a *different* placeholder, `{{entry_root}}` (the bare code) and
`{{entry_root_link}}` (a pre-rendered `<a>` to that root's `/entries/<slug>.html` or
`/by-root/<root>/`), never `{{root}}` itself. Keep this distinction if any future template adds
another field that happens to share a name with a layout placeholder.

## Per-template placeholder list

### `base.tmpl.html`
| Placeholder | Value |
|---|---|
| `{{title}}` | `<title>` text, e.g. `EQ-015/B.01.v1 — Toledo` |
| `{{description}}` | one-sentence `<meta name="description">` value |
| `{{root}}` | site-root-relative prefix, see above |
| `{{page_class}}` | a body class hook, e.g. `page-entry`, `page-home` (optional styling hook; may be empty) |
| `{{katex_head}}` | empty string, or the exact KaTeX `<link>` block below — only on a page that renders at least one `latex`/`latex+ascii` statement |
| `{{katex_scripts}}` | empty string, or the exact KaTeX `<script>` block below — same condition as `{{katex_head}}` |
| `{{content}}` | the fully-rendered inner fragment from one of the seven templates below |

### `home.tmpl.html` (`/index.html`, consumes `data/manifest.json`)
`{{entry_count}}`, `{{root_count}}` (root rows, `data/manifest.json` or `genesis_root.json` row
count), `{{current_count}}` (`counts_by_status.current`), `{{closed_count}}`
(`counts_by_coq_status.closed`), `{{domain_links_html}}` (one pill per populated domain letter,
e.g. `<a class="pill-link" href="{{root}}/by-domain/P/">P — physics (288)</a>`, using the same
`{{root}}` prefix), `{{registry_release_version}}`, `{{generated_at_human}}` (a human-formatted
date, not the raw ISO timestamp).

### `browse.tmpl.html` (`/browse/index.html`)
`{{entry_count}}`, `{{jump_nav_html}}` (one `<a href="#band-X">X</a>` per first-character band
present), `{{rows_html}}` — one `<tr>` per code in natural code order; **the first row of each
first-character band must carry `id="band-<CHAR>"`** matching the jump-nav hrefs. Row shape:
`<tr><td class="code-cell"><a href="{{root}}/entries/<site-slug>.html">CODE</a></td><td>NAME</td>
<td><span class="badge badge-tier">TIER</span></td><td>DOMAIN</td><td>STATUS</td></tr>`.
If `/browse/` ever exceeds the 200 KB budget (`site/DESIGN.md` §3's contingency), shard by
first-character band into `/browse/<band>/` pages and reduce this template's own row list to the
band links — do not silently truncate.

### `listing.tmpl.html` (every `/by-root/`, `/by-domain/`, `/by-tier/`, `/by-status/` page)
`{{root}}`, `{{axis_label}}` (`"Root"` / `"Domain"` / `"Tier"` / `"Status"`), `{{axis_index_path}}`
(the axis's own listing root, e.g. `by-domain`, used in the breadcrumb link), `{{axis_value}}` (the
slug/value itself, e.g. `P`, `Th_coqc`), `{{axis_description}}` (one sentence — e.g. for a domain
page, the domain's full name), `{{row_count}}`, `{{row_count_noun}}` (`"entry"` or `"entries"`),
`{{rows_html}}` (same row shape as `browse.tmpl.html`). Emit one page per value **actually present**
in the registry; emit none for a value with zero entries.

### `entry.tmpl.html` (`/entries/<site-slug>.html`)
Scalar/attribute placeholders: `{{root}}`, `{{code}}`, `{{entry_root}}`, `{{entry_root_link}}`,
`{{api_mangled_code}}` (the *hyphen-stripped* mangling, `registry/SCHEMA.md`'s Coq-filename rule,
reused via `mcp/toledo_mcp/export_static.mangle_code` — **not** the same string as the page's own
`<site-slug>`, which keeps the hyphen; see `site/DESIGN.md` §5).

Fragment placeholders (each a complete, S1-rendered HTML fragment):
- `{{name_html}}` — the entry's `name` (or `name_latex` inline-math rendering when present); wrap
  in an element carrying **`data-verbatim-source="true"`** (already on the template's own `<p>` —
  keep it there) so `site/checks/check_banned_words_and_leaks.py`'s verbatim-source exception
  applies to this quoted source text.
- `{{domain_badge_html}}` / `{{tier_badge_html}}` / `{{status_badge_html}}` /
  `{{coq_status_badge_html}}` — `<span class="badge badge-tier">…</span>` /
  `<span class="badge badge-status badge-status--current|caution|bad">…</span>` /
  `<span class="badge badge-coq">…</span>`. Map `status` to the badge modifier: `current` →
  `--current`; `unverified` / `historical` / `imprecise_as_stated` → `--caution`; `superseded_by` /
  `split` / `not_an_equation` → `--bad`. Empty string for `{{domain_badge_html}}` on a root row
  (`domain` is `null` there).
- `{{status_note_html}}` — `<p class="note">…</p>` when `status_note` is non-empty, else `""`.
- `{{aliases_html}}` — a short "Also known as: …" line when `aliases[]` is non-empty, else `""`.
- `{{statement_html}}` — branch on `statement.format` (see "Statement rendering" below).
- `{{ancestry_html}}` — the primary parent chain (`parents[0]` walked to a root), each hop a link
  to its own `/entries/<site-slug>.html`; wrap the whole thing in `<ol class="relation-list">…</ol>`
  or similar.
- `{{relations_html}}` — the *inner* content of the `<details>` "Full relations" block already in
  the template (full `parents[]`, computed `children[]`, `relations[]` and reverse relations),
  each entry linked the same way.
- `{{occurrences_html}}` — a `<div class="table-wrap"><table>…</table></div>` of `occurrences[]`
  rows (record_id, doi, label, section), or a plain `<p>` saying none are recorded. Wrap each raw
  `label`/quoted title in `data-verbatim-source="true"`.
- `{{coq_html}}` — the `coq{}` object: file, identifier, assumptions, `imported_from` (already
  written as `"solver arc (private)@<ref>"` for that source — display verbatim, never re-derive the
  real name), `coq_status`, `coq_axioms[]`, `identifiers[]` when present.
- `{{origin_html}}` — `origin{}` (source, repo_anchor, record/doi/section — same private-repo
  display rule as `{{coq_html}}`), plus `first_assigned`, `dateCreated`, `dateModified`, and
  `owner_year`/`drift_note` when present (both are three-state fields per `registry/SCHEMA.md` —
  render only when the key exists, never render a literal "null").
- `{{jsonld}}` — the raw JSON text of `registry/entries/<site-slug>.json` (already valid
  schema.org JSON-LD) — embed verbatim inside the template's `<script type="application/ld+json">`,
  do not re-serialize or reformat it.

**Statement rendering** (`statement.format`):
- `latex` or `latex+ascii` → `<div class="math-display">\[ {{HTML-escaped latex/ascii text}} \]</div>`
  (KaTeX auto-render replaces this at render time; the raw source stays as the element's plain text
  otherwise, satisfying "reading works with JS off"). HTML-escape the string (`&`, `<`, `>`) before
  inserting — auto-render reads the browser's already-decoded DOM text, so an escaped `&lt;`
  reaches KaTeX as a literal `<`. Immediately after, when `presentation_mathml` is present for this
  entry, add `<noscript><math xmlns="http://www.w3.org/1998/Math/MathML">{{presentation_mathml}}
  </math></noscript>` — browsers strip `<noscript>` content when scripting is enabled, so this
  never duplicates KaTeX's own `htmlAndMathml` output; it exists purely for the no-JS/no-KaTeX
  path, where it is the only source of real MathML semantics for a screen reader.
- `ascii-math` → `<pre class="statement-ascii">{{escaped ascii text}}</pre>`.
- `coq` → `<pre class="statement-coq"><code>{{escaped Coq declaration}}</code></pre>`.
- `prose` → `<p class="statement-prose">{{escaped prose text}}</p>` (the one `not_an_equation`
  entry; caption it as pointing to prose, per the founder-rule verdict 4, never as a formula).

### `search.tmpl.html` (`/search/index.html`)
No registry placeholders — only `{{root}}` (stylesheet/script src). The interactive app markup
(`#search-app`, `#search-input`, `#search-status`, `#search-results-body`) and the `<noscript>`
fallback are fixed in the template; do not add server-rendered rows here.

### `agents.tmpl.html` (`/agents/index.html`, content owned by S3 per `site/DESIGN.md` §11)
`{{root}}`, `{{mcp_json_snippet}}` (verbatim text of the repository root's own `.mcp.json`, read
fresh at build time — never hand-copied, so it cannot drift), `{{tools_table_rows}}` (one `<tr>`
per row of `data/tools-table.json`, itself parsed from `mcp/README.md`'s own table — see that
file's generation note), `{{coverage_html}}` (identical fragment to `about.tmpl.html`'s — build it
once, reuse it), `{{entry_count}}`, `{{registry_release_version}}`, `{{generated_at_human}}`. The
`.mcp.json` display, curl line, Python example, and crawler JSON-LD block are fixed in the template
(static, non-registry-dependent boilerplate per `site/DESIGN.md` §6) — S3 may adjust their wording
but should not need a new placeholder for them.

### `about.tmpl.html` (`/about/index.html`)
`{{root}}`, `{{entry_count}}`, `{{root_count}}`, `{{status_breakdown_html}}` /
`{{domain_breakdown_html}}` / `{{tier_breakdown_html}}` / `{{coq_status_breakdown_html}}` (each a
small `<ul>` or `<div class="stats-grid">` built from `data/manifest.json`'s matching `counts_by_*`
map — every key, in the map's own order, count only, no interpretation), `{{coverage_html}}` (the
§9 sentence pair — mathml coverage + `statement.format` split — shared with `agents.tmpl.html`),
`{{concept_doi}}` (read from `CITATION.cff`, not hand-typed), `{{registry_release_version}}`,
`{{generated_at_human}}`, `{{generated_from_commit}}`.

## KaTeX loading (pinned, verified 2026-09-07 via `api.cdnjs.com`)

Version **0.18.5**. SRI hashes below were confirmed by a direct `curl` against
`https://api.cdnjs.com/libraries/KaTeX/0.18.5?fields=sri` and a `200` HEAD check against each file
URL — not copied from an unread source.

`{{katex_head}}` (place in `<head>`, only on a page with ≥1 `latex`/`latex+ascii` statement):
```html
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.18.5/katex.min.css"
  integrity="sha512-eLvr2vghJzBvLDxpgIyx3qrDj1chzZfD4SPOE4otnJPa6GsyJ/lBDGFhZO8OsmyYNnqqjqXOSjHAV1cBax33oA=="
  crossorigin="anonymous">
```

`{{katex_scripts}}` (place just before `</body>`, same condition):
```html
<script src="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.18.5/katex.min.js"
  integrity="sha512-yRrA0fXbfdjHDJXBxj4ABSlaLGZk5HOm5qpvXx6GEjR1t5yCLdenOvN9hzHZhrznHyHVKuIK+QltSR4gc//lQA=="
  crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.18.5/contrib/auto-render.min.js"
  integrity="sha512-0HzJcHCD+wBh9kNUUcm3DWH9IbNDfudsYyMD5EHwSuFK6aEsaa/UEPqqk4t0pm4bbmwR6A11yNsD7Q+nz6XF+Q=="
  crossorigin="anonymous"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
  if (window.renderMathInElement) {
    renderMathInElement(document.body, {
      delimiters: [
        {left: '\\[', right: '\\]', display: true},
        {left: '$', right: '$', display: false}
      ],
      output: 'htmlAndMathml',
      throwOnError: false
    });
  }
});
</script>
```
`output: 'htmlAndMathml'` is explicit per the accessibility checklist (`site/DESIGN.md` §14) —
never rely on the library default. `throwOnError: false` matters here specifically: some
`statement.latex` values are mechanically converted from ascii-math (`registry/SCHEMA.md`'s
`latex+ascii` addendum) and are disclosed as best-effort, so one malformed render must not stop
every other formula on the page from rendering. The inline `$…$` delimiter is included for
`name_latex` (registry addendum, `$…$`-wrapped inline math in an entry's `name`).

## CSS class contract (`site/assets/toledo.css`)

Fragments built by `build_site.py` must use these class names for the stylesheet to apply
(reference `site/assets/toledo.css` for the full rule set): `.badge` / `.badge-tier` /
`.badge-coq` / `.badge-status` + one of `.badge-status--current` / `--caution` / `--bad`;
`.badge-row` around a group of badges; `.math-display`, `.statement-ascii`, `.statement-coq`,
`.statement-prose` for the four statement variants; `.note` for a caveat/status-note callout;
`.table-wrap` wrapping every `<table>` (horizontal-scroll safety on narrow viewports — the page
body itself must never scroll horizontally); `.relation-list` for ancestry/relations lists;
`.jump-nav` for the browse letter-band nav and the home domain links; `.stats-grid` /
`.stat-card` (with inner `.n` for the number, `.l` for the label) for the home/about stat tiles;
`.pill-link` for a small pill-shaped inline link (e.g. a domain quick-link); `.lede` for an
introductory paragraph; `.breadcrumb` for the top-of-page trail; `.search-status` for a small
muted status/footer line.

## Banned-word / leak-scan interaction (`site/checks/check_banned_words_and_leaks.py`, S4)

Every template file in this directory was hand-checked and contains **no** priority/comparative
marketing word (novel, first, unprecedented, world-class, state of the art, best, leading,
cutting-edge, revolutionary, …), no AI vendor/model name, no `/home` path or username, and never
the private solver-arc repository's real name — the templates' own authored prose (nav copy,
`/about/`, `/agents/` boilerplate) is written in plain, descriptive language throughout. Any hit
the scanner finds in the *rendered* output must therefore come from a fragment `build_site.py`
built from registry data (an entry's own `name`/`statement`/occurrence `label`/quoted paper title)
— exactly the case the `data-verbatim-source="true"` attribute exists to mark, so the scanner
reports it as a named warning rather than failing the build. Make sure every such
registry-sourced fragment carries that attribute on its wrapping element; a `/home` path, a
username, or the private repo's real name is a hard failure regardless of the attribute — those
have no legitimate verbatim-quote exception (this should never occur, since `origin.repo_anchor`
already writes `"solver arc (private)"` rather than the real name at the registry layer).

## Files delivered by S2

```
site/templates/base.tmpl.html
site/templates/home.tmpl.html
site/templates/browse.tmpl.html
site/templates/listing.tmpl.html
site/templates/entry.tmpl.html
site/templates/search.tmpl.html
site/templates/agents.tmpl.html
site/templates/about.tmpl.html
site/templates/PLACEHOLDERS.md   (this file — contract doc, not a page template)
site/assets/toledo.css           (5,494 bytes, budget < 6 KB)
site/assets/search.js            (3,950 bytes, budget < 4 KB)
```
