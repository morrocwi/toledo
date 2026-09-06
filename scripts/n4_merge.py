#!/usr/bin/env python3
"""N4 merge (REGISTRAR pass) -- merges the swarm-2 proposal files into the N3-relabelled
CANONICAL.json / genesis_root.json / LINEAGE.jsonl, per docs/HANDOFF_OVERNIGHT_2026-09-06.md's
"Update 22:30" merge order:
  (1) split_proposal_SW.json  (retire -> split; prose members/rows -> not_an_equation pointers)
  (2) readings_genesis_domains.json + readings_universe_solver.json entries[] (final nn per
      (root,D), phi-criterion dedup against what is already in CANONICAL before adding); their
      mirrors[] become occurrence_added LINEAGE events on the existing genesis_root.json rows
      (no new entries)
  (3) genesis_tiers.sidecar.json -> genesis_root.json rows (tier/tier_in_genesis_verbatim/tier_evidence)
  (4) coq_map.json (already == coq_map.N3.json, merged during the N3 checker pass -- verified,
      not repeated) -> CANONICAL entries' coq.identifiers[] + coq_status

Readout-not-truth discipline: every decision below quotes the evidence it is based on (the
proposal files' own evidence_quote/text_verbatim fields, or this script's own computed
normalized-statement match, disclosed as a heuristic proxy for the phi-criterion -- not a
certified symbolic check).

Run: python3 scripts/n4_merge.py
Inputs : registry/CANONICAL.json (post-N3), registry/genesis_root.json, registry/LINEAGE.jsonl,
         registry/split_proposal_SW.json, registry/readings_genesis_domains.json,
         registry/readings_universe_solver.json, registry/genesis_tiers.sidecar.json,
         registry/coq_map.json, coq/canonical/*.v (existence check only)
Outputs: registry/CANONICAL.pre-N4.json (snapshot of the input, untouched)
         registry/genesis_root.pre-N4.json (snapshot of the input, untouched)
         registry/CANONICAL.json (rewritten)
         registry/genesis_root.json (rewritten)
         registry/LINEAGE.jsonl (appended, existing lines untouched)
"""
import json
import re
import shutil
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
DATE = "2026-09-06"
BY = "toledo-n4-merge"

CODE_RE = re.compile(
    r"^(?P<root>EQ-0\d{2}|[A-Za-z][A-Za-z0-9]*(?:[._-][A-Za-z0-9]+)*)"
    r"(?:/(?P<domain>[EHSWMPCB])\.(?P<seq>\d{2,4})(?:\.v(?P<rev>[1-9]\d*))?)?$"
)

DEFAULT_COQ = {
    "file": None, "identifier": None, "assumptions": None, "imported_from": None,
    "coq_status": "not_yet_formalised", "coq_axioms": [], "coq_source_redistributed": True,
}

# ---------------------------------------------------------------------------
# 0. Load inputs, snapshot the pre-N4 files, idempotency guard
# ---------------------------------------------------------------------------
PRE_N4_CANON = REG / "CANONICAL.pre-N4.json"
if not PRE_N4_CANON.exists():
    shutil.copy(REG / "CANONICAL.json", PRE_N4_CANON)
canonical_doc = json.load(open(REG / "CANONICAL.json", encoding="utf-8"))
entries = canonical_doc["canonical"]
by_code = {e["code"]: e for e in entries}
r2c = dict(canonical_doc["raw_to_canonical"])

if any(e.get("status") == "not_an_equation" for e in entries) or any(
    e.get("status") == "split" for e in entries
):
    print("N4 already applied to registry/CANONICAL.json (found status in "
          "{not_an_equation, split}) -- refusing to re-run and duplicate LINEAGE events. "
          "Restore from CANONICAL.pre-N4.json first if a clean re-run is intended.")
    sys.exit(1)

PRE_N4_GENESIS = REG / "genesis_root.pre-N4.json"
if not PRE_N4_GENESIS.exists():
    shutil.copy(REG / "genesis_root.json", PRE_N4_GENESIS)
