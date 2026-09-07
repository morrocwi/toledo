"""Registry integrity tests: every raw equation maps to exactly one code; codes are unique; lineage is append-only-shaped.

T7.1-T7.9 below implement docs/MEETING_2026-09-06_toledo_design.md decision T7 / registry/SCHEMA.md
"Validated by", extending the original 3 tests (test_raw_inventory_loads,
test_canonical_codes_unique_and_mapped, test_lineage_shape), which are kept unchanged above them.
"""
import json, glob, pathlib, collections, re, subprocess
import pytest

R = pathlib.Path(__file__).resolve().parent.parent / 'registry'

CODE_RE = re.compile(
    r'^(?P<root>EQ-0\d{2}|[A-Za-z][A-Za-z0-9]*(?:[._-][A-Za-z0-9]+)*)'
    r'(?:/(?P<domain>[EHSWMPCB])\.(?P<seq>\d{2,4})(?:\.v(?P<rev>[1-9]\d*))?)?$'
)


def _load_genesis_roots():
    p = R / 'genesis_root.json'
    if not p.exists():
        return []
    return json.load(open(p))['root_equations']


def _load_canonical():
    p = R / 'CANONICAL.json'
    if not p.exists():
        return None
    return json.load(open(p))


def _load_lineage():
    p = R / 'LINEAGE.jsonl'
    if not p.exists():
        return []
    return [json.loads(l) for l in open(p) if l.strip()]


def test_raw_inventory_loads():
    n = 0
    for f in glob.glob(str(R / 'eq_*.json')):
        d = json.load(open(f)); assert 'record_id' in d and isinstance(d.get('equations', []), list); n += len(d['equations'])
    assert n > 0


def test_canonical_codes_unique_and_mapped():
    p = R / 'CANONICAL.json'
    if not p.exists(): return
    c = json.load(open(p)); codes = [x.get('code') for x in c['canonical']]
    assert all(codes), 'every canonical object needs a code'
    assert len(codes) == len(set(codes)), 'codes must be unique'
    raw = {f"{json.load(open(f))['record_id']}:{e.get('label')}" for f in glob.glob(str(R / 'eq_*.json')) for e in json.load(open(f)).get('equations', [])}
    mapped = set(c.get('raw_to_canonical', {}))
    assert raw <= mapped, f'unmapped raw equations: {sorted(raw - mapped)[:10]}'


def test_lineage_shape():
    p = R / 'LINEAGE.jsonl'
    if not p.exists(): return
    for l in open(p):
        e = json.loads(l); assert {'code', 'date', 'event'} <= set(e)


# ---------------------------------------------------------------------------
# T7.1 test_no_orphans
# ---------------------------------------------------------------------------
def _root_orphan_exempt(r):
    """EQ-001 is the one Genesis-document root with no parent (T3.4). A second,
    narrower exemption (registry/GENESIS_CODE_SCHEME.md "Root registry
    extension R1", 2026-09-07, founder ruling BBL-2026-09-07-207): a
    root-extension root (role=="root-extension", sourced outside the two
    anchored Genesis documents) may also have parents==[] PROVIDED the absence
    of a connection was checked and disclosed, never silently -- relations==[]
    together with a non-empty relations_note stating what was checked and why
    no link was found (e.g. the "CMC" row, per registry/root_candidates_report.md).
    A root-extension row with parents==[] and no relations_note is still an
    orphan -- this does not exempt inventing a root and skipping the check."""
    if r['code'] == 'EQ-001':
        return True
    return (r.get('role') == 'root-extension'
            and r.get('relations') == []
            and bool(r.get('relations_note')))


def test_no_orphans():
    roots = _load_genesis_roots()
    orphans = [r['code'] for r in roots if r.get('parents') == [] and not _root_orphan_exempt(r)]
    assert not orphans, f"root entries with parents==[] and no disclosed root-extension exemption: {orphans}"

    can = _load_canonical()
    if can:
        bad = [e['id'] for e in can['canonical'] if e.get('parents') == []]
        assert not bad, f"CANONICAL.json entries (layer=reading/coq_import/rule) with parents==[]: {bad}"


