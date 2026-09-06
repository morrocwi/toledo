#!/usr/bin/env python3
"""N4 Coq splitter -- for every CANONICAL.json entry with status "split" (the
30 bundles produced by scripts/n4_merge.py's STEP 1 SPLIT, per
registry/split_proposal_SW.json), move each member's own Coq apparatus out of
the bundle's single coq/canonical/<code>.v file into that member's own child
file coq/canonical/<child code>.v, leaving the bundle file as a thin
re-export (`From MRC Require Export <child>.` for every child actually
carved out of it) so every existing `Require` of the bundle module keeps
resolving.

Readout-not-truth discipline: every child->content mapping below is decided
by quoting the child's own `source_occurrences` (from
registry/split_proposal_SW.json) against a specific named Definition/Record/
Theorem/Variable already present in the bundle's own .v file (an equation
number in a header comment, e.g. "eq.(5)", or a comment naming the same
concept, e.g. "Axiom I: Reality-as-Record"). A child whose occurrence has NO
matching Coq construct in the source gets no file (coq_status stays
"not_yet_formalised", already set by n4_merge.py) -- nothing is fabricated.

Two disclosed conventions, applied only where the source itself is jointly
indivisible:
  (a) "primary carrier": three bundles (weld/S.02.v1 CE-04 witness;
      EQ-015/S.04.v1's 17-item Inductive; EQ-015/S.11.v1's 7-item Inductive;
      A.5/W.03.v1's 9-item generic-shape theorem) formalise SEVERAL sibling
      members' non-collapse claim(s) in ONE inseparable Coq construct (one
      Inductive+injectivity proof, or one universally-quantified theorem).
      The construct is given to the FIRST such sibling's child file; every
      other sibling gets a `relations: [{"type":"reads","target":<primary>}]`
      entry recording that the joint proof lives there, not a duplicated or
      fabricated proof of its own -- coq_status stays not_yet_formalised.
  (b) "excluded-member orphan": a few bundles' Coq files also formalise a
      member the founder's split ruling classified as prose/excluded (no
      child code at all: weld/S.04.v1 Prop-1, EQ-015/W.19.v1 Proposition 3,
      EQ-002/W.01.v1 Proposition 4). That apparatus has no child home; it is
      kept attached to a disclosed sibling child's own file with a header
      note naming which excluded occurrence it also carries -- never given
      its own fabricated child code, never silently dropped.

Where a child's own content depends on a small prerequisite Definition/Record
declared earlier in the SAME original Section (e.g. CAN_117_Record, needed by
three of CAN-117's four children), that prerequisite is duplicated verbatim
into every dependent child's own Section wrapper (never invented, never
altered) rather than cross-Requiring a sibling file -- this keeps every
generated child file independently self-contained and avoids Coq qualified-
name plumbing across freshly-split files. Cross-BUNDLE references that
already existed before this split (e.g. EQ-015/S.01.v1's own
`From MRC Require Import weld__S_02_v1.`) are left untouched: they keep
resolving because the referenced bundle becomes a re-export shim.

Run: python3 scripts/n4_coq_split.py
Inputs : registry/CANONICAL.json, registry/split_proposal_SW.json,
         coq/canonical/<bundle-code-mangled>.v (30 files, read-only inputs)
Outputs: coq/canonical/<child-code-mangled>.v (new files, ~60 of the 170
         children have real Coq apparatus per the mapping above)
         coq/canonical/<bundle-code-mangled>.v (rewritten: thin re-export)
         coq/canonical/_CoqProject (regenerated, topological order)
         registry/CANONICAL.json (coq.file/coq.identifier filled for every
         child that got a file; `relations` appended for primary-carrier
         siblings) -- LINEAGE.jsonl gets a `revised` event per file written
"""
import json, re, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REG = ROOT / "registry"
CAN_DIR = ROOT / "coq" / "canonical"
DATE = "2026-09-06"
BY = "toledo-n4-merge"

REQUIRE_BLOCK_RE = re.compile(
    r"^\(\*.*?\*\)\n\n((?:.*\n)*?)\n\(\* =+ \*\)", re.MULTILINE
)


def mangle(code: str) -> str:
    return code.replace("/", "__").replace(".", "_").replace("-", "_") + ".v"


def read(bundle_code: str) -> str:
    return (CAN_DIR / mangle(bundle_code)).read_text(encoding="utf-8")


def require_block(src: str) -> str:
    """The Require/Import/Set-Implicit block between the header comment and
    the first '(* ==== *)' divider, copied verbatim into every child (unused
    imports are harmless in Coq; this guarantees every child compiles with
    at least the same environment the bundle itself had)."""
    m = REQUIRE_BLOCK_RE.match(src)
    if not m:
        raise SystemExit(f"require_block: no match at top of source (len={len(src)})")
    return m.group(1).rstrip("\n")


def slice_between(text: str, start: str, end: str = None) -> str:
    i = text.index(start)
    j = text.index(end, i + len(start)) if end is not None else len(text)
    return text[i:j].rstrip("\n") + "\n"


def child_header(code: str, tier: str, parents) -> str:
    plist = ", ".join(p["code"] for p in parents)
    return f"(* {code} — {tier} — parents: {plist} *)\n"


# ===========================================================================
# Registry
# ===========================================================================
canon = json.load(open(REG / "CANONICAL.json", encoding="utf-8"))
entries = canon["canonical"]
by_code = {e["code"]: e for e in entries}
splits = [e for e in entries if e["status"] == "split"]
assert len(splits) == 30, f"expected 30 split bundles, found {len(splits)}"

# child_code -> body text (Requires excluded; added uniformly at write time)
CHILD_BODY: dict[str, str] = {}
# child_code -> extra header note (for orphan-carrier / primary-carrier disclosure)
CHILD_NOTE: dict[str, str] = {}
# child_code -> [(relation_type, target_code, note)] appended to CANONICAL.json
CHILD_RELATIONS: dict[str, list] = {}
# bundle_code -> [child_code,...] actually carved out (drives the re-export shim)
BUNDLE_REAL_CHILDREN: dict[str, list] = {}


def emit(bundle_code, child_code, body, note=None):
    CHILD_BODY[child_code] = body
    if note:
        CHILD_NOTE[child_code] = note
    BUNDLE_REAL_CHILDREN.setdefault(bundle_code, []).append(child_code)


def primary_carrier(bundle_code, primary_child, siblings, body, note):
    emit(bundle_code, primary_child, body, note)
    for sib in siblings:
        CHILD_RELATIONS.setdefault(sib, []).append(
            ("reads", primary_child,
             f"joint non-collapse construct formalised once, on {primary_child} "
             f"(see that code's own coq.file) -- the source proves all sibling "
             f"members' claims in a single Inductive+injectivity (or single "
             f"universally-quantified) proof, not separable into independent "
             f"per-member lemmas; not duplicated or fabricated here.")
        )