genesis_doc = json.load(open(REG / "genesis_root.json", encoding="utf-8"))
genesis_rows = genesis_doc["root_equations"]
genesis_by_code = {r["code"]: r for r in genesis_rows}

lineage_events = []  # appended to LINEAGE.jsonl at the end; existing file lines untouched

try:
    GIT_SHA = subprocess.check_output(["git", "-C", str(ROOT), "rev-parse", "HEAD"], text=True).strip()
except Exception:
    GIT_SHA = "unknown"


def mangle(code: str) -> str:
    return code.replace("/", "__").replace(".", "_") + ".v"


def coq_file_exists(code: str) -> bool:
    return (ROOT / "coq" / "canonical" / mangle(code)).exists()


def parse_member(raw_key: str):
    """'22424434:(28)' -> (22424434, '(28)'); falls back to (None, raw_key) if unparsable."""
    m = re.match(r"^(\d+):(.*)$", raw_key)
    if m:
        return int(m.group(1)), m.group(2)
    return None, raw_key


def norm_stmt(s: str) -> str:
    """Normalized-string equality proxy for the phi-criterion (renaming / positive scale /
    constant substitution, exact -- SCHEMA.md / GENESIS_CODE_SCHEME.md). This is a heuristic
    (exact match after unicode/whitespace normalization), not a certified symbolic checker:
    it catches byte-identical-up-to-notation duplicates (the only two real cases found in this
    corpus, see LINEAGE 'merged' events below); it does not attempt genuine algebraic
    equivalence detection, and never asserts a merge without quoting both statements."""
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


# running (root, domain) -> current max nn, continued across steps 1 and 2, never reused
def compute_seq_state():
    m = defaultdict(int)
    for e in entries:
        mo = re.match(r"^(.+)/([EHSWMPCB])\.(\d+)\.v\d+$", e["code"])
        if mo:
            key = (mo.group(1), mo.group(2))
            m[key] = max(m[key], int(mo.group(3)))
    return m


seq_state = compute_seq_state()


def next_code(root: str, domain: str) -> str:
    key = (root, domain)
    seq_state[key] += 1
    nn = seq_state[key]
    width = 2 if nn < 100 else len(str(nn))
    return f"{root}/{domain}.{nn:0{width}d}.v1"


# statement index for the phi-criterion dedup check in step 2, seeded from the pre-N4 (i.e.
# post-N3 + post-split) CANONICAL entries; grows as step 2 adds entries.
def seed_stmt_index():
    idx = {}
    for e in entries:
        key = (e["root"], e["domain"], norm_stmt(e["statement"]["latest"]))
        idx.setdefault(key, e["code"])
    return idx


# ===========================================================================
# STEP 1 -- SPLIT (registry/split_proposal_SW.json)
# ===========================================================================
sw = json.load(open(REG / "split_proposal_SW.json", encoding="utf-8"))

split_children_created = 0
prose_rows_retired = 0

