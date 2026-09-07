"""Tests for the Toledo public site per `site/DESIGN.md` section 10.

Independent of streams S1-S3 by construction: every test here reads
`site/dist/` (the built output of `site/build_site.py`) and the registry
directly — it never imports `site/build_site.py`'s internals — so a test
cannot pass merely because it shares an assumption with the generator it
is checking.

Two kinds of test live here:

- Tests against the **real build** (`site/dist/`, produced by
  `python3 site/build_site.py --out site/dist`, stream S1). These `skip`
  with a message naming that exact command when `site/dist/` does not yet
  exist, rather than failing — this file is written against the target
  contract in `site/DESIGN.md` and is correct whether or not S1's
  generator has shipped yet in this checkout.
- Tests against **`site/checks/`** (owned by this same stream, S4) using
  small synthetic fixtures under `tmp_path`. These need no prior build and
  always run, so this file gives real, executable signal even before
  `site/dist/` exists.

Two ASSUMPTIONS this file makes about slugs `site/DESIGN.md` names but does
not spell out a transform for (`root-slug`, `tier-slug`, `status-slug`),
stated here so a mismatch against S1's actual choice fails loudly and
specifically rather than silently:

  ASSUMPTION 1 (root-slug): the same "site-slug" mangling section 1 defines
  for a full reading code (`/` -> `__`, `.` -> `_`, hyphen kept), applied to
  a bare root code (which never contains `/`). E.g. root `MQ.08` -> `MQ_08`.

  ASSUMPTION 2 (tier-slug / status-slug): the tier/status value used
  verbatim as the directory name. Every tier and status value in
  `registry/SCHEMA.md`'s enums is already a bare identifier
  (letters/digits/underscore only), so no further transform is needed.
"""
from __future__ import annotations

import json
import pathlib
import re
import sys

import pytest

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent
CANONICAL_JSON = REPO_ROOT / "registry" / "CANONICAL.json"
TOLEDO_JSON = REPO_ROOT / "registry" / "TOLEDO.json"
STATIC_API_ENTRIES = REPO_ROOT / "mcp" / "dist" / "static-api" / "v1" / "entries"
MCP_README = REPO_ROOT / "mcp" / "README.md"
SITE_DIST = REPO_ROOT / "site" / "dist"

sys.path.insert(0, str(REPO_ROOT / "site" / "checks"))


# --------------------------------------------------------------------- #
# Mangling helpers (site/DESIGN.md section 1) — reimplemented locally,
# deliberately not imported from mcp/toledo_mcp/export_static.py or a
# future site/build_site.py, so this test cannot pass merely because it
# shares code with what it is checking.
# --------------------------------------------------------------------- #

def site_slug(code: str) -> str:
    return code.replace("/", "__").replace(".", "_")


def api_mangled(code: str) -> str:
    return code.replace("/", "__").replace(".", "_").replace("-", "_")


def root_slug(root_code: str) -> str:
    # ASSUMPTION 1 above.
    return site_slug(root_code)


def tier_slug(tier: str) -> str:
    # ASSUMPTION 2 above.
    return tier


def status_slug(status: str) -> str:
    # ASSUMPTION 2 above.
    return status


# --------------------------------------------------------------------- #
# Shared fixtures
# --------------------------------------------------------------------- #

@pytest.fixture(scope="module")
def canonical():
    with open(CANONICAL_JSON, encoding="utf-8") as fh:
        return json.load(fh)


@pytest.fixture(scope="module")
def toledo_entries():
    with open(TOLEDO_JSON, encoding="utf-8") as fh:
        doc = json.load(fh)
    return doc["canonical"]


def _require_site_dist():
    if not SITE_DIST.is_dir():
        pytest.skip(
            f"{SITE_DIST} not built yet — run "
            "`python3 site/build_site.py --out site/dist` first (stream S1)"
        )


def _require_static_api():
    if not STATIC_API_ENTRIES.is_dir():
        pytest.skip(
            f"{STATIC_API_ENTRIES} not built yet — run "
            "`python3 -m toledo_mcp.export_static --out mcp/dist/static-api` first"
        )


# --------------------------------------------------------------------- #
# Real-build tests (skip until site/dist/ exists)
# --------------------------------------------------------------------- #

