"use strict";
/*
 * site/static/js/_ir_eval.js -- the ONE shared AST walker for the Toledo executable-equations
 * JavaScript twin (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.5, stream S2).
 *
 * ES2020, zero dependencies, no `import`/`export`, no network fetch -- loaded by a bare
 * <script src="/static/js/_qfrac.js"> + <script src="/static/js/_ir_eval.js"> pair (this file
 * must load AFTER _qfrac.js, which defines the global `QFrac`/`QFracError` this file uses).
 * `node` runs this exact same file headlessly for the automated cross-check
 * (scripts/executable/crosscheck_runner.py, stream S3) -- a subprocess invocation of the
 * shipped browser file, never a second implementation for automation's sake (sec.5).
 *
 * Same node shape as scripts/executable/ir_kernel.py's `eval_node` (sec.3) -- this file is
 * that walker's JavaScript twin, not an independent redesign. No native single/double-
 * precision floating-point sin, cos, pi constant, sqrt, exp, or log built-in ever appears in
 * the evaluated/compared value path anywhere in this file -- every transcendental `fn` below
 * is computed via a genuinely
 * different algorithm FAMILY than ir_kernel.py's own (continued-fraction evaluation instead
 * of truncated power-series summation / Newton-Raphson), named in ALGORITHM_FAMILY_JS so a
 * build-time lint (scripts/executable/ir_eval.py::check_transcendental_lint) can assert the
 * two families are never the same string for the same `fn` (sec.3/sec.13).
 */
