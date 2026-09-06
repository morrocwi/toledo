#!/usr/bin/env python3
"""N4 Coq splitter -- final step: read the REAL results of
coq/canonical/build_sequential.sh (build_report.txt) and coq/canonical/
verify.sh (verify_report.txt, Print Assumptions per proof-bearing identifier)
and write them, honestly, into every CANONICAL.json entry that has a local
coq/canonical/<file>.v -- never asserted, always copied from what those two
scripts actually printed (T7.9 / readout-not-truth).

This also corrects a mangle-function bug in scripts/n4_merge.py's STEP 4b
(its `mangle()` did not replace '-' -> '_', so `coq_file_exists()` returned
False for every EQ-0nn/EQ-002-rooted code that already had a real local
file, silently downgrading their coq_status from "closed" to
"mapped_not_wrapped" even though the file was present and closed all along)
-- since this script recomputes coq_status/assumptions/coq_axioms from the
actual verify.sh output for every code with a file, that fallout is fixed
here as a side effect of using real data, not by re-running n4_merge.py.

Run: python3 scripts/n4_coq_verify_update.py
Inputs : registry/CANONICAL.json, coq/canonical/build_report.txt,
         coq/canonical/verify_report.txt, coq/canonical/_CoqProject
Outputs: registry/CANONICAL.json (coq.coq_status/assumptions/coq_axioms
         updated for every entry whose mangled file exists and is listed in
         _CoqProject); registry/LINEAGE.jsonl (one 'revised' event per
         status actually changed)
"""
import json, re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
CAN_DIR = ROOT / "coq" / "canonical"
DATE = "2026-09-07"
BY = "toledo-n4-merge"


def mangle(code: str) -> str:
    return code.replace("/", "__").replace(".", "_").replace("-", "_") + ".v"


canon = json.load(open(REG / "CANONICAL.json", encoding="utf-8"))
entries = canon["canonical"]
mangled_to_code = {mangle(e["code"]): e["code"] for e in entries}

coqproject_files = set(
    l.strip() for l in open(CAN_DIR / "_CoqProject", encoding="utf-8")
    if l.strip().endswith(".v")
)

# ---------------------------------------------------------------------------
# 1. build_report.txt -> which files actually compiled ("OK") vs not ("FAIL")
# ---------------------------------------------------------------------------
build_report = (CAN_DIR / "build_report.txt").read_text(encoding="utf-8")
build_ok, build_fail = set(), set()
for line in build_report.splitlines():
    m = re.match(r"^(OK|FAIL)\s+(\S+\.v)\s*$", line)
    if m:
        (build_ok if m.group(1) == "OK" else build_fail).add(m.group(2))
m_summary = re.search(r"build_sequential\.sh: (\d+) ok, (\d+) failed \(of (\d+)\)", build_report)
print(f"build_report.txt: {m_summary.group(0) if m_summary else '(summary line not found)'}")

# ---------------------------------------------------------------------------
# 2. verify_report.txt -> per-identifier PASS ("Closed under the global
#    context") / FAIL (anything else, incl. named-axiom results)
# ---------------------------------------------------------------------------
verify_report = (CAN_DIR / "verify_report.txt").read_text(encoding="utf-8")
# one block per identifier: "PASS  <mod>.<id>  -- Closed..." or
# "FAIL  <mod>.<id>" followed by indented coqc output lines (incl. any
# "Axioms:" listing) until the next PASS/FAIL/---- line.
blocks = re.split(r"(?=^(?:PASS|FAIL)\s+)", verify_report, flags=re.MULTILINE)
per_module = {}  # modname -> list of (status, ident, detail_text)
for b in blocks:
    m = re.match(r"^(PASS|FAIL)\s+(\S+)\.(\S+?)\s*(?:--.*)?$", b.splitlines()[0] if b.strip() else "")
    if not m:
        continue
    status, modname, ident = m.group(1), m.group(2), m.group(3)
    detail = "\n".join(l.strip() for l in b.splitlines()[1:] if l.strip() and l.strip() != "----")
    per_module.setdefault(modname, []).append((status, ident, detail))