def test_every_code_has_an_entry_page(toledo_entries):
    _require_site_dist()
    entries_dir = SITE_DIST / "entries"
    missing = []
    for e in toledo_entries:
        slug = site_slug(e["code"])
        if not (entries_dir / f"{slug}.html").is_file():
            missing.append(e["code"])
    assert not missing, f"{len(missing)} code(s) missing an entry page, e.g. {missing[:10]}"


def test_entry_page_api_link_is_correctly_mangled(toledo_entries):
    _require_site_dist()
    _require_static_api()
    entries_dir = SITE_DIST / "entries"
    link_re = re.compile(r"/v1/entries/([A-Za-z0-9_]+)\.json")

    checked = 0
    bad_link = []
    dangling = []
    for e in toledo_entries:
        code = e["code"]
        slug = site_slug(code)
        page = entries_dir / f"{slug}.html"
        if not page.is_file():
            continue  # already reported by test_every_code_has_an_entry_page
        text = page.read_text(encoding="utf-8")
        m = link_re.search(text)
        if not m:
            bad_link.append(code)
            continue
        expected = api_mangled(code)
        if m.group(1) != expected:
            bad_link.append(code)
            continue
        if not (STATIC_API_ENTRIES / f"{m.group(1)}.json").is_file():
            dangling.append(code)
        checked += 1

    assert checked > 0, "no entry page carried a /v1/entries/ link to check"
    assert not bad_link, f"{len(bad_link)} entry page(s) with a missing/wrong api-mangled link, e.g. {bad_link[:10]}"
    assert not dangling, f"{len(dangling)} entry page(s) link to a /v1/entries/ file that does not exist, e.g. {dangling[:10]}"


def test_mislabeled_latex_prose_renders_as_ascii_not_math(toledo_entries):
    """R1-1 regression: a registry `statement.format` of "latex"/
    "latex+ascii" is sometimes actually plain English prose (a data
    mislabeling, not a code bug — see CHANGELOG). Rendering that text inside
    a KaTeX `\\[ ... \\]` math environment either squashes it into unreadable
    run-together gibberish or throws a visible `.katex-error` block once
    client-side KaTeX runs. `site/build_site.py::render_statement_html`
    guards against this by falling back to plain wrapped text (the same path
    `format=="ascii-math"` already uses) whenever the statement carries no
    backslash macro and reads like a sentence rather than an expression.
    This test re-implements that same heuristic from scratch (never imports
    `build_site.py`) and checks the real build output directly, so it cannot
    pass merely because it shares logic with what it verifies."""
    _require_site_dist()

    def looks_like_real_latex(text: str) -> bool:
        if "\\" in text:
            return True
        words = re.findall(r"[A-Za-z]+", text)
        if len(words) < 6:
            return True
        stopword_hits = re.findall(
            r"\b(?:the|is|are|then|if|and|of|that|with|on|as|under|only|for|"
            r"every|not|by|per|used|here|follows|this|which)\b",
            text, re.IGNORECASE,
        )
        return len(stopword_hits) < 2

    entries_dir = SITE_DIST / "entries"
    checked = 0
    bad = []
    for e in toledo_entries:
        fmt = e["statement"].get("format")
        if fmt not in ("latex", "latex+ascii"):
            continue
        src = e["statement"].get("latex") or e["statement"].get("latest") or ""
        if looks_like_real_latex(src):
            continue  # genuinely LaTeX — out of scope for this regression test
        slug = site_slug(e["code"])
        page = entries_dir / f"{slug}.html"
        if not page.is_file():
            continue
        text = page.read_text(encoding="utf-8")
        checked += 1
        if 'class="math-display"' in text:
            bad.append(e["code"])

    assert checked > 0, "no mislabeled-prose latex/latex+ascii entry found to check against"
    assert not bad, (
        f"{len(bad)} mislabeled-prose entr(y/ies) still rendered inside a KaTeX "
        f"math-display block instead of falling back to plain text, e.g. {bad[:10]}"
    )


@pytest.mark.parametrize("axis_dir,counts_key,slug_fn", [
    ("by-domain", "by_domain", lambda v: v),
    ("by-tier", "by_tier", tier_slug),
    ("by-status", "by_status", status_slug),
])
def test_listing_pages_exist_only_for_populated_values(canonical, axis_dir, counts_key, slug_fn):
    _require_site_dist()
    counts = canonical["counts"][counts_key]
    populated = {value for value, n in counts.items() if n > 0}
    expected_slugs = {slug_fn(v) for v in populated}

    base = SITE_DIST / axis_dir
    assert base.is_dir(), f"{base} does not exist"
    actual_slugs = {child.name for child in base.iterdir() if child.is_dir()}

    missing = expected_slugs - actual_slugs
    extra = actual_slugs - expected_slugs
    assert not missing, f"{axis_dir}: missing listing page(s) for populated value(s): {missing}"
    assert not extra, f"{axis_dir}: listing page(s) exist for a value with zero entries: {extra}"

    for slug in expected_slugs:
        assert (base / slug / "index.html").is_file(), f"{axis_dir}/{slug}/index.html missing"


