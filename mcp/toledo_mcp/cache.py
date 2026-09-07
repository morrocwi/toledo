"""Process-wide cache over `core.load_registry` + `index.build_index` —
the layer `server.py`'s tool bodies should actually call.

Why this exists, and why it is NOT "just use `queries.py` for everything"
(the finding this module encodes, from `benchmarks/bench_index.py` run
against the real registry — see `docs/DESIGN.md` "What the benchmark
actually found" for the full numbers):

1. By far the largest cost anything in this package pays is `core.load_
   registry()`'s per-call JSON reparse + `build_entries` merge — ~90-100ms
   on this machine against the real ~1,500-entry / ~3.4MB CANONICAL.json.
   The baseline spike's `server.py` pays this on EVERY tool call, because
   `core.load_registry()` never caches. Avoiding that reparse is the
   single biggest win available (measured 13.7x end-to-end on `search`,
   and a `get` call goes from ~90ms to ~25 microseconds cached — the
   dominant cost by two orders of magnitude has nothing to do with SQL vs.
   Python).
2. Once a `core.Registry` is already sitting in memory, most single-key
   lookups (`get`, `status`, the single-parent `ancestry_chain`,
   `descendants`, `neighbours`) are ALREADY O(1)/O(local) against it —
   `parents[]`/`children[]`/`relations[]` are attributes already computed
   and attached to each entry dict by `build_entries`. Routing these
   through a SQL query and a Python<->sqlite3 round trip added measured
   overhead rather than removing it at this corpus's current size (the
   benchmark's `lineage_lookup`/`by_record_lookup` runs: the plain
   in-memory scan beat the indexed SQL join, ~0.4-0.5ms vs ~1.0-1.8ms).
3. Two operations DID show a real, large, benchmark-confirmed win from
   SQL specifically: FTS5-ranked `search` (13.7x once reload cost is
   removed from both sides — a genuine ranking/matching improvement, not
   just an avoided reparse) and the equivalence `check` tool's length-band
   prefilter (115x — an actual algorithmic-complexity win: it avoids
   running the expensive pairwise `compare_statements` against the whole
   corpus). Those two go through `IndexHandle`/`queries.search`/
   `equivalence.find_candidates_indexed`. `lineage_window` (pagination /
   date-range / event-type browsing across the WHOLE log, not one code)
   also has no in-memory-dict equivalent worth building and stays on the
   SQL path.

So: this cache holds a `core.Registry` plus a handful of cheap Python dict
indices (root/domain/record/reverse-relations) built once per refresh, AND
a lazily-opened `queries.IndexHandle` for the two operations that actually
need it. Both are refreshed together (same three source files, one cheap
`index.needs_rebuild` stat check per tool call) so a long-running stdio
server pays the reparse+rebuild only when the registry changed underneath
it, never on every call.

This module holds ONE such cache per process (`get_cache()` returns a
module-level singleton) — the natural lifetime for a single long-running
stdio MCP server process. Tests that need isolation construct their own
`RegistryCache(root=...)` directly rather than using the singleton.

**Stale-with-disclosure fallback (grafts A4/C5, mcp/DESIGN.md sec. 4).**
`core.load_registry` already retries a transient `JSONDecodeError` with
backoff before raising. If it STILL fails after every retry (the write on
the other end spans the whole retry window — observed, not hypothetical,
against this repo's own live registry edits), `ensure_fresh` below does NOT
let that exception escape into a calling tool: it keeps serving the
last-known-good `Registry` already held in memory, sets `self.degraded =
True` / `self.degraded_reason` to the failure plus when the cache was last
refreshed successfully, and returns `False` (no reload happened) rather than
raising. `index_status()` surfaces both fields so a caller can tell "the
answer you are getting is real but old" from "everything is fine". If there
is no last-known-good `Registry` yet at all (first call, and even the first
attempt's retries are exhausted), the exception DOES propagate — there is
nothing to fall back to, and the caller (`server.py`) is the one that turns
that into an `INDEX_UNAVAILABLE` envelope, not a silent stale serve.
"""
from __future__ import annotations

import collections
import dataclasses
import datetime
import json
import pathlib
import sqlite3

from . import core, index, paths, queries


def _utc_now_iso() -> str:
    return datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

# NOTE: this module intentionally reuses `core._summarize` (the exact same
# compact-entry shape `core.search`'s results already use) rather than
# duplicating that shaping logic a third time (queries.py has its own copy
# for its SQL-row-shaped callers). If `core.py` ever renames/moves it, update
# the four call sites below.


