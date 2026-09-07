#!/usr/bin/env python3
"""
scripts/register_reproduction_evidence.py -- builds registry/reproduction_card_index.json and
registry/review_report_index.json (registry/SCHEMA.md addendum; scripts/compute_resistance.py's
own documented input contract) from glosa's own Reproduction Cards and review reports.

Toledo mapping is a CITATION, never a copy (glosa methodology/P22_reproduction_ledger.md sec.2,
"P19/P0 one-fact-one-home"; design/RESISTANCE_LADDER_v0_1.md sec.2's own worked example): this
script reads glosa's `cases/repro/<id>.json` cards plus the `review_report.yaml`/`.json` files
glosa's own `glosa repro verify` wrote, and writes one row per artifact into each of Toledo's own
two citation-index files -- it never copies a card/report wholesale beyond the specific fields
`compute_resistance.py`'s own rung predicates read, and every row carries a
`citation{repo, commit, path, id}` pointer back to the glosa checkout (the same shape
`origin.repo_anchor` already uses for other external-repo citations, registry/SCHEMA.md).

Honest exception, stated here rather than silently glossed over: a Reproduction Card's own review
reports live under glosa's `reviews/routes/` tree, which glosa's own `.gitignore` excludes from
git entirely (a local review artifact, never committed) -- so a review row's `citation.commit` is
`null` with a `commit_note` explaining why, and `content_sha256` (of the review file's own raw
bytes, at the time this script ran) stands in as the "pinned, not just trust-me" anchor `origin.
repo_anchor`'s `commit` field would otherwise provide. A repro CARD's citation.commit is real: the
cards live in `cases/repro/`, which IS git-tracked in glosa.

Usage:
  python3 scripts/register_reproduction_evidence.py [--glosa-repo PATH] [--dry-run]

Idempotent: re-running replaces each index file's rows wholesale from glosa's current on-disk
state -- never appends a duplicate row for the same card/review across repeated runs (design doc
S1's own append-only convention is `glosa repro to-ret`'s, a different file; this Toledo-side
index is a full projection of "whatever glosa's cases/repro/ + reviews/routes/ hold right now",
matching `scripts/toledo_build.py`'s own "regenerate, don't append" convention for a build-time
citation table).

Pure Python 3 stdlib except PyYAML (already a Toledo dependency -- scripts/n3_relabel.py) for
reading a `review_report.yaml` file.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import pathlib
import subprocess
import sys

try:
    import yaml  # type: ignore
except ImportError:  # pragma: no cover -- PyYAML is a declared dependency elsewhere in this repo
    yaml = None

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent


def _git(repo: pathlib.Path, *args: str) -> str:
    return subprocess.run(
        ["git", "-C", str(repo), *args], capture_output=True, text=True, check=True,
    ).stdout.strip()


def load_card(path: pathlib.Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def load_review(path: pathlib.Path) -> dict:
    text = path.read_text(encoding="utf-8")
    if path.suffix == ".json":
        return json.loads(text)
    if yaml is None:
        raise RuntimeError(f"PyYAML is required to parse {path} but is not importable")
    return yaml.safe_load(text) or {}


def card_row(card: dict, commit: str, rel_path: str) -> dict:
    """Only the fields `scripts/compute_resistance.py`'s own rung predicates read -- never the
    card's full `lineage`/free-text `notes` prose beyond what R6's tolerance check needs."""
    return {
        "toledo_codes": list(card.get("toledo_codes") or []),
        "claim": card.get("claim"),
        "status": card.get("status"),
        "preregistered_prediction": card.get("preregistered_prediction"),
        "oracle": card.get("oracle"),
        "run": card.get("run"),
        "result": card.get("result"),
        "notes": card.get("notes"),
        "citation": {"repo": "glosa", "commit": commit, "path": rel_path, "id": card.get("id")},
    }


def parse_hash_match(verdict) -> "bool | None":
    """Parse a `glosa repro verify` review_report's own free-text `verdict` field (`cli/glosa`'s
    `cmd_repro_verify`: "hash match on re-execution: input_hash MATCH (...), output_hash
    MATCH|MISMATCH (...).") into a structured boolean `compute_resistance.py`'s `card_holds_r3`
    can read directly, instead of re-parsing prose at rung-computation time (methodology/
    P22_reproduction_ledger.md item 3: this review, not the maker's own first `repro run`, is what
    actually holds R3 for a reader other than the maker -- so a disclosed MISMATCH here must be
    able to reach R3). Returns `None` when there is no verdict text, or it names neither word --
    never guessed."""
    text = str(verdict or "")
    if not text:
        return None
    lower = text.lower()
    if "mismatch" in lower:
        return False
    if "match" in lower:
        return True
    return None


def review_row(review: dict, codes: list, commit_note: str, content_sha256: str, rel_path: str) -> dict:
    return {
        "toledo_codes": codes,
        "claim": review.get("claim_ref"),
        "independence_class": review.get("independence_class"),
        "reviewer_identity": review.get("reviewer_identity"),
        "verdict_tier": review.get("verdict_tier"),
        "citation": {
            "repo": "glosa", "commit": None, "commit_note": commit_note,
            "content_sha256": content_sha256, "path": rel_path, "id": review.get("route_id"),
            "hash_match": parse_hash_match(review.get("verdict")),
        },
    }


def find_repro_cards(glosa_repo: pathlib.Path) -> list:
    return sorted((glosa_repo / "cases" / "repro").glob("*.json"))


def find_review_reports(glosa_repo: pathlib.Path) -> list:
    routes = glosa_repo / "reviews" / "routes"
    if not routes.is_dir():
        return []
    return sorted(routes.glob("**/review_report.yaml")) + sorted(routes.glob("**/review_report.json"))


def build(glosa_repo: pathlib.Path, card_paths: list, review_paths: list) -> "tuple[dict, dict]":
    commit = _git(glosa_repo, "rev-parse", "HEAD")
    gitignored_note = (
        "glosa/.gitignore excludes reviews/routes/ from version control (a local review "
        "artifact, never committed) -- this row's citation is pinned by content_sha256 of the "
        "review file's own raw bytes instead of a commit; readout-not-truth: this is a citation, "
        "not proof the review report will remain reachable at this path indefinitely."
    )

    repro_rows = []
    codes_by_card_id = {}
    for p in card_paths:
        card = load_card(p)
        rel = str(p.resolve().relative_to(glosa_repo.resolve()))
        repro_rows.append(card_row(card, commit, rel))
        codes_by_card_id[card.get("id")] = list(card.get("toledo_codes") or [])

    review_rows = []
    for p in review_paths:
        review = load_review(p)
        rel = str(p.resolve().relative_to(glosa_repo.resolve()))
        route_id = str(review.get("route_id") or "")
        # cli/glosa's own cmd_repro_verify convention: a repro-verify review's route_id is
        # "repro-verify-<card id>" -- match it back to that SAME card's toledo_codes, so this
        # review counts as R5 evidence for the codes the card itself backs (never guessed from
        # the review's own claim_ref text, which is free prose, not a code list).
        card_id = route_id[len("repro-verify-"):] if route_id.startswith("repro-verify-") else None
        codes = codes_by_card_id.get(card_id, [])
        content_sha256 = hashlib.sha256(p.read_bytes()).hexdigest()
        review_rows.append(review_row(review, codes, gitignored_note, content_sha256, rel))

    repro_doc = {
        "schema_version": "1.0.0",
        "source_repo": "glosa", "source_commit": commit,
        "note": "citation index (registry/SCHEMA.md addendum) -- glosa methodology/P22 sec.2's own "
                "citation, never copy: the cards themselves live in glosa's own cases/repro/, this "
                "index is a build-time projection of exactly the fields scripts/compute_resistance.py "
                "reads, regenerated by scripts/register_reproduction_evidence.py, never hand-edited.",
        "cards": repro_rows,
    }
    review_doc = {
        "schema_version": "1.0.0",
        "source_repo": "glosa", "source_commit": commit,
        "note": "citation index (registry/SCHEMA.md addendum), same convention as "
                "reproduction_card_index.json -- see this file's own source_commit for the card "
                "citations; review_report files themselves are git-ignored in glosa (see each "
                "row's own citation.commit_note).",
        "reviews": review_rows,
    }
    return repro_doc, review_doc


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--glosa-repo", type=pathlib.Path, default=REPO_ROOT.parent / "glosa")
    ap.add_argument("--out-repro-index", type=pathlib.Path,
                     default=REPO_ROOT / "registry" / "reproduction_card_index.json")
    ap.add_argument("--out-review-index", type=pathlib.Path,
                     default=REPO_ROOT / "registry" / "review_report_index.json")
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args(argv)

    glosa_repo = args.glosa_repo.resolve()
    if not (glosa_repo / ".git").exists():
        print(f"error: {glosa_repo} is not a git repository (no .git)", file=sys.stderr)
        return 2

    card_paths = find_repro_cards(glosa_repo)
    review_paths = find_review_reports(glosa_repo)
    repro_doc, review_doc = build(glosa_repo, card_paths, review_paths)

    print(f"cards indexed: {len(repro_doc['cards'])} from {glosa_repo}")
    print(f"reviews indexed: {len(review_doc['reviews'])} from {glosa_repo}")
    if args.dry_run:
        return 0

    args.out_repro_index.parent.mkdir(parents=True, exist_ok=True)
    args.out_repro_index.write_text(json.dumps(repro_doc, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    args.out_review_index.write_text(json.dumps(review_doc, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(f"wrote {args.out_repro_index}")
    print(f"wrote {args.out_review_index}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
