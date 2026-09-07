#!/usr/bin/env python3
"""Toledo v1.5 fix, SCHEMA-CONSISTENCY-1 -- registrar+builder for the 23
file-less coq.coq_status in {"definition","open_prop"} "Recursive
Epistemic Tunnel" entries (RET-N01..N23; roots EQ-015/EQ-002/weld/A.5/A.8)
whose coq.coq_status was already assigned at merge time (toledo-v1.5-
tunnel, from the source's own tier tag: Definition -> definition,
Dr -> open_prop) but coq.file was still null.

Per-code Coq bodies are hand-authored in scripts/v15_tunnel_bodies.py
(loaded here, not duplicated) directly from each entry's own
statement.latest (quoted in this script's generated file header). Every
symbol the statement itself does not already fix is introduced as a
`Parameter` local to that entry's own Section -- never asserting what it
computes, only enough structure to type-check the equation as literally
stated.

Idempotent per SCHEMA.md's convention: re-reads registry/CANONICAL.json
immediately before every atomic write, touches only coq.file/coq.identifier
of entries still exactly at {coq_status in (definition, open_prop),
file: null} for its own 23 target codes -- never coq_status/tier.

RAM discipline: one coqc invocation at a time, docs/RAM_LOW checked (and
waited on) before every one; no -j anywhere.

Usage:
  python3 scripts/v15_tunnel.py --report
  python3 scripts/v15_tunnel.py --apply [--start N] [--limit N]
"""
import argparse
import json
import re
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
CAN = REG / "CANONICAL.json"
LINEAGE = REG / "LINEAGE.jsonl"
CAN_DIR = ROOT / "coq" / "canonical"
RAM_LOW = ROOT / "docs" / "RAM_LOW"
DATE = "2026-09-07"
BY = "toledo-v1.5-fix"

sys.path.insert(0, str(Path(__file__).resolve().parent))
from v15_tunnel_bodies import BODIES  # noqa: E402

FLAGS = [
    "-Q", ".", "MRC",
    "-Q", "../master-river", "MR",
    "-R", "../solver-arc", "RDL",
    "-Q", "../readout_universe/evidence", "URR",
    "-Q", "../readout_genesis/formal", "ReadoutGenesis.Formal",
]

IDENT_RE = re.compile(
    r"^\s*(?:Definition|Inductive|Record)\s+([A-Za-z0-9_']+)", re.MULTILINE)


def mangle(code: str) -> str:
    return code.replace("/", "__").replace(".", "_").replace("-", "_")


def load():
    return json.loads(CAN.read_text(encoding="utf-8"))


