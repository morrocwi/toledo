#!/usr/bin/env python3
"""Toledo v1.8 REGISTRAR merge -- registry/proposals/spectral_ceiling_family.json.

Four founder-instructed spectral-graph-theory objects (2026-09-08 intake),
already through an independent adversarial re-verification pass
(ops/urcf_tower/REVERIFICATION_2026-09-08.md) that checked each one against
the LIVE registry (not just the proposal's own prose):

  SPEC-01 (weld/M.40.v1) -- Anderson-Morley sharp curvature ceiling, witness
    form over Q. partial_overlap: the base inequality |lam| <= deg u + deg v
    duplicates the CLASSICAL fact already bare-cited (no real Coq witness)
    as q_formal/M.05.v1 -- kept out of this entry's own registered
    statement, but this file is that citation's first real proof. Only the
    curvature-floor corollary (lam <= 4 - Fmin) is registered as this
    entry's own statement. relations[] cross-references q_formal/M.05.v1.
    AMBIGUITY (flagged, not silently resolved): the task instructions asked
    whether q_formal/M.05.v1 itself should instead be bumped in place
    (LINEAGE 'revised' event, .v1 -> .v2, coq_status wrapped_related ->
    closed) as its own long-overdue witness, rather than registering a
    brand-new code. No LINEAGE.jsonl precedent for "citation later gets its
    first real witness" was found (checked below, live, before writing).
    Per the task's own instruction, pattern (a) -- new code + relation -- is
    taken as the default in the absence of a precedent, and this ambiguity
    is reported to the chair rather than silently guessed.

  SPEC-02 (weld/M.41.v1) -- Dirichlet energy PSD/gauge/stencil/second-
    difference. genuinely_new, registered in full.

  SPEC-03 (weld/M.42.v1) -- Rayleigh-quotient ceiling lam <= 2*dmax,
    division-free. genuinely_new, registered in full. Thematically-adjacent
    bare citations q_formal/M.04.v1 and q_formal/M.08.v1 are cross-
    referenced (relates-to, per the reverification note's own suggestion),
    NOT claimed as overlap/duplicates.

  SPEC-04 (weld/M.43.v1) -- kernel(L_R) = constants under connectivity.
    partial_overlap: the "constants subset of kernel" half duplicates
    L_R/M.22.v1 (closed, no connectivity needed) -- kept out of this
    entry's own registered statement; only the reverse inclusion (kernel
    subset of constants, given connectivity / lambda_2>0 characterization)
    is registered as this entry's own statement. relations[] cross-
    references L_R/M.22.v1 (the real overlap) and, as thematic-adjacency
    only, the bare citations q_formal/M.06.v1 / q_formal/M.07.v1.

Same idiom as scripts/v18_urcf_merge.py / scripts/v18_ranc_merge.py /
scripts/v18_causal_merge.py: re-reads registry/CANONICAL.json immediately
before the one atomic write, is idempotent (a second run is a no-op once
the codes/aliases exist), verifies every parent/relation target code
actually exists in the LIVE registry before writing an edge, and assigns
real running weld/M.<nn>.v1 numbers (next free after the live max, computed
fresh, not hardcoded from a stale read).

Preserves each object's own 2026-09-08 reverification verdict/evidence
verbatim inside that entry's `drift_note` field (registry/SCHEMA.md's own
field for "this entry's placement (parent/relation) is disclosed as weaker
than a demonstrated reading -- quotes what was checked and why no stronger
evidence was found"), exactly the pattern used for weld/H.51.v1 and
weld/P.05.v1 earlier today (git show d786116 / d0d4709).

coq_status: closed for all four (coqc-verified IN THIS REPO by this script's
author before running this script -- see the accompanying report; every
`Print Assumptions` call in each of the four coq/canonical/weld__M_*.v files
printed "Closed under the global context", independently re-observed, not
copied from the proposal's own `print_assumptions_verbatim` claim).

Run: python3 scripts/v18_spectral_merge.py
"""
import json
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
CAN_DIR = ROOT / "coq" / "canonical"
DATE = "2026-09-08"
BY = "toledo-v1.8-spectral"

CANONICAL_PATH = REG / "CANONICAL.json"
GENESIS_PATH = REG / "genesis_root.json"
LINEAGE_PATH = REG / "LINEAGE.jsonl"

