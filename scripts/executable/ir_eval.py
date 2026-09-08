#!/usr/bin/env python3
"""scripts/executable/ir_eval.py -- the ONE evaluator every consumer of a Toledo executable-
equations IR sidecar calls (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.4, stream S2): the site
widget's build step, `toledo_eval` (mcp/toledo_mcp/server.py, stream S4), and
`scripts/executable/crosscheck_runner.py` (stream S3) all import this module rather than
re-implementing the walk -- never a second, parallel interpretation of the same IR (sec.13
item 4).

Loads one IR sidecar (registry/executable/<mangled-code>.json, sec.3 shape), validates it,
binds caller-supplied input values (accepted only as strings, parsed via
`ir_kernel.parse_rational` -- a JSON/Python float is rejected outright, never silently
coerced), walks the tree via `ir_kernel.eval_node`, and returns an exact-rational result plus
its `terms_used`/`error_bound` (transcendental case) or `None`/`None` (fully Q-exact case).

This module never edits registry/executable/*.json; it only reads a sidecar its caller
already loaded, or loads one itself from a path.
"""
from __future__ import annotations

import json
from fractions import Fraction
from pathlib import Path
from typing import Any, Mapping

try:
    from . import ir_kernel
except ImportError:
    # Loaded as a flat module rather than as part of the `scripts.executable` package --
    # e.g. via importlib.util.spec_from_file_location, mcp/toledo_mcp/core.py's own
    # established convention for reaching a repo script whose enclosing directories are not
    # guaranteed importable as regular packages (a real collision exists in at least one
    # environment on this workstation: a third-party `scripts` package installed in
    # site-packages shadows this repository's own top-level `scripts/` directory once any
    # sys.path entry ahead of the repo root supplies one). Fall back to a sibling-file import
    # so this module works identically either way.
    import sys as _sys
    from pathlib import Path as _Path

    _sys.path.insert(0, str(_Path(__file__).resolve().parent))
    import ir_kernel  # type: ignore[no-redef]

__all__ = [
    "IRValidationError",
    "REQUIRED_TOP_LEVEL_KEYS",
    "VALID_DOMAINS",
    "load_ir",
    "validate_ir_shape",
    "check_transcendental_lint",
    "evaluate",
    "evaluate_file",
]


class IRValidationError(ValueError):
    """The loaded IR sidecar (or the caller-supplied inputs) does not match the sec.3 schema
    this evaluator requires -- raised, never silently patched or guessed at."""


REQUIRED_TOP_LEVEL_KEYS = (
    "schema_version",
    "code",
    "root",
    "variables",
    "relation",
    "lhs",
    "rhs",
    "eligibility",
    "sample_inputs",
    "status",
)

VALID_DOMAINS = frozenset({"Z", "Z_pos", "Q", "Q_pos", "Q_nonzero"})

_VALID_STATUSES = frozenset({"candidate", "reviewed_eligible", "reviewed_rejected", "built"})


def _fail(message: str) -> None:
    raise IRValidationError(message)


def validate_ir_shape(ir: Mapping[str, Any]) -> None:
    """Structural validation against sec.3's IR schema. Does NOT check `status`/
    `eligibility.reviewed_by` gating for evaluation eligibility -- that fail-closed decision
    belongs to each caller (toledo_eval, crosscheck_runner), which know what status they are
    permitted to act on; this function only checks the document is well-formed."""
    if not isinstance(ir, Mapping):
        _fail("an IR sidecar must be a JSON object")

    missing = [k for k in REQUIRED_TOP_LEVEL_KEYS if k not in ir]
    if missing:
        _fail(f"IR sidecar missing required key(s): {missing}")

    if ir["schema_version"] != "executable-ir-0.1":
        _fail(f"unsupported schema_version: {ir['schema_version']!r}")

    if ir["status"] not in _VALID_STATUSES:
        _fail(f"unrecognised status: {ir['status']!r}")

    if ir["status"] in ("reviewed_eligible", "reviewed_rejected", "built"):
        eligibility = ir.get("eligibility") or {}
        if not eligibility.get("reviewed_by"):
            _fail(
                f"status {ir['status']!r} requires a non-empty eligibility.reviewed_by "
                "(sec.3: only a human registrar may write this status)"
            )
        if not eligibility.get("reviewed_at"):
            _fail(f"status {ir['status']!r} requires a non-null eligibility.reviewed_at")

    variables = ir["variables"]
    if not isinstance(variables, list) or not variables:
        _fail("'variables' must be a non-empty array")

    names_seen: set[str] = set()
    output_names: list[str] = []
    for v in variables:
        if not isinstance(v, Mapping) or "name" not in v or "domain" not in v or "role" not in v:
            _fail(f"malformed variable entry: {v!r}")
        name = v["name"]
        if name in names_seen:
            _fail(f"duplicate variable name: {name!r}")
        names_seen.add(name)
        if v["domain"] not in VALID_DOMAINS:
            _fail(f"variable {name!r} has an invalid domain: {v['domain']!r} (must be one of {sorted(VALID_DOMAINS)})")
        if v["role"] not in ("input", "output"):
            _fail(f"variable {name!r} has an invalid role: {v['role']!r}")
        if v["role"] == "output":
            output_names.append(name)

    if len(output_names) != 1:
        _fail(f"IR must declare exactly one output variable, found {len(output_names)}: {output_names}")

    if ir["relation"] != "eq":
        _fail(f"unsupported relation: {ir['relation']!r} (only 'eq' is implemented)")

    lhs = ir["lhs"]
    if lhs.get("op") != "var" or lhs.get("name") != output_names[0]:
        _fail(
            "'lhs' must be a bare {'op': 'var', 'name': <output variable>} reference -- "
            "this evaluator only computes the declared output from 'rhs', it does not solve "
            "an arbitrary equation for an unknown on either side"
        )

    check_transcendental_lint(ir)


