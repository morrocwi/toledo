#!/usr/bin/env python3
"""
scripts/compute_resistance.py — S3, Resistance Ladder + Reproduction Ledger
(design/RESISTANCE_LADDER_v0_1.md sec.5, founder ruling BBL-2026-09-07-229,
glosa repo, `toledo/ops/HANDOFF_OVERNIGHT_2026-09-06.md`'s 2026-09-08 entry).

Computes, and is the ONLY script permitted to write, the per-entry
`resistance` block: a SET of R0-R6 rungs, each `{held, evidence[], reason?}`
— never a single collapsed score (design doc sec.0's binding design
principle, restated here because this script is where it is enforced
mechanically: nothing in this file ever emits a scalar).

Reads (never writes, except where named):
  - registry/CANONICAL.json          (reading-layer + any promoted root
                                       entries; `coq{}` block per entry)
  - registry/genesis_root.json       (Layer-0 root rows; these are NOT
                                       stored in registry/CANONICAL.json —
                                       `scripts/toledo_build.py` synthesizes
                                       a CANONICAL-shaped entry for each one
                                       only at BUILD time. Card 1 (EQ-068,
                                       EQ-045, design doc sec.6) targets two
                                       root codes, so a root row needs its
                                       own persisted `resistance` block too,
                                       for the exact same reason CANONICAL.json
                                       entries do — this script writes one
                                       into each `root_equations[]` row here.)
  - registry/reproduction_card_index.json   (S1's citation index — glosa's
                                       `glosa repro run --register-toledo`
                                       appends one row per Reproduction Card
                                       that names a Toledo code; see the
                                       shape documented in this repo's own
                                       registry/SCHEMA.md addendum, since
                                       this file lives in Toledo and is the
                                       toledo-side half of that contract)
  - registry/review_report_index.json       (same citation pattern, for R5)
  - registry/claim_card_index.json          (same citation pattern, for R1's
                                       claim-card-falsifier fallback path)

All three index files are OPTIONAL — at drafting time (2026-09-08) none of
them exists yet (a direct `ls` found no such file under `registry/`; S1's
CLI had not yet landed). Their absence is not an error: every rung is then
computed from Toledo's own files alone (R0/R2), and R1/R3/R4/R5/R6 all read
`held: false` with an honest, quoted reason — never fabricated as `true`.
Re-running this script after S1's CLI starts populating those index files
picks up the new evidence automatically, on the next run, with no code
change needed here.

Writes:
  - registry/CANONICAL.json          adds/replaces each entry's own
                                       `resistance` key IN PLACE — no other
                                       content field is ever touched, and
                                       `registry/LINEAGE.jsonl` is untouched
                                       (a computed/derived field, the same
                                       status `children[]` already has;
                                       registry/SCHEMA.md sec. "Entry shape"
                                       documents `children[]` this way and
                                       this script's own SCHEMA.md addendum
                                       states the same for `resistance`).
  - registry/genesis_root.json       adds/replaces each root row's own
                                       `resistance` key IN PLACE, same rule.

Pure Python 3 stdlib. No network, no coqc. Idempotent: running this twice in
a row with no index-file changes produces byte-identical output (same
`computed_at` only when run on the same day; the rung table itself is a
pure function of the inputs).
"""
from __future__ import annotations

import argparse
import datetime
import json
import pathlib
import sys

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent

RUNG_ORDER = ["R0", "R1", "R2", "R3", "R4", "R5", "R6"]

# design/RESISTANCE_LADDER_v0_1.md sec.1's own table — the exact three kinds
# an R4/R6-eligible oracle can be (coq_kernel and human_review are real
# `oracle.kind` values too, but they back R2 and R5 respectively, never R4).
EXTERNAL_ORACLE_KINDS = {"published_value", "independent_implementation", "public_dataset"}

# P6's independence-class ladder (glosa/methodology/P06_independent_check.md);
# only the ordering matters here — "I2 or above" per sec.1's R5 row.
_INDEPENDENCE_RANK = {"I0": 0, "I1": 1, "I2": 2, "I3": 3, "I4": 4}

