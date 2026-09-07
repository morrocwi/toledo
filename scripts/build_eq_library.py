#!/usr/bin/env python3
"""Regenerate EQ_LIBRARY.md — the one file that says where every equation of the programme stands.
Sources: registry/eq_<record_id>.json (raw inventory, 40 chapters), registry/CANONICAL.json (when present) —
each canonical entry's own `root`, `statement.latest` and `coq{}` fields per registry/SCHEMA.md.
Readout, not truth: every number is counted from files."""
import json, glob, pathlib, datetime, yaml
R = pathlib.Path(__file__).resolve().parent.parent / 'registry'
MAN = R / 'textbook_manifest.yaml'  # copy of the textbook manifest (record ids, DOIs, titles); refreshed at each release
man = yaml.safe_load(MAN.read_text()); meta = {c['record_id']: c for P in man['parts'] for c in P['chapters'] if c.get('record_id')}
can = json.load(open(R / 'CANONICAL.json')) if (R / 'CANONICAL.json').exists() else None
r2c = (can or {}).get('raw_to_canonical', {})
# T11 (design meeting): NO fallback code generator — codes come only from the relabel step per SCHEMA.md; a missing code is a build error.
if can:
    missing=[c['id'] for c in can['canonical'] if not c.get('code')]
    if missing: raise SystemExit(f'BUILD ERROR: {len(missing)} canonical entries have no code (first: {missing[:5]}) — run the relabel step')
code_of = {c['id']: c.get('code', '') for c in (can or {}).get('canonical', [])}
# Coq data comes straight from each canonical entry's own `coq{}` object (SCHEMA.md) —
# the coq/canonical/LEDGER_*.md ledger format was superseded by per-code Coq files at N3
# (2026-09-06) and no such file exists any more (build_eq_library bug, gate B1, 2026-09-07).
coq_identified = sum(1 for c in (can or {}).get('canonical', []) if c.get('coq', {}).get('identifier'))
out = [f"# Equation Library — Human–AI Readout Programme\n\nGenerated {datetime.date.today()} by `registry/build_eq_library.py`. One file for the state of every equation: raw inventory per chapter → canonical id (Genesis-first: one root equation read per domain; latest formulation wins; occurrences mapped, sources never edited) → Coq identifier and tier.\n"]
files = sorted(glob.glob(str(R / 'eq_*.json')))
raw = sum(len(json.load(open(f)).get('equations', [])) for f in files)
out.append(f"## Status\n- Chapters inventoried: {len(files)}\n- Raw equations: {raw}\n- Canonical objects: {len(can['canonical']) if can else 'not yet built (WF-CANON running)'}\n- Raw→canonical mapped: {len(r2c)}\n- Coq identifiers (canonical set): {coq_identified}\n- Master River v1.4 (22519148) equations 1–79: Coq set 22518450, 45 lemmas closed (coq/MR_Ledger.md)\n- Founder rulings: BBL-165 (Th_coqc for every equation), 170 (all chapters, one file), 171 (canonicalise first), 172 (latest formulation), 173 (map only), 174 (one master equation along the line), 175/176 (Readout Genesis first: same equation read per domain), 177 (collapse until one reader reads the whole line)\n")
if can:
    out.append("## Canonical objects (Genesis-first order; codes per EQ_CODE_SCHEME.md)\n\n| Code | CAN | Root object | Domain | Canonical statement | Tier | Coq | #occ |\n|---|---|---|---|---|---|---|---|")
    for c in can['canonical']:
        coq = c.get('coq', {}) or {}
        coq_cell = ' '.join(x for x in (coq.get('coq_status', ''), coq.get('identifier', '')) if x)
        out.append(f"| {c.get('code','')} | {c['id']} | {c.get('root','')} | {c.get('domain','')} | {((c.get('statement') or {}).get('latest',''))[:110].replace('|','\\|')} | {c.get('tier','')} | {coq_cell[:110].replace('|','\\|')} | {len(c.get('occurrences',[]))} |")
    out.append('')
out.append("## Raw inventory by chapter (every numbered equation, with its canonical id when assigned)\n")
for f in files:
    d = json.load(open(f)); rid = d['record_id']; m = meta.get(rid, {})
    out.append(f"### {m.get('title', d.get('title',''))[:90]} — {d.get('doi', m.get('doi',''))} ({len(d.get('equations',[]))} equations)\n")
    if d.get('equations'):
        out.append("| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |\n|---|---|---|---|---|---|")
        for e in d['equations']:
            key = f"{rid}:{e.get('label','')}"
            out.append(f"| {e.get('label','')} | {str(e.get('section',''))[:40].replace('|','\\|')} | {str(e.get('text',''))[:120].replace('|','\\|').replace(chr(10),' ')} | {e.get('paper_tier','')} | {e.get('in_master_river') or ''} | {code_of.get(r2c.get(key,''), r2c.get(key,''))} |")
    else:
        out.append(f"_No numbered equations ({d.get('note','')})._")
    out.append('')
(R / 'EQ_LIBRARY.md').write_text('\n'.join(out))
print('EQ_LIBRARY.md', raw, 'raw equations,', len(files), 'chapters, canonical', len(can['canonical']) if can else 0)
