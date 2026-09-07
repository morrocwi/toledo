#!/usr/bin/env python3
"""
toledo_build.py — GENERATOR layer for the Toledo equation library.

Reads registry/CANONICAL.json (the ruled schema in registry/SCHEMA.md, decision T1
in docs/MEETING_2026-09-06_toledo_design.md) plus registry/genesis_root.json for any
Layer-0 root row CANONICAL.json does not yet carry, and writes every generated
artifact: per-code JSON-LD documents, the aggregate TOLEDO.json, the typed graph
(JSON / GraphML / Turtle), the site search index, Obsidian vault pages, and the
generated LaTeX catalogue body.

Pure Python 3 stdlib + latex2mathml + sympy. No network, no coqc, no pdflatex.
Nothing here is hand-edited output — every file this script writes is regenerated
from registry/CANONICAL.json + registry/genesis_root.json on every run.

Run with --sample to exercise the whole pipeline against
tests/fixtures/CANONICAL.sample.json before the real registry/CANONICAL.json lands,
writing to sample_output/ instead of the real output directories so nothing here
collides with tonight's real build.
"""
from __future__ import annotations

import argparse
import copy
import datetime
import json
import pathlib
import re
import sys
import xml.sax.saxutils as sax

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent

CODE_RE = re.compile(
    r"^(?P<root>EQ-0\d{2}|[A-Za-z][A-Za-z0-9]*(?:[._-][A-Za-z0-9]+)*)"
    r"(?:/(?P<domain>[EHSWMPCB])\.(?P<seq>\d{2,4})(?:\.v(?P<rev>[1-9]\d*))?)?$"
)

TIER_ENUM = {"Th_coqc", "finite_diagnostic", "Dr", "Open", "Definition", "Ax", "RETRACTED", "untagged"}

# A synthesized root row whose own `statement` text already quotes a literal Coq
# `Axiom <name> : <Type>.` line (gate B2, 2026-09-07) — used by genesis_row_to_canonical()
# to disclose that directly instead of defaulting it the same as an un-investigated row.
ROOT_AXIOM_STATEMENT_RE = re.compile(r"^\s*Axiom\s+(\w+)\s*:")

ASSUMPTIONS_MADE = []  # collected for the --sample / build report


def note_assumption(text: str) -> None:
    if text not in ASSUMPTIONS_MADE:
        ASSUMPTIONS_MADE.append(text)


def code_safe(code: str) -> str:
    """Filesystem-safe mangling per docs/EQ_CODE_SCHEME.md: '/' -> '__', '.' -> '_'."""
    return code.replace("/", "__").replace(".", "_")


def today() -> str:
    return datetime.date.today().isoformat()


# --------------------------------------------------------------------------
# Loading + reconciling CANONICAL.json and genesis_root.json
# --------------------------------------------------------------------------

def load_json(path: pathlib.Path):
    with open(path, encoding="utf-8") as fh:
        return json.load(fh)


def load_canonical(path: pathlib.Path):
    if path.exists():
        return load_json(path)
    note_assumption(
        f"registry/CANONICAL.json not found at build time ({path}); "
        "built the canonical set from registry/genesis_root.json root rows alone."
    )
    return {"schema_version": "1.0.0", "generated_from_commit": None, "canonical": [], "raw_to_canonical": {}}


def map_tier(tier_in_genesis: str) -> str:
    """Best-effort fold of a free-text Genesis tier string into the small CANONICAL tier enum.
    ASSUMPTION (for the registrar): this heuristic is a stand-in for the real N3 tier-normalisation
    pass; tier_in_genesis_verbatim always preserves the original text losslessly."""
    if not tier_in_genesis:
        return "untagged"
    t = tier_in_genesis.strip()
    if t.upper() == "RETRACTED":
        return "RETRACTED"
    if t in TIER_ENUM:
        return t
    low = t.lower()
    if "th_coqc" in low:
        return "Th_coqc"
    if "finite_diagnostic" in low:
        return "finite_diagnostic"
    if re.search(r"(^|[^a-z])dr([^a-z]|$)", low):
        return "Dr"
    if "open" in low:
        return "Open"
    if "definition" in low or low.startswith("def"):
        return "Definition"
    if low.startswith("ax"):
        return "Ax"
    return "untagged"


def genesis_row_to_canonical(row: dict, anchor: dict) -> dict:
    """Synthesize a CANONICAL-shaped entry (SCHEMA.md entry shape) from one
    registry/genesis_root.json root row. ASSUMPTIONS this makes (reported to the
    registrar; the real N3 pass in CANONICAL.json should supersede all of these):

    - genesis_root.json rows carry ONE `derived_via` for the whole row and a flat
      list of parent-code strings; mapped here to CANONICAL's per-parent
      {code, derived_via} shape by repeating the row's single derived_via for
      every parent.
    - genesis_root.json carries no `id`; synthesized as CAN-ROOT-<code-safe>.
    - genesis_root.json carries no `statement.format`; treated as "ascii-math"
      (never "latex") since these are Genesis's own prose/unicode statements,
      not typeset source — so no MathML is attempted for synthesized root rows
      (this is a real gap the real CANONICAL.json entries should close by giving
      roots a latex statement.format where one exists).
    - `first_assigned` is stamped with the build date (today), since
      genesis_root.json rows carry no assignment date of their own.
    - `status`/`status_note`: "historical" + a generic note when
      tier_in_genesis == RETRACTED (T14), else "current".
    - `tier` is filled by the best-effort map_tier() heuristic; verbatim text is
      always preserved in tier_in_genesis_verbatim.
    - `occurrences[]` is built from `synthesis_occurrences` (bare strings like
      "(4)") with everything except `raw_key` left null, since genesis_root.json
      does not carry record_id/doi/label/section per occurrence.
    - `coq` object defaults to all-empty/"root_layer_unwired" for a synthesized root row
      (Coq wiring happens in a later stream, N5, not this generator) — a distinct value
      from the reading-layer's retired `not_yet_formalised` enum member (gate B2,
      2026-09-07, `registry/SCHEMA.md`'s dated addendum), so the two are never confused in
      a rendered view. The one exception is a root row whose own `statement` already
      quotes a literal Coq `Axiom` line (currently only `CMC`) — disclosed via
      `ROOT_AXIOM_STATEMENT_RE` instead of defaulted, since the source already discloses
      more than "not yet looked at".
    """
    code = row["code"]
    parents = [{"code": p, "derived_via": row.get("derived_via") or "reads"} for p in row.get("parents", [])]
    tier_in_genesis = row.get("tier_in_genesis", "") or ""
    is_retracted = tier_in_genesis.strip().upper() == "RETRACTED"
    axiom_match = ROOT_AXIOM_STATEMENT_RE.match(row.get("statement", "") or "")
    if axiom_match:
        coq = {
            "file": None,
            "identifier": axiom_match.group(1),
            "assumptions": None,
            "imported_from": row.get("section") or None,
            "coq_status": "axioms",
            "coq_axioms": [axiom_match.group(1)],
            "coq_source_redistributed": row.get("coq_source_redistributed", True),
        }
    else:
        coq = {
            "file": None, "identifier": None, "assumptions": None, "imported_from": None,
            "coq_status": "root_layer_unwired", "coq_axioms": [], "coq_source_redistributed": True,
        }
    entry = {
        "id": f"CAN-ROOT-{code_safe(code)}",
        "code": code,
        "root": code,
        "layer": "root",
        "domain": None,
        "aliases": list(row.get("aliases", [])),
        "name": row.get("name", ""),
        "statement": {"latest": row.get("statement", ""), "format": "ascii-math"},
        "statements_history": [
            {"v": 1, "statement": row.get("statement", ""), "date": today(),
             "reason": "seeded from registry/genesis_root.json (Genesis root inventory)", "by": "toledo_build"}
        ],
        "parents": parents,
        "children": [],
        "origin": {
            "source": "genesis",
            "repo_anchor": {
                "repo": anchor.get("repo", "readout_genesis"),
                "commit": anchor.get("commit"),
                "path": row.get("section", ""),
            } if anchor else None,
            "record_id": None,
            "doi": None,
            "section": row.get("section"),
        },
        "status": "historical" if is_retracted else "current",
        "status_note": (f"RETRACTED in Readout Genesis: {tier_in_genesis}" if is_retracted else ""),
        "superseded_by": None,
        "tier": "RETRACTED" if is_retracted else map_tier(tier_in_genesis),
        "tier_in_genesis_verbatim": tier_in_genesis,
        "coq": coq,
        "relations": [],
        "occurrences": [
            {"record_id": None, "doi": None, "label": None, "section": row.get("section"), "raw_key": occ}
            for occ in row.get("synthesis_occurrences", [])
        ],
        "role": row.get("role", "other"),
        "first_assigned": today(),
    }
    return entry


