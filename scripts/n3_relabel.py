#!/usr/bin/env python3
"""N3 relabel (REGISTRAR pass) — turns the pre-N3 CANONICAL.json (253 S1-canonicalisation
objects, old ad-hoc shape) into the T1-ratified SCHEMA.md shape: codes rooted in Genesis's
own genesis_root.json ids, parents/derived_via, origin/status, step, cross-domain relations,
and a seeded LINEAGE.jsonl.

Readout-not-truth discipline: every root/parent decision below quotes the evidence it is
based on (genesis_root.json's own statement text, or registry/COLLAPSE.md's own recorded
reading, which is itself already an evidenced reading of CANONICAL.json's `relations`
field / keyword match / domain convention — see COLLAPSE.md sec 3.1 for the tier of each).

Run: python3 scripts/n3_relabel.py
Inputs : registry/CANONICAL.json (pre-N3), registry/genesis_root.json, registry/COLLAPSE.md,
         registry/textbook_manifest.yaml, registry/eq_21425420.json (CAN-054 split source)
Outputs: registry/CANONICAL.pre-N3.json (copy of the input, untouched)
         registry/CANONICAL.json (rewritten, SCHEMA.md shape)
         registry/LINEAGE.jsonl (seeded: one 'assigned' event per final code + 'split' events)
"""
import json, re, subprocess, shutil, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
DATE = "2026-09-06"
BY = "N3 registrar"

# ---------------------------------------------------------------------------
# 0. Load inputs, snapshot the pre-N3 file
# ---------------------------------------------------------------------------
PRE_N3_PATH = REG / "CANONICAL.pre-N3.json"
if not PRE_N3_PATH.exists():
    shutil.copy(REG / "CANONICAL.json", PRE_N3_PATH)
pre = json.load(open(PRE_N3_PATH, encoding="utf-8"))

genesis = json.load(open(REG / "genesis_root.json", encoding="utf-8"))
genesis_rows = {r["code"]: r for r in genesis["root_equations"]}
genesis_step = {c: r["step"] for c, r in genesis_rows.items()}

import yaml
manifest = yaml.safe_load(open(REG / "textbook_manifest.yaml", encoding="utf-8"))
manifest_by_record = {}
for part in manifest["parts"]:
    for ch in part.get("chapters", []) or []:
        rid = ch.get("record_id") or ch.get("seed_record")
        if rid:
            manifest_by_record[rid] = ch

collapse_text = open(REG / "COLLAPSE.md", encoding="utf-8").read()

try:
    GIT_SHA = subprocess.check_output(["git", "-C", str(ROOT), "rev-parse", "HEAD"], text=True).strip()
except Exception:
    GIT_SHA = "unknown"

# ---------------------------------------------------------------------------
# 1. CAN-054 split (dedup review over-merge fix)
#    eq_21425420.json labels (18)-(29),(32)-(34),(38),(40)-(42) = rank-bounded retention (KEEP CAN-054)
#                            (43)-(48)                          = Human-LoRA rival-model ladder (NEW CAN-257)
#                            (36)-(37)                          = well-being vector W_n + maladaptive-cost C_mal (NEW CAN-258)
# ---------------------------------------------------------------------------
entries = pre["canonical"]
by_id = {e["id"]: e for e in entries}
can054 = by_id["CAN-054"]

RIVAL_LABELS = {"(43)", "(44)", "(45)", "(46)", "(47)", "(48)"}
WELLBEING_LABELS = {"(36)", "(37)"}

occ054 = can054["occurrences"]
occ_keep = [o for o in occ054 if o["label"] not in RIVAL_LABELS | WELLBEING_LABELS]
occ_rival = [o for o in occ054 if o["label"] in RIVAL_LABELS]
occ_well = [o for o in occ054 if o["label"] in WELLBEING_LABELS]
assert occ_rival and occ_well, "CAN-054 split source labels not found in pre-N3 occurrences"

can054["occurrences"] = occ_keep
can054["object"] = "Selective retention as a rank-bounded factorized update (Human LoRA) — split 2026-09-06, keeps only the rank-bounded retention mechanism"
can054["notes"] = (can054.get("notes") or "") + (
    " [N3 split 2026-09-06: this id previously also carried the Human-LoRA rival-model "
    "ladder (eq.(43)-(48), now CAN-257) and the well-being vector / maladaptive-cost pair "
    "(eq.(36)-(37), now CAN-258) — over-merge caught in dedup review; occurrences (18)-(29),"
    "(32)-(34),(38),(40)-(42) of record 21425420 kept here as the rank-bounded retention "
    "object proper.]"
)

