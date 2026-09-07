"""toledo_mcp.core — pure functions over the Toledo registry files.

Founder ruling, 2026-09-07: every equation must be looked up in Toledo before an
agent uses it; no agent may use an unregistered equation. This module is the
reusable engine behind that rule: it reads `registry/CANONICAL.json` +
`registry/genesis_root.json` + `registry/LINEAGE.jsonl`, and reuses
`scripts/toledo_build.py`'s own root+reading merge (`build_entries`) so its view
of "what is registered" never drifts from what `make build` also produces.

This module never writes to `registry/CANONICAL.json`, `registry/genesis_root.json`
or `registry/LINEAGE.jsonl`, and never touches `coq/` or `latex/`. The only write
it performs is `register_proposal`, which drops a JSON file under
`mcp/proposals/` (`paths.proposals_dir()`; moved from `registry/proposals/` per
mcp/DESIGN.md sec. 6, graft C4 — `proposals.py`'s reader was repointed in the
same coordinated change) for a human registrar to review and merge by hand — it
does not itself add anything to the canonical registry.

Every function here takes a `Registry` (see `load_registry`) and is otherwise a
pure function of its arguments, so both `server.py` (the MCP tools) and
`scripts/toledo` (the existing CLI) can call the same engine without duplicating
the merge/search/scoring logic.

`load_registry` retries a transient `JSONDecodeError` with backoff (mcp/DESIGN.md
sec. 4, grafts A4/C5) before giving up, since `registry/CANONICAL.json` is a live,
concurrently-edited file — a read landing mid-write is a real, observed condition
in this workspace, not a hypothetical one. A caller that already holds a
previously-loaded `Registry` and wants to keep serving it rather than raising when
every retry is exhausted is `cache.RegistryCache.ensure_fresh`, which wraps this
function and adds the stale-with-disclosure fallback.
"""
from __future__ import annotations

import collections
import copy
import datetime
import difflib
import importlib.util
import json
import os
import pathlib
import re
import sys
import time
import unicodedata
from dataclasses import dataclass, field
from typing import Any

from . import regex_guard

REPO_ROOT = pathlib.Path(__file__).resolve().parents[2]
REGISTRY_DIR = REPO_ROOT / "registry"
SCRIPTS_DIR = REPO_ROOT / "scripts"

_TB_MODULE_NAME = "_toledo_build_for_mcp"


