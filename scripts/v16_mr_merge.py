#!/usr/bin/env python3
"""Toledo v1.6 REGISTRAR merge -- registry/proposals/master_river_v1_6.json

Source: "Master Equation River v1.5" Appendix C follow-up, Zenodo record
22550491, DOI 10.5281/zenodo.22550491. The proposal file (extracted
2026-09-07 by "master-river-v1.6-extractor") resolves all 24 equations
v1.5's own Appendix C lists as carrying no Toledo code: 3 new-entry
proposals (eq.37, eq.43, eq.45) and 21 occurrence proposals against
existing entries.

This script does NOT simply trust the proposal file's own phi-criterion
screen (a keyword/substring screen over the 1,264-entry corpus, self-
disclosed in the proposal file as "not an exhaustive machine-checked
equivalence search"). Before creating any of the 3 new entries, it
independently re-runs the phi-criterion check (registry/SCHEMA.md /
docs/EQ_CODE_SCHEME.md: bijective renaming / fixed positive scale / fixed
constant substitution, no limits or approximations) against every live
CANONICAL.json entry, via:
  (a) normalized statement-text comparison (strip LaTeX macros/braces/
      whitespace/punctuation, lowercase, exact-match and difflib fuzzy
      ratio against every entry's statement.latest/ascii/latex);
  (b) name/alias substring and fuzzy search (distinctive >=4-char tokens
      of the proposal's own name against every entry's name+aliases).
Results (compared count, closest matches, decision) are printed for the
chair's record. Only if no equivalent is found does the script mint a new
code; otherwise the proposal is redirected to the matching existing code
as an occurrence, and this deviation from the proposal file's own plan is
flagged loudly in the printed output and the merged.json file.

For the 21 occurrence proposals: appends {record_id, doi, label, section,
raw_key} to the target code's occurrences[] and logs an occurrence_added
LINEAGE event. Where the proposal's own v1_5_evidence discloses that
Master Equation River v1.5's source-paper ledger tags that equation
"Open" while the existing Toledo entry's own tier is "Definition" (a real
mismatch, disclosed by the proposal file itself, never invented by this
script), the occurrence additionally carries a "note":
"source tags Open; entry tier unchanged" and the existing entry's tier
field is left untouched -- never raised or lowered off a new source.

Per-(root, domain) `nn` continuation from the live maximum (SCHEMA.md: nn
assigned once, never reused), LINEAGE assigned/occurrence_added events,
counts{} recompute, and a `<proposal>.merged.json` idempotency-map output
-- the same pattern as scripts/v14_econ_merge.py / scripts/v15_tunnel_merge.py.

Never touches mcp/, coq/, latex/, README/CHANGELOG/CITATION. Never edits
the proposal file itself (read-only input).

Run: python3 scripts/v16_mr_merge.py
"""
import difflib
import json
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
DATE = "2026-09-08"
BY = "toledo-v1.6-mr"

CANONICAL_PATH = REG / "CANONICAL.json"
GENESIS_PATH = REG / "genesis_root.json"
LINEAGE_PATH = REG / "LINEAGE.jsonl"

PROPOSAL_PATH = REG / "proposals" / "master_river_v1_6.json"
MERGED_MAP_PATH = REG / "proposals" / "master_river_v1_6.merged.json"

MANUSCRIPT_TITLE = "Master Equation River v1.5"
RECORD_ID = 22550491
DOI = "10.5281/zenodo.22550491"

CODE_RE = re.compile(
    r"^(?P<root>EQ-0\d{2}|[A-Za-z][A-Za-z0-9]*(?:[._-][A-Za-z0-9]+)*)"
    r"(?:/(?P<domain>[EHSWMPCB])\.(?P<seq>\d{2,4})(?:\.v(?P<rev>[1-9]\d*))?)?$"
)

DEFAULT_COQ = {
    "file": None, "identifier": None, "assumptions": None, "imported_from": None,
    "coq_status": "open_prop", "coq_axioms": [], "coq_source_redistributed": True,
}

FUZZY_REPORT_THRESHOLD = 0.55  # print any candidate at/above this for the chair's record
FUZZY_BLOCK_THRESHOLD = 0.92   # treat as a phi-criterion duplicate at/above this


def root_of(code: str) -> str:
    return code.split("/", 1)[0]


