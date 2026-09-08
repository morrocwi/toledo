#!/usr/bin/env python3
"""scripts/executable/classify.py — S1, Executable Equations classifier.

docs/EXECUTABLE_EQUATIONS_v0_1.md sec.1.2-1.4, sec.10 (stream S1).

Applies the base eligibility gate — the FLOOR, not a ceiling — to
registry/CANONICAL.json:

    status not in {not_an_equation, split}
    AND statement.format in {latex, latex+ascii}

then runs sympy.parsing.latex.parse_latex over the same source string
scripts/toledo_build.py::content_mathml would use if it ran on this format
(statement.latex for latex+ascii entries, statement.latest for latex
entries), and classifies each parse outcome into the buckets the spec
measured directly: parse-raises / no-Eq-node / Eq-both-bare-symbols
(categorical) / Eq-with-real-structure.

THE CLASSIFIER SCHEDULES REVIEW WORK, IT NEVER GRANTS ELIGIBILITY BY ITSELF
(sec.1.2, restated verbatim). A raw sympy parse-success is not a coverage or
rigor metric (sec.13 item 12) — this script's own report states that
plainly next to every number it prints, and flags the two false-positive
hazards sec.1.3 named (prose parsed as an implicit symbol product; a
genuine formula fragment embedded in a longer prose statement) as their own
separate diagnostic, never folded into the "eq_structured" count as if that
count alone certified anything.

This script NEVER writes registry/CANONICAL.json, registry/entries/*.json,
or registry/executable/*.json (extract_ir.py owns the latter, status
"candidate" only, per sec.13 item 2 — a classifier's raw output is never
auto-promoted).

Writes:
  - scripts/executable/_classify_output.json   (machine-readable per-entry
    classification; a working cache for extract_ir.py to read, NOT a second
    registry — sec.13 item 7 forbids a second, parallel registry/index for
    *executable metadata*; this file carries only this run's own transient
    classifier verdicts, superseded by the next run, and is never cited as
    evidence by anything downstream of extract_ir.py)
  - ops/executable_classifier_report.md        (human-readable; the exact
    per-domain table sec.1.3 shows, refreshed against this checkout, plus
    the sec.1.4 domain-honesty note verbatim)

Pure Python 3 stdlib + sympy (an existing registry dependency) +
antlr4-python3-runtime (checked by check_antlr4.py, called first; this
script refuses to run past a failed precondition — sec.1.1).
"""
from __future__ import annotations

import datetime
import json
import pathlib
import re
import subprocess
import sys

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent.parent
CANONICAL_PATH = REPO_ROOT / "registry" / "CANONICAL.json"
OUTPUT_JSON = pathlib.Path(__file__).resolve().parent / "_classify_output.json"
REPORT_MD = REPO_ROOT / "ops" / "executable_classifier_report.md"

DOMAINS = ["P", "B", "C", "M", "H", "W", "E", "S"]
DOMAIN_NAMES = {
    "E": "epistemic", "H": "human-AI", "S": "social", "W": "world-system",
    "M": "method", "P": "physics", "C": "chemistry", "B": "biology",
}

INELIGIBLE_STATUS = {"not_an_equation", "split"}
ELIGIBLE_FORMATS = {"latex", "latex+ascii"}

# sec.1.3 hazard 1: sympy's parse_latex treats prose as implicit
# multiplication of symbols. Heuristic signal only (never a hard 100%
# classifier) — a run of "word-shaped" symbol names (3+ plain letters, no
# digit/underscore/subscript) is what a sentence chopped into single-token
# symbols looks like; a real physics/chem/bio variable in this registry is
# overwhelmingly a single letter, a letter+digit, or a letter with a
# subscript (sympy renders \alpha, \Gamma, ... as the SPELLED-OUT Greek
# name, e.g. "alpha", "Gamma" — those are standard math notation, not
# English prose, and are excluded here by name so they never trip this
# heuristic; direct spot-check against this run's own output caught this —
# without the exclusion list, ordinary Greek-letter physics symbols were
# false-flagged as prose at a rate that made the diagnostic useless).
_WORDLIKE_SYMBOL = re.compile(r"^[a-zA-Z]{3,}$")
_GREEK_NAMES = {
    "alpha", "beta", "gamma", "delta", "epsilon", "varepsilon", "zeta",
    "eta", "theta", "vartheta", "iota", "kappa", "lambda", "mu", "nu", "xi",
    "omicron", "pi", "varpi", "rho", "varrho", "sigma", "varsigma", "tau",
    "upsilon", "phi", "varphi", "chi", "psi", "omega",
    "Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta", "Theta",
    "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omicron", "Pi", "Rho",
    "Sigma", "Tau", "Upsilon", "Phi", "Chi", "Psi", "Omega",
}


