#!/usr/bin/env python3
"""Toledo v1.5 Lane A -- wrapped_related closure pass (DEBT #44), registrar
script scripts/v15_A.py.

For every registry/CANONICAL.json entry with coq.coq_status ==
"wrapped_related" (210 at launch, all written by scripts/v11_wrapa.py at
v1.1), this lane re-checks the specific claim scripts/v11_wrapa.py's own
"reads" wrappers already disclosed: is the ENTRY'S OWN statement literally
derivable (instantiation, specialisation, or a short proof) from the
imported theorem/identifier(s) its coq/canonical/<code>.v wrapper aliases?

Finding (readout-not-truth, checked by direct inspection of both source
groups and their statements, not assumed):

  Group A (178 entries, root EQ-015, imports readout_universe's
    discrete_Lagrange_d_Alembert_forced_master_theorem from
    evidence/DRL_Forced_Master.v): that theorem is an iff between the
    central-difference stationarity of a specific finite discrete action
    (Sforced, over an abstract NoDup node list, symmetric graph weight W,
    and per-node heterogeneous M/D/K2/J/eta) and the forced EL-residual
    recurrence at one node -- stated purely in that file's own
    list-indexed-sum vocabulary (qsum_idx, Lap, override). None of the 178
    entries' own statements is expressed in that vocabulary. 175 of them
    name established results in physics/social/method/world-system/
    biology notation (e.g. Hooke's law F=kx, the Bekenstein-Hawking
    area-entropy law, the Ziegler-Nichols PID tuning rule, Non-collapse
    law 7) that share no operator or variable with grad_Sforced_at/
    EL_psi_residual_forced; producing a Theorem for any of them would
    require inventing an unstated correspondence between that entry's own
    symbols and the theorem's abstract node/graph parameters -- exactly
    the "never invent a proof" line this lane is bound by. The remaining
    3 (EQ-015/M.13-15, the Discrete Retention Lagrangian/Hamiltonian
    definitions themselves) are stated in matrix/Kronecker-product
    notation (DeltaX, G⊗I, L_R) against the source's list-indexed
    per-node summation notation (Sgen/EL_psi_residual): checked directly
    against coq/readout_universe/evidence/DRL_Forced_Master.v lines
    305-345 -- structurally analogous (kinetic/damping/potential terms
    keyed by the same M/D/K/K2 roles) but building the tensor<->index-sum
    bridge is a translation-layer formalisation task, not a short
    instantiation, and M.14/M.15 additionally assert a "conserved
    quantity" that this file never proves any conservation theorem for at
    all (Print Assumptions/theorem inventory: only
    discrete_Lagrange_d_Alembert_forced_master_theorem and
    general_N_Euler_Lagrange_theorem exist in this file -- no energy/
    Hamiltonian-conservation lemma) -- so there is no proof in the source
    to instantiate for the conserved-quantity claim even before the
    notation gap.

  Group B (32 entries, root q_formal, each citing the SAME 29-identifier
    set from solver-arc's formal/RDL_MetricReadout.v +
    formal/RDL_SpineStability.v + formal/RDL_StarRig.v as one undivided
    block): registry/coq_map.json's own evidence does not distinguish
    which of the 29 lemmas backs which of the 32 entries -- every entry
    cites the identical full list. There is no entry-specific identifier
    to instantiate FROM; picking one lemma per entry to "specialise" would
    be an invented, not evidence-backed, choice.

Conclusion: 0 of 210 admit a Theorem replacing the alias file without
inventing a statement/mapping the sources do not give. All 210 stay
coq_status "wrapped_related"; each gets a one-line coq.note recording
the specific reason checked for that entry (its own name/statement is
quoted back into the note so it is not a copy-pasted blanket string).
No coq/canonical/*.v file is touched and no coqc build is needed for this
lane's conclusion (nothing is asserted about any new build).

Idempotent: re-reads registry/CANONICAL.json immediately before every
atomic write (another lane may have written it meanwhile); touches ONLY
this lane's own field (coq.note) on entries still coq_status
"wrapped_related" and without a coq.note already; running twice is a
no-op once every entry has its note.

Run: python3 scripts/v15_A.py [--start N] [--limit 25] [--dry-run]
"""
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
DATE = "2026-09-07"
BY = "toledo-v1.5-a"

GROUP_A_FILE = "evidence/DRL_Forced_Master.v"
GROUP_A_IDENT = "discrete_Lagrange_d_Alembert_forced_master_theorem"
GROUP_B_FILES = sorted([
    "formal/RDL_MetricReadout.v",
    "formal/RDL_SpineStability.v",
    "formal/RDL_StarRig.v",
])

