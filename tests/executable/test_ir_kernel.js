#!/usr/bin/env node
"use strict";
/*
 * tests/executable/test_ir_kernel.js -- unit tests for site/static/js/_qfrac.js and
 * _ir_eval.js (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.9, stream S2), run via `node` --
 * the same runtime scripts/executable/crosscheck_runner.py (stream S3) invokes headlessly
 * against these exact shipped browser files.
 *
 * Covers: every row of the shared tests/executable/vectors.json (also consumed, identically,
 * by tests/executable/test_ir_kernel.py); explicit division-by-zero and domain checks; and a
 * grep guard asserting no native floating-point transcendental (Math.sin/Math.cos/Math.PI/
 * Math.sqrt/Math.exp/Math.log) appears anywhere in _qfrac.js/_ir_eval.js outside
 * toDecimalString's own function body.
 *
 * No test framework dependency (no jest/mocha) -- a small hand-rolled runner, consistent with
 * this feature's own "zero dependencies" constraint (sec.5) extended to its own test suite.
 * Exit code 0 iff every check passed; a failure prints which one and exits 1.
 */

const fs = require("fs");
const path = require("path");
const assert = require("assert");

const REPO_ROOT = path.resolve(__dirname, "..", "..");
const QFRAC_PATH = path.join(REPO_ROOT, "site", "static", "js", "_qfrac.js");
const IR_EVAL_PATH = path.join(REPO_ROOT, "site", "static", "js", "_ir_eval.js");
const VECTORS_PATH = path.join(__dirname, "vectors.json");

require(QFRAC_PATH);
const E = require(IR_EVAL_PATH);

const vectorsDoc = JSON.parse(fs.readFileSync(VECTORS_PATH, "utf-8"));
assert.strictEqual(vectorsDoc.schema_version, "executable-test-vectors-0.1");
const VECTORS = vectorsDoc.vectors;

let passed = 0;
let failed = 0;

function test(name, fn) {
  try {
    fn();
    passed += 1;
    console.log(`ok - ${name}`);
  } catch (err) {
    failed += 1;
    console.log(`FAIL - ${name}`);
    console.log(`  ${err.message}`);
  }
}

function envFromInputs(inputs) {
  const env = {};
  for (const [name, value] of Object.entries(inputs)) {
    env[name] = QFrac.fromString(value);
  }
  return env;
}

// ---------------------------------------------------------------------
// Shared vectors, via the AST walker directly.
// ---------------------------------------------------------------------

for (const vector of VECTORS) {
  test(`shared vector: ${vector.name}`, () => {
    const ir = vector.ir;
    const env = envFromInputs(vector.inputs);
    const terms = ir.transcendental ? ir.transcendental.default_terms : E.DEFAULT_TERMS;

    const result = E.evalNode(ir.rhs, env, terms);
    const expected = QFrac.fromString(vector.expected_value);
    const tolerance = QFrac.fromString(vector.tolerance);

    const delta = result.sub(expected).abs();
    assert.ok(
      delta.cmp(tolerance) <= 0,
      `${vector.name}: got ${result.toString()}, expected ${expected.toString()} +/- ${tolerance.toString()} (delta ${delta.toString()})`
    );
  });
}

// ---------------------------------------------------------------------
// Sanity checks mirroring the Python-side edge-case tests.
// ---------------------------------------------------------------------

test("division by zero raises", () => {
  const node = { op: "div", args: [{ op: "const", value: "1" }, { op: "var", name: "d" }] };
  assert.throws(
    () => E.evalNode(node, { d: QFrac.fromInt(0) }),
    (err) => err instanceof E.IRKernelError && /division by zero/.test(err.message)
  );
});

test("division by zero raises even when the zero comes from a variable", () => {
  const node = { op: "div", args: [{ op: "var", name: "a" }, { op: "var", name: "d" }] };
  assert.throws(
    () => E.evalNode(node, { a: QFrac.fromInt(3), d: QFrac.fromInt(0) }),
    (err) => err instanceof E.IRKernelError
  );
});

test("sqrt of a negative rational raises", () => {
  const node = { op: "call", fn: "sqrt", args: [{ op: "const", value: "-1" }] };
  assert.throws(
    () => E.evalNode(node, {}),
    (err) => err instanceof E.IRKernelError && /domain/.test(err.message)
  );
});

test("log of zero raises", () => {
  const node = { op: "call", fn: "log", args: [{ op: "const", value: "0" }] };
  assert.throws(
    () => E.evalNode(node, {}),
    (err) => err instanceof E.IRKernelError && /domain/.test(err.message)
  );
});

test("log of a negative rational raises", () => {
  const node = { op: "call", fn: "log", args: [{ op: "const", value: "-5" }] };
  assert.throws(
    () => E.evalNode(node, {}),
    (err) => err instanceof E.IRKernelError && /domain/.test(err.message)
  );
});

test("negative power of zero raises", () => {
  const node = { op: "pow", args: [{ op: "const", value: "0" }, { op: "const", value: "-1" }] };
  assert.throws(
    () => E.evalNode(node, {}),
    (err) => err instanceof E.IRKernelError && /negative power/.test(err.message)
  );
});

test("non-integer pow exponent is rejected", () => {
  const node = { op: "pow", args: [{ op: "const", value: "2" }, { op: "const", value: "1/2" }] };
  assert.throws(
    () => E.evalNode(node, {}),
    (err) => err instanceof E.IRKernelError && /integer/.test(err.message)
  );
});

