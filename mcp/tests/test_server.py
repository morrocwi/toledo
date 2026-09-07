"""Tests the actual `@mcp.tool()`-decorated functions in server.py (FastMCP's
decorator returns the original function unchanged — modulo this file's own
`_safe` wrapper, which preserves the call signature via `functools.wraps` —
so these are called exactly as written, no MCP transport involved, but the
same code path a real tool call runs).

Every assertion below goes through the error-envelope shape (mcp/DESIGN.md
sec. 3, graft A1): `{"ok": bool, "data": ..., "error": {"code","message"} |
None}`. `_data(result)` is this file's own small helper for "assert ok is
true and hand me `data`" so the individual tests below read close to the
pre-envelope assertions they replace, rather than repeating the same three
lines forty times.
"""
from __future__ import annotations

import sqlite3

import pytest

from toledo_mcp import cache as cache_mod
from toledo_mcp import cli, server


def _data(result: dict):
    assert result["ok"] is True, result
    assert result["error"] is None or result["error"].get("code") == "STALE_INDEX", result
    return result["data"]


@pytest.fixture(autouse=True)
def _isolated_cache(fixture_root):
    cache_mod.reset_cache_for_tests()
    yield
    cache_mod.reset_cache_for_tests()


# ---------------------------------------------------------------------------
# Envelope shape itself
# ---------------------------------------------------------------------------

def test_every_tool_result_is_the_ok_data_error_envelope(fixture_root):
    for result in (
        server.toledo_search("primordial"),
        server.toledo_get("EQ-001/M.05.v1"),
        server.toledo_status("EQ-001/M.05.v1"),
        server.toledo_check(code="EQ-001/M.05.v1"),
        server.toledo_lineage("EQ-001/M.05.v1"),
        server.toledo_ancestors("EQ-001/M.05.v1"),
        server.toledo_descendants("EQ-001/M.08.v1"),
        server.toledo_neighbours("EQ-001/M.01.v1"),
        server.toledo_by_root("EQ-001"),
        server.toledo_by_domain("H"),
        server.toledo_by_record("1"),
        server.toledo_by_raw_key("1:(1)"),
        server.toledo_lineage_window(limit=2),
        server.toledo_counts(),
        server.toledo_index_status(),
        server.toledo_show_verdict_rules(),
        server.toledo_list_proposals(),
    ):
        assert set(result.keys()) == {"ok", "data", "error"}
        assert isinstance(result["ok"], bool)


def test_not_found_is_ok_true_with_null_data_not_a_transport_error(fixture_root):
    """graft A1's whole point: a genuinely-absent code is a normal answer
    (`ok: true, data: null`), never a transport-level error."""
    for result in (
        server.toledo_get("NOPE"),
        server.toledo_status("NOPE"),
        server.toledo_lineage("NOPE"),
        server.toledo_ancestors("NOPE"),
        server.toledo_by_raw_key("nope"),
        server.toledo_proposal_status("mcp/proposals/does-not-exist.json"),
    ):
        assert result["ok"] is True
        assert result["data"] is None
        assert result["error"] is None


def test_invalid_input_is_ok_false_with_typed_error_code(fixture_root):
    both = server.toledo_check(formula="x", code="Y")
    neither = server.toledo_check()
    bad_domain = server.toledo_by_domain("ZZ")
    bad_limit = server.toledo_search("x", limit=-1)

    for result in (both, neither, bad_domain, bad_limit):
        assert result["ok"] is False
        assert result["data"] is None
        assert result["error"]["code"] == "INVALID_INPUT"


def test_register_proposal_rejects_non_dict_fields(fixture_root):
    result = server.toledo_register_proposal("not a dict")  # type: ignore[arg-type]
    assert result["ok"] is False
    assert result["error"]["code"] == "INVALID_INPUT"


# ---------------------------------------------------------------------------
# Individual tools
# ---------------------------------------------------------------------------