# ===========================================================================
# weld/S.01.v1 (CAN-115) -> children S.10..S.26 (17)
# ===========================================================================
sc = by_code["weld/S.01.v1"]["split_children"]  # S.10..S.26 in proposal order
src = read("weld/S.01.v1")
emit("weld/S.01.v1", sc[12],  # discrete forced-Laplacian stepper generator
     slice_between(src, "Section CAN_115_SocialLRStepper.",
                   "End CAN_115_L1_L4_Open.").rsplit("Section CAN_115_L1_L4_Open", 1)[0].rstrip("\n") + "\n")
# the four Open L1-L4 declarations: same shared Section wrapper duplicated,
# each keeping only its own Variable line.
l1_l4_top = slice_between(src, "Section CAN_115_L1_L4_Open.", "  (* L1:")
l1_l4_end = "\nEnd CAN_115_L1_L4_Open.\n"
for idx, (var_marker, next_marker) in enumerate([
    ("  (* L1: a bounded amplitude-only intervention", "  (* L2: holding the state"),
    ("  (* L2: holding the state", "  (* L3: raising dissipation"),
    ("  (* L3: raising dissipation", "  (* L4: suppressing one node"),
    ("  (* L4: suppressing one node", None),
]):
    block = slice_between(src, var_marker, next_marker) if next_marker else src[src.index(var_marker):src.index("\nEnd CAN_115_L1_L4_Open.")]
    emit("weld/S.01.v1", sc[13 + idx], l1_l4_top + block.rstrip("\n") + l1_l4_end)

# ===========================================================================
# weld/S.02.v1 (CAN-116) -> children S.10..S.13 (4): CE-01..CE-04
# ===========================================================================
sc = by_code["weld/S.02.v1"]["split_children"]
src = read("weld/S.02.v1")
emit("weld/S.02.v1", sc[0],  # CE-01 Reality-as-Record
     "Section CAN_116_EthAxiom.\n\n  Variable Event : Type.\n\n"
     "  (* Axiom I: Reality-as-Record — M(t') is (typed as) a finite record. *)\n"
     "  Definition CAN_116_ManifestedRecord : Type := list Event.\n\n"
     "End CAN_116_EthAxiom.\n")
emit("weld/S.02.v1", sc[1],  # CE-02 Agency-as-Choice
     "Section CAN_116_EthAxiom.\n\n  Variable Event : Type.\n\n"
     "  Definition CAN_116_ManifestedRecord : Type := list Event.\n\n"
     "  (* Axiom II: Agency-as-Choice — A_i(t') subseteq M(t'). *)\n"
     "  Definition CAN_116_is_agency (A M : CAN_116_ManifestedRecord) : Prop :=\n"
     "    incl A M.\n\nEnd CAN_116_EthAxiom.\n")
emit("weld/S.02.v1", sc[2],  # CE-03 Collective as Coupled Agencies + witness (last defining sibling)
     "Section CAN_116_EthAxiom.\n\n  Variable Event : Type.\n\n"
     "  Definition CAN_116_ManifestedRecord : Type := list Event.\n\n"
     "  Definition CAN_116_is_agency (A M : CAN_116_ManifestedRecord) : Prop :=\n"
     "    incl A M.\n\n"
     "  (* Axiom IV: Collective as Coupled Agencies — G(t') := {A_1,...,A_N}\n"
     "     subseteq M(t'); a collective is a finite list of agencies, each\n"
     "     itself included in the shared record. *)\n"
     "  Definition CAN_116_is_collective\n"
     "             (G : list CAN_116_ManifestedRecord) (M : CAN_116_ManifestedRecord) : Prop :=\n"
     "    Forall (fun A => CAN_116_is_agency A M) G.\n\n"
     + slice_between(src, "  (* Witness (tier: Th_coqc): the axioms are jointly", "\nEnd CAN_116_EthAxiom.")
     + "\nEnd CAN_116_EthAxiom.\n",
     note="also proves joint satisfiability of CE-01 (weld/S.10.v1) and CE-02 "
          "(weld/S.11.v1) together with this axiom -- the witness needs all "
          "three, so it is carried here (the last of the three defining "
          "children) rather than duplicated three times.")
# CE-04 (Admissible Regime Set): no matching Coq construct in the source
# (never defined anywhere in the file) -- no file, stays not_yet_formalised.

# ===========================================================================
# EQ-015/S.01.v1 (CAN-117) -> children S.13..S.16 (4): CE-05..CE-08
# ===========================================================================
sc = by_code["EQ-015/S.01.v1"]["split_children"]
REGIME_PREREQ = (
    "  Definition CAN_117_Record := CAN_116_ManifestedRecord Event.\n\n"
    "  Record CAN_117_Regime : Type := mkRegime\n"
    "    { reg_T_R : CAN_117_Record -> CAN_117_Record                    (* translation operator: updates M *)\n"
    "    ; reg_I_R : CAN_117_Record -> CAN_117_Record -> CAN_117_Record  (* interaction operator: updates A given M *)\n"
    "    }.\n\n"
)
emit("EQ-015/S.01.v1", sc[0],  # CE-05 Regime Structure
     "Section CAN_117_Regime.\n\n  Variable Event : Type.\n\n" + REGIME_PREREQ
     + "End CAN_117_Regime.\n")
emit("EQ-015/S.01.v1", sc[1],  # CE-06 record_updates
     "Section CAN_117_Regime.\n\n  Variable Event : Type.\n\n" + REGIME_PREREQ
     + "  (* CE-06 (update law): the two defining equations a regime's data\n"
       "     must satisfy at one tick. *)\n"
       "  Definition CAN_117_record_updates (R : CAN_117_Regime) (M M' : CAN_117_Record) : Prop :=\n"
       "    M' = reg_T_R R M.\n\nEnd CAN_117_Regime.\n")
emit("EQ-015/S.01.v1", sc[2],  # CE-07 agency_updates
     "Section CAN_117_Regime.\n\n  Variable Event : Type.\n\n" + REGIME_PREREQ
     + "  Definition CAN_117_agency_updates (R : CAN_117_Regime) (A M A' : CAN_117_Record) : Prop :=\n"
       "    incl A' (reg_I_R R A M).\n\nEnd CAN_117_Regime.\n")
emit("EQ-015/S.01.v1", sc[3],  # CE-08 Etic + witness
     "Section CAN_117_Regime.\n\n  Variable Event : Type.\n\n" + REGIME_PREREQ
     + "  Definition CAN_117_record_updates (R : CAN_117_Regime) (M M' : CAN_117_Record) : Prop :=\n"
       "    M' = reg_T_R R M.\n\n"
       "  Definition CAN_117_agency_updates (R : CAN_117_Regime) (A M A' : CAN_117_Record) : Prop :=\n"
       "    incl A' (reg_I_R R A M).\n\n"
     + slice_between(src := read("EQ-015/S.01.v1"),
                      "  (* CE-08: Etic(A;t')", "\nEnd CAN_117_Regime.")
     + "\nEnd CAN_117_Regime.\n")

