#!/usr/bin/env python3
"""bench_index.py — measures, on THIS machine against the real repo registry
(read-only; writes only to a throwaway state dir), the actual cost this
design changes: `core.load_registry()`'s per-call cold JSON-reparse-and-merge
against a cached `IndexHandle`'s SQLite-backed queries, plus the indexed vs.
linear-scan cost of search / lineage / by-record.

Every number this script prints comes from `time.perf_counter()` calls
around real code in this checkout, run just now — nothing here is a
carried-over or estimated figure. Run: `python3 benchmarks/bench_index.py`.

Also folds in (mcp/DESIGN.md sec. 10, S1's own commitment there) the two
measurements that document previously only reported from an ad hoc, uncommitted
script: a search latency distribution (p50/p95/p99/mean/max over 1,000 queries,
fixed-seed word pool, against a warm cache) and a 5-run cold index-rebuild-time
sample (each into its own fresh temp state dir). Re-run before citing either
number in a release note — the registry is a live, growing artifact.
"""
from __future__ import annotations

import json
import os
import pathlib
import random
import statistics
import sys
import tempfile
import time

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent))

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent.parent


def _time(fn, repeat=5):
    times = []
    result = None
    for _ in range(repeat):
        t0 = time.perf_counter()
        result = fn()
        times.append(time.perf_counter() - t0)
    return result, times


