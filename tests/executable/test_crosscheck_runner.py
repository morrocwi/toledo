"""
tests/executable/test_crosscheck_runner.py -- integration test for scripts/executable/
crosscheck_runner.py (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.9's own "Cross-check runner
integration test": one fixed fixture IR + a --dry-run mode that skips writing into the sibling
glosa checkout, asserting the runner's own PASS/FAIL/ERROR classification against a hand-verified
expected result).

Runs the runner's Python driver process for real, against S2's REAL, landed shared kernels
(`scripts/executable/ir_eval.py`/`ir_kernel.py`, `site/static/js/_qfrac.js`/`_ir_eval.js` -- all
present in this checkout) -- this is genuine cross-implementation integration testing, not a
double standing in for a not-yet-built dependency. `--executable-dir` still points at
`tests/executable/fixtures/` because the REAL `registry/executable/` has zero sidecars in this
checkout (S1 has not extracted/reviewed any yet) -- the two fixture IR sidecars here
(`TEST_EXEC__A_01_v1.json`: a Q-exact `add`; `TEST_EXEC__A_02_v1.json`: `pi_const`, exercising
the real Machin-arctan-series-vs-Brouncker-continued-fraction transcendental comparison) are
schema-valid IR documents using only the real, allowed op/fn vocabulary S2 actually implements --
never a toy operator invented for this test.

Skips (never fails) when `node` is not runnable on this workstation -- the runner itself already
reports that condition as a RunnerError (exit 2) rather than crashing; this test's own skip
condition mirrors that same honest-absence handling.
"""
from __future__ import annotations

import json
import pathlib
import shutil
import subprocess
import sys

import pytest

REPO_ROOT = pathlib.Path(__file__).resolve().parents[2]
FIXTURES_DIR = pathlib.Path(__file__).resolve().parent / "fixtures"
RUNNER = REPO_ROOT / "scripts" / "executable" / "crosscheck_runner.py"

sys.path.insert(0, str(REPO_ROOT / "scripts" / "executable"))
import crosscheck_runner as cr  # noqa: E402


NODE_AVAILABLE = shutil.which("node") is not None


def _run_cli(*extra_args: str) -> subprocess.CompletedProcess:
    """Invokes the real CLI against the real S2 kernels (default --ir-eval-path/--qfrac-path/
    --ir-eval-js-path), only overriding --executable-dir to this test's own fixture sidecars."""
    return subprocess.run(
        [sys.executable, str(RUNNER), "--executable-dir", str(FIXTURES_DIR), *extra_args],
        capture_output=True, text=True,
    )


# ---------------------------------------------------------------------------
# Unit-level: mangling, comparison, overall-status (no subprocess needed)
# ---------------------------------------------------------------------------

def test_mangle_code_matches_schema_convention():
    assert cr.mangle_code("EQ-045/P.03.v1") == "EQ_045__P_03_v1"
    assert cr.mangle_code("MQ.08/H.02.v1") == "MQ_08__H_02_v1"


def test_compare_row_q_exact_pass():
    row = cr.compare_row({"value": "5/3", "error_bound": None}, {"value": "5/3", "error_bound": None}, None)
    assert row["status"] == "PASS"


def test_compare_row_q_exact_fail_hand_verified():
    """Hand-verified expected result (sec.9's own requirement): 1/3 != 2/3, so a Q-exact node MUST
    report FAIL, never ERROR and never a silently-passed 'close enough'."""
    row = cr.compare_row({"value": "1/3", "error_bound": None}, {"value": "2/3", "error_bound": None}, None)
    assert row["status"] == "FAIL"


def test_compare_row_transcendental_pass_within_bound():
    row = cr.compare_row(
        {"value": "1/2", "error_bound": "1/100"},
        {"value": "501/1000", "error_bound": "1/100"},
        {"fn": "pi_const"},
    )
    # |1/2 - 501/1000| = 1/1000 <= max(1/100, 1/100) = 1/100 -> PASS
    assert row["status"] == "PASS"


