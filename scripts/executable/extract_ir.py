#!/usr/bin/env python3
r"""scripts/executable/extract_ir.py — S1, IR extraction.

docs/EXECUTABLE_EQUATIONS_v0_1.md sec.3 (IR schema), sec.10 (stream S1).

Reads this run's `scripts/executable/_classify_output.json` (classify.py)
and, for the entries classified `eq_structured` and NOT flagged by
classify.py's own prose-contamination heuristic, attempts a MECHANICAL
conversion of the parsed sympy `Eq` into the small generic AST sec.3
defines (`add|sub|mul|div|pow|neg|const|var|call`), then writes ONE small
IR sidecar per successfully-converted entry to
`registry/executable/<mangled-code>.json`.

**Every sidecar this script writes has `status: "candidate"` and
`eligibility.reviewed_by: null` — no exception, ever** (sec.3, sec.13 item
2: "No auto-promotion from a classifier's raw output"). This script is not
a registrar; a human is the only writer of `reviewed_eligible` /
`reviewed_rejected`.

Two extra, DISCLOSED risk checks run beyond classify.py's own heuristic,
because direct inspection of this run's own "not prose-flagged" set found
real problems classify.py's heuristic does not catch (see
ops/executable_classifier_report.md's "IR extraction pass" section for the
concrete examples this was measured against, not assumed):

  1. **Bare (un-escaped) multi-letter word risk.** A source LaTeX/ascii
     string with a run of 2+ plain letters not preceded by a backslash and
     not one of a small allowlisted function/operator name (e.g. "Gamma_R"
     or "tau_c" or "pi" typed without "\") is a known-live failure mode:
     sympy's `parse_latex` shatters exactly that word into a product of its
     own single letters, silently corrupting one term while leaving the
     rest of the equation looking fine. Flagged as `bare_word_risk` in the
     drift_note; the sidecar is still written (a human, not this script,
     makes the call — sec.13 item 2), but the risk is not swallowed.
  2. **Multi-letter superscript-as-exponent risk.** A raw `^{<2+ letters>}`
     block (e.g. `\mu_t^{eff}`, `\pi_t^{RET}`) is ambiguous between "a
     label" and "an exponent"; sympy's grammar reads it as the latter
     unconditionally, changing the statement's meaning. Flagged as
     `superscript_label_risk`.

A THIRD, purely-internal cross-check also runs and is NOT a substitute for
either of the above: after converting sympy's parsed RHS into this
script's own AST, the AST is converted back to a sympy expression
(`node_to_sympy`, the exact inverse vocabulary) and checked for exact
symbolic equality (`sympy.simplify(reconstructed - original) == 0`)
against the ORIGINAL PARSED expression — never against the source text.
This only certifies "this script's own JSON round-trips through sympy
without losing/changing the math sympy itself already parsed" — it is
explicitly NOT the sec.6 Python-reference-vs-JS-twin cross-check (which
needs S2's ir_kernel.py/_ir_eval.js, neither of which exists yet), and it
is never used as if it were R3/R4 evidence. Its own PASS/FAIL is what this
run reports as its "cross-checks run" count.

**No second, parallel interpreter is written here** (sec.13 item 4):
`node_to_sympy` reconstructs a sympy expression to ask sympy itself whether
two sympy objects are equal — it never evaluates the IR independently of
sympy, and it is not `ir_kernel.py`/`ir_eval.py` (S2 owns those, not yet
built).

Writes:
  - registry/executable/<mangled-code>.json   (status "candidate" only)
  - appends an "## IR extraction pass" section (replacing any previous one
    from an earlier run of this script) to
    ops/executable_classifier_report.md

Never writes registry/CANONICAL.json, registry/entries/*.json, ir_kernel.py,
ir_eval.py, or anything under site/ or mcp/ (those are S2/S3/S4, sec.10).
"""
from __future__ import annotations

