"""Tests for the GENERATOR + TOOLING layer (scripts/toledo_build.py, scripts/toledo,
site/build_site.py) against the fixture tests/fixtures/CANONICAL.sample.json.

Run in isolation into a tmp_path output root so this never touches the real
registry/ or sample_output/ directories.
"""
import json
import pathlib
import subprocess
import sys

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent
FIXTURE = REPO_ROOT / "tests" / "fixtures" / "CANONICAL.sample.json"

sys.path.insert(0, str(REPO_ROOT / "scripts"))
import toledo_build  # noqa: E402


def _build(tmp_path):
    toledo_build.ASSUMPTIONS_MADE.clear()
    out_root = tmp_path / "out"
    report = toledo_build.run_build(FIXTURE, None, out_root)
    return out_root, report


def test_build_produces_expected_files(tmp_path):
    out_root, report = _build(tmp_path)
    assert report["entries"] == 6
    assert (out_root / "registry" / "TOLEDO.json").exists()
    assert (out_root / "graph" / "toledo_graph.json").exists()
    assert (out_root / "graph" / "toledo.graphml").exists()
    assert (out_root / "graph" / "toledo.ttl").exists()
    assert (out_root / "site" / "index.json").exists()
    assert (out_root / "latex" / "catalogue_body.tex").exists()
    for code in ["SMP-ROOT", "SMP-ROOT2", "SMP-ROOT__H_01_v1", "SMP-ROOT2__S_01_v1",
                 "SMP-ROOT__H_02_v1", "SMP-ROOT__H_03_v1"]:
        assert (out_root / "registry" / "entries" / f"{code}.json").exists(), code
        assert (out_root / "vault" / f"{code}.md").exists(), code


def test_jsonld_has_context(tmp_path):
    out_root, _ = _build(tmp_path)
    doc = json.loads((out_root / "registry" / "entries" / "SMP-ROOT.json").read_text())
    assert "@context" in doc
    assert doc["@context"]["parents"] == "prov:wasDerivedFrom"
    assert doc["@context"]["code"] == "schema:identifier"
    assert doc["code"] == "SMP-ROOT"


def test_graph_edges_match_parents(tmp_path):
    out_root, _ = _build(tmp_path)
    toledo = json.loads((out_root / "registry" / "TOLEDO.json").read_text())
    graph = json.loads((out_root / "graph" / "toledo_graph.json").read_text())
    expected_parent_edges = set()
    for e in toledo["canonical"]:
        for p in e.get("parents", []):
            expected_parent_edges.add((p["code"], e["code"]))
    actual_parent_edges = {
        (edge["source"], edge["target"])
        for edge in graph["edges"] if edge["type"] == "parent"
    }
    assert expected_parent_edges == actual_parent_edges
    node_codes = {n["code"] for n in graph["nodes"]}
    assert node_codes == {e["code"] for e in toledo["canonical"]}


def test_children_computed_by_inversion(tmp_path):
    out_root, _ = _build(tmp_path)
    toledo = json.loads((out_root / "registry" / "TOLEDO.json").read_text())
    by_code = {e["code"]: e for e in toledo["canonical"]}
    assert "SMP-ROOT/H.01.v1" in by_code["SMP-ROOT"]["children"]
    assert "SMP-ROOT/H.02.v1" in by_code["SMP-ROOT"]["children"]
    assert "SMP-ROOT2" in by_code["SMP-ROOT"]["children"]
    assert "SMP-ROOT/H.03.v1" in by_code["SMP-ROOT/H.02.v1"]["children"]


def test_mathml_produced_for_latex_statements(tmp_path):
    out_root, _ = _build(tmp_path)
    doc = json.loads((out_root / "registry" / "entries" / "SMP-ROOT.json").read_text())
    assert doc["presentation_mathml"] is not None
    assert "<math" in doc["presentation_mathml"]
    # SMP-ROOT/H.01.v1 has statement.format == "ascii-math" -> no MathML, with a reason
    reading = json.loads((out_root / "registry" / "entries" / "SMP-ROOT__H_01_v1.json").read_text())
    assert reading["presentation_mathml"] is None
    assert reading["presentation_mathml_reason"]


