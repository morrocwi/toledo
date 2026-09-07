"""Tests for the GENERATOR + TOOLING layer (scripts/toledo_build.py, scripts/toledo,
site/build_site.py) against the fixture tests/fixtures/CANONICAL.sample.json.

Run in isolation into a tmp_path output root so this never touches the real
registry/ or sample_output/ directories.
"""
import json
import pathlib
import subprocess
import sys

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent
FIXTURE = REPO_ROOT / "tests" / "fixtures" / "CANONICAL.sample.json"

sys.path.insert(0, str(REPO_ROOT / "scripts"))
import toledo_build  # noqa: E402
import compute_resistance  # noqa: E402


def _build(tmp_path):
    toledo_build.ASSUMPTIONS_MADE.clear()
    out_root = tmp_path / "out"
    report = toledo_build.run_build(FIXTURE, None, out_root)
    return out_root, report


def test_build_produces_expected_files(tmp_path):
    out_root, report = _build(tmp_path)
    assert report["entries"] == 6
    assert (out_root / "registry" / "TOLEDO.json").exists()
    assert (out_root / "graph" / "toledo_graph.json").exists()
    assert (out_root / "graph" / "toledo.graphml").exists()
    assert (out_root / "graph" / "toledo.ttl").exists()
    assert (out_root / "site" / "index.json").exists()
    assert (out_root / "latex" / "catalogue_body.tex").exists()
    for code in ["SMP-ROOT", "SMP-ROOT2", "SMP-ROOT__H_01_v1", "SMP-ROOT2__S_01_v1",
                 "SMP-ROOT__H_02_v1", "SMP-ROOT__H_03_v1"]:
        assert (out_root / "registry" / "entries" / f"{code}.json").exists(), code
        assert (out_root / "vault" / f"{code}.md").exists(), code


def test_jsonld_has_context(tmp_path):
    out_root, _ = _build(tmp_path)
    doc = json.loads((out_root / "registry" / "entries" / "SMP-ROOT.json").read_text())
    assert "@context" in doc
    assert doc["@context"]["parents"] == "prov:wasDerivedFrom"
    assert doc["@context"]["code"] == "schema:identifier"
    assert doc["code"] == "SMP-ROOT"


def test_graph_edges_match_parents(tmp_path):
    out_root, _ = _build(tmp_path)
    toledo = json.loads((out_root / "registry" / "TOLEDO.json").read_text())
    graph = json.loads((out_root / "graph" / "toledo_graph.json").read_text())
    expected_parent_edges = set()
    for e in toledo["canonical"]:
        for p in e.get("parents", []):
            expected_parent_edges.add((p["code"], e["code"]))
    actual_parent_edges = {
        (edge["source"], edge["target"])
        for edge in graph["edges"] if edge["type"] == "parent"
    }
    assert expected_parent_edges == actual_parent_edges
    node_codes = {n["code"] for n in graph["nodes"]}
    assert node_codes == {e["code"] for e in toledo["canonical"]}


def test_children_computed_by_inversion(tmp_path):
    out_root, _ = _build(tmp_path)
    toledo = json.loads((out_root / "registry" / "TOLEDO.json").read_text())
    by_code = {e["code"]: e for e in toledo["canonical"]}
    assert "SMP-ROOT/H.01.v1" in by_code["SMP-ROOT"]["children"]
    assert "SMP-ROOT/H.02.v1" in by_code["SMP-ROOT"]["children"]
    assert "SMP-ROOT2" in by_code["SMP-ROOT"]["children"]
    assert "SMP-ROOT/H.03.v1" in by_code["SMP-ROOT/H.02.v1"]["children"]


def test_mathml_produced_for_latex_statements(tmp_path):
    out_root, _ = _build(tmp_path)
    doc = json.loads((out_root / "registry" / "entries" / "SMP-ROOT.json").read_text())
    assert doc["presentation_mathml"] is not None
    assert "<math" in doc["presentation_mathml"]
    # SMP-ROOT/H.01.v1 has statement.format == "ascii-math" -> no MathML, with a reason
    reading = json.loads((out_root / "registry" / "entries" / "SMP-ROOT__H_01_v1.json").read_text())
    assert reading["presentation_mathml"] is None
    assert reading["presentation_mathml_reason"]


