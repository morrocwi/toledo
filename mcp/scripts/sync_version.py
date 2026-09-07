#!/usr/bin/env python3
"""sync_version — copy the registry's own release version into this package.

Per `mcp/DESIGN.md` section 11 ("Versioning — package version = registry
release"): `toledo_mcp`'s package version tracks the registry's own release
version, not an independently incremented API number. This script is the
single place that copy happens.

It **reads** (never writes) the repository root's `CITATION.cff` `version:`
field, and writes that value verbatim into:

  - `mcp/pyproject.toml`'s `[project] version` field, and
  - `mcp/toledo_mcp/__init__.py`'s `__version__` assignment.

Nothing else in either file is touched. This is a release-time step (run by
CI or a human cutting a release — see `mcp/DESIGN.md` section 12's CI plan),
not something every commit re-runs: a mid-cycle code change to this package
does not need a version bump of its own, and the version answers "which
registry release was this built against" rather than this package's own
change history.

Two independent numbers stay untouched by this script, deliberately (see
`mcp/DESIGN.md` sec. 11): `toledo_mcp.index.INDEX_SCHEMA_VERSION` (the
SQLite index's own column/table layout) and
`toledo_mcp.index.SUPPORTED_CANONICAL_SCHEMA_VERSIONS` (the set of
`registry/CANONICAL.json` `schema_version` values this build understands).

Usage:
    python3 mcp/scripts/sync_version.py            # write the sync
    python3 mcp/scripts/sync_version.py --check    # exit 1 if out of sync, write nothing

Never edits `CITATION.cff` itself — that file belongs to the registry-owning
release process, not to this package.
"""
from __future__ import annotations

import argparse
import pathlib
import re
import sys

SCRIPTS_DIR = pathlib.Path(__file__).resolve().parent
MCP_DIR = SCRIPTS_DIR.parent
REPO_ROOT = MCP_DIR.parent

CITATION_PATH = REPO_ROOT / "CITATION.cff"
PYPROJECT_PATH = MCP_DIR / "pyproject.toml"
INIT_PATH = MCP_DIR / "toledo_mcp" / "__init__.py"

# CITATION.cff is YAML, but this script only ever needs one scalar field out
# of it and never writes to it — a single anchored regex avoids adding a YAML
# parser dependency (this package is stdlib-only, see requirements-mcp.txt)
# for a one-field read.
_CITATION_VERSION_RE = re.compile(r'^version:\s*"([^"]+)"\s*$', re.MULTILINE)
_PYPROJECT_VERSION_RE = re.compile(r'^version = "([^"]+)"(\s*#.*)?$', re.MULTILINE)
# `__init__.py`'s own version line may be indented (e.g. the fallback branch
# of a `try: __version__ = importlib.metadata.version(...) / except: ...`
# block) — the leading whitespace is captured and preserved on write so a
# sync never de-indents a line out of its block.
_INIT_VERSION_RE = re.compile(r'^([ \t]*)__version__ = "([^"]+)"$', re.MULTILINE)


def read_citation_version(citation_path: pathlib.Path = CITATION_PATH) -> str:
    text = citation_path.read_text(encoding="utf-8")
    m = _CITATION_VERSION_RE.search(text)
    if not m:
        raise ValueError(f'no `version: "..."` line found in {citation_path}')
    return m.group(1)


def read_pyproject_version(pyproject_path: pathlib.Path = PYPROJECT_PATH) -> str:
    text = pyproject_path.read_text(encoding="utf-8")
    m = _PYPROJECT_VERSION_RE.search(text)
    if not m:
        raise ValueError(f'no `version = "..."` [project] line found in {pyproject_path}')
    return m.group(1)


def read_init_version(init_path: pathlib.Path = INIT_PATH) -> str:
    text = init_path.read_text(encoding="utf-8")
    m = _INIT_VERSION_RE.search(text)
    if not m:
        raise ValueError(f'no `__version__ = "..."` line found in {init_path}')
    return m.group(2)


def write_pyproject_version(new_version: str, pyproject_path: pathlib.Path = PYPROJECT_PATH) -> bool:
    """Returns True iff the file's content actually changed."""
    text = pyproject_path.read_text(encoding="utf-8")
    new_text, n = _PYPROJECT_VERSION_RE.subn(
        lambda m: f'version = "{new_version}"' + (m.group(2) or ""), text, count=1
    )
    if n != 1:
        raise ValueError(f'expected exactly one `version = "..."` line in {pyproject_path}, found {n}')
    if new_text == text:
        return False
    pyproject_path.write_text(new_text, encoding="utf-8")
    return True


def write_init_version(new_version: str, init_path: pathlib.Path = INIT_PATH) -> bool:
    """Returns True iff the file's content actually changed. Preserves
    whatever leading indentation the matched line already had (see
    `_INIT_VERSION_RE`'s docstring above) — this line may sit inside a
    `try`/`except` block, not always at column 0."""
    text = init_path.read_text(encoding="utf-8")
    new_text, n = _INIT_VERSION_RE.subn(
        lambda m: f'{m.group(1)}__version__ = "{new_version}"', text, count=1
    )
    if n != 1:
        raise ValueError(f'expected exactly one `__version__ = "..."` line in {init_path}, found {n}')
    if new_text == text:
        return False
    init_path.write_text(new_text, encoding="utf-8")
    return True


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--check", action="store_true",
                         help="exit 1 if pyproject.toml/__init__.py are out of sync with CITATION.cff; write nothing")
    parser.add_argument("--citation", type=pathlib.Path, default=CITATION_PATH)
    parser.add_argument("--pyproject", type=pathlib.Path, default=PYPROJECT_PATH)
    parser.add_argument("--init", type=pathlib.Path, default=INIT_PATH)
    args = parser.parse_args(argv)

    registry_version = read_citation_version(args.citation)

    if args.check:
        pyproject_version = read_pyproject_version(args.pyproject)
        init_version = read_init_version(args.init)
        drift = []
        if pyproject_version != registry_version:
            drift.append(f"{args.pyproject}: has {pyproject_version!r}, CITATION.cff has {registry_version!r}")
        if init_version != registry_version:
            drift.append(f"{args.init}: has {init_version!r}, CITATION.cff has {registry_version!r}")
        if drift:
            for line in drift:
                print(f"OUT OF SYNC: {line}", file=sys.stderr)
            return 1
        print(f"in sync: {registry_version}")
        return 0

    changed_pyproject = write_pyproject_version(registry_version, args.pyproject)
    changed_init = write_init_version(registry_version, args.init)
    print(
        f"registry_release_version={registry_version} "
        f"pyproject.toml={'updated' if changed_pyproject else 'already in sync'} "
        f"__init__.py={'updated' if changed_init else 'already in sync'}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
