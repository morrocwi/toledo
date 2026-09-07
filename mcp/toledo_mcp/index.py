"""SQLite (+ FTS5) search index built ON TOP OF `toledo_mcp.core.load_registry`.

Design note (why this sits on `core.load_registry`, not on its own file
reads): a baseline spike already landed in this package as `core.py` +
`server.py` before this module was finished. Its `load_registry()` re-reads
`registry/CANONICAL.json` + `registry/genesis_root.json` fresh on every call
and re-runs `scripts/toledo_build.py`'s own `build_entries` merge (imported by
file path, not re-implemented) — which is exactly right for correctness
(children[] arrives already computed by that same function, root rows are
already merged in, and it can never drift from what `make build` also
produces) but does an O(n) re-parse of a multi-megabyte JSON document plus an
O(n) linear scan per search/check call, with no persistence.

This module's job is narrowly: take the `core.Registry` `core.load_registry()`
already builds correctly, and materialize it once into a SQLite database with
an FTS5 full-text index, so repeated lookups (search, get, lineage, ancestry/
descendant graph walks, by-root/by-domain/by-record listing) are indexed
instead of linearly scanned, without re-implementing `core`'s loading or
merge logic a second time. `queries.py` reads this database; `equivalence.py`
extends `core.normalise_formula`'s symbol table with the scale/renaming
detection the φ-criterion needs beyond exact-string comparison.

Invalidation is against the three files `core.load_registry` itself reads
(`registry/CANONICAL.json`, `registry/genesis_root.json`,
`registry/LINEAGE.jsonl`) — NOT against `registry/TOLEDO.json` (an earlier
draft of this module indexed TOLEDO.json instead; that draft is kept only as
`docs/DESIGN.md`'s discussion of the option, not as code, because indexing
CANONICAL.json/genesis_root.json directly means this index is never stale
relative to a registry edit that `make build` hasn't picked up yet, matching
`core.load_registry`'s own "always live" property; `TOLEDO.json` is still
useful corroboration and this module cross-checks against it when present —
see `cross_check_toledo_json`).

Two-tier invalidation for latency: a cheap `os.stat` (size + mtime_ns)
comparison runs before every tool call (`needs_rebuild`); a full sha256
(`hashing.py`) is computed once at build time and stored in `meta`, available
to the `status` tool and a `--strict-hash` CLI flag, but not recomputed on
every call.
"""
from __future__ import annotations

import dataclasses
import json
import os
import pathlib
import sqlite3
import tempfile
import time
import unicodedata

from . import paths
from .hashing import file_fingerprint, sha256_file

INDEX_SCHEMA_VERSION = "2"  # bumped from the TOLEDO.json-sourced draft (see module docstring)

# registry/CANONICAL.json `schema_version` values this build of index.py is
# known to understand (registry/SCHEMA.md is currently at "1.0.0"). A version
# not in this set does NOT block the build (failing closed on every registry
# format bump would make this server brittle against a trivial, additive
# schema change) — it is recorded in `meta` and surfaced by
# `cache.RegistryCache.index_status` / the `toledo_index_status` tool instead,
# so a human decides whether an unrecognised bump is safe to keep serving
# against, rather than the server silently assuming it is.
SUPPORTED_CANONICAL_SCHEMA_VERSIONS = {"1.0.0"}

SOURCE_FILES = ("canonical_json", "genesis_root_json", "lineage_jsonl")

