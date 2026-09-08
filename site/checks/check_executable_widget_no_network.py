#!/usr/bin/env python3
"""check_executable_widget_no_network — CI gate: the executable-equations
try-it widget (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.7/sec.9, stream S4)
never fetches anything over the network at run time, and never uses a
native floating-point transcendental outside the one named display-only
exception.

Scoped to a built `site/dist/` plus the two shared kernel files it copies
in from `site/static/js/` (S2's own deliverable — this script only reads
them, never edits them). Three checks, each a hard FAIL on any hit:

1. **No `fetch(`, `XMLHttpRequest`, or `WebSocket` token** anywhere in
   `static/js/_qfrac.js`, `static/js/_ir_eval.js`, or any rendered entry
   page's inline `<script>` block (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.9's
   own "Site widget test" item, verbatim) — the widget's own IR is embedded
   inline at build time (sec.7), never fetched again per entry.
2. **No native floating-point transcendental** (`Math.sin`, `Math.cos`,
   `Math.PI`, `Math.sqrt`, `Math.exp`, `Math.log`) in `_qfrac.js`/
   `_ir_eval.js` OUTSIDE `toDecimalString`'s own function body (sec.5/sec.9's
   grep guard) — a plain textual scan: everything between the line
   declaring `toDecimalString(` and its own matching brace-depth-0 close is
   exempt, every other line is not.
3. **Every entry page's `<script type="application/json" data-executable-ir>`
   block, if present, is well-formed JSON** — a widget whose embedded IR
   silently failed to serialise correctly is a build defect, not a
   network-safety concern, but catching it here (same scan) costs nothing
   extra and prevents a broken widget from shipping silently.

This is deliberately narrow — it does NOT re-check every no-JS/accessibility
rule already covered by `check_a11y.py`, and it does NOT assert any given
entry page HAS a widget (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.13 item 3: no
entry is required to carry one). An empty scan (no widget anywhere yet,
e.g. before `scripts/compute_executable.py` has ever marked an entry
`reviewed_eligible`/`built`) is reported as a clean pass with 0 pages
carrying a widget — never a failure and never silently skipped.

Usage:
    python3 site/checks/check_executable_widget_no_network.py site/dist
"""
from __future__ import annotations

import argparse
import json
import pathlib
import re
import sys

_NETWORK_TOKEN_RE = re.compile(r"\bfetch\s*\(|\bXMLHttpRequest\b|\bWebSocket\b")
_NATIVE_FLOAT_FN_RE = re.compile(r"\bMath\.(?:sin|cos|PI|sqrt|exp|log)\b")
_INLINE_SCRIPT_RE = re.compile(r"<script(?![^>]*\btype=\"application/json\")[^>]*>(.*?)</script>", re.IGNORECASE | re.DOTALL)
_IR_JSON_SCRIPT_RE = re.compile(
    r'<script type="application/json" data-executable-ir="true">(.*?)</script>', re.IGNORECASE | re.DOTALL,
)


def _strip_exempt_function_bodies(text: str, fn_name: str) -> str:
    """Removes every occurrence of `fn_name(...) { ... }`'s own body (brace-
    depth-tracked, so a nested `{`/`}` inside `toDecimalString` itself does
    not truncate the exemption early) from `text`, so the caller's own
    regex scan never sees inside it. A plain textual transform — good
    enough for this repo's own hand-written, un-minified kernel files; not
    a general JS parser."""
    out = []
    i = 0
    marker = re.compile(re.escape(fn_name) + r"\s*\([^)]*\)\s*\{")
    while True:
        m = marker.search(text, i)
        if not m:
            out.append(text[i:])
            break
        out.append(text[i:m.start()])
        depth = 1
        j = m.end()
        while j < len(text) and depth > 0:
            if text[j] == "{":
                depth += 1
            elif text[j] == "}":
                depth -= 1
            j += 1
        i = j
    return "".join(out)


def _scan_kernel_file(path: pathlib.Path) -> list[str]:
    findings = []
    text = path.read_text(encoding="utf-8")
    for m in _NETWORK_TOKEN_RE.finditer(text):
        line = text.count("\n", 0, m.start()) + 1
        findings.append(f"{path.name}:{line}: network token {m.group(0)!r} [FAIL]")
    outside_exempt = _strip_exempt_function_bodies(text, "toDecimalString")
    for m in _NATIVE_FLOAT_FN_RE.finditer(outside_exempt):
        # Approximate line number against the ORIGINAL text (good enough for
        # a human to locate — the exempt-body removal only ever shortens the
        # text, so a reported line is always at or before the real one).
        line = outside_exempt.count("\n", 0, m.start()) + 1
        findings.append(
            f"{path.name}:{line}: native floating-point transcendental {m.group(0)!r} "
            "outside toDecimalString [FAIL]"
        )
    return findings


def _scan_entry_page(path: pathlib.Path, dist: pathlib.Path) -> tuple[list[str], bool]:
    """Returns (findings, carries_widget)."""
    findings = []
    text = path.read_text(encoding="utf-8")
    rel = path.relative_to(dist)
    carries_widget = 'class="executable-widget"' in text

    for m in _INLINE_SCRIPT_RE.finditer(text):
        body = m.group(1)
        for token_m in _NETWORK_TOKEN_RE.finditer(body):
            line = text.count("\n", 0, m.start() + token_m.start()) + 1
            findings.append(f"{rel}:{line}: network token {token_m.group(0)!r} in inline <script> [FAIL]")

    for m in _IR_JSON_SCRIPT_RE.finditer(text):
        raw = m.group(1)
        try:
            json.loads(raw)
        except json.JSONDecodeError as exc:
            line = text.count("\n", 0, m.start()) + 1
            findings.append(f"{rel}:{line}: embedded executable IR is not valid JSON: {exc} [FAIL]")

    return findings, carries_widget


def run(dist: pathlib.Path) -> tuple[int, list[str]]:
    lines: list[str] = []
    if not dist.exists():
        return 2, [f"error: dist path does not exist: {dist}"]

    findings: list[str] = []

    kernel_files = [
        dist / "static" / "js" / "_qfrac.js",
        dist / "static" / "js" / "_ir_eval.js",
    ]
    kernel_files_found = [p for p in kernel_files if p.is_file()]
    for p in kernel_files_found:
        findings.extend(_scan_kernel_file(p))

    entries_dir = dist / "entries"
    pages_with_widget = 0
    pages_scanned = 0
    if entries_dir.is_dir():
        for p in sorted(entries_dir.glob("*.html")):
            pages_scanned += 1
            page_findings, carries_widget = _scan_entry_page(p, dist)
            findings.extend(page_findings)
            if carries_widget:
                pages_with_widget += 1

    lines.append(
        f"{len(kernel_files_found)}/2 kernel file(s) found; {pages_scanned} entry page(s) scanned; "
        f"{pages_with_widget} carrying the try-it widget"
    )
    if not kernel_files_found:
        lines.append(
            "note: static/js/_qfrac.js / _ir_eval.js not present in this build (S2 has not "
            "landed them, or copy_executable_static_into_dist found nothing to copy) — "
            "0 kernel files scanned is not itself a failure"
        )
    for f in findings:
        lines.append(f)

    if findings:
        lines.append(f"FAIL: {len(findings)} finding(s)")
        return 1, lines

    lines.append("OK: no network call, no native floating-point transcendental outside toDecimalString")
    return 0, lines


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("dist", type=pathlib.Path, help="path to the built site (e.g. site/dist)")
    args = parser.parse_args(argv)

    code, lines = run(args.dist)
    for line in lines:
        print(line)
    return code


if __name__ == "__main__":
    sys.exit(main())
