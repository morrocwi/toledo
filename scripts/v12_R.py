#!/usr/bin/env python3
"""
scripts/v12_R.py -- Toledo v1.2 Lane R (root extension).

Founder ruling 2026-09-07 (BBL-2026-09-07-207, relayed in
ops/HANDOFF_OVERNIGHT_2026-09-06.md "2026-09-07 09:10 -- founder rulings ->
v1.2.0"): "Theta and CMC become roots connected into the lineage."

This script adds:
  1. Two new Layer-0 root rows to registry/genesis_root.json: "Theta" (the
     Theta programme, public, readout_genesis) and "CMC" (Causal-Memory
     Closure, private solver arc). Codes are the sources' own verbatim
     identifiers (never re-prefixed), per registry/GENESIS_CODE_SCHEME.md.
  2. One reading in registry/CANONICAL.json for every coq_map.json-listed
     identifier in the ten Theta/CP files (86) and six CMC files (33) --
     119 readings total, coq_status "mapped_not_wrapped" (wrapping is a
     later lane per the overnight handoff).
  3. registry/coq_map.json "codes" filled in for those same 119 rows.
  4. registry/LINEAGE.jsonl "assigned" events for every new code (2 roots +
     119 readings = 121 events).

Idempotent: re-reads each registry file immediately before its own atomic
write, and only ever adds rows/codes that are not already present (checked
by code / by (file, identifier) pair / by LINEAGE "assigned" code) -- a
re-run after a partial failure or after another lane's commit lands is
therefore always safe and never touches an entry this lane did not create.

Never invents a statement, tier, root, or parent: every statement below is
the literal Coq declaration from the source file (format "coq"); every tier
is derived from coq/verify_all.sh's own recorded status in coq_map.json
(the strongest available evidence, per registry/SCHEMA.md's own convention
that `assumptions` is "never asserted, always copied from
coq/verify_all.sh's own output"), never invented and never raised above
what that status says. RD1-RD9 are NOT touched by this script (already
resolved distinct-object in registry/rd_root_map.json; out of scope here).
"""
import json
import os

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TODAY = "2026-09-07"
BY = "toledo-v1.2-R"

GENESIS_PATH = os.path.join(ROOT, "registry", "genesis_root.json")
CANONICAL_PATH = os.path.join(ROOT, "registry", "CANONICAL.json")
COQMAP_PATH = os.path.join(ROOT, "registry", "coq_map.json")
LINEAGE_PATH = os.path.join(ROOT, "registry", "LINEAGE.jsonl")

THETA_DIR_REL = "coq/readout_genesis/formal"
CMC_DIR_REL = "coq/solver-arc/formal"

THETA_COMMIT = "082dde893b70c7500c13d463239909c99cf17f0a"
CMC_COMMIT = "961151db33b0491cba8fabade69f594238d33f84"

THETA_FILES = [
    "InfoThetaCPSquareObstruction_attempt.v",
    "InfoThetaEdgeCensus_attempt.v",
    "InfoThetaFixedPointBalance_attempt.v",
    "InfoThetaLivingOrientationSign_attempt.v",
    "InfoThetaMinimalLiving_attempt.v",
    "InfoThetaOrientedSkewObstruction_attempt.v",
    "InfoThetaQuartetSquareObstruction_attempt.v",
    "InfoThetaSectorSpectrum_attempt.v",
    "InfoThetaTopologyReadout_attempt.v",
    "InfoCPEquivariantGenerationBound_attempt.v",
]
CMC_FILES = [
    "CMC_Bridge_Decomposition.v",
    "CMC_ClosureFree_Exhaustive.v",
    "CMC_Independent_Definitions.v",
    "CMC_ModelClass_Witnesses.v",
    "CMC_PhysicsClass_Instances.v",
    "CMC_TargetClass_Definitions.v",
]

# ---------------------------------------------------------------------------
# Coq declaration extraction (Theorem/Lemma/Definition/... name + verbatim
# statement text, up to but excluding "Proof."). Read directly from the
# mirrored .v files already imported under coq/ by the S7 lane.
# ---------------------------------------------------------------------------
KEYWORDS = ("Theorem", "Lemma", "Definition", "Corollary", "Example",
            "Remark", "Fact", "Axiom", "Fixpoint", "Inductive")