can257 = {
    "id": "CAN-257",
    "key": "human-lora-rival-model-ladder",
    "object": "Six rival hypotheses (M0-M5) for the mechanism behind the Human-LoRA update O_H",
    "root_object": "L_R",
    "domain": "human–AI",
    "reading": "A candidate-model ladder for HOW the retention operator updates — of which the rank-bounded factorized update (CAN-054, M2) is one candidate among six, not the only one; split out of CAN-054 because it is a distinct object (a hypothesis space over mechanisms) from the mechanism CAN-054 itself proposes.",
    "canonical_text": "M0: context-only state change; M1: sparse but not low-rank update; M2: low-rank factorized update (= CAN-054's own ΔO_n=B_nA_n); M3: regularized full-rank update; M4: finite graph rewiring; M5: hybrid fast trace plus slow update",
    "canonical_source": "Experience Is the Human LoRA eq.(43)-(48) [record 21425420]",
    "tier": "hypothesis/Open (rival-model comparison, not itself proved)",
    "occurrences": occ_rival,
    "in_master_river": None,
    "relations": [{"to": "CAN-054", "type": "reads"}],
    "notes": "[N3 split 2026-09-06, dedup review: dissolved out of the former over-merged CAN-054, which bundled this rival-model ladder together with the rank-bounded retention mechanism and the well-being/maladaptive-cost pair under one id. Distinct object from CAN-054: this is the SPACE of candidate mechanisms, CAN-054 is one member (M2) of that space asserted as the proposed one.]",
    "merged_from": [],
}

can258 = {
    "id": "CAN-258",
    "key": "human-lora-wellbeing-maladaptive-cost",
    "object": "Well-being state vector W_n and multiplicative maladaptive-cost index C_mal[n]",
    "root_object": "L_R",
    "domain": "human–AI",
    "reading": "A distinct measurement object from the retention-update mechanism itself: W_n scores functioning/agency/meaning/relation/competence/repair; C_mal is a multiplicative cost index over rigidity/generalization-failure/misattribution/loss — split out of CAN-054 because it is what the retention update is EVALUATED against, not the update mechanism itself.",
    "canonical_text": "W_n=(F_n,A_n^agency,M_n^meaning,R_n^relation,C_n^competence,Q_n^repair); C_mal[n]=rig(a_n)·gen(a_n)·mis(a_n)·loss(a_n)",
    "canonical_source": "Experience Is the Human LoRA eq.(36)-(37) [record 21425420]",
    "tier": "definition",
    "occurrences": occ_well,
    "in_master_river": None,
    "relations": [{"to": "CAN-054", "type": "reads"}],
    "notes": "[N3 split 2026-09-06, dedup review: dissolved out of the former over-merged CAN-054 — see CAN-257's note for the same source over-merge.]",
    "merged_from": [],
}

entries = [e for e in entries if e["id"] != "CAN-054"] + [can054, can257, can258]
by_id = {e["id"]: e for e in entries}

# raw_to_canonical: remap split labels
r2c = dict(pre["raw_to_canonical"])
for lbl in RIVAL_LABELS:
    key = f"21425420:{lbl}"
    assert r2c.get(key) == "CAN-054"
    r2c[key] = "CAN-257"
for lbl in WELLBEING_LABELS:
    key = f"21425420:{lbl}"
    assert r2c.get(key) == "CAN-054"
    r2c[key] = "CAN-258"

