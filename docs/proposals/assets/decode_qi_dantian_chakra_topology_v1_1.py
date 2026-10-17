#!/usr/bin/env python3
"""Decode user Qi–Dantian–Chakra typed graph topology; research semantics only.

All IDs, types, typed links, and step-unrolled causal graph links are in the
LZMA base64 file. Full rich node and edge metadata is preserved separately
in the complete research ZIP; do not infer anatomy or clinical effects.
"""
from __future__ import annotations
from collections import Counter, deque
from pathlib import Path
import base64
import json
import lzma
import sys

HERE = Path(__file__).resolve().parent
PAYLOAD = HERE / "qi_dantian_chakra_full_topology_v1_1.lzma.b64"

def verify(data: dict) -> dict:
    nodes, edges, dag = data["n"], data["e"], data["c"]
    assert len(nodes) == 479 and len(edges) == 894, "Semantic count mismatch"
    assert len(dag["n"]) == 48 and len(dag["e"]) == 109, "DAG count mismatch"
    ids = [n[0] for n in nodes]
    assert len(ids) == len(set(ids)), "Duplicate node ID"
    id_set = set(ids)
    assert all(s in id_set and t in id_set for s,t,_ in edges), "Dangling semantic edge"
    types = Counter(n[1] for n in nodes)
    assert types["Acupoint"] == 361 and types["ExtraAcupoint"] == 1
    assert types["Dantian"] == 3 and types["Chakra"] == 7
    assert "EX-HN3" in id_set and all(x in id_set for x in ("GV20","KI1","PC8"))
    relations = Counter(e[2] for e in edges)
    assert relations["belongs_to_meridian"] == 361
    assert relations["next_in_registry_order"] == 347
    assert relations["traditional_practice_orbit_step"] == 10
    assert relations["traditional_axial_practice_order"] == 6
    assert relations["symbolic_receives_from_earth"] == 1
    assert relations["symbolic_sends_outward"] == 1
    dag_ids = [x["id"] for x in dag["n"]]
    assert len(dag_ids) == len(set(dag_ids))
    indegree = {n: 0 for n in dag_ids}
    following = {n: [] for n in dag_ids}
    for e in dag["e"]:
        s,t = e["source"],e["target"]
        assert s in indegree and t in indegree
        following[s].append(t)
        indegree[t] += 1
    ready = deque(n for n,v in indegree.items() if v == 0)
    consumed = 0
    while ready:
        u = ready.popleft()
        consumed += 1
        for v in following[u]:
            indegree[v] -= 1
            if indegree[v] == 0:
                ready.append(v)
    assert consumed == len(dag_ids), "Hypothesis causal DAG contains a cycle"
    return {"semantic_nodes":len(nodes),"semantic_edges":len(edges),
            "causal_nodes":len(dag["n"]),"causal_edges":len(dag["e"]),
            "standard_points":361,"extra_points":1,
            "semantic_cycle_expected":True,"causal_dag_acyclic":True,
            "physically_verified_qi":False,"clinical_predictions":False}

def main():
    data = json.loads(lzma.decompress(base64.b64decode(PAYLOAD.read_text())))
    results = verify(data)
    print(json.dumps(results, ensure_ascii=False, indent=2))
    if "--export-json" in sys.argv:
        dst = HERE / "qi_dantian_chakra_topology_decoded.json"
        dst.write_text(json.dumps(data,ensure_ascii=False,indent=2)+"\n")
        print("Exported:", dst)

if __name__ == "__main__":
    main()
