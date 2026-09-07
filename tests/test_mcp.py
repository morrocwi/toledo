"""Tests for the toledo_mcp core engine (mcp/toledo_mcp/core.py).

Core-functions only — no server process is started here (that would need a live
stdio transport and an MCP client, which is out of scope for a unit test). These
tests exercise the real, read-only registry in this repository; they never write
to registry/CANONICAL.json, registry/genesis_root.json, or registry/LINEAGE.jsonl,
and register_proposal is only exercised against a throwaway tmp_path so no file
lands under the real registry/proposals/.
"""
from __future__ import annotations

import json
import pathlib
import sys

import pytest

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent
MCP_DIR = REPO_ROOT / "mcp"
if str(MCP_DIR) not in sys.path:
    sys.path.insert(0, str(MCP_DIR))

from toledo_mcp import core  # noqa: E402


@pytest.fixture(scope="module")
def reg():
    return core.load_registry(REPO_ROOT)


def test_search_finds_eq_015(reg):
    hits = core.search(reg, "EQ-015", limit=10)
    codes = [h["code"] for h in hits]
    assert "EQ-015" in codes


def test_get_eq_015_root_entry(reg):
    e = core.get(reg, "EQ-015")
    assert e is not None
    assert e["code"] == "EQ-015"
    assert e["layer"] == "root"


def test_check_on_known_statement_returns_registered(reg):
    e = core.get(reg, "EQ-015")
    result = core.check(reg, e["statement"]["latest"])
    assert result["verdict"] == "registered"
    codes = [m["code"] for m in result["matches"]]
    assert "EQ-015" in codes


def test_check_on_unregistered_formula_says_not_found(reg):
    result = core.check(
        reg,
        "qzjklxv_unregistered_probe_47281 (( )) ~~ nonexistent-formula-token-99887",
    )
    assert result["verdict"] == "not found - must register before use"


def test_normalise_formula_unifies_symbol_spellings():
    a = core.normalise_formula(r"\partial_t \Phi \cdot \nabla \Phi")
    b = core.normalise_formula("∂_t Φ · ∇ Φ")
    assert a == b


def test_natural_sort_key_orders_numerically_not_lexicographically():
    codes = ["EQ-015/P.100.v1", "EQ-015/P.2.v1", "EQ-015/P.10.v1"]
    ordered = sorted(codes, key=core.natural_sort_key)
    assert ordered == ["EQ-015/P.2.v1", "EQ-015/P.10.v1", "EQ-015/P.100.v1"]


def test_counts_reflect_real_files(reg):
    c = core.counts(reg)
    assert c["canonical_entries"] > 0
    assert c["genesis_root_rows"] > 0
    assert isinstance(c["by_status"], dict) and c["by_status"]


def test_status_for_known_code(reg):
    s = core.status(reg, "EQ-015")
    assert s is not None
    assert s["code"] == "EQ-015"
    assert "tier" in s and "coq_status" in s


def test_status_for_unknown_code_is_none(reg):
    assert core.status(reg, "NOT-A-REAL-CODE-XYZ") is None


def test_lineage_of_a_known_reading_reaches_its_root(reg):
    # ancestry follows parents[0] all the way up (same convention as
    # `scripts/toledo ancestry`), so it may pass through EQ-015's own parent
    # chain to an earlier Genesis root axiom, not stop at EQ-015 itself.
    lin = core.lineage(reg, "EQ-015/M.01.v1")
    assert lin is not None
    assert "EQ-015" in lin["ancestry"]
    assert lin["ancestry"][-1] == "EQ-015/M.01.v1"


def test_search_filters_by_root_and_domain(reg):
    hits = core.search(reg, "", root="EQ-015", domain="P", limit=5)
    assert hits
    for h in hits:
        assert h["root"] == "EQ-015"
        assert h["domain"] == "P"


def test_register_proposal_writes_a_proposal_file_not_the_registry(tmp_path):
    """Updated 2026-09-07 (residual review finding #5): this test predates
    the move of the proposal write path from `registry/proposals/` to
    `mcp/proposals/` (`mcp/DESIGN.md` sec. 6, graft C4 — see
    `toledo_mcp/proposals.py`'s module docstring for the full rationale:
    `registry/proposals/` sits inside the exact top-level directory this
    package must never edit). `core.register_proposal` itself was updated to
    the new location; this test still asserted the OLD one and so was
    failing against the current, correct behaviour. Not a duplicate of
    `mcp/tests/test_proposals.py::test_proposals_write_under_mcp_proposals_
    never_registry` — that test exercises `proposals.write_proposal` (the
    function `server.py`'s `toledo_register_proposal` tool actually calls),
    a deliberately separate S2-owned copy of this same write logic (see
    `proposals.py`'s docstring); this one is the only test anywhere that
    pins `core.register_proposal`'s own location, so it is kept, just
    corrected."""
    fields = {
        "name": "Test-only proposal equation",
        "statement": {"latest": "x = y", "format": "ascii-math"},
    }
    result = core.register_proposal(fields, repo_root=tmp_path)
    out = tmp_path / result["path"]
    assert out.exists()
    assert out.parent == tmp_path / "mcp" / "proposals"
    doc = json.loads(out.read_text(encoding="utf-8"))
    assert doc["proposal"]["name"] == "Test-only proposal equation"
    assert "not registered" in doc["note"].lower() or "PROPOSAL" in doc["note"]
    # never a write to the real repo's canonical files
    assert not (tmp_path / "registry" / "CANONICAL.json").exists()