_DDL = """
PRAGMA journal_mode = WAL;

CREATE TABLE meta (
    key   TEXT PRIMARY KEY,
    value TEXT
);

CREATE TABLE entries (
    code              TEXT PRIMARY KEY,
    id                TEXT,
    root              TEXT,
    layer             TEXT,
    domain            TEXT,
    name              TEXT,
    statement         TEXT,
    statement_format  TEXT,
    statement_norm    TEXT,
    phi_len           INTEGER,
    name_norm         TEXT,
    tier              TEXT,
    tier_verbatim     TEXT,
    status            TEXT,
    status_note       TEXT,
    superseded_by     TEXT,
    role              TEXT,
    first_assigned    TEXT,
    owner_year        TEXT,
    drift_note        TEXT,
    coq_status        TEXT,
    coq_file          TEXT,
    coq_assumptions   TEXT,
    origin_source     TEXT,
    origin_repo       TEXT,
    origin_commit     TEXT,
    record_id         INTEGER,
    doi               TEXT,
    raw_json          TEXT NOT NULL
);
CREATE INDEX idx_entries_root ON entries(root);
CREATE INDEX idx_entries_domain ON entries(domain);
CREATE INDEX idx_entries_status ON entries(status);
CREATE INDEX idx_entries_layer ON entries(layer);
CREATE INDEX idx_entries_tier ON entries(tier);
CREATE INDEX idx_entries_coq_status ON entries(coq_status);
CREATE INDEX idx_entries_statement_norm ON entries(statement_norm);
CREATE INDEX idx_entries_phi_len ON entries(phi_len);
CREATE INDEX idx_entries_name_norm ON entries(name_norm);

CREATE TABLE aliases (
    code       TEXT NOT NULL,
    alias      TEXT NOT NULL,
    alias_norm TEXT NOT NULL,
    PRIMARY KEY (code, alias)
);
CREATE INDEX idx_aliases_alias ON aliases(alias);
CREATE INDEX idx_aliases_norm ON aliases(alias_norm);

CREATE TABLE parents (
    code        TEXT NOT NULL,
    parent_code TEXT NOT NULL,
    derived_via TEXT,
    ord         INTEGER NOT NULL,
    PRIMARY KEY (code, parent_code)
);
CREATE INDEX idx_parents_parent ON parents(parent_code);

CREATE TABLE children (
    code       TEXT NOT NULL,
    child_code TEXT NOT NULL,
    PRIMARY KEY (code, child_code)
);
CREATE INDEX idx_children_child ON children(child_code);

CREATE TABLE relations (
    code   TEXT NOT NULL,
    target TEXT NOT NULL,
    type   TEXT,
    note   TEXT,
    ord    INTEGER NOT NULL
);
CREATE INDEX idx_relations_code ON relations(code);
CREATE INDEX idx_relations_target ON relations(target);

CREATE TABLE occurrences (
    code      TEXT NOT NULL,
    record_id INTEGER,
    doi       TEXT,
    label     TEXT,
    section   TEXT,
    raw_key   TEXT,
    ord       INTEGER NOT NULL
);
CREATE INDEX idx_occurrences_code ON occurrences(code);
CREATE INDEX idx_occurrences_record ON occurrences(record_id);
CREATE INDEX idx_occurrences_doi ON occurrences(doi);
CREATE INDEX idx_occurrences_raw_key ON occurrences(raw_key);

CREATE TABLE raw_to_canonical (
    raw_key TEXT PRIMARY KEY,
    code    TEXT NOT NULL
);

CREATE TABLE lineage (
    seq                    INTEGER PRIMARY KEY,
    code                   TEXT,
    date                   TEXT,
    event                  TEXT,
    from_code              TEXT,
    to_code                TEXT,
    reason                 TEXT,
    by                     TEXT,
    phi_criterion_evidence TEXT,
    raw_json               TEXT NOT NULL
);
CREATE INDEX idx_lineage_code ON lineage(code);
CREATE INDEX idx_lineage_to ON lineage(to_code);
CREATE INDEX idx_lineage_event ON lineage(event);
CREATE INDEX idx_lineage_date ON lineage(date);

-- One row per (event, target-code) pair, exploding a LINEAGE.jsonl `to`
-- field whether it is a single code string or a list of codes (a `split`
-- event's `to` is a list). `lineage.to_code` keeps the raw display form
-- (a string, or a JSON-encoded list); THIS table is what querying
-- "every event that names code X, as its own code OR as a target" joins
-- against, since a JSON-encoded list column cannot be matched with `=`.
CREATE TABLE lineage_targets (
    seq  INTEGER NOT NULL,
    code TEXT NOT NULL
);
CREATE INDEX idx_lineage_targets_code ON lineage_targets(code);
CREATE INDEX idx_lineage_targets_seq ON lineage_targets(seq);

CREATE VIRTUAL TABLE entries_fts USING fts5(
    code UNINDEXED,
    name,
    statement,
    aliases,
    occurrences_text,
    tokenize = 'unicode61 remove_diacritics 2'
);
"""


def normalize_text(s: str | None) -> str:
    """Shallow normalization for the *_norm index columns and exact/candidate
    matching: NFKC fold, casefold, collapse whitespace. This is NOT the
    φ-criterion (renaming / positive scale / constant substitution) — see
    `equivalence.py` for where that judgment call actually lives and where it
    stops being mechanical."""
    if not s:
        return ""
    s = unicodedata.normalize("NFKC", s)
    s = s.casefold()
    return " ".join(s.split())


