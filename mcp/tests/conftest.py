from __future__ import annotations

import json
import pathlib
import sys

import pytest

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))

from toledo_mcp import paths  # noqa: E402


def _entry(**kw) -> dict:
    base = {
        "id": kw.get("id", f"CAN-{kw['code']}"),
        "code": kw["code"],
        "root": kw.get("root", kw["code"]),
        "layer": kw.get("layer", "reading"),
        "domain": kw.get("domain", "M"),
        "aliases": kw.get("aliases", []),
        "name": kw.get("name", f"name for {kw['code']}"),
        "statement": kw.get("statement", {"latest": kw.get("statement_text", "a + b = c"), "format": "ascii-math"}),
        "statements_history": [],
        "parents": kw.get("parents", []),
        "children": kw.get("children", []),
        "origin": kw.get("origin", {"source": "textbook", "repo_anchor": None, "record_id": 1, "doi": "10.0/x", "section": None}),
        "status": kw.get("status", "current"),
        "status_note": kw.get("status_note", ""),
        "superseded_by": kw.get("superseded_by"),
        "tier": kw.get("tier", "Definition"),
        "tier_in_genesis_verbatim": kw.get("tier_in_genesis_verbatim", "Definition"),
        "coq": kw.get("coq", {"file": None, "identifier": None, "assumptions": None, "imported_from": None,
                               "coq_status": "not_yet_formalised", "coq_axioms": [], "coq_source_redistributed": True}),
        "relations": kw.get("relations", []),
        "occurrences": kw.get("occurrences", [{"record_id": 1, "doi": "10.0/x", "label": "(1)", "section": "S1", "raw_key": "1:(1)"}]),
        "role": kw.get("role", "other"),
        "first_assigned": kw.get("first_assigned", "2026-09-06"),
    }
    return base


FIXTURE_ENTRIES = [
    _entry(code="EQ-001", layer="root", domain=None, statement_text="a != b", parents=[], role="root-axiom"),
    _entry(code="EQ-001/M.01.v1", root="EQ-001", statement_text="a != b readout", parents=[{"code": "EQ-001", "derived_via": "reads"}]),
    _entry(code="EQ-001/M.02.v1", root="EQ-001", statement_text="2*a != 2*b readout",
           parents=[{"code": "EQ-001", "derived_via": "reads"}]),  # positive-scale candidate of M.01 (k=2)
    _entry(code="EQ-001/M.03.v1", root="EQ-001", statement_text="x != y readout",
           parents=[{"code": "EQ-001", "derived_via": "reads"}]),  # renaming candidate of M.01 (a->x, b->y)
    _entry(code="EQ-001/M.04.v1", root="EQ-001", statement_text="OLD FORM retired",
           status="superseded_by", superseded_by="EQ-001/M.05.v1", status_note="retired in favour of M.05",
           parents=[{"code": "EQ-001", "derived_via": "reads"}]),
    _entry(code="EQ-001/M.05.v1", root="EQ-001", statement_text="NEW FORM current",
           parents=[{"code": "EQ-001", "derived_via": "reads"}]),
    _entry(code="EQ-001/M.06.v1", root="EQ-001", statement_text="CYCLE A",
           status="superseded_by", superseded_by="EQ-001/M.07.v1", status_note="cycles",
           parents=[{"code": "EQ-001", "derived_via": "reads"}]),
    _entry(code="EQ-001/M.07.v1", root="EQ-001", statement_text="CYCLE B",
           status="superseded_by", superseded_by="EQ-001/M.06.v1", status_note="cycles back",
           parents=[{"code": "EQ-001", "derived_via": "reads"}]),
    _entry(code="EQ-001/M.08.v1", root="EQ-001", statement_text="bundled record",
           status="split", status_note="quoted: two distinct objects found",
           children=["EQ-001/M.09.v1", "EQ-001/M.10.v1"],
           parents=[{"code": "EQ-001", "derived_via": "reads"}]),
    _entry(code="EQ-001/M.09.v1", root="EQ-001", statement_text="split child one",
           parents=[{"code": "EQ-001/M.08.v1", "derived_via": "restates"}]),
    _entry(code="EQ-001/M.10.v1", root="EQ-001", statement_text="split child two",
           parents=[{"code": "EQ-001/M.08.v1", "derived_via": "restates"}]),
    _entry(code="EQ-001/M.11.v1", root="EQ-001", statement_text="just prose, no operator",
           status="not_an_equation", status_note="quoted prose only",
           parents=[{"code": "EQ-001", "derived_via": "reads"}]),
    _entry(code="EQ-001/M.12.v1", root="EQ-001", statement_text="carried forward unverified",
           status="unverified", status_note="source tags Th_coqc but no Coq identifier located",
           parents=[{"code": "EQ-001", "derived_via": "reads"}]),
    _entry(code="EQ-001/H.01.v1", root="EQ-001", statement_text="delta_R = (a sharp b) primordial distinction weld",
           domain="H", aliases=["weld-alias"],
           parents=[{"code": "EQ-001", "derived_via": "reads"}],
           relations=[{"type": "reads", "target": "EQ-001/M.01.v1", "note": "cross-domain reading"}]),
    # Unicode-symbol-heavy statement: `core.normalise_formula` expands each of
    # these to multi-character words ("∂"->"d","·"->"*",...) while
    # `index.normalize_text` (used for `statement_norm`/search) does not —
    # the two normalisers disagree substantially on LENGTH for a statement
    # like this. Regression fixture for the phi_len/statement_len mismatch
    # bug caught by benchmarks/bench_index.py against the real registry (see
    # docs/DESIGN.md "A bug the benchmark caught"): without this entry the
    # small ASCII-only fixture above does not exercise the divergence at all.
    _entry(code="EQ-001/P.01.v1", root="EQ-001", domain="P",
           statement_text="∂_t Φ = δ_R · ∇ Φ", name="symbol-heavy reading",
           parents=[{"code": "EQ-001", "derived_via": "reads"}]),
    _entry(code="EQ-001/P.02.v1", root="EQ-001", domain="P",
           statement_text=r"\partial_t \Phi = \delta_R \cdot \nabla \Phi",  # LaTeX spelling of the same statement
           name="symbol-heavy reading, LaTeX spelling",
           parents=[{"code": "EQ-001", "derived_via": "reads"}]),
]

