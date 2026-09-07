"""End-to-end walkthroughs a builder wiring server.py's tool bodies should be
able to read directly: each test plays out one MCP tool call as
`server.py` would implement it (core.load_registry -> index -> queries /
equivalence -> verdict), asserting the whole pipeline agrees with itself and
with `core`'s existing behaviour.
"""
from __future__ import annotations

import asyncio
import json
import pathlib
import sys

from toledo_mcp import core, equivalence, index, queries, verdict


def _handle(root):
    reg = core.load_registry(root)
    index.build_index(reg, root)
    conn = index.get_connection(root, auto_build=False)
    return reg, conn


def test_toledo_get_tool_attaches_verdict(fixture_root):
    reg, conn = _handle(fixture_root)
    try:
        entry = queries.get(conn, "EQ-001/M.04.v1")  # superseded
        v = verdict.verdict_for_entry(entry, lambda c: reg.by_code.get(c))
        assert entry["status"] == "superseded_by"
        assert v.verdict == "REGISTERED_SUPERSEDED"
        assert v.redirect == ["EQ-001/M.05.v1"]
    finally:
        conn.close()


def test_toledo_check_tool_by_code_current(fixture_root):
    reg, conn = _handle(fixture_root)
    try:
        entry = queries.get(conn, "EQ-001/M.05.v1")
        v = verdict.verdict_for_check(entry, [], lambda c: reg.by_code.get(c))
        assert v.verdict == "REGISTERED_CURRENT"
        assert v.usable is True
    finally:
        conn.close()


def test_toledo_check_tool_by_statement_renaming_candidate(fixture_root):
    reg, conn = _handle(fixture_root)
    try:
        # EQ-001/M.03.v1's statement is "x != y readout" -- a renaming of
        # M.01.v1's "a != b readout".
        candidates = equivalence.find_candidates(core.normalise_formula, "x != y readout", reg.entries)
        v = verdict.verdict_for_check(None, candidates, lambda c: reg.by_code.get(c))
        assert v.verdict in ("REGISTERED_CURRENT", "CANDIDATE_MATCH")
        assert any(c["code"] == "EQ-001/M.03.v1" for c in v.candidates)
    finally:
        conn.close()


def test_toledo_check_tool_unknown_formula_not_registered(fixture_root):
    reg, conn = _handle(fixture_root)
    try:
        candidates = equivalence.find_candidates(core.normalise_formula, "totally novel formula z = w^42", reg.entries)
        v = verdict.verdict_for_check(None, candidates, lambda c: reg.by_code.get(c))
        assert v.verdict == "NOT_REGISTERED"
        assert v.usable is False
    finally:
        conn.close()


def test_full_pipeline_matches_core_for_every_fixture_code(fixture_root):
    """Every code's queries.* result must equal the corresponding core.*
    result exactly (same JSON shape) -- the index is a cache, not a
    reinterpretation."""
    reg, conn = _handle(fixture_root)
    try:
        for code, entry in reg.by_code.items():
            assert queries.get(conn, code) == entry
            assert queries.status(conn, code) == core.status(reg, code)
            got_lineage = queries.lineage_for_code(conn, code)
            want_lineage = core.lineage(reg, code)
            assert got_lineage["ancestry"] == want_lineage["ancestry"]
            assert sorted(got_lineage["children"]) == sorted(want_lineage["children"])
            assert got_lineage["events"] == want_lineage["events"]
    finally:
        conn.close()