def main() -> None:
    state_dir = tempfile.mkdtemp(prefix="toledo_mcp_bench_state_")
    os.environ["TOLEDO_MCP_STATE_DIR"] = state_dir
    os.environ.pop("TOLEDO_ROOT", None)

    from toledo_mcp import cache as cache_mod
    from toledo_mcp import core, equivalence, index, queries

    report: dict = {"machine_note": "single run on the developer machine in this session; indicative, not a guaranteed SLA", "runs": {}}

    canonical_path = REPO_ROOT / "registry" / "CANONICAL.json"
    genesis_path = REPO_ROOT / "registry" / "genesis_root.json"
    lineage_path = REPO_ROOT / "registry" / "LINEAGE.jsonl"
    report["source_sizes_bytes"] = {
        "CANONICAL.json": canonical_path.stat().st_size if canonical_path.exists() else None,
        "genesis_root.json": genesis_path.stat().st_size if genesis_path.exists() else None,
        "LINEAGE.jsonl": lineage_path.stat().st_size if lineage_path.exists() else None,
    }

    # 1. core.load_registry() cold cost -- what EVERY baseline tool call pays today.
    _, t_load = _time(lambda: core.load_registry(REPO_ROOT), repeat=5)
    report["runs"]["core.load_registry_cold_call"] = {
        "repeat": len(t_load), "seconds_each": [round(x, 4) for x in t_load],
        "median_seconds": round(statistics.median(t_load), 4),
    }

    reg = core.load_registry(REPO_ROOT)
    entry_count = len(reg.entries)
    report["entry_count"] = entry_count

    # 2. Index build cost (paid once, amortised across calls until source files change).
    build_report = index.build_index(reg, REPO_ROOT)
    report["runs"]["index_build_once"] = {"seconds": build_report["build_seconds"], "entry_count": build_report["entry_count"]}
    report["toledo_json_cross_check"] = build_report["toledo_json_cross_check"]

    handle = queries.IndexHandle.open(REPO_ROOT)
    conn = handle.conn

    # 3. Cached indexed lookup cost -- what every subsequent call pays once
    #    the index exists and is fresh (no reparse, no rebuild).
    def cached_get():
        return queries.get(conn, "EQ-001")

    _, t_cached_get = _time(cached_get, repeat=50)
    report["runs"]["queries.get_cached_connection"] = {
        "repeat": len(t_cached_get), "median_seconds": round(statistics.median(t_cached_get), 6),
    }

    def baseline_get():
        r = core.load_registry(REPO_ROOT)
        return core.get(r, "EQ-001")

    _, t_baseline_get = _time(baseline_get, repeat=5)
    report["runs"]["core.get_reloading_every_call"] = {
        "repeat": len(t_baseline_get), "median_seconds": round(statistics.median(t_baseline_get), 4),
    }

    # 4. search(): common-word text query.
    common_query = "readout"

    def baseline_search_common():
        return core.search(reg, common_query, limit=20)

    def indexed_search_common():
        return queries.search(conn, common_query, limit=20)

    base_hits, t_base_search = _time(baseline_search_common, repeat=5)
    idx_hits, t_idx_search = _time(indexed_search_common, repeat=20)
    report["runs"]["search_common_word"] = {
        "query": common_query,
        "baseline_search_only_median_seconds": round(statistics.median(t_base_search), 4),
        "indexed_cached_median_seconds": round(statistics.median(t_idx_search), 6),
        "baseline_hit_count": len(base_hits),
        "indexed_hit_count": len(idx_hits),
    }

    # 4b. The honest end-to-end comparison: baseline pays reload+search on
    # every call (it has no cache); the indexed path pays reload+search only
    # the first time a process sees a changed file, then just search.
    def baseline_end_to_end_search():
        r = core.load_registry(REPO_ROOT)
        return core.search(r, common_query, limit=20)

    _, t_e2e_baseline = _time(baseline_end_to_end_search, repeat=5)
    report["runs"]["search_common_word_end_to_end"] = {
        "note": "baseline = fresh core.load_registry()+core.search() per call (no cache exists in the baseline spike); "
                "indexed = queries.search() on an already-open, already-fresh cached connection",
        "baseline_median_seconds": round(statistics.median(t_e2e_baseline), 4),
        "indexed_median_seconds": round(statistics.median(t_idx_search), 6),
        "speedup_x": round(statistics.median(t_e2e_baseline) / statistics.median(t_idx_search), 1),
    }

    # 5. search(): symbol-heavy query (falls back to the LIKE path).
    symbol_query = "δ_R"

    def baseline_search_symbol():
        return core.search(reg, symbol_query, limit=20)

    def indexed_search_symbol():
        return queries.search(conn, symbol_query, limit=20)

    base_sym_hits, t_base_sym = _time(baseline_search_symbol, repeat=5)
    idx_sym_hits, t_idx_sym = _time(indexed_search_symbol, repeat=20)
    report["runs"]["search_symbol_heavy"] = {
        "query": symbol_query,
        "baseline_search_only_median_seconds": round(statistics.median(t_base_sym), 4),
        "indexed_cached_median_seconds": round(statistics.median(t_idx_sym), 6),
        "baseline_hit_count": len(base_sym_hits),
        "indexed_hit_count": len(idx_sym_hits),
    }

    # 6. lineage(): scans all LINEAGE.jsonl events (baseline) vs indexed join.
    sample_code = reg.entries[len(reg.entries) // 2]["code"]

    def baseline_lineage():
        return core.lineage(reg, sample_code)

    def indexed_lineage():
        return queries.lineage_for_code(conn, sample_code)

    _, t_base_lin = _time(baseline_lineage, repeat=10)
    _, t_idx_lin = _time(indexed_lineage, repeat=50)
    report["runs"]["lineage_lookup"] = {
        "sample_code": sample_code,
        "baseline_lineage_events_scanned": len(reg.lineage_events),
        "baseline_median_seconds": round(statistics.median(t_base_lin), 6),
        "indexed_cached_median_seconds": round(statistics.median(t_idx_lin), 6),
    }

    # 7. by_record(): baseline scans every entry's occurrences[] list.
    sample_record = None
    for e in reg.entries:
        for occ in e.get("occurrences") or []:
            if occ.get("record_id"):
                sample_record = occ["record_id"]
                break
        if sample_record:
            break

    if sample_record:
        def baseline_by_record():
            hits = []
            for e in reg.entries:
                for occ in e.get("occurrences") or []:
                    if str(occ.get("record_id")) == str(sample_record):
                        hits.append(e)
                        break
            return hits

        def indexed_by_record():
            return queries.by_record(conn, sample_record)

        _, t_base_rec = _time(baseline_by_record, repeat=10)
        _, t_idx_rec = _time(indexed_by_record, repeat=50)
        report["runs"]["by_record_lookup"] = {
            "sample_record": sample_record,
            "baseline_median_seconds": round(statistics.median(t_base_rec), 6),
            "indexed_cached_median_seconds": round(statistics.median(t_idx_rec), 6),
        }

    # 8. equivalence candidate search over the WHOLE registry for one query statement.
    probe_statement = (reg.entries[0].get("statement") or {}).get("latest", "a = b")

    def equivalence_scan():
        return equivalence.find_candidates(core.normalise_formula, probe_statement, reg.entries, limit=5)

    hits, t_equiv = _time(equivalence_scan, repeat=5)
    report["runs"]["equivalence_find_candidates_full_scan"] = {
        "entries_scanned": entry_count,
        "median_seconds": round(statistics.median(t_equiv), 4),
        "top_hit_kind": hits[0].kind if hits else None,
    }

    def equivalence_scan_indexed():
        return equivalence.find_candidates_indexed(conn, core.normalise_formula, probe_statement, limit=5)

    hits_idx, t_equiv_idx = _time(equivalence_scan_indexed, repeat=20)
    report["runs"]["equivalence_find_candidates_indexed_prefilter"] = {
        "median_seconds": round(statistics.median(t_equiv_idx), 6),
        "top_hit_kind": hits_idx[0].kind if hits_idx else None,
        "speedup_x_vs_full_scan": round(statistics.median(t_equiv) / statistics.median(t_equiv_idx), 1),
        "same_top_hit_as_full_scan": (hits[0].code, hits[0].kind) == (hits_idx[0].code, hits_idx[0].kind) if hits and hits_idx else None,
    }

    # 9. RegistryCache (the recommended design, see docs/DESIGN.md): a cached
    # in-memory Registry for the O(1)/O(local) lookups, delegating only
    # search + equivalence to the SQL index.
    rc = cache_mod.RegistryCache(root=REPO_ROOT)
    rc.ensure_fresh()

    _, t_cache_get = _time(lambda: rc.get("EQ-001"), repeat=50)
    _, t_cache_lineage = _time(lambda: rc.lineage(sample_code), repeat=50)
    _, t_cache_by_record = _time((lambda: rc.by_record(sample_record)) if sample_record else (lambda: None), repeat=50)
    _, t_cache_search = _time(lambda: rc.search(common_query, limit=20), repeat=20)
    report["runs"]["registry_cache"] = {
        "get_median_seconds": round(statistics.median(t_cache_get), 6),
        "lineage_median_seconds": round(statistics.median(t_cache_lineage), 6),
        "by_record_median_seconds": round(statistics.median(t_cache_by_record), 6) if sample_record else None,
        "search_median_seconds": round(statistics.median(t_cache_search), 6),
        "note": "get/lineage/by_record are plain Python dict lookups against the cached Registry "
                "(no SQL at all); search delegates to the same SQL FTS index as queries.search above.",
    }
    rc.close()

    # 10. Search latency distribution: p50/p95/p99 over many queries against
    # a warm cache (mcp/DESIGN.md sec. 10 — folded in here per S1's own
    # commitment in that section, so `python3 benchmarks/bench_index.py`
    # alone reproduces every number quoted there; no separate ad hoc script).
    _WORD_POOL = [
        "readout", "delta", "primordial", "distinction", "weld", "domain",
        "epistemic", "physics", "social", "chemistry", "biology", "method",
        "world", "human", "tier", "verified", "closed", "definition",
        "candidate", "structural",
    ]
    rc2 = cache_mod.RegistryCache(root=REPO_ROOT)
    rc2.ensure_fresh()
    rng = random.Random(20260907)  # fixed seed -- reproducible query sample
    queries_sample = [rng.choice(_WORD_POOL) for _ in range(1000)]

    latencies_ms: list[float] = []
    for q in queries_sample:
        t0 = time.perf_counter()
        rc2.search(q, limit=20)
        latencies_ms.append((time.perf_counter() - t0) * 1000.0)
    latencies_ms.sort()

    def _pctl(sorted_vals: list[float], p: float) -> float:
        if not sorted_vals:
            return 0.0
        idx = min(len(sorted_vals) - 1, int(round(p / 100.0 * (len(sorted_vals) - 1))))
        return sorted_vals[idx]

    report["runs"]["search_latency_distribution_1000_queries"] = {
        "n": len(latencies_ms),
        "word_pool_size": len(_WORD_POOL),
        "seed": 20260907,
        "p50_ms": round(_pctl(latencies_ms, 50), 4),
        "p95_ms": round(_pctl(latencies_ms, 95), 4),
        "p99_ms": round(_pctl(latencies_ms, 99), 4),
        "mean_ms": round(statistics.mean(latencies_ms), 4),
        "max_ms": round(max(latencies_ms), 4),
    }
    rc2.close()

    # 11. Index rebuild time, cold, into a fresh temp state dir each run (5
    # runs) -- mcp/DESIGN.md sec. 10's other folded-in measurement.
    rebuild_seconds: list[float] = []
    for _ in range(5):
        rebuild_state_dir = tempfile.mkdtemp(prefix="toledo_mcp_bench_rebuild_")
        prior_state_dir_env = os.environ.get("TOLEDO_MCP_STATE_DIR")
        os.environ["TOLEDO_MCP_STATE_DIR"] = rebuild_state_dir
        try:
            fresh_reg = core.load_registry(REPO_ROOT)
            rebuild_report = index.build_index(fresh_reg, REPO_ROOT)
            rebuild_seconds.append(rebuild_report["build_seconds"])
        finally:
            if prior_state_dir_env is not None:
                os.environ["TOLEDO_MCP_STATE_DIR"] = prior_state_dir_env
            else:
                os.environ.pop("TOLEDO_MCP_STATE_DIR", None)
    report["runs"]["index_rebuild_cold_5_runs"] = {
        "runs_seconds": [round(x, 4) for x in rebuild_seconds],
        "median_seconds": round(statistics.median(rebuild_seconds), 4),
        "median_ms": round(statistics.median(rebuild_seconds) * 1000.0, 2),
    }

    handle.close()

    # 12. Real stdio cold-start timing (DEBT #48, 2026-09-07, lane E) — spawns
    # the actual `toledo_mcp/server.py` subprocess (real MCP-over-stdio, real
    # `initialize()` + one real tool call), under two scenarios, each `repeat`
    # times into its own fresh temp state dir + a throwaway registry-only
    # "shadow root" copy (never the real registry/ files, and never the
    # developer's own mcp/state/ — this must be safe to run alongside other
    # concurrent lanes editing the real registry):
    #   - "no_shipped_index": empty state dir, no mcp/state/index.sqlite3 at
    #     all -- must build cold every time; unaffected by this fix, kept as
    #     the control.
    #   - "shipped_index_mtime_changed": a shadow root whose registry files
    #     were copied then had their mtime bumped (`os.utime`) with NO byte
    #     change, and a state dir pre-seeded with an index already built
    #     against that shadow root -- exactly what a release zip landing on a
    #     fresh machine looks like. Before the DEBT #48 fix this scenario paid
    #     the same full rebuild as "no_shipped_index" (a pure stat mismatch
    #     always forced one); after it, `index.check_freshness`'s sha256
    #     fallback accepts the shipped index and `cache.RegistryCache.
    #     ensure_fresh` skips the rebuild.
    # Requires the `mcp` client SDK (mcp/requirements-mcp.txt); skipped with a
    # disclosed reason if it is not importable rather than failing the run.
    try:
        import asyncio
        import shutil as _shutil
        from mcp import ClientSession, StdioServerParameters
        from mcp.client.stdio import stdio_client
    except ImportError as exc:
        report["runs"]["mcp_cold_start_stdio"] = {"skipped": f"mcp client SDK not importable: {exc!r}"}
    else:
        server_path = REPO_ROOT / "mcp" / "toledo_mcp" / "server.py"

        def _make_shadow_root(tmp_base: pathlib.Path) -> pathlib.Path:
            shadow = tmp_base / "shadow_root"
            (shadow / "registry").mkdir(parents=True)
            for name in ("CANONICAL.json", "genesis_root.json", "LINEAGE.jsonl"):
                src = REPO_ROOT / "registry" / name
                if src.exists():
                    _shutil.copy2(src, shadow / "registry" / name)
            return shadow

        async def _one_cold_start(registry_root: pathlib.Path, state_dir: pathlib.Path) -> dict:
            env = dict(os.environ)
            env["TOLEDO_ROOT"] = str(registry_root)
            env["TOLEDO_MCP_STATE_DIR"] = str(state_dir)
            params = StdioServerParameters(command=sys.executable, args=[str(server_path)], env=env)
            t0 = time.perf_counter()
            async with stdio_client(params) as (read, write):
                async with ClientSession(read, write) as session:
                    await session.initialize()
                    init_ms = (time.perf_counter() - t0) * 1000.0
                    t1 = time.perf_counter()
                    await session.call_tool("toledo_counts", {})
                    first_call_ms = (time.perf_counter() - t1) * 1000.0
            return {"init_ms": round(init_ms, 2), "first_call_ms": round(first_call_ms, 2)}

        cold_start_repeat = 3
        no_index_runs = []
        shipped_runs = []
        for _ in range(cold_start_repeat):
            tmp_base = pathlib.Path(tempfile.mkdtemp(prefix="toledo_mcp_bench_cold_"))

            # Scenario A: no shipped index -- must build cold.
            shadow_a = _make_shadow_root(tmp_base / "a")
            state_a = tmp_base / "a" / "state"
            state_a.mkdir(parents=True)
            no_index_runs.append(asyncio.run(_one_cold_start(shadow_a, state_a)))

            # Scenario B: shipped index, mtime bumped after building (bytes unchanged).
            shadow_b = _make_shadow_root(tmp_base / "b")
            state_b = tmp_base / "b" / "state"
            state_b.mkdir(parents=True)
            prior_state_env = os.environ.get("TOLEDO_MCP_STATE_DIR")
            os.environ["TOLEDO_MCP_STATE_DIR"] = str(state_b)
            try:
                shipped_reg = core.load_registry(shadow_b)
                index.build_index(shipped_reg, shadow_b)
            finally:
                if prior_state_env is not None:
                    os.environ["TOLEDO_MCP_STATE_DIR"] = prior_state_env
                else:
                    os.environ.pop("TOLEDO_MCP_STATE_DIR", None)
            for name in ("CANONICAL.json", "genesis_root.json", "LINEAGE.jsonl"):
                p = shadow_b / "registry" / name
                if p.exists():
                    os.utime(p, None)  # bump mtime only -- bytes unchanged, simulates a zip unpack/checkout
            shipped_runs.append(asyncio.run(_one_cold_start(shadow_b, state_b)))

        def _summ(runs: list[dict]) -> dict:
            inits = [r["init_ms"] for r in runs]
            firsts = [r["first_call_ms"] for r in runs]
            return {
                "runs": runs,
                "median_init_ms": round(statistics.median(inits), 2),
                "median_first_call_ms": round(statistics.median(firsts), 2),
            }

        report["runs"]["mcp_cold_start_stdio"] = {
            "repeat": cold_start_repeat,
            "no_shipped_index": _summ(no_index_runs),
            "shipped_index_mtime_changed": _summ(shipped_runs),
        }

    print(json.dumps(report, indent=2, ensure_ascii=False))

    out_path = pathlib.Path(__file__).resolve().parent / "results.json"
    with open(out_path, "w", encoding="utf-8") as fh:
        json.dump(report, fh, indent=2, ensure_ascii=False)
    print(f"\nwritten to {out_path.relative_to(REPO_ROOT)}", file=sys.stderr)


if __name__ == "__main__":
    main()
