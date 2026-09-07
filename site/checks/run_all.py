#!/usr/bin/env python3
"""run_all — runs check_perf_budget, check_a11y and
check_banned_words_and_leaks in sequence against a built `site/dist/`,
per `site/DESIGN.md` section 10. Called from the `build-site` CI job
(section 8). Non-zero exit on any hard failure from any check.

Usage:
    python3 site/checks/run_all.py site/dist
    python3 site/checks/run_all.py site/dist --denylist-file /path/to/local/denylist.txt
"""
from __future__ import annotations

import argparse
import os
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))

import check_a11y  # noqa: E402
import check_banned_words_and_leaks  # noqa: E402
import check_perf_budget  # noqa: E402


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("dist", type=pathlib.Path, help="path to the built site (e.g. site/dist)")
    parser.add_argument(
        "--denylist-file",
        type=pathlib.Path,
        default=os.environ.get("TOLEDO_LEAK_SCAN_DENYLIST_FILE"),
        help="optional file of extra literal patterns (private-repo name etc.), one per "
             "line — same TOLEDO_LEAK_SCAN_DENYLIST_FILE env-var fallback "
             "check_banned_words_and_leaks.py and mcp/scripts/leak_scan.py already use",
    )
    args = parser.parse_args(argv)

    checks = [
        ("check_perf_budget", lambda: check_perf_budget.run(args.dist)),
        ("check_a11y", lambda: check_a11y.run(args.dist)),
        ("check_banned_words_and_leaks", lambda: check_banned_words_and_leaks.run(args.dist, args.denylist_file)),
    ]

    worst = 0
    for name, fn in checks:
        print(f"=== {name} ===")
        code, lines = fn()
        for line in lines:
            print(line)
        print()
        # 2 (config error) always wins; otherwise any 1 (fail) beats 0 (ok).
        if code == 2:
            worst = 2
        elif code == 1 and worst != 2:
            worst = 1

    if worst == 0:
        print("run_all: OK — all checks passed")
    elif worst == 2:
        print("run_all: CONFIGURATION ERROR — see above")
    else:
        print("run_all: FAIL — see above")
    return worst


if __name__ == "__main__":
    sys.exit(main())
