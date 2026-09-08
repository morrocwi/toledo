"""Readouts of which (code, dimension) pairs sit at a reader-only cell today.

Each function below reads a file already produced by an auditor (a
findings_<dimension>.json header note, or a probes/<dimension>/ file) and
returns the set of codes that cell currently applies to. Nothing here is
invented: where a probe file lists the exact codes, we use it; where only a
header note gives an aggregate rule (e.g. "needs_reader for every entry with
a coq file"), we apply that rule against the registry itself and say so.
"""
from __future__ import annotations

import json

from . import readout as R


def tier_witness_codes() -> set:
    path = R.CLEARING / "probes" / "tier" / "reader_queue.json"
    if not path.exists():
        return set()
    data = R.load_json(path)
    return {row["code"] for row in data.get("rows", []) if row.get("code")}


def lineage_reader_codes() -> set:
    path = R.CLEARING / "probes" / "lineage" / "reader_rows.jsonl"
    if not path.exists():
        return set()
    codes = set()
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line:
            continue
        row = json.loads(line)
        if row.get("code"):
            codes.add(row["code"])
    return codes


def coq_encodes_structure_codes(canonical_entries) -> set:
    """Header rule: needs_reader for every entry that has a coq.file set."""
    return {
        e["code"]
        for e in canonical_entries
        if isinstance(e.get("coq"), dict) and e["coq"].get("file")
    }


def symbols_sense_codes(canonical_entries) -> set:
    """Header rule: no ops/clearing/glossary/ exists yet, so the `sense`
    cell is needs_reader for every entry (SCHEMA v0.1 default)."""
    glossary_dir = R.CLEARING / "glossary"
    if glossary_dir.exists() and any(glossary_dir.glob("*.json")):
        return set()
    return {e["code"] for e in canonical_entries}


def duplicates_reader_codes(dup_header: dict) -> set:
    codes = set()
    listings = dup_header.get("listings") or {}
    for key in ("contradiction_candidates", "identical_name_groups"):
        groups = listings.get(key) or []
        for group in groups:
            if isinstance(group, dict):
                members = group.get("codes") or group.get("members") or []
            elif isinstance(group, list):
                members = group
            else:
                members = []
            for m in members:
                if isinstance(m, str):
                    codes.add(m)
                elif isinstance(m, dict) and m.get("code"):
                    codes.add(m["code"])
    return codes


def lineage_root_edge_codes(canonical_entries) -> set:
    """Every reading with at least one root-layer (no-'/') parent carries a
    `needs_reader` lineage cell until ruling R-2 (spec sec.2.7)."""
    codes = set()
    for e in canonical_entries:
        for p in e.get("parents") or []:
            pcode = p.get("code") if isinstance(p, dict) else p
            if pcode and "/" not in pcode:
                codes.add(e["code"])
                break
    return codes