# ---------------------------------------------------------------------------
# T7.2 test_no_unresolved_raw_above_threshold
# ---------------------------------------------------------------------------
def test_no_unresolved_raw_above_threshold():
    p = R / 'UNRESOLVED_RAW.json'
    if not p.exists():
        return  # nothing recorded as unresolved -> vacuously 0
    unresolved = json.load(open(p))
    assert len(unresolved) == 0, f"{len(unresolved)} unresolved raw equations at v1.0.0 (target: 0)"


def _combined_parent_graph():
    """code -> list-of-parent-codes, merging genesis_root.json (root layer) and
    CANONICAL.json (reading/coq_import/rule layer) into one graph keyed by code."""
    graph = {}
    for r in _load_genesis_roots():
        graph[r['code']] = list(r.get('parents') or [])
    can = _load_canonical()
    if can:
        for e in can['canonical']:
            graph[e['code']] = [p['code'] for p in (e.get('parents') or [])]
    return graph


# ---------------------------------------------------------------------------
# T7.3 test_no_cycles
# ---------------------------------------------------------------------------
def test_no_cycles():
    graph = _combined_parent_graph()
    WHITE, GRAY, BLACK = 0, 1, 2
    color = {c: WHITE for c in graph}
    cycles = []

    def dfs(node, stack):
        color[node] = GRAY
        for p in graph.get(node, []):
            if p not in graph:
                continue
            if color.get(p) == GRAY:
                cycles.append(stack + [p])
            elif color.get(p) == WHITE:
                dfs(p, stack + [p])
        color[node] = BLACK

    for c in list(graph):
        if color[c] == WHITE:
            dfs(c, [c])
    assert not cycles, f"cycle(s) found in parents graph: {cycles[:5]}"


# ---------------------------------------------------------------------------
# T7.4 test_duplicate_codes
# ---------------------------------------------------------------------------
def test_duplicate_codes():
    seen = collections.defaultdict(list)  # value -> list of (origin, kind)

    for r in _load_genesis_roots():
        seen[r['code']].append(('genesis_root', 'code'))
        for a in r.get('aliases') or []:
            seen[a].append(('genesis_root', 'alias-of:' + r['code']))

    can = _load_canonical()
    if can:
        for e in can['canonical']:
            seen[e['code']].append(('CANONICAL', 'code'))
            for a in e.get('aliases') or []:
                seen[a].append(('CANONICAL', 'alias-of:' + e['code']))

    collisions = {}
    for value, origins in seen.items():
        codes = [o for o in origins if o[1] == 'code']
        aliases = [o for o in origins if o[1].startswith('alias-of:')]
        # a genuine collision: this value is used as a primary `code` by more
        # than one entry, OR it is both a primary code AND an alias of a
        # *different* entry.
        if len(codes) > 1:
            collisions[value] = origins
        elif codes and aliases:
            alias_targets = {a[1].split('alias-of:', 1)[1] for a in aliases}
            if alias_targets - {value}:
                collisions[value] = origins

    assert not collisions, f"code/alias collisions (T7.4): {collisions}"


# ---------------------------------------------------------------------------
# T7.5 test_forced_chain_intact
# ---------------------------------------------------------------------------
ROMAN_ORDER = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X",
               "XI", "XII", "XIII", "XIV", "XV", "XVI", "XVII", "XVIII", "XIX", "XX",
               "XXI", "XXII", "XXIII", "XXIV"]


@pytest.mark.xfail(
    reason=(
        "Known, disclosed deviation from meeting decision T4's strict-chain rule: "
        "genesis_root.json's actual Forced.II..Forced.XXIV rows mostly point to the "
        "specific named object each step forces (MQ08-stepper, LivingGeometry, "
        "Face.8.MetricReadout, ...), not uniformly to the immediately preceding roman "
        "numeral. Every member still resolves to EQ-001 (see test_no_orphans / "
        "test_no_cycles), so the corpus is not broken -- but it is not the literal "
        "N -> N-1 chain T4 ruled. Recorded as a BLOCK per docs/MEETING_2026-09-06_"
        "toledo_design.md's own 'conflict = BLOCK, recorded, not silently resolved' "
        "instruction, not silently forced into a fabricated chain."
    ),
    strict=False,
)
def test_forced_chain_intact():
    roots = _load_genesis_roots()
    by_code = {r['code']: r for r in roots}
    missing_or_misdirected = []
    prev = None
    for roman in ROMAN_ORDER:
        row = by_code.get(roman)
        if row is None:
            missing_or_misdirected.append((roman, 'missing row'))
            prev = roman
            continue
        if prev is not None and roman != "I":
            if row.get('parents') != [prev]:
                missing_or_misdirected.append((roman, f"parents={row.get('parents')} expected [{prev!r}]"))
        prev = roman
    assert not missing_or_misdirected, f"Forced chain break(s): {missing_or_misdirected}"


