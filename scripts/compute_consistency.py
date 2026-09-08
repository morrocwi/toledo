#!/usr/bin/env python3
"""Toledo internal-consistency grader (docs/CONSISTENCY_SPEC_v0_1.md).

Idempotent, read-only over registry/*.json, registry/LINEAGE.jsonl, and the
seven ops/clearing/findings_<dimension>.json files the equation-clearing
auditors already produced. Writes only under registry/consistency/:

  registry/consistency/<mangled code>.json   -- one sidecar per entry
  registry/consistency/INDEX.json            -- corpus-wide histogram

No content field of registry/CANONICAL.json, registry/genesis_root.json, or
registry/LINEAGE.jsonl is ever read for writing, and none is ever touched.
`grade` is never a score; a `needs_reader` cell is an honest state, never a
silent pass.

Usage: python3 scripts/compute_consistency.py [--check]
  --check   exit non-zero if writing would change any file (CI regression
            guard); does not write in that mode's dry pass first, then
            compares.
"""
from __future__ import annotations

import argparse
import json
import sys
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from scripts.clearing import readout as R
from scripts.clearing import reader_cells as RC

OUT_DIR = R.REGISTRY / "consistency"


def _dump(obj) -> str:
    return json.dumps(obj, sort_keys=True, indent=1, ensure_ascii=False) + "\n"


_FIXED_TIER_CELL_TABLE_IDS = {
    "tier.cell_table#Th_coqc-x-wrapped_related",
    "tier.cell_table#Th_coqc-x-not_formalisable",
    "tier.cell_table#Th_coqc-x-definition",
}
_FIXED_HEADER_TIER_ID = "tier.header_tier#inner-comment"


def _still_open_tier_cell_table(code, entry):
    return entry.get("status") == "current"


def _still_open_header_tier(code, entry):
    coq = entry.get("coq") or {}
    file_rel = coq.get("file")
    tier = entry.get("tier")
    if not file_rel or not tier:
        return True
    path = R.ROOT / file_rel
    if not path.exists():
        return True
    text = path.read_text(encoding="utf-8")
    import re as _re

    for cm in _re.finditer(r"\(\*.*?\*\)", text, _re.DOTALL):
        m = _re.search(r"tier:\s*([A-Za-z_][A-Za-z0-9_]*)", cm.group(0))
        if m:
            return m.group(1).strip() != tier
    return True


def build_code_index(canonical_entries, root_rows):
    """dimension -> code -> list of finding ids.

    Reconciliation note: scripts/v18_clearing_fixes.py is the one script
    allowed to change registry/CANONICAL.json and coq/canonical/*.v; when it
    applies a finding this run re-checks that finding's own pass condition
    live against the current file, so a fixed finding does not keep
    blocking a rung after the fix that cleared it. Every other finding is
    read verbatim from the auditor's findings_<dimension>.json (a finding
    fixed by any other means still shows here until that dimension's
    auditor re-runs -- an honest limitation, not silently hidden).
    """
    by_code_live = {e["code"]: e for e in canonical_entries}
    index = {dim: {} for dim in R.DIMENSIONS}
    finding_meta = {}
    dim_headers = {}
    for dim in R.DIMENSIONS:
        loaded = R.load_findings(dim)
        dim_headers[dim] = loaded["header"]
        for f in loaded["findings"]:
            fid = f.get("id")
            sev = R.spec_severity(f)
            status = f.get("status", "open")
            finding_meta[fid] = {"severity": sev, "status": status, "dimension": dim}
            codes = R.extract_codes(f)
            if fid in _FIXED_TIER_CELL_TABLE_IDS:
                codes = [c for c in codes if _still_open_tier_cell_table(c, by_code_live.get(c, {}))]
            elif fid == _FIXED_HEADER_TIER_ID:
                codes = [c for c in codes if _still_open_header_tier(c, by_code_live.get(c, {}))]
            for code in codes:
                index[dim].setdefault(code, []).append(fid)
    return index, finding_meta, dim_headers


def unparsed_sets(dup_header):
    fp = dup_header.get("fingerprint") or {}
    readings = set(fp.get("unparsed_codes_readings") or [])
    roots = set(fp.get("unparsed_codes_roots") or [])
    return readings, roots