test("disallowed operator is rejected", () => {
  assert.throws(
    () => E.evalNode({ op: "eval", args: [] }, {}),
    (err) => err instanceof E.IRKernelError && /disallowed IR operator/.test(err.message)
  );
});

test("disallowed function is rejected", () => {
  const node = { op: "call", fn: "eval", args: [{ op: "const", value: "1" }] };
  assert.throws(
    () => E.evalNode(node, {}),
    (err) => err instanceof E.IRKernelError && /disallowed transcendental function/.test(err.message)
  );
});

// ---------------------------------------------------------------------
// R2-1 integration fix (2026-09-08): QFrac.roundToPrecision must round a negative exact tie the
// SAME way scripts/executable/ir_kernel.py::_round_to_precision does (Python's divmod-based
// rule: floor division, remainder always in [0, denominator), every exact tie toward
// +infinity) -- these are the exact hand-verified examples the finding named. Before this fix
// QFrac.roundToPrecision(-3/2, 0) returned -2 (away from zero); the Python reference returns -1.
// ---------------------------------------------------------------------

const ROUND_TO_PRECISION_CASES = [
  { num: -3n, den: 2n, digits: 0, expectedNum: -1n, expectedDen: 1n },  // -1.5 exact tie -> -1
  { num: -5n, den: 2n, digits: 0, expectedNum: -2n, expectedDen: 1n },  // -2.5 exact tie -> -2
  { num: -1n, den: 2n, digits: 0, expectedNum: 0n, expectedDen: 1n },   // -0.5 exact tie -> 0
  { num: 3n, den: 2n, digits: 0, expectedNum: 2n, expectedDen: 1n },    // +1.5 exact tie -> 2 (unaffected side)
  { num: -7n, den: 4n, digits: 1, expectedNum: -17n, expectedDen: 10n }, // -1.75 exact tie at 1 digit -> -1.7
];

for (const c of ROUND_TO_PRECISION_CASES) {
  test(`roundToPrecision negative-tie case ${c.num}/${c.den} @ ${c.digits} digits`, () => {
    const result = new QFrac(c.num, c.den).roundToPrecision(c.digits);
    const expected = new QFrac(c.expectedNum, c.expectedDen);
    assert.ok(
      result.eq(expected),
      `${c.num}/${c.den} rounded to ${c.digits} digits: got ${result.toString()}, expected ${expected.toString()}`
    );
  });
}

test("QFrac.fromString rejects a malformed literal", () => {
  assert.throws(() => QFrac.fromString("not-a-number"), (err) => err instanceof QFracError);
});

test("algorithm families are pairwise distinct per function (JS side's own view)", () => {
  for (const fn of E.ALLOWED_FNS) {
    // The JS-declared family for `fn` must differ from the Python reference's own declared
    // family for the same fn -- cross-checked here against the identical constant
    // scripts/executable/ir_kernel.py keeps for the Python side (ir_kernel.ALGORITHM_FAMILY_PY),
    // reproduced literally since this test file cannot import a Python module.
    const ALGORITHM_FAMILY_PY = {
      pi_const: "machin_arctan_series",
      exp: "taylor_series_halving_reduction",
      sin: "taylor_series_halving_reduction",
      cos: "taylor_series_halving_reduction",
      sqrt: "newton_raphson",
      log: "artanh_series_sqrt_reduction",
    };
    assert.notStrictEqual(E.ALGORITHM_FAMILY_JS[fn], ALGORITHM_FAMILY_PY[fn], `family collision for ${fn}`);
  }
});

// ---------------------------------------------------------------------
// Grep guard: no native floating-point transcendental outside toDecimalString.
// ---------------------------------------------------------------------

const FORBIDDEN_TOKENS = ["Math.sin", "Math.cos", "Math.PI", "Math.sqrt", "Math.exp", "Math.log"];

function extractFunctionBody(source, functionName) {
  const marker = `${functionName}(`;
  const start = source.indexOf(marker);
  assert.ok(start >= 0, `could not locate ${functionName}( in source`);
  const braceStart = source.indexOf("{", start);
  let depth = 0;
  let i = braceStart;
  for (; i < source.length; i++) {
    if (source[i] === "{") depth += 1;
    else if (source[i] === "}") {
      depth -= 1;
      if (depth === 0) break;
    }
  }
  return source.slice(braceStart, i + 1);
}

test("no native Math transcendental outside toDecimalString in _qfrac.js/_ir_eval.js", () => {
  for (const filePath of [QFRAC_PATH, IR_EVAL_PATH]) {
    const source = fs.readFileSync(filePath, "utf-8");
    let sourceOutsideAllowedException = source;
    if (source.includes("toDecimalString(")) {
      const body = extractFunctionBody(source, "toDecimalString");
      sourceOutsideAllowedException = source.replace(body, "");
    }
    for (const token of FORBIDDEN_TOKENS) {
      assert.ok(
        !sourceOutsideAllowedException.includes(token),
        `${path.basename(filePath)} contains ${token} outside toDecimalString's own function body`
      );
    }
  }
});

test("toDecimalString itself uses no native Math transcendental either (BigInt long division only)", () => {
  const source = fs.readFileSync(QFRAC_PATH, "utf-8");
  const body = extractFunctionBody(source, "toDecimalString");
  for (const token of FORBIDDEN_TOKENS) {
    assert.ok(!body.includes(token), `toDecimalString itself contains ${token}`);
  }
});

// ---------------------------------------------------------------------

console.log(`\n${passed} passed, ${failed} failed`);
process.exit(failed === 0 ? 0 : 1);
