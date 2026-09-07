from __future__ import annotations

import json
import sqlite3
import time

import pytest

from toledo_mcp import cache as cache_mod
from toledo_mcp import core, index, paths


def test_ensure_fresh_loads_once_and_skips_when_unchanged(fixture_root):
    c = cache_mod.RegistryCache(root=fixture_root)
    assert c.ensure_fresh() is True  # first call always loads
    reg1 = c.registry
    assert c.ensure_fresh() is False  # nothing changed
    assert c.registry is reg1  # same object, not reloaded


def test_ensure_fresh_reloads_after_source_edit(fixture_root):
    c = cache_mod.RegistryCache(root=fixture_root)
    c.ensure_fresh()
    reg1 = c.registry

    canonical_path = fixture_root / "registry" / "CANONICAL.json"
    text = canonical_path.read_text(encoding="utf-8")
    time.sleep(0.01)
    canonical_path.write_text(text + "\n", encoding="utf-8")

    assert c.ensure_fresh() is True
    assert c.registry is not reg1


def test_ensure_fresh_reuses_shipped_index_when_hash_matches_despite_mtime_change(fixture_root, monkeypatch):
    """MCP cold-start prebuilt-index fix (DEBT #48, 2026-09-07, lane E): a
    release zip ships `mcp/state/index.sqlite3` already built (see
    `mcp/scripts/build_index.py`); unpacking/checking it out changes the
    source registry files' mtimes without changing their bytes. A *fresh*
    `RegistryCache` (modelling a brand-new server process's cold start) must
    still load the registry into memory (`ensure_fresh()` returns True — the
    Python-side object always needs building), but must NOT throw away and
    rebuild an on-disk index that already matches by content hash. Before
    this fix, `ensure_fresh` called `index.build_index` unconditionally on
    every first load, defeating a shipped index entirely."""
    reg = core.load_registry(fixture_root)
    index.build_index(reg, fixture_root)  # the "release-time" build

    canonical_path = fixture_root / "registry" / "CANONICAL.json"
    text = canonical_path.read_text(encoding="utf-8")
    time.sleep(0.01)
    canonical_path.write_text(text, encoding="utf-8")  # identical bytes, new mtime -- simulates an unpacked release

    build_calls = []
    real_build_index = index.build_index

    def spy_build_index(*args, **kwargs):
        build_calls.append(1)
        return real_build_index(*args, **kwargs)

    monkeypatch.setattr(index, "build_index", spy_build_index)

    c = cache_mod.RegistryCache(root=fixture_root)  # a brand-new process's cache
    assert c.ensure_fresh() is True  # the in-memory Registry is always (re)loaded on a cold start
    assert build_calls == []  # but the shipped, matching-by-hash index must not be rebuilt
    assert c.get("EQ-001/M.01.v1") is not None  # the cache is fully functional off the shipped index


def test_get_status_match_core(fixture_root):
    c = cache_mod.RegistryCache(root=fixture_root)
    reg = core.load_registry(fixture_root)
    for code in reg.by_code:
        assert c.get(code) == core.get(reg, code)
        assert c.status(code) == core.status(reg, code)


def test_by_root_by_domain_by_record(fixture_root):
    c = cache_mod.RegistryCache(root=fixture_root)
    under_root = c.by_root("EQ-001")
    assert any(e["code"] == "EQ-001/H.01.v1" for e in under_root)
    h_domain = c.by_domain("H")
    assert {e["code"] for e in h_domain} == {"EQ-001/H.01.v1"}
    rec_hits = c.by_record("1")
    assert any(e["code"] == "EQ-001/M.01.v1" for e in rec_hits)
    assert c.by_raw_key("1:(1)")["code"] == "EQ-001/M.01.v1"
    assert c.by_raw_key("nope") is None


