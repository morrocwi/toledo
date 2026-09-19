#!/usr/bin/env python3
"""
scripts/compute_counts.py -- S3, the top-level `counts` summary block in
registry/CANONICAL.json (registry/SCHEMA.md's `counts` field; the same
in-place-write discipline `scripts/compute_resistance.py` and
`scripts/compute_executable.py` already use for their own computed blocks,
mirrored here on purpose so this file reads the same way).

`registry/CANONICAL.json`'s own `counts` key is a computed/derived
readout over `canonical[]` -- never a hand-maintained number -- and it goes
stale exactly the way `tests/test_registry.py::test_counts_match_canonical`
already warns about: any lane script that appends/edits `canonical[]` but
never re-derives `counts` leaves the registry disagreeing with its own
array (readout-not-truth: counts come from the array, never from a cached
object that can silently drift). This script is the ONE place that
recomputes and writes that block, so "update counts" is a command, not a
by-hand edit.

Reads (never writes, except where named):
  - registry/CANONICAL.json          `canonical[]`; `status`, `domain`,
                                       `tier`, `coq.coq_status` fields per
                                       entry are what get grouped.

Writes:
  - registry/CANONICAL.json          adds/replaces the top-level `counts`
                                       key IN PLACE -- no other field (not
                                       `canonical[]`, not `raw_to_canonical`,
                                       not `generated_from_commit`, not the
                                       `resistance`/`executable` blocks the
                                       other two compute_*.py scripts own)
                                       is ever touched.

Group-by rules, confirmed against the existing stored `counts` block before
writing this script (registry/CANONICAL.json's own `counts.by_tier` already
carries an `"untagged"` bucket for entries with no/empty `tier`, and every
entry observed so far always carries a `domain`, a `status`, and a
`coq.coq_status`):
  - by_status:      Counter(e["status"] for e in canonical)
  - by_domain:      Counter(e["domain"] for e in canonical if e.get("domain"))
  - by_tier:        Counter(e.get("tier") or "untagged" for e in canonical)
  - by_coq_status:  Counter((e.get("coq") or {}).get("coq_status") for e in canonical
                            if (e.get("coq") or {}).get("coq_status"))

Pure Python 3 stdlib. No network, no coqc. Idempotent: running this twice in
a row with no `canonical[]` changes produces byte-identical output (the
`computed` note is the only field that can change, and only its trailing
free-text sentence -- the counts themselves are a pure function of the
input).
"""
from __future__ import annotations

import argparse
import collections
import json
import pathlib

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent


# ---------------------------------------------------------------------------
# IO helpers (same shape as scripts/compute_resistance.py's own)
# ---------------------------------------------------------------------------

def load_json(path: pathlib.Path, default=None):
    if not path.exists():
        return default
    with open(path, encoding="utf-8") as fh:
        return json.load(fh)


def write_json(path: pathlib.Path, obj) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(obj, fh, indent=2, ensure_ascii=False, sort_keys=False)
        fh.write("\n")


# ---------------------------------------------------------------------------
# The group-by itself
# ---------------------------------------------------------------------------

def compute_counts_block(canonical: list[dict], note: str) -> dict:
    return {
        "entries": len(canonical),
        "by_status": dict(collections.Counter(e.get("status") for e in canonical if e.get("status"))),
        "by_domain": dict(collections.Counter(e.get("domain") for e in canonical if e.get("domain"))),
        "by_tier": dict(collections.Counter(e.get("tier") or "untagged" for e in canonical)),
        "by_coq_status": dict(collections.Counter(
            (e.get("coq") or {}).get("coq_status") for e in canonical
            if (e.get("coq") or {}).get("coq_status")
        )),
        "computed": note,
    }


def run(canonical_path: pathlib.Path, note: str, *, dry_run: bool = False) -> dict:
    canonical_doc = load_json(canonical_path, default=None)

    report = {
        "canonical_entries_seen": 0,
        "counts_changed": False,
        "dry_run": dry_run,
    }

    if canonical_doc is None:
        report["note_canonical"] = f"{canonical_path} not found; skipped"
        return report

    canonical = canonical_doc.get("canonical", [])
    report["canonical_entries_seen"] = len(canonical)

    old_counts = canonical_doc.get("counts")
    new_counts = compute_counts_block(canonical, note)

    # "changed" ignores the free-text `computed` note (that field is
    # expected to change every run) -- only the actual group-by numbers
    # count as a real change, so a no-op run reports itself honestly as one.
    old_numeric = {k: v for k, v in (old_counts or {}).items() if k != "computed"}
    new_numeric = {k: v for k, v in new_counts.items() if k != "computed"}
    report["counts_changed"] = old_numeric != new_numeric
    report["counts"] = new_counts

    canonical_doc["counts"] = new_counts
    if not dry_run:
        write_json(canonical_path, canonical_doc)

    return report


def main(argv: "list[str] | None" = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--canonical", type=pathlib.Path, default=REPO_ROOT / "registry" / "CANONICAL.json")
    ap.add_argument("--note", default="computed by scripts/compute_counts.py from canonical[] (group-by "
                                       "over status/domain/tier/coq.coq_status)",
                     help="free-text sentence stored in counts.computed")
    ap.add_argument("--dry-run", action="store_true",
                     help="compute and report without writing registry/CANONICAL.json")
    args = ap.parse_args(argv)

    report = run(args.canonical, args.note, dry_run=args.dry_run)
    print(json.dumps(report, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