def test_superseded_entry_has_edge(tmp_path):
    out_root, _ = _build(tmp_path)
    graph = json.loads((out_root / "graph" / "toledo_graph.json").read_text())
    edges = {(e["source"], e["target"], e["type"]) for e in graph["edges"]}
    assert ("SMP-ROOT/H.02.v1", "SMP-ROOT/H.03.v1", "supersedes_by") in edges


def test_cli_ancestry(tmp_path):
    out_root, _ = _build(tmp_path)
    result = subprocess.run(
        [sys.executable, str(REPO_ROOT / "scripts" / "toledo"),
         "--out-root", str(out_root), "ancestry", "SMP-ROOT/H.03.v1"],
        capture_output=True, text=True, check=True,
    )
    assert result.stdout.strip() == "SMP-ROOT -> SMP-ROOT/H.02.v1 -> SMP-ROOT/H.03.v1"


def test_cli_show(tmp_path):
    out_root, _ = _build(tmp_path)
    result = subprocess.run(
        [sys.executable, str(REPO_ROOT / "scripts" / "toledo"),
         "--out-root", str(out_root), "show", "SMP-ROOT2"],
        capture_output=True, text=True, check=True,
    )
    doc = json.loads(result.stdout)
    assert doc["code"] == "SMP-ROOT2"


def test_site_builds(tmp_path):
    out_root, _ = _build(tmp_path)
    sys.path.insert(0, str(REPO_ROOT / "site"))
    import build_site
    # build_site() now requires out_dir/data_dir/templates_dir explicitly
    # (TEST-BREAK-1: the A5 website workflow added these positional params).
    # root=out_root so load_entries()/load_canonical_counts() read the
    # fixture build's own registry/ (written by toledo_build.run_build
    # above), never the real repo's ~967-entry registry; templates_dir
    # points at the real site/templates (the fixture carries no templates
    # of its own). build_data_files()/build_pages() also read, unconditionally,
    # root/registry/CANONICAL.json (counts{} block -- an absent *key* is
    # tolerated, but the file itself must exist), root/mcp/README.md (the
    # tools table) and root/.mcp.json (the /agents/ page) -- none of those
    # are written by run_build, so all three are copied read-only into
    # out_root; out_dir/data_dir stay under tmp_path for isolation, matching
    # this file's own module docstring ("never touches the real ... directories").
    (out_root / "registry").mkdir(parents=True, exist_ok=True)
    (out_root / "registry" / "CANONICAL.json").write_bytes(FIXTURE.read_bytes())
    (out_root / "mcp").mkdir(parents=True, exist_ok=True)
    (out_root / "mcp" / "README.md").write_bytes((REPO_ROOT / "mcp" / "README.md").read_bytes())
    (out_root / ".mcp.json").write_bytes((REPO_ROOT / ".mcp.json").read_bytes())
    site_out = out_root / "site"
    report = build_site.build_site(
        out_root, site_out, site_out / "data", REPO_ROOT / "site" / "templates",
    )
    # Not a fixed literal count: build_pages() emits one page per entry PLUS
    # a growing set of index/listing pages (browse, by-root, by-domain,
    # by-tier, by-status, and any further axis a later stream adds -- this
    # count already moved from 17 to 18 between two runs of this same test
    # during Toledo v1.5 lane A5's own website work, purely from a new
    # legitimate page, not a regression). Asserting the exact number here
    # would make this test flake against ongoing, unrelated feature work in
    # site/build_site.py. What TEST-BREAK-1 actually needs verified is that
    # the build completed honestly (nothing silently skipped or unresolved)
    # and that the per-entry pages this test's other assertions rely on
    # really exist -- a lower bound (>= one page per fixture entry, plus the
    # site's own index) still catches the real regression class (build_site
    # crashing, or writing zero pages) without pinning to a moving total.
    assert report["pages_skipped"] == 0
    assert report["templates_missing"] == []
    assert report["unresolved_placeholders"] == {}
    assert report["pages_written"] >= 7  # >= 6 fixture entries + index.html
    assert (site_out / "index.html").exists()
    assert (site_out / "entries" / "SMP-ROOT.html").exists()
    for code in ["SMP-ROOT", "SMP-ROOT2", "SMP-ROOT__H_01_v1", "SMP-ROOT2__S_01_v1",
                 "SMP-ROOT__H_02_v1", "SMP-ROOT__H_03_v1"]:
        assert (site_out / "entries" / f"{code}.html").exists(), code
