from __future__ import annotations

import datetime as _real_datetime

from toledo_mcp import core, paths, proposals


class _FrozenDatetimeModule:
    """A drop-in replacement for the stdlib `datetime` module exposing just
    enough (`datetime.now`, `timezone`) for `write_proposal`/
    `register_proposal` to compute their submission timestamp -- frozen at
    one instant so two calls land on the exact same one-second-resolution
    `ts` string, reproducing the real race this fix guards against (two
    independent agents proposing the same code within the same wall-clock
    second) deterministically instead of relying on real-clock timing."""

    timezone = _real_datetime.timezone

    class datetime:
        @staticmethod
        def now(tz=None):
            return _real_datetime.datetime(2026, 9, 7, 12, 0, 0, tzinfo=_real_datetime.timezone.utc)


def test_register_proposal_writes_file_never_touches_registry(fixture_root):
    canonical_before = (fixture_root / "registry" / "CANONICAL.json").read_text(encoding="utf-8")
    lineage_before = (fixture_root / "registry" / "LINEAGE.jsonl").read_text(encoding="utf-8")

    result = core.register_proposal({"name": "test eq", "statement": "p = q"}, repo_root=fixture_root)
    assert (fixture_root / result["path"]).exists()

    assert (fixture_root / "registry" / "CANONICAL.json").read_text(encoding="utf-8") == canonical_before
    assert (fixture_root / "registry" / "LINEAGE.jsonl").read_text(encoding="utf-8") == lineage_before


def test_proposal_lifecycle_ledger(fixture_root):
    result = core.register_proposal({"name": "lifecycle test", "statement": "p = q", "code": "EQ-001/M.99.v1"}, repo_root=fixture_root)
    proposals.record_submitted(result["path"], result["slug"], result["submitted_at"], root=fixture_root)

    listing = proposals.list_proposals(root=fixture_root)
    assert any(p["path"] == result["path"] and p["status"] == "PENDING" for p in listing)

    proposals.append_status(result["path"], "ACCEPTED", by="test-registrar", note="merged", root=fixture_root)
    listing2 = proposals.list_proposals(root=fixture_root)
    row = next(p for p in listing2 if p["path"] == result["path"])
    assert row["status"] == "ACCEPTED"

    got = proposals.get_proposal(result["path"], root=fixture_root)
    assert got["proposal"]["code"] == "EQ-001/M.99.v1"
    assert got["status"]["status"] == "ACCEPTED"


def test_list_proposals_filters_by_status(fixture_root):
    r1 = core.register_proposal({"name": "a"}, repo_root=fixture_root)
    r2 = core.register_proposal({"name": "b"}, repo_root=fixture_root)
    proposals.record_submitted(r1["path"], r1["slug"], r1["submitted_at"], root=fixture_root)
    proposals.record_submitted(r2["path"], r2["slug"], r2["submitted_at"], root=fixture_root)
    proposals.append_status(r2["path"], "REJECTED", by="test-registrar", root=fixture_root)

    pending = proposals.list_proposals(status="PENDING", root=fixture_root)
    rejected = proposals.list_proposals(status="REJECTED", root=fixture_root)
    assert {p["path"] for p in pending} == {r1["path"]}
    assert {p["path"] for p in rejected} == {r2["path"]}


def test_get_proposal_refuses_path_traversal(fixture_root):
    core.register_proposal({"name": "a"}, repo_root=fixture_root)
    assert proposals.get_proposal("registry/CANONICAL.json", root=fixture_root) is None
    assert proposals.get_proposal("../outside.json", root=fixture_root) is None


# ---------------------------------------------------------------------------
# graft C4 (mcp/DESIGN.md sec. 6): proposals moved to mcp/proposals/, and
# server.py's own write path (proposals.write_proposal, not core.register_
# proposal) is what toledo_register_proposal actually calls.
# ---------------------------------------------------------------------------

def test_proposals_dir_matches_paths_module_when_available(fixture_root):
    """Pinning test for the TODO in `proposals.proposals_dir`'s docstring:
    once `paths.py` grows its own `proposals_dir()` (mcp/DESIGN.md sec. 1/6),
    this module must delegate to it, never compute a second, independently
    drifting copy of the same path."""
    expected = fixture_root / "mcp" / "proposals"
    assert proposals.proposals_dir(fixture_root) == expected
    if hasattr(paths, "proposals_dir"):
        assert proposals.proposals_dir(fixture_root) == paths.proposals_dir(fixture_root)


