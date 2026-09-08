#!/usr/bin/env python3
"""Toledo v1.8 REGISTRAR merge -- registry/proposals/urcf_rd_all_family.json.

17 founder-instructed objects from URCF_RD_All.v, Module RD (private tower
file, Downloads, not previously deposited or registered) -- the discrete
number ladder D -> Z -> Q -> R and its model-theoretic superstructure
(Peano axioms, term-language semantics transfer, first-order satisfaction,
a Hilbert-style proof system, D |= PA, Con(PA) both constructively and
classically, categoricity, a discrete metric/Tarski geometry, the integer
ring Z, the rational field Q, and the real ordered field R).

Already through an independent adversarial re-verification pass
(ops/urcf_tower/REVERIFICATION_2026-09-08.md) that checked each object
against the LIVE registry, not just the proposal's own prose. Verdicts,
trims, and cross-reference relations below all come from that pass;
see each entry's own drift_note for the verbatim evidence quote.

  PROP-URCF-01 (weld/M.44.v1) -- Peano succ-injectivity for D (RD4).
    partial_overlap: succ<>zero half DUPLICATES RD3/M.01.v1 (closed,
    over nat) -- dropped, not re-registered. succ-injective half is
    genuinely new (root RD4 had zero registered readings). relations[]
    cross-references RD3/M.01.v1 (same_form_different_theory: an
    independent second Coq proof of the sibling axiom over a different
    concrete representation of the same root RD3/RD4 axiom pair).

  PROP-URCF-02..14, 16 (weld/M.45-57.v1, weld/M.59.v1) -- genuinely_new,
    registered in full: D is a commutative semiring; (D,<=) total order +
    cancellation; toNat:D~=nat iso; eval_hom/eqn_transfer; D==nat
    elementary equivalence; Hilbert proof system sound+consistent; D|=PA;
    Con(PA) constructive; PA true in N; second-order categoricity; D is a
    discrete metric space + Tarski betweenness; Z is a commutative ring;
    Q is a commutative field.

  PROP-URCF-10 (weld/M.53.v1) -- Con(PA) classical. genuinely_new but
    explicitly NOT axiom-free: uses Classical_Prop.classic as its sole
    axiom (re-observed independently in this repo's own coqc run, not
    copied from the proposal's claim). coq_status "axioms", tier stays
    Th_coqc (a real machine-checked theorem, not itself a bare axiom --
    distinct from CMC/M.*.v1's tier "Ax" rows, which ARE bare asserted
    obligations). Kept as its own tagged entry, never folded into
    PROP-URCF-09 (the constructive Con(PA), weld/M.52.v1, axiom-free).

  PROP-URCF-15 (weld/M.58.v1) -- discrete Leibniz product rule for
    Z-valued sequences. partial_overlap: the bundled discrete FTC
    (FTC/FTC_Z/FTC_inverse) DUPLICATES A2/M.03.v1 and Z/M.06.v1 (both
    closed) -- dropped, not re-registered. Only the pointwise Leibniz
    rule (logically distinct from Z/M.09.v1's SUMMED consequence) is
    registered. relations[] cross-references A2/M.03.v1 and Z/M.06.v1.

  PROP-URCF-17 (weld/M.60.v1) -- R (Bishop regular Cauchy sequences of Q)
    is a complete ordered field. partial_overlap but kept WHOLE per the
    reverification note's own recommendation (the overlap with
    R/M.33-35.v1 is a thin, structurally-different pointwise-commutativity
    triviality on a different concrete representation of R; the bulk of
    the claim -- order, inverse, completeness, lattice, convergence,
    metric, continuity -- has no existing reading anywhere).  relations[]
    cross-references R/M.33.v1, R/M.34.v1, R/M.35.v1
    (same_form_different_theory).

Same idiom as scripts/v18_spectral_merge.py / v18_urcf_merge.py /
v18_causal_merge.py: re-reads registry/CANONICAL.json immediately before
the one atomic write, is idempotent (a second run is a no-op once the
codes/aliases exist), verifies every parent/relation target code actually
exists in the LIVE registry before writing an edge, and assigns real
running weld/M.<nn>.v1 numbers (next free after the live max, computed
fresh, not hardcoded from a stale read).

coq_status: closed for all entries except weld/M.53.v1 (axioms, sole
axiom Classical_Prop.classic) -- coqc-verified IN THIS REPO by this
script's author before running this script (coqc 8.20.1,
coq/canonical/_CoqProject `-Q . MRC` convention); every `Print
Assumptions` call independently re-observed, not copied from the source
file's own verbatim output.

Run: python3 scripts/v18_tower_merge.py
"""
import json
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
CANONICAL_PATH = REG / "CANONICAL.json"
GENESIS_PATH = REG / "genesis_root.json"
LINEAGE_PATH = REG / "LINEAGE.jsonl"

DATE = "2026-09-08"
BY = "toledo-v1.8-tower"
SOURCE_SECTION = (
    "URCF_RD_All.v, Module RD, lines ~3155-5634 (private tower file, "
    "Downloads, not previously deposited or registered)"
)

REVERIF_CITE = (
    "registry/proposals/urcf_rd_all_family.json, PROP-URCF-{n:02d}"
    ".reverification_2026-09-08"
)


def entry(
    num, code, name, statement_latex, aliases, parents, relations,
    coq_file, coq_ident_display, identifiers, coq_status, assumptions,
    coq_axioms, drift_note,
):
    return {
        "code": code,
        "root": parents[0]["code"] if len(parents) == 1 else parents[0]["code"],
        "layer": "reading",
        "domain": "M",
        "aliases": aliases,
        "name": name,
        "statement": {"latest": statement_latex, "format": "latex"},
        "statements_history": [
            {
                "v": 1,
                "statement": statement_latex,
                "date": DATE,
                "reason": (
                    f"{BY}: initial capture from {SOURCE_SECTION}, PROP-URCF-{num:02d}. "
                    "See drift_note for the 2026-09-08 reverification verdict/evidence."
                ),
                "by": BY,
            }
        ],
        "parents": parents,
        "children": [],
        "origin": {
            "source": "domain_registry",
            "repo_anchor": None,
            "record_id": None,
            "doi": None,
            "section": SOURCE_SECTION,
        },
        "status": "current",
        "status_note": "",
        "superseded_by": None,
        "tier": "Th_coqc",
        "tier_in_genesis_verbatim": "",
        "coq": {
            "file": coq_file,
            "identifier": coq_ident_display,
            "assumptions": assumptions,
            "imported_from": None,
            "coq_status": coq_status,
            "coq_axioms": coq_axioms,
            "coq_source_redistributed": True,
            "identifiers": identifiers,
        },
        "relations": relations,
        "occurrences": [],
        "role": "other",
        "first_assigned": DATE,
        "drift_note": drift_note,
    }


