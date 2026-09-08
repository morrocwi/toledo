#!/usr/bin/env python3
"""
scripts/compute_executable.py -- S3, Executable Equations: the computed `executable` block
(docs/EXECUTABLE_EQUATIONS_v0_1.md sec.3.1, the one narrow authorised exception to this repo's own
"do not edit registry/CANONICAL.json content fields by hand" rule -- the SAME exception the
`resistance` block already uses, and this file mirrors scripts/compute_resistance.py's own shape
on purpose: same in-place-write discipline, same "never touches registry/LINEAGE.jsonl" rule, run
in the Makefile immediately alongside `resistance:` and before `build:`).

This is the ONLY script permitted to write the per-entry `executable` block, and the only script
permitted to write registry/executable/INDEX.json.

Reads (never writes, except where named):
  - registry/CANONICAL.json                 content entries; `code` is the join key
  - registry/executable/<mangled-code>.json  one IR sidecar per code S1 (classifier + extraction)
                                              has drafted or a human registrar has reviewed --
                                              schema per docs/EXECUTABLE_EQUATIONS_v0_1.md sec.3.
                                              NEVER written or edited by this script (S1's/a human
                                              registrar's own file; this script is read-only here,
                                              exactly like scripts/compute_resistance.py is
                                              read-only over the three citation-index files it
                                              consumes).
  - registry/reproduction_card_index.json    S1's OWN existing citation index (scripts/
                                              register_reproduction_evidence.py's output, zero
                                              edits) -- used only to find the specific EXEC-<code>
                                              Reproduction Card citation for a code whose sidecar
                                              says `status` is `reviewed_eligible`/`built`, never
                                              to compute anything else. OPTIONAL: if this file does
                                              not exist yet, every entry's `reproduction_card` sub
                                              -field is simply omitted (never fabricated).

Writes:
  - registry/CANONICAL.json          adds/replaces each entry's own `executable` key IN PLACE
                                       when (and only when) a sidecar exists for that code; DELETES
                                       a stale `executable` key when no sidecar exists any more (the
                                       same "recompute fresh, never let a removed sidecar leave a
                                       ghost block behind" discipline `children[]` already applies) --
                                       no other content field is ever touched, and
                                       `registry/LINEAGE.jsonl` is untouched (a computed/derived
                                       field, per registry/SCHEMA.md's own resistance-block
                                       addendum, restated here for `executable`).
  - registry/executable/INDEX.json   a single generated (never hand-edited) aggregate over every
                                       sidecar's own `code`/`status`/`reviewed_by`/card citation --
                                       docs/EXECUTABLE_EQUATIONS_v0_1.md sec.6 step 8's own
                                       "executable feature's own analogue of
                                       registry/genesis_root.json's summary role"; not a second,
                                       competing registry (sec.13 item 7) -- every fact in it is a
                                       projection of the sidecars plus registry/
                                       reproduction_card_index.json, both already described above.

Scope note (honest, stated once): this script computes the `executable` block for
`registry/CANONICAL.json` entries only. `registry/genesis_root.json` root rows are not handled --
docs/EXECUTABLE_EQUATIONS_v0_1.md never names a root-row requirement for this feature the way
`compute_resistance.py`'s own root-row handling was an explicit, separately-ruled requirement
(registry/SCHEMA.md's resistance addendum); if a root code is ever made eligible, this script's
`compute_for_canonical`-shaped function can be reused for `root_equations[]` the same way
`compute_resistance.py` reuses its own `compute_resistance_block` -- deferred, not silently
dropped, because nothing in the spec asked for it yet.

`not_attempted` (the fifth legal value in sec.3.1's own `status` enum) is never emitted by this
script -- it is reserved for a possible future S1-classifier-driven pass over the eligible pool
that has not been extracted into a sidecar at all; this script only ever sees entries that already
have a sidecar (mapped to `candidate`/`reviewed_eligible`/`reviewed_ineligible`/`built`) or entries
with none (the `executable` key is omitted entirely for those -- sec.1.4/sec.3.1's own "the vast
majority of the 1,267 entries carry no executable block at all, by design").

Pure Python 3 stdlib. No network, no coqc, no sympy, no mpmath. Idempotent: running this twice in a
row with no sidecar/index changes produces byte-identical output (same `computed_at` only when run
on the same day; the block itself is a pure function of the inputs).
"""
from __future__ import annotations

import argparse
import datetime
import json
import pathlib
import sys

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent

# Loaded by file path (sibling-file sys.path insert), not `from scripts.executable import
# ir_eval` -- this workstation demonstrates a real collision (a third-party `scripts` package
# installed in site-packages shadows this repository's own top-level `scripts/` directory once
# any sys.path entry ahead of the repo root supplies one, confirmed directly in ir_eval.py's own
# module docstring). `ir_eval.py` itself does `from . import ir_kernel`, which raises
# `ImportError: attempted relative import with no known parent package` when loaded as a flat
# module this way -- its own `except ImportError` fallback (module-level in ir_eval.py) then
# inserts its own directory onto sys.path and imports `ir_kernel` as a plain sibling module, so
# this simple flat import still resolves correctly end to end.
sys.path.insert(0, str(REPO_ROOT / "scripts" / "executable"))
import ir_eval  # noqa: E402

# sec.3's own sidecar status lifecycle -> sec.3.1's own CANONICAL.json `executable.status` enum.
# The two enums use different words for the same "a human looked and said no" state
# (`reviewed_rejected` on the sidecar vs `reviewed_ineligible` on the computed block) -- this is
# the one, explicit, named translation, never silently guessed at read time downstream.
_SIDECAR_STATUS_TO_BLOCK_STATUS = {
    "candidate": "candidate",
    "reviewed_eligible": "reviewed_eligible",
    "reviewed_rejected": "reviewed_ineligible",
    "built": "built",
}


def today() -> str:
    return datetime.date.today().isoformat()


# ---------------------------------------------------------------------------
# IO helpers (mirrors scripts/compute_resistance.py's own helpers verbatim)
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


# ---------------------------------------------------------------------------
# Loading every IR sidecar under registry/executable/
# ---------------------------------------------------------------------------

def load_sidecars(executable_dir: pathlib.Path) -> "dict[str, dict]":
    """Returns {code: sidecar_dict}, skipping (with a stderr warning, never a crash) any file that
    is not valid JSON, carries no `code` field, or fails `ir_eval.validate_ir_shape` -- a
    malformed sidecar must never silently vanish from view nor abort the whole build.

    Integration fix (2026-09-08): this loader used to check for a `code` key ONLY -- a
    schema-invalid sidecar (e.g. one whose `transcendental.algorithm_py`/`algorithm_js` disagree
    with `ir_kernel.py`'s own declared families, or one missing a required top-level key) would
    silently enter `registry/executable/INDEX.json` and `CANONICAL.json`'s `executable` block via
    `make build` with no warning at all, surfacing only much later as a runtime exception from
    `toledo_eval`, the site widget's build step, or `crosscheck_runner.py`. Calling the SAME
    schema gate `tests/executable/test_ir_schema.py` checks (never a second, re-derived check)
    here means a bad sidecar is reported loudly at `make executable` time instead -- fail-loud,
    per this repo's own readout-not-truth discipline -- and is excluded from this run's counts
    exactly like an unreadable/code-less file already was."""
    sidecars: dict[str, dict] = {}
    if not executable_dir.is_dir():
        return sidecars
    for path in sorted(executable_dir.glob("*.json")):
        if path.name == "INDEX.json":
            continue
        try:
            doc = json.loads(path.read_text(encoding="utf-8"))
        except (json.JSONDecodeError, OSError) as exc:
            print(f"warning: skipping unreadable sidecar {path}: {exc}", file=sys.stderr)
            continue
        code = doc.get("code")
        if not code:
            print(f"warning: skipping sidecar with no 'code' field: {path}", file=sys.stderr)
            continue
        try:
            ir_eval.validate_ir_shape(doc)
        except ir_eval.IRValidationError as exc:
            print(f"warning: skipping schema-invalid sidecar {path} (code {code!r}): {exc}",
                  file=sys.stderr)
            continue
        sidecars[code] = doc
    return sidecars


# ---------------------------------------------------------------------------
# Matching a code to its EXEC-<mangled-code> Reproduction Card citation, via the
# EXISTING reproduction_card_index.json (scripts/register_reproduction_evidence.py's
# own unmodified output -- read here, never written)
# ---------------------------------------------------------------------------

def mangle_code(code: str) -> str:
    """registry/SCHEMA.md's own filesystem-safe mangling rule (BBL-182), reused verbatim -- the
    SAME rule already governing Coq file names, reused here per docs/EXECUTABLE_EQUATIONS_v0_1.md
    sec.3's own instruction ("reused verbatim because it is already the shared, reviewed
    convention")."""
    return code.replace("/", "__").replace(".", "_").replace("-", "_")


