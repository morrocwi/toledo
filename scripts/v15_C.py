#!/usr/bin/env python3
"""Toledo v1.5, Lane C (unverified + untagged, no coqc) -- scripts/v15_C.py.

DEBT #42 (52 unverified entries) and DEBT #43 (255 untagged CANONICAL entries
+ 310 genesis_root.json root rows without a normalised tier), per
ops/HANDOFF_OVERNIGHT_2026-09-06.md and ops/TODOLIST_snapshot_2026-09-07.md.

Every fact this script writes was re-checked directly against the cited
source file at the cited commit in this same session (readout_genesis is a
local clone pinned at commit 082dde893b70c7500c13d463239909c99cf17f0a, the
same commit genesis_root.json's own anchors already cite; the private
solver-arc paths are the local clone of "solver arc (private)" pinned at
961151db33b0491cba8fabade69f594238d33f84, the same commit
coq/solver-arc/PROVENANCE.json already cites). Nothing here is inferred or
interpreted beyond what the cited line literally states; a source that
states no controlled-vocabulary tier word, or an ambiguous/composite one, is
left exactly as it was.

Three independent fixes, all idempotent and each guarded by its own
before-state check so a rerun (or a partial prior run) never double-applies:

(1) CANONICAL.json status_note refinement (task 1, the 4 EQ-001/B.14-17
    entries): re-confirms, at today's date, that the theorem identifiers a
    prior lane (v1.2 lane S) already located by direct inspection of the
    named solver-arc file are STILL absent from this Toledo tree's
    coq/solver-arc/ mirror and registry/coq_map.json -- i.e. the prior
    status_note's "missing" claim is re-verified true today, not stale.
    status stays "unverified" (nothing here promotes it to "current"); only
    status_note gains a dated re-confirmation clause. The other 48
    unverified entries were also individually re-checked this session
    against their exact readout_genesis RULE_REGISTRY.json rule (same
    anchored commit) and found byte-identical to what their existing
    status_note already states -- no file write needed for those (see the
    task's final report for the full accounting).

(2) CANONICAL.json tier tagging (task 2a, 10 entries the existing
    tier-tagging scripts -- scripts/v11_C.py's check_solver_arc_row /
    check_textbook -- never covered because their occurrence raw_key does
    not match either function's regex):
      - EQ-015/B.01..B.09 (9 entries): the health-stream theorem readings
        from "solver arc (private)" formal/InfoHealthCausalRelax_attempt.v
        and formal/InfoHealthCuspFold_attempt.v, each of which carries an
        explicit "SCOPE -- ... TIER = Th_coqc" header comment naming the
        tier for every Theorem/Lemma in that file.
      - EQ-009/E.03.v1 (1 entry, root reading of readout_universe's T4
        bridge): v2/APPEND_ONLY_RECORD.md line 17 names T4 directly,
        parenthetically, inside an explicit "[Open]" bracket tag ("the
        narrow novelty-candidate layer ([Open]): ... the quantitative
        bridge to DRL (T4 below)"). The file's later verdict paragraph
        upgrades a DIFFERENT, separately-quoted composite statement
        (T2+T3, "dissipation = handoff across Pi") to
        "[finite_diagnostic in the tape model]" -- that upgrade names T2+T3
        explicitly, not T4, so it is not applied here (never a tier claimed
        for a different statement than the one being tagged).

(3) genesis_root.json tier normalisation (task 2b, 97 of the 310 rows whose
    "tier" key is absent/null): wherever this session located a specific,
    on-topic line in READOUT_GENESIS_CORE.md (or, for the two WP.S24 rows,
    READOUT_GENESIS_UNIVERSAL_TECHNICAL_WHITEPAPER_v1.2.0.md) that names a
    single controlled-vocabulary tier word for that exact object -- not a
    generic tier-legend definition line, not a tag stated for a sibling
    object -- tier + tier_evidence{quote,line,commit} is set. The remaining
    213 of the 310 rows are left with no "tier" key: their own
    tier_in_genesis field is either a composite/ambiguous string (e.g.
    "Dr/finite_diagnostic", "mixed: ...", "Th_coqc-adjacent ...") or a
    non-enum classification word (e.g. "Type-P", "declared_finite_
    architecture", "GREEN (formal-closed)") that this script's own
    controlled-vocabulary regex correctly refuses to guess at, or (2 rows,
    XI.5-FT1 / XI.5-FT2) a case where this session could find the row's own
    falsifier text in the source but no line nearby actually states the
    tier word itself for that specific object (only for a neighbouring
    object) -- left untagged rather than borrow a neighbour's tag.

Idempotent: every touch checks the current on-disk value first and skips if
another lane already changed it; the files are re-read immediately before
each write.

Run: python3 scripts/v15_C.py [--dry-run]
Inputs : registry/CANONICAL.json, registry/genesis_root.json (this session's
         direct reading of readout_genesis/READOUT_GENESIS_CORE.md,
         readout_genesis/READOUT_GENESIS_UNIVERSAL_TECHNICAL_WHITEPAPER_v1.2.0.md
         and the private solver-arc formal/*.v files informs the literal
         values below; those external repos are not re-read by this script
         at run time, since the evidence has already been transcribed here
         verbatim and re-reading a private-repo path from a Toledo script
         would need care this task does not require)
Outputs: registry/CANONICAL.json (status_note / tier / tier_evidence fields
         only, on entries this script itself touches)
         registry/genesis_root.json (tier / tier_evidence fields only, on
         rows this script itself touches)
         registry/LINEAGE.jsonl (one "revised" event per touched CANONICAL
         entry; genesis_root.json tier normalisation follows the existing
         convention of the prior lane's own tier-setting rows -- e.g.
         "Forced.II", "Face.12", "N5" -- none of which have a
         corresponding LINEAGE.jsonl event either, since LINEAGE is scoped
         to CANONICAL-layer code lifecycle events)
"""
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
DATE = "2026-09-07"
BY = "toledo-v1.5-C"