@dataclasses.dataclass
class Freshness:
    stale: bool
    reasons: list[str]
    index_exists: bool
    source_entry_count: int | None = None
    built_at: str | None = None


def _fp_key(name: str, suffix: str) -> str:
    return f"{name}_{suffix}"


def _source_paths(root: pathlib.Path) -> dict[str, pathlib.Path]:
    return {
        "canonical_json": paths.canonical_json_path(root),
        "genesis_root_json": paths.genesis_root_json_path(root),
        "lineage_jsonl": paths.lineage_path(root),
    }


def _readonly_connection(db_path: pathlib.Path) -> sqlite3.Connection:
    """Open `db_path` via a `mode=ro` URI (graft C3, mcp/DESIGN.md sec. 4):
    a connection that reads the already-built index is incapable of writing
    by construction, not merely by convention — a stronger, cheaper
    complement to the write-boundary hash-diff test
    (`tests/test_proposals.py::test_register_proposal_writes_file_never_touches_registry`),
    which proves the write boundary at the Python-call level; this proves it
    cannot even be crossed by a bug in a future `queries.py`/`cache.py`
    change. `build_index`'s own writer connection (the atomic
    temp-file-then-`os.replace` build) is unaffected — it legitimately
    writes and keeps its own plain read-write connection."""
    conn = sqlite3.connect(f"file:{db_path}?mode=ro", uri=True)
    conn.row_factory = sqlite3.Row
    return conn


def _load_meta(conn: sqlite3.Connection) -> dict:
    try:
        rows = conn.execute("SELECT key, value FROM meta").fetchall()
    except sqlite3.DatabaseError:
        # PERF-1 fix (2026-09-07): `sqlite3.OperationalError` does not cover
        # a genuinely corrupted database file — a truncated/bit-rotted
        # `index.sqlite3` (the source registry files left completely
        # untouched) raises `sqlite3.DatabaseError` ("database disk image is
        # malformed") directly, which is `OperationalError`'s PARENT class,
        # not a subclass, so the narrower except did not catch it and this
        # exact freshness check crashed instead of self-healing. Catching
        # the broader `DatabaseError` (which still covers every
        # `OperationalError` case this used to handle) makes this return
        # `{}` here, which `check_freshness` already turns into `stale=True`
        # (its fingerprint comparisons see `meta.get(...)` return `None`),
        # which `needs_rebuild`/`cache.RegistryCache.ensure_fresh` already
        # turn into an automatic rebuild from the unaffected source files —
        # no other code path needs to change for this case to self-heal.
        return {}
    return {k: v for k, v in rows}


def check_freshness(root: pathlib.Path | None = None) -> Freshness:
    """Cheap-first (stat-only) check of whether the index needs rebuilding:
    compares size+mtime_ns of CANONICAL.json, genesis_root.json and
    LINEAGE.jsonl against what was recorded in `meta` at the last build.

    MCP cold-start prebuilt-index fix (DEBT #48, 2026-09-07, lane E): a stat
    mismatch alone no longer condemns the index to a rebuild. A release zip
    ships `mcp/state/index.sqlite3` already built at packaging time (see
    `mcp/scripts/build_index.py`); unpacking/cloning it onto a different
    machine, or simply `git`-checking it out, gives every source registry
    file a FRESH mtime even though its bytes are byte-for-byte the shipped
    ones — a pure stat comparison would then rebuild on every single cold
    start, every time, for a file that never actually changed. So: for any
    source file whose stat disagrees with `meta`, fall back to comparing the
    sha256 `build_index` already recorded for it (`meta[f"{name}_sha256"]`,
    populated on every build, not a new field) against a freshly computed
    hash of the file on disk — a real, if slightly more expensive
    (single-digest-per-mismatched-file, not per call) content check, not a
    second stat trick. Only a genuine content difference (a real registry
    edit) is still reported as a staleness reason; a shipped index whose
    hash matches is accepted with no rebuild. `needs_rebuild`/
    `cache.RegistryCache.ensure_fresh` both route through this function, so
    the acceptance is automatic wherever a cold start currently forces a
    rebuild."""
    root = root or paths.repo_root()
    db = paths.index_db_path(root)
    if not db.exists():
        return Freshness(True, ["no index built yet"], False)

    conn = _readonly_connection(db)
    try:
        meta = _load_meta(conn)
    finally:
        conn.close()

    reasons: list[str] = []
    for name, p in _source_paths(root).items():
        fp = file_fingerprint(p)
        if str(fp["size"]) == meta.get(_fp_key(name, "size")) and str(fp["mtime_ns"]) == meta.get(_fp_key(name, "mtime_ns")):
            continue  # stat agrees outright -- no hashing needed for this file
        stored_hash = meta.get(_fp_key(name, "sha256"))
        actual_hash = sha256_file(p) if stored_hash else None
        if stored_hash and actual_hash == stored_hash:
            continue  # stat differs (repackaged/checked-out/touched) but bytes are identical -- accept, no rebuild
        reasons.append(f"registry/{p.name} changed since the index was built")

    stale = bool(reasons)
    return Freshness(
        stale=stale,
        reasons=reasons,
        index_exists=True,
        source_entry_count=int(meta["entry_count"]) if meta.get("entry_count") else None,
        built_at=meta.get("built_at"),
    )


