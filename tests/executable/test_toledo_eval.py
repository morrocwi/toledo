"""Tests for `toledo_eval` (mcp/toledo_mcp/server.py, 21st tool, S4 —
docs/EXECUTABLE_EQUATIONS_v0_1.md sec.8/sec.9).

Scope, exactly per the spec's own §9 test list: fail-closed for a code with
no sidecar; fail-closed for a `candidate`-status sidecar; correct evaluation
for a fixture `reviewed_eligible` sidecar; a non-string input is rejected.

This suite never touches `registry/CANONICAL.json`, `registry/genesis_root.json`,
or `registry/LINEAGE.jsonl` — every isolated case runs against a throwaway
`tmp_path` pointed to by `TOLEDO_ROOT`, the same isolation mechanism
`mcp/tests/test_server.py::test_toledo_search_reports_index_unavailable_
when_canonical_json_missing` already uses. `registry/executable/*.json`
sidecars (S1's own output) and `scripts/executable/ir_eval.py` (S2's own
shared evaluator) do not exist in this checkout as of this pass — S1/S2 land
separately (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.10's build-stream table).
The fail-closed tests below need neither: a missing sidecar file, or a hand-
written fixture sidecar with `status: "candidate"`/`"reviewed_rejected"`, is
enough to exercise `toledo_eval`'s own branching. The one success-path test
(`test_reviewed_eligible_sidecar_evaluates_via_ir_eval`) injects a minimal
fake `scripts.executable.ir_eval` module via `sys.modules` — a dependency
substitution, not a rewrite of S2's ownership — so this test PINS the calling
contract `toledo_eval` expects (`ir_eval.evaluate(sidecar_dict, inputs) ->
{"value", "terms_used", "error_bound"}`) and will need no change once the
real module lands, provided it honours that contract.
"""
from __future__ import annotations

import json
import pathlib
import sys
import types

import pytest

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent.parent
MCP_DIR = REPO_ROOT / "mcp"
if str(MCP_DIR) not in sys.path:
    sys.path.insert(0, str(MCP_DIR))

from toledo_mcp import cache as cache_mod  # noqa: E402
from toledo_mcp import export_static, server  # noqa: E402


def _data(result: dict):
    assert result["ok"] is True, result
    assert result["error"] is None or result["error"].get("code") == "STALE_INDEX", result
    return result["data"]


@pytest.fixture(autouse=True)
def _reset_cache():
    cache_mod.reset_cache_for_tests()
    yield
    cache_mod.reset_cache_for_tests()


@pytest.fixture()
def isolated_root(tmp_path, monkeypatch):
    """A throwaway repo root with `registry/executable/` writable but no
    `registry/CANONICAL.json` — deliberately: the fail-closed sidecar-status
    tests below never need a resolvable canonical entry, only a sidecar file
    (`toledo_eval`'s own reproduction_card lookup degrades to `None` on a
    registry-read failure by design — see server.py's own comment at that
    call site — so this stays a genuine unit test of the sidecar branching,
    not a full-registry integration test)."""
    (tmp_path / "registry" / "executable").mkdir(parents=True)
    monkeypatch.setenv("TOLEDO_ROOT", str(tmp_path))
    monkeypatch.setenv("TOLEDO_MCP_STATE_DIR", str(tmp_path / "state"))
    return tmp_path


def _write_sidecar(root: pathlib.Path, code: str, doc: dict) -> pathlib.Path:
    p = root / "registry" / "executable" / f"{export_static.mangle_code(code)}.json"
    p.write_text(json.dumps(doc), encoding="utf-8")
    return p


# ---------------------------------------------------------------------------
# Envelope shape + fail-closed: no sidecar
# ---------------------------------------------------------------------------

def test_no_sidecar_is_fail_closed_not_an_exception(isolated_root):
    data = _data(server.toledo_eval("EQ-999/P.01.v1", {"n": "3"}))
    assert data["evaluable"] is False
    assert data["code"] == "EQ-999/P.01.v1"
    assert "no IR sidecar" in data["reason"]


def test_result_is_the_ok_data_error_envelope(isolated_root):
    result = server.toledo_eval("EQ-999/P.01.v1", {"n": "3"})
    assert set(result.keys()) == {"ok", "data", "error"}
    assert result["ok"] is True  # a genuinely-not-evaluable code is a normal answer, not a transport error


# ---------------------------------------------------------------------------
# Fail-closed: candidate / reviewed_rejected status
# ---------------------------------------------------------------------------

def test_candidate_status_sidecar_is_fail_closed(isolated_root):
    _write_sidecar(isolated_root, "EQ-045/P.03.v1", {
        "code": "EQ-045/P.03.v1", "status": "candidate", "eligibility": {"reviewed_by": None},
    })
    data = _data(server.toledo_eval("EQ-045/P.03.v1", {"n": "3"}))
    assert data["evaluable"] is False
    assert "candidate" in data["reason"]
    assert "not yet human-reviewed" in data["reason"]


