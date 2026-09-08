#!/usr/bin/env python3
"""scripts/executable/ir_kernel.py -- the ONE shared AST walker for the Toledo executable-
equations Python reference runtime (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.4, stream S2).

Pure standard library. `fractions.Fraction` is the only numeric type used anywhere in this
file -- no `float`, no `mpmath`, no `math` module transcendental. This is the reference-path
constraint the spec's own build-time lint (tests/executable/test_ir_kernel.py) checks
mechanically by scanning this file's own source for a bare float literal used in an
arithmetic operator context.

Widening what this kernel can express (a new operator, a new transcendental function) is a
reviewed change to exactly this file plus its JavaScript twin, site/static/js/_ir_eval.js --
never a per-equation decision (sec.2's architecture ruling).

Node shape (sec.3): every IR expression node is one of
    {"op": "const", "value": "<exact rational string>"}
    {"op": "var",   "name": "<variable name>"}
    {"op": "add"|"mul", "args": [<node>, ...]}      -- 2 or more args, commutative/associative
    {"op": "sub"|"div"|"pow", "args": [<node>, <node>]}   -- exactly 2 args; pow's second
                                                              arg must evaluate to an integer
    {"op": "neg", "args": [<node>]}                 -- exactly 1 arg
    {"op": "call", "fn": "<name>", "args": [<node>, ...]}  -- fn is one of ALLOWED_FNS below,
                                                              never an arbitrary string eval'd

Every transcendental `fn` is computed on Fraction only, at a fixed internal working
precision (WORKING_PRECISION_DIGITS decimal digits, truncated/rounded to that many digits
after each accumulating step) -- an exact-but-deliberately-truncated rational, the same
"finite discrete rational readout" discipline glosa/methodology/P24_mathematical_floor.md's
Q-computability law states, and the same "fixed working precision, not literal infinite
series" convention this workspace's own information-discrete-math package already applies
(see glosa/cases/repro/run_IDM_ladder_constants.py's docstring) -- reproduced here with
Fraction-only exact-rational rounding in place of that package's own mpmath.mpf fixed-dps
arithmetic, per this spec's "mpmath never appears in this file" constraint (sec.4).

ALGORITHM_FAMILY_PY / ALGORITHM_FAMILY_JS below are NOT executable code paths -- they are the
fixed, named algorithm family this reference kernel (resp. the JavaScript twin,
site/static/js/_ir_eval.js) actually implements per transcendental `fn`, kept here as plain
data so an IR sidecar's own declared `transcendental.algorithm_py`/`algorithm_js` strings can
be checked against what each interpreter genuinely does, and so the two families can be
asserted distinct (sec.3's "must never name the same algorithm family for the same fn" rule)
without importing a JavaScript file into a Python process.
"""
from __future__ import annotations

from fractions import Fraction
from typing import Any, Mapping, Sequence

__all__ = [
    "IRKernelError",
    "ALLOWED_OPS",
    "ALLOWED_FNS",
    "DEFAULT_TERMS",
    "WORKING_PRECISION_DIGITS",
    "ALGORITHM_FAMILY_PY",
    "ALGORITHM_FAMILY_JS",
    "parse_rational",
    "eval_node",
    "pi_const",
    "sqrt_finite",
    "exp_finite",
    "sin_finite",
    "cos_finite",
    "log_finite",
]


class IRKernelError(ValueError):
    """A malformed IR node, a disallowed operator/function, or a domain violation (division
    by zero, sqrt of a negative rational, an out-of-range log argument, a non-integer pow
    exponent) encountered while walking the tree. Always raised, never silently coerced to
    0/inf -- tests/executable/test_ir_kernel.py checks this explicitly for the division and
    domain cases named in docs/EXECUTABLE_EQUATIONS_v0_1.md sec.9."""


# ---------------------------------------------------------------------------
# Fixed vocabulary -- never an arbitrary string the kernel evaluates.
# ---------------------------------------------------------------------------

ALLOWED_OPS = frozenset({"add", "sub", "mul", "div", "pow", "neg", "const", "var", "call"})
ALLOWED_FNS = frozenset({"sqrt", "exp", "sin", "cos", "log", "pi_const"})

DEFAULT_TERMS = 30          # series-term / Newton-iteration count, absent an IR-declared value
WORKING_PRECISION_DIGITS = 60  # decimal digits every transcendental accumulator is rounded to

