#!/usr/bin/env python3
"""Decode the complete Qi v1.2 semantic graph, causal DAG, and validity ledger.

Requires only a Brotli decoder: pip install brotli
No patient, physiology, or clinical data are generated. No simulation occurs.
v1.2 is additive over v1.1 (v1.1 files are untouched; verify with test_qi_v1_2.py).
"""
from __future__ import annotations
import argparse, base64, hashlib, json
from pathlib import Path

N_PARTS = 9
PART_CHARS = 4000
PARTS = [f"qi_v1_2.brotli_base64.part{i:02d}.txt" for i in range(1, N_PARTS + 1)]
ENCODED_CHARS = 33196
BROTLI_SHA256 = "f8c01dd1c64b8c0edc3991d42daf45c04a8601712859a88b79f03a3c7b936e1a"
RAW_SHA256 = "baa0fc67dbd8ea872b71099c62220cb7ccad603ea0fc66b56fdb77a87da1279f"
EXPECTED = {"semantic_nodes": 550, "semantic_edges": 1218, "causal_nodes": 44, "causal_edges": 93}
WHO_STANDARDS = 361
EXTRA_POINTS = 48

def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()

def decode(source_dir: Path, dest: Path) -> dict:
    try:
        import brotli
    except ImportError as e:
        raise SystemExit("Install the Brotli decoder first: python -m pip install brotli") from e
    encoded = ""
    for i, name in enumerate(PARTS):
        file = source_dir / name
        if not file.is_file():
            raise FileNotFoundError(f"Missing full-graph payload part: {file}")
        piece = file.read_text(encoding="ascii").strip()
        want = PART_CHARS if i < N_PARTS - 1 else ENCODED_CHARS - PART_CHARS * (N_PARTS - 1)
        if len(piece) != want:
            raise ValueError(f"Wrong payload-part length: {name}: {len(piece)} not {want}")
        encoded += piece
    if len(encoded) != ENCODED_CHARS:
        raise ValueError(f"Incomplete encoded graph; expected {ENCODED_CHARS} base64 characters")
    compressed = base64.b64decode(encoded, validate=True)
    if sha256(compressed) != BROTLI_SHA256:
        raise ValueError("Compressed payload integrity failure")
    raw = brotli.decompress(compressed)
    if sha256(raw) != RAW_SHA256:
        raise ValueError("Decompressed payload integrity failure")
    obj = json.loads(raw)
    g = obj["semantic_graph"]
    dag = obj["causal_dag"]
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
    if sum(n["type"] == "ExtraAcupoint" for n in g["nodes"]) != EXTRA_POINTS:
        raise ValueError("Extra-point cardinality is not 48 (EX-HN3 + 47 added)")
    if len(dag["nodes"]) != len({n["id"] for n in dag["nodes"]}):
        raise ValueError("Duplicate causal DAG nodes")
    steps = {n["id"]: int(n["step"]) for n in dag["nodes"]}
    for edge in dag["edges"]:
        if steps[edge["source"]] > steps[edge["target"]]:
            raise ValueError("Backward causal step")
    dest.mkdir(parents=True, exist_ok=True)
    for key, filename in [
        ("semantic_graph", "qi_knowledge_graph_v1_2.json"),
        ("causal_dag", "qi_causal_dag_v1_2.json"),
        ("validation", "qi_validation_v1_2.json"),
    ]:
        (dest / filename).write_text(json.dumps(obj[key], ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"status": "PASS", "counts": EXPECTED, "point_cardinality": WHO_STANDARDS,
                      "extra_points": EXTRA_POINTS, "disagreements": len(g["disagreements"]),
                      "output_dir": str(dest), "raw_sha256": RAW_SHA256}, indent=2))
    return obj

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=Path(__file__).resolve().parent)
    parser.add_argument("--output", type=Path, default=Path.cwd() / "qi_unpacked_v1_2")
    args = parser.parse_args()
    decode(args.source, args.output)
