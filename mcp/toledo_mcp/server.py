#!/usr/bin/env python3
"""toledo_mcp.server — MCP stdio server over the Toledo equation library.

FOUNDER RULE (2026-09-07): every equation must be looked up in Toledo before an
agent uses it. No agent may use an unregistered equation. `toledo_check` and
every `toledo_get`/`toledo_status`/`toledo_by_raw_key` result carries a
`verdict` — do not use a formula from a `usable: false` verdict; call
`toledo_register_proposal` and wait for a human registrar to merge it.

Data path (see docs/DESIGN.md for the full reasoning and the benchmark that
drove it): every tool goes through `cache.get_cache()`, a process-wide
`RegistryCache` that loads `core.Registry` once and reuses it across calls,
refreshing only when `registry/CANONICAL.json` / `registry/genesis_root.json`
/ `registry/LINEAGE.jsonl` actually change (a cheap `os.stat` comparison, not
a JSON reparse). Most tools are then plain O(1)/O(local) Python lookups
against that cached Registry; `toledo_search` and the statement-lookup path
of `toledo_check` delegate to a SQLite+FTS5 index built from the same cached
Registry, which is where SQL measurably earns its cost (see
benchmarks/bench_index.py).

Changes from the first landed pass of this file (per this package's build
instructions: "build on it, do not discard silently — say what you replace
and why"; grafts numbered per `mcp/DESIGN.md`, the second, independent design
synthesis this rewrite implements):

  - **Error envelope (graft A1, `mcp/DESIGN.md` sec. 3).** Every tool now
    returns `{"ok": bool, "data": ..., "error": {"code", "message"} | None}`
    instead of a bare payload. This is a deliberate, documented BREAKING
    change to every tool's top-level return shape (the previous pass returned
    the payload directly — a bare `dict`, `list`, or `None`) — it is what lets
    a caller tell "the registry answered and the code genuinely does not
    exist" (`ok: true, data: null, error: null` — a normal, common answer,
    never a transport-level failure) apart from "the server could not answer
    at all" (`ok: false`, `error.code` one of `INVALID_INPUT` /
    `INDEX_UNAVAILABLE`), and apart from "the answer came from disclosed
    stale data" (`ok: true`, `data.stale: true`, `error.code: "STALE_INDEX"`).
  - **Verdict fail-safe fix (grafts A2/C1) lives in `verdict.py`, not here**
    — `toledo_get`/`toledo_status`/`toledo_check`/`toledo_by_raw_key` all
    call the same `verdict_for_entry`/`verdict_for_check`, so the fix applies
    to every one of them automatically; nothing in this file special-cases
    the old dangerous fallback.
  - **Per-entry `verdict` on every tool returning a citable entry or hit
    list** (graft B1): `toledo_search`, `toledo_by_root`, `toledo_by_domain`,
    `toledo_by_record`, `toledo_descendants`, and the parent/child rows (not
    the relation/reverse-relation cross-links) of `toledo_neighbours` now
    each carry their own `verdict` block, computed against the SAME full
    entry `toledo_get` would return for that code — an agent that only ever
    calls `toledo_search` still cannot walk past a superseded/split/
    not-an-equation code without seeing that in the row itself.
  - **`format="toon"` on every uniform row-list tool** (grafts B5/C7):
    `toledo_search`, `toledo_by_root`, `toledo_by_domain`, `toledo_by_record`,
    `toledo_descendants` accept `format: "json" | "toon" = "json"`. `toon`
    mode TOON-encodes the same row array as a single string
    (`data.<key>_toon`) with `data.<key>` set to `null` in that mode — the
    two are mutually exclusive in one response so a caller never has to guess
    which is authoritative. The encoder is `cli.encode_toon` — this file
    IMPORTS it rather than carrying a second copy (`mcp/DESIGN.md` sec. 7/14:
    "same encoder, imported by server.py from cli.py -- a single
    implementation, not two"); an earlier draft of this rewrite carried a
    temporary local copy because `toledo_mcp/cli.py` did not exist yet in
    this checkout at the time -- it now does (a different build stream landed
    it since), so that temporary copy was deleted in favour of this import,
    exactly per its own TODO.
  - **`toledo_show_verdict_rules`, 19th tool** (graft A6): returns the exact
    decision table `verdict.py` runs (`verdict.RULES`/`verdict.VERDICT_VALUES`
    /`verdict._KNOWN_STATUSES`), as data — audit the founder-rule enforcement
    without reading Python source.
  - **Proposal writes relocated to `mcp/proposals/`** (graft C4): this file
    calls `proposals.write_proposal` (this package's own, S2-owned write
    path — see `proposals.py`'s module docstring for why `core.
    register_proposal`, which belongs to a different build stream and now
    ALSO targets `mcp/proposals/` since that stream's own later edit, is
    deliberately still not called here) instead of `core.register_proposal`
    directly. `toledo_register_proposal`'s return shape (`{"path", "slug",
    "submitted_at"}`, now wrapped in the envelope) is otherwise unchanged; a
    caller only sees the `mcp/proposals/` location in the returned `path`
    string.
  - **`INDEX_UNAVAILABLE` on a genuine read/parse failure** (graft A1 table):
    every tool body is wrapped (`_safe`) so a `FileNotFoundError`/`OSError`/
    `json.JSONDecodeError` escaping `cache.get_cache()` becomes a typed
    `{"ok": false, "error": {"code": "INDEX_UNAVAILABLE", ...}}` instead of an
    uncaught exception reaching the MCP transport.
  - **`STALE_INDEX` disclosure hook** (grafts A4/C5): every envelope-building
    helper checks `cache.get_cache()` for a `degraded`/`degraded_reason`
    attribute pair and, if set, marks the response `data.stale: true` with
    `error.code: "STALE_INDEX"`. `cache.py`'s retry-with-backoff-then-serve-
    stale behaviour (`mcp/DESIGN.md` sec. 4) is specified but not yet landed
    in this checkout as of this rewrite (`RegistryCache` carries no
    `degraded` attribute today) — this file is written against the spec
    (`getattr(cache, "degraded", False)`, never assuming the attribute
    exists) so the disclosure activates the moment that other build stream
    lands it, with no further change needed here. See
    `test_stale_disclosure_activates_once_cache_reports_degraded` in
    `tests/test_server.py` for the pinning test that exercises this via a
    monkeypatched cache object today (a TODO test per this package's build
    instructions, since the real `cache.degraded` attribute does not exist
    yet to exercise directly).

S4 addition (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.8) -- `toledo_eval`, the 21st
tool: evaluates one reviewed-eligible executable-equation IR sidecar
(`registry/executable/<mangled-code>.json`, S1's output) at caller-declared
exact-rational inputs, via `scripts/executable.ir_eval` -- S2's shared,
Fraction-only reference evaluator, the SAME one the site widget's build step
and the cross-check runner (S3) both call, never re-implemented here. Reads
`inputs` values ONLY as strings; a JSON/float number is rejected, never
silently coerced, so no floating value ever crosses into the evaluator.
Fail-closed for a code with no sidecar, an unreviewed (`candidate`) sidecar, a
`reviewed_rejected` sidecar, or a runtime that is not yet importable on this
build (S2 has not landed `scripts/executable/ir_eval.py` in every checkout
this file runs against) -- returns `{"evaluable": false, ...}` rather than
raising. A live result carries the identical "not a Reproduction Card" caveat
the site widget shows and is never itself written into any resistance/
reproduction record.

Kept from the first pass, unchanged in shape or reasoning:
  - Every tool reads through `cache.get_cache()` instead of calling
    `core.load_registry()` fresh inline.
  - `toledo_check` keeps its `formula=`/`code=` contract and the richer
    verdict vocabulary (walking `superseded_by`/`split`/`not_an_equation`),
    with `method="phi"` (default, the indexed φ-criterion prefilter) or
    `method="difflib"` (`core.check`'s original whole-registry scan, kept for
    compatibility).
  - The full tool set closing the parity gap with `scripts/toledo`
    (`toledo_by_root`/`by_domain`/`by_record`/`neighbours`/`descendants`) plus
    `toledo_ancestors`, `toledo_by_raw_key`, `toledo_lineage_window`, and the
    proposal-queue tools.

Reads the registry read-only; the only write path anywhere in this server is
`toledo_register_proposal` (via `proposals.write_proposal`, plus the
STATUS.jsonl ledger `proposals.py` appends next to it). Nothing here ever
edits `registry/CANONICAL.json`, `registry/genesis_root.json`,
`registry/LINEAGE.jsonl`, `coq/`, or `latex/`.

Transport: stdio only (`mcp.server.fastmcp.FastMCP`, `.run("stdio")`).
Dependency: the `mcp` package plus the Python standard library; nothing else.
"""
from __future__ import annotations

