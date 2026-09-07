from __future__ import annotations

from toledo_mcp import core, verdict


def _resolver(reg):
    return lambda code: reg.by_code.get(code)


def test_current_status_gives_registered_current(fixture_root):
    reg = core.load_registry(fixture_root)
    v = verdict.verdict_for_entry(reg.by_code["EQ-001/M.05.v1"], _resolver(reg))
    assert v.verdict == "REGISTERED_CURRENT"
    assert v.usable is True


def test_superseded_redirects_to_current_target(fixture_root):
    reg = core.load_registry(fixture_root)
    v = verdict.verdict_for_entry(reg.by_code["EQ-001/M.04.v1"], _resolver(reg))
    assert v.verdict == "REGISTERED_SUPERSEDED"
    assert v.usable is False
    assert v.redirect == ["EQ-001/M.05.v1"]


def test_superseded_two_cycle_is_ambiguous_not_infinite_loop(fixture_root):
    reg = core.load_registry(fixture_root)
    v = verdict.verdict_for_entry(reg.by_code["EQ-001/M.06.v1"], _resolver(reg))
    assert v.verdict == "AMBIGUOUS"
    assert v.usable is False
    assert "cycle" in v.reason.lower()


def test_split_gives_children_as_redirect(fixture_root):
    reg = core.load_registry(fixture_root)
    v = verdict.verdict_for_entry(reg.by_code["EQ-001/M.08.v1"], _resolver(reg))
    assert v.verdict == "REGISTERED_SPLIT"
    assert v.usable is False
    assert set(v.redirect) == {"EQ-001/M.09.v1", "EQ-001/M.10.v1"}


def test_not_an_equation_blocks_usage(fixture_root):
    reg = core.load_registry(fixture_root)
    v = verdict.verdict_for_entry(reg.by_code["EQ-001/M.11.v1"], _resolver(reg))
    assert v.verdict == "REGISTERED_NOT_AN_EQUATION"
    assert v.usable is False


def test_unverified_is_usable_but_caveated(fixture_root):
    reg = core.load_registry(fixture_root)
    v = verdict.verdict_for_entry(reg.by_code["EQ-001/M.12.v1"], _resolver(reg))
    assert v.verdict == "REGISTERED_UNVERIFIED"
    assert v.usable is True
    assert "Th_coqc" in v.reason  # status_note text carried through


def test_check_no_match_is_not_registered():
    v = verdict.verdict_for_check(None, [], lambda c: None)
    assert v.verdict == "NOT_REGISTERED"
    assert v.usable is False


def test_check_candidate_is_never_usable():
    class FakeEv:
        def __init__(self, code, kind, ratio, detail):
            self.code, self.kind, self.ratio, self.detail = code, kind, ratio, detail

    candidates = [FakeEv("A", "renaming_candidate", 0.97, "detail")]
    v = verdict.verdict_for_check(None, candidates, lambda c: None)
    assert v.verdict == "CANDIDATE_MATCH"
    assert v.usable is False


def test_unknown_status_defaults_to_caution():
    """The confirmed bug this pinning test guards against (mcp/DESIGN.md
    sec. 0/5): the fallback branch of `verdict_for_entry` used to answer a
    missing/unrecognised `status` with `REGISTERED_CURRENT`/`usable=True` —
    silently promoting an unrecognised or malformed entry to "safe to cite",
    the single most dangerous failure mode this server can have. Both a
    genuinely-missing `status` (`None` — a real, reachable state: a
    hand-authored proposal merged with a typo, a partially-written entry
    mid-edit) and a schema value this build has not been taught yet must
    resolve to `CAUTION`/`usable=False`, never anything else."""
    entry_missing_status = {"code": "EQ-999/M.99.v1"}  # no "status" key at all
    v1 = verdict.verdict_for_entry(entry_missing_status, lambda c: None)
    assert v1.verdict == "CAUTION"
    assert v1.usable is False

    entry_unrecognised_status = {"code": "EQ-999/M.98.v1", "status": "something_new_v2"}
    v2 = verdict.verdict_for_entry(entry_unrecognised_status, lambda c: None)
    assert v2.verdict == "CAUTION"
    assert v2.usable is False

    # CAUTION is spelled differently from AMBIGUOUS on purpose (absent/
    # unrecognised evidence vs. conflicting evidence) -- pin the distinction.
    assert v1.verdict != "AMBIGUOUS"
    assert "CAUTION" in verdict.VERDICT_VALUES
    assert len(verdict.VERDICT_VALUES) == 11


