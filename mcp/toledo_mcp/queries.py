"""Indexed read queries over the SQLite database `index.py` builds.

The single biggest cost this module removes relative to `core.py`'s
per-call `core.load_registry()` is not algorithmic (most of `core`'s
per-entry lookups — `get`, `status` — are already O(1) dict lookups once
loaded); it is that `core.load_registry()` re-reads and re-parses
`registry/CANONICAL.json` (multi-megabyte JSON) and re-runs the full
root-merge/children-inversion **on every single tool call**, with no
caching at all. `IndexHandle` below holds one sqlite3 connection across many
calls and only pays a rebuild when the source files actually changed
(`index.needs_rebuild`, a cheap stat comparison) — see
`benchmarks/bench_index.py` for the measured difference.

The second cost this module removes is real algorithmic complexity for the
handful of operations `core.py` implements as an O(n) or O(n·m) scan over
every entry on every call: `search` (text scan), `check`/equivalence
candidate lookup (scans every statement), `lineage` (scans all
`LINEAGE.jsonl` events), and `by-record` (scans every entry's occurrences).
Each becomes an indexed lookup here (FTS5 for text, dedicated tables for
root/domain/record/lineage-by-code).

Every function takes an open `sqlite3.Connection` (row_factory=sqlite3.Row)
and returns plain dicts/lists — JSON-serializable as-is, matching the shapes
`core.py`'s equivalent functions already return so `server.py`'s tool bodies
can switch their data source without changing a tool's external JSON shape.
"""
from __future__ import annotations

import json
import re
import sqlite3
from dataclasses import dataclass

from . import core
from . import index as index_mod
from . import paths
from . import regex_guard

_NUM_RE = re.compile(r"(\d+)")


def natural_sort_key(code: str) -> list:
    return [int(part) if part.isdigit() else part.lower() for part in _NUM_RE.split(code or "")]


def _row_to_entry(row: sqlite3.Row) -> dict:
    return json.loads(row["raw_json"])


def _summarize(row: sqlite3.Row, score: float | None = None) -> dict:
    out = {
        "code": row["code"],
        "root": row["root"],
        "layer": row["layer"],
        "domain": row["domain"],
        "name": row["name"],
        "tier": row["tier"],
        "status": row["status"],
        "coq_status": row["coq_status"],
        "statement": row["statement"],
    }
    if score is not None:
        out["score"] = round(score, 3)
    return out


# ---------------------------------------------------------------------------
# Handle: one connection, reopened only when the source files actually change
# ---------------------------------------------------------------------------

@dataclass
class IndexHandle:
    root: object
    conn: sqlite3.Connection | None = None

    @classmethod
    def open(cls, root=None):
        root = root or paths.repo_root()
        h = cls(root=root)
        h.ensure_fresh()
        return h

    def ensure_fresh(self) -> bool:
        """Reopen the connection if the index is missing/stale. Returns True
        if a rebuild happened."""
        if self.conn is not None and not index_mod.needs_rebuild(self.root):
            return False
        if self.conn is not None:
            self.conn.close()
        self.conn = index_mod.get_connection(self.root, auto_build=True)
        return True

    def close(self):
        if self.conn is not None:
            self.conn.close()
            self.conn = None


# ---------------------------------------------------------------------------
# Filters shared by search/by_root/by_domain
# ---------------------------------------------------------------------------

_FILTER_COLUMNS = {"root": "root", "domain": "domain", "tier": "tier", "status": "status", "coq_status": "coq_status"}


def _apply_filters(where: list[str], params: list, **filters):
    for key, col in _FILTER_COLUMNS.items():
        val = filters.get(key)
        if val:
            where.append(f"{col} = ?")
            params.append(val)


# ---------------------------------------------------------------------------
# search
# ---------------------------------------------------------------------------

_FTS_TOKEN_RE = re.compile(r"[A-Za-z0-9]+")


def _fts_query(text: str) -> str | None:
    """Build an FTS5 MATCH expression that behaves like a prefix search over
    each alnum token in `text`. Returns None if `text` tokenizes to nothing
    usable (symbol-heavy math text — e.g. "δ_R", "∂/∂t" — falls through to
    the LIKE-based path in `search`, since FTS5's unicode61 tokenizer drops
    most math symbols and would silently match nothing or everything).

    Tokens shorter than 3 characters are dropped before building the MATCH
    expression (search-relevance fix, 2026-09-07): a symbol-heavy query like
    "δ_R" tokenizes (after every Greek/math character is stripped by
    `_FTS_TOKEN_RE`) to the single one-character token "R", which FTS5 then
    runs as a near-universal `"R"*` prefix scan — pulling dozens of
    unrelated entries into the ranking ahead of the entry the symbol
    actually names. Dropping such fragments falls through to the
    substring/alias path below instead, which matches against the
    unstripped, unicode-preserving `statement_norm`/`alias_norm` columns."""
    tokens = [t for t in _FTS_TOKEN_RE.findall(text) if len(t) >= 3]
    if not tokens:
        return None
    return " ".join(f'"{t}"*' for t in tokens)