import decimal
import functools
import importlib.util
import json as _json
import pathlib
import sqlite3
import sys
from fractions import Fraction
from typing import Any, Literal

from mcp.server.fastmcp import FastMCP

try:
    from . import cache as cache_mod
    from . import cli, core, equivalence, export_static, lint, paths, proposals, regex_guard, verdict
except ImportError:
    # Run directly as a script (`python3 mcp/toledo_mcp/server.py`, as in the
    # repo-root .mcp.json) rather than via `python3 -m toledo_mcp.server` — put
    # mcp/ on sys.path so the package-relative import above still resolves.
    import sys

    sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))
    from toledo_mcp import cache as cache_mod
    from toledo_mcp import cli, core, equivalence, export_static, lint, paths, proposals, regex_guard, verdict

mcp = FastMCP(
    name="toledo",
    instructions=(
        "Toledo is the permanent registry of every equation in the Human-AI "
        "Readout Programme. Founder rule (2026-09-07): every equation must be "
        "looked up here before use; no agent may use an unregistered equation. "
        "Call toledo_check(formula=..., or code=...) before citing or deriving "
        "from any equation. Every response envelope is {\"ok\", \"data\", "
        "\"error\"}; a citable entry/row always carries a `verdict` object "
        "with a boolean `usable` inside `data` — never use a formula whose "
        "verdict has usable=false. If nothing registered is found, call "
        "toledo_register_proposal(...) and wait for a human registrar to "
        "merge it (poll toledo_proposal_status with the returned path to see "
        "whether that happened). Call toledo_show_verdict_rules() to audit "
        "the exact decision table this server enforces."
    ),
)


# ---------------------------------------------------------------------------
# Error envelope (graft A1, mcp/DESIGN.md sec. 3)
# ---------------------------------------------------------------------------

def _stale_state() -> tuple[bool, str | None]:
    """(degraded, reason) read from the process-wide cache, if it reports
    one. `cache.RegistryCache` is specified (mcp/DESIGN.md sec. 4, grafts
    A4/C5) to gain `degraded`/`degraded_reason` attributes once its
    retry-with-backoff-then-serve-stale path lands — that build stream owns
    `cache.py`, not this file, and has not landed it as of this rewrite. This
    helper is written against the spec (`getattr(..., False)`/`getattr(...,
    None)`) rather than assuming the attributes exist, so the disclosure
    activates automatically the moment they do, with no change needed here."""
    c = cache_mod.get_cache()
    degraded = bool(getattr(c, "degraded", False))
    reason = getattr(c, "degraded_reason", None) if degraded else None
    return degraded, reason


def _envelope(data: Any) -> dict[str, Any]:
    """Wrap a successful payload, disclosing staleness if the cache reports
    it (graft A4/C5's tool-facing half — see `_stale_state`)."""
    degraded, reason = _stale_state()
    if not degraded:
        return {"ok": True, "data": data, "error": None}
    if isinstance(data, dict):
        data = {**data, "stale": True}
    else:
        data = {"value": data, "stale": True}
    return {
        "ok": True,
        "data": data,
        "error": {
            "code": "STALE_INDEX",
            "message": reason or "serving last-known-good registry data after a read failure; disclosed, not silently treated as current",
        },
    }


def _invalid(message: str) -> dict[str, Any]:
    return {"ok": False, "data": None, "error": {"code": "INVALID_INPUT", "message": message}}


def _unavailable(message: str) -> dict[str, Any]:
    return {"ok": False, "data": None, "error": {"code": "INDEX_UNAVAILABLE", "message": message}}