def test_superseded_entry_has_edge(tmp_path):
    out_root, _ = _build(tmp_path)
    graph = json.loads((out_root / "graph" / "toledo_graph.json").read_text())
    edges = {(e["source"], e["target"], e["type"]) for e in graph["edges"]}
    assert ("SMP-ROOT/H.02.v1", "SMP-ROOT/H.03.v1", "supersedes_by") in edges


def test_cli_ancestry(tmp_path):
    out_root, _ = _build(tmp_path)
    result = subprocess.run(
        [sys.executable, str(REPO_ROOT / "scripts" / "toledo"),
         "--out-root", str(out_root), "ancestry", "SMP-ROOT/H.03.v1"],
        capture_output=True, text=True, check=True,
    )
    assert result.stdout.strip() == "SMP-ROOT -> SMP-ROOT/H.02.v1 -> SMP-ROOT/H.03.v1"


def test_cli_show(tmp_path):
    out_root, _ = _build(tmp_path)
    result = subprocess.run(
        [sys.executable, str(REPO_ROOT / "scripts" / "toledo"),
         "--out-root", str(out_root), "show", "SMP-ROOT2"],
        capture_output=True, text=True, check=True,
    )
    doc = json.loads(result.stdout)
    assert doc["code"] == "SMP-ROOT2"


def test_site_builds(tmp_path):
    out_root, _ = _build(tmp_path)
    sys.path.insert(0, str(REPO_ROOT / "site"))
    import build_site
    # build_site() now requires out_dir/data_dir/templates_dir explicitly
    # (TEST-BREAK-1: the A5 website workflow added these positional params).
    # root=out_root so load_entries()/load_canonical_counts() read the
    # fixture build's own registry/ (written by toledo_build.run_build
    # above), never the real repo's ~967-entry registry; templates_dir
    # points at the real site/templates (the fixture carries no templates
    # of its own). build_data_files()/build_pages() also read, unconditionally,
    # root/registry/CANONICAL.json (counts{} block -- an absent *key* is
    # tolerated, but the file itself must exist), root/mcp/README.md (the
    # tools table) and root/.mcp.json (the /agents/ page) -- none of those
    # are written by run_build, so all three are copied read-only into
    # out_root; out_dir/data_dir stay under tmp_path for isolation, matching
    # this file's own module docstring ("never touches the real ... directories").
    (out_root / "registry").mkdir(parents=True, exist_ok=True)
    (out_root / "registry" / "CANONICAL.json").write_bytes(FIXTURE.read_bytes())
    (out_root / "mcp").mkdir(parents=True, exist_ok=True)
    (out_root / "mcp" / "README.md").write_bytes((REPO_ROOT / "mcp" / "README.md").read_bytes())
    (out_root / ".mcp.json").write_bytes((REPO_ROOT / ".mcp.json").read_bytes())
    site_out = out_root / "site"
    report = build_site.build_site(
        out_root, site_out, site_out / "data", REPO_ROOT / "site" / "templates",
    )
    # Not a fixed literal count: build_pages() emits one page per entry PLUS
    # a growing set of index/listing pages (browse, by-root, by-domain,
    # by-tier, by-status, and any further axis a later stream adds -- this
    # count already moved from 17 to 18 between two runs of this same test
    # during Toledo v1.5 lane A5's own website work, purely from a new
    # legitimate page, not a regression). Asserting the exact number here
    # would make this test flake against ongoing, unrelated feature work in
    # site/build_site.py. What TEST-BREAK-1 actually needs verified is that
    # the build completed honestly (nothing silently skipped or unresolved)
    # and that the per-entry pages this test's other assertions rely on
    # really exist -- a lower bound (>= one page per fixture entry, plus the
    # site's own index) still catches the real regression class (build_site
    # crashing, or writing zero pages) without pinning to a moving total.
    assert report["pages_skipped"] == 0
    assert report["templates_missing"] == []
    assert report["unresolved_placeholders"] == {}
    assert report["pages_written"] >= 7  # >= 6 fixture entries + index.html
    assert (site_out / "index.html").exists()
    assert (site_out / "entries" / "SMP-ROOT.html").exists()
    for code in ["SMP-ROOT", "SMP-ROOT2", "SMP-ROOT__H_01_v1", "SMP-ROOT2__S_01_v1",
                 "SMP-ROOT__H_02_v1", "SMP-ROOT__H_03_v1"]:
        assert (site_out / "entries" / f"{code}.html").exists(), code


