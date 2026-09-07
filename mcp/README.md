# Toledo MCP server

Fast search, lineage, and status lookup over the Toledo equation registry, exposed
as an MCP (Model Context Protocol) server over stdio — for any AI agent that needs
to check an equation before using it.

See `docs/DESIGN.md` for the full architecture, the SQLite/FTS5 index design,
the benchmark numbers behind every performance claim below, and the exact
tool JSON schemas. `mcp/DESIGN.md` (repo-relative, one level up from this
file) is the specification that engineering pass implemented against — kept
as the historical record of the review that produced this package's current
shape; `docs/DESIGN.md` is the as-built record of what is actually here
today, updated by the 2026-09-07 integration pass that installed this
package, ran its full test suite, drove every tool over a real stdio
session against the real registry, ran the benchmark script, and exported
the static API — see `docs/CHANGELOG.md` for the dated record of exactly
what that pass verified.

## Status

This package is the **implemented target** `mcp/DESIGN.md` specified: 19
tools (including `toledo_show_verdict_rules`), the `{"ok","data","error"}`
envelope on every tool, a per-row `verdict` on every tool that returns a
citable entry or hit list, `format="json"|"toon"` on the uniform row-list
tools, the `toledo` console-script CLI, and the static JSON export for
GitHub Pages — all verified present and working (a real stdio round trip
over all 19 tools against the real registry, a real `export_static.py` run
producing 2,108 files) during the 2026-09-07 integration pass. A later
2026-09-07 pass fixed nine defects an independent adversarial review found
(regex denial-of-service, a proposal-write race, a counts field polluted by
the merged search corpus, search-relevance regressions on exact-code/
unicode queries, a status-blind `toledo_check` verdict, and three
robustness gaps) — see "Known issues, fixed" below and `docs/CHANGELOG.md`'s
`1.2.0` entry. A further 2026-09-07 pass fixed six residual findings a
second review left open (a proposal-path file-existence oracle, a
`toledo_check` similarity-tie verdict, inconsistent `limit=0` handling, a
mid-session corrupted-index self-heal gap, a stale root test, and several
stale docstrings) — see `docs/CHANGELOG.md`'s next entry and
`mcp/BENCHMARKS.md`'s matching section. Current test count: 214 passing
(`cd mcp && python3 -m pytest -q`). See "Tests and benchmarks" below and
`mcp/BENCHMARKS.md` for every pass's full, quoted output.

### Known issues, fixed

`toledo_mcp/verdict.py`'s fallback branch used to answer a `None`/missing
`status` on an entry as `verdict="REGISTERED_CURRENT"`, `usable=True` — a
malformed or mid-edit entry silently promoted to "safe to cite" instead of
stopped. This was the single most dangerous failure mode this server could
have. It is fixed: an unrecognised or missing `status` now returns the
dedicated `CAUTION` verdict, `usable=False` (never a usable outcome),
pinned by `test_unknown_status_defaults_to_caution` in
`tests/test_verdict.py`. `verdict.py`'s `RULES` list documents the full
decision table as introspectable data (`toledo_show_verdict_rules`/`toledo
show-verdict-rules`).

A separate bug in the SAME verdict machinery, caught by a later independent
review (2026-09-07): an EXACT statement match (no `status` problem, a
perfectly well-formed entry) was hard-coded to
`verdict="REGISTERED_CURRENT"`, `usable=True` with no check of the matched
entry's own `status` at all — so a formula that exact-matched a
`not_an_equation`/`superseded_by`/`split` entry's statement got the same
dangerous "safe to cite" answer, in both `toledo_check`'s default and
`method="difflib"` paths. Fixed: both paths now resolve the matched entry
and delegate to the same status-aware `verdict_for_entry` a code lookup
already goes through. See `docs/CHANGELOG.md`'s `1.2.0` entry for this and
eight further defects (a regex denial-of-service reachable through
`toledo_search(regex=True)`/`toledo find --regex`, a proposal-write race
that could silently destroy a submitted proposal, `toledo_counts` counting
the wrong entry set, search-relevance regressions on exact-code/unicode
queries, and three index/registry robustness gaps) the same review found
and this pass fixed, each with its own regression test and a live
confirmation against the real registry.