import datetime
import json
import pathlib
import re
import subprocess
import sys

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent.parent
CLASSIFY_OUTPUT = pathlib.Path(__file__).resolve().parent / "_classify_output.json"
EXECUTABLE_DIR = REPO_ROOT / "registry" / "executable"
REPORT_MD = REPO_ROOT / "ops" / "executable_classifier_report.md"

# Loaded by file path (sibling of this script, same directory), not `from scripts.executable
# import ir_kernel` -- this workstation demonstrates a real collision (a third-party `scripts`
# package installed in site-packages shadows this repository's own top-level `scripts/`
# directory once any sys.path entry ahead of the repo root supplies one), so a package-style
# import is not reliable here (the same reason ir_eval.py/crosscheck_runner.py/
# test_ir_kernel.py all avoid it too). `ir_kernel.py` is the SOLE source of truth for which
# algorithm family each interpreter implements per transcendental `fn` (sec.3/sec.5) -- this
# extractor never drafts its own competing pair (Integration fix, 2026-09-08: a prior
# `DRAFT_ALGORITHMS` dict here disagreed with `ir_kernel.ALGORITHM_FAMILY_PY`/`_JS` for every
# single function, which `ir_eval.py::check_transcendental_lint` would have rejected the moment
# a human tried to promote a transcendental candidate to `reviewed_eligible`).
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
import ir_kernel  # noqa: E402

SCHEMA_VERSION = "executable-ir-0.1"

# The exact vocabulary the shared kernels (ir_kernel.py / _ir_eval.js) actually implement
# (ir_kernel.ALLOWED_FNS) plus the ordinary Q-exact functions sympy may represent as an
# explicit Function node. `tan`, `abs`, and `e_const` were REMOVED here (Integration fix,
# 2026-09-08): neither kernel implements them, so an IR sidecar naming any of the three could
# never be evaluated by ir_eval.py/_ir_eval.js/toledo_eval, permanently -- a statement using one
# of them is correctly rejected by `sympy_to_node` (`Unsupported`) rather than silently drafted
# into a dead sidecar. Widening this list is a reviewed, two-file change to `ir_kernel.py` +
# `_ir_eval.js` first (sec.2's architecture ruling), never a unilateral addition here.
ALLOWED_FUNCTIONS = {"sin", "cos", "exp", "log", "sqrt"}
# fn names that are not Q-exact and need a `transcendental` block (sec.3) -- kept identical to
# `ir_kernel.ALLOWED_FNS` by construction (asserted below), the same "one shared vocabulary"
# guarantee sec.2 requires.
TRANSCENDENTAL_FUNCTIONS = {"sin", "cos", "exp", "log", "sqrt", "pi_const"}
assert TRANSCENDENTAL_FUNCTIONS == set(ir_kernel.ALLOWED_FNS), (
    "extract_ir.py's own transcendental vocabulary has drifted from ir_kernel.ALLOWED_FNS -- "
    "widen/narrow both together, never one alone"
)

_BARE_WORD = re.compile(r"(?<!\\)(?<![A-Za-z])[A-Za-z]{2,}(?![A-Za-z])")
_SAFE_BARE_WORDS = {
    "sin", "cos", "tan", "cot", "sec", "csc", "sinh", "cosh", "tanh",
    "exp", "log", "ln", "sqrt", "min", "max", "arg", "det", "dim", "gcd",
    "lcm", "inf", "sup", "lim", "cdot", "times", "div", "mod", "text",
    "left", "right", "frac", "quad", "qquad", "displaystyle",
}
_MULTI_LETTER_SUPERSCRIPT = re.compile(r"\^\{[A-Za-z]{2,}\}")


class Unsupported(Exception):
    pass


def bare_word_risk(source_text: str) -> list[str]:
    hits = []
    for m in _BARE_WORD.finditer(source_text):
        word = m.group(0)
        if word.lower() not in _SAFE_BARE_WORDS:
            hits.append(word)
    return sorted(set(hits))


