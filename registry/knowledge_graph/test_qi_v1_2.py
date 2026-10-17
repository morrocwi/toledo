"""Qi knowledge graph v1.2: additive-over-v1.1 integrity tests (no clinical content, no simulation)."""
from __future__ import annotations
import importlib.util, json, os, re
from collections import Counter, defaultdict
from pathlib import Path
import pytest

if os.environ.get("CI"):
    import brotli  # noqa: F401  (CI must have it: CI must install it; fail, never skip)
else:
    pytest.importorskip("brotli", reason="brotli not installed (pip install brotli); install it for CI")

KG = Path(__file__).resolve().parent
MANIFEST = KG.parent / "proposals" / "qi_dantian_chakra_full_graph_manifest_v1_2.json"
V11_RAW_SHA = "20f3218a85720efb292cd4a36fe63962e86878a452251ba75c41382efe35cd14"


def _load(name):
    spec = importlib.util.spec_from_file_location(name, KG / f"{name}.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


@pytest.fixture(scope="module")
def v11(tmp_path_factory):
    mod = _load("decode_qi_v1_1")
    assert mod.RAW_SHA256 == V11_RAW_SHA
    return mod.decode(KG, tmp_path_factory.mktemp("v11"))


@pytest.fixture(scope="module")
def v12(tmp_path_factory):
    return _load("decode_qi_v1_2").decode(KG, tmp_path_factory.mktemp("v12"))


@pytest.fixture(scope="module")
def manifest():
    return json.loads((MANIFEST).read_text(encoding="utf-8"))


def test_v11_unchanged(v11):
    g = v11["semantic_graph"]
    assert (len(g["nodes"]), len(g["edges"])) == (497, 959)
    assert (len(v11["causal_dag"]["nodes"]), len(v11["causal_dag"]["edges"])) == (44, 93)


def test_counts_and_hashes_match_manifest(v12, manifest):
    g = v12["semantic_graph"]
    c = manifest["counts"]
    assert (len(g["nodes"]), len(g["edges"])) == (c["semantic_nodes"], c["semantic_edges"])
    assert g["version"].startswith("1.2")
    assert c["new_nodes"] == len(g["nodes"]) - 497 and c["new_edges"] == len(g["edges"]) - 959
    assert manifest["payload"]["raw_sha256"] == _load("decode_qi_v1_2").RAW_SHA256
    assert g["changelog"]["new_nodes_by_type"] == c["new_nodes_by_type"]
    assert Counter(e["relation"] for e in g["edges"][959:]) == Counter(c["new_edges_by_relation"])


def test_v11_is_exact_prefix_and_ids_superset(v11, v12):
    a, b = v11["semantic_graph"], v12["semantic_graph"]
    assert b["nodes"][: len(a["nodes"])] == a["nodes"]
    assert b["edges"][: len(a["edges"])] == a["edges"]
    assert {n["id"] for n in a["nodes"]} <= {n["id"] for n in b["nodes"]}
    assert v12["causal_dag"] == v11["causal_dag"]
    for k in ("simulation", "biophysical_validation", "clinical", "cosmological_symbol_policy", "graph_layer_policy", "base"):
        assert b[k] == a[k]
    assert v12["validation"]["gates"] == v11["validation"]["gates"]
    assert v12["validation"]["status"] == v11["validation"]["status"]


def test_no_collision_and_endpoints(v12):
    g = v12["semantic_graph"]
    ids = [n["id"] for n in g["nodes"]]
    assert len(ids) == len(set(ids))
    s = set(ids)
    keys = [(e["source"], e["target"], e["relation"]) for e in g["edges"]]
    assert len(keys) == len(set(keys))
    assert all(e["source"] in s and e["target"] in s for e in g["edges"])


def test_new_items_have_provenance(v12):
    g = v12["semantic_graph"]
    for e in g["edges"][959:]:
        assert e["evidence_class"] and e["source_ref"], e
        assert isinstance(e["contested"], bool) and e["verification"]
        if e["contested"]:
            assert e["evidence_class"].endswith("CONTESTED") or e["evidence_class"].startswith("CLASSICAL_TCM_WEAK") or e["relation"] == "luo_connecting"
    for n in g["nodes"][497:]:
        assert n["evidence_class"]
    dids = {d["id"] for d in g["disagreements"]}
    for e in g["edges"][959:]:
        if e.get("disagreement_id"):
            assert e["disagreement_id"] in dids
    for d in g["disagreements"]:
        assert d["claims"] and all(c["source_ref"] for c in d["claims"])


def test_extra_points(v12):
    nodes = {n["id"]: n for n in v12["semantic_graph"]["nodes"]}
    extras = [n for n in nodes.values() if n["type"] == "ExtraAcupoint"]
    assert len(extras) == 48
    pat = {"HN": 15, "CA": 1, "B": 9, "UE": 11, "LE": 12}
    for r, n in pat.items():
        assert {f"EX-{r}{i}" for i in range(1, n + 1)} <= set(nodes)
    assert nodes["EX-HN3"]["hanzi"] == "印堂" and "region" not in nodes["EX-HN3"]  # v1.1 node untouched
    assert sum(n["type"] == "Acupoint" for n in nodes.values()) == 361


def test_flows_to_single_12_cycle(v12):
    fl = [e for e in v12["semantic_graph"]["edges"] if e["relation"] == "flows_to"]
    assert len(fl) == 12
    nxt = {e["source"]: e["target"] for e in fl}
    assert len(nxt) == 12 and len(set(nxt.values())) == 12
    order = ["LU", "LI", "ST", "SP", "HT", "SI", "BL", "KI", "PC", "TE", "GB", "LR"]
    cur, seen = "CHN:LU", []
    for _ in range(12):
        seen.append(cur)
        cur = nxt[cur]
    assert cur == "CHN:LU" and [s[4:] for s in seen] == order


def test_luo_count_matches_readme(v12):
    g = v12["semantic_graph"]
    nodes = {n["id"]: n for n in g["nodes"]}
    luo = [e for e in g["edges"] if e["relation"] == "luo_connecting" and nodes[e["source"]]["type"] == "Acupoint"]
    assert {e["source"] for e in luo} == set("LU7 LI6 ST40 SP4 HT5 SI7 BL58 KI4 PC6 TE5 GB37 LR5 CV15 GV1 SP21".split())
    readme = (KG / "README_QI_V1_2.md").read_text(encoding="utf-8")
    assert "15 classical luo" in readme and len(luo) == 15
    xl = [e for e in g["edges"] if e["source"] == "TCM:XULI"]
    assert xl and all(e["evidence_class"] not in ("CLASSICAL_TCM",) for e in xl)


def test_vessel_and_confluent(v12):
    g = v12["semantic_graph"]
    conf = {(e["source"], e["target"]) for e in g["edges"] if e["relation"] == "confluent_point_of"}
    assert conf == {("SP4", "CHN:XCHONG"), ("PC6", "CHN:XYINWEI"), ("SI3", "CHN:GV"), ("BL62", "CHN:XYANGQIAO"),
                    ("TE5", "CHN:XYANGWEI"), ("GB41", "CHN:XDAI"), ("LU7", "CHN:CV"), ("KI6", "CHN:XYINQIAO")}
    tg = {e["target"] for e in g["edges"] if e["relation"] == "member_of_extraordinary_vessel"}
    assert tg == {"CHN:X" + k for k in ("CHONG", "DAI", "YINQIAO", "YANGQIAO", "YINWEI", "YANGWEI")}
    assert any(e["relation"] == "crossing_point_of" for e in g["edges"])


def test_causal_dag_acyclic(v12):
    dag = v12["causal_dag"]
    adj = defaultdict(list)
    indeg = {n["id"]: 0 for n in dag["nodes"]}
    for e in dag["edges"]:
        adj[e["source"]].append(e["target"])
        indeg[e["target"]] += 1
    q = [k for k, v in indeg.items() if v == 0]
    n = 0
    while q:
        x = q.pop()
        n += 1
        for y in adj[x]:
            indeg[y] -= 1
            if indeg[y] == 0:
                q.append(y)
    assert n == len(dag["nodes"])


def test_payload_has_no_personal_data(v12):
    blob = json.dumps(v12, ensure_ascii=False)
    assert not re.search(r"[\w.+-]+@[\w-]+\.[\w.]+", blob)
    assert not re.search(r"(?<!\d)(?:\+?\d{1,3}[ -])?\(?\d{2,4}\)?[ -]\d{3,4}[ -]\d{3,4}(?!\d)", blob)