def build_entries(canonical_doc: dict, genesis_doc: dict | None) -> tuple[list[dict], dict]:
    """Merge CANONICAL.json['canonical'] with any genesis_root.json root row whose
    code is not already present. Returns (entries, raw_to_canonical)."""
    entries_by_code: dict[str, dict] = {}
    for e in canonical_doc.get("canonical", []):
        entries_by_code[e["code"]] = copy.deepcopy(e)

    if genesis_doc is not None:
        anchor = genesis_doc.get("anchor", {}) or {}
        for row in genesis_doc.get("root_equations", []):
            if row["code"] not in entries_by_code:
                entries_by_code[row["code"]] = genesis_row_to_canonical(row, anchor)

    entries = list(entries_by_code.values())

    # children[] is ALWAYS computed here, never trusted from input (T1).
    for e in entries:
        if e.get("children"):
            note_assumption(
                f"entry {e['code']!r} arrived with a non-empty hand-written children[]; "
                "overwritten by the computed inversion of parents[] per SCHEMA.md."
            )
        e["children"] = []
    for e in entries:
        for p in e.get("parents", []):
            parent_code = p.get("code")
            if parent_code in entries_by_code:
                entries_by_code[parent_code]["children"].append(e["code"])

    raw_to_canonical = dict(canonical_doc.get("raw_to_canonical", {}))
    return entries, raw_to_canonical


# --------------------------------------------------------------------------
# MathML / OpenMath generation (DLMF statement layer, BBL-200)
# --------------------------------------------------------------------------

def presentation_mathml(statement: dict):
    if statement.get("format") != "latex":
        return None, "statement.format is not \"latex\" (no Presentation MathML attempted)"
    latex_src = statement.get("latest", "")
    if not latex_src.strip():
        return None, "empty statement"
    try:
        import latex2mathml.converter as l2m
        return l2m.convert(latex_src), None
    except Exception as exc:  # pragma: no cover - defensive
        return None, f"latex2mathml failed: {exc}"


def content_mathml(statement: dict):
    if statement.get("format") != "latex":
        return None, None, "statement.format is not \"latex\" (no Content MathML/OpenMath attempted)"
    latex_src = statement.get("latest", "")
    if not latex_src.strip():
        return None, None, "empty statement"
    try:
        from sympy.parsing.latex import parse_latex
        from sympy.printing.mathml import mathml
        expr = parse_latex(latex_src)
        cmml = mathml(expr, printer="content")
        try:
            from sympy.printing.repr import srepr  # noqa: F401
        except Exception:
            pass
        openmath = None  # sympy has no direct OpenMath printer; Content MathML is the closest available generated form
        return cmml, openmath, None
    except ImportError as exc:
        return None, None, f"sympy.parsing.latex unavailable ({exc}); antlr4 runtime not installed"
    except Exception as exc:
        return None, None, f"statement not parseable by sympy.parsing.latex: {exc}"


# --------------------------------------------------------------------------
# JSON-LD
# --------------------------------------------------------------------------

JSONLD_CONTEXT = {
    "schema": "https://schema.org/",
    "prov": "http://www.w3.org/ns/prov#",
    "dcterms": "http://purl.org/dc/terms/",
    "datacite": "http://purl.org/spar/datacite/",
    "code": "schema:identifier",
    "name": "schema:name",
    "statement": "schema:text",
    "parents": "prov:wasDerivedFrom",
    "origin": "prov:wasAttributedTo",
    "record": "schema:isPartOf",
    "dateCreated": "schema:dateCreated",
    "dateModified": "schema:dateModified",
    "status": "schema:creativeWorkStatus",
    "tier": "datacite:ResourceType",
    "root": "prov:wasDerivedFrom",
    "children": "prov:generated",
    "relations": "schema:isRelatedTo",
    "occurrences": "prov:wasQuotedFrom",
}


def entry_to_jsonld(e: dict, build_commit: str | None, generated_at: str) -> dict:
    origin = e.get("origin") or {}
    doc = {
        "@context": JSONLD_CONTEXT,
        "@id": f"https://morrocwi.github.io/toledo/{e['code']}",
        "@type": "schema:CreativeWork",
        "code": e["code"],
        "root": e["root"],
        "layer": e["layer"],
        "domain": e.get("domain"),
        "aliases": e.get("aliases", []),
        "name": e.get("name", ""),
        "statement": e.get("statement", {}),
        "parents": [
            {"@type": "prov:Entity", "code": p["code"], "derived_via": p.get("derived_via")}
            for p in e.get("parents", [])
        ],
        "children": e.get("children", []),
        "origin": {
            "@type": "prov:Attribution",
            "source": origin.get("source"),
            "repo_anchor": origin.get("repo_anchor"),
            "record": {"doi": origin.get("doi")} if origin.get("doi") else None,
            "section": origin.get("section"),
        },
        "status": e.get("status"),
        "status_note": e.get("status_note", ""),
        "superseded_by": e.get("superseded_by"),
        "tier": e.get("tier"),
        "tier_in_genesis_verbatim": e.get("tier_in_genesis_verbatim", ""),
        "relations": e.get("relations", []),
        "occurrences": e.get("occurrences", []),
        "role": e.get("role"),
        "dateCreated": e.get("first_assigned"),
        "dateModified": generated_at,
        "coq": e.get("coq", {}),
        "generated_from_commit": build_commit,
    }
    return doc


# --------------------------------------------------------------------------
# Graph (JSON / GraphML / Turtle)
# --------------------------------------------------------------------------