def superscript_label_risk(source_text: str) -> list[str]:
    return sorted(set(_MULTI_LETTER_SUPERSCRIPT.findall(source_text)))


# --------------------------------------------------------------------------
# sympy Expr -> generic AST (sec.3's node vocabulary)
# --------------------------------------------------------------------------

def rational_str(value) -> str:
    if value.is_Integer:
        return str(int(value))
    p, q = value.as_numer_denom()
    return f"{int(p)}/{int(q)}"


def sympy_to_node(expr, used_fns: set) -> dict:
    import sympy

    if expr.is_Symbol:
        return {"op": "var", "name": str(expr)}

    if expr == sympy.pi:
        used_fns.add("pi_const")
        return {"op": "call", "fn": "pi_const", "args": []}
    if expr == sympy.E:
        # Neither ir_kernel.py nor _ir_eval.js implements a bare Euler's-number constant fn
        # (Integration fix, 2026-09-08 -- ir_kernel.ALLOWED_FNS has no "e_const"; only `exp(x)`
        # is supported, handled separately below via the is_Pow/base==sympy.E branch). Reject
        # here rather than draft a sidecar the shared kernel can never evaluate.
        raise Unsupported("bare Euler's number 'e' has no shared-kernel fn (e_const is not "
                           "implemented by ir_kernel.py/_ir_eval.js); rewrite as exp(1) if "
                           "that is what the source statement means")

    if expr.is_Rational:  # covers Integer and Rational, not Float
        return {"op": "const", "value": rational_str(expr)}
    if expr.is_Float:
        raise Unsupported(f"float literal {expr} — no float ever allowed in the IR")

    if expr.is_Add:
        args = list(expr.args)
        node = sympy_to_node(args[0], used_fns)
        for a in args[1:]:
            coeff, _rest = a.as_coeff_Mul()
            if coeff.is_negative:
                node = {"op": "sub", "args": [node, sympy_to_node(-a, used_fns)]}
            else:
                node = {"op": "add", "args": [node, sympy_to_node(a, used_fns)]}
        return node

    if expr.is_Mul:
        factors = list(expr.args)
        neg = False
        if factors and factors[0] == -1:
            neg = True
            factors = factors[1:]
        num_factors, den_factors = [], []
        for f in factors:
            if f.is_Pow and f.args[1].is_Rational and f.args[1].is_negative:
                den_factors.append(sympy.Pow(f.args[0], -f.args[1]))
            else:
                num_factors.append(f)
        if not num_factors:
            num_node = {"op": "const", "value": "1"}
        else:
            num_node = sympy_to_node(num_factors[0], used_fns)
            for f in num_factors[1:]:
                num_node = {"op": "mul", "args": [num_node, sympy_to_node(f, used_fns)]}
        if den_factors:
            den_node = sympy_to_node(den_factors[0], used_fns)
            for f in den_factors[1:]:
                den_node = {"op": "mul", "args": [den_node, sympy_to_node(f, used_fns)]}
            node = {"op": "div", "args": [num_node, den_node]}
        else:
            node = num_node
        return {"op": "neg", "args": [node]} if neg else node

    if expr.is_Pow:
        base, exp = expr.args
        if base == sympy.E:
            used_fns.add("exp")
            return {"op": "call", "fn": "exp", "args": [sympy_to_node(exp, used_fns)]}
        if exp == sympy.Rational(1, 2):
            used_fns.add("sqrt")
            return {"op": "call", "fn": "sqrt", "args": [sympy_to_node(base, used_fns)]}
        if exp.is_Integer:
            return {"op": "pow", "args": [sympy_to_node(base, used_fns), sympy_to_node(exp, used_fns)]}
        raise Unsupported(f"non-integer, non-1/2 exponent {exp!r} in {expr!r}")

    if isinstance(expr, sympy.Function) or (hasattr(expr, "func") and hasattr(expr.func, "__name__")):
        fname = expr.func.__name__.lower()
        if fname not in ALLOWED_FUNCTIONS:
            raise Unsupported(f"function '{fname}' not in the allowlist {sorted(ALLOWED_FUNCTIONS)}")
        if len(expr.args) != 1:
            raise Unsupported(f"function '{fname}' called with {len(expr.args)} args, only arity-1 supported")
        used_fns.add(fname)
        return {"op": "call", "fn": fname, "args": [sympy_to_node(expr.args[0], used_fns)]}

    raise Unsupported(f"unhandled sympy node type {type(expr).__name__}: {expr!r}")


