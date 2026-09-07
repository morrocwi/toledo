"""Verdict semantics for the founder rule (2026-09-07): every equation must
be looked up in Toledo before it is used; no agent may use an unregistered
equation.

This module is the single place that rule turns into a value a caller (an
AI agent, another tool, a human) can branch on. It is deliberately attached
to BOTH the dedicated `check` tool AND every `get`/`status` response (see
`server.py` integration notes in docs/DESIGN.md) — an agent that skips
`check` and calls `get` directly on a code it already has still receives the
verdict alongside the statement, so "look it up before use" cannot be
silently bypassed by only ever calling the one tool that returns the
formula text. This is as much enforcement as a stdio tool surface can give:
it cannot stop an agent from ignoring the field, but it cannot hand back a
bare formula without it either, and every non-clean verdict is designed to
read as a clear stop sign rather than something easy to skim past.

Verdict values:

- ``REGISTERED_CURRENT`` — exact code match, ``status == "current"``. Safe to
  cite this code as-is.
- ``REGISTERED_UNVERIFIED`` / ``REGISTERED_HISTORICAL`` /
  ``REGISTERED_IMPRECISE`` — exact code match, but ``status`` is
  ``unverified`` / ``historical`` / ``imprecise_as_stated``. Usable, but the
  caller MUST disclose the caveat (``status_note``) alongside the citation —
  never presented as a plain, unqualified ``current`` result.
- ``REGISTERED_SUPERSEDED`` — ``status == "superseded_by"``. Do not use this
  code; use ``redirect`` instead (the chain is walked and reported; a 2-cycle
  is reported as ``AMBIGUOUS`` rather than looped, matching
  ``registry/SCHEMA.md``'s own "no 2-cycle" rule for this field).
- ``REGISTERED_SPLIT`` — ``status == "split"``. Do not use this code; one of
  ``children`` names the object actually wanted.
- ``REGISTERED_NOT_AN_EQUATION`` — ``status == "not_an_equation"``. This code
  is a pointer to prose, not a formula; do not present it as one.
- ``CANDIDATE_MATCH`` — no exact code given/found, but
  ``equivalence.find_candidates`` returned one or more
  renaming/scale/structural candidates. Do not treat any of them as
  registered; either get a documented φ confirmation and cite the matched
  code, or call ``register_proposal``.
- ``AMBIGUOUS`` — more than one exact/high-confidence candidate conflicts
  (including a superseded_by 2-cycle), or the same normalised statement
  matches two different ``current`` codes. Escalate to a human; do not guess.
- ``CAUTION`` — ``status`` is missing (``None``) or is a string outside every
  status this module recognises (a future schema field the registry-owning
  lane added without this server being taught about it yet, a hand-authored
  proposal merged with a typo, a partially-written entry mid-edit). This is
  the fail-safe default (fixed 2026-09-07, `mcp/DESIGN.md` sec. 5): the
  fallback branch previously answered an unrecognised/missing ``status`` with
  ``REGISTERED_CURRENT``/``usable=True`` when ``status is None`` — the single
  most dangerous failure mode this server can have, silently promoting an
  unrecognised entry to "safe to cite". ``CAUTION`` is never usable and is
  spelled differently from ``AMBIGUOUS`` on purpose: ``AMBIGUOUS`` is for
  *conflicting* evidence (two matches, a broken chain), ``CAUTION`` is for
  *absent/unrecognised* evidence — a caller or log can tell "the registry
  disagrees with itself" from "this server doesn't understand what it's
  looking at" without parsing ``reason`` text.
- ``NOT_REGISTERED`` — no code, no candidate. Call ``register_proposal``
  before using this equation.

Eleven verdict values in total (``VERDICT_VALUES`` below) once ``CAUTION`` is
counted alongside the ten already named in earlier drafts of this docstring.

``RULES`` (below) restates this same decision table as data, walked by
``verdict_for_entry``/``verdict_for_check`` wherever the branch is a simple
membership test — it backs the ``toledo_show_verdict_rules`` MCP tool
(`mcp/DESIGN.md` sec. 8, graft A6) so a calling agent or a human can audit the
founder-rule enforcement mechanically, without reading this file's Python.

``stale`` (bool) is attached to every verdict payload from
``index.check_freshness`` — see that module's docstring for what it means and
why it is disclosed rather than silently absorbed into the verdict itself.
"""
from __future__ import annotations

from dataclasses import dataclass, field

# The exact set of `status` values this module recognises — anything else
# (including `None`) falls to the CAUTION branch at the bottom of
# `verdict_for_entry`, never silently treated as `current`. Kept as a
# standalone, importable set (rather than inlined only in the branch logic)
# so `toledo_show_verdict_rules` can report it verbatim and
# `test_show_verdict_rules_matches_verdict_py_known_statuses` can pin the two
# from drifting apart.
_KNOWN_STATUSES = {
    "current",
    "unverified",
    "historical",
    "imprecise_as_stated",
    "superseded_by",
    "split",
    "not_an_equation",
}