def build_graph(entries: list[dict]) -> dict:
    nodes = []
    for e in entries:
        nodes.append({
            "code": e["code"],
            "layer": e.get("layer"),
            "domain": e.get("domain"),
            "tier": e.get("tier"),
            "step": e.get("step"),
            "name": e.get("name", ""),
        })
    edges = []
    for e in entries:
        for p in e.get("parents", []):
            edges.append({"source": p["code"], "target": e["code"], "type": "parent", "derived_via": p.get("derived_via")})
        for r in e.get("relations", []):
            edges.append({"source": e["code"], "target": r["target"], "type": r["type"], "note": r.get("note", "")})
        if e.get("status") == "superseded_by" and e.get("superseded_by"):
            edges.append({"source": e["code"], "target": e["superseded_by"], "type": "supersedes_by", "note": ""})
        for occ in e.get("occurrences", []):
            rid = occ.get("record_id")
            if rid is not None:
                edges.append({"source": e["code"], "target": f"record:{rid}", "type": "occurrence", "note": occ.get("label", "")})
    return {"nodes": nodes, "edges": edges}


def graph_to_graphml(graph: dict) -> str:
    lines = [
        '<?xml version="1.0" encoding="UTF-8"?>',
        '<graphml xmlns="http://graphml.graphdrawing.org/xmlns">',
        '  <key id="layer" for="node" attr.name="layer" attr.type="string"/>',
        '  <key id="domain" for="node" attr.name="domain" attr.type="string"/>',
        '  <key id="tier" for="node" attr.name="tier" attr.type="string"/>',
        '  <key id="step" for="node" attr.name="step" attr.type="string"/>',
        '  <key id="name" for="node" attr.name="name" attr.type="string"/>',
        '  <key id="edgetype" for="edge" attr.name="type" attr.type="string"/>',
        '  <graph id="toledo" edgedefault="directed">',
    ]
    for n in graph["nodes"]:
        nid = sax.escape(n["code"])
        lines.append(f'    <node id="{nid}">')
        for k in ("layer", "domain", "tier", "step", "name"):
            v = n.get(k)
            if v is not None:
                lines.append(f'      <data key="{k}">{sax.escape(str(v))}</data>')
        lines.append('    </node>')
    for i, ed in enumerate(graph["edges"]):
        s, t = sax.escape(ed["source"]), sax.escape(ed["target"])
        lines.append(f'    <edge id="e{i}" source="{s}" target="{t}">')
        lines.append(f'      <data key="edgetype">{sax.escape(ed["type"])}</data>')
        lines.append('    </edge>')
    lines.append('  </graph>')
    lines.append('</graphml>')
    return "\n".join(lines) + "\n"


TTL_PREFIXES = """@prefix schema: <https://schema.org/> .
@prefix prov: <http://www.w3.org/ns/prov#> .
@prefix toledo: <https://morrocwi.github.io/toledo/> .
"""


def ttl_escape(s: str) -> str:
    return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")


def entries_to_ttl(entries: list[dict]) -> str:
    lines = [TTL_PREFIXES]
    for e in entries:
        subj = f"toledo:{code_safe(e['code'])}"
        lines.append(f'{subj} a schema:CreativeWork ;')
        lines.append(f'  schema:identifier "{ttl_escape(e["code"])}" ;')
        if e.get("name"):
            lines.append(f'  schema:name "{ttl_escape(e["name"])}" ;')
        stmt = (e.get("statement") or {}).get("latest", "")
        if stmt:
            lines.append(f'  schema:text "{ttl_escape(stmt)}" ;')
        for p in e.get("parents", []):
            lines.append(f'  prov:wasDerivedFrom toledo:{code_safe(p["code"])} ;')
        origin = e.get("origin") or {}
        if origin.get("doi"):
            lines.append(f'  schema:isPartOf <https://doi.org/{origin["doi"]}> ;')
        if origin.get("source"):
            lines.append(f'  prov:wasAttributedTo "{ttl_escape(origin["source"])}" ;')
        if e.get("status"):
            lines.append(f'  schema:creativeWorkStatus "{ttl_escape(e["status"])}" ;')
        lines[-1] = lines[-1][:-2] + "."  # replace trailing " ;" with "."
        lines.append("")
    return "\n".join(lines) + "\n"


# --------------------------------------------------------------------------
# Obsidian vault pages (DLMF-style layout)
# --------------------------------------------------------------------------

def vault_markdown(e: dict) -> str:
    stmt = (e.get("statement") or {}).get("latest", "")
    fmt = (e.get("statement") or {}).get("format", "")
    # v1.5 lane D: when this entry carries a name_latex (scripts/v15_D.py --
    # a faithful LaTeX rendering of the ASCII sub/superscript notation
    # already in `name`), use it for the vault heading instead of the plain
    # `name` -- Obsidian and most Markdown renderers (this is what
    # site/build_site.py's own minimal Markdown->HTML converter is built
    # for) already render a bare `$...$` span as inline math, so this needs
    # no wrapper macro the way the printed LaTeX catalogue's
    # \texorpdfstring{} does (see heading_content() above). Falls back to
    # the plain `name` when no name_latex was assigned.
    heading_name = e.get("name_latex") or e.get("name", "")
    lines = [f"# {e['code']} — {heading_name}", ""]
    lines.append("## Statement")
    lines.append("")
    lines.append(f"```{fmt}")
    lines.append(stmt)
    lines.append("```")
    lines.append("")
    lines.append("## Symbols")
    lines.append("")
    if e.get("aliases"):
        lines.append("Also known as: " + ", ".join(f"`{a}`" for a in e["aliases"]))
    else:
        lines.append("_(no aliases recorded)_")
    lines.append("")
    lines.append("## Conditions")
    lines.append("")
    lines.append(f"- layer: `{e.get('layer')}`" + (f", domain: `{e.get('domain')}`" if e.get("domain") else ""))
    lines.append(f"- tier: `{e.get('tier')}` (verbatim: {e.get('tier_in_genesis_verbatim', '')})")
    lines.append(f"- role: `{e.get('role')}`")
    lines.append("")
    lines.append("## Provenance")
    lines.append("")
    origin = e.get("origin") or {}
    lines.append(f"- source: `{origin.get('source')}`")
    anchor = origin.get("repo_anchor")
    if anchor:
        lines.append(f"- repo anchor: `{anchor.get('repo')}` @ `{anchor.get('commit')}` :: `{anchor.get('path')}`")
    if origin.get("doi"):
        lines.append(f"- record DOI: {origin['doi']}")
    if origin.get("section"):
        lines.append(f"- section: {origin['section']}")
    lines.append("")
    lines.append("## Verification")
    lines.append("")
    coq = e.get("coq") or {}
    lines.append(f"- coq status: `{coq.get('coq_status', 'none')}`")
    if coq.get("file"):
        lines.append(f"- coq file: `{coq['file']}`")
    if coq.get("assumptions"):
        lines.append(f"- assumptions: {coq['assumptions']}")
    lines.append("")
    lines.append("## History")
    lines.append("")
    lines.append(f"- status: `{e.get('status')}`" + (f" — {e.get('status_note')}" if e.get("status_note") else ""))
    if e.get("superseded_by"):
        lines.append(f"- superseded by: [[{code_safe(e['superseded_by'])}]]")
    for h in e.get("statements_history", []):
        lines.append(f"- v{h.get('v')} ({h.get('date')}): {h.get('reason', '')} — by {h.get('by', '')}")
    lines.append("")
    lines.append("## Relations")
    lines.append("")
    if e.get("root") and e.get("root") != e.get("code"):
        lines.append(f"- root: [[{code_safe(e['root'])}]]")
    for p in e.get("parents", []):
        lines.append(f"- parent ({p.get('derived_via')}): [[{code_safe(p['code'])}]]")
    for c in e.get("children", []):
        lines.append(f"- child: [[{code_safe(c)}]]")
    for r in e.get("relations", []):
        lines.append(f"- {r['type']}: [[{code_safe(r['target'])}]]" + (f" — {r.get('note')}" if r.get("note") else ""))
    lines.append("")
    lines.append("## Permalink")
    lines.append("")
    lines.append(f"https://morrocwi.github.io/toledo/{e['code']}")
    lines.append("")
    return "\n".join(lines)


