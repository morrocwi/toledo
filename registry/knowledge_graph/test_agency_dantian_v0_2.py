#!/usr/bin/env python3
"""Agency-Dantian v0.2: verify real knowledge graph and semantic typed overlay.

This tests descriptive structure and DAG acyclicity ONLY, never clinical Qi or Agency.
Usage:
  python test_agency_dantian_v0_2.py /path/to/qi_v1.json /path/to/qi_v1_1.json \
    /path/to/agency_dantian_bridge_overlay_v0_2.json
Inputs may be the JSON extracted from the provided ZIPs or decoded Git payload.
"""
import collections
import json
import sys

TARGETS = ["DT-L", "DT-M", "DT-U", "EX-HN3", "CV6", "CV17", "GV20"]
REGIONAL = {"in_region_of_or_associated_with", "approximate_region_overlap"}

def audit(g):
    nd = {n["id"] for n in g["nodes"]}
    assert len(nd) == len(g["nodes"]), "duplicate node IDs"
    assert all(e["source"] in nd and e["target"] in nd for e in g["edges"]), "missing endpoint"
    return {v: {
        "all": sum(v in (e["source"], e["target"]) for e in g["edges"]),
        "region": sum(
            v in (e["source"], e["target"]) and e["relation"] in REGIONAL
            for e in g["edges"])
    } for v in TARGETS}

def acyclic(nodes, edges):
    adj = collections.defaultdict(list)
    indeg = {n["id"]: 0 for n in nodes}
    assert len(indeg) == len(nodes)
    for e in edges:
        s, t = e["source"], e["target"]
        assert s in indeg and t in indeg
        adj[s].append(t)
        indeg[t] += 1
    q = collections.deque(k for k, v in indeg.items() if v == 0)
    visit = 0
    while q:
        v = q.popleft()
        visit += 1
        for dst in adj[v]:
            indeg[dst] -= 1
            if indeg[dst] == 0:
                q.append(dst)
    return visit == len(indeg)

def main(old_path, new_path, overlay_path):
    with open(old_path, encoding="utf-8") as f:
        old = json.load(f)
    with open(new_path, encoding="utf-8") as f:
        new = json.load(f)
    with open(overlay_path, encoding="utf-8") as f:
        layer = json.load(f)
    assert (len(old["nodes"]),len(old["edges"])) == (457,845)
    assert (len(new["nodes"]),len(new["edges"])) == (497,959)
    actual_old, actual_new = audit(old), audit(new)
    assert [actual_old[v]["all"] for v in TARGETS[:3]] == [6,4,5]
    assert [actual_new[v]["all"] for v in TARGETS[:3]] == [14,5,6]
    assert all(actual_old[v]["region"] == actual_new[v]["region"] for v in TARGETS[:3])
    old_ids = {n["id"] for n in new["nodes"]}
    overlay_ids = {n["id"] for n in layer["new_nodes"]}
    assert len(overlay_ids) == 15 and not overlay_ids.intersection(old_ids)
    assert len(layer["new_edges"]) == 25
    assert all(e["source"] in (old_ids|overlay_ids) and e["target"] in (old_ids|overlay_ids)
               for e in layer["new_edges"])
    assert acyclic(layer["causal_dag"]["new_nodes"],layer["causal_dag"]["new_edges"])
    assert any(e["relation"] == "candidate_focus_choice_overlaps_DT-L" for e in layer["new_edges"])
    out = {
        "status": "PASS_STRUCTURE_ONLY",
        "original": actual_old,
        "expanded": actual_new,
        "overlay_nodes": len(layer["new_nodes"]),
        "overlay_edges": len(layer["new_edges"]),
        "hypothesis_dag_nodes": len(layer["causal_dag"]["new_nodes"]),
        "hypothesis_dag_edges": len(layer["causal_dag"]["new_edges"]),
        "hypothesis_dag_acyclic": True,
        "biological_agency_estimated": False,
        "clinical_prediction": None,
    }
    print(json.dumps(out, ensure_ascii=False, indent=2))

if __name__ == "__main__":
    if len(sys.argv) != 4:
        raise SystemExit("Expected: old.json new.json overlay.json")
    main(*sys.argv[1:])