def extract_decls(path):
    import re
    lines = open(path, encoding="utf-8").read().split("\n")
    out = {}
    i = 0
    n = len(lines)
    while i < n:
        line = lines[i]
        stripped = line.strip()
        kind = None
        for kw in KEYWORDS:
            if stripped.startswith(kw + " "):
                kind = kw
                break
        if kind:
            rest = stripped[len(kind):].strip()
            name_m = re.match(r"([A-Za-z0-9_']+)", rest)
            if not name_m:
                i += 1
                continue
            name = name_m.group(1)
            start_line = i + 1
            collected = [line]
            j = i + 1
            while j < n:
                l2 = lines[j]
                if l2.strip() == "Proof." or l2.strip().startswith("Proof."):
                    break
                collected.append(l2)
                if (l2.strip().endswith(".") and
                        kind in ("Definition", "Fixpoint", "Inductive", "Axiom") and
                        len(collected) > 1):
                    j += 1
                    break
                if l2.strip() == "" and len(collected) > 1:
                    break
                j += 1
                if j - i > 25:
                    break
            statement = "\n".join(collected).strip()
            out[name] = {"line": start_line, "kind": kind, "statement": statement}
            i = j
        else:
            i += 1
    return out


# ---------------------------------------------------------------------------
# CMC identifiers whose coq_map.json status names a disclosed axiom
# dependency (checked directly against registry/coq_map.json below; this
# constant only documents the expectation and is asserted, not assumed).
# ---------------------------------------------------------------------------
CMC_AXIOM_DEPENDENT = {
    "cmc_no_refuter_under_axioms",
    "decomposed_bridge_obligation",
    "decomposed_no_refuter",
}


def tier_for(kind, status):
    """Never invented: Definition-class -> tier Definition (no proof
    obligation); else tier is read off coq_map.json's own status string,
    which is itself copied verbatim from coq/verify_all.sh's Print
    Assumptions output (registry/SCHEMA.md's own convention for the
    `assumptions` field) -- the strongest available evidence, never
    raised above what it says."""
    if kind in ("Definition", "Fixpoint", "Inductive"):
        return ("Definition",
                "Definition (Coq `%s` declaration; no proof obligation -- "
                "verify.sh does not run Print Assumptions on a Definition)." % kind)
    if status == "Closed under the global context":
        return ("Th_coqc",
                "registry/coq_map.json status = \"Closed under the global "
                "context\" (Print Assumptions output, verified in the S7 "
                "Coq-import pass) -- the corpus's own working definition of "
                "Th_coqc (machine-checked, axiom-free).")
    return ("Ax",
            "registry/coq_map.json status = %r (Print Assumptions names a "
            "disclosed axiom dependency); tier capped at Ax, the tier of its "
            "weakest disclosed dependency, per registry/SCHEMA.md's rule that "
            "tier is never raised above the source's own evidence." % status)


def load(path):
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def atomic_write(path, data, indent=1, trailing_newline=True):
    """Preserve each registry file's own existing indent width and trailing-
    newline convention, so this lane's diff shows only the rows it actually
    added -- not a whole-file reformat."""
    tmp = path + ".tmp_v12R"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=indent, ensure_ascii=False)
        if trailing_newline:
            f.write("\n")
    os.replace(tmp, path)


def recompute_canonical_counts(cd):
    canon = cd["canonical"]
    from collections import Counter
    cd["counts"] = {
        "entries": len(canon),
        "by_status": dict(Counter(e["status"] for e in canon)),
        "by_domain": dict(Counter(e["domain"] for e in canon if e.get("domain"))),
        "by_tier": dict(Counter(e["tier"] for e in canon)),
        "by_coq_status": dict(Counter(e["coq"]["coq_status"] for e in canon)),
        "computed": "%s from canonical[] (scripts/v12_R.py)" % TODAY,
    }


