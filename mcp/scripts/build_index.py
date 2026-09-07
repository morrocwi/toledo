#!/usr/bin/env python3
"""build_index.py — MCP cold-start prebuilt-index step (DEBT #48, lane E,
2026-09-07).

This is the "build time" half of the fix: it builds `mcp/state/index.sqlite3`
from the current `registry/CANONICAL.json` + `registry/genesis_root.json` +
`registry/LINEAGE.jsonl` (exactly `toledo_mcp.core.load_registry` +
`toledo_mcp.index.build_index` — the same engine `server.py`/`cache.py` use
at runtime, never a second reimplementation) so a release zip can ship an
already-built index instead of making every cold start pay a rebuild.

Wired into `make build` (repository `Makefile`, `build:` target) so the
index is regenerated every time the registry-facing generator runs — never a
manual step someone forgets before cutting a release.

This script never touches `registry/CANONICAL.json`, `registry/genesis_root.json`
or `registry/LINEAGE.jsonl` — read-only against all three, same rule every
other file in `mcp/toledo_mcp/` already follows.

The "runtime half" of the fix lives in `toledo_mcp/index.py`
(`check_freshness` now accepts a shipped index whose sha256 content hash
matches even when its mtime does not — the mtime is expected to change on
every git checkout / zip unpack / copy, the bytes are not) and
`toledo_mcp/cache.py` (`RegistryCache.ensure_fresh` only calls
`index.build_index` when `index.needs_rebuild` actually says so, instead of
unconditionally on every process's first load).

Usage:
    python3 mcp/scripts/build_index.py               # build against the real repo root
    python3 mcp/scripts/build_index.py --root <path> # build against a different checkout
"""
from __future__ import annotations

import argparse
import json
import pathlib
import sys

MCP_DIR = pathlib.Path(__file__).resolve().parent.parent
sys.path.insert(0, str(MCP_DIR))

from toledo_mcp import core, index, paths  # noqa: E402


def build(root: pathlib.Path | None = None) -> dict:
    root = root or paths.repo_root()
    registry = core.load_registry(root)
    report = index.build_index(registry, root)
    return report


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--root", type=pathlib.Path, default=None,
                     help="repository root (default: the checkout mcp/ lives in, or $TOLEDO_ROOT)")
    args = ap.parse_args(argv)
    report = build(args.root)
    print(json.dumps(report, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
