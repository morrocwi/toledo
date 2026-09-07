"""New in this pass (mcp/DESIGN.md sec. 1/9, stream S1) — pins the grafts
`core.py` itself is responsible for: A5 (one shared `toledo_build.py` merge,
never re-derived), B4 (genesis `parents[]` shape tolerance), A4/C5 (retry-
with-backoff on a transient JSON parse failure), and the `paths.proposals_dir`
addition from sec. 6."""
from __future__ import annotations

import json
import pathlib
import sys
import time

import pytest

from toledo_mcp import core, paths, regex_guard

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent.parent


def test_core_reuses_real_toledo_build_module():
    """Graft A5: pins "one shared merge implementation" as an import-identity
    fact, not a matching-output coincidence that could silently drift if
    `core.py` ever grew its own parallel merge. Checks, against the real
    files in this checkout (not a fixture):

    1. `core._toledo_build()` is memoized — two calls return the identical
       module object (`is`), so `scripts/toledo_build.py` is imported once
       per process, not re-executed (and potentially re-diverging from its
       own on-disk state) on every `load_registry` call.
    2. That module object is genuinely `scripts/toledo_build.py` on disk —
       loaded by file path, not a vendored copy under a different name — and
       is the same object already sitting in `sys.modules` under `core.py`'s
       own cache key.
    3. `core.py`'s own source never re-declares `build_entries`/
       `genesis_row_to_canonical` itself — the merge really does live in one
       place, mechanically checked by grep rather than asserted by comment.
    """
    tb1 = core._toledo_build()
    tb2 = core._toledo_build()
    assert tb1 is tb2
    assert tb1 is sys.modules[core._TB_MODULE_NAME]
    assert pathlib.Path(tb1.__file__).resolve() == (REPO_ROOT / "scripts" / "toledo_build.py").resolve()

    core_src = pathlib.Path(core.__file__).read_text(encoding="utf-8")
    assert "def build_entries(" not in core_src
    assert "def genesis_row_to_canonical(" not in core_src
    # and core.load_registry genuinely calls the imported module's function,
    # not a same-named local one shadowing it:
    assert core.load_registry.__globals__["_toledo_build"] is core._toledo_build


def test_genesis_parents_tolerates_string_and_object_shape():
    """Graft B4. `scripts/toledo_build.py`'s `genesis_row_to_canonical` (owned
    by the registry-building lane, never edited by this package) only
    tolerates a bare-string `parents[]` — confirmed true of every row in the
    real `registry/genesis_root.json` today (764/764 strings, mcp/DESIGN.md
    sec. 0), but nothing stops a future root-extension edit from writing the
    same per-parent `{"code":..., "derived_via":...}` object shape
    `CANONICAL.json` itself already uses. `core._normalise_genesis_parents`
    is this package's own defensive normalisation, applied before the
    document reaches `build_entries` — this test feeds it a synthetic row
    whose `parents[]` mixes both shapes and asserts the result is a clean,
    uniform list of bare code strings (which `genesis_row_to_canonical` can
    then handle exactly as it always has)."""
    genesis_doc = {
        "anchor": {"repo": "readout_genesis", "commit": "deadbeef", "files": []},
        "root_equations": [
            {
                "code": "EQ-900",
                "name": "mixed-shape parents",
                "statement": "a = b",
                "tier_in_genesis": "Definition",
                "synthesis_occurrences": [],
                "parents": [
                    "EQ-001",  # bare string (today's real shape)
                    {"code": "EQ-002", "derived_via": "reads"},  # CANONICAL-shaped object
                    {"code": "EQ-003"},  # object with no derived_via at all
                ],
                "derived_via": "reads",
                "step": 2,
                "step_label": "I.2",
            }
        ],
    }
    normalised = core._normalise_genesis_parents(genesis_doc)
    row = normalised["root_equations"][0]
    assert row["parents"] == ["EQ-001", "EQ-002", "EQ-003"]
    assert all(isinstance(p, str) for p in row["parents"])

    # End to end: the normalised doc must not break build_entries/
    # genesis_row_to_canonical (the function this package cannot edit) —
    # every parent lands as a proper {"code","derived_via"} pair, never a
    # dict nested inside "code".
    tb = core._toledo_build()
    entries, _ = tb.build_entries({"schema_version": "1.0.0", "canonical": []}, normalised)
    entry = next(e for e in entries if e["code"] == "EQ-900")
    assert entry["parents"] == [
        {"code": "EQ-001", "derived_via": "reads"},
        {"code": "EQ-002", "derived_via": "reads"},
        {"code": "EQ-003", "derived_via": "reads"},
    ]