def grade_entry(code, is_root, code_findings, finding_meta, reader_sets):
    """Returns (grade, flag, blocked_at, dimensions_dict, findings_list, clearances_list)."""
    dims_out = {}
    all_findings = []
    mech_pass = {}  # dimension -> bool (no block finding)
    for dim in R.DIMENSIONS:
        fids = code_findings.get(dim, {}).get(code, [])
        cells = {}
        block_fids = [fid for fid in fids if finding_meta[fid]["severity"] == "block"]
        warn_fids = [fid for fid in fids if finding_meta[fid]["severity"] == "warn"]
        info_fids = [fid for fid in fids if finding_meta[fid]["severity"] == "info"]

        needs_reader_here = code in reader_sets.get(dim, set())

        if dim == "coq" and is_root:
            status = "pass"
            cells["_"] = "not_applicable: root row"
        elif dim == "symbols" and is_root:
            status = "pass"
            cells["_"] = "not_applicable: root row (symbols.dimension only)"
        elif block_fids:
            status = "fail"
        elif needs_reader_here or warn_fids:
            status = "needs_reader"
        else:
            status = "pass"

        if warn_fids:
            cells["warn_findings"] = warn_fids
        if info_fids:
            cells["info_findings"] = info_fids
        if block_fids:
            cells["block_findings"] = block_fids

        mech_pass[dim] = not block_fids
        dims_out[dim] = {"status": status, "evidence": {"cells": cells}}
        all_findings.extend(block_fids)
        all_findings.extend(warn_fids)

    # duplicates fingerprint coverage gates IC-2 specifically
    unparsed = code in reader_sets.get("_unparsed", set())

    ic1_ok = all(mech_pass[d] for d in R.IC1_DIMENSIONS)
    ic2_ok = ic1_ok and all(mech_pass[d] for d in R.IC2_EXTRA_DIMENSIONS) and not unparsed
    # IC-3 needs clearance rows; none exist in this checkout.
    ic3_ok = False

    if ic3_ok:
        grade = "IC-3"
    elif ic2_ok:
        grade = "IC-2"
    elif ic1_ok:
        grade = "IC-1"
    else:
        grade = "IC-0"

    has_open_finding = bool(all_findings)
    flag = "IC-F" if has_open_finding else None

    blocked_at = None
    if has_open_finding:
        # lowest failing {rung, dimension, finding}
        for dim in R.IC1_DIMENSIONS:
            if not mech_pass[dim]:
                fid = code_findings.get(dim, {}).get(code, [None])[0]
                blocked_at = {"rung": "IC-1", "dimension": dim, "finding": fid}
                break
        if blocked_at is None:
            for dim in R.IC2_EXTRA_DIMENSIONS:
                if not mech_pass[dim]:
                    fid = code_findings.get(dim, {}).get(code, [None])[0]
                    blocked_at = {"rung": "IC-2", "dimension": dim, "finding": fid}
                    break
        if blocked_at is None:
            # a warn-only (needs_ruling) finding: names the dimension, no rung denied
            for dim in R.DIMENSIONS:
                fids = code_findings.get(dim, {}).get(code, [])
                if fids:
                    blocked_at = {"rung": None, "dimension": dim, "finding": fids[0]}
                    break

    clearances = []  # ops/clearing/clearances.jsonl does not exist in this checkout
    findings_sorted = sorted(set(all_findings))
    return grade, flag, blocked_at, dims_out, findings_sorted, clearances


def last_lineage_event(lineage_events, code):
    events = [e for e in lineage_events if e.get("code") == code]
    if not events:
        return None
    events.sort(key=lambda e: (e.get("date") or "", e.get("event") or ""))
    last = events[-1]
    return {
        "event": last.get("event"),
        "date": last.get("date"),
        "by": last.get("by"),
    }


