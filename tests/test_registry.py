"""Registry integrity tests: every raw equation maps to exactly one code; codes are unique; lineage is append-only-shaped."""
import json, glob, pathlib, collections
R = pathlib.Path(__file__).resolve().parent.parent / 'registry'
def test_raw_inventory_loads():
    n = 0
    for f in glob.glob(str(R / 'eq_*.json')):
        d = json.load(open(f)); assert 'record_id' in d and isinstance(d.get('equations', []), list); n += len(d['equations'])
    assert n > 0
def test_canonical_codes_unique_and_mapped():
    p = R / 'CANONICAL.json'
    if not p.exists(): return
    c = json.load(open(p)); codes = [x.get('code') for x in c['canonical']]
    assert all(codes), 'every canonical object needs a code'
    assert len(codes) == len(set(codes)), 'codes must be unique'
    raw = {f"{json.load(open(f))['record_id']}:{e.get('label')}" for f in glob.glob(str(R / 'eq_*.json')) for e in json.load(open(f)).get('equations', [])}
    mapped = set(c.get('raw_to_canonical', {}))
    assert raw <= mapped, f'unmapped raw equations: {sorted(raw - mapped)[:10]}'
def test_lineage_shape():
    p = R / 'LINEAGE.jsonl'
    if not p.exists(): return
    for l in open(p):
        e = json.loads(l); assert {'code', 'date', 'event'} <= set(e)
