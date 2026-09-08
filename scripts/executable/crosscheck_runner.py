#!/usr/bin/env python3
"""
scripts/executable/crosscheck_runner.py -- S3, cross-check runner + Reproduction Card
registration (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.6).

ONE generic, code-parameterized script -- never a bespoke per-equation file (unlike glosa's own
two existing example runners, `run_EQ-045_gauge_dim.py` / `run_EQ-068_higgs_pdg.py`, each a
separate hand-written file per claim; this runner is the opposite pattern: one script, invoked as
`--code <toledo_code>` or `--all-reviewed` to batch over every `reviewed_eligible`/`built` sidecar).
"Per-entry" describes the generated Reproduction Card (sec.6's own "resolving one apparent
tension"); "never per-entry" describes the authoring effort, which stays at exactly this one file
regardless of how many cards it eventually emits.

Per code, this script:
  1. Loads the IR sidecar (registry/executable/<mangled-code>.json); refuses (no card written)
     unless `status` is `reviewed_eligible` or `built`.
  2. Writes a PRE-REGISTERED prediction into the card BEFORE running anything: the comparison RULE
     (exact-match for a Q-exact node; "difference must fall inside each evaluator's own reported
     error_bound" for a transcendental one) -- never a numeric tolerance invented after seeing the
     delta.
  3. Runs the Python reference (S2's `scripts/executable/ir_eval.py`) once, for real, against each
     `sample_inputs` row.
  4. Runs the JS twin (S2's `site/static/js/_qfrac.js` + `_ir_eval.js`) once, for real, via a
     `node` subprocess -- a thin harness that only `eval`s the two shipped browser files and calls
     the one function they are expected to expose; never a second implementation of the walker.
  5. Compares the two results per sample-input row and writes `result.status` honestly
     (PASS/FAIL/ERROR) -- a disclosed FAIL is filed exactly as legitimately as a PASS.
  6. Emits `cases/repro/EXEC-<mangled-code>.json` under a sibling `glosa` checkout
     (`--glosa-repo PATH`, same convention `run_IDM_ladder_constants.py` /
     `register_reproduction_evidence.py` already use -- no absolute path, no username, ever
     written into the card).

Registration into `registry/reproduction_card_index.json` is UNCHANGED and NOT done by this
script: the existing `scripts/register_reproduction_evidence.py [--glosa-repo PATH]` already reads
`cases/repro/*.json` wholesale with zero edits needed, and picks up the new `EXEC-*.json` cards
this script writes on its own next run. `scripts/compute_executable.py` (also S3) reads that index
afterwards to fill each code's `executable.reproduction_card` citation and to (re)generate
`registry/executable/INDEX.json`. The pipeline order is therefore:

    crosscheck_runner.py --all-reviewed        (this file: writes EXEC-*.json cards)
      -> register_reproduction_evidence.py     (existing, UNMODIFIED: indexes them)
        -> compute_executable.py               (this stream's other file: computes the block)

A live "try it" widget result (site, S4) is NEVER written into any of this -- only a filed,
hash-frozen card that has been through this runner counts (sec.13 item 10).

-------------------------------------------------------------------------------------------------
INTERFACE this script actually calls on S2's two shared kernels (S2's files are read-only here,
per sec.13 item 4 -- "never re-implement"; confirmed directly against the real, landed S2 files
in this checkout, not assumed):

  Python (`scripts/executable/ir_eval.py`, a real submodule of the `scripts.executable` package
  -- `from . import ir_kernel` inside it, so it MUST be loaded package-aware, never as a flat
  file-path module; `_load_ir_eval_module` below registers a private, uniquely-named synthetic
  package pointing at `scripts/executable/` so that relative import resolves without colliding
  with any same-named package already on `sys.path` -- e.g. a `scripts` distribution installed
  in site-packages on this very workstation shadows a naive `sys.path`-based
  `from scripts.executable import ir_eval`, confirmed directly: this is exactly why
  `mcp/toledo_mcp/core.py` already avoids package-style imports for repo scripts):
      def evaluate(ir: dict, inputs: dict[str, str]) -> dict:
          # returns {"value": "<exact Fraction as string>",
          #          "terms_used": int | None, "error_bound": "<Fraction as string>" | None}

  JavaScript (`site/static/js/_qfrac.js` defines global `QFrac`; `site/static/js/_ir_eval.js`
  defines global `ToledoIREval = {evalNode, DEFAULT_TERMS, ...}` -- confirmed directly against
  the real, landed files): this file's own node driver (`_NODE_DRIVER_TEMPLATE` below) binds
  `inputs` via `QFrac.fromString`, calls `ToledoIREval.evalNode(ir.rhs, env, terms)` exactly the
  way `ir_eval.py::evaluate` calls `ir_kernel.eval_node`, and reports the result the same shape
  Python's `evaluate()` does. **Honest disclosure, not glossed over:** S2 shipped `_ir_eval.js` as
  the walker twin of `ir_kernel.py` only (sec.5's own words) -- there is no shipped JS
  counterpart of `ir_eval.py`'s own `_series_error_bound(fn, terms)` (a formula specific to the
  Python side's power-series/Newton truncation shape, which does not carry over to the JS side's
  entirely different continued-fraction algorithm family). For a TRANSCENDENTAL IR, this driver
  therefore computes the JS side's own `error_bound` EMPIRICALLY -- |evalNode(terms) -
  evalNode(terms + EMPIRICAL_SAFETY_TERMS)| * EMPIRICAL_SAFETY_FACTOR -- labelled, in the filed
  card's own `result.observed` rows, as `"error_bound_method": "empirical_doubling"` so a reader
  never mistakes it for a proven analytic bound the way the Python side's is. This is a real,
  disclosed gap (tier: Dr/heuristic on the JS side of a transcendental comparison only; the
  Q-exact comparison path below carries none of this and is fully exact on both sides), not a
  silent invention of new mathematics -- flagged in this stream's own final report for S2/a human
  reviewer to close with a real convergence-rate derivation per continued-fraction family.

This script never calls `Math.sin`/`mpmath`/a bare `float` itself -- it only shells out to the two
kernels above and compares the STRINGS they each return via `fractions.Fraction`, exactly once per
sample-input row, never re-deriving a value of its own (the empirical JS error-bound estimate
above re-uses `evalNode` twice at different `terms`, never a value of its own either).
-------------------------------------------------------------------------------------------------

Reads only:
  - registry/executable/<mangled-code>.json   the IR sidecar (S1/S2's contract, sec.3)
  - scripts/executable/ir_eval.py             S2's Python reference (imported by file path,
                                                mirroring mcp/toledo_mcp/core.py's own
                                                `_toledo_build()` convention for a repo script that
                                                is not an installed package)
  - site/static/js/_qfrac.js + _ir_eval.js    S2's JS twin, run headlessly via `node`

Writes only:
  - <glosa-repo>/cases/repro/EXEC-<mangled-code>.json   one card per processed code

Never touches `scripts/register_reproduction_evidence.py` (reads its unmodified output on a later
pipeline stage) and never re-implements `ir_eval.py`/`_ir_eval.js` (sec.13 item 4). Pure Python 3
stdlib in this driver process itself; `node` is invoked as a declared subprocess exactly the way a
Reproduction Card names an external oracle command (`environment.packages: {}`, `node` named only
in `run.command`, never as a Python package).

Usage:
  python3 scripts/executable/crosscheck_runner.py --code EQ-045/P.03.v1 [--glosa-repo PATH]
  python3 scripts/executable/crosscheck_runner.py --all-reviewed [--glosa-repo PATH] [--dry-run]

Exit codes: 0 = ran (regardless of individual PASS/FAIL/ERROR verdicts -- those are this script's
own honestly-computed fields, never hidden by a nonzero exit). 2 = a named RunnerError (no sidecar,
wrong sidecar status, S2 dependency missing, `node` not runnable, glosa checkout not a git repo) --
fail-closed, never a silent skip and never a raw traceback.
"""
from __future__ import annotations

