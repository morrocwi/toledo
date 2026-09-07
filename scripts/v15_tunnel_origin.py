#!/usr/bin/env python3
"""Toledo v1.5 fix -- Tunnel origin completion.

"The Recursive Epistemic Tunnel" was deposited: v2.1, Zenodo record id
22639311, DOI 10.5281/zenodo.22639311 (concept DOI 10.5281/zenodo.22639309).
Two groups of registry/CANONICAL.json entries carried a placeholder pending
this deposit:

(A) The 23 RET-N01..N23 entries themselves (toledo-v1.5-tunnel merge):
    origin.source = "The Recursive Epistemic Tunnel v2.0 (Zenodo record
    pending -- origin to be completed by a LINEAGE revised event after
    deposit)", origin.record_id/doi = null, occurrences = []. Set origin to
    {source: "The Recursive Epistemic Tunnel v2.1", record_id: 22639311,
    doi: "10.5281/zenodo.22639311", section: <unchanged>} and occurrences
    to [{record_id: 22639311, doi: ..., label: "Tunnel-v2.1:eq.N", section:
    <unchanged>, raw_key: <unchanged except v2.0->v2.1>}] -- the v2.0 label
    is kept as an alias note in the new occurrence's own section text
    (never silently dropped).

(B) The 23 existing occurrences already recorded, on OTHER (parent)
    CANONICAL entries, of a "Tunnel-v2.0:eq.N" label with record_id null
    (added by the toledo-v1.5-tunnel merge's own occurrence_added LINEAGE
    events, e.g. EQ-015/M.01.v1, weld/M.02.v1, A.8/M.02.v1 ...): set
    record_id 22639311 and doi 10.5281/zenodo.22639311, label kept exactly
    as "Tunnel-v2.0:eq.N" (that label names the manuscript equation number
    at the pre-deposit revision the occurrence was recorded against; only
    the record/doi identity is being completed here, not the label).

Idempotent: re-reads registry/CANONICAL.json immediately before its own
write; each occurrence/entry is only touched if it still carries the
pending-deposit placeholder (record_id is None and, for group A, origin
still says "Zenodo record pending").

Run: python3 scripts/v15_tunnel_origin.py [--dry-run]
"""
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
CAN = REG / "CANONICAL.json"
LINEAGE = REG / "LINEAGE.jsonl"
DATE = "2026-09-07"
BY = "toledo-v1.5-fix"

RECORD_ID = 22639311
DOI = "10.5281/zenodo.22639311"
CONCEPT_DOI = "10.5281/zenodo.22639309"
TITLE_V21 = "The Recursive Epistemic Tunnel v2.1"

# code -> "eq.N" suffix (from the entry's own aliases / occurrences label)
RET_CODES = {
    "EQ-015/H.40.v1": "eq.1",
    "EQ-002/H.05.v1": "eq.2",
    "EQ-002/H.06.v1": "eq.3",
    "EQ-015/H.41.v1": "eq.4",
    "weld/H.35.v1": "eq.5",
    "weld/H.36.v1": "eq.6",
    "A.8/M.20.v1": "eq.7",
    "EQ-015/H.42.v1": "eq.8",
    "weld/H.37.v1": "eq.9",
    "EQ-015/H.43.v1": "eq.10",
    "EQ-015/H.44.v1": "eq.11",
    "EQ-015/H.45.v1": "eq.12",
    "EQ-015/H.46.v1": "eq.13",
    "EQ-015/H.47.v1": "eq.14",
    "A.5/H.24.v1": "eq.15",
    "A.8/M.21.v1": "eq.16",
    "A.8/M.22.v1": "eq.17",
    "A.8/M.23.v1": "eq.18",
    "A.8/M.24.v1": "eq.19",
    "EQ-002/M.04.v1": "eq.20",
    "EQ-015/H.48.v1": "eq.21",
    "EQ-015/H.49.v1": "eq.22",
    "weld/W.11.v1": "eq.23",
}


def load():
    return json.loads(CAN.read_text(encoding="utf-8"))