# ---------------------------------------------------------------------------
# Resistance Ladder + Reproduction Ledger (S3, design/RESISTANCE_LADDER_v0_1.md,
# founder ruling BBL-2026-09-07-229). scripts/compute_resistance.py's own pure
# rung-computation functions first (no files touched), then its file-level
# run() against isolated tmp_path copies (never the real registry/ — S1's
# glosa CLI has not landed yet at the time these tests were written, and even
# once it has, this file must never race a concurrently-running registrar
# lane over the real registry/CANONICAL.json / registry/genesis_root.json),
# then propagation through scripts/toledo_build.py (the fixture's own
# SMP-ROOT entry carries a hand-seeded `resistance` block; SMP-ROOT2 carries
# none, exercising the "not yet computed" honest-absence path).
# ---------------------------------------------------------------------------

def test_compute_rungs_never_collapses_to_a_scalar():
    """sec.0's binding design principle, checked mechanically: the return
    shape is exactly the seven named rungs, each its own dict — never a
    'score'/'total'/percentage key anywhere in the structure."""
    rungs = compute_resistance.compute_rungs("SMP-X", "E = m c^2", None, [], [], [])
    assert set(rungs.keys()) == set(compute_resistance.RUNG_ORDER)
    for r, row in rungs.items():
        assert set(row.keys()) <= {"held", "evidence", "reason"}
        assert isinstance(row["held"], bool)
        assert isinstance(row["evidence"], list)


def test_compute_rungs_r0_true_r2_only_on_closed_coq():
    rungs_no_coq = compute_resistance.compute_rungs("SMP-X", "E = m c^2", None, [], [], [])
    assert rungs_no_coq["R0"]["held"] is True
    assert rungs_no_coq["R2"]["held"] is False
    assert "not 'closed'" in rungs_no_coq["R2"]["reason"]

    rungs_empty_statement = compute_resistance.compute_rungs("SMP-X", "", None, [], [], [])
    assert rungs_empty_statement["R0"]["held"] is False

    coq_closed = {"file": "coq/canonical/SMP_X.v", "coq_status": "closed"}
    rungs_closed = compute_resistance.compute_rungs("SMP-X", "E = m c^2", coq_closed, [], [], [])
    assert rungs_closed["R2"]["held"] is True
    assert rungs_closed["R2"]["evidence"] == [{"type": "coq", "path": "coq/canonical/SMP_X.v"}]

    coq_definition = {"file": "coq/canonical/SMP_X.v", "coq_status": "definition"}
    rungs_def = compute_resistance.compute_rungs("SMP-X", "E = m c^2", coq_definition, [], [], [])
    assert rungs_def["R2"]["held"] is False, "definition/wrapped_related/etc. must never hold R2"


def _card(**over):
    card = {
        "citation": {"repo": "glosa", "commit": "abc123", "path": "cases/repro/T-1.json", "id": "T-1"},
        "toledo_codes": ["EQ-068"],
        "preregistered_prediction": {"declared_at": "2026-09-08T09:00:00Z", "tolerance": "±5%"},
        "oracle": {"kind": "published_value", "source": "PDG"},
        "run": {"command": "python3 run.py", "ai_at_runtime": 0, "date": "2026-09-08T10:00:00Z"},
        "result": {"status": "FAIL", "observed": 218.005, "deviation": "74.13%"},
    }
    card.update(over)
    return card


def test_compute_rungs_r1_r3_r4_from_a_reproduction_card_including_a_disclosed_fail():
    card = _card()
    rungs = compute_resistance.compute_rungs("EQ-068", "some statement", None, [card], [], [])
    assert rungs["R1"]["held"] is True
    assert rungs["R3"]["held"] is True
    # sec.0's non-tautology rule: a disclosed FAIL still holds R4 — the
    # comparison happened, honestly, which is exactly what R4 certifies.
    assert rungs["R4"]["held"] is True
    assert rungs["R4"]["evidence"][0]["id"] == "T-1"
    # R6 is derived from the card's own real fields (frozen before the run,
    # AI=0, a non-vacuous declared tolerance) -- never a bespoke
    # `aowc_qualifying` field (design doc sec.1/sec.5: "not a new schema
    # field"; integration fix 2026-09-08, see card_holds_r6's own
    # docstring). This card's own defaults already satisfy all four AOWC
    # conditions, so a disclosed FAIL holds R6 too -- exactly the founder's
    # own paradigm case (EQ-068 fails PDG and that FAIL is still filed as
    # R4/R6 evidence, never hidden).
    assert rungs["R6"]["held"] is True
    assert rungs["R6"]["evidence"][0]["id"] == "T-1"