def test_toledo_search_tool(fixture_root):
    data = _data(server.toledo_search("primordial"))
    assert any(h["code"] == "EQ-001/H.01.v1" for h in data["hits"])


def test_toledo_get_tool_returns_entry_and_verdict(fixture_root):
    data = _data(server.toledo_get("EQ-001/M.05.v1"))
    assert data["entry"]["code"] == "EQ-001/M.05.v1"
    assert data["verdict"]["verdict"] == "REGISTERED_CURRENT"
    assert data["verdict"]["usable"] is True
    assert _data(server.toledo_get("NOPE")) is None


def test_toledo_get_tool_blocks_superseded(fixture_root):
    data = _data(server.toledo_get("EQ-001/M.04.v1"))
    assert data["verdict"]["verdict"] == "REGISTERED_SUPERSEDED"
    assert data["verdict"]["usable"] is False
    assert data["verdict"]["redirect"] == ["EQ-001/M.05.v1"]


def test_toledo_status_tool_matches_get_verdict(fixture_root):
    data = _data(server.toledo_status("EQ-001/M.08.v1"))
    assert data["verdict"] == "REGISTERED_SPLIT"
    assert data["usable"] is False
    assert set(data["redirect"]) == {"EQ-001/M.09.v1", "EQ-001/M.10.v1"}


def test_toledo_check_by_code(fixture_root):
    data = _data(server.toledo_check(code="EQ-001/M.05.v1"))
    assert data["verdict"] == "REGISTERED_CURRENT"


def test_toledo_check_by_formula_phi_method(fixture_root):
    data = _data(server.toledo_check(formula="x != y readout"))
    assert data["verdict"] in ("REGISTERED_CURRENT", "CANDIDATE_MATCH")
    assert any(c["code"] == "EQ-001/M.03.v1" for c in data["candidates"])


def test_toledo_check_by_formula_difflib_method(fixture_root):
    data = _data(server.toledo_check(formula="a != b readout", method="difflib"))
    assert data["verdict"] == "REGISTERED_CURRENT"


def test_toledo_check_by_formula_difflib_exact_match_to_not_an_equation_is_never_registered_current(fixture_root):
    """R3-1 (2026-09-07): the `method="difflib"` path used to map a bare
    similarity-threshold "registered" verdict straight to
    REGISTERED_CURRENT/usable=True with NO check of the matched entry's own
    `status` -- so a formula that exact-matches a `not_an_equation` entry's
    statement (EQ-001/M.11.v1's own statement, verbatim, in the fixture)
    used to come back "REGISTERED_CURRENT, usable, cite that code" for a
    coded prose-pointer that must never be presented as an equation."""
    data = _data(server.toledo_check(formula="just prose, no operator", method="difflib"))
    assert data["verdict"] == "REGISTERED_NOT_AN_EQUATION"
    assert data["usable"] is False
    assert data["verdict"] != "REGISTERED_CURRENT"


def test_toledo_check_rejects_both_or_neither(fixture_root):
    """Changed from the first pass (mcp/DESIGN.md sec. 3, graft A1): this
    malformed-call shape used to come back as a verdict of AMBIGUOUS; the
    call itself being malformed and the registry genuinely being ambiguous
    are now told apart via the error envelope."""
    assert server.toledo_check()["error"]["code"] == "INVALID_INPUT"
    assert server.toledo_check(formula="x", code="Y")["error"]["code"] == "INVALID_INPUT"


def test_toledo_check_not_registered(fixture_root):
    data = _data(server.toledo_check(formula="totally novel formula never seen z=w^99"))
    assert data["verdict"] == "NOT_REGISTERED"
    assert data["usable"] is False


def test_toledo_check_rejects_negative_limit(fixture_root):
    assert server.toledo_check(formula="x", limit=-1)["error"]["code"] == "INVALID_INPUT"


def test_toledo_lineage_tool(fixture_root):
    data = _data(server.toledo_lineage("EQ-001/M.09.v1"))
    assert data is not None
    assert "EQ-001/M.08.v1" in data["ancestry"]


