#!/usr/bin/env python3
"""Toledo v1.8 REGISTRAR merge -- registry/proposals/causal_sweep.json.

27 founder-instructed causal-memory-programme proposals (2026-09-08 sweep:
judged_part1/2/3.json, 41 raw new-branch objects deduped to 27 across
parts -- see the proposal file's own `sweep_source`). Same idiom as
scripts/v17_river_merge.py / scripts/v18_ranc_merge.py: re-read
registry/CANONICAL.json immediately before the one atomic write
(concurrent-run discipline -- this script never reads or writes
registry/executable/ or registry/consistency/), re-verify every parent
code and every alias against the LIVE registry (never trust the proposal
file's own morning-of dedup as still current), assign real `.v1` running
numbers per (root, domain) replacing the proposal's `??` placeholders
(GENESIS_CODE_SCHEME.md numbering: next nn from CANONICAL.json's own live
maximum for that pair, never reused), append one LINEAGE `assigned` event
per new entry dated 2026-09-08.

Every one of the 27 is coq_status="open_prop": tier as proposed (never
raised), no proof. Each gets its own coq/canonical/<mangled-code>.v stub
-- a `Definition <ident>_hyp (...) : Prop := <body>` stating the claim's
general shape over abstract Parameters/Types (never a proof, never a
top-level Axiom), same discipline as the existing open_prop stubs
(coq/canonical/EQ_001__C_03_v1.v, weld__S_30_v1.v, weld__H_51_v1.v).

Idempotent: an alias already present anywhere in CANONICAL.json means that
proposal was already merged on a prior run -- skipped, re-verified against
the live registry, not re-added.

Run: python3 scripts/v18_causal_merge.py
"""
import json
import re
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
CAN_DIR = ROOT / "coq" / "canonical"
DATE = "2026-09-08"
BY = "toledo-v1.8-causal-sweep"

CANONICAL_PATH = REG / "CANONICAL.json"
GENESIS_PATH = REG / "genesis_root.json"
LINEAGE_PATH = REG / "LINEAGE.jsonl"
PROPOSALS_PATH = REG / "proposals" / "causal_sweep.json"
MERGED_MAP_PATH = REG / "proposals" / "causal_sweep.merged.json"

CODE_RE = re.compile(
    r"^(?P<root>EQ-0\d{2}|[A-Za-z][A-Za-z0-9]*(?:[._-][A-Za-z0-9]+)*)"
    r"(?:/(?P<domain>[EHSWMPCB])\.(?P<seq>\d{2,4})(?:\.v(?P<rev>[1-9]\d*))?)?$"
)

DEFAULT_COQ = {
    "file": None, "identifier": None, "assumptions": None, "imported_from": None,
    "coq_status": "open_prop", "coq_axioms": [], "coq_source_redistributed": True,
}

STATUS_NOTE = (
    "Causal-sweep proposal (2026-09-08); tier as sourced, never raised; "
    "unverified pending independent (maker-checker) review of the parent "
    "reading and the Coq open_prop stub this entry ships with."
)

COQ_HEADER = """(* {code} -- open_prop -- {name} *)
(* source statement (registry/CANONICAL.json statement.latest, ascii): *)
(* {statement} *)
(* Toledo v1.8 (causal sweep merge): finite-model open_prop -- the *)
(* Definition below states the claim's general propositional shape over *)
(* abstract Parameters/Types; nothing about its truth is asserted, no *)
(* proof is attempted (source tier: {tier}). *)

Require Import QArith.
Require Import Qminmax.
Require Import Qabs.
Require Import List.
Import ListNotations.

{body}
"""