# ===========================================================================
# EQ-015/S.02.v1 (CAN-118) -> children S.17..S.22 (6): CE-09,10,11,12,13,19
# ===========================================================================
sc = by_code["EQ-015/S.02.v1"]["split_children"]
src = read("EQ-015/S.02.v1")
ETHLOAD_TOP = "Section CAN_118_EthLoad.\n\n  Variable V : nat -> Q.       (* ethical-load ledger, one value per tick *)\n  Variable tau_c : Q.          (* causal-memory admissibility parameter *)\n  Variable Delta_spec : Q.     (* spectral-stability margin *)\n\n"
non_incr = "  Definition CAN_118_non_increasing : Prop :=\n    forall n : nat, V (S n) <= V n.\n\n"
ethical = "  Definition CAN_118_Ethical : Prop :=\n    CAN_118_non_increasing /\\ tau_c > 0 /\\ Delta_spec > 0.\n\n"
witness = slice_between(src, "  (* Witness (tier: Th_coqc): satisfiable", "\nEnd CAN_118_EthLoad.")
emit("EQ-015/S.02.v1", sc[0], ETHLOAD_TOP + non_incr + "End CAN_118_EthLoad.\n",
     note="Ethical Load (Lyapunov potential) V_{A,R} >= 0 is read here via its "
          "operational content already in this corpus (the per-tick "
          "non-increase clause CAN_118_non_increasing); the source's own "
          "file states no separate non-negativity construct for V itself.")
emit("EQ-015/S.02.v1", sc[1], ETHLOAD_TOP + "End CAN_118_EthLoad.\n",
     note="tau_c > 0 is a bare Variable hypothesis in the source (CAN_118_Ethical's "
          "second conjunct), not a separately named Coq construct of its own; "
          "kept as the Section-typed Variable it already is.")
emit("EQ-015/S.02.v1", sc[2], ETHLOAD_TOP + "End CAN_118_EthLoad.\n",
     note="Delta_spec > 0 is likewise a bare Variable hypothesis (CAN_118_Ethical's "
          "third conjunct); kept as the Section-typed Variable it already is.")
emit("EQ-015/S.02.v1", sc[3],  # CE-12 the locked inequality + witness (last of the four)
     ETHLOAD_TOP + non_incr + ethical + witness + "\nEnd CAN_118_EthLoad.\n",
     note="also carries the witness that V/tau_c/Delta_spec (CE-09/10/11, "
          "weld/S.17-19... -- see EQ-015/S.17-19.v1) are jointly satisfiable, "
          "since the witness proves the composite CAN_118_Ethical, not any one "
          "conjunct alone.")
# CE-13 (notation V-dot-plus) and CE-19 (Individual Ethics Condition, a
# restatement of CAN_118_Ethical under a different name) have no separate
# Coq construct in the source -- not_yet_formalised.

# ===========================================================================
# EQ-015/S.03.v1 (CAN-119) -> children S.23..S.33 (11)
# ===========================================================================
sc = by_code["EQ-015/S.03.v1"]["split_children"]
src = read("EQ-015/S.03.v1")
COLCONF_TOP = ("Section CAN_119_ColConf.\n\n"
               "  Variable V_G : nat -> Q.               (* collective ethical-load ledger *)\n"
               "  Variable individual_margins : list Q.  (* {Delta_spec(R_i)}_i, finite, declared *)\n"
               "  Variable V_indiv : nat -> Q.           (* one representative individual ledger, for Conf *)\n\n")
min_margin = ("  Definition CAN_119_min_margin : Q :=\n"
              "    match individual_margins with\n    | nil => 0\n    | x :: xs => fold_right Qmin x xs\n    end.\n\n")
emit("EQ-015/S.03.v1", sc[6],  # (21) Eth_col
     COLCONF_TOP + min_margin
     + "  Definition CAN_119_Eth_col : Prop :=\n"
       "    (forall n, V_G (S n) <= V_G n) /\\ CAN_119_min_margin > 0.\n\n"
       "End CAN_119_ColConf.\n")
emit("EQ-015/S.03.v1", sc[7],  # (22) Conf_ind_to_col
     COLCONF_TOP
     + "  Definition CAN_119_Conf_ind_to_col : Prop :=\n"
       "    (forall n, V_indiv (S n) <= V_indiv n) /\\ ~ (forall n, V_G (S n) <= V_G n).\n\n"
       "End CAN_119_ColConf.\n")
emit("EQ-015/S.03.v1", sc[8],  # (23) Conf_col_to_ind
     COLCONF_TOP
     + "  Definition CAN_119_Conf_col_to_ind : Prop :=\n"
       "    (forall n, V_G (S n) <= V_G n) /\\ ~ (forall n, V_indiv (S n) <= V_indiv n).\n\n"
       "End CAN_119_ColConf.\n")
emit("EQ-015/S.03.v1", sc[10],  # (30) structural injustice + witness
     COLCONF_TOP
     + slice_between(src, "  (* Structural injustice", "\nEnd CAN_119_ColConf.")
     + "\nEnd CAN_119_ColConf.\n")
# (14)(15)(16)(17)(18)(20)(24) spectral-decomposition/survival/collective-potential-
# alone/regime-incompatibility have no matching Coq construct -- not_yet_formalised.

# ===========================================================================
# weld/S.03.v1 (CAN-120) -> children S.31..S.42 (12)
# ===========================================================================
sc = by_code["weld/S.03.v1"]["split_children"]
src = read("weld/S.03.v1")
MORALCOST_TOP = ("Section CAN_120_MoralCost.\n\n"
                 "  Variable Vplus : nat -> Q.       (* per-tick worsening-load indicator, >= 0 *)\n"
                 "  Variable chi_causal chi_spec : Q. (* per-regime causal-memory / spectral violation indicators *)\n"
                 "  Variable alpha beta gamma : Q.\n"
                 "  Hypothesis Halpha : alpha > 0.\n  Hypothesis Hbeta  : beta  > 0.\n  Hypothesis Hgamma : gamma > 0.\n\n")
moral_cost = ("  Definition CAN_120_moral_cost (t1 t2 : nat) : Q :=\n"
              "    fold_right Qplus 0\n"
              "      (map (fun _ => alpha * Vplus t1 + beta * chi_causal + gamma * chi_spec)\n"
              "           (List.seq t1 (t2 - t1))).\n\n")
emit("weld/S.03.v1", sc[2], MORALCOST_TOP + moral_cost + "End CAN_120_MoralCost.\n")  # CE-27
emit("weld/S.03.v1", sc[3], MORALCOST_TOP + moral_cost
     + "  Definition CAN_120_Responsibility (t1 t2 : nat) : Q := CAN_120_moral_cost t1 t2.\n\n"
       "End CAN_120_MoralCost.\n")  # CE-28
emit("weld/S.03.v1", sc[6],  # CE-32 (Open, deliberately unproved)
     MORALCOST_TOP
     + slice_between(src, "  (* CE-32, Cost-Survival Link", "\nEnd CAN_120_MoralCost.")
     + "\nEnd CAN_120_MoralCost.\n")
emit("weld/S.03.v1", sc[9],  # choice-gate + witness
     MORALCOST_TOP
     + slice_between(src, "  (* Choice-gate:", "  (* Tragic regime class:")
     + "End CAN_120_MoralCost.\n")
emit("weld/S.03.v1", sc[10],  # Tragic + witness
     MORALCOST_TOP
     + slice_between(src, "  (* Tragic regime class:", "\nEnd CAN_120_MoralCost.")
     + "\nEnd CAN_120_MoralCost.\n")