# --------------------------------------------------------------------------
# Catalogue (LaTeX body, Genesis-first order, per-root domain tables)
# --------------------------------------------------------------------------

def latex_escape(s: str) -> str:
    repl = {
        "&": r"\&", "%": r"\%", "$": r"\$", "#": r"\#", "_": r"\_",
        "{": r"\{", "}": r"\}", "~": r"\textasciitilde{}", "^": r"\textasciicircum{}",
        "\\": r"\textbackslash{}",
    }
    out = []
    for ch in s:
        out.append(repl.get(ch, ch))
    return "".join(out)


# --------------------------------------------------------------------------
# Printable catalogue (BBL-208, v1.2.0 redesign) — A4/10pt, one block per
# entry, natural code sort, Genesis-step Parts, real statement typesetting.
# --------------------------------------------------------------------------

_DIGIT_RUN_RE = re.compile(r"(\d+)")


def natural_key(code: str):
    """Sort key that orders digit runs numerically (A.2 before A.10) instead
    of lexicographically (BBL-208: the v1.1.0 catalogue string-sorted codes,
    e.g. A.1, A.10, A.11, A.2). Every token is tagged (0, text) or (1, int) so
    two keys of different shape never compare a str against an int."""
    key = []
    for part in _DIGIT_RUN_RE.split(code):
        if part == "":
            continue
        key.append((1, int(part)) if part.isdigit() else (0, part.lower()))
    return key


def natural_sort_string(code: str) -> str:
    """A single sortable string for makeidx \\index{sortkey@code}: every digit
    run zero-padded to a fixed width so lexicographic (makeindex's own) sort
    matches natural_key's numeric order."""
    return "".join(
        p.zfill(6) if p.isdigit() else p for p in _DIGIT_RUN_RE.split(code) if p != ""
    )


# Top-level Genesis headings ("PART I ...", "APPENDIX C ...", "THE FORCED SET
# ..."); used only to cluster root codes into printable \part{}s for
# navigation — a display grouping, never a claim about the corpus.
_PART_HEADING_RE = re.compile(r"^(PART\s+[IVXLCM]+(?:-[A-Z])?\b.*|APPENDIX\s+[A-Z]\b.*|THE FORCED SET\b.*)")

_EXT_PART_LABEL = "Root registry extension (founder ruling 2026-09-07)"
_UNCLASSIFIED_PART_LABEL = "Genesis (heading not yet classified)"


def genesis_part_label(section) -> str | None:
    if not section:
        return None
    top = str(section).split(">")[0].strip()
    return top if _PART_HEADING_RE.match(top) else None


def assign_root_parts(roots_sorted: list[dict], root_steps: dict) -> dict[str, str]:
    """Forward-fill each root's own top-level Genesis heading (when its
    `origin.section` carries one) across roots in step order, so a root whose
    own section string is a narrower sub-heading still lands in the Part its
    step position actually belongs to. Roots with no step (a founder root-
    registry extension, e.g. Theta/CMC) get their own trailing Part."""
    part_of: dict[str, str] = {}
    current = _UNCLASSIFIED_PART_LABEL
    for r in roots_sorted:
        step, _ = root_steps.get(r["code"], (None, None))
        if step is None:
            part_of[r["code"]] = _EXT_PART_LABEL
            continue
        own = genesis_part_label((r.get("origin") or {}).get("section"))
        if own:
            current = own
        part_of[r["code"]] = current
    return part_of


_BREAK_MARK = ""
_BREAK_EVERY = 14  # raw (pre-escape) characters between forced break points;
# tuned against real `latex/catalogue.log` Overfull \hbox warnings (BBL-208
# "iterate until 0 errors ... report the Overfull \hbox count") — lower this
# if any wrapped monospace block still overflows a line.


def _wrap_raw_line(line: str, break_every: int = _BREAK_EVERY, break_after: str = "") -> str:
    """Insert an invisible, zero-width break opportunity every `break_every`
    characters of unspaced text so a long unbroken ascii-math/Coq token still
    wraps inside the printed column (BBL-208: no fixed-width table, no
    overflow). Marks are inserted on the RAW string, before latex_escape(), so
    a mark can only ever land between two whole source characters — it never
    splits a multi-byte Unicode codepoint or a to-be-escaped special char.

    `break_after` (v1.5 lane D, Overfull \\hbox reduction) additionally forces
    a break immediately after any character it names, resetting the periodic
    counter there too — e.g. `break_after="/."` inserts a break right after
    every `/` and `.`, a natural place to wrap a run like
    "Schwarzschild/Kerr" or "V.17" that the plain periodic rule alone did not
    always reach in time on real headings (found by direct inspection of
    `latex/catalogue.log`'s Overfull \\hbox lines)."""
    out = []
    run = 0
    for ch in line:
        out.append(ch)
        if ch == " ":
            run = 0
            continue
        if break_after and ch in break_after:
            out.append(_BREAK_MARK)
            run = 0
            continue
        run += 1
        if run >= break_every:
            out.append(_BREAK_MARK)
            run = 0
    return "".join(out)


_HEADING_BREAK_EVERY = 10  # tighter than the body-text _BREAK_EVERY (14): a
# \section/\subsubsection* heading is set in a bold, often larger (10-14.4pt)
# font, so the same character count covers more horizontal width than in
# body text -- several headings still produced an Overfull \hbox at the
# original body-text threshold (BBL-208 v1.5 lane D, found by direct
# inspection of latex/catalogue.log).

_HEADING_BREAK_AFTER = "/."  # natural break points in this corpus's own
# heading names ("Schwarzschild/Kerr", "V.17 Registered Domain: ..."),
# combined with the periodic rule above (v1.5 lane D).


def wrap_heading_text(name: str) -> str:
    """A \\section{}/\\subsubsection*{} title does not wrap the way body text
    does when it contains one very long, space-free run (a name that embeds
    an inline formula fragment, e.g. "`M_hat_OLS/M_true ~ Var(a_true)/...`"
    with no internal spaces) -- found by direct test against the real
    document (this was the largest remaining source of Overfull \\hbox
    warnings, BBL-208). Applies the same invisible-break technique as
    monospace_block, tightened for headings (_HEADING_BREAK_EVERY,
    _HEADING_BREAK_AFTER — v1.5 lane D), so a long heading still wraps onto a
    second line instead of overflowing the page margin. `\\sloppy`, scoped to
    just this heading's own text via the enclosing group, relaxes
    interword-glue limits so TeX prefers a looser (rather than overfull)
    line when a natural hyphen (e.g. "domain-discovery") is the only
    available break near the margin -- a v1.5 lane D addition, the other
    technique (besides break-marks) this corpus's own Overfull \\hbox
    reduction task named for the heading class of warning."""
    marked = _wrap_raw_line(name or "", break_every=_HEADING_BREAK_EVERY, break_after=_HEADING_BREAK_AFTER)
    escaped = latex_escape(marked).replace(_BREAK_MARK, "\\hspace{0pt}")
    return "{\\sloppy " + escaped + "}"