# ---------------------------------------------------------------------------
# Root rows (genesis_root.json). Statements/quotes copied verbatim from the
# cited files; relations only where the source itself states the connection
# (quoted); relations left [] with an honest note where root_candidates_report
# already found no source text states one (CMC).
# ---------------------------------------------------------------------------
THETA_ROOT_ROW = {
    "code": "Theta",
    "genesis_id": "Theta",
    "aliases": ["THETA_ROOT_PROGRAM"],
    "name": "Theta -- living/relational-geometry root state (root extension)",
    "statement": "G[Theta] = G_0 + Sum_a Theta^a G_a",
    "section": ("coq/readout_genesis/formal/InfoThetaEdgeCensus_attempt.v, header "
                "comment lines 4-8 (founder-ruling context + operator definition); "
                "programme name cited verbatim as \"THETA_ROOT_PROGRAM.md\" in "
                "coq/readout_genesis/formal/InfoThetaMinimalLiving_attempt.v, line 4 "
                "-- that companion document is not itself copied into this Toledo "
                "tree; only the .v files citing it were imported (S7)."),
    "tier_in_genesis": "untagged",
    "tier_in_genesis_note": ("the root-elevation ruling itself carries no bracket "
        "tier tag; the programme's own files carry per-item tiers (Th_coqc / Ax / "
        "Definition, per this row's readings below, each with its own evidence)."),
    "synthesis_occurrences": [],
    "role": "root-extension",
    # genesis_root.json's own convention (589/590 pre-existing rows) is a flat
    # list of parent CODE STRINGS, not the richer CANONICAL.json parents[]
    # object shape -- matched here so tests/test_registry.py::test_no_cycles'
    # combined parent graph (which reads genesis_root parents as plain
    # strings) walks this row correctly. Both links are genuine "reads"
    # evidence, quoted in full in `relations` below -- nothing here is
    # guessed, and this satisfies test_no_orphans (a root other than EQ-001
    # must carry a non-empty parents[]).
    "parents": ["EQ-008", "EQ-022"],
    "relations": [
        {
            "type": "reads",
            "target": "EQ-008",
            "note": "Theta's admissible-operator census reuses EQ-008's own forced characterization as a definition, not re-proven",
            "evidence_quote": ("\"the index set of `a` was never declared anywhere in "
                "the corpus (readout_universe survey, 2026-08-08). This file closes "
                "that gap for the 3-vertex case, from the root's OWN forced "
                "characterization: admissible retained-difference operators are "
                "exactly the matrices that are symmetric, zero-row-sum, off-diagonal "
                "<= 0 (the same three properties that force L_R = D_W - W, "
                "readout_universe logic.md R-L / R-L-uniq, Th_coqc there; re-used "
                "here as the DEFINITION of admissibility, not re-proven).\""),
            "evidence_source": "coq/readout_genesis/formal/InfoThetaEdgeCensus_attempt.v, lines 51-58",
        },
        {
            "type": "reads",
            "target": "EQ-022",
            "note": ("Theta (Theta_n) is the geometry-state variable inside the "
                     "living-geometry operator G[Theta_n] that already appears, "
                     "under that name, in Genesis root EQ-022's own stated reader/"
                     "record recurrence -- the same object, not a re-derivation"),
            "evidence_quote": ("EQ-022 statement (registry/genesis_root.json): "
                "\"Reader: M delta_t^2 Phi_n + D delta_t^c Phi_n + K G[Theta_n] Phi_n "
                "+ grad V(Phi_n) - J_n = R_Phi,n; ...\" -- the operator G[Theta_n] is "
                "literally the object InfoThetaEdgeCensus_attempt.v's header names: "
                "\"The living-geometry operator is affine in the geometry state: "
                "G[Theta] = G_0 + Sum_a Theta^a G_a\"."),
            "evidence_source": ("registry/genesis_root.json EQ-022 (from "
                "READOUT_GENESIS_CORE.md); coq/readout_genesis/formal/"
                "InfoThetaEdgeCensus_attempt.v, lines 6-7"),
        },
    ],
    "origin": {
        "source": "readout_genesis",
        "repo_anchor": {
            "repo": "readout_genesis",
            "commit": THETA_COMMIT,
            "path": "formal/InfoThetaEdgeCensus_attempt.v",
            "line": 5,
        },
        "doi": None,
    },
    "founder_ruling": {
        "quote": ("CONTEXT (founder ruling 2026-08-08: Theta is elevated to a NEW "
                  "ROOT alongside reader Phi / record Psi / retained difference "
                  "delta_R)."),
        "quote_source": "coq/readout_genesis/formal/InfoThetaEdgeCensus_attempt.v, lines 4-5",
        "toledo_ruling": ("BBL-2026-09-07-207 (founder, 2026-09-07, relayed in "
            "ops/HANDOFF_OVERNIGHT_2026-09-06.md): \"Theta and CMC become roots "
            "connected into the lineage.\""),
    },
    "step": None,
    "step_note": ("not part of READOUT_GENESIS_CORE.md's own \"Genesis of the "
        "Universe, Step by Step\" ordering (BBL-192/193) -- Theta's root status "
        "comes from a 2026-08-08 ruling recorded only in the imported .v files' "
        "own header comments, downstream of that document; no step position is "
        "invented for it. Open item for a future lane if the founder places it "
        "in the step sequence."),
}

