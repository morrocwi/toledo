#!/usr/bin/env python3
"""toledo_mcp.export_static — static JSON mirror for GitHub Pages (S3,
mcp/DESIGN.md sec. 13, grafts A3/B3/C6).

Contract, restated from the design doc because it is the whole point of
this module: every file this writes is generated from the EXACT SAME
`cache.py`/`queries.py` query layer the live MCP server reads — never a
second, independently-derived transform of `registry/CANONICAL.json`. This
is corroboration/offline-read convenience for a caller with no MCP/stdio
access, NEVER a substitute for a live `toledo_check` call — every file this
writes says so in its own `disclosure`/`generated_at`/`generated_from_commit`
fields, and this module never claims the export is current relative to a
registry edit that happened after it ran (test_static_export_discloses_
generation_metadata pins this).

This module never writes to `registry/CANONICAL.json`, `registry/
genesis_root.json`, `registry/LINEAGE.jsonl`, `coq/`, or `latex/` — its only
output is the directory tree under `--out` (default `mcp/dist/static-api`,
gitignored — see `mcp/.gitignore`, owned by S4).

Output layout under `<out>/v1/` (mcp/DESIGN.md sec. 13):

    manifest.json             generation metadata + entry_count + disclosure
    entries/<mangled-code>.json   one file per canonical entry: the full
                                   entry + its verdict AS COMPUTED AT EXPORT
                                   TIME (disclosed as export-time, not live)
    by-root/<root>.json       array of compact entries under that root
    by-domain/<letter>.json   array of compact entries in that domain
    search-index.json         every compact entry, flattened, for a
                               client-side search implementation
    counts.json               same shape as the toledo_counts tool
    verdict-rules.json        same shape as toledo_show_verdict_rules would
                               return, IF verdict.py (S2) has landed the
                               RULES/_KNOWN_STATUSES/VERDICT_VALUES data
                               this depends on; otherwise an honest
                               `{"available": false, "reason": ...}` — this
                               module never fabricates a rule table that is
                               not the code's own real decision path (same
                               discipline as `cli.py`'s `show-verdict-rules`).

Filesystem-safe code mangling reuses `registry/SCHEMA.md`'s own rule
verbatim (never a third, independently invented scheme):
`code.replace('/', '__').replace('.', '_').replace('-', '_')`.
"""
from __future__ import annotations

import datetime
import json
import pathlib
import re
import subprocess

try:
    from . import __version__ as _package_version
    from . import cache as cache_mod
    from . import paths, verdict
except ImportError:
    import sys

    sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))
    from toledo_mcp import __version__ as _package_version
    from toledo_mcp import cache as cache_mod
    from toledo_mcp import paths, verdict

DISCLOSURE = (
    "eventually consistent; call the live MCP server for a current answer, "
    "never treat this as authoritative for a release-sensitive task"
)

_CITATION_VERSION_RE = re.compile(r'^version:\s*"?([^"\n]+)"?\s*$', re.MULTILINE)


def mangle_code(code: str) -> str:
    """`registry/SCHEMA.md`'s own Coq-file-name mangling rule, reused
    verbatim for filesystem-safe static filenames (never a third scheme)."""
    return code.replace("/", "__").replace(".", "_").replace("-", "_")


def _git_commit(root: pathlib.Path) -> str | None:
    """Best-effort, read-only `git rev-parse HEAD` in `root`. Never raises —
    a shallow checkout, a detached worktree, or git being unavailable are
    all real conditions this export must survive, disclosed as `None`
    rather than crashing the whole export over a metadata field."""
    try:
        proc = subprocess.run(
            ["git", "rev-parse", "HEAD"], cwd=str(root), capture_output=True,
            text=True, timeout=5, check=False,
        )
    except (OSError, subprocess.SubprocessError):
        return None
    if proc.returncode != 0:
        return None
    commit = proc.stdout.strip()
    return commit or None


def _registry_release_version(root: pathlib.Path) -> str | None:
    """Read-only parse of the root `CITATION.cff`'s `version:` field — the
    same field `mcp/DESIGN.md` sec. 11 says `sync_version.py` (S4, not yet
    landed) will copy into `toledo_mcp.__version__`/`pyproject.toml`. This
    module only READS it for disclosure; it never writes `CITATION.cff`."""
    p = root / "CITATION.cff"
    if not p.exists():
        return None
    m = _CITATION_VERSION_RE.search(p.read_text(encoding="utf-8"))
    return m.group(1) if m else None


def _verdict_rules_payload() -> dict:
    """Same availability check as `cli.py`'s `cmd_show_verdict_rules` —
    duplicated intentionally rather than imported, since it is three
    `getattr` calls, not logic worth a cross-module dependency for."""
    rules = getattr(verdict, "RULES", None)
    known = getattr(verdict, "_KNOWN_STATUSES", None)
    values = getattr(verdict, "VERDICT_VALUES", None)
    if rules is None or known is None or values is None:
        return {
            "available": False,
            "reason": (
                "verdict.py does not yet expose RULES/_KNOWN_STATUSES/"
                "VERDICT_VALUES on this build (mcp/DESIGN.md sec. 8, graft "
                "A6) — pending that module's own owner; nothing here "
                "fabricates a rule table that is not the code's real "
                "decision path."
            ),
        }
    return {"available": True, "statuses": sorted(known), "verdict_values": list(values), "rules": rules}


