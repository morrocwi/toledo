"""Tests for `toledo_mcp.export_static` (S3, mcp/DESIGN.md sec. 13, grafts
A3/B3/C6): the static GitHub-Pages JSON mirror generated from the exact
same `cache.py`/`queries.py` layer the live server reads — never a second,
independently-derived transform of `registry/CANONICAL.json`."""
from __future__ import annotations

import json

import pytest

from toledo_mcp import cache as cache_mod
from toledo_mcp import export_static


@pytest.fixture(autouse=True)
def _isolated_cache(fixture_root):
    cache_mod.reset_cache_for_tests()
    yield
    cache_mod.reset_cache_for_tests()


def _load(path):
    return json.loads(path.read_text(encoding="utf-8"))


def test_export_static_writes_expected_layout(fixture_root, tmp_path):
    out = tmp_path / "static-out"
    summary = export_static.export_static(out, root=fixture_root)
    v1 = out / "v1"

    assert (v1 / "manifest.json").exists()
    assert (v1 / "search-index.json").exists()
    assert (v1 / "counts.json").exists()
    assert (v1 / "verdict-rules.json").exists()
    assert (v1 / "by-root" / "EQ_001.json").exists()  # mangled: hyphen -> underscore
    assert (v1 / "by-domain" / "H.json").exists()
    assert (v1 / "entries" / "EQ_001__M_01_v1.json").exists()
    assert summary["out_dir"] == str(v1)
    assert len(summary["files_written"]) == len(list(v1.rglob("*.json")))


def test_export_static_mangles_code_per_schema_rule():
    assert export_static.mangle_code("MQ.08/H.02.v1") == "MQ_08__H_02_v1"
    assert export_static.mangle_code("EQ-015/M.01.v1") == "EQ_015__M_01_v1"


def test_export_static_entry_matches_live_query(fixture_root, tmp_path):
    """graft B3/C6's explicit requirement: byte-for-byte the same payload
    (modulo the generation-metadata header) as calling the same query
    through cache.py directly — never a second, independently-derived
    transform."""
    out = tmp_path / "static-out"
    export_static.export_static(out, root=fixture_root)

    c = cache_mod.RegistryCache(root=fixture_root)
    live_entry = c.get("EQ-001/M.05.v1")

    exported = _load(out / "v1" / "entries" / "EQ_001__M_05_v1.json")
    assert exported["entry"] == live_entry
    assert exported["verdict"]["verdict"] == "REGISTERED_CURRENT"
    # generation metadata present and disclosed, but not implying liveness
    assert "generated_at" in exported
    assert "generated_from_commit" in exported
    assert exported["disclosure"] == export_static.DISCLOSURE
    c.close()


def test_export_static_by_root_matches_live_query(fixture_root, tmp_path):
    out = tmp_path / "static-out"
    export_static.export_static(out, root=fixture_root)

    c = cache_mod.RegistryCache(root=fixture_root)
    live_rows = c.by_root("EQ-001", limit=None)
    exported_rows = _load(out / "v1" / "by-root" / "EQ_001.json")  # mangled filename
    assert exported_rows == live_rows
    c.close()


def test_export_static_by_domain_matches_live_query(fixture_root, tmp_path):
    out = tmp_path / "static-out"
    export_static.export_static(out, root=fixture_root)

    c = cache_mod.RegistryCache(root=fixture_root)
    live_rows = c.by_domain("H", limit=None)
    exported_rows = _load(out / "v1" / "by-domain" / "H.json")
    assert exported_rows == live_rows
    c.close()


def test_export_static_search_index_matches_live_unfiltered_search(fixture_root, tmp_path):
    out = tmp_path / "static-out"
    export_static.export_static(out, root=fixture_root)

    c = cache_mod.RegistryCache(root=fixture_root)
    c.ensure_fresh()
    # `limit=0` no longer means "unlimited" (see `core.resolve_limit`) — a
    # zero/missing limit now resolves to the call's own default, same as
    # every other tool. Match `export_static`'s own explicit
    # limit=len(entries) call so this stays a genuine live-vs-exported
    # comparison rather than a stale assumption about limit=0.
    total_entries = len(c.registry.entries)
    live_rows = c.search("", limit=total_entries)
    exported_rows = _load(out / "v1" / "search-index.json")
    assert exported_rows == live_rows
    assert {r["code"] for r in exported_rows} >= {"EQ-001/M.01.v1", "EQ-001/H.01.v1"}
    c.close()


