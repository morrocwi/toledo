#!/usr/bin/env python3
"""check_banned_words_and_leaks — CI gate for the site's own build output.

Scoped to `site/dist/` only. A sibling to `mcp/scripts/leak_scan.py` (which
stays scoped to `mcp/`) — written fresh for the site's own output tree per
`site/DESIGN.md` section 10, so neither script silently drifts by one
editing the other's file. Five categories:

1. A filesystem path rooted under the local `/home` hierarchy. Always a
   hard FAIL, any region.
2. This machine's own username, read from `$USER`/`$LOGNAME` at scan time
   — never hard-coded here (a hard-coded username would itself be the
   exact leak this category exists to catch). Always a hard FAIL, any
   region.
3. The private solver-arc repository's own literal name. Deliberately NOT
   hard-coded in this script (nobody authoring a Toledo checker is meant
   to know or go looking for that name, per BBL-198 as already honoured by
   `mcp/scripts/leak_scan.py`); supplied out-of-band via `--denylist-file`
   / `TOLEDO_LEAK_SCAN_DENYLIST_FILE`. The sanctioned phrase
   `"solver arc (private)"` is always allowed. Absent a denylist file this
   category is honestly reported as NOT RUN — never silently clean.
   Always a hard FAIL, any region, when it does run.
4. The banned priority/comparative marketing-word list (hard-coded here —
   these are ordinary English words, not secrets). **The verbatim-source
   exception** (site/DESIGN.md section 10): a hit inside an HTML element
   marked `data-verbatim-source="true"` (or nested inside one) is reported
   as a WARNING, never a hard FAIL, and the source text is never edited by
   this script. A hit anywhere else in an `*.html` file is a hard FAIL.
   This category only runs against `*.html` files — the templates are the
   only place the verbatim-source marking mechanism exists, so a JSON/JS
   data file that happens to mirror an entry's own quoted wording (with no
   way to mark it verbatim) is not scanned for this category, only for 1-3
   above.
5. A fixed list of AI vendor/model names, reusing `mcp/scripts/leak_scan.py`'s
   own `_AI_VENDOR_TOKENS_B64`/`_decode_tokens` machinery (decoded once at
   import time, same base64-without-plaintext-comment convention — see that
   module's docstring point 4 for why). Applies to every scanned file, any
   region, always a hard FAIL — a quoted vendor name has no more legitimate
   excuse than a quoted private-repo name or a quoted home path, so this
   category gets no verbatim-source exemption.

On any hit: prints `<file>:<line>: <category> [WARN|FAIL]`, never the
matched text or its containing line, matching `mcp/scripts/leak_scan.py`'s
own convention (a match could itself be more sensitive than expected).

Usage:
    python3 site/checks/check_banned_words_and_leaks.py site/dist
    python3 site/checks/check_banned_words_and_leaks.py site/dist --denylist-file /path/to/local/denylist.txt

Exit codes: 0 = clean (WARNs allowed); 1 = at least one hard FAIL;
2 = usage/configuration error (the given path does not exist).
"""
from __future__ import annotations

import argparse
import os
import pathlib
import re
import sys
from dataclasses import dataclass, field
from html.parser import HTMLParser

# Category 5 (AI vendor/model names) reuses `mcp/scripts/leak_scan.py`'s own
# `_AI_VENDOR_TOKENS_B64`/`_decode_tokens` machinery rather than maintaining a
# second, independently-drifting copy of the same base64-encoded token list.
# This is an import only — this module never edits `mcp/scripts/leak_scan.py`.
_MCP_SCRIPTS_DIR = str(pathlib.Path(__file__).resolve().parent.parent.parent / "mcp" / "scripts")
if _MCP_SCRIPTS_DIR not in sys.path:
    sys.path.insert(0, _MCP_SCRIPTS_DIR)
from leak_scan import _AI_VENDOR_TOKENS_B64, _decode_tokens  # noqa: E402

SANCTIONED_PRIVATE_REPO_PHRASE = "solver arc (private)"