## The rule this server exists to enforce

**Founder ruling, 2026-09-07: every equation must be looked up in Toledo before it
is used. No AI agent may use an unregistered equation.**

That means, before stating, citing, or building on any formula:

1. Call `toledo_check` (with `formula=...` or an exact `code=...`) — or read the
   `verdict` block `toledo_get`/`toledo_status`/`toledo_by_raw_key` already
   attach if you're looking a code up directly.
2. `verdict.usable == true` (`REGISTERED_CURRENT`, or a caveated
   `REGISTERED_UNVERIFIED`/`HISTORICAL`/`IMPRECISE` — disclose the caveat) —
   cite the matched code; do not restate or re-derive the formula.
3. `REGISTERED_SUPERSEDED`/`REGISTERED_SPLIT` — do not use this code; use one
   of `verdict.redirect` instead.
4. `REGISTERED_NOT_AN_EQUATION` — this code is a pointer to prose, not a
   formula; do not present it as one.
5. `CANDIDATE_MATCH` — a plausible match was found (renaming / positive
   scale / structural similarity — see `docs/DESIGN.md`) but is **not**
   confirmed; get a documented φ-criterion confirmation before treating it
   as the same object, or register a proposal.
6. `AMBIGUOUS` — conflicting evidence; escalate to a human, do not guess.
7. `NOT_REGISTERED` — call `toledo_register_proposal` and wait for a human
   registrar to merge it (poll `toledo_proposal_status` with the returned
   `path`) before using the formula. This server never merges a proposal
   into the registry itself; that step is always a human, per
   `registry/SCHEMA.md`.

## What it reads, what it writes

- Reads `registry/CANONICAL.json`, `registry/genesis_root.json`, and
  `registry/LINEAGE.jsonl` through a process-wide cache
  (`toledo_mcp/cache.py`) that reloads only when those files actually
  change — not fresh on every call (see `docs/DESIGN.md` for why: a fresh
  reparse cost ~90-100ms per call on this machine against the current
  registry; cached, most lookups cost tens of microseconds). It still
  reuses `scripts/toledo_build.py`'s own root+reading merge underneath
  (`toledo_mcp/core.py`), so its view of "what is registered" is always the
  one `make build` would also produce.
- Writes **nothing** to `registry/CANONICAL.json`, `registry/genesis_root.json`,
  `registry/LINEAGE.jsonl`, `coq/`, or `latex/`.
- The **only** write path in the whole server is `toledo_register_proposal`,
  which drops one JSON file under `mcp/proposals/<timestamp>_<slug>.json`
  for a human registrar to review and merge by hand, plus a status-ledger
  row in `mcp/proposals/STATUS.jsonl` (`toledo_mcp/proposals.py`) — moved
  from `registry/proposals/` (never used in this checkout) specifically so
  the write path sits outside the `registry/` directory that carries the
  five files this package must never edit.
- `mcp/state/index.sqlite3` (gitignored) is this server's own generated
  search index — safe to delete at any time; it is rebuilt automatically.
- Every tool response is wrapped in `{"ok": bool, "data": ..., "error":
  {"code", "message"} | None}`; `data: null, ok: true` means "the registry
  answered and this code/root/domain genuinely does not exist" — a normal,
  common answer, not a failure.

## Tools (19)

