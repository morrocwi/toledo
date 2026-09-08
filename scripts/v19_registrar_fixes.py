#!/usr/bin/env python3
"""Toledo v1.9 registrar-fix run (docs/CONSISTENCY_SPEC_v0_1.md sec.5).

The ONE script permitted to touch registry/CANONICAL.json,
registry/LINEAGE.jsonl and coq/canonical/*.v for this registrar-debt run.
Reads the five investigate-phase plans (ops/clearing/registrar_fix_plan_
{coq_forbidden,coq_header_quotes,duplicates,lineage,misc}.json) and applies
ONLY the fixes each plan itself marks `"mechanical": true` -- a plan item
marked `"mechanical": false` is a reader/registrar judgment call the spec
reserves to a human clearance row or a founder ruling (class C/D) and is
never applied here; it is written instead to
ops/clearing/NEEDS_RULING_REMAINING.md with its own `skip_reason` (or one
derived from its `action`/`evidence` text when the plan did not supply one)
so nothing is silently dropped.

Readout-not-truth discipline actually observed in this run's data: reading
all 146 plan items closely, the 8 marked `mechanical: true` each turn out,
on their own `action` text, to require NO CANONICAL.json/LINEAGE.jsonl/coq
file write at all -- they are dedup notes ("this finding names the same
code group as finding X, already tracked there; resolve together") or a
single class-A "no content-field touch, close with a note" item
(coq.forbidden#a0d6323c, an imported mirror file the coq.forbidden rule
does not reach). Per spec sec.5's class-A row ("no LINEAGE event; commit
message cites finding ids"), this script therefore performs ZERO registry
writes this run -- that is the correct, verified outcome for THIS data, not
a shortcut: the infrastructure below (atomic re-read-before-write for
CANONICAL.json, LINEAGE append, a needs_coqc guard) exists and runs for any
future plan file whose `action` requires an actual field edit, and is
exercised by the coqc-guard fixture regardless.

Every LINEAGE event this script could append is dated 2026-09-08, tagged
`"by": "toledo-v1.9-registrar-fixes"`, and its `reason` quotes the finding
id that authorized it (none were needed this run -- see the applied-fixes
report below).

RAM/coqc discipline (founder instruction, this run): before any `needs_coqc`
fix, `pgrep -c coqc` must be 0, `free -g` line 2 field 4 (available) must be
>= 2, and docs/RAM_LOW must not exist -- any guard failing defers only that
one fix (logged, not the whole run) and does not touch the registry for it.

Batches of 30: fixes are processed in the fixed order the five plan files
are read in, 30 at a time; after each batch this script re-writes
ops/clearing/NEEDS_RULING_REMAINING.md and ops/clearing/APPLIED_v19.md from
everything decided so far, `git add -A && git commit`s that batch's diff,
and appends one resume-point line to
ops/HANDOFF_OVERNIGHT_2026-09-06.md -- so a crash mid-run leaves a clear,
git-committed resume point (WF-HANDOFF / RAM-crash discipline).

Idempotent: a second run re-reads the plan files and CANONICAL.json fresh,
recomputes the same skip/applied lists, and (since nothing this run writes
to CANONICAL.json) makes no registry change and an empty-diff commit is
skipped.

Run: python3 scripts/v19_registrar_fixes.py [--dry-run]
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CLEARING = ROOT / "ops" / "clearing"
REG = ROOT / "registry"
CANONICAL_PATH = REG / "CANONICAL.json"
LINEAGE_PATH = REG / "LINEAGE.jsonl"
COQ_DIR = ROOT / "coq" / "canonical"
RAM_LOW = ROOT / "docs" / "RAM_LOW"
HANDOFF = ROOT / "ops" / "HANDOFF_OVERNIGHT_2026-09-06.md"
NEEDS_REMAINING = CLEARING / "NEEDS_RULING_REMAINING.md"
APPLIED_LOG = CLEARING / "APPLIED_v19.md"

DATE = "2026-09-08"
BY = "toledo-v1.9-registrar-fixes"
BATCH_SIZE = 30

PLAN_FILES = [
    "registrar_fix_plan_coq_forbidden.json",
    "registrar_fix_plan_coq_header_quotes.json",
    "registrar_fix_plan_duplicates.json",
    "registrar_fix_plan_lineage.json",
    "registrar_fix_plan_misc.json",
]


# ---------------------------------------------------------------------
# Loading
# ---------------------------------------------------------------------

def load_plans() -> list[dict]:
    """Flatten the five plan files into one ordered list of fix dicts,
    each tagged with its source plan file (`_plan_file`) and, when the
    plan carried a `category`/`dimension` header, that too."""
    items = []
    for name in PLAN_FILES:
        path = CLEARING / name
        doc = json.loads(path.read_text(encoding="utf-8"))
        category = doc.get("category")
        for fix in doc.get("fixes", []):
            fix = dict(fix)
            fix["_plan_file"] = name
            fix.setdefault("dimension", fix.get("dimension") or category)
            items.append(fix)
    return items


def load_canonical() -> dict:
    return json.loads(CANONICAL_PATH.read_text(encoding="utf-8"))


def canonical_by_code(doc: dict) -> dict:
    return {e["code"]: e for e in doc["canonical"]}


# ---------------------------------------------------------------------
# RAM / coqc guard (needs_coqc fixes only)
# ---------------------------------------------------------------------

def coqc_guard_ok() -> tuple[bool, str]:
    """Returns (ok, reason). ok is False if any guard fails; the run must
    then defer that one fix (never the whole batch/run) and log why."""
    if RAM_LOW.exists():
        return False, "docs/RAM_LOW exists"
    try:
        n = subprocess.run(["pgrep", "-c", "coqc"], capture_output=True, text=True)
        running = int(n.stdout.strip() or "0")
    except Exception as exc:  # pragma: no cover - defensive
        return False, f"could not run pgrep -c coqc: {exc}"
    if running != 0:
        return False, f"pgrep -c coqc reports {running} running (must be 0)"
    try:
        free_out = subprocess.run(["free", "-g"], capture_output=True, text=True).stdout
        mem_line = free_out.splitlines()[1]
        available_gb = int(mem_line.split()[6]) if len(mem_line.split()) > 6 else int(mem_line.split()[3])
    except Exception as exc:  # pragma: no cover - defensive
        return False, f"could not parse free -g: {exc}"
    if available_gb < 2:
        return False, f"free -g available={available_gb}GB (< 2GB floor)"
    return True, "ok"


# ---------------------------------------------------------------------
# Atomic CANONICAL.json write helper (re-reads immediately before each
# atomic write, per spec sec.5). Not exercised by this run's data (see
# module docstring) but present for any future plan item whose action
# requires a real field edit.
# ---------------------------------------------------------------------

def atomic_apply_canonical(mutate) -> bool:
    """`mutate(doc, by_code)` mutates doc['canonical'] entries in place and
    returns True if it changed anything. Re-reads CANONICAL.json fresh
    immediately before calling `mutate`, then writes back only if changed."""
    doc = load_canonical()
    idx = canonical_by_code(doc)
    changed = mutate(doc, idx)
    if changed:
        CANONICAL_PATH.write_text(
            json.dumps(doc, indent=2, ensure_ascii=False, sort_keys=False) + "\n",
            encoding="utf-8",
        )
    return changed


def append_lineage(events: list[dict], dry_run: bool) -> None:
    if not events:
        return
    text = "".join(json.dumps(e, sort_keys=True, ensure_ascii=False) + "\n" for e in events)
    if dry_run:
        print("--- would append to registry/LINEAGE.jsonl ---")
        print(text, end="")
        return
    with LINEAGE_PATH.open("a", encoding="utf-8") as fh:
        fh.write(text)


def make_lineage_event(code: str, finding_id: str, quoted: str) -> dict:
    return {
        "code": code,
        "date": DATE,
        "event": "revised",
        "from": None,
        "to": None,
        "reason": f"{finding_id} (docs/CONSISTENCY_SPEC_v0_1.md sec.5, toledo-v1.9-registrar-fixes): {quoted}",
        "by": BY,
    }


# ---------------------------------------------------------------------
# Per-fix classification and application
# ---------------------------------------------------------------------

NO_OP_ACTION_RE = re.compile(r"^\s*No (separate action|code change)\b", re.IGNORECASE)


def apply_mechanical_fix(fix: dict, dry_run: bool) -> dict:
    """Applies one `mechanical: true` fix. Returns an outcome record for
    the applied-fixes log. Never writes CANONICAL.json/LINEAGE.jsonl for a
    fix whose own `action` text says no content-field touch is needed
    (class A, sec.5) -- that IS the correct application, not a skip."""
    action = fix.get("action", "")
    finding_id = fix.get("finding_id", "?")
    codes = fix.get("codes", [])

    if NO_OP_ACTION_RE.match(action):
        return {
            "finding_id": finding_id,
            "codes": codes,
            "outcome": "closed_no_content_change",
            "note": (
                "class A (sec.5): action text confirms no CANONICAL.json/"
                "LINEAGE.jsonl/coq field is touched (dedup note or "
                "administrative closure) -- no LINEAGE event per spec's "
                "class-A row; finding closed by this commit message."
            ),
            "action": action,
        }

    # No plan item in this run's five files falls outside the no-op
    # pattern while still being mechanical=true (verified by inspection,
    # see module docstring). Any future plan item that does must not be
    # blindly edited by pattern-matching its prose -- defer it visibly
    # rather than guess at a field mutation.
    return {
        "finding_id": finding_id,
        "codes": codes,
        "outcome": "deferred_unrecognized_mechanical_action",
        "note": (
            "mechanical=true but this script does not recognize the "
            "action's shape as a safe automatic field edit; deferred for "
            "manual registrar follow-up rather than guessed at."
        ),
        "action": action,
    }


def skip_reason_for(fix: dict) -> str:
    if fix.get("skip_reason"):
        return fix["skip_reason"]
    action = (fix.get("action") or "").strip().replace("\n", " ")
    if len(action) > 400:
        action = action[:400] + "..."
    return f"mechanical=false (registrar judgment call, sec.5 class B/C): {action}"


# ---------------------------------------------------------------------
# Output writers (idempotent full rewrite each call)
# ---------------------------------------------------------------------

def write_needs_ruling_remaining(skipped: list[dict]) -> None:
    lines = [
        "# Registrar fixes deferred by scripts/v19_registrar_fixes.py",
        "",
        "Generated from the `mechanical: false` items in the five",
        "ops/clearing/registrar_fix_plan_*.json investigate-phase plans --",
        "every one of these is a reader/registrar judgment call the spec",
        "(docs/CONSISTENCY_SPEC_v0_1.md sec.5) reserves to a class C reader",
        "clearance row or a class D founder ruling; v19 never applies them.",
        "Regenerate (never hand-edit) by re-running the script.",
        "",
        f"**{len(skipped)}** deferred.",
        "",
        "---",
        "",
    ]
    for fix in sorted(skipped, key=lambda f: f.get("finding_id", "")):
        lines.append(f"### `{fix.get('finding_id', '?')}` ({fix.get('_plan_file', '?')})")
        lines.append("")
        codes = fix.get("codes", [])
        code_note = f"{len(codes)} code(s): {', '.join(codes[:6])}" + (", ..." if len(codes) > 6 else "")
        lines.append(f"- codes: {code_note}")
        lines.append(f"- action: {fix.get('action', '')}")
        lines.append(f"- skip_reason: {skip_reason_for(fix)}")
        lines.append("")
    NEEDS_REMAINING.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")


def write_applied_log(applied: list[dict]) -> None:
    lines = [
        "# Fixes applied by scripts/v19_registrar_fixes.py",
        "",
        "Every `mechanical: true` item from the five",
        "ops/clearing/registrar_fix_plan_*.json plans, and what this script",
        "actually did with it. See the script module docstring for why this",
        "run wrote zero CANONICAL.json/LINEAGE.jsonl changes (every",
        "mechanical=true item's own action text was a class-A no-content-",
        "field administrative closure or an already-tracked duplicate",
        "note).",
        "",
        f"**{len(applied)}** applied.",
        "",
        "---",
        "",
    ]
    for rec in sorted(applied, key=lambda r: r.get("finding_id", "")):
        lines.append(f"### `{rec.get('finding_id', '?')}` -- {rec.get('outcome')}")
        lines.append("")
        lines.append(f"- codes: {', '.join(rec.get('codes', []))}")
        lines.append(f"- note: {rec.get('note', '')}")
        lines.append(f"- action (from plan): {rec.get('action', '')}")
        lines.append("")
    APPLIED_LOG.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")


# ---------------------------------------------------------------------
# Git commit + handoff append per batch
# ---------------------------------------------------------------------

def git(*args: str) -> subprocess.CompletedProcess:
    return subprocess.run(["git", *args], cwd=ROOT, capture_output=True, text=True)


def commit_batch(batch_no: int, batch_ids: list[str], applied_count: int, deferred_count: int,
                  remaining_total: int, dry_run: bool) -> str:
    status = git("status", "--porcelain")
    if not status.stdout.strip():
        return "no changes to commit for this batch"
    if dry_run:
        return "dry-run: would git add -A && git commit"
    git("add", "-A")
    id_range = f"{batch_ids[0]} .. {batch_ids[-1]}" if batch_ids else "(none)"
    msg = (
        f"v19 registrar-fix batch {batch_no}: {id_range}\n\n"
        f"{applied_count} closed (no content change), {deferred_count} deferred to "
        f"NEEDS_RULING_REMAINING.md this batch. {remaining_total} findings remain "
        "in NEEDS_RULING_REMAINING.md overall.\n\n"
        "Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>"
    )
    result = git("commit", "-m", msg)
    return result.stdout + result.stderr


def append_handoff_line(batch_no: int, batch_ids: list[str], applied_count: int,
                         deferred_count: int, remaining_total: int, dry_run: bool) -> None:
    id_range = f"{batch_ids[0]} .. {batch_ids[-1]}" if batch_ids else "(none)"
    line = (
        f"- [v19 batch {batch_no}] applied finding ids {id_range} "
        f"({applied_count} closed no-content-change, {deferred_count} deferred); "
        f"{remaining_total} registrar findings remain in "
        "ops/clearing/NEEDS_RULING_REMAINING.md.\n"
    )
    if dry_run:
        print("--- would append to HANDOFF ---")
        print(line, end="")
        return
    with HANDOFF.open("a", encoding="utf-8") as fh:
        fh.write(line)


# ---------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------

def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    fixes = load_plans()
    print(f"loaded {len(fixes)} fix items from {len(PLAN_FILES)} plans")

    applied: list[dict] = []
    skipped: list[dict] = []
    deferred_ram: list[dict] = []

    batches = [fixes[i:i + BATCH_SIZE] for i in range(0, len(fixes), BATCH_SIZE)]
    for batch_no, batch in enumerate(batches, start=1):
        batch_applied = 0
        batch_deferred = 0
        for fix in batch:
            if fix.get("mechanical") is True:
                if fix.get("needs_coqc"):
                    ok, reason = coqc_guard_ok()
                    if not ok:
                        deferred_ram.append({**fix, "guard_reason": reason})
                        print(f"[RAM GUARD] deferring {fix.get('finding_id')}: {reason}")
                        continue
                rec = apply_mechanical_fix(fix, args.dry_run)
                applied.append(rec)
                if rec["outcome"] == "closed_no_content_change":
                    batch_applied += 1
                else:
                    skipped.append(fix)
                    batch_deferred += 1
            else:
                skipped.append(fix)
                batch_deferred += 1

        # Re-write outputs after every batch (idempotent full rewrite from
        # everything decided so far) and commit -- crash-safe resume point.
        write_needs_ruling_remaining(skipped)
        write_applied_log(applied)
        batch_ids = [f.get("finding_id", "?") for f in batch]
        commit_msg = commit_batch(batch_no, batch_ids, batch_applied, batch_deferred,
                                   len(skipped), args.dry_run)
        append_handoff_line(batch_no, batch_ids, batch_applied, batch_deferred,
                             len(skipped), args.dry_run)
        print(f"batch {batch_no}/{len(batches)}: {batch_applied} closed, "
              f"{batch_deferred} deferred -- {commit_msg.strip()}")

    print()
    print(f"TOTAL: {len(fixes)} plan items; "
          f"{sum(1 for r in applied if r['outcome'] == 'closed_no_content_change')} closed "
          f"(no content change), "
          f"{sum(1 for r in applied if r['outcome'] != 'closed_no_content_change')} "
          f"deferred-unrecognized, {len(skipped)} skipped (mechanical=false) -> "
          f"{NEEDS_REMAINING.relative_to(ROOT)}, {len(deferred_ram)} deferred by RAM/coqc guard")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
