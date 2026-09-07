#!/usr/bin/env python3
"""Toledo v1.4 REGISTRAR merge -- registry/proposals/economics_of_expertise_v1_0.json
and registry/proposals/core_epistemic_structure.json.

Deposited record for the economics manuscript: "The Economics of Expertise in the
Age of Generative AI" v1.0.1, Zenodo record id 22636999, DOI
10.5281/zenodo.22636999 (concept DOI 10.5281/zenodo.22636987). The proposal file
was extracted before deposit and carries record_id: null / doi: null / "Zenodo
record pending" in its own origin blocks -- this script substitutes the real
deposited identity for every new entry and every occurrence it writes, exactly
as Task 1 specifies, without editing the proposal file itself.

Two proposal batches, one script, one run, sharing running (root, domain) -> nn
state across both so the second batch continues numbering from wherever the
first left off (SCHEMA.md: nn assigned once, never reused):

  BATCH A -- registry/proposals/economics_of_expertise_v1_0.json
    (a) 16 new-entry proposals (proposals[]): each gets the next nn for its own
        (root, domain), a full SCHEMA.md-shaped entry (statement latex verbatim;
        tier exactly as proposed; parents exactly as proposed, each checked to
        exist in genesis_root.json or CANONICAL.json -- abort if not;
        coq.coq_status resolved off the v1.1 ladder: "definition" for tier
        Definition, "open_prop" for tier Dr/Open, "not_formalisable" only if the
        proposal's own coq block already says so), a LINEAGE "assigned" event
        (by "toledo-v1.4-econ", date 2026-09-07, quoting the ledger row via
        tier_in_genesis_verbatim + provenance_note_verbatim).
    (b) 7 existing-code occurrence proposals (occurrences[]): the named code's
        occurrences[] gets the real-record occurrence appended and a LINEAGE
        "occurrence_added" event is logged. Equation 1's occurrence (the
        domain-weld commuting-requirement instantiation on weld/M.02.v1) carries
        an extra "note": "domain_instantiation (economics)" field per Task 1(b).
    (c) Equation 6 (the historical raw knowledge triple (Tr_A, Str_A, Cap_A)) is
        folded into the same occurrence-append path against weld/E.03.v1 (whose
        current statement.latest is the richer admission-status formula) with an
        extra "status_note" field quoting the reviewer's finding verbatim -- no
        new entry is created for it, per Task 1(c).

  BATCH B -- registry/proposals/core_epistemic_structure.json
    5 new-entry proposals (Blackbox Log BBL-2026-09-07-217): same new-entry path
    as (a) above, parented on the Batch-A codes weld/H.22.v1, weld/H.23.v1 and
    weld/H.28.v1 (checked to exist -- they do, having just been assigned in
    Batch A of this same run). Tier Definition for 4 of the 5 (E_p, M_AI,
    X_int_empty, X_exp); tier Dr for the non-collapse rule.

Both proposal files are read-only inputs; this script never edits them. Outputs:
registry/CANONICAL.json, registry/LINEAGE.jsonl (both existing files), and (new)
registry/proposals/economics_of_expertise_v1_0.merged.json,
registry/proposals/core_epistemic_structure.merged.json, mapping every proposal
id to the final code it resolved to.

Idempotent per batch: an alias already present anywhere in CANONICAL.json, or an
occurrence with that label already recorded against record_id 22636999, means
that proposal was already merged on a prior run -- skipped, not re-added.

Never touches mcp/, coq/, latex/, README/CHANGELOG/CITATION.

Run: python3 scripts/v14_econ_merge.py
"""
import json
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
DATE = "2026-09-07"
BY = "toledo-v1.4-econ"

CANONICAL_PATH = REG / "CANONICAL.json"
GENESIS_PATH = REG / "genesis_root.json"
LINEAGE_PATH = REG / "LINEAGE.jsonl"

ECON_PROPOSALS_PATH = REG / "proposals" / "economics_of_expertise_v1_0.json"
ECON_MERGED_MAP_PATH = REG / "proposals" / "economics_of_expertise_v1_0.merged.json"

CES_PROPOSALS_PATH = REG / "proposals" / "core_epistemic_structure.json"
CES_MERGED_MAP_PATH = REG / "proposals" / "core_epistemic_structure.merged.json"

# Real deposited identity of the economics manuscript (Task 1) -- substituted
# for the proposal file's own "record pending" / null placeholders.
ECON_RECORD_ID = 22636999
ECON_DOI = "10.5281/zenodo.22636999"
ECON_CONCEPT_DOI = "10.5281/zenodo.22636987"
ECON_TITLE = "The Economics of Expertise in the Age of Generative AI v1.0.1"