PARENT_L_R = "L_R"
REL_TARGET_SPEC01 = "q_formal/M.05.v1"
REL_TARGET_SPEC04 = "L_R/M.22.v1"
REL_ADJACENT_SPEC03 = ["q_formal/M.04.v1", "q_formal/M.08.v1"]
REL_ADJACENT_SPEC04 = ["q_formal/M.06.v1", "q_formal/M.07.v1"]

AMBIGUITY_NOTE_SPEC01 = (
    "AMBIGUITY FLAGGED, not silently resolved: this could instead have been "
    "registered as a LINEAGE 'revised' event bumping q_formal/M.05.v1 itself "
    "in place (.v1 -> .v2, coq_status wrapped_related -> closed), since this "
    "file is q_formal/M.05.v1's own long-overdue first real Coq witness. "
    "LINEAGE.jsonl was checked live for a 'citation later gets its first "
    "real witness' precedent before choosing -- none found (the closest "
    "entries are v1.1 Lane A 'wrapped_related' wrapper events, which wrap "
    "an EXISTING Toledo-native identifier around already-imported code, not "
    "a later independent proof of a previously bare-cited classical fact). "
    "Per task instruction, pattern (a) -- new code + relations[] cross-"
    "reference -- is taken in the absence of a precedent; reported to the "
    "chair as a genuinely open design question, not a confident choice."
)