# Per-proposal Coq body -- `{ident}` is substituted with the final
# <mangled-code>_hyp identifier once the running code number is assigned.
# Each states the claim's general shape (implication/equation/inequality
# over Q and abstract Types), matching the existing open_prop convention
# (coq/canonical/EQ_001__C_03_v1.v, weld__S_30_v1.v): a genuine attempt at
# the propositional shape, never a proof, never asserted as true.
COQ_BODY = {
    "CS-01": (
        "Definition {ident}\n"
        "  (State : Type) (L C u b : State -> Q) (alpha : Q -> Q)\n"
        "  (worst_case_exceeds_capacity execution_forced : Prop)\n"
        "  : Prop :=\n"
        "  (forall s : State, b s = C s - L s) /\\\n"
        "  (worst_case_exceeds_capacity -> execution_forced)."
    ),
    "CS-02": (
        "Definition {ident}\n"
        "  (Time State : Type) (S R E P A : Time -> State)\n"
        "  (causal_link : State -> State -> Prop)\n"
        "  : Prop :=\n"
        "  forall t : Time, causal_link (S t) (R t) /\\\n"
        "                   (causal_link (R t) (E t) /\\ causal_link (R t) (P t))."
    ),
    "CS-03": (
        "Definition {ident}\n"
        "  (gamma0 : Q) (D : Q -> Q) (monotone_decreasing : (Q -> Q) -> Prop)\n"
        "  (gamma_eff : Q -> Q)\n"
        "  : Prop :=\n"
        "  monotone_decreasing D /\\ (forall pm25 : Q, gamma_eff pm25 = gamma0 * D pm25)."
    ),
    "CS-04": (
        "Definition {ident}\n"
        "  (IPR mean_IPR threshold Delta : Q) (bounded : Prop)\n"
        "  : Prop :=\n"
        "  Delta = IPR / mean_IPR /\\ (Delta > threshold <-> bounded)."
    ),
    "CS-05": (
        "Definition {ident}\n"
        "  (Time : Type) (r_mis r_al : Time -> Q) (threshold : Q)\n"
        "  (collapse : Time -> Prop) (statistical_emergence_law : Prop)\n"
        "  : Prop :=\n"
        "  (forall t : Time, r_mis t - r_al t > threshold -> collapse t) /\\\n"
        "  statistical_emergence_law."
    ),
    "CS-06": (
        "Definition {ident}\n"
        "  (S : Type) (F : S -> Q) (kappa : Q) (grad_s Psi : S -> Q)\n"
        "  (weighted_lyapunov_dissipative : Prop)\n"
        "  : Prop :=\n"
        "  (forall x : S, F x = kappa * grad_s x + Psi x) /\\ weighted_lyapunov_dissipative."
    ),
    "CS-07": (
        "Definition {ident}\n"
        "  (hbar_star g_star hbar G : Q) (uv_no_go : Prop)\n"
        "  : Prop :=\n"
        "  hbar_star = hbar /\\ g_star = G /\\ uv_no_go."
    ),
    "CS-08": (
        "Definition {ident}\n"
        "  (theta_star : Q -> Q)\n"
        "  : Prop :=\n"
        "  forall eps : Q, eps > 0 ->\n"
        "    exists p0 : Q, forall p : Q, 0 < p -> p < p0 -> Qabs (theta_star p) < eps."
    ),
    "CS-09": (
        "Definition {ident}\n"
        "  (Class : Type) (record_cost : Class -> Q)\n"
        "  (persistent_class_bias record_cost_asymmetry : Prop)\n"
        "  : Prop :=\n"
        "  persistent_class_bias -> record_cost_asymmetry."
    ),
    "CS-10": (
        "Definition {ident}\n"
        "  (Time State : Type) (H : Time -> State) (F : State -> State)\n"
        "  (order_sensitivity monotone_records dissipation_with_memory : Prop)\n"
        "  : Prop :=\n"
        "  order_sensitivity /\\ monotone_records /\\ dissipation_with_memory /\\\n"
        "  (forall t : Time, exists s : State, H t = s)."
    ),
    "CS-11": (
        "Definition {ident}\n"
        "  (t_d T d_theta dt_proc dt_verify dt_deploy T_avail : Q)\n"
        "  : Prop :=\n"
        "  t_d <= T - d_theta /\\\n"
        "  T_avail = T - t_d - dt_proc - dt_verify - dt_deploy /\\ T_avail >= 0."
    ),
    "CS-12": (
        "Definition {ident}\n"
        "  (tau D G M r_min : Q) (phi : Q -> Q) (pde_holds : Prop)\n"
        "  : Prop :=\n"
        "  pde_holds /\\ r_min > 0."
    ),
    "CS-13": (
        "Definition {ident}\n"
        "  (Lambda tau_cosmic H0 rho_Lambda hbar c ell_P : Q)\n"
        "  : Prop :=\n"
        "  tau_cosmic = 1 / H0 /\\ Lambda = 1 / (tau_cosmic * tau_cosmic) /\\\n"
        "  rho_Lambda = (hbar * c) / (tau_cosmic * tau_cosmic * ell_P * ell_P * ell_P)."
    ),
    "CS-14": (
        "Definition {ident}\n"
        "  (R_s c tau_c G hbar ell_P : Q)\n"
        "  : Prop :=\n"
        "  R_s * c * tau_c = (G * hbar) / (c * c * c) /\\\n"
        "  (G * hbar) / (c * c * c) = ell_P * ell_P."
    ),
    "CS-15": (
        "Definition {ident}\n"
        "  (tau Omega De ell Rg dt : Q)\n"
        "  : Prop :=\n"
        "  De = tau * Omega /\\ De / tau = (ell * Rg / dt) * (ell * Rg / dt)."
    ),
    "CS-16": (
        "Definition {ident}\n"
        "  (Time : Type) (t : Time -> Q) (tau_c_micro : Q) (C : Time -> Q)\n"
        "  (kappa : Q)\n"
        "  : Prop :=\n"
        "  (forall s : Time, C s = t s / tau_c_micro) /\\ kappa = 1 / tau_c_micro."
    ),
    "CS-17": (
        "Definition {ident}\n"
        "  (BoxPhi lambda u_grad_Phi Omega Phi a0 c H0 : Q)\n"
        "  : Prop :=\n"
        "  BoxPhi + 2 * lambda * u_grad_Phi + Omega * Omega * Phi = 0 /\\ a0 = c * H0."
    ),
    "CS-18": (
        "Definition {ident}\n"
        "  (G M r ell_c Phi_N : Q) (exp_neg : Q -> Q)\n"
        "  : Prop :=\n"
        "  Phi_N = - (G * M / r) * (1 - exp_neg (r / ell_c))."
    ),
    "CS-19": (
        "Definition {ident}\n"
        "  (c D_ring tau_220 D_i D_j tau_i tau_j : Q)\n"
        "  : Prop :=\n"
        "  D_ring = c * c * tau_220 /\\ D_i / D_j = tau_i / tau_j."
    ),
    "CS-20": (
        "Definition {ident}\n"
        "  (v tau x t xi G : Q) (Hstep delta I0 I1 exp_neg sqrtf : Q -> Q)\n"
        "  : Prop :=\n"
        "  xi = sqrtf (v * v * t * t - x * x) / (2 * v * tau) /\\\n"
        "  G = (exp_neg (t / (2 * tau)) / (2 * v)) * Hstep (v * t - Qabs x) *\n"
        "      (delta (Qabs x - v * t) +\n"
        "       (I0 xi + (v * t / sqrtf (v * v * t * t - x * x)) * I1 xi) / (2 * tau))."
    ),
    "CS-21": (
        "Definition {ident}\n"
        "  (r_p_core Delta_r tau_c r_p_eff : Q) (sqrtf : Q -> Q)\n"
        "  : Prop :=\n"
        "  r_p_eff = r_p_core + Delta_r * sqrtf tau_c."
    ),
    "CS-22": (
        "Definition {ident}\n"
        "  (tau H a D d2rho_dt2 drho_dt lap_rho : Q)\n"
        "  : Prop :=\n"
        "  tau * d2rho_dt2 + (1 + 3 * H * tau) * drho_dt = (D / (a * a)) * lap_rho."
    ),
    "CS-23": (
        "Definition {ident}\n"
        "  (R_s r tau_c_proper tau_c_distant : Q) (sqrtf : Q -> Q)\n"
        "  : Prop :=\n"
        "  tau_c_distant = sqrtf (1 - R_s / r) * tau_c_proper."
    ),
    "CS-24": (
        "Definition {ident}\n"
        "  (Kernel : Type) (causal passive finite_order_recurrence : Kernel -> Prop)\n"
        "  (is_CMF : Kernel -> Prop)\n"
        "  : Prop :=\n"
        "  forall K : Kernel, causal K -> passive K -> finite_order_recurrence K -> is_CMF K."
    ),
    "CS-25": (
        "Definition {ident}\n"
        "  (tau_c hbar c m_eff d2psi_dt2 lap_psi psi_val : Q)\n"
        "  : Prop :=\n"
        "  m_eff = hbar / (2 * c * c * tau_c) /\\\n"
        "  d2psi_dt2 - c * c * lap_psi + psi_val / (4 * tau_c * tau_c) = 0."
    ),
    "CS-26": (
        "Definition {ident}\n"
        "  (v_star lambda Psi_dd tau_c Riemann : Q) (flat : Prop)\n"
        "  : Prop :=\n"
        "  v_star * v_star = lambda * Psi_dd / tau_c /\\ (Riemann = 0 <-> flat)."
    ),
    "CS-27": (
        "Definition {ident}\n"
        "  (Edge Node : Type) (head tail : Edge -> Node) (delay : Edge -> Q)\n"
        "  (f : Node -> Q) (CC : Edge -> Q)\n"
        "  (sum_CC_delay : Q) (path_start path_end : Node)\n"
        "  : Prop :=\n"
        "  (forall e : Edge, CC e = (f (head e) - f (tail e)) / delay e) /\\\n"
        "  (sum_CC_delay = f path_end - f path_start ->\n"
        "     sum_CC_delay = f path_end - f path_start)."
    ),
}


