"""tests/executable/test_ir_schema.py -- the schema test docs/EXECUTABLE_EQUATIONS_v0_1.md sec.9
promises ("every registry/executable/*.json matches the shape in sec.3") but which did not exist
in this tree before this file (Integration fix, 2026-09-08, "missing-promised-schema-test"
finding). This is the exact gap that let a real algorithm-family drift ship undetected: neither
tests/executable/test_ir_kernel.py nor test_ir_kernel.js ever opened the OTHER language's file and
diffed its declared ALGORITHM_FAMILY_JS against ir_kernel.py's own copy -- so ir_kernel.py's own
(wrong) belief about what site/static/js/_ir_eval.js implements for `pi_const` went unchecked
against the real file. Four checks, each doing one job:

  1. Every real registry/executable/*.json sidecar (excluding the generated INDEX.json)
     structurally validates via ir_eval.validate_ir_shape -- the SAME gate
     scripts/compute_executable.py::load_sidecars now calls, never a second, re-derived check.
  2. Every code a sidecar references resolves to a real, non-`not_an_equation`/`split` entry in
     registry/CANONICAL.json (sec.9's own second promised assertion).
  3. Cross-language reconciliation: ir_kernel.ALGORITHM_FAMILY_JS (Python's own belief about what
     the JS twin implements per transcendental fn) is byte-identical to site/static/js/_ir_eval.js's
     own, real, shipped ALGORITHM_FAMILY_JS constant, for every fn in ir_kernel.ALLOWED_FNS -- this
     single check would have caught the real `pi_const` "brouncker_continued_fraction" (wrong) vs.
     "arctan_continued_fraction" (what the file actually implements) mismatch immediately.
  4. S1-to-S2 handoff integration: scripts/executable/extract_ir.py's own `sympy_to_node` output,
     combined with ir_kernel.py's own canonical algorithm-family names (the one place S1 is now
     allowed to read them from, since the "Integration fix, 2026-09-08" removal of extract_ir.py's
     own competing DRAFT_ALGORITHMS dict), validates cleanly via ir_eval.validate_ir_shape -- so
     the S1/S2 interface has at least one real, executed test rather than none (confirmed before
     this file: `grep -rl extract_ir tests/` had zero real hits).
"""
from __future__ import annotations

import json
import pathlib
import subprocess
import sys

import pytest

REPO_ROOT = pathlib.Path(__file__).resolve().parents[2]
EXECUTABLE_SCRIPTS_DIR = REPO_ROOT / "scripts" / "executable"
EXECUTABLE_REGISTRY_DIR = REPO_ROOT / "registry" / "executable"
CANONICAL_PATH = REPO_ROOT / "registry" / "CANONICAL.json"
QFRAC_PATH = REPO_ROOT / "site" / "static" / "js" / "_qfrac.js"
IR_EVAL_JS_PATH = REPO_ROOT / "site" / "static" / "js" / "_ir_eval.js"

sys.path.insert(0, str(EXECUTABLE_SCRIPTS_DIR))
import ir_eval  # noqa: E402
import ir_kernel  # noqa: E402

NODE_AVAILABLE = __import__("shutil").which("node") is not None


def _real_sidecar_paths() -> "list[pathlib.Path]":
    if not EXECUTABLE_REGISTRY_DIR.is_dir():
        return []
    return sorted(p for p in EXECUTABLE_REGISTRY_DIR.glob("*.json") if p.name != "INDEX.json")


# ---------------------------------------------------------------------------
# 1. Every real sidecar matches sec.3's IR schema.
# ---------------------------------------------------------------------------

@pytest.mark.parametrize("path", _real_sidecar_paths(), ids=lambda p: p.name)
def test_real_sidecar_matches_ir_schema(path: pathlib.Path) -> None:
    doc = json.loads(path.read_text(encoding="utf-8"))
    ir_eval.validate_ir_shape(doc)  # raises IRValidationError on any shape mismatch


def test_at_least_the_known_pilot_sidecars_are_present() -> None:
    """A regression guard against this parametrized test silently collecting zero cases (e.g. a
    path typo) and reporting a false 'all passed' with nothing actually checked."""
    names = {p.name for p in _real_sidecar_paths()}
    assert names, "no registry/executable/*.json sidecars found -- this test collected 0 cases"


# ---------------------------------------------------------------------------
# 2. Every sidecar's own `code` resolves to a real, eligible CANONICAL.json entry.
# ---------------------------------------------------------------------------

def _canonical_status_by_code() -> "dict[str, str]":
    doc = json.loads(CANONICAL_PATH.read_text(encoding="utf-8"))
    return {e["code"]: e.get("status") for e in doc.get("canonical", []) if e.get("code")}


@pytest.mark.parametrize("path", _real_sidecar_paths(), ids=lambda p: p.name)
def test_real_sidecar_code_resolves_to_an_eligible_canonical_entry(path: pathlib.Path) -> None:
    doc = json.loads(path.read_text(encoding="utf-8"))
    code = doc["code"]
    status_by_code = _canonical_status_by_code()
    assert code in status_by_code, f"{path.name}: code {code!r} has no registry/CANONICAL.json entry"
    status = status_by_code[code]
    assert status not in ("not_an_equation", "split"), (
        f"{path.name}: code {code!r} has CANONICAL.json status {status!r} -- sec.1.2's own "
        f"eligibility gate excludes this status, so no sidecar should ever reference it"
    )