# Built from two halves at runtime, same reason as mcp/scripts/leak_scan.py:
# this module is itself a potential scan target (e.g. if ever copied under
# site/dist/ by mistake), and a contiguous literal would false-positive on
# itself.
_HOME_PREFIX = "/" + "home/"
_HOME_PATH_RE = re.compile(re.escape(_HOME_PREFIX) + r"[^\s\"'>]+")

# Priority/comparative marketing words banned from generator-authored prose
# (founder instruction). Matched case-insensitively on word/phrase
# boundaries. "first"/"novel"/"unprecedented" are the founder's own named
# examples and are matched literally like the rest — a generator that needs
# an ordinal in technical prose (e.g. "the first ~140 characters") should
# reword rather than rely on an exemption this scanner does not grant.
BANNED_MARKETING_WORDS = [
    "novel", "first", "unprecedented", "world-class", "world class",
    "state-of-the-art", "state of the art", "cutting-edge", "cutting edge",
    "groundbreaking", "ground-breaking", "revolutionary", "best-in-class",
    "best in class", "industry-leading", "industry leading", "leading",
    "premier", "unparalleled", "unrivaled", "unrivalled", "breakthrough",
    "best", "superior", "game-changing", "game changing", "pioneering",
]
_MARKETING_RE = re.compile(
    r"\b(" + "|".join(re.escape(w) for w in BANNED_MARKETING_WORDS) + r")\b",
    re.IGNORECASE,
)

_SKIP_SUFFIXES = {
    ".png", ".jpg", ".jpeg", ".gif", ".ico", ".woff", ".woff2", ".ttf", ".pdf",
}


@dataclass
class Finding:
    path: str
    line: int
    category: str
    severity: str  # "FAIL" or "WARN"


@dataclass
class ScanResult:
    files_scanned: int = 0
    findings: list[Finding] = field(default_factory=list)
    private_repo_category_ran: bool = False

    @property
    def hard_fail_count(self) -> int:
        return sum(1 for f in self.findings if f.severity == "FAIL")

    @property
    def ok(self) -> bool:
        return self.hard_fail_count == 0


def _iter_files(root: pathlib.Path):
    for path in sorted(root.rglob("*")):
        if not path.is_file():
            continue
        if path.suffix.lower() in _SKIP_SUFFIXES:
            continue
        yield path


def _load_denylist(denylist_file: pathlib.Path | None) -> list[str]:
    if denylist_file is None:
        return []
    text = denylist_file.read_text(encoding="utf-8", errors="replace")
    return [line.strip() for line in text.splitlines() if line.strip()]


def _scan_plain_text_categories(
    text: str, rel: str, denylist: list[str], username: str | None,
    ai_vendor_tokens: list[str],
) -> list[Finding]:
    """Categories 1-3 and 5: home path, username, private-repo denylist,
    AI vendor/model name. Applies to every scanned file, any line, always a
    hard FAIL."""
    findings: list[Finding] = []
    for lineno, line in enumerate(text.splitlines(), start=1):
        if _HOME_PATH_RE.search(line):
            findings.append(Finding(rel, lineno, "home_path", "FAIL"))
        if username and re.search(re.escape(username), line):
            findings.append(Finding(rel, lineno, "username", "FAIL"))
        for pattern in denylist:
            if pattern and pattern != SANCTIONED_PRIVATE_REPO_PHRASE and pattern in line:
                findings.append(Finding(rel, lineno, "private_repo_name", "FAIL"))
        for token in ai_vendor_tokens:
            if token.lower() in line.lower():
                findings.append(Finding(rel, lineno, "ai_vendor_name", "FAIL"))
                break
    return findings


