# Toledo MCP — benchmark run record

Every number on this page came from an actual command run on this machine,
on 2026-09-07, during the integration pass that made this package installable
and runnable end to end (`pip install -e .`, `python3 -m pytest -q`, a real
stdio round trip over all 19 tools, `python3 -m toledo_mcp.export_static`).
None of it is carried over, estimated, or copied from `mcp/DESIGN.md`'s own
numbers — those were a separate run, on a separate occasion, and are kept
there as that document's own record. Re-run the commands below for a current
number; this file is a snapshot, not a live figure, and — like every timing
in this package's own docs — is disclosed as **indicative of this run**, not
a guaranteed SLA, because the registry (`registry/CANONICAL.json`,
`registry/genesis_root.json`, `registry/LINEAGE.jsonl`) was actively being
edited by the concurrently-running registry-owning lane (v1.2, `wf_3483b2de-
ea9`, per `ops/HANDOFF_OVERNIGHT_2026-09-06.md`) while this run happened —
the stdio cold-start numbers in particular are slower than `mcp/DESIGN.md`'s
own figures for exactly that reason (shared-machine contention from that
concurrent run), not a regression in this package.

## Registry state at the time of this run

```
$ python3 -m toledo_mcp.cli index-status
```
```json
{
  "package_version": "1.1.0",
  "index_schema_version": "2",
  "source_schema_version": "1.0.0",
  "source_schema_supported": true,
  "entry_count": 1504,
  "lineage_event_count": 2542
}
```
`registry/CANONICAL.json` 3,372,220 bytes; `registry/genesis_root.json`
679,122 bytes; `registry/LINEAGE.jsonl` 1,083,656 bytes (all three sizes read
by `benchmarks/bench_index.py` itself, quoted below).

## `python3 -m pytest -q` (from `mcp/`)

```
........................................................................ [ 38%]
........................................................................ [ 76%]
............................................                             [100%]
188 passed in 6.55s
```

188 passing — 85 from the first landed pass plus the ≥17 named in
`mcp/DESIGN.md` §9's test plan for streams S1–S4, plus additional tests each
stream added beyond the named minimum.

## `python3 benchmarks/bench_index.py` (full output, this run)

```json
{
  "machine_note": "single run on the developer machine in this session; indicative, not a guaranteed SLA",
  "runs": {
    "core.load_registry_cold_call": {
      "repeat": 5,
      "seconds_each": [0.1215, 0.1078, 0.0957, 0.0924, 0.0939],
      "median_seconds": 0.0957
    },
    "index_build_once": { "seconds": 0.2041, "entry_count": 1504 },
    "queries.get_cached_connection": { "repeat": 50, "median_seconds": 2.5e-05 },
    "core.get_reloading_every_call": { "repeat": 5, "median_seconds": 0.0864 },
    "search_common_word": {
      "query": "readout",
      "baseline_search_only_median_seconds": 0.0036,
      "indexed_cached_median_seconds": 0.006695,
      "baseline_hit_count": 20,
      "indexed_hit_count": 20
    },
    "search_common_word_end_to_end": {
      "note": "baseline = fresh core.load_registry()+core.search() per call (no cache exists in the baseline spike); indexed = queries.search() on an already-open, already-fresh cached connection",
      "baseline_median_seconds": 0.0918,
      "indexed_median_seconds": 0.006695,
      "speedup_x": 13.7
    },
    "search_symbol_heavy": {
      "query": "δ_R",
      "baseline_search_only_median_seconds": 0.003,
      "indexed_cached_median_seconds": 0.003541,
      "baseline_hit_count": 12,
      "indexed_hit_count": 13
    },
    "lineage_lookup": {
      "sample_code": "ChemDomain_ledger/C.41.v1",
      "baseline_lineage_events_scanned": 2542,
      "baseline_median_seconds": 0.000402,
      "indexed_cached_median_seconds": 0.001641
    },
    "by_record_lookup": {
      "sample_record": 21529456,
      "baseline_median_seconds": 0.000343,
      "indexed_cached_median_seconds": 0.00098
    },
    "equivalence_find_candidates_full_scan": {
      "entries_scanned": 1504,
      "median_seconds": 0.9666,
      "top_hit_kind": "exact"
    },
    "equivalence_find_candidates_indexed_prefilter": {
      "median_seconds": 0.00833,
      "top_hit_kind": "exact",
      "speedup_x_vs_full_scan": 116.0,
      "same_top_hit_as_full_scan": true
    },
    "registry_cache": {
      "get_median_seconds": 3.8e-05,
      "lineage_median_seconds": 0.000448,
      "by_record_median_seconds": 9.4e-05,
      "search_median_seconds": 0.007221,
      "note": "get/lineage/by_record are plain Python dict lookups against the cached Registry (no SQL at all); search delegates to the same SQL FTS index as queries.search above."
    },
    "search_latency_distribution_1000_queries": {
      "n": 1000,
      "word_pool_size": 20,
      "seed": 20260907,
      "p50_ms": 4.5135,
      "p95_ms": 7.2512,
      "p99_ms": 7.5519,
      "mean_ms": 4.767,
      "max_ms": 8.1767
    },
    "index_rebuild_cold_5_runs": {
      "runs_seconds": [0.1993, 0.2006, 0.1991, 0.2407, 0.1993],
      "median_seconds": 0.1993,
      "median_ms": 199.3
    }
  },
  "source_sizes_bytes": {
    "CANONICAL.json": 3372220,
    "genesis_root.json": 679122,
    "LINEAGE.jsonl": 1083656
  },
  "entry_count": 1504,
  "toledo_json_cross_check": []
}
```