def _safe(fn):
    """Applied to every `@mcp.tool()` function (innermost decorator, so
    `functools.wraps` leaves `fn`'s real signature reachable via
    `__wrapped__` for FastMCP's own schema introspection). Converts a
    genuine "cannot read the registry at all" failure into the typed
    `INDEX_UNAVAILABLE` envelope (graft A1) instead of letting it reach the
    stdio transport as an uncaught exception. Never catches anything a tool
    body itself already turns into `_invalid`/`_envelope` — only the class of
    error that means there was nothing to answer from in the first place."""

    @functools.wraps(fn)
    def inner(*args: Any, **kwargs: Any) -> Any:
        try:
            return fn(*args, **kwargs)
        except (FileNotFoundError, OSError, sqlite3.Error) as exc:
            # PERF-2 fix (2026-09-07): `sqlite3.Error` (the base class
            # covering `DatabaseError`/`OperationalError`/etc.) was missing
            # here despite this module's own docstring documenting this
            # decorator as catching every genuine "cannot read the registry
            # at all" failure — a corrupted `mcp/state/index.sqlite3` (bit
            # rot, a killed process mid-write, a bad copy) raised
            # `sqlite3.DatabaseError` straight past this except tuple and
            # out through the bare FastMCP tool-error string, bypassing the
            # `{"ok","data","error"}` envelope entirely for `toledo_search`
            # and — worse — `toledo_index_status`, the one tool this design
            # documents as how to check whether the index is healthy.
            return _unavailable(f"registry could not be read: {exc}")
        except _json.JSONDecodeError as exc:
            return _unavailable(f"registry JSON could not be parsed: {exc}")

    return inner


# ---------------------------------------------------------------------------
# TOON row-list payload shaping (grafts B5/C7) — encoder imported from cli.py
# ---------------------------------------------------------------------------

def _row_payload(rows: list[dict], fmt: str, key: str) -> dict[str, Any]:
    """`{key: rows}` for `fmt="json"`; `{key: None, f"{key}_toon": <str>}`
    for `fmt="toon"` — the two are mutually exclusive in one response so a
    caller never has to guess which is authoritative. The encoder itself
    (`cli.encode_toon`) is imported from `toledo_mcp.cli`, not re-implemented
    here (`mcp/DESIGN.md` sec. 7/14 — "same encoder, imported by server.py
    from cli.py"), so a `toledo_search --format toon` CLI call and a
    `toledo_search(format="toon")` MCP call are byte-identical for the same
    rows."""
    if fmt == "toon":
        return {key: None, f"{key}_toon": cli.encode_toon(rows)}
    return {key: rows}


# ---------------------------------------------------------------------------
# Verdict attachment helpers
# ---------------------------------------------------------------------------

def _resolver():
    c = cache_mod.get_cache()
    c.ensure_fresh()
    reg = c.registry
    return lambda code: reg.by_code.get(code) if reg else None


def _attach_verdict(entry: dict | None) -> dict | None:
    if entry is None:
        return None
    return {"entry": entry, "verdict": verdict.verdict_for_entry(entry, _resolver()).to_dict()}


def _attach_verdict_to_status(entry: dict | None, status_summary: dict | None) -> dict | None:
    if entry is None or status_summary is None:
        return None
    v = verdict.verdict_for_entry(entry, _resolver())
    return {**status_summary, "verdict": v.verdict, "usable": v.usable, "verdict_reason": v.reason, "redirect": v.redirect}


def _verdict_for_row(row: dict) -> dict | None:
    """Compute the SAME verdict `toledo_get(row['code'])` would return,
    looking the full entry up by code (graft B1) — a compact-entry row from
    `core._summarize` does not itself carry `status_note`/`superseded_by`/
    `children`, so this re-fetches the full entry rather than working from
    the row's own (necessarily partial) fields."""
    code = row.get("code")
    if not code:
        return None
    entry = cache_mod.get_cache().get(code)
    if entry is None:
        return None
    return verdict.verdict_for_entry(entry, _resolver()).to_dict()


def _attach_row_verdicts(rows: list[dict]) -> list[dict]:
    return [{**r, "verdict": _verdict_for_row(r)} for r in rows]


_VALID_DOMAINS = {"E", "H", "S", "W", "M", "P", "C", "B"}


# ---------------------------------------------------------------------------
# Tools
# ---------------------------------------------------------------------------

@mcp.tool()
@_safe
def toledo_search(
    query: str = "",
    root: str | None = None,
    domain: str | None = None,
    tier: str | None = None,
    status: str | None = None,
    coq_status: str | None = None,
    regex: bool = False,
    limit: int = 20,
    format: Literal["json", "toon"] = "json",
) -> dict[str, Any]:
    """Search the Toledo registry. FOUNDER RULE: look an equation up here before
    using it; never use an unregistered equation.

    `query` is matched (plain substring by default, or a Python regex if
    `regex=True`) against each entry's code, aliases, name, and statement text
    (whatever its own format — ascii-math, latex, or coq). Leave `query` empty to
    just apply the filters below and list matches in natural code order.

    Optional exact filters: `root` (a Layer-0 code, e.g. "EQ-015"), `domain`
    (one of E H S W M P C B), `tier` (Th_coqc | finite_diagnostic | Dr | Open |
    Definition | Ax | RETRACTED | untagged), `status` (current | superseded_by |
    split | not_an_equation | historical | unverified | imprecise_as_stated),
    `coq_status` (closed | definition | wrapped_related | open_prop |
    not_formalisable | not_yet_formalised | ...).

    Returns `{"ok": true, "data": {"hits": [...]}, "error": null}` — up to
    `limit` compact entries (code/root/domain/name/tier/status/coq_status/
    statement/score, best match first), each carrying its own `verdict` block
    (do not use a hit whose `verdict.usable` is false without following its
    `redirect`). Pass `format="toon"` to get `data.hits_toon` (a TOON-encoded
    string of the same rows) instead of `data.hits` (which is then `null`).

    `limit`: 0 or a missing value means "use the default of 20" (never
    "unlimited" and never "zero results"); negative is a caller error
    (`INVALID_INPUT`). This is the one `limit` rule for every search/list
    tool in this server — see `core.resolve_limit`.
    """
    if limit is not None and limit < 0:
        return _invalid("limit must be >= 0")
    try:
        rows = cache_mod.get_cache().search(
            query, root=root, domain=domain, tier=tier, status=status, coq_status=coq_status, regex=regex, limit=limit,
        )
    except regex_guard.RegexQueryTooLong as exc:
        return _invalid(str(exc))
    except regex_guard.RegexTimeout as exc:
        return _invalid(str(exc))
    rows = _attach_row_verdicts(rows)
    return _envelope(_row_payload(rows, format, "hits"))


@mcp.tool()
@_safe
def toledo_get(code: str) -> dict[str, Any]:
    """Return `{"ok": true, "data": {"entry": <full Toledo entry>, "verdict":
    {...}}, "error": null}` for one exact `code` (e.g. "EQ-015",
    "EQ-015/H.02.v1", "weld/M.01.v1"); `data: null` (still `ok: true` — a
    genuinely-absent code is a normal answer, not a transport error) if that
    code is not registered.

    FOUNDER RULE: read `data.verdict.usable` before using anything from
    `data.entry` — a superseded/split/not-an-equation code returns its data
    for transparency but `usable: false`, with `verdict.redirect` naming the
    code(s) to use instead. A null `data` means this equation is not
    registered at all — call toledo_register_proposal first.
    """
    return _envelope(_attach_verdict(cache_mod.get_cache().get(code)))


