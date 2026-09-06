#!/usr/bin/env python3
"""Checker (I2) part (e): every CANONICAL.json entry with coq_status "closed" or
"axioms" must name a coq/canonical/<file> that exists, and (for closed) every
proof-bearing identifier in that file must appear as PASS/"Closed under the
global context" in coq/canonical/verify_report.txt."""
import json, re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
COQ = ROOT / "coq" / "canonical"

def mangle(code):
    return code.replace('/', '__').replace('.', '_').replace('-', '_')

def main():
    canon = json.load(open(REG / "CANONICAL.json"))
    entries = canon["canonical"]

    verify_report = (COQ / "verify_report.txt").read_text()
    passed_pairs = set()
    for line in verify_report.splitlines():
        m = re.match(r"^PASS\s+(\S+)\s+--", line)
        if m:
            passed_pairs.add(m.group(1))  # "<modname>.<ident>"

    modnames_passed = {p.split('.', 1)[0] for p in passed_pairs}

    checked = 0
    fails = []
    for e in entries:
        cq = e["coq"]
        status = cq.get("coq_status")
        if status not in ("closed", "axioms"):
            continue
        checked += 1
        fname = cq.get("file")
        code = e["code"]
        expected_mangled = mangle(code)
        if not fname:
            fails.append((code, "coq_status closed/axioms but coq.file is null"))
            continue
        vpath = ROOT / fname
        if not vpath.exists():
            fails.append((code, f"named file {fname} does not exist"))
            continue
        modname = Path(fname).stem
        if modname != expected_mangled:
            fails.append((code, f"file {fname} does not match expected mangled name {expected_mangled}.v"))
        if status == "closed":
            src = vpath.read_text(encoding="utf-8", errors="replace")
            proof_idents = re.findall(
                r"^\s*(?:Theorem|Lemma|Corollary|Example|Remark)\s+([A-Za-z0-9_']+)",
                src, re.MULTILINE)
            if proof_idents:
                missing = [i for i in proof_idents if f"{modname}.{i}" not in passed_pairs]
                if missing:
                    fails.append((code, f"module {modname} has proof-bearing identifiers "
                                         f"{missing} with no PASS line in verify_report.txt"))
            # else: Definition/Record/Inductive-only file -- verify.sh's own documented
            # design (see coq/canonical/verify.sh header) skips these as carrying no proof
            # obligation; "closed" here means build-succeeded-with-no-obligations, not
            # Print-Assumptions-checked -- pre-existing N3 convention, not an N4 finding.

    print(f"[info] entries with coq_status closed/axioms: {checked}")
    if fails:
        print(f"[FAIL] {len(fails)} problems:")
        for f in fails[:40]:
            print("  ", f)
    else:
        print("[PASS] every closed/axioms entry's file exists and (if closed) has PASS lines in verify_report.txt")

if __name__ == "__main__":
    main()
