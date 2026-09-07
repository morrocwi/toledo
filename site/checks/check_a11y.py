#!/usr/bin/env python3
"""check_a11y — CI gate: per-page accessibility structure checks plus a
WCAG AA contrast check of the shared CSS token system, against a built
`site/dist/`.

Mirrors the checklist in `site/DESIGN.md` section 14 / the test list in
section 10. Stdlib-only (`html.parser`), no third-party dependency, so
this runs anywhere the rest of this repo's tooling does.

Per-page structure checks (every `*.html` file under the given root):
  - exactly one `<h1>`; no skipped heading level (h1 -> h3 with no h2
    between is a skip; going back down a level is always fine).
  - every `<table>`'s `<th>` cells carry `scope="col"`.
  - no re-implemented ARIA widget: any `role="..."` attribute at all is
    flagged (the design deliberately uses only native interactive
    elements, so a `role` attribute has no legitimate reason to appear).
  - `<html lang="en">` present (case-insensitive attribute match); a
    nested `lang="th"` span is allowed and not itself checked here.
  - the first focusable element in `<body>` is a skip-to-content link
    (`<a href="#...">` as the first anchor/button/input encountered).

CSS contrast check (once, not per page):
  - every token pair named in `site/DESIGN.md` section 7 meets WCAG AA
    (4.5:1, the stricter "normal text" threshold applied uniformly since
    this scanner cannot tell which uses are "large text") in both the
    light (`:root`) and dark (`prefers-color-scheme: dark`) blocks of
    `assets/toledo.css`.

Usage:
    python3 site/checks/check_a11y.py site/dist

Exit codes: 0 = clean; 1 = at least one finding; 2 = usage/configuration
error (the given path, or its `assets/toledo.css`, does not exist).
"""
from __future__ import annotations

import argparse
import pathlib
import re
import sys
from dataclasses import dataclass, field
from html.parser import HTMLParser

HEADING_TAGS = {f"h{i}": i for i in range(1, 7)}
FOCUSABLE_TAGS = {"a", "button", "input", "select", "textarea"}
VOID_TAGS = {
    "area", "base", "br", "col", "embed", "hr", "img", "input",
    "link", "meta", "param", "source", "track", "wbr",
}

# Token pairs to contrast-check: (background-token, foreground-token).
# Restricted to the clearly textual pairs named in DESIGN.md section 7 —
# the pill-* tokens are background chips whose paired text color is not
# specified there, so they are intentionally left out rather than guessed.
CONTRAST_PAIRS = [
    ("--bg", "--fg"),
    ("--bg", "--fg-muted"),
    ("--bg", "--link"),
    ("--bg", "--link-visited"),
    ("--bg-raised", "--fg"),
    ("--bg-raised", "--fg-muted"),
    ("--code-bg", "--fg"),
]
WCAG_AA_NORMAL_TEXT = 4.5


@dataclass
class Finding:
    path: str
    line: int
    message: str


@dataclass
class Report:
    files_scanned: int = 0
    findings: list[Finding] = field(default_factory=list)

    @property
    def ok(self) -> bool:
        return not self.findings


class PageAuditor(HTMLParser):
    def __init__(self, path: str):
        super().__init__(convert_charrefs=True)
        self.path = path
        self.findings: list[Finding] = []
        self.h1_count = 0
        self.heading_levels: list[int] = []
        self.in_body = False
        self.first_focusable_seen = False
        self.table_depth = 0
        self.th_stack: list[bool] = []  # per open <th>, whether scope="col" was set

    def _add(self, msg: str) -> None:
        line = self.getpos()[0]
        self.findings.append(Finding(self.path, line, msg))

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        attr_map = {k.lower(): (v or "") for k, v in attrs}
        tag = tag.lower()

        if tag == "html":
            if attr_map.get("lang", "").lower() != "en":
                self._add('missing or non-"en" lang attribute on <html>')

        if tag == "body":
            self.in_body = True

        if tag in HEADING_TAGS:
            level = HEADING_TAGS[tag]
            if level == 1:
                self.h1_count += 1
            if self.heading_levels and level > self.heading_levels[-1] + 1:
                self._add(
                    f"skipped heading level: h{self.heading_levels[-1]} -> h{level}"
                )
            self.heading_levels.append(level)

        if "role" in attr_map:
            self._add(f're-implemented ARIA widget: role="{attr_map["role"]}" on <{tag}>')

        if tag == "table":
            self.table_depth += 1
        if tag == "th":
            self.th_stack.append("scope" in attr_map and attr_map["scope"].lower() == "col")

        if self.in_body and not self.first_focusable_seen and tag in FOCUSABLE_TAGS:
            self.first_focusable_seen = True
            href = attr_map.get("href", "")
            if tag != "a" or not href.startswith("#"):
                self._add(
                    "first focusable element in <body> is not a "
                    f'skip-to-content link (<a href="#...">): got <{tag} href="{href}">'
                )

    def handle_startendtag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        # Void/self-closing tags: still relevant for the role/lang/focusable
        # checks above, never for th/table nesting.
        self.handle_starttag(tag, attrs)

    def handle_endtag(self, tag: str) -> None:
        tag = tag.lower()
        if tag == "th" and self.th_stack:
            has_scope_col = self.th_stack.pop()
            if not has_scope_col:
                self._add('<th> without scope="col"')
        if tag == "table":
            self.table_depth = max(0, self.table_depth - 1)

    def finalize(self) -> None:
        if self.h1_count == 0:
            self._add("no <h1> found")
        elif self.h1_count > 1:
            self._add(f"{self.h1_count} <h1> elements found, expected exactly 1")


