#!/usr/bin/env python3
"""Toledo v1.1, Lane A (wrap) -- registrar script scripts/v11_wrapa.py.

For every registry/CANONICAL.json entry with coq.coq_status ==
"mapped_not_wrapped" (210 at launch), write a Toledo-native wrapper file
coq/canonical/<mangled-code>.v that Requires the mirror module(s) named in
that entry's coq.identifiers[] (from coq_map.json evidence) and restates
them as a named Definition per identifier.

Readout-not-truth discipline: the two groups actually present at launch
(confirmed by direct inspection, not assumed) are:

  Group A (178 entries, root EQ-015): coq.identifiers == exactly one row,
    {"file": "evidence/DRL_Forced_Master.v",
     "identifier": "discrete_Lagrange_d_Alembert_forced_master_theorem"}
    -- readout_universe's own discrete Lagrange-d'Alembert forced master
    theorem (the EQ-015 trunk equation's Coq proof), cited as the general
    discrete-mechanics construct each of these domain readings specializes
    from. None of these 178 statements (named physics/social/method/
    world-system/biology equations and definitions) is a literal Coq
    restatement of that one theorem -- the wrapper is written as "reads"
    per the task rule, coq_status "wrapped_related", never "closed".

  Group B (32 entries, root q_formal): coq.identifiers == exactly the same
    29-row set (all theorems of solver-arc's formal/RDL_MetricReadout.v,
    formal/RDL_SpineStability.v, formal/RDL_StarRig.v). Same finding: no
    single q_formal reading's own statement (a named graph-curvature /
    quantum-spine construct) is a literal restatement of any one of these
    29 lemmas -- also written as "reads", coq_status "wrapped_related".

Both source-file groups were rebuilt fresh on this machine before this
script ran (`coqc -q -R . RDL formal/RDL_MetricReadout.v` etc., and
`coqc -q -Q evidence URR evidence/DRL_Forced_Master.v`); all 4 files are
0-axiom/"Closed under the global context" per solver-arc's own
verify_report.json and readout_universe's own verify_report.json (quoted,
not asserted) -- so a wrapper Definition aliasing one of these identifiers
carries the identical "Closed under the global context" assumption as the
identifier itself; this script does not re-run Print Assumptions per
wrapper (210 more coqc invocations for no new information) but instead
cites the already-verified per-source report, exactly as
scripts/n4_coq_split.py's own convention for imported/aliased constructs.

Run: python3 scripts/v11_wrapa.py [--start N] [--limit N] [--dry-run]
Inputs : registry/CANONICAL.json (read immediately before every write --
         another lane may have written it), coq/canonical/_CoqProject
Outputs: coq/canonical/<mangled-code>.v (one per processed entry)
         coq/canonical/_CoqProject (new files appended, topologically safe
         since they only import the two external mirrors, never MRC)
         registry/CANONICAL.json (this entry's coq{} fields only)
         registry/LINEAGE.jsonl (one "revised" event per processed entry)
"""
import argparse
import json
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
CAN_DIR = ROOT / "coq" / "canonical"
RAM_LOW = ROOT / "docs" / "RAM_LOW"
DATE = "2026-09-07"
BY = "toledo-v1.1-wrapa"

SOLVER_ARC_COMMIT = "961151db33b0491cba8fabade69f594238d33f84"
READOUT_UNIVERSE_COMMIT = "960165f13ced6e3f2bfd433928733a35be8283e6"

GROUP_A_FILE = "evidence/DRL_Forced_Master.v"
GROUP_A_IDENT = "discrete_Lagrange_d_Alembert_forced_master_theorem"
GROUP_B_FILES = [
    "formal/RDL_MetricReadout.v",
    "formal/RDL_SpineStability.v",
    "formal/RDL_StarRig.v",
]


def mangle(code: str) -> str:
    return code.replace("/", "__").replace(".", "_").replace("-", "_")


def defang(text: str) -> str:
    """Make arbitrary registry text safe to embed inside a Coq (* ... *) comment."""
    return (text or "").replace("(*", "( *").replace("*)", "* )")


def wrap_comment(text: str, width: int = 74) -> list[str]:
    words = text.split()
    lines, cur = [], ""
    for w in words:
        if cur and len(cur) + 1 + len(w) > width:
            lines.append(cur)
            cur = w
        else:
            cur = (cur + " " + w) if cur else w
    if cur:
        lines.append(cur)
    return lines or [""]


