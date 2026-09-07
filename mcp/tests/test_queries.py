from __future__ import annotations

import time

import pytest

from toledo_mcp import core, index, queries, regex_guard


def _conn(fixture_root):
    reg = core.load_registry(fixture_root)
    index.build_index(reg, fixture_root)
    return index.get_connection(fixture_root, auto_build=False)


def test_get_matches_core_get(fixture_root):
    reg = core.load_registry(fixture_root)
    conn = _conn(fixture_root)
    try:
        for code in reg.by_code:
            assert queries.get(conn, code) == core.get(reg, code)
        assert queries.get(conn, "NOPE") is None
    finally:
        conn.close()


def test_status_matches_core_status(fixture_root):
    reg = core.load_registry(fixture_root)
    conn = _conn(fixture_root)
    try:
        for code in reg.by_code:
            assert queries.status(conn, code) == core.status(reg, code)
    finally:
        conn.close()


def test_search_plain_text_finds_expected_code(fixture_root):
    conn = _conn(fixture_root)
    try:
        hits = queries.search(conn, "primordial")
        codes = {h["code"] for h in hits}
        assert "EQ-001/H.01.v1" in codes
    finally:
        conn.close()


def test_search_symbol_heavy_query_falls_back_to_like(fixture_root):
    conn = _conn(fixture_root)
    try:
        hits = queries.search(conn, "delta_R")
        codes = {h["code"] for h in hits}
        assert "EQ-001/H.01.v1" in codes
    finally:
        conn.close()


def test_search_filters_by_domain(fixture_root):
    conn = _conn(fixture_root)
    try:
        hits = queries.search(conn, "", domain="H")
        assert all(h["domain"] == "H" for h in hits)
        assert any(h["code"] == "EQ-001/H.01.v1" for h in hits)
    finally:
        conn.close()


def test_search_regex(fixture_root):
    conn = _conn(fixture_root)
    try:
        hits = queries.search(conn, r"CYCLE [AB]", regex=True)
        codes = {h["code"] for h in hits}
        assert codes == {"EQ-001/M.06.v1", "EQ-001/M.07.v1"}
    finally:
        conn.close()


# ---------------------------------------------------------------------------
# SEC-1 (2026-09-07): `query, regex=True` is exposed directly to every AI
# agent over the shared stdio MCP server (`toledo_search(regex=True)`) and
# the CLI (`toledo find --regex`); an uncapped agent-supplied pattern run
# against an uncapped haystack can backtrack exponentially and hang the
# whole single-process server for every other caller.
# ---------------------------------------------------------------------------

def test_search_regex_rejects_overlong_query(fixture_root):
    conn = _conn(fixture_root)
    try:
        with pytest.raises(ValueError):
            queries.search(conn, "a" * (regex_guard.MAX_REGEX_QUERY_LEN + 1), regex=True)
    finally:
        conn.close()


def test_search_regex_catastrophic_pattern_times_out_instead_of_hanging(fixture_root):
    """Before this fix, `re.compile(query).search(haystack)` ran unbounded
    for every row on every `regex=True` call. Add one entry with a long,
    entirely benign statement crafted to force catastrophic backtracking
    under a classic vulnerable pattern, and confirm the guarded search
    raises a timeout well within a bounded wall-clock budget instead of
    hanging (confirmed live against the real registry: this exact class of
    pattern left the process "still hung after 25.002 s" pre-fix)."""
    reg = core.load_registry(fixture_root)
    # Ends in "!" (never "...aaaa$") so `(a+)+$` cannot match trivially and
    # must exhaust its backtracking search instead.
    long_statement = "a" * 60 + "!"
    reg.entries.append({
        "code": "TEST-LONG/M.99.v1", "root": "TEST-LONG", "layer": "reading", "domain": "M",
        "name": "regression fixture: long benign statement",
        "statement": {"latest": long_statement, "format": "ascii-math"},
        "aliases": [], "status": "current", "tier": "Definition",
        "coq": {"coq_status": "not_yet_formalised"},
    })
    index.build_index(reg, fixture_root)
    conn = index.get_connection(fixture_root, auto_build=False)
    try:
        start = time.monotonic()
        with pytest.raises(regex_guard.RegexTimeout):
            queries.search(conn, r"(a+)+$", regex=True)
        elapsed = time.monotonic() - start
        assert elapsed < 10.0
    finally:
        conn.close()