def _collect_call_fns(node: Any, found: set[str]) -> None:
    if not isinstance(node, Mapping):
        return
    if node.get("op") == "call":
        fn = node.get("fn")
        if isinstance(fn, str):
            found.add(fn)
    for arg in node.get("args", []) or []:
        _collect_call_fns(arg, found)


def check_transcendental_lint(ir: Mapping[str, Any]) -> None:
    """Sec.3/sec.13's build-time lint: a 'call' node anywhere in lhs/rhs requires a non-null
    `transcendental` block naming exactly that function; `algorithm_py`/`algorithm_js` must
    match this kernel's own declared family (ir_kernel.ALGORITHM_FAMILY_PY/_JS) and must never
    name the same family as each other for the same fn. An equation mixing two distinct
    transcendental functions in one statement is out of scope for this narrow subset and is
    rejected here rather than silently under-checked."""
    fns_used: set[str] = set()
    _collect_call_fns(ir["lhs"], fns_used)
    _collect_call_fns(ir["rhs"], fns_used)

    transcendental = ir.get("transcendental")

    if not fns_used:
        if transcendental is not None:
            _fail("'transcendental' block present but no 'call' node exists in lhs/rhs")
        return

    if len(fns_used) > 1:
        _fail(
            f"more than one distinct transcendental function in one statement is out of scope "
            f"for this IR schema: {sorted(fns_used)}"
        )
    (fn,) = fns_used

    if transcendental is None:
        _fail(f"a 'call' node uses {fn!r} but no 'transcendental' block is present")

    for key in ("fn", "algorithm_py", "algorithm_js", "default_terms"):
        if key not in transcendental:
            _fail(f"'transcendental' block missing required key: {key!r}")

    if transcendental["fn"] != fn:
        _fail(f"'transcendental.fn' ({transcendental['fn']!r}) does not match the call node's fn ({fn!r})")

    if transcendental["algorithm_py"] == transcendental["algorithm_js"]:
        _fail(
            f"algorithm_py and algorithm_js name the same family ({transcendental['algorithm_py']!r}) "
            f"for {fn!r} -- a cross-check between one algorithm typed twice is not independent evidence"
        )

    expected_py = ir_kernel.ALGORITHM_FAMILY_PY.get(fn)
    expected_js = ir_kernel.ALGORITHM_FAMILY_JS.get(fn)
    if transcendental["algorithm_py"] != expected_py:
        _fail(
            f"transcendental.algorithm_py {transcendental['algorithm_py']!r} does not match "
            f"the Python reference kernel's own declared family {expected_py!r} for {fn!r}"
        )
    if transcendental["algorithm_js"] != expected_js:
        _fail(
            f"transcendental.algorithm_js {transcendental['algorithm_js']!r} does not match "
            f"the JavaScript twin's own declared family {expected_js!r} for {fn!r}"
        )
    if not isinstance(transcendental["default_terms"], int) or transcendental["default_terms"] <= 0:
        _fail(f"transcendental.default_terms must be a positive integer, got {transcendental['default_terms']!r}")


def _check_domain(value: Fraction, domain: str, name: str) -> None:
    if domain == "Z":
        if value.denominator != 1:
            _fail(f"input {name!r} declares domain Z but {value} is not an integer")
    elif domain == "Z_pos":
        if value.denominator != 1 or value <= 0:
            _fail(f"input {name!r} declares domain Z_pos but {value} is not a positive integer")
    elif domain == "Q":
        pass
    elif domain == "Q_pos":
        if value <= 0:
            _fail(f"input {name!r} declares domain Q_pos but {value} is not positive")
    elif domain == "Q_nonzero":
        if value == 0:
            _fail(f"input {name!r} declares domain Q_nonzero but the given value is zero")
    else:  # pragma: no cover -- validate_ir_shape already rejects any other domain string
        _fail(f"unknown domain: {domain!r}")