def test_proposals_write_under_mcp_proposals_never_registry(fixture_root):
    """graft C4's own named test (mcp/DESIGN.md sec. 9): `write_proposal` —
    the function `server.py`'s `toledo_register_proposal` tool actually
    calls — writes under `mcp/proposals/`, never `registry/proposals/`, and
    never touches any of the five protected registry paths."""
    canonical_before = (fixture_root / "registry" / "CANONICAL.json").read_text(encoding="utf-8")
    lineage_before = (fixture_root / "registry" / "LINEAGE.jsonl").read_text(encoding="utf-8")
    genesis_before = (fixture_root / "registry" / "genesis_root.json").read_text(encoding="utf-8")

    result = proposals.write_proposal({"name": "toon test eq", "statement": "u = v"}, root=fixture_root)

    written = fixture_root / result["path"]
    assert written.exists()
    assert result["path"].startswith("mcp/proposals/"), result["path"]
    assert not result["path"].startswith("registry/proposals/")
    assert written.resolve().is_relative_to((fixture_root / "mcp" / "proposals").resolve())

    # the write-boundary hash-diff check, extended to all three protected files
    assert (fixture_root / "registry" / "CANONICAL.json").read_text(encoding="utf-8") == canonical_before
    assert (fixture_root / "registry" / "LINEAGE.jsonl").read_text(encoding="utf-8") == lineage_before
    assert (fixture_root / "registry" / "genesis_root.json").read_text(encoding="utf-8") == genesis_before


def test_write_proposal_lifecycle_and_status_ledger_round_trip(fixture_root):
    """The ledger/list/get functions this module already exercised against
    `core.register_proposal` above must work identically against
    `write_proposal`'s new location -- the same lifecycle, a different
    write path."""
    result = proposals.write_proposal(
        {"name": "lifecycle via write_proposal", "statement": "p = q", "code": "EQ-001/M.77.v1"},
        root=fixture_root,
    )
    proposals.record_submitted(result["path"], result["slug"], result["submitted_at"], root=fixture_root)

    listing = proposals.list_proposals(root=fixture_root)
    assert any(p["path"] == result["path"] and p["status"] == "PENDING" for p in listing)

    proposals.append_status(result["path"], "ACCEPTED", by="test-registrar", note="merged", root=fixture_root)
    got = proposals.get_proposal(result["path"], root=fixture_root)
    assert got["proposal"]["code"] == "EQ-001/M.77.v1"
    assert got["status"]["status"] == "ACCEPTED"


# ---------------------------------------------------------------------------
# SEC-2 / R3-2 (2026-09-07): two independent proposals for the SAME code
# submitted within the same wall-clock second used to silently collide on
# the exact same `{ts}_{slug}.json` filename -- a plain `open(path, "w")`
# with no existence check, so whichever call wrote second silently
# destroyed the first with no exception, no warning, and no trace in
# STATUS.jsonl. This is the expected-case race the founder rule creates by
# design: many independent agents are each individually required to notice
# an unregistered code and call register/write_proposal for it.
# ---------------------------------------------------------------------------

def test_write_proposal_same_second_same_code_collision_creates_distinct_files(fixture_root, monkeypatch):
    monkeypatch.setattr(proposals, "datetime", _FrozenDatetimeModule)

    r1 = proposals.write_proposal(
        {"code": "EQ-999/H.01.v1", "name": "first version", "statement": "p = q"}, root=fixture_root,
    )
    r2 = proposals.write_proposal(
        {"code": "EQ-999/H.01.v1", "name": "second version - DIFFERENT", "statement": "p != q"}, root=fixture_root,
    )

    assert r1["path"] != r2["path"], "two same-second, same-code proposals collided on one filename"
    assert (fixture_root / r1["path"]).exists()
    assert (fixture_root / r2["path"]).exists()

    got1 = proposals.get_proposal(r1["path"], root=fixture_root)
    got2 = proposals.get_proposal(r2["path"], root=fixture_root)
    assert got1["proposal"]["name"] == "first version"
    assert got2["proposal"]["name"] == "second version - DIFFERENT"


def test_register_proposal_same_second_same_code_collision_creates_distinct_files(fixture_root, monkeypatch):
    """Same bug, same fix, `core.register_proposal`'s own copy of the write
    path (SEC-2 named both `queries.search`-adjacent files: `proposals.py`
    AND `core.py` carried the identical unguarded `open(path, "w")`)."""
    monkeypatch.setattr(core, "datetime", _FrozenDatetimeModule)

    r1 = core.register_proposal(
        {"code": "EQ-998/H.01.v1", "name": "first version", "statement": "p = q"}, repo_root=fixture_root,
    )
    r2 = core.register_proposal(
        {"code": "EQ-998/H.01.v1", "name": "second version - DIFFERENT", "statement": "p != q"}, repo_root=fixture_root,
    )

    assert r1["path"] != r2["path"], "two same-second, same-code proposals collided on one filename"
    assert (fixture_root / r1["path"]).exists()
    assert (fixture_root / r2["path"]).exists()

    got1 = proposals.get_proposal(r1["path"], root=fixture_root)
    got2 = proposals.get_proposal(r2["path"], root=fixture_root)
    assert got1["proposal"]["name"] == "first version"
    assert got2["proposal"]["name"] == "second version - DIFFERENT"