def node_to_sympy(node: dict):
    """Inverse of sympy_to_node, restricted to the SAME allowed vocabulary —
    used only to ask sympy whether this script's own JSON round-trips
    without changing the math sympy already parsed (this file's own
    cross-check; see module docstring). Not a second interpreter of the
    IR (sec.13 item 4) — it hands the question back to sympy itself."""
    import sympy

    op = node["op"]
    if op == "var":
        return sympy.Symbol(node["name"])
    if op == "const":
        return sympy.Rational(node["value"])
    if op == "call":
        fn = node["fn"]
        if fn == "pi_const":
            return sympy.pi
        arg = node_to_sympy(node["args"][0])
        return {"sin": sympy.sin, "cos": sympy.cos,
                "exp": sympy.exp, "log": sympy.log, "sqrt": sympy.sqrt}[fn](arg)
    if op == "neg":
        return -node_to_sympy(node["args"][0])
    if op == "add":
        a, b = node["args"]
        return node_to_sympy(a) + node_to_sympy(b)
    if op == "sub":
        a, b = node["args"]
        return node_to_sympy(a) - node_to_sympy(b)
    if op == "mul":
        a, b = node["args"]
        return node_to_sympy(a) * node_to_sympy(b)
    if op == "div":
        a, b = node["args"]
        return node_to_sympy(a) / node_to_sympy(b)
    if op == "pow":
        a, b = node["args"]
        return node_to_sympy(a) ** node_to_sympy(b)
    raise Unsupported(f"node_to_sympy: unhandled op {op!r}")


def mangle(code: str) -> str:
    return code.replace("/", "__").replace(".", "_").replace("-", "_")


_FIELD_TO_FORMAT = {"statement.latex": "latex+ascii", "statement.latest": "latex"}