@mcp.tool()
@_safe
def toledo_status(code: str) -> dict[str, Any]:
    """Compact status + verdict readout for one `code`: tier, status,
    status_note, coq_status, superseded_by, plus `verdict`/`usable`/
    `verdict_reason`/`redirect` (see toledo_get). `data: null` if `code` is
    not registered — FOUNDER RULE: an unregistered equation must not be used;
    register it first."""
    c = cache_mod.get_cache()
    return _envelope(_attach_verdict_to_status(c.get(code), c.status(code)))


@mcp.tool()
@_safe
def toledo_check(
    formula: str | None = None,
    code: str | None = None,
    limit: int = 5,
    method: Literal["phi", "difflib"] = "phi",
) -> dict[str, Any]:
    """FOUNDER RULE (2026-09-07): call this before using any equation. Pass
    EITHER `code` (you already have a specific Toledo code and want its
    verdict) OR `formula` (a bare statement string to look up) — not both,
    not neither (that call shape is now `{"ok": false, "error":
    {"code": "INVALID_INPUT", ...}}`, graft A1 — previously this returned a
    verdict of AMBIGUOUS for the same malformed input; the call itself being
    malformed and the registry genuinely being ambiguous are now told apart).

    With `code`: looks it up exactly and returns its verdict (same as
    toledo_status, wrapped in this tool's shape for callers that always call
    toledo_check).

    With `formula`: normalises it and searches for a registered match.
    `method="phi"` (default) uses the indexed φ-criterion prefilter
    (equivalence.py: exact / renaming_candidate / positive_scale_candidate /
    structural_candidate — see registry/SCHEMA.md's merge rule);
    `method="difflib"` uses `core.check`'s original whole-registry difflib
    scan (kept for exact compatibility with the first pass of this server;
    slower — see benchmarks/bench_index.py — and does not distinguish
    renaming from positive-scale evidence).

    Returns `{"ok": true, "data": {"verdict", "usable", "reason", "redirect",
    "candidates"}, "error": null}`. `verdict` is one of: REGISTERED_CURRENT |
    REGISTERED_UNVERIFIED | REGISTERED_HISTORICAL | REGISTERED_IMPRECISE |
    REGISTERED_SUPERSEDED | REGISTERED_SPLIT | REGISTERED_NOT_AN_EQUATION |
    CANDIDATE_MATCH | AMBIGUOUS | CAUTION | NOT_REGISTERED (call
    toledo_show_verdict_rules for what each means and what to do about it).
    `usable=false` on anything but a REGISTERED_* current/caveated verdict
    means: do not cite/derive from this — either get a documented
    φ-criterion confirmation for a CANDIDATE_MATCH, follow `redirect` for a
    SUPERSEDED/SPLIT, or call toledo_register_proposal for NOT_REGISTERED.

    `limit`: 0 or missing means "use the default of 5" (same rule as every
    other search/list tool — see toledo_search's docstring / `core.
    resolve_limit`); negative is `INVALID_INPUT`. When `method="difflib"`
    finds two or more DIFFERENT codes tied at the top similarity score, the
    verdict is `AMBIGUOUS` (not a blindly-picked single code) and `reason`
    lists every tied code — see toledo_show_verdict_rules.
    """
    if bool(formula) == bool(code):
        return _invalid("pass exactly one of `formula` or `code`, not both and not neither.")
    if limit is not None and limit < 0:
        return _invalid("limit must be >= 0")

    c = cache_mod.get_cache()
    c.ensure_fresh()
    if code:
        entry = c.get(code)
        return _envelope(verdict.verdict_for_check(entry, [], _resolver()).to_dict())

    if method == "difflib":
        result = core.check(c.registry, formula, limit=limit)
        if result["verdict"] == "registered":
            # R3-1 fix (2026-09-07): this branch used to map straight to
            # REGISTERED_CURRENT/usable=True off `core.check`'s bare
            # similarity-ratio threshold, with no check of the matched
            # entry's own `status` — the same status-blind bug as the
            # `method="phi"` exact-match path (fixed in verdict.py), just
            # duplicated here for the difflib path. Resolve the top match's
            # code to its full entry and run it through the SAME
            # status-aware `verdict.verdict_for_entry` a code lookup
            # already goes through, instead of trusting the threshold alone.
            # R3-3 fix (2026-09-07): this branch used to pick `matches[0]`
            # (the difflib scan's own sort order, which breaks ties on code
            # alone) with no check for whether more than one DIFFERENT code
            # tied at that same top similarity — so when the same normalised
            # statement was an equally-good match to two or more registered
            # codes, one was picked blindly and the others silently dropped,
            # even though this exact conflict is already the documented
            # AMBIGUOUS case for the `method="phi"` path just above
            # (`verdict_for_check`'s `tied` check on `kind == "exact"`
            # candidates). Mirror that: collect every match tied with the
            # top similarity score (distinct codes only — repeated
            # occurrences of the same code are not a conflict) and, if more
            # than one, report AMBIGUOUS naming all of them instead of
            # resolving just the first.
            top_score = result["matches"][0]["similarity"] if result["matches"] else None
            tied_codes = sorted({
                m["code"] for m in result["matches"]
                if m.get("similarity") == top_score
            }) if top_score is not None else []
            if len(tied_codes) > 1:
                return _envelope({
                    "verdict": "AMBIGUOUS", "usable": False,
                    "reason": (
                        f"core.check (difflib) found {len(tied_codes)} different codes tied at "
                        f"similarity {top_score} — this statement is registered under several "
                        f"codes: {tied_codes} — escalate to a human, do not pick one."
                    ),
                    "redirect": [], "candidates": result["matches"],
                })
            top_match = result["matches"][0] if result["matches"] else None
            top_code = top_match.get("code") if top_match else None
            matched_entry = c.registry.by_code.get(top_code) if top_code else None
            if matched_entry is None:
                return _envelope({
                    "verdict": "AMBIGUOUS", "usable": False,
                    "reason": (
                        f"core.check (difflib) reported a registered match to {top_code!r} but it "
                        "could not be re-resolved to a full entry — escalate to a human."
                    ),
                    "redirect": [], "candidates": result["matches"],
                })
            v = verdict.verdict_for_entry(matched_entry, _resolver())
            return _envelope({
                "verdict": v.verdict, "usable": v.usable,
                "reason": f"core.check (difflib) best_score={result['best_score']}; {v.reason}",
                "redirect": v.redirect, "candidates": result["matches"],
            })
        # "candidate - confirm" / "not found - must register before use" —
        # neither names a specific matched entry to status-check, so the
        # richer vocabulary's closest non-registered equivalent still applies.
        mapped = {"candidate - confirm": "CANDIDATE_MATCH",
                  "not found - must register before use": "NOT_REGISTERED"}[result["verdict"]]
        return _envelope({
            "verdict": mapped, "usable": False,
            "reason": f"core.check (difflib) best_score={result['best_score']}",
            "redirect": [], "candidates": result["matches"],
        })

    candidates = c.find_equivalence_candidates(formula, limit=limit)
    return _envelope(verdict.verdict_for_check(None, candidates, _resolver()).to_dict())


