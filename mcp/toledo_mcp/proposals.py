"""Proposal lifecycle: the write path (graft C4) plus the query layer over it.

**Location, moved 2026-09-07** (`mcp/DESIGN.md` sec. 6, graft C4): proposal
files now live under `mcp/proposals/`, not `registry/proposals/` (the
baseline spike's location). Rationale, verbatim from the design synthesis:
`registry/proposals/` sits inside the exact top-level directory that carries
the five paths this package must never edit (`registry/CANONICAL.json`,
`registry/genesis_root.json`, `registry/LINEAGE.jsonl`, plus the sibling
`coq/`/`latex/` directories) — even though `proposals/` itself was never one
of those five, a reader of "never edit `registry/*`" cannot tell that at a
glance, and no one ever explicitly blessed a `proposals/` subdirectory living
inside it. At the time of this move, `ls registry/proposals/` showed no such
directory existed yet and no real proposal had ever been filed, so the move
costs nothing today; `mcp/.gitignore` (S4, `mcp/DESIGN.md` sec. 6) is
expected to add `proposals/` alongside `dist/` so this runtime-generated
directory is never committed.

Design choice kept from the baseline spike, not replaced: proposals are
individual, human-readable JSON files, not rows in a database — a human
registrar reviews and merges them by hand, and a plain file is
`git diff`-able / PR-able the way a database row is not. This module's own
addition (kept from the spike) is a queryable STATUS ledger next to them
(`mcp/proposals/STATUS.jsonl`, append-only, one line per lifecycle event —
the same convention `registry/LINEAGE.jsonl` already uses for the canonical
registry) so an agent that submitted a proposal, or a human triaging the
queue, can ask "what happened to this" without re-reading every file by
hand. This module never edits a proposal's own JSON file after it is
written — it only appends ledger rows and reads both.

Lifecycle values: ``PENDING`` (written automatically at submission),
``ACCEPTED`` (merged into `registry/CANONICAL.json` by a human registrar —
appended by that registrar, this package has no write path into
CANONICAL.json to do it automatically), ``REJECTED``, ``SUPERSEDED`` (a later
proposal replaces this one). Nothing here re-derives a status the ledger
doesn't state; a code with no ledger row beyond its initial PENDING one is
reported as still ``PENDING``, not silently assumed accepted.

**The write path** (`write_proposal`, below) is this stream's (S2's) own
reimplementation of the baseline spike's `core.register_proposal`, targeting
the new location. Docstring corrected 2026-09-07 (residual review finding
#6, stale-docstring pass): `core.register_proposal` has SINCE been updated
(by its own owning stream) to target `mcp/proposals/` too — it is no longer
writing to the old `registry/proposals/` location described in earlier
drafts of this docstring; `mcp/tests/test_mcp.py::
test_register_proposal_writes_a_proposal_file_not_the_registry` pins its
current, corrected location. `write_proposal` here remains a deliberate,
separate S2-owned copy of the same write logic (not a call-through to
`core.register_proposal`) — this module's `write_proposal` is the function
`server.py`'s `toledo_register_proposal` tool actually calls; see
`write_proposal`'s own docstring for the reasoning kept for the two call
sites this file still uses.
"""
from __future__ import annotations

import datetime
import json
import os
import pathlib
from typing import Any

from . import core, paths


def proposals_dir(root: pathlib.Path | None = None) -> pathlib.Path:
    """`mcp/proposals/` (moved from `registry/proposals/`, see module
    docstring). Delegates to `paths.proposals_dir()` the moment that function
    exists (`mcp/DESIGN.md` sec. 1/6 specify it as `paths.py`'s own addition,
    owned by another build stream) so every module ends up resolving this one
    location one way; until then this computes the same path directly from
    `paths.repo_root()` so behaviour already matches the spec.
    `test_proposals_dir_matches_paths_module_when_available` (test_proposals.py)
    is the pinning test that stops the two from silently drifting apart once
    that function lands."""
    if hasattr(paths, "proposals_dir"):
        return paths.proposals_dir(root)  # type: ignore[attr-defined]
    return paths.repo_root(root) / "mcp" / "proposals"


def status_ledger_path(root: pathlib.Path | None = None) -> pathlib.Path:
    return proposals_dir(root) / "STATUS.jsonl"