def ids(fname, names):
    return [{"file": f"coq/canonical/{fname}", "identifier": n} for n in names]


CLOSED = "Closed under the global context"

NEW_ENTRIES = []

# ---------------------------------------------------------------------
# 01 -- weld/M.44.v1 -- Peano succ-injectivity for D (RD4)
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    1, "weld/M.44.v1",
    "Peano successor injectivity for the retained-difference object D (RD4 axiom, first Toledo witness)",
    r"\forall x\, y : D,\ \mathrm{succ}(x) = \mathrm{succ}(y) \Rightarrow x = y",
    ["URCF_RD_All:RD.RD4_succ_inj"],
    [{
        "code": "RD4",
        "derived_via": "restates",
        "evidence": (
            "genesis_root.json root RD4 states the succ-injectivity axiom "
            "verbatim ('RD4 succ is injective'); root RD4 had zero "
            "registered readings before this entry (confirmed by a live "
            "query against CANONICAL.json) -- this is the first Toledo "
            "witness of RD4's own already-declared but never-formalized axiom."
        ),
    }],
    [{
        "type": "same_form_different_theory",
        "target": "RD3/M.01.v1",
        "note": (
            "The proposal's succ<>zero half duplicates RD3/M.01.v1 "
            "('succ_ground_distinct', closed, over Coq's built-in nat) -- "
            "dropped, not re-registered as a second object. This entry's "
            "own registered statement is ONLY the succ-injectivity half "
            "(RD4), an independent second Coq proof of the sibling RD3/RD4 "
            "axiom pair over a different concrete representation (a custom "
            "inductive D vs. built-in nat)."
        ),
    }],
    "coq/canonical/weld__M_44_v1.v", "RD4_succ_inj",
    ids("weld__M_44_v1.v", ["RD4_succ_inj"]),
    "closed", CLOSED, [],
    (
        "Reverification 2026-09-08 verdict: partial_overlap. Verbatim "
        "evidence: \"Original proposal bundled two axioms (RD3_succ_ne_zero, "
        "RD4_succ_inj). RD3_succ_ne_zero is a DUPLICATE: RD3/M.01.v1 already "
        "proves the identical fact `S 0 <> 0` over Coq's built-in nat -- "
        "under the phi-criterion this is the same object as URCF's "
        "`RD3_succ_ne_zero : forall x, succ x <> zero` (renaming D->nat, "
        "succ->S, zero->0). RD4_succ_inj is GENUINELY NEW: root RD4 has "
        "zero registered readings. This proposal is trimmed to keep only "
        "the succ-injectivity content; the succ<>zero half is dropped as a "
        "duplicate of RD3/M.01.v1, not registered again.\" ("
        + REVERIF_CITE.format(n=1) + "). This repo's own recompile confirms "
        "RD4_succ_inj is Closed under the global context, over the custom "
        "inductive D (zero/succ), independent of RD3/M.01.v1's nat-level proof."
    ),
))

# ---------------------------------------------------------------------
# 02 -- weld/M.45.v1 -- D is a commutative semiring
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    2, "weld/M.45.v1",
    "D is a commutative semiring under add/mul/zero/one (first Toledo-local Coq witness of root D's Th 2.2)",
    (
        r"(D,\ \mathrm{add},\ \mathrm{mul},\ \mathrm{zero},\ \mathrm{one}) "
        r"\text{ satisfies: add\_assoc, add\_comm, mul\_comm, mul\_assoc, "
        r"mul\_add, add\_mul, mul\_one, one\_mul}"
    ),
    ["URCF_RD_All:RD.add_assoc", "URCF_RD_All:RD.add_comm",
     "URCF_RD_All:RD.mul_comm", "URCF_RD_All:RD.mul_assoc",
     "URCF_RD_All:RD.mul_add", "URCF_RD_All:RD.add_mul",
     "URCF_RD_All:RD.mul_one", "URCF_RD_All:RD.one_mul"],
    [{
        "code": "D",
        "derived_via": "restates",
        "evidence": (
            "genesis_root.json root row D states verbatim \"D is a "
            "commutative semiring (Th 2.2)\" -- this proof set is the "
            "first Toledo-local Coq witness of that already-declared but "
            "previously-unformalized root claim (root D's own coq field is "
            "null; this repo's coq/information-discrete-math/formal/"
            "IDM_Genesis.v carries only 3 unrelated theorems, none semiring laws)."
        ),
    }],
    [],
    "coq/canonical/weld__M_45_v1.v",
    "add_assoc, add_comm, mul_comm, mul_assoc, mul_add, add_mul, mul_one, one_mul",
    ids("weld__M_45_v1.v", ["add_assoc", "add_comm", "mul_comm", "mul_assoc",
                             "mul_add", "add_mul", "mul_one", "one_mul"]),
    "closed", CLOSED, [],
    (
        "Reverification 2026-09-08 verdict: genuinely_new. Verbatim "
        "evidence: \"Root D's own prose already ASSERTS 'D is a commutative "
        "semiring (Th 2.2)' ... but that root row's own coq field is null "
        "... Checked all 80 D/* readings in CANONICAL.json by name: "
        "pigeonhole/weight/bcube/automorphism/classify-family content, zero "
        "overlap with add_assoc/add_comm/mul_comm/mul_assoc/mul_add/"
        "add_mul/mul_one/one_mul. No existing READING covers this claim, so "
        "per the duplicate-requires-an-existing-reading rule this is "
        "genuinely_new.\" (" + REVERIF_CITE.format(n=2) + ")."
    ),
))

# ---------------------------------------------------------------------
# 03 -- weld/M.46.v1 -- (D,<=) total order + cancellation + strong induction
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    3, "weld/M.46.v1",
    "(D, le) is a total, well-ordered order with additive cancellation and strong induction (first Toledo-local witness of root D's Th 2.3)",
    (
        r"\mathrm{le} \text{ is refl/trans/antisym/total on } D;\ "
        r"\mathrm{add} \text{ is right-cancellative};\ "
        r"\mathrm{lt} \text{ is irrefl/trans/trichotomous and well-founded, "
        r"giving strong induction on } D"
    ),
    ["URCF_RD_All:RD.le_refl", "URCF_RD_All:RD.le_trans",
     "URCF_RD_All:RD.le_antisym", "URCF_RD_All:RD.le_total",
     "URCF_RD_All:RD.add_cancel_r", "URCF_RD_All:RD.lt_irrefl",
     "URCF_RD_All:RD.lt_trans", "URCF_RD_All:RD.lt_trichotomy",
     "URCF_RD_All:RD.lt_wf", "URCF_RD_All:RD.strong_induction"],
    [{
        "code": "D",
        "derived_via": "restates",
        "evidence": (
            "genesis_root.json root row D states verbatim \"(D,≺) is a "
            "total, well-ordered order (Th 2.3)\" -- first Toledo-local "
            "witness of that declared claim."
        ),
    }],
    [],
    "coq/canonical/weld__M_46_v1.v",
    "le_refl, le_trans, le_antisym, le_total, add_cancel_r, lt_irrefl, lt_trans, lt_trichotomy, lt_wf, strong_induction",
    ids("weld__M_46_v1.v", ["le_refl", "le_trans", "le_antisym", "le_total",
                             "add_cancel_r", "lt_irrefl", "lt_trans",
                             "lt_trichotomy", "lt_wf", "strong_induction"]),
    "closed", CLOSED, [],
    (
        "Reverification 2026-09-08 verdict: genuinely_new. Verbatim "
        "evidence: \"Same reasoning as 02 for Th 2.3 -- no reading covers "
        "le_refl/le_total/lt_wf/strong_induction etc.\" ("
        + REVERIF_CITE.format(n=3) + ")."
    ),
))