def extract_one(entry: dict, commit: str, sympy_version: str, antlr4_version: str) -> dict:
    """Returns a result dict: {"code", "status": "written"|"skipped",
    "reason"?, "cross_check"?}. Never raises."""
    import sympy
    from sympy.parsing.latex import parse_latex

    code = entry["code"]
    text = entry["source_text"]
    result = {"code": code}

    try:
        expr = parse_latex(text)
    except Exception as exc:  # noqa: BLE001
        result["status"] = "skipped"
        result["reason"] = f"re-parse failed unexpectedly: {exc}"
        return result

    if not isinstance(expr, sympy.Eq):
        result["status"] = "skipped"
        result["reason"] = "not an Eq node on re-parse (classify.py's cached outcome is stale)"
        return result

    lhs, rhs = expr.lhs, expr.rhs
    if lhs.is_Symbol and not rhs.is_Symbol:
        output_symbol, formula_expr = lhs, rhs
    elif rhs.is_Symbol and not lhs.is_Symbol:
        output_symbol, formula_expr = rhs, lhs
    else:
        result["status"] = "skipped"
        result["reason"] = (
            "no isolated output variable on either side of the equation "
            "(neither side is a single bare symbol) — mechanically "
            "extracting which side is the computed output requires solving "
            "the relation, out of scope for this extractor"
        )
        return result

    used_fns: set = set()
    try:
        rhs_node = sympy_to_node(formula_expr, used_fns)
    except Unsupported as exc:
        result["status"] = "skipped"
        result["reason"] = f"AST conversion unsupported: {exc}"
        return result

    if len(used_fns & TRANSCENDENTAL_FUNCTIONS) > 1:
        result["status"] = "skipped"
        result["reason"] = (
            f"multiple distinct transcendental functions in one relation "
            f"({sorted(used_fns & TRANSCENDENTAL_FUNCTIONS)}) — drafting a "
            f"single algorithm-pair proposal for a mixed-transcendental "
            f"relation needs a human's own algorithm plan, out of scope "
            f"for a mechanical first pass"
        )
        return result

    # cross-check: does this script's own JSON round-trip through sympy
    # back to something sympy calls identical to what it originally parsed?
    try:
        reconstructed = node_to_sympy(rhs_node)
        cross_check = "PASS" if sympy.simplify(reconstructed - formula_expr) == 0 else "FAIL"
    except Exception as exc:  # noqa: BLE001
        cross_check = f"ERROR: {exc}"

    if cross_check != "PASS":
        result["status"] = "skipped"
        result["reason"] = f"round-trip cross-check did not pass: {cross_check}"
        result["cross_check"] = cross_check
        return result

    input_vars = sorted(str(s) for s in formula_expr.free_symbols)
    variables = [
        {"name": v, "domain": "Q", "role": "input", "unit": None, "constraint": None}
        for v in input_vars
    ]
    variables.append({
        "name": str(output_symbol), "domain": "Q", "role": "output",
        "unit": None, "constraint": None,
    })

    risks = []
    bw = bare_word_risk(text)
    if bw:
        risks.append(f"bare_word_risk: unescaped word(s) {bw} in source text may have been "
                      f"shattered into single-letter products by sympy's parser — CONFIRM "
                      f"parsed_repr against source_statement.text before any promotion")
    sl = superscript_label_risk(text)
    if sl:
        risks.append(f"superscript_label_risk: raw superscript block(s) {sl} — sympy always "
                      f"reads a multi-letter '^{{...}}' as an exponent; the source may have "
                      f"intended a LABEL (e.g. mu^eff), not a numeric power — CONFIRM before "
                      f"any promotion")

    transcendental = None
    used_transcendental = used_fns & TRANSCENDENTAL_FUNCTIONS
    if used_transcendental:
        fn = next(iter(used_transcendental))
        # Read verbatim from S2's own shared kernel (ir_kernel.py), NEVER drafted here
        # (Integration fix, 2026-09-08) — this is the one place these names are allowed to
        # come from, so a sidecar this script writes can never disagree with what
        # ir_eval.py::check_transcendental_lint will require at promotion/evaluation time.
        algo_py = ir_kernel.ALGORITHM_FAMILY_PY[fn]
        algo_js = ir_kernel.ALGORITHM_FAMILY_JS[fn]
        transcendental = {
            "terms_param": "n_terms",
            "algorithm_py": algo_py,
            "algorithm_js": algo_js,
            "default_terms": 40,
        }
        risks.append(
            f"transcendental_algorithm_families: algorithm_py='{algo_py}' / "
            f"algorithm_js='{algo_js}' for fn='{fn}' are read verbatim from S2's own shared "
            f"kernel (ir_kernel.ALGORITHM_FAMILY_PY/_JS) — CONFIRM the source statement "
            f"actually needs {fn!r} (not a different transcendental) before promotion"
        )

    drift_parts = [
        "Mechanically extracted candidate (S1, extract_ir.py). NOT reviewed. "
        "sample_inputs intentionally left empty (sec.3: human-declared at "
        "review time). variables[].domain defaulted to \"Q\" pending human "
        "confirmation of the true domain from the source statement. Output "
        "variable kept under its own parsed name (not renamed to a generic "
        "\"result\") for direct traceability back to source_statement.text.",
    ]
    drift_parts.extend(risks)
    drift_note = " ".join(drift_parts)

    sidecar = {
        "schema_version": SCHEMA_VERSION,
        "code": code,
        "root": entry.get("root") or code.split("/")[0],
        "generated_from_commit": commit,
        "source_statement": {
            "format": _FIELD_TO_FORMAT.get(entry["field_used"], entry["field_used"]),
            "text": text,
        },
        "classifier": {
            "tool": "sympy.parsing.latex.parse_latex",
            "sympy_version": sympy_version,
            "antlr4_version": antlr4_version,
            "parsed_at": datetime.date.today().isoformat(),
            "parsed_repr": str(expr),
        },
        "variables": variables,
        "relation": "eq",
        "lhs": {"op": "var", "name": str(output_symbol)},
        "rhs": rhs_node,
        "transcendental": transcendental,
        "eligibility": {
            "classifier_candidate": True,
            "reviewed_by": None,
            "reviewed_at": None,
            "review_note": None,
        },
        "sample_inputs": [],
        "status": "candidate",
        "drift_note": drift_note,
    }
    result["status"] = "written"
    result["cross_check"] = cross_check
    result["risks"] = [r.split(":")[0] for r in risks]
    result["sidecar"] = sidecar
    return result


