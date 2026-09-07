"""Tests for scripts/register_reproduction_evidence.py -- builds Toledo's
registry/reproduction_card_index.json + registry/review_report_index.json from a fake glosa
checkout (a real git repo under tmp_path, never the real ../glosa checkout), so this stays
independent of whatever reproduction cards happen to exist there at test time.
"""
import json
import pathlib
import subprocess
import sys

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO_ROOT / "scripts"))
import register_reproduction_evidence as rre  # noqa: E402


def _git(repo, *args):
    subprocess.run(["git", "-C", str(repo), *args], check=True, capture_output=True, text=True)


def _make_fake_glosa_repo(tmp_path) -> pathlib.Path:
    repo = tmp_path / "glosa"
    (repo / "cases" / "repro").mkdir(parents=True)
    (repo / "reviews" / "routes" / "some-claim" / "repro-verify-CARD-1").mkdir(parents=True)
    card = {
        "id": "CARD-1",
        "toledo_codes": ["EQ-999"],
        "claim": "a test claim",
        "preregistered_prediction": {"declared_at": "2026-09-08T09:00:00Z", "tolerance": "±5%"},
        "oracle": {"kind": "published_value", "source": "a test oracle"},
        "run": {"command": "true", "ai_at_runtime": 0, "date": "2026-09-08T10:00:00Z"},
        "result": {"status": "PASS", "observed": 1, "deviation": 0},
        "notes": "a test card, not AOWC-qualifying by any special marker",
    }
    (repo / "cases" / "repro" / "CARD-1.json").write_text(json.dumps(card), encoding="utf-8")
    review_yaml = (
        "route_id: repro-verify-CARD-1\n"
        "reviewer_identity: checker1\n"
        "independence_class: I2\n"
        "verdict_tier: finite_diagnostic\n"
        "claim_ref: a test claim\n"
    )
    (repo / "reviews" / "routes" / "some-claim" / "repro-verify-CARD-1" / "review_report.yaml").write_text(
        review_yaml, encoding="utf-8",
    )
    _git(repo, "init", "-q")
    _git(repo, "config", "user.email", "test@example.invalid")
    _git(repo, "config", "user.name", "test")
    _git(repo, "add", "-A")
    _git(repo, "commit", "-q", "-m", "fixture")
    return repo


def test_build_indexes_one_card_and_its_review(tmp_path):
    glosa_repo = _make_fake_glosa_repo(tmp_path)
    card_paths = rre.find_repro_cards(glosa_repo)
    review_paths = rre.find_review_reports(glosa_repo)
    assert len(card_paths) == 1
    assert len(review_paths) == 1

    repro_doc, review_doc = rre.build(glosa_repo, card_paths, review_paths)

    assert len(repro_doc["cards"]) == 1
    card_row = repro_doc["cards"][0]
    assert card_row["toledo_codes"] == ["EQ-999"]
    assert card_row["result"]["status"] == "PASS"
    assert card_row["citation"]["repo"] == "glosa"
    assert card_row["citation"]["id"] == "CARD-1"
    assert card_row["citation"]["commit"] == repro_doc["source_commit"]
    assert len(repro_doc["source_commit"]) == 40  # a real git commit sha, not a placeholder

    assert len(review_doc["reviews"]) == 1
    review_row = review_doc["reviews"][0]
    # the review's own toledo_codes are inherited from the SAME card via the
    # repro-verify-<card id> route_id convention (cli/glosa's own naming),
    # never guessed from the review's free-text claim_ref.
    assert review_row["toledo_codes"] == ["EQ-999"]
    assert review_row["independence_class"] == "I2"
    assert review_row["citation"]["commit"] is None
    assert "excludes reviews/routes/" in review_row["citation"]["commit_note"]
    assert len(review_row["citation"]["content_sha256"]) == 64