def test_search_relevance_real_registry_symbol_and_exact_code_queries(real_root):
    """search-relevance fix (2026-09-07): a verbatim unicode/math symbol or a
    bare root code drawn from a known entry's own statement/code must rank
    that entry #1 -- the exact gap this review's lens ("search relevance on
    30 hand-picked queries incl. codes, aliases, unicode symbols") was asked
    to check, which the pre-fix implementation failed on 5/25 fixed-
    expectation queries, all concentrated in exactly the "exact code" and
    "unicode symbol" categories exercised here. Regression-tested against
    the REAL registry, not `tests/conftest.py`'s small synthetic fixture
    (whose ASCII-only statements never exercised the Unicode-stripping FTS
    bug or the flat/alphabetical-tie-break bug this fix closes) -- exactly
    the corpus the pre-fix implementation was broken against."""
    reg = core.load_registry(real_root)
    index.build_index(reg, real_root)
    conn = index.get_connection(real_root, auto_build=False)
    try:
        cases = [
            # "δ_R" -- the literal symbol naming this registry's own
            # founding equation, verbatim inside weld/M.01.v1's own
            # statement; used to omit weld/M.01.v1 from the top 5 entirely
            # (the single-character-token FTS blowup).
            ("δ_R", "weld/M.01.v1"),
            # a root's own bare code, competing against its own readings and
            # an unrelated "WeldDSL" code; used to rank the root 4th.
            ("weld", "weld"),
            # ditto -- used to tie on score with an unrelated substring hit
            # and lose the tie to alphabetical sort.
            ("Theta", "Theta"),
            ("CMC", "CMC"),
            # "Λ_n" -- verbatim inside EQ-015/M.01.v1's own name; used to
            # rank that entry 3rd.
            ("Λ_n", "EQ-015/M.01.v1"),
        ]
        for query, expected_top in cases:
            hits = queries.search(conn, query, limit=5)
            assert hits, f"no hits at all for {query!r}"
            assert hits[0]["code"] == expected_top, (
                f"query {query!r} expected top hit {expected_top!r}, got {[h['code'] for h in hits]}"
            )
    finally:
        conn.close()


# ---------------------------------------------------------------------------
# Real-repo smoke test (read-only) -- proves the pipeline holds at real scale,
# not only against the small synthetic fixture above.
# ---------------------------------------------------------------------------

def test_real_registry_builds_and_answers_queries(real_root):
    reg = core.load_registry(real_root)
    assert len(reg.entries) > 0
    report = index.build_index(reg, real_root)
    assert report["entry_count"] == len(reg.entries)

    conn = index.get_connection(real_root, auto_build=False)
    try:
        c = queries.counts(conn)
        # counts-mismatch fix (2026-09-07): `canonical_entries` counts ONLY
        # `layer != "root"` rows -- i.e. exactly registry/CANONICAL.json's
        # own `canonical[]` array -- not the merged root+reading search
        # corpus `reg.entries` holds. The merged total is still available,
        # under its own key, as `merged_search_entries`.
        canonical_only = [e for e in reg.entries if e.get("layer") != "root"]
        assert c["canonical_entries"] == len(canonical_only)
        assert c["merged_search_entries"] == len(reg.entries)
        assert sum(c["by_status"].values()) == len(canonical_only)

        # EQ-001 is the Genesis root axiom and must be present and current
        # (registry/genesis_root.json's own first row) unless a future
        # registry revision retires it -- either way `get` must agree with
        # `core.get` on whatever is actually on disk right now.
        assert queries.get(conn, "EQ-001") == core.get(reg, "EQ-001")

        hits = queries.search(conn, "primordial", limit=5)
        assert isinstance(hits, list)
    finally:
        conn.close()