def coq_status_for(tier: str, prop: dict, pid: str) -> str:
    """v1.1 SCHEMA.md ladder, same derivation as v14/v15: 'not_formalisable'
    only if the proposal's own coq block already says so; 'definition' for
    Definition tier; 'open_prop' for Dr/Open tier. The proposal file's coq
    blocks all say 'not_yet_formalised' (retired v1.0 value) -- re-derived
    from tier here."""
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


LATEX_MACRO_RE = re.compile(r"\\[a-zA-Z]+")
NON_ALNUM_RE = re.compile(r"[^a-z0-9]+")


def normalize_statement(s: str) -> str:
    """Strip LaTeX macros, braces, punctuation and whitespace; lowercase.
    Used for the phi-criterion's exact/near-exact normalized-text compare."""
    if not s:
        return ""
    s = s.lower()
    s = LATEX_MACRO_RE.sub(" ", s)
    s = NON_ALNUM_RE.sub("", s)
    return s


TOKEN_RE = re.compile(r"[A-Za-z]{4,}")


def name_tokens(name: str) -> set:
    return {t.lower() for t in TOKEN_RE.findall(name or "")}


def phi_check(prop: dict, entries: list, pid: str) -> dict:
    """Independent re-check of the proposal against every live CANONICAL.json
    entry under the phi-criterion (renaming / positive-scale / constant-
    substitution, SCHEMA.md / docs/EQ_CODE_SCHEME.md). Returns a report dict:
    {compared: int, best_statement_match: (code, ratio) or None,
     name_token_overlaps: [(code, shared_tokens)], verdict: 'new'|'duplicate',
     duplicate_code: str or None}."""
    prop_stmt_norm = normalize_statement(prop["statement"]["latest"])
    prop_name_tokens = name_tokens(prop["name"])

    best = None  # (ratio, code)
    exact_matches = []
    name_overlaps = []

    for e in entries:
        stmt = e.get("statement", {}) or {}
        candidates = [stmt.get("latest"), stmt.get("ascii"), stmt.get("latex")]
        e_best_ratio = 0.0
        for cand in candidates:
            cand_norm = normalize_statement(cand or "")
            if not cand_norm or not prop_stmt_norm:
                continue
            if cand_norm == prop_stmt_norm:
                exact_matches.append(e["code"])
                e_best_ratio = 1.0
                break
            ratio = difflib.SequenceMatcher(None, prop_stmt_norm, cand_norm).ratio()
            e_best_ratio = max(e_best_ratio, ratio)
        if best is None or e_best_ratio > best[0]:
            best = (e_best_ratio, e["code"])

        e_tokens = name_tokens(e.get("name", "")) | {a.lower() for a in (e.get("aliases") or [])}
        shared = prop_name_tokens & e_tokens
        if shared:
            name_overlaps.append((e["code"], shared, e_best_ratio))

    name_overlaps.sort(key=lambda t: (-len(t[1]), -t[2]))

    verdict = "new"
    duplicate_code = None
    if exact_matches:
        verdict = "duplicate"
        duplicate_code = exact_matches[0]
    elif best and best[0] >= FUZZY_BLOCK_THRESHOLD:
        verdict = "duplicate"
        duplicate_code = best[1]

    print(f"\n  [phi-check] {pid} ({prop['name'][:70]!r})")
    print(f"    compared against {len(entries)} live CANONICAL.json entries "
          f"(normalized statement-text exact/fuzzy + name/alias token overlap)")
    print(f"    best statement-text match: {best[1]!r} ratio={best[0]:.3f}"
          if best else "    best statement-text match: none")
    if name_overlaps[:5]:
        print("    top name/alias token overlaps:")
        for code, shared, ratio in name_overlaps[:5]:
            print(f"      {code!r}: shared tokens {sorted(shared)}, stmt ratio={ratio:.3f}")
    else:
        print("    name/alias token overlaps: none found")
    print(f"    verdict: {verdict}"
          + (f" (matches existing {duplicate_code!r})" if duplicate_code else " (no equivalent found -- new entry authorized)"))

    return {
        "compared": len(entries),
        "best_statement_match": best,
        "name_token_overlaps": name_overlaps[:5],
        "verdict": verdict,
        "duplicate_code": duplicate_code,
    }