def word_like_symbol_count(expr) -> int:
    n = 0
    for s in expr.free_symbols:
        name = str(s)
        if name in _GREEK_NAMES:
            continue
        if _WORDLIKE_SYMBOL.match(name):
            n += 1
    return n


def check_antlr4_or_die() -> None:
    result = subprocess.run(
        [sys.executable, str(pathlib.Path(__file__).resolve().parent / "check_antlr4.py")],
        capture_output=True, text=True,
    )
    print(result.stdout.strip())
    if result.returncode != 0:
        print(
            "classify.py: REFUSING to run — antlr4 precondition (sec.1.1) "
            "did not pass. Fix the precondition, then re-run.",
            file=sys.stderr,
        )
        sys.exit(result.returncode)


def source_text(entry: dict) -> tuple[str | None, str]:
    """Returns (text, field_used) — the same source string
    scripts/toledo_build.py::content_mathml would use for this format."""
    stmt = entry.get("statement", {})
    fmt = stmt.get("format")
    if fmt == "latex+ascii":
        text = stmt.get("latex")
        return text, "statement.latex"
    if fmt == "latex":
        text = stmt.get("latest")
        return text, "statement.latest"
    return None, "n/a"


def classify_one(code: str, domain: str, text: str, field_used: str) -> dict:
    from sympy import Eq
    from sympy.parsing.latex import parse_latex

    row = {
        "code": code, "domain": domain, "field_used": field_used,
        "source_text": text,
    }
    try:
        expr = parse_latex(text)
    except Exception as exc:  # noqa: BLE001 — classifier must never crash the batch
        row["outcome"] = "parse_raises"
        row["error"] = f"{type(exc).__name__}: {exc}"
        return row

    row["parsed_repr"] = str(expr)
    row["word_like_symbol_count"] = word_like_symbol_count(expr)
    # threshold >=1, not >=2: direct inspection of this run's own "clean"
    # (unflagged) set at a >=2 threshold still let through a genuine
    # LaTeX-parser-artifact leak — "\mathcal{L}"/"\mathcal C" both
    # contribute the SAME spurious "mathcal" symbol into free_symbols
    # (a set, so a repeated leak still counts once), so a >=2 threshold
    # missed it; even a single word-like symbol is a strong contamination
    # signal given this registry's own single-letter/subscript variable
    # convention, so >=1 is used instead. A THIRD false-positive hazard
    # found this same way, beyond the two sec.1.3 already named: a bare
    # (un-escaped) word in the source LaTeX/ascii text that happens to
    # read as a LaTeX macro name without its leading backslash (seen live
    # in this run as "Gamma_R", "tau_c", "pi" typed without "\") is NOT
    # consumed as an implicit-multiplication artifact the way hazard 1
    # describes full sentences — instead sympy shatters just that one
    # bare word into a product of its own single letters, silently
    # corrupting one term of an otherwise well-formed equation. This
    # third hazard will NOT always trip word_like_symbol_count (the
    # shattered letters are individually short), so it is disclosed
    # separately per-entry via `parsed_repr` (sec.3's own designed
    # human-spot-check field) rather than claimed as caught by this flag.
    row["prose_heuristic_flag"] = (
        word_like_symbol_count(expr) >= 1 or len(expr.free_symbols) > 8
    )

    if not isinstance(expr, Eq):
        row["outcome"] = "no_eq_node"
        return row

    lhs, rhs = expr.lhs, expr.rhs
    lhs_bare = lhs.is_Symbol
    rhs_bare = rhs.is_Symbol
    if lhs_bare and rhs_bare:
        row["outcome"] = "categorical"
        return row

    row["outcome"] = "eq_structured"
    return row