def test_build_is_idempotent_and_never_duplicates_across_reruns(tmp_path):
    glosa_repo = _make_fake_glosa_repo(tmp_path)
    card_paths = rre.find_repro_cards(glosa_repo)
    review_paths = rre.find_review_reports(glosa_repo)
    doc_a, _ = rre.build(glosa_repo, card_paths, review_paths)
    doc_b, _ = rre.build(glosa_repo, card_paths, review_paths)
    assert len(doc_a["cards"]) == len(doc_b["cards"]) == 1


def test_main_writes_both_index_files(tmp_path):
    glosa_repo = _make_fake_glosa_repo(tmp_path)
    out_repro = tmp_path / "out" / "reproduction_card_index.json"
    out_review = tmp_path / "out" / "review_report_index.json"
    code = rre.main([
        "--glosa-repo", str(glosa_repo),
        "--out-repro-index", str(out_repro),
        "--out-review-index", str(out_review),
    ])
    assert code == 0
    assert out_repro.is_file()
    assert out_review.is_file()
    written = json.loads(out_repro.read_text(encoding="utf-8"))
    assert len(written["cards"]) == 1
    # no local absolute filesystem path anywhere in either written file (leak-scan
    # regression: this script must cite by repo-relative path only; this comment
    # deliberately never spells the pattern itself, same convention as
    # mcp/scripts/leak_scan.py's own docstring, since this file is scanned too).
    for doc_path in (out_repro, out_review):
        text = doc_path.read_text(encoding="utf-8")
        assert str(glosa_repo) not in text


def test_no_glosa_repo_reports_error_not_a_crash(tmp_path):
    missing = tmp_path / "does-not-exist"
    code = rre.main(["--glosa-repo", str(missing)])
    assert code == 2


def test_parse_hash_match_reads_the_verdict_text_structurally():
    """`scripts/compute_resistance.py`'s `card_holds_r3` reads `citation.hash_match` as a boolean
    -- this is the parse that populates it from `cli/glosa`'s own verdict-text convention
    ("... input_hash MATCH (...), output_hash MATCH|MISMATCH (...)."). Never guessed when neither
    word appears."""
    assert rre.parse_hash_match(
        "hash match on re-execution: input_hash MATCH ('a' vs recorded 'a'), "
        "output_hash MISMATCH ('b' vs recorded 'c')."
    ) is False
    assert rre.parse_hash_match(
        "hash match on re-execution: input_hash MATCH ('a' vs recorded 'a'), "
        "output_hash MATCH ('b' vs recorded 'b')."
    ) is True
    assert rre.parse_hash_match(None) is None
    assert rre.parse_hash_match("") is None
    assert rre.parse_hash_match("something unrelated") is None


def test_review_row_carries_hash_match_from_the_verdict(tmp_path):
    glosa_repo = _make_fake_glosa_repo(tmp_path)
    review_path = glosa_repo / "reviews" / "routes" / "some-claim" / "repro-verify-CARD-1" / "review_report.yaml"
    review_path.write_text(
        review_path.read_text(encoding="utf-8")
        + "verdict: 'hash match on re-execution: input_hash MATCH (a vs a), output_hash MISMATCH (b vs c).'\n",
        encoding="utf-8",
    )
    card_paths = rre.find_repro_cards(glosa_repo)
    review_paths = rre.find_review_reports(glosa_repo)
    _repro_doc, review_doc = rre.build(glosa_repo, card_paths, review_paths)
    assert review_doc["reviews"][0]["citation"]["hash_match"] is False
    # registry/SCHEMA.md addendum: verify_outcome is the same fact spelled the way cli/glosa's
    # own verdict text does -- one parse (parse_hash_match), two renderings.
    assert review_doc["reviews"][0]["citation"]["verify_outcome"] == "MISMATCH"


def test_verify_outcome_of_is_a_total_three_valued_rendering_of_hash_match():
    assert rre.verify_outcome_of(True) == "MATCH"
    assert rre.verify_outcome_of(False) == "MISMATCH"
    assert rre.verify_outcome_of(None) is None