for row in sw["rows"]:
    code = row["code"]
    classification = row["classification"]

    if classification == "single_equation":
        continue  # already correct: one code, one occurrence set; no action

    e = by_code.get(code)
    if e is None:
        raise SystemExit(f"split_proposal_SW.json row {code!r} not found in CANONICAL.json")

    if classification == "prose_propositions_not_equations":
        pointers = []
        for mem in row["members"]:
            rid, label = parse_member(mem)
            pointers.append({"record_id": rid, "section": None, "label": label})
        e["status"] = "not_an_equation"
        e["status_note"] = (
            "N4 split ruling (founder 22:20, 2026-09-06, registry/split_proposal_SW.json): "
            + row["evidence_quote"]
        )
        e["pointer"] = pointers
        e["superseded_by"] = None
        reason = row["evidence_quote"]
        if row.get("proposed_lineage_events"):
            reason += " | proposed_lineage_events: " + json.dumps(
                row["proposed_lineage_events"], ensure_ascii=False
            )

        # --- integrity fix (task-named flag #1): weld/S.06.v1's statement.latest must come
        # from its OWN cited occurrence, not from a different code's formula.
        if code == "weld/S.06.v1":
            quoted = None
            for exm in row["excluded_members"]:
                if exm["occurrence"] == row["members"][0]:
                    quoted = exm["text_verbatim"]
            if quoted is None:
                raise SystemExit("weld/S.06.v1 integrity fix: excluded_members text not found")
            old_stmt = e["statement"]["latest"]
            e["statement"] = {"latest": quoted, "format": "prose"}
            e["statements_history"].append({
                "v": len(e["statements_history"]) + 1,
                "statement": quoted,
                "date": DATE,
                "reason": (
                    "N4 registrar integrity fix (data-integrity flag from swarm-2 checker, "
                    f"2026-09-06 22:30 handoff): statement.latest was a copy of a DIFFERENT "
                    f"code's formula (verbatim prior value: \"{old_stmt}\", which is "
                    "EQ-015/S.08.v1's own 'Recoverable Live-Field Gap' formula, occurrence "
                    "22357788:CBC-10) rather than derived from this entry's own cited "
                    f"occurrence 22424434:(28); corrected to quote that occurrence verbatim: "
                    f"\"{quoted}\" -- which is prose (no operator), so status is set to "
                    "not_an_equation rather than left as a live formula reading."
                ),
                "by": BY,
            })
            e["status_note"] += (
                f" INTEGRITY FIX: prior statement.latest (\"{old_stmt}\") was misattributed "
                "from EQ-015/S.08.v1 and has been replaced with this entry's own occurrence "
                f"text, quoted above; corrected per N4 task instruction."
            )
            reason += (
                f" | INTEGRITY FIX: statement.latest corrected from misattributed formula "
                f"\"{old_stmt}\" to this entry's own occurrence text \"{quoted}\"."
            )

        lineage_events.append({
            "code": e["code"], "date": DATE, "event": "retired",
            "from": e["code"], "to": None, "reason": reason, "by": BY,
        })
        prose_rows_retired += 1
        continue

    # --- classification in (bundle_of_equations, mixed) ---
    root, domain = e["root"], e["domain"]
    bundle_parents = [dict(p) for p in e["parents"]]
    bundle_occ_by_key = {o["raw_key"]: o for o in e["occurrences"]}

    def resolve_occurrence(rid: int, label_full: str):
        base_label = re.sub(r"\s*\(list item.*$", "", label_full).strip()
        match = bundle_occ_by_key.get(f"{rid}:{base_label}")
        doi = match["doi"] if match else None
        section = match["section"] if match else None
        return {"record_id": rid, "doi": doi, "label": label_full, "section": section,
                "raw_key": f"{rid}:{label_full}"}

    new_children_codes = []
    for i, child in enumerate(row["proposed_children"], start=1):
        occs = []
        for m in re.finditer(r"(\d{5,}):([^,;]+)", child["source_occurrences"]):
            rid = int(m.group(1))
            label_full = m.group(2).strip()
            occs.append(resolve_occurrence(rid, label_full))
        if not occs:
            raise SystemExit(f"no occurrence resolved for split child of {code}: {child}")

        child_code = next_code(root, domain)
        child_id = f"{e['id']}-SPLIT-{i:02d}"
        child_entry = {
            "id": child_id,
            "code": child_code,
            "root": root,
            "layer": "reading",
            "domain": domain,
            "aliases": [],
            "name": child["label"],
            "statement": {"latest": child["statement_latex_verbatim"], "format": e["statement"]["format"]},
            "statements_history": [{
                "v": 1,
                "statement": child["statement_latex_verbatim"],
                "date": DATE,
                "reason": (
                    f"N4 split of {code} (founder ruling 22:20, 2026-09-06, "
                    f"registry/split_proposal_SW.json): {row['evidence_quote']}"
                ),
                "by": BY,
            }],
            "parents": bundle_parents + [{"code": code, "derived_via": "split"}],
            "children": [],
            "origin": dict(e["origin"]),
            "status": "current",
            "status_note": "",
            "superseded_by": None,
            "tier": child.get("tier", "untagged"),
            "tier_in_genesis_verbatim": e.get("tier_in_genesis_verbatim", ""),
            "coq": dict(DEFAULT_COQ),
            "relations": [],
            "occurrences": occs,
            "role": "other",
            "first_assigned": DATE,
        }
        entries.append(child_entry)
        by_code[child_code] = child_entry
        new_children_codes.append(child_code)
        split_children_created += 1

        for occ in occs:
            if occ["raw_key"] in r2c:
                r2c[occ["raw_key"]] = child_code

        lineage_events.append({
            "code": child_code, "date": DATE, "event": "assigned",
            "from": code, "to": child_code,
            "reason": (
                f"split child of {code}: {child['label']}; statement verbatim from "
                f"split_proposal_SW.json: \"{child['statement_latex_verbatim']}\" "
                f"(source occurrence(s): {child['source_occurrences']})"
            ),
            "by": BY,
        })

    # excluded members (prose or redundant-content, per the proposal's own reason) -- disclosed
    # on the retired bundle entry rather than silently dropped or guess-merged into one specific
    # child (readout-not-truth: no fabricated exact match where the evidence does not name one).
    excluded_disclosure = []
    pointer_list = []
    for exm in row.get("excluded_members", []):
        rid, label = parse_member(exm["occurrence"])
        excluded_disclosure.append({
            "record_id": rid, "label": label,
            "text_verbatim": exm["text_verbatim"], "reason": exm["reason"],
        })
        pointer_list.append({"record_id": rid, "section": None, "label": label})

    status_note = f"N4 split (founder ruling 22:20, 2026-09-06): {row['evidence_quote']}"

    # --- integrity fix (task-named flag #2): A.5/W.03.v1's own name claims "ten" separations
    # but only 9 members are mapped to occurrences in this corpus -- record the count honestly.
    if code == "A.5/W.03.v1":
        old_name = e["name"]
        e["name"] = "Human Conversion Imperative's non-collapse separations (9 mapped; source heading says \"ten\")"
        status_note += (
            f" INTEGRITY FIX: this entry's own name (\"{old_name}\") states \"ten non-collapse "
            f"separations\", but only {len(row['members'])} member occurrences "
            f"({', '.join(row['members'])}) are mapped in CANONICAL.json -- the tenth "
            "separation could not be located in the occurrence set and is not fabricated here; "
            "count corrected to 9, honestly, per readout-not-truth."
        )

    e["status"] = "split"
    e["status_note"] = status_note
    e["superseded_by"] = None
    if pointer_list:
        e["pointer"] = pointer_list
    if excluded_disclosure:
        e["split_excluded_members"] = excluded_disclosure
    e["split_children"] = new_children_codes

    lineage_events.append({
        "code": code, "date": DATE, "event": "split",
        "from": code, "to": new_children_codes,
        "reason": row["evidence_quote"], "by": BY,
    })