def test_descendants_and_neighbours_reverse_relation(fixture_root):
    c = cache_mod.RegistryCache(root=fixture_root)
    desc = {d["code"] for d in c.descendants("EQ-001/M.08.v1")}
    assert desc == {"EQ-001/M.09.v1", "EQ-001/M.10.v1"}

    forward = c.neighbours("EQ-001/H.01.v1")
    assert any(n["code"] == "EQ-001/M.01.v1" and n["relation"] == "reads" for n in forward)
    reverse = c.neighbours("EQ-001/M.01.v1")
    assert any(n["code"] == "EQ-001/H.01.v1" and n["relation"] == "reverse_relation" for n in reverse)


def test_full_ancestors(fixture_root):
    c = cache_mod.RegistryCache(root=fixture_root)
    anc = c.full_ancestors("EQ-001/M.09.v1")
    assert "EQ-001/M.08.v1" in anc and "EQ-001" in anc


def test_lineage_matches_core(fixture_root):
    c = cache_mod.RegistryCache(root=fixture_root)
    reg = core.load_registry(fixture_root)
    for code in ["EQ-001/M.01.v1", "EQ-001/M.09.v1"]:
        assert c.lineage(code) == core.lineage(reg, code)


def test_counts_matches_core(fixture_root):
    c = cache_mod.RegistryCache(root=fixture_root)
    reg = core.load_registry(fixture_root)
    assert c.counts() == core.counts(reg)


def test_index_status_reports_schema_and_freshness(fixture_root):
    c = cache_mod.RegistryCache(root=fixture_root)
    status = c.index_status()
    assert status["source_schema_version"] == "1.0.0"
    assert status["source_schema_supported"] is True
    assert status["stale"] is False
    assert status["entry_count"] > 0
    c.close()


def test_index_status_flags_unsupported_schema_version(fixture_root):
    import json as _json

    canonical_path = fixture_root / "registry" / "CANONICAL.json"
    doc = _json.loads(canonical_path.read_text(encoding="utf-8"))
    doc["schema_version"] = "9.9.9-future"
    canonical_path.write_text(_json.dumps(doc), encoding="utf-8")

    c = cache_mod.RegistryCache(root=fixture_root)
    status = c.index_status()
    assert status["source_schema_version"] == "9.9.9-future"
    assert status["source_schema_supported"] is False
    c.close()


def test_search_delegates_to_sql_index(fixture_root):
    c = cache_mod.RegistryCache(root=fixture_root)
    hits = c.search("primordial")
    assert any(h["code"] == "EQ-001/H.01.v1" for h in hits)
    c.close()


def test_find_equivalence_candidates_delegates_to_indexed_prefilter(fixture_root):
    c = cache_mod.RegistryCache(root=fixture_root)
    hits = c.find_equivalence_candidates("x != y readout", limit=5)
    assert any(h.code == "EQ-001/M.03.v1" for h in hits)
    c.close()


def test_lineage_window_delegates_to_sql(fixture_root):
    c = cache_mod.RegistryCache(root=fixture_root)
    page = c.lineage_window(limit=2)
    assert len(page["events"]) == 2
    c.close()


def test_cache_falls_back_to_stale_with_disclosure_when_retries_exhausted(fixture_root, monkeypatch):
    """Grafts A4/C5 (mcp/DESIGN.md sec. 4): once a `RegistryCache` already
    holds a good `Registry`, a `core.load_registry` call that fails outright
    (every retry inside it exhausted) must not raise into the caller — the
    cache keeps serving the last-known-good `Registry`, flags itself
    `degraded`, and every subsequent read still answers (with the fact of
    staleness now disclosed via `index_status()`), rather than the whole
    server going dark on one bad read."""
    c = cache_mod.RegistryCache(root=fixture_root)
    assert c.ensure_fresh() is True
    good_registry = c.registry
    assert c.degraded is False

    def always_fails(root=None, **kwargs):
        raise json.JSONDecodeError("boom", doc="", pos=0)

    monkeypatch.setattr(core, "load_registry", always_fails)
    # Force ensure_fresh() past its unchanged-fingerprint short-circuit
    # WITHOUT touching the actual registry files on disk (which would also
    # invalidate the already-built SQLite index and pull an unrelated
    # rebuild-path failure into the index_status() call below) -- this
    # simulates "the cache believes a reload is due" the same way a real
    # source edit would, while keeping the on-disk index legitimately fresh.
    c._source_fp = {}

    assert c.ensure_fresh() is False  # no reload happened -- fell back
    assert c.registry is good_registry  # still serving the last-known-good view
    assert c.degraded is True
    assert c.degraded_reason is not None and "boom" in c.degraded_reason

    status = c.index_status()
    assert status["degraded"] is True
    assert status["degraded_reason"] is not None
    # the tool-facing read still works, from the retained-good registry
    assert c.get("EQ-001") is not None