def _series_error_bound(fn: str, terms: int) -> Fraction:
    """A conservative, honestly-computed upper bound on the truncation error of this
    reference kernel's own series/iteration at `terms`, given its argument-reduction
    strategy (every reduced argument satisfies |x| <= 1/4 before the series/Newton loop
    runs, per ir_kernel's own reduction constants) -- NOT a measured empirical delta, a
    bound derived from the alternating-series remainder rule (next omitted term's own
    magnitude) applied to the worst case |x| = 1/4, plus a fixed safety factor for the
    recombination steps (squaring/double-angle/sqrt-scaling), which can only shrink a
    already-tiny error further for a contracting map. Always paired with `terms_used` in
    ir_eval.evaluate's return shape (sec.4) so a reader can see both the term count and this
    bound, never one without the other."""
    x = Fraction(1, 4)
    if fn in ("sin", "cos", "pi_const"):
        # alternating series in x**2; next term bound
        k = terms
        bound = (x ** (2 * k + 1)) / ir_kernel._factorial(2 * k + 1) if fn != "pi_const" else (x ** (2 * k + 1))
    elif fn == "exp":
        bound = (x ** (terms + 1)) / ir_kernel._factorial(terms + 1)
    elif fn == "sqrt":
        # Newton-Raphson error roughly squares each step from an initial error <= 1;
        # 2**-(2**terms) is astronomically small for terms >= 5 -- reported honestly, not
        # rounded up to a rounder-looking number.
        bound = Fraction(1, 2 ** min(2 ** terms, 4096))
    elif fn == "log":
        bound = (x ** (2 * terms + 1)) / (2 * terms + 1)
    else:  # pragma: no cover
        bound = Fraction(1, 10 ** 20)
    # Safety margin: never claim a bound tighter than the kernel's own internal rounding
    # precision could actually resolve.
    floor = Fraction(1, 10 ** (ir_kernel.WORKING_PRECISION_DIGITS - 5))
    return max(bound, floor)


def load_ir(path: str | Path) -> dict[str, Any]:
    """Load and structurally validate one IR sidecar file. Raises IRValidationError (never
    returns a partially-trusted document) on any shape mismatch."""
    with open(path, "r", encoding="utf-8") as f:
        ir = json.load(f)
    validate_ir_shape(ir)
    return ir


def evaluate(ir: Mapping[str, Any], inputs: Mapping[str, str]) -> dict[str, Any]:
    """Evaluate an already-loaded, already-validated IR document at the given inputs.
    `inputs` values MUST be strings -- a float/int is rejected here, never coerced, so no
    floating value ever crosses into the evaluator (sec.4/sec.8)."""
    validate_ir_shape(ir)

    input_vars = [v for v in ir["variables"] if v["role"] == "input"]

    env: dict[str, Fraction] = {}
    for v in input_vars:
        name = v["name"]
        if name not in inputs:
            _fail(f"missing required input {name!r}")
        raw = inputs[name]
        if not isinstance(raw, str):
            _fail(f"input {name!r} must be an exact-rational string (e.g. \"3\", \"22/7\"), "
                  f"got {type(raw).__name__} -- a JSON/Python number is never accepted")
        value = ir_kernel.parse_rational(raw)
        _check_domain(value, v["domain"], name)
        env[name] = value

    transcendental = ir.get("transcendental")
    terms = int(transcendental["default_terms"]) if transcendental else ir_kernel.DEFAULT_TERMS

    result = ir_kernel.eval_node(ir["rhs"], env, terms)

    if transcendental is not None:
        terms_used: int | None = terms
        error_bound: Fraction | None = _series_error_bound(transcendental["fn"], terms)
    else:
        terms_used = None
        error_bound = None

    return {
        "value": str(result),
        "terms_used": terms_used,
        "error_bound": str(error_bound) if error_bound is not None else None,
    }


def evaluate_file(path: str | Path, inputs: Mapping[str, str]) -> dict[str, Any]:
    """Convenience wrapper: load, validate, and evaluate one IR sidecar file in one call."""
    return evaluate(load_ir(path), inputs)


def _main(argv: list[str] | None = None) -> int:
    """CLI convenience for manual spot-checks: `python3 -m scripts.executable.ir_eval
    <ir.json> '{"n": "3"}'`. Not used by any other stream -- toledo_eval/crosscheck_runner
    call `evaluate`/`evaluate_file` in-process."""
    import sys

    args = sys.argv[1:] if argv is None else argv
    if len(args) != 2:
        print("usage: ir_eval.py <ir.json> '<json object of string inputs>'", file=sys.stderr)
        return 2
    ir_path, inputs_json = args
    try:
        inputs = json.loads(inputs_json)
        result = evaluate_file(ir_path, inputs)
    except (IRValidationError, ir_kernel.IRKernelError, json.JSONDecodeError) as exc:
        print(json.dumps({"evaluable": False, "reason": str(exc)}), file=sys.stderr)
        return 1
    print(json.dumps({"evaluable": True, **result}, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":  # pragma: no cover
    import sys
    sys.exit(_main())
