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
    report = build_site.build_site(out_root)
    assert report["pages"] == 6
    assert (out_root / "site" / "index.html").exists()
    assert (out_root / "site" / "SMP-ROOT.html").exists()