CODE_RE = re.compile(
    r"^(?P<root>EQ-0\d{2}|[A-Za-z][A-Za-z0-9]*(?:[._-][A-Za-z0-9]+)*)"
    r"(?:/(?P<domain>[EHSWMPCB])\.(?P<seq>\d{2,4})(?:\.v(?P<rev>[1-9]\d*))?)?$"
)

DEFAULT_COQ = {
    "file": None, "identifier": None, "assumptions": None, "imported_from": None,
    "coq_status": "open_prop", "coq_axioms": [], "coq_source_redistributed": True,
}


def root_of(code: str) -> str:
    """Root portion of a code -- everything before the first '/<D>.' reading
    suffix, or the whole string if it is itself a bare root code."""
    return code.split("/", 1)[0]


def coq_status_for(tier: str, prop: dict, pid: str) -> str:
    """SCHEMA.md v1.1 addendum ladder: 'not_yet_formalised' is retired.
    'not_formalisable' only if the proposal's own coq block already says so;
    'definition' for a Definition-tier reading; 'open_prop' for a Dr- or
    Open-tier reading (an unproved proposition/derivation/non-collapse/
    hypothesis/synthesis stated as Prop, not yet formalised)."""
    proposed = (prop.get("coq") or {}).get("coq_status")
    if proposed == "not_formalisable":
        return "not_formalisable"
    if tier == "Definition":
        return "definition"
    if tier in ("Dr", "Open"):
        return "open_prop"
    raise SystemExit(
        f"{pid}: tier {tier!r} has no coq_status mapping in the v1.1 ladder for "
        "this merge (only Definition/Dr/Open are handled)."
    )