(function (root) {
  const QFrac = root.QFrac;
  const QFracError = root.QFracError;
  if (!QFrac) {
    throw new Error("_ir_eval.js requires _qfrac.js to be loaded first (defines global QFrac)");
  }

  class IRKernelError extends Error {}

  const ALLOWED_OPS = new Set(["add", "sub", "mul", "div", "pow", "neg", "const", "var", "call"]);
  const ALLOWED_FNS = new Set(["sqrt", "exp", "sin", "cos", "log", "pi_const"]);

  const DEFAULT_TERMS = 30;
  const WORKING_PRECISION_DIGITS = 60;

  // The algorithm family THIS file actually implements per transcendental `fn` -- a genuinely
  // different family than scripts/executable/ir_kernel.py::ALGORITHM_FAMILY_PY for every row,
  // by construction (continued-fraction evaluation vs. truncated power series / Newton).
  const ALGORITHM_FAMILY_JS = {
    pi_const: "arctan_continued_fraction",
    exp: "lambert_continued_fraction",
    sin: "tan_half_angle_continued_fraction",
    cos: "tan_half_angle_continued_fraction",
    sqrt: "generalized_continued_fraction",
    log: "continued_fraction_ln1p",
  };

  function require_(cond, msg) {
    if (!cond) throw new IRKernelError(msg);
  }

  function isqrtBigInt(n) {
    if (n < 0n) throw new IRKernelError("isqrt requires a nonnegative integer");
    if (n === 0n) return 0n;
    let x = n;
    let y = (x + 1n) / 2n;
    while (y < x) {
      x = y;
      y = (x + n / x) / 2n;
    }
    return x;
  }

  // ---------------------------------------------------------------------
  // Transcendental primitives -- continued-fraction family (ALGORITHM_FAMILY_JS).
  // Every intermediate value is rounded to WORKING_PRECISION_DIGITS via QFrac's own
  // roundToPrecision, the identical discipline ir_kernel.py applies on the Python side.
  // ---------------------------------------------------------------------

  /** Continued fraction for arctan(z): z / (1 + z^2*1^2/(3 + z^2*2^2/(5 + z^2*3^2/(7+...)))). */
  function arctanCF(z, terms) {
    let T = QFrac.fromInt(2 * terms + 1);
    for (let k = terms; k >= 1; k--) {
      const a = QFrac.fromInt(2 * (k - 1) + 1);
      const b = z.mul(z).mul(QFrac.fromInt(k * k));
      T = a.add(b.div(T)).roundToPrecision(WORKING_PRECISION_DIGITS);
    }
    return z.div(T).roundToPrecision(WORKING_PRECISION_DIGITS);
  }

  /** pi = 16*arctan(1/5) - 4*arctan(1/239) (Machin's identity), each arctan evaluated by
   * continued fraction instead of a power series -- a different algorithm family than
   * ir_kernel.py's own Machin-arctan-*series* reference. */
  function piConst(terms) {
    const a = arctanCF(QFrac.fromString("1/5"), terms);
    const b = arctanCF(QFrac.fromString("1/239"), terms);
    return QFrac.fromInt(16).mul(a).sub(QFrac.fromInt(4).mul(b)).roundToPrecision(WORKING_PRECISION_DIGITS);
  }

  /** Generalized continued fraction for sqrt(x): write x = p/q, n = p*q, a = isqrt(n),
   * r = n - a^2; sqrt(n) = a + r/(2a + r/(2a + ...)); sqrt(x) = sqrt(n)/q. A different
   * algorithm family than ir_kernel.py's own Newton-Raphson reference. */
  function sqrtFinite(x, terms) {
    require_(x.cmp(QFrac.fromInt(0)) >= 0, "sqrt domain requires a nonnegative rational");
    if (x.isZero()) return QFrac.fromInt(0);
    const p = x.num;
    const q = x.den;
    const n = p * q;
    const a = isqrtBigInt(n);
    const r = n - a * a;
    if (r === 0n) return new QFrac(a, q);
    let T = QFrac.fromInt(2n * a);
    const rFrac = new QFrac(r, 1n);
    for (let i = 0; i < terms; i++) {
      T = QFrac.fromInt(2n * a).add(rFrac.div(T)).roundToPrecision(WORKING_PRECISION_DIGITS);
    }
    const val = new QFrac(a, 1n).add(rFrac.div(T));
    return val.div(new QFrac(q, 1n)).roundToPrecision(WORKING_PRECISION_DIGITS);
  }

  /** Lambert's continued fraction for e^x:
   * e^x = 1 + 2x/((2-x) + x^2/(6 + x^2/(10 + x^2/(14 + ...)))). A different algorithm family
   * than ir_kernel.py's own halving-reduced Taylor series. */
  function expFinite(x, terms) {
    const x2 = x.mul(x);
    function denomAt(i) {
      return i === 0 ? QFrac.fromInt(2).sub(x) : QFrac.fromInt(4 * i + 2);
    }
    let T = denomAt(terms);
    for (let k = terms; k >= 1; k--) {
      T = denomAt(k - 1).add(x2.div(T)).roundToPrecision(WORKING_PRECISION_DIGITS);
    }
    return QFrac.fromInt(1).add(QFrac.fromInt(2).mul(x).div(T)).roundToPrecision(WORKING_PRECISION_DIGITS);
  }

  /** tan(x) via continued fraction: x/(1 - x^2/(3 - x^2/(5 - ...))); sin/cos recovered from
   * t = tan(x/2) via sin(x)=2t/(1+t^2), cos(x)=(1-t^2)/(1+t^2). A different algorithm family
   * than ir_kernel.py's own halving+double-angle Taylor series. */
  function tanCF(x, terms) {
    let T = QFrac.fromInt(2 * terms - 1);
    const x2 = x.mul(x);
    for (let k = terms - 1; k >= 1; k--) {
      T = QFrac.fromInt(2 * k - 1).sub(x2.div(T)).roundToPrecision(WORKING_PRECISION_DIGITS);
    }
    return x.div(T).roundToPrecision(WORKING_PRECISION_DIGITS);
  }

  function sinCosViaHalfAngle(x, terms) {
    const half = x.div(QFrac.fromInt(2));
    const t = tanCF(half, terms);
    const denom = QFrac.fromInt(1).add(t.mul(t));
    const s = QFrac.fromInt(2).mul(t).div(denom).roundToPrecision(WORKING_PRECISION_DIGITS);
    const c = QFrac.fromInt(1).sub(t.mul(t)).div(denom).roundToPrecision(WORKING_PRECISION_DIGITS);
    return [s, c];
  }

  function sinFinite(x, terms) {
    return sinCosViaHalfAngle(x, terms)[0];
  }

  function cosFinite(x, terms) {
    return sinCosViaHalfAngle(x, terms)[1];
  }

  /** ln(1+y) via continued fraction: y/(1 + 1^2*y/(2 + 1^2*y/(3 + 2^2*y/(4 + 2^2*y/(5+...))))).
   * x is first range-reduced into (1/2, 2] by halving/doubling against a once-computed ln(2)
   * (itself the same continued fraction at y=1) -- a power-of-2 scaling reduction, distinct
   * from ir_kernel.py's own repeated-sqrt reduction. A different algorithm family overall
   * than ir_kernel.py's own artanh-series-with-sqrt-reduction reference. */
  function ln1pCF(y, terms) {
    let D = QFrac.fromInt(terms);
    for (let k = terms - 1; k >= 1; k--) {
      const halfK = (k + 1) >> 1; // integer floor((k+1)/2) via bit shift -- no Math.* call
      const coeff = QFrac.fromInt(halfK ** 2);
      const N = coeff.mul(y);
      D = QFrac.fromInt(k).add(N.div(D)).roundToPrecision(WORKING_PRECISION_DIGITS);
    }
    return y.div(D).roundToPrecision(WORKING_PRECISION_DIGITS);
  }

  function logFinite(x, terms) {
    require_(x.cmp(QFrac.fromInt(0)) > 0, "log domain requires a positive rational");
    const ln2 = ln1pCF(QFrac.fromInt(1), terms); // ln(2)
    let reduced = x;
    let k = 0; // net factor is 2**k (reduced = x / 2**k)
    const two = QFrac.fromInt(2);
    const half = QFrac.fromString("1/2");
    let guard = 0;
    while (reduced.cmp(two) > 0 && guard < 4096) {
      reduced = reduced.div(two);
      k += 1;
      guard += 1;
    }
    while (reduced.cmp(half) < 0 && guard < 4096) {
      reduced = reduced.mul(two);
      k -= 1;
      guard += 1;
    }
    const y = reduced.sub(QFrac.fromInt(1));
    const lnReduced = ln1pCF(y, terms);
    return lnReduced.add(QFrac.fromInt(k).mul(ln2)).roundToPrecision(WORKING_PRECISION_DIGITS);
  }

  const TRANSCENDENTAL_FNS = {
    pi_const: (values, terms) => piConst(terms),
    sqrt: (values, terms) => sqrtFinite(values[0], terms),
    exp: (values, terms) => expFinite(values[0], terms),
    sin: (values, terms) => sinFinite(values[0], terms),
    cos: (values, terms) => cosFinite(values[0], terms),
    log: (values, terms) => logFinite(values[0], terms),
  };

  function callFn(fn, values, terms) {
    require_(ALLOWED_FNS.has(fn), `disallowed transcendental function: "${fn}"`);
    const expectedArity = fn === "pi_const" ? 0 : 1;
    require_(
      values.length === expectedArity,
      `"${fn}" takes exactly ${expectedArity} argument(s), got ${values.length}`
    );
    if (fn === "sqrt") {
      require_(values[0].cmp(QFrac.fromInt(0)) >= 0, "'sqrt' argument is outside its declared domain");
    }
    if (fn === "log") {
      require_(values[0].cmp(QFrac.fromInt(0)) > 0, "'log' argument is outside its declared domain");
    }
    return TRANSCENDENTAL_FNS[fn](values, terms);
  }

  // ---------------------------------------------------------------------
  // The generic AST walker -- the twin of ir_kernel.py::eval_node.
  // ---------------------------------------------------------------------

  function evalNode(node, env, terms) {
    if (typeof terms === "undefined") terms = DEFAULT_TERMS;
    require_(
      node && typeof node === "object" && typeof node.op === "string",
      "an IR node must be an object with an 'op' key"
    );
    const op = node.op;
    require_(ALLOWED_OPS.has(op), `disallowed IR operator: "${op}"`);

    if (op === "const") {
      return QFrac.fromString(node.value);
    }

    if (op === "var") {
      const name = node.name;
      require_(typeof name === "string" && Object.prototype.hasOwnProperty.call(env, name),
        `no bound value for variable "${name}"`);
      return env[name];
    }

    if (op === "call") {
      const fn = node.fn;
      const args = node.args || [];
      require_(Array.isArray(args), "a 'call' node's 'args' must be a list");
      const values = args.map((a) => evalNode(a, env, terms));
      return callFn(fn, values, terms);
    }

    const args = node.args;
    require_(Array.isArray(args) && args.length > 0, `"${op}" node requires a non-empty 'args' list`);
    const values = args.map((a) => evalNode(a, env, terms));

    if (op === "add") {
      let total = QFrac.fromInt(0);
      for (const v of values) total = total.add(v);
      return total;
    }
    if (op === "mul") {
      let product = QFrac.fromInt(1);
      for (const v of values) product = product.mul(v);
      return product;
    }
    if (op === "sub") {
      require_(values.length === 2, "'sub' requires exactly 2 args");
      return values[0].sub(values[1]);
    }
    if (op === "div") {
      require_(values.length === 2, "'div' requires exactly 2 args");
      require_(!values[1].isZero(), "division by zero");
      return values[0].div(values[1]);
    }
    if (op === "neg") {
      require_(values.length === 1, "'neg' requires exactly 1 arg");
      return values[0].neg();
    }
    if (op === "pow") {
      require_(values.length === 2, "'pow' requires exactly 2 args");
      const base = values[0];
      const exponent = values[1];
      require_(exponent.den === 1n, "'pow' exponent must evaluate to an integer rational");
      if (exponent.num < 0n) {
        require_(!base.isZero(), "cannot raise zero to a negative power");
      }
      return base.pow(exponent.num);
    }
    throw new IRKernelError(`unhandled operator: "${op}"`);
  }

  root.ToledoIREval = {
    IRKernelError,
    ALLOWED_OPS,
    ALLOWED_FNS,
    DEFAULT_TERMS,
    WORKING_PRECISION_DIGITS,
    ALGORITHM_FAMILY_JS,
    evalNode,
    piConst,
    sqrtFinite,
    expFinite,
    sinFinite,
    cosFinite,
    logFinite,
  };

  // Node/CommonJS export for headless invocation (scripts/executable/crosscheck_runner.py's
  // `node _ir_eval.js` subprocess call, and this stream's own node-run test suite) -- the
  // browser <script> tag path above (attaching to `root`/globalThis) is unaffected.
  if (typeof module !== "undefined" && module.exports) {
    module.exports = root.ToledoIREval;
  }
})(typeof globalThis !== "undefined" ? globalThis : this);
