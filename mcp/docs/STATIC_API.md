# Toledo static API — external contract

**Status: implemented, verified against the real registry.** This document
describes the contract `toledo_mcp/export_static.py` (stream S3,
`mcp/DESIGN.md` §13) satisfies. Confirmed by the 2026-09-07 integration
pass: `python3 -m toledo_mcp.export_static --out mcp/dist/static-api`
against the real 1,504-entry registry wrote 2,108 files matching the layout
below exactly (`manifest.json`, `counts.json`, `verdict-rules.json`,
`search-index.json`, one `entries/<mangled-code>.json` per canonical entry,
`by-root/`, `by-domain/`) — full run output in `mcp/BENCHMARKS.md`. Every
path and shape below is the shape actually written, not a forward-looking
intention; check `mcp/docs/CHANGELOG.md`'s dated entries for anything that
changes after this writing.

## Why this exists, and why it can never replace the live server

The founder rule this whole package enforces — every equation looked up in
Toledo before use, no agent may use an unregistered one — needs a live
verdict, computed from the registry at the moment of the lookup. A file
generated at export time is, by construction, already possibly stale the
instant a new proposal is merged into `registry/CANONICAL.json`. This export
exists for exactly one situation: a caller with no MCP/stdio access at all
(a static site, a notebook with no subprocess permission, a quick `curl`
from a machine that will never run this package) who needs *some* answer
rather than none, and who can tolerate "as of the last export", not "as of
right now". **It is corroboration, never a substitute for a live
`toledo_check` call** — every file this export writes says so explicitly
(see `manifest.json` below), and any client library built against this API
should refuse to present its answer as equivalent to a live verdict.

## Generation contract

- **Single source of truth.** Every file below is generated from the exact
  same `toledo_mcp.cache`/`toledo_mcp.queries` layer the live MCP server
  reads — never a second, independent transform of `registry/CANONICAL.json`.
  If a static file and a live `toledo_get` call ever disagree on the shape
  or content of an entry (age of the export aside), that is a bug in
  `export_static.py`, not an alternate reading of the registry.
- **Never committed.** `mcp/dist/static-api/` is build output, gitignored
  (`mcp/.gitignore`), produced by CI (`.github/workflows/toledo-mcp-ci.yml`'s
  `export-static`/`deploy-pages` jobs, S4) and published to GitHub Pages —
  never hand-edited, never checked into version control.
- **Eventually consistent, disclosed as such.** Every generated file that
  can go stale relative to a registry edit carries `generated_at` and
  `generated_from_commit`; `manifest.json`'s `disclosure` field states the
  staleness risk in plain language a client can surface to its own users.
- **Filesystem-safe naming.** File and directory names use the exact code
  mangling `registry/SCHEMA.md`'s "Coq file-name mangling" section already
  defines (`code.replace('/', '__').replace('.', '_').replace('-', '_')`) —
  never a third, independently invented mangling scheme for this one export.
  `MQ.08/H.02.v1` → `MQ_08__H_02_v1.json`; `EQ-015/M.01.v1` →
  `EQ_015__M_01_v1.json`.

## Layout (`mcp/dist/static-api/v1/`)

```
v1/
  manifest.json
  entries/<mangled-code>.json
  by-root/<root>.json
  by-domain/<letter>.json
  search-index.json
  counts.json
  verdict-rules.json
```

### `manifest.json`

```json
{
  "generated_at": "2026-09-07T12:00:00Z",
  "generated_from_commit": "<git commit hash of the registry state exported>",
  "registry_release_version": "1.1.0",
  "package_version": "1.1.0",
  "entry_count": 1504,
  "disclosure": "eventually consistent; call the live MCP server for a current answer, never treat this as authoritative for a release-sensitive task"
}
```

`registry_release_version`/`package_version` are read the same way
`toledo_index_status` reads them at export time (root `CITATION.cff`'s
`version:` field via `scripts/sync_version.py`'s logic, §11 of
`mcp/DESIGN.md`) — never hand-typed into this file.

### `entries/<mangled-code>.json`