_MATH_SPAN_SPLIT_RE = re.compile(r"(?<!\\)\$")


def wrap_mixed_heading(name_latex: str) -> str:
    """Heading-layout treatment for a `name_latex` string (scripts/v15_D.py,
    v1.5 lane D): the SAME \\sloppy + break-after-'/'-and-'.' technique
    wrap_heading_text() applies to a plain name, but applied only to the
    PLAIN-TEXT spans of name_latex (already latex_escape()'d by v15_D.py) —
    every `$...$` math span it contains is left byte-for-byte untouched, so
    no break mark or \\sloppy scoping is ever inserted inside real math. This
    is a display-layout decision only: the name_latex FIELD written to
    registry/CANONICAL.json by v15_D.py never carries a break mark or
    \\sloppy wrapper -- those are added here, at catalogue-render time, the
    same separation of concerns wrap_heading_text() already keeps between
    `name` (data) and its own heading rendering."""
    parts = _MATH_SPAN_SPLIT_RE.split(name_latex)
    out = []
    for i, part in enumerate(parts):
        if i % 2 == 0:
            marked = _wrap_raw_line(part, break_every=_HEADING_BREAK_EVERY, break_after=_HEADING_BREAK_AFTER)
            out.append(marked.replace(_BREAK_MARK, "\\hspace{0pt}"))
        else:
            out.append("$" + part + "$")
    return "{\\sloppy " + "".join(out) + "}"


def heading_content(e: dict) -> str:
    """Heading text for one catalogue \\section/\\subsubsection* (BBL-208
    layout; v1.5 lane D name_latex extension). When this entry carries a
    `name_latex` (scripts/v15_D.py: a faithful LaTeX rendering of the ASCII
    sub/superscript notation already present in its plain `name`), the
    heading typesets that rendering wrapped in \\texorpdfstring{}{} so
    hyperref's PDF bookmark/outline and text-extraction string still gets
    the plain, math-free `name` (the same `latex_escape(name)` fallback
    used when there is no name_latex, per hyperref's own \\pdfstringdef
    handling of the standard escaped-text macros latex_escape() produces) —
    a raw math command left inside a bare heading argument would otherwise
    leak into the PDF outline/search string as literal TeX source. Falls
    back to the existing plain-name path when no name_latex was assigned."""
    name = e.get("name", "")
    name_latex = e.get("name_latex")
    if name_latex:
        return f"\\texorpdfstring{{{wrap_mixed_heading(name_latex)}}}{{{latex_escape(name)}}}"
    return wrap_heading_text(name)


def monospace_block(text: str) -> list[str]:
    """Wrapped monospace block for ascii-math / Coq / any non-LaTeX, non-prose
    statement (BBL-208). Uses \\ttfamily + \\raggedright + an explicit,
    invisible break every _BREAK_EVERY characters instead of a true verbatim
    environment (fancyvrb/listings): this project's Unicode fallback
    (latex/unicode_pdf_fallback.sty, \\newunicodechar) relies on the source
    characters keeping their normal category codes so they still expand —
    a real Verbatim/lstlisting environment changes catcodes and was found,
    by direct test, to break on this corpus's Unicode math symbols (Invalid
    UTF-8 byte errors under fvextra's breakanywhere). \\ttfamily keeps the
    same escaping/substitution path already proven to compile."""
    text = text or ""
    lines = []
    for raw_line in text.split("\n"):
        marked = _wrap_raw_line(raw_line)
        escaped = latex_escape(marked).replace(_BREAK_MARK, "\\hspace{0pt}")
        lines.append(escaped)
    body = " \\\\\n".join(lines) if lines else "\\textit{[no statement text recorded]}"
    return ["\\begin{quote}", "\\ttfamily\\small\\raggedright\\noindent", body, "\\end{quote}"]


_DMATH_LENGTH_CAP = 150  # see statement_tex_lines: display math (\[ \]) does
# not auto-break, so a statement longer than this is routed straight to the
# wrapped monospace block instead of one massively overfull display line.
# (An earlier version of this generator used breqn's auto-breaking `dmath*`
# to typeset every statement.latex regardless of length; found by direct
# timing test against the real ~400-entry document to occasionally cost
# minutes per equation on this corpus's longer chained-relation statements —
# unacceptable build-time risk for a benefit (automatic line-breaking) that
# a length cap plus the existing monospace fallback already covers.)

# Three or more consecutive sub/superscript groups on one nucleus with no
# operator between them (`^{eff}_{tA}^{corr}_{H,t}...`) is invalid LaTeX
# ("Double subscript"/"Double superscript") -- one sub and one super on the
# same atom is fine, a third is not. Found by direct test against the real
# document: this specific chained-annotation shape (Lane S's mechanical
# ascii->LaTeX conversion has no notation for the source's own "iterated
# qualifier" style) was not reliably caught by the compile-based validation
# in scripts/latex_pdf_safe.py (a pdflatex log line can wrap a \message{}
# marker across two physical log lines, silently losing that block's
# boundary), so it is rejected here, statically, before display math is ever
# attempted -- a build-time typesetting decision, not a change to the
# statement.
_SCRIPT_RUN_RE = re.compile(r"(?:[_^](?:\{[^{}]*\}|[A-Za-z0-9]))+")
_SCRIPT_MARKER_RE = re.compile(r"[_^]")


def has_chained_subsup(latex_src: str) -> bool:
    """A TeX atom takes at most one subscript and one superscript, one of
    each. Any run of 2+ consecutive script groups that is NOT exactly one `_`
    and one `^` (in either order) is a "Double subscript"/"Double
    superscript" error -- e.g. `I_{dot}_{t}` (two subscripts) or
    `^{eff}_{tA}^{corr}` (three groups). Found by direct test against the
    real document."""
    for run in _SCRIPT_RUN_RE.findall(latex_src):
        markers = _SCRIPT_MARKER_RE.findall(run)
        if len(markers) > 2 or (len(markers) == 2 and markers[0] == markers[1]):
            return True
    return False


# A \text{...} argument is meant to hold a plain English word-run (this
# scheme's own stated rule for Lane S's ascii->LaTeX conversion); one that
# instead contains a bare control sequence (`\text{proportional-to \Gamma }`)
# is a mis-boundaried \text{} from that mechanical conversion -- found by
# direct test against the real document (the single largest source of
# residual pdflatex errors: one such entry alone produced 43 cascading
# "Missing }"/"Extra }"/"Missing $" errors). Rejected here, statically,
# before display math is attempted; the same monospace fallback every other
# non-LaTeX statement gets.
_TEXT_WITH_MACRO_RE = re.compile(r"\\text\{[^{}]*\\[A-Za-z]")


def has_macro_inside_text(latex_src: str) -> bool:
    return bool(_TEXT_WITH_MACRO_RE.search(latex_src))


def comment_out(lines: list[str]) -> list[str]:
    """Prefix every line with '% ' so it compiles as inert LaTeX comment text
    until scripts/latex_pdf_safe.py's validation pass decides to uncomment it
    (used for the disclosed dmath*-failure fallback block, see
    statement_tex_lines)."""
    out = []
    for block in lines:
        for line in block.split("\n"):
            out.append("% " + line)
    return out