# The same lexical vacuous-tolerance markers glosa's own
# `kernel/glosa_kernel.py::aowc_gate_check` checks for R6 (one fact, two
# repositories that cannot import each other's code — kept textually
# identical on purpose; a change to one must be mirrored in the other).
_AOWC_VACUOUS_TOLERANCE_MARKERS = (
    "any value", "no tolerance", "always pass", "always true", "no band", "unbounded",
    "n/a", "not applicable",
)


def _parse_iso(value) -> "datetime.datetime | None":
    """Best-effort ISO 8601 parse (date or datetime, optional trailing Z), mirroring
    `kernel/glosa_kernel.py::_parse_repro_timestamp` in the glosa repo. Returns None on anything
    unparseable — never fabricated as "ordering is fine"."""
    if not isinstance(value, str) or not value.strip():
        return None
    text = value.strip()
    if text.endswith("Z"):
        text = text[:-1] + "+00:00"
    try:
        return datetime.datetime.fromisoformat(text)
    except ValueError:
        pass
    try:
        return datetime.datetime.combine(datetime.date.fromisoformat(text), datetime.time.min)
    except ValueError:
        return None


def today() -> str:
    return datetime.date.today().isoformat()


# ---------------------------------------------------------------------------
# IO helpers
# ---------------------------------------------------------------------------

def load_json(path: pathlib.Path, default=None):
    if not path.exists():
        return default
    with open(path, encoding="utf-8") as fh:
        return json.load(fh)


def write_json(path: pathlib.Path, obj) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(obj, fh, indent=2, ensure_ascii=False, sort_keys=False)
        fh.write("\n")


def load_index(path: pathlib.Path, list_key: str) -> list[dict]:
    """Loads one of the three OPTIONAL citation-index files. Missing file or
    missing/empty list key both mean "no evidence of this kind yet" — never
    an error; this is the honest-absence path sec.0/sec.5 both require."""
    doc = load_json(path, default=None)
    if not isinstance(doc, dict):
        return []
    rows = doc.get(list_key)
    return rows if isinstance(rows, list) else []


# ---------------------------------------------------------------------------
# Matching a citation-index row to a Toledo code
# ---------------------------------------------------------------------------

def _codes_of(row: dict) -> set[str]:
    codes = set(c for c in (row.get("toledo_codes") or []) if isinstance(c, str))
    single = row.get("code")
    if isinstance(single, str):
        codes.add(single)
    return codes


def rows_for_code(code: str, rows: list[dict]) -> list[dict]:
    return [r for r in rows if code in _codes_of(r)]


def citation_evidence(row: dict, evidence_type: str) -> dict:
    """`{repo, commit, path, id}` the way `origin.repo_anchor` already cites
    an external repo (design doc sec.2's "Toledo mapping is a citation,
    never a copy") — never the card/report's own full content."""
    cit = dict(row.get("citation") or {})
    ev = {"type": evidence_type}
    ev.update({k: v for k, v in cit.items() if v is not None})
    return ev


# ---------------------------------------------------------------------------
# Per-rung predicates over one Reproduction-Card citation row
# ---------------------------------------------------------------------------

def _card_run(card: dict) -> dict:
    run = card.get("run")
    return run if isinstance(run, dict) else {}


def _card_result(card: dict) -> dict:
    result = card.get("result")
    return result if isinstance(result, dict) else {}


def _review_matches_card(review: dict, card: dict) -> bool:
    """True when `review`'s own citation names the SAME reproduction_card it independently
    re-executed -- matched by the card's own citation id occurring in the review's citation
    id/path (the "repro-verify-<card id>" route_id convention `cli/glosa`'s `cmd_repro_verify`
    already uses), never by Toledo code alone (one code can be backed by several cards, and a
    review of one must never silently contradict a different card for the same code)."""
    card_id = (card.get("citation") or {}).get("id") or card.get("id")
    if not card_id:
        return False
    citation = review.get("citation") or {}
    haystack = f"{citation.get('id') or ''} {citation.get('path') or ''}"
    return card_id in haystack