# All eleven verdict values this module can return, in the same order the
# module docstring above introduces them. Exposed for `toledo_show_verdict_
# rules` and for tests that want to assert exhaustiveness.
VERDICT_VALUES = [
    "REGISTERED_CURRENT",
    "REGISTERED_UNVERIFIED",
    "REGISTERED_HISTORICAL",
    "REGISTERED_IMPRECISE",
    "REGISTERED_SUPERSEDED",
    "REGISTERED_SPLIT",
    "REGISTERED_NOT_AN_EQUATION",
    "CANDIDATE_MATCH",
    "AMBIGUOUS",
    "CAUTION",
    "NOT_REGISTERED",
]

# The decision table as data (`mcp/DESIGN.md` sec. 8, graft A6). This is not
# a second, independent restatement that could silently drift from the real
# branch logic below — `_KNOWN_STATUSES`/`VERDICT_VALUES` above are the same
# objects the branches use, and the two structural branches this table
# cannot fully capture (the `superseded_by` chain-walk, and which `children`
# entry a `split` redirect names) are called out below as exactly that,
# rather than pretended to be table-shaped.
RULES: list[dict] = [
    {"when": "status == 'current'", "verdict": "REGISTERED_CURRENT", "usable": True},
    {
        "when": "status in {'unverified','historical','imprecise_as_stated'}",
        "verdict": "REGISTERED_UNVERIFIED | REGISTERED_HISTORICAL | REGISTERED_IMPRECISE",
        "usable": True,
        "note": "caller MUST disclose status_note alongside the citation",
    },
    {
        "when": "status == 'superseded_by'",
        "verdict": "REGISTERED_SUPERSEDED",
        "usable": False,
        "note": "redirect = walked chain; a detected 2-cycle returns AMBIGUOUS instead of looping (structural, not a table lookup)",
    },
    {
        "when": "status == 'split'",
        "verdict": "REGISTERED_SPLIT",
        "usable": False,
        "note": "redirect = children[] (structural, not a table lookup)",
    },
    {"when": "status == 'not_an_equation'", "verdict": "REGISTERED_NOT_AN_EQUATION", "usable": False},
    {
        "when": "no exact code/entry, but equivalence.find_candidates found >=1",
        "verdict": "CANDIDATE_MATCH",
        "usable": False,
    },
    {
        "when": "conflicting evidence (two current codes exact-match one normalised statement; a malformed superseded_by chain)",
        "verdict": "AMBIGUOUS",
        "usable": False,
    },
    {
        "when": "status is None, or any string outside the recognised set above",
        "verdict": "CAUTION",
        "usable": False,
        "note": "fail-safe default (fixed 2026-09-07, see mcp/DESIGN.md sec. 5) — never promoted to a usable verdict",
    },
    {
        "when": "no code, no candidate",
        "verdict": "NOT_REGISTERED",
        "usable": False,
        "note": "call toledo_register_proposal before using this equation",
    },
]


@dataclass
class Verdict:
    verdict: str
    usable: bool
    reason: str
    redirect: list[str] = field(default_factory=list)  # codes to use instead, if any
    candidates: list[dict] = field(default_factory=list)

    def to_dict(self) -> dict:
        return {
            "verdict": self.verdict,
            "usable": self.usable,
            "reason": self.reason,
            "redirect": self.redirect,
            "candidates": self.candidates,
        }


_CAVEATED_STATUS = {
    "unverified": "REGISTERED_UNVERIFIED",
    "historical": "REGISTERED_HISTORICAL",
    "imprecise_as_stated": "REGISTERED_IMPRECISE",
}


