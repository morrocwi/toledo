"""tests/executable/test_extract_ir_guards.py -- EXEC-1 mechanical guards in
scripts/executable/extract_ir.py against identifier shattering and dropped clauses.

Both hazards were found by hand, after the fact, in the real registry:
EQ-001/P.45.v1's own eligibility.review_note names two mechanical defects a human reviewer had
to catch because extract_ir.py wrote a `status: "candidate"` sidecar anyway --
  (1) the bare (no leading backslash) identifier "Gamma_R" was shattered by sympy's
      parse_latex into a product of single-letter symbols (G, a, m, a_{R}), silently changing
      the map x' = Gamma_R*(x - u*t) into an unrelated six-factor product function;
  (2) the statement's second clause (t' = ...) and its declared exact witness were dropped
      entirely -- parse_latex only ever returns the first comma-separated relational clause.

This test exercises the two mechanical guards added to close both holes at extraction time
(no network, no token, no dependence on run order): `shattered_identifier_candidates` +
`confirm_shattered_identifiers`, and `dropped_clause_count`, wired into `extract_one` so that a
source triggering either guard is REJECTED (no sidecar written, `status: "skipped"` with a named
reason) rather than silently emitted as a `candidate`.

Known-bad case: EQ-001/P.45.v1's own real source text (must now be rejected at extraction, not
just caught later by a reviewer). Known-good case: EQ-001/P.63.v1's own real source text (must
still extract cleanly -- it also contains many ordinary English prose words after its equation,
which must NOT be mistaken for a shattered underscore-identifier or an extra dropped clause).
"""
from __future__ import annotations

import pathlib
import sys
import unittest

REPO_ROOT = pathlib.Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO_ROOT / "scripts" / "executable"))

import extract_ir as ei  # noqa: E402

COMMIT = "182a4914c8e08450b269e81f7fce1e6b3630bf0b"
SYMPY_VERSION = "1.14.0"
ANTLR4_VERSION = "4.11.0"

# Real registry content, quoted verbatim from
# registry/executable/EQ_001__P_45_v1.json / EQ_001__P_63_v1.json's own source_statement.text
# (and scripts/executable/_classify_output.json's matching entries).
P45_TEXT = (
    "x'=Gamma_R\\cdot (x-u\\cdot t), t'=Gamma_R\\cdot (t-u\\cdot x/v^2). "
    "Exact witness: event (t=8,x=5) \\to (t'=7,x'=-5/4); Q_v=Q_v'=75."
)
P63_TEXT = (
    "r_s = 2\\cdot G\\cdot E/c^4, admitted only as a declared calculator identity, "
    "not a derived theorem of this domain."
)


def _entry(code: str, text: str) -> dict:
    return {"code": code, "source_text": text, "field_used": "statement.latest", "root": "EQ-001"}


class TestShatteredIdentifierCandidates(unittest.TestCase):
    def test_finds_bare_underscore_identifier(self):
        self.assertEqual(ei.shattered_identifier_candidates(P45_TEXT), ["Gamma_R"])

    def test_single_letter_prefix_not_flagged(self):
        # "r_s", "Q_v", "x_" style identifiers (1-letter prefix) are NOT what parse_latex
        # shatters -- sympy keeps those intact as a single Symbol.
        hits = ei.shattered_identifier_candidates(P63_TEXT)
        self.assertNotIn("r_s", hits)

    def test_prose_words_are_not_underscore_identifiers(self):
        # P63's trailing prose ("admitted only as a declared calculator identity...") has no
        # underscore-bearing identifiers at all -- must not spuriously match.
        self.assertEqual(ei.shattered_identifier_candidates(P63_TEXT), [])


class TestDroppedClauseCount(unittest.TestCase):
    def test_p45_has_many_equals_multiple_clauses_dropped(self):
        self.assertGreater(ei.dropped_clause_count(P45_TEXT), 1)

    def test_p63_has_exactly_one_equals_no_dropped_clause(self):
        self.assertEqual(ei.dropped_clause_count(P63_TEXT), 1)


class TestExtractOneRejectsKnownBad(unittest.TestCase):
    def test_p45_is_rejected_by_shattered_identifier_guard(self):
        r = ei.extract_one(_entry("EQ-001/P.45.v1", P45_TEXT), COMMIT, SYMPY_VERSION, ANTLR4_VERSION)
        self.assertEqual(r["status"], "skipped")
        self.assertIn("shattered-identifier guard", r["reason"])
        self.assertIn("Gamma_R", r["reason"])
        self.assertNotIn("sidecar", r)  # never emits a candidate on rejection


class TestExtractOneAcceptsKnownGood(unittest.TestCase):
    def test_p63_still_extracts_cleanly(self):
        r = ei.extract_one(_entry("EQ-001/P.63.v1", P63_TEXT), COMMIT, SYMPY_VERSION, ANTLR4_VERSION)
        self.assertEqual(r["status"], "written", r.get("reason"))
        self.assertEqual(r["cross_check"], "PASS")
        self.assertEqual(r["sidecar"]["status"], "candidate")
        self.assertIsNone(r["sidecar"]["eligibility"]["reviewed_by"])


if __name__ == "__main__":
    unittest.main()