# CE-25/26/29/31/33/34/(Tragic-min) have no matching Coq construct.

# ===========================================================================
# A.5/S.01.v1 (CAN-121) -> children S.04..S.13 (10)
# ===========================================================================
sc = by_code["A.5/S.01.v1"]["split_children"]
src = read("A.5/S.01.v1")
AGH_TOP = ("Section CAN_121_AgencyHierarchy.\n\n  Variables X C H : Type.\n  Variable F : X -> C -> X.\n\n")
proto = ('  (* Level 0/1 (Proto-Agency): the constraint update does not depend on\n'
         '     the state at all — "partial C / partial x = 0" discretely replaced\n'
         '     as: the update function ignores its state argument. *)\n'
         '  Definition CAN_121_ProtoAgency (G : X -> C -> C) : Prop :=\n'
         '    forall (x1 x2 : X) (c : C), G x1 c = G x2 c.\n\n')
coupling = ('  (* Level 2 (Agency-Condition, necessary not sufficient): the update\n'
            '     function genuinely does depend on the state — "partial C/partial x\n'
            '     <> 0" discretely replaced as: some state pair changes the update. *)\n'
            '  Definition CAN_121_StateConstraintCoupling (G : X -> C -> C) : Prop :=\n'
            '    exists (x1 x2 : X) (c : C), G x1 c <> G x2 c.\n\n')
emit("A.5/S.01.v1", sc[6], AGH_TOP + proto + "End CAN_121_AgencyHierarchy.\n")  # Proto-Agency-Condition
emit("A.5/S.01.v1", sc[4], AGH_TOP + coupling + "End CAN_121_AgencyHierarchy.\n")  # State-Constraint-Coupling
emit("A.5/S.01.v1", sc[7],  # L3
     AGH_TOP + "  Definition CAN_121_L3_history (G3 : X -> C -> H -> C) : Type := X -> C -> H -> C.\n\n"
     "End CAN_121_AgencyHierarchy.\n")
emit("A.5/S.01.v1", sc[8],  # L4
     AGH_TOP + "  Definition CAN_121_L4_predictive (G4 : X -> C -> X -> C) : Type := X -> C -> X -> C.\n\n"
     "End CAN_121_AgencyHierarchy.\n")
emit("A.5/S.01.v1", sc[9],  # L5 + witness (references ProtoAgency/StateConstraintCoupling directly)
     AGH_TOP + proto + coupling
     + "  Definition CAN_121_L5_meta (M : (X -> C -> C) -> (X -> C -> C)) : Type :=\n"
       "    (X -> C -> C) -> (X -> C -> C).\n\n"
       "End CAN_121_AgencyHierarchy.\n\n"
     + slice_between(src, "(* Witness (tier: Th_coqc): the hierarchy is non-vacuous"),
     note="also carries the joint witness that Proto-Agency (A.5/S.10.v1), "
          "State-Constraint-Coupling (A.5/S.08.v1) and this Level-5 meta-update "
          "are simultaneously exhibitable -- the witness needs all three, so it "
          "is duplicated onto this, the capping level, rather than the two "
          "earlier siblings.")
# Def-1/Def-2/Persistence-Regulation-Condition/Constraint-Evolution/Def-3
# have no matching Coq construct.

# ===========================================================================
# weld/S.04.v1 (CAN-122, mixed) -> children S.43..S.46 (4); Prop-1 excluded
# ===========================================================================
sc = by_code["weld/S.04.v1"]["split_children"]
src = read("weld/S.04.v1")
BELIEF_TOP = "Section CAN_122_BeliefRelation.\n\n  Variables Agent Prop_ Context BeliefFactors : Type.\n\n"
bv = ("  Record CAN_122_BeliefVector : Type := mkBeliefVector\n"
      "    { bv_e : Q ; bv_c : Q ; bv_s : Q ; bv_a : Q ; bv_eta : Q ; bv_g : Q ; bv_r : Q }.\n\n")
relb = ("  Variable Rel_B : Agent -> Prop_ -> Context -> CAN_122_BeliefVector.\n"
        "  Variable U_B   : CAN_122_BeliefVector -> CAN_122_BeliefVector.   (* per-tick update *)\n"
        "  Variable Stabilize_B : list CAN_122_BeliefVector -> CAN_122_BeliefVector.  (* group stabilisation *)\n\n")
emit("weld/S.04.v1", sc[0],  # (17) Belief relation
     BELIEF_TOP + bv + relb + "  Definition CAN_122_Bel := Rel_B.\n\nEnd CAN_122_BeliefRelation.\n")
emit("weld/S.04.v1", sc[1],  # (18) Canonical belief vector
     BELIEF_TOP + bv + "End CAN_122_BeliefRelation.\n")
emit("weld/S.04.v1", sc[2],  # (19) Belief update rule
     BELIEF_TOP + bv + relb + "  Definition CAN_122_update := U_B.\n\nEnd CAN_122_BeliefRelation.\n")
emit("weld/S.04.v1", sc[3],  # (20) Group belief stabilization -- also carries the excluded Prop-1 apparatus
     BELIEF_TOP + bv + relb
     + "  Definition CAN_122_group_belief := Stabilize_B.\n\n"
     + slice_between(src, "  (* Belief-scale nonpromotion", "\nEnd CAN_122_BeliefRelation.")
     + "\nEnd CAN_122_BeliefRelation.\n",
     note="also carries the Coq apparatus for the founder-excluded prose "
          "member '21529456:Prop-1' (Belief-scale nonpromotion, CAN_122_sigma_K "
          "+ CAN_122_belief_scale_nonpromotion) -- that member was ruled "
          "not_an_equation (registry/split_proposal_SW.json) so it carries no "
          "child code of its own; its formalisation is kept here, disclosed, "
          "rather than given a fabricated code or silently dropped.")

# ===========================================================================
# weld/S.05.v1 (CAN-123) -> children S.47..S.50 (4)
# ===========================================================================
sc = by_code["weld/S.05.v1"]["split_children"]
src = read("weld/S.05.v1")
CR_TOP = "Section CAN_123_CollectiveReadout.\n\n  Variables IndZ TimeT AggT CouplT SemVal EventT : Type.\n\n"
gs = ("  Record CAN_123_GroupState : Type := mkGroupState\n"
      "    { gs_individuals : list IndZ\n    ; gs_time        : TimeT\n"
      "    ; gs_aggregator  : AggT\n    ; gs_coupling    : CouplT\n    }.\n\n")
emit("weld/S.05.v1", sc[0],  # (43) group state tuple
     CR_TOP + gs + "End CAN_123_CollectiveReadout.\n")
emit("weld/S.05.v1", sc[1],  # (44) group semantic readout
     CR_TOP + gs + "  Variable q_sem_G : CAN_123_GroupState -> SemVal.\n\n"
     "  Definition CAN_123_group_readout (Z : CAN_123_GroupState) : SemVal := q_sem_G Z.\n\n"
     "End CAN_123_CollectiveReadout.\n")
