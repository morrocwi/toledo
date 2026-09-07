from __future__ import annotations

import sqlite3
import time

import pytest

from toledo_mcp import core, index, paths


def test_build_index_from_fixture(fixture_root):
    reg = core.load_registry(fixture_root)
    report = index.build_index(reg, fixture_root)
    assert report["entry_count"] == len(reg.entries)
    assert report["lineage_event_count"] == len(reg.lineage_events)

    conn = index.get_connection(fixture_root, auto_build=False)
    try:
        n = conn.execute("SELECT COUNT(*) AS n FROM entries").fetchone()["n"]
        assert n == len(reg.entries)
        fts_n = conn.execute("SELECT COUNT(*) AS n FROM entries_fts").fetchone()["n"]
        assert fts_n == len(reg.entries)
        lineage_n = conn.execute("SELECT COUNT(*) AS n FROM lineage").fetchone()["n"]
        assert lineage_n == len(reg.lineage_events)
    finally:
        conn.close()


def test_needs_rebuild_false_right_after_build(fixture_root):
    reg = core.load_registry(fixture_root)
    index.build_index(reg, fixture_root)
    assert index.needs_rebuild(fixture_root) is False


def test_needs_rebuild_true_after_source_edit(fixture_root):
    reg = core.load_registry(fixture_root)
    index.build_index(reg, fixture_root)
    assert index.needs_rebuild(fixture_root) is False

    canonical_path = fixture_root / "registry" / "CANONICAL.json"
    text = canonical_path.read_text(encoding="utf-8")
    time.sleep(0.01)
    canonical_path.write_text(text + "\n", encoding="utf-8")  # size + mtime both change

    assert index.needs_rebuild(fixture_root) is True


def test_get_connection_auto_builds(fixture_root):
    conn = index.get_connection(fixture_root, auto_build=True)
    try:
        n = conn.execute("SELECT COUNT(*) AS n FROM entries").fetchone()["n"]
        assert n > 0
    finally:
        conn.close()


def test_atomic_swap_leaves_old_readable_mid_rebuild(fixture_root):
    """A connection opened before a rebuild keeps working after the rebuild
    (os.replace swaps the path; the already-open fd on POSIX keeps pointing
    at the old inode's data)."""
    reg = core.load_registry(fixture_root)
    index.build_index(reg, fixture_root)
    old_conn = index.get_connection(fixture_root, auto_build=False)
    old_count = old_conn.execute("SELECT COUNT(*) AS n FROM entries").fetchone()["n"]

    # simulate a registry change + rebuild happening concurrently
    reg2 = core.load_registry(fixture_root)
    index.build_index(reg2, fixture_root)

    # old connection still serves a consistent (old) view without error
    still_old_count = old_conn.execute("SELECT COUNT(*) AS n FROM entries").fetchone()["n"]
    assert still_old_count == old_count
    old_conn.close()


def test_cross_check_toledo_json_reports_absence_when_missing(fixture_root):
    reg = core.load_registry(fixture_root)
    findings = index.cross_check_toledo_json(reg.entries, fixture_root)
    assert any("not found" in f for f in findings)


def test_readonly_connection_cannot_write(fixture_root):
    """Graft C3 (mcp/DESIGN.md sec. 4): a connection opened via
    `index.get_connection` — the same helper `queries.IndexHandle.open`
    uses — is incapable of writing by construction (`mode=ro` URI), not
    merely by convention. Complements, rather than replaces, the existing
    write-boundary hash-diff test
    (`tests/test_proposals.py::test_register_proposal_writes_file_never_touches_registry`),
    which proves the boundary at the Python-call level; this proves the
    SQL-level one cannot even be crossed by a bug in a future `queries.py`
    change."""
    reg = core.load_registry(fixture_root)
    index.build_index(reg, fixture_root)
    conn = index.get_connection(fixture_root, auto_build=False)
    try:
        with pytest.raises(sqlite3.OperationalError, match="readonly"):
            conn.execute("INSERT INTO meta (key, value) VALUES ('x', 'y')")
        with pytest.raises(sqlite3.OperationalError, match="readonly"):
            conn.execute("DELETE FROM entries")
    finally:
        conn.close()


# ---------------------------------------------------------------------------
# PERF-1 (2026-09-07): `_load_meta` only caught `sqlite3.OperationalError`,
# which is `DatabaseError`'s PARENT class, not a subclass -- a genuinely
# corrupted index.sqlite3 (bit rot, a killed process mid-write, a bad copy)
# raises `sqlite3.DatabaseError` ("database disk image is malformed")
# straight past that narrower except, turning a condition every OTHER
# staleness case in this design self-heals from into a hard crash instead.
# ---------------------------------------------------------------------------

def test_corrupted_index_self_heals_via_check_freshness_and_rebuild(fixture_root):
    """Source registry files are left completely untouched -- only
    `index.sqlite3` is corrupted, exactly the condition the finding
    reproduced live. `_load_meta`'s widened except must return `{}` instead
    of raising, which `check_freshness` already turns into `stale=True`,
    which `needs_rebuild`/`get_connection(auto_build=True)` already turn
    into an automatic rebuild from the unaffected source files -- no other
    code path should need to change for this to self-heal."""
    reg = core.load_registry(fixture_root)
    index.build_index(reg, fixture_root)

    db_path = paths.index_db_path(fixture_root)
    original_size = db_path.stat().st_size
    with open(db_path, "r+b") as fh:
        fh.truncate(original_size // 2)

    # Must not raise (the confirmed-live bug: sqlite3.DatabaseError escaping
    # straight out of `_load_meta`/`check_freshness` uncaught).
    freshness = index.check_freshness(fixture_root)
    assert freshness.stale is True

    # And a normal, auto_build=True caller must transparently self-heal --
    # not merely report staleness without recovering.
    conn = index.get_connection(fixture_root, auto_build=True)
    try:
        n = conn.execute("SELECT COUNT(*) AS n FROM entries").fetchone()["n"]
        assert n == len(reg.entries)
    finally:
        conn.close()


def test_check_freshness_connection_is_also_readonly(fixture_root):
    """`check_freshness`'s own internal `meta` read (used by
    `index.needs_rebuild`) goes through the same `_readonly_connection`
    helper as `get_connection` — a second call site, same guarantee, not a
    second implementation of the read-only decision."""
    reg = core.load_registry(fixture_root)
    index.build_index(reg, fixture_root)
    freshness = index.check_freshness(fixture_root)
    assert freshness.stale is False
    assert freshness.source_entry_count == len(reg.entries)
