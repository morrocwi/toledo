"""Path resolution for toledo_mcp.

All paths are derived from one root, resolved in this order:
1. the ``TOLEDO_ROOT`` environment variable, if set;
2. the parent of the ``mcp/`` package's own directory (i.e. running in place
   inside a checkout of the toledo repository).

No path in this module or written by this package is a /home path, a
username, or a private-repo name in any string it logs or returns — the repo
root itself may resolve through the user's home directory at runtime, but
that resolved absolute path is never echoed into a tool response or a stored
proposal; only paths relative to the repo root are surfaced there.
"""
from __future__ import annotations

import os
import pathlib

PACKAGE_DIR = pathlib.Path(__file__).resolve().parent
MCP_DIR = PACKAGE_DIR.parent


def repo_root() -> pathlib.Path:
    env = os.environ.get("TOLEDO_ROOT")
    if env:
        return pathlib.Path(env).resolve()
    return MCP_DIR.parent


def registry_dir(root: pathlib.Path | None = None) -> pathlib.Path:
    return (root or repo_root()) / "registry"


def toledo_json_path(root: pathlib.Path | None = None) -> pathlib.Path:
    return registry_dir(root) / "TOLEDO.json"


def lineage_path(root: pathlib.Path | None = None) -> pathlib.Path:
    return registry_dir(root) / "LINEAGE.jsonl"


def canonical_json_path(root: pathlib.Path | None = None) -> pathlib.Path:
    """Read-only staleness reference only — never opened for writing by this
    package, and never parsed as the primary data source (see docs/DESIGN.md
    "Why TOLEDO.json, not CANONICAL.json")."""
    return registry_dir(root) / "CANONICAL.json"


def genesis_root_json_path(root: pathlib.Path | None = None) -> pathlib.Path:
    """Read-only staleness reference only, same rule as canonical_json_path."""
    return registry_dir(root) / "genesis_root.json"


def state_dir(root: pathlib.Path | None = None) -> pathlib.Path:
    """Where this package keeps its own generated/runtime data: the SQLite
    search index and the proposals store. Overridable with
    ``TOLEDO_MCP_STATE_DIR`` (tests use a temp directory here)."""
    env = os.environ.get("TOLEDO_MCP_STATE_DIR")
    if env:
        p = pathlib.Path(env).resolve()
    else:
        p = MCP_DIR / "state"
    p.mkdir(parents=True, exist_ok=True)
    return p


def index_db_path(root: pathlib.Path | None = None) -> pathlib.Path:
    return state_dir(root) / "index.sqlite3"


def proposals_db_path(root: pathlib.Path | None = None) -> pathlib.Path:
    return state_dir(root) / "proposals.sqlite3"


def proposals_dir(root: pathlib.Path | None = None) -> pathlib.Path:
    """Where a registration proposal is written (mcp/DESIGN.md sec. 6, graft
    C4). Deliberately `mcp/proposals/`, NOT `registry/proposals/` — the
    latter sits inside the exact top-level directory that carries the files
    this package must never edit (CANONICAL.json, genesis_root.json,
    LINEAGE.jsonl), and a reader of "never edit registry/*" cannot tell at a
    glance that a `proposals/` subdirectory was meant to be exempt.

    This is the single source both sides of the write/read boundary resolve
    through: `core.register_proposal` (S1, this package's core.py) writes
    here, and `proposals.py` (S2-owned: `proposals_dir()`,
    `status_ledger_path()`, `list_proposals`, `get_proposal`) reads from the
    same place by delegating to this function — see that module's own
    docstring for its side of the move. `tests/test_core.py::
    test_proposals_dir_points_at_mcp_proposals` pins this function's value;
    `tests/test_proposals.py` and `tests/test_server.py` (S2-owned) exercise
    the write-then-read round trip through it end to end."""
    return (root or repo_root()) / "mcp" / "proposals"


def relpath(p: pathlib.Path, root: pathlib.Path | None = None) -> str:
    """Render a path relative to the repo root for anything that leaves the
    process (tool responses, proposal records, log lines) — the absolute
    filesystem prefix (which contains the operator's home directory and
    username on this machine) must never appear in output."""
    root = root or repo_root()
    try:
        return str(p.resolve().relative_to(root.resolve()))
    except ValueError:
        return p.name