Full machine-readable copy: `mcp/benchmarks/results.json` (same run, written
by the script itself).

### Reading the numbers

- **Cache win is real and large**: a fresh `core.load_registry()` +
  `core.search()` (no cache at all — the original baseline-spike behaviour)
  costs **~92ms** end to end for one search; the cached, already-indexed path
  costs **~6.7ms** — a **13.7x** speedup, dominated by not re-reading and
  re-merging 3.37MB of JSON per call.
- **The equivalence length-band prefilter is the largest single win
  measured**: a full φ-criterion scan over all 1,504 entries costs **~967ms**;
  the indexed, `phi_len`-prefiltered version answers the same top hit in
  **~8.3ms** — **116x**.
- **SQL is not universally faster than a plain Python dict** at this
  registry size — `registry_cache`'s `get`/`lineage`/`by_record` entries are
  plain in-memory dict lookups (tens of microseconds) and are *not* routed
  through SQLite at all; only `search` and the equivalence prefilter go
  through the SQLite/FTS5 index, because those are the two operations this
  run measured an actual win for.
- **1,000-query search latency** against the real, warm-cached registry:
  **p50 4.51ms · p95 7.25ms · p99 7.55ms · mean 4.77ms · max 8.18ms** — a
  fresh, independent measurement from the single-query figure two rows
  above it, consistent with it (the single repeated-query figure sits near
  this run's p50/p95 band).
- **Index rebuild** (`index.build_index`, cold, 5 runs): **199.1–240.7ms**,
  median **199.3ms**, over the current 1,504-entry / 2,542-event registry.

## Real stdio round trip, all 19 tools, real registry (not the test fixture)

Spawned `python3 mcp/toledo_mcp/server.py` as a real subprocess with
`TOLEDO_ROOT` pointed at this checkout and `TOLEDO_MCP_STATE_DIR` redirected
to a throwaway temp directory (so this run never touched
`mcp/state/index.sqlite3` for the real checkout), spoke real MCP-over-stdio
via the `mcp` Python client SDK (`mcp.client.stdio.stdio_client` +
`mcp.ClientSession`), listed tools, and called every one of the 19 with a
real argument against the real 1,504-entry registry:

```
initialize() ok: server=toledo protocolVersion=2025-11-25
list_tools() -> 19 tools
  (toledo_ancestors, toledo_by_domain, toledo_by_raw_key, toledo_by_record,
   toledo_by_root, toledo_check, toledo_counts, toledo_descendants,
   toledo_get, toledo_index_status, toledo_lineage, toledo_lineage_window,
   toledo_list_proposals, toledo_neighbours, toledo_proposal_status,
   toledo_register_proposal, toledo_search, toledo_show_verdict_rules,
   toledo_status)
toledo_index_status({}) -> ok=True
toledo_counts({}) -> ok=True :: canonical_entries=1504
toledo_show_verdict_rules({}) -> ok=True :: 11 verdict values
toledo_search({'query': 'primordial', 'limit': 5}) -> ok=True :: hit EQ-001
toledo_get({'code': 'EQ-001'}) -> ok=True
toledo_status({'code': 'EQ-001'}) -> ok=True
toledo_check({'formula': 'totally novel unregistered formula xyz123'}) -> ok=True :: verdict=NOT_REGISTERED (bug #3 regression still holds on the real registry)
toledo_check({'code': 'EQ-001'}) -> ok=True :: verdict=REGISTERED_CURRENT
toledo_lineage({'code': 'EQ-001'}) -> ok=True
toledo_ancestors({'code': 'EQ-001/B.01.v1'}) -> ok=True :: ["EQ-001"]
toledo_descendants({'code': 'EQ-001', 'format': 'json'}) -> ok=True
toledo_neighbours({'code': 'EQ-001'}) -> ok=True
toledo_by_root({'root': 'EQ-001', 'limit': 5}) -> ok=True
toledo_by_domain({'domain': 'P', 'limit': 5}) -> ok=True
toledo_by_record({'record_id_or_doi': '1'}) -> ok=True :: items=[]
toledo_by_raw_key({'raw_key': 'does-not-exist:none'}) -> ok=True :: data=null
toledo_lineage_window({'limit': 5}) -> ok=True
toledo_register_proposal({'fields': {...}}) -> ok=True :: wrote mcp/proposals/20260907T035600Z_integration-smoke-test-proposal-safe-to-discard.json
toledo_list_proposals({'limit': 5}) -> ok=True
toledo_proposal_status({'path': '...'}) -> ok=True

ALL 19 TOOLS EXERCISED OVER REAL STDIO AGAINST THE REAL REGISTRY — OK
```

The one write this round trip made (`toledo_register_proposal`) landed under
`mcp/proposals/` (gitignored, confirmed with `git status --short
mcp/proposals` returning nothing) and was deleted immediately after the
smoke test confirmed it round-tripped through `toledo_list_proposals`/
`toledo_proposal_status`; `git diff --stat registry/CANONICAL.json
registry/genesis_root.json registry/LINEAGE.jsonl` before and after this
whole integration session shows only the registry-owning lane's own
concurrent edits, never a write from this package.

## Real stdio cold-start timing (this run, this machine, 3 runs)

```json
{"init_ms": 1226.51, "first_call_ms": 1687.91}
{"init_ms": 1223.93, "first_call_ms": 1683.87}
{"init_ms": 1224.87, "first_call_ms": 1687.37}
```

**~1.22s** to `initialize()`, **~1.68s** to first tool response, this run.
This is markedly slower than the ~454ms/~947ms figures `mcp/DESIGN.md` §10
recorded on an earlier occasion — the difference is shared-machine
contention: `registry/CANONICAL.json`, `registry/genesis_root.json` and
`registry/LINEAGE.jsonl` were all being actively rewritten by a concurrent
registry-release run (v1.2, `wf_3483b2de-ea9`) while this benchmark ran, not
a regression introduced by this integration pass — the per-call numbers
above (index rebuild ~199ms, cached `get` tens of microseconds) are
consistent with `mcp/DESIGN.md`'s own figures and are the numbers that
actually describe this package's steady-state cost; the cold-start figure is
dominated by Python process/import startup plus whatever else the machine
was doing at that exact moment, and should be re-measured on a quiet machine
before being quoted as a representative cold-start cost.

## Static API export (`export_static.py`)

```
$ python3 -m toledo_mcp.export_static --out mcp/dist/static-api
{
  "out_dir": "mcp/dist/static-api/v1",
  "file_count": 2108
}
```

2,108 files written: one `manifest.json`, one `counts.json`, one
`verdict-rules.json`, one `search-index.json`, 1,504 `entries/<mangled-
code>.json` (one per canonical entry), plus the `by-root/` and `by-domain/`
directory trees. `manifest.json` from this run:

```json
{
  "generated_at": "2026-09-07T03:53:58Z",
  "generated_from_commit": "a365c017c7a36e989021c9a4a0bcc169d5dc2e52",
  "registry_release_version": "1.1.0",
  "package_version": "1.1.0",
  "entry_count": 1504,
  "disclosure": "eventually consistent; call the live MCP server for a current answer, never treat this as authoritative for a release-sensitive task"
}
```

Inspected a sample entry file and `counts.json`/`manifest.json` by hand: no
absolute filesystem path, username, or private-repo name appears in any
exported file (consistent with `mcp/scripts/leak_scan.py mcp/` reporting 0
findings over the whole package, see `docs/CHANGELOG.md`). `dist/` is
gitignored — this export is a build artifact, regenerated by CI, never
committed.

## Re-run discipline

The registry is a live, growing, concurrently-edited artifact. Re-run
`python3 benchmarks/bench_index.py` and the stdio round trip before quoting
any number on this page in a release note — this file is this run's honest
record, not a standing guarantee.

## 2026-09-07 (later) — security/correctness fix pass verification

A separate, later pass on the same date fixed nine defects an independent
adversarial review found in the run recorded above (`docs/CHANGELOG.md`'s
`1.2.0` entry has the full list). Every number below came from an actual
command run on this machine during that fix pass, against the real registry
(912 canonical entries at the time of this run; the entry count above,
1,504, is this package's own merged root+reading search-corpus total —
see the counts-mismatch fix in `docs/CHANGELOG.md`, which is exactly the
distinction this run re-verifies).

### `python3 -m pytest -q` (from `mcp/`)

```
........................................................................ [ 33%]
........................................................................ [ 67%]
....................................................................     [100%]
212 passed in 9.85s
```

### Real stdio round trip against the real registry (regex DoS + self-heal)

```
tools: 19
counts.canonical_entries: 912 want: 912
merged_search_entries: 1504
COUNTS FIX: OK
search('δ_R') top1='weld/M.01.v1' want='weld/M.01.v1'
search('weld') top1='weld' want='weld'
search('Theta') top1='Theta' want='Theta'
search('CMC') top1='CMC' want='CMC'
search('Λ_n') top1='EQ-015/M.01.v1' want='EQ-015/M.01.v1'
SEARCH-RELEVANCE FIX: OK
check(not_an_equation statement, phi): REGISTERED_NOT_AN_EQUATION False
check(not_an_equation statement, difflib): REGISTERED_NOT_AN_EQUATION False
R3-1 FIX: OK
regex DoS query returned in 1.02s: ok=False
canary toledo_counts call after the regex call took 0.006s (server not blocked)
SEC-1 FIX: OK
overlong regex query -> False {'code': 'INVALID_INPUT', 'message': 'regex query is 500 characters, longer than the 200-character cap allowed for regex=True searches; simplify the pattern'}
ALL LIVE CHECKS PASSED
```

Before this fix, the same `regex DoS query` (`"(.*)+ZZZ_NOT_PRESENT_ANYWHERE_IN_THE_REGISTRY"`,
`regex=True`) was confirmed live to still be hung after a 25-second
observation window against this same real registry — the guard above bounds
it to ~1 second and leaves the server answering a canary call immediately
afterward, not blocked.

A second, separate stdio session (state redirected to an isolated temp
directory, source registry files never touched) confirmed the corrupted-
index self-heal:

```
1) search before corruption -> True
corrupted index.sqlite3 (11943936 -> 5971968 bytes); source registry files untouched
2) search AFTER corruption (fresh process) -> True isError: False
3) toledo_index_status AFTER corruption -> True isError: False
ALL PERF-1/PERF-2 LIVE CHECKS PASSED
```

`mcp/scripts/leak_scan.py mcp/` after this pass: `2157 file(s) scanned, 0
finding(s)` (the `private_repo_name` category still honestly discloses "did
not run this pass" absent a `--denylist-file`, unchanged from the run
above).

## 2026-09-07 (later still) — residual-findings fix pass verification

A third, later pass on the same date closed six residual findings an
engineering-run review left open: SEC-3 (a file-existence oracle in
`proposals.get_proposal`), R3-3 (`toledo_check`'s `method="difflib"` path
picking one code blindly on a similarity tie), inconsistent `limit=0`
semantics across every search/list function, a corrupted-index self-heal
gap for corruption discovered mid-session (not only at connection-open
time), a root `tests/test_mcp.py` test left asserting the pre-move
`registry/proposals/` location, and several stale docstrings. Every fix
shipped with its own regression test; the full suite was re-run after every
fix, not just once at the end.

### `cd mcp && python3 -m pytest -q`

```
........................................................................ [ 33%]
........................................................................ [ 67%]
......................................................................   [100%]
214 passed in 10.28s
```

214 = the 212 already landed at the security/correctness fix pass above
plus 2 new regression tests
(`tests/test_cache.py::test_search_self_heals_when_index_file_is_corrupted_mid_session`,
`tests/test_cache.py::test_run_indexed_raises_clear_error_when_rebuild_does_not_repair`).

### `python3 -m pytest -q tests` (repo root)

```
............................x....x.x                                     [100%]
33 passed, 3 xfailed, 1 warning in 2.17s
```

(`tests/test_mcp.py::test_register_proposal_writes_a_proposal_file_not_the_registry`
updated to assert the current `mcp/proposals/` location — see
`docs/CHANGELOG.md`'s entry for this pass.)

### `python3 mcp/scripts/leak_scan.py mcp/ tests/test_mcp.py`

```
leak_scan: WARNING — private_repo_name category did not run this pass (no --denylist-file / TOLEDO_LEAK_SCAN_DENYLIST_FILE configured); this is disclosed, not a clean result for that category.
leak_scan: 2157 file(s) scanned, 0 finding(s)
```

### Real stdio round trip against the real registry: R3-3 tie fix (`toledo_check`)

The real registry has one genuine same-statement tie today —
`EQ-001/P.02.v1` and `EQ-001/B.02.v1` both carry the exact statement "The
asymmetric ordering yields ordered transitions with a positive retention
time tau_c>0." — found by grouping every entry's `core.normalise_formula`d
statement and looking for a group with more than one code. A real stdio
session (`mcp.client.stdio`, state redirected to an isolated temp
directory, source registry files never touched) called `toledo_check` with
that exact statement text under both methods:

```
difflib: {'ok': True, 'data': {'verdict': 'AMBIGUOUS', 'usable': False,
'reason': "core.check (difflib) found 2 different codes tied at similarity
1.0 — this statement is registered under several codes:
['EQ-001/B.02.v1', 'EQ-001/P.02.v1'] — escalate to a human, do not pick
one.", 'redirect': [], 'candidates': [... 5 candidates, both tied codes at
similarity 1.0, ...]}, 'error': None}

phi: {'ok': True, 'data': {'verdict': 'AMBIGUOUS', 'usable': False,
'reason': "the normalised statement is an exact match to 2 different
codes: ['EQ-001/P.02.v1', 'EQ-001/B.02.v1'] — escalate to a human, do not
pick one.", 'redirect': [], 'candidates': [{'code': 'EQ-001/P.02.v1',
'kind': 'exact', 'ratio': 1.0, ...}, {'code': 'EQ-001/B.02.v1', 'kind':
'exact', 'ratio': 1.0, ...}]}, 'error': None}
```

Before this fix, `method="difflib"` picked `matches[0]` — one of the two
tied codes, chosen by the difflib scan's own internal sort order — and
returned a plain per-entry verdict for it alone, silently dropping the
other tied code; `method="phi"` already had this exact tie-handling (the
`verdict_for_check` branch this fix's difflib path was brought in line
with). Both paths now agree: `AMBIGUOUS`, both codes named, no code picked
blindly.
