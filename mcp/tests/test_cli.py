"""Tests for `toledo_mcp.cli` (S3, mcp/DESIGN.md secs. 8/9/14): the TOON
encoder/decoder, every subcommand's own behaviour against the shared
`fixture_root` (see `conftest.py`, S4-owned, used-not-edited here), and the
CLI-parity check against `scripts/toledo` (mcp/DESIGN.md sec. 9's S3 test
plan: `test_cli_parity_matches_scripts_toledo`)."""
from __future__ import annotations

import hashlib
import json
import subprocess
import sys

import pytest

from toledo_mcp import cache as cache_mod
from toledo_mcp import cli, core


@pytest.fixture(autouse=True)
def _isolated_cache(fixture_root):
    cache_mod.reset_cache_for_tests()
    yield
    cache_mod.reset_cache_for_tests()


def _run(capsys, argv):
    cli.main(argv)
    return capsys.readouterr().out


def _codes(json_text: str):
    return {row["code"] for row in json.loads(json_text)}


# ---------------------------------------------------------------------------
# TOON encode/decode
# ---------------------------------------------------------------------------

def test_encode_decode_toon_round_trip():
    rows = [
        {"code": "EQ-001", "name": "primordial difference", "tier": "Ax"},
        {"code": "EQ-001/M.01.v1", "name": "simple, with a comma", "tier": "Definition"},
    ]
    encoded = cli.encode_toon(rows)
    assert encoded.startswith("[2]{code,name,tier}:")
    assert cli.decode_toon(encoded) == rows


def test_encode_toon_empty_list():
    assert cli.encode_toon([]) == "[0]{}:"
    assert cli.decode_toon("[0]{}:") == []


def test_encode_toon_quotes_embedded_quote_and_delimiter():
    rows = [{"code": "X", "statement": 'a "weird" value, with comma'}]
    encoded = cli.encode_toon(rows)
    assert cli.decode_toon(encoded) == rows


def test_decode_toon_rejects_non_tabular_header():
    with pytest.raises(ValueError):
        cli.decode_toon("not a toon header\n  a,b")


# ---------------------------------------------------------------------------
# find / show
# ---------------------------------------------------------------------------

def test_cli_find_returns_rows_with_verdict(capsys, fixture_root):
    rows = json.loads(_run(capsys, ["find", "primordial"]))
    hit = next(r for r in rows if r["code"] == "EQ-001/H.01.v1")
    assert hit["verdict"] == "REGISTERED_CURRENT"
    assert hit["usable"] is True


def test_cli_find_toon_format_round_trips(capsys, fixture_root):
    out = _run(capsys, ["find", "primordial", "--format", "toon"])
    rows = cli.decode_toon(out)
    assert any(r["code"] == "EQ-001/H.01.v1" for r in rows)


def test_cli_show_returns_entry_and_verdict(capsys, fixture_root):
    result = json.loads(_run(capsys, ["show", "EQ-001/M.05.v1"]))
    assert result["entry"]["code"] == "EQ-001/M.05.v1"
    assert result["verdict"]["verdict"] == "REGISTERED_CURRENT"


def test_cli_show_not_found_exits_nonzero(fixture_root):
    with pytest.raises(SystemExit) as exc:
        cli.main(["show", "NOPE"])
    assert exc.value.code == 1


def test_cli_show_blocks_superseded(capsys, fixture_root):
    result = json.loads(_run(capsys, ["show", "EQ-001/M.04.v1"]))
    assert result["verdict"]["verdict"] == "REGISTERED_SUPERSEDED"
    assert result["verdict"]["redirect"] == ["EQ-001/M.05.v1"]


# ---------------------------------------------------------------------------
# ancestry / descendants / neighbours
# ---------------------------------------------------------------------------

def test_cli_ancestry_prints_chain(capsys, fixture_root):
    out = _run(capsys, ["ancestry", "EQ-001/M.05.v1"])
    assert out.strip() == "EQ-001 -> EQ-001/M.05.v1"


def test_cli_ancestry_not_found(fixture_root):
    with pytest.raises(SystemExit):
        cli.main(["ancestry", "NOPE"])


def test_cli_descendants(capsys, fixture_root):
    codes = _codes(_run(capsys, ["descendants", "EQ-001/M.08.v1"]))
    assert codes == {"EQ-001/M.09.v1", "EQ-001/M.10.v1"}