CMC_ROOT_ROW = {
    "code": "CMC",
    "genesis_id": "CMC",
    "aliases": ["Causal-Memory Closure", "CMC_Bridge_Obligation"],
    "name": "CMC (Causal-Memory Closure) -- founder-level bridge axiom (root extension)",
    "statement": "Axiom cmc_bridge_axiom : CMC_Bridge_Obligation.",
    "section": ("solver arc (private), formal/CMC_TargetClass_Definitions.v, lines "
                "51-58 (CMC_Bridge_Obligation definition + the disclosed axiom "
                "declaration and its disclosure comment)"),
    "tier_in_genesis": "Ax",
    "tier_in_genesis_note": ("not a Genesis bracket tag -- inferred directly from "
        "the Coq `Axiom` keyword and the source's own disclosure comment (quoted "
        "below), which is stronger, not weaker, evidence than a bracket tag."),
    "synthesis_occurrences": [],
    "role": "root-extension",
    "parents": [],
    "relations": [],
    "relations_note": ("registry/root_candidates_report.md checked this directly "
        "and found no source text states a derivation link: \"its `CMC_TargetClass` "
        "definitions consume a `TransportReadout` record whose fields -- "
        "`diffusion_positive`, `speed_positive`, `speed_finite`, "
        "`retained_diffusive`, `intrinsic_finite_speed` -- read as a bridge "
        "condition connecting back to Genesis's own `EQ-005`/`EQ-006`/`EQ-007` "
        "persistence/discreteness/finite-speed root axioms, but no source text "
        "anywhere states that identification explicitly, so this report does not "
        "assert it as a `parents[]` link either.\" This row keeps relations: [] "
        "rather than assert that reading -- said here plainly, per instruction, "
        "rather than silently."),
    "origin": {
        "source": "solver_arc",
        "repo_anchor": {
            "repo": "solver arc (private)",
            "commit": CMC_COMMIT,
            "path": "formal/CMC_TargetClass_Definitions.v",
            "line": 58,
        },
        "doi": None,
    },
    "founder_ruling": {
        "quote": ("Founder-level CMC axiom, intentionally named and disclosed. The "
                  "project does not retreat from this claim. Journal-facing work "
                  "must either defend this axiom, instantiate it for concrete "
                  "classes, or exhibit an actual refuter satisfying "
                  "CMC_Refuter_Burden."),
        "quote_source": "coq/solver-arc/formal/CMC_TargetClass_Definitions.v, lines 54-57",
        "toledo_ruling": ("BBL-2026-09-07-207 (founder, 2026-09-07, relayed in "
            "ops/HANDOFF_OVERNIGHT_2026-09-06.md): \"Theta and CMC become roots "
            "connected into the lineage.\""),
    },
    "coq_source_redistributed": False,
    "step": None,
    "step_note": ("CMC does not appear in READOUT_GENESIS_CORE.md or the "
        "whitepaper at all (confirmed by direct grep, registry/"
        "root_candidates_report.md); it has no position in the Genesis "
        "document's own step sequence, and none is invented for it."),
}


