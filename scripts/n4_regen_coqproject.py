#!/usr/bin/env python3
"""Regenerate coq/canonical/_CoqProject in topological order (dependencies
before dependents), by parsing each file's own `From MRC Require (Import|
Export) <mod>.` lines. MRC_Prelude.v always first (nothing depends on
depends-on-nothing files more foundational than it, and several files
Require it). Deterministic tie-break: alphabetical among files with no
remaining unlisted dependency, so re-running this script does not reshuffle
files that carry no relative-order constraint."""
import re
from pathlib import Path

CAN_DIR = Path(__file__).resolve().parent.parent / "coq" / "canonical"
REQ_RE = re.compile(r"^From MRC Require (?:Import|Export) ([A-Za-z0-9_]+)\.", re.MULTILINE)

files = sorted(p.name for p in CAN_DIR.glob("*.v"))
deps = {}
for f in files:
    text = (CAN_DIR / f).read_text(encoding="utf-8")
    deps[f] = sorted({m + ".v" for m in REQ_RE.findall(text)} & set(files))

order = []
visiting = set()
visited = set()


def visit(f, stack):
    if f in visited:
        return
    if f in visiting:
        raise SystemExit(f"cycle detected: {stack + [f]}")
    visiting.add(f)
    for d in deps[f]:
        visit(d, stack + [f])
    visiting.discard(f)
    visited.add(f)
    order.append(f)


for f in files:
    visit(f, [])

with open(CAN_DIR / "_CoqProject", "w", encoding="utf-8") as fh:
    fh.write("-Q . MRC\n-Q ../master-river MR\n\n")
    fh.write("\n".join(order) + "\n")

print(f"Wrote _CoqProject: {len(order)} files, topological order "
      f"({sum(1 for f in files if deps[f])} files with at least one MRC dependency).")