def test_compare_row_transcendental_fail_outside_bound():
    row = cr.compare_row(
        {"value": "22/7", "error_bound": "1/100"},
        {"value": "19/6", "error_bound": "1/100"},
        {"fn": "pi_const"},
    )
    # |22/7 - 19/6| = 1/42 ~= 0.0238, > max(1/100, 1/100) = 0.01 -> FAIL
    assert row["status"] == "FAIL"


def test_compare_row_transcendental_missing_error_bound_is_error_not_guessed():
    row = cr.compare_row({"value": "3", "error_bound": None}, {"value": "3", "error_bound": "1/10"},
                          {"fn": "pi_const"})
    assert row["status"] == "ERROR"


def test_overall_status_fail_beats_pass_and_error():
    assert cr.overall_status([{"status": "PASS"}, {"status": "FAIL"}]) == "FAIL"
    assert cr.overall_status([{"status": "PASS"}, {"status": "ERROR"}]) == "ERROR"
    assert cr.overall_status([{"status": "PASS"}, {"status": "PASS"}]) == "PASS"
    assert cr.overall_status([{"status": "FAIL"}, {"status": "ERROR"}]) == "FAIL"


def test_require_eligible_refuses_candidate_status():
    with pytest.raises(cr.RunnerError, match="not 'reviewed_eligible' or 'built'"):
        cr.require_eligible({"code": "X", "status": "candidate"})


def test_require_eligible_refuses_reviewed_rejected():
    with pytest.raises(cr.RunnerError):
        cr.require_eligible({"code": "X", "status": "reviewed_rejected"})


def test_require_eligible_accepts_reviewed_eligible_and_built():
    cr.require_eligible({"code": "X", "status": "reviewed_eligible"})
    cr.require_eligible({"code": "X", "status": "built"})


def test_missing_sidecar_is_runner_error_not_traceback():
    with pytest.raises(cr.RunnerError, match="no IR sidecar"):
        cr.load_sidecar_by_code(FIXTURES_DIR, "NO/SUCH.code.v1")


def test_missing_s2_python_kernel_is_named_runner_error():
    with pytest.raises(cr.RunnerError, match="S2 dependency missing"):
        cr.run_python_reference(FIXTURES_DIR / "does_not_exist.py", {}, {})


# ---------------------------------------------------------------------------
# End-to-end (real subprocess: this driver process + a real `node` for the JS twin), against the
# fixture kernels, in --dry-run mode (writes no card, per sec.9)
# ---------------------------------------------------------------------------

@pytest.mark.skipif(not NODE_AVAILABLE, reason="node is not runnable on this workstation")
def test_end_to_end_q_exact_pass_dry_run():
    proc = _run_cli("--code", "TEST-EXEC/A.01.v1", "--dry-run")
    assert proc.returncode == 0, proc.stderr
    out = json.loads(proc.stdout)
    assert out["processed"] == 1
    assert out["cards_written"] == 0  # dry-run: never writes into the glosa checkout
    assert out["summaries"][0]["status"] == "PASS"
    assert out["summaries"][0]["rows"] == 2


@pytest.mark.skipif(not NODE_AVAILABLE, reason="node is not runnable on this workstation")
def test_end_to_end_transcendental_pass_dry_run():
    proc = _run_cli("--code", "TEST-EXEC/A.02.v1", "--dry-run")
    assert proc.returncode == 0, proc.stderr
    out = json.loads(proc.stdout)
    assert out["summaries"][0]["status"] == "PASS"


@pytest.mark.skipif(not NODE_AVAILABLE, reason="node is not runnable on this workstation")
def test_end_to_end_all_reviewed_finds_both_fixtures():
    proc = _run_cli("--all-reviewed", "--dry-run")
    assert proc.returncode == 0, proc.stderr
    out = json.loads(proc.stdout)
    assert out["processed"] == 2
    codes = {s["code"] for s in out["summaries"]}
    assert codes == {"TEST-EXEC/A.01.v1", "TEST-EXEC/A.02.v1"}