def test_cache_raises_on_first_load_failure_with_nothing_to_fall_back_to(fixture_root, monkeypatch):
    """If the VERY FIRST load fails (nothing good in memory yet), there is
    genuinely nothing to fall back to — this must raise, not silently
    report an empty/degraded cache as if it had ever served real data."""
    def always_fails(root=None, **kwargs):
        raise json.JSONDecodeError("boom", doc="", pos=0)

    monkeypatch.setattr(core, "load_registry", always_fails)
    c = cache_mod.RegistryCache(root=fixture_root)
    with pytest.raises(json.JSONDecodeError):
        c.ensure_fresh()


def test_hot_path_freshness_check_uses_stat_only(fixture_root, monkeypatch):
    """Graft B6, perf-regression guard: `RegistryCache.get`'s hot path
    (`ensure_fresh` when nothing changed) must decide freshness from
    `index.source_fingerprints` (a plain `os.stat` per source file) alone —
    never by opening the on-disk SQLite index (`index.check_freshness`/
    `needs_rebuild`), which costs a real connect/query/close round trip this
    cache exists specifically to avoid paying on every single lookup. Pins
    the fix `mcp/docs/DESIGN.md` already recorded once, so it cannot regress
    silently a second time."""
    c = cache_mod.RegistryCache(root=fixture_root)
    c.ensure_fresh()  # first load, real index build -- allowed to touch sqlite

    def must_not_be_called(*args, **kwargs):
        raise AssertionError("index.check_freshness/needs_rebuild must not be called on the cache.get() hot path")

    monkeypatch.setattr(index, "check_freshness", must_not_be_called)
    monkeypatch.setattr(index, "needs_rebuild", must_not_be_called)

    for _ in range(100):
        assert c.get("EQ-001") is not None


def test_get_cache_singleton_and_reset(fixture_root, monkeypatch):
    cache_mod.reset_cache_for_tests()
    c1 = cache_mod.get_cache(fixture_root)
    c2 = cache_mod.get_cache(fixture_root)
    assert c1 is c2
    cache_mod.reset_cache_for_tests()
    c3 = cache_mod.get_cache(fixture_root)
    assert c3 is not c1


# ---------------------------------------------------------------------------
# Residual review finding, 2026-09-07: "the self-heal for a corrupted
# mcp/state/index.sqlite3 only triggers on a fresh connection." The existing
# self-heal (`index._load_meta`'s `sqlite3.DatabaseError` catch) only fires
# when a FRESH connection is opened to read `meta` during a freshness check
# (`queries.IndexHandle.ensure_fresh`'s own `needs_rebuild` call). If that
# freshness check itself does not detect the corruption (e.g. corruption
# confined to pages `needs_rebuild`'s narrow `meta`-table read never
# touches), `IndexHandle.ensure_fresh` keeps serving the SAME, actually-
# corrupted connection — and the real query against it used to have nothing
# catching a `sqlite3.DatabaseError` at all. `RegistryCache._run_indexed`
# closes this gap by catching `sqlite3.DatabaseError` from the QUERY ITSELF
# (not only from a freshness check), then close/delete/rebuild/retry once.
# ---------------------------------------------------------------------------