One file per canonical entry: the full `registry/SCHEMA.md`-shaped entry
(every field an equivalent `toledo_get` call's `data.entry` would carry),
plus its `verdict` block **as computed at export time** — itself carrying a
nested `computed_at` so a client can tell how old that specific verdict is,
independent of the top-level manifest's `generated_at` (the two are written
in the same export run and will normally match, but a client should read
the per-file timestamp, not assume it equals the manifest's).

```json
{
  "entry": { "...": "full SCHEMA.md entry, unchanged from the live schema" },
  "verdict": { "verdict": "REGISTERED_CURRENT", "usable": true, "reason": "...", "redirect": [], "candidates": [] },
  "computed_at": "2026-09-07T12:00:00Z"
}
```

### `by-root/<root>.json` and `by-domain/<letter>.json`

An array of compact entries (the same field set `toledo_by_root`/
`toledo_by_domain` return in their `data.hits`), one file per root code /
per domain letter (`E H S W M P C B`, `registry/SCHEMA.md`'s "8 domain
letters" table). No per-row verdict is attached in these list files — a
client wanting a citable verdict for a specific hit fetches
`entries/<mangled-code>.json` for that one code, matching the live server's
own division of labour between a list tool and `toledo_get`/`toledo_check`.

### `search-index.json`

The same compact-entry fields the live server's SQLite FTS5 index carries
(`code, root, layer, domain, name, tier, status, coq_status, statement`),
flattened to one plain JSON array covering every canonical entry — built so
a client-side search implementation (a browser page with no server round
trip) can filter/rank it itself with no dependency on this package's own
`equivalence.py`/`index.py` machinery. This file has no ranking built in;
it is raw material for a client's own search, not a served search result.

### `counts.json`

Byte-identical in shape to the live `toledo_counts` tool's `data` payload:
`{canonical_entries, merged_search_entries, by_status, by_domain, by_tier,
by_coq_status, lineage_events, genesis_root_rows}`. `canonical_entries`/
`by_status`/`by_domain`/`by_tier`/`by_coq_status` count `registry/
CANONICAL.json`'s own `canonical[]` array only (`layer != "root"`) —
matching that file's own `counts{}` field exactly; `merged_search_entries`
is the larger root+reading search-corpus total this package's cache also
indexes (counts-mismatch fix, 2026-09-07 — see `docs/CHANGELOG.md`'s
`1.2.0` entry).

### `verdict-rules.json`

Byte-identical in shape to `toledo_show_verdict_rules`'s `data` payload
(`{"statuses": [...], "verdict_values": [...], "rules": [...]}`, `mcp/DESIGN.md`
§8). This is the **one file in this export that genuinely cannot go stale
relative to a registry edit** — it describes this package's own verdict
logic, not the registry's content — so, uniquely among these files, a
client may treat it as current without re-checking `generated_at`.

## What a client should and should not do with this API

- **Should**: use `entries/`, `by-root/`, `by-domain/`, `search-index.json`
  for browsing, corroboration, or an offline mirror where no MCP transport
  is available.
- **Should**: read `manifest.json`'s `generated_at`/`generated_from_commit`
  before presenting any answer from this export as more than "as of that
  export".
- **Should not**: gate a founder-rule-sensitive decision ("is this equation
  registered, can I cite it") on this export alone when a live MCP
  connection is available — call `toledo_check`/`toledo_get` instead, exactly
  as `README.md`'s own founder-rule walkthrough describes.
- **Should not**: assume this export exists or is current for the equation
  in question at all — `NOT_FOUND` here (a missing `entries/<code>.json`)
  is not proof the code is unregistered; it may simply mean the code was
  registered after the last export ran. A missing file here is a reason to
  fall back to the live server, never to conclude `NOT_REGISTERED`.

## Cross-reference

Full generation-side specification and CI wiring: `mcp/DESIGN.md` §9 (test
plan: `test_static_export_matches_live_queries`,
`test_static_export_discloses_generation_metadata`), §12 (CI jobs
`export-static`/`deploy-pages`), §13 (this contract's authoring source).
Landing status: `mcp/docs/CHANGELOG.md`.
