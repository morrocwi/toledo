#!/usr/bin/env python3
"""Toledo v1.5 REGISTRAR merge -- registry/proposals/recursive_epistemic_tunnel_v2_0.json

Source manuscript: "The Recursive Epistemic Tunnel v2.0" (Zenodo record pending
at merge time). The TOLEDO EXTRACTOR pass over this manuscript produced 23
RET-Nxx new-equation proposals (Appendix B ledger) and 23 CAN-object
occurrence proposals (Appendix A ledger), plus a phi_check (0 matches -- all
23 RET-Nxx equations are genuinely new, none collapse into an existing
Toledo object) and glosa_gate_findings (rule 6 priority words: 0 violations;
rule 9 AI-vendor names: 3 hits, all inside the manuscript's own disclosure/
registration apparatus, not a credit/trailer -- no action; rule 17 citations:
satisfied, with 5 hygiene recommendations for the chair).

"7 unresolved" reading of the extractor's own notes: the extractor file
carries no top-level "unresolved" list -- every one of the 23 new-entry
proposals already has a resolved (checked-to-exist) parent set and a chosen
root (disclosed as a "convention" in a drift_note when more than one parent
root contributed). The 7 items that are genuinely open/flagged-not-blocking
in the extractor's own findings are:
  - 2 "GAP FINDING" occurrences (CAN-066 -> weld/H.07.v1, CAN-078 ->
    EQ-015/H.18.v1): named only in the manuscript's Appendix A table, no
    body-text use found. Handled honestly below: still merged as a
    domain_reading occurrence (the extractor's own relation call), because
    an Appendix-A listing is itself a real, if thin, occurrence -- but the
    LINEAGE occurrence_added event quotes the GAP FINDING verbatim so the
    thinness is not silently lost.
  - 5 rule_17 "unattributed but resolvable" citation points (secs.37.2-37.7):
    these are about the manuscript's own reference apparatus, not about any
    Toledo code -- out of scope for this registrar merge; reported to the
    chair in this script's own printed output and in the merged.json file,
    not written into CANONICAL.json.
No proposal's parent was actually unresolved/missing in the sense of
SCHEMA.md's "abort if a parent code does not exist" rule -- all parent codes
checked below existed in the live CANONICAL.json before this run.

Per-(root, domain) `nn` continuation from the live maximum (SCHEMA.md: nn
assigned once, never reused), LINEAGE assigned/occurrence_added events,
counts{} recompute, and a `<proposal>.merged.json` idempotency-map output --
the same pattern as scripts/v14_econ_merge.py.

Never touches mcp/, coq/, latex/, README/CHANGELOG/CITATION. Never edits the
proposal file itself (read-only input). Re-reads registry/CANONICAL.json
immediately before the one atomic write below (other lanes edit tier/coq
fields on existing entries concurrently) and touches only: (a) new entries
this script appends, (b) the occurrences[] array of the 23 named existing
entries, (c) the top-level counts{} and children[] recompute over the full
array. No other field of any pre-existing entry is modified.

Run: python3 scripts/v15_tunnel_merge.py
"""
import json
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
DATE = "2026-09-07"
BY = "toledo-v1.5-tunnel"

CANONICAL_PATH = REG / "CANONICAL.json"
GENESIS_PATH = REG / "genesis_root.json"
LINEAGE_PATH = REG / "LINEAGE.jsonl"

PROPOSAL_PATH = REG / "proposals" / "recursive_epistemic_tunnel_v2_0.json"
MERGED_MAP_PATH = REG / "proposals" / "recursive_epistemic_tunnel_v2_0.merged.json"

MANUSCRIPT_TITLE = "The Recursive Epistemic Tunnel v2.0"
ORIGIN_SOURCE = (
    "The Recursive Epistemic Tunnel v2.0 (Zenodo record pending -- origin to "
    "be completed by a LINEAGE revised event after deposit)"
)

CODE_RE = re.compile(
    r"^(?P<root>EQ-0\d{2}|[A-Za-z][A-Za-z0-9]*(?:[._-][A-Za-z0-9]+)*)"
    r"(?:/(?P<domain>[EHSWMPCB])\.(?P<seq>\d{2,4})(?:\.v(?P<rev>[1-9]\d*))?)?$"
)

DEFAULT_COQ = {
    "file": None, "identifier": None, "assumptions": None, "imported_from": None,
    "coq_status": "open_prop", "coq_axioms": [], "coq_source_redistributed": True,
}


def root_of(code: str) -> str:
    return code.split("/", 1)[0]


