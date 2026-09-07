"""φ-criterion-aware candidate equivalence matching.

`docs/EQ_CODE_SCHEME.md`'s merge rule: two raw equations are ONE object only
under the Equivalence Registry φ-criterion — "a documented bijective φ of
(i) renaming, (ii) fixed positive scale, (iii) fixed constant substitution
gives A(x)=B(φ(x)) on the shared domain — no limits, no approximations."
That is a mathematical judgment call a registrar documents; nothing in this
module (or anywhere in this package) automates or certifies it. What this
module DOES do is the mechanical part worth automating: given a candidate
statement, find the registry entries whose statement is a plausible match
under one of the three legs, tell the caller WHICH leg looks plausible and
WHY (the evidence a registrar would need to check), and stop there. A
"renaming_candidate"/"positive_scale_candidate" result is exactly that — a
candidate for a human (or a documented φ in a proposal) to confirm, per
`registry/SCHEMA.md`'s `test_merge_has_phi_evidence` — never a merge, never
a verdict of "the same object".

Builds on `core.normalise_formula`'s symbol-spelling table (unify
ascii/unicode/LaTeX spellings of the same operator to one token) rather than
re-deriving it, so the two modules' idea of "the same symbol" cannot drift
apart.
"""
from __future__ import annotations

import difflib
import re
from dataclasses import dataclass, field

def _resolve_limit(limit: int | None, default: int) -> int:
    """The same `limit` semantics as `core.resolve_limit` (0/missing ->
    `default`, negative -> `ValueError`), reimplemented here rather than
    imported so this module keeps no hard dependency on `core` (see module
    docstring) — `find_candidates`/`find_candidates_indexed` are this
    module's only two callers of `limit`, so a tiny duplicate is cheaper
    than the import it would otherwise need."""
    if limit is None or limit == 0:
        return default
    if limit < 0:
        raise ValueError("limit must be >= 0")
    return limit


_NUMBER_RE = re.compile(r"-?\d+(?:\.\d+)?")
_IDENT_RE = re.compile(r"[A-Za-z][A-Za-z0-9]*")

# Tokens `core.normalise_formula` already maps operator spellings to — these
# are NOT free identifiers even though they match _IDENT_RE, so renaming
# detection must not treat e.g. "grad" or "delta" as a variable name.
_OPERATOR_WORDS = {
    "delta", "Delta", "eta", "theta", "Theta", "Phi", "phi", "pi", "alpha",
    "beta", "gamma", "Gamma", "mu", "sigma", "tau", "chi", "lambda", "Lambda",
    "grad", "infinity", "exists", "forall", "sum", "integral", "sqrt", "in",
}


@dataclass
class EquivalenceEvidence:
    code: str
    kind: str  # "exact" | "renaming_candidate" | "positive_scale_candidate" | "structural_candidate"
    ratio: float
    detail: str


def _skeleton_and_identifiers(normalised: str) -> tuple[str, list[str]]:
    """Replace every free-identifier token with a positional placeholder in
    first-occurrence order (alpha-renaming canonicalisation), leaving numbers
    and known operator words untouched. Returns (skeleton, identifiers) where
    `identifiers` is the distinct free identifiers found, in first-occurrence
    order — the same skeleton from two statements with a consistent
    identifier count is the mechanical signature of a pure renaming."""
    seen: dict[str, str] = {}

    def repl(m: re.Match) -> str:
        tok = m.group(0)
        if tok in _OPERATOR_WORDS:
            return tok
        if tok not in seen:
            seen[tok] = f"V{len(seen)}"
        return seen[tok]

    skeleton = _IDENT_RE.sub(repl, normalised)
    return skeleton, list(seen.keys())


def _numeric_skeleton_and_literals(normalised: str) -> tuple[str, list[float]]:
    """Replace every numeric literal with a placeholder, returning the
    number-free skeleton and the literals in order — used for positive-scale
    detection: same skeleton + a single consistent positive ratio between
    corresponding literals is the mechanical signature of A(x) = k * B(x) on
    the constants actually written in the statement (not a proof the whole
    expression scales that way — see the docstring's "no limits, no
    approximations" boundary this stops short of)."""
    literals: list[float] = []

    def repl(m: re.Match) -> str:
        literals.append(float(m.group(0)))
        return "#"

    skeleton = _NUMBER_RE.sub(repl, normalised)
    return skeleton, literals