# ---------------------------------------------------------------------------
# SPEC-01 -- weld/M.40.v1
# ---------------------------------------------------------------------------
SPEC01 = {
    "code": "weld/M.40.v1",
    "root": "weld",
    "layer": "reading",
    "domain": "M",
    "aliases": ["InfoSpectralCeilingSharp:sharp_curvature_ceiling"],
    "name": "Sharp curvature ceiling for a graph Laplacian eigenpair (Anderson-Morley corollary, witness form over Q)",
    "statement": {
        "latest": (
            r"\forall (\lambda,x) \text{ an exact eigenpair witness of } L_R x=\lambda x,\ "
            r"\forall F_{\min} \text{ a curvature floor } (\forall e,\ F_{\min}\le \mathrm{forman}(e)):\ "
            r"\lambda \le 4-F_{\min}"
        ),
        "format": "latex",
    },
    "statements_history": [
        {
            "v": 1,
            "statement": (
                r"\forall (\lambda,x) \text{ an exact eigenpair witness of } L_R x=\lambda x,\ "
                r"\forall F_{\min} \text{ a curvature floor } (\forall e,\ F_{\min}\le \mathrm{forman}(e)):\ "
                r"\lambda \le 4-F_{\min}"
            ),
            "date": DATE,
            "reason": (
                f"{BY}: initial capture from InfoSpectralCeilingSharp.v "
                "(standalone Coq file, Downloads, not previously deposited "
                "or registered), Corollary sharp_curvature_ceiling. Trimmed "
                "to the curvature-floor corollary only per the "
                "2026-09-08 reverification note -- the base inequality "
                "|lam|<=deg u+deg v duplicates the classical citation "
                "q_formal/M.05.v1, not re-registered here."
            ),
            "by": BY,
        }
    ],
    "parents": [
        {
            "code": PARENT_L_R,
            "derived_via": "refines",
            "evidence": (
                "Sharpens (a factor sqrt(2) tighter, per the source file's "
                "own header) the weaker 2*dmax spectral ceiling (weld/M.42.v1) "
                "bounding the spectrum of the same retained graph-Laplacian "
                "operator L_R (root EQ-008 / root row L_R)."
            ),
        }
    ],
    "children": [],
    "origin": {
        "source": "domain_registry",
        "repo_anchor": None,
        "record_id": None,
        "doi": None,
        "section": (
            "InfoSpectralCeilingSharp.v (standalone Coq file, Downloads, "
            "not previously deposited or registered)"
        ),
    },
    "status": "current",
    "status_note": "",
    "superseded_by": None,
    "tier": "Th_coqc",
    "tier_in_genesis_verbatim": "",
    "coq": {
        "file": "coq/canonical/weld__M_40_v1.v",
        "identifier": "sharp_curvature_ceiling",
        "assumptions": "Closed under the global context",
        "imported_from": None,
        "coq_status": "closed",
        "coq_axioms": [],
        "coq_source_redistributed": True,
        "identifiers": [
            {"file": "coq/canonical/weld__M_40_v1.v", "identifier": "esum_abs_triangle"},
            {"file": "coq/canonical/weld__M_40_v1.v", "identifier": "exists_max_edge"},
            {"file": "coq/canonical/weld__M_40_v1.v", "identifier": "acontrib_bound"},
            {"file": "coq/canonical/weld__M_40_v1.v", "identifier": "pair_term_bound"},
            {"file": "coq/canonical/weld__M_40_v1.v", "identifier": "anderson_morley_witness"},
            {"file": "coq/canonical/weld__M_40_v1.v", "identifier": "sharp_curvature_ceiling"},
        ],
    },
    "relations": [
        {
            "type": "refines",
            "target": REL_TARGET_SPEC01,
            "note": (
                "q_formal/M.05.v1 bare-cites this same classical Anderson-"
                "Morley inequality (untagged/wrapped_related, no entry-"
                "specific Coq witness in Toledo -- see its own coq.note). "
                "This entry's base lemma anderson_morley_witness is the "
                "first real Coq proof of that already-cited fact; only the "
                "curvature-floor corollary is registered as this entry's "
                "own new statement."
            ),
        }
    ],
    "occurrences": [],
    "role": "other",
    "first_assigned": DATE,
    "drift_note": (
        "Reverification 2026-09-08 verdict: partial_overlap. Verbatim "
        "evidence: \"Found q_formal/M.05.v1 in CANONICAL.json, named "
        "literally 'Anderson-Morley eigenvalue bound lambda_max<=max(deg "
        "u+deg v)' -- the exact same classical theorem this proposal cites "
        "as its BORROWED half. However q_formal/M.05.v1 is tier "
        "'untagged', coq_status 'wrapped_related', and its own coq.note "
        "admits its 29 cited identifiers ... are an undivided generic "
        "block shared identically across all 32 q_formal entries, 'with "
        "no entry-specific identifier singled out as evidence for this "
        "entry's own statement ... picking one lemma to specialise from "
        "would be an invented, not evidence-backed, choice -- not done.' "
        "In plain terms: q_formal/M.05.v1 is a bare NAME-CITATION of the "
        "classical Anderson-Morley result with NO actual matching Coq "
        "proof behind it in Toledo. So: the base inequality |lam|<=deg "
        "u+deg v is a duplicate of the classical fact q_formal/M.05.v1 "
        "already cites by name (not registered as a second new object), "
        "but this proposal's Coq file is the FIRST real formalization "
        "Toledo has of that already-cited claim. The curvature-floor "
        "corollary (lambda<=4-Fmin) is additional content specific to this "
        "proposal, not part of the classical citation or any other Toledo "
        "row -- genuinely new.\" (registry/proposals/spectral_ceiling_family.json, "
        "PROP-SPEC-01.reverification_2026-09-08). "
        + AMBIGUITY_NOTE_SPEC01
    ),
}