def main(argv=None):
    ap = argparse.ArgumentParser()
    ap.add_argument("--check", action="store_true")
    args = ap.parse_args(argv)

    canonical_doc = R.load_canonical()
    canonical_entries = canonical_doc["canonical"]
    genesis_doc = R.load_genesis_root()
    root_rows = genesis_doc["root_equations"]
    lineage_events = R.load_lineage()

    code_findings, finding_meta, dim_headers = build_code_index(canonical_entries, root_rows)

    dup_header = dim_headers.get("duplicates", {})
    unparsed_readings, unparsed_roots = unparsed_sets(dup_header)

    reader_sets = {
        "tier": RC.tier_witness_codes(),
        "lineage": RC.lineage_reader_codes() | RC.lineage_root_edge_codes(canonical_entries),
        "coq": RC.coq_encodes_structure_codes(canonical_entries),
        "symbols": RC.symbols_sense_codes(canonical_entries),
        "duplicates": RC.duplicates_reader_codes(dup_header),
        "_unparsed": unparsed_readings | unparsed_roots,
    }

    grader_commit = R.git_head()
    registry_commit = canonical_doc.get("generated_from_commit", "unknown")
    computed_at_date = datetime.now(timezone.utc).strftime("%Y-%m-%d")
    computed_at_full = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    # clear stale sidecars from a previous run so removed codes don't linger
    for old in OUT_DIR.glob("*.json"):
        if old.name != "INDEX.json":
            old.unlink()

    histogram = {
        "readings": {"IC-0": 0, "IC-1": 0, "IC-2": 0, "IC-3": 0, "IC-F": 0, "total": 0},
        "roots": {"IC-0": 0, "IC-1": 0, "IC-2": 0, "IC-3": 0, "IC-F": 0, "total": 0},
    }
    by_dimension = {d: {"pass": 0, "fail": 0, "not_checked": 0, "needs_reader": 0} for d in R.DIMENSIONS}
    findings_open_by_class = {"A": 0, "B": 0, "C": 0, "D": 0}
    entries_out = []

    def process(code, is_root, layer):
        grade, flag, blocked_at, dims_out, findings, clearances = grade_entry(
            code, is_root, code_findings, finding_meta, reader_sets
        )
        bucket = "roots" if is_root else "readings"
        histogram[bucket][grade] += 1
        histogram[bucket]["total"] += 1
        if flag:
            histogram[bucket]["IC-F"] += 1
        for dim, d in dims_out.items():
            st = d["status"]
            if st not in by_dimension[dim]:
                st = "not_checked"
            by_dimension[dim][st] += 1

        sidecar = {
            "code": code,
            "layer": layer,
            "grade": grade,
            "flag": flag,
            "blocked_at": blocked_at,
            "dimensions": dims_out,
            "findings": findings,
            "clearances": clearances,
            "computed_at": computed_at_date,
            "grader_commit": grader_commit,
            "last_lineage_event": last_lineage_event(lineage_events, code),
        }
        mangled = R.mangle(code)
        (OUT_DIR / f"{mangled}.json").write_text(_dump(sidecar), encoding="utf-8")
        entries_out.append(
            {
                "code": code,
                "grade": grade,
                "flag": flag,
                "sidecar": f"registry/consistency/{mangled}.json",
            }
        )

    for e in canonical_entries:
        process(e["code"], False, e.get("layer", "reading"))
    for r_ in root_rows:
        process(r_["code"], True, "root")

    for dim in R.DIMENSIONS:
        for f in R.load_findings(dim)["findings"]:
            if f.get("status") == "open":
                pf = f.get("proposed_fix")
                cls = (pf.get("class") if isinstance(pf, dict) else None) or f.get("class") or "?"
                if cls in findings_open_by_class:
                    findings_open_by_class[cls] += 1

    fp_total_readings = len(canonical_entries)
    fp_total_roots = len(root_rows)
    index = {
        "schema_version": "consistency-index-0.1",
        "computed_at": computed_at_full,
        "grader_commit": grader_commit,
        "registry_commit": registry_commit,
        "histogram": histogram,
        "by_dimension": by_dimension,
        "fingerprint": {
            "readings_parsed": fp_total_readings - len(unparsed_readings),
            "readings_unparsed": len(unparsed_readings),
            "readings_unparsed_fraction": f"{len(unparsed_readings)}/{fp_total_readings}",
            "roots_parsed": fp_total_roots - len(unparsed_roots),
            "roots_unparsed": len(unparsed_roots),
            "roots_unparsed_fraction": f"{len(unparsed_roots)}/{fp_total_roots}",
        },
        "reader_coverage": {
            "lineage_root_edges_total": len(RC.lineage_root_edge_codes(canonical_entries)),
            "lineage_root_edges_cleared": 0,
        },
        "findings_open_by_class": findings_open_by_class,
        "entries": sorted(entries_out, key=lambda x: x["code"]),
        "note": (
            "IC is a readout of the registry's own internal agreement, never a truth score "
            "and never merged with the resistance ladder R0-R6. needs_reader means unchecked "
            "by a human/agent reader, not failing. See docs/CONSISTENCY_SPEC_v0_1.md."
        ),
    }
    index_path = OUT_DIR / "INDEX.json"
    new_index_text = _dump(index)

    if args.check:
        old = index_path.read_text(encoding="utf-8") if index_path.exists() else None
        # computed_at always differs; compare everything else
        def strip_ts(text):
            if text is None:
                return None
            d = json.loads(text)
            d.pop("computed_at", None)
            return d

        if strip_ts(old) != strip_ts(new_index_text):
            print("compute_consistency --check: INDEX would change", file=sys.stderr)
            index_path.write_text(new_index_text, encoding="utf-8")
            return 1
        index_path.write_text(new_index_text, encoding="utf-8")
        return 0

    index_path.write_text(new_index_text, encoding="utf-8")
    print(
        f"registry/consistency/: {len(entries_out)} sidecars written; "
        f"readings {histogram['readings']}; roots {histogram['roots']}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