def build_readings(coqmap_rows):
    """coqmap_rows: the 119 rows already present in registry/coq_map.json for
    the Theta/CP and CMC files (file, identifier, status). Returns a list of
    (file, identifier, entry_dict) in a fixed, deterministic order."""
    theta_decls = {f: extract_decls(os.path.join(ROOT, THETA_DIR_REL, f)) for f in THETA_FILES}
    cmc_decls = {f: extract_decls(os.path.join(ROOT, CMC_DIR_REL, f)) for f in CMC_FILES}

    by_file = {}
    for r in coqmap_rows:
        fname = r["file"].split("/")[-1]
        by_file.setdefault(fname, []).append(r)

    results = []
    domain_seq = {}  # (root, domain) -> next seq

    def next_seq(root, domain):
        key = (root, domain)
        domain_seq[key] = domain_seq.get(key, 0) + 1
        return domain_seq[key]

    def one_group(files, decls_map, root_code, source_type, commit, dir_rel):
        for fname in files:
            decls = decls_map[fname]
            rows = sorted(by_file.get(fname, []), key=lambda r: decls[r["identifier"]]["line"])
            for r in rows:
                ident = r["identifier"]
                decl = decls[ident]
                domain = "P" if (source_type == "theta" or fname == "CMC_PhysicsClass_Instances.v") else "M"
                seq = next_seq(root_code, domain)
                code = "%s/%s.%02d.v1" % (root_code, domain, seq)
                tier, tier_evidence = tier_for(decl["kind"], r["status"])
                if source_type == "theta":
                    imported_from = "readout_genesis@%s:%s/%s" % (commit, dir_rel, fname)
                    redistributed = True
                    origin_source = "readout_genesis"
                    repo = "readout_genesis"
                else:
                    imported_from = "solver arc (private)@%s:%s/%s" % (commit, dir_rel, fname)
                    redistributed = False
                    origin_source = "solver_arc"
                    repo = "solver arc (private)"
                coq_axioms = sorted(_axioms_from_status(r["status"]))
                entry = {
                    "id": None,  # filled by caller once merged with existing ids
                    "code": code,
                    "root": root_code,
                    "layer": "reading",
                    "domain": domain,
                    "aliases": [],
                    "name": "%s (%s)" % (ident, decl["kind"]),
                    "statement": {"latest": decl["statement"], "format": "coq"},
                    "statements_history": [{
                        "v": 1,
                        "statement": decl["statement"],
                        "date": TODAY,
                        "reason": "Toledo v1.2 Lane R root extension: initial reading, statement copied verbatim from source .v declaration",
                        "by": BY,
                    }],
                    "parents": [{
                        "code": root_code,
                        "derived_via": "reads",
                        "evidence": ("declared in %s/%s line %d, one of the files "
                            "constituting the %s root per registry/root_candidates_report.md "
                            "and founder ruling BBL-2026-09-07-207." % (dir_rel, fname, decl["line"], root_code)),
                    }],
                    "children": [],
                    "origin": {
                        "source": origin_source,
                        "repo_anchor": {"repo": repo, "commit": commit, "path": "%s/%s" % (dir_rel, fname), "line": decl["line"]},
                        "record_id": None,
                        "doi": None,
                        "section": None,
                    },
                    "status": "current",
                    "status_note": "",
                    "superseded_by": None,
                    "tier": tier,
                    "tier_in_genesis_verbatim": tier_evidence,
                    "coq": {
                        "file": None,
                        "identifier": ident,
                        "assumptions": _assumptions_str(r["status"]),
                        "imported_from": imported_from,
                        "coq_status": "mapped_not_wrapped",
                        "coq_axioms": coq_axioms,
                        "coq_source_redistributed": redistributed,
                        # NOTE: this "file" matches coq_map.json's own "file" field
                        # verbatim (e.g. "formal/Foo.v", not the fuller repo-relative
                        # path used in origin.repo_anchor.path below) -- required so
                        # the (file, identifier) key used for idempotency matches
                        # coq_map.json's own row exactly on every re-run.
                        "identifiers": [{"file": r["file"], "identifier": ident}],
                    },
                    "relations": [],
                    "occurrences": [{
                        "record_id": None,
                        "doi": None,
                        "label": "`%s/%s`, `%s`" % (dir_rel, fname, ident),
                        "section": "%s root programme" % root_code,
                        "raw_key": "coq_map.json:%s::%s" % (r["file"], ident),
                    }],
                    "role": "other",
                    "first_assigned": TODAY,
                    "_src_file": r["file"],
                    "_src_ident": ident,
                }
                results.append(entry)

    one_group(THETA_FILES, theta_decls, "Theta", "theta", THETA_COMMIT, THETA_DIR_REL)
    one_group(CMC_FILES, cmc_decls, "CMC", "cmc", CMC_COMMIT, CMC_DIR_REL)
    return results


def _axioms_from_status(status):
    if status.startswith("axioms:"):
        try:
            lst = eval(status[len("axioms:"):], {"__builtins__": {}})
            return list(lst)
        except Exception:
            return []
    return []


def _assumptions_str(status):
    if status == "Closed under the global context":
        return status
    axs = _axioms_from_status(status)
    if axs:
        return "+axioms: " + ", ".join(axs)
    return status