def test_cli_neighbours_includes_reverse_relation(capsys, fixture_root):
    rows = json.loads(_run(capsys, ["neighbours", "EQ-001/M.01.v1"]))
    relations = {(r["code"], r["relation"]) for r in rows}
    assert ("EQ-001", "parent") in relations
    assert ("EQ-001/H.01.v1", "reverse_relation") in relations
    # neighbours rows are relation edges, not citable entries — no verdict.
    assert all("verdict" not in r for r in rows)


# ---------------------------------------------------------------------------
# by-root / by-domain / by-record
# ---------------------------------------------------------------------------

def test_cli_by_root(capsys, fixture_root):
    codes = _codes(_run(capsys, ["by-root", "EQ-001"]))
    assert "EQ-001/M.01.v1" in codes


def test_cli_by_domain(capsys, fixture_root):
    codes = _codes(_run(capsys, ["by-domain", "H"]))
    assert codes == {"EQ-001/H.01.v1"}


def test_cli_by_record(capsys, fixture_root):
    codes = _codes(_run(capsys, ["by-record", "1"]))
    assert "EQ-001/M.01.v1" in codes


# ---------------------------------------------------------------------------
# export
# ---------------------------------------------------------------------------

def test_cli_export_json_matches_registry(capsys, fixture_root):
    doc = json.loads(_run(capsys, ["export", "--format", "json"]))
    codes = {e["code"] for e in doc["canonical"]}
    assert "EQ-001/M.01.v1" in codes


def test_cli_export_md_smoke(capsys, fixture_root):
    out = _run(capsys, ["export", "--format", "md"])
    assert "## EQ-001/M.01.v1" in out


# ---------------------------------------------------------------------------
# check / status
# ---------------------------------------------------------------------------

def test_cli_check_by_code(capsys, fixture_root):
    result = json.loads(_run(capsys, ["check", "--code", "EQ-001/M.05.v1"]))
    assert result["verdict"] == "REGISTERED_CURRENT"


def test_cli_check_requires_exactly_one_of_formula_or_code(capsys, fixture_root):
    assert json.loads(_run(capsys, ["check"]))["verdict"] == "AMBIGUOUS"
    result = json.loads(_run(capsys, ["check", "--code", "EQ-001", "--formula", "a != b"]))
    assert result["verdict"] == "AMBIGUOUS"


def test_cli_check_by_formula_phi(capsys, fixture_root):
    result = json.loads(_run(capsys, ["check", "--formula", "x != y readout"]))
    assert result["verdict"] in ("REGISTERED_CURRENT", "CANDIDATE_MATCH")
    assert any(c["code"] == "EQ-001/M.03.v1" for c in result["candidates"])


def test_cli_check_by_formula_difflib(capsys, fixture_root):
    result = json.loads(_run(capsys, ["check", "--formula", "a != b readout", "--method", "difflib"]))
    assert result["verdict"] == "REGISTERED_CURRENT"


def test_cli_check_by_formula_difflib_exact_match_to_not_an_equation_is_never_registered_current(capsys, fixture_root):
    """R3-1 (2026-09-07), CLI side: `cmd_check`'s docstring says it mirrors
    `server.py`'s `toledo_check` body by hand -- this pins the same fix
    against the same bug in this file's own duplicated difflib branch (a
    bare similarity-threshold "registered" verdict used to map straight to
    REGISTERED_CURRENT/usable=True with no check of the matched entry's own
    `status`)."""
    result = json.loads(_run(capsys, ["check", "--formula", "just prose, no operator", "--method", "difflib"]))
    assert result["verdict"] == "REGISTERED_NOT_AN_EQUATION"
    assert result["usable"] is False
    assert result["verdict"] != "REGISTERED_CURRENT"


def test_cli_find_regex_rejects_overlong_query(capsys, fixture_root):
    """SEC-1 (2026-09-07), CLI side: `toledo find --regex` goes through the
    same `regex_guard`-protected `cache.search`/`queries.search` path as the
    MCP tool; an over-long pattern must fail with a clear CLI error, not
    hang or crash with a raw traceback."""
    with pytest.raises(SystemExit):
        _run(capsys, ["find", "a" * 500, "--regex"])


