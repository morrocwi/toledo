#!/usr/bin/env python3
"""leak_scan — CI gate: fail the build if a tracked file under the given
path(s) leaks a local filesystem path, this machine's username, the private
solver-arc repository's own name, or an AI vendor/model name.

Per `mcp/DESIGN.md` section 12 and this repository's own standing rule (no
local home-directory path, username, private-repo name, or AI vendor/model
name in any file this package writes or returns): this script is the
mechanical, CI-runnable version of the leak-scan pass every public-facing
publish in this workspace already requires by hand. It checks four
categories:

1. A filesystem path rooted under the local `/home` hierarchy (this
   docstring deliberately never spells the full two-slash prefix followed by
   more path text — see `_home_path_re()` below for why: this file is itself
   scanned by this category, and a literal example would trip it).
2. This machine's own username — read from `$USER`/`$LOGNAME` at scan time,
   never hard-coded into this script (a hard-coded username would itself be
   exactly the leak this category exists to catch).
3. The private solver-arc repository's own literal name. This script does
   NOT hard-code that name — nobody authoring this package is meant to know
   or go looking for it (BBL-198: the name is withheld from every Toledo
   file, this one included). Instead this category reads an optional,
   never-committed local file of extra patterns (see `--denylist-file` /
   `TOLEDO_LEAK_SCAN_DENYLIST_FILE`) that a human or a CI secret can supply
   out-of-band. The sanctioned phrase `"solver arc (private)"` is always
   allowed regardless of what the denylist contains.
   If no such file is configured, this category is honestly reported as
   NOT RUN this pass — never silently treated as a clean scan.
4. A fixed list of AI vendor/model names. Kept base64-encoded in this file's
   source (decoded once at import time, `_decode_tokens` below) rather than
   as bare literals — deliberately with NO plaintext annotation next to each
   token either, since a `# <vendor name>` comment would defeat the whole
   point just as surely as writing the name directly — so this scanner's own
   source does not itself become a plaintext list of the exact strings the
   whole repository is trying to avoid. This is the same instinct as never
   printing a *matched* secret (below), applied to the denylist definition
   itself. Extend `_AI_VENDOR_TOKENS_B64` (decode a candidate string with
   `base64.b64encode(name.encode()).decode()` to add one, and confirm with
   `_decode_tokens` rather than leaving a plaintext trail in a commit
   message); supplement with `--denylist-file` for anything this baseline
   list does not cover.

On any hit: prints `<file>:<line>: <category> match`, never the matched text
or the containing line — a match could itself be more sensitive than
expected (a pasted credential, a private path fragment), so nothing beyond
"something in this category matched here" is echoed.

Usage:
    python3 mcp/scripts/leak_scan.py mcp/
    python3 mcp/scripts/leak_scan.py mcp/ registry/ --denylist-file /path/to/local/denylist.txt

Exit codes: 0 = clean; 1 = at least one leak found; 2 = usage/configuration
error (e.g. a given path does not exist).
"""
from __future__ import annotations

import argparse
import base64
import os
import re
import subprocess
import sys
from dataclasses import dataclass, field

# ---------------------------------------------------------------------------
# AI vendor/model name denylist — base64-encoded, see module docstring §4.
# Decoded once below into a plain list of strings for matching; never
# re-encoded or written anywhere.
# ---------------------------------------------------------------------------
# 17 tokens, deliberately unannotated (see module docstring point 4 above) —
# a running index is the only label offered so a hit can still be reported
# by position without decoding it into the log.
_AI_VENDOR_TOKENS_B64 = [
    "Q2xhdWRl",
    "QW50aHJvcGlj",
    "T3BlbkFJ",
    "Q2hhdEdQVA==",
    "R1BULTQ=",
    "R1BULTU=",
    "R2VtaW5p",
    "Q29QaWxvdA==",
    "U29ubmV0",
    "T3B1cw==",
    "SGFpa3U=",
    "TGxhTWE=",
    "TWlzdHJhbA==",
    "RGVlcFNlZWs=",
    "UXdlbg==",
    "Y2xhdWRlLmFp",
    "YW50aHJvcGljLmNvbQ==",
]


def _decode_tokens(tokens_b64: list[str]) -> list[str]:
    return [base64.b64decode(t).decode("ascii") for t in tokens_b64]


SANCTIONED_PRIVATE_REPO_PHRASE = "solver arc (private)"

# Built from two halves at runtime rather than written as one literal
# the home-directory prefix followed by more text — this module is itself a scan target, and a
# contiguous example of the exact pattern it looks for would be a false
# positive against itself every single run.
_HOME_PREFIX = "/" + "home/"
_HOME_PATH_RE = re.compile(re.escape(_HOME_PREFIX) + r"[^\s\"'>]+")

# Extensions/dirs never worth scanning as text — binary or generated.
_SKIP_SUFFIXES = {
    ".pyc", ".sqlite3", ".sqlite3-wal", ".sqlite3-shm", ".png", ".jpg", ".jpeg",
    ".gif", ".pdf", ".zip", ".ico", ".woff", ".woff2", ".ttf",
}
_SKIP_DIR_PARTS = {"__pycache__", ".pytest_cache", ".git"}


@dataclass
class Finding:
    path: str
    line: int
    category: str