@mcp.tool()
@_safe
def toledo_lineage(code: str) -> dict[str, Any]:
    """Lineage for one `code`: the root-first ancestry chain to the Genesis
    root, this code's direct children, and every registry/LINEAGE.jsonl event
    (assigned | revised | retired | merged | split | occurrence_added) that
    names this code, either as the event's own code or in its `to` (a single
    code or a list, e.g. a `split` event). `data: null` if `code` is not
    registered. See toledo_ancestors for the full parent-DAG (not just this
    single chain) and toledo_lineage_window to browse the whole log."""
    return _envelope(cache_mod.get_cache().lineage(code))


@mcp.tool()
@_safe
def toledo_ancestors(code: str) -> dict[str, Any]:
    """Every code reachable by following ALL parent edges of `code`
    breadth-first (not only each entry's own parents[0], which is all
    toledo_lineage's `ancestry` and `scripts/toledo ancestry` give you) — the
    complete parent-DAG ancestor set, as `data` (a plain list of code
    strings — these are not full entry rows, so no per-row `verdict` is
    attached; call toledo_get on any one of them for that). `data: null` if
    `code` is not registered."""
    c = cache_mod.get_cache()
    if c.get(code) is None:
        return _envelope(None)
    return _envelope(c.full_ancestors(code))


@mcp.tool()
@_safe
def toledo_descendants(code: str, format: Literal["json", "toon"] = "json") -> dict[str, Any]:
    """Every code reachable by following children[] edges from `code`
    breadth-first (compact entries, each with its own `verdict`, best-match
    order = discovery order). `data.items` is `[]` if `code` has no children
    or is not registered. Pass `format="toon"` for `data.items_toon` instead
    (see toledo_search)."""
    rows = _attach_row_verdicts(cache_mod.get_cache().descendants(code))
    return _envelope(_row_payload(rows, format, "items"))


@mcp.tool()
@_safe
def toledo_neighbours(code: str, type: str | None = None) -> dict[str, Any]:
    """Direct parents, children, and relations of `code` — PLUS, unlike
    `scripts/toledo neighbours`, the REVERSE relation edges: every other
    entry whose own relations[] names `code` as its target (relation
    "reverse_relation"). Each item is `{"code", "relation", "note",
    "verdict"}` where `relation` is "parent" | "child" | one of
    registry/SCHEMA.md's relation types (reads | refines | supersedes |
    same_form_different_theory | special_case_of) | "reverse_relation".
    `verdict` is attached ONLY on "parent"/"child" rows (graft B1 — these
    name a registered entry the same way toledo_get's result does); a
    relation/reverse_relation row's `verdict` is `null` since it is a
    cross-link annotation, not itself a citable entry. Pass `type` to filter
    to one kind. Returns `data: {"neighbours": [...]}`."""
    rows = cache_mod.get_cache().neighbours(code, rel_type=type)
    out = []
    for r in rows:
        v = _verdict_for_row(r) if r.get("relation") in ("parent", "child") else None
        out.append({**r, "verdict": v})
    return _envelope({"neighbours": out})


@mcp.tool()
@_safe
def toledo_by_root(root: str, limit: int | None = None, format: Literal["json", "toon"] = "json") -> dict[str, Any]:
    """Every code whose `root` field equals `root` (a Layer-0 code, e.g.
    "EQ-015" or "weld"), in natural code order, each with its own `verdict`.
    Returns `data: {"items": [...]}` (or `data.items_toon` — see
    toledo_search).

    `limit`: 0 or missing means this tool's own default, which is genuinely
    uncapped (every matching entry) — negative is `INVALID_INPUT`. See
    toledo_search's docstring / `core.resolve_limit` for the shared rule."""
    if limit is not None and limit < 0:
        return _invalid("limit must be >= 0")
    rows = _attach_row_verdicts(cache_mod.get_cache().by_root(root, limit=limit))
    return _envelope(_row_payload(rows, format, "items"))


@mcp.tool()
@_safe
def toledo_by_domain(domain: str, limit: int | None = None, format: Literal["json", "toon"] = "json") -> dict[str, Any]:
    """Every code whose `domain` field equals `domain` (one of E H S W M P C
    B — see registry/SCHEMA.md), in natural code order, each with its own
    `verdict`. Returns `data: {"items": [...]}` (or `data.items_toon` — see
    toledo_search).

    `limit`: 0 or missing means this tool's own default, which is genuinely
    uncapped (every matching entry) — negative is `INVALID_INPUT`. See
    toledo_search's docstring / `core.resolve_limit` for the shared rule."""
    if domain not in _VALID_DOMAINS:
        return _invalid(f"domain must be one of {sorted(_VALID_DOMAINS)}, got {domain!r}")
    if limit is not None and limit < 0:
        return _invalid("limit must be >= 0")
    rows = _attach_row_verdicts(cache_mod.get_cache().by_domain(domain, limit=limit))
    return _envelope(_row_payload(rows, format, "items"))


@mcp.tool()
@_safe
def toledo_by_record(record_id_or_doi: str, format: Literal["json", "toon"] = "json") -> dict[str, Any]:
    """Every code that occurs in a given source (a Zenodo `record_id` as an
    integer-valued string, e.g. "21529456", or its DOI, e.g.
    "10.5281/zenodo.21529456"), each with its own `verdict`. Returns
    `data: {"items": [...]}` (or `data.items_toon` — see toledo_search)."""
    rows = _attach_row_verdicts(cache_mod.get_cache().by_record(record_id_or_doi))
    return _envelope(_row_payload(rows, format, "items"))