# ---------------------------------------------------------------------------
# 2. The 9 root-spine CAN ids -> Genesis root code (quoted evidence)
# ---------------------------------------------------------------------------
# derived_via: 'restates' when the CAN entry's own text is verbatim/near-verbatim the
# Genesis row's own statement; 'reads'/'specializes' when it elaborates/operationalises it.
SPINE_ROOT = {
    # CAN id : (genesis root code, derived_via, quoted genesis statement, note)
    "CAN-001": ("weld", "restates",
                genesis_rows["weld"]["statement"],
                "CAN-001 is this corpus's own restatement of the Genesis weld itself "
                "(READOUT_GENESIS_CORE.md 'THE ONE-LINE MASTER EQUATION'), independently "
                "corroborated in two further chapters per its own occurrence list."),
    "CAN-002": ("EQ-015", "reads",
                genesis_rows["EQ-015"]["statement"],
                "root_object='F-stepper' per the S1 pass; CAN-002's state tuple "
                "S_n=(G_n,Λ_n,T_n) is the argument the EQ-015 spine stepper/PDE acts on."),
    "CAN-003": ("EQ-015", "restates",
                genesis_rows["EQ-015"]["statement"],
                "CAN-003's S_{n+1}=F(S_n,u_n,c_n,T_n) is the discrete-stepper reading of "
                "EQ-015's mixed-tier spine PDE (root_object='F-stepper')."),
    "CAN-004": ("EQ-015", "reads",
                genesis_rows["EQ-015"]["statement"],
                "root_object='F-stepper' per the S1 pass; the Retention->...->Report "
                "admission order is the semantic/epistemic unpacking of one F-step."),
    "CAN-006": ("weld", "restates",
                genesis_rows["weld"]["statement"],
                "CAN-006's q_{D,n+1}∘F_n=F#_{D,n}∘q_{D,n} is verbatim the weld's own "
                "commuting-square clause '{q_D : q_D∘F=F#_D∘q_D}' (root_object='domain weld q_D')."),
    "CAN-007": ("weld", "reads",
                genesis_rows["weld"]["statement"],
                "root_object='domain weld q_D'; the no-early-collapse reader-equivalence "
                "z~z' is the horizon-bounded refinement of the weld's own q_D-admissibility "
                "condition, not a byte-identical restatement of it."),
    "CAN-008": ("A.5", "restates",
                genesis_rows["A.5"]["statement"],
                "root_object='non-collapse'; CAN-008's S_n≠Z_{D,n}≠D_{D,n} is the same "
                "three-way non-identity as Genesis A.5 '𝔖_n ≠ 𝔃_{α,n} ≠ 𝒟_{α,n}' (state, "
                "candidate representation, discovered quotient), same object under a "
                "notation substitution (root_object literally says 'non-collapse' — this "
                "IS the S≠Z_D≠D_D row named in the N3 brief)."),
    "CAN-009": ("A.8", "reads",
                genesis_rows["A.8"]["statement"],
                "root_object='decisive record'; CAN-009's ΔA_past=0 (the historical "
                "occurrence is not rewritten) is the same discipline as Genesis A.8 "
                "'sharing a structural node is not the same as being identical at the "
                "level of record' — historical-invariance reads A.8's non-erasure law."),
    "CAN-201": ("EQ-002", "specializes",
                genesis_rows["EQ-002"]["statement"],
                "root_object='readout R'; no genesis_root.json row states "
                "'Readout_{Q,O,c}(S)=z,z≠S' verbatim (checked against all 590 rows: no "
                "match on Q,O,c subscripts or the z≠S inequality) — nearest attested root "
                "axiom is EQ-002/E00.2, the general distinguisher axiom "
                "'∃A: A discriminates E1≠E2' that Genesis's readout gate operationalises "
                "with explicit reader/observer/context (Q,O,c) parameters and an explicit "
                "non-identity guarantee. Recorded as a drift note, not asserted as an "
                "exact-text match."),
}

DOMAIN_LETTER = {
    "epistemic": "E", "human–AI": "H", "social": "S",
    "world-system": "W", "method": "M", "root": "M",
}

# ---------------------------------------------------------------------------
# 3. COLLAPSE.md's own reading table -> parent CAN id + evidence tier, for the
#    244 non-spine entries (extracted mechanically from the committed file, not
#    retyped, so it stays a readout of COLLAPSE.md rather than a fresh assertion).
# ---------------------------------------------------------------------------
rows = re.findall(
    r"\|\s*(CAN-\d+)\s*\|\s*([^|]+?)\s*\|\s*(CAN-\d+)\s*\([^|]*?\)[^|]*\|\s*([^|]+?)\s*\|",
    collapse_text,
)
def _norm_evidence(tier: str) -> str:
    # strip only a trailing "(corrected...)" annotation; keep tags like "(weakest)"
    # that are part of the tier name itself (see COLLAPSE.md sec 3.1).
    base = re.sub(r"\s*\(corrected[^)]*\)\s*$", "", tier.strip())
    return base.strip()
collapse_parent = {r[0]: (r[2], _norm_evidence(r[3])) for r in rows}

SPINE_IDS = set(SPINE_ROOT)
non_spine_ids = set(by_id) - SPINE_IDS - {"CAN-257", "CAN-258"}
missing = non_spine_ids - set(collapse_parent)
assert not missing, f"COLLAPSE.md mapping missing ids: {missing}"

EVIDENCE_TO_DERIVED_VIA = {
    "graph-evidenced": "reads",
    "manual (verified textual match)": "restates",
    "textual/keyword": "reads",
    "domain-default (weakest)": "reads",
}
DOMAIN_DEFAULT_IDS = set()  # filled below for the 44 weakest-evidence ids

# CAN-257 / CAN-258 (new split children) inherit CAN-054's own COLLAPSE.md parent
# (CAN-004, graph-evidenced) — they are facets of the same retention-update complex
# CAN-054 itself reads; a finer-grained future pass may re-route them individually.
collapse_parent["CAN-257"] = collapse_parent["CAN-054"]
collapse_parent["CAN-258"] = collapse_parent["CAN-054"]

