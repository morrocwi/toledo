"""Shared readout helpers for the internal-consistency grader.

Every function here is a pure reader: it loads a file already committed in
this checkout and returns it. No function in this module ever writes.
"""
from __future__ import annotations

import json
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
REGISTRY = ROOT / "registry"
CLEARING = ROOT / "ops" / "clearing"

DIMENSIONS = ["schema", "structure", "tier", "symbols", "coq", "duplicates", "lineage"]

# The seven audit dimensions, in the order the spec's ladder needs them:
# rung-1 (IC-1, "shape-consistent") mechanical dimensions vs the extra
# rung-2 (IC-2, "text-consistent") mechanical dimensions.
IC1_DIMENSIONS = ["schema", "structure", "tier", "lineage"]
IC2_EXTRA_DIMENSIONS = ["symbols", "coq", "duplicates"]


def mangle(code: str) -> str:
    """SCHEMA.md Coq mangling rule: '/' -> '__', '.' -> '_', '-' -> '_'."""
    return code.replace("/", "__").replace(".", "_").replace("-", "_")


def git_head() -> str:
    try:
        return subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
        ).strip()
    except Exception:
        return "unknown"


def load_json(path: Path):
    return json.loads(Path(path).read_text(encoding="utf-8"))


def load_canonical():
    return load_json(REGISTRY / "CANONICAL.json")


def load_genesis_root():
    return load_json(REGISTRY / "genesis_root.json")


def load_lineage():
    events = []
    path = REGISTRY / "LINEAGE.jsonl"
    if not path.exists():
        return events
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line:
            continue
        events.append(json.loads(line))
    return events


def load_findings(dimension: str) -> dict:
    """Read ops/clearing/findings_<dimension>.json, already produced by that
    dimension's auditor (ops/clearing/audit_<dimension>.py). Returns
    {"header": {...}, "findings": [...]}. Never writes; if the file is
    absent (a dimension not yet audited) returns an empty, honest shape.
    """
    path = CLEARING / f"findings_{dimension}.json"
    if not path.exists():
        return {"header": {}, "findings": []}
    data = load_json(path)
    findings = data.get("findings", [])
    if "header" in data:
        header = data["header"]
    else:
        header = {k: v for k, v in data.items() if k != "findings"}
    return {"header": header, "findings": findings}


def extract_codes(finding: dict):
    """A finding names the entries it touches either via a top-level
    'codes' array or, for some dimensions' shape, via evidence.entries[].code.
    """
    codes = finding.get("codes")
    if codes:
        return list(codes)
    evidence = finding.get("evidence") or {}
    entries = evidence.get("entries")
    out = []
    if isinstance(entries, list):
        for item in entries:
            if isinstance(item, dict) and item.get("code"):
                out.append(item["code"])
            elif isinstance(item, str):
                out.append(item)
    return out


_SEVERITY_FALLBACK = {"block": "block", "major": "warn", "minor": "info"}


def spec_severity(finding: dict) -> str:
    """The spec's three-value severity (block|warn|info). Prefer the
    dimension's own spec_severity field; for dimensions that do not yet
    carry it, fall back to a readout of the auditor's own
    block|major|minor vocabulary (documented as an approximation).
    """
    value = finding.get("spec_severity")
    if value in ("block", "warn", "info"):
        return value
    sev = str(finding.get("severity") or "").lower()
    return _SEVERITY_FALLBACK.get(sev, "warn")