# Fix up EQ-001's children to match parents[] above (as build_entries() would compute).
_children_map: dict[str, list[str]] = {}
for _e in FIXTURE_ENTRIES:
    for _p in _e.get("parents", []):
        _children_map.setdefault(_p["code"], []).append(_e["code"])
for _e in FIXTURE_ENTRIES:
    if _e["code"] in _children_map and _e["code"] != "EQ-001/M.08.v1":
        _e["children"] = _children_map[_e["code"]]
    elif _e["code"] == "EQ-001":
        _e["children"] = _children_map.get("EQ-001", [])

FIXTURE_LINEAGE = [
    {"code": "EQ-001/M.01.v1", "date": "2026-09-06", "event": "assigned", "from": "CAN-001", "to": "EQ-001/M.01.v1", "reason": "initial", "by": "test"},
    {"code": "EQ-001/M.04.v1", "date": "2026-09-06", "event": "retired", "from": "EQ-001/M.04.v1", "to": "EQ-001/M.05.v1", "reason": "superseded", "by": "test"},
    {"code": "EQ-001/M.08.v1", "date": "2026-09-06", "event": "split", "from": "EQ-001/M.08.v1", "to": ["EQ-001/M.09.v1", "EQ-001/M.10.v1"], "reason": "over-merge fix", "by": "test",
     "phi_criterion_evidence": {"quote": "two distinct objects found"}},
]


def write_fixture_registry(root: pathlib.Path) -> None:
    (root / "registry").mkdir(parents=True, exist_ok=True)
    canonical_doc = {
        "schema_version": "1.0.0",
        "generated_from_commit": "deadbeef",
        "canonical": [e for e in FIXTURE_ENTRIES if e["layer"] != "root"],
        "raw_to_canonical": {"1:(1)": "EQ-001/M.01.v1"},
    }
    (root / "registry" / "CANONICAL.json").write_text(json.dumps(canonical_doc, ensure_ascii=False, indent=2), encoding="utf-8")

    genesis_doc = {
        "anchor": {"repo": "readout_genesis", "commit": "082dde8", "files": []},
        "root_equations": [
            {
                "code": "EQ-001", "genesis_id": "EQ-001", "aliases": [], "name": "Primordial difference",
                "statement": "a != b", "section": "APPENDIX C", "tier_in_genesis": "Ax",
                "synthesis_occurrences": [], "role": "root-axiom", "parents": [], "derived_via": "definition",
                "step": 1, "step_label": "I.1",
            }
        ],
    }
    (root / "registry" / "genesis_root.json").write_text(json.dumps(genesis_doc, ensure_ascii=False, indent=2), encoding="utf-8")

    with open(root / "registry" / "LINEAGE.jsonl", "w", encoding="utf-8") as fh:
        for ev in FIXTURE_LINEAGE:
            fh.write(json.dumps(ev, ensure_ascii=False) + "\n")


@pytest.fixture()
def fixture_root(tmp_path, monkeypatch):
    root = tmp_path / "toledo_fixture"
    write_fixture_registry(root)
    monkeypatch.setenv("TOLEDO_ROOT", str(root))
    monkeypatch.setenv("TOLEDO_MCP_STATE_DIR", str(tmp_path / "state"))
    return root


@pytest.fixture()
def real_root(monkeypatch, tmp_path):
    """The real toledo repo, read-only — state (index db) is redirected to a
    temp dir so tests never write into the shared mcp/state/ used by a
    developer's own running server."""
    monkeypatch.delenv("TOLEDO_ROOT", raising=False)
    monkeypatch.setenv("TOLEDO_MCP_STATE_DIR", str(tmp_path / "state"))
    return paths.repo_root()