def test_compute_rungs_r6_from_the_cards_own_real_aowc_conditions():
    """R6 (integration fix 2026-09-08: no more `aowc_qualifying` field —
    design doc sec.1/sec.5 is explicit this must be derived from the card's
    own fields, matching glosa's kernel/glosa_kernel.py::aowc_gate_check)."""
    # All four real conditions hold (frozen before run, AI=0, PASS/FAIL
    # result, non-vacuous tolerance) -> R6 held.
    card = _card()
    rungs = compute_resistance.compute_rungs("EQ-068", "s", None, [card], [], [])
    assert rungs["R6"]["held"] is True

    # A vacuous/always-pass tolerance text never holds R6 (RET-N18's own
    # "T is allowed to count against H" condition) even though R4 holds.
    card_vacuous = _card()
    card_vacuous["preregistered_prediction"]["tolerance"] = "any value is acceptable"
    rungs2 = compute_resistance.compute_rungs("EQ-068", "s", None, [card_vacuous], [], [])
    assert rungs2["R4"]["held"] is True
    assert rungs2["R6"]["held"] is False

    # A post-hoc "prediction" (declared_at AFTER the run) never holds R1,
    # and therefore never holds R6 either.
    card_posthoc = _card()
    card_posthoc["preregistered_prediction"]["declared_at"] = "2026-09-09T00:00:00Z"
    rungs3 = compute_resistance.compute_rungs("EQ-068", "s", None, [card_posthoc], [], [])
    assert rungs3["R1"]["held"] is False
    assert rungs3["R6"]["held"] is False

    # ai_at_runtime != 0 never holds R6 either (AI=0 at execution is a hard
    # AOWC requirement, re-checked independently of R3/R4's own check).
    card_ai = _card()
    card_ai["run"]["ai_at_runtime"] = 1
    rungs4 = compute_resistance.compute_rungs("EQ-068", "s", None, [card_ai], [], [])
    assert rungs4["R6"]["held"] is False


def test_compute_rungs_r3_held_without_a_result_but_r4_is_not():
    card = _card()
    card["result"] = {"status": "PENDING"}
    rungs = compute_resistance.compute_rungs("EQ-068", "s", None, [card], [], [])
    assert rungs["R3"]["held"] is True, "R3 only needs a filled run{}, regardless of result.status"
    assert rungs["R4"]["held"] is False
    assert "no external-oracle card" in rungs["R4"]["reason"]


def test_compute_rungs_coq_kernel_oracle_never_holds_r4():
    """design doc sec.1/sec.4: a card.oracle.kind == 'coq_kernel' backs R2,
    never R4/R6 — machine-side and world-side resistance stay two separate
    counts, always."""
    card = _card(oracle={"kind": "coq_kernel", "source": "coq/canonical/EQ_068.v"})
    rungs = compute_resistance.compute_rungs("EQ-068", "s", None, [card], [], [])
    assert rungs["R4"]["held"] is False
    assert rungs["R3"]["held"] is True  # the run itself still holds R3


