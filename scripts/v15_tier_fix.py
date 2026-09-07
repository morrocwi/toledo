#!/usr/bin/env python3
"""Toledo v1.5 fix -- TIER-QUOTE-1 and TIER-COMPOSITE-1.

TIER-QUOTE-1: registry/CANONICAL.json entries EQ-015/B.01.v1, EQ-015/B.02.v1,
EQ-015/B.03.v1 carried a tier_evidence.quote/line that (a) paraphrased text
that does not appear verbatim in the source file at all ("read before
trusting this as more than it is", "for everything BELOW" -- neither
string is in the actual file) and (b) pointed at line 25, one line short of
the real header. Direct re-reading this session of the mirrored source
(local clone of "solver arc (private)" pinned at the same commit
registry/CANONICAL.json's own origin.repo_anchor already cites,
961151db33b0491cba8fabade69f594238d33f84, formal/
InfoHealthCausalRelax_attempt.v) shows the file's own tier tag is a single
SCOPE header block at lines 27-31 covering all three theorems in the file
(setpoint_is_fixed L47, one_step_error L61, n_step_error L83) -- there is
no separate per-theorem tag nearer each theorem. That header does state
"TIER = Th_coqc (Q, axiom-free)" for the discrete-step STRUCTURE (the
tier this repo already carries for these three entries), so tier itself is
kept; only tier_evidence is corrected to quote the real line verbatim.

TIER-COMPOSITE-1: registry/genesis_root.json rows Gateway.InputAdapter and
Gateway.OutputAdapters were tagged tier="finite_diagnostic" (toledo-v1.5-C)
from a composite quote at READOUT_GENESIS_CORE.md:2249 ("[Dr] for the
deeper native-unit master PDE, [Dr] + [finite_diagnostic] for the gateway
calculator itself") that tags the IV.6 gateway calculator as a whole, not
these two specific rows (the 14-unit input adapter and the output-adapter
table) by name. Reverted to their pre-v1.5 state (git HEAD:registry/
genesis_root.json, commit d1057fb): no "tier"/"tier_evidence" key at all.

Idempotent: re-reads each file immediately before its own write; each
touch checks the current on-disk value first and is a no-op if already
fixed/reverted by a prior run.

Run: python3 scripts/v15_tier_fix.py [--dry-run]
"""
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
CAN = REG / "CANONICAL.json"
GENESIS = REG / "genesis_root.json"
LINEAGE = REG / "LINEAGE.jsonl"
DATE = "2026-09-07"
BY = "toledo-v1.5-fix"

SOLVER_ARC_COMMIT = "961151db33b0491cba8fabade69f594238d33f84"

# Verbatim source lines 27-31 (confirmed this session by direct reading of
# the local pinned-commit clone of "solver arc (private)"
# formal/InfoHealthCausalRelax_attempt.v -- the same commit this entry's
# own origin.repo_anchor already cites).
REAL_QUOTE = (
    "\"SCOPE -- TIER = Th_coqc (Q, axiom-free). 'causal safety relaxes to a "
    "bounded setpoint' is the STRUCTURE; the reading of C as clinical "
    "'causal safety' and of u as a safety input is Dr, not validated. The "
    "continuum ODE and its exp(-beta t) solution are NOT used (exp is a "
    "non-readout); only the discrete rational step. No Reals; no axiom.\" "
    "-- formal/InfoHealthCausalRelax_attempt.v, lines 27-31 (a single "
    "SCOPE header covering all three theorems in the file -- "
    "setpoint_is_fixed L47, one_step_error L61, n_step_error L83 -- there "
    "is no separate per-theorem tag nearer any individual theorem)."
)
REAL_LINE = "formal/InfoHealthCausalRelax_attempt.v:27-31"

TIER_QUOTE_TARGETS = {
    "EQ-015/B.01.v1": 47,
    "EQ-015/B.02.v1": 61,
    "EQ-015/B.03.v1": 83,
}

TIER_COMPOSITE_TARGETS = ["Gateway.InputAdapter", "Gateway.OutputAdapters"]


def load(path):
    return json.loads(path.read_text(encoding="utf-8"))