def main() -> int:
    check_antlr4_or_die()

    import sympy  # noqa: F401 — import here, after the precondition check
    from importlib.metadata import version as pkg_version

    data = json.loads(CANONICAL_PATH.read_text())
    canonical = data["canonical"]
    commit = subprocess.run(
        ["git", "rev-parse", "HEAD"], cwd=REPO_ROOT, capture_output=True, text=True,
    ).stdout.strip()

    total = len(canonical)
    eligible_rows = []
    for e in canonical:
        if e.get("status") in INELIGIBLE_STATUS:
            continue
        if e.get("statement", {}).get("format") not in ELIGIBLE_FORMATS:
            continue
        eligible_rows.append(e)

    per_domain = {d: {"pool": 0, "parse_succeeds": 0, "eq_structured": 0,
                       "prose_flagged_of_succeeds": 0} for d in DOMAINS}
    outcomes_all = {"parse_raises": 0, "no_eq_node": 0, "categorical": 0, "eq_structured": 0}
    missing_source = 0
    classified = []

    for e in eligible_rows:
        code = e["code"]
        domain = e.get("domain")
        text, field_used = source_text(e)
        if domain in per_domain:
            per_domain[domain]["pool"] += 1
        if not text or not str(text).strip():
            missing_source += 1
            classified.append({
                "code": code, "domain": domain, "field_used": field_used,
                "outcome": "no_source_text",
            })
            continue
        row = classify_one(code, domain, text, field_used)
        classified.append(row)
        outcomes_all[row["outcome"]] = outcomes_all.get(row["outcome"], 0) + 1
        if row["outcome"] in ("no_eq_node", "categorical", "eq_structured"):
            if domain in per_domain:
                per_domain[domain]["parse_succeeds"] += 1
                if row.get("prose_heuristic_flag"):
                    per_domain[domain]["prose_flagged_of_succeeds"] += 1
        if row["outcome"] == "eq_structured" and domain in per_domain:
            per_domain[domain]["eq_structured"] += 1

    eligible_count = len(eligible_rows)
    parse_succeeds = sum(v for k, v in outcomes_all.items() if k != "parse_raises")
    output_doc = {
        "schema_version": "executable-classify-0.1",
        "generated_from_commit": commit,
        "generated_at": datetime.date.today().isoformat(),
        "sympy_version": sympy.__version__,
        "antlr4_version": pkg_version("antlr4-python3-runtime"),
        "canonical_total": total,
        "eligible_pool": eligible_count,
        "missing_source_text": missing_source,
        "outcomes": outcomes_all,
        "per_domain": per_domain,
        "entries": classified,
    }
    OUTPUT_JSON.write_text(json.dumps(output_doc, indent=2, ensure_ascii=False) + "\n")

    write_report(output_doc, total)

    print(f"canonical entries:            {total}")
    print(f"eligible pool (status/format gate): {eligible_count}")
    print(f"  missing source text (skipped):    {missing_source}")
    print(f"parse_raises:                  {outcomes_all['parse_raises']}")
    print(f"parse_succeeds:                {parse_succeeds}")
    print(f"  no_eq_node:                  {outcomes_all['no_eq_node']}")
    print(f"  categorical (both bare sym): {outcomes_all['categorical']}")
    print(f"  eq_structured:               {outcomes_all['eq_structured']}")
    print(f"wrote {OUTPUT_JSON}")
    print(f"wrote {REPORT_MD}")
    return 0


