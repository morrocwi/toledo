"""
tests/executable/test_compute_executable.py -- unit/integration tests for
scripts/compute_executable.py (S3, docs/EXECUTABLE_EQUATIONS_v0_1.md sec.3.1).

Mirrors the style of the existing scripts/compute_resistance.py test coverage: builds small
in-memory/tempdir fixtures rather than mutating the real 6MB registry/CANONICAL.json, and asserts
the exact "omitted, not null" / "stale key removed" / "reviewed_by omitted when empty" contract
sec.3.1 and registry/SCHEMA.md's resistance-block precedent both specify.
"""
from __future__ import annotations

import json
import pathlib
import sys

REPO_ROOT = pathlib.Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO_ROOT / "scripts"))
import compute_executable as ce  # noqa: E402


def _write(path: pathlib.Path, obj) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj), encoding="utf-8")


def test_mangle_code_matches_schema_convention():
    assert ce.mangle_code("EQ-045/P.03.v1") == "EQ_045__P_03_v1"


def test_no_sidecar_means_no_executable_key_at_all(tmp_path):
    canonical = {"generated_from_commit": "abc123",
                 "canonical": [{"code": "EQ-045/P.03.v1", "name": "x"}]}
    report = ce.run(
        canonical_path=_dump(tmp_path, "CANONICAL.json", canonical),
        executable_dir=tmp_path / "executable_empty",
        repro_index_path=tmp_path / "no_such_index.json",
        index_out_path=tmp_path / "INDEX.json",
        dry_run=True,
    )
    assert report["sidecars_found"] == 0
    assert report["canonical_entries_written"] == 0
    entry = canonical["canonical"][0]
    assert "executable" not in entry


def test_reviewed_eligible_sidecar_produces_block_with_reviewed_by(tmp_path):
    canonical = {"generated_from_commit": "abc123",
                 "canonical": [{"code": "EQ-045/P.03.v1", "name": "x"}]}
    sidecar = {
        "code": "EQ-045/P.03.v1",
        "status": "reviewed_eligible",
        "eligibility": {"reviewed_by": "registrar-1"},
    }
    _write(tmp_path / "executable" / "EQ_045__P_03_v1.json", sidecar)
    canonical_path = _dump(tmp_path, "CANONICAL.json", canonical)

    report = ce.run(
        canonical_path=canonical_path,
        executable_dir=tmp_path / "executable",
        repro_index_path=tmp_path / "no_such_index.json",
        index_out_path=tmp_path / "INDEX.json",
        dry_run=False,
    )
    assert report["canonical_entries_written"] == 1
    written = json.loads(canonical_path.read_text(encoding="utf-8"))
    block = written["canonical"][0]["executable"]
    assert block["status"] == "reviewed_eligible"
    assert block["reviewed_by"] == "registrar-1"
    assert block["ir_ref"] == "registry/executable/EQ_045__P_03_v1.json"
    assert "reproduction_card" not in block  # no matching EXEC- card in the (missing) index

    index = json.loads((tmp_path / "INDEX.json").read_text(encoding="utf-8"))
    assert index["counts"]["reviewed_eligible"] == 1
    assert index["entries"][0]["code"] == "EQ-045/P.03.v1"


def test_candidate_sidecar_omits_reviewed_by_when_empty(tmp_path):
    canonical = {"generated_from_commit": "abc123",
                 "canonical": [{"code": "EQ-045/P.03.v1", "name": "x"}]}
    sidecar = {"code": "EQ-045/P.03.v1", "status": "candidate",
               "eligibility": {"reviewed_by": None}}
    _write(tmp_path / "executable" / "EQ_045__P_03_v1.json", sidecar)
    canonical_path = _dump(tmp_path, "CANONICAL.json", canonical)

    ce.run(canonical_path=canonical_path, executable_dir=tmp_path / "executable",
           repro_index_path=tmp_path / "no_such_index.json", index_out_path=tmp_path / "INDEX.json",
           dry_run=False)
    written = json.loads(canonical_path.read_text(encoding="utf-8"))
    block = written["canonical"][0]["executable"]
    assert block["status"] == "candidate"
    assert "reviewed_by" not in block  # omitted, never null (sec.3.1's own three-state convention)