_SUBSUP_TEXT_RE = re.compile(r"[_^]\\text\{")


def brace_wrap_subsup_text(latex_src: str) -> str:
    """breqn's own math tokenizer (unlike plain amsmath) can misparse a bare
    \\text{...} used directly as a sub/superscript argument (`^\\text{...}` /
    `_\\text{...}`, produced wherever Lane S wrapped an English word-run right
    after a `^`/`_`), raising "Argument of \\text@ has an extra }" cascading
    into "You can't use `\\lastbox' in vertical mode" (found by direct test
    against the real document, BBL-208). Wrapping it in its own explicit outer
    group (`^{\\text{...}}`) changes nothing about what is typeset — a
    sub/superscript already takes exactly the next brace group or token —
    it only gives breqn's tokenizer an unambiguous group boundary. A
    display-typesetting workaround, not a change to the statement (the
    registry/JSON/site copies of statement.latex are untouched)."""
    out = []
    i, n = 0, len(latex_src)
    while i < n:
        m = _SUBSUP_TEXT_RE.match(latex_src, i)
        if not m:
            out.append(latex_src[i])
            i += 1
            continue
        marker = latex_src[i]
        j = m.end()
        depth = 1
        while j < n and depth > 0:
            if latex_src[j] == "\\" and j + 1 < n:
                j += 2
                continue
            if latex_src[j] == "{":
                depth += 1
            elif latex_src[j] == "}":
                depth -= 1
            j += 1
        out.append(marker + "{" + latex_src[i + 1:j] + "}")
        i = j
    return "".join(out)


def statement_tex_lines(statement: dict | None) -> list[str]:
    """Render one entry's statement per BBL-208: statement.latex present ->
    display math (dmath* auto-breaks long lines, \\allowdisplaybreaks in the
    preamble); else format=="prose" -> plain paragraph text; else (ascii-math,
    "coq", or a bare "latex"-labelled plain-text statement carrying no actual
    .latex field) -> the wrapped monospace block above. Nothing inside a
    display-math/prose run is escaped or altered — copied verbatim from the
    source per BBL-172 (latest formulation wins). Display math uses plain
    `\[ \]` (not breqn's auto-breaking dmath*, see _DMATH_LENGTH_CAP above).

    A display-math candidate also carries its own monospace fallback,
    pre-rendered here but emitted as an inert LaTeX comment between disclosed
    markers: scripts/latex_pdf_safe.py test-compiles every such block
    standalone and, for the ones that do not compile (the mechanical
    ascii->LaTeX conversion upstream of this script is not error-free — e.g.
    an unbraced \\sqrt argument, a literal embedded "$"), swaps the block for
    its own fallback and adds a one-line disclosure. This is a build-time
    typesetting decision, not a change to the registry statement — the
    fallback text is the entry's own ascii/latest field, unedited, just as any
    other ascii-math entry renders."""
    statement = statement or {}
    latex_src = statement.get("latex")
    fmt = statement.get("format")
    latest = statement.get("latest", "") or ""
    if latex_src:
        # Every statement.latex in this corpus (Toledo v1.2 Lane S) is written
        # as a complete, self-delimited inline-math string ("$...$"), meant to
        # stand on its own — not as a bare expression meant for insertion into
        # an already-open math environment. dmath* opens its own math mode, so
        # the wrapping pair is stripped here (a display-typesetting decision,
        # not a change to the statement: the registry/JSON/site copies of
        # statement.latex keep the full "$...$" string exactly as Lane S wrote
        # it). Any OTHER literal, unescaped "$" inside is left untouched and
        # will simply fail the compile check below like any other malformed
        # snippet, falling back to the monospace print form.
        if len(latex_src) >= 2 and latex_src.startswith("$") and latex_src.endswith("$"):
            latex_src = latex_src[1:-1]
        latex_src = brace_wrap_subsup_text(latex_src)
        # breqn's automatic line-breaking (dmath*) does a combinatorial search
        # over candidate break points; a long chain of many relation operators
        # (found by direct test: a ~900-character statement built from ~25
        # chained \\neq clauses took minutes where a typical entry takes
        # sub-second) makes that search blow up. _DMATH_LENGTH_CAP bounds
        # build time by routing the longest statements straight to the same
        # monospace block used for every non-LaTeX statement, instead of ever
        # attempting to compile them as display math. A build-time
        # typesetting decision (like the $-stripping above), not a change to
        # the statement.
        if (len(latex_src) > _DMATH_LENGTH_CAP or has_chained_subsup(latex_src)
                or has_macro_inside_text(latex_src)):
            return monospace_block(statement.get("ascii") or latest)
        fallback = monospace_block(statement.get("ascii") or latest)
        return (
            ["% TOLEDO-DMATH-BEGIN", "\\[", latex_src, "\\]", "% TOLEDO-DMATH-END",
             "% TOLEDO-FALLBACK-BEGIN"]
            + comment_out(fallback)
            + ["% TOLEDO-FALLBACK-END"]
        )
    if fmt == "prose":
        return ["\\par\\noindent " + latex_escape(latest)]
    return monospace_block(statement.get("ascii") or latest)


def seqsplit_wrap(s: str) -> str:
    """`\\seqsplit{<latex_escape(s)>}` (latex/toledo.sty now `\\RequirePackage`s
    `seqsplit`, v1.5 lane D): seqsplit lets TeX insert a break between ANY two
    characters of its argument, which is exactly what a single long
    unbreakable technical token (a `coq_status` enum value like
    `root_layer_unwired`, a bare code, a `record_id:label` occurrence) needs
    and the periodic `_wrap_raw_line` mark-insertion approach could still miss
    depending on font/column width (found by direct inspection of
    `latex/catalogue.log`'s Overfull \\hbox lines for the metadata and
    occurrences lines, BBL-208 v1.5 lane D). Safe over already-escaped ASCII
    text: seqsplit's own scanner (`seqsplit.dtx`) consumes one TeX TOKEN at a
    time, so an escape sequence like `\\_` is never split apart -- the break
    is only ever inserted between whole tokens.

    LATEX-1 (2026-09-07): that token-scanning guarantee does NOT extend to a
    raw multi-byte UTF-8 character (e.g. a section sign, an em/en-dash) that
    latex_escape() passes through untouched -- under pdfTeX's 8-bit engine
    with inputenc-utf8 such a character is two-or-more catcode-12 byte
    tokens, not one, and \\seqsplit can and does insert a discretionary break
    between those bytes (reproduced every time on a clean `make catalogue`:
    56 real "Invalid UTF-8 byte sequence" errors). The technical tokens this
    function exists for (tier/status/coq_status enum values, bare codes,
    record_id:label occurrence pieces) are ASCII-only per this docstring's
    own opening paragraph -- non-ASCII only ever arrives here from a source
    text field (an occurrence label, e.g.) that was never the intended
    target. Fix: any non-ASCII codepoint anywhere in the input skips
    \\seqsplit entirely and falls back to plain latex_escape() -- no
    mid-character break is possible then, at the cost of that one string not
    getting seqsplit's anywhere-break behaviour (an ASCII-only technical
    token never hits this branch, so the fix changes nothing for the actual
    intended use)."""
    if not s.isascii():
        return latex_escape(s)
    return "\\seqsplit{" + latex_escape(s) + "}"