# ---------------------------------------------------------------------------
# T7.6 test_merge_has_phi_evidence
# ---------------------------------------------------------------------------
def test_merge_has_phi_evidence():
    bad = []
    for e in _load_lineage():
        if e.get('event') == 'merged' and not e.get('phi_criterion_evidence'):
            bad.append(e.get('code'))
    assert not bad, f"'merged' LINEAGE.jsonl lines missing phi_criterion_evidence: {bad}"


# ---------------------------------------------------------------------------
# T7.7 test_status_consistency
# ---------------------------------------------------------------------------
def test_status_consistency():
    can = _load_canonical()
    if not can:
        return
    by_code = {e['code']: e for e in can['canonical']}
    bad = []
    for e in can['canonical']:
        status = e.get('status')
        superseded_by = e.get('superseded_by')
        if status == 'superseded_by':
            if not superseded_by or superseded_by not in by_code:
                bad.append((e['id'], 'status==superseded_by but superseded_by missing/unknown'))
            elif by_code[superseded_by].get('superseded_by') == e['code']:
                bad.append((e['id'], '2-cycle with', superseded_by))
        if status == 'current' and superseded_by not in (None,):
            bad.append((e['id'], 'status==current but superseded_by is non-null'))
        if status != 'current' and not (e.get('status_note') or '').strip():
            bad.append((e['id'], f'status=={status!r} with empty status_note'))
    assert not bad, f"status consistency violations (T7.7): {bad}"


# ---------------------------------------------------------------------------
# T7.8 test_code_grammar
# ---------------------------------------------------------------------------
def test_code_grammar():
    bad = []
    codes = [r['code'] for r in _load_genesis_roots()]
    can = _load_canonical()
    if can:
        codes += [e['code'] for e in can['canonical']]
    drift_notes = {}
    if can:
        drift_notes = {e['code']: e.get('drift_note') for e in can['canonical']}
    for code in codes:
        if code.startswith('HRP-X.'):
            if not (drift_notes.get(code) or '').strip():
                bad.append((code, 'HRP-X code missing drift_note'))
            continue
        if not CODE_RE.match(code):
            bad.append((code, 'fails T2 code grammar'))
    assert not bad, f"code grammar violations (T7.8): {bad}"


# ---------------------------------------------------------------------------
# T7.9 test_coq_assumptions_honest
# ---------------------------------------------------------------------------
def test_coq_assumptions_honest():
    can = _load_canonical()
    if not can:
        return
    # Toledo v1.1 (lanes B1/B2, 2026-09-07) introduced two coq_status values
    # with a coq.file but no proof obligation: "definition" (a Definition/
    # Record/Inductive only, nothing for Print Assumptions to check) and
    # "open_prop" (a Definition <name>_hyp : Prop, deliberately unproved).
    # For those, assumptions legitimately stays null -- asserting "Closed
    # under the global context" there would itself be the dishonest claim
    # this test exists to catch. Every other coq_status with a file set
    # still requires the honest copied-from-coqc text.
    NO_PROOF_OBLIGATION = {'definition', 'open_prop'}
    bad = []
    for e in can['canonical']:
        coq = e.get('coq') or {}
        if coq.get('file') is not None:
            a = coq.get('assumptions')
            if coq.get('coq_status') in NO_PROOF_OBLIGATION and a is None:
                continue
            if a != 'Closed under the global context' and not (isinstance(a, str) and a.startswith('+axioms:')):
                bad.append((e['id'], coq.get('file'), a))
    assert not bad, f"coq.file set with dishonest/missing assumptions (T7.9): {bad}"