def merge_new_entries(proposals, by_code, genesis_codes, entries, stmt_index,
                       seq_state, id_prefix, max_id_state, lineage_events,
                       merged_map, new_codes, could_not_merge, origin_override,
                       reason_builder):
    """Shared new-entry merge path for both batches (no phi-equivalent-occurrence
    check here -- both proposal files' own phi_check sections already screened
    for that and found no match; Task 1(b)/(c) handle the 7 economics
    occurrence-proposals through merge_occurrence() below instead)."""

    def next_code(root: str, domain: str) -> str:
        key = (root, domain)
        seq_state[key] += 1
        nn = seq_state[key]
        width = 2 if nn < 100 else len(str(nn))
        return f"{root}/{domain}.{nn:0{width}d}.v1"

    for prop in proposals:
        pid = prop["id"]
        alias = prop["aliases"][0]

        if alias in stmt_index.get("_aliases", set()):
            existing_code = None
            for e in entries:
                if alias in (e.get("aliases") or []):
                    existing_code = e["code"]
                    break
            merged_map[pid] = existing_code
            continue

        try:
            parents = prop.get("parents") or []
            if not parents:
                raise ValueError(f"{pid}: proposal has no parents (SCHEMA.md T3.4: "
                                  "empty parents is legal only for EQ-001)")
            for p in parents:
                if p["code"] not in by_code and p["code"] not in genesis_codes:
                    raise ValueError(f"{pid}: parent code {p['code']!r} not found "
                                      "in genesis_root.json or CANONICAL.json -- abort")

            root = prop.get("root") or root_of(parents[0]["code"])
            domain = prop["domain"]
            other_roots = []
            for p in parents:
                r = root_of(p["code"])
                if r != root and r not in other_roots:
                    other_roots.append(r)

            tier = prop["tier"]
            code = next_code(root, domain)
            max_id_state[0] += 1
            origin = origin_override(prop) if origin_override else dict(prop["origin"])

            entry = {
                "id": f"{id_prefix}-{max_id_state[0]:02d}",
                "code": code,
                "root": root,
                "layer": prop.get("layer", "reading"),
                "domain": domain,
                "aliases": list(prop["aliases"]),
                "name": prop["name"],
                "statement": {"latest": prop["statement"]["latest"],
                              "format": prop["statement"].get("format", "latex")},
                "statements_history": [dict(h) for h in prop.get("statements_history", [])] or [{
                    "v": 1,
                    "statement": prop["statement"]["latest"],
                    "date": DATE,
                    "reason": f"{BY}: initial capture, {origin.get('source', '')}, "
                              f"{origin.get('section', '')}, {origin.get('label', '')}",
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
            if prop.get("provenance_note_verbatim"):
                entry["provenance_note_verbatim"] = prop["provenance_note_verbatim"]
            if prop.get("review_note"):
                entry["review_note"] = prop["review_note"]

            entries.append(entry)
            by_code[code] = entry
            stmt_index.setdefault("_aliases", set()).add(alias)
            new_codes.append(code)
            merged_map[pid] = code

            lineage_events.append({
                "code": code, "date": DATE, "event": "assigned",
                "from": pid, "to": code,
                "reason": reason_builder(prop, code, origin),
                "by": BY,
            })

        except ValueError as exc:
            could_not_merge.append(str(exc))
            merged_map[pid] = None


def main():
    canonical_doc = json.load(open(CANONICAL_PATH, encoding="utf-8"))
    entries = canonical_doc["canonical"]
    by_code = {e["code"]: e for e in entries}

    genesis_doc = json.load(open(GENESIS_PATH, encoding="utf-8"))
    genesis_codes = {r["code"] for r in genesis_doc["root_equations"]}

    econ_doc = json.load(open(ECON_PROPOSALS_PATH, encoding="utf-8"))
    econ_proposals = econ_doc["proposals"]
    econ_occurrences = econ_doc.get("occurrences", [])

    ces_doc = json.load(open(CES_PROPOSALS_PATH, encoding="utf-8"))
    ces_proposals = ces_doc["proposals"]

    # ------------------------------------------------------------------
    # Idempotency state.
    # ------------------------------------------------------------------
    existing_aliases = set()
    existing_occ_labels_by_record = defaultdict(set)
    for e in entries:
        for a in e.get("aliases") or []:
            existing_aliases.add(a)
        for occ in e.get("occurrences") or []:
            if occ.get("record_id") is not None:
                existing_occ_labels_by_record[occ["record_id"]].add(occ.get("label"))

    # running (root, domain) -> current max nn, seeded from CANONICAL.json's
    # actual state (retired/split/superseded codes still count).
    seq_state = defaultdict(int)
    for e in entries:
        mo = re.match(r"^(.+)/([EHSWMPCB])\.(\d+)\.v\d+$", e["code"])
        if mo:
            key = (mo.group(1), mo.group(2))
            seq_state[key] = max(seq_state[key], int(mo.group(3)))

    stmt_index = {"_aliases": set(existing_aliases)}

    lineage_events = []
    econ_merged_map = {}
    ces_merged_map = {}
    occurrences_added = 0
    new_codes = []
    could_not_merge = []
    skipped_already_merged = []

    max_id_state_econ = [0]
    max_id_state_ces = [0]
    for e in entries:
        if isinstance(e.get("id"), str) and e["id"].startswith("ECONEXP-v1.0-"):
            try:
                max_id_state_econ[0] = max(max_id_state_econ[0], int(e["id"].rsplit("-", 1)[1]))
            except ValueError:
                pass
        if isinstance(e.get("id"), str) and e["id"].startswith("CES-2026-09-07-"):
            try:
                max_id_state_ces[0] = max(max_id_state_ces[0], int(e["id"].rsplit("-", 1)[1]))
            except ValueError:
                pass

    # ==================================================================
    # BATCH A -- economics_of_expertise_v1_0.json
    # ==================================================================

    def econ_origin_override(prop):
        o = dict(prop["origin"])
        o["source"] = ECON_TITLE
        o["record_id"] = ECON_RECORD_ID
        o["doi"] = ECON_DOI
        # section/label kept exactly as extracted from the proposal.
        return o

    def econ_reason_builder(prop, code, origin):
        reason_quote = prop.get("provenance_note_verbatim") or prop.get("tier_in_genesis_verbatim", "")
        ledger_quote = prop.get("tier_in_genesis_verbatim", "")
        return (
            f"Toledo v1.4 Economics of Expertise merge (proposal {prop['id']}, "
            f"{prop['name']}, origin: {origin['source']}, {origin['section']}, "
            f"{origin['label']}, record_id {origin['record_id']}, doi {origin['doi']}): "
            f"ledger status {ledger_quote!r} -- {reason_quote}"
        )

    # (a) new entries
    (already, remaining) = ([], [])
    for prop in econ_proposals:
        alias = prop["aliases"][0]
        if alias in existing_aliases:
            already.append(prop["id"])
        else:
            remaining.append(prop)

    merge_new_entries(
        remaining, by_code, genesis_codes, entries, stmt_index, seq_state,
        "ECONEXP-v1.0", max_id_state_econ, lineage_events, econ_merged_map,
        new_codes, could_not_merge, econ_origin_override, econ_reason_builder,
    )
    for pid in already:
        existing_code = None
        for e in entries:
            for prop2 in econ_proposals:
                if prop2["id"] == pid and prop2["aliases"][0] in (e.get("aliases") or []):
                    existing_code = e["code"]
        econ_merged_map[pid] = existing_code
        skipped_already_merged.append(pid)

    # (b)+(c) occurrence proposals against existing codes
    for occ_prop in econ_occurrences:
        target_code = occ_prop["toledo_code"]
        eq_n = occ_prop["equation"]
        label = f"eq.{eq_n}"
        if target_code not in by_code:
            could_not_merge.append(f"occurrence eq.{eq_n}: target code {target_code!r} not found in CANONICAL.json")
            continue
        target = by_code[target_code]
        if label in existing_occ_labels_by_record[ECON_RECORD_ID] and any(
            o.get("label") == label and o.get("record_id") == ECON_RECORD_ID
            for o in (target.get("occurrences") or [])
        ):
            skipped_already_merged.append(f"occurrence-eq.{eq_n}")
            econ_merged_map[f"OCC-eq.{eq_n}"] = target_code
            continue

        occ = {
            "record_id": ECON_RECORD_ID,
            "doi": ECON_DOI,
            "label": label,
            "section": None,
            "raw_key": f"{ECON_RECORD_ID}:{label}",
        }
        reason_extra = ""
        if occ_prop["relation"] == "domain_instantiation" and eq_n == 1:
            occ["note"] = "domain_instantiation (economics)"
            reason_extra = " Recorded with note 'domain_instantiation (economics)' per Task 1(b)."
        if eq_n == 6:
            occ["status_note"] = occ_prop["evidence"]
            reason_extra = (
                " Task 1(c): the reviewer found this is a historical raw form under "
                f"{target_code} whose current statement is a richer tuple -- recorded as "
                "an occurrence with status_note quoting that finding, no new entry created."
            )

        target.setdefault("occurrences", []).append(occ)
        occurrences_added += 1
        econ_merged_map[f"OCC-eq.{eq_n}"] = target_code
        lineage_events.append({
            "code": target_code, "date": DATE, "event": "occurrence_added",
            "from": f"EconExpertise-v1.0:eq.{eq_n}", "to": target_code,
            "reason": (
                f"Toledo v1.4 Economics of Expertise merge: Eq.({eq_n}) of "
                f"{ECON_TITLE} (record_id {ECON_RECORD_ID}, doi {ECON_DOI}) is a "
                f"{occ_prop['relation']} occurrence of {target_code} -- ledger row quote: "
                f"\"{occ_prop['evidence']}\".{reason_extra}"
            ),
            "by": BY,
        })

    # ==================================================================
    # BATCH B -- core_epistemic_structure.json (parents: weld/H.22.v1,
    # weld/H.23.v1, weld/H.28.v1 -- all just assigned in Batch A above, or
    # already present from a prior run).
    # ==================================================================

    def ces_origin_override(prop):
        return dict(prop["origin"])

    def ces_reason_builder(prop, code, origin):
        return (
            f"Toledo v1.4 Core Epistemic Structure merge (proposal {prop['id']}, "
            f"{prop['name']}, origin: {origin['source']}, {origin['section']}, "
            f"{origin['label']}, doi {origin['doi']}): {prop.get('provenance_note_verbatim', '')}"
        )

    already_ces, remaining_ces = [], []
    for prop in ces_proposals:
        alias = prop["aliases"][0]
        if alias in existing_aliases:
            already_ces.append(prop["id"])
        else:
            remaining_ces.append(prop)

    merge_new_entries(
        remaining_ces, by_code, genesis_codes, entries, stmt_index, seq_state,
        "CES-2026-09-07", max_id_state_ces, lineage_events, ces_merged_map,
        new_codes, could_not_merge, ces_origin_override, ces_reason_builder,
    )
    for pid in already_ces:
        existing_code = None
        for e in entries:
            for prop2 in ces_proposals:
                if prop2["id"] == pid and prop2["aliases"][0] in (e.get("aliases") or []):
                    existing_code = e["code"]
        ces_merged_map[pid] = existing_code
        skipped_already_merged.append(pid)

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
        "computed": f"{DATE} from canonical[] (scripts/v14_econ_merge.py)",
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

    json.dump(econ_merged_map, open(ECON_MERGED_MAP_PATH, "w", encoding="utf-8"),
               indent=2, ensure_ascii=False, sort_keys=True)
    with open(ECON_MERGED_MAP_PATH, "a", encoding="utf-8") as fh:
        fh.write("\n")

    json.dump(ces_merged_map, open(CES_MERGED_MAP_PATH, "w", encoding="utf-8"),
               indent=2, ensure_ascii=False, sort_keys=True)
    with open(CES_MERGED_MAP_PATH, "a", encoding="utf-8") as fh:
        fh.write("\n")

    print("\nv1.4 Economics of Expertise + Core Epistemic Structure merge complete.")
    print(f"  economics proposals total: {len(econ_proposals)}")
    print(f"  economics occurrence-proposals total: {len(econ_occurrences)}")
    print(f"  CES proposals total: {len(ces_proposals)}")
    print(f"  new entries created: {len(new_codes)}: {new_codes}")
    print(f"  occurrences added to existing entries: {occurrences_added}")
    print(f"  already-merged (idempotent skip): {len(skipped_already_merged)}: {skipped_already_merged}")
    print(f"  could not merge: {len(could_not_merge)}")
    for msg in could_not_merge:
        print("   -", msg)


if __name__ == "__main__":
    main()