def gen_group_a(code: str, e: dict) -> str:
    base = mangle(code)
    parents = ", ".join(p["code"] for p in e["parents"]) or "(none)"
    stmt = defang(e["statement"]["latest"])
    name = defang(e["name"])
    tier = e["tier"]
    tier_verb = defang(e["tier_in_genesis_verbatim"])
    header = (
        f"(* {code} — wrapped_related — wraps {GROUP_A_FILE}."
        f"{GROUP_A_IDENT} — parents: {parents} *)\n"
        f"(* name: {name} *)\n"
        f"(* tier: {tier} ({tier_verb}) *)\n"
        f"(* statement (Toledo canonical, latest): {stmt} *)\n"
    )
    gap_text = (
        "Gap (readout-not-truth, v1.1 lane wrap): registry/coq_map.json's own "
        "evidence for this reading cites readout_universe's discrete "
        "Lagrange-d'Alembert forced master theorem (evidence/DRL_Forced_Master.v, "
        "the EQ-015 trunk equation's own Coq proof) as the general discrete-"
        "mechanics construct this reading is claimed to specialize from. It is "
        "NOT a literal Coq restatement of this entry's own statement above -- "
        "no closure of the statement as written is claimed here. What is "
        "genuinely proved and imported below is the cited theorem itself: for "
        "any NoDup node list, any symmetric graph weight W, any per-node "
        "heterogeneous M/D/K2/J/eta, at any node k, the central-difference "
        "stationarity of the force-augmented discrete action is algebraically "
        "equivalent (over Q, no approximation) to the full forced master-"
        "equation recurrence at that node -- Closed under the global context, "
        "0 axioms, per readout_universe's own verify_report.json (quoted, not "
        "asserted)."
    )
    gap = "(* " + "\n   ".join(wrap_comment(gap_text)) + " *)\n"
    body = (
        "\nFrom URR Require Import DRL_Forced_Master.\n\n"
        f"Definition {base}_reads := {GROUP_A_IDENT}.\n"
    )
    return header + gap + body


def gen_group_b(code: str, e: dict, idents: list[str]) -> str:
    base = mangle(code)
    parents = ", ".join(p["code"] for p in e["parents"]) or "(none)"
    stmt = defang(e["statement"]["latest"])
    name = defang(e["name"])
    tier = e["tier"]
    tier_verb = defang(e["tier_in_genesis_verbatim"])
    header = (
        f"(* {code} — wrapped_related — wraps "
        f"{', '.join(GROUP_B_FILES)} (29 identifiers) — parents: {parents} *)\n"
        f"(* name: {name} *)\n"
        f"(* tier: {tier} ({tier_verb}) *)\n"
        f"(* statement (Toledo canonical, latest): {stmt} *)\n"
    )
    gap_text = (
        "Gap (readout-not-truth, v1.1 lane wrap): registry/coq_map.json's own "
        "evidence for this q_formal reading cites the full theorem set of "
        "solver-arc's finite-model metric/spine/algebra toolkit (n-D discrete "
        "metric-readout invariance, the quantum/classical spine-discriminant "
        "split, and the star-rig Kraus-completeness relation) as the general "
        "discrete apparatus this reading is claimed to draw on. None of these "
        "29 lemmas is a literal Coq restatement of this entry's own statement "
        "above -- no closure of the statement as written is claimed here. What "
        "is genuinely proved and imported below is each cited lemma itself, "
        "Closed under the global context, 0 axioms, per solver-arc's own "
        "verify_report.json (quoted, not asserted)."
    )
    gap = "(* " + "\n   ".join(wrap_comment(gap_text)) + " *)\n"
    reqs = "\n".join(f"From RDL.formal Require Import {f.split('/')[-1][:-2]}." for f in GROUP_B_FILES)
    defs = "\n".join(f"Definition {base}_reads_{ident} := {ident}." for ident in idents)
    body = f"\n{reqs}\n\n{defs}\n"
    return header + gap + body


def build_one(relpath: Path) -> tuple[bool, str]:
    while RAM_LOW.exists():
        time.sleep(10)
    cmd = [
        "coqc", "-q",
        "-Q", ".", "MRC",
        "-Q", "../master-river", "MR",
        "-R", "../solver-arc", "RDL",
        "-Q", "../readout_universe/evidence", "URR",
        str(relpath.name),
    ]
    out = subprocess.run(cmd, cwd=str(CAN_DIR), capture_output=True, text=True)
    return out.returncode == 0, (out.stdout + out.stderr)


def ensure_coqproject_lines():
    cp = CAN_DIR / "_CoqProject"
    text = cp.read_text(encoding="utf-8")
    lines = text.splitlines()
    needed = ["-R ../solver-arc RDL", "-Q ../readout_universe/evidence URR"]
    changed = False
    insert_at = None
    for i, l in enumerate(lines):
        if l.strip() == "-Q ../master-river MR":
            insert_at = i + 1
            break
    for n in needed:
        if n not in lines:
            if insert_at is None:
                lines.insert(0, n)
            else:
                lines.insert(insert_at, n)
                insert_at += 1
            changed = True
    if changed:
        cp.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return changed


