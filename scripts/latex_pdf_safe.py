#!/usr/bin/env python3
"""latex_pdf_safe.py — build-time-only transform for the printable catalogue PDF.

Reads the GENERATED latex/catalogue_body.tex (written by scripts/toledo_build.py;
never hand-edited, never modified in place by this script) and writes
latex/catalogue_body.pdf.tex — the same content, except contiguous runs of Thai
or Cyrillic script (natural-language quotes embedded verbatim in a statement or
note, not mathematical notation) are replaced by a disclosed bracketed pointer,
because this machine's pdflatex has no shaped Thai/Cyrillic font available to
it. Every other literal Unicode character (math alphanumerics, arrows,
relations, dashes, quotation marks, ...) passes through unchanged; those are
handled at typeset time by latex/unicode_pdf_fallback.sty via newunicodechar.

This is a PRINT-ARTIFACT compatibility step only. The registries
(registry/CANONICAL.json, registry/genesis_root.json), the generated JSON-LD
entries, TOLEDO.json, the docs site and the vault all carry the exact source
text with no substitution — this script never touches any of them.
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "latex" / "catalogue_body.tex"
DST = ROOT / "latex" / "catalogue_body.pdf.tex"

THAI_RUN = re.compile(r"[฀-๿]+")
CYRILLIC_RUN = re.compile(r"[Ѐ-ӿ]+")

THAI_NOTE = r"[Thai text omitted in the print catalogue -- see the JSON/site entry for the source text]"
CYRILLIC_NOTE = r"[Cyrillic text omitted in the print catalogue -- see the JSON/site entry for the source text]"


def main() -> int:
    if not SRC.exists():
        print(f"latex_pdf_safe.py: {SRC} not found -- run `make build` first", file=sys.stderr)
        return 1
    text = SRC.read_text(encoding="utf-8")
    thai_runs = len(THAI_RUN.findall(text))
    cyr_runs = len(CYRILLIC_RUN.findall(text))
    text = THAI_RUN.sub(THAI_NOTE, text)
    text = CYRILLIC_RUN.sub(CYRILLIC_NOTE, text)
    DST.write_text(text, encoding="utf-8")
    print(f"latex_pdf_safe.py: {SRC.name} -> {DST.name} "
          f"({thai_runs} Thai run(s), {cyr_runs} Cyrillic run(s) replaced)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