emit("weld/S.05.v1", sc[2],  # (45) group memory update + witness
     CR_TOP
     + slice_between(src, "  (* m^G_{t+1} = rho", "\nEnd CAN_123_CollectiveReadout.")
     + "\nEnd CAN_123_CollectiveReadout.\n")
# (46) Group warrant function W_G,t: no matching Coq construct.

# ===========================================================================
# A.5/S.03.v1 (CAN-128) -> children S.14..S.20 (7)
# ===========================================================================
sc = by_code["A.5/S.03.v1"]["split_children"]
src = read("A.5/S.03.v1")
LIVE_ALIASES = {
    0: ("Definition CAN_128_live_full_nesting := @MR_Live.eq19_full_nesting.\n"
        "Definition CAN_128_is_valid_choice := @MR_Live.is_valid_choice.\n"),  # CBC-01 containment+choice
    1: "Definition CAN_128_live_field := @MR_Live.live_field.\n",  # CBC-05 live possibility field
    2: "Definition CAN_128_Pi_live := @MR_Live.Pi_live.\n",  # CBC-06 live-set threshold
    3: None,  # CBC-02 duplicate of CBC-01 -- no separate construct
    4: ("Definition CAN_128_enactment_may_differ_from_choice :=\n"
        "  @MR_Live.eq23_enactment_may_differ_from_choice.\n"
        "Definition CAN_128_observation_loses_information :=\n"
        "  @MR_Live.eq23_observation_loses_information.\n"),  # CBC-03
    5: "Definition CAN_128_six_level_non_collapse := @MR_Live.eq24_stage_chain_non_collapse.\n",  # CBC-04
    6: None,  # CBC-09 witnessed-set refinement -- no separate construct
}
for idx, code_line in LIVE_ALIASES.items():
    if code_line:
        emit("A.5/S.03.v1", sc[idx], code_line)

# ===========================================================================
# EQ-015/S.04.v1 (CAN-129) -> children S.34..S.50 (17) -- joint Inductive
# ===========================================================================
sc = by_code["EQ-015/S.04.v1"]["split_children"]
src = read("EQ-015/S.04.v1")
primary_carrier(
    "EQ-015/S.04.v1", sc[0], sc[1:],
    slice_between(src, "Inductive CAN_129_NCItem"),
    note="carries the JOINT 17-item non-collapse proof for all of "
         "EQ-015/S.34.v1..EQ-015/S.50.v1 (a single 17-constructor Inductive "
         "type with an injective nat index, proved once) -- see this "
         "bundle's own header for the source's stated reason "
         "('the same MRC_root_spine.v CAN_004_Stage pattern, scaled up: "
         "injectivity of the index is the single witnessed fact').",
)

# ===========================================================================
# EQ-015/S.06.v1 (CAN-132) -> children S.51..S.55 (5)
# ===========================================================================
sc = by_code["EQ-015/S.06.v1"]["split_children"]
emit("EQ-015/S.06.v1", sc[0],  # CBC-08 witnessed-readout potential
     "Definition CAN_132_p_star := @MR_Live.p_star.\n"
     "Definition CAN_132_p_star_upper_bound := @MR_Live.p_star_upper_bound.\n")
# the other 4 (restatement/vector/aggregate/chain-rule) have no local construct.

# ===========================================================================
# EQ-015/S.07.v1 (CAN-133) -> children S.56..S.57 (2)
# ===========================================================================
sc = by_code["EQ-015/S.07.v1"]["split_children"]
src = read("EQ-015/S.07.v1")
RE_TOP = "Section CAN_133_RecoverableEnvelope.\n\n  Variables Cond : Type.\n  Variable A_corr : Cond -> Q.\n  Variable J_feas : list Cond.\n\n"
p2 = "  Definition CAN_133_p_star2 (p_of : Cond -> Q) : Q :=\n    fold_right Qmax 0 (map p_of J_feas).\n\n"
emit("EQ-015/S.07.v1", sc[0], RE_TOP + p2 + "End CAN_133_RecoverableEnvelope.\n")
emit("EQ-015/S.07.v1", sc[1],
     RE_TOP + slice_between(src, "  Definition CAN_133_recoverable_gap", "\nEnd CAN_133_RecoverableEnvelope.")
     + "\nEnd CAN_133_RecoverableEnvelope.\n")

# ===========================================================================
# EQ-015/S.10.v1 (CAN-136, mixed) -> child S.58 (1); P-A excluded (same code)
# ===========================================================================
sc = by_code["EQ-015/S.10.v1"]["split_children"]
src = read("EQ-015/S.10.v1")
emit("EQ-015/S.10.v1", sc[0], src[src.index("Inductive CAN_136_Observation"):])

# ===========================================================================
# EQ-015/S.11.v1 (CAN-137) -> children S.59..S.65 (7) -- joint Inductive
# ===========================================================================
sc = by_code["EQ-015/S.11.v1"]["split_children"]
src = read("EQ-015/S.11.v1")
primary_carrier(
    "EQ-015/S.11.v1", sc[0], sc[1:],
    slice_between(src, "Inductive CAN_137_Distinction"),
    note="carries the JOINT 7-item non-collapse proof for all of "
         "EQ-015/S.59.v1..EQ-015/S.65.v1 (same CAN-129/17-item pattern, "
         "scaled to 7).",
)

# ===========================================================================
# EQ-015/W.03.v1 (CAN-142) -> children W.20..W.24 (5)
# ===========================================================================
sc = by_code["EQ-015/W.03.v1"]["split_children"]
src = read("EQ-015/W.03.v1")
emit("EQ-015/W.03.v1", sc[0],  # eq5
     "Section CAN_142_MachineCapacityBlock.\n\n"
     + slice_between(src, "  Definition CAN_142_B_RB", "  Definition CAN_142_M_index")
     + "End CAN_142_MachineCapacityBlock.\n")
# eq6 (growth decomposition): explicitly a refused continuum non-readout per the bundle's own header -- no file.
emit("EQ-015/W.03.v1", sc[2],  # eq7
     "Section CAN_142_MachineCapacityBlock.\n\n"
     + slice_between(src, "  Definition CAN_142_M_index", "  Definition CAN_142_rho_CES")
     + "End CAN_142_MachineCapacityBlock.\n")
emit("EQ-015/W.03.v1", sc[3],  # eq9
     "Section CAN_142_MachineCapacityBlock.\n\n"
     + slice_between(src, "  Definition CAN_142_rho_CES", "  Definition CAN_142_labour_share")
     + "End CAN_142_MachineCapacityBlock.\n")
emit("EQ-015/W.03.v1", sc[4],  # eq10
     "Section CAN_142_MachineCapacityBlock.\n\n"
     + slice_between(src, "  Definition CAN_142_labour_share", "\nEnd CAN_142_MachineCapacityBlock.")
     + "\nEnd CAN_142_MachineCapacityBlock.\n")

# ===========================================================================
# EQ-015/W.04.v1 (CAN-143, mixed) -> child W.25 (1)
# ===========================================================================
sc = by_code["EQ-015/W.04.v1"]["split_children"]
emit("EQ-015/W.04.v1", sc[0],
     "Definition CAN_143_LabourCentrality := MR_WorldSystem.LabourCentrality.\n"
     "Definition CAN_143_mk_labour_centrality := MR_WorldSystem.mk_labour_centrality.\n")

