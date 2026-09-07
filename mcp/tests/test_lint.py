"""Tests for toledo_mcp.lint (TODO IDM-5).

12 statements (6 clean, 6 continuum-injecting) exercising the
contaminated-concept -> discrete-replacement rule table, plus one
live-registry test that every `toledo_code` alias in `lint.RULES` actually
resolves against the real registry (registry/genesis_root.json's IDM
root-extension rows) — not "code pending".
"""
from __future__ import annotations

from toledo_mcp import cache as cache_mod
from toledo_mcp import lint

# ---------------------------------------------------------------------------
# 6 clean statements — must never fire a rule.
# ---------------------------------------------------------------------------

CLEAN_STATEMENTS = [
    "1/3 + 1/6 = 1/2, exact rational arithmetic in Q, no rounding.",
    "the graph Laplacian L_R is symmetric, positive semi-definite, with kernel containing the constants.",
    "overlap(v,e) = |<v,e>_G|^2 / (<v,v>_G * <e,e>_G), a Born-rule ratio in [0,1].",
    "the retained difference delta_R exists between a and b: a != b.",
    "D is a commutative semiring modelling Peano arithmetic; Z is its Grothendieck completion.",
    "the discrete FTC: the telescoping sum of Delta f from i=1 to n equals f(n) minus f(0).",
]

# ---------------------------------------------------------------------------
# 6 continuum-injecting statements, one per class family below.
# ---------------------------------------------------------------------------

INJECTING = [
    ("the angle between the two vectors is 37.5 degrees, computed via acos(cos_theta).", {"angle_degree"}),
    ("as N tends to infinity the sum converges to a real number by completeness of ℝ (LUB).", {"I1"}),
    ("in the limit h→0 the continuum PDE governs wave propagation via ∂²u/∂t².", {"I2", "continuum_operator"}),
    ("space is built from points of zero extent r=0, each a delta-source.", {"Z1"}),
    ("the exact vacuum state has T=0 and v=0 everywhere.", {"Z3"}),
    ("the distance between two points is √Σ(Δx_i)², the usual Euclidean formula.", {"coordinate_distance"}),
]


def test_clean_statements_produce_clean_verdict():
    for statement in CLEAN_STATEMENTS:
        result = lint.lint_statement(statement)
        assert result["verdict"] == "clean", (statement, result["findings"])
        assert result["findings"] == []


def test_injecting_statements_are_flagged_with_expected_classes():
    for statement, expected_classes in INJECTING:
        result = lint.lint_statement(statement)
        assert result["verdict"] == "continuum_injection_warned", statement
        found_classes = {f["class"] for f in result["findings"]}
        assert expected_classes <= found_classes, (statement, found_classes)
        for finding in result["findings"]:
            assert finding["severity"] == "warn"
            assert finding["why"]
            assert finding["discrete_replacement"]
            assert finding["toledo_code"]  # never empty/None — "code pending" fails soft, never blank


def test_never_blocks_verdict_is_one_of_two_values():
    """P24: this lint disciplines, it never gates. Only two verdict strings
    exist in this module's vocabulary, for both clean and injecting input."""
    for statement in CLEAN_STATEMENTS + [s for s, _ in INJECTING]:
        result = lint.lint_statement(statement)
        assert result["verdict"] in {"clean", "continuum_injection_warned"}


def test_code_is_echoed_back_but_does_not_change_findings():
    bare = lint.lint_statement("the angle is 12 degrees")
    with_code = lint.lint_statement("the angle is 12 degrees", code="EQ-999999")
    assert with_code["code"] == "EQ-999999"
    assert bare["code"] is None
    assert [f["class"] for f in with_code["findings"]] == [f["class"] for f in bare["findings"]]


def test_unresolvable_alias_fails_soft_to_code_pending():
    class _EmptyRegistry:
        entries: list = []

    class _EmptyCache:
        registry = _EmptyRegistry()

        def ensure_fresh(self):
            return False

    assert lint.resolve_toledo_code("IDM:reals-R", cache=_EmptyCache()) == "code pending"


def test_every_rule_alias_resolves_against_the_real_registry(real_root):
    """Live-registry test (mcp/DESIGN.md-style discipline): every
    `LintRule.alias` in `lint.RULES` must resolve to a real Toledo code
    against the actual, currently-checked-in registry — not fall back to
    "code pending". This is what keeps the rule table honest as the IDM
    root-extension rows in registry/genesis_root.json evolve."""
    cache_mod.reset_cache_for_tests()
    c = cache_mod.get_cache(real_root)
    unresolved = []
    for rule in lint.RULES:
        code = lint.resolve_toledo_code(rule.alias, cache=c)
        if code == "code pending":
            unresolved.append((rule.cls, rule.alias))
    assert unresolved == [], f"aliases not found in the live registry: {unresolved}"