GENESIS_COMMIT = "082dde893b70c7500c13d463239909c99cf17f0a"
SOLVER_ARC_COMMIT = "961151db33b0491cba8fabade69f594238d33f84"

# ---------------------------------------------------------------------------
# (1) status_note refinement for the 4 EQ-001/B.14-17 entries (task 1)
# ---------------------------------------------------------------------------
STATUS_NOTE_REFINEMENTS = {
    "EQ-001/B.14.v1": (
        "Toledo v1.5 Lane C re-check (2026-09-07): confirmed today, by direct "
        "re-reading of \"solver arc (private)\" formal/InfoBioHomeostasis_attempt.v "
        f"at commit {SOLVER_ARC_COMMIT} (unchanged from the commit already anchored "
        "elsewhere in this tree), that the three named theorems (decay_geometric "
        "line 49, homeostasis_balance line 62, turnover_is_production line 68) are "
        "present exactly as previously located, and that this file is still absent "
        "from coq/solver-arc/formal/ in this Toledo tree and from registry/"
        "coq_map.json (grepped, zero matches). The v1.2 lane S finding stands, "
        "re-verified rather than stale; status remains unverified pending an N5+ "
        "import of this file."
    ),
    "EQ-001/B.15.v1": (
        "Toledo v1.5 Lane C re-check (2026-09-07): confirmed today, by direct "
        "re-reading of \"solver arc (private)\" formal/InfoHealthCausalRelax_attempt.v "
        f"at commit {SOLVER_ARC_COMMIT}, that the three named theorems "
        "(setpoint_is_fixed line 47, one_step_error line 61, n_step_error line 83) "
        "are present exactly as previously located, and that this file is still "
        "absent from coq/solver-arc/formal/ in this Toledo tree and from registry/"
        "coq_map.json (grepped, zero matches). The v1.2 lane S finding stands, "
        "re-verified rather than stale; status remains unverified pending an N5+ "
        "import of this file."
    ),
    "EQ-001/B.16.v1": (
        "Toledo v1.5 Lane C re-check (2026-09-07): confirmed today, by direct "
        "re-reading of \"solver arc (private)\" formal/InfoHealthCuspFold_attempt.v "
        f"at commit {SOLVER_ARC_COMMIT}, that the six named theorems (disc_even "
        "line 73, cusp_factor line 79, fold_from_double_root line 87, "
        "bistable_window_dec line 105, critical_slowing_marginal line 109, "
        "rest_iff_critical line 117) are present exactly as previously located, "
        "and that this file is still absent from coq/solver-arc/formal/ in this "
        "Toledo tree and from registry/coq_map.json (grepped, zero matches). The "
        "v1.2 lane S finding stands, re-verified rather than stale; status remains "
        "unverified pending an N5+ import of this file."
    ),
    "EQ-001/B.17.v1": (
        "Toledo v1.5 Lane C re-check (2026-09-07): confirmed today, by direct "
        "re-reading of \"solver arc (private)\" formal/InfoCoupledCuspEP3_attempt.v "
        f"at commit {SOLVER_ARC_COMMIT}, that the four named theorems "
        "(coupling_energy_nonneg line 70, locked_iff_energy_zero line 86, "
        "two_way_conserves line 98, one_way_breaks_conservation line 104) are "
        "present exactly as previously located, and that this file is still "
        "absent from coq/solver-arc/formal/ in this Toledo tree and from registry/"
        "coq_map.json (grepped, zero matches). The v1.2 lane S finding stands, "
        "re-verified rather than stale; status remains unverified pending an N5+ "
        "import of this file."
    ),
}