# ---------------------------------------------------------------------------
# R3-1 (2026-09-07): an exact statement match used to be hard-coded to
# REGISTERED_CURRENT/usable=True with NO check of the matched entry's own
# `status` -- so a formula that exact-matches a `not_an_equation`/
# `superseded_by`/`split` entry's statement was told "REGISTERED_CURRENT,
# usable, cite that code", precisely the moment (an agent has formula text,
# not yet a code) the founder rule most needs to bite.
# ---------------------------------------------------------------------------

class _FakeEv:
    def __init__(self, code, kind, ratio, detail=""):
        self.code, self.kind, self.ratio, self.detail = code, kind, ratio, detail


def test_check_exact_match_to_not_an_equation_entry_is_never_registered_current(fixture_root):
    reg = core.load_registry(fixture_root)
    entry = reg.by_code["EQ-001/M.11.v1"]  # status == "not_an_equation" in the fixture
    candidates = [_FakeEv(entry["code"], "exact", 1.0)]
    v = verdict.verdict_for_check(None, candidates, _resolver(reg))
    assert v.verdict == "REGISTERED_NOT_AN_EQUATION"
    assert v.usable is False
    assert v.verdict != "REGISTERED_CURRENT"


def test_check_exact_match_to_superseded_entry_redirects_not_registered_current(fixture_root):
    reg = core.load_registry(fixture_root)
    entry = reg.by_code["EQ-001/M.04.v1"]  # status == "superseded_by" in the fixture
    candidates = [_FakeEv(entry["code"], "exact", 1.0)]
    v = verdict.verdict_for_check(None, candidates, _resolver(reg))
    assert v.verdict == "REGISTERED_SUPERSEDED"
    assert v.usable is False
    assert v.redirect == ["EQ-001/M.05.v1"]


def test_check_exact_match_to_current_entry_still_registered_current(fixture_root):
    """The fix must not regress the ordinary, safe case: an exact match to a
    genuinely `current` entry is still REGISTERED_CURRENT/usable=True."""
    reg = core.load_registry(fixture_root)
    entry = reg.by_code["EQ-001/M.05.v1"]  # status == "current"
    candidates = [_FakeEv(entry["code"], "exact", 1.0)]
    v = verdict.verdict_for_check(None, candidates, _resolver(reg))
    assert v.verdict == "REGISTERED_CURRENT"
    assert v.usable is True


def test_check_exact_match_that_cannot_be_reresolved_is_ambiguous():
    """A candidate names a code the resolver cannot find a full entry for
    (a stale/inconsistent index) -- escalate to a human, never fall through
    to REGISTERED_CURRENT."""
    candidates = [_FakeEv("GHOST-CODE/M.01.v1", "exact", 1.0)]
    v = verdict.verdict_for_check(None, candidates, lambda c: None)
    assert v.verdict == "AMBIGUOUS"
    assert v.usable is False


def test_known_statuses_and_rules_are_consistent():
    """`verdict.RULES` (the introspectable decision table `toledo_show_
    verdict_rules` serialises) must not silently drift from the real
    `_KNOWN_STATUSES` set the branch logic actually uses."""
    assert verdict._KNOWN_STATUSES == {
        "current", "unverified", "historical", "imprecise_as_stated",
        "superseded_by", "split", "not_an_equation",
    }
    assert any(r["verdict"] == "CAUTION" for r in verdict.RULES)
    assert all({"when", "verdict", "usable"} <= set(r.keys()) for r in verdict.RULES)