_EQUATION_SIGNAL_RE = re.compile(r"[=<>+\-*/^]|\d")


def _looks_like_equation(normalised: str) -> bool:
    """A crude but load-bearing guard against a real false-positive class
    this design's own end-to-end smoke test caught (see docs/DESIGN.md "A
    second bug the smoke test caught"): a `renaming_candidate` classification
    is just "same word count, same word-repetition pattern" once every free
    identifier is blanked out — which an ordinary ENGLISH SENTENCE with no
    mathematical content at all can match by pure coincidence (the smoke
    test found "totally novel unregistered formula xyz123" scored a 0.97
    renaming_candidate against the registry's own title-only record "A
    mathematical theory of communication" — five words, five substituted
    tokens, zero mathematical relationship). Requiring at least one
    equation-like signal (a relational/arithmetic operator, a known operator
    word from `_OPERATOR_WORDS`, or a digit) in normalised text before
    accepting the strong renaming/positive-scale verdicts does not eliminate
    false positives on genuine short equations that coincidentally share a
    shape, but it does rule out plain prose, which the registry demonstrably
    contains (`not_an_equation`/`untagged`-tier title/description strings)."""
    if _EQUATION_SIGNAL_RE.search(normalised):
        return True
    return any(re.search(rf"\b{re.escape(w)}\b", normalised) for w in _OPERATOR_WORDS)


def compare_statements(a_normalised: str, b_normalised: str) -> EquivalenceEvidence | None:
    """Compare two ALREADY-normalised statement strings (see
    `core.normalise_formula`) and return the strongest mechanical evidence
    found, or None if they share nothing worth reporting."""
    if not a_normalised or not b_normalised:
        return None
    if a_normalised == b_normalised:
        return EquivalenceEvidence("", "exact", 1.0, "normalised statements are byte-identical")
    if a_normalised.replace(" ", "") == b_normalised.replace(" ", ""):
        return EquivalenceEvidence("", "exact", 0.99, "identical once whitespace around operators is ignored")

    equation_like = _looks_like_equation(a_normalised) and _looks_like_equation(b_normalised)

    a_skel_id, a_idents = _skeleton_and_identifiers(a_normalised)
    b_skel_id, b_idents = _skeleton_and_identifiers(b_normalised)
    if equation_like and a_skel_id == b_skel_id and (a_idents != b_idents):
        mapping = ", ".join(f"{x}->{y}" for x, y in zip(a_idents, b_idents) if x != y)
        return EquivalenceEvidence(
            "", "renaming_candidate", 0.97,
            f"identical after alpha-renaming free identifiers (candidate mapping: {mapping or 'identity'}); "
            "confirm this is a documented bijective renaming, not a coincidental token match, before citing φ(renaming)",
        )

    a_skel_num, a_lits = _numeric_skeleton_and_literals(a_normalised)
    b_skel_num, b_lits = _numeric_skeleton_and_literals(b_normalised)
    if a_skel_num == b_skel_num and a_lits and len(a_lits) == len(b_lits):
        ratios = []
        ok = True
        for x, y in zip(a_lits, b_lits):
            if x == 0:
                ok = ok and (y == 0)
                continue
            ratios.append(y / x)
        if ok and ratios and all(r > 0 for r in ratios) and max(ratios) - min(ratios) < 1e-9:
            k = ratios[0]
            if abs(k - 1.0) > 1e-12:
                return EquivalenceEvidence(
                    "", "positive_scale_candidate", 0.95,
                    f"identical skeleton with every numeric literal scaled by a single consistent positive "
                    f"factor k={k:.6g}; confirm this is φ(positive scale) over the shared domain, not a "
                    "coincidence of the literals actually written",
                )

    ratio = difflib.SequenceMatcher(None, a_normalised, b_normalised).ratio()
    if ratio >= 0.6:
        return EquivalenceEvidence("", "structural_candidate", ratio, f"difflib similarity ratio {ratio:.3f}; no specific φ leg mechanically confirmed — read both statements")
    return None


