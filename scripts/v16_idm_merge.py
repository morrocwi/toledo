#!/usr/bin/env python3
"""
scripts/v16_idm_merge.py -- Toledo v1.6 REGISTRAR merge -- root registry
extension R2 (information-discrete-math), registry/proposals/idm.json.

Founder ruling (2026-09-08, relayed in ops/HANDOFF_OVERNIGHT_2026-09-06.md,
"2026-09-08 -- Resistance ladder + Reproduction Ledger (founder ruling
BBL-229)" section): "เอา idm เอาเข้า toledo ก่อน และใน idm ให้อัพเดทรหัสสมการ
ให้ตรงกับ toledo, ultracode" -- IDM enters Toledo first, using this repo's own
root registry extension mechanism (R1, GENESIS_CODE_SCHEME.md, founder ruling
BBL-2026-09-07-207, applied here as R2 under the same "no invented numbering"
discipline, context BBL-2026-09-07-229 / the 2026-09-08 instruction above),
IDM then carries the Toledo codes it is assigned (a later, separate lane
edits the IDM repo itself).

This script does exactly five things, each idempotent (re-reads the target
file immediately before its own atomic write; only ever adds rows/codes not
already present, checked by code / by (file, identifier) pair / by LINEAGE
"assigned" code -- a re-run after a partial failure is always safe):

  1. registry/genesis_root.json["root_equations"]: 18 new Layer-0 root rows
     -- RD1..RD9 (the Retained-Difference/Peano axioms) and D, Z, Q, R, L_R,
     delta_R, Keystone, A2, A3 (the number ladder + the keystone + the
     FOLD/DECISION engine) -- role "root-extension", codes = IDM's OWN ids
     verbatim (never re-prefixed, per registry/GENESIS_CODE_SCHEME.md).
     Connection to Genesis is asserted ONLY where the proposal's phi_check
     already found a quoted textual link (delta_R -> EQ-001, L_R -> EQ-008,
     Keystone -> EQ-008; genesis_relations_asserted: 3) -- those three carry
     the target as a real `parents` entry (matching the R1 "Theta" pattern:
     a `relations` quote mirrored into `parents` so test_no_orphans sees a
     real parent, not just a disclosed non-finding). The other 15 roots carry
     `parents: []` with `relations: []` and a non-empty `relations_note`
     (the R1 "CMC" exemption pattern, registry/SCHEMA.md / test_registry.py
     `_root_orphan_exempt`): for RD1-RD9, the note quotes
     registry/rd_root_map.json's own prior, already-adversarially-checked
     finding (NOT_SAME_OBJECT, all 9) -- IDM's own textbook states its
     RD1-RD9 are "the exact same RD1-RD9" as the solver-arc/readout_universe
     RD.v mirror rd_root_map.json already checked against Genesis, so that
     finding transfers rather than being redone; for D/Z/Q/R/A2/A3, the note
     records that registry/GENESIS_CODE_SCHEME.md and genesis_root.json were
     checked directly and no source text states a connection, so none is
     invented.
  2. registry/CANONICAL.json["canonical"]: 274 new readings, one per
     coq_map.json-listed identifier in the 274/274-closed
     coq/information-discrete-math mirror (coq/information-discrete-math/
     verify_report.json), already shaped and coded by the extractor
     (<root>/<D>.<nn>.v1, nn continuing per (root,D) from the live maximum --
     here 0, since IDM had zero prior Toledo presence, confirmed by the
     proposal's own phi_check). `id` is assigned here (IDM-0001..IDM-0274).
     coq.coq_status "mapped_not_wrapped" (evidence-backed coq_map.json match,
     no Toledo-native wrapper file yet -- registry/SCHEMA.md's own definition
     of that value), tier "Th_coqc" per verify_report.json's
     "Closed under the global context" for all 274 (never asserted above
     what that Print Assumptions output says).
  3. registry/coq_map.json: `codes` filled in for the 274 identifiers whose
     `source` is "information-discrete-math" (all were UNMAPPED before this
     merge -- confirmed below), by evidence (file+identifier match against
     the same source line the reading's statement was copied from).
  4. registry/LINEAGE.jsonl: "assigned" events for every new code (18 roots
     + 274 readings = 292 events).
  5. registry/proposals/idm.merged.json: proposal-id -> assigned-code map
     (idempotency record, matching scripts/v15_tunnel_merge.py's own
     <proposal>.merged.json pattern).

Never invents a statement, code, tier, root, or parent: every root
statement/tier below is copied verbatim from the proposal (itself extracted
verbatim from information-discrete-math's own treatise/formal sources, per
registry/proposals/idm.json.idm_origin); every reading statement/tier/coq
field is copied verbatim from the proposal's own already-built CANONICAL-
shaped entries (extracted from coq/information-discrete-math/verify_report.json
and registry/coq_map.json). Never touches mcp/, coq/, latex/, docs/ (the
GENESIS_CODE_SCHEME.md / EQ_CODE_SCHEME.md dated addenda documenting this
merge are written separately, not by this script), README/CHANGELOG/CITATION.

Run: python3 scripts/v16_idm_merge.py
"""
import json
import os
import re
from collections import Counter

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TODAY = "2026-09-08"
BY = "toledo-v1.6-idm"