# ---------------------------------------------------------------------------
# SPEC-02 -- weld/M.41.v1
# ---------------------------------------------------------------------------
SPEC02 = {
    "code": "weld/M.41.v1",
    "root": "weld",
    "layer": "reading",
    "domain": "M",
    "aliases": [
        "RDL_GammaSpectral:energy_nonneg",
        "RDL_GammaSpectral:laplacian_stencil",
        "RDL_GammaSpectral:secondDiff_readout_invariant",
    ],
    "name": "Dirichlet energy PSD/gauge invariance for a weighted graph (L_R PSD, Fiedler); discrete second-difference IS the discrete negative Laplacian",
    "statement": {
        "latest": (
            r"\text{energy\_nonneg: nonnegative edge weights} \Rightarrow \Gamma(x)\ge 0\ "
            r"(L_R \text{ PSD}).\quad "
            r"\text{energy\_edge\_gauge: } \Gamma \text{ invariant under edge-list relabelling}.\quad "
            r"\text{laplacian\_stencil: } [1,-2,1]*f = (\Delta_{\text{discrete}} f).\quad "
            r"\text{secondDiff\_readout\_invariant: the second difference of a quadratic reads out "
            r"the same value } 2a \text{ at every resolution } h"
        ),
        "format": "latex",
    },
    "statements_history": [
        {
            "v": 1,
            "statement": (
                r"\text{energy\_nonneg: nonnegative edge weights} \Rightarrow \Gamma(x)\ge 0\ "
                r"(L_R \text{ PSD}).\quad "
                r"\text{energy\_edge\_gauge: } \Gamma \text{ invariant under edge-list relabelling}.\quad "
                r"\text{laplacian\_stencil: } [1,-2,1]*f = (\Delta_{\text{discrete}} f).\quad "
                r"\text{secondDiff\_readout\_invariant: the second difference of a quadratic reads out "
                r"the same value } 2a \text{ at every resolution } h"
            ),
            "date": DATE,
            "reason": (
                f"{BY}: initial capture from RDL_GammaSpectral.v (standalone "
                "Coq file, Downloads, not previously deposited or "
                "registered); genuinely new content per the 2026-09-08 "
                "reverification (no existing L_R/* reading proves PSD-ness "
                "for all x, gauge invariance, the [1,-2,1] stencil, or "
                "readout-invariance of the second difference)."
            ),
            "by": BY,
        }
    ],
    "parents": [
        {
            "code": PARENT_L_R,
            "derived_via": "refines",
            "evidence": (
                "Proves, over Q with no axioms, the PSD/positive-"
                "semidefinite property that the existing root row L_R "
                "already states in prose (symmetric (B_sym), PSD "
                "(B_self_nonneg), kernel contains constants); L_R/M.20.v1 "
                "and L_R/M.21.v1 already witness the symmetry and row-sum-"
                "zero halves of that same root prose -- this entry adds "
                "the PSD half plus new gauge/stencil/readout-invariance "
                "content that has no existing reading at all."
            ),
        }
    ],
    "children": [],
    "origin": {
        "source": "domain_registry",
        "repo_anchor": None,
        "record_id": None,
        "doi": None,
        "section": (
            "RDL_GammaSpectral.v (standalone Coq file, Downloads, not "
            "previously deposited or registered)"
        ),
    },
    "status": "current",
    "status_note": "",
    "superseded_by": None,
    "tier": "Th_coqc",
    "tier_in_genesis_verbatim": "",
    "coq": {
        "file": "coq/canonical/weld__M_41_v1.v",
        "identifier": "energy_nonneg, energy_edge_gauge, laplacian_stencil, secondDiff_quadratic, secondDiff_readout_invariant",
        "assumptions": "Closed under the global context",
        "imported_from": None,
        "coq_status": "closed",
        "coq_axioms": [],
        "coq_source_redistributed": True,
        "identifiers": [
            {"file": "coq/canonical/weld__M_41_v1.v", "identifier": "energy_nonneg"},
            {"file": "coq/canonical/weld__M_41_v1.v", "identifier": "energy_edge_gauge"},
            {"file": "coq/canonical/weld__M_41_v1.v", "identifier": "laplacian_stencil"},
            {"file": "coq/canonical/weld__M_41_v1.v", "identifier": "secondDiff_quadratic"},
            {"file": "coq/canonical/weld__M_41_v1.v", "identifier": "secondDiff_readout_invariant"},
        ],
    },
    "relations": [],
    "occurrences": [],
    "role": "other",
    "first_assigned": DATE,
    "drift_note": (
        "Reverification 2026-09-08 verdict: genuinely_new. Verbatim "
        "evidence: \"Checked L_R/M.20.v1 (laplacian_symmetric), L_R/M.21.v1 "
        "(laplacian_rowsum_zero) and L_R/M.22.v1 (laplacian_ones_in_kernel) "
        "-- the only existing L_R/* readings anywhere near this subject. "
        "All three are purely structural facts about the Laplacian matrix "
        "(symmetry, zero row-sums, the constant vector lying in the "
        "kernel); NONE of them prove positive-semidefiniteness (Gamma(x)>=0 "
        "for ALL x, not just the constant vector), gauge invariance under "
        "edge relabelling, the [1,-2,1] finite-difference stencil "
        "identity, or the readout-invariance of the second difference of a "
        "quadratic across resolutions h. Whole-registry keyword search for "
        "'positive semidefinite'/'psd'/'gauge invarian'/'stencil'/'second "
        "difference'/'dirichlet energy' turned up nothing else relevant. "
        "Confirmed genuinely_new.\" "
        "(registry/proposals/spectral_ceiling_family.json, "
        "PROP-SPEC-02.reverification_2026-09-08)."
    ),
}