# The algorithm family THIS file actually implements per transcendental `fn` -- data, not
# code; consumed by ir_eval.py's sidecar lint (sec.3/sec.13 item... "no per-entry generated
# source" / "algorithm_py and algorithm_js must never name the same algorithm family").
ALGORITHM_FAMILY_PY: dict[str, str] = {
    "pi_const": "machin_arctan_series",
    "exp": "taylor_series_halving_reduction",
    "sin": "taylor_series_halving_reduction",
    "cos": "taylor_series_halving_reduction",
    "sqrt": "newton_raphson",
    "log": "artanh_series_sqrt_reduction",
}

# The algorithm family the JavaScript twin (site/static/js/_ir_eval.js) implements per `fn` --
# a genuinely different family per row than ALGORITHM_FAMILY_PY above, by construction (sec.5,
# sec.6 step 5: two independent derivations, not one algorithm typed twice).
ALGORITHM_FAMILY_JS: dict[str, str] = {
    "pi_const": "brouncker_continued_fraction",
    "exp": "lambert_continued_fraction",
    "sin": "tan_half_angle_continued_fraction",
    "cos": "tan_half_angle_continued_fraction",
    "sqrt": "generalized_continued_fraction",
    "log": "continued_fraction_ln1p",
}

assert set(ALGORITHM_FAMILY_PY) == set(ALGORITHM_FAMILY_JS) == set(ALLOWED_FNS)
for _fn in ALLOWED_FNS:
    assert ALGORITHM_FAMILY_PY[_fn] != ALGORITHM_FAMILY_JS[_fn], (
        f"algorithm_py and algorithm_js must never name the same family for {_fn!r}"
    )


def _require(condition: bool, message: str) -> None:
    if not condition:
        raise IRKernelError(message)


# ---------------------------------------------------------------------------
# Exact-rational parsing -- the ONE place a string becomes a Fraction.
# ---------------------------------------------------------------------------

def parse_rational(value: str) -> Fraction:
    """Parse an exact-rational literal string ("3", "-1/2", "22/7") into a Fraction. Never
    accepts a JSON/Python float or int directly -- the caller must already hold a string, so
    no floating value can silently cross into this evaluator (sec.4)."""
    _require(isinstance(value, str), "a rational literal must be given as a string, never a float/int")
    text = value.strip()
    _require(bool(text), "empty string is not a valid rational literal")
    try:
        if "/" in text:
            num_s, den_s = text.split("/", 1)
            return Fraction(int(num_s), int(den_s))
        return Fraction(int(text))
    except (ValueError, ZeroDivisionError) as exc:
        raise IRKernelError(f"invalid exact-rational literal: {value!r}") from exc


def _round_to_precision(value: Fraction, digits: int = WORKING_PRECISION_DIGITS) -> Fraction:
    """Round a Fraction to `digits` decimal digits, returned as an exact Fraction whose
    denominator divides 10**digits -- integer arithmetic only (divmod), never a float. This
    bounds the bit-length of every transcendental accumulator (an exact, uncapped Newton/
    Taylor iteration on Fraction roughly doubles its denominator's bit-length every step,
    which is only impractical to carry forward -- rounding to a fixed decimal precision is
    itself still an exact rational value, the same "finite discrete readout" P24 requires,
    mirroring this workspace's own fixed-dps convention (run_IDM_ladder_constants.py's
    docstring) with Fraction-exact rounding standing in for that convention's mpmath.mpf."""
    scale = 10 ** digits
    numerator = value.numerator * scale
    denominator = value.denominator
    quotient, remainder = divmod(numerator, denominator)
    if 2 * remainder >= denominator:
        quotient += 1
    return Fraction(quotient, scale)


# ---------------------------------------------------------------------------
# Transcendental primitives -- Python-reference algorithm family (ALGORITHM_FAMILY_PY).
# Fraction only; every accumulating step is rounded via _round_to_precision.
# ---------------------------------------------------------------------------

def _arctan_series(x: Fraction, terms: int) -> Fraction:
    _require(abs(x) < 1, "arctan series requires |x| < 1")
    total = Fraction(0)
    power = x
    x2 = _round_to_precision(x * x)
    for k in range(terms):
        term = power / (2 * k + 1)
        total = _round_to_precision(total + term if k % 2 == 0 else total - term)
        power = _round_to_precision(power * x2)
    return total