def test_normalise_genesis_parents_is_noop_on_none_and_empty():
    assert core._normalise_genesis_parents(None) is None
    doc = {"anchor": {}, "root_equations": [{"code": "EQ-1", "parents": []}]}
    out = core._normalise_genesis_parents(doc)
    assert out["root_equations"][0]["parents"] == []


def test_normalise_genesis_parents_does_not_mutate_input():
    doc = {"anchor": {}, "root_equations": [{"code": "EQ-1", "parents": ["EQ-0"]}]}
    original_parents = doc["root_equations"][0]["parents"]
    core._normalise_genesis_parents(doc)
    assert doc["root_equations"][0]["parents"] is original_parents


def test_load_registry_retries_then_succeeds_on_transient_parse_error(fixture_root, monkeypatch):
    """Graft A4/C5: a transient `JSONDecodeError` on the first attempt(s)
    must not surface to the caller if a later retry, within `retries`,
    succeeds — pins the backoff loop's happy path."""
    real_load_canonical = core._toledo_build().load_canonical
    calls = {"n": 0}

    def flaky_load_canonical(path):
        calls["n"] += 1
        if calls["n"] < 3:
            raise json.JSONDecodeError("boom", doc="", pos=0)
        return real_load_canonical(path)

    monkeypatch.setattr(core._toledo_build(), "load_canonical", flaky_load_canonical)
    reg = core.load_registry(fixture_root, retries=5, backoff_base_seconds=0.001)
    assert calls["n"] == 3
    assert len(reg.entries) > 0


def test_load_registry_raises_after_retries_exhausted(fixture_root, monkeypatch):
    def always_fails(path):
        raise json.JSONDecodeError("boom", doc="", pos=0)

    monkeypatch.setattr(core._toledo_build(), "load_canonical", always_fails)
    with pytest.raises(json.JSONDecodeError):
        core.load_registry(fixture_root, retries=3, backoff_base_seconds=0.001)


def test_proposals_dir_points_at_mcp_proposals(fixture_root):
    """Sec. 6 (graft C4): `paths.proposals_dir()` names `mcp/proposals/`, the
    new, agreed write location — a pinned pointer both this package's own
    future move of `core.register_proposal` and the S2-owned `proposals.py`
    repoint to together (see `paths.proposals_dir`'s own docstring for why
    the two have not yet been flipped in the same change)."""
    d = paths.proposals_dir(fixture_root)
    assert d == fixture_root / "mcp" / "proposals"


def test_natural_sort_key_orders_digits_numerically():
    codes = ["H.117", "H.2", "H.10", "H.3"]
    assert sorted(codes, key=core.natural_sort_key) == ["H.2", "H.3", "H.10", "H.117"]


# ---------------------------------------------------------------------------
# SEC-1 (2026-09-07): core.search's regex=True branch is exposed to every
# caller of `scripts/toledo find --regex` and (via the same shared
# `regex_guard`) is the identical vulnerability class `queries.search`'s
# regex branch has (see tests/test_queries.py for that side).
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# PERF-3 (2026-09-07): a missing registry/CANONICAL.json used to silently
# resolve to an empty canonical set (scripts/toledo_build.py's own
# `load_canonical` treats that as its legitimate "first bootstrap" case),
# indistinguishable from "the registry legitimately has zero entries" --
# exactly the deployment mistake (a misconfigured TOLEDO_ROOT, an
# un-populated checkout) this founder-mandated lookup gate most needs to
# fail loud on, not quiet.
# ---------------------------------------------------------------------------

def test_load_registry_raises_file_not_found_when_canonical_json_missing(tmp_path):
    root = tmp_path / "empty_repo"
    (root / "registry").mkdir(parents=True)
    with pytest.raises(FileNotFoundError, match="CANONICAL.json"):
        core.load_registry(root)


def test_search_regex_rejects_overlong_query(fixture_root):
    reg = core.load_registry(fixture_root)
    with pytest.raises(ValueError):
        core.search(reg, "a" * (regex_guard.MAX_REGEX_QUERY_LEN + 1), regex=True)


def test_search_regex_catastrophic_pattern_times_out_instead_of_hanging(fixture_root):
    """Before this fix, `re.compile(query).search(haystack)` ran unbounded
    for every entry on every `regex=True` call. A classic catastrophic-
    backtracking pattern against a sufficiently long, entirely benign
    statement backtracks exponentially and would hang the calling process
    indefinitely. Add one such entry and confirm the guarded search raises
    a timeout well within a bounded wall-clock budget instead."""
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
    start = time.monotonic()
    with pytest.raises(regex_guard.RegexTimeout):
        core.search(reg, r"(a+)+$", regex=True)
    elapsed = time.monotonic() - start
    assert elapsed < 10.0
