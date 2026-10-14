#!/usr/bin/env python3
"""Source-KG audit + edge-cycle linear algebra, NOT a human or Qi assay.
Usage: python test_agency_cycle_v0_3.py old_kg.json new_kg.json
Install: pip install networkx sympy
"""
import json
import sys
import networkx as nx
import sympy as sp

def inspect(path):
    with open(path, encoding="utf-8") as f: data=json.load(f)
    g=nx.Graph()
    g.add_nodes_from(n["id"] for n in data["nodes"])
    g.add_edges_from((e["source"],e["target"]) for e in data["edges"])
    return data,g,nx.closeness_centrality(g),nx.betweenness_centrality(g)

def test(old_path,new_path):
    old,g0,c0,b0=inspect(old_path)
    new,g1,c1,b1=inspect(new_path)
    assert (g0.number_of_nodes(),len(old["edges"]),g1.number_of_nodes(),len(new["edges"]))==(457,845,497,959)
    assert g0.number_of_edges()==845 and g1.number_of_edges()==955
    assert g0.number_of_edges()-g0.number_of_nodes()+nx.number_connected_components(g0)==389
    assert g1.number_of_edges()-g1.number_of_nodes()+nx.number_connected_components(g1)==459
    assert [g0.degree(v) for v in ["DT-L","DT-M","DT-U"]]==[6,4,5]
    assert c0["DT-U"]>c0["DT-L"] and b0["DT-U"]>b0["DT-L"]
    assert c1["GV20"]>c1["DT-L"] and b1["GV20"]>b1["DT-L"]
    kinds={"traditionally_practiced_posterior_ascent",
           "traditionally_practiced_anterior_descent","practice_loop_closure_symbolic"}
    orbit=nx.DiGraph((e["source"],e["target"]) for e in new["edges"] if e["relation"] in kinds)
    cycles=list(nx.simple_cycles(orbit))
    assert orbit.number_of_nodes()==10 and orbit.number_of_edges()==10
    assert len(cycles)==1 and len(cycles[0])==10
    B=sp.Matrix([[-1,1,0,0],[0,-1,1,0],[0,0,-1,1],[1,0,0,-1]])
    c=sp.ones(4,1)
    q=sp.Matrix(sp.symbols("q0:4"))
    W=sp.diag(*sp.symbols("w0:4", positive=True))
    assert B.rank()==3 and B.T*c==sp.zeros(4,1)
    assert sp.simplify((c.T*W.inv()*(-W*B*q))[0])==0
    assert B.T*(-W*B*q+3*c)==B.T*(-W*B*q)
    print(json.dumps({"status":"PASS_STRUCTURE_ONLY",
        "semantic_cycle_rank":[389,459],"practice_cycle_edges":10,
        "node_readout_cannot_identify_unmeasured_loop_flux":True,
        "human_Qi_or_Agency_measurements":None},indent=2))

if __name__=="__main__":
    if len(sys.argv)!=3:raise SystemExit("Supply original and expanded decoded KG JSONs")
    test(*sys.argv[1:])