def find_reproduction_card_citation(code: str, repro_rows: "list[dict]") -> "dict | None":
    """A card counts here only if it (a) names this code in its own `toledo_codes[]` AND (b) its
    citation id/path names this feature's own `EXEC-` prefix (crosscheck_runner.py's own filed-card
    convention, docs/EXECUTABLE_EQUATIONS_v0_1.md sec.6) -- so an unrelated, non-executable-feature
    Reproduction Card that happens to also cite the same code (e.g. a hand-authored EQ-045/EQ-068
    card) is never mistaken for this feature's own filed evidence.

    Returns `{"citation": {...}, "result_status": "PASS"|"FAIL"|"ERROR"}` (the last key omitted,
    never null, when the filed card's own `result` is still unset/PENDING -- the same
    "omitted, not null" three-state convention this module already uses elsewhere). Integration
    fix (2026-09-08): this used to discard the row's own `result.status` entirely, so a filed,
    disclosed FAIL was invisible everywhere this citation is surfaced (registry/executable/
    INDEX.json, CANONICAL.json's `executable` block, and every site surface built from either) --
    read verbatim from `reproduction_card_index.json`'s own row, never recomputed or re-derived,
    exactly the "a disclosed FAIL is filed exactly as legitimately as a PASS" discipline P22/P23
    already hold the rest of this registry to."""
    for row in repro_rows:
        codes = set(c for c in (row.get("toledo_codes") or []) if isinstance(c, str))
        if code not in codes:
            continue
        citation = row.get("citation") or {}
        card_id = str(citation.get("id") or "")
        card_path = str(citation.get("path") or "")
        if card_id.startswith("EXEC-") or "EXEC-" in card_path:
            card_info: dict = {"citation": {k: v for k, v in citation.items() if v is not None}}
            result_status = (row.get("result") or {}).get("status")
            if result_status:
                card_info["result_status"] = result_status
            return card_info
    return None


def load_repro_rows(repro_index_path: pathlib.Path) -> "list[dict]":
    doc = load_json(repro_index_path, default=None)
    if not isinstance(doc, dict):
        return []
    rows = doc.get("cards")
    return rows if isinstance(rows, list) else []


# ---------------------------------------------------------------------------
# One entry's `executable` block
# ---------------------------------------------------------------------------

def compute_executable_block(code: str, sidecar: dict, repro_rows: "list[dict]",
                              computed_at: str) -> dict:
    sidecar_status = sidecar.get("status")
    block_status = _SIDECAR_STATUS_TO_BLOCK_STATUS.get(sidecar_status)
    if block_status is None:
        # An unrecognised/malformed status is reported honestly as `candidate` (the floor state,
        # never invented as `built`) rather than silently dropped -- readout-not-truth: a status
        # this script cannot classify is disclosed, never guessed upward.
        block_status = "candidate"

    block: dict = {
        "computed_at": computed_at,
        "status": block_status,
        "ir_ref": f"registry/executable/{mangle_code(code)}.json",
    }

    reviewed_by = ((sidecar.get("eligibility") or {}).get("reviewed_by") or "").strip()
    if reviewed_by:
        block["reviewed_by"] = reviewed_by
    # else: omitted, not null -- sec.3.1's own three-state convention (never write null here).

    if block_status in ("reviewed_eligible", "built"):
        card_info = find_reproduction_card_citation(code, repro_rows)
        if card_info:
            block["reproduction_card"] = card_info
        # else: omitted -- no filed card for this code yet (crosscheck_runner.py has not
        # been run against it, or it has and produced no card because the sidecar itself
        # refused eligibility at run time -- either way, never fabricated).

    return block


# ---------------------------------------------------------------------------
# Orchestration over registry/CANONICAL.json
# ---------------------------------------------------------------------------

def compute_for_canonical(canonical_doc: dict, sidecars: "dict[str, dict]",
                           repro_rows: "list[dict]", computed_at: str) -> "tuple[int, int, int]":
    """Returns (entries_with_sidecar, entries_written, stale_keys_removed)."""
    with_sidecar = 0
    written = 0
    removed = 0
    for e in canonical_doc.get("canonical", []):
        code = e.get("code")
        if not code:
            continue
        sidecar = sidecars.get(code)
        if sidecar is None:
            if "executable" in e:
                del e["executable"]
                removed += 1
            continue
        with_sidecar += 1
        e["executable"] = compute_executable_block(code, sidecar, repro_rows, computed_at)
        written += 1
    return with_sidecar, written, removed


