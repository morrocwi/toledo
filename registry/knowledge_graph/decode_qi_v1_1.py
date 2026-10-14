#!/usr/bin/env python3
"""Decode the complete Qi v1.1 semantic graph, causal DAG, and validity ledger.

Requires only a Brotli decoder: pip install brotli
No patient, physiology, or clinical data are generated. No simulation occurs.
"""
from __future__ import annotations
import argparse, base64, hashlib, json
from pathlib import Path

PARTS = [f"qi_v1_1.brotli_base64.part{i:02d}.txt" for i in range(1, 7)]
BROTLI_SHA256 = "adeff813a36b1525989ae1a26251ce63f37f90c2fbea9b4217753789cd054763"
RAW_SHA256 = "20f3218a85720efb292cd4a36fe63962e86878a452251ba75c41382efe35cd14"
EXPECTED = {"semantic_nodes": 497, "semantic_edges": 959, "causal_nodes": 44, "causal_edges": 93}
WHO_STANDARDS = 361

def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()

def decode(source_dir: Path, dest: Path) -> dict:
    try:
        import brotli
    except ImportError as e:
        raise SystemExit("Install the Brotli decoder first: python -m pip install brotli") from e
    encoded = ""
    for name in PARTS:
        file = source_dir / name
        if not file.is_file():
            raise FileNotFoundError(f"Missing full-graph payload part: {file}")
        piece = file.read_text(encoding="ascii").strip()
        if len(piece) != 3608:
            raise ValueError(f"Wrong payload-part length: {name}: {len(piece)}")
        encoded += piece
    if len(encoded) != 21648:
        raise ValueError("Incomplete encoded graph; expected 21648 base64 characters")
    compressed = base64.b64decode(encoded, validate=True)
    if sha256(compressed) != BROTLI_SHA256:
        raise ValueError("Compressed payload integrity failure")
    raw = brotli.decompress(compressed)
    if sha256(raw) != RAW_SHA256:
        raise ValueError("Decompressed payload integrity failure")
    obj = json.loads(raw)
    g = obj["semantic_graph"]
    dag = obj["causal_dag"]
    v = obj["validation"]
    for name, actual in [
        ("semantic_nodes", len(g["nodes"])),
        ("semantic_edges", len(g["edges"])),
        ("causal_nodes", len(dag["nodes"])),
        ("causal_edges", len(dag["edges"])),
    ]:
        if actual != EXPECTED[name]:
            raise ValueError(f"{name} mismatch: {actual} not {EXPECTED[name]}")
    ids = [n["id"] for n in g["nodes"]]
    if len(ids) != len(set(ids)):
        raise ValueError("Duplicate node IDs")
    active = set(ids)
    for edge in g["edges"]:
        if edge["source"] not in active or edge["target"] not in active:
            raise ValueError(f"Unresolved graph edge: {edge}")
    if sum(n["type"] == "Acupoint" for n in g["nodes"]) != WHO_STANDARDS:
        raise ValueError("WHO standard 361 cardinality changed")
    if sum(n["type"] == "ExtraAcupoint" for n in g["nodes"]) != 1:
        raise ValueError("EX-HN3 extra-point separation failed")
    if len(dag["nodes"]) != len({n["id"] for n in dag["nodes"]}):
        raise ValueError("Duplicate causal DAG nodes")
    for edge in dag["edges"]:
        src = next(n for n in dag["nodes"] if n["id"] == edge["source"])
        dst = next(n for n in dag["nodes"] if n["id"] == edge["target"])
        if int(src["step"]) > int(dst["step"]):
            raise ValueError("Backward causal step")
    dest.mkdir(parents=True, exist_ok=True)
    for key, filename in [
        ("semantic_graph", "qi_knowledge_graph_v1_1.json"),
        ("causal_dag", "qi_causal_dag_v1_1.json"),
        ("validation", "qi_validation_v1_1.json"),
    ]:
        (dest / filename).write_text(json.dumps(obj[key], ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"status":"PASS","counts":EXPECTED,"point_cardinality":WHO_STANDARDS,
                      "output_dir":str(dest),"raw_sha256":RAW_SHA256}, indent=2))
    return obj

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source",type=Path,default=Path(__file__).resolve().parent)
    parser.add_argument("--output",type=Path,default=Path.cwd() / "qi_unpacked_v1_1")
    args = parser.parse_args()
    decode(args.source,args.output)