def _write_new_proposal_file(pdir: pathlib.Path, ts: str, slug: str, doc: dict) -> pathlib.Path:
    """Write `doc` as JSON to a file under `pdir` named from `ts`/`slug`,
    NEVER overwriting an existing file (SEC-2/R3-2 fix, 2026-09-07 — same
    bug and same fix as `core._write_new_proposal_file`, kept as this
    module's own copy per this file's own module docstring on why
    `write_proposal` is a deliberate second, S2-owned copy of `core.py`'s
    file-writing logic rather than an edit to that file): `ts` has
    one-second resolution and `slug` is agent-supplied, so two independent
    proposals for the same code submitted within the same wall-clock
    second — the expected-case race this founder-mandated write path
    exists for, since the rule is designed to make many independent agents
    each individually discover the same unregistered code and race to
    propose it — used to collide on the exact same filename; a plain
    `open(path, "w")` then silently truncated whichever proposal wrote
    second, destroying the first with no exception, no warning, and no
    trace in `STATUS.jsonl` (which records path/status/date, not content).

    Uses `os.O_CREAT | os.O_EXCL` so "does this name already exist" and
    "create it" are one atomic OS call, not a check-then-write race of this
    function's own; on `FileExistsError` it retries with a disambiguating
    numeric suffix (`{ts}_{slug}-1.json`, `-2.json`, ...) until an exclusive
    create succeeds, so two same-second, same-code proposals always land in
    two distinct files, both visible to the human registrar untouched."""
    attempt = 0
    while True:
        name = f"{ts}_{slug}.json" if attempt == 0 else f"{ts}_{slug}-{attempt}.json"
        candidate = pdir / name
        try:
            fd = os.open(str(candidate), os.O_CREAT | os.O_EXCL | os.O_WRONLY, 0o644)
        except FileExistsError:
            attempt += 1
            continue
        with os.fdopen(fd, "w", encoding="utf-8") as fh:
            json.dump(doc, fh, indent=2, ensure_ascii=False)
            fh.write("\n")
        return candidate