def write_report(doc: dict, total: int) -> None:
    lines = []
    lines.append("# Executable-equations classifier report (S1)")
    lines.append("")
    lines.append(
        "Tier: `finite_diagnostic` — a mechanical sympy parse pass over this "
        "checkout, run by `scripts/executable/classify.py`. **A raw parse-"
        "success count is a syntactic signal, never a coverage or rigor "
        "metric** (docs/EXECUTABLE_EQUATIONS_v0_1.md sec.1.3, sec.13 item "
        "12) — it schedules human review work, it does not itself grant "
        "eligibility (sec.1.2)."
    )
    lines.append("")
    lines.append(f"- Generated: {doc['generated_at']}")
    lines.append(f"- Registry commit: `{doc['generated_from_commit']}`")
    lines.append(f"- sympy {doc['sympy_version']}, antlr4-python3-runtime {doc['antlr4_version']}")
    lines.append("")
    lines.append("## Scope rule — measured counts (this checkout)")
    lines.append("")
    lines.append(f"- canonical entries: **{total}**")
    lines.append(f"- eligible pool (`status not in {{not_an_equation, split}}` AND "
                  f"`statement.format in {{latex, latex+ascii}}`): **{doc['eligible_pool']}**")
    if doc["missing_source_text"]:
        lines.append(
            f"- of which **{doc['missing_source_text']}** had no non-empty source "
            f"text in the field `content_mathml` itself would read, and were "
            f"skipped rather than mis-classified as a parse failure"
        )
    o = doc["outcomes"]
    succeeds = sum(v for k, v in o.items() if k != "parse_raises")
    lines.append(f"- `sympy.parsing.latex.parse_latex` raises: **{o['parse_raises']}**")
    lines.append(f"- `sympy.parsing.latex.parse_latex` succeeds: **{succeeds}**")
    lines.append(f"  - of which: no top-level Eq (`=`) node at all: **{o['no_eq_node']}**")
    lines.append(f"  - Eq node, both sides bare symbols (categorical): **{o['categorical']}**")
    lines.append(f"  - Eq node, at least one side has real structure: **{o['eq_structured']}**")
    lines.append("")
    lines.append(
        "**This is a raw syntactic-parse count, not a coverage or rigor "
        "metric.** Two independent hazards (sec.1.3) mean `eq_structured` is "
        "an UPPER BOUND on today's raw classifier signal, not a projected "
        "build count:"
    )
    lines.append("")
    lines.append(
        "1. sympy's `parse_latex` treats English prose as implicit "
        "multiplication of symbols — running prose can be silently accepted "
        "as if it had algebraic structure."
    )
    lines.append(
        "2. Even a genuine Eq node can come from a multi-sentence statement "
        "with one formula fragment embedded — sympy parses only up to the "
        "first relational clause, blind to qualifying prose around it. "
        "Extracting the formula correctly needs a human to read the "
        "surrounding sentence, not a stronger regex."
    )
    lines.append("")
    n_flagged = sum(v["prose_flagged_of_succeeds"] for v in doc["per_domain"].values())
    lines.append(
        f"This run's own prose-heuristic diagnostic (word-shaped symbol "
        f"names, or more than 8 distinct free symbols in one relation — a "
        f"signal only, never a hard classifier) flags **{n_flagged}** of the "
        f"{succeeds} parse-successes as hazard-(1)/(2)-shaped and needing "
        f"extra scrutiny at extraction/human-review time; it is not "
        f"subtracted from `eq_structured` above because it is a supplementary "
        f"signal, not a re-derivation of that count."
    )
    lines.append("")
    lines.append("## By domain (pool / parse-succeeds / eq-structured / prose-flagged-of-succeeds)")
    lines.append("")
    lines.append("| Domain | Pool | Parse-succeeds | Eq-structured | Prose-flagged |")
    lines.append("|---|---:|---:|---:|---:|")
    for d in DOMAINS:
        v = doc["per_domain"][d]
        lines.append(
            f"| {d} ({DOMAIN_NAMES[d]}) | {v['pool']} | {v['parse_succeeds']} | "
            f"{v['eq_structured']} | {v['prose_flagged_of_succeeds']} |"
        )
    lines.append("")
    lines.append("## Domain-honesty note (carried verbatim, sec.1.4)")
    lines.append("")
    lines.append(
        "The by-domain table above shows real skew: S (social) typically "
        "measures at or near zero parse-successes; E (epistemic), W "
        "(world-system) and H (human–AI) are all low. **This is not a "
        "quality gap in those domains** — they are legitimately mostly "
        "comparative, definitional, and relational statements (\"agency A "
        "does not have epistemic veto over agency B\", \"a fork must "
        "preserve lineage\"), not numeric relations, and a low or zero "
        "executable count there is not a signal that those domains are less "
        "rigorous or less complete than P/B/C/M. Every place this feature's "
        "coverage count is surfaced (`/browse/`, `/about/`, any future "
        "report) must carry this note next to the number, not as a footnote "
        "nobody reads."
    )
    lines.append("")
    lines.append("## What this script does NOT do")
    lines.append("")
    lines.append(
        "- Does not write `registry/CANONICAL.json`, `registry/entries/*.json`, "
        "or `registry/executable/*.json` — a human registrar is the only "
        "writer of anything beyond `status: \"candidate\"` "
        "(docs/EXECUTABLE_EQUATIONS_v0_1.md sec.13 item 2)."
    )
    lines.append(
        "- Does not attempt IR extraction — that is `extract_ir.py`, which "
        "reads this run's `_classify_output.json` and only ever emits "
        "`status: \"candidate\"` sidecars with `eligibility.reviewed_by: null`."
    )
    lines.append(
        "- Does not commit to a fixed large-scale target — sec.13 item 8 "
        "forbids treating any of these counts as a scale commitment before "
        "a real, timed pilot review exists."
    )
    REPORT_MD.write_text("\n".join(lines) + "\n")


if __name__ == "__main__":
    sys.exit(main())