def test_toledo_ancestors_tool(fixture_root):
    data = _data(server.toledo_ancestors("EQ-001/M.09.v1"))
    assert "EQ-001/M.08.v1" in data and "EQ-001" in data
    assert _data(server.toledo_ancestors("NOPE")) is None


def test_toledo_descendants_tool(fixture_root):
    data = _data(server.toledo_descendants("EQ-001/M.08.v1"))
    got = {d["code"] for d in data["items"]}
    assert got == {"EQ-001/M.09.v1", "EQ-001/M.10.v1"}


def test_toledo_neighbours_tool_reverse_relation(fixture_root):
    data = _data(server.toledo_neighbours("EQ-001/M.01.v1"))
    rows = data["neighbours"]
    assert any(n["code"] == "EQ-001/H.01.v1" and n["relation"] == "reverse_relation" for n in rows)


def test_toledo_neighbours_verdict_only_on_parent_child_rows(fixture_root):
    """graft B1's own carve-out: a relation/reverse_relation row is a
    cross-link annotation, not itself a citable entry, so it carries no
    verdict; parent/child rows do."""
    data = _data(server.toledo_neighbours("EQ-001/M.09.v1"))
    rows = data["neighbours"]
    parent_rows = [r for r in rows if r["relation"] == "parent"]
    assert parent_rows and all(r["verdict"] is not None for r in parent_rows)

    reverse_rows = [r for r in rows if r["relation"] == "reverse_relation"]
    relation_rows = [r for r in rows if r["relation"] not in ("parent", "child")]
    for r in reverse_rows + relation_rows:
        assert r["verdict"] is None


def test_toledo_by_root_by_domain_by_record_by_raw_key(fixture_root):
    assert any(e["code"] == "EQ-001/H.01.v1" for e in _data(server.toledo_by_root("EQ-001"))["items"])
    assert {e["code"] for e in _data(server.toledo_by_domain("H"))["items"]} == {"EQ-001/H.01.v1"}
    assert any(e["code"] == "EQ-001/M.01.v1" for e in _data(server.toledo_by_record("1"))["items"])
    data = _data(server.toledo_by_raw_key("1:(1)"))
    assert data["entry"]["code"] == "EQ-001/M.01.v1"
    assert _data(server.toledo_by_raw_key("nope")) is None


def test_toledo_lineage_window_tool(fixture_root):
    data = _data(server.toledo_lineage_window(limit=2))
    assert len(data["events"]) == 2
    assert data["next_cursor"] == 2


def test_toledo_lineage_window_rejects_negative_limit_or_cursor(fixture_root):
    assert server.toledo_lineage_window(limit=-1)["error"]["code"] == "INVALID_INPUT"
    assert server.toledo_lineage_window(cursor=-1)["error"]["code"] == "INVALID_INPUT"


def test_toledo_index_status_tool(fixture_root):
    data = _data(server.toledo_index_status())
    assert data["source_schema_supported"] is True
    assert data["stale"] is False


def test_toledo_counts_tool(fixture_root):
    data = _data(server.toledo_counts())
    assert data["canonical_entries"] > 0
    # counts-mismatch fix (2026-09-07): the merged root+reading search
    # corpus total is exposed under its own key, never folded back into
    # canonical_entries.
    assert data["merged_search_entries"] >= data["canonical_entries"]


# ---------------------------------------------------------------------------
# PERF-2 (2026-09-07): `_safe` only caught `(FileNotFoundError, OSError)` --
# `sqlite3.Error` (and every subclass, including a corrupted-index
# `sqlite3.DatabaseError`) escaped straight past it to a bare FastMCP
# tool-error string, bypassing the `{"ok","data","error"}` envelope this
# module's own docstring documents `_safe` as guaranteeing.
# ---------------------------------------------------------------------------

