from __future__ import annotations

import re
import time

import pytest

from toledo_mcp import regex_guard


def test_check_regex_query_length_rejects_over_cap():
    long_query = "a" * (regex_guard.MAX_REGEX_QUERY_LEN + 1)
    with pytest.raises(regex_guard.RegexQueryTooLong):
        regex_guard.check_regex_query_length(long_query)


def test_check_regex_query_length_allows_at_cap():
    ok_query = "a" * regex_guard.MAX_REGEX_QUERY_LEN
    regex_guard.check_regex_query_length(ok_query)  # must not raise


def test_safe_search_returns_normally_for_ordinary_pattern():
    pattern = re.compile("abc")
    assert regex_guard.safe_search(pattern, "xxabcxx") is not None
    assert regex_guard.safe_search(pattern, "no match here") is None


def test_safe_search_raises_timeout_instead_of_hanging_on_catastrophic_backtracking():
    """SEC-1 (2026-09-07): a classic catastrophic-backtracking pattern
    against a haystack with no match at the end forces the `re` engine's
    backtracking to blow up exponentially in the haystack length. Without a
    bound this would hang the calling process indefinitely (confirmed live:
    the real finding this guards against left the real evil call "still
    hung after 25.002 s" -- effectively forever, since growth is
    exponential). `safe_search` must instead raise `RegexTimeout` within
    (approximately) the requested budget, never silently completing late or
    hanging past it."""
    pattern = re.compile(r"(a+)+$")
    haystack = "a" * 32 + "!"  # no trailing match forces full backtracking
    start = time.monotonic()
    with pytest.raises(regex_guard.RegexTimeout):
        regex_guard.safe_search(pattern, haystack, timeout_seconds=0.2)
    elapsed = time.monotonic() - start
    # Generous upper bound -- proves this test (and the guard) does not hang
    # indefinitely, without being a flaky tight timing assertion.
    assert elapsed < 5.0


def test_safe_search_timeout_does_not_leak_the_alarm_into_later_calls():
    """The SIGALRM handler/itimer must be fully torn down after a timeout
    (or a normal return) so a later, ordinary `safe_search` call in the same
    process is never spuriously interrupted by a stale pending alarm."""
    pattern = re.compile(r"(a+)+$")
    haystack = "a" * 32 + "!"
    with pytest.raises(regex_guard.RegexTimeout):
        regex_guard.safe_search(pattern, haystack, timeout_seconds=0.1)

    ordinary = re.compile("abc")
    assert regex_guard.safe_search(ordinary, "xxabcxx") is not None