def entry_metadata_line(e: dict) -> str:
    dom = e.get("domain")
    coq_status = (e.get("coq") or {}).get("coq_status") or "none"
    parent_codes = [p.get("code", "") for p in (e.get("parents") or []) if p.get("code")]
    # A parent code can itself be a long, space-free slug (a founder-ruled
    # root-registry extension id, a rootless HRP-X.<nnn> drift code) —
    # \seqsplit{} (v1.5 lane D) lets it wrap anywhere it needs to.
    parents_txt = ", ".join(seqsplit_wrap(c) for c in parent_codes) if parent_codes else "none"
    bits = [
        f"domain: {latex_escape(dom) if dom else '\\textemdash'}",
        # tier/status/coq_status are enum-style single "words" (often
        # underscore-joined, e.g. "root_layer_unwired") with no internal
        # space for TeX to break at — \seqsplit{} (v1.5 lane D) rather than
        # a bare latex_escape() so a long value can still wrap.
        f"tier: {seqsplit_wrap(e.get('tier') or 'untagged')}",
        f"status: {seqsplit_wrap(e.get('status') or '')}",
        f"coq: {seqsplit_wrap(coq_status)}",
        f"parents: {parents_txt}",
    ]
    return " \\textbullet\\ ".join(bits)


def entry_occurrences_line(e: dict) -> str | None:
    occs = e.get("occurrences") or []
    if not occs:
        return None
    shown = []
    for o in occs[:12]:
        rid, label = o.get("record_id"), o.get("label")
        piece = ":".join(str(x) for x in (rid, label) if x not in (None, "")) or (o.get("raw_key") or "")
        if piece:
            # An occurrence label can itself embed a long unbroken run (a
            # source file path, a raw_key) that overflows a footnotesize
            # paragraph line — \seqsplit{} (v1.5 lane D) instead of the
            # periodic invisible-break marks, same rationale as
            # entry_metadata_line() above.
            shown.append(seqsplit_wrap(str(piece)))
    more = f" (+{len(occs) - len(occs[:12])} more)" if len(occs) > 12 else ""
    return f"Occurrences ({len(occs)}): " + ", ".join(shown) + more


def render_entry_body(e: dict) -> list[str]:
    out = ["\\par\\noindent\\textit{\\small " + entry_metadata_line(e) + "}"]
    note = e.get("status_note")
    if e.get("status") not in (None, "current") and note:
        out.append("\\par\\noindent{\\footnotesize\\itshape " + latex_escape(note) + "}")
    # No blank line here on purpose: breqn's dmath*/dmath environment expects
    # to be invoked while still in horizontal mode (mid-paragraph), grabbing
    # the preceding text's last box for its automatic line-breaking; a blank
    # line here forces an extra \par first, landing dmath* in vertical mode
    # instead and raising "You can't use `\\lastbox' in vertical mode" —
    # found by direct test against the real 1504-entry document (BBL-208).
    out.extend(statement_tex_lines(e.get("statement")))
    occ_line = entry_occurrences_line(e)
    if occ_line:
        out.append("")
        out.append("\\par\\noindent{\\footnotesize " + occ_line + "}")
    out.append("\\medskip")
    out.append("")
    return out


def status_counts_block(entries: list[dict]) -> list[str]:
    import collections
    status_counts = collections.Counter(e.get("status") or "current" for e in entries)
    tier_counts = collections.Counter(e.get("tier") or "untagged" for e in entries)
    coq_counts = collections.Counter((e.get("coq") or {}).get("coq_status") or "none" for e in entries)
    out = [f"\\textit{{Computed at this build over {len(entries)} entries.}}", ""]
    for title, counts in (("status", status_counts), ("tier", tier_counts), ("coq\\_status", coq_counts)):
        out.append(f"\\subsection*{{By {title}}}")
        out.append("\\begin{tabular}{lr}")
        out.append("\\toprule")
        out.append(f"{title} & count \\\\")
        out.append("\\midrule")
        for key, n in sorted(counts.items(), key=lambda kv: (-kv[1], str(kv[0]))):
            out.append(f"{latex_escape(str(key))} & {n} \\\\")
        out.append("\\bottomrule")
        out.append("\\end{tabular}")
        out.append("")
    return out


def code_index_block(entries: list[dict]) -> list[str]:
    """Generated two-column index-of-codes (makeidx): every entry's code was
    already given \\index{sortkey@code} at its own heading in build_catalogue_body;
    this just emits \\printindex. Kept as its own function so the fallback
    path (no makeindex available) can be swapped in from one call site."""
    return ["\\clearpage", "\\phantomsection", "\\addcontentsline{toc}{section}{Index of codes}", "\\printindex"]


def build_catalogue_body(entries: list[dict], root_steps: dict | None = None) -> str:
    root_steps = root_steps or {}
    roots = [e for e in entries if e.get("layer") == "root"]
    root_codes = {r["code"] for r in roots}
    readings_by_root: dict[str, list[dict]] = {}
    orphans = []
    for e in entries:
        if e.get("layer") == "root":
            continue
        root = e.get("root")
        if root in root_codes:
            readings_by_root.setdefault(root, []).append(e)
        else:
            orphans.append(e)

    def root_sort_key(r):
        step, _ = root_steps.get(r["code"], (None, None))
        return (0, step) if step is not None else (1, natural_key(r["code"]))

    roots_sorted = sorted(roots, key=root_sort_key)
    part_of = assign_root_parts(roots_sorted, root_steps)

    # Group roots by their assigned Part label so each Part heading is emitted
    # exactly once (a root's own step is still what orders roots_sorted, but
    # the same Genesis heading can recur at non-contiguous step ranges across
    # 592 root rows built up over several registry passes — grouping first
    # keeps the printed table of contents from repeating one Part many times).
    part_groups: dict[str, list[dict]] = {}
    for r in roots_sorted:
        part_groups.setdefault(part_of.get(r["code"], _UNCLASSIFIED_PART_LABEL), []).append(r)

    def part_order_key(label: str):
        steps = [s for s, _ in (root_steps.get(r["code"], (None, None)) for r in part_groups[label]) if s is not None]
        return (0, min(steps)) if steps else (1, label)

    part_labels_ordered = sorted(part_groups.keys(), key=part_order_key)

    out = ["% GENERATED by scripts/toledo_build.py (build_catalogue_body) --- do not hand-edit.",
           "\\allowdisplaybreaks"]
    entries_typeset = 0
    for label in part_labels_ordered:
        out.append(f"\\part{{{latex_escape(label)}}}")
        for r in part_groups[label]:
            skey = natural_sort_string(r["code"])
            out.append(f"\\section{{{latex_escape(r['code'])} --- {heading_content(r)}}}\\index{{{skey}@{latex_escape(r['code'])}}}")
            out.extend(render_entry_body(r))
            entries_typeset += 1
            readings = sorted(readings_by_root.get(r["code"], []), key=lambda e: natural_key(e["code"]))
            for rd in readings:
                rskey = natural_sort_string(rd["code"])
                out.append(f"\\subsubsection*{{{latex_escape(rd['code'])} --- {heading_content(rd)}}}\\index{{{rskey}@{latex_escape(rd['code'])}}}")
                out.extend(render_entry_body(rd))
                entries_typeset += 1

    if orphans:
        out.append(f"\\part{{Rootless items (target: none)}}")
        for e in sorted(orphans, key=lambda e: natural_key(e["code"])):
            skey = natural_sort_string(e["code"])
            out.append(f"\\subsubsection*{{{latex_escape(e['code'])} --- {heading_content(e)}}}\\index{{{skey}@{latex_escape(e['code'])}}}")
            out.append(f"\\par\\noindent\\textit{{\\small root {latex_escape(str(e.get('root')))} not found in this build}}")
            out.extend(render_entry_body(e))
            entries_typeset += 1

    out.append("\\part{End matter}")
    out.append("\\section{Status counts at this build}")
    out.extend(status_counts_block(entries))
    out.append("\\section{Index of codes}")
    out.extend(code_index_block(entries))

    out.insert(1, f"% entries_typeset={entries_typeset}")
    return "\n".join(out)


