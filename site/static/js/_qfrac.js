"use strict";
/*
 * site/static/js/_qfrac.js -- the ONE shared BigInt-based exact rational type for the Toledo
 * executable-equations JavaScript twin (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.5, stream S2).
 *
 * No dependency, no bundler, no `import`/`export` -- a bare <script> tag defines the global
 * `QFrac`/`QFracError` this file's own sibling, _ir_eval.js, and the site try-it widget both
 * consume. Loaded once per page as a permanent, cacheable, same-origin static asset (sec.5) --
 * never generated per entry.
 *
 * Every value is `{num: BigInt, den: BigInt}`, always kept in lowest terms (den > 0) via a
 * BigInt GCD. `toDecimalString` is the SOLE, NAMED, ISOLATED exception where a
 * floating-point-*shaped* decimal string is ever produced (via exact BigInt long division, no
 * native float arithmetic) -- it is display-only and is never fed back into a comparison or
 * another QFrac operation; every other method here stays exact-rational, always.
 */
(function (root) {
  function bigAbs(x) {
    return x < 0n ? -x : x;
  }

  function bigGcd(a, b) {
    a = bigAbs(a);
    b = bigAbs(b);
    while (b !== 0n) {
      const t = a % b;
      a = b;
      b = t;
    }
    return a === 0n ? 1n : a;
  }

  class QFracError extends Error {}

  class QFrac {
    /**
     * @param {bigint|number|string} num
     * @param {bigint|number|string} den
     */
    constructor(num, den) {
      if (den === undefined) den = 1n;
      num = QFrac._toBigInt(num, "numerator");
      den = QFrac._toBigInt(den, "denominator");
      if (den === 0n) throw new QFracError("QFrac denominator must not be zero");
      if (den < 0n) {
        num = -num;
        den = -den;
      }
      const g = bigGcd(num, den);
      this.num = num / g;
      this.den = den / g;
    }

    static _toBigInt(v, label) {
      if (typeof v === "bigint") return v;
      if (typeof v === "number") {
        if (!Number.isInteger(v)) {
          throw new QFracError(`QFrac ${label} must be an integer, got non-integer number ${v}`);
        }
        return BigInt(v);
      }
      if (typeof v === "string") {
        try {
          return BigInt(v);
        } catch (e) {
          throw new QFracError(`QFrac ${label} could not be parsed as an integer: "${v}"`);
        }
      }
      throw new QFracError(`QFrac ${label} must be a bigint, integer number, or integer string`);
    }

    /**
     * Parse an exact-rational literal string ("3", "-1/2", "22/7") into a QFrac. Never accepts
     * a JS `number` directly -- the caller must already hold a string, so no floating value
     * ever crosses into this parser (mirrors ir_kernel.parse_rational's own contract).
     */
    static fromString(s) {
      if (typeof s !== "string") {
        throw new QFracError("a rational literal must be given as a string, never a number");
      }
      const text = s.trim();
      if (text.length === 0) throw new QFracError("empty string is not a valid rational literal");
      if (text.includes("/")) {
        const parts = text.split("/");
        if (parts.length !== 2) throw new QFracError(`invalid exact-rational literal: "${s}"`);
        try {
          return new QFrac(QFrac._parseSignedInt(parts[0]), QFrac._parseSignedInt(parts[1]));
        } catch (e) {
          throw new QFracError(`invalid exact-rational literal: "${s}"`);
        }
      }
      try {
        return new QFrac(QFrac._parseSignedInt(text), 1n);
      } catch (e) {
        throw new QFracError(`invalid exact-rational literal: "${s}"`);
      }
    }

    static _parseSignedInt(s) {
      const t = s.trim();
      if (!/^[+-]?\d+$/.test(t)) throw new QFracError(`not an integer: "${s}"`);
      return BigInt(t);
    }

    static fromInt(n) {
      return new QFrac(BigInt(n), 1n);
    }

    add(other) {
      return new QFrac(this.num * other.den + other.num * this.den, this.den * other.den);
    }

    sub(other) {
      return new QFrac(this.num * other.den - other.num * this.den, this.den * other.den);
    }

    mul(other) {
      return new QFrac(this.num * other.num, this.den * other.den);
    }

    div(other) {
      if (other.num === 0n) throw new QFracError("division by zero");
      return new QFrac(this.num * other.den, this.den * other.num);
    }

    neg() {
      return new QFrac(-this.num, this.den);
    }

    abs() {
      return this.num < 0n ? this.neg() : this;
    }

    /** Integer exponent only (sec.5) -- never a fractional/irrational power. */
    pow(n) {
      let exp = typeof n === "bigint" ? n : BigInt(n);
      if (exp === 0n) return QFrac.fromInt(1);
      if (exp < 0n) {
        if (this.num === 0n) throw new QFracError("cannot raise zero to a negative power");
        return new QFrac(this.den ** -exp, this.num ** -exp);
      }
      return new QFrac(this.num ** exp, this.den ** exp);
    }

    isZero() {
      return this.num === 0n;
    }

    /** -1, 0, or 1. */
    cmp(other) {
      const l = this.num * other.den;
      const r = other.num * this.den;
      if (l < r) return -1;
      if (l > r) return 1;
      return 0;
    }

    lt(other) {
      return this.cmp(other) < 0;
    }
    gt(other) {
      return this.cmp(other) > 0;
    }
    eq(other) {
      return this.cmp(other) === 0;
    }

    /**
     * Round to `digits` decimal digits, returned as an exact QFrac whose denominator divides
     * 10**digits -- integer arithmetic only (BigInt divmod, floor + round-half-up), never a
     * float. Mirrors scripts/executable/ir_kernel.py::_round_to_precision EXACTLY, digit for
     * digit, so both interpreters bound the bit-length of a transcendental accumulator the
     * identical way -- including at a negative exact tie (Python's `divmod` always yields a
     * remainder in [0, denominator), i.e. floor division, and rounds every exact tie toward
     * +infinity; this method reproduces that same rule via a floor-corrected remainder rather
     * than a magnitude/sign-based tie-break, which previously rounded a negative exact tie
     * away from zero -- the opposite direction from the Python reference).
     */
    roundToPrecision(digits) {
      const scale = 10n ** BigInt(digits);
      const numerator = this.num * scale;
      const denominator = this.den; // always > 0 -- QFrac's own constructor invariant
      let quotient = numerator / denominator;
      let remainder = numerator % denominator;
      if (remainder < 0n) {
        remainder += denominator;
        quotient -= 1n;
      }
      if (2n * remainder >= denominator) quotient += 1n;
      return new QFrac(quotient, scale);
    }

    toString() {
      return this.den === 1n ? this.num.toString() : `${this.num}/${this.den}`;
    }

    /**
     * DISPLAY-ONLY decimal rendering to `digits` fractional digits, via exact BigInt long
     * division (no native float arithmetic anywhere in this method). Captioned by every
     * caller as "decimal display only, not the computed value" (sec.7) -- never compared
     * against another QFrac, never round-tripped back into arithmetic.
     */
    toDecimalString(digits) {
      const sign = this.num < 0n ? "-" : "";
      const n = bigAbs(this.num);
      const d = this.den;
      const scale = 10n ** BigInt(digits);
      const scaled = (n * scale) / d;
      const intPart = scaled / scale;
      const fracPart = (scaled % scale).toString().padStart(digits, "0");
      return digits > 0 ? `${sign}${intPart}.${fracPart}` : `${sign}${intPart}`;
    }
  }

  root.QFrac = QFrac;
  root.QFracError = QFracError;
})(typeof globalThis !== "undefined" ? globalThis : this);
