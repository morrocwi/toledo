#!/usr/bin/env python3
"""Toledo v1.3 REGISTRAR merge -- registry/proposals/effort_v0_3.json.

Merges the 34 proposals extracted from "Effort Across Stochastic, Controlled,
and Adaptive Worlds v0.3" (Zenodo record 22622206, DOI 10.5281/zenodo.22622206)
into registry/CANONICAL.json and registry/LINEAGE.jsonl.

Per the proposal file's own extractor_note, a phi-criterion screen already
found no existing CANONICAL.json entry structurally equivalent to any of the
34 proposals -- but that screen is disclosed as a keyword/manual scan, not an
exhaustive check. This REGISTRAR pass re-runs its own phi-criterion test
(normalized-statement equality within the same (root, domain) pair, the same
heuristic proxy scripts/n4_merge.py used) before accepting any proposal as a
genuinely new object:

  (1) phi-equivalent occurrence: if a proposal's statement normalizes to an
      exact match of an existing entry's statement.latest within the same
      (root, domain), the proposal is NOT a new object -- append its
      occurrence {record_id: 22622206, label: "eq.N"} to the existing entry
      and log a LINEAGE occurrence_added event. No new code is assigned.

  (2) new entry: otherwise, assign the next `nn` for (root, domain),
      continuing the existing maximum found in registry/CANONICAL.json
      (never reusing a retired number -- retired/split/superseded entries
      keep their code in canonical[], so they are already counted). Build a
      full SCHEMA.md-shaped entry: statement {latest, format: "latex"}; tier
      exactly as proposed (never raised); status "current"; parents exactly
      as proposed (each parent code checked to exist in genesis_root.json or
      CANONICAL.json -- abort if not); origin quoting record_id/doi/section/
      page/label; aliases ["Effort-v0.3:eq.N"]; occurrences
      [{record_id, label: "eq.N"}]; coq.coq_status resolved off the current
      ladder (SCHEMA.md v1.1 addendum) -- "definition" for a
      NEW DOMAIN DEFINITION (tier Definition), "open_prop" for an unproved
      proposition/derivation/non-collapse/synthesis (tier Dr), or
      "not_formalisable" only if the proposal itself says so; a LINEAGE
      "assigned" event quoting the proposal's own provenance_note_verbatim.

  (3) multi-root proposals (parents spanning more than one root): primary
      root = the first parent's own root; the remaining roots are recorded
      in the entry's own `reads_also` list (EQ_CODE_SCHEME.md: "A reading of
      a composite names the primary root and lists reads_also").

  (4) top-level counts{} is recomputed from canonical[] exactly as
      scripts/v12_R.py's recompute_canonical_counts() does.

  (5) registry/proposals/effort_v0_3.merged.json is written, mapping every
      proposal id to the final code it resolved to (existing code for an
      occurrence merge, new code for a new entry).

Idempotent: an alias "Effort-v0.3:eq.N" already present anywhere in
CANONICAL.json (as a new entry's own alias) or an occurrence with that label
already recorded against record_id 22622206 (the occurrence-merge path) means
this proposal was already merged -- it is skipped, not re-added, on any
re-run.

Never touches mcp/, coq/, latex/, README/CHANGELOG/CITATION -- only
registry/CANONICAL.json, registry/LINEAGE.jsonl, and (new) registry/
proposals/effort_v0_3.merged.json.

Run: python3 scripts/v13_effort_merge.py
"""
import json
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
DATE = "2026-09-07"
BY = "toledo-v1.3-effort"

CANONICAL_PATH = REG / "CANONICAL.json"
GENESIS_PATH = REG / "genesis_root.json"
LINEAGE_PATH = REG / "LINEAGE.jsonl"
PROPOSALS_PATH = REG / "proposals" / "effort_v0_3.json"
MERGED_MAP_PATH = REG / "proposals" / "effort_v0_3.merged.json"