| Tool | Purpose |
|---|---|
| `toledo_search` | Ranked/filtered text search (root, domain, tier, status, coq_status); `format="json"\|"toon"`; per-row `verdict`. |
| `toledo_get` | `{"entry": <full entry>, "verdict": {...}}` for one exact code. |
| `toledo_status` | Compact tier/status/coq_status/superseded_by + verdict for one code. |
| `toledo_check` | Founder-rule gate: pass `formula=` or `code=`; returns a verdict (see above). |
| `toledo_lineage` | Ancestry chain, direct children, and every LINEAGE.jsonl event for one code. |
| `toledo_ancestors` | Full parent-DAG (not just the single parents[0] chain). |
| `toledo_descendants` | Full child-DAG; `format="json"\|"toon"`. |
| `toledo_neighbours` | Parents + children + relations + **reverse** relations; per-row `verdict` on parent/child members. |
| `toledo_by_root` | Every reading of a given Layer-0 root; `format="json"\|"toon"`. |
| `toledo_by_domain` | Every entry in a given domain letter (E H S W M P C B); `format="json"\|"toon"`. |
| `toledo_by_record` | Every code citing a given Zenodo record id / DOI; `format="json"\|"toon"`. |
| `toledo_by_raw_key` | Exact `<record_id>:<label>` occurrence-key lookup. |
| `toledo_lineage_window` | Paginated/filtered browse of the whole lineage log. |
| `toledo_counts` | Live aggregate counts. |
| `toledo_index_status` | Index freshness + schema-version compatibility + `registry_release_version`. |
| `toledo_show_verdict_rules` | Introspect the verdict decision table (`verdict.py`'s `RULES`) as data. |
| `toledo_register_proposal` | The only write path — a human-reviewed proposal file under `mcp/proposals/`. |
| `toledo_list_proposals` | Browse the proposal queue, optionally by status. |
| `toledo_proposal_status` | One proposal's current lifecycle state. |

## Install / dependency

```
python3 -c "import mcp"          # if this fails:
pip install --user mcp           # version pinned in mcp/requirements-mcp.txt / pyproject.toml
```

Everything else the server uses is the Python 3 standard library (SQLite +
its FTS5 extension, confirmed available on this machine). Transport is
stdio only — no ports, no network.

## Running it directly

```
python3 mcp/toledo_mcp/server.py
```

It talks MCP-over-stdio; run it through an MCP client rather than a plain
terminal. `docs/DESIGN.md` "End-to-end verification" shows a real client
session (via the `mcp` Python SDK) exercising `toledo_index_status`,
`toledo_search`, `toledo_get`, and `toledo_check` over a real stdio
subprocess launched exactly as `.mcp.json` below launches it.

## Wiring it into an agent

Every MCP-capable agent needs the same three things for a stdio server: a
command to run, the arguments to run it with, and (optionally) environment
variables — then it discovers the tools above itself via `tools/list`.
The examples below use that same `command`/`args` shape; only the top-level
config key name and file location differ by the agent's own convention.

**A terminal coding agent that reads a project-level MCP config file.** This
repo's own root `.mcp.json` (already present) is:

```json
{
  "mcpServers": {
    "toledo": {
      "command": "python3",
      "args": [
        "mcp/toledo_mcp/server.py"
      ]
    }
  }
}
```

Such an agent typically loads this automatically when its working directory is
the repo root (or a directory that contains this file); check that agent's own
docs for the exact discovery path if it is not picked up automatically.

**An IDE-integrated or desktop agent with its own MCP settings file.** Add the
same `"toledo": {"command": "python3", "args": ["mcp/toledo_mcp/server.py"]}`
object under whatever key that agent's own settings file uses for its list of
stdio MCP servers (commonly `mcpServers`, sometimes `mcp_servers` or a
per-server file under an `mcp/` or `.mcp/` settings directory) — the object
shape is identical; only the surrounding key/file convention changes. If that
agent resolves paths relative to a different working directory than the repo
root, either point `args` at the absolute path to
`mcp/toledo_mcp/server.py` on that machine, or set the agent's own
"working directory" / `cwd` setting for this server entry to the Toledo repo
root so the relative path above resolves, or set the `TOLEDO_ROOT`
environment variable to the repo root explicitly.

**Any other agent that can only invoke a shell command (no native MCP
support).** Run `python3 mcp/toledo_mcp/server.py` as a subprocess and speak
MCP-over-stdio to it directly, or use that agent's own MCP-bridge/adapter
tooling if it has one — the server itself does not need to change either way.

## Tests and benchmarks

```
python3 -m pytest -q                 # 214 tests (run from mcp/)
python3 benchmarks/bench_index.py    # prints + writes benchmarks/results.json
```

Full quoted output of both, plus a real stdio round trip over all 19 tools
against the real registry and a real `export_static.py` run: see
`mcp/BENCHMARKS.md` (2026-09-07 integration pass, plus the later 2026-09-07
security/correctness fix pass appended at the end of that file).

## `toledo` console-script CLI and static API export

Both surfaces specified in `mcp/DESIGN.md` are implemented and installed
(`pip install -e mcp/` puts `toledo` and `toledo-mcp` on `PATH` via
`[project.scripts]`):

- **`toledo` CLI** (`mcp/DESIGN.md` §14, stream S3) — a console script
  matching `scripts/toledo`'s subcommand names (`find`, `show`, `ancestry`,
  `descendants`, `neighbours`, `by-root`, `by-domain`, `by-record`,
  `export`) but answering from this package's cached/indexed layer instead
  of a fresh `registry/TOLEDO.json` read, plus new verdict-aware
  subcommands (`check`, `status`, `proposals list/show`,
  `register-proposal`, `index-status`, `show-verdict-rules`). It is a
  separate, MCP-package-owned CLI — `scripts/toledo` itself is untouched and
  remains the registry-owning lane's own build-verification tool.
