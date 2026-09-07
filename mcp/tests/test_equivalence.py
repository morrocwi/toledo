from __future__ import annotations

from toledo_mcp import core, equivalence, index, queries


def test_exact_match_after_normalisation():
    a = core.normalise_formula(r"\partial_t \Phi = \nabla \cdot J")
    b = core.normalise_formula("∂_t Φ = ∇ · J")
    ev = equivalence.compare_statements(a, b)
    assert ev is not None
    assert ev.kind == "exact"
    assert ev.ratio == 1.0


def test_renaming_candidate_detected():
    a = core.normalise_formula("a != b")
    b = core.normalise_formula("x != y")
    ev = equivalence.compare_statements(a, b)
    assert ev is not None
    assert ev.kind == "renaming_candidate"
    assert "a->x" in ev.detail and "b->y" in ev.detail


def test_renaming_not_claimed_for_different_structure():
    a = core.normalise_formula("a != b")
    b = core.normalise_formula("a != b != c")
    ev = equivalence.compare_statements(a, b)
    assert ev is None or ev.kind != "renaming_candidate"


def test_positive_scale_candidate_detected():
    a2 = core.normalise_formula("y = 3 * x + 6")
    b2 = core.normalise_formula("y = 9 * x + 18")  # every literal * 3
    ev = equivalence.compare_statements(a2, b2)
    assert ev is not None
    assert ev.kind == "positive_scale_candidate"
    assert "k=3" in ev.detail


def test_negative_or_inconsistent_scale_not_claimed_as_positive_scale():
    a = core.normalise_formula("y = 3 * x + 6")
    b = core.normalise_formula("y = -3 * x + 18")  # inconsistent ratio (one negative, one x9)
    ev = equivalence.compare_statements(a, b)
    assert ev is None or ev.kind != "positive_scale_candidate"


def test_renaming_not_claimed_for_plain_prose_same_word_count():
    """Regression for a real false positive this design's own end-to-end
    stdio smoke test caught against the live registry: two ordinary English
    sentences with the same word count and repetition pattern (no
    mathematical content at all) must NOT be classified as a
    renaming_candidate merely because blanking out every word yields the
    same skeleton. See docs/DESIGN.md "A second bug the smoke test caught"."""
    a = core.normalise_formula("totally novel unregistered formula xyz123")
    b = core.normalise_formula("a mathematical theory of communication")
    ev = equivalence.compare_statements(a, b)
    assert ev is None or ev.kind != "renaming_candidate"


def test_renaming_still_claimed_for_genuine_equation_with_operator():
    a = core.normalise_formula("a != b")
    b = core.normalise_formula("x != y")
    ev = equivalence.compare_statements(a, b)
    assert ev is not None and ev.kind == "renaming_candidate"


def test_unrelated_statements_no_match():
    a = core.normalise_formula("y = 3 * x + 6")
    b = core.normalise_formula("completely different sentence about biology and cells")
    ev = equivalence.compare_statements(a, b)
    assert ev is None or ev.ratio < 0.6


def test_find_candidates_ranks_exact_above_structural():
    entries = [
        {"code": "A", "statement": {"latest": "y = 3 * x + 6"}},
        {"code": "B", "statement": {"latest": "totally unrelated text about oceans"}},
        {"code": "C", "statement": {"latest": "y = 9 * x + 18"}},
    ]
    hits = equivalence.find_candidates(core.normalise_formula, "y = 3*x+6", entries, limit=5)
    assert hits[0].code == "A"
    assert hits[0].kind == "exact"
    codes_returned = {h.code for h in hits}
    assert "C" in codes_returned  # positive-scale candidate should surface


def test_find_candidates_indexed_matches_full_scan_on_fixture(fixture_root):
    reg = core.load_registry(fixture_root)
    index.build_index(reg, fixture_root)
    conn = index.get_connection(fixture_root, auto_build=False)
    try:
        full = equivalence.find_candidates(core.normalise_formula, "x != y readout", reg.entries, limit=10)
        indexed = equivalence.find_candidates_indexed(conn, core.normalise_formula, "x != y readout", limit=10, length_band=12)
        assert {(h.code, h.kind) for h in full} == {(h.code, h.kind) for h in indexed}
    finally:
        conn.close()


def test_find_candidates_indexed_phi_len_not_confused_with_statement_norm_len(fixture_root):
    """Regression for a real bug this design's own benchmark caught against
    the live registry: `phi_len` (used by the length-band prefilter) MUST be
    computed with `core.normalise_formula` — the same normaliser
    `compare_statements` uses — not with `index.normalize_text` (used for
    `statement_norm`/plain-text search), which disagrees on length for any
    statement using LaTeX/Unicode math symbols (∂, δ, ·, ∇, ...). Using the
    wrong normaliser's length silently prefiltered out true exact/renaming
    matches on symbol-heavy statements; it did not show up on the plain-ASCII
    fixture entries above, only against real statements — see
    docs/DESIGN.md "A bug the benchmark caught"."""
    reg = core.load_registry(fixture_root)
    index.build_index(reg, fixture_root)
    conn = index.get_connection(fixture_root, auto_build=False)
    try:
        # EQ-001/P.02.v1 is the LaTeX spelling of EQ-001/P.01.v1's unicode
        # statement -- core.normalise_formula must fold both to the same
        # normalised string, and the indexed prefilter must find the exact
        # match despite the raw LaTeX source text being a very different
        # length/encoding from the raw unicode source text.
        hits = equivalence.find_candidates_indexed(
            conn, core.normalise_formula, "∂_t Φ = δ_R · ∇ Φ", limit=10, length_band=12
        )
        exact_codes = {h.code for h in hits if h.kind == "exact"}
        assert "EQ-001/P.01.v1" in exact_codes
        assert "EQ-001/P.02.v1" in exact_codes
    finally:
        conn.close()


def test_find_candidates_indexed_excludes_far_off_lengths(fixture_root):
    reg = core.load_registry(fixture_root)
    index.build_index(reg, fixture_root)
    conn = index.get_connection(fixture_root, auto_build=False)
    try:
        # "EQ-001/H.01.v1"'s statement is far longer than "a != b readout" --
        # a zero-width length band must exclude it even though it shares
        # tokens ("delta_R = (a ...) primordial distinction weld" contains
        # neither "!=" nor "readout" as a coincidence, but a wide band would
        # still let a difflib ratio slip it in; length_band=0 must not).
        hits_wide = equivalence.find_candidates_indexed(conn, core.normalise_formula, "a != b readout", limit=10, length_band=100)
        hits_narrow = equivalence.find_candidates_indexed(conn, core.normalise_formula, "a != b readout", limit=10, length_band=0)
        assert "EQ-001/H.01.v1" not in {h.code for h in hits_narrow}
        assert len(hits_narrow) <= len(hits_wide)
    finally:
        conn.close()