# ---------------------------------------------------------------------------
# (2) tier tagging for CANONICAL entries the prior scripts never checked
# ---------------------------------------------------------------------------
CANONICAL_TIER_TAGS = {
    "EQ-015/B.01.v1": {
        "tier": "Th_coqc",
        "tier_evidence": {
            "quote": (
                "\"SCOPE -- read before trusting this as more than it is. TIER = "
                "Th_coqc (Q, axiom-free) for everything BELOW\" -- formal/"
                "InfoHealthCausalRelax_attempt.v, line 25 (the setpoint_is_fixed "
                "theorem at line 47 is below this SCOPE comment)."
            ),
            "source": f'"solver arc (private)"@{SOLVER_ARC_COMMIT}, formal/InfoHealthCausalRelax_attempt.v',
            "line": "formal/InfoHealthCausalRelax_attempt.v:25",
        },
    },
    "EQ-015/B.02.v1": {
        "tier": "Th_coqc",
        "tier_evidence": {
            "quote": (
                "\"SCOPE -- read before trusting this as more than it is. TIER = "
                "Th_coqc (Q, axiom-free) for everything BELOW\" -- formal/"
                "InfoHealthCausalRelax_attempt.v, line 25 (the one_step_error "
                "theorem at line 61 is below this SCOPE comment)."
            ),
            "source": f'"solver arc (private)"@{SOLVER_ARC_COMMIT}, formal/InfoHealthCausalRelax_attempt.v',
            "line": "formal/InfoHealthCausalRelax_attempt.v:25",
        },
    },
    "EQ-015/B.03.v1": {
        "tier": "Th_coqc",
        "tier_evidence": {
            "quote": (
                "\"SCOPE -- read before trusting this as more than it is. TIER = "
                "Th_coqc (Q, axiom-free) for everything BELOW\" -- formal/"
                "InfoHealthCausalRelax_attempt.v, line 25 (the n_step_error "
                "theorem at line 83 is below this SCOPE comment)."
            ),
            "source": f'"solver arc (private)"@{SOLVER_ARC_COMMIT}, formal/InfoHealthCausalRelax_attempt.v',
            "line": "formal/InfoHealthCausalRelax_attempt.v:25",
        },
    },
    "EQ-015/B.04.v1": {
        "tier": "Th_coqc",
        "tier_evidence": {
            "quote": (
                "\"SCOPE -- read before trusting this as more than it is. TIER = "
                "Th_coqc (Q, axiom-free) for everything BELOW\" -- formal/"
                "InfoHealthCuspFold_attempt.v, line 47 (the disc_even theorem at "
                "line 73 is below this SCOPE comment)."
            ),
            "source": f'"solver arc (private)"@{SOLVER_ARC_COMMIT}, formal/InfoHealthCuspFold_attempt.v',
            "line": "formal/InfoHealthCuspFold_attempt.v:47",
        },
    },
    "EQ-015/B.05.v1": {
        "tier": "Th_coqc",
        "tier_evidence": {
            "quote": (
                "\"SCOPE -- ... TIER = Th_coqc (Q, axiom-free) for everything "
                "BELOW\" -- formal/InfoHealthCuspFold_attempt.v, line 47 (the "
                "cusp_factor lemma at line 79 is below this SCOPE comment)."
            ),
            "source": f'"solver arc (private)"@{SOLVER_ARC_COMMIT}, formal/InfoHealthCuspFold_attempt.v',
            "line": "formal/InfoHealthCuspFold_attempt.v:47",
        },
    },
    "EQ-015/B.06.v1": {
        "tier": "Th_coqc",
        "tier_evidence": {
            "quote": (
                "\"SCOPE -- ... TIER = Th_coqc (Q, axiom-free) for everything "
                "BELOW\" -- formal/InfoHealthCuspFold_attempt.v, line 47 (the "
                "fold_from_double_root theorem at line 87 is below this SCOPE "
                "comment)."
            ),
            "source": f'"solver arc (private)"@{SOLVER_ARC_COMMIT}, formal/InfoHealthCuspFold_attempt.v',
            "line": "formal/InfoHealthCuspFold_attempt.v:47",
        },
    },
    "EQ-015/B.07.v1": {
        "tier": "Th_coqc",
        "tier_evidence": {
            "quote": (
                "\"SCOPE -- ... TIER = Th_coqc (Q, axiom-free) for everything "
                "BELOW\" -- formal/InfoHealthCuspFold_attempt.v, line 47 (the "
                "bistable_window_dec theorem at line 105 is below this SCOPE "
                "comment)."
            ),
            "source": f'"solver arc (private)"@{SOLVER_ARC_COMMIT}, formal/InfoHealthCuspFold_attempt.v',
            "line": "formal/InfoHealthCuspFold_attempt.v:47",
        },
    },
    "EQ-015/B.08.v1": {
        "tier": "Th_coqc",
        "tier_evidence": {
            "quote": (
                "\"SCOPE -- ... TIER = Th_coqc (Q, axiom-free) for everything "
                "BELOW\" -- formal/InfoHealthCuspFold_attempt.v, line 47 (the "
                "critical_slowing_marginal theorem at line 109 is below this "
                "SCOPE comment)."
            ),
            "source": f'"solver arc (private)"@{SOLVER_ARC_COMMIT}, formal/InfoHealthCuspFold_attempt.v',
            "line": "formal/InfoHealthCuspFold_attempt.v:47",
        },
    },
    "EQ-015/B.09.v1": {
        "tier": "Th_coqc",
        "tier_evidence": {
            "quote": (
                "\"SCOPE -- ... TIER = Th_coqc (Q, axiom-free) for everything "
                "BELOW\" -- formal/InfoHealthCuspFold_attempt.v, line 47 (the "
                "rest_iff_critical theorem at line 117 is below this SCOPE "
                "comment)."
            ),
            "source": f'"solver arc (private)"@{SOLVER_ARC_COMMIT}, formal/InfoHealthCuspFold_attempt.v',
            "line": "formal/InfoHealthCuspFold_attempt.v:47",
        },
    },
    "EQ-009/E.03.v1": {
        "tier": "Open",
        "tier_evidence": {
            "quote": (
                "\"ชั้นผู้สมัครความใหม่ (แคบ, [Open]): "
                "การอ่าน tape เป็น RD6-7 concatenation "
                "ที่ realize RD4 injectivity ใน dynamics + "
                "สะพานเชิงปริมาณเข้าหา DRL (T4 ด้านล่าง)\" "
                "-- v2/APPEND_ONLY_RECORD.md, line 17. This line names T4 directly, "
                "parenthetically, as part of the object tagged [Open] (\"the narrow "
                "novelty-candidate layer ([Open]): reading the tape as an RD6-7 "
                "concatenation that realises RD4 injectivity in dynamics + the "
                "quantitative bridge to DRL (T4 below)\"). NOTE: the file's later "
                "verdict paragraph (line 38-40) upgrades a DIFFERENT, separately-"
                "named composite statement (\"dissipation = handoff across Pi\", "
                "evidenced by T2+T3) to \"[finite_diagnostic in the tape model]\" -- "
                "that upgrade names T2+T3 explicitly, not T4, so it is not applied "
                "to this entry."
            ),
            "source": "readout_universe@960165f13ced6e3f2bfd433928733a35be8283e6, v2/APPEND_ONLY_RECORD.md",
            "line": "v2/APPEND_ONLY_RECORD.md:17",
        },
    },
}