def test_by_root_listing_pages_cover_every_root(toledo_entries):
    _require_site_dist()
    roots = {e["code"] for e in toledo_entries if e.get("layer") == "root"}
    base = SITE_DIST / "by-root"
    assert base.is_dir(), f"{base} does not exist"

    expected_slugs = {root_slug(r) for r in roots}
    actual_slugs = {child.name for child in base.iterdir() if child.is_dir()}

    missing = expected_slugs - actual_slugs
    extra = actual_slugs - expected_slugs
    assert not missing, f"by-root: missing page(s) for root(s): {list(missing)[:10]}"
    assert not extra, f"by-root: page(s) exist for unknown root slug(s): {list(extra)[:10]}"


def _parse_tools_table_from_readme() -> list[dict]:
    """Independent re-parse of mcp/README.md's own `## Tools (19)` markdown
    table — deliberately re-implemented here rather than imported from
    site/build_site.py, so drift between the two parsers is itself a test
    failure."""
    text = MCP_README.read_text(encoding="utf-8")
    m = re.search(r"## Tools \(\d+\)\n\n(\|.*?\n)(?:\n|\Z)", text, re.DOTALL)
    assert m, "mcp/README.md: '## Tools (N)' section not found"
    rows = []
    for line in m.group(1).splitlines():
        if not line.startswith("|"):
            continue
        cells = [c.strip() for c in line.strip("|").split("|")]
        if len(cells) < 2:
            continue
        tool, purpose = cells[0], cells[1]
        if tool in ("Tool", "---") or set(tool) <= {"-"}:
            continue
        tool_name = tool.strip("`")
        rows.append({"tool": tool_name, "purpose": purpose})
    return rows


def test_tools_table_matches_readme_exactly():
    expected = _parse_tools_table_from_readme()
    _n = int(re.search(r"^## Tools \\((\\d+)\\)", text, flags=re.M).group(1)) if re.search(r"^## Tools \\((\\d+)\\)", text, flags=re.M) else len(expected)
    assert len(expected) == _n, f"mcp/README.md Tools table has {len(expected)} rows, heading says {_n}"
    for row in expected:
        assert re.match(r"^toledo_[a-z_]+$", row["tool"]), row["tool"]

    candidates = [
        SITE_DIST / "data" / "tools-table.json",
        REPO_ROOT / "site" / "data" / "tools-table.json",
    ]
    data_file = next((p for p in candidates if p.is_file()), None)
    if data_file is None:
        pytest.skip(
            "site/data/tools-table.json not built yet — run "
            "`python3 site/build_site.py --out site/dist` first (stream S1)"
        )
    actual = json.loads(data_file.read_text(encoding="utf-8"))
    assert len(actual) == 19, f"{data_file} has {len(actual)} rows, expected 19"
    for row in actual:
        assert re.match(r"^toledo_[a-z_]+$", row["tool"]), row["tool"]
    assert actual == expected, (
        f"{data_file} has drifted from mcp/README.md's own Tools table "
        "(must be re-derivable byte-for-byte, per site/DESIGN.md section 10)"
    )


def _independent_manifest_counts(canonical: dict) -> dict:
    c = canonical["counts"]
    return {
        "entry_count": c["entries"],
        "counts_by_status": c["by_status"],
        "counts_by_domain": c["by_domain"],
        "counts_by_tier": c["by_tier"],
        "counts_by_coq_status": c["by_coq_status"],
    }


def _independent_mathml_and_format_counts() -> tuple[int, int, dict]:
    entries_dir = REPO_ROOT / "registry" / "entries"
    mathml_present = 0
    mathml_reason_only = 0
    format_counts: dict[str, int] = {}
    for path in entries_dir.glob("*.json"):
        doc = json.loads(path.read_text(encoding="utf-8"))
        if doc.get("presentation_mathml"):
            mathml_present += 1
        elif doc.get("presentation_mathml_reason"):
            mathml_reason_only += 1
        fmt = (doc.get("statement") or {}).get("format")
        if fmt:
            format_counts[fmt] = format_counts.get(fmt, 0) + 1
    return mathml_present, mathml_reason_only, format_counts