# ---------------------------------------------------------------------
# 04 -- weld/M.47.v1 -- toNat: D ~= nat isomorphism
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    4, "weld/M.47.v1",
    "toNat is a semiring-and-order isomorphism D ~= nat (first Toledo-local witness of root D's Th 2.4)",
    (
        r"\mathrm{toNat} : D \to \mathbb{N} \text{ is injective and "
        r"preserves add, mul, le}: \mathrm{iso\_to\_of},\ \mathrm{iso\_of\_to},\ "
        r"\mathrm{toNat\_inj},\ \mathrm{toNat\_add},\ \mathrm{toNat\_mul},\ "
        r"\mathrm{le\_toNat},\ \mathrm{toNat\_le}"
    ),
    ["URCF_RD_All:RD.iso_to_of", "URCF_RD_All:RD.iso_of_to",
     "URCF_RD_All:RD.toNat_inj", "URCF_RD_All:RD.toNat_add",
     "URCF_RD_All:RD.toNat_mul", "URCF_RD_All:RD.le_toNat",
     "URCF_RD_All:RD.toNat_le"],
    [{
        "code": "D",
        "derived_via": "restates",
        "evidence": (
            "genesis_root.json root row D states verbatim \"toNat: D → "
            "ℕ is a semiring-and-order isomorphism D ≅ ℕ (Th 2.4)\" "
            "-- first Toledo-local witness of that declared claim."
        ),
    }],
    [],
    "coq/canonical/weld__M_47_v1.v",
    "iso_to_of, iso_of_to, toNat_inj, toNat_add, toNat_mul, le_toNat, toNat_le",
    ids("weld__M_47_v1.v", ["iso_to_of", "iso_of_to", "toNat_inj",
                             "toNat_add", "toNat_mul", "le_toNat", "toNat_le"]),
    "closed", CLOSED, [],
    (
        "Reverification 2026-09-08 verdict: genuinely_new. Verbatim "
        "evidence: \"Root D's prose states 'toNat: D -> N is a "
        "semiring-and-order isomorphism D ≅ N (Th 2.4)' but again no "
        "local Coq witness exists for the isomorphism itself in this repo, "
        "and no D/* reading covers toNat_inj/toNat_add/toNat_mul/iso_to_of/"
        "iso_of_to/le_toNat/toNat_le.\" (" + REVERIF_CITE.format(n=4) + ")."
    ),
))

# ---------------------------------------------------------------------
# 05 -- weld/M.48.v1 -- eval_hom / eqn_transfer
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    5, "weld/M.48.v1",
    "Term-language interpretation homomorphism and equational transfer between D and nat",
    (
        r"\mathrm{eval\_hom}:\ \mathrm{toNat}(\mathrm{evD}(env,t)) = "
        r"\mathrm{evN}(\mathrm{toNat}\circ env,\ t);\quad "
        r"\mathrm{eqn\_transfer}: \text{equations valid on nat under this "
        r"env transfer back to } D"
    ),
    ["URCF_RD_All:RD.eval_hom", "URCF_RD_All:RD.eqn_transfer"],
    [{
        "code": "D",
        "derived_via": "derives",
        "evidence": (
            "Builds on D's Th 2.4 isomorphism (weld/M.47.v1) but states new "
            "content (term-language semantics transfer) not present "
            "anywhere else in Toledo."
        ),
    }],
    [],
    "coq/canonical/weld__M_48_v1.v", "eval_hom, eqn_transfer",
    ids("weld__M_48_v1.v", ["eval_hom", "eqn_transfer"]),
    "closed", CLOSED, [],
    (
        "Reverification 2026-09-08 verdict: genuinely_new. Verbatim "
        "evidence: \"Whole-registry keyword search for 'homomorphism'/"
        "'term-language' found nothing relevant.\" ("
        + REVERIF_CITE.format(n=5) + ")."
    ),
))

# ---------------------------------------------------------------------
# 06 -- weld/M.49.v1 -- D == nat (elementary equivalence)
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    6, "weld/M.49.v1",
    "Full first-order satisfaction transfer; D and nat are elementarily equivalent",
    (
        r"\forall f\ (\text{first-order formula}),\ envD,\ envN:\ "
        r"(\forall v,\ \mathrm{toNat}(envD\,v)=envN\,v) \Rightarrow "
        r"(\mathrm{satD}(envD,f) \Leftrightarrow \mathrm{satN}(envN,f));\quad "
        r"\mathrm{sentence\_transfer}: D \equiv \mathrm{nat}"
    ),
    ["URCF_RD_All:RD.sat_transfer", "URCF_RD_All:RD.sentence_transfer",
     "URCF_RD_All:RD.satD_ext", "URCF_RD_All:RD.evN_ext",
     "URCF_RD_All:RD.evD_evN"],
    [{
        "code": "D",
        "derived_via": "derives",
        "evidence": (
            "Full first-order-satisfaction/elementary-equivalence transfer "
            "for D and nat is not stated anywhere in genesis_root.json's D "
            "row or elsewhere in CANONICAL.json -- new model-theoretic "
            "property built on root D."
        ),
    }],
    [],
    "coq/canonical/weld__M_49_v1.v", "sat_transfer, sentence_transfer",
    ids("weld__M_49_v1.v", ["sat_transfer", "sentence_transfer"]),
    "closed", CLOSED, [],
    (
        "Reverification 2026-09-08 verdict: genuinely_new. Verbatim "
        "evidence: \"Searched CANONICAL.json for 'elementarily equivalent', "
        "'first-order', 'model-theoretic' restricted to any D/IDM/RD "
        "material -- zero matches.\" (" + REVERIF_CITE.format(n=6) + ")."
    ),
))