def test_counts_matches_registry_canonical_json_own_counts_field(real_root):
    """counts-mismatch fix (2026-09-07) -- the missing check the review that
    caught the bug asked for: compare against the real repository's own
    `registry/CANONICAL.json` `counts{}` field directly, not only against
    this package's fixture/self-consistency (which is all the pre-existing
    `test_counts_matches_core`-family tests ever did, and why 188/188
    passing tests did not catch this).

    Before this fix, `core.counts`/`queries.counts` aggregated over the
    MERGED root+reading entries list (912 canonical readings + 592 genesis-
    root-only rows = 1504 on the corpus this was verified against), not over
    `registry/CANONICAL.json`'s own `canonical[]` array -- inflating
    `canonical_entries` past the registry's own true count and polluting
    every breakdown with placeholder values no canonical entry actually
    carries (a `None` domain bucket, a `RETRACTED` tier not among
    `registry/SCHEMA.md`'s tiers, a `not_yet_formalised` coq_status)."""
    canonical_doc = json.loads((real_root / "registry" / "CANONICAL.json").read_text(encoding="utf-8"))
    want = canonical_doc["counts"]

    reg = core.load_registry(real_root)
    got = core.counts(reg)

    assert got["canonical_entries"] == want["entries"]
    assert got["by_status"] == want["by_status"]
    assert got["by_domain"] == want["by_domain"]
    assert got["by_tier"] == want["by_tier"]
    assert got["by_coq_status"] == want["by_coq_status"]

    # queries.counts (the SQL-backed path toledo_counts/toledo_index_status
    # actually serve from) must agree with core.counts field-for-field, not
    # just each independently agree with CANONICAL.json's own field.
    index.build_index(reg, real_root)
    conn = index.get_connection(real_root, auto_build=False)
    try:
        got_sql = queries.counts(conn)
        assert got_sql["canonical_entries"] == want["entries"]
        assert got_sql["by_status"] == want["by_status"]
        assert got_sql["by_domain"] == want["by_domain"]
        assert got_sql["by_tier"] == want["by_tier"]
        assert got_sql["by_coq_status"] == want["by_coq_status"]
    finally:
        conn.close()


# ---------------------------------------------------------------------------
# Real stdio round trip (mcp/DESIGN.md sec. 9, S2 test plan) -- promotes the
# ad hoc, previously-uncommitted smoke test (spawn a real subprocess, speak
# real MCP-over-stdio, not just call the Python function directly) into the
# committed suite. This is the class of test that already caught one real
# bug in the first pass of this package (a prose false positive found only
# once the server was driven end to end) -- it must not go back to being a
# manually-run, uncommitted step.
# ---------------------------------------------------------------------------

def test_stdio_roundtrip_lists_20_tools(fixture_root, tmp_path):
    from mcp import ClientSession
    from mcp.client.stdio import StdioServerParameters, stdio_client

    server_script = pathlib.Path(__file__).resolve().parent.parent / "toledo_mcp" / "server.py"

    async def _run():
        params = StdioServerParameters(
            command=sys.executable,
            args=[str(server_script)],
            env={
                "TOLEDO_ROOT": str(fixture_root),
                "TOLEDO_MCP_STATE_DIR": str(tmp_path / "stdio_state"),
            },
        )
        async with stdio_client(params) as (read, write):
            async with ClientSession(read, write) as session:
                await session.initialize()

                tools = await session.list_tools()
                names = {t.name for t in tools.tools}
                assert len(tools.tools) == 20, sorted(names)
                assert "toledo_show_verdict_rules" in names
                assert "toledo_register_proposal" in names

                status = await session.call_tool("toledo_index_status", {})
                status_payload = status.structuredContent
                assert status_payload["ok"] is True
                assert status_payload["data"]["source_schema_supported"] is True

                search = await session.call_tool("toledo_search", {"query": "primordial"})
                search_payload = search.structuredContent
                assert search_payload["ok"] is True
                assert any(h["code"] == "EQ-001/H.01.v1" for h in search_payload["data"]["hits"])
                # graft B1: real stdio round trip still carries a per-row verdict
                assert all("verdict" in h for h in search_payload["data"]["hits"])

                rules = await session.call_tool("toledo_show_verdict_rules", {})
                rules_payload = rules.structuredContent
                assert rules_payload["ok"] is True
                assert len(rules_payload["data"]["verdict_values"]) == 11

                missing = await session.call_tool("toledo_get", {"code": "NOPE-DOES-NOT-EXIST"})
                missing_payload = missing.structuredContent
                assert missing_payload == {"ok": True, "data": None, "error": None}

    asyncio.run(_run())