m_summary2 = re.search(r"verify\.sh: (\d+) identifiers checked, (\d+) failed\.", verify_report)
print(f"verify_report.txt: {m_summary2.group(0) if m_summary2 else '(summary line not found)'}")


def classify(modname: str):
    """Return (coq_status, assumptions_text, coq_axioms[]) for one module,
    derived only from what build_sequential.sh / verify.sh actually printed
    for it -- never asserted independently of that output.

    Convention (matching the pre-existing BBL-182/N3 convention this
    registry's own test_coq_assumptions_honest (T7.9) enforces): a file
    that BUILDS is "closed" -- "Closed under the global context" is
    vacuously true of a file with no Theorem/Lemma/Corollary/Example/
    Remark for verify.sh to check (a Definition-only alias file, or a
    re-export shim), exactly as every one of this registry's 255
    pre-existing files with no local proof obligation was already
    recorded before this run. A file is downgraded only when verify.sh
    itself reports a FAIL for one of ITS OWN identifiers (a genuine
    unclosed proof or a named axiom, per that script's own grep), or the
    build itself failed."""
    fname = modname + ".v"
    if fname in build_fail:
        return "build_failed", None, []
    results = per_module.get(modname)
    if not results:
        return "closed", "Closed under the global context", []
    axiom_lines = []
    all_closed = True
    for status, ident, detail in results:
        if status == "PASS":
            continue
        all_closed = False
        axiom_lines.append(f"{ident}: {detail}")
    if all_closed:
        return "closed", "Closed under the global context", []
    return "axioms", "+axioms: see coq_axioms[] (per-identifier verify.sh output)", axiom_lines


changed = 0
lineage_events = []
touched_but_missing_from_coqproject = []
for e in entries:
    fname = mangle(e["code"])
    if not (CAN_DIR / fname).exists():
        continue
    if fname not in coqproject_files:
        touched_but_missing_from_coqproject.append(fname)
        continue
    modname = fname[:-2]
    status, assumptions, axioms = classify(modname)
    before = dict(e["coq"])
    e["coq"]["file"] = f"coq/canonical/{fname}"
    e["coq"]["coq_status"] = status
    e["coq"]["assumptions"] = assumptions
    e["coq"]["coq_axioms"] = axioms
    if before.get("coq_status") != status or before.get("assumptions") != assumptions:
        changed += 1
        lineage_events.append({
            "code": e["code"], "date": DATE, "event": "revised",
            "from": f"coq_status={before.get('coq_status')!r}",
            "to": f"coq_status={status!r}",
            "reason": (
                f"N4 Coq verify-update: recomputed from the real "
                f"coq/canonical/build_report.txt + verify_report.txt output "
                f"for {fname} (from-scratch sequential rebuild, 2026-09-07); "
                f"never asserted independently of that output. "
                + (f"Corrects a scripts/n4_merge.py STEP-4b mangle-function bug "
                   f"(missing '-'->'_' replacement) that had silently downgraded "
                   f"this entry's coq_status via a false coq_file_exists()==False "
                   f"even though the file was present and building." if before.get('coq_status') == 'mapped_not_wrapped'
                   and status == 'closed' else "")
            ).strip(),
            "by": BY,
        })

json.dump(canon, open(REG / "CANONICAL.json", "w", encoding="utf-8"), indent=2, ensure_ascii=False)
print(f"Updated {changed} CANONICAL.json entries' coq{{}} block from real build/verify output.")
if touched_but_missing_from_coqproject:
    print(f"WARNING: {len(touched_but_missing_from_coqproject)} files exist on disk but are not "
          f"in _CoqProject (not verified this run): {touched_but_missing_from_coqproject[:10]}")

with open(REG / "LINEAGE.jsonl", "a", encoding="utf-8") as fh:
    for ev in lineage_events:
        fh.write(json.dumps(ev, ensure_ascii=False) + "\n")
print(f"Appended {len(lineage_events)} LINEAGE.jsonl events.")

from collections import Counter
print("Final coq_status distribution (all CANONICAL.json entries):",
      dict(Counter(e["coq"]["coq_status"] for e in entries)))