# ---------------------------------------------------------------------------
# 4. tier normalisation (150+ free-text strings -> the small SCHEMA enum)
# ---------------------------------------------------------------------------
def normalize_tier(raw: str) -> str:
    t = raw or ""
    tl = t.lower()
    if "retracted" in tl:
        return "RETRACTED"
    if "th_coqc" in tl:
        return "Th_coqc"
    if "finite_diagnostic" in tl or "governance" in tl:
        return "finite_diagnostic"
    if re.search(r"\bdr\b", t) or "dr (" in tl or "dr/" in tl:
        return "Dr"
    if re.search(r"\bax\b", t) or "axiom" in tl:
        return "Ax"
    if "definition" in tl:
        return "Definition"
    if "hypothesis" in tl or "open" in tl:
        return "Open"
    if "law" in tl or "theorem" in tl or "proposition" in tl or "measurement" in tl:
        return "Dr"
    return "untagged"

# ---------------------------------------------------------------------------
# 5. Build (root, domain_letter) grouping + sequence, in original (river) order
# ---------------------------------------------------------------------------
def entry_root(e):
    cid = e["id"]
    if cid in SPINE_ROOT:
        return SPINE_ROOT[cid][0]
    parent_id, _tier = collapse_parent[cid]
    return SPINE_ROOT[parent_id][0]

def entry_num(cid):
    return int(re.search(r"\d+", cid).group())

entries_sorted = sorted(entries, key=lambda e: entry_num(e["id"]))

group_seq = {}
new_code = {}
new_root = {}
new_seq = {}
for e in entries_sorted:
    cid = e["id"]
    root = entry_root(e)
    d_letter = DOMAIN_LETTER[e["domain"]]
    key = (root, d_letter)
    group_seq[key] = group_seq.get(key, 0) + 1
    nn = group_seq[key]
    code = f"{root}/{d_letter}.{nn:02d}.v1"
    new_code[cid] = code
    new_root[cid] = root
    new_seq[cid] = nn

assert len(set(new_code.values())) == len(new_code), "duplicate codes generated"

# ---------------------------------------------------------------------------
# 6. origin{} from the first occurrence + textbook_manifest.yaml
# ---------------------------------------------------------------------------
def build_origin(e):
    occ = e.get("occurrences") or []
    if not occ:
        return {"source": "textbook", "repo_anchor": None, "record_id": None,
                "doi": None, "section": None, "version": None, "date": None, "label": None}
    o0 = occ[0]
    rid = o0["record_id"]
    ch = manifest_by_record.get(rid, {})
    return {
        "source": "textbook",
        "repo_anchor": None,
        "record_id": rid,
        "doi": ch.get("doi"),
        "section": None,
        "version": ch.get("version"),
        "date": ch.get("date"),
        "label": o0.get("label"),
    }

def build_occurrences(e):
    out = []
    for o in e.get("occurrences") or []:
        ch = manifest_by_record.get(o["record_id"], {})
        out.append({
            "record_id": o["record_id"],
            "doi": ch.get("doi"),
            "label": o.get("label"),
            "section": None,
            "raw_key": f"{o['record_id']}:{o.get('label')}",
        })
    return out

# ---------------------------------------------------------------------------
# 7. statements_history special cases (BBL-172 supersession recorded IN the
#    entry's own history, not as a separate status) — quoted from the pre-N3
#    entry's own `notes` field.
# ---------------------------------------------------------------------------
STATEMENTS_HISTORY_OVERRIDE = {
    "CAN-021": [
        {"v": 1, "statement": "ΔA_H(x,c) = A_H^post − A_H^pre",
         "date": "2026-09-05", "reason": "earlier accessibility-change diagnostic reading",
         "by": "Meaning Before Naming (record 22410666)"},
        {"v": 2,
         "statement": "I_{H,n}=Retrieve(M_{H,n}|c_n,Q_n); Res_H(n)=C_H(E_n^cur,I_{H,n}|c_n,Q_n) ∈[0,1]; Res≠Identity, Res≠Truth, Res≠Retention, Res≠Improvement",
         "date": "2026-09-05",
         "reason": "current congruence definition; supersedes the accessibility-diagnostic reading per the source's own stated fact (rule 2, latest formulation wins)",
         "by": "Experience Is Meaning-Giving (record 22357744)"},
    ],
    "CAN-132": [
        {"v": 1, "statement": "p*_{A,g} = max_{π∈Π^feas_A(g)} Pr^π(...)",
         "date": "2026-09-05", "reason": "older feasible-set form (CBC-08)",
         "by": "Choice Begins Before Choice (record 22357788)"},
        {"v": 2,
         "statement": "p*_{A,g}(h,z;T,B,P) = max_{π∈Π^{wit}_A(g;h,z,T,B)} Pr^π_P(Read_g∩D_g∩X_g∩F_g), with p*_{A,g}:=0 when the set is empty; p*_A=(p*_{A,g})_{g∈G}, C^α_A={g:p*_{A,g}≥α}; A^{corr}_A(h,z;T,B,P,w):=Σ_g w_g p*_{A,g}∈[0,1]; chain-rule p_{A,g}(π)=r·d·x·f",
         "date": "2026-09-05",
         "reason": "witnessed-set Π^wit form ('tier-raising pass'); Master River's own FixBox states v1.0 used the feasible-set form, since replaced by this witnessed-set form",
         "by": "Potential as a Readout (record 22361830)"},
    ],
}