CODE_RE = re.compile(
    r"^(?P<root>EQ-0\d{2}|[A-Za-z][A-Za-z0-9]*(?:[._-][A-Za-z0-9]+)*)"
    r"(?:/(?P<domain>[EHSWMPCB])\.(?P<seq>\d{2,4})(?:\.v(?P<rev>[1-9]\d*))?)?$"
)

DEFAULT_COQ = {
    "file": None, "identifier": None, "assumptions": None, "imported_from": None,
    "coq_status": "open_prop", "coq_axioms": [], "coq_source_redistributed": True,
}


def norm_stmt(s: str) -> str:
    """Normalized-string equality proxy for the phi-criterion (renaming /
    positive scale / constant substitution, exact -- SCHEMA.md /
    GENESIS_CODE_SCHEME.md). Same heuristic scripts/n4_merge.py uses: exact
    match after unicode/whitespace normalization, not a certified symbolic
    equivalence checker."""
    if not s:
        return ""
    repl = {
        "−": "-", "‐": "-", "–": "-", "—": "-",
        "≠": "!=", "·": "*", "×": "*", "∘": "o",
        "∈": " in ", "∀": "forall", "∃": "exists",
        "∑": "sum", "∂": "d", "∇": "nabla",
        "≤": "<=", "≥": ">=", "→": "->", "↦": "->",
        "⊢": "|-", "∧": "and", "∨": "or", "¬": "not",
        "⊂": "subset", "⊆": "subseteq",
    }
    for k, v in repl.items():
        s = s.replace(k, v)
    s = re.sub(r"\s+", "", s)
    return s.lower()


def root_of(code: str) -> str:
    """Root portion of a code -- everything before the first '/<D>.' reading
    suffix, or the whole string if it is itself a bare root code."""
    return code.split("/", 1)[0]


def coq_status_for(tier: str, proposal: dict) -> str:
    """SCHEMA.md v1.1 addendum ladder: 'not_yet_formalised' is retired.
    'not_formalisable' only if the proposal's own coq block already says so;
    'definition' for a Definition-tier reading (a domain definition, no proof
    obligation); 'open_prop' for a Dr-tier reading (an unproved proposition/
    derivation/non-collapse/synthesis stated as Prop, not yet formalised)."""
    proposed = (proposal.get("coq") or {}).get("coq_status")
    if proposed == "not_formalisable":
        return "not_formalisable"
    if tier == "Definition":
        return "definition"
    if tier == "Dr":
        return "open_prop"
    raise SystemExit(
        f"{proposal['id']}: tier {tier!r} has no coq_status mapping in the "
        "v1.1 ladder for this merge (only Definition/Dr are handled -- extend "
        "coq_status_for() before merging a proposal with a different tier)."
    )