@mcp.tool()
@_safe
def toledo_by_raw_key(raw_key: str) -> dict[str, Any]:
    """Exact lookup by a raw occurrence key (`<record_id>:<label>`, the exact
    key registry/CANONICAL.json's `raw_to_canonical` map uses — e.g.
    "21529456:(1)"). Returns `data: {"entry": ..., "verdict": ...}` (same
    shape as toledo_get) or `data: null` if the raw key does not map to any
    canonical code."""
    return _envelope(_attach_verdict(cache_mod.get_cache().by_raw_key(raw_key)))


@mcp.tool()
@_safe
def toledo_lineage_window(
    event: str | None = None,
    since: str | None = None,
    until: str | None = None,
    limit: int = 50,
    cursor: int = 0,
) -> dict[str, Any]:
    """Paginated browse of the WHOLE registry/LINEAGE.jsonl log (not one
    code — see toledo_lineage for that), newest-appended-first within the
    page. Optional filters: `event` (assigned | revised | retired | merged |
    split | occurrence_added), `since`/`until` (inclusive "YYYY-MM-DD" date
    bounds). Returns `data: {"events": [...], "next_cursor": int|null}` —
    pass `next_cursor` back as `cursor` to continue; null means no more
    pages. Lineage events are log rows, not canonical entries, so no
    `verdict` is attached to them.

    `limit`: 0 or missing means "use the default of 50" — negative is
    `INVALID_INPUT`. See toledo_search's docstring / `core.resolve_limit`
    for the shared rule."""
    if limit is not None and limit < 0:
        return _invalid("limit must be >= 0")
    if cursor is not None and cursor < 0:
        return _invalid("cursor must be >= 0")
    return _envelope(cache_mod.get_cache().lineage_window(event=event, since=since, until=until, limit=limit, cursor=cursor))


@mcp.tool()
@_safe
def toledo_counts() -> dict[str, Any]:
    """Live counts read straight from the cached registry (refreshed
    whenever the underlying files change — never a stale carried-over
    number): canonical_entries, by_status, by_domain, by_tier,
    by_coq_status, lineage_events, genesis_root_rows."""
    return _envelope(cache_mod.get_cache().counts())


@mcp.tool()
@_safe
def toledo_index_status() -> dict[str, Any]:
    """Health/versioning readout for THIS server, not one equation: whether
    the SQLite index is stale relative to registry/CANONICAL.json (and why),
    this build's `index_schema_version`, the source registry's own
    `schema_version` and whether this server recognises it
    (`source_schema_supported`), entry/lineage counts, and a cross-check
    against registry/TOLEDO.json (if present) flagging any divergence — e.g.
    TOLEDO.json not yet regenerated since the last registry edit. Call this
    when a result looks unexpectedly stale or incomplete, or before relying
    on this server for a release-sensitive task."""
    return _envelope(cache_mod.get_cache().index_status())


@mcp.tool()
@_safe
def toledo_show_verdict_rules() -> dict[str, Any]:
    """Introspect the exact verdict decision table this server enforces
    (graft A6) — audit the founder rule ("every equation must be looked up
    in Toledo before use; no agent may use an unregistered equation")
    mechanically, without reading `verdict.py`'s Python source. Returns
    `data: {"statuses": [...known CANONICAL.json status values...],
    "verdict_values": [...all eleven verdict strings this server can
    return...], "rules": [{"when", "verdict", "usable", "note"?}, ...]}` —
    `rules` is the same `verdict.RULES` list `verdict_for_entry` itself walks
    for its simple membership-test branches (the `superseded_by` chain-walk
    and `split`-redirect branches are structural, not table lookups, and are
    called out as such in each rule's own `note`)."""
    return _envelope({
        "statuses": sorted(verdict._KNOWN_STATUSES),
        "verdict_values": list(verdict.VERDICT_VALUES),
        "rules": [dict(r) for r in verdict.RULES],
    })


@mcp.tool()
@_safe
def toledo_lint(statement: str, code: str | None = None) -> dict[str, Any]:
    """TODO IDM-5: continuum-injection lint over a statement (LaTeX/ascii/
    prose), per the `information-discrete-math` skill's contaminated-concept
    -> discrete-replacement table (SKILL.md). Detects classical-continuum
    smuggling — I1 ℝ-completeness/limits-that-land, I2 h→0 infinite
    divisibility, I3 infinite scale separation (Re→∞, Λ→∞), I4 actual +∞;
    Z1 a point of zero extent, Z2 exact-zero spacing, Z3 absolute rest/exact
    vacuum, Z4 the void — plus the classic traps: angle/degree/acos/atan2, a
    coordinate distance √Σ(Δx)², an operator on a continuum (∂²/
    d'Alembertian), ε–δ continuity as primitive, π/e/φ as primitive numbers,
    and trichotomy/LUB.

    `code` is an OPTIONAL Toledo code this statement is being checked for or
    against — purely informational context echoed back in `data.code`; it
    does not change which rules fire.

    **This NEVER blocks (P24: it disciplines, not gates)** — `data.verdict`
    is always exactly one of `"clean"` or `"continuum_injection_warned"`,
    never a usability gate like `verdict.py`'s founder-rule values. Each
    `data.findings[]` entry carries `{"class", "matched_text", "why",
    "discrete_replacement", "toledo_code", "severity": "warn"}` —
    `toledo_code` is resolved at call time against the LIVE registry by
    alias (the IDM ladder root/keystone object that carries the discrete
    replacement, e.g. `R`, `Q`, `D`, `Z`, `L_R`); if that alias is not (yet)
    registered, `toledo_code` fails soft to the literal string
    `"code pending"` rather than fabricating a code.
    """
    return _envelope(lint.lint_statement(statement, code))


# ---------------------------------------------------------------------------
# toledo_eval (21st tool, S4 — docs/EXECUTABLE_EQUATIONS_v0_1.md sec.8)
# ---------------------------------------------------------------------------

def _executable_sidecar_path(code: str, root: pathlib.Path) -> pathlib.Path:
    """`registry/executable/<mangled-code>.json` — reuses
    `export_static.mangle_code` verbatim (registry/SCHEMA.md's own Coq-file
    mangling rule; never a fourth independently-invented scheme — the site's
    api-mangled URLs and the Coq wrapper file names already share this one)."""
    return paths.registry_dir(root) / "executable" / f"{export_static.mangle_code(code)}.json"


def _load_executable_sidecar(code: str) -> dict[str, Any] | None:
    """Reads one IR sidecar straight off disk. S1 (docs/EXECUTABLE_EQUATIONS_
    v0_1.md sec.10) owns writing these files; this is a plain, read-only load
    — the same relationship this server already holds with every other
    registry file. `None` for a missing or unparsable sidecar (this server
    never writes `registry/executable/`), so `toledo_eval` can fail closed
    with "no IR sidecar for this code" rather than raising."""
    p = _executable_sidecar_path(code, paths.repo_root())
    if not p.exists():
        return None
    try:
        with open(p, encoding="utf-8") as fh:
            data = _json.load(fh)
    except (OSError, _json.JSONDecodeError):
        return None
    return data if isinstance(data, dict) else None


