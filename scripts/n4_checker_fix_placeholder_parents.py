#!/usr/bin/env python3
"""Checker (I2) mechanical fix: 5 parents[] entries in registry/CANONICAL.json still
carry the unresolved "proposed_after" placeholder code (literal "EQ-015/M.??.v1" /
"EQ-009/E.??.v1") instead of the actual final code the referenced prior-chain-item
resolved to during N4 registrar assignment. This is a mechanical resolution against
registry/readings_universe_solver.json's own `proposed_after` text (which names the
prior chain item unambiguously) cross-referenced with the entries' own final `code`
in CANONICAL.json -- no new statement, no new relation invented, no code renumbered.

Affected (found by grep for literal ".??" in registry/CANONICAL.json, N=5):
  RUS-0003 (EQ-015/M.14.v1) parent EQ-015/M.??.v1 -> EQ-015/M.13.v1 (RUS-0002,
    "propose immediately after the DRL.Lagrangian_Ln reading" = RUS-0002 itself)
  RUS-0004 (EQ-015/M.15.v1) parent EQ-015/M.??.v1 -> EQ-015/M.14.v1 (RUS-0003,
    "propose immediately after DRL.Hamiltonian_H" = RUS-0003 itself)
  RUS-0006 (EQ-009/E.02.v1) parent EQ-009/E.??.v1 -> EQ-009/E.01.v1 (RUS-0005,
    "propose immediately after APPEND_ONLY_RECORD.branch_split" = RUS-0005 itself)
  RUS-0007 (EQ-009/E.03.v1) parent EQ-009/E.??.v1 -> EQ-009/E.02.v1 (RUS-0006,
    "propose immediately after APPEND_ONLY_RECORD.T1_conservation" = RUS-0006 itself)
  RUS-0007 (EQ-009/E.03.v1) parent EQ-015/M.??.v1 -> EQ-015/M.13.v1 (RUS-0002,
    evidence text: "explicit cross-reference to the DRL Lagrangian's D and M
    coefficients" -- D and M are RUS-0002's own Lagrangian coefficients, per
    RUS-0002's statement "M d2Phi + D dPhi + K.L_R Phi + grad V(Phi) = J - eta")

Idempotent: rerunning after the fix is applied finds 0 placeholders and exits 0
with no write.

Appends one LINEAGE.jsonl 'revised' event per corrected parent (reason quotes the
evidence above), matching the LINEAGE discipline (no silent edits).
"""
import json, re
from pathlib import Path
from datetime import date

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
DATE = "2026-09-06"
BY = "toledo-n4-merge"

FIXES = {
    ("RUS-0003", "EQ-015/M.??.v1"): "EQ-015/M.13.v1",
    ("RUS-0004", "EQ-015/M.??.v1"): "EQ-015/M.14.v1",
    ("RUS-0006", "EQ-009/E.??.v1"): "EQ-009/E.01.v1",
    ("RUS-0007", "EQ-009/E.??.v1"): "EQ-009/E.02.v1",
    ("RUS-0007", "EQ-015/M.??.v1"): "EQ-015/M.13.v1",
}

REASON = {
    "EQ-015/M.13.v1": "N3/N4 registrar left the readings_universe_solver.json "
        "'proposed_after' placeholder code unresolved; resolved to the final code "
        "the named prior chain item (RUS-0002, DRL Lagrangian) actually received "
        "during N4 registration -- quoting readings_universe_solver.json's own "
        "proposed_after text for this id.",
    "EQ-015/M.14.v1": "N3/N4 registrar left the readings_universe_solver.json "
        "'proposed_after' placeholder code unresolved; resolved to the final code "
        "the named prior chain item (RUS-0003, DRL Hamiltonian conservation check) "
        "actually received during N4 registration.",
    "EQ-009/E.01.v1": "N3/N4 registrar left the readings_universe_solver.json "
        "'proposed_after' placeholder code unresolved; resolved to the final code "
        "the named prior chain item (RUS-0005, APPEND_ONLY_RECORD.branch_split) "
        "actually received during N4 registration.",
    "EQ-009/E.02.v1": "N3/N4 registrar left the readings_universe_solver.json "
        "'proposed_after' placeholder code unresolved; resolved to the final code "
        "the named prior chain item (RUS-0006, APPEND_ONLY_RECORD.T1_conservation) "
        "actually received during N4 registration.",
}


def main():
    canon_path = REG / "CANONICAL.json"
    canon = json.load(open(canon_path, encoding="utf-8"))
    by_id = {e["id"]: e for e in canon["canonical"]}

    applied = []
    for (eid, placeholder), target in FIXES.items():
        e = by_id.get(eid)
        if e is None:
            raise SystemExit(f"entry {eid} not found -- refusing to guess")
        changed = False
        for p in e.get("parents") or []:
            if p["code"] == placeholder:
                p["code"] = target
                changed = True
        if changed:
            applied.append((eid, placeholder, target))

    if not applied:
        print("[idempotent] no literal '??' placeholder parent codes remain -- nothing to do")
        return

    json.dump(canon, open(canon_path, "w", encoding="utf-8"), indent=2, ensure_ascii=False)
    print(f"[fixed] {len(applied)} placeholder parent codes resolved:")
    for eid, ph, target in applied:
        print(f"  {eid}: {ph} -> {target}")

    lineage_path = REG / "LINEAGE.jsonl"
    with open(lineage_path, "a", encoding="utf-8") as f:
        for eid, ph, target in applied:
            e = by_id[eid]
            ev = {
                "code": e["code"],
                "date": DATE,
                "event": "revised",
                "from": ph,
                "to": target,
                "reason": f"checker (I2) fix: unresolved proposed_after placeholder parent "
                          f"code in this entry's parents[] resolved to its actual final code. "
                          + REASON[target],
                "by": BY,
            }
            f.write(json.dumps(ev, ensure_ascii=False) + "\n")
    print(f"[lineage] appended {len(applied)} 'revised' events to LINEAGE.jsonl")


if __name__ == "__main__":
    main()