def test_cli_status_matches_show_verdict(capsys, fixture_root):
    result = json.loads(_run(capsys, ["status", "EQ-001/M.08.v1"]))
    assert result["verdict"] == "REGISTERED_SPLIT"
    assert set(result["redirect"]) == {"EQ-001/M.09.v1", "EQ-001/M.10.v1"}


def test_cli_status_not_registered_prints_null(capsys, fixture_root):
    assert _run(capsys, ["status", "NOPE"]).strip() == "null"


# ---------------------------------------------------------------------------
# index-status / show-verdict-rules
# ---------------------------------------------------------------------------

def test_cli_index_status(capsys, fixture_root):
    result = json.loads(_run(capsys, ["index-status"]))
    assert result["entry_count"] > 0


def test_cli_show_verdict_rules_reports_available_now_that_verdict_py_exposes_rules(capsys, fixture_root):
    """`cli.py`'s original design (see its module docstring) treated
    verdict.py's RULES/_KNOWN_STATUSES/VERDICT_VALUES as a TODO cross-stream
    dependency (S2, mcp/DESIGN.md sec. 8, graft A6) not yet landed at the
    time this test was written. It has since landed — this asserts the now-
    real, activated behaviour; the monkeypatched test right below covers the
    honest-degradation branch deterministically, independent of verdict.py's
    live state, so this package's own fallback logic stays covered either
    way."""
    from toledo_mcp import verdict as verdict_mod

    if not all(hasattr(verdict_mod, n) for n in ("RULES", "_KNOWN_STATUSES", "VERDICT_VALUES")):
        pytest.skip("verdict.py (S2) does not yet expose RULES/_KNOWN_STATUSES/VERDICT_VALUES on this build")
    result = json.loads(_run(capsys, ["show-verdict-rules"]))
    assert result["available"] is True
    assert "rules" in result and "statuses" in result and "verdict_values" in result
    assert "CAUTION" in result["verdict_values"]


def test_cli_show_verdict_rules_degrades_honestly_when_verdict_py_lacks_rules(capsys, fixture_root, monkeypatch):
    """Forces the pre-landing code path via monkeypatch so this behaviour
    stays covered regardless of verdict.py's current, live state (it is a
    file actively owned and edited by another stream) — this package must
    never fabricate a rule table it cannot actually read from verdict.py."""
    from toledo_mcp import verdict as verdict_mod

    monkeypatch.delattr(verdict_mod, "RULES", raising=False)
    monkeypatch.delattr(verdict_mod, "_KNOWN_STATUSES", raising=False)
    monkeypatch.delattr(verdict_mod, "VERDICT_VALUES", raising=False)
    result = json.loads(_run(capsys, ["show-verdict-rules"]))
    assert result["available"] is False
    assert "reason" in result


# ---------------------------------------------------------------------------
# proposals / register-proposal
# ---------------------------------------------------------------------------

def test_cli_register_proposal_then_list_then_show(capsys, fixture_root, tmp_path):
    payload = {
        "name": "a new test equation",
        "statement": {"latest": "p = q", "format": "ascii-math"},
        "parents": [{"code": "EQ-001", "derived_via": "reads"}],
        "origin": {"source": "textbook", "repo_anchor": None, "record_id": 99, "doi": None, "section": None},
        "tier": "Definition", "occurrences": [],
    }
    src = tmp_path / "proposal.json"
    src.write_text(json.dumps(payload), encoding="utf-8")

    result = json.loads(_run(capsys, ["register-proposal", "--from-json", str(src)]))
    assert "mcp/proposals/" in result["path"]

    rows = json.loads(_run(capsys, ["proposals", "list"]))
    row = next(r for r in rows if r["path"] == result["path"])
    assert row["status"] == "PENDING"

    doc = json.loads(_run(capsys, ["proposals", "show", result["path"]]))
    assert doc["proposal"]["name"] == "a new test equation"
    assert doc["status"]["status"] == "PENDING"


def test_cli_proposals_show_missing_path_exits_nonzero(fixture_root):
    with pytest.raises(SystemExit):
        cli.main(["proposals", "show", "registry/proposals/does-not-exist.json"])