_IR_EVAL_PKG_NAME = "_toledo_scripts_executable_for_mcp"

# `scripts/executable/` is CODE shipped alongside this package (like
# `scripts/toledo_build.py`, which `core._toledo_build` resolves the exact
# same way — `pathlib.Path(__file__).resolve().parents[2]`), never registry
# DATA — so it is deliberately NOT resolved via `paths.repo_root()`
# (`TOLEDO_ROOT`-overridable, meant for pointing an isolated test at a
# fixture registry while the server's own code stays the real installed
# tree). Kept as its own constant, computed the same way `core.py`'s
# `REPO_ROOT` is, so the two never silently diverge in what "this repo's
# root" means for locating a checked-in script.
_REPO_ROOT_FOR_SCRIPTS = pathlib.Path(__file__).resolve().parents[2]


def _load_ir_eval():
    """Loads `scripts/executable/ir_eval.py` by file path (matching
    `core.py`'s own established pattern for `scripts/toledo_build.py` — see
    `core._toledo_build`), rather than `from scripts.executable import
    ir_eval` (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.8's own named
    alternative: "or an equivalent local-file import").

    This is not stylistic: on this workstation a pip-installed distribution
    happens to occupy the top-level name `scripts` in `site-packages`, and
    PEP 420 namespace-package resolution means a REGULAR package found
    anywhere on `sys.path` wins over this repository's own `scripts/`
    directory (which carries no `__init__.py`) regardless of import order —
    `import scripts.executable` silently resolves to the wrong distribution
    (or fails outright) rather than this repo's own tree. File-path loading
    sidesteps the collision entirely; `scripts/executable/ir_eval.py`'s own
    `from . import ir_kernel` relative import still resolves correctly
    because the parent package below is registered in `sys.modules` with a
    real `__path__` before `ir_eval` itself is executed.

    Raises `ImportError` (never a bare `FileNotFoundError`/`AttributeError`)
    when `scripts/executable/` is not yet present on this build (S2 has not
    landed it in this checkout) — the caller turns that into `toledo_eval`'s
    own disclosed "runtime not available" reason."""
    if f"{_IR_EVAL_PKG_NAME}.ir_eval" in sys.modules:
        return sys.modules[f"{_IR_EVAL_PKG_NAME}.ir_eval"]

    scripts_executable_dir = _REPO_ROOT_FOR_SCRIPTS / "scripts" / "executable"
    pkg_init = scripts_executable_dir / "__init__.py"
    if not pkg_init.is_file():
        raise ImportError(f"{scripts_executable_dir} not present on this build (scripts/executable/__init__.py missing)")

    if _IR_EVAL_PKG_NAME not in sys.modules:
        pkg_spec = importlib.util.spec_from_file_location(
            _IR_EVAL_PKG_NAME, pkg_init, submodule_search_locations=[str(scripts_executable_dir)],
        )
        if pkg_spec is None or pkg_spec.loader is None:
            raise ImportError(f"cannot load {pkg_init}")
        pkg_mod = importlib.util.module_from_spec(pkg_spec)
        sys.modules[_IR_EVAL_PKG_NAME] = pkg_mod
        pkg_spec.loader.exec_module(pkg_mod)

    mod_path = scripts_executable_dir / "ir_eval.py"
    if not mod_path.is_file():
        raise ImportError(f"{mod_path} not present on this build (S2 has not landed ir_eval.py)")
    full_name = f"{_IR_EVAL_PKG_NAME}.ir_eval"
    spec = importlib.util.spec_from_file_location(full_name, mod_path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {mod_path}")
    mod = importlib.util.module_from_spec(spec)
    mod.__package__ = _IR_EVAL_PKG_NAME
    sys.modules[full_name] = mod
    spec.loader.exec_module(mod)
    return mod


def _decimal_display(value_str: str, digits: int = 24) -> str:
    """Decimal string, DISPLAY ONLY — the MCP-side mirror of `site/static/
    js/_qfrac.js`'s `toDecimalString` (docs/EXECUTABLE_EQUATIONS_v0_1.md
    sec.5's "the one place a floating-point-shaped string is ever produced,
    and it is never fed back into a comparison"). This is a presentational
    helper owned by this tool's own response shaping, not part of the
    Fraction-only reference kernel (`ir_kernel.py`/`ir_eval.py`, S2) — it
    never participates in `toledo_eval`'s own evaluation or in any
    cross-check comparison."""
    try:
        frac = Fraction(value_str)
    except (ValueError, ZeroDivisionError):
        return value_str
    ctx = decimal.Context(prec=digits + 12)
    d = ctx.divide(decimal.Decimal(frac.numerator), decimal.Decimal(frac.denominator))
    text = format(d, f".{digits}f")
    if "." in text:
        text = text.rstrip("0").rstrip(".")
    return text or "0"


@mcp.tool()
@_safe
def toledo_eval(code: str, inputs: dict[str, str]) -> dict[str, Any]:
    """Evaluate one reviewed-eligible executable equation at declared rational inputs.

    Fail-closed for any code with no IR sidecar, or whose sidecar status is not
    "reviewed_eligible"/"built": returns {"evaluable": false, "code": ..., "reason": "..."}
    rather than raising or guessing. `inputs` values MUST be strings ("3", "22/7") —
    a JSON/float number is rejected, never silently coerced, so no floating value ever
    crosses into the evaluator.

    Reuses `scripts/executable/ir_eval.py` — the SAME in-process evaluator the site
    widget's build step and the cross-check runner both call — never a second,
    parallel interpretation of the same IR (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.4/
    sec.13 item 4). A live `toledo_eval` result carries the identical "not a
    Reproduction Card" caveat the site widget shows (sec.7) and is never itself
    written into any resistance/reproduction record.

    Success: `data = {"evaluable": true, "code", "value": "<exact rational string>",
    "approx_display": "<decimal string, captioned display-only>", "terms_used":
    int | null, "error_bound": "<rational string>" | null, "reproduction_card":
    {citation} | null}`.

    Failure: `data = {"evaluable": false, "code", "reason": "no IR sidecar for this
    code" | "sidecar status is 'candidate', not yet human-reviewed" | "sidecar
    status is 'reviewed_rejected': <review_note>" | "<input name> could not be
    parsed as an exact rational" | "executable reference runtime is not available
    on this build: <detail>"}` — the last reason fires when `scripts/executable/
    ir_eval.py` (S2's own deliverable) is not yet importable in this checkout;
    it is disclosed honestly rather than treated as "code not registered".
    """
    if not isinstance(inputs, dict):
        return _invalid("inputs must be a JSON object of {variable_name: exact-rational-string}")
    for name, value in inputs.items():
        if not isinstance(value, str):
            return _envelope({
                "evaluable": False, "code": code,
                "reason": (
                    f"{name!r} could not be parsed as an exact rational "
                    '(inputs must be strings, e.g. "3" or "22/7" — a JSON/float '
                    "number is rejected, never silently coerced)"
                ),
            })

    sidecar = _load_executable_sidecar(code)
    if sidecar is None:
        return _envelope({"evaluable": False, "code": code, "reason": "no IR sidecar for this code"})

    status = sidecar.get("status")
    if status == "candidate":
        return _envelope({
            "evaluable": False, "code": code,
            "reason": "sidecar status is 'candidate', not yet human-reviewed",
        })
    if status == "reviewed_rejected":
        note = ((sidecar.get("eligibility") or {}).get("review_note") or "").strip()
        return _envelope({
            "evaluable": False, "code": code,
            "reason": f"sidecar status is 'reviewed_rejected': {note}",
        })
    if status not in ("reviewed_eligible", "built"):
        return _envelope({
            "evaluable": False, "code": code,
            "reason": f"sidecar status is {status!r}, not evaluable",
        })

    try:
        ir_eval = _load_ir_eval()  # S2-owned shared evaluator, loaded by file path — see _load_ir_eval's docstring
    except ImportError as exc:
        return _envelope({
            "evaluable": False, "code": code,
            "reason": f"executable reference runtime is not available on this build: {exc}",
        })

    try:
        result = ir_eval.evaluate(sidecar, inputs)
    except Exception as exc:  # noqa: BLE001 — ir_eval's own contract: a
        # malformed rational string, or a domain violation (e.g. dividing by
        # a variable whose stated domain excludes zero), raises; this is the
        # one place that exception becomes toledo_eval's typed fail-closed
        # shape instead of an uncaught error reaching the stdio transport (a
        # genuine "cannot read the registry at all" failure still escapes to
        # `_safe` above, unchanged).
        return _envelope({"evaluable": False, "code": code, "reason": str(exc)})

    value = result.get("value") if isinstance(result, dict) else None
    # The reproduction-card citation is an optional annotation on an
    # otherwise-complete evaluation — a registry read failure here (e.g. no
    # `registry/CANONICAL.json` in an isolated test checkout) must never
    # turn a genuinely successful `ir_eval.evaluate` result into a hard
    # error; it degrades to `reproduction_card: None` instead.
    try:
        entry = cache_mod.get_cache().get(code)
    except (FileNotFoundError, OSError, _json.JSONDecodeError):
        entry = None
    reproduction_card = (entry.get("executable") or {}).get("reproduction_card") if entry else None
    return _envelope({
        "evaluable": True,
        "code": code,
        "value": value,
        "approx_display": _decimal_display(value) if value is not None else None,
        "terms_used": result.get("terms_used") if isinstance(result, dict) else None,
        "error_bound": result.get("error_bound") if isinstance(result, dict) else None,
        "reproduction_card": reproduction_card,
    })


@mcp.tool()
@_safe
def toledo_register_proposal(fields: dict[str, Any]) -> dict[str, Any]:
    """Register a proposal for a NEW or CORRECTED equation entry. FOUNDER
    RULE: call this whenever toledo_check/toledo_search finds no registered
    match (verdict NOT_REGISTERED, or CANDIDATE_MATCH without a confirmed φ)
    for an equation you need — do not use an unregistered equation.

    Writes a SCHEMA.md-shaped JSON file under `mcp/proposals/` (moved from
    `registry/proposals/`, graft C4 — see proposals.py) for a human
    registrar to review and merge, and records a PENDING row in
    `mcp/proposals/STATUS.jsonl` (see toledo_proposal_status). It NEVER
    writes registry/CANONICAL.json, registry/genesis_root.json, or
    registry/LINEAGE.jsonl directly, and the formula is NOT registered until
    a registrar merges it — toledo_check/toledo_status will keep returning
    NOT_REGISTERED/null for it until then.

    `fields` should carry as many registry/SCHEMA.md entry fields as you
    have: at minimum `name` and `statement`; ideally also `code` (only if
    confident of the correct code per docs/EQ_CODE_SCHEME.md — otherwise
    leave it out for the registrar to assign), `parents`, `origin`, `tier`,
    `occurrences`. Returns `data: {"path", "slug", "submitted_at"}`.
    """
    if not isinstance(fields, dict):
        return _invalid("fields must be a JSON object of registry/SCHEMA.md entry fields")
    cache_mod.get_cache().ensure_fresh()  # validate the registry loads before writing anything
    root = paths.repo_root()
    result = proposals.write_proposal(fields, root=root)
    proposals.record_submitted(result["path"], result["slug"], result["submitted_at"], root=root)
    return _envelope(result)


@mcp.tool()
@_safe
def toledo_list_proposals(status: str | None = None, limit: int = 50) -> dict[str, Any]:
    """List submitted proposals (`mcp/proposals/*.json`), newest first.
    Optional `status` filter: PENDING | ACCEPTED | REJECTED | SUPERSEDED.
    Returns `data: {"items": [{"path", "status", "submitted_at", "code",
    "name"}, ...]}` — these are proposal-queue rows, not registered Toledo
    entries, so no `verdict` is attached (an un-merged proposal is, by
    definition, NOT_REGISTERED).

    `limit`: 0 or missing means "use the default of 50" — negative is
    `INVALID_INPUT`. See toledo_search's docstring / `core.resolve_limit`
    for the shared rule."""
    if limit is not None and limit < 0:
        return _invalid("limit must be >= 0")
    rows = proposals.list_proposals(status=status, limit=limit, root=paths.repo_root())
    return _envelope({"items": rows})


@mcp.tool()
@_safe
def toledo_proposal_status(path: str) -> dict[str, Any]:
    """Full proposal document plus its current lifecycle status, for the
    exact `path` a toledo_register_proposal/toledo_list_proposals call
    returned. `data: null` if `path` is not a file under `mcp/proposals/`."""
    return _envelope(proposals.get_proposal(path, root=paths.repo_root()))


def main() -> None:
    mcp.run("stdio")


if __name__ == "__main__":
    main()