- **Static API export for GitHub Pages** (`mcp/DESIGN.md` §13, stream S3) —
  a periodic, eventually-consistent JSON mirror of the same query layer this
  server answers from, for a caller with no MCP/stdio access. Full contract:
  `docs/STATIC_API.md`. Run it with:
  ```
  python3 -m toledo_mcp.export_static --out mcp/dist/static-api
  ```
  Verified against the real registry (2026-09-07): 2,108 files written
  (`manifest.json`, `counts.json`, `verdict-rules.json`,
  `search-index.json`, one `entries/<mangled-code>.json` per canonical
  entry, `by-root/`, `by-domain/`) — see `mcp/BENCHMARKS.md`. `mcp/dist/` is
  gitignored; CI (`.github/workflows/toledo-mcp-ci.yml`) publishes it to
  GitHub Pages on `main`, it is never committed by hand.

See `docs/CHANGELOG.md` for the dated entry recording when each landed.

## Cold start: prebuilt index (DEBT #48, 2026-09-07)

`mcp/state/index.sqlite3` is normally built lazily, on demand, the first
time a tool call needs it — fine for a long-running dev checkout, but it
means a from-scratch clone (or a downloaded release) pays a full registry
JSON-parse-and-merge plus an index build on its very first cold start.

`make build` (and CI's `build-index` job) now also run
`python3 mcp/scripts/build_index.py`, which builds `mcp/state/index.sqlite3`
from the current registry right after `scripts/toledo_build.py` runs. **A
release archive should include this file under `mcp/state/`** alongside the
package so a fresh unpack starts with an already-built index rather than an
empty `mcp/state/`.

`mcp/state/*.sqlite3` stays gitignored (`mcp/.gitignore`) — it is still
never a second source of truth checked into git, only a build artifact a
release zip carries alongside the code, the same way `mcp/dist/static-api/`
is a build artifact CI publishes without ever committing it.

The runtime side of this: `toledo_mcp.index.check_freshness` used to compare
only file `size`+`mtime_ns` against what was recorded when the index was
last built — so a shipped index would look "stale" on a fresh unpack purely
because unpacking gives every file a new mtime, even though its bytes are
identical to what the index was built from, forcing an unnecessary rebuild
on every single cold start. It now falls back to comparing the sha256
content hash already recorded in the index's own `meta` table (`build_index`
has always computed and stored this) whenever the cheap stat check
disagrees, and only reports staleness when the hash disagrees too — a real
content change, not a touched mtime. `toledo_mcp.cache.RegistryCache.
ensure_fresh` was also changed to call `index.build_index` only when
`index.needs_rebuild` actually says so (it used to rebuild unconditionally
on every full reload, including a process's very first one) — so a
correctly shipped, matching index is reused as-is. See `mcp/BENCHMARKS.md`
for the measured before/after cold-start numbers.