# ---------------------------------------------------------------------------
# 3. Cross-language reconciliation: ir_kernel.py's own belief about the JS twin's declared
#    algorithm families must be byte-identical to the REAL, shipped _ir_eval.js file's own
#    declaration -- not merely "pairwise distinct from the Python family" (which
#    test_ir_kernel.py/.js already check and which a wrong-but-still-distinct name would still
#    satisfy).
# ---------------------------------------------------------------------------

@pytest.mark.skipif(not NODE_AVAILABLE, reason="node is not runnable on this workstation")
def test_ir_kernel_py_algorithm_family_js_matches_the_real_shipped_js_file() -> None:
    script = (
        "require(process.argv[1]); "
        "const E = require(process.argv[2]); "
        "process.stdout.write(JSON.stringify(E.ALGORITHM_FAMILY_JS));"
    )
    proc = subprocess.run(
        ["node", "-e", script, str(QFRAC_PATH), str(IR_EVAL_JS_PATH)],
        capture_output=True, text=True,
    )
    assert proc.returncode == 0, proc.stderr
    real_js_family = json.loads(proc.stdout)

    for fn in sorted(ir_kernel.ALLOWED_FNS):
        assert fn in real_js_family, (
            f"_ir_eval.js's own ALGORITHM_FAMILY_JS has no entry for {fn!r}, which "
            f"ir_kernel.ALLOWED_FNS declares supported"
        )
        assert ir_kernel.ALGORITHM_FAMILY_JS[fn] == real_js_family[fn], (
            f"ir_kernel.py's own belief about the JS twin's algorithm family for {fn!r} "
            f"({ir_kernel.ALGORITHM_FAMILY_JS[fn]!r}) does not match what site/static/js/"
            f"_ir_eval.js ACTUALLY declares ({real_js_family[fn]!r}) -- this is exactly the "
            f"real 'pi_const' drift this test was written to catch mechanically"
        )


# ---------------------------------------------------------------------------
# 4. S1 (extract_ir.py) -> S2 (ir_eval.py/ir_kernel.py) handoff integration test.
# ---------------------------------------------------------------------------

def _load_extract_ir_module():
    import importlib.util

    spec = importlib.util.spec_from_file_location(
        "_toledo_extract_ir_for_schema_test", EXECUTABLE_SCRIPTS_DIR / "extract_ir.py",
    )
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def test_extract_ir_sympy_to_node_output_validates_against_the_real_shared_kernel() -> None:
    """Runs extract_ir.py's own sympy_to_node() against a synthetic transcendental statement,
    assembles the minimal sec.3 sidecar shape around it using ir_kernel.py's own canonical
    algorithm-family names (never a value invented by this test), and pipes the whole thing
    through ir_eval.validate_ir_shape -- exercising the real S1-to-S2 interface end to end, which
    no test in this tree did before this file (confirmed: `grep -rl extract_ir tests/` had no
    real hit prior to this addition)."""
    import sympy

    extract_ir = _load_extract_ir_module()

    x = sympy.Symbol("x")
    used_fns: set = set()
    rhs_node = extract_ir.sympy_to_node(sympy.sin(x), used_fns)
    assert used_fns == {"sin"}

    sidecar = {
        "schema_version": "executable-ir-0.1",
        "code": "TESTFIX/S1S2.v1",
        "root": "TESTFIX",
        "generated_from_commit": "test-fixture-not-a-real-commit",
        "variables": [
            {"name": "x", "domain": "Q", "role": "input", "unit": None, "constraint": None},
            {"name": "y", "domain": "Q", "role": "output", "unit": None, "constraint": None},
        ],
        "relation": "eq",
        "lhs": {"op": "var", "name": "y"},
        "rhs": rhs_node,
        "transcendental": {
            "fn": "sin",
            "terms_param": "n_terms",
            "algorithm_py": ir_kernel.ALGORITHM_FAMILY_PY["sin"],
            "algorithm_js": ir_kernel.ALGORITHM_FAMILY_JS["sin"],
            "default_terms": 40,
        },
        "eligibility": {"classifier_candidate": True, "reviewed_by": None, "reviewed_at": None,
                         "review_note": None},
        "sample_inputs": [],
        "status": "candidate",
        "drift_note": "S1-to-S2 handoff integration test fixture (tests/executable/test_ir_schema.py).",
    }
    ir_eval.validate_ir_shape(sidecar)  # must not raise


def test_extract_ir_rejects_functions_the_shared_kernel_does_not_implement() -> None:
    """Integration fix (2026-09-08): extract_ir.py's own ALLOWED_FUNCTIONS/TRANSCENDENTAL_
    FUNCTIONS previously included tan/abs/e_const, none of which ir_kernel.ALLOWED_FNS supports
    -- a sidecar naming one of those could never be evaluated by ir_eval.py/_ir_eval.js/
    toledo_eval, permanently. Confirms the vocabularies are now identical by construction."""
    extract_ir = _load_extract_ir_module()
    assert extract_ir.TRANSCENDENTAL_FUNCTIONS == set(ir_kernel.ALLOWED_FNS)
    for removed in ("tan", "abs", "e_const"):
        assert removed not in extract_ir.ALLOWED_FUNCTIONS
        assert removed not in extract_ir.TRANSCENDENTAL_FUNCTIONS


if __name__ == "__main__":  # pragma: no cover
    raise SystemExit(pytest.main([__file__, "-v"]))