def main():
    canonical_doc = json.load(open(CANONICAL_PATH, encoding="utf-8"))
    entries = canonical_doc["canonical"]
    by_code = {e["code"]: e for e in entries}

    genesis_doc = json.load(open(GENESIS_PATH, encoding="utf-8"))
    genesis_codes = {r["code"] for r in genesis_doc["root_equations"]}

    proposals_doc = json.load(open(PROPOSALS_PATH, encoding="utf-8"))
    proposals = proposals_doc["proposals"]

    # ------------------------------------------------------------------
    # Idempotency guard: aliases already on a CANONICAL entry, or occurrence
    # labels already recorded against this deposit's record_id, mean a prior
    # run of this script already merged that proposal.
    # ------------------------------------------------------------------
    existing_aliases = set()
    existing_occ_labels_by_record = defaultdict(set)
    for e in entries:
        for a in e.get("aliases") or []:
            existing_aliases.add(a)
        for occ in e.get("occurrences") or []:
            if occ.get("record_id") is not None:
                existing_occ_labels_by_record[occ["record_id"]].add(occ.get("label"))

    def already_merged(alias: str, label: str, record_id: int) -> bool:
        return alias in existing_aliases or label in existing_occ_labels_by_record[record_id]

    # ------------------------------------------------------------------
    # running (root, domain) -> current max nn, seeded from CANONICAL.json's
    # actual state (retired/split/superseded codes still count -- their code
    # stays in canonical[] -- so a retired number is never reused).
    # ------------------------------------------------------------------
    seq_state = defaultdict(int)
    for e in entries:
        mo = re.match(r"^(.+)/([EHSWMPCB])\.(\d+)\.v\d+$", e["code"])
        if mo:
            key = (mo.group(1), mo.group(2))
            seq_state[key] = max(seq_state[key], int(mo.group(3)))

    def next_code(root: str, domain: str) -> str:
        key = (root, domain)
        seq_state[key] += 1
        nn = seq_state[key]
        width = 2 if nn < 100 else len(str(nn))
        return f"{root}/{domain}.{nn:0{width}d}.v1"

    # phi-criterion statement index, seeded from the pre-merge CANONICAL
    # entries and grown as new entries are accepted within this same run (so
    # two mutually-duplicate proposals in the same batch would also be
    # caught, not just duplicates of a pre-existing entry).
    stmt_index = {}
    for e in entries:
        if e.get("domain"):
            stmt_index[(e["root"], e["domain"], norm_stmt(e["statement"]["latest"]))] = e["code"]

    lineage_events = []
    merged_map = {}
    occurrences_added = 0
    new_codes = []
    skipped_already_merged = []
    could_not_merge = []

    max_effort_id = 0
    for e in entries:
        if isinstance(e.get("id"), str) and e["id"].startswith("EFFORT-v0.3-"):
            try:
                max_effort_id = max(max_effort_id, int(e["id"].rsplit("-", 1)[1]))
            except ValueError:
                pass

    for prop in proposals:
        pid = prop["id"]
        m = re.search(r"-(\d+)$", pid)
        eq_n = m.group(1) if m else pid
        alias = f"Effort-v0.3:eq.{eq_n}"
        label = f"eq.{eq_n}"
        record_id = prop["origin"]["record_id"]

        if already_merged(alias, label, record_id):
            # find which existing entry already carries this, for the report
            existing_code = None
            for e in entries:
                if alias in (e.get("aliases") or []) or any(
                    o.get("label") == label and o.get("record_id") == record_id
                    for o in (e.get("occurrences") or [])
                ):
                    existing_code = e["code"]
                    break
            merged_map[pid] = existing_code
            skipped_already_merged.append(pid)
            continue

        try:
            # ---- parents: each must already exist -------------------------
            parents = prop.get("parents") or []
            if not parents:
                raise ValueError(f"{pid}: proposal has no parents (SCHEMA.md T3.4: empty "
                                  "parents is legal only for EQ-001)")
            for p in parents:
                if p["code"] not in by_code and p["code"] not in genesis_codes:
                    raise ValueError(f"{pid}: parent code {p['code']!r} not found in "
                                      "genesis_root.json or CANONICAL.json -- abort")

            root = root_of(parents[0]["code"])
            domain = prop["domain"]
            other_roots = []
            for p in parents[1:]:
                r = root_of(p["code"])
                if r != root and r not in other_roots:
                    other_roots.append(r)

            statement_latest = prop["statement"]["latest"]
            key = (root, domain, norm_stmt(statement_latest))

            # ---- (1) phi-equivalent occurrence of an existing code --------
            if key in stmt_index:
                survivor_code = stmt_index[key]
                survivor = by_code[survivor_code]
                occ = {"record_id": record_id, "label": label}
                survivor.setdefault("occurrences", []).append(occ)
                lineage_events.append({
                    "code": survivor_code, "date": DATE, "event": "occurrence_added",
                    "from": pid, "to": survivor_code,
                    "reason": (
                        f"Toledo v1.3 Effort v0.3 merge: proposal {pid} ({prop['name']}) "
                        f"normalizes to an exact statement match of {survivor_code} within "
                        f"(root={root}, domain={domain}) -- phi-criterion occurrence, not a "
                        f"new object. Proposal statement: \"{statement_latest}\" -- "
                        f"survivor statement: \"{survivor['statement']['latest']}\"."
                    ),
                    "by": BY,
                })
                occurrences_added += 1
                merged_map[pid] = survivor_code
                continue

            # ---- (2) new entry ---------------------------------------------
            tier = prop["tier"]
            code = next_code(root, domain)
            max_effort_id += 1
            entry = {
                "id": f"EFFORT-v0.3-{max_effort_id:02d}",
                "code": code,
                "root": root,
                "layer": prop.get("layer", "reading"),
                "domain": domain,
                "aliases": [alias],
                "name": prop["name"],
                "statement": {"latest": statement_latest, "format": prop["statement"].get("format", "latex")},
                "statements_history": [dict(h) for h in prop.get("statements_history", [])],
                "parents": [dict(p) for p in parents],
                "children": [],
                "origin": dict(prop["origin"]),
                "status": prop.get("status", "current"),
                "status_note": "",
                "superseded_by": None,
                "tier": tier,
                "tier_in_genesis_verbatim": prop.get("tier_in_genesis_verbatim", ""),
                "coq": dict(DEFAULT_COQ),
                "relations": [dict(r) for r in prop.get("relations", [])],
                "occurrences": [{"record_id": record_id, "label": label}],
                "role": prop.get("role", "other"),
                "first_assigned": DATE,
            }
            entry["coq"]["coq_status"] = coq_status_for(tier, prop)
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
            stmt_index[key] = code
            new_codes.append(code)
            merged_map[pid] = code

            reason_quote = prop.get("provenance_note_verbatim") or prop.get("tier_in_genesis_verbatim", "")
            lineage_events.append({
                "code": code, "date": DATE, "event": "assigned",
                "from": pid, "to": code,
                "reason": (
                    f"Toledo v1.3 Effort v0.3 merge (proposal {pid}, {prop['name']}, "
                    f"origin: {prop['origin']['source']}, {prop['origin']['section']}, "
                    f"p.{prop['origin']['page']}, {prop['origin']['label']}, "
                    f"record_id {record_id}, doi {prop['origin']['doi']}): {reason_quote}"
                ),
                "by": BY,
            })

        except ValueError as exc:
            could_not_merge.append(str(exc))
            merged_map[pid] = None

    # ------------------------------------------------------------------
    # children[] = invert parents[] across the full final array (SCHEMA.md:
    # computed, never hand-authored).
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
    # Validation (same shape as scripts/n4_merge.py step 6).
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
    # counts{} recompute -- exactly scripts/v12_R.py's
    # recompute_canonical_counts().
    # ------------------------------------------------------------------
    canonical_doc["counts"] = {
        "entries": len(entries),
        "by_status": dict(Counter(e["status"] for e in entries)),
        "by_domain": dict(Counter(e["domain"] for e in entries if e.get("domain"))),
        "by_tier": dict(Counter(e["tier"] for e in entries)),
        "by_coq_status": dict(Counter(e["coq"]["coq_status"] for e in entries)),
        "computed": f"{DATE} from canonical[] (scripts/v13_effort_merge.py)",
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

    json.dump(merged_map, open(MERGED_MAP_PATH, "w", encoding="utf-8"), indent=2, ensure_ascii=False, sort_keys=True)
    with open(MERGED_MAP_PATH, "a", encoding="utf-8") as fh:
        fh.write("\n")

    print("\nv1.3 Effort v0.3 merge complete.")
    print(f"  proposals total: {len(proposals)}")
    print(f"  new entries created: {len(new_codes)}: {new_codes}")
    print(f"  occurrences added to existing entries: {occurrences_added}")
    print(f"  already-merged (idempotent skip): {len(skipped_already_merged)}: {skipped_already_merged}")
    print(f"  could not merge: {len(could_not_merge)}")
    for msg in could_not_merge:
        print("   -", msg)


if __name__ == "__main__":
    main()