import argparse
import datetime
import hashlib
import importlib.util
import json
import pathlib
import subprocess
import sys
import tempfile
from fractions import Fraction

REPO_ROOT = pathlib.Path(__file__).resolve().parents[2]
_IR_EVAL_PKG_NAME = "_toledo_executable_pkg_for_crosscheck"

# JS-side transcendental error_bound is empirical (module docstring above) -- these two constants
# are this driver's own, honestly-disclosed choice, never read back from the IR sidecar (which
# carries only default_terms, sec.3).
_EMPIRICAL_SAFETY_TERMS = 5
_EMPIRICAL_SAFETY_FACTOR = 4


class RunnerError(Exception):
    """A named, fail-closed condition -- never a raw traceback, never a silent skip."""


def now_iso() -> str:
    return datetime.datetime.now(datetime.timezone.utc).isoformat()


def mangle_code(code: str) -> str:
    """registry/SCHEMA.md's own filesystem-safe mangling rule (BBL-182), reused verbatim."""
    return code.replace("/", "__").replace(".", "_").replace("-", "_")


# ---------------------------------------------------------------------------
# Sidecar loading
# ---------------------------------------------------------------------------

def load_sidecar_by_code(executable_dir: pathlib.Path, code: str) -> dict:
    path = executable_dir / f"{mangle_code(code)}.json"
    if not path.is_file():
        raise RunnerError(f"no IR sidecar for {code!r} at {path}")
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        raise RunnerError(f"sidecar {path} is not valid JSON: {exc}") from exc


