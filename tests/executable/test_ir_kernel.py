"""tests/executable/test_ir_kernel.py -- unit tests for scripts/executable/ir_kernel.py and
ir_eval.py (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.9, stream S2).

Covers: every row of the shared tests/executable/vectors.json (also consumed, identically, by
test_ir_kernel.js); explicit division-by-zero and out-of-domain checks (raise, never silently
return 0/inf); and a static no-float/no-mpmath guard over ir_kernel.py's and ir_eval.py's own
source, mirroring the denylist-style guard convention mcp/toledo_mcp/regex_guard.py already
uses in this repository.
"""
from __future__ import annotations

import ast
import json
import pathlib
import sys
from fractions import Fraction

import pytest

REPO_ROOT = pathlib.Path(__file__).resolve().parents[2]
EXECUTABLE_DIR = REPO_ROOT / "scripts" / "executable"

# Loaded by file path, not `from scripts.executable import ...` -- this workstation's own
# environment demonstrates a real collision (a third-party `scripts` package installed in
# site-packages shadows this repository's top-level `scripts/` directory once any sys.path
# entry ahead of the repo root supplies one), so a package-style import is not reliable here.
# ir_eval.py's own import of ir_kernel falls back to this identical sibling-file strategy for
# the same reason (see ir_eval.py's own try/except ImportError block).
sys.path.insert(0, str(EXECUTABLE_DIR))
import ir_kernel  # noqa: E402
import ir_eval  # noqa: E402

VECTORS_PATH = pathlib.Path(__file__).resolve().parent / "vectors.json"
KERNEL_SOURCE_FILES = [
    REPO_ROOT / "scripts" / "executable" / "ir_kernel.py",
    REPO_ROOT / "scripts" / "executable" / "ir_eval.py",
]


def _load_vectors() -> list[dict]:
    with open(VECTORS_PATH, "r", encoding="utf-8") as f:
        doc = json.load(f)
    assert doc["schema_version"] == "executable-test-vectors-0.1"
    return doc["vectors"]


VECTORS = _load_vectors()


def _env_from_inputs(ir: dict, inputs: dict[str, str]) -> dict[str, Fraction]:
    return {name: ir_kernel.parse_rational(value) for name, value in inputs.items()}


@pytest.mark.parametrize("vector", VECTORS, ids=[v["name"] for v in VECTORS])
def test_shared_vector_via_kernel(vector: dict) -> None:
    """Walk the vector's own 'rhs' node directly through ir_kernel.eval_node, at the term
    count its own 'transcendental' block (if any) declares, and check the result against the
    shared expected_value within the shared tolerance -- both parsed as exact Fraction, never
    float."""
    ir = vector["ir"]
    env = _env_from_inputs(ir, vector["inputs"])
    terms = ir["transcendental"]["default_terms"] if ir.get("transcendental") else ir_kernel.DEFAULT_TERMS

    result = ir_kernel.eval_node(ir["rhs"], env, terms)
    expected = ir_kernel.parse_rational(vector["expected_value"])
    tolerance = ir_kernel.parse_rational(vector["tolerance"])

    assert abs(result - expected) <= tolerance, (
        f"{vector['name']}: got {result}, expected {expected} +/- {tolerance}"
    )


@pytest.mark.parametrize("vector", VECTORS, ids=[v["name"] for v in VECTORS])
def test_shared_vector_via_ir_eval(vector: dict) -> None:
    """End-to-end: the same vector through ir_eval.evaluate (schema validation + the public
    evaluator every other stream calls), not just the bare kernel walker."""
    ir = vector["ir"]
    result = ir_eval.evaluate(ir, vector["inputs"])

    got = ir_kernel.parse_rational(result["value"])
    expected = ir_kernel.parse_rational(vector["expected_value"])
    tolerance = ir_kernel.parse_rational(vector["tolerance"])
    assert abs(got - expected) <= tolerance

    if ir.get("transcendental") is not None:
        assert result["terms_used"] == ir["transcendental"]["default_terms"]
        assert result["error_bound"] is not None
        assert ir_kernel.parse_rational(result["error_bound"]) >= 0
    else:
        assert result["terms_used"] is None
        assert result["error_bound"] is None