def review_hash_match(review: dict) -> "bool | None":
    """`citation.hash_match` -- a boolean `scripts/register_reproduction_evidence.py` parses from
    a `repro-verify-*` review_report's own `verdict` text ("... MATCH ..." / "... MISMATCH...").
    `None` means no such field is present (an index built before this fix, or a review with no
    parseable verdict) -- never guessed as either True or False."""
    value = (review.get("citation") or {}).get("hash_match")
    return value if isinstance(value, bool) else None


def card_holds_r1(card: dict) -> bool:
    pred = card.get("preregistered_prediction") or {}
    declared_at = pred.get("declared_at")
    if not declared_at:
        return False
    run_date = _card_run(card).get("date")
    # declared_at must PREDATE run.date when a run exists; a card with no
    # run yet still holds R1 on the pre-registration alone (design doc
    # sec.1 R1 row: "written before the run/observation it constrains").
    if run_date and str(declared_at) > str(run_date):
        return False
    return True


def card_holds_r3(card: dict, reviews: "list[dict] | None" = None) -> bool:
    run = _card_run(card)
    # "a filled run{} block" (sec.1 R3 row) — command present is the load-
    # bearing signal; ai_at_runtime must be the literal 0 per the schema
    # (sec.2), checked defensively here too rather than trusted blind.
    if not (bool(run.get("command")) and run.get("ai_at_runtime", 0) == 0):
        return False
    # Integration fix (2026-09-08): methodology/P22_reproduction_ledger.md item 3 states plainly
    # that an independent `glosa repro verify` review_report -- never this card's own first
    # `repro run` -- is what actually HOLDS R3 for a reader other than the maker. When such a
    # review is linked (registry/review_report_index.json, via
    # scripts/register_reproduction_evidence.py's own citation.hash_match parse of the review's
    # verdict text) and it recorded a hash MISMATCH, R3 is not held for this card, regardless of
    # what the maker's own run{} claims — this is exactly the EQ-068 case caught live: a
    # repro-verify review disclosed "output_hash MISMATCH" right next to a resistance block that
    # still reported R3/R4/R6 all held:true.
    for review in (reviews or []):
        if _review_matches_card(review, card) and review_hash_match(review) is False:
            return False
    return True


def card_holds_r4(card: dict, reviews: "list[dict] | None" = None) -> bool:
    if not card_holds_r3(card, reviews):
        return False
    oracle = card.get("oracle") or {}
    if oracle.get("kind") not in EXTERNAL_ORACLE_KINDS:
        return False
    status = _card_result(card).get("status")
    # PASS or FAIL both hold R4 (sec.0's non-tautology rule); PENDING/ERROR/
    # missing do not — a card whose run crashed has not yet produced an
    # oracle comparison to disclose.
    return status in ("PASS", "FAIL")


def card_holds_r6(card: dict, reviews: "list[dict] | None" = None) -> bool:
    """AOWC gate (sec.1 R6 row / sec.8/sec.5's `kernel.aowc_gate_check`).

    Integration fix (2026-09-08): this function used to require a bespoke
    `aowc_qualifying: true` field that exists NOWHERE — not in
    `schema/reproduction_card.schema.json`, not in either of the two
    first-batch real cards (EQ-045/EQ-068) — so R6 could never be held for
    any real card regardless of how genuinely AOWC-qualifying it was. The
    design doc (sec.5/sec.8) is explicit this is meant to be ONE shared
    function between `glosa score` (`kernel/glosa_kernel.py::aowc_gate_check`,
    which `cli/glosa`'s own R6 computation actually calls) and this script,
    "never a new schema field" (sec.1's own R6 row: "not a new schema
    field"). Toledo still cannot IMPORT that glosa module at build time
    (separate repositories by design) — so this re-implements the exact
    same four mechanically-checkable conditions `aowc_gate_check` documents,
    over the reproduction_card's own fields the citation row already
    carries (never a field invented for this script alone):
      1. R4 is held (external-oracle comparison, PASS or FAIL, actually ran).
      2. `run.ai_at_runtime == 0` (re-checked explicitly, matching
         `aowc_gate_check`'s own "AI = 0 at both execution and evaluation").
      3. `preregistered_prediction.declared_at` parses and predates
         `run.date` — frozen before the run (same ordering `card_holds_r1`
         checks, re-verified here so this function is self-contained).
      4. `preregistered_prediction.tolerance` is non-empty and does not read
         as a vacuous/always-pass band (the same lexical HEURISTIC
         `aowc_gate_check` applies — readout-not-truth: a lexical check on
         free text, never a verified judgment that a human designed the
         band non-vacuously)."""
    if not card_holds_r4(card, reviews):
        return False
    run = _card_run(card)
    if run.get("ai_at_runtime") != 0:
        return False
    pred = card.get("preregistered_prediction") or {}
    declared_at = _parse_iso(pred.get("declared_at"))
    run_date = _parse_iso(run.get("date"))
    if declared_at is None or run_date is None or declared_at > run_date:
        return False
    tolerance = str(pred.get("tolerance") or "").strip()
    if not tolerance:
        return False
    lower = tolerance.lower()
    if any(marker in lower for marker in _AOWC_VACUOUS_TOLERANCE_MARKERS):
        return False
    return True