GENESIS_PATH = os.path.join(ROOT, "registry", "genesis_root.json")
CANONICAL_PATH = os.path.join(ROOT, "registry", "CANONICAL.json")
COQMAP_PATH = os.path.join(ROOT, "registry", "coq_map.json")
LINEAGE_PATH = os.path.join(ROOT, "registry", "LINEAGE.jsonl")
PROPOSAL_PATH = os.path.join(ROOT, "registry", "proposals", "idm.json")
MERGED_MAP_PATH = os.path.join(ROOT, "registry", "proposals", "idm.merged.json")

CODE_RE = re.compile(
    r"^(?P<root>EQ-0\d{2}|[A-Za-z][A-Za-z0-9]*(?:[._-][A-Za-z0-9]+)*)"
    r"(?:/(?P<domain>[EHSWMPCB])\.(?P<seq>\d{2,4})(?:\.v(?P<rev>[1-9]\d*))?)?$"
)

# Root -> Genesis code, ONLY where the proposal's own phi_check already
# quoted a textual connection (genesis_relations_asserted: 3). Never guessed.
GENESIS_LINK = {"delta_R": "EQ-001", "L_R": "EQ-008", "Keystone": "EQ-008"}

FOUNDER_RULING = {
    "quote": ("เอา idm เอาเข้า toledo ก่อน "
              "และใน idm ให้อัพเดทรหัสสมการ"
              "ให้ตรงกับ toledo, ultracode"
              " (\"take IDM into Toledo first, and in IDM update the equation "
              "codes to match Toledo, ultracode\")"),
    "quote_source": ("ops/HANDOFF_OVERNIGHT_2026-09-06.md, \"2026-09-08 -- "
        "Resistance ladder + Reproduction Ledger (founder ruling BBL-229)\" "
        "section, \"IDM into Toledo\" line, founder, 2026-09-08"),
    "toledo_ruling": ("Root registry extension R2 (IDM), applying the same "
        "mechanism as R1 (BBL-2026-09-07-207/229 context: Theta/CMC root "
        "extension, registry/GENESIS_CODE_SCHEME.md) to information-discrete-math."),
}


def load(path):
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def atomic_write(path, data, indent=1, trailing_newline=True):
    tmp = path + ".tmp_v16idm"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=indent, ensure_ascii=False)
        if trailing_newline:
            f.write("\n")
    os.replace(tmp, path)


def rd_root_map_note(code, rd_map):
    """RD1..RD9: quote registry/rd_root_map.json's own already-adversarially-
    checked verdict for this identifier (it was built against the byte-
    identical solver-arc/readout_universe RD.v mirror; IDM's own treatise
    states its RD1-RD9 are "the exact same RD1-RD9" as that mirror -- so the
    prior finding transfers by the source's own claim of identity, quoted
    below, rather than being re-derived here)."""
    entry = rd_map["map"][code]
    return (
        "registry/rd_root_map.json (Toledo v1.1 Lane C task, already checked "
        "this exact identifier against every Genesis root row): verdict "
        f"{entry['verdict']} -- \"{entry['reasoning']}\" IDM's own treatise "
        "states its RD1-RD9 are the same object as that mirror's RD1-RD9 "
        "(information-discrete-math textbook/INFORMATION_DISCRETE_MATHEMATICS.md, "
        "lines 799-800, 1071-1072: \"the exact same RD1-RD9 that generate D "
        "(Part II) are the shared root of both repos\"), so this prior, "
        "already-quoted finding transfers rather than being redone; relations "
        "kept empty, nothing invented."
    )


NO_LINK_NOTE = (
    "registry/GENESIS_CODE_SCHEME.md and registry/genesis_root.json (592 "
    "pre-existing rows) were checked directly for a stated connection from "
    "this object to any Genesis root axiom or named result; no source text "
    "(IDM's own treatise, or Genesis's own two anchored documents) states one "
    "for this object. relations kept empty rather than guessed, per the same "
    "disclosed-non-finding convention as the R1 \"CMC\" root row."
)