def build_index(sidecars: "dict[str, dict]", repro_rows: "list[dict]", computed_at: str,
                 generated_from_commit: "str | None") -> dict:
    entries = []
    # `by_result` (Integration fix, 2026-09-08): a PASS/FAIL/ERROR breakdown over every FILED
    # EXEC- card this index projects, kept as a sub-object under `counts` (never flattened into
    # its sibling int keys, so `sum(counts[k] for k in ("candidate", ...))`-style callers over
    # the sidecar-status keys are unaffected) -- so a disclosed FAIL is exactly as visible in
    # this aggregate as a PASS, matching P22/P23's own "cited regardless of outcome" discipline
    # (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.7's `/browse/`/`/about/` tallies read this same
    # breakdown rather than a collapsed binary "executable: yes/no" count).
    counts = {
        "candidate": 0, "reviewed_eligible": 0, "reviewed_ineligible": 0, "built": 0,
        "by_result": {"PASS": 0, "FAIL": 0, "ERROR": 0},
    }
    for code in sorted(sidecars):
        sidecar = sidecars[code]
        block = compute_executable_block(code, sidecar, repro_rows, computed_at)
        counts[block["status"]] = counts.get(block["status"], 0) + 1
        row = {"code": code, "status": block["status"], "ir_ref": block["ir_ref"]}
        if "reviewed_by" in block:
            row["reviewed_by"] = block["reviewed_by"]
        if "reproduction_card" in block:
            row["reproduction_card"] = block["reproduction_card"]
            result_status = block["reproduction_card"].get("result_status")
            if result_status in counts["by_result"]:
                counts["by_result"][result_status] += 1
        entries.append(row)
    return {
        "schema_version": "executable-index-0.1",
        "computed_at": computed_at,
        "generated_from_commit": generated_from_commit,
        "note": "generated (never hand-edited) by scripts/compute_executable.py -- a projection of "
                "registry/executable/*.json sidecars plus registry/reproduction_card_index.json's "
                "EXEC-* rows; docs/EXECUTABLE_EQUATIONS_v0_1.md sec.6 step 8.",
        "counts": counts,
        "entries": entries,
    }


def run(canonical_path: pathlib.Path, executable_dir: pathlib.Path, repro_index_path: pathlib.Path,
        index_out_path: pathlib.Path, *, dry_run: bool = False) -> dict:
    computed_at = today()
    sidecars = load_sidecars(executable_dir)
    repro_rows = load_repro_rows(repro_index_path)

    canonical_doc = load_json(canonical_path, default=None)

    report = {
        "computed_at": computed_at,
        "sidecars_found": len(sidecars),
        "reproduction_card_index_rows": len(repro_rows),
        "canonical_entries_with_sidecar": 0,
        "canonical_entries_written": 0,
        "canonical_stale_keys_removed": 0,
        "index_entries_written": 0,
        "dry_run": dry_run,
    }

    generated_from_commit = None
    if canonical_doc is not None:
        generated_from_commit = canonical_doc.get("generated_from_commit")
        with_sidecar, written, removed = compute_for_canonical(
            canonical_doc, sidecars, repro_rows, computed_at,
        )
        report["canonical_entries_with_sidecar"] = with_sidecar
        report["canonical_entries_written"] = written
        report["canonical_stale_keys_removed"] = removed
        if not dry_run:
            write_json(canonical_path, canonical_doc)
    else:
        report["note_canonical"] = f"{canonical_path} not found; skipped"

    index_doc = build_index(sidecars, repro_rows, computed_at, generated_from_commit)
    report["index_entries_written"] = len(index_doc["entries"])
    report["index_counts"] = index_doc["counts"]
    if not dry_run:
        write_json(index_out_path, index_doc)

    return report


def main(argv: "list[str] | None" = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--canonical", type=pathlib.Path, default=REPO_ROOT / "registry" / "CANONICAL.json")
    ap.add_argument("--executable-dir", type=pathlib.Path, default=REPO_ROOT / "registry" / "executable")
    ap.add_argument("--repro-index", type=pathlib.Path,
                     default=REPO_ROOT / "registry" / "reproduction_card_index.json")
    ap.add_argument("--index-out", type=pathlib.Path,
                     default=REPO_ROOT / "registry" / "executable" / "INDEX.json")
    ap.add_argument("--dry-run", action="store_true",
                     help="compute and report without writing registry/CANONICAL.json or "
                          "registry/executable/INDEX.json")
    args = ap.parse_args(argv)

    report = run(args.canonical, args.executable_dir, args.repro_index, args.index_out,
                 dry_run=args.dry_run)
    print(json.dumps(report, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