def review_rank(review: dict) -> int:
    return _INDEPENDENCE_RANK.get(str(review.get("independence_class") or ""), -1)


# ---------------------------------------------------------------------------
# One entry/root-row's full rung table
# ---------------------------------------------------------------------------

def _coq_evidence(code: str, coq: dict) -> dict:
    path = coq.get("file")
    if not path:
        # SCHEMA.md's own mangling rule — the same fallback filename a
        # `coq_status == "closed"` entry is expected to have `file` set to
        # already; this is only reached if that invariant is ever violated,
        # so the evidence pointer still names a real, checkable location.
        mangled = code.replace("/", "__").replace(".", "_").replace("-", "_")
        path = f"coq/canonical/{mangled}.v"
    return {"type": "coq", "path": path}


def compute_rungs(code: str, statement_text: str, coq: dict | None,
                   repro_rows: list[dict], review_rows: list[dict],
                   claim_rows: list[dict]) -> dict:
    coq = coq or {}
    cards = rows_for_code(code, repro_rows)
    reviews = rows_for_code(code, review_rows)
    claims = rows_for_code(code, claim_rows)

    rungs: dict[str, dict] = {}

    # R0 — Stated. Every entry with a non-empty statement holds this
    # trivially (sec.1: "its only job is to make explicit that a bare
    # stated equation carries zero resistance by itself").
    r0_held = bool((statement_text or "").strip())
    rungs["R0"] = {"held": r0_held, "evidence": []} if r0_held else {
        "held": False, "evidence": [], "reason": "no statement text recorded for this code",
    }

    # R1 — Pre-registered falsifier / claim boundary.
    r1_cards = [c for c in cards if card_holds_r1(c)]
    if r1_cards:
        rungs["R1"] = {
            "held": True,
            "evidence": [citation_evidence(c, "reproduction_card") for c in r1_cards],
        }
    else:
        non_todo_claims = [
            c for c in claims
            if str(c.get("falsifier") or "").strip() and str(c.get("falsifier")).strip().upper() != "TODO"
        ]
        if non_todo_claims:
            rungs["R1"] = {
                "held": True,
                "evidence": [citation_evidence(c, "claim_card") for c in non_todo_claims],
            }
        else:
            rungs["R1"] = {
                "held": False, "evidence": [],
                "reason": "no linked reproduction_card.preregistered_prediction or claim_card falsifier",
            }

    # R2 — Coq-closed (kernel outside our loop). Only `coq_status == "closed"`
    # holds this — the v1.1 honest ladder's own floor (SCHEMA.md addendum
    # 2026-09-07); `definition`/`wrapped_related`/`mapped_not_wrapped`/
    # `open_prop`/`not_formalisable`/`axioms`/`root_layer_unwired` never do.
    coq_status = coq.get("coq_status")
    if coq_status == "closed":
        rungs["R2"] = {"held": True, "evidence": [_coq_evidence(code, coq)]}
    else:
        rungs["R2"] = {
            "held": False, "evidence": [],
            "reason": f"coq_status is {coq_status!r} (not 'closed')",
        }

    # R3 — Reproducible run, hash-frozen, AI=0.
    r3_cards = [c for c in cards if card_holds_r3(c, reviews)]
    if r3_cards:
        rungs["R3"] = {"held": True, "evidence": [citation_evidence(c, "reproduction_card") for c in r3_cards]}
    else:
        mismatched = [
            c for c in cards
            if bool(_card_run(c).get("command")) and _card_run(c).get("ai_at_runtime", 0) == 0
            and any(_review_matches_card(r, c) and review_hash_match(r) is False for r in reviews)
        ]
        if mismatched:
            rungs["R3"] = {
                "held": False, "evidence": [],
                "reason": "a linked repro-verify review_report recorded a hash MISMATCH against "
                          "this code's own reproduction_card run — see registry/review_report_index.json",
            }
        elif cards:
            rungs["R3"] = {
                "held": False, "evidence": [],
                "reason": "linked reproduction_card(s) reference this code but none has a filled run{} yet",
            }
        else:
            rungs["R3"] = {"held": False, "evidence": [], "reason": "no reproduction_card references this code"}

    # R4 — External oracle.
    r4_cards = [c for c in cards if card_holds_r4(c, reviews)]
    if r4_cards:
        rungs["R4"] = {"held": True, "evidence": [citation_evidence(c, "reproduction_card") for c in r4_cards]}
    elif not rungs["R3"]["held"]:
        rungs["R4"] = {"held": False, "evidence": [], "reason": "R3 not held"}
    else:
        rungs["R4"] = {
            "held": False, "evidence": [],
            "reason": "no external-oracle card (published_value/independent_implementation/"
                      "public_dataset) with a filled result for this code",
        }

    # R5 — Independent reviewer (I2+) or interactional-expert record.
    r5_reviews = [r for r in reviews if review_rank(r) >= _INDEPENDENCE_RANK["I2"]]
    if r5_reviews:
        rungs["R5"] = {"held": True, "evidence": [citation_evidence(r, "review_report") for r in r5_reviews]}
    else:
        rungs["R5"] = {
            "held": False, "evidence": [],
            "reason": "no review_report at independence_class >= I2 references this code",
        }

    # R6 — AOWC world record.
    r6_cards = [c for c in cards if card_holds_r6(c, reviews)]
    if r6_cards:
        rungs["R6"] = {"held": True, "evidence": [citation_evidence(c, "reproduction_card") for c in r6_cards]}
    elif not rungs["R4"]["held"]:
        rungs["R6"] = {"held": False, "evidence": [], "reason": "R4 not held"}
    else:
        rungs["R6"] = {
            "held": False, "evidence": [],
            "reason": "no R4-holding card for this code passes the AOWC gate (Tunnel v2.1 sec.30: "
                      "frozen before the run, AI=0, and a non-vacuous declared tolerance)",
        }

    return {r: rungs[r] for r in RUNG_ORDER}