# ---------------------------------------------------------------------------
# 8. Cross-domain relations (task step 7) — same_form_different_theory unless a
#    documented phi-criterion (renaming / positive-scale / constant-substitution,
#    exact) is shown; each carries a one-line phi check.
# ---------------------------------------------------------------------------
EXTRA_RELATIONS = {}  # old CAN id -> list of relation dicts (target uses OLD CAN id or a bare genesis code)

def add_rel(cid, type_, target, note, evidence=""):
    EXTRA_RELATIONS.setdefault(cid, []).append(
        {"type": type_, "target": target, "note": note, "evidence": evidence}
    )

# (a) social-instability stepper (Causal Grammar A=L_R+Gamma) <-> Genesis spine PDE / Face 1-4
add_rel("CAN-115", "same_form_different_theory", "EQ-015",
        "phi-check: CAN-115's A:=L_R+Gamma augments the forced Laplacian with a "
        "social-specific relational-damping term Gamma not present in EQ-015's spine PDE; "
        "no renaming/positive-scale/constant-substitution bijection maps A to L_R alone "
        "(Gamma is added structure, not a relabelling) -> same_form_different_theory, not a merge.",
        evidence="CAN-115: 'L_R = D_W − W (forced Laplacian); A := L_R + Γ'")
add_rel("CAN-115", "same_form_different_theory", "Face.1.Eigenmode",
        "phi-check: same reasoning as the EQ-015 edge above, applied to the eigenmode face "
        "(Face 1's L_R φ_k=λ_k φ_k) that CAN-115's own A operator would be diagonalised against.",
        evidence="Face.1.Eigenmode: 'L_R φ_k = λ_k φ_k'")
add_rel("CAN-115", "same_form_different_theory", "Face.4",
        "phi-check: CAN-115's L1 invariance/recurrence result parallels Face 4's energy "
        "monotonicity dE/dt<=0, but is proved for the augmented operator A=L_R+Gamma, not L_R "
        "itself -> same_form_different_theory.",
        evidence="Face.4: 'dE/dt = −D ‖v‖² ≤ 0'")

# (b) Causal Ethics spectral margin/energy <-> Face 3 / Face 4
add_rel("CAN-118", "same_form_different_theory", "Face.4",
        "phi-check: V_{A,R_A}(M(t')) with d/dt'V<=0 is a Lyapunov/energy functional over the "
        "ethics-regime state M(t'), the same monotone-decay SHAPE as Face 4's dE/dt<=0 over the "
        "physical field Phi, but no bijection is shown between the ethics-domain state and the "
        "physical field -> same_form_different_theory.",
        evidence="CAN-118: 'd/dt' V_{A,R_A}(M(t')) ≤ 0'; Face.4: 'dE/dt = −D ‖v‖² ≤ 0'")
add_rel("CAN-118", "same_form_different_theory", "Face.3.CriticalSplit",
        "phi-check: Delta_spec(R_A)>0 (a spectral-margin admissibility test on the regime) has "
        "the same gate SHAPE as Face 3's critical split lambda_c=D^2/(4MK) separating regimes, "
        "but the ethics-domain spectrum is not shown to be the same operator's spectrum "
        "-> same_form_different_theory.",
        evidence="CAN-118: 'Δ_spec(R_A) > 0'; Face.3.CriticalSplit: 'λ_c = D² / (4 M K)'")

# (c) Human LoRA low-rank retention <-> Face 1 eigenmode / Face 9 CPTP
add_rel("CAN-054", "same_form_different_theory", "Face.1.Eigenmode",
        "phi-check: the rank-bounded factorization Delta O=B_nA_n (rank<=m_n) is a finite-rank "
        "operator update, the same SHAPE as a truncated eigenmode expansion (Face 1), but B_n,A_n "
        "are not shown to be eigenvectors of L_R -> same_form_different_theory.",
        evidence="CAN-054: 'rank_ℚ(B_nA_n)≤m_n (proved)'; Face.1.Eigenmode: 'L_R φ_k = λ_k φ_k'")