# ===========================================================================
# EQ-015/W.05.v1 (CAN-144) -> children W.26..W.30 (5)
# ===========================================================================
sc = by_code["EQ-015/W.05.v1"]["split_children"]
src = read("EQ-015/W.05.v1")
convex = ("Section CAN_144_ClaimConstitution.\n\n"
          "  Definition CAN_144_convex_combine (a b : Q) : Q := a + b * (1 - a).\n\n"
          "  Theorem CAN_144_convex_combine_identity :\n"
          "    forall a b : Q, CAN_144_convex_combine a b == 1 - (1 - a) * (1 - b).\n"
          "  Proof. intros a b. unfold CAN_144_convex_combine. ring. Qed.\n\n")
emit("EQ-015/W.05.v1", sc[0],  # eq11 q_t
     convex + "  (* q_t = o_t + tau_t (1 - o_t) *)\n"
     "  Definition CAN_144_q_t (o_t tau_t : Q) : Q := CAN_144_convex_combine o_t tau_t.\n\n"
     "End CAN_144_ClaimConstitution.\n")
emit("EQ-015/W.05.v1", sc[1],  # eq12 Gamma_t
     convex + "  (* Gamma_t = s^L_t + q_t (1 - s^L_t) *)\n"
     "  Definition CAN_144_Gamma_t (s_L_t q_t : Q) : Q := CAN_144_convex_combine s_L_t q_t.\n\n"
     "End CAN_144_ClaimConstitution.\n")
emit("EQ-015/W.05.v1", sc[2],  # eq13 q^min (aliases, outside any Section in source)
     "Definition CAN_144_q_min := MR_WorldSystem.q_min.\n"
     "Definition CAN_144_citizen_claim_threshold_identity :=\n"
     "  MR_WorldSystem.eq54_citizen_claim_threshold_identity.\n")
# eq14 (D^rent) / eq15 (Gamma^net): source's own header states these "carry
# no further equation of their own in this id's occurrence range" -- no file.

# ===========================================================================
# EQ-015/W.06.v1 (CAN-145, mixed) -> children W.31..W.33 (3)
# ===========================================================================
sc = by_code["EQ-015/W.06.v1"]["split_children"]
src = read("EQ-015/W.06.v1")
emit("EQ-015/W.06.v1", sc[0],
     "Section CAN_145_DemandRealization.\n\n"
     + slice_between(src, "  Definition CAN_145_AD", "  Definition CAN_145_chi_dem")
     + "End CAN_145_DemandRealization.\n")
emit("EQ-015/W.06.v1", sc[1],
     "Section CAN_145_DemandRealization.\n\n"
     + slice_between(src, "  Definition CAN_145_chi_dem", "  Definition CAN_145_Pi_M")
     + "End CAN_145_DemandRealization.\n")
emit("EQ-015/W.06.v1", sc[2],
     "Section CAN_145_DemandRealization.\n\n"
     + slice_between(src, "  Definition CAN_145_Pi_M", "\nEnd CAN_145_DemandRealization.")
     + "\nEnd CAN_145_DemandRealization.\n")

# ===========================================================================
# EQ-015/W.07.v1 (CAN-146) -> children W.34..W.36 (3)
# ===========================================================================
sc = by_code["EQ-015/W.07.v1"]["split_children"]
src = read("EQ-015/W.07.v1")
emit("EQ-015/W.07.v1", sc[0],
     "Section CAN_146_OwnershipAccumulation.\n\n"
     + slice_between(src, "  Definition CAN_146_ownership_accumulate", "  Definition CAN_146_ownership_share")
     + "End CAN_146_OwnershipAccumulation.\n")
emit("EQ-015/W.07.v1", sc[1],
     "Section CAN_146_OwnershipAccumulation.\n\n"
     + slice_between(src, "  Definition CAN_146_ownership_share", "  Theorem CAN_146_redistribution")
     + "End CAN_146_OwnershipAccumulation.\n")
emit("EQ-015/W.07.v1", sc[2],
     "Section CAN_146_OwnershipAccumulation.\n\n"
     + "  Definition CAN_146_ownership_accumulate\n"
       "             (delta_W r W s_cap T_cap Tax_cap : Q) : Q :=\n"
       "    (1 - delta_W) * W + r * W + s_cap + T_cap - Tax_cap.\n\n"
       "  Definition CAN_146_ownership_share (W_i W_total : Q) : Q := W_i / W_total.\n\n"
     + slice_between(src, "  Theorem CAN_146_redistribution", "\nEnd CAN_146_OwnershipAccumulation.")
     + "\nEnd CAN_146_OwnershipAccumulation.\n")

# ===========================================================================
# A.5/W.01.v1 (CAN-147) -> children W.04..W.06 (3)
# ===========================================================================
sc = by_code["A.5/W.01.v1"]["split_children"]
src = read("A.5/W.01.v1")
emit("A.5/W.01.v1", sc[0],
     "Section CAN_147_ScarceAssetRent.\n\n"
     + slice_between(src, "  Definition CAN_147_B_scarce", "  Definition CAN_147_Gamma_eff")
     + "End CAN_147_ScarceAssetRent.\n")
emit("A.5/W.01.v1", sc[1],
     "Section CAN_147_ScarceAssetRent.\n\n"
     + slice_between(src, "  Definition CAN_147_Gamma_eff", "  Theorem CAN_147_abundance")
     + "End CAN_147_ScarceAssetRent.\n")
emit("A.5/W.01.v1", sc[2],
     "Section CAN_147_ScarceAssetRent.\n\n"
     + "  Definition CAN_147_Gamma_eff (Gamma_net B_scarce_val : Q) : Q :=\n"
       "    Qmax 0 (Gamma_net - B_scarce_val).\n\n"
     + slice_between(src, "  Theorem CAN_147_abundance", "\nEnd CAN_147_ScarceAssetRent.")
     + "\nEnd CAN_147_ScarceAssetRent.\n")

# ===========================================================================
# EQ-015/W.08.v1 (CAN-148) -> children W.37..W.41 (5)
# ===========================================================================
sc = by_code["EQ-015/W.08.v1"]["split_children"]
src = read("EQ-015/W.08.v1")
emit("EQ-015/W.08.v1", sc[0],  # eq26 G^conv
     "Section CAN_148_ConversionGates.\n\n"
     + slice_between(src, "  Definition CAN_148_G_conv", "  Definition CAN_148_Dependency")
     + "End CAN_148_ConversionGates.\n")
# eq27 (credible-exit index X): no matching Coq construct.
emit("EQ-015/W.08.v1", sc[2],  # eq28 Dependency
     "Section CAN_148_ConversionGates.\n\n"
     + "  Definition CAN_148_G_conv (V_full V_excl : Q) : Q :=\n"
       "    1 - Qmax 0 (V_excl / V_full).\n\n"
     + slice_between(src, "  Definition CAN_148_Dependency", "  Theorem CAN_148_concentration")
     + "End CAN_148_ConversionGates.\n")