print(f"STEP 1 SPLIT: {prose_rows_retired} rows retired to not_an_equation, "
      f"{split_children_created} split children created "
      f"(of {sw['counts']['total_proposed_children']} proposed).")

# ===========================================================================
# STEP 2 -- READINGS (registry/readings_genesis_domains.json, readings_universe_solver.json)
# ===========================================================================
stmt_index = seed_stmt_index()


def safe_aliases(raw_aliases, entry_id):
    """T7.4 (test_duplicate_codes) forbids an alias value that equals a DIFFERENT entity's
    primary code. The domain-rule proposal files reuse short ids (e.g. biology rule 'T2') that
    coincidentally collide with an unrelated genesis_root.json code of the same name (Genesis's
    own 'T2' abstract-closure theorem) -- namespace only the colliding ones, in place, rather
    than silently dropping the source's own identifier."""
    out = []
    for a in raw_aliases or []:
        if a in genesis_by_code:
            namespaced = f"reading-alias:{entry_id}:{a}"
            print(f"  (alias collision guard: {entry_id!r}'s own alias {a!r} collides with "
                  f"genesis_root.json code {a!r} -- namespaced to {namespaced!r})")
            out.append(namespaced)
        else:
            out.append(a)
    return out


def build_reading_entry(src: dict, code: str) -> dict:
    ent = {
        "id": src["id"],
        "code": code,
        "root": src["root"],
        "layer": "reading",
        "domain": src["domain"],
        "aliases": safe_aliases(src.get("aliases"), src["id"]),
        "name": src.get("name") or code,
        "statement": dict(src["statement"]),
        "statements_history": [dict(h) for h in (src.get("statements_history") or [])],
        "parents": [dict(p) for p in (src.get("parents") or [])],
        "children": [],
        "origin": dict(src["origin"]),
        "status": src.get("status", "current"),
        "status_note": src.get("status_note", "") or "",
        "superseded_by": src.get("superseded_by"),
        "tier": src.get("tier", "untagged"),
        "tier_in_genesis_verbatim": src.get("tier_in_genesis_verbatim", ""),
        "coq": dict(src.get("coq") or DEFAULT_COQ),
        "relations": [dict(r) for r in (src.get("relations") or [])],
        "occurrences": [dict(o) for o in (src.get("occurrences") or [])],
        "role": src.get("role", "other"),
        "first_assigned": DATE,
    }
    if src.get("owner_year"):
        ent["owner_year"] = src["owner_year"]
    return ent