def _toledo_build():
    """Import scripts/toledo_build.py by file path (it is a repo script, not an
    installed package) so this module reuses its exact CANONICAL.json +
    genesis_root.json merge (`build_entries`, `load_canonical`, `load_json`)
    instead of re-implementing that merge and risking it drift out of sync."""
    if _TB_MODULE_NAME in sys.modules:
        return sys.modules[_TB_MODULE_NAME]
    path = SCRIPTS_DIR / "toledo_build.py"
    spec = importlib.util.spec_from_file_location(_TB_MODULE_NAME, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    mod = importlib.util.module_from_spec(spec)
    sys.modules[_TB_MODULE_NAME] = mod
    spec.loader.exec_module(mod)
    return mod


# ---------------------------------------------------------------------------
# Loading
# ---------------------------------------------------------------------------

@dataclass
class Registry:
    """A read-only, in-memory view of the Toledo registry at load time."""

    entries: list[dict]
    by_code: dict[str, dict]
    raw_to_canonical: dict[str, str]
    canonical_doc: dict
    genesis_doc: dict | None
    lineage_events: list[dict]
    repo_root: pathlib.Path = field(default_factory=lambda: REPO_ROOT)


def load_lineage(path: pathlib.Path) -> list[dict]:
    events: list[dict] = []
    if not path.exists():
        return events
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            events.append(json.loads(line))
    return events


def _normalise_genesis_parents(genesis_doc: dict | None) -> dict | None:
    """Defensive shape tolerance for `genesis_root.json`'s `parents[]` (graft
    B4). Every row's `parents[]` is a bare code string in every live
    `genesis_root.json` checked so far (confirmed 2026-09-07, 764/764 entries
    across 592 rows — see mcp/DESIGN.md sec. 0), but
    `scripts/toledo_build.py`'s `genesis_row_to_canonical` — owned by the
    registry-building lane, never edited by this package — only handles that
    bare-string shape: `[{"code": p, "derived_via": row.get("derived_via")}
    for p in row["parents"]]` assigns the *whole* element to `"code"`, so a
    future root-extension edit that writes a `{"code": ..., "derived_via":
    ...}` object per parent (matching `CANONICAL.json`'s own `parents[]`
    shape) instead of a string would silently produce a dict where a code
    string belongs, not raise. Since this package cannot change
    `toledo_build.py` itself, this normalises any dict-shaped parent back
    down to its bare code string BEFORE the document reaches
    `build_entries`/`genesis_row_to_canonical` — both shapes are tolerated
    without touching the file this package must never edit. A no-op today
    (every input is already all-strings); see
    `tests/test_core.py::test_genesis_parents_tolerates_string_and_object_shape`
    for the case this guards."""
    if not genesis_doc:
        return genesis_doc
    doc = copy.deepcopy(genesis_doc)
    for row in doc.get("root_equations", []) or []:
        parents = row.get("parents")
        if not parents:
            continue
        row["parents"] = [(p.get("code") if isinstance(p, dict) else p) for p in parents]
    return doc


def _load_once(root: pathlib.Path) -> Registry:
    reg_dir = root / "registry"
    tb = _toledo_build()
    canonical_path = reg_dir / "CANONICAL.json"
    if not canonical_path.exists():
        # PERF-3 fix (2026-09-07): `scripts/toledo_build.py`'s own
        # `load_canonical` treats a missing CANONICAL.json as its own
        # legitimate "first bootstrap, build from genesis roots alone" case
        # and returns an empty canonical set rather than raising — correct
        # for that build script's own purpose, but wrong for this server:
        # docs/DESIGN.md documents that a missing CANONICAL.json must
        # surface as a genuine "nothing to serve" error (`FileNotFoundError`
        # naming the exact missing path), not a misleadingly empty result
        # set indistinguishable from "the registry legitimately has zero
        # matches for this query" — exactly the deployment mistake (a
        # misconfigured TOLEDO_ROOT, an un-populated registry checkout) this
        # founder-mandated lookup gate most needs to fail loud on, not quiet.
        raise FileNotFoundError(
            f"registry/CANONICAL.json not found under {root} "
            "(check TOLEDO_ROOT and that the registry has been populated)"
        )
    canonical_doc = tb.load_canonical(canonical_path)
    genesis_path = reg_dir / "genesis_root.json"
    genesis_doc = tb.load_json(genesis_path) if genesis_path.exists() else None
    genesis_doc = _normalise_genesis_parents(genesis_doc)
    entries, raw_to_canonical = tb.build_entries(canonical_doc, genesis_doc)
    by_code = {e["code"]: e for e in entries}
    lineage_events = load_lineage(reg_dir / "LINEAGE.jsonl")
    return Registry(
        entries=entries,
        by_code=by_code,
        raw_to_canonical=raw_to_canonical,
        canonical_doc=canonical_doc,
        genesis_doc=genesis_doc,
        lineage_events=lineage_events,
        repo_root=root,
    )


def load_registry(
    repo_root: pathlib.Path | None = None,
    *,
    retries: int = 3,
    backoff_base_seconds: float = 0.05,
) -> Registry:
    """Read CANONICAL.json + genesis_root.json + LINEAGE.jsonl fresh from disk
    and return the merged, read-only view every tool in this module operates on.
    Cheap enough (registry is a few MB of JSON) to call once per tool call — this
    module never caches, so it always reflects the live files on disk.

    Retries a `JSONDecodeError` up to `retries` times with exponential backoff
    (`backoff_base_seconds * 2**attempt`) before letting it propagate (graft
    A4/C5, mcp/DESIGN.md sec. 4) — the registry is a live, concurrently-edited
    artifact (confirmed, not hypothetical: `registry/CANONICAL.json`,
    `registry/genesis_root.json` and `registry/LINEAGE.jsonl` were all modified
    by the registry-owning lane while this module was being written), so a read
    landing mid-write is a real, reachable condition, not an edge case. Raises
    the final `JSONDecodeError` if every attempt fails — the caller (typically
    `cache.RegistryCache.ensure_fresh`) decides whether to fall back to a
    previously-loaded `Registry` or report `INDEX_UNAVAILABLE`."""
    root = repo_root or REPO_ROOT
    last_exc: json.JSONDecodeError | None = None
    for attempt in range(retries):
        try:
            return _load_once(root)
        except json.JSONDecodeError as exc:
            last_exc = exc
            if attempt == retries - 1:
                raise
            time.sleep(backoff_base_seconds * (2 ** attempt))
    raise last_exc  # pragma: no cover — unreachable (loop above always returns or raises)


# ---------------------------------------------------------------------------
# `limit` semantics — one definition, every search/list tool and CLI mirror
# ---------------------------------------------------------------------------

def resolve_limit(limit: int | None, default: int | None) -> int | None:
    """Canonical `limit` semantics for every search/list function in this
    package (residual review finding, 2026-09-07: "a zero limit is silently
    treated as unlimited or as empty in different places"). Confirmed true
    before this fix: `core.search`/`queries.search`/`cache.by_root`/
    `cache.by_domain` all used `if limit: ... [:limit]` — a falsy `0` skipped
    the slice entirely, i.e. "unlimited" — while `core.check`'s
    `scored[:limit]` and `equivalence.find_candidates`/`find_candidates_
    indexed`'s `out[:limit]` sliced a bare `0` straight through to an empty
    list, i.e. "nothing". Two different, silently-coexisting readings of the
    same input, in the same package, across sibling functions a caller has
    every reason to expect behave alike.

    The one rule, from here on, for every caller of this function: a missing
    (``None``) or explicit ``0`` limit means "use this call's own stated
    default" — never "unlimited" and never "empty". A negative limit is
    always a caller error (raises ``ValueError``); the MCP tool boundary in
    `server.py` already rejects a negative limit before it ever reaches this
    function (returning the typed `INVALID_INPUT` envelope instead), but the
    `toledo` CLI (`cli.py`) does not pre-validate, so it lets this
    ``ValueError`` propagate to its own top-level error handling.

    A function whose own default behaviour is genuinely uncapped — `by_root`/
    `by_domain`, whose parameter default is `None`, not a number, because
    "every matching entry, no default cap" is the documented contract — calls
    this with `default=None`. `0`/`None` then both still resolve to `None`
    ("no cap"), which is already the correct, pre-existing behaviour for
    those two; this function only changes behaviour where a function's real
    default is a finite number (`search`'s 20, `check`'s 5,
    `find_candidates`'s 5, `list_proposals`'s 50, `lineage_window`'s 50)."""
    if limit is None or limit == 0:
        return default
    if limit < 0:
        raise ValueError("limit must be >= 0")
    return limit


# ---------------------------------------------------------------------------
# Natural code sort
# ---------------------------------------------------------------------------

_NUM_RE = re.compile(r"(\d+)")


def natural_sort_key(code: str) -> list:
    """Sort codes the way a person reads them: EQ-2 before EQ-10, H.02 before
    H.117 — digits compared as integers, everything else as lowercase text."""
    return [int(part) if part.isdigit() else part.lower() for part in _NUM_RE.split(code or "")]


def sort_codes(entries: list[dict]) -> list[dict]:
    return sorted(entries, key=lambda e: natural_sort_key(e.get("code", "")))


# ---------------------------------------------------------------------------
# Search
# ---------------------------------------------------------------------------

def _summarize(e: dict, score: float | None = None) -> dict:
    stmt = (e.get("statement") or {}).get("latest", "")
    out = {
        "code": e.get("code"),
        "root": e.get("root"),
        "layer": e.get("layer"),
        "domain": e.get("domain"),
        "name": e.get("name"),
        "tier": e.get("tier"),
        "status": e.get("status"),
        "coq_status": (e.get("coq") or {}).get("coq_status"),
        "statement": stmt,
    }
    if score is not None:
        out["score"] = round(score, 3)
    return out


def _score_entry(e: dict, needle_l: str) -> float:
    """Simple weighted substring scoring over code / aliases / name / statement.
    Not a ranking of an equation's standing — only of how well the query text
    matches this entry's own recorded fields."""
    if not needle_l:
        return 0.0
    score = 0.0
    code_l = (e.get("code") or "").lower()
    if code_l == needle_l:
        score += 100.0
    elif needle_l in code_l:
        score += 40.0

    for alias in e.get("aliases") or []:
        alias_l = (alias or "").lower()
        if not alias_l:
            continue
        if alias_l == needle_l:
            score += 60.0
        elif needle_l in alias_l:
            score += 20.0

    name_l = (e.get("name") or "").lower()
    if needle_l in name_l:
        score += 15.0

    stmt_l = ((e.get("statement") or {}).get("latest") or "").lower()
    if needle_l in stmt_l:
        score += 10.0

    for occ in e.get("occurrences") or []:
        label_l = (occ.get("label") or "").lower()
        if label_l and needle_l in label_l:
            score += 5.0
            break

    return score


def search(
    reg: Registry,
    query: str = "",
    *,
    root: str | None = None,
    domain: str | None = None,
    tier: str | None = None,
    status: str | None = None,
    coq_status: str | None = None,
    regex: bool = False,
    limit: int = 20,
) -> list[dict]:
    """Text search over code / aliases / name / statement (latest text, whatever
    its own `format` — ascii-math, latex, or coq), with optional exact filters on
    root / domain / tier / status / coq_status. Empty `query` with filters returns
    every matching entry in natural code order.

    `limit`: 0 or missing means "use the default of 20" (never "unlimited"),
    negative raises `ValueError` — see `resolve_limit`."""
    limit = resolve_limit(limit, 20)
    candidates = reg.entries
    if root:
        candidates = [e for e in candidates if e.get("root") == root]
    if domain:
        candidates = [e for e in candidates if e.get("domain") == domain]
    if tier:
        candidates = [e for e in candidates if e.get("tier") == tier]
    if status:
        candidates = [e for e in candidates if e.get("status") == status]
    if coq_status:
        candidates = [e for e in candidates if (e.get("coq") or {}).get("coq_status") == coq_status]

    if not query:
        ranked = [(0.0, e) for e in sort_codes(candidates)]
    elif regex:
        # SEC-1 fix (2026-09-07): see queries.search's identical guard for
        # the full reasoning — an agent-supplied, uncapped regex compiled
        # and run against uncapped registry text can backtrack
        # exponentially and hang the calling process. Reject an over-long
        # pattern up front and bound every per-entry `.search()` call to a
        # hard wall-clock budget.
        regex_guard.check_regex_query_length(query)
        pattern = re.compile(query, re.IGNORECASE)
        ranked = []
        for e in candidates:
            haystack = " ".join(filter(None, [
                e.get("code", ""),
                e.get("name", ""),
                (e.get("statement") or {}).get("latest", ""),
                " ".join(e.get("aliases") or []),
            ]))
            if regex_guard.safe_search(pattern, haystack):
                ranked.append((1.0, e))
        ranked.sort(key=lambda t: natural_sort_key(t[1].get("code", "")))
    else:
        needle_l = query.lower().strip()
        scored = []
        for e in candidates:
            s = _score_entry(e, needle_l)
            if s > 0:
                scored.append((s, e))
        scored.sort(key=lambda t: (-t[0], natural_sort_key(t[1].get("code", ""))))
        ranked = scored

    ranked = ranked[:limit]
    return [_summarize(e, score=(s if query and not regex else None)) for s, e in ranked]


# ---------------------------------------------------------------------------
# Get / lineage / status
# ---------------------------------------------------------------------------

def get(reg: Registry, code: str) -> dict | None:
    """Full generated entry for one code, or None if the code is not registered."""
    e = reg.by_code.get(code)
    return dict(e) if e is not None else None


def ancestry_chain(reg: Registry, code: str) -> list[str]:
    """Root-first chain of codes from the Genesis root down to `code` (its own
    parents[0] each step — the same single-parent-chain convention as
    `scripts/toledo ancestry`)."""
    chain = [code]
    seen = {code}
    cur = code
    while True:
        e = reg.by_code.get(cur)
        if not e or not e.get("parents"):
            break
        nxt = e["parents"][0]["code"]
        if nxt in seen:
            break
        chain.append(nxt)
        seen.add(nxt)
        cur = nxt
    return list(reversed(chain))


def children_of(reg: Registry, code: str) -> list[str]:
    e = reg.by_code.get(code)
    return list(e.get("children", [])) if e else []


def lineage(reg: Registry, code: str) -> dict | None:
    """Ancestry chain to the Genesis root, direct children, and every
    LINEAGE.jsonl event touching this code (as the event's own `code`, or named
    in a `to` list/string of an assigned/revised/retired/merged/split event)."""
    if code not in reg.by_code:
        return None
    events = []
    for ev in reg.lineage_events:
        if ev.get("code") == code:
            events.append(ev)
            continue
        to = ev.get("to")
        to_list = to if isinstance(to, list) else ([to] if to else [])
        if code in to_list:
            events.append(ev)
    return {
        "code": code,
        "ancestry": ancestry_chain(reg, code),
        "children": children_of(reg, code),
        "events": events,
    }


def status(reg: Registry, code: str) -> dict | None:
    """Compact tier/status/coq_status/superseded_by readout for one code."""
    e = reg.by_code.get(code)
    if e is None:
        return None
    coq = e.get("coq") or {}
    return {
        "code": e.get("code"),
        "tier": e.get("tier"),
        "status": e.get("status"),
        "status_note": e.get("status_note") or None,
        "coq_status": coq.get("coq_status"),
        "superseded_by": e.get("superseded_by"),
    }


# ---------------------------------------------------------------------------
# Formula normalisation + check
# ---------------------------------------------------------------------------

# (pattern, replacement) — a LaTeX pattern always starts with a literal
# backslash and is applied as a regex; anything else is a plain substring
# replacement. Order matters only where one spelling is a substring of
# another's LaTeX command name, which none of these are.
_SYMBOL_EQUIV: list[tuple[str, str]] = [
    (r"\\cdot", "*"), ("·", "*"), ("∙", "*"), ("×", "*"), (r"\\times", "*"),
    (r"\\partial", "d"), ("∂", "d"),
    (r"\\nabla", "grad"), ("∇", "grad"),
    (r"\\infty", "infinity"), ("∞", "infinity"),
    (r"\\pm", "+-"), ("±", "+-"),
    (r"\\neq", "!="), ("≠", "!="),
    (r"\\geq", ">="), ("≥", ">="),
    (r"\\leq", "<="), ("≤", "<="),
    (r"\\rightarrow", "->"), (r"\\to", "->"), ("→", "->"),
    (r"\\exists", "exists"), ("∃", "exists"),
    (r"\\forall", "forall"), ("∀", "forall"),
    (r"\\in", " in "), ("∈", " in "),
    (r"\\sum", "sum"), ("∑", "sum"),
    (r"\\int", "integral"), ("∫", "integral"),
    (r"\\sqrt", "sqrt"), ("√", "sqrt"),
    (r"\\vdash", "|-"), ("⊢", "|-"),
    ("≡", "=="), ("≈", "~="),
    (r"\\lambda", "lambda"), ("λ", "lambda"),
    (r"\\Lambda", "Lambda"), ("Λ", "Lambda"),
    (r"\\delta", "delta"), ("δ", "delta"),
    (r"\\Delta", "Delta"), ("Δ", "Delta"),
    (r"\\eta", "eta"), ("η", "eta"),
    (r"\\theta", "theta"), ("θ", "theta"),
    (r"\\Theta", "Theta"), ("Θ", "Theta"),
    (r"\\Phi", "Phi"), ("Φ", "Phi"),
    (r"\\phi", "phi"), ("φ", "phi"),
    (r"\\pi", "pi"), ("π", "pi"),
    (r"\\alpha", "alpha"), ("α", "alpha"),
    (r"\\beta", "beta"), ("β", "beta"),
    (r"\\gamma", "gamma"), ("γ", "gamma"),
    (r"\\Gamma", "Gamma"), ("Γ", "Gamma"),
    (r"\\mu", "mu"), ("μ", "mu"),
    (r"\\sigma", "sigma"), ("σ", "sigma"),
    (r"\\tau", "tau"), ("τ", "tau"),
    (r"\\chi", "chi"), ("χ", "chi"),
    ("²", "^2"), ("³", "^3"),
    ("₀", "_0"), ("₁", "_1"), ("₂", "_2"), ("₃", "_3"), ("ₙ", "_n"),
]


def normalise_formula(text: str | None) -> str:
    """Normalise a formula string for comparison only (never rewrites the
    registry): NFKC unicode fold, unify common ascii/unicode/LaTeX spellings of
    the same symbol to one token each, collapse whitespace, lowercase."""
    if not text:
        return ""
    s = unicodedata.normalize("NFKC", text)
    for pattern, repl in _SYMBOL_EQUIV:
        if pattern.startswith("\\"):
            s = re.sub(pattern, repl, s)
        else:
            s = s.replace(pattern, repl)
    s = re.sub(r"\s+", " ", s).strip().lower()
    return s


def check(reg: Registry, formula: str, limit: int = 5) -> dict:
    """Founder rule (2026-09-07): every equation must be looked up here before an
    agent uses it. Normalises `formula` and compares it against every registered
    statement (root + reading layers), returning the closest entries with a
    similarity score and one of three verdicts:

    - "registered" — a very close/exact match exists; cite that code, do not
      restate or re-derive the formula.
    - "candidate - confirm" — a plausible near match exists but is not exact;
      confirm against the listed code(s) before citing it as the same object.
    - "not found - must register before use" — no close match; call
      `register_proposal` and get it merged before this formula is used.

    `limit`: 0 or missing means "use the default of 5" (never "empty" — a
    bare `scored[:limit]` used to silently return zero matches for
    `limit=0`, the opposite mistake from `search`'s "unlimited" reading of
    the same input; see `resolve_limit`), negative raises `ValueError`.
    """
    limit = resolve_limit(limit, 5)
    needle = normalise_formula(formula)
    scored: list[tuple[float, dict]] = []
    for e in reg.entries:
        stmt = (e.get("statement") or {}).get("latest", "")
        cand = normalise_formula(stmt)
        if not cand:
            continue
        ratio = difflib.SequenceMatcher(None, needle, cand).ratio()
        if needle and needle == cand:
            ratio = 1.0
        elif needle and len(needle) >= 4 and (needle in cand or cand in needle):
            ratio = max(ratio, 0.9)
        if ratio <= 0:
            continue
        scored.append((ratio, e))
    scored.sort(key=lambda t: (-t[0], natural_sort_key(t[1].get("code", ""))))
    top = scored[:limit]
    best = top[0][0] if top else 0.0

    if best >= 0.85:
        verdict = "registered"
    elif best >= 0.5:
        verdict = "candidate - confirm"
    else:
        verdict = "not found - must register before use"

    return {
        "verdict": verdict,
        "best_score": round(best, 3),
        "matches": [{**_summarize(e), "similarity": round(s, 3)} for s, e in top],
    }


# ---------------------------------------------------------------------------
# Counts
# ---------------------------------------------------------------------------

def counts(reg: Registry) -> dict:
    """Live counts read straight from the loaded files — never a carried-over
    number from a prior note (see the honest-state discipline in README.md).

    `canonical_entries`/`by_status`/`by_domain`/`by_tier`/`by_coq_status` are
    computed over `layer != "root"` entries ONLY (counts-mismatch fix,
    2026-09-07) — i.e. exactly `registry/CANONICAL.json`'s own `canonical[]`
    array, matching that file's own live `counts{}` field field-for-field.
    `reg.entries` also carries the genesis-root-only rows the merged search
    corpus needs (this module's own root+reading merge, reused so search/
    get/ancestry never drift from what `make build` also produces) —
    counting those alongside real canonical entries previously polluted
    every breakdown here with placeholder values no canonical entry
    actually carries (`by_domain[None]`, `by_tier["RETRACTED"]` not among
    registry/SCHEMA.md's tiers, `by_coq_status["not_yet_formalised"]`) and
    inflated `canonical_entries` itself well past the registry's own true
    count. The merged total is still exposed, under its own unambiguous
    key, as `merged_search_entries` — never overloading `canonical_entries`
    with it again."""
    entries = [e for e in reg.entries if e.get("layer") != "root"]
    genesis_rows = len((reg.genesis_doc or {}).get("root_equations", [])) if reg.genesis_doc else 0
    return {
        "canonical_entries": len(entries),
        "merged_search_entries": len(reg.entries),
        "by_status": dict(collections.Counter(e.get("status") for e in entries)),
        "by_domain": dict(collections.Counter(e.get("domain") for e in entries)),
        "by_tier": dict(collections.Counter(e.get("tier") for e in entries)),
        "by_coq_status": dict(collections.Counter((e.get("coq") or {}).get("coq_status") for e in entries)),
        "lineage_events": len(reg.lineage_events),
        "genesis_root_rows": genesis_rows,
    }


# ---------------------------------------------------------------------------
# Register proposal (the only write path in this module)
# ---------------------------------------------------------------------------

_SLUG_RE = re.compile(r"[^a-z0-9]+")


def slugify(text: str | None) -> str:
    s = _SLUG_RE.sub("-", (text or "").lower()).strip("-")
    return s or "proposal"


def _write_new_proposal_file(pdir: pathlib.Path, ts: str, slug: str, doc: dict) -> pathlib.Path:
    """Write `doc` as JSON to a file under `pdir` named from `ts`/`slug`,
    NEVER overwriting an existing file (SEC-2 fix, 2026-09-07): `ts` has
    one-second resolution and `slug` is agent-supplied, so two independent
    proposals for the same code submitted within the same wall-clock
    second — a realistic race, not a contrived one, since the founder rule
    this module enforces is designed to make many independent agents each
    individually discover the same unregistered code and race to propose it
    — used to collide on the exact same filename; a plain `open(path, "w")`
    then silently truncated whichever proposal wrote second, destroying the
    first with no exception, no warning, and no trace in `STATUS.jsonl`
    (which records path/status/date, not content).

    Uses `os.O_CREAT | os.O_EXCL` so "does this name already exist" and
    "create it" are one atomic OS call, not a check-then-write race of this
    function's own; on `FileExistsError` it retries with a disambiguating
    numeric suffix (`{ts}_{slug}-1.json`, `-2.json`, ...) until an exclusive
    create succeeds, so two same-second, same-code proposals always land in
    two distinct files, both visible to the human registrar untouched."""
    attempt = 0
    while True:
        name = f"{ts}_{slug}.json" if attempt == 0 else f"{ts}_{slug}-{attempt}.json"
        candidate = pdir / name
        try:
            fd = os.open(str(candidate), os.O_CREAT | os.O_EXCL | os.O_WRONLY, 0o644)
        except FileExistsError:
            attempt += 1
            continue
        with os.fdopen(fd, "w", encoding="utf-8") as fh:
            json.dump(doc, fh, indent=2, ensure_ascii=False)
            fh.write("\n")
        return candidate


def register_proposal(fields: dict[str, Any], *, repo_root: pathlib.Path | None = None) -> dict:
    """Write a SCHEMA.md-shaped registration proposal to `mcp/proposals/` for
    a human registrar to review and merge (mcp/DESIGN.md sec. 6, graft C4 —
    moved from `registry/proposals/`, since that path sits inside the exact
    top-level directory this package must never write into: even though
    `proposals/` itself was never one of the protected files, a reader of
    "never edit registry/*" could not tell that at a glance). This is the
    ONLY write this module ever performs — it never touches
    registry/CANONICAL.json, registry/genesis_root.json or
    registry/LINEAGE.jsonl directly. `fields` should carry as many SCHEMA.md
    entry fields as the caller has (code/name/statement/parents/origin/tier/...);
    anything omitted is left for the registrar to fill in.

    The formula this proposes is NOT registered until a registrar merges it —
    `toledo_check`/`toledo_status` will keep returning "not found" for it until
    then, and no agent should use it as if it were already in the library.
    """
    from . import paths as _paths  # local import: avoids a hard cycle at module load time

    root = repo_root or REPO_ROOT
    proposals_dir = _paths.proposals_dir(root)
    proposals_dir.mkdir(parents=True, exist_ok=True)
    ts = datetime.datetime.now(datetime.timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    slug = slugify(fields.get("code") or fields.get("name"))
    doc = {
        "proposal": fields,
        "note": (
            "This is a PROPOSAL, not a registered Toledo entry. A registrar reviews "
            "it against registry/SCHEMA.md and merges it into registry/CANONICAL.json "
            "by hand; this file itself is never read by the CLI, this MCP server, or "
            "any agent as if it were already registered. Do not use this formula "
            "until it is merged and a toledo_status lookup on its code returns it."
        ),
        "submitted_at": ts,
    }
    out_path = _write_new_proposal_file(proposals_dir, ts, slug, doc)
    try:
        rel = str(out_path.relative_to(root))
    except ValueError:
        rel = str(out_path)
    return {"path": rel, "slug": slug, "submitted_at": ts}
