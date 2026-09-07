#!/usr/bin/env python3
"""Toledo v1.5, lane AF (fix AXIOM-FORMAT-1).

scripts/v15_b.py's classify_assumptions() copied coqc's raw multi-line
"Axioms:\\n..." header text verbatim into registry/CANONICAL.json's
coq.assumptions field for axiom-carrying results. registry/SCHEMA.md's own
T7.9 contract (and tests/test_registry.py::test_coq_assumptions_honest)
requires a string that is either exactly "Closed under the global context"
or starts "+axioms:" naming the axioms. This made coq.assumptions for the
3 axiom-carrying v1.5-lane-B entries (CMC/M.01.v1, CMC/M.02.v1, CMC/M.18.v1)
schema-noncompliant, and made coq/canonical/verify.sh's grep-only pass
criterion ("Closed under the global context" is the only string it accepts)
report those 3 identifiers as FAIL even though the content is 100% honest
(all 3 are correctly tiered coq_status=="axioms", never "closed").

This script does NOT re-derive or re-classify anything new: it re-runs the
same, already-written coq/canonical/<mangled-code>.v wrapper files for these
3 entries through coqc (one at a time, RAM-gated, same flags as
build_sequential.sh/verify.sh/v15_b.py) so the assumptions string it writes
is freshly copied from real coqc output using the now-fixed
classify_assumptions() in scripts/v15_b.py -- never asserted, never
reformatted from the old stored string by hand.

Idempotent, per SCHEMA.md's own convention: re-reads registry/CANONICAL.json
immediately before the atomic write and touches only the coq.assumptions /
coq.coq_axioms fields of these 3 entries -- skipped if a code's
coq.coq_status is no longer "axioms" by write time (another lane got there
first).

Usage:
  python3 scripts/v15_af.py --report   # dry run, no coqc, no writes
  python3 scripts/v15_af.py --apply    # build + write
"""
import argparse
import importlib.util
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
CAN = REG / "CANONICAL.json"
LINEAGE = REG / "LINEAGE.jsonl"
DATE = "2026-09-07"
BY = "toledo-v1.5-af"

TARGET_CODES = ["CMC/M.01.v1", "CMC/M.02.v1", "CMC/M.18.v1"]

# Load the (now-fixed) helpers from v15_b.py directly, so this lane shares
# exactly the same mangle / atomic_write / append_lineage / run_coqc /
# classify_assumptions logic rather than a second, possibly-drifting copy.
_spec = importlib.util.spec_from_file_location("v15_b", str(Path(__file__).parent / "v15_b.py"))
v15_b = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(v15_b)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true")
    ap.add_argument("--report", action="store_true")
    args = ap.parse_args()

    doc = v15_b.load()
    by_code = {e["code"]: e for e in doc["canonical"]}

    print(f"AXIOM-FORMAT-1: {len(TARGET_CODES)} target entries")
    for code in TARGET_CODES:
        e = by_code.get(code)
        if e is None:
            print(f"  MISSING {code}: not found in CANONICAL.json")
            continue
        print(f"  {code}: coq_status={e['coq']['coq_status']} file={e['coq']['file']} "
              f"assumptions={e['coq']['assumptions']!r}")

    if not args.apply:
        return

    results = []  # (code, relpath, ident, coq_status, assumptions)
    fail = 0
    for code in TARGET_CODES:
        doc_now = v15_b.load()  # re-read: another lane may have written meanwhile
        e = next((x for x in doc_now["canonical"] if x["code"] == code), None)
        if e is None or e["coq"]["coq_status"] != "axioms":
            print(f"SKIP {code}: no longer coq_status==axioms (other lane got there first)")
            continue
        relpath = Path(e["coq"]["file"]).name  # coq/canonical/<mangled>.v -> <mangled>.v
        ident = e["coq"]["identifier"]
        out, rc = v15_b.run_coqc(relpath)
        assumptions = v15_b.classify_assumptions(out, ident)
        if rc != 0 or assumptions is None:
            fail += 1
            print(f"FAIL {code} ({relpath}):\n{out[-2000:]}")
            continue
        if not (assumptions == "Closed under the global context" or assumptions.startswith("+axioms:")):
            fail += 1
            print(f"FAIL {code}: classify_assumptions produced a non-conforming string: {assumptions!r}")
            continue
        results.append((code, relpath, ident, assumptions))
        print(f"OK   {code} -> {assumptions}")

    if fail:
        print(f"{fail} failures -- stopping before registry write.", file=sys.stderr)
        sys.exit(1)

    if not results:
        print("nothing to write to the registry.")
        return

    doc_now = v15_b.load()
    by_code_now = {x["code"]: x for x in doc_now["canonical"]}
    events = []
    changed = 0
    for code, relpath, ident, assumptions in results:
        e = by_code_now.get(code)
        if e is None or e["coq"]["coq_status"] != "axioms":
            print(f"SKIP-AT-WRITE {code}: registry entry moved on before this write")
            continue
        old_assumptions = e["coq"]["assumptions"]
        if old_assumptions == assumptions:
            print(f"NOOP {code}: assumptions already matches the fixed format")
            continue
        axiom_part = assumptions.split(":", 1)[1] if assumptions.startswith("+axioms:") else ""
        axiom_lines = [a.strip() for a in axiom_part.split(",") if a.strip()]
        e["coq"]["assumptions"] = assumptions
        if axiom_lines:
            e["coq"]["coq_axioms"] = axiom_lines
        events.append({
            "code": code, "date": DATE, "event": "revised",
            "from": f"coq.assumptions={old_assumptions!r}",
            "to": f"coq.assumptions={assumptions!r}",
            "reason": (
                "Toledo v1.5 lane AF (AXIOM-FORMAT-1): reformatted coq.assumptions "
                "from the raw coqc 'Axioms:\\n...' header to the SCHEMA.md T7.9 "
                "'+axioms: ...' contract; re-verified by re-running the existing "
                f"coq/canonical/{relpath} wrapper through coqc this run "
                "(scripts/v15_b.py's classify_assumptions, now fixed)."
            ),
            "by": BY,
        })
        changed += 1

    v15_b.atomic_write(doc_now)
    v15_b.append_lineage(events)
    print(f"registry updated: {changed} entries, {len(events)} lineage events appended.")


if __name__ == "__main__":
    main()