def merge_duplicate(survivor: dict, dup: dict):
    for occ in dup.get("occurrences") or []:
        survivor["occurrences"].append(dict(occ))
    for a in dup.get("aliases") or []:
        if a not in survivor["aliases"]:
            survivor["aliases"].append(a)
    lineage_events.append({
        "code": survivor["code"], "date": DATE, "event": "merged",
        "from": dup["id"], "to": survivor["code"],
        "reason": (
            f"phi-criterion dedup (N4 READINGS merge, scoped to (root={survivor['root']}, "
            f"domain={survivor['domain']}) since a Layer-1 reading is domain-specific by "
            f"definition): duplicate {dup['id']} was about to be added as a second reading "
            f"under the same (root, domain) pair as the already-present {survivor['code']}, "
            "with a normalized-statement-identical text -- merged as an occurrence rather than "
            "a second code."
        ),
        "phi_criterion_evidence": (
            f"surviving ({survivor['code']}, id={survivor['id']}): "
            f"\"{survivor['statement']['latest']}\" | duplicate (id={dup['id']}): "
            f"\"{dup['statement']['latest']}\" -- identical after normalized-notation "
            "comparison (exact match, no renaming/scale/constant-substitution needed)."
        ),
        "by": BY,
    })


def process_reading(src: dict):
    root, domain = src["root"], src["domain"]
    code_placeholder = src["code"]
    if "/" not in code_placeholder or ".??." not in code_placeholder:
        raise SystemExit(f"unexpected reading code shape (expected '<root>/<D>.??.v1'): {code_placeholder!r}")
    key = (root, domain, norm_stmt(src["statement"]["latest"]))
    if key in stmt_index:
        survivor = by_code[stmt_index[key]]
        merge_duplicate(survivor, src)
        return stmt_index[key]
    code = next_code(root, domain)
    ent = build_reading_entry(src, code)
    entries.append(ent)
    by_code[code] = ent
    stmt_index[key] = code
    return code


# --- 2a. readings_genesis_domains.json, in each (root,domain) group's own proposed_after chain
rgd = json.load(open(REG / "readings_genesis_domains.json", encoding="utf-8"))
rgd_groups = defaultdict(list)
for src in rgd["canonical"]:
    rgd_groups[(src["root"], src["domain"])].append(src)