def test_division_by_zero_raises() -> None:
    """A 'div' node whose divisor evaluates to zero raises IRKernelError -- never silently
    returns 0 or inf (sec.9)."""
    node = {"op": "div", "args": [{"op": "const", "value": "1"}, {"op": "var", "name": "d"}]}
    with pytest.raises(ir_kernel.IRKernelError, match="division by zero"):
        ir_kernel.eval_node(node, {"d": Fraction(0)})


def test_division_by_zero_raises_even_for_a_nonzero_declared_domain() -> None:
    """The kernel's own zero-check is unconditional -- it does not trust a variable's
    declared domain (e.g. Q_nonzero) to already exclude the value actually bound to it; the
    check re-verifies at the point of division itself."""
    node = {"op": "div", "args": [{"op": "var", "name": "a"}, {"op": "var", "name": "d"}]}
    with pytest.raises(ir_kernel.IRKernelError, match="division by zero"):
        ir_kernel.eval_node(node, {"a": Fraction(3), "d": Fraction(0)})


def test_sqrt_of_negative_raises() -> None:
    node = {"op": "call", "fn": "sqrt", "args": [{"op": "const", "value": "-1"}]}
    with pytest.raises(ir_kernel.IRKernelError, match="domain"):
        ir_kernel.eval_node(node, {})


def test_log_of_zero_raises() -> None:
    node = {"op": "call", "fn": "log", "args": [{"op": "const", "value": "0"}]}
    with pytest.raises(ir_kernel.IRKernelError, match="domain"):
        ir_kernel.eval_node(node, {})


def test_log_of_negative_raises() -> None:
    node = {"op": "call", "fn": "log", "args": [{"op": "const", "value": "-5"}]}
    with pytest.raises(ir_kernel.IRKernelError, match="domain"):
        ir_kernel.eval_node(node, {})


def test_negative_power_of_zero_raises() -> None:
    node = {"op": "pow", "args": [{"op": "const", "value": "0"}, {"op": "const", "value": "-1"}]}
    with pytest.raises(ir_kernel.IRKernelError, match="negative power"):
        ir_kernel.eval_node(node, {})


def test_non_integer_pow_exponent_rejected() -> None:
    node = {"op": "pow", "args": [{"op": "const", "value": "2"}, {"op": "const", "value": "1/2"}]}
    with pytest.raises(ir_kernel.IRKernelError, match="integer"):
        ir_kernel.eval_node(node, {})


def test_disallowed_operator_rejected() -> None:
    with pytest.raises(ir_kernel.IRKernelError, match="disallowed IR operator"):
        ir_kernel.eval_node({"op": "eval", "args": []}, {})


def test_disallowed_function_rejected() -> None:
    node = {"op": "call", "fn": "os.system", "args": [{"op": "const", "value": "1"}]}
    with pytest.raises(ir_kernel.IRKernelError, match="disallowed transcendental function"):
        ir_kernel.eval_node(node, {})


def test_const_node_rejects_non_string_value() -> None:
    """A 'const' node's value must be a string -- never a JSON number a lenient parser might
    otherwise silently accept and round to a float."""
    with pytest.raises(ir_kernel.IRKernelError):
        ir_kernel.eval_node({"op": "const", "value": 3}, {})  # type: ignore[dict-item]


def test_ir_eval_rejects_non_string_input() -> None:
    ir = VECTORS[0]["ir"]
    bad_inputs = dict(VECTORS[0]["inputs"])
    a_name = next(iter(bad_inputs))
    bad_inputs[a_name] = 0.5  # a float, never accepted
    with pytest.raises(ir_eval.IRValidationError):
        ir_eval.evaluate(ir, bad_inputs)


def test_ir_eval_rejects_candidate_status_transcendental_lint_mismatch() -> None:
    """sec.3/sec.13: algorithm_py and algorithm_js must never name the same family; a build-
    time lint rejects a sidecar where they match."""
    ir = json.loads(json.dumps(VECTORS[4]["ir"]))  # sqrt_two, a transcendental vector
    ir["transcendental"]["algorithm_js"] = ir["transcendental"]["algorithm_py"]
    with pytest.raises(ir_eval.IRValidationError, match="same family"):
        ir_eval.validate_ir_shape(ir)