emit("EQ-015/W.08.v1", sc[3],  # eq29 non-collapse concentration/gate/dependency + witness
     "Section CAN_148_ConversionGates.\n\n"
     + "  Definition CAN_148_G_conv (V_full V_excl : Q) : Q :=\n"
       "    1 - Qmax 0 (V_excl / V_full).\n\n"
       "  Definition CAN_148_Dependency (w G_conv_val X : Q) : Q :=\n"
       "    w * G_conv_val * (1 - X).\n\n"
     + slice_between(src, "  Theorem CAN_148_concentration", "\nEnd CAN_148_ConversionGates.")
     + "\nEnd CAN_148_ConversionGates.\n")
# eq53 (conditional non-collapse concentration/dependency/agency-loss): no matching construct.

# ===========================================================================
# EQ-015/W.10.v1 (CAN-151, mixed) -> children W.42..W.46 (5)
# ===========================================================================
sc = by_code["EQ-015/W.10.v1"]["split_children"]
emit("EQ-015/W.10.v1", sc[0],  # eq40 P^H_t index
     "Definition CAN_151_P_H_index := MR_WorldSystem.P_H_index.\n")
# eq41/eq42 (growth-rate decomposition parts 1/2): no local construct (continuum log-derivative, refused elsewhere in this family).
emit("EQ-015/W.10.v1", sc[3],  # eq43 non-collapse output-growth vs P^H growth
     "Definition CAN_151_output_rise_not_position_rise :=\n"
     "  MR_WorldSystem.eq59_output_rise_not_position_rise.\n")
# eq44 (Abundance-Without-Agency tuple): no local construct.

# ===========================================================================
# EQ-015/W.11.v1 (CAN-152) -> children W.47..W.48 (2)
# ===========================================================================
sc = by_code["EQ-015/W.11.v1"]["split_children"]
src = read("EQ-015/W.11.v1")
emit("EQ-015/W.11.v1", sc[0],  # eq36 S-dot^H
     "Section CAN_152_SocialRoleStanding.\n\n"
     + slice_between(src, "  Definition CAN_152_S_H_next", "  Definition CAN_152_time_budget_valid")
     + "End CAN_152_SocialRoleStanding.\n")
emit("EQ-015/W.11.v1", sc[1],  # eq37 time-budget identity + witness
     "Section CAN_152_SocialRoleStanding.\n\n"
     + slice_between(src, "  Definition CAN_152_time_budget_valid", "\nEnd CAN_152_SocialRoleStanding.")
     + "\nEnd CAN_152_SocialRoleStanding.\n")

# ===========================================================================
# EQ-015/W.12.v1 (CAN-153, mixed) -> children W.49..W.50 (2)
# ===========================================================================
sc = by_code["EQ-015/W.12.v1"]["split_children"]
src = read("EQ-015/W.12.v1")
emit("EQ-015/W.12.v1", sc[0],  # eq38 H^cap dynamic
     src[src.index("Section CAN_153_SocialReproduction."):])
emit("EQ-015/W.12.v1", sc[1],  # eq39 non-collapse productive-vs-social necessity
     "Definition CAN_153_productive_not_social_necessity_witness :=\n"
     "  CAN_ws_generic_rise_not_entail_rise.\n")

# ===========================================================================
# A.5/W.02.v1 (CAN-154, mixed) -> children W.07..W.11 (5)
# ===========================================================================
sc = by_code["A.5/W.02.v1"]["split_children"]
src = read("A.5/W.02.v1")
emit("A.5/W.02.v1", sc[0],  # eq45 3-channel power vector
     "Section CAN_154_PowerChannels.\n\n  Variables PEcon PInfo PCoerc State3 : Type.\n\n"
     + slice_between(src, "  Definition PowerVector", "  Variable F_I")
     + "End CAN_154_PowerChannels.\n")
# eq46 (bargaining power P^B_t) / eq47 (epistemic power P^E_t): no local construct.
emit("A.5/W.02.v1", sc[3],  # eq48 institutional-change rate I-dot
     "Section CAN_154_PowerChannels.\n\n  Variables PEcon PInfo PCoerc State3 : Type.\n\n"
     + slice_between(src, "  Definition PowerVector", "  Definition CAN_154_mk_power_vector")
     + slice_between(src, "  Variable F_I", "\nEnd CAN_154_PowerChannels.")
     + "\nEnd CAN_154_PowerChannels.\n")
emit("A.5/W.02.v1", sc[4],  # eq50 non-collapse ownership/informational/coercive power
     "Definition CAN_154_channel_noncollapse_witness :=\n"
     "  CAN_ws_generic_rise_not_entail_rise.\n")

# ===========================================================================
# EQ-015/W.16.v1 (CAN-159, mixed) -> children W.51..W.54 (4)
# ===========================================================================
sc = by_code["EQ-015/W.16.v1"]["split_children"]
emit("EQ-015/W.16.v1", sc[0],  # (1) non-collapse machine vs human expansion
     "Definition CAN_159_machine_expansion_not_human_expansion :=\n"
     "  MR_WorldSystem.eq60_machine_expansion_not_human_expansion.\n")
emit("EQ-015/W.16.v1", sc[1],  # (11) Human Conversion Vector
     "Definition CAN_159_HumanConversionVector := MR_WorldSystem.HumanConversionVector.\n"
     "Definition CAN_159_mk_human_conversion_vector := MR_WorldSystem.mk_human_conversion_vector.\n")
emit("EQ-015/W.16.v1", sc[2],  # (12) conversion elasticity
     "Definition CAN_159_eta_HC := MR_WorldSystem.eta_HC.\n")
# (13) elasticity sign constraints: no local construct.

# ===========================================================================
# A.5/W.03.v1 (CAN-160) -> children W.12..W.20 (9) -- joint generic-shape theorem
# ===========================================================================
sc = by_code["A.5/W.03.v1"]["split_children"]
src = read("A.5/W.03.v1")
primary_carrier(
    "A.5/W.03.v1", sc[0], sc[1:],
    src[src.index("Definition CAN_160_separation"):],
    note="carries the JOINT proof for all nine bundled non-collapse pairs "
         "(A.5/W.12.v1..A.5/W.20.v1): a single universally-quantified "
         "theorem (CAN_160_all_separations_satisfiable) that the shared "
         "rise-does-not-entail-rise shape is satisfiable for every "
         "arbitrarily-indexed pair in the bundle, per this bundle's own "
         "header note -- not nine independent per-pair proofs.",
)

# ===========================================================================
# EQ-015/W.19.v1 (CAN-163, mixed) -> children W.55..W.59 (5); Prop-3 excluded
# ===========================================================================
sc = by_code["EQ-015/W.19.v1"]["split_children"]
src = read("EQ-015/W.19.v1")
emit("EQ-015/W.19.v1", sc[0],  # (17) reversibility window -- also carries excluded Proposition 3
     "Definition CAN_163_reversibility_window := MR_WorldSystem.reversibility_window.\n"
     "Definition CAN_163_in_reversibility_window := MR_WorldSystem.in_reversibility_window.\n\n"
     + src[src.index("Definition CAN_163_Open_reversibility_principle"):],
     note="also carries the Coq apparatus for the founder-excluded prose "
          "member '22481926:Proposition 3' (the Reversibility Principle "
          "itself, CAN_163_Open_reversibility_principle) -- ruled "
          "not_an_equation, so it carries no child code of its own; its "
          "(deliberately un-proved, Open) declaration is kept here, "
          "disclosed, since it is stated over exactly this reversibility-"
          "window apparatus.")