def root_of(code: str) -> str:
    return code.split("/", 1)[0]


def domain_of_placeholder(code: str) -> str:
    mo = re.match(r"^.+/([EHSWMPCB])\.\?\?\.v\d+$", code)
    if not mo:
        raise SystemExit(f"cannot read placeholder domain out of code {code!r}")
    return mo.group(1)


def mangle(code: str) -> str:
    return code.replace("/", "__").replace(".", "_").replace("-", "_")


def main():
    # Re-read CANONICAL.json fresh right before writing -- concurrent-run
    # discipline, this script never touches registry/executable/ or
    # registry/consistency/, and never works off a stale in-memory copy.
    canonical_doc = json.loads(CANONICAL_PATH.read_text(encoding="utf-8"))
    entries = canonical_doc["canonical"]
    by_code = {e["code"]: e for e in entries}
    entries_before = len(entries)

    genesis_doc = json.loads(GENESIS_PATH.read_text(encoding="utf-8"))
    genesis_codes = {r["code"] for r in genesis_doc["root_equations"]}

    prop_doc = json.loads(PROPOSALS_PATH.read_text(encoding="utf-8"))
    proposals = prop_doc["proposals"]
    founder_note = prop_doc.get("founder_instruction", "")

    existing_aliases = set()
    for e in entries:
        for a in e.get("aliases") or []:
            existing_aliases.add(a)

    seq_state = {}
    for e in entries:
        mo = re.match(r"^(.+)/([EHSWMPCB])\.(\d+)\.v\d+$", e["code"])
        if mo:
            key = (mo.group(1), mo.group(2))
            seq_state[key] = max(seq_state.get(key, 0), int(mo.group(3)))

    def next_code(root: str, domain: str) -> str:
        key = (root, domain)
        seq_state[key] = seq_state.get(key, 0) + 1
        nn = seq_state[key]
        width = 2 if nn < 100 else len(str(nn))
        return f"{root}/{domain}.{nn:0{width}d}.v1"

    max_existing_id = 0
    for e in entries:
        if isinstance(e.get("id"), str) and e["id"].startswith("CAUSAL-2026-09-08-"):
            try:
                max_existing_id = max(max_existing_id, int(e["id"].rsplit("-", 1)[1]))
            except ValueError:
                pass

    lineage_events = []
    merged_map = {}
    new_codes = []
    skipped_already_merged = []
    could_not_merge = []
    coq_writes = []  # (path, text) -- written only after all validation passes

    for prop in proposals:
        pid = prop["id"]
        aliases = list(prop["aliases"])

        # Idempotency + re-verification against the LIVE registry -- never
        # trust the proposal file's own morning-of dedup as still current.
        if any(a in existing_aliases for a in aliases):
            existing_code = next(
                (e["code"] for e in entries if any(a in (e.get("aliases") or []) for a in aliases)),
                None,
            )
            merged_map[pid] = existing_code
            skipped_already_merged.append(pid)
            continue

        try:
            parents = prop.get("parents") or []
            if not parents:
                raise ValueError(f"{pid}: proposal has no parents")
            for p in parents:
                if p["code"] not in by_code and p["code"] not in genesis_codes:
                    raise ValueError(
                        f"{pid}: parent code {p['code']!r} not found in the LIVE "
                        "registry (genesis_root.json / CANONICAL.json) -- abort"
                    )

            placeholder_code = prop["code"]
            root = root_of(placeholder_code)
            domain = domain_of_placeholder(placeholder_code)
            if prop.get("domain") and prop["domain"] != domain:
                raise ValueError(
                    f"{pid}: proposal 'domain' field {prop['domain']!r} does not match "
                    f"domain letter in code {placeholder_code!r}"
                )

            tier = prop["tier"]
            code = next_code(root, domain)
            max_existing_id += 1
            entry_id = f"CAUSAL-2026-09-08-{max_existing_id:02d}"

            mangled = mangle(code)
            coq_ident = f"{mangled}_hyp"
            coq_file_rel = f"coq/canonical/{mangled}.v"

            if pid not in COQ_BODY:
                raise ValueError(f"{pid}: no Coq open_prop body template registered")
            body = COQ_BODY[pid].format(ident=coq_ident)
            coq_text = COQ_HEADER.format(
                code=code, name=prop["name"], statement=prop["statement"]["latest"],
                tier=tier, body=body,
            )

            entry = {
                "id": entry_id,
                "code": code,
                "root": root,
                "layer": "reading",
                "domain": domain,
                "aliases": aliases,
                "name": prop["name"],
                "statement": {
                    "latest": prop["statement"]["latest"],
                    "format": prop["statement"].get("format", "ascii"),
                },
                "statements_history": [{
                    "v": 1,
                    "statement": prop["statement"]["latest"],
                    "date": DATE,
                    "reason": (
                        f"{BY}: initial capture from causal-sweep proposal {pid}, "
                        f"origin: {prop['origin'].get('source')}"
                    ),
                    "by": BY,
                }],
                "parents": [{"code": p["code"], "derived_via": p["derived_via"]} for p in parents],
                "children": [],
                "origin": dict(prop["origin"]),
                "status": prop.get("status", "unverified"),
                "status_note": STATUS_NOTE,
                "superseded_by": None,
                "tier": tier,
                "tier_in_genesis_verbatim": "",
                "coq": {
                    "file": coq_file_rel,
                    "identifier": coq_ident,
                    "assumptions": None,
                    "imported_from": None,
                    "coq_status": "open_prop",
                    "coq_axioms": [],
                    "coq_source_redistributed": True,
                },
                "relations": [],
                "occurrences": [dict(o) for o in prop.get("occurrences", [])],
                "role": "other",
                "first_assigned": DATE,
            }

            entries.append(entry)
            by_code[code] = entry
            existing_aliases.update(aliases)
            new_codes.append(code)
            merged_map[pid] = code
            coq_writes.append((ROOT / coq_file_rel, coq_text))

            lineage_events.append({
                "code": code, "date": DATE, "event": "assigned",
                "from": pid, "to": code,
                "reason": (
                    f"Toledo v1.8 causal-sweep merge (proposal {pid}, {prop['name']}, "
                    f"tier {tier}, parents {[p['code'] for p in parents]}): "
                    f"founder instruction: \"{founder_note}\""
                ),
                "by": BY,
            })

        except ValueError as exc:
            could_not_merge.append(str(exc))
            merged_map[pid] = None

    if could_not_merge:
        print("VALIDATION PROBLEMS (aborting before write):")
        for m in could_not_merge:
            print(" -", m)
        sys.exit(1)

    # children[] = invert parents[] across the full final array
    code_set = {f["code"] for f in entries}
    children_map = {c: [] for c in code_set}
    for f in entries:
        for p in f["parents"]:
            if p["code"] in children_map:
                children_map[p["code"]].append(f["code"])
    for f in entries:
        f["children"] = sorted(set(children_map[f["code"]]))

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

    canonical_doc["counts"] = {
        "entries": len(entries),
        "by_status": dict(Counter(e["status"] for e in entries)),
        "by_domain": dict(Counter(e["domain"] for e in entries if e.get("domain"))),
        "by_tier": dict(Counter(e["tier"] for e in entries)),
        "by_coq_status": dict(Counter(e["coq"]["coq_status"] for e in entries)),
        "computed": f"{DATE} from canonical[] (scripts/v18_causal_merge.py)",
    }

    if new_codes:
        text = json.dumps(canonical_doc, indent=2, ensure_ascii=False)
        CANONICAL_PATH.write_text(text + "\n", encoding="utf-8")
        print(f"Wrote {CANONICAL_PATH}: {len(entries)} canonical entries (was {entries_before}).")

        CAN_DIR.mkdir(parents=True, exist_ok=True)
        for path, text in coq_writes:
            path.write_text(text, encoding="utf-8")
        print(f"Wrote {len(coq_writes)} coq/canonical/*.v open_prop stubs.")

    if lineage_events:
        with LINEAGE_PATH.open("a", encoding="utf-8") as fh:
            for ev in lineage_events:
                fh.write(json.dumps(ev, ensure_ascii=False) + "\n")
        print(f"Appended {len(lineage_events)} events to {LINEAGE_PATH}")

    merged_map_sorted = dict(sorted(merged_map.items()))
    MERGED_MAP_PATH.write_text(
        json.dumps(merged_map_sorted, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
    )

    print("\nv1.8 causal-sweep merge complete.")
    print(f"  proposals total: {len(proposals)}")
    print(f"  new entries created: {len(new_codes)}: {new_codes}")
    print(f"  already-merged (idempotent skip): {len(skipped_already_merged)}: {skipped_already_merged}")


if __name__ == "__main__":
    main()