def test_search_self_heals_when_index_file_is_corrupted_mid_session(fixture_root, monkeypatch):
    """Corrupts `mcp/state/index.sqlite3` ON DISK after a `RegistryCache`
    has already opened (and cached) a live connection to it — reproducing a
    real mid-session corruption (bit rot, a killed process mid-write, a bad
    copy landing under a live server). `index.needs_rebuild` is monkeypatched
    to always report "not stale" — simulating the freshness check's blind
    spot this finding names (a corruption `needs_rebuild`'s own check does
    not happen to catch) — so the ONLY thing that can possibly recover here
    is `_run_indexed`'s catch around the query itself, not the pre-existing
    freshness-check self-heal. Must not raise, must return the correct,
    fully-rebuilt result, and must have rebuilt the on-disk index file."""
    c = cache_mod.RegistryCache(root=fixture_root)
    reg = core.load_registry(fixture_root)

    # Warm the cache: open the real connection once (mirrors ordinary use).
    first = c.search("", limit=len(reg.entries))
    assert len(first) == len(reg.entries)

    # SQLite caches pages in memory per-connection; this test's fixture
    # database is small enough to be fully cached after one query, which
    # would otherwise mask an on-disk corruption from the SAME connection
    # (it would just keep serving from its own cache, never re-reading the
    # now-corrupted bytes) — defeating the very scenario this test exists to
    # reproduce. Force the live, cached connection to drop its page cache so
    # the NEXT query genuinely has to read the corrupted bytes back off disk.
    conn = c._index_handle.conn
    conn.execute("PRAGMA cache_size=0")
    conn.execute("PRAGMA shrink_memory")

    # Corrupt the on-disk index file while the connection above is (still)
    # live/cached inside `c`'s `IndexHandle`.
    db_path = paths.index_db_path(fixture_root)
    with open(db_path, "r+b") as fh:
        fh.seek(0)
        fh.write(b"\x00" * min(4096, db_path.stat().st_size))

    # Simulate the freshness check's blind spot EXACTLY ONCE: even though
    # the file is objectively corrupted, the very next `needs_rebuild` call
    # (as invoked from `queries.IndexHandle.ensure_fresh`, right before the
    # real query runs) reports "nothing changed" — so the pre-existing
    # fresh-connection self-heal path does not fire and the query runs
    # against the still-cached, now-corrupted connection. Every call AFTER
    # that first one behaves normally (needed so `_run_indexed`'s own
    # recovery — which legitimately calls `needs_rebuild` again once the
    # file has been deleted — can actually detect "no index built yet" and
    # rebuild for real).
    real_needs_rebuild = index.needs_rebuild
    calls = {"n": 0}

    def lie_once(root=None):
        calls["n"] += 1
        if calls["n"] == 1:
            return False
        return real_needs_rebuild(root)

    monkeypatch.setattr(index, "needs_rebuild", lie_once)

    # The real query must still self-heal: it hits `sqlite3.DatabaseError`
    # against the now-corrupted cached connection, and `_run_indexed`
    # recovers by closing, deleting the index file, forcing one rebuild, and
    # retrying — all internal to this one call.
    second = c.search("", limit=len(reg.entries))
    assert len(second) == len(reg.entries)
    assert {r["code"] for r in second} == {r["code"] for r in first}

    # The on-disk file must be a genuinely rebuilt, healthy database now
    # (not the zeroed-out corruption still sitting there).
    conn = sqlite3.connect(f"file:{db_path}?mode=ro", uri=True)
    try:
        n = conn.execute("SELECT COUNT(*) FROM entries").fetchone()[0]
        assert n == len(reg.entries)
    finally:
        conn.close()


def test_run_indexed_raises_clear_error_when_rebuild_does_not_repair(fixture_root, monkeypatch):
    """If even the post-rebuild retry still fails (e.g. the query itself is
    broken, not the file), `_run_indexed` must raise a clear, typed error —
    `sqlite3.OperationalError` (a `sqlite3.Error` subclass), so
    `server.py`'s existing `_safe` catch still turns it into the standard
    `INDEX_UNAVAILABLE` envelope — never loop, never silently return a
    partial/empty answer."""
    c = cache_mod.RegistryCache(root=fixture_root)
    c.ensure_fresh()

    def always_broken(conn):
        raise sqlite3.DatabaseError("simulated: query itself is unfixable by a rebuild")

    with pytest.raises(sqlite3.OperationalError, match="did not repair it"):
        c._run_indexed(always_broken)