# (18) capability-conversion gap / (20) urgency vector / (21) maximum urgency: no local construct.
emit("EQ-015/W.19.v1", sc[2],  # (19) urgency index
     "Definition CAN_163_urgency_term := MR_WorldSystem.urgency_term.\n")

# ===========================================================================
# EQ-002/W.01.v1 (CAN-164, mixed) -> child W.03 (1); Proposition 4 excluded
# ===========================================================================
sc = by_code["EQ-002/W.01.v1"]["split_children"]
src = read("EQ-002/W.01.v1")
emit("EQ-002/W.01.v1", sc[1],  # (23) inequality index -- also carries excluded Proposition 4
     "Section CAN_164_DistributionalConversion.\n\n"
     + slice_between(src, "  Definition CAN_164_I_H", "\nEnd CAN_164_DistributionalConversion.")
     + "\nEnd CAN_164_DistributionalConversion.\n",
     note="also carries the Coq apparatus for the founder-excluded prose "
          "member '22481926:Proposition 4' (broad human expansion requires "
          "conversion gains across the distribution -- "
          "CAN_164_Open_proposition4_broad_expansion) -- ruled "
          "not_an_equation, so it carries no child code of its own; its "
          "(deliberately un-proved, Open) declaration is kept here, "
          "disclosed, since it is stated directly over the percentile "
          "readouts I_H already formalises.")
# (22) bare percentile readouts C10/C50/C90: no local construct of their own.

print(f"Planned {len(CHILD_BODY)} real child files across {len(BUNDLE_REAL_CHILDREN)} bundles "
      f"(of 170 total children across 30 bundles).")

if __name__ == "__main__" and "--plan-only" in sys.argv:
    if "--dump" in sys.argv:
        want = sys.argv[sys.argv.index("--dump") + 1].split(",")
        for w in want:
            print(f"\n=========== {w} ===========")
            print(child_header(w, by_code[w]["tier"], by_code[w]["parents"]), end="")
            if CHILD_NOTE.get(w):
                print(f"(* {CHILD_NOTE[w]} *)")
            print(CHILD_BODY.get(w, "<<NO BODY -- not a real child>>"))
    sys.exit(0)

# ===========================================================================
# Write child files
# ===========================================================================
for child_code, body in CHILD_BODY.items():
    e = by_code[child_code]
    header = child_header(child_code, e["tier"], e["parents"])
    note = CHILD_NOTE.get(child_code)
    note_line = f"(* {note} *)\n" if note else ""
    bundle_code = [p["code"] for p in e["parents"] if p["derived_via"] == "split"][0]
    text = header + note_line + "\n" + require_block(read(bundle_code)) + "\n\n" + body
    out_path = CAN_DIR / mangle(child_code)
    out_path.write_text(text, encoding="utf-8")

# ===========================================================================
# Rewrite bundle files as thin re-export shims
# ===========================================================================
for bundle_code, children in BUNDLE_REAL_CHILDREN.items():
    e = by_code[bundle_code]
    src = read(bundle_code)
    reqs = require_block(src)
    header = f"(* {bundle_code} — {e['tier']} — parents: " + ", ".join(p['code'] for p in e['parents']) + " *)\n"
    exports = "\n".join(f"From MRC Require Export {mangle(c)[:-2]}." for c in children)
    text = (
        header
        + "(* N4 split (2026-09-06): this bundle's own Coq apparatus has been\n"
          "   distributed to its child codes (registry/CANONICAL.json "
          "\"split_children\"); kept\n"
          "   as a thin re-export so existing `Require`s of this module keep "
          "resolving. *)\n\n"
        + reqs + "\n\n"
        + exports + "\n"
    )
    (CAN_DIR / mangle(bundle_code)).write_text(text, encoding="utf-8")

print(f"Wrote {len(CHILD_BODY)} child files, rewrote {len(BUNDLE_REAL_CHILDREN)} bundle shims.")

# ===========================================================================
# Apply relations for primary-carrier siblings + record which children got files
# ===========================================================================
for sib, rels in CHILD_RELATIONS.items():
    e = by_code[sib]
    for rtype, target, note in rels:
        e["relations"].append({"type": rtype, "target": target, "note": note})

for child_code in CHILD_BODY:
    e = by_code[child_code]
    e["coq"]["file"] = f"coq/canonical/{mangle(child_code)}"
    ids = re.findall(
        r"^\s*(?:Definition|Theorem|Corollary|Example|Remark|Record|Inductive|Notation|Fixpoint)\s+"
        r"([A-Za-z0-9_']+)", CHILD_BODY[child_code], re.MULTILINE)
    e["coq"]["identifier"] = ", ".join(dict.fromkeys(ids))
    # coq_status/assumptions/coq_axioms are set from the REAL build+verify
    # pass below (n4_coq_verify_update.py), never asserted here.

for bundle_code in BUNDLE_REAL_CHILDREN:
    e = by_code[bundle_code]
    e["coq"]["identifier"] = "(re-export shim; apparatus moved to split_children)"

json.dump(canon, open(REG / "CANONICAL.json", "w", encoding="utf-8"), indent=2, ensure_ascii=False)
print(f"Updated {REG/'CANONICAL.json'}: coq.file/coq.identifier set for {len(CHILD_BODY)} children, "
      f"{len(BUNDLE_REAL_CHILDREN)} bundle shims.")

with open(REG / "LINEAGE.jsonl", "a", encoding="utf-8") as fh:
    for child_code in CHILD_BODY:
        fh.write(json.dumps({
            "code": child_code, "date": DATE, "event": "revised",
            "from": f"{by_code[child_code]['parents'][-1]['code']} (bundle Coq apparatus)",
            "to": f"coq/canonical/{mangle(child_code)}",
            "reason": "N4 Coq splitter: member's own Coq apparatus moved out of the "
                      "bundle's single .v file into this child's own file, per "
                      "scripts/n4_coq_split.py's quoted per-member mapping.",
            "by": BY,
        }, ensure_ascii=False) + "\n")
    for bundle_code in BUNDLE_REAL_CHILDREN:
        fh.write(json.dumps({
            "code": bundle_code, "date": DATE, "event": "revised",
            "from": f"coq/canonical/{mangle(bundle_code)} (full apparatus)",
            "to": f"coq/canonical/{mangle(bundle_code)} (thin re-export shim)",
            "reason": "N4 Coq splitter: apparatus distributed to "
                      f"{BUNDLE_REAL_CHILDREN[bundle_code]}; this file now only "
                      "re-exports them so existing Requires keep resolving.",
            "by": BY,
        }, ensure_ascii=False) + "\n")
print(f"Appended {len(CHILD_BODY) + len(BUNDLE_REAL_CHILDREN)} LINEAGE.jsonl events.")