def test_export_static_counts_matches_live_counts(fixture_root, tmp_path):
    out = tmp_path / "static-out"
    export_static.export_static(out, root=fixture_root)

    c = cache_mod.RegistryCache(root=fixture_root)
    live_counts = c.counts()
    exported_counts = _load(out / "v1" / "counts.json")
    # JSON object keys are always strings, so a Counter keyed by `None` (a
    # `domain`-less root row, e.g. Layer-0 EQ-001 itself) round-trips its
    # key as the literal string "null" — normalise the live side through
    # the same JSON round-trip before comparing, rather than asserting a
    # Python-vs-JSON key-typing difference that isn't a real export bug.
    assert exported_counts == json.loads(json.dumps(live_counts))
    c.close()


def test_export_static_discloses_generation_metadata(fixture_root, tmp_path):
    out = tmp_path / "static-out"
    export_static.export_static(out, root=fixture_root)

    manifest = _load(out / "v1" / "manifest.json")
    for key in ("generated_at", "generated_from_commit", "registry_release_version", "package_version", "entry_count", "disclosure"):
        assert key in manifest
    assert "eventually consistent" in manifest["disclosure"]
    assert "never treat this as authoritative" in manifest["disclosure"]
    assert manifest["entry_count"] > 0


def test_export_static_verdict_rules_available_now_that_verdict_py_exposes_rules(fixture_root, tmp_path):
    """Mirrors test_cli.py's matching pair: verdict.py (S2) has since landed
    RULES/_KNOWN_STATUSES/VERDICT_VALUES (mcp/DESIGN.md sec. 8) — this
    asserts the now-real, activated static export; the monkeypatched test
    right below covers the honest-degradation branch deterministically,
    independent of verdict.py's live state."""
    from toledo_mcp import verdict as verdict_mod

    if not all(hasattr(verdict_mod, n) for n in ("RULES", "_KNOWN_STATUSES", "VERDICT_VALUES")):
        pytest.skip("verdict.py (S2) does not yet expose RULES/_KNOWN_STATUSES/VERDICT_VALUES on this build")
    out = tmp_path / "static-out"
    export_static.export_static(out, root=fixture_root)
    doc = _load(out / "v1" / "verdict-rules.json")
    assert doc["available"] is True
    assert "rules" in doc and "statuses" in doc and "verdict_values" in doc


def test_export_static_verdict_rules_degrades_honestly_when_verdict_py_lacks_rules(fixture_root, tmp_path, monkeypatch):
    """Forces the pre-landing code path via monkeypatch so this stays
    covered regardless of verdict.py's current, live state (it is a file
    actively owned and edited by another stream) — export_static must
    never fabricate a rule table it cannot actually read from verdict.py."""
    from toledo_mcp import verdict as verdict_mod

    monkeypatch.delattr(verdict_mod, "RULES", raising=False)
    monkeypatch.delattr(verdict_mod, "_KNOWN_STATUSES", raising=False)
    monkeypatch.delattr(verdict_mod, "VERDICT_VALUES", raising=False)
    out = tmp_path / "static-out"
    export_static.export_static(out, root=fixture_root)
    doc = _load(out / "v1" / "verdict-rules.json")
    assert doc["available"] is False


def test_export_static_git_commit_never_raises_outside_a_repo(tmp_path):
    # A directory that is not a git checkout at all must degrade to None,
    # never raise — the export must survive this, not crash the whole run
    # over one metadata field.
    not_a_repo = tmp_path / "not_a_repo"
    not_a_repo.mkdir()
    assert export_static._git_commit(not_a_repo) is None


def test_export_static_cli_entrypoint_smoke(fixture_root, tmp_path, capsys, monkeypatch):
    out = tmp_path / "static-out-cli"
    monkeypatch.setenv("TOLEDO_ROOT", str(fixture_root))
    rc = export_static.main(["--out", str(out), "--root", str(fixture_root)])
    assert rc == 0
    summary = json.loads(capsys.readouterr().out)
    assert summary["file_count"] > 0
    assert (out / "v1" / "manifest.json").exists()