# ---------------------------------------------------------------------------
# SPEC-03 -- weld/M.42.v1
# ---------------------------------------------------------------------------
SPEC03 = {
    "code": "weld/M.42.v1",
    "root": "weld",
    "layer": "reading",
    "domain": "M",
    "aliases": ["RDL_SpectralCeiling:rayleigh_ceiling", "RDL_SpectralCeiling:step_ratio_window"],
    "name": "Rayleigh-quotient spectral ceiling of a graph quadratic form from the degree bound (division-free, no eigenvalue theory)",
    "statement": {
        "latest": (
            r"x^T L x \le 2\,d_{\max}\,\|x\|^2\quad\Rightarrow\quad "
            r"0\le\lambda\le 2\,d_{\max}\ \text{(any exact Rayleigh pair)}"
        ),
        "format": "latex",
    },
    "statements_history": [
        {
            "v": 1,
            "statement": (
                r"x^T L x \le 2\,d_{\max}\,\|x\|^2\quad\Rightarrow\quad "
                r"0\le\lambda\le 2\,d_{\max}\ \text{(any exact Rayleigh pair)}"
            ),
            "date": DATE,
            "reason": (
                f"{BY}: initial capture from RDL_SpectralCeiling.v "
                "(standalone Coq file, Downloads, not previously deposited "
                "or registered); genuinely new per the 2026-09-08 "
                "reverification."
            ),
            "by": BY,
        }
    ],
    "parents": [
        {
            "code": PARENT_L_R,
            "derived_via": "refines",
            "evidence": (
                "The Gershgorin-type spectral ceiling lambda<=2*dmax for "
                "the retained graph-Laplacian L_R, derived by pure sum "
                "manipulation (no eigen-theory invoked, an eigenpair taken "
                "extensionally as a hypothesis) -- the weaker bound that "
                "weld/M.40.v1 (Anderson-Morley) sharpens by a factor of "
                "sqrt(2)."
            ),
        }
    ],
    "children": [],
    "origin": {
        "source": "domain_registry",
        "repo_anchor": None,
        "record_id": None,
        "doi": None,
        "section": (
            "RDL_SpectralCeiling.v (standalone Coq file, Downloads, not "
            "previously deposited or registered)"
        ),
    },
    "status": "current",
    "status_note": "",
    "superseded_by": None,
    "tier": "Th_coqc",
    "tier_in_genesis_verbatim": "",
    "coq": {
        "file": "coq/canonical/weld__M_42_v1.v",
        "identifier": "deg_node_swap, form_degree_bound, rayleigh_nonneg, rayleigh_ceiling, mode_product_ceiling, step_ratio_window",
        "assumptions": "Closed under the global context",
        "imported_from": None,
        "coq_status": "closed",
        "coq_axioms": [],
        "coq_source_redistributed": True,
        "identifiers": [
            {"file": "coq/canonical/weld__M_42_v1.v", "identifier": "deg_node_swap"},
            {"file": "coq/canonical/weld__M_42_v1.v", "identifier": "form_degree_bound"},
            {"file": "coq/canonical/weld__M_42_v1.v", "identifier": "rayleigh_nonneg"},
            {"file": "coq/canonical/weld__M_42_v1.v", "identifier": "rayleigh_ceiling"},
            {"file": "coq/canonical/weld__M_42_v1.v", "identifier": "mode_product_ceiling"},
            {"file": "coq/canonical/weld__M_42_v1.v", "identifier": "step_ratio_window"},
        ],
    },
    "relations": [
        {
            "type": "relates-to",
            "target": t,
            "note": (
                "Thematically adjacent bare 'untagged'/'wrapped_related' "
                "name-citation (same generic non-entry-specific evidence "
                "block as q_formal/M.05.v1) -- NOT a proof of this specific "
                "division-free inequality; cross-referenced per the "
                "2026-09-08 reverification note's own suggestion, not a "
                "claimed overlap."
            ),
        }
        for t in REL_ADJACENT_SPEC03
    ],
    "occurrences": [],
    "role": "other",
    "first_assigned": DATE,
    "drift_note": (
        "Reverification 2026-09-08 verdict: genuinely_new. Verbatim "
        "evidence: \"Found q_formal/M.04.v1 ('Rayleigh quotient / theory of "
        "sound') and q_formal/M.08.v1 ('Spectral graph theory (survey)') "
        "in CANONICAL.json -- thematically adjacent, but both are the SAME "
        "'untagged'/'wrapped_related' bare-citation pattern as "
        "q_formal/M.05.v1 above (identical generic 29-identifier evidence "
        "block, explicitly disclosed by their own coq.note as not entry-"
        "specific). Neither states the specific inequality x^T L x <= "
        "2*dmax*||x||^2 or the ceiling lambda <= 2*dmax; they are general "
        "survey/topic citations, not this specific division-free "
        "Gershgorin-type bound. Confirmed genuinely_new content, though "
        "thematically related to q_formal/M.04.v1 and M.08.v1 (worth "
        "cross-referencing at merge time as 'reads' relations, not as "
        "duplicates).\" (registry/proposals/spectral_ceiling_family.json, "
        "PROP-SPEC-03.reverification_2026-09-08). Cross-reference added as "
        "'relates-to' (not 'reads') since neither is an actual proof being "
        "read/used by this entry's own proof."
    ),
}