# ---------------------------------------------------------------------
# 07 -- weld/M.50.v1 -- Hilbert-style proof system, sound + consistent
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    7, "weld/M.50.v1",
    "A Hilbert-style proof system over D, sound and consistent",
    (
        r"\text{a substitution lemma (satD\_subst) supports a Hilbert-style "
        r"derivability relation Prov over } D,\ \text{sound (soundness) and "
        r"consistent via a model-existence argument (consistency, prov\_sound\_N)}"
    ),
    ["URCF_RD_All:RD.satD_subst", "URCF_RD_All:RD.Prov",
     "URCF_RD_All:RD.soundness", "URCF_RD_All:RD.consistency",
     "URCF_RD_All:RD.prov_sound_N"],
    [{
        "code": "D",
        "derived_via": "derives",
        "evidence": (
            "No Hilbert-style proof system, soundness theorem, or "
            "consistency result for D appears anywhere in CANONICAL.json or "
            "genesis_root.json -- new proof-theoretic content built on root D."
        ),
    }],
    [],
    "coq/canonical/weld__M_50_v1.v",
    "satD_subst, soundness, consistency, prov_sound_N",
    ids("weld__M_50_v1.v", ["satD_subst", "soundness", "consistency", "prov_sound_N"]),
    "closed", CLOSED, [],
    (
        "Reverification 2026-09-08 verdict: genuinely_new. Verbatim "
        "evidence: \"Searched CANONICAL.json for 'Hilbert', 'soundness', "
        "'proof system' restricted to math/D material -- zero matches.\" "
        "(" + REVERIF_CITE.format(n=7) + ")."
    ),
))

# ---------------------------------------------------------------------
# 08 -- weld/M.51.v1 -- D |= PA
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    8, "weld/M.51.v1",
    "D is a model of first-order Peano Arithmetic",
    (
        r"D \text{ validates every first-order induction instance "
        r"(D\_validates\_induction), hence } D \models \mathrm{PA} "
        r"\text{ (D\_models\_PA)}"
    ),
    ["URCF_RD_All:RD.D_validates_induction", "URCF_RD_All:RD.D_models_PA",
     "URCF_RD_All:RD.PA_closed", "URCF_RD_All:RD.IndAx", "URCF_RD_All:RD.PA"],
    [{
        "code": "D",
        "derived_via": "derives",
        "evidence": (
            "genesis_root.json code D states D's algebraic/order structure "
            "but no existing Toledo row asserts the model-theoretic fact "
            "D |= PA -- a new named result built on the already-registered "
            "D object."
        ),
    }],
    [],
    "coq/canonical/weld__M_51_v1.v",
    "D_validates_induction, D_models_PA",
    ids("weld__M_51_v1.v", ["D_validates_induction", "D_models_PA"]),
    "closed", CLOSED, [],
    (
        "Reverification 2026-09-08 verdict: genuinely_new. Verbatim "
        "evidence: \"Searched CANONICAL.json for 'Peano Arithmetic', 'model "
        "of' restricted to math/D material -- zero matches (the two 'model "
        "of' hits found elsewhere are an unrelated ODE-model and a "
        "kinetic-isotope-effect entry).\" (" + REVERIF_CITE.format(n=8) + ")."
    ),
))

# ---------------------------------------------------------------------
# 09 -- weld/M.52.v1 -- Con(PA), constructive
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    9, "weld/M.52.v1",
    "Constructive consistency of PA, witnessed by the D model",
    r"\mathrm{Con}(\mathrm{PA}) \text{ holds constructively (no excluded middle used), witnessed by } D\_models\_PA",
    ["URCF_RD_All:RD.Con_PA"],
    [{
        "code": "D",
        "derived_via": "derives",
        "evidence": (
            "No Toledo object states constructive Con(PA); it chains to "
            "root D via the D_models_PA result (weld/M.51.v1) rather than "
            "any pre-existing consistency row."
        ),
    }],
    [],
    "coq/canonical/weld__M_52_v1.v", "Con_PA",
    ids("weld__M_52_v1.v", ["Con_PA"]),
    "closed", CLOSED, [],
    (
        "Reverification 2026-09-08 verdict: genuinely_new. Verbatim "
        "evidence: \"Searched CANONICAL.json for 'Con(PA)', 'consistency of "
        "PA' -- zero matches. Confirmed genuinely_new; source line 3768 "
        "`Theorem Con_PA : ~ Prov PA Fbot.` uses no Classical_Prop axiom "
        "(checked surrounding proof, purely constructive).\" ("
        + REVERIF_CITE.format(n=9) + "). This repo's own recompile confirms "
        "Con_PA is Closed under the global context -- no classical axiom, "
        "distinct from weld/M.53.v1's classical sibling."
    ),
))

# ---------------------------------------------------------------------
# 10 -- weld/M.53.v1 -- Con(PA), classical (Classical_Prop.classic)
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    10, "weld/M.53.v1",
    "Classical consistency of PA (excluded-middle dependent, Classical_Prop.classic)",
    (
        r"\text{a classical derivability relation ProvC over PA is sound "
        r"(soundnessC) and consistent (consistencyC, Con\_PA\_classical), "
        r"with } \mathtt{Classical\_Prop.classic} \text{ as the sole axiom used}"
    ),
    ["URCF_RD_All:RD.ProvC", "URCF_RD_All:RD.soundnessC",
     "URCF_RD_All:RD.consistencyC", "URCF_RD_All:RD.Con_PA_classical"],
    [{
        "code": "D",
        "derived_via": "derives",
        "evidence": (
            "No Toledo object states classical Con(PA); same lineage as "
            "constructive Con_PA (weld/M.52.v1) but explicitly non-axiom-"
            "free (sole axiom Classical_Prop.classic), so registered as its "
            "own tagged entry rather than folded into the axiom-free sibling."
        ),
    }],
    [],
    "coq/canonical/weld__M_53_v1.v", "Con_PA_classical",
    ids("weld__M_53_v1.v", ["Con_PA_classical"]),
    "axioms", "+axioms: classic : forall P : Prop, P \\/ ~ P",
    ["classic : forall P : Prop, P \\/ ~ P"],
    (
        "Reverification 2026-09-08 verdict: genuinely_new. Verbatim "
        "evidence: \"Searched CANONICAL.json for classical-PA-consistency "
        "content -- zero matches. Confirmed genuinely_new, and confirmed "
        "via source (lines 5444-5503, module tags ProvC/soundnessC/"
        "consistencyC/Con_PA_classical) that this branch is NOT axiom-free "
        "-- it is a separate proof path from the constructive Con_PA "
        "(weld/M.52.v1) and must not be folded into it or presented as "
        "axiom-free.\" (" + REVERIF_CITE.format(n=10) + "). This repo's own "
        "recompile of coq/canonical/weld__M_53_v1.v independently confirms: "
        "`Print Assumptions Con_PA_classical.` reports exactly one axiom, "
        "`classic : forall P : Prop, P \\/ ~ P` -- never presented as "
        "axiom-free, kept a distinct entry from weld/M.52.v1 (constructive, closed)."
    ),
))