def atomic_write(doc):
    tmp = CAN.with_suffix(".json.tmp")
    tmp.write_text(json.dumps(doc, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    tmp.replace(CAN)


def append_lineage(events):
    if not events:
        return
    with open(LINEAGE, "a", encoding="utf-8") as fh:
        for ev in events:
            fh.write(json.dumps(ev, ensure_ascii=False) + "\n")


PRELUDE = (
    "Require Import QArith.\n"
    "Require Import Qminmax.\n"
    "Require Import Qabs.\n"
    "Require Import List.\n"
    "Import ListNotations.\n"
)


def build_file_text(code: str, e: dict) -> str:
    expected_status, suffix, body_tpl = BODIES[code]
    assert e["coq"]["coq_status"] == expected_status, (code, e["coq"]["coq_status"], expected_status)
    mangled = mangle(code)
    name = f"{mangled}_{suffix}"
    body = body_tpl.replace("NAME", name)
    body = body.replace("Section SEC.", f"Section {mangled}_sec.").replace("End SEC.", f"End {mangled}_sec.")
    stmt = e["statement"]["latest"].replace("(*", "( *").replace("*)", "* )")
    label = (e["name"] or "").replace("(*", "( *").replace("*)", "* )")
    header = (
        f"(* {code} -- not_yet_formalised -> {expected_status} -- {label} *)\n"
        f"(* source: The Recursive Epistemic Tunnel v2.1, DOI 10.5281/zenodo.22639311 *)\n"
        f"(* source statement (registry/CANONICAL.json statement.latest, LaTeX): *)\n"
        + "".join(f"(* {ln} *)\n" for ln in stmt.splitlines())
        + f"(* Toledo v1.5 fix (SCHEMA-CONSISTENCY-1): finite-model {expected_status} --\n"
        f"   every symbol not already fixed by the statement above is a local\n"
        f"   Section Parameter (its type chosen only so the equation\n"
        f"   type-checks; nothing about what it computes is asserted).\n"
        f"   {'Unproved by design (Dr source label).' if expected_status == 'open_prop' else 'A defining equation/notion, not a theorem -- no proof obligation.'} *)\n"
    )
    return header + "\n" + PRELUDE + "\n" + body.strip() + "\n"


def run_coqc(relpath: str) -> tuple[str, int]:
    while RAM_LOW.exists():
        print(f"RAM_LOW present, waiting 10s before {relpath}", file=sys.stderr)
        time.sleep(10)
    cmd = ["coqc", "-q"] + FLAGS + [relpath]
    out = subprocess.run(cmd, cwd=str(CAN_DIR), capture_output=True, text=True)
    return out.stdout + out.stderr, out.returncode


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true")
    ap.add_argument("--report", action="store_true")
    ap.add_argument("--start", type=int, default=0)
    ap.add_argument("--limit", type=int, default=10**9)
    args = ap.parse_args()

    doc = load()
    by_code = {x["code"]: x for x in doc["canonical"]}
    all_codes = sorted(BODIES.keys())
    missing = [c for c in all_codes if c not in by_code]
    if missing:
        print(f"ERROR: codes not found in CANONICAL.json: {missing}", file=sys.stderr)
        sys.exit(2)
    targets = [c for c in all_codes if by_code[c]["coq"]["file"] is None]
    chunk = targets[args.start: args.start + args.limit]
    print(f"total file-less target={len(targets)} (of {len(all_codes)} defined bodies); "
          f"this run covers {len(chunk)} (start={args.start}, limit={args.limit})")

    if not args.report and not args.apply:
        args.report = True
    if args.report and not args.apply:
        for c in chunk:
            print(" would process:", c)
        return

    results = []
    fail = 0
    for code in chunk:
        doc_now = load()
        e = next((x for x in doc_now["canonical"] if x["code"] == code), None)
        if e is None or e["coq"]["file"] is not None:
            print(f"SKIP {code}: already has a file (other lane got there first)")
            continue
        mangled = mangle(code)
        relpath = f"{mangled}.v"
        text = build_file_text(code, e)
        (CAN_DIR / relpath).write_text(text, encoding="utf-8")
        out, rc = run_coqc(relpath)
        if rc != 0:
            fail += 1
            print(f"FAIL {code} ({relpath}):\n{out[-2500:]}")
            continue
        ident = ", ".join(dict.fromkeys(IDENT_RE.findall(text)))
        results.append((code, relpath, ident))
        print(f"OK   {code} -> {e['coq']['coq_status']} :: {ident}")

    if fail:
        print(f"{fail} failures -- stopping before registry write.", file=sys.stderr)
        sys.exit(1)
    if not results:
        print("nothing to write.")
        return

    doc_now = load()
    by_code2 = {x["code"]: x for x in doc_now["canonical"]}
    events = []
    for code, relpath, ident in results:
        e = by_code2.get(code)
        if e is None or e["coq"]["file"] is not None:
            print(f"SKIP-AT-WRITE {code}: moved on before this chunk's write")
            continue
        e["coq"]["file"] = f"coq/canonical/{relpath}"
        e["coq"]["identifier"] = ident
        events.append({
            "code": code, "date": DATE, "event": "revised",
            "from": "coq.file=null",
            "to": f"coq.file=coq/canonical/{relpath}",
            "reason": (
                f"Toledo v1.5 fix (SCHEMA-CONSISTENCY-1): wrote coq/canonical/{relpath} "
                f"as a finite-model {e['coq']['coq_status']} (identifiers: {ident}), "
                f"coqc-verified this run."
            ),
            "by": BY,
        })
    atomic_write(doc_now)
    append_lineage(events)
    print(f"registry updated: {len(events)} entries.")


if __name__ == "__main__":
    main()