def atomic_write(doc):
    tmp = CAN.with_suffix(".json.tmp")
    tmp.write_text(json.dumps(doc, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    tmp.replace(CAN)


def append_lineage(events):
    if not events:
        return
    with open(LINEAGE, "a", encoding="utf-8") as fh:
        for ev in events:
            fh.write(json.dumps(ev, ensure_ascii=False) + "\n")


def fix_group_a(doc, events):
    """The 23 RET entries themselves: origin + occurrences."""
    touched = 0
    for e in doc["canonical"]:
        code = e["code"]
        if code not in RET_CODES:
            continue
        origin = e["origin"]
        if origin.get("record_id") == RECORD_ID:
            print(f"SKIP {code}: origin already completed")
            continue
        if "Zenodo record pending" not in (origin.get("source") or ""):
            print(f"SKIP {code}: origin does not carry the pending-deposit placeholder, left untouched")
            continue
        old_origin = json.dumps(origin, ensure_ascii=False)
        old_occ = json.dumps(e.get("occurrences"), ensure_ascii=False)
        eq_n = RET_CODES[code]
        label_v21 = f"Tunnel-v2.1:{eq_n}"
        label_v20 = f"Tunnel-v2.0:{eq_n}"
        section = origin.get("section")
        e["origin"] = {
            "source": TITLE_V21,
            "repo_anchor": None,
            "record_id": RECORD_ID,
            "doi": DOI,
            "section": section,
        }
        e["occurrences"] = [{
            "record_id": RECORD_ID,
            "doi": DOI,
            "label": label_v21,
            "section": f"{section} (alias: pre-deposit label {label_v20})",
            "raw_key": f"The Recursive Epistemic Tunnel v2.1:{label_v21}",
        }]
        touched += 1
        events.append({
            "code": code, "date": DATE, "event": "revised",
            "from": f"origin={old_origin}, occurrences={old_occ}",
            "to": f"origin={json.dumps(e['origin'], ensure_ascii=False)}, occurrences={json.dumps(e['occurrences'], ensure_ascii=False)}",
            "reason": (
                'Toledo v1.5 fix (Tunnel origin): "The Recursive Epistemic '
                f'Tunnel" deposited as v2.1, Zenodo record id {RECORD_ID}, '
                f'DOI {DOI} (concept DOI {CONCEPT_DOI}). Completed the '
                "origin/occurrence placeholder toledo-v1.5-tunnel left "
                f"pending deposit; kept the pre-deposit label {label_v20} "
                "as an alias note in the occurrence's own section text "
                "rather than dropping it."
            ),
            "by": BY,
        })
        print(f"FIX  {code}: origin/occurrences set to v2.1 record {RECORD_ID}")
    return touched


def fix_group_b(doc, events):
    """The 23 existing occurrences on other entries with record_id null."""
    touched = 0
    for e in doc["canonical"]:
        code = e["code"]
        occs = e.get("occurrences") or []
        for occ in occs:
            label = occ.get("label") or ""
            if not label.startswith("Tunnel-v2.0:eq."):
                continue
            if occ.get("record_id") == RECORD_ID:
                continue
            if occ.get("record_id") is not None:
                continue
            old_occ = json.dumps(occ, ensure_ascii=False)
            occ["record_id"] = RECORD_ID
            occ["doi"] = DOI
            touched += 1
            events.append({
                "code": code, "date": DATE, "event": "revised",
                "from": f"occurrence={old_occ}",
                "to": f"occurrence={json.dumps(occ, ensure_ascii=False)}",
                "reason": (
                    'Toledo v1.5 fix (Tunnel origin): "The Recursive '
                    f'Epistemic Tunnel" deposited, Zenodo record id '
                    f'{RECORD_ID}, DOI {DOI} (concept DOI {CONCEPT_DOI}). '
                    "This occurrence's record_id/doi were null pending "
                    "deposit (toledo-v1.5-tunnel merge); completed now. "
                    "label kept exactly as recorded (names the manuscript "
                    "equation number at the revision the occurrence was "
                    "found against; not itself changed by the deposit)."
                ),
                "by": BY,
            })
            print(f"FIX  {code}: occurrence {label!r} record_id/doi completed")
    return touched


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    doc = load()
    events = []
    n_a = fix_group_a(doc, events)
    n_b = fix_group_b(doc, events)

    if (n_a or n_b) and not args.dry_run:
        atomic_write(doc)
        append_lineage(events)
    print(f"group A (RET entries): {n_a} touched. group B (CAN occurrences): {n_b} touched. "
          f"{'(dry-run, no write)' if args.dry_run else ''}")


if __name__ == "__main__":
    main()