def test_reviewed_rejected_maps_to_reviewed_ineligible(tmp_path):
    canonical = {"generated_from_commit": "abc123",
                 "canonical": [{"code": "EQ-045/P.03.v1", "name": "x"}]}
    sidecar = {"code": "EQ-045/P.03.v1", "status": "reviewed_rejected",
               "eligibility": {"reviewed_by": "registrar-1"}}
    _write(tmp_path / "executable" / "EQ_045__P_03_v1.json", sidecar)
    canonical_path = _dump(tmp_path, "CANONICAL.json", canonical)

    ce.run(canonical_path=canonical_path, executable_dir=tmp_path / "executable",
           repro_index_path=tmp_path / "no_such_index.json", index_out_path=tmp_path / "INDEX.json",
           dry_run=False)
    written = json.loads(canonical_path.read_text(encoding="utf-8"))
    assert written["canonical"][0]["executable"]["status"] == "reviewed_ineligible"


def test_matching_exec_card_citation_is_attached(tmp_path):
    canonical = {"generated_from_commit": "abc123",
                 "canonical": [{"code": "EQ-045/P.03.v1", "name": "x"}]}
    sidecar = {"code": "EQ-045/P.03.v1", "status": "built",
               "eligibility": {"reviewed_by": "registrar-1"}}
    _write(tmp_path / "executable" / "EQ_045__P_03_v1.json", sidecar)
    canonical_path = _dump(tmp_path, "CANONICAL.json", canonical)

    repro_index = {"cards": [
        {"toledo_codes": ["EQ-045/P.03.v1"],
         "citation": {"repo": "glosa", "commit": "deadbeef", "path": "cases/repro/EXEC-EQ_045__P_03_v1.json",
                       "id": "EXEC-EQ_045__P_03_v1"}},
        {"toledo_codes": ["EQ-045/P.03.v1"],  # an UNRELATED, non-executable-feature card for the
         "citation": {"repo": "glosa", "commit": "deadbeef", "path": "cases/repro/EQ-045_gauge_dim.json",
                       "id": "EQ-045_gauge_dim"}},  # same code -- must be ignored (no EXEC- prefix)
    ]}
    repro_index_path = _dump(tmp_path, "reproduction_card_index.json", repro_index)

    ce.run(canonical_path=canonical_path, executable_dir=tmp_path / "executable",
           repro_index_path=repro_index_path, index_out_path=tmp_path / "INDEX.json", dry_run=False)
    written = json.loads(canonical_path.read_text(encoding="utf-8"))
    card = written["canonical"][0]["executable"]["reproduction_card"]["citation"]
    assert card["id"] == "EXEC-EQ_045__P_03_v1"


def test_stale_executable_key_is_removed_when_sidecar_disappears(tmp_path):
    canonical = {"generated_from_commit": "abc123",
                 "canonical": [{"code": "EQ-045/P.03.v1", "name": "x",
                                 "executable": {"computed_at": "2020-01-01", "status": "built",
                                                "ir_ref": "registry/executable/EQ_045__P_03_v1.json"}}]}
    canonical_path = _dump(tmp_path, "CANONICAL.json", canonical)

    report = ce.run(canonical_path=canonical_path, executable_dir=tmp_path / "executable_empty",
                     repro_index_path=tmp_path / "no_such_index.json", index_out_path=tmp_path / "INDEX.json",
                     dry_run=False)
    assert report["canonical_stale_keys_removed"] == 1
    written = json.loads(canonical_path.read_text(encoding="utf-8"))
    assert "executable" not in written["canonical"][0]


def test_real_registry_dry_run_smoke():
    """Runs for real against this checkout's own registry/CANONICAL.json, in --dry-run mode
    (never writes). This is a live, concurrently-built registry (other streams land sidecars
    while this stream works), so the exact sidecar count is NOT pinned here -- only the internal
    consistency this script itself must always hold, whatever S1 has produced so far: every
    sidecar found must correspond to exactly one written CANONICAL.json entry (a code with no
    matching canonical entry would be a real cross-stream bug, not silently ignored), and the
    per-status index counts must sum to the total sidecar count."""
    report = ce.run(
        canonical_path=REPO_ROOT / "registry" / "CANONICAL.json",
        executable_dir=REPO_ROOT / "registry" / "executable",
        repro_index_path=REPO_ROOT / "registry" / "reproduction_card_index.json",
        index_out_path=REPO_ROOT / "registry" / "executable" / "INDEX.json",
        dry_run=True,
    )
    assert report["dry_run"] is True
    assert report["canonical_entries_written"] == report["sidecars_found"]
    assert sum(report["index_counts"].values()) == report["sidecars_found"]


def _dump(tmp_path: pathlib.Path, name: str, obj) -> pathlib.Path:
    path = tmp_path / name
    path.write_text(json.dumps(obj), encoding="utf-8")
    return path