class VerbatimScopedTextExtractor(HTMLParser):
    """Walks an HTML document, yielding (line, text, in_verbatim) for every
    text node, where `in_verbatim` is true iff the text node is inside an
    element (or a descendant of one) carrying `data-verbatim-source="true"`.
    """

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.segments: list[tuple[int, str, bool]] = []
        self._stack: list[bool] = []  # True at the frame that opened verbatim scope
        self._verbatim_depth = 0
        self._skip_stack: list[str] = []  # tag names of <script>/<style> currently open

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        attr_map = {k.lower(): (v or "") for k, v in attrs}
        opens_verbatim = attr_map.get("data-verbatim-source", "").lower() == "true"
        self._stack.append(opens_verbatim)
        if opens_verbatim:
            self._verbatim_depth += 1
        if tag.lower() in ("script", "style"):
            self._skip_stack.append(tag.lower())

    def handle_startendtag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        # Self-closing tag: no matching end tag will pop the stack, so
        # don't push either.
        pass

    def handle_endtag(self, tag: str) -> None:
        if self._skip_stack and self._skip_stack[-1] == tag.lower():
            self._skip_stack.pop()
        if self._stack:
            opened = self._stack.pop()
            if opened:
                self._verbatim_depth = max(0, self._verbatim_depth - 1)

    def handle_data(self, data: str) -> None:
        if self._skip_stack:
            return  # script/style body text is not reader-facing prose
        if not data.strip():
            return
        line = self.getpos()[0]
        self.segments.append((line, data, self._verbatim_depth > 0))


def _scan_marketing_words_html(text: str, rel: str) -> list[Finding]:
    findings: list[Finding] = []
    extractor = VerbatimScopedTextExtractor()
    extractor.feed(text)
    extractor.close()
    for line, segment, in_verbatim in extractor.segments:
        if _MARKETING_RE.search(segment):
            severity = "WARN" if in_verbatim else "FAIL"
            findings.append(Finding(rel, line, "marketing_word", severity))
    return findings


def run(
    dist: pathlib.Path, denylist_file: pathlib.Path | None = None,
) -> tuple[int, list[str]]:
    if not dist.exists():
        return 2, [f"error: dist path does not exist: {dist}"]

    denylist = _load_denylist(denylist_file)
    username = os.environ.get("USER") or os.environ.get("LOGNAME")
    ai_vendor_tokens = _decode_tokens(_AI_VENDOR_TOKENS_B64)

    result = ScanResult(private_repo_category_ran=denylist_file is not None)

    for path in _iter_files(dist):
        rel = str(path.relative_to(dist))
        try:
            text = path.read_text(encoding="utf-8", errors="replace")
        except (UnicodeDecodeError, OSError):
            continue
        result.files_scanned += 1
        result.findings.extend(_scan_plain_text_categories(text, rel, denylist, username, ai_vendor_tokens))
        if path.suffix.lower() in (".html", ".htm"):
            result.findings.extend(_scan_marketing_words_html(text, rel))

    lines = [f"{result.files_scanned} file(s) scanned"]
    lines.append(f"ai_vendor_name category: ran ({len(ai_vendor_tokens)} token(s) checked, unconditional — no configuration needed)")
    if not result.private_repo_category_ran:
        lines.append(
            "private_repo_name category: NOT RUN this pass (no --denylist-file given)"
        )
    for f in result.findings:
        lines.append(f"{f.path}:{f.line}: {f.category} [{f.severity}]")

    if result.ok:
        lines.append(f"OK: 0 hard failure(s) ({sum(1 for f in result.findings if f.severity == 'WARN')} warning(s))")
        return 0, lines
    lines.append(f"FAIL: {result.hard_fail_count} hard failure(s)")
    return 1, lines


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("dist", type=pathlib.Path, help="path to the built site (e.g. site/dist)")
    parser.add_argument(
        "--denylist-file",
        type=pathlib.Path,
        default=os.environ.get("TOLEDO_LEAK_SCAN_DENYLIST_FILE"),
        help="optional file of extra literal patterns (private-repo name etc.), one per line",
    )
    args = parser.parse_args(argv)

    code, lines = run(args.dist, args.denylist_file)
    for line in lines:
        print(line)
    return code


if __name__ == "__main__":
    sys.exit(main())