def test_compute_rungs_r3_r4_r6_not_held_when_linked_repro_verify_recorded_a_mismatch():
    """Integration fix, 2026-09-08: found live via a real card (EQ-068) whose OWN card claimed a
    filled run{}, but a linked `glosa repro verify` review_report (registry/review_report_index.json,
    citation.hash_match parsed from the review's own verdict text) recorded an "output_hash
    MISMATCH" -- and the computed resistance block still reported R3/R4/R6 all held:true, with no
    mention of the contradiction anywhere the reader could see it without opening a second file.
    methodology/P22_reproduction_ledger.md item 3: the review, not the maker's own card, is what
    actually holds R3 for anyone but the maker."""
    card = _card()
    review_match = {
        "citation": {"repo": "glosa", "id": "repro-verify-T-1", "path": "reviews/routes/x/repro-verify-T-1/review_report.yaml",
                     "hash_match": False},
        "toledo_codes": ["EQ-068"],
    }
    rungs = compute_resistance.compute_rungs("EQ-068", "some statement", None, [card], [review_match], [])
    assert rungs["R3"]["held"] is False
    assert "MISMATCH" in rungs["R3"]["reason"]
    assert rungs["R4"]["held"] is False, "R4 must not hold when its own R3 basis is contradicted"
    assert rungs["R6"]["held"] is False, "R6 must not hold when its own R4 basis is contradicted"

    # A review that MATCHED (or an unrelated review, or one with no parseable verdict) must never
    # suppress R3 -- only an actual disclosed MISMATCH does.
    review_ok = {
        "citation": {"repo": "glosa", "id": "repro-verify-T-1", "path": "reviews/routes/x/repro-verify-T-1/review_report.yaml",
                     "hash_match": True},
        "toledo_codes": ["EQ-068"],
    }
    rungs_ok = compute_resistance.compute_rungs("EQ-068", "s", None, [card], [review_ok], [])
    assert rungs_ok["R3"]["held"] is True
    assert rungs_ok["R6"]["held"] is True

    review_unrelated = {
        "citation": {"repo": "glosa", "id": "repro-verify-OTHER-CARD", "path": "reviews/routes/y/repro-verify-OTHER-CARD/review_report.yaml",
                     "hash_match": False},
        "toledo_codes": ["EQ-068"],
    }
    rungs_unrelated = compute_resistance.compute_rungs("EQ-068", "s", None, [card], [review_unrelated], [])
    assert rungs_unrelated["R3"]["held"] is True


def test_compute_rungs_r5_needs_independence_class_i2_or_above():
    review_i1 = {"citation": {"repo": "glosa", "id": "REV-1"}, "toledo_codes": ["EQ-068"],
                 "independence_class": "I1"}
    rungs_i1 = compute_resistance.compute_rungs("EQ-068", "s", None, [], [review_i1], [])
    assert rungs_i1["R5"]["held"] is False

    review_i2 = {"citation": {"repo": "glosa", "id": "REV-2"}, "toledo_codes": ["EQ-068"],
                 "independence_class": "I2"}
    rungs_i2 = compute_resistance.compute_rungs("EQ-068", "s", None, [], [review_i2], [])
    assert rungs_i2["R5"]["held"] is True
    assert rungs_i2["R5"]["evidence"][0]["id"] == "REV-2"


def test_compute_rungs_r1_claim_card_falsifier_fallback():
    claim_todo = {"citation": {"id": "CC-1"}, "toledo_codes": ["EQ-068"], "falsifier": "TODO"}
    rungs_todo = compute_resistance.compute_rungs("EQ-068", "s", None, [], [], [claim_todo])
    assert rungs_todo["R1"]["held"] is False

    claim_real = {"citation": {"id": "CC-2"}, "toledo_codes": ["EQ-068"],
                  "falsifier": "fails if the residual exceeds 5%"}
    rungs_real = compute_resistance.compute_rungs("EQ-068", "s", None, [], [], [claim_real])
    assert rungs_real["R1"]["held"] is True


def _write_json(path, obj):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj), encoding="utf-8")


def test_compute_resistance_run_writes_into_canonical_and_genesis_root(tmp_path):
    canonical = {
        "schema_version": "1.0.0", "canonical": [
            {"code": "EQ-068", "statement": {"latest": "fit statement"},
             "coq": {"coq_status": "not_yet_formalised"}},
        ],
    }
    genesis = {"anchor": {}, "root_equations": [
        {"code": "EQ-045", "statement": "dim Z(g) = 1"},
    ]}
    canonical_path = tmp_path / "CANONICAL.json"
    genesis_path = tmp_path / "genesis_root.json"
    _write_json(canonical_path, canonical)
    _write_json(genesis_path, genesis)

    repro_index = tmp_path / "reproduction_card_index.json"
    _write_json(repro_index, {"cards": [
        {**_card(), "toledo_codes": ["EQ-068"]},
    ]})
    review_index = tmp_path / "review_report_index.json"
    _write_json(review_index, {"reviews": []})
    claim_index = tmp_path / "claim_card_index.json"
    _write_json(claim_index, {"claims": []})

    report = compute_resistance.run(
        canonical_path, genesis_path, repro_index, review_index, claim_index,
    )
    assert report["canonical_entries_computed"] == 1
    assert report["genesis_root_rows_computed"] == 1
    assert report["held_counts"]["R4"] == 1
    assert report["held_counts"]["R6"] == 1

    written_canonical = json.loads(canonical_path.read_text())
    eq068 = written_canonical["canonical"][0]
    assert eq068["code"] == "EQ-068"
    assert eq068["resistance"]["rungs"]["R4"]["held"] is True
    assert eq068["resistance"]["rungs"]["R6"]["held"] is True
    assert eq068["statement"] == {"latest": "fit statement"}, "no content field besides resistance touched"

    written_genesis = json.loads(genesis_path.read_text())
    eq045 = written_genesis["root_equations"][0]
    assert eq045["code"] == "EQ-045"
    assert eq045["resistance"]["rungs"]["R0"]["held"] is True
    assert eq045["resistance"]["rungs"]["R2"]["held"] is False, "root rows never carry coq_status=='closed'"
    assert eq045["statement"] == "dim Z(g) = 1"


