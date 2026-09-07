#!/usr/bin/env python3
"""Toledo v1.1 -- correction for finding STALE-COUNTS-FIELD.

registry/CANONICAL.json's top-level counts.by_tier was written once by
scripts/v11_C.py from a snapshot and never refreshed after scripts/v11_b1.py
(and the other v1.1 registrars) retagged more untagged->Definition entries
-- readout-not-truth: counts must come from the live canonical[] array, not
a stale snapshot sitting inside the project's own machine-readable source of
truth. There was also no counts.by_coq_status field at all.

This script is idempotent and safe to re-run any number of times: it
re-reads registry/CANONICAL.json immediately before writing, recomputes
counts.by_tier and counts.by_coq_status directly from the live canonical[]
array (nothing else in counts.* -- raw, by_domain, n4_* -- is touched), and
overwrites those two fields. No LINEAGE event is appended (this is metadata
about the registry, not a change to any coded entry).

Run LAST, after every other v1.1 registry-content fix (v11_b1_fix_assumptions.py,
v11_reclassify_stale_closed.py, any lane script), so the recomputed counts
reflect the final state.
"""
import json
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CAN_PATH = ROOT / "registry" / "CANONICAL.json"


def main():
    data = json.loads(CAN_PATH.read_text(encoding="utf-8"))  # re-read immediately before writing
    entries = data["canonical"]

    by_tier = Counter(e.get("tier", "untagged") for e in entries)
    by_coq_status = Counter((e.get("coq") or {}).get("coq_status", "none") for e in entries)

    old_by_tier = data["counts"].get("by_tier")
    old_by_coq_status = data["counts"].get("by_coq_status")

    data["counts"]["by_tier"] = dict(sorted(by_tier.items()))
    data["counts"]["by_coq_status"] = dict(sorted(by_coq_status.items()))

    CAN_PATH.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    print("by_tier: old =", old_by_tier)
    print("by_tier: new =", data["counts"]["by_tier"])
    print("by_coq_status: old =", old_by_coq_status)
    print("by_coq_status: new =", data["counts"]["by_coq_status"])


if __name__ == "__main__":
    main()