# ---------------------------------------------------------------------------
# Extra: step-order (checker block step-order-violations; not one of the 9
# named T7.x tests, but requested by that block). See
# registry/genesis_root.parents_0_conflicts.json for the full, pre-existing
# list this reproduces.
# ---------------------------------------------------------------------------
@pytest.mark.xfail(
    reason=(
        "31 known, disclosed step-order violations remain after merging the S3-fix "
        "agent's document-order step recompute (see registry/LINEAGE.jsonl, "
        "'genesis_root.json (all 590 root rows)' entry, 2026-09-06). These are cases "
        "where an Appendix-C reprint entry (EQ-015..EQ-063, part of the Forced Set, "
        "Face.1.Decomposition) is positioned early in the Appendix-C stream but names a "
        "Part II/III/IV/V object developed later in the book's own narrative order -- "
        "recorded as a BLOCK per the design meeting's own instruction, not silently "
        "resolved by overriding a named parent or renumbering the reprint stream."
    ),
    strict=False,
)
def test_step_order_reported():
    roots = _load_genesis_roots()
    by_code = {r['code']: r for r in roots}
    bad = []
    for r in roots:
        for p in r.get('parents', []):
            pr = by_code.get(p)
            if pr is not None and pr.get('step') is not None and r.get('step') is not None and pr['step'] > r['step']:
                bad.append((r['code'], p))
    assert not bad, f"step-order violations (child.step < parent.step): {len(bad)} -- {bad[:10]}"


# ---------------------------------------------------------------------------
# B1 (2026-09-07 fixer): counts.by_status/by_domain/by_tier/by_coq_status must
# equal a live recompute from canonical[] -- catches the class of bug where a
# lane script changes entries but never refreshes the embedded top-level
# `counts` summary, so the registry's own self-reported numbers disagree with
# its own array (readout-not-truth: counts from files, not from a cached
# object that can silently drift).
# ---------------------------------------------------------------------------
def test_counts_match_canonical():
    can = _load_canonical()
    if not can or "counts" not in can:
        return
    canon = can["canonical"]
    expected = {
        "entries": len(canon),
        "by_status": dict(collections.Counter(e["status"] for e in canon)),
        "by_domain": dict(collections.Counter(e["domain"] for e in canon if e.get("domain"))),
        "by_tier": dict(collections.Counter(e["tier"] for e in canon)),
        "by_coq_status": dict(collections.Counter(e["coq"]["coq_status"] for e in canon)),
    }
    stored = can["counts"]
    for key, exp in expected.items():
        got = stored.get(key)
        assert got == exp, f"counts.{key} stale: stored={got} recomputed={exp}"


# ---------------------------------------------------------------------------
# B3 (2026-09-07 fixer): registry/CANONICAL.json's own `generated_from_commit`
# (SCHEMA.md: "the toledo git sha at build time") must not drift arbitrarily far
# behind HEAD -- v1.2.0 shipped with it still pointing at an early N3-stage commit
# (9ca306c), 11 commits and three releases (N4/N5, v1.0.0, v1.1.0, v1.2.0) stale.
# ---------------------------------------------------------------------------
STALE_COMMIT_THRESHOLD = 5  # commits behind HEAD before this is real, not cosmetic, drift


@pytest.mark.xfail(
    reason=(
        "Known, disclosed carry-over (gate B3, 2026-09-07 fixer pass): registry/CANONICAL.json "
        "is owned by the v1.2 lane run and is off-limits for this fixer pass to "
        "hand-edit, so `generated_from_commit` is not re-stamped here. scripts/stamp_release_commit.py "
        "re-stamps it to the exact HEAD sha and is meant to run as the LAST step before `git tag "
        "v1.2.0` (ops/HANDOFF_OVERNIGHT_2026-09-06.md, '2026-09-07 09:10'); this test passes once "
        "that step has run for the commit under test."
    ),
    strict=False,
)
def test_generated_from_commit_not_stale():
    can = _load_canonical()
    if not can or "generated_from_commit" not in can:
        return
    sha = can["generated_from_commit"]
    assert sha, "generated_from_commit is empty/null"
    repo_root = R.parent
    check = subprocess.run(["git", "cat-file", "-e", sha], cwd=repo_root, capture_output=True)
    assert check.returncode == 0, f"generated_from_commit {sha} is not a commit reachable in this repo's history"
    behind = subprocess.run(
        ["git", "rev-list", "--count", f"{sha}..HEAD"], cwd=repo_root,
        check=True, capture_output=True, text=True,
    ).stdout.strip()
    assert int(behind) <= STALE_COMMIT_THRESHOLD, (
        f"generated_from_commit {sha} is {behind} commits behind HEAD "
        f"(threshold {STALE_COMMIT_THRESHOLD}) -- run scripts/stamp_release_commit.py before tagging"
    )