# ---------------------------------------------------------------------------
# SPEC-04 -- weld/M.43.v1
# ---------------------------------------------------------------------------
SPEC04 = {
    "code": "weld/M.43.v1",
    "root": "weld",
    "layer": "reading",
    "domain": "M",
    "aliases": ["URCF_RD_All:Graph.kernel_connected"],
    "name": "Kernel of the graph Laplacian equals the constants on a connected graph (lambda_2 > 0 zero-mode characterization)",
    "statement": {
        "latest": (
            r"\text{Graph connected} \Rightarrow \ker(L_R) \subseteq \{\text{constant vectors}\}\ "
            r"(\lambda_2>0)\quad\text{(reverse inclusion; forward inclusion is L\_R/M.22.v1)}"
        ),
        "format": "latex",
    },
    "statements_history": [
        {
            "v": 1,
            "statement": (
                r"\text{Graph connected} \Rightarrow \ker(L_R) \subseteq \{\text{constant vectors}\}\ "
                r"(\lambda_2>0)\quad\text{(reverse inclusion; forward inclusion is L\_R/M.22.v1)}"
            ),
            "date": DATE,
            "reason": (
                f"{BY}: initial capture from URCF_RD_All.v, Module Graph "
                "(originally RDL_Graph.v), standalone Coq file, Downloads, "
                "not previously deposited or registered. Trimmed to the "
                "reverse-inclusion direction only per the 2026-09-08 "
                "reverification note -- the 'constants subset of kernel' "
                "half duplicates L_R/M.22.v1, not re-registered here."
            ),
            "by": BY,
        }
    ],
    "parents": [
        {
            "code": PARENT_L_R,
            "derived_via": "refines",
            "evidence": (
                "Sharpens the root row L_R's own stated property ('its "
                "kernel contains constants') to an exact equality "
                "conditional on graph connectivity. Also discharges the "
                "zero-mode premise the URCF turbulence law (weld/P.05.v1) "
                "assumes but never itself proves."
            ),
        }
    ],
    "children": [],
    "origin": {
        "source": "domain_registry",
        "repo_anchor": None,
        "record_id": None,
        "doi": None,
        "section": (
            "URCF_RD_All.v, module Graph (from RDL_Graph.v; standalone Coq "
            "file, Downloads, not previously deposited or registered)"
        ),
    },
    "status": "current",
    "status_note": "",
    "superseded_by": None,
    "tier": "Th_coqc",
    "tier_in_genesis_verbatim": "",
    "coq": {
        "file": "coq/canonical/weld__M_43_v1.v",
        "identifier": "kernel_connected",
        "assumptions": "Closed under the global context",
        "imported_from": None,
        "coq_status": "closed",
        "coq_axioms": [],
        "coq_source_redistributed": True,
        "identifiers": [
            {"file": "coq/canonical/weld__M_43_v1.v", "identifier": "energy_nonneg"},
            {"file": "coq/canonical/weld__M_43_v1.v", "identifier": "energy_const"},
            {"file": "coq/canonical/weld__M_43_v1.v", "identifier": "energy_zero_edge"},
            {"file": "coq/canonical/weld__M_43_v1.v", "identifier": "kernel_connected"},
        ],
    },
    "relations": [
        {
            "type": "refines",
            "target": REL_TARGET_SPEC04,
            "note": (
                "L_R/M.22.v1 (laplacian_ones_in_kernel, closed) already "
                "proves the 'constants subset of kernel' half for ANY "
                "graph, no connectivity needed -- duplicate of that half, "
                "not re-registered here. This entry registers only the "
                "reverse inclusion (kernel subset of constants, given "
                "connectivity)."
            ),
        },
    ] + [
        {
            "type": "relates-to",
            "target": t,
            "note": (
                "Thematically adjacent bare 'untagged'/'wrapped_related' "
                "name-citation (Fiedler/algebraic-connectivity), same "
                "generic non-entry-specific evidence block as "
                "q_formal/M.05.v1 -- NOT a proof of the kernel-equality "
                "fact; cross-referenced, not a claimed overlap."
            ),
        }
        for t in REL_ADJACENT_SPEC04
    ],
    "occurrences": [],
    "role": "other",
    "first_assigned": DATE,
    "drift_note": (
        "Reverification 2026-09-08 verdict: partial_overlap. Verbatim "
        "evidence: \"L_R/M.22.v1 ('laplacian_ones_in_kernel', tier "
        "Th_coqc, coq_status closed, formal/IDM_Matrix.v line 132) "
        "ALREADY proves Sum n (fun j => Lap i j * 1) == 0 -- i.e. the "
        "all-ones (constant) vector lies in ker(L), for ANY graph, no "
        "connectivity assumption needed. This is exactly the 'constants "
        "subset of kernel' half of this proposal's claim -- a DUPLICATE of "
        "L_R/M.22.v1, not new. The reverse inclusion ('kernel subset of "
        "constants, given connectivity', i.e. the full equality "
        "ker(L)=span{1} and the lambda_2>0 zero-mode characterization) is "
        "NOT covered by L_R/M.22.v1 or any other L_R/* reading, and is not "
        "covered by the thematically-adjacent q_formal/M.06.v1 "
        "('Algebraic connectivity / Fiedler value') or q_formal/M.07.v1 "
        "('Diameter-based algebraic-connectivity floor') either -- both of "
        "those are again bare 'untagged'/'wrapped_related' name-citations "
        "with the same generic non-entry-specific evidence block, no "
        "actual proof of the kernel-equality fact. Kept as "
        "partial_overlap: the constants-in-kernel half duplicates "
        "L_R/M.22.v1, the connectivity-implies-equality half (and the "
        "lambda_2>0 characterization) is genuinely new.\" "
        "(registry/proposals/spectral_ceiling_family.json, "
        "PROP-SPEC-04.reverification_2026-09-08)."
    ),
}

