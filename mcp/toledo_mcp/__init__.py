"""toledo_mcp — an MCP server over the Toledo equation library's own generated
and source registry files (registry/CANONICAL.json, registry/genesis_root.json,
registry/LINEAGE.jsonl).

Founder rule (2026-09-07): every equation must be looked up in Toledo before it
is used; no agent may use an unregistered equation.

Module layout (see docs/DESIGN.md for the full architecture and the reasoning
behind each layer):
  - `core.py`      — pure, side-effect-free load/search/check/register_proposal
                      functions (first landed as this package's baseline spike).
  - `paths.py`      — TOLEDO_ROOT/TOLEDO_MCP_STATE_DIR-aware path resolution.
  - `hashing.py`    — file fingerprint/sha256 helpers for index invalidation.
  - `index.py`      — the SQLite+FTS5 search index: schema, build/refresh from
                      an already-loaded `core.Registry`, staleness checks.
  - `queries.py`    — indexed read queries against that SQLite database.
  - `equivalence.py`— φ-criterion candidate matching (renaming / positive
                      scale / structural), plain and index-prefiltered.
  - `verdict.py`    — the founder-rule enforcement verdict vocabulary: eleven
                      values (REGISTERED_* x7, CANDIDATE_MATCH, AMBIGUOUS,
                      CAUTION, NOT_REGISTERED), a fail-safe default for a
                      missing/unrecognised `status` (fixed 2026-09-07, see
                      `mcp/DESIGN.md` sec. 5 — never `REGISTERED_CURRENT`),
                      and `RULES`/`VERDICT_VALUES` as introspectable data for
                      the `toledo_show_verdict_rules` tool.
  - `proposals.py`  — the proposal lifecycle: `write_proposal` (the only
                      write path anywhere in this package, since 2026-09-07 —
                      writes under `mcp/proposals/*.json`, moved from
                      `registry/proposals/`, see `mcp/DESIGN.md` sec. 6) plus
                      the queryable STATUS.jsonl ledger next to it.
  - `cache.py`      — `RegistryCache`, the process-wide cache `server.py`'s
                      tools actually call (cached Registry for O(1)/O(local)
                      lookups; the SQL index only for search + equivalence).
  - `server.py`     — the stdio MCP server (`mcp.server.fastmcp.FastMCP`),
                      19 `@mcp.tool()` functions. Every tool returns a typed
                      `{"ok", "data", "error"}` envelope (graft A1); every
                      tool returning a citable entry or row list attaches a
                      per-row `verdict` (graft B1); `toledo_search`/
                      `by_root`/`by_domain`/`by_record`/`descendants` accept
                      `format="toon"` (grafts B5/C7); `toledo_show_
                      verdict_rules` is the 19th tool (graft A6).
  - `cli.py`         — the `toledo` console script (`mcp/DESIGN.md` sec. 14):
                      CLI parity with `scripts/toledo`'s verb set plus the
                      verdict-aware subcommands (`check`, `status`,
                      `proposals`, `register-proposal`, `index-status`,
                      `show-verdict-rules`), answering from `cache.py`/
                      `queries.py` rather than a fresh `registry/TOLEDO.json`
                      read.
  - `export_static.py` — the static GitHub Pages mirror (`mcp/DESIGN.md`
                      sec. 13): `manifest.json`, one JSON file per entry,
                      `by-root/`/`by-domain/`, `search-index.json`,
                      `counts.json`, `verdict-rules.json`, generated from the
                      same `cache.py`/`queries.py` layer the live server
                      reads — never a second, independent transform of
                      `registry/CANONICAL.json`.

This package never writes to registry/CANONICAL.json, registry/genesis_root.json,
registry/LINEAGE.jsonl, coq/, or latex/. The only write path anywhere in it is
`proposals.write_proposal` (`mcp/proposals/*.json`), plus the `proposals.py`
status ledger next to it. `core.register_proposal` (still present for direct,
non-MCP callers) also targets `mcp/proposals/` via `paths.proposals_dir()` —
both write paths were repointed together in the same change (mcp/DESIGN.md
sec. 6, graft C4); neither ever targets `registry/proposals/` any more.
"""

from . import core  # noqa: F401

# NOTE: `mcp/DESIGN.md` sec. 11 — this is synced from the registry's own
# release version (root CITATION.cff) by `scripts/sync_version.py` (a
# different build stream's script; run it, don't hand-edit this line to
# "guess" a release number). That script matches this exact literal-string
# form with a regex (`^__version__ = "([^"]+)"$`), so keep it a plain
# assignment — no expression, no importlib.metadata lookup — or
# sync_version.py's own read/write round-trip breaks.
__version__ = "1.3.0"

__all__ = ["core", "__version__"]