# ---------------------------------------------------------------------------
# (3) genesis_root.json tier normalisation -- (code, tier, quote, source_file, line)
# ---------------------------------------------------------------------------
_GENESIS_DOC = "READOUT_GENESIS_CORE.md"
_WP_DOC = "READOUT_GENESIS_UNIVERSAL_TECHNICAL_WHITEPAPER_v1.2.0.md"

ROOT_TIER_TAGS = [
    ("EQ-001", "Ax", "EQ-001  Ax          ∃ a,b : a ≠ b", _GENESIS_DOC, 7313),
    ("EQ-005", "Ax", "EQ-005  Ax          τ_c > 0", _GENESIS_DOC, 7317),
    ("EQ-006", "Ax", "EQ-006  Ax          t = nΔθ,  n∈ℕ,  Δθ>0", _GENESIS_DOC, 7318),
    ("EQ-009", "Ax", "EQ-009  Ax          1 RD := one retained-distinction record", _GENESIS_DOC, 7321),
    ("EQ-010", "Ax", "EQ-010  Ax          x_domain --[Enc_Ω]--> x_RD", _GENESIS_DOC, 7322),
    ("EQ-011", "Ax", "EQ-011  Ax          y_RD --[Dec_Ω]--> y_domain", _GENESIS_DOC, 7323),
    ("EQ-012", "Ax", "EQ-012  Ax          Γ ⊢_{α,ρ,κ} φ", _GENESIS_DOC, 7324),
    ("EQ-013", "Ax", "EQ-013  Ax          A ⇏ A⊗A", _GENESIS_DOC, 7325),
    ("EQ-014", "Ax", "EQ-014  Ax          !_κA ⊢ A^⊗m,  m ≤ κ", _GENESIS_DOC, 7326),
    ("EQ-016", "Dr", "EQ-016  Dr          λ_c = D²/(4MK)", _GENESIS_DOC, 7331),
    ("EQ-017", "finite_diagnostic", "EQ-017  finite_diagnostic (PASS_WITH_LIMITS)", _GENESIS_DOC, 7332),
    ("EQ-018", "Dr", "EQ-018  Dr          𝔖_n = (G_n, Λ_n, 𝒯_n, Θ_n)", _GENESIS_DOC, 7335),
    ("EQ-019", "Dr", "EQ-019  Dr          X_n^A = (Φ_n^I, Ψ_n^I)^T", _GENESIS_DOC, 7336),
    ("EQ-020", "Dr", "EQ-020  Dr          𝔾_n = L_{G_n}⊗I_ℱ + I_{G_n}⊗C_ℱ + C_int,n", _GENESIS_DOC, 7337),
    ("EQ-023", "finite_diagnostic", "EQ-023  finite_diagnostic", _GENESIS_DOC, 7347),
    ("EQ-024", "finite_diagnostic", "EQ-024  finite_diagnostic", _GENESIS_DOC, 7350),
    ("EQ-025", "finite_diagnostic", "EQ-025  finite_diagnostic", _GENESIS_DOC, 7354),
    ("EQ-026", "Th_coqc", "EQ-026  Th_coqc (2026-07-25 grounding, see this Appendix's own Face 10 note above)", _GENESIS_DOC, 7359),
    ("EQ-027", "Th_coqc", "EQ-027  Th_coqc (2026-07-25 grounding)", _GENESIS_DOC, 7361),
    ("EQ-028", "Th_coqc", "EQ-028  Th_coqc (2026-07-25 grounding)", _GENESIS_DOC, 7363),
    ("EQ-029", "Dr", "EQ-029  Dr          I_Q = I_B + O_C + O_P + O_B", _GENESIS_DOC, 7366),
    ("EQ-030", "Dr", "EQ-030  Dr          Z_n = (Φ_n, Ψ_n, Θ_n, U_n, Σ_n, 𝒯_n, Λ_n)", _GENESIS_DOC, 7374),
    ("EQ-031", "Dr", "EQ-031  Dr          r = O(X)", _GENESIS_DOC, 7375),
    ("EQ-032", "Th_coqc", "EQ-032  Th_coqc     ∀X,R,O,x1,x2 : x1≠x2 → O(x1)=O(x2) → ...", _GENESIS_DOC, 7379),
    ("EQ-033", "Th_coqc", "EQ-033  Th_coqc     ∀X,R,O,h,x : h(x)≠x → O(h(x))=O(x) → ...", _GENESIS_DOC, 7382),
    ("EQ-034", "Th_coqc", "EQ-034  Th_coqc     x1≠x2 → O(x1)=O(x2) → ...", _GENESIS_DOC, 7385),
    ("EQ-035", "Dr", "EQ-035  Dr          ⟨x,y⟩_G = x†Gy,  G>0", _GENESIS_DOC, 7388),
    ("EQ-042", "Dr", "EQ-042  Dr          𝒜 = { h : Oh=O, hF=Fh, h†Gh=G }", _GENESIS_DOC, 7411),
    ("EQ-043", "Dr", "EQ-043  Dr          H_C = ∏_{e∈C} U_e", _GENESIS_DOC, 7413),
    ("EQ-044", "Dr", "EQ-044  Dr          𝓕_all = 𝓕_G+𝓕_EM+𝓕_W+𝓕_S+𝓕_res", _GENESIS_DOC, 7416),
    ("EQ-045", "finite_diagnostic", "EQ-045  finite_diagnostic (blind pipeline)", _GENESIS_DOC, 7418),
    ("EQ-046", "Dr", "EQ-046  Dr          x ↦ e^{iα}x", _GENESIS_DOC, 7422),
    ("EQ-047", "Dr", "EQ-047  Dr          x ↦ ρ_R(g)x", _GENESIS_DOC, 7423),
    ("EQ-048", "Dr", "EQ-048  Dr          3⊗3̄ → 1+…", _GENESIS_DOC, 7426),
    ("EQ-050", "Dr", "EQ-050  Dr          ℰ_physical ⊆ ℰ_{τ=0}", _GENESIS_DOC, 7434),
    ("EQ-051", "finite_diagnostic", "EQ-051  finite_diagnostic (exact pass, Z₃/2D case only)", _GENESIS_DOC, 7435),
    ("EQ-054", "Th_coqc", "EQ-054  Th_coqc     c_0'(κ) = 2c_3(κ)", _GENESIS_DOC, 7458),
    ("EQ-056", "finite_diagnostic", "EQ-056  finite_diagnostic", _GENESIS_DOC, 7468),
    ("EQ-060", "finite_diagnostic", "EQ-060  finite_diagnostic", _GENESIS_DOC, 7479),
    ("EQ-061", "finite_diagnostic", "EQ-061  finite_diagnostic", _GENESIS_DOC, 7483),
    ("EQ-062", "finite_diagnostic", "EQ-062  finite_diagnostic (NEGATIVE finding — refutes its own opening hypothesis)", _GENESIS_DOC, 7486),
    ("EQ-068", "finite_diagnostic", "EQ-068  finite_diagnostic (THREE NEGATIVE FINDINGS, all disclosed, none hidden) — 2026-07-25", _GENESIS_DOC, 7538),
    ("EQ-069", "RETRACTED", "EQ-069  RETRACTED 2026-07-26 (continuum contamination — founder ruling; number kept so the ...)", _GENESIS_DOC, 7565),
    ("EQ-070", "RETRACTED", "EQ-070  RETRACTED 2026-07-26 (continuum contamination — founder ruling)", _GENESIS_DOC, 7573),
    ("EQ-071", "RETRACTED", "EQ-071  RETRACTED 2026-07-26 (continuum contamination — founder ruling)", _GENESIS_DOC, 7581),
    ("InverseArrow", "finite_diagnostic", "What the inverse arrow does **not** upgrade: the discovered law is `[finite_diagnostic]` on the tape", _GENESIS_DOC, 790),
    ("MemoryKernel", "finite_diagnostic", "it comes from MQ.08 rather than positing it independently. `[Dr]` derivation stance, `[finite_diagnostic]` (memory kernel and speed relations)", _GENESIS_DOC, 938),
    ("GaugeFaces", "Dr", "`[Dr]` — these are **structural readouts**, not derivations of measured physics.", _GENESIS_DOC, 1035),
    ("TermTier-D", "finite_diagnostic", "`M ∂²_t Φ` | memory / inertia | `[Dr]`, forcing attempts `[finite_diagnostic]` (failed) ...", _GENESIS_DOC, 1108),
    ("Layer3", "finite_diagnostic", "**Layer 2 — RTPE turbulence (1st-order relaxation).** `[finite_diagnostic]`, status **PASS_WITH_LIMITS**", _GENESIS_DOC, 1187),
    ("Rgeo", "finite_diagnostic", "`[finite_diagnostic]` for the executable stepper machinery (it runs and is checkable on finite instances)", _GENESIS_DOC, 1245),
    ("DRLAction", "Dr", "Face 8's `[Dr]`-tier companion-field proposal (Part III)", _GENESIS_DOC, 1241),
    ("EtaOmegaMatrices", "Dr", "Face 8's `[Dr]`-tier companion-field proposal (Part III)", _GENESIS_DOC, 1241),
    ("GaussJordanStepper", "finite_diagnostic", "`[finite_diagnostic]` for the executable stepper machinery (it runs and is checkable on finite instances)", _GENESIS_DOC, 1245),
    ("Face.3.CharEq", "Th_coqc", "### Face 3: Dispersion Split — Classical / Quantum Regimes   [Th_coqc]", _GENESIS_DOC, 1588),
    ("Face.3.CriticalSplit", "Th_coqc", "### Face 3: Dispersion Split — Classical / Quantum Regimes   [Th_coqc]", _GENESIS_DOC, 1588),
    ("Face.3.Dispersion", "Th_coqc", "### Face 3: Dispersion Split — Classical / Quantum Regimes   [Th_coqc]", _GENESIS_DOC, 1588),
    ("Face.4", "Th_coqc", "### Face 4: Stability / Energy   [Th_coqc]", _GENESIS_DOC, 1631),
    ("Face.5.GraphSpeed", "Open", "the physical speed of light is **`[Open]`** — it is a structural analogy, not a demonstrated identity", _GENESIS_DOC, 1687),
    ("Face.8.MetricReadout", "Th_coqc", "### Face 8: Operator-to-Metric Geometry   [Th_coqc]", _GENESIS_DOC, 1775),
    ("Face.8.Guardrail", "Th_coqc", "### Face 8: Operator-to-Metric Geometry   [Th_coqc]", _GENESIS_DOC, 1775),
    ("Face.8.CurvatureForce", "Dr", "**Curvature and force, restated on this face (new, 2026-07-21, [Dr]).**", _GENESIS_DOC, 1819),
    ("Face.9", "Th_coqc", "### Face 9: CPTP / Quantum-Channel Face   [Th_coqc]", _GENESIS_DOC, 1841),
    ("Face.10.StrictGap", "Th_coqc", "**`[Th_coqc]` grounding, added 2026-07-25** (formal/InfoTrueRecordUnreadable_attempt.v)", _GENESIS_DOC, 1891),
    ("Face.10.IdentifiabilityGate", "finite_diagnostic", "`[finite_diagnostic]` that discovers, from the tape alone: (a) how many variables the domain ...", _GENESIS_DOC, 1925),
    ("Face.10.bRLedger", "finite_diagnostic", "the year's cross-domain translation architecture belongs, again explicitly tagged `[finite_diagnostic]` and explicitly *not* first-principles", _GENESIS_DOC, 1960),
    ("Gateway.PrimitiveTuple", "Dr", "filled in here as the rest of the same table, not a new concept: `[Dr]` (open) for the deeper structure", _GENESIS_DOC, 2248),
    ("Gateway.NativeMasterPDE", "Dr", "filled in here as the rest of the same table, not a new concept: `[Dr]` (open) for the deeper structure", _GENESIS_DOC, 2248),
    ("Gateway.InputAdapter", "finite_diagnostic", "native-unit master PDE, `[Dr] + [finite_diagnostic]` for the gateway calculator itself — explicitly ...", _GENESIS_DOC, 2249),
    ("Gateway.OutputAdapters", "finite_diagnostic", "native-unit master PDE, `[Dr] + [finite_diagnostic]` for the gateway calculator itself — explicitly ...", _GENESIS_DOC, 2249),
    ("V0_DomainDiscoveryEngine", "finite_diagnostic", "a **domain-discovery engine**, tiered `finite_diagnostic`", _GENESIS_DOC, 2447),
    ("lambda0_collapse", "Dr", "**The λ=0 collapse (new, 2026-07-21, [Dr]).** The same Fiedler spectrum that reads out ...", _GENESIS_DOC, 2575),
    ("q_formal_commuting_square", "Th_coqc", "it has been given a machine-checked name: **InfoQuotientCompressionExactness** — a `Th_coqc` theorem, not a metaphor.", _GENESIS_DOC, 2224),
    ("bR_Ledger_qQ_negative_result", "finite_diagnostic", "New in v3.1: a `finite_diagnostic`-tier **architecture**, not a first-principles derivation, for ...", _GENESIS_DOC, 2751),
    ("SM_G0_order_defect", "Th_coqc", "`=0` + a **Z₆ global quotient** (Th_coqc); the one-generation matter skeleton is found BLIND", _GENESIS_DOC, 3327),
    ("B.2a.ConservationLedger", "Dr", "those two steps — carried here as bookkeeping machinery, `[finite_diagnostic]` where it runs, `[Dr]` (interpretive layer)", _GENESIS_DOC, 3986),
    ("B.2a.SynthesisComplexity", "finite_diagnostic", "those two steps — carried here as bookkeeping machinery, `[finite_diagnostic]` where it runs, `[Dr]` (interpretive layer)", _GENESIS_DOC, 3986),
    ("MeasuringAgency", "Dr", "Claim tier: `Dr` (open theoretical; falsifiable — §11 of `docs/claims/HUMAN_AGENCY_SINGLE_TAU_C.md`)", _GENESIS_DOC, 5072),
    ("step38", "Th_coqc", "Steps 38–41 — the growth ladder, the record law, CPTP completeness, and the operator→metric theorem are each proven axiom-free in `RDL_*.v` ... `Th_coqc` here certifies these four specific ∀-statements are proven", _GENESIS_DOC, 5897),
    ("step39", "Th_coqc", "Steps 38–41 — the growth ladder, the record law, CPTP completeness, and the operator→metric theorem are each proven axiom-free in `RDL_*.v` ... `Th_coqc` here certifies these four specific ∀-statements are proven", _GENESIS_DOC, 5897),
    ("step40", "Th_coqc", "Steps 38–41 — the growth ladder, the record law, CPTP completeness, and the operator→metric theorem are each proven axiom-free in `RDL_*.v` ... `Th_coqc` here certifies these four specific ∀-statements are proven", _GENESIS_DOC, 5897),
    ("step41", "Th_coqc", "Steps 38–41 — the growth ladder, the record law, CPTP completeness, and the operator→metric theorem are each proven axiom-free in `RDL_*.v` ... `Th_coqc` here certifies these four specific ∀-statements are proven", _GENESIS_DOC, 5897),
    ("X.1", "Th_coqc", "(scale-covariance constant) rescales covariantly — `[Th_coqc]`", _GENESIS_DOC, 5957),
    ("X.3", "Th_coqc", "X.3 — Assumption Ledger (Th_coqc naming corollary): a claim is `Th_coqc` only when the Coq artifact builds AND assumptions are publicly disclosed.", _GENESIS_DOC, 6002),
    ("X.4a", "Th_coqc", "| `Th_coqc` | Machine-checked structural theorem | Energy stability, CPTP, metric | (X.4 admissibility-square row, InfoQuotientCompressionExactness)", _GENESIS_DOC, 6099),
    ("XI.1b", "Th_coqc", "XI.1 — NEW rule: Th_coqc may never be paired with an unmatched continuum-physics noun (label inflation) | `Th_coqc` | Machine-checked structural theorem |", _GENESIS_DOC, 6099),
    ("XI.2b", "Dr", "**Quantity is not a pre-existing ℝ (new, 2026-07-21, [Dr], capstone).**", _GENESIS_DOC, 6131),
    ("XI.5-Fhuman", "Dr", "F-human: Measure τ_c^H directly and find it is not in the predicted range ... (falsifies §VIII / Dr claim)", _GENESIS_DOC, 6269),
    ("Guard10", "Dr", "Skew-L_R / metric-G well-posedness probe (pre-T1) ... passing this probe does not promote the tier above PROPOSED/Dr.", _GENESIS_DOC, 6432),
    ("Guard14", "finite_diagnostic", "NOT a new root rule — the finite_diagnostic instance of the domain-discovery engine, run over ℚ, else abstain.", _GENESIS_DOC, 6473),
    ("XIV.6", "finite_diagnostic", "### XIV.6 Domain-Discovery Engine (`finite_diagnostic`, adversarially battery-tested)", _GENESIS_DOC, 6693),
    ("v011.2", "Ax", "(z_n,u_n) ≠ (z_n',u_n')  ⇒  (z_{n+1},r_n) ≠ (z_{n+1}',r_n')      [Ax]  no distinction lost at the step", _GENESIS_DOC, 6947),
    ("v011.4", "finite_diagnostic", "Source: v0.11 §10. [finite_diagnostic]", _GENESIS_DOC, 6974),
    ("v011.13", "Open", "Source: v0.11 §19, \"Proposed/open,\" reproduced verbatim. [Open].", _GENESIS_DOC, 7138),
    ("WP.S24.HeldOutCheckerReport", "finite_diagnostic", "(HeldOutCheckerReport yaml block, §24.4) claim_status: finite_diagnostic", _WP_DOC, 3440),
    ("WP.S24.ConcreteDomainRunReport", "finite_diagnostic", "(ConcreteDomainRunReport yaml block, §24) tier: finite_diagnostic", _WP_DOC, 3636),
    (
        "CMC", "Ax",
        (
            "\"Axiom cmc_bridge_axiom : CMC_Bridge_Obligation.\" preceded by \"Founder-level "
            "CMC axiom, intentionally named and disclosed. The project does not retreat "
            "from this claim.\" -- this row's own tier_in_genesis_note already states: "
            "\"not a Genesis bracket tag -- inferred directly from the Coq `Axiom` keyword "
            "and the source's own disclosure comment ..., which is stronger, not weaker, "
            "evidence than a bracket tag.\""
        ),
        "formal/CMC_TargetClass_Definitions.v", 58,
    ),
]


