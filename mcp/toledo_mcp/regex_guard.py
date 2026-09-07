"""Shared guard for evaluating an agent-supplied regex pattern against
registry text (`queries.search`'s and `core.search`'s `regex=True` branch,
and anything reached through them — `toledo_search(regex=True)` over MCP,
`toledo find --regex` on the CLI).

Fixes a real denial-of-service: `re.compile(query).search(haystack)` with an
unbounded, caller-supplied pattern and an unbounded haystack is exponential
on a classic catastrophic-backtracking pattern (e.g. `"(.*)+ZZZ_NOT_PRESENT"`
against any sufficiently long real statement — several exist in this
registry). Because `mcp`'s FastMCP calls a sync tool function directly
inside the asyncio event loop, one hung regex call blocks the ENTIRE
single-process server for every other caller — including the founder-
mandated lookup gate itself ("every equation must be looked up in Toledo
before use").

Two independent guards, both stdlib-only:

1. ``check_regex_query_length`` — reject a `regex=True` query longer than a
   small cap before it is ever compiled. Cuts off the worst blowups (pattern
   complexity in the catastrophic-backtracking classes grows with pattern
   AND input length) for near-zero cost.
2. ``safe_search`` — run `pattern.search(haystack)` under a hard wall-clock
   budget via `signal.setitimer(signal.ITIMER_REAL, ...)` + a `SIGALRM`
   handler that raises `RegexTimeout` instead of hanging. Correct only when
   called from the main thread of a single-process, single-threaded server —
   true here: `mcp.run("stdio")` runs the whole FastMCP event loop in the
   main thread, and `scripts/toledo`/`toledo_mcp.cli` are themselves single-
   threaded processes.
"""
from __future__ import annotations

import re
import signal

# Small enough to cut off the worst catastrophic-backtracking blowups before
# a pattern is even compiled, generous enough for any real registry query
# (`docs/EQ_CODE_SCHEME.md`/`registry/SCHEMA.md` codes and statements are far
# shorter than this).
MAX_REGEX_QUERY_LEN = 200

# Wall-clock budget for one `pattern.search(haystack)` call. Generous for any
# legitimate regex against any one registry entry's text; a call that has not
# returned within this budget is treated as pathological, not merely slow.
DEFAULT_TIMEOUT_SECONDS = 1.0


class RegexQueryTooLong(ValueError):
    """`regex=True` query exceeds `MAX_REGEX_QUERY_LEN`."""


class RegexTimeout(TimeoutError):
    """A single `pattern.search(...)` call exceeded its wall-clock budget."""


def check_regex_query_length(query: str, *, max_len: int = MAX_REGEX_QUERY_LEN) -> None:
    """Raise `RegexQueryTooLong` (a `ValueError`) if `query` is longer than
    `max_len`. Call this BEFORE `re.compile(query)` in every `regex=True`
    search path."""
    if len(query) > max_len:
        raise RegexQueryTooLong(
            f"regex query is {len(query)} characters, longer than the {max_len}-character "
            "cap allowed for regex=True searches; simplify the pattern"
        )


def _raise_timeout(signum, frame):  # pragma: no cover — invoked by the OS, not called directly
    raise RegexTimeout("regex query took too long to evaluate against the registry; simplify the pattern")


def safe_search(pattern: "re.Pattern[str]", haystack: str, *, timeout_seconds: float = DEFAULT_TIMEOUT_SECONDS):
    """`pattern.search(haystack)` under a hard wall-clock budget. Raises
    `RegexTimeout` instead of hanging past `timeout_seconds`.

    On a platform with no `signal.SIGALRM` (non-POSIX — this workspace only
    runs on Linux, but the guard degrades safely rather than raising
    `AttributeError` if it is ever imported elsewhere) this runs the search
    unguarded; `check_regex_query_length` above is the remaining protection
    there, since the stdlib offers no other thread/process-free hard-timeout
    primitive.
    """
    if not hasattr(signal, "SIGALRM"):  # pragma: no cover — this workspace is Linux-only
        return pattern.search(haystack)

    previous_handler = signal.signal(signal.SIGALRM, _raise_timeout)
    try:
        signal.setitimer(signal.ITIMER_REAL, timeout_seconds)
        try:
            return pattern.search(haystack)
        finally:
            signal.setitimer(signal.ITIMER_REAL, 0)
    finally:
        signal.signal(signal.SIGALRM, previous_handler)