def audit_page(path: pathlib.Path, rel: str) -> list[Finding]:
    text = path.read_text(encoding="utf-8", errors="replace")
    auditor = PageAuditor(rel)
    auditor.feed(text)
    auditor.close()
    auditor.finalize()
    return auditor.findings


# --------------------------------------------------------------------- #
# Contrast check
# --------------------------------------------------------------------- #

_ROOT_BLOCK_RE = re.compile(r":root\s*{([^}]*)}")
_DARK_MEDIA_RE = re.compile(
    r"@media\s*\(prefers-color-scheme:\s*dark\)\s*{\s*:root(?:\[[^\]]*\])?\s*{([^}]*)}",
    re.IGNORECASE,
)
_TOKEN_RE = re.compile(r"(--[a-zA-Z0-9-]+)\s*:\s*(#[0-9a-fA-F]{3,8})\s*;")


def _parse_tokens(css_text: str) -> tuple[dict[str, str], dict[str, str]]:
    """Returns (light_tokens, dark_tokens) as {token-name: '#hex'}."""
    light: dict[str, str] = {}
    m = _ROOT_BLOCK_RE.search(css_text)
    if m:
        light = dict(_TOKEN_RE.findall(m.group(1)))
    dark: dict[str, str] = {}
    m = _DARK_MEDIA_RE.search(css_text)
    if m:
        dark = dict(_TOKEN_RE.findall(m.group(1)))
    return light, dark


def _hex_to_rgb(hexcolor: str) -> tuple[int, int, int]:
    h = hexcolor.lstrip("#")
    if len(h) == 3:
        h = "".join(c * 2 for c in h)
    h = h[:6]
    return int(h[0:2], 16), int(h[2:4], 16), int(h[4:6], 16)


def _relative_luminance(rgb: tuple[int, int, int]) -> float:
    def chan(c: int) -> float:
        c_srgb = c / 255.0
        return c_srgb / 12.92 if c_srgb <= 0.03928 else ((c_srgb + 0.055) / 1.055) ** 2.4

    r, g, b = (chan(c) for c in rgb)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def contrast_ratio(hex_a: str, hex_b: str) -> float:
    l1 = _relative_luminance(_hex_to_rgb(hex_a))
    l2 = _relative_luminance(_hex_to_rgb(hex_b))
    lighter, darker = max(l1, l2), min(l1, l2)
    return (lighter + 0.05) / (darker + 0.05)


def check_contrast(css_path: pathlib.Path) -> list[Finding]:
    findings: list[Finding] = []
    if not css_path.is_file():
        findings.append(Finding(str(css_path), 0, "stylesheet not found — cannot run contrast check"))
        return findings

    css_text = css_path.read_text(encoding="utf-8", errors="replace")
    light, dark = _parse_tokens(css_text)

    for scheme, tokens in (("light", light), ("dark", dark)):
        for bg_tok, fg_tok in CONTRAST_PAIRS:
            if bg_tok not in tokens or fg_tok not in tokens:
                findings.append(
                    Finding(str(css_path), 0, f"{scheme}: {bg_tok}/{fg_tok} not defined")
                )
                continue
            ratio = contrast_ratio(tokens[bg_tok], tokens[fg_tok])
            if ratio < WCAG_AA_NORMAL_TEXT:
                findings.append(
                    Finding(
                        str(css_path), 0,
                        f"{scheme}: {bg_tok}/{fg_tok} contrast {ratio:.2f}:1 "
                        f"< {WCAG_AA_NORMAL_TEXT}:1 (WCAG AA normal text)",
                    )
                )
    return findings


def run(dist: pathlib.Path) -> tuple[int, list[str]]:
    if not dist.exists():
        return 2, [f"error: dist path does not exist: {dist}"]

    report = Report()
    html_files = sorted(dist.rglob("*.html"))
    for path in html_files:
        rel = str(path.relative_to(dist))
        report.files_scanned += 1
        report.findings.extend(audit_page(path, rel))

    css_path = dist / "assets" / "toledo.css"
    report.findings.extend(check_contrast(css_path))

    lines = [f"{report.files_scanned} HTML page(s) scanned"]
    for f in report.findings:
        lines.append(f"{f.path}:{f.line}: {f.message}")

    if report.ok:
        lines.append("OK: no accessibility findings")
        return 0, lines
    lines.append(f"FAIL: {len(report.findings)} accessibility finding(s)")
    return 1, lines


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