def apply_canonical_fixes(canon, dry_run):
    by_code = {e["code"]: e for e in canon["canonical"]}
    lineage_events = []
    n_status_refined = 0
    n_tier_tagged = 0
    n_skipped_status = 0
    n_skipped_tier = 0

    for code, new_note in STATUS_NOTE_REFINEMENTS.items():
        e = by_code.get(code)
        if e is None:
            continue
        if e.get("status") != "unverified":
            n_skipped_status += 1
            continue
        if new_note in (e.get("status_note") or ""):
            n_skipped_status += 1
            continue  # already refined by a prior run
        print(f"STATUS_NOTE refine  {code}")
        if not dry_run:
            old_note = e.get("status_note", "")
            e["status_note"] = old_note.rstrip() + " " + new_note
            lineage_events.append({
                "code": code, "date": DATE, "event": "revised",
                "from": "status_note (pre-re-check)",
                "to": "status_note (Lane C 2026-09-07 re-check appended)",
                "reason": (
                    "Toledo v1.5 Lane C task 1: re-verified the prior lane's own "
                    "finding directly against the cited private-repo source file at "
                    "the same anchored commit; status stays unverified, status_note "
                    "gains a dated re-confirmation."
                ),
                "by": BY,
            })
        n_status_refined += 1

    for code, result in CANONICAL_TIER_TAGS.items():
        e = by_code.get(code)
        if e is None:
            continue
        if e.get("tier") != "untagged":
            n_skipped_tier += 1
            continue
        print(f"TIER tag  {code} -> {result['tier']}")
        if not dry_run:
            old_verbatim = e.get("tier_in_genesis_verbatim", "")
            e["tier"] = result["tier"]
            e["tier_evidence"] = result["tier_evidence"]
            lineage_events.append({
                "code": code, "date": DATE, "event": "revised",
                "from": f"tier=untagged (tier_in_genesis_verbatim={old_verbatim!r})",
                "to": f"tier={result['tier']}",
                "reason": (
                    "Toledo v1.5 Lane C task 2: the entry's own source occurrence "
                    "(not previously checked by scripts/v11_C.py, whose regex does "
                    "not match this occurrence's raw_key shape) states this tier "
                    f"explicitly. {result['tier_evidence']['quote'][:200]}"
                ),
                "by": BY,
            })
        n_tier_tagged += 1

    return lineage_events, n_status_refined, n_tier_tagged, n_skipped_status, n_skipped_tier