@dataclasses.dataclass
class RegistryCache:
    root: pathlib.Path | None = None
    registry: object | None = None  # core.Registry once loaded
    _index_handle: object | None = None  # queries.IndexHandle, opened lazily
    _by_root: dict = dataclasses.field(default_factory=dict)
    _by_domain: dict = dataclasses.field(default_factory=dict)
    _by_record: dict = dataclasses.field(default_factory=dict)  # str(record_id)|doi -> [codes]
    _reverse_relations: dict = dataclasses.field(default_factory=dict)  # target_code -> [(src_code, type, note)]
    _source_fp: dict = dataclasses.field(default_factory=dict)  # index.source_fingerprints() as of the last load
    degraded: bool = False
    degraded_reason: str | None = None
    _last_refreshed_at: str | None = None

    def _resolve_root(self) -> pathlib.Path:
        from . import paths
        return self.root or paths.repo_root()

    def ensure_fresh(self) -> bool:
        """Reload + reindex if the registry changed since the last refresh
        (or this is the first call). Returns True if a reload happened.

        Uses `index.source_fingerprints` (plain `os.stat`, no SQLite
        connection) against a copy this object keeps in memory, NOT
        `index.needs_rebuild` (which opens the on-disk index db to compare
        against its stored `meta` row on every call — a real sqlite3
        connect/query/close cost, ~0.3-0.5ms measured, that would otherwise
        be paid on every single `get`/`status`/... call once the point of
        this cache is exactly to make those calls cheap; see `index.py`'s
        `source_fingerprints` docstring).

        On a `JSONDecodeError` that survives `core.load_registry`'s own
        retry/backoff (grafts A4/C5 — see this module's docstring), falls
        back to the last-known-good `Registry` with `self.degraded` set,
        rather than raising, UNLESS there is no last-known-good `Registry`
        yet (first call) — that case re-raises, since there is nothing to
        fall back to."""
        root = self._resolve_root()
        current_fp = index.source_fingerprints(root)
        if self.registry is not None and current_fp == self._source_fp and not self.degraded:
            return False

        try:
            new_registry = core.load_registry(root)
        except json.JSONDecodeError as exc:
            if self.registry is None:
                raise
            self.degraded = True
            self.degraded_reason = f"{exc} (last refreshed at {self._last_refreshed_at})"
            return False

        self.registry = new_registry
        index.build_index(self.registry, root)
        self._source_fp = current_fp
        self.degraded = False
        self.degraded_reason = None
        self._last_refreshed_at = _utc_now_iso()
        if self._index_handle is not None:
            self._index_handle.close()
        self._index_handle = None  # opened lazily on first search/equivalence call
        self._build_python_indices()
        return True

    def _build_python_indices(self) -> None:
        by_root = collections.defaultdict(list)
        by_domain = collections.defaultdict(list)
        by_record = collections.defaultdict(list)
        reverse_relations = collections.defaultdict(list)
        for e in self.registry.entries:
            code = e.get("code")
            if e.get("root"):
                by_root[e["root"]].append(code)
            if e.get("domain"):
                by_domain[e["domain"]].append(code)
            for occ in e.get("occurrences") or []:
                if occ.get("record_id") is not None:
                    by_record[str(occ["record_id"])].append(code)
                if occ.get("doi"):
                    by_record[occ["doi"]].append(code)
            for r in e.get("relations") or []:
                if r.get("target"):
                    reverse_relations[r["target"]].append((code, r.get("type"), r.get("note", "")))
        self._by_root = dict(by_root)
        self._by_domain = dict(by_domain)
        self._by_record = dict(by_record)
        self._reverse_relations = dict(reverse_relations)

    def index_conn(self):
        """Open (once per refresh) the SQLite connection backing FTS search
        and the equivalence prefilter. Only touched by `search` and
        `check`/equivalence — every other method below never needs it."""
        self.ensure_fresh()
        if self._index_handle is None:
            self._index_handle = queries.IndexHandle.open(self._resolve_root())
        else:
            self._index_handle.ensure_fresh()
        return self._index_handle.conn

    def _run_indexed(self, fn):
        """Run `fn(conn)` against the SQLite index connection, self-healing
        a corruption discovered MID-SESSION (residual review finding,
        2026-09-07: "the self-heal for a corrupted mcp/state/index.sqlite3
        only triggers on a fresh connection"). The existing self-heal
        (`index._load_meta`'s `sqlite3.DatabaseError` catch, PERF-1 fix) only
        fires when a FRESH connection is opened specifically to read the
        `meta` table during a freshness check (`IndexHandle.ensure_fresh`'s
        own `needs_rebuild` call) — a corruption that does not happen to
        touch `meta` (e.g. the `entries`/`entries_fts` tables, or a
        disk-level fault that only manifests once a query walks a damaged
        page) surfaces only when the REAL query runs against the
        already-open connection this method was handed by `index_conn()`,
        and nothing caught that: every query function in `queries.py`/
        `equivalence.py` lets `sqlite3.DatabaseError` propagate uncaught.

        Every caller of the index connection (`search`, `find_equivalence_
        candidates`, `lineage_window`, `index_status`) now goes through this
        instead of calling `queries.*`/`equivalence.*` directly against
        `self.index_conn()`: on `sqlite3.DatabaseError` from the query
        itself, close the connection, delete the on-disk index file and its
        WAL/SHM/journal siblings outright (a corrupted file's own `meta` row
        cannot be trusted to drive a normal rebuild-if-stale decision), force
        exactly one rebuild from the unaffected source registry files, and
        retry the SAME query exactly once against the rebuilt index. If it
        fails again, raise a clear, typed `RuntimeError` naming both errors
        rather than looping or silently returning a partial answer."""
        conn = self.index_conn()
        try:
            return fn(conn)
        except sqlite3.DatabaseError as exc:
            self.close()
            db_path = paths.index_db_path(self._resolve_root())
            for suffix in ("", "-wal", "-shm", "-journal"):
                pathlib.Path(str(db_path) + suffix).unlink(missing_ok=True)
            try:
                conn = self.index_conn()
                return fn(conn)
            except sqlite3.DatabaseError as exc2:
                # Raised as `sqlite3.OperationalError` (a `sqlite3.Error`
                # subclass), not a bare `RuntimeError`, so `server.py`'s
                # `_safe` decorator's existing `sqlite3.Error` catch turns
                # this into the same typed `INDEX_UNAVAILABLE` envelope every
                # other "cannot read the registry at all" failure already
                # gets — a clear, typed error, not a bespoke shape callers
                # would need a second branch to recognise.
                raise sqlite3.OperationalError(
                    "mcp/state/index.sqlite3 was corrupted and a fresh rebuild from the "
                    f"source registry files did not repair it: {exc2!r} (original error "
                    f"before rebuild: {exc!r})"
                ) from exc2

    def close(self) -> None:
        if self._index_handle is not None:
            self._index_handle.close()
            self._index_handle = None

    # -- O(1)/O(local) lookups against the cached Registry -----------------

    def get(self, code: str) -> dict | None:
        self.ensure_fresh()
        return core.get(self.registry, code)

    def status(self, code: str) -> dict | None:
        self.ensure_fresh()
        return core.status(self.registry, code)

    def ancestry_chain(self, code: str) -> list[str]:
        self.ensure_fresh()
        return core.ancestry_chain(self.registry, code)

    def full_ancestors(self, code: str) -> list[str]:
        self.ensure_fresh()
        seen = {code}
        frontier = [code]
        out: list[str] = []
        while frontier:
            cur = frontier.pop(0)
            e = self.registry.by_code.get(cur)
            if not e:
                continue
            for p in e.get("parents") or []:
                pcode = p.get("code")
                if pcode and pcode not in seen:
                    seen.add(pcode)
                    out.append(pcode)
                    frontier.append(pcode)
        return out

    def descendants(self, code: str) -> list[dict]:
        self.ensure_fresh()
        seen = {code}
        frontier = [code]
        out_codes: list[str] = []
        while frontier:
            cur = frontier.pop(0)
            e = self.registry.by_code.get(cur)
            if not e:
                continue
            for c in e.get("children") or []:
                if c not in seen:
                    seen.add(c)
                    out_codes.append(c)
                    frontier.append(c)
        return [core._summarize(self.registry.by_code[c]) for c in out_codes if c in self.registry.by_code]

    def neighbours(self, code: str, rel_type: str | None = None) -> list[dict]:
        self.ensure_fresh()
        e = self.registry.by_code.get(code)
        if not e:
            return []
        out = []
        for p in e.get("parents") or []:
            if not rel_type or rel_type == "parent":
                out.append({"code": p.get("code"), "relation": "parent", "note": p.get("derived_via") or ""})
        for c in e.get("children") or []:
            if not rel_type or rel_type == "child":
                out.append({"code": c, "relation": "child", "note": ""})
        for r in e.get("relations") or []:
            if not rel_type or rel_type == r.get("type"):
                out.append({"code": r.get("target"), "relation": r.get("type"), "note": r.get("note", "")})
        for src, rtype, note in self._reverse_relations.get(code, []):
            rel = "reverse_relation"
            if not rel_type or rel_type == rel:
                out.append({"code": src, "relation": rel, "note": note})
        return out

    def by_root(self, root_code: str, limit: int | None = None) -> list[dict]:
        """`limit`: 0 or missing means uncapped (every matching entry) — see
        `core.resolve_limit(limit, default=None)`."""
        self.ensure_fresh()
        limit = core.resolve_limit(limit, None)
        codes = sorted(self._by_root.get(root_code, []), key=core.natural_sort_key)
        if limit:
            codes = codes[:limit]
        return [core._summarize(self.registry.by_code[c]) for c in codes]

    def by_domain(self, domain: str, limit: int | None = None) -> list[dict]:
        """`limit`: 0 or missing means uncapped, same as `by_root` — see
        `core.resolve_limit`."""
        self.ensure_fresh()
        limit = core.resolve_limit(limit, None)
        codes = sorted(self._by_domain.get(domain, []), key=core.natural_sort_key)
        if limit:
            codes = codes[:limit]
        return [core._summarize(self.registry.by_code[c]) for c in codes]

    def by_record(self, record_id_or_doi: str) -> list[dict]:
        self.ensure_fresh()
        codes = sorted(set(self._by_record.get(str(record_id_or_doi), [])), key=core.natural_sort_key)
        return [core._summarize(self.registry.by_code[c]) for c in codes]

    def by_raw_key(self, raw_key: str) -> dict | None:
        self.ensure_fresh()
        code = self.registry.raw_to_canonical.get(raw_key)
        return core.get(self.registry, code) if code else None

    def lineage(self, code: str) -> dict | None:
        self.ensure_fresh()
        return core.lineage(self.registry, code)

    def counts(self) -> dict:
        self.ensure_fresh()
        return core.counts(self.registry)

    def index_status(self) -> dict:
        """Health/versioning readout for the `toledo_index_status` tool:
        freshness, the SQL index's schema-compatibility check against
        `registry/CANONICAL.json`'s own declared `schema_version`, entry/
        lineage counts, and the TOLEDO.json cross-check (see `index.py`).
        This is "versioning with the registry" made queryable: a caller can
        tell whether this server's understanding of the registry format is
        current, not just whether its data is fresh."""
        root = self._resolve_root()
        self.ensure_fresh()
        freshness = index.check_freshness(root)
        meta = self._run_indexed(index._load_meta)
        from . import __version__ as _pkg_version

        return {
            "package_version": _pkg_version,
            "index_schema_version": meta.get("index_schema_version"),
            "source_schema_version": meta.get("source_schema_version"),
            "source_schema_supported": meta.get("source_schema_supported") == "True",
            "supported_source_schema_versions": sorted(index.SUPPORTED_CANONICAL_SCHEMA_VERSIONS),
            "built_at": meta.get("built_at"),
            "stale": freshness.stale,
            "stale_reasons": freshness.reasons,
            "entry_count": int(meta.get("entry_count", 0)),
            "lineage_event_count": int(meta.get("lineage_event_count", 0)),
            "toledo_json_cross_check": index.cross_check_toledo_json(self.registry.entries, root),
            "degraded": self.degraded,
            "degraded_reason": self.degraded_reason,
            "last_refreshed_at": self._last_refreshed_at,
        }

    # -- delegate to the SQLite index (the two operations that need it) ----

    def search(self, query: str = "", **kwargs) -> list[dict]:
        return self._run_indexed(lambda conn: queries.search(conn, query, **kwargs))

    def find_equivalence_candidates(self, statement: str, limit: int = 5):
        from . import equivalence
        return self._run_indexed(
            lambda conn: equivalence.find_candidates_indexed(conn, core.normalise_formula, statement, limit=limit)
        )

    def lineage_window(self, **kwargs) -> dict:
        return self._run_indexed(lambda conn: queries.lineage_window(conn, **kwargs))


_singleton: RegistryCache | None = None


def get_cache(root: pathlib.Path | None = None) -> RegistryCache:
    global _singleton
    if _singleton is None or (root is not None and _singleton.root != root):
        _singleton = RegistryCache(root=root)
    return _singleton


def reset_cache_for_tests() -> None:
    """Test-only: drop the module-level singleton so the next `get_cache()`
    starts fresh (used when a test changes `TOLEDO_ROOT`/registry contents
    and must not see a previous test's cached Registry)."""
    global _singleton
    if _singleton is not None:
        _singleton.close()
    _singleton = None