def test_ir_eval_rejects_wrong_algorithm_py_family() -> None:
    ir = json.loads(json.dumps(VECTORS[4]["ir"]))
    ir["transcendental"]["algorithm_py"] = "not_a_real_family"
    with pytest.raises(ir_eval.IRValidationError, match="does not match"):
        ir_eval.validate_ir_shape(ir)


def test_ir_eval_requires_reviewed_by_for_reviewed_status() -> None:
    ir = json.loads(json.dumps(VECTORS[0]["ir"]))
    ir["eligibility"]["reviewed_by"] = None
    with pytest.raises(ir_eval.IRValidationError, match="reviewed_by"):
        ir_eval.validate_ir_shape(ir)


def test_ir_eval_requires_bare_output_variable_on_lhs() -> None:
    ir = json.loads(json.dumps(VECTORS[0]["ir"]))
    ir["lhs"] = {"op": "const", "value": "0"}
    with pytest.raises(ir_eval.IRValidationError, match="bare"):
        ir_eval.validate_ir_shape(ir)


def test_algorithm_families_are_pairwise_distinct_per_function() -> None:
    """ir_kernel.py's own module-level invariant, re-asserted here as a test rather than only
    an import-time assert: for every allowed transcendental fn, the declared Python-reference
    family differs from the declared JavaScript-twin family."""
    for fn in ir_kernel.ALLOWED_FNS:
        assert ir_kernel.ALGORITHM_FAMILY_PY[fn] != ir_kernel.ALGORITHM_FAMILY_JS[fn]


# ---------------------------------------------------------------------------
# Static no-float / no-mpmath guard (sec.9's own required check).
# ---------------------------------------------------------------------------

@pytest.mark.parametrize("path", KERNEL_SOURCE_FILES, ids=[p.name for p in KERNEL_SOURCE_FILES])
def test_no_float_literals_in_reference_source(path: pathlib.Path) -> None:
    """No bare Python float literal (e.g. `0.5`, `1e-9`) appears anywhere in this file's own
    AST -- the reference path is Fraction-only, always (sec.4)."""
    tree = ast.parse(path.read_text(encoding="utf-8"), filename=str(path))
    float_literals = [
        node for node in ast.walk(tree)
        if isinstance(node, ast.Constant) and isinstance(node.value, float)
    ]
    assert not float_literals, f"{path.name} contains a bare float literal: {float_literals}"


@pytest.mark.parametrize("path", KERNEL_SOURCE_FILES, ids=[p.name for p in KERNEL_SOURCE_FILES])
def test_no_mpmath_import_in_reference_source(path: pathlib.Path) -> None:
    """No `import mpmath` / `from mpmath import ...` anywhere in this file (sec.4: "mpmath
    and float never appear in this file or in ir_eval.py")."""
    tree = ast.parse(path.read_text(encoding="utf-8"), filename=str(path))
    for node in ast.walk(tree):
        if isinstance(node, ast.Import):
            assert not any(alias.name.split(".")[0] == "mpmath" for alias in node.names), (
                f"{path.name} imports mpmath"
            )
        if isinstance(node, ast.ImportFrom):
            assert node.module != "mpmath" and (node.module or "").split(".")[0] != "mpmath", (
                f"{path.name} imports from mpmath"
            )


@pytest.mark.parametrize("path", KERNEL_SOURCE_FILES, ids=[p.name for p in KERNEL_SOURCE_FILES])
def test_no_bare_float_builtin_call_in_reference_source(path: pathlib.Path) -> None:
    """No call to the builtin `float(...)` anywhere in this file."""
    tree = ast.parse(path.read_text(encoding="utf-8"), filename=str(path))
    for node in ast.walk(tree):
        if isinstance(node, ast.Call) and isinstance(node.func, ast.Name) and node.func.id == "float":
            pytest.fail(f"{path.name} calls the builtin float(...)")


if __name__ == "__main__":  # pragma: no cover
    raise SystemExit(pytest.main([__file__, "-v"]))
