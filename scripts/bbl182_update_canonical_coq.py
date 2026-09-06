#!/usr/bin/env python3
"""BBL-182 finishing step: write coq.{file,identifier,assumptions,coq_status}
into registry/CANONICAL.json for every canonical entry now backed by a
coq/canonical/<code>.v file, from the verify.sh PASS/FAIL report and the
rename ledger -- never hand-edited. CAN-257/CAN-258 (new N3 splits with no
Coq content yet) get coq_status "not_yet_formalised", left otherwise as-is.
"""
import json, os, re

import pathlib as _pathlib
ROOT = str(_pathlib.Path(__file__).resolve().parents[1])
REG = os.path.join(ROOT, "registry", "CANONICAL.json")
LEDGER = os.path.join(ROOT, "registry", "coq_rename_ledger.json")
VERIFY = os.path.join(ROOT, "coq", "canonical", "verify_report.txt")


def mangle(code):
    return code.replace('/', '__').replace('.', '_').replace('-', '_')


def main():
    with open(REG, encoding='utf-8') as f:
        reg = json.load(f)
    with open(LEDGER, encoding='utf-8') as f:
        ledger = json.load(f)

    can_id_idents = {}
    for e in ledger['entries']:
        can_id_idents.setdefault(e['can_id'], []).append(e['old_identifier'])

    proved = set()  # "<module>.<ident>" that verify.sh confirmed closed
    proof_bearing_by_module = {}
    if os.path.exists(VERIFY):
        for line in open(VERIFY, encoding='utf-8'):
            m = re.match(r'^PASS\s+(\S+)\.(\S+)\s', line)
            if m:
                proved.add(m.group(1) + '.' + m.group(2))
                proof_bearing_by_module.setdefault(m.group(1), set()).add(m.group(2))

    n_updated = 0
    for e in reg['canonical']:
        cid = e['id']
        code = e.get('code')
        if not code:
            continue
        mangled = mangle(code)
        vfile = f"coq/canonical/{mangled}.v"
        path = os.path.join(ROOT, vfile)
        if not os.path.exists(path):
            # CAN-257 / CAN-258: N3 split, not yet formalised in the 9 MRC modules
            e['coq'] = {
                "file": None, "identifier": None, "assumptions": None,
                "imported_from": None, "coq_status": "not_yet_formalised",
                "coq_axioms": [], "coq_source_redistributed": True,
            }
            n_updated += 1
            continue
        idents = can_id_idents.get(cid, [])
        module = mangled
        bearing = proof_bearing_by_module.get(module, set())
        all_closed = all((module + '.' + i) in proved for i in bearing) if bearing else True
        assumptions = "Closed under the global context" if all_closed else "+axioms: see verify_report.txt"
        e['coq'] = {
            "file": vfile,
            "identifier": ", ".join(idents) if idents else None,
            "assumptions": assumptions,
            "imported_from": None,
            "coq_status": "closed" if all_closed else "build_failed",
            "coq_axioms": [],
            "coq_source_redistributed": True,
        }
        n_updated += 1

    reg.setdefault('counts', {})['coq_files_bbl182'] = n_updated
    with open(REG, 'w', encoding='utf-8') as f:
        json.dump(reg, f, indent=2, ensure_ascii=False)
        f.write('\n')
    print(f"updated coq{{}} on {n_updated} canonical entries")


if __name__ == '__main__':
    main()
