#!/usr/bin/env python3
"""BBL-182 follow-up: some CAN ids alias (reuse-not-redefine) an identifier
that a DIFFERENT CAN id's own file actually defines (CAN-005/CAN-222 alias
CAN-004/CAN-008; a handful of epistemic/social/method ids likewise reuse a
sibling id's identifier rather than redefine it). Those generated files fail
with "The reference X was not found". This script:
  1. builds identifier -> defining-file from registry/coq_rename_ledger.json
  2. runs coqc on a given file, and on "reference X not found", inserts
     `From MRC Require Import <that file's module>.` right after the
     existing Require block, then retries (bounded iterations).
Only ever ADDS a Require line; never edits proof content.
"""
import json, os, re, subprocess, sys

import pathlib as _pathlib
ROOT = str(_pathlib.Path(__file__).resolve().parents[1])
CAN_DIR = os.path.join(ROOT, "coq/canonical")
REG_DIR = os.path.join(ROOT, "registry")

with open(os.path.join(REG_DIR, 'coq_rename_ledger.json')) as f:
    ledger = json.load(f)

ident2file = {}
for e in ledger['entries']:
    mod = e['new_file'].split('/')[-1][:-2]  # strip 'coq/canonical/' and '.v'
    ident2file.setdefault(e['old_identifier'], set()).add(mod)

NOT_FOUND_RE = re.compile(r'The reference (\S+) was not found')


def insert_require(path, other_mod):
    with open(path, encoding='utf-8') as f:
        text = f.read()
    line = f"From MRC Require Import {other_mod}.\n"
    if line in text:
        return False
    # insert right before the blank line that follows the Require block --
    # i.e. right before the first blank line after 'Set Implicit Arguments.'
    marker = "Set Implicit Arguments.\n"
    idx = text.find(marker)
    if idx == -1:
        return False
    idx2 = idx + len(marker)
    new_text = text[:idx2] + line + text[idx2:]
    with open(path, 'w', encoding='utf-8') as f:
        f.write(new_text)
    return True


def try_build(path):
    r = subprocess.run(
        ['coqc', '-q', '-Q', '.', 'MRC', '-Q', '../master-river', 'MR', os.path.basename(path)],
        cwd=CAN_DIR, capture_output=True, text=True)
    return r.returncode == 0, r.stdout + r.stderr


def fix_one(fname, max_rounds=8):
    path = os.path.join(CAN_DIR, fname)
    self_mod = fname[:-2]
    for _ in range(max_rounds):
        ok, out = try_build(path)
        if ok:
            return True, "OK"
        m = NOT_FOUND_RE.search(out)
        if not m:
            return False, out
        missing = m.group(1)
        cands = ident2file.get(missing, set()) - {self_mod}
        if not cands:
            return False, f"no known defining file for {missing}\n{out}"
        other = sorted(cands)[0]
        if not insert_require(path, other):
            return False, f"could not insert require for {other}\n{out}"
    return False, "max rounds exceeded"


def main():
    targets = sys.argv[1:]
    if not targets:
        print("usage: bbl182_autorequire.py <file1.v> [file2.v ...]")
        sys.exit(2)
    results = {}
    for fname in targets:
        ok, msg = fix_one(fname)
        results[fname] = (ok, msg)
        print(("OK  " if ok else "FAIL"), fname, ("" if ok else msg[:300].replace('\n', ' | ')))
    nfail = sum(1 for ok, _ in results.values() if not ok)
    print(f"---- {len(targets)-nfail}/{len(targets)} fixed")


if __name__ == '__main__':
    main()