def pi_const(terms: int = DEFAULT_TERMS) -> Fraction:
    """Machin's formula: pi = 16*arctan(1/5) - 4*arctan(1/239), each arctan by its own
    finite alternating series -- the same construction this workspace's own
    information-discrete-math package ships (provefull/_kernel.py PI_FINITE), reproduced
    here on Fraction rather than mpmath.mpf."""
    a = _arctan_series(Fraction(1, 5), terms)
    b = _arctan_series(Fraction(1, 239), terms)
    return _round_to_precision(16 * a - 4 * b)


def sqrt_finite(x: Fraction, terms: int = DEFAULT_TERMS) -> Fraction:
    """Pure Newton-Raphson iteration (+,-,*,/ only) after scaling the argument into [1/4, 4)
    so the fixed iteration count above converges reliably regardless of x's own magnitude."""
    _require(x >= 0, "sqrt domain requires a nonnegative rational")
    if x == 0:
        return Fraction(0)
    scale = Fraction(1)
    scaled = x
    guard = 0
    while scaled >= 4 and guard < 4096:
        scaled = _round_to_precision(scaled / 4)
        scale *= 2
        guard += 1
    while scaled < Fraction(1, 4) and guard < 4096:
        scaled = _round_to_precision(scaled * 4)
        scale /= 2
        guard += 1
    guess = Fraction(1)
    for _ in range(terms):
        guess = _round_to_precision((guess + scaled / guess) / 2)
    return _round_to_precision(guess * scale)


def exp_finite(x: Fraction, terms: int = DEFAULT_TERMS) -> Fraction:
    """Argument-reduced Taylor series: exp(x) = exp(x/2**k)**(2**k) (halving reduction, then
    a finite Taylor sum on the small reduced argument, squared back k times)."""
    reduced = x
    halvings = 0
    while abs(reduced) > Fraction(1, 4) and halvings < 4096:
        reduced = _round_to_precision(reduced / 2)
        halvings += 1
    total = Fraction(1)
    term = Fraction(1)
    for i in range(1, terms + 1):
        term = _round_to_precision(term * reduced / i)
        total = _round_to_precision(total + term)
    for _ in range(halvings):
        total = _round_to_precision(total * total)
    return total


def _factorial(n: int) -> int:
    result = 1
    for i in range(2, n + 1):
        result *= i
    return result


def _sin_cos_small(x: Fraction, terms: int) -> tuple[Fraction, Fraction]:
    """Direct Taylor series for sin/cos of an already-small argument (|x| <= 1/4)."""
    x2 = _round_to_precision(x * x)

    sin_total = Fraction(0)
    power = x
    for k in range(terms):
        term = power / _factorial(2 * k + 1)
        sin_total = _round_to_precision(sin_total + term if k % 2 == 0 else sin_total - term)
        power = _round_to_precision(power * x2)

    cos_total = Fraction(0)
    power = Fraction(1)
    for k in range(terms):
        term = power / _factorial(2 * k)
        cos_total = _round_to_precision(cos_total + term if k % 2 == 0 else cos_total - term)
        power = _round_to_precision(power * x2)

    return sin_total, cos_total


def _reduce_and_recombine(x: Fraction, terms: int) -> tuple[Fraction, Fraction]:
    reduced = x
    halvings = 0
    while abs(reduced) > Fraction(1, 4) and halvings < 4096:
        reduced = _round_to_precision(reduced / 2)
        halvings += 1
    s, c = _sin_cos_small(reduced, terms)
    for _ in range(halvings):
        s, c = _round_to_precision(2 * s * c), _round_to_precision(c * c - s * s)
    return s, c


def sin_finite(x: Fraction, terms: int = DEFAULT_TERMS) -> Fraction:
    """Argument-reduced (halving + double-angle recombination) Taylor series for sin."""
    s, _c = _reduce_and_recombine(x, terms)
    return s


def cos_finite(x: Fraction, terms: int = DEFAULT_TERMS) -> Fraction:
    """Argument-reduced (halving + double-angle recombination) Taylor series for cos."""
    _s, c = _reduce_and_recombine(x, terms)
    return c