def compute_resistance_block(code: str, statement_text: str, coq: dict | None,
                              repro_rows: list[dict], review_rows: list[dict],
                              claim_rows: list[dict], computed_at: str) -> dict:
    return {
        "computed_at": computed_at,
        "rungs": compute_rungs(code, statement_text, coq, repro_rows, review_rows, claim_rows),
    }


def rung_summary(rungs: dict) -> str:
    return "".join(r if rungs[r]["held"] else "-" for r in RUNG_ORDER)


# ---------------------------------------------------------------------------
# Orchestration over registry/CANONICAL.json and registry/genesis_root.json
# ---------------------------------------------------------------------------

def compute_for_canonical(canonical_doc: dict, repro_rows, review_rows, claim_rows, computed_at: str) -> int:
    n = 0
    for e in canonical_doc.get("canonical", []):
        code = e.get("code")
        if not code:
            continue
        statement_text = (e.get("statement") or {}).get("latest", "")
        e["resistance"] = compute_resistance_block(
            code, statement_text, e.get("coq"), repro_rows, review_rows, claim_rows, computed_at,
        )
        n += 1
    return n


def compute_for_genesis_root(genesis_doc: dict, repro_rows, review_rows, claim_rows, computed_at: str) -> int:
    n = 0
    for row in genesis_doc.get("root_equations", []):
        code = row.get("code")
        if not code:
            continue
        statement_text = row.get("statement", "") or ""
        # Root rows carry no `coq{}` block of their own (that is synthesized
        # only at build time, registry/SCHEMA.md's v1.2 addendum) — R2 is
        # therefore always computed as not-held for a root row here; a root
        # row's real coq_status (root_layer_unwired / axioms) never equals
        # "closed" by construction (SCHEMA.md), so passing `coq=None` (which
        # compute_rungs reads as coq_status=None, "not 'closed'") is exactly
        # equivalent and does not need genesis_row_to_canonical's own
        # axiom-detection duplicated here.
        row["resistance"] = compute_resistance_block(
            code, statement_text, None, repro_rows, review_rows, claim_rows, computed_at,
        )
        n += 1
    return n