def test_reviewed_rejected_status_sidecar_is_fail_closed_and_quotes_review_note(isolated_root):
    _write_sidecar(isolated_root, "EQ-045/P.03.v1", {
        "code": "EQ-045/P.03.v1", "status": "reviewed_rejected",
        "eligibility": {"reviewed_by": "registrar-1", "review_note": "prose fragment, not a formula"},
    })
    data = _data(server.toledo_eval("EQ-045/P.03.v1", {"n": "3"}))
    assert data["evaluable"] is False
    assert "reviewed_rejected" in data["reason"]
    assert "prose fragment, not a formula" in data["reason"]


def test_unknown_status_sidecar_is_fail_closed(isolated_root):
    _write_sidecar(isolated_root, "EQ-045/P.03.v1", {"code": "EQ-045/P.03.v1", "status": "built_but_broken"})
    data = _data(server.toledo_eval("EQ-045/P.03.v1", {"n": "3"}))
    assert data["evaluable"] is False
    assert "not evaluable" in data["reason"]


# ---------------------------------------------------------------------------
# Non-string input is rejected (never silently coerced from a JSON number)
# ---------------------------------------------------------------------------

def test_non_string_input_is_rejected_not_coerced(isolated_root):
    _write_sidecar(isolated_root, "EQ-045/P.03.v1", {"code": "EQ-045/P.03.v1", "status": "reviewed_eligible"})
    data = _data(server.toledo_eval("EQ-045/P.03.v1", {"n": 3}))  # a real JSON/Python int, not "3"
    assert data["evaluable"] is False
    assert "'n'" in data["reason"]
    assert "must be strings" in data["reason"]


def test_non_dict_inputs_is_invalid_input(isolated_root):
    result = server.toledo_eval("EQ-045/P.03.v1", "not a dict")  # type: ignore[arg-type]
    assert result["ok"] is False
    assert result["error"]["code"] == "INVALID_INPUT"


# ---------------------------------------------------------------------------
# Reviewed-eligible sidecar: parse failure and successful evaluation
# ---------------------------------------------------------------------------

@pytest.fixture()
def fake_ir_eval(monkeypatch):
    """Substitutes `server._load_ir_eval` (server.py's own file-path loader
    for `scripts/executable/ir_eval.py` — see its docstring for why this is
    a file-path load rather than `from scripts.executable import ir_eval`:
    a same-named `scripts` distribution in this workstation's site-packages
    shadows the repo's own `scripts/` namespace-package directory) with a
    minimal fake module. This pins `toledo_eval`'s own calling contract
    against S2's real module (`ir_eval.evaluate(sidecar_dict, inputs) ->
    {"value", "terms_used", "error_bound"}`, confirmed directly against the
    real `scripts/executable/ir_eval.py` in this checkout) without depending
    on any specific IR schema shape S2's real evaluator would itself
    validate — a deliberate substitution, not a rewrite of S2's ownership
    (no file is written under `scripts/executable/`)."""
    from fractions import Fraction

    def evaluate(ir: dict, inputs: dict) -> dict:
        # ir_eval's own real contract (docs/EXECUTABLE_EQUATIONS_v0_1.md
        # sec.4): parse every input as an exact rational, never a float;
        # raise on a malformed value rather than returning a guessed result.
        n = Fraction(inputs["n"])
        return {"value": str(n * 2), "terms_used": None, "error_bound": None}

    fake_ir_eval_mod = types.ModuleType("fake_ir_eval_for_test")
    fake_ir_eval_mod.evaluate = evaluate
    monkeypatch.setattr(server, "_load_ir_eval", lambda: fake_ir_eval_mod)
    return fake_ir_eval_mod


def test_reviewed_eligible_sidecar_evaluates_via_ir_eval(isolated_root, fake_ir_eval):
    _write_sidecar(isolated_root, "EQ-045/P.03.v1", {"code": "EQ-045/P.03.v1", "status": "reviewed_eligible"})
    data = _data(server.toledo_eval("EQ-045/P.03.v1", {"n": "22/7"}))
    assert data["evaluable"] is True
    assert data["code"] == "EQ-045/P.03.v1"
    assert data["value"] == "44/7"  # exact rational string, never a float
    assert data["approx_display"].startswith("6.2857142857")  # display-only, captioned separately
    assert data["terms_used"] is None
    assert data["error_bound"] is None
    assert data["reproduction_card"] is None  # no registry/CANONICAL.json in this isolated root


def test_built_status_also_evaluates(isolated_root, fake_ir_eval):
    """`built` (S2 has validated the sidecar against `sample_inputs`) is
    evaluable exactly like `reviewed_eligible` (docs/EXECUTABLE_EQUATIONS_
    v0_1.md sec.3's status lifecycle)."""
    _write_sidecar(isolated_root, "EQ-045/P.03.v1", {"code": "EQ-045/P.03.v1", "status": "built"})
    data = _data(server.toledo_eval("EQ-045/P.03.v1", {"n": "3"}))
    assert data["evaluable"] is True
    assert data["value"] == "6"