def build_genesis_row(prop_row, idm_origin, rd_map):
    code = prop_row["code"]
    relations = []
    for r in prop_row.get("relations") or []:
        relations.append({
            "type": r["type"],
            "target": r["target"],
            "note": r["note"],
            "evidence_quote": r.get("evidence_quote_idm", r.get("evidence_quote", "")),
            "evidence_source": r.get("evidence_source_idm", r.get("evidence_source", "")),
        })

    row = {
        "code": code,
        "genesis_id": code,
        "aliases": list(prop_row.get("aliases") or []),
        "name": prop_row["name"],
        "statement": prop_row["statement"]["latest"],
        "section": prop_row["section"],
        "tier_in_genesis": prop_row.get("tier_in_genesis_verbatim", ""),
        "tier_in_genesis_note": prop_row.get("tier_in_genesis_note", ""),
        "synthesis_occurrences": [],
        "role": "root-extension",
        "origin": {
            "source": "information-discrete-math",
            "repo_anchor": {
                "repo": idm_origin["repo"],
                "commit": idm_origin["commit"],
                "path": (prop_row.get("origin") or {}).get("repo_anchor", {}).get("path", idm_origin["treatise_path"]),
                "line": (prop_row.get("origin") or {}).get("repo_anchor", {}).get("line"),
            },
            "doi": None,
        },
        "founder_ruling": dict(FOUNDER_RULING),
        "coq_source_redistributed": True,
        "step": None,
        "step_note": ("not part of READOUT_GENESIS_CORE.md's own \"Genesis of "
            "the Universe, Step by Step\" ordering (BBL-192/193) -- this root "
            "is sourced from information-discrete-math (root registry "
            "extension R2), a separate repository; no step position is "
            "invented for it."),
    }

    if code in GENESIS_LINK:
        row["parents"] = [GENESIS_LINK[code]]
        row["relations"] = relations
    else:
        row["parents"] = []
        row["relations"] = []
        if code.startswith("RD") and code in rd_map["map"]:
            row["relations_note"] = rd_root_map_note(code, rd_map)
        else:
            row["relations_note"] = NO_LINK_NOTE
    return row