def run(canonical_path: pathlib.Path, genesis_path: pathlib.Path,
        repro_index_path: pathlib.Path, review_index_path: pathlib.Path,
        claim_index_path: pathlib.Path, *, dry_run: bool = False) -> dict:
    computed_at = today()
    repro_rows = load_index(repro_index_path, "cards")
    review_rows = load_index(review_index_path, "reviews")
    claim_rows = load_index(claim_index_path, "claims")

    canonical_doc = load_json(canonical_path, default=None)
    genesis_doc = load_json(genesis_path, default=None)

    report = {
        "computed_at": computed_at,
        "reproduction_cards_indexed": len(repro_rows),
        "review_reports_indexed": len(review_rows),
        "claim_cards_indexed": len(claim_rows),
        "canonical_entries_computed": 0,
        "genesis_root_rows_computed": 0,
        "held_counts": {r: 0 for r in RUNG_ORDER},
        "dry_run": dry_run,
    }

    if canonical_doc is not None:
        report["canonical_entries_computed"] = compute_for_canonical(
            canonical_doc, repro_rows, review_rows, claim_rows, computed_at,
        )
        if not dry_run:
            write_json(canonical_path, canonical_doc)
        for e in canonical_doc.get("canonical", []):
            for r in RUNG_ORDER:
                if e.get("resistance", {}).get("rungs", {}).get(r, {}).get("held"):
                    report["held_counts"][r] += 1
    else:
        report["note_canonical"] = f"{canonical_path} not found; skipped"

    if genesis_doc is not None:
        report["genesis_root_rows_computed"] = compute_for_genesis_root(
            genesis_doc, repro_rows, review_rows, claim_rows, computed_at,
        )
        if not dry_run:
            write_json(genesis_path, genesis_doc)
        for row in genesis_doc.get("root_equations", []):
            for r in RUNG_ORDER:
                if row.get("resistance", {}).get("rungs", {}).get(r, {}).get("held"):
                    report["held_counts"][r] += 1
    else:
        report["note_genesis"] = f"{genesis_path} not found; skipped"

    return report


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--canonical", type=pathlib.Path, default=REPO_ROOT / "registry" / "CANONICAL.json")
    ap.add_argument("--genesis-root", type=pathlib.Path, default=REPO_ROOT / "registry" / "genesis_root.json")
    ap.add_argument("--repro-index", type=pathlib.Path,
                     default=REPO_ROOT / "registry" / "reproduction_card_index.json")
    ap.add_argument("--review-index", type=pathlib.Path,
                     default=REPO_ROOT / "registry" / "review_report_index.json")
    ap.add_argument("--claim-index", type=pathlib.Path,
                     default=REPO_ROOT / "registry" / "claim_card_index.json")
    ap.add_argument("--dry-run", action="store_true",
                     help="compute and report without writing registry/CANONICAL.json or "
                          "registry/genesis_root.json")
    args = ap.parse_args(argv)

    report = run(args.canonical, args.genesis_root, args.repro_index, args.review_index,
                 args.claim_index, dry_run=args.dry_run)
    print(json.dumps(report, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