rgd_created = 0
rgd_merged = 0
for group_key, items in rgd_groups.items():
    ids = {it["id"] for it in items}
    by_id = {it["id"]: it for it in items}
    heads = [it["id"] for it in items if it["proposed_after"] is None or it["proposed_after"] not in ids]
    if len(heads) != 1:
        raise SystemExit(f"readings_genesis_domains.json group {group_key} has {len(heads)} chain heads: {heads}")
    next_map = {}
    for it in items:
        if it["proposed_after"] in ids:
            next_map[it["proposed_after"]] = it["id"]
    order = [heads[0]]
    cur = heads[0]
    while cur in next_map:
        cur = next_map[cur]
        order.append(cur)
    if len(order) != len(items):
        raise SystemExit(f"readings_genesis_domains.json group {group_key}: chain covers "
                          f"{len(order)}/{len(items)} entries -- incomplete proposed_after chain")
    for entry_id in order:
        before = len(entries)
        final_code = process_reading(by_id[entry_id])
        if len(entries) > before:
            rgd_created += 1
            # raw_to_canonical: reconstruct "<domain_folder>:<alias>" per GENESIS-DOMAINS
            # worker's own key convention (verified against registry/readings_genesis_domains.json
            # raw_to_canonical sample values, e.g. "chem:RT-LEDGER-001").
            domain_folder = entry_id.split("-")[1].lower()
            alias = (by_id[entry_id].get("aliases") or [None])[0]
            if alias:
                r2c[f"{domain_folder}:{alias}"] = final_code
        else:
            rgd_merged += 1

print(f"STEP 2a READINGS (genesis domains): {rgd_created} new entries, {rgd_merged} merged as occurrences "
      f"(of {rgd['counts']['n_readings_written']} proposed).")

# --- 2b. readings_universe_solver.json entries[], in file order (proposed_after is descriptive
# text here, not an id chain; the file's own array order already encodes the intended sequence
# -- verified against each entry's own "propose immediately after ..." text, 2026-09-06).
rus = json.load(open(REG / "readings_universe_solver.json", encoding="utf-8"))
rus_created = 0
rus_merged = 0
for src in rus["entries"]:
    before = len(entries)
    process_reading(src)
    if len(entries) > before:
        rus_created += 1
    else:
        rus_merged += 1

print(f"STEP 2b READINGS (universe+solver): {rus_created} new entries, {rus_merged} merged as occurrences "
      f"(of {rus['counts']['entries_total']} proposed).")

# --- 2c. mirrors[] -> occurrence_added LINEAGE events on the existing genesis_root.json rows
# (do not create CANONICAL entries -- these are second synced copies of Appendix-C rows, not new
# objects; see GENESIS_CODE_SCHEME.md's own note that READOUT_GENESIS_CORE.md is the primary SoT
# and these files are mirrors of it).
mirrors_missing_code = []
mirrors_already_covered = 0
_lineage_before_mirrors = len(lineage_events)
for mirror in rus.get("mirrors", []):
    alias_of = mirror["alias_of"]
    if alias_of not in genesis_by_code:
        # not a genesis root at all -- check whether this is the one documented case (readings_
        # universe_solver.json's own text: "(Toledo reading, this file, not a Genesis root)")
        # where the "mirror" is actually of a Toledo reading entry already created in step 2b,
        # and whose occurrence is already present verbatim in that entry's own occurrences[]
        # (checked by matching label -- not guessed).
        already = any(
            any(o.get("label") == mirror["label"] for o in ent.get("occurrences") or [])
            for ent in entries
        )
        if already:
            mirrors_already_covered += 1
            continue
        mirrors_missing_code.append(alias_of)
        continue
    lineage_events.append({
        "code": alias_of, "date": DATE, "event": "occurrence_added",
        "from": mirror["source"], "to": alias_of,
        "reason": (
            f"mirror occurrence ({mirror['source']}, label={mirror['label']}, "
            f"file={mirror['file']}, blob={mirror.get('blob')}): {mirror['is_mirror_of_verbatim']}"
        ),
        "by": BY,
    })