def test_all_reviewed_over_empty_registry_directory_is_a_clean_noop(tmp_path):
    """The real registry/executable/ directory has zero sidecars in this checkout today (S1 has
    not run yet) -- --all-reviewed against an empty directory must report 0 processed, never
    error, matching what a real `make executable` run sees right now."""
    result = subprocess.run(
        [sys.executable, str(RUNNER), "--all-reviewed", "--dry-run",
         "--executable-dir", str(tmp_path)],
        capture_output=True, text=True,
    )
    assert result.returncode == 0, result.stderr
    out = json.loads(result.stdout)
    assert out == {"processed": 0, "cards_written": 0, "summaries": [],
                   "note": "no reviewed_eligible/built sidecar found"}


# ---------------------------------------------------------------------------
# Real (non-dry-run) card write into a throwaway git-initialised directory, validated against
# glosa's own schema/reproduction_card.schema.json -- proves the emitted card is actually shaped
# right, not merely that the CLI exits 0.
# ---------------------------------------------------------------------------

@pytest.mark.skipif(not NODE_AVAILABLE, reason="node is not runnable on this workstation")
def test_written_card_matches_glosa_schema(tmp_path):
    jsonschema = pytest.importorskip("jsonschema")

    fake_glosa = tmp_path / "glosa"
    (fake_glosa / "cases" / "repro").mkdir(parents=True)
    subprocess.run(["git", "init", "-q"], cwd=fake_glosa, check=True)

    proc = _run_cli("--code", "TEST-EXEC/A.01.v1", "--glosa-repo", str(fake_glosa))
    assert proc.returncode == 0, proc.stderr
    out = json.loads(proc.stdout)
    assert out["cards_written"] == 1
    card_path = fake_glosa / out["summaries"][0]["card_path"]
    assert card_path.is_file()
    card = json.loads(card_path.read_text(encoding="utf-8"))

    schema_dir = REPO_ROOT.parent / "glosa" / "schema"
    schema_path = schema_dir / "reproduction_card.schema.json"
    if not schema_path.is_file():
        pytest.skip(f"sibling glosa checkout schema not found at {schema_path}")
    schema = json.loads(schema_path.read_text(encoding="utf-8"))

    # reproduction_card.schema.json $refs a sibling file (core_epistemic_structure.schema.json)
    # by a bare relative filename -- resolve it from the same directory on disk, the way any
    # other consumer of this schema pair (e.g. glosa's own `glosa check`) would.
    def _retrieve(uri: str):
        from referencing import Resource
        filename = uri.rsplit("/", 1)[-1]
        return Resource.from_contents(json.loads((schema_dir / filename).read_text(encoding="utf-8")))

    from referencing import Registry
    registry = Registry(retrieve=_retrieve)
    validator_cls = jsonschema.validators.validator_for(schema)
    validator = validator_cls(schema, registry=registry)
    validator.validate(card)  # raises on any violation

    assert card["run"]["ai_at_runtime"] == 0
    assert card["result"]["status"] == "PASS"
    assert card["toledo_codes"] == ["TEST-EXEC/A.01.v1"]
    # No AI vendor name anywhere in the filed card (glosa AGENTS.md rule 9 / global no-attribution rule).
    blob = json.dumps(card).lower()
    for banned in ("claude", "anthropic", "gpt", "openai", "gemini"):
        assert banned not in blob


def test_refuses_to_write_outside_a_git_checkout(tmp_path):
    not_a_repo = tmp_path / "not_glosa"
    not_a_repo.mkdir()
    proc = _run_cli("--code", "TEST-EXEC/A.01.v1", "--glosa-repo", str(not_a_repo))
    assert proc.returncode == 2
    assert "not a git repository" in proc.stderr
