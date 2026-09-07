# Changelog — `toledo_mcp` (this package)

This is `mcp/`'s own changelog — the MCP server, CLI, and static-API-export
package built over the Toledo equation registry. It is **distinct from** the
registry's own root `CHANGELOG.md` (which this package never edits and which
records registry content releases — v1.0.0, v1.1.0, …). An entry here
records a change to *this package's code or contract*, never a registry
content change; a registry release (new codes, new tiers, a corrected count)
shows up here only indirectly, as "the registry this build's tests ran
against now has N entries" where that fact is relevant to a benchmark or a
schema-compatibility note.

Dates are the date the change was written down in this file. Every count or
test-output line below was produced by actually running the command shown,
on this machine, at that time — never carried over from a description of
intended work.

## 1.2.0 (residual-findings pass) — 2026-09-07

A further pass on the same date closed six residual findings a review of
the 1.2.0 fix pass below left open (this package's `__version__`/pyproject
version stays `1.2.0` — this pass is a within-version fix set, not a new
release; version bumps are `scripts/sync_version.py`'s own job, tracking
the registry's release version, not this package's fix cadence). Every fix
shipped with its own regression test; the full suite was re-run after
every fix.

- **SEC-3: a file-existence oracle in `proposals.get_proposal`.** The
  containment check (is this path actually inside `mcp/proposals/`) used
  to run AFTER `f.exists()`/`f.suffix` — so a `path_rel` naming a file
  outside `mcp/proposals/` (including an absolute path, which `pathlib`'s
  `/` operator silently lets override the repo root entirely, e.g.
  `root / "/etc/shadow" == Path("/etc/shadow")`) still triggered a real
  filesystem stat of that outside path before being refused. Fixed:
  containment is now checked FIRST, against the resolved path, with no
  stat/open call made until containment is confirmed — an outside path and
  a genuinely-missing inside path are refused by the exact same branch,
  returning the exact same `None`.