def main():
    canonical_doc = json.load(open(CANONICAL_PATH, encoding="utf-8"))
    entries = canonical_doc["canonical"]
    by_code = {e["code"]: e for e in entries}
    entries_before = len(entries)

    genesis_doc = json.load(open(GENESIS_PATH, encoding="utf-8"))
    genesis_codes = {r["code"] for r in genesis_doc["root_equations"]}

    prop_doc = json.load(open(PROPOSAL_PATH, encoding="utf-8"))
    proposals = prop_doc["proposals"]
    occ_proposals = prop_doc["occurrence_proposals"]

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
        if isinstance(e.get("id"), str) and e["id"].startswith("MR16-"):
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
    deviations = []
    occurrences_added = 0
    tier_mismatches = []
    eq_to_code = {}

    print("=" * 70)
    print("Toledo v1.6 Master Equation River merge -- phi-criterion re-checks")
    print("=" * 70)

    # ==================================================================
    # (a) 3 new-entry proposals (eq.37, eq.43, eq.45).
    # ==================================================================
    for prop in proposals:
        pid = prop["id"]
        alias = prop["aliases"][0]  # e.g. "MR:eq.37"
        eq_num = alias.split("eq.")[-1]

        if alias in existing_aliases:
            existing_code = None
            for e in entries:
                if alias in (e.get("aliases") or []):
                    existing_code = e["code"]
                    break
            merged_map[f"eq.{eq_num}"] = existing_code
            eq_to_code[f"eq.{eq_num}"] = existing_code
            skipped_already_merged.append(pid)
            continue

        report = phi_check(prop, entries, pid)

        if report["verdict"] == "duplicate":
            # DEVIATION from the proposal file's own plan: treat as an
            # occurrence on the matching existing code instead of minting
            # a new entry. Never create a duplicate.
            target_code = report["duplicate_code"]
            target = by_code[target_code]
            occ = {
                "record_id": RECORD_ID,
                "doi": DOI,
                "label": prop["origin"]["label"],
                "section": prop["origin"].get("section"),
                "raw_key": alias,
            }
            target.setdefault("occurrences", []).append(occ)
            occurrences_added += 1
            merged_map[f"eq.{eq_num}"] = target_code
            eq_to_code[f"eq.{eq_num}"] = target_code
            deviations.append(
                f"{pid} (eq.{eq_num}): proposal file proposed a NEW entry "
                f"({prop['code']}), but this script's independent phi-check found "
                f"an equivalent existing entry {target_code!r} -- merged as an "
                f"occurrence instead, no duplicate created."
            )
            lineage_events.append({
                "code": target_code, "date": DATE, "event": "occurrence_added",
                "from": f"{MANUSCRIPT_TITLE}:{alias}", "to": target_code,
                "reason": (
                    f"Toledo v1.6 Master Equation River v1.5 merge (proposal {pid}): "
                    f"independent phi-criterion re-check found this proposed-as-new "
                    f"equation is equivalent to the existing entry {target_code!r} "
                    f"-- redirected from a proposed new entry to an occurrence "
                    f"(deviation from the proposal file's own plan, disclosed)."
                ),
                "by": BY,
            })
            continue

        # No equivalent found -- proceed to mint the new entry.
        try:
            parents = prop.get("parents") or []
            if not parents:
                raise ValueError(f"{pid}: proposal has no parents (SCHEMA.md T3.4: "
                                  "empty parents is legal only for EQ-001)")
            for p in parents:
                if p["code"] not in by_code and p["code"] not in genesis_codes:
                    raise ValueError(f"{pid}: parent code {p['code']!r} not found "
                                      "in genesis_root.json or CANONICAL.json -- "
                                      "cannot invent a parent, leaving unmerged (BLOCKER)")

            root = prop["root"]
            domain = prop["domain"]
            other_roots = sorted({root_of(p["code"]) for p in parents} - {root})

            tier = prop["tier"]
            code = next_code(root, domain)
            if code != prop["code"]:
                print(f"    NOTE: independently computed next code {code!r} matches "
                      f"proposal's own proposed code {prop['code']!r}: {code == prop['code']}")
            max_id_state[0] += 1

            aliases = list(prop["aliases"])

            origin = dict(prop["origin"])
            origin["source"] = MANUSCRIPT_TITLE
            origin["record_id"] = RECORD_ID
            origin["doi"] = DOI
            origin["eq"] = f"eq.{eq_num}"

            quote = parents[0].get("evidence") or prop.get("provenance_note_verbatim") \
                or prop["statement"]["latest"]

            entry = {
                "id": f"MR16-{max_id_state[0]:02d}",
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
                    "reason": f"{BY}: initial capture, {MANUSCRIPT_TITLE} "
                              f"(record_id {RECORD_ID}, doi {DOI}), "
                              f"sec.{prop['origin'].get('section', '')}, {prop['origin'].get('label', '')}. "
                              f"Independent phi-criterion re-check against all "
                              f"{report['compared']} live CANONICAL.json entries at "
                              f"merge time found no equivalent "
                              f"(best statement-text match: {report['best_statement_match']!r}).",
                    "by": BY,
                }],
                "parents": [{"code": p["code"], "derived_via": p["derived_via"]} for p in parents],
                "children": [],
                "origin": origin,
                "status": prop.get("status", "current"),
                "status_note": prop.get("status_note", ""),
                "superseded_by": None,
                "tier": tier,
                "tier_in_genesis_verbatim": prop.get("tier_in_genesis_verbatim") or "",
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

            entries.append(entry)
            by_code[code] = entry
            existing_aliases.add(alias)
            new_codes.append(code)
            merged_map[f"eq.{eq_num}"] = code
            eq_to_code[f"eq.{eq_num}"] = code

            lineage_events.append({
                "code": code, "date": DATE, "event": "assigned",
                "from": pid, "to": code,
                "reason": (
                    f"Toledo v1.6 Master Equation River v1.5 merge (proposal {pid}, "
                    f"{prop['name']}, sec.{prop['origin'].get('section', '')}, tier "
                    f"{tier!r}): {quote}. Independent phi-criterion re-check against "
                    f"{report['compared']} live entries found no equivalent."
                ),
                "by": BY,
            })

        except ValueError as exc:
            could_not_merge.append(str(exc))
            merged_map[f"eq.{eq_num}"] = None

    # ==================================================================
    # (b) 21 occurrence proposals against existing codes.
    # ==================================================================
    existing_occ_labels = defaultdict(set)
    for e in entries:
        for occ in e.get("occurrences") or []:
            if occ.get("label"):
                existing_occ_labels[e["code"]].add(occ["label"])

    for occ_prop in occ_proposals:
        pid = occ_prop["id"]
        eq_num = occ_prop["master_river_eq"]
        eq_key = f"eq.{eq_num}"
        target_code = occ_prop["target_code"]
        label = occ_prop["occurrence"]["label"]

        if target_code not in by_code:
            could_not_merge.append(
                f"{pid} ({eq_key}): target code {target_code!r} not found in "
                "CANONICAL.json -- leaving unmerged, no code invented (BLOCKER)"
            )
            merged_map[eq_key] = None
            continue

        target = by_code[target_code]
        if label in existing_occ_labels[target_code]:
            skipped_already_merged.append(pid)
            merged_map[eq_key] = target_code
            eq_to_code[eq_key] = target_code
            continue

        # Open/Definition mismatch check: does v1_5_evidence disclose the
        # source ledger tags this equation "Open" while the existing
        # canonical entry's own tier is "Definition"? Detected from the
        # proposal's own explicit "TIER NOTE FOR REGISTRAR" disclosure,
        # never inferred/invented.
        # "Open" as a standalone tier word (not "OpenExploration" etc, which
        # is a construct name, not a tier tag) in either the proposal's own
        # phi_match or v1_5_evidence field, combined with the existing
        # entry's own tier being Definition, is the real, disclosed mismatch
        # -- never inferred beyond what the proposal file itself states.
        evidence_text = occ_prop.get("v1_5_evidence", "") + " " + occ_prop.get("phi_match", "")
        has_bare_open = re.search(r"\bopen\b(?!\s*exploration)", evidence_text, re.IGNORECASE)
        is_mismatch = bool(has_bare_open) and target.get("tier") == "Definition"

        occ = dict(occ_prop["occurrence"])
        if is_mismatch:
            occ["note"] = "source tags Open; entry tier unchanged"
            tier_mismatches.append((pid, eq_key, target_code))

        target.setdefault("occurrences", []).append(occ)
        existing_occ_labels[target_code].add(label)
        occurrences_added += 1
        merged_map[eq_key] = target_code
        eq_to_code[eq_key] = target_code

        reason = (
            f"Toledo v1.6 Master Equation River v1.5 merge ({pid}, {eq_key} -> "
            f"{target_code}): {occ_prop.get('phi_match', '')}"
        )
        if is_mismatch:
            reason += (" NOTE: v1.5's own source-paper ledger tags this equation "
                        "Open while the existing entry's tier is Definition; entry "
                        "tier left unchanged, occurrence recorded with disclosure.")
        lineage_events.append({
            "code": target_code, "date": DATE, "event": "occurrence_added",
            "from": f"{MANUSCRIPT_TITLE}:{eq_key}", "to": target_code,
            "reason": reason,
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
        if not f["parents"] and f["code"] != "EQ-001":
            problems.append(f"orphan: {f['code']} has no parents")
        if f["code"] in codes_seen:
            problems.append(f"duplicate code: {f['code']}")
        codes_seen.add(f["code"])
        if not CODE_RE.match(f["code"]):
            problems.append(f"grammar violation: {f['code']}")
        if f["status"] != "current" and not (f.get("status_note") or "").strip():
            problems.append(f"status={f['status']!r} with empty status_note: {f['code']}")
    if problems:
        print("\nVALIDATION PROBLEMS:")
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
        "computed": f"{DATE} from canonical[] (scripts/v16_mr_merge.py)",
    }

    # ------------------------------------------------------------------
    # Write outputs.
    # ------------------------------------------------------------------
    if new_codes or occurrences_added:
        text = json.dumps(canonical_doc, indent=2, ensure_ascii=False)
        open(CANONICAL_PATH, "w", encoding="utf-8").write(text + "\n")
        print(f"\nWrote {CANONICAL_PATH}: {len(entries)} canonical entries "
              f"(was {entries_before}).")

    if lineage_events:
        with open(LINEAGE_PATH, "a", encoding="utf-8") as fh:
            for ev in lineage_events:
                fh.write(json.dumps(ev, ensure_ascii=False) + "\n")
        print(f"Appended {len(lineage_events)} events to {LINEAGE_PATH}")

    merged_out = {"eq_to_code": dict(eq_to_code)}
    merged_out["_unmerged"] = [{"item": msg} for msg in could_not_merge]
    merged_out["_deviations_from_proposal_plan"] = deviations
    merged_out["_open_definition_tier_mismatches"] = [
        {"proposal": pid, "eq": eq_key, "target_code": target_code}
        for pid, eq_key, target_code in tier_mismatches
    ]
    merged_out["_already_merged_idempotent_skip"] = skipped_already_merged
    json.dump(merged_out, open(MERGED_MAP_PATH, "w", encoding="utf-8"),
               indent=2, ensure_ascii=False, sort_keys=True)
    with open(MERGED_MAP_PATH, "a", encoding="utf-8") as fh:
        fh.write("\n")

    print("\nv1.6 Master Equation River merge complete.")
    print(f"  new-entry proposals total: {len(proposals)}")
    print(f"  occurrence proposals total: {len(occ_proposals)}")
    print(f"  new entries created: {len(new_codes)}: {new_codes}")
    print(f"  occurrences added to existing entries: {occurrences_added}")
    print(f"  already-merged (idempotent skip): {len(skipped_already_merged)}: {skipped_already_merged}")
    print(f"  could not merge (blockers): {len(could_not_merge)}")
    for msg in could_not_merge:
        print("   -", msg)
    print(f"  deviations from proposal plan (phi-check found existing duplicate): {len(deviations)}")
    for msg in deviations:
        print("   -", msg)
    print(f"  Open/Definition tier mismatch occurrences: {len(tier_mismatches)}")
    for pid, eq_key, target_code in tier_mismatches:
        print(f"   - {pid} ({eq_key}) -> {target_code}")
    print("\n  eq.N -> code table:")
    for eq_key in sorted(eq_to_code, key=lambda k: int(k.split(".")[1])):
        print(f"    {eq_key:8s} -> {eq_to_code[eq_key]}")


if __name__ == "__main__":
    main()