def test_safe_decorator_catches_sqlite_errors_as_index_unavailable():
    @server._safe
    def boom():
        raise sqlite3.DatabaseError("database disk image is malformed")

    result = boom()
    assert result["ok"] is False
    assert result["error"]["code"] == "INDEX_UNAVAILABLE"
    assert "database disk image is malformed" in result["error"]["message"]


# ---------------------------------------------------------------------------
# PERF-3 (2026-09-07): a missing `registry/CANONICAL.json` used to come back
# from `toledo_search` as a misleadingly empty `{"hits": []}` -- `ok: true`,
# indistinguishable from "the registry legitimately has zero matches" --
# instead of the documented "nothing to serve" error.
# ---------------------------------------------------------------------------

def test_toledo_search_reports_index_unavailable_when_canonical_json_missing(tmp_path, monkeypatch):
    empty_root = tmp_path / "no_registry_here"
    (empty_root / "registry").mkdir(parents=True)
    monkeypatch.setenv("TOLEDO_ROOT", str(empty_root))
    monkeypatch.setenv("TOLEDO_MCP_STATE_DIR", str(tmp_path / "state"))
    cache_mod.reset_cache_for_tests()
    try:
        result = server.toledo_search("anything")
        assert result["ok"] is False
        assert result["error"]["code"] == "INDEX_UNAVAILABLE"
        assert "CANONICAL.json" in result["error"]["message"]
    finally:
        cache_mod.reset_cache_for_tests()


def test_toledo_register_and_list_and_status_proposal(fixture_root):
    result = _data(server.toledo_register_proposal({"name": "server test eq", "statement": "p = q"}))
    assert result["path"]
    assert result["path"].startswith("mcp/proposals/")
    listing = _data(server.toledo_list_proposals(status="PENDING"))["items"]
    assert any(p["path"] == result["path"] for p in listing)
    got = _data(server.toledo_proposal_status(result["path"]))
    assert got["proposal"]["name"] == "server test eq"
    assert got["status"]["status"] == "PENDING"


def test_toledo_register_proposal_never_touches_registry_files(fixture_root):
    canonical_before = (fixture_root / "registry" / "CANONICAL.json").read_text(encoding="utf-8")
    server.toledo_register_proposal({"name": "x"})
    assert (fixture_root / "registry" / "CANONICAL.json").read_text(encoding="utf-8") == canonical_before


def test_toledo_list_proposals_rejects_negative_limit(fixture_root):
    assert server.toledo_list_proposals(limit=-1)["error"]["code"] == "INVALID_INPUT"


# ---------------------------------------------------------------------------
# graft B1 — per-entry verdict on every row-list tool
# ---------------------------------------------------------------------------

def test_search_and_list_tools_carry_per_row_verdict(fixture_root):
    search_hits = _data(server.toledo_search(""))["hits"]
    by_root_hits = _data(server.toledo_by_root("EQ-001"))["items"]
    by_domain_hits = _data(server.toledo_by_domain("H"))["items"]
    by_record_hits = _data(server.toledo_by_record("1"))["items"]
    descendants_hits = _data(server.toledo_descendants("EQ-001/M.08.v1"))["items"]

    for rows, label in (
        (search_hits, "search"), (by_root_hits, "by_root"), (by_domain_hits, "by_domain"),
        (by_record_hits, "by_record"), (descendants_hits, "descendants"),
    ):
        assert rows, f"{label} returned no rows to check"
        for row in rows:
            assert "verdict" in row, (label, row)
            assert set(row["verdict"].keys()) == {"verdict", "usable", "reason", "redirect", "candidates"}

    # the superseded fixture code, when it appears, must carry a non-usable verdict
    superseded_row = next((r for r in search_hits if r["code"] == "EQ-001/M.04.v1"), None)
    if superseded_row is not None:
        assert superseded_row["verdict"]["verdict"] == "REGISTERED_SUPERSEDED"
        assert superseded_row["verdict"]["usable"] is False


# ---------------------------------------------------------------------------
# grafts B5/C7 — format="toon"
# ---------------------------------------------------------------------------

