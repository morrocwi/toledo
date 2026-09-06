# LEDGER — family "root-spine"

Coq 8.20.1. Build/verify command used throughout (RAM discipline: one file
at a time, never parallel `coqc`):

```sh
cd research/society-justice-peace/master-river/coq_canon
coqc -Q . MRC -Q ../coq MR MRC_root_spine.v
coqc -Q . MRC -Q ../coq MR MRC_master.v
```

Both files compiled clean (`MRC_master.v` had one deprecation warning —
`app_length` → `length_app`, Coq 8.20 renamed the lemma — fixed, final
compile has zero warnings and zero errors).

Family assignment record: `../registry/family_root-spine.json`.
Assignment method: `root-spine = spine_ids` exactly as fixed in
`../registry/COLLAPSE.md` §1 — nine `domain: "root"` CAN ids
(`CAN-002, CAN-201, CAN-001, CAN-003, CAN-006, CAN-007, CAN-008, CAN-004,
CAN-009`). Two further `domain: "root"` ids in CANONICAL.json (CAN-005,
CAN-222) are **excluded** — COLLAPSE.md states both are *readings* of a
spine element (CAN-004 and CAN-008 respectively) by the root paper's own
semantic layer, not additional root objects.

None of the nine ids is itself a Master River eq. (1)-(79) (their
`occurrences` in CANONICAL.json cite Readout Genesis Standalone Synthesis,
Mind as Information Horizon, RG-HCA, "Before Meaning, Before Choice", "From
Problem to Hypothesis", and "After Labour" — not `v1_3/main.tex` /
`v1_4/main.tex`), so `MRC_root_spine.v` does not `Require` any `MR_*`
module; the `-Q ../coq MR` path is passed on every `coqc` call per the
task's fixed build command, but is unused by this family's content.

## `MRC_root_spine.v` — the nine spine CAN ids