# ---------------------------------------------------------------------
# 11 -- weld/M.54.v1 -- PA true in the standard model nat
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    11, "weld/M.54.v1",
    "PA is true in the standard model nat",
    r"\mathrm{PA\_true\_in\_N}:\ \mathrm{PA}(a) \Rightarrow \mathrm{satN}(env0N,\ a), \text{ transported via toNat (Th 2.4) and D\_models\_PA}",
    ["URCF_RD_All:RD.PA_true_in_N"],
    [{
        "code": "D",
        "derived_via": "derives",
        "evidence": (
            "No matching Toledo row; genesis_root's D entry already states "
            "toNat: D -> N is a semiring-and-order isomorphism (Th 2.4), "
            "and this result rides that isomorphism (weld/M.47.v1) and "
            "D_models_PA (weld/M.51.v1) to transport PA-truth."
        ),
    }],
    [],
    "coq/canonical/weld__M_54_v1.v", "PA_true_in_N",
    ids("weld__M_54_v1.v", ["PA_true_in_N"]),
    "closed", CLOSED, [],
    (
        "Reverification 2026-09-08 verdict: genuinely_new. Verbatim "
        "evidence: \"No matching Toledo row for 'PA_true_in_N' or "
        "PA-truth transport. Confirmed genuinely_new; depends on "
        "PROP-URCF-04 (toNat iso) and PROP-URCF-08 (D_models_PA), both "
        "themselves confirmed genuinely_new above.\" ("
        + REVERIF_CITE.format(n=11) + ")."
    ),
))

# ---------------------------------------------------------------------
# 12 -- weld/M.55.v1 -- second-order categoricity of D (Dedekind)
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    12, "weld/M.55.v1",
    "Second-order categoricity of D (Dedekind's theorem)",
    (
        r"\text{any second-order structure } (M,z_M,s_M) \text{ satisfying "
        r"D's axioms is uniquely isomorphic to } D \text{ via the canonical "
        r"embedding } \mathrm{emb}"
    ),
    ["URCF_RD_All:RD.categoricity", "URCF_RD_All:RD.emb",
     "URCF_RD_All:RD.emb_surj", "URCF_RD_All:RD.emb_inj"],
    [{
        "code": "D",
        "derived_via": "derives",
        "evidence": (
            "No existing Toledo/Genesis row -- the D root row states D's "
            "semiring/order/isomorphism facts (Th 2.2-2.4) but not "
            "categoricity of any second-order axiomatization of D."
        ),
    }],
    [],
    "coq/canonical/weld__M_55_v1.v", "categoricity",
    ids("weld__M_55_v1.v", ["categoricity"]),
    "closed", CLOSED, [],
    (
        "Reverification 2026-09-08 verdict: genuinely_new. Verbatim "
        "evidence: \"Searched CANONICAL.json for 'categoricity', "
        "'Dedekind' -- zero matches.\" (" + REVERIF_CITE.format(n=12) + ")."
    ),
))

# ---------------------------------------------------------------------
# 13 -- weld/M.56.v1 -- D discrete metric space + Tarski betweenness
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    13, "weld/M.56.v1",
    "D (and D*D) is a discrete metric space with Tarski-style betweenness",
    (
        r"\mathrm{dist}(x,y) := |\mathrm{toNat}(x)-\mathrm{toNat}(y)| "
        r"\text{ satisfies the metric axioms; the L1 product metric dist2 "
        r"on } D{\times}D \text{ inherits them; Tarski-style Betw satisfies "
        r"identity, symmetry, reflexivity}"
    ),
    ["URCF_RD_All:RD.dist", "URCF_RD_All:RD.dist_self", "URCF_RD_All:RD.dist_eq0",
     "URCF_RD_All:RD.dist_pos", "URCF_RD_All:RD.dist_sym", "URCF_RD_All:RD.dist_tri",
     "URCF_RD_All:RD.Betw", "URCF_RD_All:RD.Betw_id", "URCF_RD_All:RD.Betw_sym",
     "URCF_RD_All:RD.Betw_refl_l", "URCF_RD_All:RD.dist2"],
    [{
        "code": "D",
        "derived_via": "derives",
        "evidence": (
            "No Toledo/Genesis row classifies D (or D*D) as a metric space "
            "or states Tarski-style betweenness on it; the existing D root "
            "row covers only the semiring/well-order structure."
        ),
    }],
    [],
    "coq/canonical/weld__M_56_v1.v",
    "dist_self, dist_eq0, dist_pos, dist_sym, dist_tri, Betw_id, Betw_sym, Betw_refl_l, dist2_self, dist2_eq0, dist2_sym, dist2_tri",
    ids("weld__M_56_v1.v", ["dist_self", "dist_eq0", "dist_pos", "dist_sym",
                             "dist_tri", "Betw_id", "Betw_sym", "Betw_refl_l",
                             "dist2_self", "dist2_eq0", "dist2_sym", "dist2_tri"]),
    "closed", CLOSED, [],
    (
        "Reverification 2026-09-08 verdict: genuinely_new. Verbatim "
        "evidence: \"Searched CANONICAL.json for 'metric space', 'Tarski', "
        "'betweenness' -- zero matches.\" (" + REVERIF_CITE.format(n=13) + ")."
    ),
))