@dataclass
class ScanResult:
    files_scanned: int = 0
    findings: list[Finding] = field(default_factory=list)
    private_repo_category_ran: bool = False

    @property
    def ok(self) -> bool:
        return not self.findings


def _tracked_files(root: str, repo_root: str) -> list[str]:
    """Every git-tracked file under `root`, relative to `repo_root`. Falls
    back to a plain directory walk (still skipping the noisy generated dirs
    above) if this is not a git checkout — a leak scan should still run
    somewhere it can, rather than silently doing nothing."""
    try:
        out = subprocess.run(
            ["git", "ls-files", "--", root],
            cwd=repo_root, capture_output=True, text=True, check=True,
        )
        files = [line for line in out.stdout.splitlines() if line.strip()]
        if files:
            return files
    except (OSError, subprocess.CalledProcessError):
        pass

    collected: list[str] = []
    abs_root = os.path.join(repo_root, root)
    for dirpath, dirnames, filenames in os.walk(abs_root):
        dirnames[:] = [d for d in dirnames if d not in _SKIP_DIR_PARTS]
        for name in filenames:
            full = os.path.join(dirpath, name)
            collected.append(os.path.relpath(full, repo_root))
    return collected


def _read_text_lines(abs_path: str) -> list[str] | None:
    """Returns the file's lines, or None if it looks binary / unreadable —
    a leak scan has nothing useful to say about a binary file's bytes."""
    if os.path.splitext(abs_path)[1].lower() in _SKIP_SUFFIXES:
        return None
    try:
        with open(abs_path, "rb") as fh:
            head = fh.read(8192)
        if b"\x00" in head:
            return None
        with open(abs_path, "r", encoding="utf-8") as fh:
            return fh.readlines()
    except (UnicodeDecodeError, OSError):
        return None


def _load_denylist_file(path: str | None) -> list[str]:
    if not path:
        return []
    if not os.path.isfile(path):
        raise FileNotFoundError(f"--denylist-file {path!r} does not exist")
    patterns: list[str] = []
    with open(path, "r", encoding="utf-8") as fh:
        for raw in fh:
            line = raw.strip()
            if not line or line.startswith("#"):
                continue
            if line == SANCTIONED_PRIVATE_REPO_PHRASE:
                continue  # never deny the sanctioned phrase itself
            patterns.append(line)
    return patterns


def scan(paths: list[str], repo_root: str, denylist_file: str | None = None) -> ScanResult:
    result = ScanResult()

    username = os.environ.get("USER") or os.environ.get("LOGNAME") or ""
    username = username.strip()
    username_re = re.compile(re.escape(username)) if len(username) >= 3 else None

    ai_vendor_tokens = _decode_tokens(_AI_VENDOR_TOKENS_B64)

    private_repo_patterns = _load_denylist_file(denylist_file)
    result.private_repo_category_ran = bool(private_repo_patterns)

    seen: set[str] = set()
    for root in paths:
        for rel in _tracked_files(root, repo_root):
            if rel in seen:
                continue
            seen.add(rel)
            abs_path = os.path.join(repo_root, rel)
            lines = _read_text_lines(abs_path)
            if lines is None:
                continue
            result.files_scanned += 1
            for lineno, line in enumerate(lines, start=1):
                if _HOME_PATH_RE.search(line):
                    result.findings.append(Finding(rel, lineno, "home_path"))
                if username_re is not None and username_re.search(line):
                    result.findings.append(Finding(rel, lineno, "username"))
                for token in ai_vendor_tokens:
                    if token.lower() in line.lower():
                        result.findings.append(Finding(rel, lineno, "ai_vendor_name"))
                        break
                for pattern in private_repo_patterns:
                    if pattern in line:
                        result.findings.append(Finding(rel, lineno, "private_repo_name"))
                        break

    return result


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("paths", nargs="+", help="repo-relative path(s) to scan (e.g. mcp/)")
    parser.add_argument(
        "--denylist-file",
        default=os.environ.get("TOLEDO_LEAK_SCAN_DENYLIST_FILE"),
        help="optional local, never-committed file of extra literal patterns "
             "(one per line; '#'-prefixed lines are comments) — this is where "
             "the private solver-arc repository's own name is supplied, out "
             "of band, if a scan run needs that category checked",
    )
    parser.add_argument("--repo-root", default=None, help="defaults to this script's own repository root")
    args = parser.parse_args(argv)

    repo_root = args.repo_root or os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))

    for p in args.paths:
        if not os.path.exists(os.path.join(repo_root, p)):
            print(f"error: path {p!r} does not exist under {repo_root!r}", file=sys.stderr)
            return 2

    try:
        result = scan(args.paths, repo_root, denylist_file=args.denylist_file)
    except FileNotFoundError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2

    for finding in result.findings:
        print(f"{finding.path}:{finding.line}: {finding.category} match")

    print(f"leak_scan: {result.files_scanned} file(s) scanned, {len(result.findings)} finding(s)")
    if not result.private_repo_category_ran:
        print(
            "leak_scan: WARNING — private_repo_name category did not run this pass "
            "(no --denylist-file / TOLEDO_LEAK_SCAN_DENYLIST_FILE configured); "
            "this is disclosed, not a clean result for that category.",
            file=sys.stderr,
        )

    return 0 if result.ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