def test_format_toon_round_trips_same_data_as_json(fixture_root):
    json_data = _data(server.toledo_search("", root="EQ-001", format="json"))
    toon_data = _data(server.toledo_search("", root="EQ-001", format="toon"))

    assert toon_data["hits"] is None
    assert isinstance(toon_data["hits_toon"], str) and toon_data["hits_toon"]
    assert json_data["hits_toon"] if "hits_toon" in json_data else True  # json mode never sets it
    assert "hits_toon" not in json_data

    decoded = cli.decode_toon(toon_data["hits_toon"])
    got = {(r["code"], r.get("tier"), r.get("status")) for r in decoded}
    want = {(r["code"], r.get("tier"), r.get("status")) for r in json_data["hits"]}
    assert got == want


def test_format_toon_on_by_root_by_domain_by_record_descendants(fixture_root):
    for call in (
        lambda fmt: server.toledo_by_root("EQ-001", format=fmt),
        lambda fmt: server.toledo_by_domain("H", format=fmt),
        lambda fmt: server.toledo_by_record("1", format=fmt),
        lambda fmt: server.toledo_descendants("EQ-001/M.08.v1", format=fmt),
    ):
        json_items = _data(call("json"))["items"]
        toon_data = _data(call("toon"))
        assert toon_data["items"] is None
        decoded = cli.decode_toon(toon_data["items_toon"])
        assert {r["code"] for r in decoded} == {r["code"] for r in json_items}


# ---------------------------------------------------------------------------
# graft A6 — toledo_show_verdict_rules
# ---------------------------------------------------------------------------

def test_show_verdict_rules_matches_verdict_py_known_statuses(fixture_root):
    from toledo_mcp import verdict as verdict_mod

    data = _data(server.toledo_show_verdict_rules())
    assert set(data["statuses"]) == verdict_mod._KNOWN_STATUSES
    assert set(data["verdict_values"]) == set(verdict_mod.VERDICT_VALUES)
    assert len(data["verdict_values"]) == 11
    assert any(r["verdict"] == "CAUTION" for r in data["rules"])


# ---------------------------------------------------------------------------
# grafts A4/C5 — stale disclosure
# ---------------------------------------------------------------------------

def test_stale_disclosure_activates_once_cache_reports_degraded(fixture_root, monkeypatch):
    """Exercises the REAL `cache.RegistryCache.ensure_fresh` degraded path
    (mcp/DESIGN.md sec. 4/5) end to end through a server tool, not just a
    hand-set flag: warm the cache with a real load, force
    `core.load_registry` to raise on the NEXT attempt, then touch a source
    file's mtime so `ensure_fresh` actually attempts (and is forced to
    retry) a reload instead of short-circuiting on an unchanged fingerprint.
    `server.py`'s envelope must then disclose `data.stale: true` +
    `error.code == "STALE_INDEX"` while still returning the last-known-good
    payload (`ok: true`), never a silent success and never a raised
    exception reaching the caller."""
    import json as _json
    import time

    from toledo_mcp import core as core_mod

    real_cache = cache_mod.get_cache()
    real_cache.ensure_fresh()  # warm: a real Registry is now held in memory
    assert real_cache.degraded is False

    def _always_raise(*_a, **_kw):
        raise _json.JSONDecodeError("synthetic failure for this test", "{}", 0)

    monkeypatch.setattr(core_mod, "load_registry", _always_raise)

    # Force ensure_fresh() to actually attempt a reload (and hit the
    # monkeypatched raise) rather than short-circuiting on an unchanged
    # fingerprint — touch a source file's mtime.
    time.sleep(0.01)
    (fixture_root / "registry" / "CANONICAL.json").touch()

    result = server.toledo_counts()
    assert result["ok"] is True
    assert result["data"]["stale"] is True
    assert result["error"]["code"] == "STALE_INDEX"
    assert "synthetic failure" in result["error"]["message"]
    assert real_cache.degraded is True