# ---------------------------------------------------------------------
# 14 -- weld/M.57.v1 -- Z is a commutative ring
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    14, "weld/M.57.v1",
    "Z (Grothendieck completion of D) is a commutative ring isomorphic to standard Z (first Toledo-local witness of root Z's Th 3.1)",
    (
        r"Z_r := (D \times D)/\sim,\ (\mathrm{zadd},\mathrm{zneg},\mathrm{zmul}) "
        r"\text{ satisfy the commutative-ring axioms up to zeq, congruent "
        r"w.r.t. zeq, and zval: } Z_r \to \mathbb{Z} \text{ is a ring homomorphism}"
    ),
    ["URCF_RD_All:RD.zeq_zval", "URCF_RD_All:RD.zval_add", "URCF_RD_All:RD.zval_neg",
     "URCF_RD_All:RD.zval_mul", "URCF_RD_All:RD.zeq_refl", "URCF_RD_All:RD.zeq_sym",
     "URCF_RD_All:RD.zeq_trans", "URCF_RD_All:RD.zadd_cong", "URCF_RD_All:RD.zneg_cong",
     "URCF_RD_All:RD.zmul_cong", "URCF_RD_All:RD.zadd_comm", "URCF_RD_All:RD.zadd_assoc",
     "URCF_RD_All:RD.zadd_0_l", "URCF_RD_All:RD.zadd_neg", "URCF_RD_All:RD.zmul_comm",
     "URCF_RD_All:RD.zmul_assoc", "URCF_RD_All:RD.zmul_1_l", "URCF_RD_All:RD.zmul_distrib_l"],
    [{
        "code": "Z",
        "derived_via": "restates",
        "evidence": (
            "genesis_root.json root Z (\"the integers Z, Grothendieck "
            "completion of D\") already states verbatim \"Th 3.1: (Z,+,*,0,1) "
            "is a commutative ring\" -- first Toledo-local witness of that "
            "declared claim, under the phi-criterion the same object "
            "(renaming zadd/zmul/zeq for +/*/=)."
        ),
    }],
    [],
    "coq/canonical/weld__M_57_v1.v",
    "zeq_zval, zval_add, zval_neg, zval_mul, zeq_refl, zeq_sym, zeq_trans, zadd_cong, zneg_cong, zmul_cong, zadd_comm, zadd_assoc, zadd_0_l, zadd_neg, zmul_comm, zmul_assoc, zmul_1_l, zmul_distrib_l",
    ids("weld__M_57_v1.v", ["zeq_zval", "zval_add", "zval_neg", "zval_mul",
                             "zeq_refl", "zeq_sym", "zeq_trans", "zadd_cong",
                             "zneg_cong", "zmul_cong", "zadd_comm", "zadd_assoc",
                             "zadd_0_l", "zadd_neg", "zmul_comm", "zmul_assoc",
                             "zmul_1_l", "zmul_distrib_l"]),
    "closed", CLOSED, [],
    (
        "Reverification 2026-09-08 verdict: genuinely_new. Verbatim "
        "evidence: \"Root Z's prose already asserts '(Z,+,*,0,1) is a "
        "commutative ring' (Th 3.1) but root Z's own coq field is null and "
        "none of the 23 Z/* readings construct Z as the Grothendieck "
        "completion (D*D)/~ or prove the full ring-axiom package on that "
        "construction: the existing readings are about delta_sum/"
        "telescoping (Z/M.01-09), a distributivity fact stated over Coq's "
        "BUILT-IN Z (Z/M.11 -- different type, narrower scope), and a "
        "tropical (min-plus) semiring family (Z/M.12-23) which is a "
        "DIFFERENT algebraic structure entirely.\" ("
        + REVERIF_CITE.format(n=14) + ")."
    ),
))

# ---------------------------------------------------------------------
# 15 -- weld/M.58.v1 -- discrete Leibniz product rule (FTC half trimmed)
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    15, "weld/M.58.v1",
    "Discrete Leibniz product rule for Z-valued sequences (FTC/FTC_Z/FTC_inverse half trimmed as duplicate)",
    (
        r"\Delta(f \cdot g)(n) = f(n{+}1)\cdot\Delta g(n) + \Delta f(n)\cdot g(n),\ "
        r"\text{exact, no remainder term, for } f,g : D \to Z_r"
    ),
    ["URCF_RD_All:RD.Leibniz"],
    [{
        "code": "A2",
        "derived_via": "derives",
        "evidence": (
            "A2 already carries the telescoping/FTCC identity (A2/M.03.v1) "
            "as a Th_coqc reading; the pointwise discrete Leibniz/"
            "product-rule identity for the same difference operator is new "
            "content built on that engine, not itself registered anywhere."
        ),
    }],
    [
        {
            "type": "reads",
            "target": "A2/M.03.v1",
            "note": (
                "A2/M.03.v1 ('ftcc_Z', closed) proves the discrete FTC "
                "telescoping identity (`fold Z.add 0 (zdelta f) N = f N - f "
                "0`); this proposal's own bundled FTC/FTC_Z/FTC_inverse "
                "content is a DUPLICATE of that identity (renaming "
                "Sum/Delta for Agg/zdelta) and is dropped from this entry's "
                "own registered statement -- kept only as internal support "
                "the Leibniz theorem is built on."
            ),
        },
        {
            "type": "reads",
            "target": "Z/M.06.v1",
            "note": (
                "Z/M.06.v1 ('FTCC_telescope', closed) proves the same "
                "telescoping identity (`Agg f N == f N - f 0`) over this "
                "repo's own Z-rooted telescoping engine -- also duplicated "
                "by the dropped FTC/FTC_Z/FTC_inverse half, not "
                "re-registered."
            ),
        },
    ],
    "coq/canonical/weld__M_58_v1.v", "Leibniz",
    ids("weld__M_58_v1.v", ["Leibniz"]),
    "closed", CLOSED, [],
    (
        "Reverification 2026-09-08 verdict: partial_overlap. Verbatim "
        "evidence: \"Original proposal bundled the discrete FTC (FTC, "
        "FTC_Z, FTC_inverse) with the discrete Leibniz product rule. The "
        "FTC part is a DUPLICATE: A2/M.03.v1 ('ftcc_Z', closed) proves "
        "`fold Z.add 0 (zdelta f) N = f N - f 0` and Z/M.06.v1 "
        "('FTCC_telescope', closed) proves `Agg f N == f N - f 0` -- both "
        "are the identical telescoping-sum-recovers-endpoint-difference "
        "identity URCF states as FTC/FTC_Z/FTC_inverse. The Leibniz part "
        "is GENUINELY NEW: it is a pointwise per-step identity, logically "
        "distinct from Z/M.09.v1 ('summation_by_parts', closed), which is "
        "the SUMMED/telescoped consequence over a whole range [0,N] -- no "
        "reading states the pointwise rule directly. This proposal is "
        "trimmed to keep only the Leibniz content; the FTC content is "
        "dropped as a duplicate of A2/M.03.v1 and Z/M.06.v1.\" ("
        + REVERIF_CITE.format(n=15) + "). This repo's own coq/canonical/"
        "weld__M_58_v1.v file physically OMITS Sum/FTC_Z/FTC/FTC_inverse "
        "(only Delta, zval_Delta and the Leibniz theorem itself are "
        "present) -- the trim is structural, not just a registry-level "
        "omission."
    ),
))

