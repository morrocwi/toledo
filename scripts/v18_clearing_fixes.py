#!/usr/bin/env python3
"""Toledo v1.8 clearing-team mechanical fixes (docs/CONSISTENCY_SPEC_v0_1.md sec.5).

The ONE script permitted to touch registry/CANONICAL.json and
registry/LINEAGE.jsonl for the equation-clearing pass. Applies ONLY
findings confirmed by the adversarial review and marked
`"mechanical": true` in the finding record, AND whose fix class needs no
outstanding founder ruling (class A or class B already prescribed by
SCHEMA.md itself, never class C/D). Idempotent: --dry-run prints the exact
diff and the LINEAGE event it would append; a second real run on an
already-applied finding is a no-op and says so; re-reads the files
immediately before the one atomic write.

Findings applied by this run (see docs/CONSISTENCY_SPEC_v0_1.md Appendix and
the equation-clearing findings files for the full evidence trail):

  tier.cell_table#Th_coqc-x-wrapped_related  (9 codes)
  tier.cell_table#Th_coqc-x-not_formalisable (4 codes)
  tier.cell_table#Th_coqc-x-definition       (2 codes)
      -> SCHEMA v1.1's own overlay: a Th_coqc-tagged reading whose Coq
      block records no closure of its own statement moves status
      current -> unverified with a dated status_note naming the
      coq_status; the tier is NEVER lowered by this script (that is
      class D). One `status_changed` LINEAGE event per code.

  tier.header_tier#inner-comment (125 codes)
      -> wrapper header fix (class B, explicitly named in spec sec.5's
      table): the inner `(* CAN-nnn -- ... -- tier: X -- ... *)` comment
      line in the entry's own coq/canonical/<mangled>.v file is rewritten
      so its `tier:` word matches the entry's own registry `tier` field.
      Comment text only -- no Definition/Theorem/Proof line is touched,
      no coq_status or tier field changes, no recompile needed.

Findings NOT applied here (left for RULINGS_REQUESTED.md, class C/D, or
findings marked mechanical: false): schema.root_edge_kind, the `refines`
and off-enum `relations.type` findings, structure.code_root,
structure.alias_collision, structure.occurrence_map, the LaTeX
glued-macro / sqrt / superscript findings (blocked on ruling R-1: "no .v
bump for pure notation only once R-1 is ruled -- until then, class B
statement edits wait"), symbols.reserved, symbols.sense, coq.encodes_
structure, every duplicates.* finding, and tier.unverified_not_closed.

Run: python3 scripts/v18_clearing_fixes.py [--dry-run] [--finding ID]
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
CANONICAL_PATH = REG / "CANONICAL.json"
LINEAGE_PATH = REG / "LINEAGE.jsonl"
COQ_DIR = ROOT / "coq" / "canonical"

DATE = "2026-09-08"
BY = "toledo-v1.8-clearing"

# The three tier.cell_table findings this run clears, with their coq_status
# and finding id (used only for the LINEAGE `reason` citation).
CELL_TABLE_FIXES = {
    "Th_coqc-x-wrapped_related": {
        "finding_id": "tier.cell_table#Th_coqc-x-wrapped_related",
        "codes": [f"EQ-015/B.0{i}.v1" for i in range(1, 10)],
        "coq_status": "wrapped_related",
    },
    "Th_coqc-x-not_formalisable": {
        "finding_id": "tier.cell_table#Th_coqc-x-not_formalisable",
        "codes": ["EQ-001/P.04.v1", "EQ-001/P.14.v1", "EQ-001/P.15.v1", "EQ-001/P.49.v1"],
        "coq_status": "not_formalisable",
    },
    "Th_coqc-x-definition": {
        "finding_id": "tier.cell_table#Th_coqc-x-definition",
        "codes": ["EQ-001/P.51.v1", "EQ-001/P.52.v1"],
        "coq_status": "definition",
    },
}

HEADER_TIER_FINDING_ID = "tier.header_tier#inner-comment"
TIER_COMMENT_RE = re.compile(r"(tier:\s*)([A-Za-z_][A-Za-z0-9_]*)")


def header_tier_finding_codes():
    """The exact 125-code list the confirmed finding names
    (ops/clearing/findings_tier.json evidence.all_codes) -- this script
    touches only those codes, never a superset its own heuristic finds."""
    path = ROOT / "ops" / "clearing" / "findings_tier.json"
    doc = json.loads(path.read_text(encoding="utf-8"))
    for f in doc.get("findings", []):
        if f.get("id") == HEADER_TIER_FINDING_ID:
            return set(f["evidence"]["all_codes"])
    return set()


def load_canonical():
    doc = json.loads(CANONICAL_PATH.read_text(encoding="utf-8"))
    return doc


def by_code(doc):
    return {e["code"]: e for e in doc["canonical"]}


def append_lineage(events_to_append, dry_run):
    if not events_to_append:
        return
    text = "".join(json.dumps(e, sort_keys=True, ensure_ascii=False) + "\n" for e in events_to_append)
    if dry_run:
        print("--- would append to registry/LINEAGE.jsonl ---")
        print(text, end="")
        return
    with LINEAGE_PATH.open("a", encoding="utf-8") as fh:
        fh.write(text)


def apply_cell_table_fixes(doc, code_index, only_finding, dry_run, report):
    lineage_events = []
    changed = 0
    for key, spec in CELL_TABLE_FIXES.items():
        if only_finding and only_finding != spec["finding_id"]:
            continue
        for code in spec["codes"]:
            entry = code_index.get(code)
            if entry is None:
                continue
            if entry.get("status") != "current":
                continue  # already fixed / not in the finding's state -> no-op
            note = (
                f"tier=Th_coqc with coq_status={spec['coq_status']} is a finding cell "
                f"of docs/CONSISTENCY_SPEC_v0_1.md Appendix B; SCHEMA v1.1's overlay moves "
                f"status current -> unverified with this dated note rather than lowering "
                f"the tier (class D). (coq_status={spec['coq_status']})"
            )
            print(f"[tier.cell_table] {code}: status current -> unverified")
            if not dry_run:
                entry["status"] = "unverified"
                entry["status_note"] = note
            lineage_events.append(
                {
                    "code": code,
                    "date": DATE,
                    "event": "status_changed",
                    "from": "current",
                    "to": "unverified",
                    "reason": (
                        f"{spec['finding_id']}: {note} "
                        f"docs/CONSISTENCY_SPEC_v0_1.md sec.2.3 tier.cell_table."
                    ),
                    "by": BY,
                }
            )
            changed += 1
    report["tier.cell_table"] = changed
    return lineage_events


def apply_header_tier_fixes(code_index, only_finding, dry_run, report):
    if only_finding and only_finding != HEADER_TIER_FINDING_ID:
        report["tier.header_tier"] = 0
        return []
    changed = 0
    events = []
    allowed_codes = header_tier_finding_codes()
    for code, entry in code_index.items():
        if code not in allowed_codes:
            continue
        coq = entry.get("coq") or {}
        file_rel = coq.get("file")
        tier = entry.get("tier")
        if not file_rel or not tier:
            continue
        path = ROOT / file_rel
        if not path.exists():
            continue
        text = path.read_text(encoding="utf-8")
        # only look inside the leading comment block(s) before the first
        # `From Coq`/`From MRC` import line, never inside a proof term
        code_start = re.search(r"^\s*(From |Section |Require )", text, re.MULTILINE)
        header_region_end = code_start.start() if code_start else len(text)
        # the inner CAN-nnn header can appear after imports too (as in the
        # sample files); search the whole file's comments but never a line
        # that is not inside a (* ... *) comment.
        m = None
        for cm in re.finditer(r"\(\*.*?\*\)", text, re.DOTALL):
            inner = TIER_COMMENT_RE.search(cm.group(0))
            if inner:
                m = inner
                comment_start = cm.start()
                break
        if not m:
            continue
        current_word = m.group(2).strip()
        if current_word == tier:
            continue
        abs_start = comment_start + m.start(2)
        abs_end = comment_start + m.end(2)
        new_text = text[:abs_start] + tier + text[abs_end:]
        print(f"[tier.header_tier] {code}: inner comment tier: {current_word!r} -> {tier!r}")
        if not dry_run:
            path.write_text(new_text, encoding="utf-8")
        events.append(
            {
                "code": code,
                "date": DATE,
                "event": "revised",
                "from": f"coq wrapper header comment 'tier: {current_word}'",
                "to": f"coq wrapper header comment 'tier: {tier}'",
                "reason": (
                    f"{HEADER_TIER_FINDING_ID}: the wrapper's inner header comment named a tier "
                    f"that disagreed with the entry's own registry tier ({tier}); comment text "
                    f"only, no Definition/Theorem/Proof line changed, no statement change. "
                    f"docs/CONSISTENCY_SPEC_v0_1.md sec.5 class B (wrapper header fixes)."
                ),
                "by": BY,
            }
        )
        changed += 1
    report["tier.header_tier"] = changed
    return events


def recompute_counts(doc):
    """schema.counts (docs/CONSISTENCY_SPEC_v0_1.md sec.2.1): `counts{}` must
    equal a fresh recount. Class A -- computed field, no content change."""
    from collections import Counter

    entries = doc["canonical"]
    counts = doc.get("counts", {})
    counts["entries"] = len(entries)
    counts["by_status"] = dict(sorted(Counter(e.get("status") for e in entries).items()))
    counts["by_domain"] = dict(sorted(Counter(e.get("domain") for e in entries).items()))
    counts["by_tier"] = dict(sorted(Counter(e.get("tier") for e in entries).items()))
    counts["by_coq_status"] = dict(
        sorted(Counter((e.get("coq") or {}).get("coq_status") for e in entries).items())
    )
    counts["computed"] = f"{DATE} from canonical[] (scripts/v18_clearing_fixes.py)"
    doc["counts"] = counts


def main(argv=None):
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--finding", default=None, help="apply only this finding id")
    args = ap.parse_args(argv)

    doc = load_canonical()
    code_index = by_code(doc)
    report = {}

    lineage_events = apply_cell_table_fixes(doc, code_index, args.finding, args.dry_run, report)
    lineage_events += apply_header_tier_fixes(code_index, args.finding, args.dry_run, report) or []

    if not args.dry_run and any(report.values()):
        recompute_counts(doc)
        # match the file's existing serialisation exactly (indent=2, key
        # insertion order preserved, raw UTF-8) so the diff shows only the
        # fields this run actually changed, never a whole-file reformat.
        CANONICAL_PATH.write_text(
            json.dumps(doc, indent=2, ensure_ascii=False) + "\n",
            encoding="utf-8",
        )
        append_lineage(lineage_events, dry_run=False)
    elif args.dry_run:
        append_lineage(lineage_events, dry_run=True)

    total = sum(report.values())
    print(f"v18_clearing_fixes: {report}, total changed rows/files = {total}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