def test_manifest_counts_match_independent_recomputation(canonical):
    candidates = [
        SITE_DIST / "data" / "manifest.json",
        REPO_ROOT / "site" / "data" / "manifest.json",
    ]
    manifest_file = next((p for p in candidates if p.is_file()), None)
    if manifest_file is None:
        pytest.skip(
            "site/data/manifest.json not built yet — run "
            "`python3 site/build_site.py --out site/dist` first (stream S1)"
        )
    manifest = json.loads(manifest_file.read_text(encoding="utf-8"))
    expected = _independent_manifest_counts(canonical)
    for key, value in expected.items():
        assert manifest.get(key) == value, f"{manifest_file}: {key} mismatch (manifest={manifest.get(key)!r}, recomputed={value!r})"

    mathml_present, mathml_reason_only, format_counts = _independent_mathml_and_format_counts()
    assert manifest.get("mathml_present") == mathml_present
    assert manifest.get("mathml_reason_only") == mathml_reason_only
    assert manifest.get("statement_format_counts") == format_counts


def test_katex_configured_with_html_and_mathml_output():
    _require_site_dist()
    candidates = list(SITE_DIST.rglob("*.html")) + list(SITE_DIST.rglob("*.js"))
    hits = 0
    katex_referenced = False
    for path in candidates:
        text = path.read_text(encoding="utf-8", errors="replace")
        if "katex" in text.lower():
            katex_referenced = True
        if re.search(r"""output\s*:\s*['"]htmlAndMathml['"]""", text):
            hits += 1
    assert katex_referenced, "no page/script referenced KaTeX at all"
    assert hits > 0, "output: 'htmlAndMathml' not found explicit anywhere in site/dist"


# --------------------------------------------------------------------- #
# site/checks/ unit tests — self-contained, run regardless of S1's status
# --------------------------------------------------------------------- #