def main() -> int:
    if not CLASSIFY_OUTPUT.exists():
        print("extract_ir.py: no _classify_output.json — run classify.py first.", file=sys.stderr)
        return 1

    doc = json.loads(CLASSIFY_OUTPUT.read_text())
    commit = doc["generated_from_commit"]
    sympy_version = doc["sympy_version"]
    antlr4_version = doc["antlr4_version"]

    candidates = [
        e for e in doc["entries"]
        if e.get("outcome") == "eq_structured" and not e.get("prose_heuristic_flag")
    ]

    EXECUTABLE_DIR.mkdir(parents=True, exist_ok=True)
    results = []
    for e in candidates:
        r = extract_one(e, commit, sympy_version, antlr4_version)
        results.append(r)
        if r["status"] == "written":
            sidecar = r.pop("sidecar")
            out_path = EXECUTABLE_DIR / f"{mangle(r['code'])}.json"
            out_path.write_text(json.dumps(sidecar, indent=2, ensure_ascii=False) + "\n")
            print(f"WROTE  {out_path.relative_to(REPO_ROOT)}  cross_check={r['cross_check']} "
                  f"risks={r.get('risks') or 'none'}")
        else:
            print(f"SKIP   {r['code']}  — {r['reason']}")

    written = [r for r in results if r["status"] == "written"]
    skipped = [r for r in results if r["status"] == "skipped"]
    passes = sum(1 for r in written if r.get("cross_check") == "PASS")

    print()
    print(f"candidates considered (eq_structured, not prose-flagged): {len(candidates)}")
    print(f"IR sidecars written (status=candidate):                   {len(written)}")
    print(f"skipped (mechanical extraction not attempted/failed):     {len(skipped)}")
    print(f"round-trip cross-checks run: {len(written)} — PASS: {passes}, other: {len(written) - passes}")

    append_report_section(candidates, results)
    print(f"appended IR-extraction section to {REPORT_MD}")
    return 0