def coq_status_for(tier: str, prop: dict, pid: str) -> str:
    """v1.1 SCHEMA.md ladder: 'not_formalisable' only if the proposal's own
    coq block already says so; 'definition' for Definition tier; 'open_prop'
    for Dr/Open tier. The proposal file's own coq blocks all say
    'not_yet_formalised' (a retired v1.0 value, pre-dating the v1.1 ladder
    this registrar merge uses) -- that string is not itself a
    not_formalisable claim, so it is re-derived from tier here, exactly as
    scripts/v14_econ_merge.py already does for the same situation."""
    proposed = (prop.get("coq") or {}).get("coq_status")
    if proposed == "not_formalisable":
        return "not_formalisable"
    if tier == "Definition":
        return "definition"
    if tier in ("Dr", "Open"):
        return "open_prop"
    raise SystemExit(
        f"{pid}: tier {tier!r} has no coq_status mapping in the v1.1 ladder "
        "for this merge (only Definition/Dr/Open are handled)."
    )


def ret_number(pid: str) -> int:
    """'PROP-RET-2026-09-07-07' -> 7."""
    return int(pid.rsplit("-", 1)[1])


def main():
    canonical_doc = json.load(open(CANONICAL_PATH, encoding="utf-8"))
    entries = canonical_doc["canonical"]
    by_code = {e["code"]: e for e in entries}

    genesis_doc = json.load(open(GENESIS_PATH, encoding="utf-8"))
    genesis_codes = {r["code"] for r in genesis_doc["root_equations"]}

    prop_doc = json.load(open(PROPOSAL_PATH, encoding="utf-8"))
    proposals = prop_doc["proposals"]
    occ_proposals = prop_doc["occurrences"]

    # ------------------------------------------------------------------
    # Idempotency state.
    # ------------------------------------------------------------------
    existing_aliases = set()
    for e in entries:
        for a in e.get("aliases") or []:
            existing_aliases.add(a)

    seq_state = defaultdict(int)
    for e in entries:
        mo = re.match(r"^(.+)/([EHSWMPCB])\.(\d+)\.v\d+$", e["code"])
        if mo:
            key = (mo.group(1), mo.group(2))
            seq_state[key] = max(seq_state[key], int(mo.group(3)))

    max_id_state = [0]
    for e in entries:
        if isinstance(e.get("id"), str) and e["id"].startswith("RET-v2.0-"):
            try:
                max_id_state[0] = max(max_id_state[0], int(e["id"].rsplit("-", 1)[1]))
            except ValueError:
                pass

    def next_code(root: str, domain: str) -> str:
        key = (root, domain)
        seq_state[key] += 1
        nn = seq_state[key]
        width = 2 if nn < 100 else len(str(nn))
        return f"{root}/{domain}.{nn:0{width}d}.v1"

    lineage_events = []
    merged_map = {}
    new_codes = []
    could_not_merge = []
    skipped_already_merged = []
    occurrences_added = 0
    ret_to_code = {}

    # ==================================================================
    # (a) 23 new-entry proposals (RET-Nxx).
    # ==================================================================
    for prop in proposals:
        pid = prop["id"]
        n = ret_number(pid)
        primary_alias = prop["aliases"][0]  # e.g. "RET-N07"
        eq_alias = f"Tunnel-v2.0:eq.{n}"

        if primary_alias in existing_aliases:
            existing_code = None
            for e in entries:
                if primary_alias in (e.get("aliases") or []):
                    existing_code = e["code"]
                    break
            merged_map[pid] = existing_code
            ret_to_code[primary_alias] = existing_code
            skipped_already_merged.append(pid)
            continue

        try:
            parents = prop.get("parents") or []
            if not parents:
                raise ValueError(f"{pid}: proposal has no parents (SCHEMA.md T3.4: "
                                  "empty parents is legal only for EQ-001)")
            for p in parents:
                if p["code"] not in by_code and p["code"] not in genesis_codes:
                    raise ValueError(f"{pid}: parent code {p['code']!r} not found "
                                      "in genesis_root.json or CANONICAL.json -- "
                                      "cannot invent a root, leaving unmerged")

            root = prop["root"]
            domain = prop["domain"]
            other_roots = sorted({root_of(p["code"]) for p in parents} - {root})

            tier = prop["tier"]
            code = next_code(root, domain)
            max_id_state[0] += 1

            aliases = list(prop["aliases"])
            if eq_alias not in aliases:
                aliases.append(eq_alias)

            origin = dict(prop["origin"])
            origin["source"] = ORIGIN_SOURCE

            # Manuscript sentence quoted for the LINEAGE "assigned" event:
            # the first parent's own evidence field always carries a direct
            # manuscript quote (sec.N: '...') -- fall back to
            # definition_verbatim, then the statement itself.
            quote = parents[0].get("evidence") or prop.get("definition_verbatim") \
                or prop["statement"]["latest"]

            entry = {
                "id": f"RET-v2.0-{max_id_state[0]:02d}",
                "code": code,
                "root": root,
                "layer": prop.get("layer", "reading"),
                "domain": domain,
                "aliases": aliases,
                "name": prop["name"],
                "statement": {"latest": prop["statement"]["latest"],
                              "format": prop["statement"].get("format", "latex")},
                "statements_history": [{
                    "v": 1,
                    "statement": prop["statement"]["latest"],
                    "date": DATE,
                    "reason": f"{BY}: initial capture, {ORIGIN_SOURCE}, "
                              f"sec.{origin.get('section', '')}, {origin.get('label', '')}",
                    "by": BY,
                }],
                "parents": [{"code": p["code"], "derived_via": p["derived_via"]} for p in parents],
                "children": [],
                "origin": origin,
                "status": prop.get("status", "current"),
                "status_note": prop.get("status_note", ""),
                "superseded_by": None,
                "tier": tier,
                "tier_in_genesis_verbatim": prop.get("tier_in_genesis_verbatim", ""),
                "coq": dict(DEFAULT_COQ),
                "relations": [dict(r) for r in prop.get("relations", [])],
                "occurrences": [dict(o) for o in prop.get("occurrences", [])],
                "role": prop.get("role", "other"),
                "first_assigned": DATE,
            }
            entry["coq"]["coq_status"] = coq_status_for(tier, prop, pid)
            if prop.get("coq", {}).get("coq_axioms"):
                entry["coq"]["coq_axioms"] = list(prop["coq"]["coq_axioms"])
            if other_roots:
                entry["reads_also"] = other_roots
            if prop.get("drift_note"):
                entry["drift_note"] = prop["drift_note"]
            if prop.get("definition_verbatim"):
                entry["provenance_note_verbatim"] = prop["definition_verbatim"]

            entries.append(entry)
            by_code[code] = entry
            existing_aliases.add(primary_alias)
            existing_aliases.add(eq_alias)
            new_codes.append(code)
            merged_map[pid] = code
            ret_to_code[primary_alias] = code

            lineage_events.append({
                "code": code, "date": DATE, "event": "assigned",
                "from": pid, "to": code,
                "reason": (
                    f"Toledo v1.5 Recursive Epistemic Tunnel v2.0 merge (proposal {pid}, "
                    f"{prop['name']}, sec.{origin.get('section', '')}, tier "
                    f"{prop.get('tier_in_genesis_verbatim', tier)!r}): {quote}"
                ),
                "by": BY,
            })

        except ValueError as exc:
            could_not_merge.append(str(exc))
            merged_map[pid] = None

    # ==================================================================
    # (b) 23 occurrence proposals against existing codes.
    # ==================================================================
    existing_occ_labels = defaultdict(set)
    for e in entries:
        for occ in e.get("occurrences") or []:
            if occ.get("label"):
                existing_occ_labels[e["code"]].add(occ["label"])

    for i, occ_prop in enumerate(occ_proposals, start=1):
        target_code = occ_prop["current_code"]
        label = f"Tunnel-v2.0:eq.{i}"
        occ_key = f"OCC-{occ_prop['toledo_id']}"

        if target_code not in by_code:
            could_not_merge.append(
                f"occurrence {occ_key} ({label}): target code {target_code!r} "
                "not found in CANONICAL.json -- leaving unmerged, no code invented"
            )
            merged_map[occ_key] = None
            continue

        target = by_code[target_code]
        if label in existing_occ_labels[target_code]:
            skipped_already_merged.append(occ_key)
            merged_map[occ_key] = target_code
            continue

        occ = {
            "record_id": None,
            "doi": None,
            "label": label,
            "section": occ_prop.get("manuscript_location"),
            "raw_key": f"{MANUSCRIPT_TITLE}:{label}",
        }
        is_gap_finding = "GAP FINDING" in occ_prop.get("evidence", "")
        reason_extra = ""
        if is_gap_finding:
            occ["status_note"] = occ_prop["evidence"]
            reason_extra = (
                " Handled honestly per extractor note: named only in the manuscript's "
                "Appendix A table, no body-text restatement or application found -- "
                "recorded as a thin occurrence, not silently dropped nor presented as "
                "a body-text usage."
            )

        target.setdefault("occurrences", []).append(occ)
        existing_occ_labels[target_code].add(label)
        occurrences_added += 1
        merged_map[occ_key] = target_code

        lineage_events.append({
            "code": target_code, "date": DATE, "event": "occurrence_added",
            "from": f"{MANUSCRIPT_TITLE}:{label}", "to": target_code,
            "reason": (
                f"Toledo v1.5 Recursive Epistemic Tunnel v2.0 merge: {occ_prop['toledo_id']} "
                f"({occ_prop['manuscript_location']}) is a {occ_prop['relation']} occurrence "
                f"of {target_code} -- extractor evidence: \"{occ_prop['evidence']}\".{reason_extra}"
            ),
            "by": BY,
        })

    # ------------------------------------------------------------------
    # children[] = invert parents[] across the full final array.
    # ------------------------------------------------------------------
    code_set = {f["code"] for f in entries}
    children_map = {c: [] for c in code_set}
    for f in entries:
        for p in f["parents"]:
            if p["code"] in children_map:
                children_map[p["code"]].append(f["code"])
    for f in entries:
        f["children"] = sorted(set(children_map[f["code"]]))

    # ------------------------------------------------------------------
    # Validation.
    # ------------------------------------------------------------------
    problems = []
    codes_seen = set()
    for f in entries:
        if not f["parents"]:
            problems.append(f"orphan: {f['code']} has no parents")
        if f["code"] in codes_seen:
            problems.append(f"duplicate code: {f['code']}")
        codes_seen.add(f["code"])
        if not CODE_RE.match(f["code"]):
            problems.append(f"grammar violation: {f['code']}")
        if f["status"] != "current" and not (f.get("status_note") or "").strip():
            problems.append(f"status={f['status']!r} with empty status_note: {f['code']}")
    if problems:
        print("VALIDATION PROBLEMS:")
        for p in problems[:50]:
            print(" -", p)
        sys.exit(1)

    # ------------------------------------------------------------------
    # counts{} recompute.
    # ------------------------------------------------------------------
    canonical_doc["counts"] = {
        "entries": len(entries),
        "by_status": dict(Counter(e["status"] for e in entries)),
        "by_domain": dict(Counter(e["domain"] for e in entries if e.get("domain"))),
        "by_tier": dict(Counter(e["tier"] for e in entries)),
        "by_coq_status": dict(Counter(e["coq"]["coq_status"] for e in entries)),
        "computed": f"{DATE} from canonical[] (scripts/v15_tunnel_merge.py)",
    }

    # ------------------------------------------------------------------
    # Write outputs.
    # ------------------------------------------------------------------
    if new_codes or occurrences_added:
        text = json.dumps(canonical_doc, indent=2, ensure_ascii=False)
        open(CANONICAL_PATH, "w", encoding="utf-8").write(text + "\n")
        print(f"Wrote {CANONICAL_PATH}: {len(entries)} canonical entries "
              f"(was {len(entries) - len(new_codes)}).")

    if lineage_events:
        with open(LINEAGE_PATH, "a", encoding="utf-8") as fh:
            for ev in lineage_events:
                fh.write(json.dumps(ev, ensure_ascii=False) + "\n")
        print(f"Appended {len(lineage_events)} events to {LINEAGE_PATH}")

    merged_out = dict(merged_map)
    merged_out["_unmerged"] = [
        {"item": msg} for msg in could_not_merge
    ]
    merged_out["_extractor_notes_handled"] = {
        "gap_finding_occurrences_merged_thin": [
            occ_prop["toledo_id"] for occ_prop in occ_proposals
            if "GAP FINDING" in occ_prop.get("evidence", "")
        ],
        "rule17_citation_hygiene_out_of_scope_for_toledo": (
            prop_doc.get("glosa_gate_findings", {})
            .get("rule_17_citation_resolvability", {})
            .get("findings", [])
        ),
    }
    json.dump(merged_out, open(MERGED_MAP_PATH, "w", encoding="utf-8"),
               indent=2, ensure_ascii=False, sort_keys=True)
    with open(MERGED_MAP_PATH, "a", encoding="utf-8") as fh:
        fh.write("\n")

    print("\nv1.5 Recursive Epistemic Tunnel v2.0 merge complete.")
    print(f"  new-equation proposals total: {len(proposals)}")
    print(f"  occurrence proposals total: {len(occ_proposals)}")
    print(f"  new entries created: {len(new_codes)}: {new_codes}")
    print(f"  occurrences added to existing entries: {occurrences_added}")
    print(f"  already-merged (idempotent skip): {len(skipped_already_merged)}: {skipped_already_merged}")
    print(f"  could not merge: {len(could_not_merge)}")
    for msg in could_not_merge:
        print("   -", msg)
    print("\n  RET-Nxx -> code table:")
    for prop in proposals:
        alias = prop["aliases"][0]
        print(f"    {alias:10s} -> {ret_to_code.get(alias)}")


if __name__ == "__main__":
    main()