# --------------------------------------------------------------------------
# Orchestration
# --------------------------------------------------------------------------

def build_catalogue_meta() -> str:
    """Tiny generated \\def block \\input by latex/catalogue.tex's title page
    (BBL-208): version/licence/date read from CITATION.cff at build time (no
    hardcoded version number), so the catalogue always states whatever
    CITATION.cff says on the day it is built. Regex, not a YAML parser
    (stdlib-only, per this script's own no-dependency rule) — CITATION.cff's
    fields here are single-line `key: "value"` scalars."""
    citation_path = REPO_ROOT / "CITATION.cff"
    version, license_, date_released = "unknown", "unknown", today()
    if citation_path.exists():
        text = citation_path.read_text(encoding="utf-8")
        m = re.search(r'^version:\s*"?([^"\n]+)"?\s*$', text, re.MULTILINE)
        if m:
            version = m.group(1).strip()
        m = re.search(r'^license:\s*"?([^"\n]+)"?\s*$', text, re.MULTILINE)
        if m:
            license_ = m.group(1).strip()
        m = re.search(r'^date-released:\s*"?([^"\n]+)"?\s*$', text, re.MULTILINE)
        if m:
            date_released = m.group(1).strip()
    else:
        note_assumption("CITATION.cff not found at build time; catalogue title page shows 'unknown' version/licence.")
    return "\n".join([
        "% GENERATED by scripts/toledo_build.py (build_catalogue_meta) --- do not hand-edit.",
        f"\\newcommand{{\\ToledoVersion}}{{{latex_escape(version)}}}",
        f"\\newcommand{{\\ToledoLicense}}{{{latex_escape(license_)}}}",
        f"\\newcommand{{\\ToledoDateReleased}}{{{latex_escape(date_released)}}}",
        "",
    ])


def write_json(path: pathlib.Path, obj) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(obj, fh, indent=2, ensure_ascii=False, sort_keys=False)
        fh.write("\n")


def write_text(path: pathlib.Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(text)


def run_build(canonical_path: pathlib.Path, genesis_path: pathlib.Path | None, out_root: pathlib.Path) -> dict:
    canonical_doc = load_canonical(canonical_path)
    genesis_doc = load_json(genesis_path) if (genesis_path and genesis_path.exists()) else None
    if genesis_path and not genesis_path.exists():
        note_assumption(f"registry/genesis_root.json not found at {genesis_path}; no root rows were seeded from it.")

    entries, raw_to_canonical = build_entries(canonical_doc, genesis_doc)
    generated_at = today()
    build_commit = canonical_doc.get("generated_from_commit")

    entries_dir = out_root / "registry" / "entries"
    for e in entries:
        doc = entry_to_jsonld(e, build_commit, generated_at)
        pres_mml, pres_reason = presentation_mathml(e.get("statement", {}))
        cont_mml, openmath, cont_reason = content_mathml(e.get("statement", {}))
        doc["presentation_mathml"] = pres_mml
        doc["presentation_mathml_reason"] = pres_reason
        doc["content_mathml"] = cont_mml
        doc["openmath"] = openmath
        doc["content_mathml_reason"] = cont_reason
        write_json(entries_dir / f"{code_safe(e['code'])}.json", doc)

    toledo_doc = {
        "schema_version": canonical_doc.get("schema_version", "1.0.0"),
        "generated_from_commit": build_commit,
        "generated_at": generated_at,
        "count": len(entries),
        "canonical": entries,
        "raw_to_canonical": raw_to_canonical,
    }
    write_json(out_root / "registry" / "TOLEDO.json", toledo_doc)

    graph = build_graph(entries)
    write_json(out_root / "graph" / "toledo_graph.json", graph)
    write_text(out_root / "graph" / "toledo.graphml", graph_to_graphml(graph))
    write_text(out_root / "graph" / "toledo.ttl", entries_to_ttl(entries))

    vault_dir = out_root / "vault"
    for e in entries:
        write_text(vault_dir / f"{code_safe(e['code'])}.md", vault_markdown(e))

    index_rows = []
    for e in entries:
        index_rows.append({
            "code": e["code"],
            "statement_plain": (e.get("statement") or {}).get("latest", ""),
            "object": e.get("name", ""),
            "root": e.get("root"),
            "domain": e.get("domain"),
            "tier": e.get("tier"),
            "occurrences": len(e.get("occurrences", [])),
        })
    write_json(out_root / "site" / "index.json", {"generated_at": generated_at, "entries": index_rows})

    root_steps: dict[str, tuple] = {}
    if genesis_doc is not None:
        for row in genesis_doc.get("root_equations", []):
            root_steps[row["code"]] = (row.get("step"), row.get("step_note"))
    catalogue_body = build_catalogue_body(entries, root_steps)
    write_text(out_root / "latex" / "catalogue_body.tex", catalogue_body)
    write_text(out_root / "latex" / "catalogue_meta.tex", build_catalogue_meta())

    return {
        "entries": len(entries),
        "entries_dir": str(entries_dir),
        "toledo_json": str(out_root / "registry" / "TOLEDO.json"),
        "graph_json": str(out_root / "graph" / "toledo_graph.json"),
        "graph_graphml": str(out_root / "graph" / "toledo.graphml"),
        "graph_ttl": str(out_root / "graph" / "toledo.ttl"),
        "site_index": str(out_root / "site" / "index.json"),
        "vault_dir": str(vault_dir),
        "catalogue_body": str(out_root / "latex" / "catalogue_body.tex"),
        "assumptions": list(ASSUMPTIONS_MADE),
    }


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--canonical", type=pathlib.Path, default=REPO_ROOT / "registry" / "CANONICAL.json")
    ap.add_argument("--genesis-root", type=pathlib.Path, default=REPO_ROOT / "registry" / "genesis_root.json")
    ap.add_argument("--out-root", type=pathlib.Path, default=REPO_ROOT)
    ap.add_argument("--sample", action="store_true",
                     help="build from tests/fixtures/CANONICAL.sample.json into sample_output/ "
                          "instead of the real registry (does not touch registry/genesis_root.json)")
    args = ap.parse_args(argv)

    if args.sample:
        canonical_path = REPO_ROOT / "tests" / "fixtures" / "CANONICAL.sample.json"
        genesis_path = None
        out_root = REPO_ROOT / "sample_output"
    else:
        canonical_path = args.canonical
        genesis_path = args.genesis_root
        out_root = args.out_root

    report = run_build(canonical_path, genesis_path, out_root)
    print(json.dumps(report, indent=2))
    if report["assumptions"]:
        print("\n# Schema fields assumed by the generator (for the registrar):", file=sys.stderr)
        for a in report["assumptions"]:
            print(f"- {a}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