def append_report_section(candidates: list, results: list) -> None:
    marker_start = "## IR extraction pass"
    text = REPORT_MD.read_text() if REPORT_MD.exists() else ""
    if marker_start in text:
        text = text.split(marker_start, 1)[0].rstrip() + "\n"

    written = [r for r in results if r["status"] == "written"]
    skipped = [r for r in results if r["status"] == "skipped"]
    passes = sum(1 for r in written if r.get("cross_check") == "PASS")

    lines = [text.rstrip(), "", marker_start, ""]
    lines.append(
        "`scripts/executable/extract_ir.py`, run against this same "
        "checkout's `_classify_output.json`. Scope: `eq_structured` "
        "entries NOT flagged by the prose-contamination heuristic above — "
        "the conservative, honestly-measured pilot slice, not a hand-"
        "picked sample and not the full 116-118 `eq_structured` count "
        "(sec.13 item 8: no scale commitment before a real pilot)."
    )
    lines.append("")
    lines.append(f"- Candidates considered: **{len(candidates)}**")
    lines.append(f"- IR sidecars written (`status: \"candidate\"`, `eligibility.reviewed_by: null` — never anything more): **{len(written)}**")
    lines.append(f"- Skipped (mechanical AST conversion not attempted or failed): **{len(skipped)}**")
    lines.append(
        f"- Round-trip cross-checks run (this script's own JSON vs. what "
        f"sympy itself parsed — NOT the sec.6 Python-reference-vs-JS-twin "
        f"check, which needs S2's kernels, not yet built): **{len(written)}** "
        f"run, **{passes} PASS**, **{len(written) - passes} other**"
    )
    lines.append("")
    lines.append(
        "**Two further false-positive hazards found live during this "
        "extraction pass, beyond sec.1.3's two and beyond classify.py's own "
        "prose-heuristic diagnostic** — direct inspection of the small "
        "\"not prose-flagged\" set still turned up real corruption:"
    )
    lines.append("")
    lines.append(
        "3. **Bare (un-escaped) multi-letter word in the source is "
        "shattered letter-by-letter.** `Gamma_R`, `tau_c`, and `pi` typed "
        "WITHOUT a leading backslash in three separate source statements "
        "all parsed as a product of single letters (`G*a*m*a_R*m` for "
        "`Gamma_R`, `t*a*u_c` for `tau_c`, `i*p` for `pi`) — this corrupts "
        "one term while the rest of the equation still looks structurally "
        "fine, so it does NOT reliably trip the word-like-symbol heuristic "
        "(the shattered pieces are all single letters). Caught here by a "
        "source-text regex (`bare_word_risk`), disclosed per-sidecar, never "
        "silently dropped."
    )
    lines.append(
        "4. **A multi-letter LaTeX superscript is read as an exponent, "
        "never as a label.** `\\mu_t^{eff}` and `\\pi_t^{RET}` both parsed "
        "as literal products-of-letters IN THE EXPONENT position "
        "(`mu_t**(e*f*f)`), changing the statement from \"mu-t, the "
        "effective value\" into an exponentiation identity. Caught here by "
        "a `\\^\\{[A-Za-z]{2,}\\}` source-text regex (`superscript_label_"
        "risk`), disclosed per-sidecar, never silently dropped."
    )
    lines.append("")
    if written:
        lines.append("Per-sidecar detail:")
        lines.append("")
        lines.append("| Code | cross_check | risks disclosed |")
        lines.append("|---|---|---|")
        for r in written:
            risks = ", ".join(r.get("risks") or []) or "none"
            lines.append(f"| `{r['code']}` | {r['cross_check']} | {risks} |")
        lines.append("")
    if skipped:
        lines.append("Skipped, with reason:")
        lines.append("")
        for r in skipped:
            lines.append(f"- `{r['code']}` — {r['reason']}")
        lines.append("")
    lines.append(
        "**None of the sidecars above is `reviewed_eligible`.** Every one "
        "is `status: \"candidate\"`, `eligibility.reviewed_by: null` — a "
        "human registrar reads `classifier.parsed_repr` against "
        "`source_statement.text`, the disclosed risks, and this section, "
        "then either promotes to `reviewed_eligible` (adding `sample_"
        "inputs` and a confirmed `variables[].domain`) or to `reviewed_"
        "rejected` with a `review_note` (sec.13 item 2, sec.3)."
    )
    REPORT_MD.write_text("\n".join(lines).rstrip() + "\n")


if __name__ == "__main__":
    sys.exit(main())