# ---------------------------------------------------------------------
# 16 -- weld/M.59.v1 -- Q is a commutative field
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    16, "weld/M.59.v1",
    "Q (field of fractions of Z) is a commutative field isomorphic to standard Q (first Toledo-local witness of root Q's Th 3.4)",
    (
        r"Q_f := (\mathbb{Z}\times\mathbb{Z}_{\neq0})/\sim,\ "
        r"(\mathrm{qadd},\mathrm{qmul}) \text{ satisfy the field axioms up "
        r"to qeq including the multiplicative inverse qmul\_inv, congruent "
        r"w.r.t. qeq, qval: } Q_f \to \mathbb{Q} \text{ a field homomorphism}"
    ),
    ["URCF_RD_All:RD.qeq_refl", "URCF_RD_All:RD.qeq_sym", "URCF_RD_All:RD.qeq_trans",
     "URCF_RD_All:RD.qadd_comm", "URCF_RD_All:RD.qadd_assoc", "URCF_RD_All:RD.qadd_0_l",
     "URCF_RD_All:RD.qadd_neg", "URCF_RD_All:RD.qmul_comm", "URCF_RD_All:RD.qmul_assoc",
     "URCF_RD_All:RD.qmul_1_l", "URCF_RD_All:RD.qmul_distrib_l", "URCF_RD_All:RD.qmul_inv"],
    [{
        "code": "Q",
        "derived_via": "restates",
        "evidence": (
            "genesis_root.json root Q (\"the rationals Q, field of "
            "fractions of Z\") already states verbatim \"Def 3.3: Q := "
            "(Z×Z_{≠0})/∼ ... Th 3.4: (Q,+,·) is a field: "
            "qadd_neg, qmul_assoc, qmul_distrib_l, and the multiplicative "
            "inverse qmul_inv\" -- same construction, same identifier name "
            "qmul_inv, first Toledo-local witness of that declared claim."
        ),
    }],
    [],
    "coq/canonical/weld__M_59_v1.v",
    "qeq_refl, qeq_sym, qeq_trans, qadd_comm, qadd_assoc, qadd_0_l, qadd_neg, qmul_comm, qmul_assoc, qmul_1_l, qmul_distrib_l, qmul_inv",
    ids("weld__M_59_v1.v", ["qeq_refl", "qeq_sym", "qeq_trans", "qadd_comm",
                             "qadd_assoc", "qadd_0_l", "qadd_neg", "qmul_comm",
                             "qmul_assoc", "qmul_1_l", "qmul_distrib_l", "qmul_inv"]),
    "closed", CLOSED, [],
    (
        "Reverification 2026-09-08 verdict: genuinely_new. Verbatim "
        "evidence: \"Root Q's prose already asserts '(Q,+,*) is a field' "
        "(Th 3.4) with 'the multiplicative inverse qmul_inv' by the SAME "
        "identifier name -- but root Q's own coq field is null, and none "
        "of the 19 Q/* readings construct Q as (Z*Z_{!=0})/~ or prove "
        "field axioms: the existing readings are about matrix trace/twirl/"
        "transpose operations (Q/M.08-19) and Sum lemmas (Q/M.02-07), a "
        "completely different subject matter.\" ("
        + REVERIF_CITE.format(n=16) + ")."
    ),
))

# ---------------------------------------------------------------------
# 17 -- weld/M.60.v1 -- R is a complete ordered field
# ---------------------------------------------------------------------
NEW_ENTRIES.append(entry(
    17, "weld/M.60.v1",
    "R (Bishop regular Cauchy sequences of Q) is a complete constructive ordered field -- top rung of the discrete-root number ladder D -> Z -> Q -> R",
    (
        r"R := \{f : \mathbb{Z}^+ \to \mathbb{Q} \mid |f(n)-f(m)| \le "
        r"\tfrac1n+\tfrac1m\}/\mathrm{Req};\ R \text{ is an ordered field up "
        r"to Req (Radd/Rle/Rlt/Rmul, order and ring laws), Cauchy-complete "
        r"(R\_complete, R\_complete\_metric) with a constructive lattice "
        r"(Rmax/Rmin), convergence (Rconv), inverses (Rinv/Rinv\_gen), a "
        r"metric (Rdist), and basic } \epsilon\text{-}\delta \text{ "
        r"continuity (Rcontinuous\_at)}"
    ),
    ["URCF_RD_All:RD.RR", "URCF_RD_All:RD.Req", "URCF_RD_All:RD.inj_Q",
     "URCF_RD_All:RD.Radd", "URCF_RD_All:RD.Rle", "URCF_RD_All:RD.Rlt",
     "URCF_RD_All:RD.Rmul", "URCF_RD_All:RD.R_complete",
     "URCF_RD_All:RD.R_complete_metric", "URCF_RD_All:RD.Rinv",
     "URCF_RD_All:RD.Rinv_gen", "URCF_RD_All:RD.Rmax", "URCF_RD_All:RD.Rmin",
     "URCF_RD_All:RD.Rconv", "URCF_RD_All:RD.Rdist",
     "URCF_RD_All:RD.Rcontinuous_at"],
    [{
        "code": "R",
        "derived_via": "restates",
        "evidence": (
            "genesis_root.json root R (\"the reals R, the continuum as a "
            "readout\") already states verbatim \"Def 3.4: R := Bishop "
            "regular Cauchy sequences of Q ... Th 3.5 (ordered field up to "
            "Req). Th 3.6 (Cauchy-completeness, R_complete)\" -- the same "
            "object names; a thin partial pre-existing witness exists "
            "(R/M.33-37, a different pointwise/gap representation, see "
            "relations[] below) but the bulk of this claim (completeness, "
            "order, inverse, metric, convergence, continuity) has no "
            "existing Toledo reading."
        ),
    }],
    [
        {
            "type": "same_form_different_theory",
            "target": "R/M.33.v1",
            "note": (
                "R/M.33.v1 ('radd_at', closed) gives a thin, "
                "structurally-different partial witness of R using a "
                "different concrete representation (pointwise sequences "
                "g,h:nat->Q with a generic 'gap' modulus function, only the "
                "pointwise add definition) -- narrower than this entry's "
                "Bishop-regular-Cauchy-sequence construction (explicit "
                "1/n+1/m modulus, Req equivalence, inj_Q injection). Kept "
                "whole per the reverification note's own recommendation "
                "rather than trimmed, since the overlap is a near-trivial "
                "fraction of the object."
            ),
        },
        {
            "type": "same_form_different_theory",
            "target": "R/M.34.v1",
            "note": (
                "R/M.34.v1 ('rmul_at', closed) is the pointwise/gap "
                "representation's mul-definition counterpart to R/M.33.v1 "
                "above -- same thin-overlap disposition, not this entry's "
                "own Rmul (canonical-bound + scaled-sampling construction, "
                "a materially different and much stronger development "
                "including commutativity, associativity, distributivity, "
                "well-definedness, and the multiplicative inverse)."
            ),
        },
        {
            "type": "same_form_different_theory",
            "target": "R/M.35.v1",
            "note": (
                "R/M.35.v1 ('radd_comm', closed) proves add-commutativity "
                "on the pointwise/gap representation -- the one piece the "
                "reverification note flags as an arguable trivial-fact "
                "overlap with this entry's own Radd_comm (Bishop-regular "
                "representation); kept as a disclosed cross-reference "
                "rather than a trim, since the two are different concrete "
                "representations of R and the overlap is a near-trivial "
                "commutativity fact."
            ),
        },
    ],
    "coq/canonical/weld__M_60_v1.v",
    "Req_refl, Req_sym, Req_trans, Radd_comm, Radd_0_l, Radd_opp, Rle_refl, Rle_trans, Rle_antisym, Rmul_comm, Rmul_1_l, Rmul_distrib_l, Rmul_assoc, R_complete, R_complete_metric, Rmul_inv, Rmul_inv_gen, Rlt_trans, Rlt_cotrans, Rmax_lub, Rmin_glb, Rconv_const, Rlimit_unique, Rconv_recip, Rdist_triangle, Rcontinuous_Rabs",
    ids("weld__M_60_v1.v",
        ["Req_refl", "Req_sym", "Req_trans", "Radd_comm", "Radd_0_l", "Radd_opp",
         "Rle_refl", "Rle_trans", "Rle_antisym", "inj_Q_le", "Radd_le_mono_r",
         "Rlt_irrefl", "Rmul_comm", "Rmul_1_l", "Rmul_wd", "Rmul_distrib_l",
         "Rmul_assoc", "R_complete", "R_complete_metric", "Rmul_inv",
         "Rmul_inv_gen", "Rlt_le_weak", "Rlt_trans", "Rlt_cotrans",
         "Rle_max_l", "Rle_max_r", "Rmax_lub", "Rmin_le_l", "Rmin_le_r",
         "Rmin_glb", "Rconv_const", "Rlimit_unique", "Rconv_recip",
         "Rcomplete_conv", "Rdist_self", "Rdist_sym", "Rdist_nonneg",
         "Rdist_triangle", "Rabs_Lipschitz", "Ropp_isometry",
         "Radd_Lipschitz", "Rcontinuous_id", "Rcontinuous_Rabs"]),
    "closed", CLOSED, [],
    (
        "Reverification 2026-09-08 verdict: partial_overlap, kept WHOLE "
        "(not trimmed). Verbatim evidence: \"Root R's prose already "
        "asserts the ordered-field + Cauchy-completeness claim (Th 3.5/3.6) "
        "verbatim. Checked all 40 R/* readings: R/M.33.v1 (radd_at), "
        "R/M.34.v1 (rmul_at), R/M.35.v1 (radd_comm), R/M.36.v1 "
        "(const_gap_zero) and R/M.37.v1 (gap_subadditive) ... DO give a "
        "thin pre-existing partial witness for a DIFFERENT representation "
        "of R: pointwise sequences g,h:nat->Q with a generic 'gap' modulus "
        "function, only proving pointwise add/mul definitions and "
        "commutativity of add plus subadditivity of the gap function -- "
        "narrower and structurally different from URCF's "
        "Bishop-regular-Cauchy-sequence construction ... The remaining, "
        "overwhelming majority of URCF's claim -- the FULL order (Rle/Rlt, "
        "antisymmetry, cotransitivity), the multiplicative inverse "
        "(Rinv/Rinv_gen), Cauchy-completeness (R_complete, "
        "R_complete_metric), the lattice (Rmax/Rmin), convergence (Rconv, "
        "uniqueness of limits), the metric (Rdist, triangle inequality, "
        "Lipschitz properties) and basic continuity (Rcontinuous_at) -- "
        "has NO existing reading anywhere in CANONICAL.json. Kept as "
        "partial_overlap rather than trimmed, since the overlapping piece "
        "(a near-trivial pointwise-add-commutativity fact on a "
        "structurally different representation) is a small fraction of "
        "the object.\" (" + REVERIF_CITE.format(n=17) + "). This repo's own "
        "recompile of coq/canonical/weld__M_60_v1.v (the full R "
        "construction through Rcontinuous_Rabs, excluding the unrelated "
        "classical-PA layer that follows it in the source file) confirms "
        "every listed identifier Closed under the global context."
    ),
))