def load_all_reviewed_sidecars(executable_dir: pathlib.Path) -> "list[dict]":
    sidecars = []
    if not executable_dir.is_dir():
        return sidecars
    for path in sorted(executable_dir.glob("*.json")):
        if path.name == "INDEX.json":
            continue
        try:
            doc = json.loads(path.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            continue
        if doc.get("status") in ("reviewed_eligible", "built") and doc.get("code"):
            sidecars.append(doc)
    return sidecars


def require_eligible(sidecar: dict) -> None:
    status = sidecar.get("status")
    if status not in ("reviewed_eligible", "built"):
        code = sidecar.get("code", "<unknown>")
        raise RunnerError(
            f"{code}: sidecar status is {status!r}, not 'reviewed_eligible' or 'built' -- "
            "refusing to write a card (sec.6 step 1)"
        )


# ---------------------------------------------------------------------------
# Python reference evaluator (S2's ir_eval.py, imported by file path -- never re-implemented)
# ---------------------------------------------------------------------------

def _load_ir_eval_module(ir_eval_path: pathlib.Path):
    """Loads `ir_eval.py` as a real submodule of a private, uniquely-named synthetic package
    rooted at `ir_eval_path.parent` -- NOT a flat file-path module -- because `ir_eval.py` itself
    does `from . import ir_kernel` (confirmed directly against the real S2 file), which only
    resolves when the module has a genuine parent package with a correct `__path__`. A naive
    `sys.path.insert(0, repo_root); from scripts.executable import ir_eval` was tried first and
    fails on THIS workstation: a `scripts` distribution already installed in site-packages
    shadows the repo's own `scripts/` directory (confirmed: `import scripts; scripts.__path__`
    resolves to the installed one, not this checkout) -- exactly the class of collision
    `mcp/toledo_mcp/core.py::_toledo_build` already avoids for `toledo_build.py` by the same
    file-path-loading technique, generalised here to a package with an internal relative
    import."""
    if not ir_eval_path.is_file():
        raise RunnerError(
            f"S2 dependency missing: {ir_eval_path} does not exist yet. This runner never "
            "re-implements the Python reference evaluator (sec.13 item 4) -- build S2 first."
        )
    executable_dir = ir_eval_path.parent
    init_path = executable_dir / "__init__.py"
    # `__init__.py` may legitimately be absent (e.g. a test-fixture directory standing in for
    # S2's own `scripts/executable/`, which does carry one) -- pass location=None in that case,
    # which importlib treats as a namespace package with no code to execute, still carrying a
    # real `__path__` so the relative `from . import ir_kernel` below still resolves.
    pkg_location = str(init_path) if init_path.is_file() else None

    if _IR_EVAL_PKG_NAME not in sys.modules:
        pkg_spec = importlib.util.spec_from_file_location(
            _IR_EVAL_PKG_NAME, pkg_location, submodule_search_locations=[str(executable_dir)],
        )
        if pkg_spec is None:
            raise RunnerError(f"cannot construct a package spec for {executable_dir}")
        pkg_module = importlib.util.module_from_spec(pkg_spec)
        sys.modules[_IR_EVAL_PKG_NAME] = pkg_module
        if pkg_spec.loader is not None:
            try:
                pkg_spec.loader.exec_module(pkg_module)
            except Exception as exc:  # noqa: BLE001
                del sys.modules[_IR_EVAL_PKG_NAME]
                raise RunnerError(f"{init_path} raised on import: {exc}") from exc

    full_name = f"{_IR_EVAL_PKG_NAME}.ir_eval"
    if full_name not in sys.modules:
        spec = importlib.util.spec_from_file_location(full_name, ir_eval_path)
        if spec is None or spec.loader is None:
            raise RunnerError(f"cannot load {ir_eval_path} as a Python module")
        mod = importlib.util.module_from_spec(spec)
        sys.modules[full_name] = mod
        try:
            spec.loader.exec_module(mod)
        except Exception as exc:  # noqa: BLE001 -- surfaced as a named RunnerError, never swallowed
            del sys.modules[full_name]
            raise RunnerError(f"{ir_eval_path} raised on import: {exc}") from exc
    mod = sys.modules[full_name]
    if not hasattr(mod, "evaluate"):
        raise RunnerError(f"{ir_eval_path} has no top-level evaluate(ir, inputs) function "
                           "(this runner's own documented interface contract, module docstring)")
    return mod


def run_python_reference(ir_eval_path: pathlib.Path, ir: dict, inputs: "dict[str, str]") -> dict:
    mod = _load_ir_eval_module(ir_eval_path)
    try:
        return mod.evaluate(ir, inputs)
    except Exception as exc:  # noqa: BLE001
        raise RunnerError(f"Python reference evaluate() raised: {exc}") from exc


# ---------------------------------------------------------------------------
# JavaScript twin (S2's _qfrac.js + _ir_eval.js, run headlessly via node -- a subprocess
# invocation of the shipped browser file, never a second implementation)
# ---------------------------------------------------------------------------

_NODE_DRIVER_TEMPLATE = """
const fs = require('fs');
const qfracSrc = fs.readFileSync(process.argv[2], 'utf8');
const irEvalSrc = fs.readFileSync(process.argv[3], 'utf8');
eval(qfracSrc);
eval(irEvalSrc);
const ir = JSON.parse(fs.readFileSync(process.argv[4], 'utf8'));
const inputs = JSON.parse(fs.readFileSync(process.argv[5], 'utf8'));
const EMPIRICAL_SAFETY_TERMS = %(safety_terms)d;
const EMPIRICAL_SAFETY_FACTOR = %(safety_factor)d;

// Small binding glue (this file's own, per crosscheck_runner.py's module docstring) around the
// shipped walker -- never a re-implementation of evalNode/QFrac themselves. Mirrors
// ir_eval.py::evaluate's own structure: bind inputs -> pick terms -> call the shared walker.
function bindEnv(ir, inputsObj) {
    const env = {};
    for (const v of ir.variables) {
        if (v.role !== 'input') continue;
        if (!(v.name in inputsObj)) {
            throw new Error('missing required input "' + v.name + '"');
        }
        env[v.name] = (typeof QFrac.fromString === 'function') ? QFrac.fromString(String(inputsObj[v.name]))
                                                                : new QFrac(String(inputsObj[v.name]));
    }
    return env;
}

let result;
try {
    const K = (typeof ToledoIREval !== 'undefined') ? ToledoIREval : null;
    if (!K || typeof K.evalNode !== 'function') {
        throw new Error('_ir_eval.js does not define global ToledoIREval.evalNode(node, env, terms)');
    }
    const env = bindEnv(ir, inputs);
    const transcendental = ir.transcendental || null;
    const terms = transcendental ? Number(transcendental.default_terms) : (K.DEFAULT_TERMS || 30);
    const value = K.evalNode(ir.rhs, env, terms);

    if (!transcendental) {
        result = {value: value.toString(), terms_used: null, error_bound: null};
    } else {
        // EMPIRICAL error_bound (crosscheck_runner.py module docstring's own disclosed gap: S2
        // shipped no JS-side counterpart of ir_eval.py's analytic _series_error_bound formula,
        // which is specific to the Python side's power-series/Newton shape anyway) -- bound the
        // truncation error by a safety-factor multiple of the observed change between `terms`
        // and `terms + EMPIRICAL_SAFETY_TERMS` more terms of the SAME algorithm, never a value
        // asserted without evidence.
        const valueMore = K.evalNode(ir.rhs, env, terms + EMPIRICAL_SAFETY_TERMS);
        const diffNum = value.num * valueMore.den - valueMore.num * value.den;
        const diffDen = value.den * valueMore.den;
        const absDiffNum = diffNum < 0n ? -diffNum : diffNum;
        const boundNum = absDiffNum * BigInt(EMPIRICAL_SAFETY_FACTOR);
        const boundDen = diffDen < 0n ? -diffDen : diffDen;
        const bound = new QFrac(boundNum, boundDen === 0n ? 1n : boundDen);
        result = {
            value: value.toString(), terms_used: terms, error_bound: bound.toString(),
            error_bound_method: 'empirical_doubling',
        };
    }
} catch (e) {
    process.stderr.write('RunnerError: ' + (e && e.stack || e));
    process.exit(2);
}
process.stdout.write(JSON.stringify(result));
""" % {"safety_terms": _EMPIRICAL_SAFETY_TERMS, "safety_factor": _EMPIRICAL_SAFETY_FACTOR}


def run_js_twin(node_bin: str, qfrac_path: pathlib.Path, ir_eval_js_path: pathlib.Path,
                 ir: dict, inputs: "dict[str, str]") -> dict:
    for p, label in ((qfrac_path, "_qfrac.js"), (ir_eval_js_path, "_ir_eval.js")):
        if not p.is_file():
            raise RunnerError(
                f"S2 dependency missing: {p} ({label}) does not exist yet. This runner never "
                "re-implements the JS twin (sec.13 item 4) -- build S2 first."
            )
    try:
        subprocess.run([node_bin, "--version"], capture_output=True, check=True)
    except (OSError, subprocess.CalledProcessError) as exc:
        raise RunnerError(f"'{node_bin}' is not runnable on this workstation: {exc}") from exc

    with tempfile.TemporaryDirectory(prefix="toledo_exec_crosscheck_") as tmp:
        tmp_path = pathlib.Path(tmp)
        driver = tmp_path / "driver.js"
        ir_file = tmp_path / "ir.json"
        inputs_file = tmp_path / "inputs.json"
        driver.write_text(_NODE_DRIVER_TEMPLATE, encoding="utf-8")
        ir_file.write_text(json.dumps(ir), encoding="utf-8")
        inputs_file.write_text(json.dumps(inputs), encoding="utf-8")

        proc = subprocess.run(
            [node_bin, str(driver), str(qfrac_path), str(ir_eval_js_path), str(ir_file), str(inputs_file)],
            capture_output=True, text=True,
        )
        if proc.returncode != 0:
            raise RunnerError(f"JS twin (node) failed: {proc.stderr.strip() or proc.stdout.strip()}")
        try:
            return json.loads(proc.stdout)
        except json.JSONDecodeError as exc:
            raise RunnerError(f"JS twin produced non-JSON stdout: {proc.stdout!r}") from exc


# ---------------------------------------------------------------------------
# Comparison -- exact for a Q-exact node, error-bound for a transcendental one. Never "close
# enough" by eyeball; always fractions.Fraction, never float.
# ---------------------------------------------------------------------------

def compare_row(py_result: dict, js_result: dict, transcendental: "dict | None") -> dict:
    py_value = Fraction(str(py_result.get("value")))
    js_value = Fraction(str(js_result.get("value")))

    if transcendental is None:
        status = "PASS" if py_value == js_value else "FAIL"
        return {
            "status": status,
            "python_value": str(py_value),
            "js_value": str(js_value),
            "error_bound_used": None,
        }

    py_bound = py_result.get("error_bound")
    js_bound = js_result.get("error_bound")
    if py_bound is None or js_bound is None:
        return {
            "status": "ERROR",
            "python_value": str(py_value),
            "js_value": str(js_value),
            "error_bound_used": None,
            "error": "transcendental IR but one or both evaluators returned error_bound: null",
        }
    bound = max(Fraction(str(py_bound)), Fraction(str(js_bound)))
    delta = abs(py_value - js_value)
    status = "PASS" if delta <= bound else "FAIL"
    return {
        "status": status,
        "python_value": str(py_value),
        "js_value": str(js_value),
        "delta": str(delta),
        "error_bound_used": str(bound),
    }


def overall_status(row_results: "list[dict]") -> str:
    """ERROR beats FAIL beats PASS is the wrong precedence for an already-disclosed FAIL (P22:
    'a FAIL result is never retried, re-tuned, or silently converted to ERROR to avoid reporting
    it') -- so a genuine FAIL always wins over a co-occurring ERROR on a DIFFERENT row; only when
    there is no FAIL at all does any ERROR promote the overall verdict above PASS."""
    statuses = {r["status"] for r in row_results}
    if "FAIL" in statuses:
        return "FAIL"
    if "ERROR" in statuses:
        return "ERROR"
    return "PASS"


# ---------------------------------------------------------------------------
# CES / lineage block -- glosa CLAUDE.md rule 9 (no AI vendor name; role only), matching
# cases/repro/IDM_ladder_constants.json's own already-filed convention exactly.
# ---------------------------------------------------------------------------

def build_ces(code: str) -> dict:
    return {
        "respondent": (
            "S3 builder stream (toledo repo) -- wrote and ran "
            "scripts/executable/crosscheck_runner.py against this code's IR sidecar; no "
            "lived-experience/standpoint judgment entered this mechanical comparison"
        ),
        "interactional": "None",
        "ai_models": [
            {
                "model": "AI assistant (session-local)",
                "role": (
                    f"wrote scripts/executable/crosscheck_runner.py, invoked it against the IR "
                    f"sidecar for {code}, and authored this card's JSON -- no vendor/model name "
                    "per glosa AGENTS.md rule 9 (no explicit founder permission granted for this "
                    "artifact)"
                ),
            }
        ],
    }


# ---------------------------------------------------------------------------
# Card assembly (schema/reproduction_card.schema.json shape)
# ---------------------------------------------------------------------------

def sha256_hex(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def build_card(sidecar: dict, row_results: "list[dict]", sample_inputs: "list[dict]",
               declared_at: str, run_date: str, input_hash: str, output_hash: str,
               run_by: str) -> dict:
    code = sidecar["code"]
    transcendental = sidecar.get("transcendental")
    status = overall_status(row_results)

    if transcendental is None:
        tolerance = (
            "exact categorical match (PASS/FAIL -- no numeric band): PASS iff, for every row in "
            "sample_inputs, the Python reference (fractions.Fraction) and the JavaScript twin "
            "(BigInt-rational) return the identical exact rational value"
        )
    else:
        fn = transcendental.get("fn") if isinstance(transcendental, dict) else None
        tolerance = (
            f"transcendental comparison (fn={fn!r}, IR default_terms="
            f"{(transcendental or {}).get('default_terms')!r}): PASS iff, for every row in "
            "sample_inputs, |python_value - js_value| <= max(python error_bound, js error_bound) "
            "as each evaluator itself reports for its own truncation -- never a numeric bound "
            "invented ahead of the run beyond this rule"
        )

    card = {
        "$schema": "reproduction_card.schema.json",
        "id": f"EXEC-{mangle_code(code)}",
        "toledo_codes": [code],
        "claim": (
            f"Toledo {code}: the reviewed-eligible IR sidecar's Python reference evaluator "
            "(scripts/executable/ir_eval.py, fractions.Fraction only) and its JavaScript twin "
            "(site/static/js/_ir_eval.js, BigInt-rational only, a genuinely different algorithm "
            "family per transcendental function where applicable) agree on every pre-registered "
            "sample_inputs row"
        ),
        "preregistered_prediction": {
            "statement": (
                f"For code {code}, sample_inputs = {json.dumps(sample_inputs)}: the Python "
                "reference and the JavaScript twin, run independently against identical inputs, "
                "produce agreeing results per the tolerance rule stated below."
            ),
            "tolerance": tolerance,
            "declared_at": declared_at,
        },
        "oracle": {
            "kind": "independent_implementation",
            "source": (
                "site/static/js/_ir_eval.js twin, run via node -- a different algorithm family "
                "per transcendental.algorithm_js than the Python reference (see this code's own "
                "IR sidecar, registry/executable/" + mangle_code(code) + ".json)"
            ),
            "doi_or_url": None,
            "version": None,
        },
        "environment": {"python": ".".join(str(v) for v in sys.version_info[:3]), "packages": {}},
        "run": {
            "command": f"python3 scripts/executable/crosscheck_runner.py --code {code}",
            "input_hash": input_hash,
            "output_hash": output_hash,
            "ai_at_runtime": 0,
            "date": run_date,
        },
        "result": {
            "status": status,
            "observed": row_results,
            "deviation": (
                "all rows agree within the pre-registered rule" if status == "PASS"
                else "see 'observed' -- at least one row did not"
            ),
        },
        "lineage": {"run_by": run_by, "ces": build_ces(code)},
        "notes": (
            "Mechanically generated by scripts/executable/crosscheck_runner.py "
            f"(docs/EXECUTABLE_EQUATIONS_v0_1.md sec.6) -- never hand-typed; the IR sidecar this "
            f"card checks was extracted at commit {sidecar.get('generated_from_commit')!r} via "
            f"{(sidecar.get('classifier') or {}).get('tool')!r}."
        ),
    }
    return card


# ---------------------------------------------------------------------------
# Per-code orchestration
# ---------------------------------------------------------------------------

def process_code(sidecar: dict, *, ir_eval_path: pathlib.Path, qfrac_path: pathlib.Path,
                  ir_eval_js_path: pathlib.Path, node_bin: str, run_by: str) -> "tuple[dict, dict]":
    """Returns (card, summary). Raises RunnerError on any fail-closed condition; a genuine
    PASS/FAIL/ERROR comparison result is NOT a RunnerError -- it is filed, honestly, in the card."""
    require_eligible(sidecar)
    code = sidecar["code"]
    sample_inputs = sidecar.get("sample_inputs") or []
    if not sample_inputs:
        raise RunnerError(f"{code}: sidecar has no sample_inputs -- nothing pre-registered to run")
    transcendental = sidecar.get("transcendental")

    declared_at = now_iso()  # pre-registered BEFORE any evaluator is called (sec.6 step 2)

    row_results = []
    ir_for_eval = {k: v for k, v in sidecar.items()}  # the IR itself is the sidecar's own tree
    for row in sample_inputs:
        inputs = {str(k): str(v) for k, v in row.items()}
        try:
            py_result = run_python_reference(ir_eval_path, ir_for_eval, inputs)
            js_result = run_js_twin(node_bin, qfrac_path, ir_eval_js_path, ir_for_eval, inputs)
        except RunnerError as exc:
            row_results.append({"status": "ERROR", "inputs": inputs, "error": str(exc)})
            continue
        cmp_row = compare_row(py_result, js_result, transcendental)
        cmp_row["inputs"] = inputs
        row_results.append(cmp_row)

    run_date = now_iso()
    output_hash = sha256_hex(json.dumps(row_results, sort_keys=True).encode("utf-8"))
    input_hash = sha256_hex(json.dumps(sidecar, sort_keys=True).encode("utf-8"))

    card = build_card(sidecar, row_results, sample_inputs, declared_at, run_date,
                       input_hash, output_hash, run_by)
    summary = {"code": code, "status": card["result"]["status"], "rows": len(row_results)}
    return card, summary


def write_card(glosa_repo: pathlib.Path, card: dict, *, dry_run: bool) -> pathlib.Path:
    out_path = glosa_repo / "cases" / "repro" / f"{card['id']}.json"
    if not dry_run:
        out_path.parent.mkdir(parents=True, exist_ok=True)
        out_path.write_text(json.dumps(card, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    return out_path


def require_glosa_repo(glosa_repo: pathlib.Path) -> None:
    if not (glosa_repo / ".git").exists():
        raise RunnerError(f"{glosa_repo} is not a git repository (no .git) -- refusing to write a "
                           "card into a non-checkout directory")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main(argv: "list[str] | None" = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    group = ap.add_mutually_exclusive_group(required=True)
    group.add_argument("--code", help="one Toledo code to cross-check")
    group.add_argument("--all-reviewed", action="store_true",
                        help="cross-check every reviewed_eligible/built sidecar")
    ap.add_argument("--glosa-repo", type=pathlib.Path, default=REPO_ROOT.parent / "glosa")
    ap.add_argument("--executable-dir", type=pathlib.Path, default=REPO_ROOT / "registry" / "executable")
    ap.add_argument("--ir-eval-path", type=pathlib.Path,
                     default=REPO_ROOT / "scripts" / "executable" / "ir_eval.py")
    ap.add_argument("--qfrac-path", type=pathlib.Path,
                     default=REPO_ROOT / "site" / "static" / "js" / "_qfrac.js")
    ap.add_argument("--ir-eval-js-path", type=pathlib.Path,
                     default=REPO_ROOT / "site" / "static" / "js" / "_ir_eval.js")
    ap.add_argument("--node-bin", default="node")
    ap.add_argument("--run-by", default="S3 builder stream (toledo repo)")
    ap.add_argument("--dry-run", action="store_true",
                     help="run every comparison for real but do not write into --glosa-repo")
    args = ap.parse_args(argv)

    try:
        if not args.dry_run:
            require_glosa_repo(args.glosa_repo)

        if args.code:
            sidecars = [load_sidecar_by_code(args.executable_dir, args.code)]
        else:
            sidecars = load_all_reviewed_sidecars(args.executable_dir)

        if not sidecars:
            print(json.dumps({"processed": 0, "cards_written": 0, "summaries": [],
                               "note": "no reviewed_eligible/built sidecar found"}, indent=2))
            return 0

        summaries = []
        cards_written = 0
        for sidecar in sidecars:
            card, summary = process_code(
                sidecar, ir_eval_path=args.ir_eval_path, qfrac_path=args.qfrac_path,
                ir_eval_js_path=args.ir_eval_js_path, node_bin=args.node_bin, run_by=args.run_by,
            )
            out_path = write_card(args.glosa_repo, card, dry_run=args.dry_run)
            summary["card_path"] = str(out_path.relative_to(args.glosa_repo)) if not args.dry_run else None
            summaries.append(summary)
            if not args.dry_run:
                cards_written += 1

        print(json.dumps({"processed": len(summaries), "cards_written": cards_written,
                           "dry_run": args.dry_run, "summaries": summaries}, indent=2))
        return 0
    except RunnerError as exc:
        print(f"RunnerError: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main())