def verdict_for_entry(entry: dict, resolve_superseded) -> Verdict:
    """`resolve_superseded(code) -> entry|None` looks up another entry by
    code (used to walk a `superseded_by` chain and to detect a 2-cycle)."""
    status = entry.get("status")
    code = entry.get("code")

    if status == "current":
        return Verdict("REGISTERED_CURRENT", True, "status is current; cite this code as-is.")

    if status in _CAVEATED_STATUS:
        note = entry.get("status_note") or "(no status_note recorded)"
        return Verdict(
            _CAVEATED_STATUS[status], True,
            f"status is {status} — usable, but disclose this caveat alongside the citation: {note}",
        )

    if status == "superseded_by":
        chain = [code]
        seen = {code}
        cur = entry
        for _ in range(50):
            nxt_code = cur.get("superseded_by")
            if not nxt_code:
                break
            if nxt_code in seen:
                return Verdict(
                    "AMBIGUOUS", False,
                    f"superseded_by chain from {code} cycles back to {nxt_code} — this is a schema "
                    "violation (registry/SCHEMA.md forbids a 2-cycle); escalate to a human, do not guess.",
                )
            chain.append(nxt_code)
            seen.add(nxt_code)
            nxt = resolve_superseded(nxt_code)
            if nxt is None:
                return Verdict(
                    "AMBIGUOUS", False,
                    f"{code} is superseded_by {nxt_code}, which is not itself a registered code — escalate to a human.",
                    redirect=[nxt_code],
                )
            cur = nxt
            if cur.get("status") == "current":
                break
        return Verdict(
            "REGISTERED_SUPERSEDED", False,
            f"{code} is retired; use {chain[-1]} instead.", redirect=chain[1:],
        )

    if status == "split":
        children = entry.get("children") or []
        return Verdict(
            "REGISTERED_SPLIT", False,
            f"{code} was split into distinct objects; use one of its children instead — "
            f"read {entry.get('status_note') or '(no status_note recorded)'} to pick the right one.",
            redirect=list(children),
        )

    if status == "not_an_equation":
        return Verdict(
            "REGISTERED_NOT_AN_EQUATION", False,
            f"{code} is a coded pointer to prose, not a formula — do not present it as an equation. "
            f"{entry.get('status_note') or ''}".strip(),
        )

    # Fail-safe default (fixed 2026-09-07, mcp/DESIGN.md sec. 5 / sec. 0's
    # confirmed bug). `status` is `None` or a string outside
    # `_KNOWN_STATUSES` (a future schema addition this build has not been
    # taught yet, a hand-authored proposal merged with a typo, a
    # partially-written entry mid-edit by the registry-owning lane). This
    # branch used to answer `status is None` with `REGISTERED_CURRENT` /
    # `usable=True` — silently promoting an unrecognised entry to "safe to
    # cite", the single most dangerous failure mode this server can have.
    # Never inferred as safe, ever: this is unreachable only if every
    # explicit branch above already matched a known status.
    return Verdict(
        "CAUTION", False,
        f"missing or unrecognised status value {status!r} on {code!r} — "
        "never inferred as safe; escalate to a human before using this entry.",
    )


def verdict_for_check(exact_entry: dict | None, candidates: list, resolve_superseded) -> Verdict:
    """Top-level verdict for the `check` tool: `exact_entry` is the result of
    an exact-code lookup if the caller passed a code (not a bare statement),
    `candidates` is the ranked `equivalence.EquivalenceEvidence` list for a
    statement lookup."""
    if exact_entry is not None:
        v = verdict_for_entry(exact_entry, resolve_superseded)
        v.candidates = [{"code": exact_entry.get("code"), "kind": "exact_code", "ratio": 1.0}]
        return v

    if not candidates:
        return Verdict("NOT_REGISTERED", False, "no registered code or candidate match found; call register_proposal before using this equation.")

    top = candidates[0]
    tied = [c for c in candidates if c.kind == top.kind and abs(c.ratio - top.ratio) < 1e-6]
    cand_dicts = [{"code": c.code, "kind": c.kind, "ratio": round(c.ratio, 3), "detail": c.detail} for c in candidates]

    if top.kind == "exact":
        if len(tied) > 1:
            return Verdict(
                "AMBIGUOUS", False,
                f"the normalised statement is an exact match to {len(tied)} different codes: "
                f"{[c.code for c in tied]} — escalate to a human, do not pick one.",
                candidates=cand_dicts,
            )
        # R3-1 fix (2026-09-07): an exact statement match used to be
        # hard-coded to REGISTERED_CURRENT/usable=True with NO check of the
        # matched entry's own `status` — so a formula that exact-matches a
        # `not_an_equation`/`superseded_by`/`split` entry's statement was
        # told "REGISTERED_CURRENT, usable, cite that code", precisely the
        # moment (an agent has formula text, not yet a code) the founder
        # rule most needs to bite. Resolve the matched code to its full
        # entry and delegate to the SAME status-aware `verdict_for_entry`
        # a code lookup already goes through, instead of a second,
        # status-blind path.
        matched = resolve_superseded(top.code)
        if matched is None:
            return Verdict(
                "AMBIGUOUS", False,
                f"exact match to {top.code} could not be re-resolved to a full entry — escalate to a human.",
                candidates=cand_dicts,
            )
        v = verdict_for_entry(matched, resolve_superseded)
        v.candidates = cand_dicts
        return v

    return Verdict(
        "CANDIDATE_MATCH", False,
        f"{len(candidates)} candidate match(es) found (top: {top.code}, {top.kind}) — none is a confirmed "
        "registration; get a documented φ-criterion confirmation and cite the matched code, or call "
        "register_proposal.",
        candidates=cand_dicts,
    )