def _write_json(path: pathlib.Path, doc: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(doc, fh, indent=2, ensure_ascii=False, sort_keys=False)
        fh.write("\n")


def export_static(out_dir: pathlib.Path, root: pathlib.Path | None = None) -> dict:
    """Write the full static mirror under `out_dir` (a caller-supplied
    directory — production usage is `<repo>/mcp/dist/static-api`, but tests
    point this at a throwaway temp dir so no test run pollutes the real
    gitignored build output). Returns a summary dict (`files_written`,
    `manifest`) for the caller/test to inspect without re-reading the
    filesystem."""
    root = root or paths.repo_root()
    out_dir = pathlib.Path(out_dir)
    v1 = out_dir / "v1"

    c = cache_mod.RegistryCache(root=root)
    c.ensure_fresh()
    reg = c.registry
    entries = list(reg.entries)

    def resolver(code: str):
        return reg.by_code.get(code)

    generated_at = datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    generated_from_commit = _git_commit(root)
    registry_release_version = _registry_release_version(root)

    manifest = {
        "generated_at": generated_at,
        "generated_from_commit": generated_from_commit,
        "registry_release_version": registry_release_version,
        "package_version": _package_version,
        "entry_count": len(entries),
        "disclosure": DISCLOSURE,
    }

    files_written: list[str] = []

    def emit(rel: str, doc: object) -> None:
        _write_json(v1 / rel, doc)
        files_written.append(rel)

    emit("manifest.json", manifest)

    # A landing page at the export root, so the Pages URL itself answers instead
    # of returning 404: it names the API version prefix and the entry files.
    index_html = (
        "<!doctype html><meta charset=\"utf-8\"><title>Toledo static API</title>"
        "<h1>Toledo — equation library, static read API</h1>"
        f"<p>Registry release {registry_release_version}, package {_package_version}, "
        f"{len(entries)} entries, generated {generated_at} from commit {generated_from_commit}.</p>"
        "<ul><li><a href=\"v1/manifest.json\">v1/manifest.json</a></li>"
        "<li><a href=\"v1/counts.json\">v1/counts.json</a></li>"
        "<li><a href=\"v1/verdict-rules.json\">v1/verdict-rules.json</a></li>"
        "<li><a href=\"v1/search-index.json\">v1/search-index.json</a></li>"
        "<li>v1/entries/&lt;code&gt;.json, v1/by-root/, v1/by-domain/</li></ul>"
        "<p>Source and documentation: <a href=\"https://github.com/morrocwi/toledo\">github.com/morrocwi/toledo</a> "
        "(mcp/docs/STATIC_API.md). Every value here is a readout of the registry files at the commit named above, not a truth claim.</p>"
    )
    out_dir.mkdir(parents=True, exist_ok=True)
    (out_dir / "index.html").write_text(index_html, encoding="utf-8")
    # index.html is not counted in files_written (that list is the v1/ JSON set).

    # entries/<mangled-code>.json — full entry + export-time verdict.
    for e in entries:
        code = e.get("code")
        if not code:
            continue
        v = verdict.verdict_for_entry(e, resolver).to_dict()
        emit(f"entries/{mangle_code(code)}.json", {
            "entry": e,
            "verdict": v,
            "generated_at": generated_at,
            "generated_from_commit": generated_from_commit,
            "disclosure": DISCLOSURE,
        })

    # by-root/<root>.json
    roots = sorted({e.get("root") for e in entries if e.get("root")})
    for r in roots:
        emit(f"by-root/{mangle_code(r)}.json", c.by_root(r, limit=None))

    # by-domain/<letter>.json
    domains = sorted({e.get("domain") for e in entries if e.get("domain")})
    for d in domains:
        emit(f"by-domain/{d}.json", c.by_domain(d, limit=None))

    # search-index.json — every compact entry, unfiltered, natural order.
    # `limit=0` used to mean "unlimited" here (an artifact of the old,
    # per-call-site limit=0 handling this package no longer has — see
    # `core.resolve_limit`'s docstring: 0/missing now means "this call's own
    # default", never "unlimited"), which would silently truncate this
    # export to `search`'s 20-row default the moment that inconsistency was
    # fixed. Pass an explicit limit covering every entry instead.
    emit("search-index.json", c.search("", limit=len(entries) or 1))

    # counts.json — same shape as the toledo_counts tool.
    emit("counts.json", c.counts())

    # verdict-rules.json — the one file that "genuinely cannot go stale
    # relative to a registry edit" (mcp/DESIGN.md sec. 13), once available.
    emit("verdict-rules.json", _verdict_rules_payload())

    c.close()
    return {"out_dir": str(v1), "files_written": files_written, "manifest": manifest}


def main(argv: list[str] | None = None) -> int:
    import argparse

    ap = argparse.ArgumentParser(
        prog="toledo-export-static",
        description="Write the Toledo static API mirror (mcp/DESIGN.md sec. 13) to --out.",
    )
    ap.add_argument("--out", type=pathlib.Path, required=True, help="output directory (files land under <out>/v1/)")
    ap.add_argument("--root", type=pathlib.Path, default=None, help="Toledo repo root (default: TOLEDO_ROOT env / checkout root)")
    args = ap.parse_args(argv)
    summary = export_static(args.out, root=args.root)
    print(json.dumps({"out_dir": summary["out_dir"], "file_count": len(summary["files_written"])}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