def find_candidates(
    normalise_fn,
    query_statement: str,
    entries: list[dict],
    *,
    limit: int = 5,
) -> list[EquivalenceEvidence]:
    """`normalise_fn` is `core.normalise_formula` (passed in, not imported,
    to keep this module free of a hard dependency on `core`'s loading path).
    `entries` is any iterable of SCHEMA.md-shaped entry dicts (from
    `core.Registry.entries` or `queries` rows re-hydrated via `get`).

    `limit`: 0 or missing means "use the default of 5" (never "empty" — a
    bare `out[:limit]` used to silently return zero candidates for
    `limit=0`; see `core.resolve_limit`'s docstring for the full rationale
    shared by every search/list function in this package — reimplemented
    inline here, not imported, per this docstring's own no-hard-core-
    dependency rule above), negative raises `ValueError`."""
    limit = _resolve_limit(limit, 5)
    needle = normalise_fn(query_statement)
    out: list[EquivalenceEvidence] = []
    for e in entries:
        stmt = (e.get("statement") or {}).get("latest", "")
        cand = normalise_fn(stmt)
        ev = compare_statements(needle, cand)
        if ev is not None:
            ev.code = e.get("code")
            out.append(ev)
    _rank = {"exact": 0, "renaming_candidate": 1, "positive_scale_candidate": 1, "structural_candidate": 2}
    out.sort(key=lambda ev: (_rank.get(ev.kind, 3), -ev.ratio))
    return out[:limit]


# ---------------------------------------------------------------------------
# Indexed prefilter (see benchmarks/bench_index.py "equivalence_find_candidates
# _full_scan": comparing one statement against every registry entry with
# `compare_statements` costs ~0.9s over 1,504 entries on the machine this was
# measured on — too slow for an interactive tool call, and it only gets worse
# as the corpus grows toward its stated multi-thousand-entry target. None of
# the three φ-criterion legs this module detects (renaming, positive scale,
# structural similarity) change a statement's normalised CHARACTER LENGTH by
# more than a small amount — renaming preserves it exactly, and a scale
# substitution only changes it by the length delta between the old and new
# numeral spellings. `index.py` stores each entry's `core.normalise_formula`
# length (`phi_len`, indexed — NOT the plain-text `statement_len` used by
# `queries.search`'s LIKE fallback, which is a different normalisation with a
# different length) precisely so this prefilter can restrict the expensive
# pairwise comparison to a length-banded SQL slice instead of the whole
# table.
# ---------------------------------------------------------------------------

def find_candidates_indexed(conn, normalise_fn, query_statement: str, *, limit: int = 5, length_band: int = 12) -> list[EquivalenceEvidence]:
    """Same contract as `find_candidates`, but pre-filters via the SQLite
    index's `statement_len` column before running `compare_statements`, so
    the expensive per-pair comparison only ever runs against a length-banded
    slice of the registry, not all of it. See `benchmarks/bench_index.py`
    for the measured before/after cost of this prefilter.

    `limit`: same 0/missing/negative semantics as `find_candidates` above —
    see `_resolve_limit`."""
    limit = _resolve_limit(limit, 5)
    needle = normalise_fn(query_statement)
    needle_len = len(needle)
    rows = conn.execute(
        "SELECT code, statement FROM entries WHERE phi_len BETWEEN ? AND ?",
        (max(0, needle_len - length_band), needle_len + length_band),
    ).fetchall()
    out: list[EquivalenceEvidence] = []
    for row in rows:
        cand = normalise_fn(row["statement"])
        ev = compare_statements(needle, cand)
        if ev is not None:
            ev.code = row["code"]
            out.append(ev)
    _rank = {"exact": 0, "renaming_candidate": 1, "positive_scale_candidate": 1, "structural_candidate": 2}
    out.sort(key=lambda ev: (_rank.get(ev.kind, 3), -ev.ratio))
    return out[:limit]