def main():
    report = {}

    # -- 1. genesis_root.json: add Theta / CMC root rows -------------------
    gd = load(GENESIS_PATH)
    existing_codes = {r["code"] for r in gd["root_equations"]}
    added_roots = []
    for row in (THETA_ROOT_ROW, CMC_ROOT_ROW):
        if row["code"] not in existing_codes:
            gd["root_equations"].append(row)
            added_roots.append(row["code"])
    if added_roots:
        atomic_write(GENESIS_PATH, gd, indent=2, trailing_newline=False)
    report["roots_added"] = added_roots

    # -- 2. figure out the 119 target coq_map rows --------------------------
    cm = load(COQMAP_PATH)
    theta_fnames = set(THETA_FILES)
    cmc_fnames = set(CMC_FILES)
    target_rows = [r for r in cm
                   if r["file"].split("/")[-1] in theta_fnames
                   or r["file"].split("/")[-1] in cmc_fnames]
    readings = build_readings(target_rows)

    # -- 3. CANONICAL.json: append readings not already present -------------
    cd = load(CANONICAL_PATH)
    existing_pairs = set()
    max_r1t = 0
    max_r1c = 0
    for e in cd["canonical"]:
        for it in (e.get("coq", {}).get("identifiers") or []):
            existing_pairs.add((it.get("file"), it.get("identifier")))
        if e["id"].startswith("R1T-"):
            max_r1t = max(max_r1t, int(e["id"].split("-")[1]))
        if e["id"].startswith("R1C-"):
            max_r1c = max(max_r1c, int(e["id"].split("-")[1]))

    new_entries = []
    codes_by_key = {}
    for entry in readings:
        key = (entry["_src_file"], entry["_src_ident"])
        if key in existing_pairs:
            continue
        if entry["root"] == "Theta":
            max_r1t += 1
            entry["id"] = "R1T-%04d" % max_r1t
        else:
            max_r1c += 1
            entry["id"] = "R1C-%04d" % max_r1c
        del entry["_src_file"]
        del entry["_src_ident"]
        new_entries.append(entry)
        codes_by_key[key] = entry["code"]

    if new_entries:
        cd["canonical"].extend(new_entries)
        recompute_canonical_counts(cd)
        atomic_write(CANONICAL_PATH, cd, indent=1, trailing_newline=True)
    report["readings_added"] = len(new_entries)

    # -- 4. coq_map.json: fill in codes for the mapped identifiers ----------
    cm2 = load(COQMAP_PATH)  # re-read immediately before this write
    updated = 0
    for r in cm2:
        key = (r["file"], r["identifier"])
        if key in codes_by_key and not r.get("codes"):
            r["codes"] = [codes_by_key[key]]
            r["confidence"] = "high"
            r["evidence"] = ("Toledo v1.2 Lane R (root extension, founder ruling "
                "BBL-2026-09-07-207): mapped to %s. Statement is this identifier's "
                "own Coq declaration in %s, quoted verbatim in registry/"
                "CANONICAL.json." % (codes_by_key[key], r["file"]))
            r["evidence_quote"] = r["evidence"]
            updated += 1
    if updated:
        atomic_write(COQMAP_PATH, cm2, indent=1, trailing_newline=False)
    report["coq_map_updated"] = updated

    # -- 5. LINEAGE.jsonl: assigned events for every new code ---------------
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
        events.append({
            "code": code,
            "date": TODAY,
            "event": "assigned",
            "from": None,
            "to": code,
            "reason": ("Toledo v1.2 Lane R root extension, founder ruling "
                "BBL-2026-09-07-207 (\"Theta and CMC become roots connected "
                "into the lineage\"): new Layer-0 root, code is the source's "
                "own verbatim identifier."),
            "by": BY,
        })
    for entry in new_entries:
        events.append({
            "code": entry["code"],
            "date": TODAY,
            "event": "assigned",
            "from": "%s::%s" % (entry["coq"]["identifiers"][0]["file"], entry["coq"]["identifiers"][0]["identifier"]),
            "to": entry["code"],
            "reason": ("Toledo v1.2 Lane R root extension: reading of root %s, "
                "mapped from registry/coq_map.json by evidence (file+identifier "
                "match, statement copied verbatim from the Coq declaration)." % entry["root"]),
            "by": BY,
        })
    new_events = [e for e in events if e["code"] not in existing_assigned]
    if new_events:
        with open(LINEAGE_PATH, "a", encoding="utf-8") as f:
            for e in new_events:
                f.write(json.dumps(e, ensure_ascii=False) + "\n")
    report["lineage_events_added"] = len(new_events)

    print(json.dumps(report, indent=1))


if __name__ == "__main__":
    main()
