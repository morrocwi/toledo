#!/usr/bin/env python3
"""check_perf_budget — CI gate: every "index-shaped" page under a built
`site/dist/` stays under the founder's 200 KB (uncompressed HTML) budget.

Per `site/DESIGN.md` section 0 / section 13: home, `/browse/`, `/search/`,
`/agents/`, `/about/`, and every `/by-root/`, `/by-domain/`, `/by-tier/`,
`/by-status/` listing page are "index-shaped" and must stay under the
budget. `/entries/<slug>.html` pages carry only a soft target (not
enforced here — see DESIGN.md section 13) since the founder's hard budget
names only the index-shaped classes.

Standalone and stdlib-only (no third-party dependency), runnable both from
`site/checks/run_all.py` and directly:

    python3 site/checks/check_perf_budget.py site/dist

Exit codes: 0 = every index-shaped page is within budget; 1 = at least one
page is over budget, or no index-shaped page was found at all (a build
that produced nothing to check is itself treated as a failure, never
silently reported clean); 2 = usage/configuration error (the given path
does not exist).
"""
from __future__ import annotations

import argparse
import pathlib
import sys

BUDGET_BYTES = 200 * 1024  # 200 KB, founder constraint (site/DESIGN.md section 0/13)

# Fixed, non-listing index-shaped pages (relative to the dist root).
FIXED_INDEX_PAGES = [
    "index.html",
    "browse/index.html",
    "search/index.html",
    "agents/index.html",
    "about/index.html",
]

# Listing-page directories: every immediate child's index.html is
# index-shaped (one page per by-root/by-domain/by-tier/by-status value).
LISTING_DIRS = ["by-root", "by-domain", "by-tier", "by-status"]


def find_index_shaped_pages(dist: pathlib.Path) -> list[pathlib.Path]:
    pages: list[pathlib.Path] = []
    for rel in FIXED_INDEX_PAGES:
        p = dist / rel
        if p.is_file():
            pages.append(p)
    for d in LISTING_DIRS:
        base = dist / d
        if not base.is_dir():
            continue
        for child in sorted(base.iterdir()):
            idx = child / "index.html"
            if idx.is_file():
                pages.append(idx)
    return pages


def run(dist: pathlib.Path) -> tuple[int, list[str]]:
    lines: list[str] = []
    if not dist.exists():
        return 2, [f"error: dist path does not exist: {dist}"]

    pages = find_index_shaped_pages(dist)
    if not pages:
        return 1, [
            f"FAIL: no index-shaped page found under {dist} "
            "(expected at least index.html) — build looks incomplete or missing"
        ]

    sizes = [(p, p.stat().st_size) for p in pages]
    sizes.sort(key=lambda t: t[1], reverse=True)

    over_budget = [(p, sz) for p, sz in sizes if sz > BUDGET_BYTES]

    lines.append(f"{len(pages)} index-shaped page(s) checked, budget {BUDGET_BYTES} bytes (200 KB)")
    lines.append("largest pages:")
    for p, sz in sizes[:10]:
        rel = p.relative_to(dist)
        flag = " OVER BUDGET" if sz > BUDGET_BYTES else ""
        lines.append(f"  {sz:>8} bytes  {rel}{flag}")

    if over_budget:
        lines.append(f"FAIL: {len(over_budget)} page(s) over the {BUDGET_BYTES}-byte budget")
        return 1, lines

    lines.append("OK: every index-shaped page is within budget")
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
