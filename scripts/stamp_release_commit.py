#!/usr/bin/env python3
"""Stamp registry/CANONICAL.json's top-level `generated_from_commit` with the current
git HEAD sha (gate B3, 2026-09-07 fixer pass).

registry/SCHEMA.md defines this field as "the toledo git sha at build time". By
v1.2.0 it had drifted to an early N3-stage commit (9ca306c) -- 11 commits and three
releases (N4/N5, v1.0.0, v1.1.0, v1.2.0) behind HEAD -- because none of the lane
scripts that write registry/CANONICAL.json (n3_relabel.py, n4_merge.py, ...) re-stamp
it on a later run; each just carries forward (or hardcodes) whatever value it last saw.

Run this as the LAST step of a release, immediately before `git tag vX.Y.Z` and after
every other registry-owning lane/checker pass has already committed its own changes --
never mid-development, since re-running it after every small edit would itself turn
the field back into a number nobody can trust (the same "readout, not truth" complaint
this script exists to fix). It is a release-tag-time tool, not a build step: `make
build`/`make site`/`make catalogue` deliberately do NOT call it, since a dev build
should show the registry's committed-from commit, not the working tree's current HEAD.

registry/CANONICAL.json is otherwise off-limits to this fixer pass (owned by the v1.2
lane run, wf_3483b2de-ea9) -- this script is written, not invoked, by that pass; running
it is the release-tagger's own explicit next step, tracked in ops/HANDOFF_OVERNIGHT_2026-09-06.md.
"""
from __future__ import annotations

import pathlib
import re
import subprocess
import sys

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent
CANONICAL = REPO_ROOT / "registry" / "CANONICAL.json"
FIELD_RE = re.compile(r'("generated_from_commit"\s*:\s*")[0-9a-f]{7,40}(")')


def git_head_sha() -> str:
    return subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=REPO_ROOT, text=True
    ).strip()


def main() -> int:
    sha = git_head_sha()
    text = CANONICAL.read_text()
    m = FIELD_RE.search(text)
    if not m:
        print("stamp_release_commit: could not find generated_from_commit field", file=sys.stderr)
        return 1
    old = text[m.start() + len(m.group(1)) : m.end() - len(m.group(2))]
    if old == sha:
        print(f"generated_from_commit already at HEAD ({sha}) -- nothing to do")
        return 0
    new_text = text[: m.start()] + m.group(1) + sha + m.group(2) + text[m.end() :]
    CANONICAL.write_text(new_text)
    print(f"generated_from_commit: {old} -> {sha}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
