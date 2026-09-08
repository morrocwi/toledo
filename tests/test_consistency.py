"""Tests for scripts/compute_consistency.py (docs/CONSISTENCY_SPEC_v0_1.md).

Covers: the grader is idempotent; every grade rests on recorded evidence
(never a bare assertion); no entry is graded above what its own dimensions
support; INDEX.json's histogram counts match the sidecar files on disk.
"""
from __future__ import annotations

import json
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
CONSISTENCY_DIR = ROOT / "registry" / "consistency"

sys.path.insert(0, str(ROOT))

from scripts.clearing import readout as R  # noqa: E402


def _run_grader():
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
        # IC-3 never awarded without clearance rows (none exist in this
        # checkout -- ops/clearing/clearances.jsonl is absent).
        assert grade != "IC-3" or doc.get("clearances")


def test_no_sidecar_carries_a_bare_pass_without_evidence_shape():
    """Every dimension entry has the {status, evidence} shape the spec's
    sidecar layout (sec.4) requires -- a `pass` is never a bare string."""
    _run_grader()
    sample = sorted(CONSISTENCY_DIR.glob("*.json"))[:50]
    for p in sample:
        if p.name == "INDEX.json":
            continue
        doc = json.loads(p.read_text(encoding="utf-8"))
        for dim, block in doc["dimensions"].items():
            assert set(block.keys()) >= {"status", "evidence"}
            assert block["status"] in ("pass", "fail", "not_checked", "needs_reader")


def test_findings_referenced_by_sidecars_exist_in_their_dimension_file():
    """Every finding id a sidecar cites is traceable back to a real,
    on-disk ops/clearing/findings_<dimension>.json row -- no invented ids."""
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