def test_cli_register_proposal_never_writes_protected_files(capsys, fixture_root, tmp_path):
    """Cross-check with the existing S2 hash-diff invariant
    (test_register_proposal_writes_file_never_touches_registry): this CLI
    path must not touch CANONICAL.json/genesis_root.json/LINEAGE.jsonl."""
    protected = [
        fixture_root / "registry" / "CANONICAL.json",
        fixture_root / "registry" / "genesis_root.json",
        fixture_root / "registry" / "LINEAGE.jsonl",
    ]
    before = {p: hashlib.sha256(p.read_bytes()).hexdigest() for p in protected}

    payload = {"name": "another test equation", "statement": {"latest": "r = s", "format": "ascii-math"}}
    src = tmp_path / "proposal2.json"
    src.write_text(json.dumps(payload), encoding="utf-8")
    cli.main(["register-proposal", "--from-json", str(src)])
    capsys.readouterr()

    after = {p: hashlib.sha256(p.read_bytes()).hexdigest() for p in protected}
    assert before == after


# ---------------------------------------------------------------------------
# CLI/scripts-toledo parity (mcp/DESIGN.md sec. 9, S3 test plan)
# ---------------------------------------------------------------------------

def _extract_codes_tsv(text: str):
    return {line.split("\t", 1)[0] for line in text.splitlines() if line.strip()}


def test_cli_parity_matches_scripts_toledo(capsys, fixture_root):
    """Builds a real registry/TOLEDO.json inside the fixture root (the same
    scripts/toledo_build.run_build core.py already reuses for its own
    merge), then runs both scripts/toledo and this module's own CLI against
    the SAME fixture registry and asserts the same code set comes back for
    each parity verb — 'CLI parity as a checked fact, not a claim.'"""
    tb = core._toledo_build()
    tb.run_build(
        fixture_root / "registry" / "CANONICAL.json",
        fixture_root / "registry" / "genesis_root.json",
        fixture_root,
    )
    scripts_path = core.SCRIPTS_DIR / "toledo"

    def run_old(args):
        proc = subprocess.run(
            [sys.executable, str(scripts_path), "--out-root", str(fixture_root), *args],
            capture_output=True, text=True, check=True,
        )
        return proc.stdout

    def run_new(argv):
        cache_mod.reset_cache_for_tests()
        capsys.readouterr()
        cli.main(argv)
        return capsys.readouterr().out

    # find — a query substring-matching exactly one entry on both sides.
    old = _extract_codes_tsv(run_old(["find", "EQ-001/M.09.v1"]))
    new = _codes(run_new(["find", "EQ-001/M.09.v1"]))
    assert old == new == {"EQ-001/M.09.v1"}

    old = _extract_codes_tsv(run_old(["by-root", "EQ-001"]))
    new = _codes(run_new(["by-root", "EQ-001"]))
    assert old == new

    old = _extract_codes_tsv(run_old(["by-domain", "M"]))
    new = _codes(run_new(["by-domain", "M"]))
    assert old == new

    old = _extract_codes_tsv(run_old(["by-record", "1"]))
    new = _codes(run_new(["by-record", "1"]))
    assert old == new

    old = _extract_codes_tsv(run_old(["descendants", "EQ-001/M.08.v1"]))
    new = _codes(run_new(["descendants", "EQ-001/M.08.v1"]))
    assert old == new == {"EQ-001/M.09.v1", "EQ-001/M.10.v1"}

    old_chain = run_old(["ancestry", "EQ-001/M.05.v1"]).strip()
    new_chain = run_new(["ancestry", "EQ-001/M.05.v1"]).strip()
    assert old_chain == new_chain == "EQ-001 -> EQ-001/M.05.v1"

    # neighbours — the new CLI additionally reports reverse_relation edges
    # (documented in server.py/cli.py); compare after filtering those out.
    old_lines = [ln for ln in run_old(["neighbours", "EQ-001/H.01.v1"]).splitlines() if ln.strip()]
    old_pairs = {(rel, code) for rel, code, _note in (line.split("\t") for line in old_lines)}
    new_rows = json.loads(run_new(["neighbours", "EQ-001/H.01.v1"]))
    new_pairs = {(r["relation"], r["code"]) for r in new_rows if r["relation"] != "reverse_relation"}
    assert old_pairs == new_pairs

    # show — code identity only (the new CLI wraps in {"entry","verdict"}).
    old_doc = json.loads(run_old(["show", "EQ-001/M.05.v1"]))
    new_doc = json.loads(run_new(["show", "EQ-001/M.05.v1"]))
    assert old_doc["code"] == new_doc["entry"]["code"] == "EQ-001/M.05.v1"