def needs_rebuild(root: pathlib.Path | None = None) -> bool:
    return check_freshness(root).stale


def source_fingerprints(root: pathlib.Path | None = None) -> dict:
    """Pure `os.stat` fingerprints of the three source files — no SQLite
    connection opened. `check_freshness`/`needs_rebuild` above always open
    the index db to compare against its stored `meta` fingerprints, which
    costs a real sqlite3 connect/query/close round trip on every call (~0.3-
    0.5ms measured — see `benchmarks/bench_index.py` "registry_cache" before
    this function existed vs. after). A caller that already holds its OWN
    copy of the last-seen fingerprints in memory (see `cache.RegistryCache`)
    should compare against THIS function's plain-Python result instead of
    calling `needs_rebuild` on every access — reserving the SQLite-backed
    check for the moment it actually needs to decide whether to rebuild the
    persisted index (once per process's first call, and after a genuine
    change), not on every single lookup."""
    root = root or paths.repo_root()
    return {name: file_fingerprint(p) for name, p in _source_paths(root).items()}


def cross_check_toledo_json(entries: list[dict], root: pathlib.Path) -> list[str]:
    """Best-effort corroboration only (never authoritative, never blocks a
    build): if registry/TOLEDO.json exists and is at least as new as
    CANONICAL.json, compare its code set and each shared code's `children[]`
    against what this build just computed via `core.load_registry`. A
    mismatch means TOLEDO.json is stale relative to CANONICAL.json (someone
    edited the registry and has not run `make build` yet) or, in principle, a
    genuine divergence between the two reconciliation call sites — either way
    it is reported, never silently resolved."""
    tj = paths.toledo_json_path(root)
    cj = paths.canonical_json_path(root)
    if not tj.exists():
        return ["registry/TOLEDO.json not found — no cross-check performed"]
    if cj.exists() and cj.stat().st_mtime_ns > tj.stat().st_mtime_ns:
        return ["registry/CANONICAL.json is newer than registry/TOLEDO.json — skipped cross-check (run `make build`)"]
    try:
        with open(tj, encoding="utf-8") as fh:
            toledo_doc = json.load(fh)
    except (OSError, json.JSONDecodeError) as exc:
        return [f"registry/TOLEDO.json unreadable: {exc}"]

    by_code_here = {e["code"]: e for e in entries}
    by_code_tj = {e["code"]: e for e in toledo_doc.get("canonical", [])}
    findings = []
    only_here = set(by_code_here) - set(by_code_tj)
    only_tj = set(by_code_tj) - set(by_code_here)
    if only_here:
        findings.append(f"{len(only_here)} code(s) in the live merge not in TOLEDO.json (e.g. {sorted(only_here)[:5]})")
    if only_tj:
        findings.append(f"{len(only_tj)} code(s) in TOLEDO.json not in the live merge (e.g. {sorted(only_tj)[:5]})")
    mismatched_children = [
        code for code in (set(by_code_here) & set(by_code_tj))
        if sorted(by_code_here[code].get("children", []) or []) != sorted(by_code_tj[code].get("children", []) or [])
    ]
    if mismatched_children:
        findings.append(f"{len(mismatched_children)} code(s) have a different children[] in TOLEDO.json (e.g. {mismatched_children[:5]})")
    return findings