NEW_ENTRIES = [SPEC01, SPEC02, SPEC03, SPEC04]


def recompute_counts(entries):
    return {
        "entries": len(entries),
        "by_status": dict(Counter(e["status"] for e in entries)),
        "by_domain": dict(Counter(e["domain"] for e in entries if e.get("domain"))),
        "by_tier": dict(Counter(e["tier"] for e in entries)),
        "by_coq_status": dict(Counter(e["coq"]["coq_status"] for e in entries)),
        "computed": f"{DATE} from canonical[] (scripts/v18_spectral_merge.py)",
    }


def main():
    doc = json.loads(CANONICAL_PATH.read_text(encoding="utf-8"))
    entries = doc["canonical"]
    by_code = {e["code"]: e for e in entries}

    pending = [e for e in NEW_ENTRIES if e["code"] not in by_code]
    if not pending:
        print("All 4 spectral-ceiling entries already exist -- idempotent no-op.")
        return

    already = [e["code"] for e in NEW_ENTRIES if e["code"] in by_code]
    if already:
        print(f"NOTE: {already} already exist -- skipping those, merging only "
              f"{[e['code'] for e in pending]}.")

    all_aliases_existing = {a for e in entries for a in (e.get("aliases") or [])}
    for e in pending:
        clash = [a for a in e["aliases"] if a in all_aliases_existing]
        if clash:
            raise SystemExit(f"{e['code']}: alias(es) {clash} already exist on "
                              "another entry -- abort, inspect before re-running.")

    # Verify every parent code and relation target actually exists live,
    # before writing any edge.
    genesis_doc = json.loads(GENESIS_PATH.read_text(encoding="utf-8"))
    genesis_codes = {r["code"] for r in genesis_doc["root_equations"]}
    for e in pending:
        for p in e["parents"]:
            if p["code"] not in by_code and p["code"] not in genesis_codes:
                raise SystemExit(
                    f"{e['code']}: parent {p['code']!r} not found in live "
                    "CANONICAL.json or genesis_root.json -- abort."
                )
        for r in e.get("relations", []):
            if r["target"] not in by_code and not any(
                x["code"] == r["target"] for x in pending
            ):
                raise SystemExit(
                    f"{e['code']}: relation target {r['target']!r} not found "
                    "in live CANONICAL.json -- abort."
                )
        if not (ROOT / e["coq"]["file"]).exists():
            raise SystemExit(
                f"{e['code']}: coq file {e['coq']['file']} does not exist on "
                "disk -- write it before running this merge script, abort."
            )

    # Assign real running weld/M.<nn>.v1 codes -- but NEW_ENTRIES above
    # already hardcode weld/M.40..43.v1; re-derive live and assert they are
    # still the next-free numbers (never silently drift if something else
    # claimed a number in the meantime).
    max_num = 0
    for e in entries:
        mo = re.match(r"^weld/M\.(\d+)\.v1$", e["code"])
        if mo:
            max_num = max(max_num, int(mo.group(1)))
    expected_next = [f"weld/M.{max_num + i}.v1" for i in range(1, len(pending) + 1)]
    got = [e["code"] for e in pending]
    if got != expected_next:
        raise SystemExit(
            f"Code assignment drift: expected next-free codes {expected_next}, "
            f"but this script's pending entries are {got} -- registry has "
            "moved since this script was written, abort and re-derive."
        )

    max_id = 0
    for e in entries:
        mo = re.match(r"^CAN-(\d+)$", str(e.get("id", "")))
        if mo:
            max_id = max(max_id, int(mo.group(1)))

    lineage_events = []
    for e in pending:
        entry = dict(e)
        max_id += 1
        entry["id"] = f"CAN-{max_id}"
        entries.append(entry)

        lineage_events.append({
            "code": entry["code"],
            "date": DATE,
            "event": "assigned",
            "from": None,
            "to": (
                f"new entry, tier={entry['tier']}, "
                f"coq_status={entry['coq']['coq_status']}, "
                f"parents={','.join(p['code'] for p in entry['parents'])}"
            ),
            "reason": (
                "Toledo v1.8 (spectral-ceiling family merge, "
                "registry/proposals/spectral_ceiling_family.json, after "
                "independent adversarial re-verification "
                "ops/urcf_tower/REVERIFICATION_2026-09-08.md): "
                f"{entry['name']}. See drift_note for the disclosed "
                "overlap/verification reasoning preserved verbatim."
            ),
            "by": BY,
        })

    for e in entries:
        e["children"] = []
    by_code_after = {e["code"]: e for e in entries}
    for e in entries:
        for p in e.get("parents", []):
            parent = by_code_after.get(p["code"])
            if parent is not None and e["code"] not in parent["children"]:
                parent["children"].append(e["code"])

    doc["counts"] = recompute_counts(entries)
    doc["canonical"] = entries
    CANONICAL_PATH.write_text(json.dumps(doc, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    with LINEAGE_PATH.open("a", encoding="utf-8") as f:
        for ev in lineage_events:
            f.write(json.dumps(ev, ensure_ascii=False) + "\n")

    print(f"Registered {len(pending)} entries: {[e['code'] for e in pending]}")
    print(f"Appended {len(lineage_events)} LINEAGE events.")
    print(f"counts: {doc['counts']}")


if __name__ == "__main__":
    main()