if mirrors_missing_code:
    raise SystemExit(f"mirrors reference unknown genesis_root.json codes: {sorted(set(mirrors_missing_code))}")

print(f"STEP 2c MIRRORS: {len(lineage_events) - _lineage_before_mirrors} occurrence_added LINEAGE "
      f"events on genesis_root.json rows; {mirrors_already_covered} already covered by an "
      "existing occurrence on a Toledo reading entry (no duplicate event needed) "
      f"(of {len(rus.get('mirrors', []))} mirror rows total).")

# ===========================================================================
# STEP 3 -- TIERS (registry/genesis_tiers.sidecar.json -> genesis_root.json)
# ===========================================================================
sidecar = json.load(open(REG / "genesis_tiers.sidecar.json", encoding="utf-8"))
sidecar_commit = sidecar["generated_from"]["readout_genesis_commit"]

tiers_applied = 0
for code, info in sidecar["entries"].items():
    row = genesis_by_code.get(code)
    if row is None:
        raise SystemExit(f"genesis_tiers.sidecar.json code {code!r} not found in genesis_root.json")
    row["tier_in_genesis_verbatim"] = row.get("tier_in_genesis", "")
    row["tier"] = info["tier_normalised"]
    row["tier_evidence"] = {
        "quote": info["evidence_quote"],
        "line": info["evidence_line"],
        "commit": sidecar_commit,
    }
    tiers_applied += 1

print(f"STEP 3 TIERS: {tiers_applied} genesis_root.json rows tagged from the sidecar "
      f"(of {len(sidecar['entries'])} sidecar entries).")

# ===========================================================================
# STEP 4 -- COQ MAP (registry/coq_map.json -> CANONICAL entries' coq.identifiers[])
# ===========================================================================
N3_COQ_MAP = REG / "coq_map.N3.json"
LIVE_COQ_MAP = REG / "coq_map.json"
PRE_N3_MERGE_COPY = REG / "coq_map.pre-N3-merge.json"
if not PRE_N3_MERGE_COPY.exists():
    raise SystemExit("registry/coq_map.pre-N3-merge.json missing -- expected the N3 checker's "
                      "pre-merge snapshot to already exist per the handoff")
if open(LIVE_COQ_MAP, "rb").read() != open(N3_COQ_MAP, "rb").read():
    shutil.copy(N3_COQ_MAP, LIVE_COQ_MAP)
    lineage_events.append({
        "code": "registry/coq_map.json", "date": DATE, "event": "revised",
        "from": "stale coq_map.json (pre-N4)",
        "to": "registry/coq_map.N3.json merged in verbatim (N4 step 4)",
        "reason": "N4 merge order step (4): replace registry/coq_map.json with coq_map.N3.json content.",
        "by": BY,
    })
    print("STEP 4a: registry/coq_map.json replaced with coq_map.N3.json content.")
else:
    print("STEP 4a: registry/coq_map.json already == coq_map.N3.json (merged during the N3 "
          "checker pass, commit b29753f/prior) -- no-op.")

coq_map = json.load(open(LIVE_COQ_MAP, encoding="utf-8"))
code_to_ids = defaultdict(list)
for row in coq_map:
    for c in row.get("codes") or []:
        pair = {"file": row["file"], "identifier": row["identifier"]}
        if pair not in code_to_ids[c]:
            code_to_ids[c].append(pair)

filled = 0
mapped_not_wrapped = 0
for e in entries:
    matches = []
    for key in (e["code"], e["root"]):
        for pair in code_to_ids.get(key, []):
            if pair not in matches:
                matches.append(pair)
    if not matches:
        continue
    e["coq"]["identifiers"] = matches
    filled += 1
    if not coq_file_exists(e["code"]):
        e["coq"]["coq_status"] = "mapped_not_wrapped"
        mapped_not_wrapped += 1
    # else: a coq/canonical/<mangled-code>.v file already exists for this code -- its own
    # coq_status (set by the earlier BBL-182 wrap/verify pass) is kept as-is, per task instruction.