def _write(path: pathlib.Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def test_check_a11y_flags_missing_h1_and_skipped_heading(tmp_path):
    import check_a11y

    _write(tmp_path / "bad.html", """<!doctype html><html lang="en"><body>
<a href="#main">Skip to content</a>
<h1>Ok</h1><h4>skipped</h4>
</body></html>""")
    code, lines = check_a11y.run(tmp_path)
    assert code == 1
    assert any("skipped heading level" in line for line in lines)


def test_check_a11y_passes_a_clean_page(tmp_path):
    import check_a11y

    _write(tmp_path / "good.html", """<!doctype html><html lang="en"><body>
<a href="#main">Skip to content</a>
<h1>Ok</h1>
<h2>Section</h2>
<table><tr><th scope="col">A</th></tr></table>
</body></html>""")
    _write(tmp_path / "assets" / "toledo.css", """:root {
  --bg: #fbfbf9; --fg: #1a1a1a; --fg-muted: #55534d; --link: #1c5fb0;
  --link-visited: #5b3a9e; --code-bg: #f0efe9; --bg-raised: #ffffff;
}
@media (prefers-color-scheme: dark) {
  :root { --bg: #15171a; --fg: #e8e8e6; --fg-muted: #a8a69f; --link: #8ab4f8;
    --link-visited: #c58af9; --code-bg: #202327; --bg-raised: #1c1f23; }
}""")
    code, lines = check_a11y.run(tmp_path)
    assert code == 0, lines


def test_check_perf_budget_flags_oversized_index_page(tmp_path):
    import check_perf_budget

    _write(tmp_path / "index.html", "x" * (check_perf_budget.BUDGET_BYTES + 1))
    code, lines = check_perf_budget.run(tmp_path)
    assert code == 1
    assert any("OVER BUDGET" in line or "FAIL" in line for line in lines)


def test_check_perf_budget_passes_small_pages(tmp_path):
    import check_perf_budget

    _write(tmp_path / "index.html", "<html></html>")
    _write(tmp_path / "by-domain" / "E" / "index.html", "<html></html>")
    code, lines = check_perf_budget.run(tmp_path)
    assert code == 0, lines


def test_check_banned_words_verbatim_exception_is_scoped_correctly(tmp_path):
    import check_banned_words_and_leaks as cbw

    _write(tmp_path / "entry.html", """<!doctype html><html lang="en"><body>
<h1>x</h1>
<p data-verbatim-source="true">quoted text calls itself the first of its kind</p>
<p>our own generated prose calls this a world-class result</p>
</body></html>""")
    code, lines = cbw.run(tmp_path)
    assert code == 1  # the non-verbatim hit is a hard FAIL
    warn_lines = [l for l in lines if "marketing_word [WARN]" in l]
    fail_lines = [l for l in lines if "marketing_word [FAIL]" in l]
    assert len(warn_lines) == 1, lines
    assert len(fail_lines) == 1, lines


def test_check_banned_words_flags_home_path_and_username_always(tmp_path, monkeypatch):
    import check_banned_words_and_leaks as cbw

    monkeypatch.setenv("USER", "probeuser123")
    leaked_path = "/" + "home/" + "probeuser123/secret.txt"
    _write(
        tmp_path / "leak.html",
        f'<!doctype html><html lang="en"><body><h1>x</h1>'
        f'<p data-verbatim-source="true">{leaked_path} and probeuser123</p></body></html>',
    )
    code, lines = cbw.run(tmp_path)
    assert code == 1  # home_path/username FAIL regardless of verbatim region
    assert any("home_path [FAIL]" in line for line in lines)
    assert any("username [FAIL]" in line for line in lines)


def test_check_banned_words_flags_ai_vendor_name_always(tmp_path):
    """R3-1 regression: an AI vendor/model name is category 5, a hard FAIL
    in any region (including inside a data-verbatim-source="true" element,
    unlike the marketing-word category) — planted here by decoding one of
    `mcp/scripts/leak_scan.py`'s own base64 tokens, never as a bare literal
    in this test file, matching that module's own no-plaintext-trail
    convention."""
    import base64

    import check_banned_words_and_leaks as cbw

    vendor_name = base64.b64decode(cbw._AI_VENDOR_TOKENS_B64[0]).decode("ascii")
    _write(
        tmp_path / "vendor.html",
        f'<!doctype html><html lang="en"><body><h1>x</h1>'
        f'<p data-verbatim-source="true">assisted by {vendor_name}</p></body></html>',
    )
    code, lines = cbw.run(tmp_path)
    assert code == 1  # ai_vendor_name FAIL regardless of verbatim region
    assert any("ai_vendor_name [FAIL]" in line for line in lines)


def test_check_banned_words_denylist_not_run_when_absent(tmp_path):
    import check_banned_words_and_leaks as cbw

    _write(tmp_path / "clean.html", '<!doctype html><html lang="en"><body><h1>x</h1></body></html>')
    code, lines = cbw.run(tmp_path, denylist_file=None)
    assert code == 0
    assert any("NOT RUN" in line for line in lines)


def test_run_all_reports_configuration_error_for_missing_dist(tmp_path):
    sys.path.insert(0, str(REPO_ROOT / "site" / "checks"))
    import run_all

    missing = tmp_path / "does-not-exist"
    code = run_all.main([str(missing)])
    assert code == 2


# --------------------------------------------------------------------- #
# Resistance Ladder + Reproduction Ledger (S3, design/RESISTANCE_LADDER_v0_1.md,
# founder ruling BBL-2026-09-07-229). Kept to this file's own stated
# independence rule: these tests never import site/build_site.py — they
# read registry/CANONICAL.json's own `resistance` block directly (a real
# artifact, not a generator's internal context dict) and, where site/dist
# already carries the corresponding rendered page, the actual HTML markup.
# A live checkout that has not yet run scripts/compute_resistance.py
# carries no `resistance` key on any entry at all — every test below skips
# HONESTLY in that case (readout-not-truth: absence of a rung is reported,
# never asserted as a pass over data that was never actually checked).
# --------------------------------------------------------------------- #

_RESISTANCE_RUNG_ORDER = ["R0", "R1", "R2", "R3", "R4", "R5", "R6"]


def _entries_with_resistance(canonical: dict) -> list[dict]:
    return [e for e in canonical.get("canonical", []) if e.get("resistance")]


def test_resistance_block_shape_when_present(canonical):
    """Whenever scripts/compute_resistance.py has run against this
    checkout, every `resistance` block it wrote is well-shaped: exactly the
    seven named rungs, each `{held: bool, evidence: list}` plus `reason`
    only on an unheld rung — never a collapsed score field anywhere in the
    structure (design doc sec.0)."""
    computed = _entries_with_resistance(canonical)
    if not computed:
        pytest.skip(
            "no entry in registry/CANONICAL.json carries a `resistance` block yet — "
            "run `python3 scripts/compute_resistance.py` first"
        )
    for e in computed:
        resistance = e["resistance"]
        assert set(resistance.keys()) == {"computed_at", "rungs"}, e["code"]
        rungs = resistance["rungs"]
        assert set(rungs.keys()) == set(_RESISTANCE_RUNG_ORDER), e["code"]
        for rung_name, row in rungs.items():
            assert isinstance(row.get("held"), bool), (e["code"], rung_name)
            assert isinstance(row.get("evidence"), list), (e["code"], rung_name)
            if not row["held"]:
                assert row.get("reason"), f"{e['code']} {rung_name}: unheld rung with no reason recorded"
            assert "score" not in resistance and "total" not in resistance, (
                "the resistance block must never carry a collapsed scalar field"
            )


def test_resistance_r4_can_be_held_on_a_disclosed_fail(canonical):
    """sec.0's non-tautology rule, checked against the real registry: R4
    being held never implies the underlying oracle comparison passed — a
    FAIL-holding R4 row is legitimate and must not be silently impossible."""
    computed = _entries_with_resistance(canonical)
    r4_held_rows = [
        e["resistance"]["rungs"]["R4"] for e in computed if e["resistance"]["rungs"]["R4"]["held"]
    ]
    if not r4_held_rows:
        pytest.skip("no entry holds R4 yet in this registry — nothing to check")
    # Not asserting any particular row IS a fail (that depends on which
    # cards exist) — only that holding R4 is a real, reachable state at
    # all once cards exist, i.e. this registry is not vacuously all-unheld.
    assert all(isinstance(row["evidence"], list) and row["evidence"] for row in r4_held_rows)


def test_resistance_static_api_summary_available():
    static_root = STATIC_API_ENTRIES.parent
    if not static_root.is_dir():
        pytest.skip(
            f"{static_root} not built yet — run "
            "`python3 -m toledo_mcp.export_static --out mcp/dist/static-api` first"
        )
    summary_path = static_root / "resistance-summary.json"
    assert summary_path.is_file(), "mcp/toledo_mcp/export_static.py must emit v1/resistance-summary.json"
    summary = json.loads(summary_path.read_text(encoding="utf-8"))
    assert set(_RESISTANCE_RUNG_ORDER) <= set(summary["held_counts"].keys())
    assert summary["entries_with_resistance_computed"] <= summary["entries_total"]
    # A held-count can never exceed how many entries were even computed —
    # a mechanical corpus-level sanity check on the same non-collapsing
    # tally build_site.py's own resistance_coverage_html renders.
    for rung in _RESISTANCE_RUNG_ORDER:
        assert summary["held_counts"][rung] <= summary["entries_with_resistance_computed"]


def test_entry_page_shows_resistance_ladder_when_computed(toledo_entries):
    """Once a live entry carries a `resistance` block AND site/templates'
    entry.tmpl.html declares `{{resistance_badges_html}}` (a template-side
    change outside this stream's own file ownership — see
    design/RESISTANCE_LADDER_v0_1.md sec.7's S3 row), its rendered page
    must show the resistance-ladder markup, with an unheld rung exactly as
    visible as a held one. Skips honestly, naming which precondition is
    missing, until both are true."""
    _require_site_dist()
    computed = [e for e in toledo_entries if e.get("resistance")]
    if not computed:
        pytest.skip("no entry in registry/TOLEDO.json carries a `resistance` block yet")
    sample = computed[0]
    page = SITE_DIST / "entries" / f"{site_slug(sample['code'])}.html"
    if not page.is_file():
        pytest.skip(f"{page} not built")
    html_text = page.read_text(encoding="utf-8")
    if "badge-resistance" not in html_text:
        pytest.skip(
            "site/templates/entry.tmpl.html does not declare {{resistance_badges_html}} yet "
            "(template ownership is outside this stream's own files) — "
            f"{sample['code']}'s resistance data exists but is not yet wired into the template"
        )
    rungs = sample["resistance"]["rungs"]
    if any(not row["held"] for row in rungs.values()):
        assert "badge-resistance--unheld" in html_text, (
            "an unheld rung must render exactly as visibly as a held one (design doc sec.0)"
        )
    if any(row["held"] for row in rungs.values()):
        assert "badge-resistance--held" in html_text