def append_coqproject_file(fname: str):
    cp = CAN_DIR / "_CoqProject"
    text = cp.read_text(encoding="utf-8")
    if f"\n{fname}\n" in ("\n" + text) or text.rstrip("\n").splitlines()[-1] == fname:
        return
    lines = text.splitlines()
    if fname not in lines:
        lines.append(fname)
        cp.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--start", type=int, default=0)
    ap.add_argument("--limit", type=int, default=30)
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    changed_cp = ensure_coqproject_lines()
    if changed_cp:
        print("Added -R/-Q mirror lines to coq/canonical/_CoqProject")

    canon = json.loads((REG / "CANONICAL.json").read_text(encoding="utf-8"))
    entries = canon["canonical"]
    by_code = {e["code"]: e for e in entries}
    pending = [e for e in entries if e["coq"]["coq_status"] == "mapped_not_wrapped"]
    pending.sort(key=lambda e: e["code"])
    chunk = pending[args.start: args.start + args.limit]
    print(f"Total mapped_not_wrapped remaining: {len(pending)}; processing this chunk: {len(chunk)}")

    lineage_events = []
    n_ok = 0
    n_fail = 0
    for e in chunk:
        code = e["code"]
        idents = e["coq"]["identifiers"]
        files = sorted(set(i["file"] for i in idents))
        if files == [GROUP_A_FILE]:
            src = gen_group_a(code, e)
            imported_from = f"readout_universe@{READOUT_UNIVERSE_COMMIT}:{GROUP_A_FILE}"
            redistributed = True
        elif files == sorted(GROUP_B_FILES):
            src = gen_group_b(code, e, [i["identifier"] for i in idents])
            imported_from = (
                f"solver arc (private)@{SOLVER_ARC_COMMIT}:" + "; ".join(GROUP_B_FILES)
            )
            redistributed = False
        else:
            print(f"SKIP {code}: unrecognised identifier-file group {files}")
            n_fail += 1
            continue

        fname = mangle(code) + ".v"
        fpath = CAN_DIR / fname
        if args.dry_run:
            print(f"[dry-run] would write {fpath} ({len(src)} bytes)")
            continue
        fpath.write_text(src, encoding="utf-8")
        append_coqproject_file(fname)

        ok, log = build_one(fpath)
        if not ok:
            print(f"FAIL  {code} -> {fname}")
            print("      " + log.replace("\n", "\n      ")[:2000])
            n_fail += 1
            continue
        n_ok += 1
        print(f"OK    {code} -> {fname}")

        e["coq"]["file"] = f"coq/canonical/{fname}"
        e["coq"]["coq_status"] = "wrapped_related"
        e["coq"]["assumptions"] = "Closed under the global context"
        e["coq"]["imported_from"] = imported_from
        e["coq"]["coq_source_redistributed"] = redistributed
        if len(idents) == 1:
            e["coq"]["identifier"] = f"{mangle(code)}_reads"
        else:
            e["coq"]["identifier"] = ", ".join(
                f"{mangle(code)}_reads_{i['identifier']}" for i in idents
            )
        lineage_events.append({
            "code": code, "date": DATE, "event": "revised",
            "from": "mapped_not_wrapped (coq_map.json evidence only, no Toledo-native file)",
            "to": f"coq/canonical/{fname} (wrapped_related)",
            "reason": (
                "Toledo v1.1 Lane A: wrote a Toledo-native wrapper Requiring the "
                "mirror identifier(s) named in coq.identifiers[] and restating "
                "them as named Definitions; the imported identifier(s) do not "
                "literally state this entry's own statement, so this is a "
                "'reads' wrapper (coq_status wrapped_related), never claimed "
                "closed for the statement itself. Build: coqc -q (see file)."
            ),
            "by": BY,
        })

    if not args.dry_run and (n_ok or n_fail):
        # re-read immediately before writing (another lane may have written meanwhile)
        canon2 = json.loads((REG / "CANONICAL.json").read_text(encoding="utf-8"))
        by_code2 = {e["code"]: e for e in canon2["canonical"]}
        for e in chunk:
            if e["coq"]["coq_status"] == "wrapped_related":
                target = by_code2.get(e["code"])
                if target is not None:
                    target["coq"] = e["coq"]
        tmp = REG / "CANONICAL.json.tmp"
        tmp.write_text(json.dumps(canon2, indent=2, ensure_ascii=False), encoding="utf-8")
        tmp.replace(REG / "CANONICAL.json")

        if lineage_events:
            with open(REG / "LINEAGE.jsonl", "a", encoding="utf-8") as fh:
                for ev in lineage_events:
                    fh.write(json.dumps(ev, ensure_ascii=False) + "\n")

    print(f"Chunk done: {n_ok} ok, {n_fail} failed/skipped of {len(chunk)}")


if __name__ == "__main__":
    main()