def test_malformed_rational_input_is_fail_closed_not_an_exception(isolated_root, fake_ir_eval):
    _write_sidecar(isolated_root, "EQ-045/P.03.v1", {"code": "EQ-045/P.03.v1", "status": "reviewed_eligible"})
    data = _data(server.toledo_eval("EQ-045/P.03.v1", {"n": "not-a-number"}))
    assert data["evaluable"] is False
    assert "not-a-number" in data["reason"] or "Fraction" in data["reason"]


def test_missing_ir_eval_module_is_disclosed_not_treated_as_missing_sidecar(isolated_root, monkeypatch):
    """Distinct from "no IR sidecar for this code" (S1's output absent) —
    when S2's `scripts/executable/ir_eval.py` itself is not importable on a
    build, that gap must be its own disclosed reason, never silently folded
    into the sidecar-absence message. `scripts/executable/ir_eval.py` DOES
    exist in this checkout (S2 landed it), so unavailability is simulated
    directly at `server._load_ir_eval` rather than by hiding the real file."""
    _write_sidecar(isolated_root, "EQ-045/P.03.v1", {"code": "EQ-045/P.03.v1", "status": "reviewed_eligible"})
    monkeypatch.setattr(server, "_load_ir_eval", lambda: (_ for _ in ()).throw(ImportError("simulated: S2 not landed on this build")))
    data = _data(server.toledo_eval("EQ-045/P.03.v1", {"n": "3"}))
    assert data["evaluable"] is False
    assert "no IR sidecar" not in data["reason"]
    assert "executable reference runtime is not available" in data["reason"]
    assert "simulated: S2 not landed" in data["reason"]


# ---------------------------------------------------------------------------
# Real end-to-end: the ACTUAL scripts/executable/ir_eval.py (S2's shipped
# module, present in this checkout), no substitution — pins toledo_eval's
# real integration, not just its own calling-contract branching above.
# ---------------------------------------------------------------------------

def _real_ir_eval_available() -> bool:
    try:
        server._load_ir_eval()
    except ImportError:
        return False
    return True


@pytest.mark.skipif(not _real_ir_eval_available(), reason="scripts/executable/ir_eval.py not present on this build (S2)")
def test_real_ir_eval_end_to_end_q_exact_relation(isolated_root):
    """A genuine Q-exact IR (`result = 2 * n`), evaluated through the REAL
    `scripts/executable/ir_eval.py` (S2) — not a fake — via `toledo_eval`.
    `registry/executable/` itself stays isolated under `TOLEDO_ROOT`
    (`isolated_root`); `scripts/executable/` resolves to the real, installed
    tree regardless (see server.py's own `_REPO_ROOT_FOR_SCRIPTS` — code, not
    registry data, so it is not `TOLEDO_ROOT`-overridable)."""
    _write_sidecar(isolated_root, "TEST-CODE/M.01.v1", {
        "schema_version": "executable-ir-0.1",
        "code": "TEST-CODE/M.01.v1",
        "root": "TEST-CODE",
        "variables": [
            {"name": "n", "domain": "Z", "role": "input"},
            {"name": "result", "domain": "Q", "role": "output"},
        ],
        "relation": "eq",
        "lhs": {"op": "var", "name": "result"},
        "rhs": {"op": "mul", "args": [{"op": "const", "value": "2"}, {"op": "var", "name": "n"}]},
        "eligibility": {"reviewed_by": "test-registrar", "reviewed_at": "2026-09-08"},
        "sample_inputs": [{"n": "3"}],
        "status": "reviewed_eligible",
    })
    data = _data(server.toledo_eval("TEST-CODE/M.01.v1", {"n": "21"}))
    assert data["evaluable"] is True
    assert data["value"] == "42"  # exact: 2 * 21, never a rounded float
    assert data["terms_used"] is None  # Q-exact relation, no series involved
    assert data["error_bound"] is None


@pytest.mark.skipif(not _real_ir_eval_available(), reason="scripts/executable/ir_eval.py not present on this build (S2)")
def test_real_ir_eval_end_to_end_domain_violation_is_fail_closed(isolated_root):
    """`n`'s declared domain is `Z` (an integer) — a non-integer input must
    raise inside the real `ir_eval.evaluate`, which `toledo_eval` turns into
    a disclosed fail-closed reason rather than an uncaught exception."""
    _write_sidecar(isolated_root, "TEST-CODE/M.01.v1", {
        "schema_version": "executable-ir-0.1",
        "code": "TEST-CODE/M.01.v1",
        "root": "TEST-CODE",
        "variables": [
            {"name": "n", "domain": "Z", "role": "input"},
            {"name": "result", "domain": "Q", "role": "output"},
        ],
        "relation": "eq",
        "lhs": {"op": "var", "name": "result"},
        "rhs": {"op": "mul", "args": [{"op": "const", "value": "2"}, {"op": "var", "name": "n"}]},
        "eligibility": {"reviewed_by": "test-registrar", "reviewed_at": "2026-09-08"},
        "sample_inputs": [{"n": "3"}],
        "status": "reviewed_eligible",
    })
    data = _data(server.toledo_eval("TEST-CODE/M.01.v1", {"n": "1/2"}))
    assert data["evaluable"] is False
    assert "domain Z" in data["reason"]