def write_proposal(fields: dict[str, Any], *, root: pathlib.Path | None = None) -> dict:
    """Write a `registry/SCHEMA.md`-shaped registration proposal under
    `mcp/proposals/` for a human registrar to review and merge by hand.
    Returns ``{"path", "slug", "submitted_at"}`` — ``path`` is relative to
    ``root`` (never an absolute filesystem path, which would carry this
    machine's home directory/username into a tool response or a stored
    file — see `paths.py`'s own leak-safety rule).

    This is the ONLY write this module performs, and (since 2026-09-07,
    `mcp/DESIGN.md` sec. 6) the only write `server.py`'s
    `toledo_register_proposal` tool performs either — it never touches
    `registry/CANONICAL.json`, `registry/genesis_root.json`, or
    `registry/LINEAGE.jsonl` directly. The formula this proposes is NOT
    registered until a human registrar merges it: `toledo_check`/
    `toledo_status` keep answering `NOT_REGISTERED`/`None` for it until then.

    Deliberately a second, S2-owned copy of `core.register_proposal`'s
    file-writing logic (reusing `core.slugify`, a pure read-only helper, so
    the slug rule itself is not re-derived a third way) rather than an edit
    to `core.py` — `core.py` belongs to another build stream
    (`mcp/DESIGN.md` sec. 16's file-ownership table keeps `register_proposal`
    there) and is not touched by this one. Status update, 2026-09-07
    (residual review finding #6): `core.register_proposal` now DOES target
    `mcp/proposals/` too (the other stream's own edit landed), so the two
    call sites' write locations no longer differ — the original TODO here
    ("once core.register_proposal itself targets mcp/proposals/, become a
    thin call-through") is still open as a follow-up de-duplication, not
    done automatically by that other edit; this function still carries its
    own copy of the JSON-writing logic today, kept as two call sites so this
    package's only actual write path (`server.py`'s `toledo_register_
    proposal`) does not depend on a cross-stream refactor landing first.
    """
    root = root or paths.repo_root()
    pdir = proposals_dir(root)
    pdir.mkdir(parents=True, exist_ok=True)
    ts = datetime.datetime.now(datetime.timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    slug = core.slugify(fields.get("code") or fields.get("name"))
    doc = {
        "proposal": fields,
        "note": (
            "This is a PROPOSAL, not a registered Toledo entry. A registrar reviews "
            "it against registry/SCHEMA.md and merges it into registry/CANONICAL.json "
            "by hand; this file itself is never read by the CLI, this MCP server, or "
            "any agent as if it were already registered. Do not use this formula "
            "until it is merged and a toledo_status lookup on its code returns it."
        ),
        "submitted_at": ts,
    }
    out_path = _write_new_proposal_file(pdir, ts, slug, doc)
    try:
        rel = str(out_path.relative_to(root))
    except ValueError:
        rel = str(out_path)
    return {"path": rel, "slug": slug, "submitted_at": ts}


def record_submitted(path_rel: str, slug: str, submitted_at: str, *, root: pathlib.Path | None = None) -> None:
    append_status(path_rel, "PENDING", by="toledo_mcp.proposals.write_proposal", note="submitted", root=root, date=submitted_at)


def append_status(path_rel: str, status: str, *, by: str, note: str = "", root: pathlib.Path | None = None, date: str | None = None) -> None:
    import datetime

    ledger = status_ledger_path(root)
    ledger.parent.mkdir(parents=True, exist_ok=True)
    row = {
        "path": path_rel,
        "status": status,
        "date": date or datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "by": by,
        "note": note,
    }
    with open(ledger, "a", encoding="utf-8") as fh:
        fh.write(json.dumps(row, ensure_ascii=False) + "\n")


def _read_ledger(root: pathlib.Path | None = None) -> list[dict]:
    p = status_ledger_path(root)
    if not p.exists():
        return []
    out = []
    with open(p, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if line:
                out.append(json.loads(line))
    return out


def latest_status(path_rel: str, root: pathlib.Path | None = None) -> dict | None:
    rows = [r for r in _read_ledger(root) if r.get("path") == path_rel]
    return rows[-1] if rows else None


def list_proposals(status: str | None = None, limit: int = 50, *, root: pathlib.Path | None = None) -> list[dict]:
    """`limit`: 0 or missing means "use the default of 50" (never
    "unlimited" — a bare `if limit and len(out) >= limit: break` used to
    never break for `limit=0`, silently returning every proposal; see
    `core.resolve_limit`), negative raises `ValueError`."""
    limit = core.resolve_limit(limit, 50)
    pdir = proposals_dir(root)
    if not pdir.exists():
        return []
    ledger = _read_ledger(root)
    latest_by_path: dict[str, dict] = {}
    for row in ledger:
        latest_by_path[row["path"]] = row

    repo_root = root or paths.repo_root()
    out = []
    for f in sorted(pdir.glob("*.json"), reverse=True):
        try:
            rel = str(f.relative_to(repo_root))
        except ValueError:
            rel = f.name
        st = latest_by_path.get(rel, {}).get("status", "PENDING")
        if status and st != status:
            continue
        try:
            doc = json.loads(f.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            continue
        fields = doc.get("proposal", {})
        out.append({
            "path": rel,
            "status": st,
            "submitted_at": doc.get("submitted_at"),
            "code": fields.get("code"),
            "name": fields.get("name"),
        })
        if len(out) >= limit:
            break
    return out


def get_proposal(path_rel: str, *, root: pathlib.Path | None = None) -> dict | None:
    """SEC-3 fix (2026-09-07): resolve `path_rel` against `root` and check
    containment inside `proposals_dir()` BEFORE any stat/open call
    (`.exists()`, `.suffix`, `.read_text()`). The previous order checked
    `f.exists()` (and `f.suffix`) FIRST and only ran the containment check
    afterward — so a `path_rel` naming a file outside `mcp/proposals/`
    (including an absolute path, which `pathlib`'s `/` operator silently
    lets override `root` entirely, e.g. `root / "/etc/shadow" ==
    Path("/etc/shadow")`) still triggered a real filesystem stat of that
    outside path before being refused, giving a caller a file-existence
    oracle over the rest of the filesystem through this one lookup — a
    different observable code path (and timing) for "outside path that
    exists" vs "outside path that doesn't", neither of which should be
    distinguishable from "inside path that doesn't exist" at all.

    Now containment is checked FIRST, against the resolved path, with no
    `.exists()`/`.suffix`/`.read_text()` call made until containment is
    confirmed — an outside path and a missing inside path are refused by
    the exact same branch, returning the exact same `None`, with zero
    filesystem stat/open calls ever made outside `mcp/proposals/`."""
    root = root or paths.repo_root()
    pdir = proposals_dir(root).resolve()
    candidate = (root / path_rel).resolve()
    try:
        candidate.relative_to(pdir)
    except ValueError:
        return None  # outside mcp/proposals/ — same generic answer as "missing", no stat/open performed
    if candidate.suffix != ".json" or not candidate.exists():
        return None
    doc = json.loads(candidate.read_text(encoding="utf-8"))
    doc["status"] = latest_status(path_rel, root) or {"status": "PENDING"}
    return doc