add_rel("CAN-054", "same_form_different_theory", "Face.9",
        "phi-check: O_H[n+1]=O_H[n]+g_n B_nA_n+eps_n is a gated additive update, the same SHAPE "
        "as a completely-positive trace-preserving channel update (Face 9 Kraus completeness "
        "Sum K_j^† K_j = I), but B_n,A_n are not shown to be Kraus operators of a channel "
        "-> same_form_different_theory.",
        evidence="CAN-054: 'O_H[n+1]=O_H[n]+ΔO_n^ret+ε_n'; Face.9: 'Σ_j K_j† K_j = I'")

# (d) accessibility kernel exp(beta*a+mu*m-nu*c) & momentum <-> Face 2 decay
add_rel("CAN-198", "same_form_different_theory", "Face.2",
        "phi-check: kappa^sem_{t+1} propto kappa^sem,(0)_t * exp(beta*a+mu*m-nu*c+xi) is an "
        "exponential update kernel, the same SHAPE as Face 2's exponential eigenmode decay "
        "|a_k[n]|<=|a_k[0]|exp(-gamma_k n Delta_theta), but the accessibility kernel's exponent "
        "carries THREE independent, both-signed social terms (+beta*a, +mu*m, -nu*c) against "
        "Face 2's single monotone decay constant gamma_k -> no positive-scale substitution "
        "reduces one to the other; same_form_different_theory.",
        evidence="CAN-198: 'κ^{sem}_{t+1} ∝ κ^{sem,(0)}_t·exp(βa_{Q,t}(e)+μm_t(e)−νc_{A,t,Q}(e)+ξ_t(e))'; "
                 "Face.2: '|a_k[n]| ≤ |a_k[0]| exp(−γ_k n Δθ)'")

# (e)/(f) chem RT-LEDGER<->Face 11/NC-79, group readout Z_G<->F-stepper on a graph:
# NOT YET RESOLVABLE at N3 — neither 'RT-LEDGER'/'NC-79' nor a 'Z_G' group-readout object
# is present anywhere in the 253+2 CANONICAL.json entries or in genesis_root.json's 590
# rows (checked by grep over both files, 2026-09-06); the chem/quantum/relativity/biology
# domain rule registries (124 rules) that would carry these objects are N4 scope (handoff
# TODO N4), not yet imported. Recorded as an open item rather than fabricated.
OPEN_RELATION_ITEMS = [
    "chem RT-LEDGER kernel rules <-> Face 11 obstruction / NC-79 ledger: no RT-LEDGER/NC-79 "
    "object exists yet in CANONICAL.json or genesis_root.json (grep, 2026-09-06) — the chem "
    "domain rule registry (17 rules) is N4 scope; add this relation when that registry is "
    "imported, not before.",
    "group readout Z_G <-> F-stepper on a graph: no Z_G object exists yet in CANONICAL.json "
    "or genesis_root.json (grep, 2026-09-06) — likely part of the quantum/relativity domain "
    "rule registries (N4 scope); add this relation when that registry is imported.",
]

# CAN-002/003/008/222 (root components) -> relation to CAN-001 (task-named requirement)
for cid, note in [
    ("CAN-002", "root state tuple S_n is the argument CAN-001's F-stepper acts on"),
    ("CAN-003", "root stepper S_{n+1}=F(S_n,u_n,c_n,T_n) is the F-component of CAN-001's weld"),
    ("CAN-008", "constitutional non-collapse S_n≠Z_{D,n}≠D_{D,n} is the guard the weld's own "
                "domain-admission clause (q_D) presupposes"),
    ("CAN-222", "Genesis's own bundled non-collapse family is a vocabulary-specific instance "
                "of the same guard CAN-008 states once, which CAN-001's weld presupposes"),
]:
    add_rel(cid, "reads", "CAN-001", note)

# CAN-118 -> CAN-135 refines (task step 5: Causal Ethics / Causal Agency early objects
# later refined; keep status=current, record the relation, never mark superseded)
add_rel("CAN-118", "refines", "CAN-135",
        "CAN-135 (2026-09-05, 'Potential as a Readout') restates Delta_spec(R)>0 with an "
        "explicit channel-openness/rate criterion; CAN-118 (2026-01-31, 'CAUSAL ETHICS') kept "
        "status=current, not superseded, per horizontal-knowledge discipline (BBL-165) — both "
        "are valid readings at their own dates. Placed on CAN-118 per the task instruction to "
        "mark the earlier object, not to invert the relation's own semantic direction.",
        evidence="CAN-118: 'Δ_spec(R_A) > 0'; CAN-135: 'Δspec(Ri) > 0 ⟺ channel_i = open ∧ Ṙ_i ≠ 0'")

