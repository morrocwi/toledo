#!/usr/bin/env python3
"""
scripts/v15_D.py -- Toledo v1.5.0, Lane D (catalogue names).

Idempotent, like every other lane registrar script in this tree
(scripts/v11_*.py, scripts/v12_S.py, scripts/v12_R.py): re-reads
registry/CANONICAL.json immediately before its one atomic write and only
ever touches the single field this lane owns -- `name_latex` -- on entries
whose `name` already contains ASCII sub/superscript notation (e.g.
"s^L_t", "q^min_t", "Gamma_t", "D^rent"). `name` itself is NEVER changed.
No entry, root, tier, parent, statement or proof is invented, merged or
re-tiered by this script.

`name_latex` is a faithful LaTeX rendering of the notation already present
in `name`: every ASCII sub/superscript token (a base identifier followed by
one or more `_..`/`^..` groups, including a bare Greek-letter word used as
an identifier, e.g. "Gamma") is converted to inline math ($...$) using the
SAME mechanical symbol/greek-word/brace-script machinery already reviewed
and shipped in scripts/v12_S.py's ascii-math -> LaTeX converter (imported
here, not duplicated, so there is exactly one such table in the tree).
Every other character of `name` -- ordinary prose -- is left as literal
text, LaTeX-escaped with the same latex_escape() scripts/toledo_build.py's
catalogue generator already uses for headings. Nothing is added, reworded,
or reordered: this is a display rendering of the same characters `name`
already carries, nothing more.

scripts/toledo_build.py's catalogue-heading and vault-markdown generators
were updated (v1.5 lane D) to use `name_latex` when present, via
\\texorpdfstring{} in the printed catalogue so hyperref's PDF bookmark/
search string still gets the plain `name`, and directly (Obsidian/most
markdown viewers render bare `$...$` as math) in the vault pages the docs
site is built from.

A token the converter cannot render with confidence (an unmapped symbol,
an unbalanced brace/paren count, an adjacent-script-marker ambiguity -- the
same heuristics scripts/v12_S.py's convert path already checks) is still
emitted best-effort, exactly like scripts/v12_S.py's task (c), and listed
in --review-out for manual review; being listed there does not by itself
change any other field.

Usage:
  python3 scripts/v15_D.py --report            # analysis only, no writes
  python3 scripts/v15_D.py --apply
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SCRIPTS = ROOT / "scripts"
REG = ROOT / "registry"
CANON = REG / "CANONICAL.json"
LINEAGE = REG / "LINEAGE.jsonl"
TODAY = "2026-09-07"
BY = "toledo-v1.5-D"

sys.path.insert(0, str(SCRIPTS))
# Reuse the reviewed ascii->LaTeX symbol/greek-word/brace-script machinery
# from lane S (v1.2) instead of duplicating a second copy of the same table
# in this tree. Import-time side effects of v12_S are limited to building
# its own module-level dicts/regexes (no file I/O) -- safe to import.
from v12_S import (  # noqa: E402
    apply_symbol_map,
    replace_greek_words,
    brace_parenthesized_scripts,
    brace_scripts,
)
from toledo_build import latex_escape, has_chained_subsup  # noqa: E402 -- same escaper +
# the same "Double subscript"/"Double superscript" LaTeX-validity guard
# scripts/toledo_build.py's statement renderer already uses (a naive
# per-underscore braced rendering of e.g. "M_hat_OLS" would otherwise emit
# invalid chained math M_{hat}_{OLS} -- never wrap in $...$ without this
# check; fall back to literal text for that token instead, see below).

# ---------------------------------------------------------------------------
# Atomic read-then-write helpers (idempotent, re-read immediately before the
# one write; touch only registry/CANONICAL.json's `name_latex` field).
# ---------------------------------------------------------------------------


def load_canonical():
    with open(CANON, "r", encoding="utf-8") as f:
        return json.load(f)


def atomic_write_canonical(doc):
    tmp = CANON.with_suffix(".json.tmp")
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(doc, f, ensure_ascii=False, indent=2)
        f.write("\n")
    tmp.replace(CANON)


def append_lineage(events):
    with open(LINEAGE, "a", encoding="utf-8") as f:
        for ev in events:
            f.write(json.dumps(ev, ensure_ascii=False) + "\n")


def by_code(doc, code):
    for e in doc["canonical"]:
        if e["code"] == code:
            return e
    return None


def recompute_canonical_counts(cd):
    """Same shape as scripts/v12_S.py's recompute_canonical_counts(cd) /
    scripts/v12_R.py's own copy -- kept local (no cross-import of a sibling
    lane's private helper) so this script has no import-time dependency
    beyond the shared machinery imported above. This lane never changes
    status/domain/tier/coq_status, so the counts it recomputes are, by
    construction, identical to what was already stored -- recomputed anyway
    so the embedded `counts` block never silently drifts from canonical[]
    if a future edit to this script ever does touch a counted field."""
    from collections import Counter

    canon = cd["canonical"]
    cd["counts"] = {
        "entries": len(canon),
        "by_status": dict(Counter(e["status"] for e in canon)),
        "by_domain": dict(Counter(e["domain"] for e in canon if e.get("domain"))),
        "by_tier": dict(Counter(e["tier"] for e in canon)),
        "by_coq_status": dict(Counter(e["coq"]["coq_status"] for e in canon)),
        "computed": f"{TODAY} from canonical[] (scripts/v15_D.py)",
    }


# ---------------------------------------------------------------------------
# Notation-token detection + mechanical ascii-notation -> LaTeX conversion.
# ---------------------------------------------------------------------------

# A base identifier (letter, then letters/digits) followed by one or more
# `_`/`^` groups, each a braced group or a run of letters/digits -- e.g.
# "s^L_t", "q^min_t", "Gamma_t", "D^rent", "C^alpha_A", "M_hat_OLS" is NOT
# matched as a chain beyond its own underscores (each `_xxx`/`^xxx` group is
# itself only letters/digits, matching this scheme's own existing corpus
# style; a comma or other punctuation inside an intended multi-part
# subscript, e.g. "Z_G,t" meaning Z_{G,t}, is deliberately NOT swept in --
# only the unambiguous "_G" part is rendered as math and the trailing ",t"
# is left as literal text; never invented past what the regex can read with
# confidence).
NOTATION_TOKEN_RE = re.compile(
    r"(?<![A-Za-z0-9_}])"
    r"[A-Za-z][A-Za-z0-9]*"
    r"(?:[_^](?:\{[^{}]*\}|[A-Za-z0-9]+))+"
)

# Safety filters found necessary by direct inspection of every match this
# regex produces over the real registry (269 raw matches; several were NOT
# math notation at all and one silently changed meaning -- see below). Each
# filter is a rejection only: a rejected token is left as literal, escaped
# text (exactly as if it had never matched), never converted, never
# dropped, never invented around.
#
# (i) A name that already demarcates its own formula with backticks (this
#     corpus's own verbatim/formula marker, e.g. "`BMR = a M^0.75`",
#     "`M_hat_OLS/M_true (Var(a_true)/...)`") is respected as already
#     explicitly delimited -- reinterpreting fragments *inside* a
#     backtick-quoted span as separate inline math produced two real
#     defects on direct inspection: a half-backtick/half-$...$ mixed
#     rendering, and (worse) "M^0.75" -- an exponent with a decimal point --
#     silently mis-split into exponent "0" plus literal trailing ".75"
#     because a bare digit-run group does not consume the decimal point,
#     changing the displayed value from M^0.75 to (M^0).75. Skipping any
#     name containing a backtick avoids both classes at once, honestly,
#     without inventing a decimal-aware grammar for a case never asked for.
# (ii) An entry whose own statement.format == "coq" (the Theta/CMC root-
#      registry-extension readings, registry/SCHEMA.md's addendum of the
#      same name) carries the bare Coq identifier itself as `name`
#      (optionally with a parenthetical kind, e.g. "qsquare_nonneg
#      (Lemma)") -- not sub/superscript math notation. Rendering
#      "qsquare_nonneg" as "$qsquare_{nonneg}$" would misrepresent a plain
#      identifier as a variable named "qsquare" with subscript "nonneg".
#      Skipped by the entry's own recorded format, not a guess.
# (iii) A name introduced by the literal phrase "theorem:" (case-
#       insensitive; this corpus's own "Health-stream theorem: <ident>"
#       labelling for EQ-015/B.04-09, format=="latex" so (ii) does not
#       catch it) is, by that same label, quoting a bare Coq identifier
#       (e.g. "disc_even", "cusp_factor") -- not notation.
_THEOREM_LABEL_RE = re.compile(r"theorem:\s*$", re.IGNORECASE)


def token_to_latex(tok: str) -> tuple[str, bool]:
    """Mechanical rendering of one matched notation token to inline math.
    Same substitution order as scripts/v12_S.py's convert_ascii_to_latex
    (minus the full-statement-only steps: brace-escaping, accent
    decomposition, ascii-arrow ops and phrase-wrapping do not apply to a
    bare identifier token). Returns (latex_without_dollars, is_ambiguous)."""
    s, unmapped = apply_symbol_map(tok)
    s = replace_greek_words(s)
    s = brace_parenthesized_scripts(s)
    s = brace_scripts(s)
    ambiguous = bool(unmapped)
    grouping_open = len(re.findall(r"(?<!\\){", s))
    grouping_close = len(re.findall(r"(?<!\\)}", s))
    if grouping_open != grouping_close:
        ambiguous = True
    return s, ambiguous


def build_name_latex(name: str, statement_format: str | None) -> tuple[str | None, bool]:
    """Returns (name_latex, is_ambiguous). name_latex is None when `name`
    carries no notation token at all, every matched token was rejected by
    one of the safety filters above or turned out chained-double-script
    (see below), or the whole name is out of scope for this lane (a
    backtick anywhere in it, or statement_format=="coq") -- either way this
    lane assigns no field (`name_latex` is a `key omitted when not
    applicable` field, same three-state convention `owner_year`/
    `drift_note` already use in registry/SCHEMA.md)."""
    if "`" in (name or "") or statement_format == "coq":
        return None, False
    matches = list(NOTATION_TOKEN_RE.finditer(name or ""))
    if not matches:
        return None, False
    pieces = []
    last = 0
    any_ambig = False
    any_math = False
    for m in matches:
        if m.start() > last:
            pieces.append(latex_escape(name[last:m.start()]))
        if _THEOREM_LABEL_RE.search(name[:m.start()]):
            # "... theorem: <identifier>" -- a bare Coq identifier label,
            # not notation (filter iii above).
            pieces.append(latex_escape(m.group(0)))
            last = m.end()
            continue
        tok_latex, ambig = token_to_latex(m.group(0))
        if has_chained_subsup(tok_latex):
            # Two-or-more sub/superscript groups of the SAME kind chained
            # directly onto one atom (e.g. naively rendering "M_hat_OLS" as
            # M_{hat}_{OLS}) is invalid LaTeX ("Double subscript"). The
            # source almost certainly meant one compound subscript
            # (M_{hat OLS} or similar) but this mechanical, symbol-for-
            # symbol converter has no way to know which word boundary was
            # intended -- never invent it. Leave this token as literal
            # escaped text instead (no math), flagged for manual review.
            pieces.append(latex_escape(m.group(0)))
            any_ambig = True
        else:
            pieces.append("$" + tok_latex + "$")
            any_math = True
            any_ambig = any_ambig or ambig
        last = m.end()
    pieces.append(latex_escape(name[last:]))
    if not any_math:
        return None, False
    return "".join(pieces), any_ambig


# ---------------------------------------------------------------------------


def run(apply_: bool, review_out: str | None):
    doc = load_canonical()
    changed = []
    ambiguous = []
    events = []
    for e in doc["canonical"]:
        name = e.get("name", "")
        statement_format = (e.get("statement") or {}).get("format")
        name_latex, is_ambig = build_name_latex(name, statement_format)
        if name_latex is None:
            continue  # no notation in this name -- field stays omitted
        if e.get("name_latex") == name_latex:
            continue  # idempotent: already correct, nothing to do
        old = e.get("name_latex")
        e["name_latex"] = name_latex
        changed.append(e["code"])
        if is_ambig:
            ambiguous.append((e["code"], name, name_latex))
        events.append({
            "code": e["code"],
            "date": TODAY,
            "event": "revised",
            "from": f"name_latex={old!r}" if old is not None else "name_latex=<absent>",
            "to": f"name_latex={name_latex!r}",
            "reason": (
                "v1.5 lane D (catalogue names): added/refreshed name_latex, a "
                "mechanical, faithful LaTeX rendering of the ASCII sub/superscript "
                "notation already present in this entry's own `name` (name itself "
                "unchanged); used by scripts/toledo_build.py for catalogue headings "
                "(via \\texorpdfstring) and vault/site pages."
                + (" FLAGGED FOR MANUAL REVIEW: converter heuristic ambiguity." if is_ambig else "")
            ),
            "by": BY,
        })

    print(f"v15_D: {len(changed)} entries given/refreshed name_latex; {len(ambiguous)} flagged ambiguous")

    if review_out:
        with open(review_out, "w", encoding="utf-8") as f:
            f.write("# v1.5 Lane D -- name -> name_latex renderings flagged for manual review\n\n")
            f.write(
                f"{len(ambiguous)} of {len(changed)} entries given a name_latex in this run were "
                "flagged by the mechanical converter's own heuristics (an unmapped Unicode symbol, "
                "or an unbalanced brace count after conversion). Never blocking -- each still got a "
                "best-effort rendering in name_latex; `name` is unchanged. Listed here for manual "
                "polish, same convention as ops/v12_S_ascii_to_latex_review.md.\n\n"
            )
            for code, name, name_latex in ambiguous:
                f.write(f"## {code}\n\n- name: `{name}`\n- name_latex (best-effort): `{name_latex}`\n\n")
        print(f"review notes written to {review_out} ({len(ambiguous)} flagged)")

    if apply_ and events:
        # re-read immediately before the atomic write (idempotency contract);
        # re-apply this run's own computation onto the freshly-read doc so a
        # concurrent lane's write in between is never clobbered.
        fresh = load_canonical()
        changed_set = set(changed)
        for e in doc["canonical"]:
            if e["code"] not in changed_set:
                continue
            fe = by_code(fresh, e["code"])
            if fe is None:
                continue
            fe["name_latex"] = e["name_latex"]
        recompute_canonical_counts(fresh)
        atomic_write_canonical(fresh)
        append_lineage(events)
        print(f"applied. {len(events)} lineage events appended.")
    elif not apply_:
        print("dry-run (pass --apply to write).")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true", help="write changes (default: dry-run report)")
    ap.add_argument("--review-out", default=str(ROOT / "ops" / "v15_D_name_latex_review.md"))
    args = ap.parse_args()
    run(args.apply, args.review_out)


if __name__ == "__main__":
    main()
