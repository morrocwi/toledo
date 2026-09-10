"""Tests for scripts/compute_consistency.py (docs/CONSISTENCY_SPEC_v0_1.md).

Covers: the grader is idempotent; every grade rests on recorded evidence
(never a bare assertion); no entry is graded above what its own dimensions
support; INDEX.json's histogram counts match the sidecar files on disk.

The raw auditor inputs live under ``ops/clearing/`` and ``ops/`` is
intentionally gitignored.  Therefore regeneration tests run when those audit
artifacts are present (the maintainer/local clearing workspace) and explicitly
SKIP in a public checkout rather than manufacturing empty evidence and then
mistaking the resulting sidecars for a real audit.
"""
from __future__ import annotations

import json
import pathlib
import subprocess
import sys

import pytest

ROOT = pathlib.Path(__file__).resolve().parent.parent
CONSISTENCY_DIR = ROOT / "registry" / "consistency"
CLEARING_DIR = ROOT / "ops" / "clearing"

sys.path.insert(0, str(ROOT))

from scripts.clearing import readout as R  # noqa: E402


def _audit_inputs_available() -> bool:
    """True only when every raw clearing artifact required by the grader exists."""
    return CLEARING_DIR.is_dir() and all(
        (CLEARING_DIR / f"findings_{dim}.json").is_file() for dim in R.DIMENSIONS
    )


def _run_grader():
    if not _audit_inputs_available():
        pytest.skip(
            "ops/clearing raw audit inputs are intentionally gitignored; "
            "consistency-regeneration checks run in the clearing workspace "
            "where those evidence files are present"
        )
    subprocess.run(
        [sys.executable, str(ROOT / "scripts" / "compute_consistency.py")],
        cwd=ROOT, check=True, capture_output=True, text=True,
    )


def _load_index():
    return json.loads((CONSISTENCY_DIR / "INDEX.json").read_text(encoding="utf-8"))


def test_grader_runs_and_produces_index():
    _run_grader()
    index = _load_index()
    assert index["schema_version"] == "consistency-index-0.1"
    assert index["histogram"]["readings"]["total"] > 0
    assert index["histogram"]["roots"]["total"] > 0


def test_grader_is_idempotent():
    _run_grader()
    index_1 = _load_index()
    sidecars_1 = {
        p.name: p.read_text(encoding="utf-8")
        for p in CONSISTENCY_DIR.glob("*.json")
        if p.name != "INDEX.json"
    }
    _run_grader()
    index_2 = _load_index()
    sidecars_2 = {
        p.name: p.read_text(encoding="utf-8")
        for p in CONSISTENCY_DIR.glob("*.json")
        if p.name != "INDEX.json"
    }
    index_1.pop("computed_at", None)
    index_2.pop("computed_at", None)
    assert index_1 == index_2
    assert sidecars_1 == sidecars_2


def test_index_histogram_matches_sidecar_files_on_disk():
    _run_grader()
    index = _load_index()
    sidecar_files = [p for p in CONSISTENCY_DIR.glob("*.json") if p.name != "INDEX.json"]
    assert len(sidecar_files) == index["histogram"]["readings"]["total"] + index["histogram"]["roots"]["total"]
    assert len(index["entries"]) == len(sidecar_files)

    counted = {"readings": {}, "roots": {}}
    for p in sidecar_files:
        doc = json.loads(p.read_text(encoding="utf-8"))
        bucket = "roots" if doc["layer"] == "root" else "readings"
        counted[bucket][doc["grade"]] = counted[bucket].get(doc["grade"], 0) + 1
    for bucket in ("readings", "roots"):
        for grade in ("IC-0", "IC-1", "IC-2", "IC-3"):
            assert counted[bucket].get(grade, 0) == index["histogram"][bucket][grade], (
                bucket, grade
            )


def test_every_grade_above_ic0_has_no_block_finding_in_its_required_dimensions():
    """A rung is earned only by every required dimension passing (no block
    finding) -- docs/CONSISTENCY_SPEC_v0_1.md sec.1. This re-derives the
    rung independently from each sidecar's own recorded dimension statuses
    and checks the grader did not award a higher rung than that."""
    _run_grader()
    for p in CONSISTENCY_DIR.glob("*.json"):
        if p.name == "INDEX.json":
            continue
        doc = json.loads(p.read_text(encoding="utf-8"))
        dims = doc["dimensions"]
        ic1_dims = R.IC1_DIMENSIONS
        ic2_extra = R.IC2_EXTRA_DIMENSIONS
        ic1_ok = all(dims[d]["status"] != "fail" for d in ic1_dims)
        ic2_ok = ic1_ok and all(dims[d]["status"] != "fail" for d in ic2_extra)
        grade = doc["grade"]
        if grade in ("IC-1", "IC-2", "IC-3"):
            assert ic1_ok, f"{doc['code']} graded {grade} but an IC-1 dimension fails"
        if grade in ("IC-2", "IC-3"):
            assert ic2_ok, f"{doc['code']} graded {grade} but an IC-2 dimension fails"
        assert grade != "IC-3" or doc.get("clearances")


def test_no_sidecar_carries_a_bare_pass_without_evidence_shape():
    """Every dimension entry has the {status, evidence} shape the spec's
    sidecar layout requires -- a `pass` is never a bare string."""
    _run_grader()
    sample = sorted(CONSISTENCY_DIR.glob("*.json"))[:50]
    for p in sample:
        if p.name == "INDEX.json":
            continue
        doc = json.loads(p.read_text(encoding="utf-8"))
        for dim, block in doc["dimensions"].items():
            assert set(block.keys()) >= {"status", "evidence"}
            assert block["status"] in ("pass", "fail", "not_checked", "needs_reader")


def test_every_examined_cell_carries_its_own_evidence_not_a_bare_pass():
    """Regression for ops/clearing/CHECKER_2026-09-08.md Block 1: a `pass`
    dimension must name which cells it examined, never leave evidence.cells
    populated only with raw finding-id lists."""
    _run_grader()
    meta_keys = {"warn_findings", "info_findings", "block_findings"}
    checked_any = False
    for p in CONSISTENCY_DIR.glob("*.json"):
        if p.name == "INDEX.json":
            continue
        doc = json.loads(p.read_text(encoding="utf-8"))
        for dim, block in doc["dimensions"].items():
            cells = block["evidence"]["cells"]
            real_cells = {k: v for k, v in cells.items() if k not in meta_keys}
            if real_cells == {"_": cells.get("_")} and "_" in real_cells:
                continue
            assert real_cells, (
                f"{p.name} dimension {dim!r} has evidence.cells populated only "
                f"with {sorted(cells.keys())} -- no named cell was examined; "
                "this is the exact 'pass and never-examined look the same' defect"
            )
            for cell, status in real_cells.items():
                assert status in ("pass", "fail", "needs_reader", "parsed", "unparsed"), (
                    p.name, dim, cell, status
                )
            checked_any = True
    assert checked_any


def test_findings_referenced_by_sidecars_exist_in_their_dimension_file():
    """Every finding id a sidecar cites is traceable to a raw clearing artifact."""
    _run_grader()
    known_ids = set()
    for dim in R.DIMENSIONS:
        for f in R.load_findings(dim)["findings"]:
            known_ids.add(f["id"])
    sample = sorted(CONSISTENCY_DIR.glob("*.json"))[:100]
    for p in sample:
        if p.name == "INDEX.json":
            continue
        doc = json.loads(p.read_text(encoding="utf-8"))
        for fid in doc["findings"]:
            assert fid in known_ids, f"{p.name} cites unknown finding {fid}"