# ---------------------------------------------------------------------------
# 9. Assemble final entries
# ---------------------------------------------------------------------------
final = []
for e in entries_sorted:
    cid = e["id"]
    code = new_code[cid]
    root = new_root[cid]
    d_letter = DOMAIN_LETTER[e["domain"]]

    if cid in SPINE_ROOT:
        _, derived_via, _quote, _note = SPINE_ROOT[cid]
        parents = [{"code": root, "derived_via": derived_via}]
    else:
        parent_id, tier = collapse_parent[cid]
        parents = [{"code": new_code[parent_id], "derived_via": EVIDENCE_TO_DERIVED_VIA[tier]}]

    old_tier = e.get("tier", "")
    tier_norm = normalize_tier(old_tier)

    occ_new = build_occurrences(e)
    origin = build_origin(e)

    # relations: keep existing (old {"to","type"} -> new {"type","target","note"}), then extras
    rel_new = []
    for r in e.get("relations") or []:
        tgt = r.get("to")
        tgt_code = new_code.get(tgt, tgt)  # resolve an old CAN id to its new code if known
        rel_new.append({"type": r.get("type"), "target": tgt_code, "note": "", "evidence": ""})
    for r in EXTRA_RELATIONS.get(cid, []):
        tgt = r["target"]
        tgt_code = new_code.get(tgt, tgt)  # resolve CAN-xxx targets, pass genesis/Face codes through
        rel_new.append({"type": r["type"], "target": tgt_code, "note": r["note"], "evidence": r.get("evidence", "")})

    if cid in STATEMENTS_HISTORY_OVERRIDE:
        hist = STATEMENTS_HISTORY_OVERRIDE[cid]
        latest_statement = hist[-1]["statement"]
    else:
        latest_statement = e["canonical_text"]
        hist = [{"v": 1, "statement": latest_statement, "date": DATE,
                 "reason": "N3 relabel: initial capture from the S1 canonicalisation pass",
                 "by": BY}]

    final.append({
        "id": cid,
        "code": code,
        "root": root,
        "layer": "reading",
        "domain": d_letter,
        "aliases": [e["key"]] if e.get("key") else [],
        "name": e.get("object") or e.get("key") or code,
        "statement": {"latest": latest_statement, "format": "ascii-math"},
        "statements_history": hist,
        "parents": parents,
        "children": [],  # computed below
        "origin": origin,
        "status": "current",
        "status_note": "",
        "superseded_by": None,
        "tier": tier_norm,
        "tier_in_genesis_verbatim": old_tier,
        "coq": {"file": None, "identifier": None, "assumptions": None, "imported_from": None,
                "coq_status": "not_yet_formalised", "coq_axioms": [], "coq_source_redistributed": True},
        "relations": rel_new,
        "occurrences": occ_new,
        "role": "other",
        "first_assigned": DATE,
        # BBL-192/193 addendum: step = root's own Genesis step + a Toledo-registry-local
        # sub-index (this reading's sequence number under that root/domain group, /10000
        # so it can never cross into the next Genesis root's own step value). This is a
        # Toledo-computed ordering aid, distinct from genesis_root.json's own `step` field
        # (which only exists for genesis_root.json's 590 rows, not for these readings).
        "step": genesis_step[root] + new_seq[cid] * 0.0001,
        # non-schema, additive debugging aid: what this code's reading/root_object was
        "_n3_reading_note": e.get("reading"),
        "_n3_root_object": e.get("root_object"),
        "_n3_in_master_river": (sorted({int(x) for x in e["in_master_river"]})
                                 if e.get("in_master_river") else None),
    })

# children[] = invert parents[] across the array (only when the parent IS itself a code
# present in this array — genesis-root parents outside CANONICAL.json get no computed
# children here, exactly as SCHEMA.md expects: that inversion is a docs-site/N4+ job).
code_set = {f["code"] for f in final}
children_map = {c: [] for c in code_set}
for f in final:
    for p in f["parents"]:
        if p["code"] in children_map:
            children_map[p["code"]].append(f["code"])
for f in final:
    f["children"] = sorted(children_map[f["code"]])

# ---------------------------------------------------------------------------
# 10. raw_to_canonical: remap old CAN-id values to new codes
# ---------------------------------------------------------------------------
old_to_new = {cid: new_code[cid] for cid in new_code}
raw_to_canonical_final = {k: old_to_new[v] for k, v in r2c.items()}

# ---------------------------------------------------------------------------
# 11. Validation (T7.1 orphans / T7.3 cycles / T7.4 duplicates / T7.8 grammar)
# ---------------------------------------------------------------------------
CODE_RE = re.compile(
    r"^(?P<root>EQ-0\d{2}|[A-Za-z][A-Za-z0-9]*(?:[._-][A-Za-z0-9]+)*)"
    r"(?:/(?P<domain>[EHSWMPCB])\.(?P<seq>\d{2,4})(?:\.v(?P<rev>[1-9]\d*))?)?$"
)
problems = []
codes_seen = set()
for f in final:
    if not f["parents"]:
        problems.append(f"orphan: {f['code']} has no parents")
    if f["code"] in codes_seen:
        problems.append(f"duplicate code: {f['code']}")
    codes_seen.add(f["code"])
    if not CODE_RE.match(f["code"]):
        problems.append(f"grammar violation: {f['code']}")