def build_index(registry, root: pathlib.Path | None = None) -> dict:
    """Build a fresh index from an already-loaded `core.Registry` (see
    `core.load_registry`) and atomically swap it into place at
    `paths.index_db_path(root)`. Builds into a temp file first and
    `os.replace`s it in, so a reader that already opened the old file keeps
    reading a complete, consistent database throughout — no reader ever
    observes a half-built index. Returns a build report dict, also used by
    `benchmarks/bench_index.py` and the `status` tool."""
    from . import core  # local import: avoids a hard cycle at module load time

    root = root or paths.repo_root()
    t0 = time.perf_counter()
    entries = registry.entries

    db_path = paths.index_db_path(root)
    db_path.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp_name = tempfile.mkstemp(prefix="index.", suffix=".sqlite3.tmp", dir=str(db_path.parent))
    os.close(fd)
    tmp_path = pathlib.Path(tmp_name)
    tmp_path.unlink(missing_ok=True)  # sqlite3.connect must create it fresh

    conn = sqlite3.connect(str(tmp_path))
    try:
        conn.executescript(_DDL)

        entry_rows, alias_rows, parent_rows, relation_rows = [], [], [], []
        occurrence_rows, fts_rows, child_rows = [], [], []

        for e in entries:
            code = e.get("code")
            statement = (e.get("statement") or {}).get("latest", "") or ""
            origin = e.get("origin") or {}
            repo_anchor = origin.get("repo_anchor") or {}
            coq = e.get("coq") or {}

            statement_norm = normalize_text(statement)
            # phi_len uses core.normalise_formula (NOT normalize_text above) because
            # that is the exact normaliser equivalence.compare_statements compares
            # lengths under (see equivalence.find_candidates_indexed) — using a
            # different normaliser's length here would silently prefilter out true
            # candidates whenever the two normalisers disagree on length (they do,
            # substantially, for symbol-heavy statements: core.normalise_formula
            # expands "∂"/"δ" etc. to multi-character words).
            phi_len = len(core.normalise_formula(statement))
            entry_rows.append((
                code, e.get("id"), e.get("root"), e.get("layer"), e.get("domain"),
                e.get("name", ""), statement, (e.get("statement") or {}).get("format"),
                statement_norm, phi_len, normalize_text(e.get("name", "")),
                e.get("tier"), e.get("tier_in_genesis_verbatim"),
                e.get("status"), e.get("status_note", ""), e.get("superseded_by"),
                e.get("role"), e.get("first_assigned"), e.get("owner_year"), e.get("drift_note"),
                coq.get("coq_status"), coq.get("file"), coq.get("assumptions"),
                origin.get("source"), repo_anchor.get("repo"), repo_anchor.get("commit"),
                origin.get("record_id"), origin.get("doi"),
                json.dumps(e, ensure_ascii=False, sort_keys=False),
            ))

            for a in e.get("aliases", []) or []:
                if a:
                    alias_rows.append((code, a, normalize_text(a)))
            for i, p in enumerate(e.get("parents", []) or []):
                if p.get("code"):
                    parent_rows.append((code, p["code"], p.get("derived_via"), i))
            for c in e.get("children", []) or []:
                child_rows.append((code, c))
            for i, r in enumerate(e.get("relations", []) or []):
                relation_rows.append((code, r.get("target"), r.get("type"), r.get("note", ""), i))
            for i, o in enumerate(e.get("occurrences", []) or []):
                occurrence_rows.append((code, o.get("record_id"), o.get("doi"), o.get("label"), o.get("section"), o.get("raw_key"), i))

            occ_text = " ".join(str(o.get("label") or "") for o in (e.get("occurrences") or []))
            fts_rows.append((code, e.get("name", ""), statement, " ".join(e.get("aliases", []) or []), occ_text))

        conn.executemany(
            "INSERT INTO entries ("
            "code, id, root, layer, domain, name, statement, statement_format, statement_norm, "
            "phi_len, name_norm, tier, tier_verbatim, status, status_note, superseded_by, role, "
            "first_assigned, owner_year, drift_note, coq_status, coq_file, coq_assumptions, "
            "origin_source, origin_repo, origin_commit, record_id, doi, raw_json"
            ") VALUES (" + ",".join(["?"] * 29) + ")",
            entry_rows,
        )
        conn.executemany("INSERT INTO aliases VALUES (?,?,?)", alias_rows)
        conn.executemany("INSERT INTO parents VALUES (?,?,?,?)", parent_rows)
        conn.executemany("INSERT OR IGNORE INTO children VALUES (?,?)", child_rows)
        conn.executemany("INSERT INTO relations VALUES (?,?,?,?,?)", relation_rows)
        conn.executemany("INSERT INTO occurrences VALUES (?,?,?,?,?,?,?)", occurrence_rows)
        conn.executemany(
            "INSERT INTO entries_fts (code, name, statement, aliases, occurrences_text) VALUES (?,?,?,?,?)",
            fts_rows,
        )
        conn.executemany(
            "INSERT OR REPLACE INTO raw_to_canonical VALUES (?,?)",
            list(registry.raw_to_canonical.items()),
        )

        lineage_rows = []
        lineage_target_rows = []
        for seq, ev in enumerate(registry.lineage_events):
            to = ev.get("to")
            to_str = to if isinstance(to, str) or to is None else json.dumps(to, ensure_ascii=False)
            phi = ev.get("phi_criterion_evidence")
            lineage_rows.append((
                seq, ev.get("code"), ev.get("date"), ev.get("event"), ev.get("from"), to_str,
                ev.get("reason"), ev.get("by"),
                json.dumps(phi, ensure_ascii=False) if phi is not None else None,
                json.dumps(ev, ensure_ascii=False),
            ))
            to_targets = to if isinstance(to, list) else ([to] if to else [])
            for t in to_targets:
                if t:
                    lineage_target_rows.append((seq, t))
        conn.executemany("INSERT INTO lineage VALUES (?,?,?,?,?,?,?,?,?,?)", lineage_rows)
        conn.executemany("INSERT INTO lineage_targets VALUES (?,?)", lineage_target_rows)

        source_schema_version = (getattr(registry, "canonical_doc", None) or {}).get("schema_version")
        meta_rows = [("index_schema_version", INDEX_SCHEMA_VERSION),
                     ("source_schema_version", source_schema_version),
                     ("source_schema_supported", str(source_schema_version in SUPPORTED_CANONICAL_SCHEMA_VERSIONS)),
                     ("built_at", time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())),
                     ("entry_count", str(len(entries))),
                     ("lineage_event_count", str(len(lineage_rows)))]
        for name, p in _source_paths(root).items():
            fp = file_fingerprint(p)
            meta_rows.append((_fp_key(name, "size"), str(fp["size"])))
            meta_rows.append((_fp_key(name, "mtime_ns"), str(fp["mtime_ns"])))
            meta_rows.append((_fp_key(name, "sha256"), sha256_file(p) or ""))
        conn.executemany("INSERT OR REPLACE INTO meta VALUES (?,?)", meta_rows)
        conn.commit()
    finally:
        conn.close()

    os.replace(tmp_path, db_path)
    pathlib.Path(str(tmp_path) + "-wal").unlink(missing_ok=True)
    pathlib.Path(str(tmp_path) + "-shm").unlink(missing_ok=True)

    elapsed = time.perf_counter() - t0
    return {
        "entry_count": len(entries),
        "lineage_event_count": len(lineage_rows),
        "build_seconds": round(elapsed, 4),
        "db_path": paths.relpath(db_path, root),
        "toledo_json_cross_check": cross_check_toledo_json(entries, root),
        "source_schema_version": source_schema_version,
        "source_schema_supported": source_schema_version in SUPPORTED_CANONICAL_SCHEMA_VERSIONS,
    }


def get_connection(root: pathlib.Path | None = None, auto_build: bool = True):
    """Open (building first if missing/stale) the index and return a live
    sqlite3.Connection with Row factory set. Callers wanting to avoid the
    `core.load_registry` re-parse cost on every rebuild check can hold the
    connection returned here across multiple tool calls and only re-open when
    `needs_rebuild(root)` turns true (see `queries.IndexHandle`).

    Returned as a `mode=ro` URI connection (graft C3, sec. 4): every caller of
    this function only ever reads (`queries.py`'s functions, `cache.py`'s
    `index_conn`) — the one legitimate writer is `build_index`'s own private
    connection to a temp file, swapped into place with `os.replace` before
    this function ever opens the result. A reader obtained here cannot write
    even if a future bug tried to."""
    from . import core  # local import: avoids a hard cycle at module load time

    root = root or paths.repo_root()
    if auto_build and needs_rebuild(root):
        registry = core.load_registry(root)
        build_index(registry, root)
    return _readonly_connection(paths.index_db_path(root))