def test_compute_resistance_run_missing_index_files_is_honest_absence_not_error(tmp_path):
    canonical_path = tmp_path / "CANONICAL.json"
    _write_json(canonical_path, {"canonical": [
        {"code": "SMP-X", "statement": {"latest": "s"}, "coq": {"coq_status": "not_yet_formalised"}},
    ]})
    missing = tmp_path / "does_not_exist.json"
    report = compute_resistance.run(canonical_path, missing, missing, missing, missing)
    assert report["canonical_entries_computed"] == 1
    assert report["reproduction_cards_indexed"] == 0
    written = json.loads(canonical_path.read_text())["canonical"][0]
    assert written["resistance"]["rungs"]["R3"]["held"] is False
    assert "no reproduction_card references this code" in written["resistance"]["rungs"]["R3"]["reason"]


def test_compute_resistance_dry_run_does_not_write(tmp_path):
    canonical_path = tmp_path / "CANONICAL.json"
    original = {"canonical": [{"code": "SMP-X", "statement": {"latest": "s"}, "coq": {}}]}
    _write_json(canonical_path, original)
    before = canonical_path.read_bytes()
    missing = tmp_path / "does_not_exist.json"
    report = compute_resistance.run(canonical_path, missing, missing, missing, missing, dry_run=True)
    assert report["canonical_entries_computed"] == 1
    assert canonical_path.read_bytes() == before, "dry_run must never touch the file on disk"


def test_resistance_propagates_through_toledo_build_jsonld_and_site_index(tmp_path):
    """SMP-ROOT (fixture) carries a hand-seeded `resistance` block; SMP-ROOT2
    carries none. scripts/toledo_build.py must propagate the first VERBATIM
    and the second as `None` — never recomputing, never inventing seven
    fabricated `unheld` rungs for the entry that has not been checked yet."""
    out_root, report = _build(tmp_path)
    smp_root = json.loads((out_root / "registry" / "entries" / "SMP-ROOT.json").read_text())
    assert smp_root["resistance"]["rungs"]["R0"]["held"] is True
    assert smp_root["resistance"]["rungs"]["R3"]["held"] is True

    smp_root2 = json.loads((out_root / "registry" / "entries" / "SMP-ROOT2.json").read_text())
    assert smp_root2["resistance"] is None

    toledo_doc = json.loads((out_root / "registry" / "TOLEDO.json").read_text())
    by_code = {e["code"]: e for e in toledo_doc["canonical"]}
    assert by_code["SMP-ROOT"]["resistance"]["rungs"]["R3"]["held"] is True
    assert by_code["SMP-ROOT2"].get("resistance") is None

    site_index = json.loads((out_root / "site" / "index.json").read_text())
    rows_by_code = {r["code"]: r for r in site_index["entries"]}
    assert rows_by_code["SMP-ROOT"]["resistance_computed"] is True
    assert set(rows_by_code["SMP-ROOT"]["resistance_rungs_held"]) == {"R0", "R3"}
    assert rows_by_code["SMP-ROOT2"]["resistance_computed"] is False
    assert rows_by_code["SMP-ROOT2"]["resistance_rungs_held"] == []


def test_genesis_row_to_canonical_propagates_resistance_verbatim():
    row_with = {"code": "EQ-999", "statement": "s", "parents": [],
                "resistance": {"computed_at": "2026-09-08", "rungs": {}}}
    entry_with = toledo_build.genesis_row_to_canonical(row_with, {})
    assert entry_with["resistance"] == row_with["resistance"]

    row_without = {"code": "EQ-998", "statement": "s", "parents": []}
    entry_without = toledo_build.genesis_row_to_canonical(row_without, {})
    assert entry_without["resistance"] is None