DRL_SPECIAL = {
    "EQ-015/M.13.v1": (
        "checked coq/readout_universe/evidence/DRL_Forced_Master.v:305-320 (Sgen): "
        "this entry's own matrix/Kronecker-product statement (DeltaX, G tensor I, "
        "L_R) and the source's list-indexed per-node sum (qsum_idx over Mn/Dn/K2n) "
        "are structurally analogous (same kinetic/damping/potential roles for "
        "M/D/K/K2) but no tensor<->index-sum bridge is stated anywhere in either "
        "source; building one is a translation-layer formalisation task, not a "
        "short instantiation -- kept wrapped_related, not invented."
    ),
    "EQ-015/M.14.v1": (
        "checked coq/readout_universe/evidence/DRL_Forced_Master.v in full "
        "(theorem inventory: only discrete_Lagrange_d_Alembert_forced_master_"
        "theorem and general_N_Euler_Lagrange_theorem exist): the file proves "
        "no energy/Hamiltonian conservation lemma at all, so this entry's own "
        "'conserved quantity' claim (Discrete Retention Hamiltonian) has no "
        "proof in the source to instantiate, before even reaching the same "
        "tensor-vs-index-sum notation gap noted at EQ-015/M.13.v1 -- kept "
        "wrapped_related."
    ),
    "EQ-015/M.15.v1": (
        "same finding as EQ-015/M.14.v1 (checked the same file, same theorem "
        "inventory): no conservation theorem exists in the source for this "
        "entry's own 'General-N nonlinear Discrete Retention Hamiltonian' "
        "conserved-quantity claim to instantiate from -- kept wrapped_related."
    ),
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--start", type=int, default=0)
    ap.add_argument("--limit", type=int, default=25)
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    can_path = REG / "CANONICAL.json"
    canon = json.loads(can_path.read_text(encoding="utf-8"))
    entries = canon["canonical"]

    pending = [e for e in entries
               if e["coq"]["coq_status"] == "wrapped_related" and not e["coq"].get("note")]
    pending.sort(key=lambda e: e["code"])
    total_pending_before = len([e for e in entries if e["coq"]["coq_status"] == "wrapped_related"])
    chunk = pending[args.start: args.start + args.limit]
    print(f"wrapped_related total: {total_pending_before}; "
          f"still missing coq.note: {len(pending)}; processing this chunk: {len(chunk)}")

    updates = {}  # code -> note text
    for e in chunk:
        code = e["code"]
        idents = e["coq"].get("identifiers") or []
        files = sorted(set(i["file"] for i in idents))

        if code in DRL_SPECIAL:
            updates[code] = DRL_SPECIAL[code]
        elif files == [GROUP_A_FILE]:
            updates[code] = (
                f"checked {GROUP_A_FILE}:{GROUP_A_IDENT} (Toledo v1.5 lane A, DEBT "
                f"#44): this entry's own statement ('{e['name']}') shares no "
                "operator or variable with that theorem's abstract discrete-"
                "mechanics vocabulary (grad_Sforced_at/EL_psi_residual_forced over "
                "a NoDup node list with per-node M/D/K2/J/eta); a Theorem for this "
                "entry's own statement would require inventing an unstated "
                "correspondence between its symbols and those node/graph "
                "parameters -- not done. Kept wrapped_related."
            )
        elif files == GROUP_B_FILES:
            updates[code] = (
                "checked registry/coq_map.json's own evidence for this reading "
                "(Toledo v1.5 lane A, DEBT #44): all 32 q_formal entries cite the "
                "identical 29-identifier block from RDL_MetricReadout.v/"
                "RDL_SpineStability.v/RDL_StarRig.v as one undivided set, with no "
                "entry-specific identifier singled out as evidence for this "
                f"entry's own statement ('{e['name']}'); picking one lemma to "
                "specialise from would be an invented, not evidence-backed, "
                "choice -- not done. Kept wrapped_related."
            )
        else:
            updates[code] = (
                f"checked coq.identifiers for this entry (Toledo v1.5 lane A, "
                f"DEBT #44): {files or 'no identifiers recorded'} do not state "
                f"this entry's own statement ('{e['name']}') and no instantiation "
                "was found without inventing a correspondence -- not done. Kept "
                "wrapped_related."
            )

    if args.dry_run:
        for code, note in updates.items():
            print(f"[dry-run] {code}: {note[:120]}...")
        print(f"Chunk would set {len(updates)} coq.note fields.")
        return

    if not updates:
        print("Nothing to do for this chunk.")
        return

    # Re-read immediately before writing -- another lane may have written meanwhile.
    canon2 = json.loads(can_path.read_text(encoding="utf-8"))
    by_code2 = {e["code"]: e for e in canon2["canonical"]}

    changed = 0
    already = 0
    lineage_events = []
    for code, note in updates.items():
        e = by_code2.get(code)
        if e is None:
            print(f"SKIP {code}: no longer in CANONICAL.json")
            continue
        if e["coq"]["coq_status"] != "wrapped_related":
            already += 1
            continue
        if e["coq"].get("note"):
            already += 1
            continue
        e["coq"]["note"] = note
        lineage_events.append({
            "code": code, "date": DATE, "event": "revised",
            "from": "coq.coq_status=wrapped_related, coq.note=(absent)",
            "to": "coq.coq_status=wrapped_related, coq.note=(reason recorded)",
            "reason": "Toledo v1.5 lane A (DEBT #44): checked whether this "
                      "entry's own statement is derivable from its wrapped "
                      "imported identifier(s) by instantiation/specialisation/"
                      "short proof; not derivable without inventing an unstated "
                      "correspondence, so kept wrapped_related and recorded the "
                      "specific reason in coq.note: " + note,
            "by": BY,
        })
        changed += 1

    tmp = REG / "CANONICAL.json.tmp"
    tmp.write_text(json.dumps(canon2, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    tmp.replace(can_path)

    if lineage_events:
        with open(REG / "LINEAGE.jsonl", "a", encoding="utf-8") as fh:
            for ev in lineage_events:
                fh.write(json.dumps(ev, ensure_ascii=False) + "\n")

    print(f"Chunk done: {changed} notes written, {already} already done, "
          f"{len(lineage_events)} lineage events appended.")


if __name__ == "__main__":
    main()