def test_by_root_and_by_domain(fixture_root):
    reg = core.load_registry(fixture_root)
    conn = _conn(fixture_root)
    try:
        all_under_root = queries.by_root(conn, "EQ-001")
        assert len(all_under_root) == len([e for e in reg.entries if e.get("root") == "EQ-001"])
        h_domain = queries.by_domain(conn, "H")
        assert {e["code"] for e in h_domain} == {"EQ-001/H.01.v1"}
    finally:
        conn.close()


def test_by_record_and_by_raw_key(fixture_root):
    conn = _conn(fixture_root)
    try:
        hits = queries.by_record(conn, "1")
        assert any(h["code"] == "EQ-001/M.01.v1" for h in hits)
        entry = queries.by_raw_key(conn, "1:(1)")
        assert entry is not None and entry["code"] == "EQ-001/M.01.v1"
        assert queries.by_raw_key(conn, "nope") is None
    finally:
        conn.close()


def test_ancestry_chain_matches_core(fixture_root):
    reg = core.load_registry(fixture_root)
    conn = _conn(fixture_root)
    try:
        for code in ["EQ-001/H.01.v1", "EQ-001/M.09.v1", "EQ-001"]:
            assert queries.ancestry_chain(conn, code) == core.ancestry_chain(reg, code)
    finally:
        conn.close()


def test_full_ancestors_includes_multi_parent(fixture_root):
    conn = _conn(fixture_root)
    try:
        anc = queries.full_ancestors(conn, "EQ-001/M.09.v1")
        assert "EQ-001/M.08.v1" in anc
        assert "EQ-001" in anc
    finally:
        conn.close()


def test_descendants(fixture_root):
    conn = _conn(fixture_root)
    try:
        desc_codes = {d["code"] for d in queries.descendants(conn, "EQ-001/M.08.v1")}
        assert desc_codes == {"EQ-001/M.09.v1", "EQ-001/M.10.v1"}
    finally:
        conn.close()


def test_neighbours_includes_reverse_relation(fixture_root):
    conn = _conn(fixture_root)
    try:
        # H.01 declares a forward relation to M.01
        forward = queries.neighbours(conn, "EQ-001/H.01.v1")
        assert any(n["code"] == "EQ-001/M.01.v1" and n["relation"] == "reads" for n in forward)
        # M.01 should see the reverse edge back to H.01 — a capability the
        # plain CLI's `neighbours` command does not offer.
        reverse = queries.neighbours(conn, "EQ-001/M.01.v1")
        assert any(n["code"] == "EQ-001/H.01.v1" and n["relation"] == "reverse_relation" for n in reverse)
    finally:
        conn.close()


def test_lineage_for_code_matches_core(fixture_root):
    reg = core.load_registry(fixture_root)
    conn = _conn(fixture_root)
    try:
        for code in ["EQ-001/M.01.v1", "EQ-001/M.05.v1", "EQ-001/M.09.v1"]:
            got = queries.lineage_for_code(conn, code)
            want = core.lineage(reg, code)
            assert got["events"] == want["events"]
            assert got["ancestry"] == want["ancestry"]
            assert sorted(got["children"]) == sorted(want["children"])
        assert queries.lineage_for_code(conn, "NOPE") is None
    finally:
        conn.close()


def test_lineage_window_pagination(fixture_root):
    conn = _conn(fixture_root)
    try:
        page = queries.lineage_window(conn, limit=2)
        assert len(page["events"]) == 2
        assert page["next_cursor"] == 2
        page2 = queries.lineage_window(conn, limit=2, cursor=page["next_cursor"])
        assert len(page2["events"]) == 1
        assert page2["next_cursor"] is None
    finally:
        conn.close()


def test_lineage_window_filter_by_event(fixture_root):
    conn = _conn(fixture_root)
    try:
        splits = queries.lineage_window(conn, event="split")
        assert len(splits["events"]) == 1
        assert splits["events"][0]["code"] == "EQ-001/M.08.v1"
    finally:
        conn.close()


def test_counts_matches_core(fixture_root):
    reg = core.load_registry(fixture_root)
    conn = _conn(fixture_root)
    try:
        c1 = core.counts(reg)
        c2 = queries.counts(conn)
        assert c1["canonical_entries"] == c2["canonical_entries"]
        assert c1["by_status"] == c2["by_status"]
        assert c1["by_domain"] == c2["by_domain"]
        assert c1["by_tier"] == c2["by_tier"]
        assert c1["lineage_events"] == c2["lineage_events"]
    finally:
        conn.close()