def recompute_counts(entries):
    return {
        "entries": len(entries),
        "by_status": dict(Counter(e["status"] for e in entries)),
        "by_domain": dict(Counter(e["domain"] for e in entries if e.get("domain"))),
        "by_tier": dict(Counter(e["tier"] for e in entries)),
        "by_coq_status": dict(Counter(e["coq"]["coq_status"] for e in entries)),
        "computed": f"{DATE} from canonical[] (scripts/v18_tower_merge.py)",
    }


def main():
    doc = json.loads(CANONICAL_PATH.read_text(encoding="utf-8"))
    entries = doc["canonical"]
    by_code = {e["code"]: e for e in entries}

    pending = [e for e in NEW_ENTRIES if e["code"] not in by_code]
    if not pending:
        print("All 17 tower entries already exist -- idempotent no-op.")
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

    genesis_doc = json.loads(GENESIS_PATH.read_text(encoding="utf-8"))
    genesis_codes = {r["code"] for r in genesis_doc["root_equations"]}
    pending_codes = {e["code"] for e in pending}
    for e in pending:
        for p in e["parents"]:
            if p["code"] not in by_code and p["code"] not in genesis_codes:
                raise SystemExit(
                    f"{e['code']}: parent {p['code']!r} not found in live "
                    "CANONICAL.json or genesis_root.json -- abort."
                )
        for r in e.get("relations", []):
            if r["target"] not in by_code and r["target"] not in pending_codes:
                raise SystemExit(
                    f"{e['code']}: relation target {r['target']!r} not found "
                    "in live CANONICAL.json -- abort."
                )
        if not (ROOT / e["coq"]["file"]).exists():
            raise SystemExit(
                f"{e['code']}: coq file {e['coq']['file']} does not exist on "
                "disk -- write it before running this merge script, abort."
            )

    # Assign real running weld/M.<nn>.v1 codes -- re-derive live and assert
    # the hardcoded NEW_ENTRIES codes are still the next-free numbers.
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
        entry_copy = dict(e)
        max_id += 1
        entry_copy["id"] = f"CAN-{max_id}"
        entries.append(entry_copy)

        lineage_events.append({
            "code": entry_copy["code"],
            "date": DATE,
            "event": "assigned",
            "from": None,
            "to": (
                f"new entry, tier={entry_copy['tier']}, "
                f"coq_status={entry_copy['coq']['coq_status']}, "
                f"parents={','.join(p['code'] for p in entry_copy['parents'])}"
            ),
            "reason": (
                "Toledo v1.8 (URCF_RD_All.v tower family merge, "
                "registry/proposals/urcf_rd_all_family.json, after "
                "independent adversarial re-verification "
                "ops/urcf_tower/REVERIFICATION_2026-09-08.md): "
                f"{entry_copy['name']}. See drift_note for the disclosed "
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