| CAN id | key | Coq identifier(s) | tier (this file) | tier (CANONICAL.json's own words) | `Print Assumptions` |
|---|---|---|---|---|---|
| CAN-002 | root-state-tuple | `RootState` (Record); `CAN_002_root_state_tuple_faithful` | Definition + Th_coqc witness | definition | Closed under the global context |
| CAN-201 | root-readout-gate | `CAN_201_readout` (Variable) + `CAN_201_readout_ne_state` (Hypothesis); `CAN_201_hypothesis_satisfiable_on_bool` | Definition + Th_coqc witness | definition | Closed under the global context |
| CAN-001 | root-weld | `CAN_001_degree`, `CAN_001_laplacian`; `CAN_001_sum_neg_distributes`, `CAN_001_laplacian_row_sums_to_neg_degree`; `CAN_001_F` (Variable); `CAN_001_laplacian_stepper_can_move_state` | Th_coqc (δ_R⊢L_R half, proved) / Definition + Th_coqc witness (L_R⊢F half — "Dr" in source, not re-derived here) | Th_coqc (δ_R⊢L_R only) / Dr (F stepper) / theorem-in-source (not independently machine-checked) | Closed under the global context (×3) |
| CAN-003 | root-stepper | `CAN_003_F` (Variable); `CAN_003_trajectory`; `CAN_003_stepper_can_move_state`, `CAN_003_trajectory_zero` | Definition + Th_coqc witness | Dr | Closed under the global context (×2) |
| CAN-006 | domain-weld | `CAN_006_domain_admissible`; `CAN_006_domain_weld_satisfiable_on_pair_projection` | Definition + Th_coqc witness | definition (admissibility condition) | Closed under the global context |
| CAN-007 | reader-equivalence | `CAN_007_reader_equiv`; `CAN_007_reader_equiv_is_equivalence` | Definition + Th_coqc (equivalence-relation proof) | definition | Closed under the global context |
| CAN-008 | constitutional-noncollapse | `CAN_008_noncollapse`; `CAN_008_root_candidate_quotient_are_three_things` | Definition + Th_coqc witness | definition | Closed under the global context |
| CAN-222 | root-non-collapse-chain | `CAN_222_root_non_collapse_chain` (alias of `CAN_008_noncollapse`); `CAN_222_root_non_collapse_chain_witness` (alias of `CAN_008_root_candidate_quotient_are_three_things`) | Definition + Th_coqc witness (both aliases — no new proof obligation, reuse-not-redefine, in the CAN-143/CAN-144 alias style) | law (non-collapse) | Closed under the global context (alias of an already-closed identifier) |
| CAN-004 | constitutional-ordering | `CAN_004_Stage` (Inductive, 12 constructors); `CAN_004_index`; `CAN_004_forbidden_order`; `CAN_004_index_injective`, `CAN_004_checking_before_status_before_report` | Definition + Th_coqc (×2) | law (constitutional ordering rule) | Closed under the global context (×2) |
| CAN-005 | readout-admission-order | `CAN_005_readout_admission_order` (alias of `CAN_004_index`); `CAN_005_readout_admission_order_stage` (alias of `CAN_004_Stage`) | Definition (both aliases — no new proof obligation, reuse-not-redefine, in the CAN-143/CAN-144 alias style) | definition | (no new proof obligation to check — `CAN_004_index_injective`/`CAN_004_checking_before_status_before_report` already cover the underlying object, Closed under the global context) |
| CAN-009 | historical-invariance | `CAN_009_extends`; `CAN_009_extension_preserves_past`, `CAN_009_witness_append_preserves_first_event` | Definition + Th_coqc (×2) | law (invariant) | Closed under the global context (×2) |

Total identifiers carrying a `(* CAN-nnn — ... *)` tag: **11** — the nine
`spine_ids` (`CAN-002, CAN-201, CAN-001, CAN-003, CAN-006, CAN-007,
CAN-008, CAN-004, CAN-009`) plus CAN-005 and CAN-222, which COLLAPSE.md
excludes from the `spine_ids` *family-membership* grouping (both are
readings of CAN-004/CAN-008 respectively, not independent root objects)
but which CANONICAL.json still lists as live, first-class `domain: "root"`
canonical ids — so each still gets its own one-line alias `Definition`
here (reuse-not-redefine, no new theorem, same style as CAN-143's alias of
`MR_WorldSystem.LabourCentrality`) so the registry-to-corpus map stays
total (fixes the coverage gap an earlier adversarial review caught: 251/253
tagged, CAN-005 and CAN-222 the only two absent). Total
`Theorem`/`Lemma`/`Remark`/`Example` proof obligations across the file:
**14** (unchanged — the two new ids add only alias `Definition`s, no new
proof), every one `Print Assumptions`-clean ("Closed under the global
context") — verified via a scratch file `Require`-ing `MRC.MRC_root_spine`
(the `-Q . MRC` module path) and calling `Print Assumptions` on each
identifier in turn (also re-run directly on the four new alias
identifiers themselves: all four "Closed under the global context").

Discrete replacements recorded (never silently injected):
- CAN-001: the graph Laplacian's degree is a **finite row-sum**
  (`fold_right Qplus 0 (map (W i) verts)`) over a declared finite vertex
  list, never an infinite/continuum sum.
- CAN-003/CAN-002: the stepper's trajectory is a `nat`-indexed
  `Fixpoint` unrolling, never an infinite-limit/continuum-time object.
- CAN-007: "no-early-collapse up to a horizon" uses `Nat.iter k F z`
  (apply `F`, `k` times, `k` a `nat`), never an unbounded/continuum
  "eventually" quantifier.
- CAN-004: "constitutional ordering" is a `nat`-valued index on a
  12-constructor `Inductive`, never a continuum before/after relation.
- CAN-009: "the past is unwritten" is the list fact `nth_error` is
  unchanged below `length h` after any `list`-append extension, never a
  continuum/irreversible-time axiom.

## `MRC_master.v` — the master equation and per-domain welds

- `master_equation` (Definition): the typed composition of the two
  function-shaped spine segments (CAN-001/CAN-003's stepper `F`,
  CAN-201's readout `O`) into one object on a single finite model.
- `master_equation_is_segment_composition` (Theorem, tier Th_coqc): the
  composition literally equals the sequential application of the two
  spine segments — proved by `reflexivity` (the honest content of the
  claim: there is no hidden step). **Closed under the global context.**
- `DomainReading` (Record) / `weld_holds` (Definition): exactly the
  brief's requested shape, `weld_holds q F F_D := forall s, q (F s) =
  F_D (q s)` — CAN-006's state-transition half specialised to a single
  already-closed stepper argument.
- Five per-domain `Th_coqc` witnesses, each a genuine finite model, never
  a universal claim that every domain reading is admissible:

  | Domain | Carrier | `q_D` | Witness theorem | `Print Assumptions` |
  |---|---|---|---|---|
  | epistemic | `bool * bool` (belief, checked) | `snd` | `CAN_006_epistemic_weld_witness` | Closed under the global context |
  | human–AI | `nat` (turn tally) | `Nat.odd` | `CAN_006_human_ai_weld_witness` | Closed under the global context |
  | social | `Z * Z` (self, other) | `fst - snd` | `CAN_006_social_weld_witness` | Closed under the global context |
  | world-system | `list nat` (sector vector) | `length` | `CAN_006_world_system_weld_witness` | Closed under the global context |
  | method (cross-cutting audit) | `list bool` (per-step checked flag) | `fold_right andb true` | `CAN_006_method_weld_witness` | Closed under the global context |

  Note on carrier choice (recorded, not hidden): the social domain uses
  `Z`, not `Q`, because `weld_holds` states a Leibniz `=`, and `Q`
  arithmetic (`Qplus`/`Qminus`) does not normalise fractions, so a
  genuine algebraic identity on `Q` only holds up to the `Qeq` setoid
  (`==`), not `=`; `Z`'s ring structure is canonical under `=`, so it
  actually discharges this file's `weld_holds` obligation honestly rather
  than requiring a silent restatement of `weld_holds` under `==`.

Total `Theorem` proof obligations in `MRC_master.v`: **6**, every one
`Print Assumptions`-clean.

## CAN ids this family could not formalise

None. All 9 assigned CAN ids (`CAN-002, CAN-201, CAN-001, CAN-003,
CAN-006, CAN-007, CAN-008, CAN-004, CAN-009`) are formalised in
`MRC_root_spine.v`, and the master-equation composition + all five
requested per-domain `DomainReading`/`weld_holds` witnesses are in
`MRC_master.v`. No `Open_*` items were needed for this family — every
spine id's own stated tier (`definition`, `Th_coqc`, `Dr`, `law`) was
achievable as `Definition` and/or a genuinely witnessed `Th_coqc` lemma on
a finite discrete model, per the house discipline already established in
`../coq/MR_Foundation.v` (eq. 5/8's "Definition + witnessed Theorem"
pattern). No tier was upgraded past what CANONICAL.json itself claims —
in particular, CAN-001's "F stepper" half stays exactly at the source's
own "Dr, not independently machine-checked" status: this file adds a
witnessed non-degeneracy fact about *a stepper of the Laplacian-consuming
arrow shape* (fixed after adversarial review: the witness function does
not, and for an arbitrary/possibly-empty `verts`/`W` cannot, actually
depend on the Laplacian's value — the comment on
`CAN_001_laplacian_stepper_can_move_state` now says exactly this, matching
CAN-003's more careful generic phrasing "the one-step stepper genuinely
can change the state" rather than claiming the witness is itself
"Laplacian-driven"), not a proof that the paper's own F is forced by L_R,
and not a claim that a stepper whose *behaviour* actually depends on the
Laplacian's entries is non-idle for every graph.

Two further `domain: "root"` CANONICAL.json ids, CAN-005 and CAN-222, are
excluded from the `spine_ids` family-membership grouping by COLLAPSE.md
(both are readings of CAN-004/CAN-008, not independent root objects) but
still receive their own one-line alias `Definition` each in
`MRC_root_spine.v` (fix for an adversarial-review coverage gap: see the
tag-count note above) — so, counting those two, this file's tagged
identifiers total 11, and the registry-to-corpus map across the whole
`coq_canon/` corpus is now total (253/253 CAN ids tagged exactly once, 0
duplicates, 0 extras).