def search(
    conn: sqlite3.Connection,
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
    """`limit`: 0 or missing means "use the default of 20" (never
    "unlimited"), negative raises `ValueError` — see `core.resolve_limit`."""
    limit = core.resolve_limit(limit, 20)
    where: list[str] = []
    params: list = []
    _apply_filters(where, params, root=root, domain=domain, tier=tier, status=status, coq_status=coq_status)
    where_sql = (" AND " + " AND ".join(where)) if where else ""

    if not query:
        sql = f"SELECT * FROM entries WHERE 1=1{where_sql}"
        rows = conn.execute(sql, params).fetchall()
        rows.sort(key=lambda r: natural_sort_key(r["code"]))
        return [_summarize(r) for r in rows[:limit]]

    if regex:
        # SEC-1 fix (2026-09-07): `query` here is an agent-supplied regex,
        # exposed directly over the shared stdio MCP server this founder
        # rule depends on. An uncapped pattern compiled with `re` and run
        # against an uncapped haystack can backtrack exponentially (e.g.
        # `"(.*)+ZZZ_NOT_PRESENT"` against any sufficiently long real
        # statement — several exist in this registry); because FastMCP calls
        # a sync tool function directly inside the asyncio event loop, one
        # hung regex call blocks the ENTIRE process for every other caller,
        # including the founder-mandated lookup gate itself. Reject an
        # over-long pattern up front, then bound every per-row `.search()`
        # call to a hard wall-clock budget so a pathological pattern that
        # slips past the length cap still fails fast instead of hanging.
        regex_guard.check_regex_query_length(query)
        sql = f"SELECT * FROM entries WHERE 1=1{where_sql}"
        rows = conn.execute(sql, params).fetchall()
        pattern = re.compile(query, re.IGNORECASE)
        hits = []
        for r in rows:
            aliases = " ".join(a["alias"] for a in conn.execute("SELECT alias FROM aliases WHERE code=?", (r["code"],)))
            haystack = " ".join(filter(None, [r["code"], r["name"], r["statement"], aliases]))
            if regex_guard.safe_search(pattern, haystack):
                hits.append(r)
        hits.sort(key=lambda r: natural_sort_key(r["code"]))
        return [_summarize(r) for r in hits[:limit]]

    # Primary path: FTS5 MATCH (indexed, ranked by bm25) for alnum-tokenizable queries.
    fts_expr = _fts_query(query)
    scored: dict[str, float] = {}
    if fts_expr:
        fts_sql = (
            "SELECT e.*, bm25(entries_fts) AS rank FROM entries_fts f "
            "JOIN entries e ON e.code = f.code "
            f"WHERE f MATCH ?{where_sql} ORDER BY rank LIMIT ?"
        )
        try:
            rows = conn.execute(fts_sql, [fts_expr, *params, max(limit * 4, 100)]).fetchall()
            for r in rows:
                scored[r["code"]] = -r["rank"]  # bm25: lower is better; flip sign so higher score = better
        except sqlite3.OperationalError:
            rows = []
    # Fallback / supplement: exact/substring match on normalized columns —
    # catches symbol-heavy math text (e.g. "δ_R") FTS5's tokenizer would
    # miss (or that `_fts_query` now drops as too-short-to-tokenize, see
    # above), and anything FTS ranked zero hits for.
    #
    # Graduated scoring (search-relevance fix, 2026-09-07) mirrors
    # `core._score_entry`'s weights: an exact code/alias match must outrank
    # a mere substring match, which must outrank an incidental name/
    # statement hit. The previous version awarded every matching column the
    # same flat +1.0 bonus regardless of exactness, so an exact match (e.g.
    # a bare root code, or a symbol verbatim from one entry's own statement)
    # could tie with a dozen other entries that only happened to contain the
    # same substring elsewhere, and then lose the tie purely to alphabetical
    # sort order — exactly the failure this rewrite closes.
    needle_norm = index_mod.normalize_text(query)
    if needle_norm:
        like = f"%{needle_norm}%"

        def _bonus(code: str, amount: float) -> None:
            scored[code] = scored.get(code, 0.0) + amount

        for r in conn.execute(f"SELECT code FROM entries WHERE lower(code) = ?{where_sql}", [needle_norm, *params]):
            _bonus(r["code"], 100.0)
        for r in conn.execute(
            f"SELECT code FROM entries WHERE lower(code) LIKE ? AND lower(code) != ?{where_sql}",
            [like, needle_norm, *params],
        ):
            _bonus(r["code"], 40.0)
        for r in conn.execute("SELECT DISTINCT code FROM aliases WHERE alias_norm = ?", (needle_norm,)):
            _bonus(r["code"], 60.0)
        for r in conn.execute(
            "SELECT DISTINCT code FROM aliases WHERE alias_norm LIKE ? AND alias_norm != ?", (like, needle_norm)
        ):
            _bonus(r["code"], 20.0)
        for r in conn.execute(f"SELECT code FROM entries WHERE name_norm LIKE ?{where_sql}", [like, *params]):
            _bonus(r["code"], 15.0)
        for r in conn.execute(f"SELECT code FROM entries WHERE statement_norm LIKE ?{where_sql}", [like, *params]):
            _bonus(r["code"], 10.0)

    if not scored:
        return []
    codes = list(scored.keys())
    placeholders = ",".join("?" * len(codes))
    all_rows = {r["code"]: r for r in conn.execute(f"SELECT * FROM entries WHERE code IN ({placeholders})", codes)}
    # re-apply filters to the LIKE/alias supplement (FTS branch already filtered in SQL)
    def _passes(r):
        if root and r["root"] != root:
            return False
        if domain and r["domain"] != domain:
            return False
        if tier and r["tier"] != tier:
            return False
        if status and r["status"] != status:
            return False
        if coq_status and r["coq_status"] != coq_status:
            return False
        return True

    ranked = sorted(
        (c for c in codes if c in all_rows and _passes(all_rows[c])),
        key=lambda c: (-scored[c], natural_sort_key(c)),
    )
    ranked = ranked[:limit]
    return [_summarize(all_rows[c], score=scored[c]) for c in ranked]


# ---------------------------------------------------------------------------
# get / status
# ---------------------------------------------------------------------------

def get(conn: sqlite3.Connection, code: str) -> dict | None:
    row = conn.execute("SELECT raw_json FROM entries WHERE code=?", (code,)).fetchone()
    return _row_to_entry(row) if row else None


def status(conn: sqlite3.Connection, code: str) -> dict | None:
    row = conn.execute(
        "SELECT code, tier, status, status_note, coq_status, superseded_by FROM entries WHERE code=?", (code,)
    ).fetchone()
    if not row:
        return None
    return {
        "code": row["code"], "tier": row["tier"], "status": row["status"],
        "status_note": row["status_note"] or None, "coq_status": row["coq_status"],
        "superseded_by": row["superseded_by"],
    }


def by_root(conn: sqlite3.Connection, root_code: str, limit: int | None = None) -> list[dict]:
    """`limit`: 0 or missing means "this tool's own default", which for
    `by_root` is genuinely uncapped (every matching entry) — see
    `core.resolve_limit(limit, default=None)`."""
    limit = core.resolve_limit(limit, None)
    rows = conn.execute("SELECT * FROM entries WHERE root=? ORDER BY code", (root_code,)).fetchall()
    rows = sorted(rows, key=lambda r: natural_sort_key(r["code"]))
    if limit:
        rows = rows[:limit]
    return [_summarize(r) for r in rows]


def by_domain(conn: sqlite3.Connection, domain: str, limit: int | None = None) -> list[dict]:
    """`limit`: 0 or missing means uncapped, same as `by_root` — see
    `core.resolve_limit`."""
    limit = core.resolve_limit(limit, None)
    rows = conn.execute("SELECT * FROM entries WHERE domain=?", (domain,)).fetchall()
    rows = sorted(rows, key=lambda r: natural_sort_key(r["code"]))
    if limit:
        rows = rows[:limit]
    return [_summarize(r) for r in rows]


def by_record(conn: sqlite3.Connection, record_id_or_doi: str) -> list[dict]:
    rows = conn.execute(
        "SELECT DISTINCT e.* FROM occurrences o JOIN entries e ON e.code=o.code "
        "WHERE CAST(o.record_id AS TEXT)=? OR o.doi=? ORDER BY e.code",
        (str(record_id_or_doi), str(record_id_or_doi)),
    ).fetchall()
    rows = sorted(rows, key=lambda r: natural_sort_key(r["code"]))
    return [_summarize(r) for r in rows]


def by_raw_key(conn: sqlite3.Connection, raw_key: str) -> dict | None:
    row = conn.execute("SELECT code FROM raw_to_canonical WHERE raw_key=?", (raw_key,)).fetchone()
    if not row:
        return None
    return get(conn, row["code"])


# ---------------------------------------------------------------------------
# graph: ancestry / descendants / neighbours
# ---------------------------------------------------------------------------

def ancestry_chain(conn: sqlite3.Connection, code: str) -> list[str]:
    """Root-first single chain via each code's own parents[0] (the same
    convention `scripts/toledo ancestry` and `core.ancestry_chain` use) —
    kept for output-shape compatibility. See `full_ancestors` for the
    complete-DAG version this package adds."""
    chain = [code]
    seen = {code}
    cur = code
    while True:
        row = conn.execute(
            "SELECT parent_code FROM parents WHERE code=? ORDER BY ord LIMIT 1", (cur,)
        ).fetchone()
        if not row:
            break
        nxt = row["parent_code"]
        if nxt in seen:
            break
        chain.append(nxt)
        seen.add(nxt)
        cur = nxt
    return list(reversed(chain))


def full_ancestors(conn: sqlite3.Connection, code: str) -> list[str]:
    """Every code reachable by following ALL parent edges (not only
    parents[0]) breadth-first — the complete-DAG ancestor set. A code with
    more than one parent (a reading citing `reads_also`, or a merge) has
    ancestors this misses under the single-chain convention above; this is
    the "registry as data" completion of it."""
    seen = {code}
    frontier = [code]
    out: list[str] = []
    while frontier:
        cur = frontier.pop(0)
        for row in conn.execute("SELECT parent_code FROM parents WHERE code=? ORDER BY ord", (cur,)):
            p = row["parent_code"]
            if p not in seen:
                seen.add(p)
                out.append(p)
                frontier.append(p)
    return out


def descendants(conn: sqlite3.Connection, code: str) -> list[dict]:
    seen = {code}
    frontier = [code]
    out_codes: list[str] = []
    while frontier:
        cur = frontier.pop(0)
        for row in conn.execute("SELECT child_code FROM children WHERE code=?", (cur,)):
            c = row["child_code"]
            if c not in seen:
                seen.add(c)
                out_codes.append(c)
                frontier.append(c)
    if not out_codes:
        return []
    placeholders = ",".join("?" * len(out_codes))
    rows = {r["code"]: r for r in conn.execute(f"SELECT * FROM entries WHERE code IN ({placeholders})", out_codes)}
    return [_summarize(rows[c]) for c in out_codes if c in rows]


def neighbours(conn: sqlite3.Connection, code: str, rel_type: str | None = None) -> list[dict]:
    """Direct parents, children AND relations — plus, unlike
    `scripts/toledo neighbours`, the REVERSE relation edges (every other
    entry whose `relations[]` names this code as its `target`), found via
    `idx_relations_target` in O(matching) instead of a whole-registry scan."""
    out = []
    if not rel_type or rel_type == "parent":
        for row in conn.execute("SELECT parent_code, derived_via FROM parents WHERE code=? ORDER BY ord", (code,)):
            out.append({"code": row["parent_code"], "relation": "parent", "note": row["derived_via"] or ""})
    if not rel_type or rel_type == "child":
        for row in conn.execute("SELECT child_code FROM children WHERE code=?", (code,)):
            out.append({"code": row["child_code"], "relation": "child", "note": ""})
    for row in conn.execute("SELECT target, type, note FROM relations WHERE code=? ORDER BY ord", (code,)):
        if not rel_type or rel_type == row["type"]:
            out.append({"code": row["target"], "relation": row["type"], "note": row["note"] or ""})
    for row in conn.execute("SELECT code AS src, note FROM relations WHERE target=?", (code,)):
        rel = f"reverse_relation"
        if not rel_type or rel_type == rel:
            out.append({"code": row["src"], "relation": rel, "note": row["note"] or ""})
    return out


# ---------------------------------------------------------------------------
# lineage
# ---------------------------------------------------------------------------

def lineage_for_code(conn: sqlite3.Connection, code: str) -> dict | None:
    exists = conn.execute("SELECT 1 FROM entries WHERE code=?", (code,)).fetchone()
    if not exists:
        return None
    events = [
        json.loads(r["raw_json"])
        for r in conn.execute(
            "SELECT DISTINCT l.seq, l.raw_json FROM lineage l "
            "LEFT JOIN lineage_targets t ON t.seq = l.seq "
            "WHERE l.code = ? OR t.code = ? ORDER BY l.seq",
            (code, code),
        )
    ]
    child_rows = [r["child_code"] for r in conn.execute("SELECT child_code FROM children WHERE code=?", (code,))]
    return {"code": code, "ancestry": ancestry_chain(conn, code), "children": child_rows, "events": events}


def lineage_window(
    conn: sqlite3.Connection,
    *,
    event: str | None = None,
    since: str | None = None,
    until: str | None = None,
    limit: int = 50,
    cursor: int = 0,
) -> dict:
    """Paginated browse over the whole LINEAGE.jsonl, newest-appended-first
    (by `seq`, LINEAGE.jsonl's own append order) — for "what changed
    recently" without pulling all 2000+ events, a capability neither the CLI
    nor the baseline MCP spike exposes today.

    `limit`: 0 or missing means "use the default of 50" (never "empty" — a
    bare `limit=0` used to fetch a single row via `LIMIT limit+1=1`, then
    slice it away with `rows[:0]`, silently returning zero events with a
    wrong `next_cursor`; see `core.resolve_limit`), negative raises
    `ValueError`."""
    limit = core.resolve_limit(limit, 50)
    where = []
    params: list = []
    if event:
        where.append("event = ?")
        params.append(event)
    if since:
        where.append("date >= ?")
        params.append(since)
    if until:
        where.append("date <= ?")
        params.append(until)
    where.append("seq >= ?")
    params.append(cursor)
    where_sql = " AND ".join(where)
    sql = f"SELECT seq, raw_json FROM lineage WHERE {where_sql} ORDER BY seq LIMIT ?"
    rows = conn.execute(sql, [*params, limit + 1]).fetchall()
    has_more = len(rows) > limit
    rows = rows[:limit]
    return {
        "events": [json.loads(r["raw_json"]) for r in rows],
        "next_cursor": rows[-1]["seq"] + 1 if (rows and has_more) else None,
    }


# ---------------------------------------------------------------------------
# counts
# ---------------------------------------------------------------------------

def counts(conn: sqlite3.Connection) -> dict:
    """Live aggregate counts. `canonical_entries`/`by_status`/`by_domain`/
    `by_tier`/`by_coq_status` are computed over `layer != 'root'` rows ONLY
    (counts-mismatch fix, 2026-09-07) — i.e. exactly `registry/CANONICAL.json`'s
    own `canonical[]` array, matching that file's own live `counts{}` field
    field-for-field. The `entries` table also carries the 592 genesis-root-
    only rows the merged search corpus needs (`core.load_registry`'s
    root+reading merge, reused so search/get/ancestry never drift from what
    `make build` also produces) — counting those alongside real canonical
    entries previously polluted every breakdown here with placeholder values
    no canonical entry actually carries (`by_domain['null']`,
    `by_tier['RETRACTED']` not among registry/SCHEMA.md's tiers,
    `by_coq_status['not_yet_formalised']`) and inflated `canonical_entries`
    itself (1,504 vs. the registry's own true 912, on the corpus this fix
    was verified against). The merged total is still exposed, under its own
    unambiguous key, as `merged_search_entries` — never overloading
    `canonical_entries` with it again."""

    def _group(col: str) -> dict:
        return {
            r[col]: r["n"]
            for r in conn.execute(f"SELECT {col}, COUNT(*) AS n FROM entries WHERE layer != 'root' GROUP BY {col}")
        }

    total = conn.execute("SELECT COUNT(*) AS n FROM entries WHERE layer != 'root'").fetchone()["n"]
    merged_total = conn.execute("SELECT COUNT(*) AS n FROM entries").fetchone()["n"]
    lineage_n = conn.execute("SELECT COUNT(*) AS n FROM lineage").fetchone()["n"]
    genesis_n = conn.execute("SELECT COUNT(*) AS n FROM entries WHERE layer='root'").fetchone()["n"]
    return {
        "canonical_entries": total,
        "merged_search_entries": merged_total,
        "by_status": _group("status"),
        "by_domain": _group("domain"),
        "by_tier": _group("tier"),
        "by_coq_status": _group("coq_status"),
        "lineage_events": lineage_n,
        "genesis_root_rows": genesis_n,
    }