def apply_root_tier_fixes(root_doc, dry_run):
    rows = root_doc["root_equations"]
    by_code = {r["code"]: r for r in rows}
    n_tagged = 0
    n_skipped = 0
    for code, tier, quote, source_file, line in ROOT_TIER_TAGS:
        r = by_code.get(code)
        if r is None:
            continue
        if r.get("tier") is not None:
            n_skipped += 1
            continue
        print(f"ROOT TIER  {code} -> {tier}")
        if not dry_run:
            commit = GENESIS_COMMIT if source_file in (_GENESIS_DOC, _WP_DOC) else SOLVER_ARC_COMMIT
            repo = "readout_genesis" if source_file in (_GENESIS_DOC, _WP_DOC) else '"solver arc (private)"'
            r["tier"] = tier
            r["tier_evidence"] = {
                "quote": quote,
                "source": f"{repo}@{commit}, {source_file}",
                "line": f"{source_file}:{line}",
                "commit": commit,
            }
        n_tagged += 1
    return n_tagged, n_skipped


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    canon = json.loads((REG / "CANONICAL.json").read_text(encoding="utf-8"))
    (lineage_events, n_status_refined, n_tier_tagged,
     n_skipped_status, n_skipped_tier) = apply_canonical_fixes(canon, dry_run=True)

    root_doc = json.loads((REG / "genesis_root.json").read_text(encoding="utf-8"))
    n_root_tagged, n_root_skipped = apply_root_tier_fixes(root_doc, dry_run=True)

    print(
        f"\nDry-run summary: CANONICAL status_note refine {n_status_refined} "
        f"(skip {n_skipped_status}), CANONICAL tier tag {n_tier_tagged} "
        f"(skip {n_skipped_tier}), genesis_root tier tag {n_root_tagged} "
        f"(skip {n_root_skipped})."
    )

    if args.dry_run:
        return

    # re-read immediately before writing (another lane may have written meanwhile)
    canon2 = json.loads((REG / "CANONICAL.json").read_text(encoding="utf-8"))
    lineage_events, *_ = apply_canonical_fixes(canon2, dry_run=False)

    by_tier = {}
    for e in canon2["canonical"]:
        by_tier[e.get("tier", "untagged")] = by_tier.get(e.get("tier", "untagged"), 0) + 1
    canon2.setdefault("counts", {})["by_tier"] = by_tier
    by_status = {}
    for e in canon2["canonical"]:
        by_status[e.get("status", "current")] = by_status.get(e.get("status", "current"), 0) + 1
    canon2.setdefault("counts", {})["by_status"] = by_status

    tmp = REG / "CANONICAL.json.tmp"
    tmp.write_text(json.dumps(canon2, indent=2, ensure_ascii=False), encoding="utf-8")
    tmp.replace(REG / "CANONICAL.json")

    if lineage_events:
        with open(REG / "LINEAGE.jsonl", "a", encoding="utf-8") as fh:
            for ev in lineage_events:
                fh.write(json.dumps(ev, ensure_ascii=False) + "\n")

    root_doc2 = json.loads((REG / "genesis_root.json").read_text(encoding="utf-8"))
    n_root_tagged2, _ = apply_root_tier_fixes(root_doc2, dry_run=False)
    tmp2 = REG / "genesis_root.json.tmp"
    tmp2.write_text(json.dumps(root_doc2, indent=2, ensure_ascii=False), encoding="utf-8")
    tmp2.replace(REG / "genesis_root.json")

    print(
        f"\nApplied: CANONICAL.json updated ({len(lineage_events)} LINEAGE events "
        f"appended); genesis_root.json {n_root_tagged2} root rows tier-tagged."
    )


if __name__ == "__main__":
    main()