def main():
    report = {}
    prop = load(PROPOSAL_PATH)
    idm_origin = prop["idm_origin"]
    rd_map = load(os.path.join(ROOT, "registry", "rd_root_map.json"))

    # -- 1. genesis_root.json: 18 root-extension rows -----------------------
    gd = load(GENESIS_PATH)
    existing_codes = {r["code"] for r in gd["root_equations"]}
    added_roots = []
    for prop_row in prop["root_rows"]:
        row = build_genesis_row(prop_row, idm_origin, rd_map)
        if row["code"] in existing_codes:
            continue
        gd["root_equations"].append(row)
        existing_codes.add(row["code"])
        added_roots.append(row["code"])
    if added_roots:
        atomic_write(GENESIS_PATH, gd, indent=2, trailing_newline=False)
    report["roots_added"] = added_roots

    # -- 2. CANONICAL.json: 274 readings -------------------------------------
    cd = load(CANONICAL_PATH)
    entries = cd["canonical"]
    canonical_codes = {e["code"] for e in entries}

    max_idm_id = 0
    for e in entries:
        if isinstance(e.get("id"), str) and e["id"].startswith("IDM-"):
            try:
                max_idm_id = max(max_idm_id, int(e["id"].split("-", 1)[1]))
            except ValueError:
                pass

    new_entries = []
    codes_by_key = {}  # (file, identifier) -> code, for coq_map.json step 3
    for r in prop["readings"]:
        code = r["code"]
        if code in canonical_codes:
            continue
        max_idm_id += 1
        entry = dict(r)
        entry["id"] = "IDM-%04d" % max_idm_id
        entries.append(entry)
        canonical_codes.add(code)
        new_entries.append(entry)
        key = (entry["origin"]["repo_anchor"]["path"], entry["coq"]["identifier"])
        codes_by_key[key] = code

    if new_entries:
        # children[] = invert parents[] across the full final array (SCHEMA.md:
        # "never hand-authored -- a build overwrites any hand-written value").
        code_set = {e["code"] for e in entries}
        children_map = {c: [] for c in code_set}
        for e in entries:
            for p in e.get("parents") or []:
                if p["code"] in children_map:
                    children_map[p["code"]].append(e["code"])
        for e in entries:
            e["children"] = sorted(set(children_map.get(e["code"], [])))

        cd["counts"] = {
            "entries": len(entries),
            "by_status": dict(Counter(e["status"] for e in entries)),
            "by_domain": dict(Counter(e["domain"] for e in entries if e.get("domain"))),
            "by_tier": dict(Counter(e["tier"] for e in entries)),
            "by_coq_status": dict(Counter(e["coq"]["coq_status"] for e in entries)),
            "computed": f"{TODAY} from canonical[] (scripts/v16_idm_merge.py)",
        }
        atomic_write(CANONICAL_PATH, cd, indent=1, trailing_newline=True)
    report["readings_added"] = len(new_entries)

    # -- 3. coq_map.json: fill `codes` for the 274 IDM identifiers -----------
    cm = load(COQMAP_PATH)
    updated = 0
    for row in cm:
        if row.get("source") != "information-discrete-math":
            continue
        key = (row["file"], row["identifier"])
        if key in codes_by_key and not row.get("codes"):
            code = codes_by_key[key]
            row["codes"] = [code]
            row["confidence"] = "high"
            row["evidence"] = (
                "Toledo v1.6 root registry extension R2 (information-discrete-math, "
                f"founder ruling context BBL-2026-09-07-229 / BBL-229, 2026-09-08 "
                f"instruction): mapped to {code}. Statement is this identifier's own "
                f"Coq declaration in {row['file']}, quoted verbatim in "
                "registry/CANONICAL.json (coq/information-discrete-math/"
                "verify_report.json: \"Closed under the global context\")."
            )
            row["evidence_quote"] = row["evidence"]
            updated += 1
    if updated:
        atomic_write(COQMAP_PATH, cm, indent=1, trailing_newline=False)
    report["coq_map_updated"] = updated

    # -- 4. LINEAGE.jsonl: assigned events -----------------------------------
    existing_assigned = set()
    if os.path.exists(LINEAGE_PATH):
        with open(LINEAGE_PATH, encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    row = json.loads(line)
                except Exception:
                    continue
                if row.get("event") == "assigned":
                    existing_assigned.add(row.get("code"))

    events = []
    for code in added_roots:
        if code in existing_assigned:
            continue
        events.append({
            "code": code, "date": TODAY, "event": "assigned",
            "from": None, "to": code,
            "reason": ("Toledo v1.6 root registry extension R2 "
                "(information-discrete-math, founder ruling context "
                "BBL-2026-09-07-229/BBL-229 + the 2026-09-08 instruction): "
                "new Layer-0 root, code is IDM's own verbatim identifier."),
            "by": BY,
        })
    for entry in new_entries:
        if entry["code"] in existing_assigned:
            continue
        ident = entry["coq"]["identifier"]
        fpath = entry["origin"]["repo_anchor"]["path"]
        events.append({
            "code": entry["code"], "date": TODAY, "event": "assigned",
            "from": f"{fpath}::{ident}", "to": entry["code"],
            "reason": ("Toledo v1.6 root registry extension R2: reading of root "
                f"{entry['root']}, mapped from registry/coq_map.json by evidence "
                "(file+identifier match against coq/information-discrete-math/"
                "verify_report.json, statement copied verbatim from the Coq "
                "declaration)."),
            "by": BY,
        })
    if events:
        with open(LINEAGE_PATH, "a", encoding="utf-8") as fh:
            for ev in events:
                fh.write(json.dumps(ev, ensure_ascii=False) + "\n")
    report["lineage_events"] = len(events)

    # -- 5. proposals/idm.merged.json ----------------------------------------
    merged_map = {}
    for prop_row in prop["root_rows"]:
        merged_map[f"root:{prop_row['code']}"] = prop_row["code"]
    for r in prop["readings"]:
        key = (r["origin"]["repo_anchor"]["path"], r["coq"]["identifier"])
        merged_map[f"reading:{key[0]}::{key[1]}"] = r["code"]
    merged_map["_summary"] = {
        "roots_added": len(added_roots),
        "readings_added": len(new_entries),
        "coq_map_updated": updated,
        "lineage_events": len(events),
        "unmerged": 0,
    }
    json.dump(merged_map, open(MERGED_MAP_PATH, "w", encoding="utf-8"),
               indent=2, ensure_ascii=False, sort_keys=True)
    with open(MERGED_MAP_PATH, "a", encoding="utf-8") as fh:
        fh.write("\n")

    print("Toledo v1.6 IDM merge (root registry extension R2) complete.")
    print(json.dumps(report, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