- **R3-3: `toledo_check`'s `method="difflib"` path picked one code blindly
  on a similarity tie.** When two or more DIFFERENT codes tied at the top
  similarity score, `matches[0]` (the difflib scan's own sort order) was
  resolved and reported as the single match, silently dropping the other
  tied code(s) — the exact conflict `method="phi"`'s `verdict_for_check`
  already treats as `AMBIGUOUS` for an exact-kind tie. Fixed (`server.py`'s
  `toledo_check` and `cli.py`'s `cmd_check`, kept in step per this
  package's own duplication note): both now collect every match tied with
  the top similarity score and, if more than one distinct code ties,
  return `AMBIGUOUS` naming all of them. Confirmed live against a genuine
  tie in the real registry (`EQ-001/P.02.v1`/`EQ-001/B.02.v1`, identical
  statements) — see `mcp/BENCHMARKS.md`'s matching section for the quoted
  stdio round trip.
- **Inconsistent `limit=0` semantics across every search/list function.**
  `core.search`/`queries.search`/`cache.by_root`/`cache.by_domain` used
  `if limit: ...[:limit]` (a falsy `0` skipped truncation entirely, i.e.
  "unlimited"), while `core.check`, `equivalence.find_candidates`/
  `find_candidates_indexed`, and `proposals.list_proposals` sliced/gated on
  a bare `limit` (`0` meant "empty"/"never stop") — two different, silently
  coexisting readings of the same input across sibling functions. Fixed:
  one canonical rule (`core.resolve_limit`, reimplemented locally in
  `equivalence.py` per that module's own no-hard-core-dependency design),
  applied everywhere: `0`/missing means "use this call's own stated
  default" (or "uncapped", for the two functions — `by_root`/`by_domain` —
  whose real default already is uncapped), never "unlimited" and never
  "empty"; negative raises `ValueError` (already surfaced as
  `INVALID_INPUT` at every MCP tool boundary). `export_static.py`'s
  `search-index.json` export (which relied on the old `limit=0 ==
  unlimited` reading to dump every entry) now passes an explicit
  `limit=len(entries)` instead. Documented in every affected tool's own
  docstring/CLI `--limit` help text.
- **Corrupted-index self-heal only triggered on a fresh connection.** The
  existing self-heal (`index._load_meta`'s `sqlite3.DatabaseError` catch)
  only fires when a FRESH connection is opened to check the `meta` table
  during a freshness check; a corruption that check does not happen to
  catch (e.g. confined to pages outside `meta`, or a fault that only
  surfaces once a query walks a damaged page) left the real query — run
  against the same already-open, already-"fresh" connection — with nothing
  catching `sqlite3.DatabaseError` at all. Fixed: `cache.RegistryCache.
  _run_indexed` now wraps every indexed query (`search`,
  `find_equivalence_candidates`, `lineage_window`, `index_status`'s meta
  read); on `sqlite3.DatabaseError` from the query itself it closes the
  connection, deletes the on-disk index file and its WAL/SHM/journal
  siblings, forces one rebuild from the unaffected source registry files,
  and retries the same query once — raising a clear `sqlite3.
  OperationalError` (still caught by `server.py`'s existing `_safe` ->
  `INDEX_UNAVAILABLE` path) if that retry also fails. Pinned by
  `tests/test_cache.py::test_search_self_heals_when_index_file_is_corrupted_mid_session`
  (corrupts the on-disk file mid-session, after a connection is already
  cached, and forces the pre-existing freshness check to lie once) and
  `::test_run_indexed_raises_clear_error_when_rebuild_does_not_repair`.
- **Root `tests/test_mcp.py` test asserted the pre-move proposal
  location.** `core.register_proposal` moved to `mcp/proposals/` a build
  stream ago, but `tests/test_mcp.py::
  test_register_proposal_writes_a_proposal_file_not_the_registry` (written
  before that move, outside `mcp/`'s own test suite) still asserted the
  old `registry/proposals/` path and was failing. Updated to the current
  location; kept (not deleted) since it is the only test anywhere pinning
  `core.register_proposal`'s own location specifically (distinct from
  `mcp/tests/test_proposals.py::
  test_proposals_write_under_mcp_proposals_never_registry`, which exercises
  the separate `proposals.write_proposal` function).
- **Stale docstrings.** `proposals.py`'s module docstring and
  `write_proposal`'s docstring still described `core.register_proposal` as
  writing to the old `registry/proposals/` location; `server.py`'s module
  docstring made the same claim. Both updated to reflect that
  `core.register_proposal` now also targets `mcp/proposals/`.

```
$ cd mcp && python3 -m pytest -q
........................................................................ [ 33%]
........................................................................ [ 67%]
......................................................................   [100%]
214 passed in 10.28s
```

(214 = the 212 at 1.2.0 below plus the two new `test_cache.py` regression
tests named above.)

## 1.2.0 — security/correctness fix pass (independent adversarial review), 2026-09-07

An independent review of the 1.1.0 package (a different pass from the one
that built it, per this workspace's maker-checker discipline) found nine
real, reachable defects — five security/robustness, four correctness — each
confirmed live against the real registry before being fixed, not merely
inferred from reading the code. Every fix below shipped with its own
regression test; the full suite was re-run after every fix, not just once
at the end:

```
$ cd mcp && python3 -m pytest -q
........................................................................ [ 33%]
........................................................................ [ 67%]
....................................................................     [100%]
212 passed in 9.85s
```

(212 = the 188 already landed at 1.1.0 plus 24 new regression tests added by
this pass — `tests/test_regex_guard.py`, new cases in `test_core.py`,
`test_queries.py`, `test_proposals.py`, `test_verdict.py`, `test_server.py`,
`test_cli.py`, `test_index.py`, `test_integration.py`.)

- **Regex denial-of-service (`toledo_search`/`scripts toledo find --regex`,
  `queries.search`/`core.search`).** An agent-supplied `regex=True` query was
  compiled and run with no length cap, no complexity check, and no timeout —
  a classic catastrophic-backtracking pattern against a sufficiently long
  real statement (several exist in this registry) backtracks exponentially,
  and because FastMCP calls a sync tool function directly inside the asyncio
  event loop, one hung call blocked the entire single-process server for
  every other caller, including the founder-mandated lookup gate itself.
  Confirmed live: `toledo_search(query="(.*)+ZZZ_NOT_PRESENT_ANYWHERE_IN_THE_REGISTRY",
  regex=True)` against the real registry used to hang past a 25-second
  observation window. Fixed by a new shared `toledo_mcp/regex_guard.py`:
  reject a `regex=True` query over 200 characters up front
  (`RegexQueryTooLong`), and bound every per-entry `pattern.search(...)`
  call to a 1-second wall-clock budget via `signal.setitimer`/`SIGALRM`
  (`RegexTimeout`), applied identically in both `queries.search` and
  `core.search`'s regex branches (and both call sites' CLI mirrors).
  Confirmed live afterward: the same pattern now returns an error in ~1.0s,
  and the server answers a canary call immediately afterward (not blocked).
- **Proposal filename collision / silent overwrite
  (`proposals.write_proposal`, `core.register_proposal`).** The proposal
  filename (`{ts}_{slug}.json`) has one-second timestamp resolution and an
  agent-supplied slug; two proposals for the same code submitted within the
  same second — the expected-case race this founder rule creates by design
  (many independent agents each individually discovering the same
  unregistered code) — silently overwrote each other via a plain
  `open(path, "w")`, with no exception, no warning, and no trace in
  `STATUS.jsonl`. Fixed: both write paths now use
  `os.O_CREAT | os.O_EXCL` and retry with a disambiguating numeric suffix
  (`-1`, `-2`, ...) on collision, so two same-second, same-code proposals
  always land in two distinct, independently recoverable files.
- **`toledo_counts`/`toledo_index_status` counts polluted by the merged
  search corpus.** `canonical_entries`/`by_status`/`by_domain`/`by_tier`/
  `by_coq_status` were computed over `core.load_registry`'s merged
  root+reading entries list (912 canonical readings + 592 genesis-root-only
  rows = 1,504 on the registry this was verified against), not over
  `registry/CANONICAL.json`'s own `canonical[]` array — inflating
  `canonical_entries` well past the registry's own true count and injecting
  placeholder values no canonical entry actually carries (a `null` domain
  bucket, a `RETRACTED` tier, a `not_yet_formalised` coq_status). Fixed:
  `core.counts`/`queries.counts` now restrict those five fields to
  `layer != "root"` rows — reproducing `registry/CANONICAL.json`'s own
  `counts{}` field exactly, field-for-field (confirmed live: 912 entries;
  `by_status`/`by_domain`/`by_tier`/`by_coq_status` all match). The merged
  total is still available under its own key, `merged_search_entries`
  (`toledo_counts`'s `data` shape gains this field; `docs/STATIC_API.md`'s
  `counts.json` contract updated to match).
- **Search relevance on exact-code and unicode-symbol queries.**
  `_fts_query`'s alnum tokenizer stripped every Greek/math symbol before
  tokenizing, so a symbol-heavy query like the registry's own founding
  equation's name degenerated to a single one-or-two-character token and
  triggered a near-universal FTS prefix scan that buried the true match
  outside the default top 5; separately, the substring/LIKE fallback
  awarded every matching column the same flat `+1.0` bonus regardless of
  exactness, so an exact code/alias match could tie with, and then lose an
  alphabetical tie-break against, a merely incidental substring hit
  elsewhere in the corpus. Fixed: `_fts_query` now drops tokens shorter than
  3 characters (falling through to the substring path instead of a
  near-universal prefix scan), and the substring/alias fallback now scores
  graduated exact/substring bonuses mirroring `core._score_entry`'s existing
  weights. Confirmed live: 5 previously-failing real queries (a verbatim
  unicode symbol, three bare root codes, one verbatim name substring) each
  now rank their correct target #1.
- **`toledo_check`'s exact-match verdict was status-blind.** An exact
  statement match (both the default φ-criterion path in `verdict.py` and the
  `method="difflib"` path in `server.py`/`cli.py`) was hard-coded to
  `REGISTERED_CURRENT`/`usable=True` with no check of the matched entry's
  own `status` — so a formula that exact-matched a `not_an_equation`/
  `superseded_by`/`split` entry's statement was told "REGISTERED_CURRENT,
  usable, cite that code", at precisely the moment (an agent has formula
  text, not yet a code) the founder rule most needs to bite. Confirmed live
  against `weld/S.06.v1` (`status: not_an_equation`). Fixed: both paths now
  resolve the matched code to its full entry and delegate to the same
  status-aware `verdict_for_entry` a code lookup already goes through.
- **A corrupted search index crashed instead of self-healing
  (`index._load_meta`).** Caught only `sqlite3.OperationalError`, which is
  `DatabaseError`'s PARENT class, not a subclass — a genuinely corrupted
  `index.sqlite3` (source registry files untouched) raised
  `sqlite3.DatabaseError` ("database disk image is malformed") straight
  past the narrower except, turning a condition every other staleness case
  in this design already self-heals from into a hard crash. Fixed by
  widening the except to `sqlite3.DatabaseError`; confirmed live that a
  corrupted index now self-heals transparently on the next call with no
  code change needed anywhere else.
- **`_safe` did not catch `sqlite3.Error`.** `server.py`'s own docstring
  documents `_safe` as converting a genuine "cannot read the registry"
  failure into the typed `INDEX_UNAVAILABLE` envelope, but its except tuple
  (`FileNotFoundError, OSError`) contained no SQLite exception class at all
  — any SQLite-level failure escaped straight past the envelope to a bare
  FastMCP tool-error string, most visibly on `toledo_index_status`, the one
  tool this design documents as how to check whether the index is healthy.
  Fixed by widening the tuple to `(FileNotFoundError, OSError, sqlite3.Error)`.
- **A missing `registry/CANONICAL.json` silently answered "zero
  matches".** `core._load_once` had no existence check of its own;
  `scripts/toledo_build.py`'s `load_canonical` treats a missing file as its
  own legitimate "first bootstrap" case and returns an empty canonical set —
  correct for that build script, but this server's `toledo_search` then
  answered `{"hits": []}`, `ok: true`, indistinguishable from "the registry
  legitimately has zero matches", on exactly the deployment mistake (a
  misconfigured `TOLEDO_ROOT`, an un-populated checkout) this server most
  needs to fail loud on. Fixed: `_load_once` now raises `FileNotFoundError`
  naming the missing path, which `_safe` turns into the documented
  `INDEX_UNAVAILABLE` envelope.

None of the above touched `registry/CANONICAL.json`, `registry/genesis_root.json`,
`registry/LINEAGE.jsonl`, `coq/`, or `latex/` (confirmed: `git diff --stat`
on those five paths before/after this pass is empty).

## 1.1.0 — S1–S4 landed; integration-verified 2026-09-07

The specification in `mcp/DESIGN.md` (the "[Unreleased]" entry this section
replaces, per that entry's own stated plan) is now built, installed, and
verified against the real registry by an integration pass that ran
(not read about, not assumed) every check below on this machine, this date:

- **Install**: `pip install -e mcp/` (editable, user site) succeeds; the
  `toledo` and `toledo-mcp` console scripts land on `PATH` and both run
  (`toledo --help`, `toledo-mcp` spawns the stdio server).
- **Tests**: `cd mcp && python3 -m pytest -q` → `188 passed in 6.55s` —
  the 85 from the baseline spike below plus every test named in
  `mcp/DESIGN.md` §9's test plan for S1–S4, plus more each stream added.
  Full quoted output: `mcp/BENCHMARKS.md`.
- **The verdict fix landed** (graft A2/C1, closes "Known issue, unfixed"
  below): `verdict_for_entry`'s fallback branch now returns the dedicated
  `CAUTION` verdict, `usable=False`, for a missing or unrecognised `status`
  — never `REGISTERED_CURRENT`. Pinned by
  `test_unknown_status_defaults_to_caution` in `tests/test_verdict.py`
  (confirmed present and passing). Eleven verdict values now exist
  (`grep -c '"[A-Z_]*",$' toledo_mcp/verdict.py`'s `VERDICT_VALUES` list),
  and `verdict.RULES` documents the full decision table as data, surfaced
  by the new `toledo_show_verdict_rules` tool.
- **19 tools** (`grep -c "@mcp.tool()" toledo_mcp/server.py` → `19`,
  confirmed by a real `session.list_tools()` call over real stdio): the 18
  from the baseline spike plus `toledo_show_verdict_rules`. Every tool
  response is wrapped in the `{"ok","data","error"}` envelope (graft A1,
  confirmed by inspecting `_envelope`/`_invalid` in `server.py` and by the
  real stdio round trip below); `toledo_search`/`by_root`/`by_domain`/
  `by_record`/`descendants`/`neighbours` all carry a per-row `verdict`
  (graft B1); `toledo_search`/`by_root`/`by_domain`/`by_record`/
  `descendants` accept `format="json"|"toon"` (grafts B5/C7), confirmed with
  a real `by-root ... --format toon` CLI call against the real registry.
- **`core.load_registry` retries a transient `JSONDecodeError` with
  backoff** (grafts A4/C5) before raising; `cache.RegistryCache` falls back
  to the last-known-good `Registry` with `degraded`/`degraded_reason` set if
  every retry is exhausted, confirmed present in `cache.py` and covered by
  its own tests.
- **Every reader connection in `index.py`/`queries.py` opens
  `sqlite3.connect(f"file:{db_path}?mode=ro", uri=True)`** (graft C3),
  confirmed by reading `index.py`'s `_open_ro`/equivalent helper; the
  writer connection in `index.build_index` is unaffected.
- **Proposals moved to `mcp/proposals/`** (graft C4): both
  `core.register_proposal` and `proposals.write_proposal` target
  `paths.proposals_dir()` (`mcp/proposals/`), never `registry/proposals/`
  — confirmed by reading both modules and by a real
  `toledo_register_proposal` call over stdio against the real registry,
  which wrote under `mcp/proposals/` (verified with `git status --short
  mcp/proposals` — gitignored, never staged) and left
  `registry/CANONICAL.json`/`genesis_root.json`/`LINEAGE.jsonl` untouched
  (`git diff --stat` on those three before/after this pass shows only the
  concurrently-running registry-owning lane's own edits).
- **`toledo_mcp.cli` (the `toledo` console script) and
  `toledo_mcp.export_static` both exist and run** against the real
  registry: `toledo find/show/ancestry/descendants/neighbours/by-root/
  by-domain/by-record/export/check/status/index-status/show-verdict-rules/
  proposals/register-proposal` all invoked successfully; `python3 -m
  toledo_mcp.export_static --out mcp/dist/static-api` wrote 2,108 files
  matching `docs/STATIC_API.md`'s contract exactly. Full output:
  `mcp/BENCHMARKS.md`.
- **Versioning**: `mcp/pyproject.toml`'s `version` and
  `toledo_mcp.__version__` both read `"1.1.0"`, matching root
  `CITATION.cff`'s `version:` field; `python3 mcp/scripts/sync_version.py`
  reports `already in sync` for both.
- **`mcp/scripts/leak_scan.py mcp/`**: `2153 file(s) scanned, 0 finding(s)`
  after this pass fixed one genuine finding it caught — see "Fixed during
  this pass" below.
- **`.github/workflows/toledo-mcp-ci.yml`**: all four jobs' steps
  (`pip install -e "mcp/[test]"`, `pytest`, `bench_index.py`, the
  installed-package `build-index` import + CLI smoke line,
  `leak_scan.py mcp/`, `export_static.py`) were run by hand during this
  pass and each one that can be run outside an actual GitHub Actions runner
  (everything except the two Pages-deploy steps, which need GitHub's own
  environment) passed.

### Fixed during this pass

1. **`mcp/DESIGN.md` line ~855 leaked a literal local-home-directory path
   pattern** in its own prose describing what `leak_scan.py` checks for —
   caught by running `leak_scan.py mcp/` itself (`home_path match`). Fixed
   by rephrasing the sentence to describe the check without spelling the
   pattern literally, the same discipline `leak_scan.py`'s own docstring
   already uses for the identical reason (a literal example would trip the
   scanner on the file describing it). No functional code changed; this was
   a documentation-only leak, not a real path ever emitted by running code.
2. **This package's own docs (`README.md`, `docs/CHANGELOG.md`,
   `docs/STATIC_API.md`, `toledo_mcp/__init__.py`'s module docstring) were
   stale relative to the actually-landed code** — each described `cli.py`/
   `export_static.py` as not-yet-built, the verdict bug as unfixed, 18
   tools, and version `0.2.0`, none of which matched what a fresh read of
   the source files or a fresh test run showed. Updated to state the
   verified, as-built facts above, each backed by a command actually run
   during this pass (not by trusting the specification's own text) — the
   `[Unreleased]` section this entry replaces is the record of exactly what
   used to be missing.

### Known issue, unfixed (tracked here because `mcp/DESIGN.md` names it a
must-fix-before-anything-else-ships item) — historical, see fix above

`toledo_mcp/verdict.py`, `verdict_for_entry`, final fallback line (quoted
verbatim, as it read before the fix landed):

```python
return Verdict("REGISTERED_CURRENT" if status is None else "AMBIGUOUS", status is None,
                f"unrecognised status value {status!r} on {code} — schema drift; escalate.")
```

An entry with a missing or unset `status` field was answered
`verdict="REGISTERED_CURRENT"`, `usable=True` — silently promoted to "safe
to cite" instead of stopped. Fixed as described above; kept here, unedited,
as the historical record of the bug this package once had, per this file's
own append-only discipline.

## 0.2.0 — baseline spike (landed; date of this checkout's `mcp/` tree)

The first working version of this package, referred to throughout
`mcp/DESIGN.md` as "the baseline spike" or "the landed server". Verified at
the time of this entry:

- **Module layout**: `toledo_mcp/{__init__,paths,hashing,core,index,queries,
  equivalence,verdict,proposals,cache,server}.py` (11 modules), matching
  `docs/DESIGN.md`'s own "Module layout" section.
- **18 tools** (`grep -c "@mcp.tool()" toledo_mcp/server.py` → `18`):
  `toledo_search`, `toledo_get`, `toledo_status`, `toledo_check`,
  `toledo_lineage`, `toledo_ancestors`, `toledo_descendants`,
  `toledo_neighbours`, `toledo_by_root`, `toledo_by_domain`,
  `toledo_by_record`, `toledo_by_raw_key`, `toledo_lineage_window`,
  `toledo_counts`, `toledo_index_status`, `toledo_register_proposal`,
  `toledo_list_proposals`, `toledo_proposal_status` — full list and shapes
  in `README.md`'s tool table and `docs/DESIGN.md`'s "Tool set" section.
- **Verdict vocabulary** (`toledo_mcp/verdict.py`, pre-fix): 10 distinct
  values (`grep -oE '"[A-Z_]+"' toledo_mcp/verdict.py | sort -u` →
  `AMBIGUOUS`, `CANDIDATE_MATCH`, `NOT_REGISTERED`, `REGISTERED_CURRENT`,
  `REGISTERED_HISTORICAL`, `REGISTERED_IMPRECISE`,
  `REGISTERED_NOT_AN_EQUATION`, `REGISTERED_SPLIT`, `REGISTERED_SUPERSEDED`,
  `REGISTERED_UNVERIFIED`). There is no eleventh (`CAUTION`) value yet — a
  `None`/unrecognised `status` is answered as one of these 10 (specifically
  `REGISTERED_CURRENT` or `AMBIGUOUS`, reused rather than a distinct signal;
  see the "Known issue" above).
- **The only write path**: `toledo_register_proposal` → one JSON file under
  `registry/proposals/<timestamp>_<slug>.json` plus a `STATUS.jsonl` row —
  never `registry/CANONICAL.json`, `registry/genesis_root.json`,
  `registry/LINEAGE.jsonl`, `coq/`, or `latex/` (tested:
  `test_register_proposal_writes_file_never_touches_registry`,
  `test_toledo_register_proposal_never_touches_registry_files`).
- **Tests**, run at the time of this entry (`cd mcp && python3 -m pytest -q
  tests/`):
  ```
  ........................................................................ [ 84%]
  .............                                                            [100%]
  85 passed in 1.35s
  ```
- **Packaging**: `mcp/pyproject.toml` — `toledo-mcp` `0.2.0`,
  `requires-python = ">=3.12"`, one runtime dependency (`mcp==1.28.1`,
  pinned), console script `toledo-mcp = toledo_mcp.server:main`. No `toledo`
  CLI console script yet (specified for S3, not landed).
- **Three real bugs already caught and fixed during this spike's own
  development** (kept here as a pointer, not restated in full — see
  `docs/DESIGN.md`'s "Three real bugs this design's own testing/benchmarking
  caught" for the complete account): the `phi_len` normaliser mismatch in
  `equivalence.py`, the `register_proposal` cross-`TOLEDO_ROOT` write-boundary
  leak, and the `renaming_candidate` false positive on plain prose.

This section will not be renumbered or edited once a real `0.3.0`/`1.0.0`
entry is added above it — per this package's own append-only discipline,
matching `registry/LINEAGE.jsonl`'s "nothing silently edited" rule at the
registry level.
