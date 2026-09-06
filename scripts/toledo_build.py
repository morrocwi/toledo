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
    - `coq` object defaults to all-empty/not_yet_formalised for a synthesized
      root row (Coq wiring happens in a later stream, N5, not this generator).
    """
    code = row["code"]
    parents = [{"code": p, "derived_via": row.get("derived_via") or "reads"} for p in row.get("parents", [])]
    tier_in_genesis = row.get("tier_in_genesis", "") or ""
    is_retracted = tier_in_genesis.strip().upper() == "RETRACTED"
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
        "coq": {"file": None, "identifier": None, "assumptions": None, "imported_from": None,
                "coq_status": "not_yet_formalised", "coq_axioms": [], "coq_source_redistributed": True},
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
    lines = [f"# {e['code']} — {e.get('name', '')}", ""]
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


def build_catalogue_body(entries: list[dict]) -> str:
    roots = [e for e in entries if e.get("layer") == "root"]
    roots.sort(key=lambda e: (e.get("step") if e.get("step") is not None else 10 ** 9, e["code"]))
    by_root: dict[str, list[dict]] = {r["code"]: [] for r in roots}
    orphans = []
    for e in entries:
        if e.get("layer") == "root":
            continue
        root = e.get("root")
        if root in by_root:
            by_root[root].append(e)
        else:
            orphans.append(e)

    out = []
    out.append("% GENERATED by scripts/toledo_build.py — do not hand-edit.")
    out.append("\\section*{Part 1 --- Genesis-first catalogue}")
    for r in roots:
        readings = sorted(by_root.get(r["code"], []), key=lambda e: e["code"])
        out.append(f"\\subsection*{{{latex_escape(r['code'])} --- {latex_escape(r.get('name', ''))}}}")
        out.append(f"\\textit{{tier: {latex_escape(r.get('tier', ''))}; status: {latex_escape(r.get('status', ''))}}}")
        out.append("")
        stmt = (r.get("statement") or {}).get("latest", "")
        out.append("\\par\\noindent\\texttt{" + latex_escape(stmt) + "}")
        out.append("")
        if readings:
            out.append("\\begin{longtable}{p{3.2cm}p{1cm}p{7cm}p{2cm}}")
            out.append("\\toprule")
            out.append("Code & Dom. & Statement & Status \\\\")
            out.append("\\midrule")
            out.append("\\endhead")
            for rd in readings:
                rstmt = (rd.get("statement") or {}).get("latest", "")
                out.append(
                    f"{latex_escape(rd['code'])} & {latex_escape(rd.get('domain') or '')} & "
                    f"{latex_escape(rstmt)} & {latex_escape(rd.get('status', ''))} \\\\"
                )
            out.append("\\bottomrule")
            out.append("\\end{longtable}")
        out.append("")

    out.append("\\section*{Part 2 --- Rootless items (target: none)}")
    hrp_orphans = [e for e in entries if e["code"].startswith("HRP-X.")]
    if not hrp_orphans and not orphans:
        out.append("\\textit{None at this build.}")
    else:
        out.append("\\begin{longtable}{p{4cm}p{9cm}}")
        out.append("\\toprule")
        out.append("Code & Note \\\\")
        out.append("\\midrule")
        out.append("\\endhead")
        for e in hrp_orphans:
            out.append(f"{latex_escape(e['code'])} & {latex_escape(e.get('status_note', 'no drift_note recorded'))} \\\\")
        for e in orphans:
            out.append(f"{latex_escape(e['code'])} & root {latex_escape(str(e.get('root')))} not found in this build \\\\")
        out.append("\\bottomrule")
        out.append("\\end{longtable}")
    out.append("")
    return "\n".join(out)


# --------------------------------------------------------------------------
# Orchestration
# --------------------------------------------------------------------------

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

    catalogue_body = build_catalogue_body(entries)
    write_text(out_root / "latex" / "catalogue_body.tex", catalogue_body)

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