def log_finite(x: Fraction, terms: int = DEFAULT_TERMS) -> Fraction:
    """ln(x) via ln(x) = 2**k * 2*artanh((r-1)/(r+1)) where r = sqrt**k(x) has been reduced
    into [2/3, 3/2] by repeated sqrt_finite calls -- a fast-converging alternating series on
    the reduced argument, scaled back by the same number of sqrt halvings taken."""
    _require(x > 0, "log domain requires a positive rational")
    reduced = x
    halvings = 0
    while (reduced > Fraction(3, 2) or reduced < Fraction(2, 3)) and halvings < 4096:
        reduced = sqrt_finite(reduced, terms)
        halvings += 1
    y = _round_to_precision((reduced - 1) / (reduced + 1))
    y2 = _round_to_precision(y * y)
    total = Fraction(0)
    power = y
    for i in range(terms):
        term = power / (2 * i + 1)
        total = _round_to_precision(total + term)
        power = _round_to_precision(power * y2)
    return _round_to_precision(total * (2 ** (halvings + 1)))


_TRANSCENDENTAL_FNS = {
    "pi_const": lambda values, terms: pi_const(terms),
    "sqrt": lambda values, terms: sqrt_finite(values[0], terms),
    "exp": lambda values, terms: exp_finite(values[0], terms),
    "sin": lambda values, terms: sin_finite(values[0], terms),
    "cos": lambda values, terms: cos_finite(values[0], terms),
    "log": lambda values, terms: log_finite(values[0], terms),
}


def _call_fn(fn: str, values: Sequence[Fraction], terms: int) -> Fraction:
    _require(fn in ALLOWED_FNS, f"disallowed transcendental function: {fn!r}")
    expected_arity = 0 if fn == "pi_const" else 1
    _require(
        len(values) == expected_arity,
        f"{fn!r} takes exactly {expected_arity} argument(s), got {len(values)}",
    )
    if fn in ("sqrt", "log"):
        _require(values[0] >= 0 if fn == "sqrt" else values[0] > 0,
                  f"{fn!r} argument is outside its declared domain")
    return _TRANSCENDENTAL_FNS[fn](values, terms)


# ---------------------------------------------------------------------------
# The generic AST walker -- the ONE evaluator every IR node shape passes through.
# ---------------------------------------------------------------------------

def eval_node(node: Mapping[str, Any], env: Mapping[str, Fraction], terms: int = DEFAULT_TERMS) -> Fraction:
    """Walk one IR expression node (sec.3 node shape) to a Fraction, given a binding of
    variable name -> Fraction in `env`. Every arithmetic step stays on Fraction; a
    transcendental `call` node dispatches to this module's own fixed-family primitives
    above, at working precision `terms` (series-term / Newton-iteration count)."""
    _require(isinstance(node, dict) and "op" in node, "an IR node must be an object with an 'op' key")
    op = node["op"]
    _require(op in ALLOWED_OPS, f"disallowed IR operator: {op!r}")

    if op == "const":
        return parse_rational(node["value"])

    if op == "var":
        name = node.get("name")
        _require(isinstance(name, str) and name in env, f"no bound value for variable {name!r}")
        return env[name]

    if op == "call":
        fn = node.get("fn")
        args = node.get("args", [])
        _require(isinstance(args, list), "a 'call' node's 'args' must be a list")
        values = [eval_node(a, env, terms) for a in args]
        return _call_fn(fn, values, terms)

    args = node.get("args")
    _require(isinstance(args, list) and len(args) > 0, f"'{op}' node requires a non-empty 'args' list")
    values = [eval_node(a, env, terms) for a in args]

    if op == "add":
        total = Fraction(0)
        for v in values:
            total += v
        return total

    if op == "mul":
        product = Fraction(1)
        for v in values:
            product *= v
        return product

    if op == "sub":
        _require(len(values) == 2, "'sub' requires exactly 2 args")
        return values[0] - values[1]

    if op == "div":
        _require(len(values) == 2, "'div' requires exactly 2 args")
        _require(values[1] != 0, "division by zero")
        return values[0] / values[1]

    if op == "neg":
        _require(len(values) == 1, "'neg' requires exactly 1 arg")
        return -values[0]

    if op == "pow":
        _require(len(values) == 2, "'pow' requires exactly 2 args")
        base, exponent = values
        _require(exponent.denominator == 1, "'pow' exponent must evaluate to an integer rational")
        exp_int = exponent.numerator
        if exp_int < 0:
            _require(base != 0, "cannot raise zero to a negative power")
        return base ** exp_int

    raise IRKernelError(f"unhandled operator: {op!r}")  # pragma: no cover -- ALLOWED_OPS guards this
