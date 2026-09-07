#!/usr/bin/env python3
"""latex_pdf_safe.py — build-time-only transform for the printable catalogue PDF.

Reads the GENERATED latex/catalogue_body.tex (written by scripts/toledo_build.py;
never hand-edited, never modified in place by this script) and writes
latex/catalogue_body.pdf.tex with two build-time-only substitutions:

1. Contiguous runs of Thai or Cyrillic script (natural-language quotes embedded
   verbatim in a statement or note, not mathematical notation) are replaced by a
   disclosed bracketed pointer, because this machine's pdflatex has no shaped
   Thai/Cyrillic font available to it. Every other literal Unicode character
   (math alphanumerics, arrows, relations, dashes, quotation marks, ...) passes
   through unchanged; those are handled at typeset time by
   latex/unicode_pdf_fallback.sty via newunicodechar.

2. BBL-208 (v1.2.0 catalogue redesign): every statement typeset as display math
   (scripts/toledo_build.py wraps it `% TOLEDO-DMATH-BEGIN ... % TOLEDO-DMATH-END`
   followed by its own pre-rendered monospace fallback, commented out, between
   `% TOLEDO-FALLBACK-BEGIN/END`) is test-compiled standalone, once, in a single
   batched pdflatex run. The mechanical ascii->LaTeX conversion upstream of this
   script (Toledo v1.2 Lane S) is not error-free on every one of ~400 statements
   (an unbraced \\sqrt argument, a double subscript, ...); a block that does not
   compile on its own is swapped for its own disclosed monospace fallback instead
   of being left to break the whole catalogue build. A block that DOES compile
   standalone is left exactly as scripts/toledo_build.py wrote it.

This is a PRINT-ARTIFACT compatibility step only. The registries
(registry/CANONICAL.json, registry/genesis_root.json), the generated JSON-LD
entries, TOLEDO.json, the docs site and the vault all carry the exact source
text with no substitution — this script never touches any of them, and neither
substitution above changes any statement's content, only how (or whether) this
one print artifact typesets it as math.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LATEX_DIR = ROOT / "latex"
SRC = LATEX_DIR / "catalogue_body.tex"
DST = LATEX_DIR / "catalogue_body.pdf.tex"
VALIDATE_STEM = LATEX_DIR / "_dmath_validate"

THAI_RUN = re.compile(r"[฀-๿]+")
CYRILLIC_RUN = re.compile(r"[Ѐ-ӿ]+")

THAI_NOTE = r"[Thai text omitted in the print catalogue -- see the JSON/site entry for the source text]"
CYRILLIC_NOTE = r"[Cyrillic text omitted in the print catalogue -- see the JSON/site entry for the source text]"

UNIT_RE = re.compile(
    r"% TOLEDO-DMATH-BEGIN\n(?P<dmath>.*?)% TOLEDO-DMATH-END\n"
    r"% TOLEDO-FALLBACK-BEGIN\n(?P<fallback>.*?)% TOLEDO-FALLBACK-END",
    re.DOTALL,
)

FALLBACK_NOTE = (
    r"\par\noindent{\footnotesize\itshape [print fallback: this entry's LaTeX "
    r"transcription did not compile as standalone display math; showing the "
    r"source ascii/latest text instead --- the registry, JSON entry and docs "
    r"site carry the LaTeX transcription unmodified]}"
)

VALIDATE_PREAMBLE = "\n".join([
    r"\documentclass[10pt,a4paper]{article}",
    r"\usepackage[T1]{fontenc}",
    r"\usepackage{lmodern}",
    r"\usepackage{textcomp}",
    r"\usepackage{amsfonts}",
    r"\usepackage{amsmath}",
    r"\usepackage{pifont}",
    r"\usepackage{newunicodechar}",
    r"\usepackage{unicode_pdf_fallback}",
    r"\begin{document}",
])


def uncomment(fallback_block: str) -> str:
    lines = []
    for line in fallback_block.split("\n"):
        if line.startswith("% "):
            lines.append(line[2:])
        elif line == "%":
            lines.append("")
        else:
            lines.append(line)
    return "\n".join(lines)


def brace_balance_ok(dmath_block: str) -> bool:
    """Cheap pre-filter, run before the block ever reaches the shared batched
    validation compile: a genuinely unbalanced brace (unlike a Missing-$ or
    double-subscript error) can trigger a TeX "Runaway argument" that swallows
    everything up to the next blank line or \\par -- potentially eating the
    following blocks' own TOLEDO-BEGIN/END \\message markers and mis-blaming
    them. Any block failing this check is marked bad directly and excluded
    from the shared compile, so it can never contaminate another block's
    result. Escaped \\{ / \\} do not count (skipped as one two-char token)."""
    depth = 0
    i = 0
    while i < len(dmath_block):
        c = dmath_block[i]
        if c == "\\" and i + 1 < len(dmath_block):
            i += 2
            continue
        if c == "{":
            depth += 1
        elif c == "}":
            depth -= 1
            if depth < 0:
                return False
        i += 1
    return depth == 0


def find_bad_dmath_indices(units: list[str]) -> set[int]:
    """Test-compile every STRUCTURALLY PLAUSIBLE dmath* block (brace-balanced,
    see brace_balance_ok) in ONE batched pdflatex run (RAM watchdog: one
    process, not one-per-entry) and return the 0-based indices (matching
    `units`' order) of every block that raised a LaTeX error -- the
    brace-unbalanced ones (never compiled, so never able to contaminate the
    batch) plus whatever the compile itself flags."""
    if not units:
        return set()
    bad: set[int] = set()
    plausible: list[tuple[int, str]] = []
    for i, dmath in enumerate(units):
        if brace_balance_ok(dmath):
            plausible.append((i, dmath))
        else:
            bad.add(i)
    if not plausible:
        return bad
    lines = [VALIDATE_PREAMBLE]
    for i, dmath in plausible:
        lines.append(f"\\message{{TOLEDO-BEGIN-{i}}}")
        # A benign paragraph line, no blank line before \begin{dmath*}: breqn
        # expects horizontal mode (mid-paragraph) immediately before it, same
        # as the real catalogue_body.tex context (see toledo_build.py's
        # render_entry_body) -- matching that here is what makes this
        # standalone check predictive of the real, full-document compile.
        lines.append(r"\par\noindent\textit{\small validation context}")
        lines.append(dmath.rstrip("\n"))
        lines.append(f"\\message{{TOLEDO-END-{i}}}")
    lines.append(r"\end{document}")
    tex_path = VALIDATE_STEM.with_suffix(".tex")
    tex_path.write_text("\n".join(lines), encoding="utf-8")
    try:
        subprocess.run(
            ["pdflatex", "-interaction=nonstopmode", "-no-shell-escape", tex_path.name],
            cwd=str(LATEX_DIR), capture_output=True, text=True, timeout=600,
        )
    except FileNotFoundError:
        print("latex_pdf_safe.py: pdflatex not found -- skipping dmath* validation "
              "for the brace-balanced blocks (only the brace-unbalanced ones above "
              "were caught; the real `make catalogue` build will surface the rest "
              "if any remain broken)", file=sys.stderr)
        return bad
    except subprocess.TimeoutExpired:
        print("latex_pdf_safe.py: dmath* validation pass timed out -- leaving the "
              "brace-balanced dmath* blocks as generated (only the brace-unbalanced "
              "ones above were caught)", file=sys.stderr)
        return bad
    log_path = VALIDATE_STEM.with_suffix(".log")
    log_text = log_path.read_text(encoding="utf-8", errors="replace") if log_path.exists() else ""
    # pdflatex wraps log lines at a fixed column; a \message{} marker landing
    # near that column can be split across two physical lines with no
    # separator other than the line break itself, silently losing it from a
    # naive line-by-line scan (found by direct test against the real
    # document -- a chained-subscript error slipped past that way). Collapse
    # runs of whitespace (newlines included) before locating markers/errors
    # by REGEX POSITION (not by line), so a wrapped marker is still one
    # contiguous, matchable substring; "!" errors are still real pdflatex
    # errors either way since collapsing whitespace cannot turn ordinary text
    # into a spurious "!" it didn't already contain.
    flat = re.sub(r"\s+", " ", log_text)
    events = []  # (position, kind, index_or_None) kind in {"begin","end","error"}
    for m in re.finditer(r"TOLEDO-BEGIN-(\d+)", flat):
        events.append((m.start(), "begin", int(m.group(1))))
    for m in re.finditer(r"TOLEDO-END-(\d+)", flat):
        events.append((m.start(), "end", int(m.group(1))))
    for m in re.finditer(r"(?<!\S)!(?!\S)", flat):
        # a bare "!" token: pdflatex always starts an error/warning line this
        # way ("! Missing $ inserted.", "! Double superscript.", ...)
        events.append((m.start(), "error", None))
    events.sort(key=lambda ev: ev[0])
    # `current` tracks the one block whose BEGIN marker we've seen without its
    # matching END yet. A block whose END never appears before the next BEGIN
    # (or before end of log) had its own boundary swallowed by some earlier
    # TeX recovery (a "Runaway argument" can eat several following tokens,
    # markers included) -- that block's result cannot be trusted, so it is
    # marked bad too, even with no directly-attributed error of its own.
    current = None
    for _, kind, idx in events:
        if kind == "begin":
            if current is not None:
                bad.add(current)  # previous block's own END was swallowed
            current = idx
        elif kind == "end":
            current = None
        elif kind == "error" and current is not None:
            bad.add(current)
    if current is not None:
        bad.add(current)  # last block's END never appeared before EOF
    for ext in (".tex", ".log", ".aux", ".pdf", ".out", ".fls", ".fdb_latexmk"):
        p = VALIDATE_STEM.with_suffix(ext)
        if p.exists():
            p.unlink()
    return bad


def apply_dmath_fallbacks(text: str) -> tuple[str, int, int]:
    units = [m.group("dmath") for m in UNIT_RE.finditer(text)]
    bad = find_bad_dmath_indices(units)
    counter = {"i": -1}

    def repl(m: re.Match) -> str:
        counter["i"] += 1
        if counter["i"] not in bad:
            return m.group(0)
        return FALLBACK_NOTE + "\n" + uncomment(m.group("fallback"))

    new_text = UNIT_RE.sub(repl, text)
    return new_text, len(units), len(bad)


def main() -> int:
    if not SRC.exists():
        print(f"latex_pdf_safe.py: {SRC} not found -- run `make build` first", file=sys.stderr)
        return 1
    text = SRC.read_text(encoding="utf-8")
    thai_runs = len(THAI_RUN.findall(text))
    cyr_runs = len(CYRILLIC_RUN.findall(text))
    text = THAI_RUN.sub(THAI_NOTE, text)
    text = CYRILLIC_RUN.sub(CYRILLIC_NOTE, text)
    text, dmath_total, dmath_bad = apply_dmath_fallbacks(text)
    DST.write_text(text, encoding="utf-8")
    print(f"latex_pdf_safe.py: {SRC.name} -> {DST.name} "
          f"({thai_runs} Thai run(s), {cyr_runs} Cyrillic run(s) replaced; "
          f"{dmath_bad}/{dmath_total} dmath* block(s) fell back to the monospace print form)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