print(f"STEP 4b: {filled} CANONICAL entries got coq.identifiers[] filled "
      f"({mapped_not_wrapped} newly set to coq_status=mapped_not_wrapped; the rest already had "
      "a coq/canonical file and kept their existing coq_status).")

# ===========================================================================
# 5. children[] = invert parents[] across the full final array (SCHEMA.md: computed, never
#    hand-authored)
# ===========================================================================
code_set = {f["code"] for f in entries}
children_map = {c: [] for c in code_set}
for f in entries:
    for p in f["parents"]:
        if p["code"] in children_map:
            children_map[p["code"]].append(f["code"])
for f in entries:
    f["children"] = sorted(set(children_map[f["code"]]))

# ===========================================================================
# 6. Validation (mirrors N3's own checks: no orphans, no duplicate codes, code grammar)
# ===========================================================================
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

graph = {f["code"]: [p["code"] for p in f["parents"]] for f in entries}
for r in genesis_rows:
    graph[r["code"]] = list(r.get("parents") or [])


def has_cycle():
    WHITE, GRAY, BLACK = 0, 1, 2
    color = {c: WHITE for c in graph}

    def visit(c, stack):
        color[c] = GRAY
        for p in graph.get(c, []):
            if p not in graph:
                continue
            if color.get(p) == GRAY:
                return stack + [c, p]
            if color.get(p) == WHITE:
                r = visit(p, stack + [c])
                if r:
                    return r
        color[c] = BLACK
        return None

    for c in list(graph):
        if color[c] == WHITE:
            r = visit(c, [])
            if r:
                return r
    return None


cyc = has_cycle()
if cyc:
    problems.append(f"cycle: {cyc}")

if problems:
    print("VALIDATION PROBLEMS:")
    for p in problems[:50]:
        print(" -", p)
    sys.exit(1)

# ===========================================================================
# 7. Write outputs
# ===========================================================================
by_domain = {}
by_tier = {}
for f in entries:
    by_domain[f["domain"]] = by_domain.get(f["domain"], 0) + 1
    by_tier[f["tier"]] = by_tier.get(f["tier"], 0) + 1

canonical_doc["schema_version"] = canonical_doc.get("schema_version", "1.0.0")
canonical_doc["generated_from_commit"] = GIT_SHA
canonical_doc["canonical"] = entries
canonical_doc["raw_to_canonical"] = r2c
canonical_doc["counts"] = {
    "raw": len(r2c),
    "canonical": len(entries),
    "by_domain": by_domain,
    "by_tier": by_tier,
    "n4_split_children_created": split_children_created,
    "n4_prose_rows_retired": prose_rows_retired,
    "n4_readings_created": rgd_created + rus_created,
    "n4_readings_merged_as_occurrence": rgd_merged + rus_merged,
}
json.dump(canonical_doc, open(REG / "CANONICAL.json", "w", encoding="utf-8"), indent=2, ensure_ascii=False)
print(f"Wrote {REG/'CANONICAL.json'}: {len(entries)} canonical entries, {len(r2c)} raw_to_canonical keys")

json.dump(genesis_doc, open(REG / "genesis_root.json", "w", encoding="utf-8"), indent=2, ensure_ascii=False)
print(f"Wrote {REG/'genesis_root.json'}: {len(genesis_rows)} root rows ({tiers_applied} tier-tagged this run)")

with open(REG / "LINEAGE.jsonl", "a", encoding="utf-8") as fh:
    for ev in lineage_events:
        fh.write(json.dumps(ev, ensure_ascii=False) + "\n")
print(f"Appended {len(lineage_events)} events to {REG/'LINEAGE.jsonl'}")

print("\nN4 merge complete.")
print(f"  entries: {len(canonical_doc['canonical'])} (was {len(json.load(open(PRE_N4_CANON))['canonical'])})")