def atomic_write(path, doc):
    tmp = path.with_suffix(path.suffix + ".tmp")
    tmp.write_text(json.dumps(doc, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    tmp.replace(path)


def append_lineage(events):
    if not events:
        return
    with open(LINEAGE, "a", encoding="utf-8") as fh:
        for ev in events:
            fh.write(json.dumps(ev, ensure_ascii=False) + "\n")


def fix_tier_quote(dry_run):
    doc = load(CAN)
    events = []
    touched = 0
    for e in doc["canonical"]:
        code = e["code"]
        if code not in TIER_QUOTE_TARGETS:
            continue
        theorem_line = TIER_QUOTE_TARGETS[code]
        old_ev = e.get("tier_evidence")
        new_quote = REAL_QUOTE
        new_line = REAL_LINE
        if old_ev is not None and old_ev.get("quote") == new_quote and old_ev.get("line") == new_line:
            print(f"SKIP {code}: tier_evidence already fixed")
            continue
        old_ev_json = json.dumps(old_ev, ensure_ascii=False)
        e["tier_evidence"] = {
            "quote": new_quote,
            "source": f'"solver arc (private)"@{SOLVER_ARC_COMMIT}, formal/InfoHealthCausalRelax_attempt.v',
            "line": new_line,
        }
        touched += 1
        events.append({
            "code": code, "date": DATE, "event": "revised",
            "from": f"tier_evidence={old_ev_json}",
            "to": f"tier_evidence={json.dumps(e['tier_evidence'], ensure_ascii=False)}",
            "reason": (
                "Toledo v1.5 fix (TIER-QUOTE-1): the prior tier_evidence quoted "
                "text not present verbatim in the source file ('read before "
                "trusting this as more than it is', 'for everything BELOW') and "
                "cited line 25, one line short of the real header. Re-read this "
                'session directly from the local pinned-commit clone of "solver '
                'arc (private)"@' + SOLVER_ARC_COMMIT + ' formal/'
                "InfoHealthCausalRelax_attempt.v: the file's only tier tag is "
                "the single SCOPE header at lines 27-31 (\"TIER = Th_coqc (Q, "
                "axiom-free)\"), covering all three theorems in the file "
                f"including this entry's own theorem at line {theorem_line}; "
                "no separate per-theorem tag exists nearer the theorem itself. "
                "tier is kept at Th_coqc (the header's own tag, not raised or "
                "invented); only the quote/line evidence is corrected to the "
                "verbatim source text."
            ),
            "by": BY,
        })
        print(f"FIX  {code}: tier_evidence corrected (line 25 -> 27-31, quote verbatim)")
    if touched and not dry_run:
        atomic_write(CAN, doc)
        append_lineage(events)
    return touched


def fix_tier_composite(dry_run):
    doc = load(GENESIS)
    old_pre_v15 = load(GENESIS)  # re-read is the point; the actual pre-v1.5 reference is git HEAD, not this file
    events = []
    touched = 0
    for r in doc["root_equations"]:
        code = r.get("code")
        if code not in TIER_COMPOSITE_TARGETS:
            continue
        if "tier" not in r and "tier_evidence" not in r:
            print(f"SKIP {code}: already reverted (untagged)")
            continue
        old_tier = r.get("tier")
        old_ev = r.get("tier_evidence")
        removed = {}
        if "tier" in r:
            removed["tier"] = r.pop("tier")
        if "tier_evidence" in r:
            removed["tier_evidence"] = r.pop("tier_evidence")
        touched += 1
        events.append({
            "code": code, "date": DATE, "event": "revised",
            "from": f"tier={old_tier!r}, tier_evidence={json.dumps(old_ev, ensure_ascii=False)}",
            "to": "tier=<absent>, tier_evidence=<absent> (reverted to pre-v1.5 state)",
            "reason": (
                "Toledo v1.5 fix (TIER-COMPOSITE-1): toledo-v1.5-C (scripts/"
                "v15_C.py) tagged this row tier=finite_diagnostic from "
                "READOUT_GENESIS_CORE.md:2249's composite quote (\"[Dr] for "
                "the deeper native-unit master PDE, [Dr] + [finite_diagnostic] "
                "for the gateway calculator itself\") -- that quote tags the "
                "IV.6 gateway calculator as a whole, not this specific row "
                "(the 14-unit input adapter / output-adapter table) by name. "
                "Re-checked this session directly against readout_genesis@"
                "082dde893b70c7500c13d463239909c99cf17f0a "
                "READOUT_GENESIS_CORE.md lines 2245-2251: confirmed the "
                "quote is a whole-calculator characterisation, not a per-row "
                "tag. Reverted to the pre-v1.5 state (git HEAD:registry/"
                "genesis_root.json, commit d1057fb): no tier/tier_evidence "
                "key on this row."
            ),
            "by": BY,
        })
        print(f"REVERT {code}: tier/tier_evidence removed (pre-v1.5 untagged state restored)")
    if touched and not dry_run:
        atomic_write(GENESIS, doc)
        append_lineage(events)
    return touched


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()
    n1 = fix_tier_quote(args.dry_run)
    n2 = fix_tier_composite(args.dry_run)
    print(f"TIER-QUOTE-1: {n1} entries touched. TIER-COMPOSITE-1: {n2} rows touched. "
          f"{'(dry-run, no write)' if args.dry_run else ''}")


if __name__ == "__main__":
    main()