# cycle check: parents graph is at most 2 levels by construction (reading -> spine's genesis
# root, which is never itself a code in this array), so no cycle is possible; verify anyway.
graph = {f["code"]: [p["code"] for p in f["parents"]] for f in final}
def has_cycle():
    WHITE, GRAY, BLACK = 0, 1, 2
    color = {c: WHITE for c in graph}
    def visit(c, stack):
        if c not in graph:
            return None
        color[c] = GRAY
        for p in graph[c]:
            if color.get(p, WHITE) == GRAY:
                return stack + [c, p]
            if color.get(p, WHITE) == WHITE:
                r = visit(p, stack + [c])
                if r:
                    return r
        color[c] = BLACK
        return None
    for c in graph:
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
    for p in problems:
        print(" -", p)
    sys.exit(1)

# ---------------------------------------------------------------------------
# 12. Write CANONICAL.json
# ---------------------------------------------------------------------------
by_domain = {}
by_tier = {}
for f in final:
    by_domain[f["domain"]] = by_domain.get(f["domain"], 0) + 1
    by_tier[f["tier"]] = by_tier.get(f["tier"], 0) + 1

out = {
    "schema_version": "1.0.0",
    "generated_from_commit": GIT_SHA,
    "canonical": final,
    "raw_to_canonical": raw_to_canonical_final,
    "counts": {
        "raw": len(raw_to_canonical_final),
        "canonical": len(final),
        "by_domain": by_domain,
        "by_tier": by_tier,
        "splits_2026_09_06": ["CAN-054 -> CAN-054 (kept) + CAN-257 (new) + CAN-258 (new)"],
    },
}
json.dump(out, open(REG / "CANONICAL.json", "w", encoding="utf-8"), indent=2, ensure_ascii=False)
print(f"Wrote {REG/'CANONICAL.json'}: {len(final)} canonical entries, "
      f"{len(raw_to_canonical_final)} raw_to_canonical keys")

# ---------------------------------------------------------------------------
# 13. LINEAGE.jsonl (append-only; this run seeds it fresh since it did not exist before N3)
# ---------------------------------------------------------------------------
lineage_lines = []
lineage_lines.append(json.dumps({
    "code": "CAN-054", "date": DATE, "event": "split",
    "from": "CAN-054 (pre-N3, over-merged: rank-bounded retention + rival-model ladder + well-being/maladaptive-cost bundled under one id)",
    "to": [new_code["CAN-054"], new_code["CAN-257"], new_code["CAN-258"]],
    "reason": "dedup review over-merge fix: eq_21425420.json labels (18)-(29),(32)-(34),(38),(40)-(42) "
              "kept as the rank-bounded retention object (CAN-054); (43)-(48) split to CAN-257 "
              "(Human-LoRA rival-model ladder M0-M5); (36)-(37) split to CAN-258 (well-being vector "
              "W_n + maladaptive-cost C_mal) — three distinct objects, quoted per-label above.",
    "by": BY,
}, ensure_ascii=False))
for f in final:
    if f["id"] in SPINE_ROOT:
        _, derived_via, quote, note = SPINE_ROOT[f["id"]]
        reason = f"root-spine mapping to Genesis {f['root']}: {note} Quoted: \"{quote}\""
    else:
        parent_id, tier = collapse_parent[f["id"]]
        reason = (f"COLLAPSE.md sec 3.1 reading: {f['id']} reads {parent_id} "
                  f"(evidence tier: {tier}) -> root {f['root']} via {new_code[parent_id]}")
    lineage_lines.append(json.dumps({
        "code": f["code"], "date": DATE, "event": "assigned",
        "from": f["id"], "to": f["code"], "reason": reason, "by": BY,
    }, ensure_ascii=False))

open(REG / "LINEAGE.jsonl", "w", encoding="utf-8").write("\n".join(lineage_lines) + "\n")
print(f"Wrote {REG/'LINEAGE.jsonl'}: {len(lineage_lines)} events")

# ---------------------------------------------------------------------------
# 14. Report
# ---------------------------------------------------------------------------
print("\nSplits:", out["counts"]["splits_2026_09_06"])
print("\nOpen relation items (deferred to N4, no fabricated targets):")
for item in OPEN_RELATION_ITEMS:
    print(" -", item)
print(f"\nroot codes used: {sorted(set(new_root.values()))}")
