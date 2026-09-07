# Equation code scheme — Human–AI Readout Programme equation library (HRP)

**Builds on what already exists (founder rule BBL-181): no new numbering where one exists.**

## Existing systems reused
| System | Where | What it gives us |
|---|---|---|
| Readout Genesis Appendix C "SM domain equation stream" | `readout_genesis/READOUT_GENESIS_CORE.md` (SOT), mirrored in the solver arc's root→SM equation stream file (private) | root codes `EQ-001 … EQ-071` with tier tags |
| Readout Genesis named results | same file | ids `weld`, `MQ.08`, `Forced.I…XXIV`, `Face.1…12`, `N1…N5`, `VI.1…VI.8`, `T0…T2`, `RD1…RD9` |
| Equation Registry (owner/year at first use) | `solver arc: docs/root/EQUATION_REGISTRY.md (private)` | rule: any imported equation is registered with owner + year at first use — the library carries `external_owner_year` and cites that registry |
| Equivalence Registry design | `solver arc: docs/design/EQUIVALENCE_REGISTRY_DESIGN.md, data/equivalence_registry.yaml (private) | the merge criterion: A ≡ B iff a documented bijective φ of (i) renaming, (ii) fixed positive scale, (iii) fixed constant substitution gives A(x)=B(φ(x)) on the shared domain — no limits, no approximations; otherwise `same_form_different_theory`, `special_case_of`, or (ours) `reads` |
| Domain Registration Standard | `readout_genesis/domains/DOMAIN_REGISTRATION_STANDARD.md` | a domain is a quotient/readout `q_D` of the one root, never a new root; claim boundary per domain |

## Layer 0 — root codes (Readout Genesis, verbatim)
`code` = the Genesis identifier as written: `EQ-0nn` when the object is in the Appendix C stream, else the named id
(`MQ.08`, `Forced.XII`, `Face.10`, `N2`, `VI.3`, `T1`, `RD4`, `weld`). Never prefixed, never renumbered. `aliases` lists any
second id the same object carries. Registry: `genesis_root.json` (git commit + blob anchors; deposited form = Standalone
Synthesis 10.5281/zenodo.21529456).

## Layer 1 — readings (domain translations)
`<root code>/<D>.<nn>.v<k>` — the same root equation read through a domain readout q_D (Domain Registration Standard):
`<D>` ∈ E epistemic · H human–AI · S social · W world-system · M method · P physics · C chemistry · B biology/health (BIRCA health equations are B readings of the root); `<nn>` sequence under that root (assigned once, never
reused); `.v<k>` revision of the canonical statement. Example `MQ.08/H.02`. A reading of a composite names the primary root and
lists `reads_also`. Genuinely rootless objects: `HRP-X.<nnn>` + drift note (target: none).

## Merge rule (canonicalisation)
Two raw equations are ONE object only under the Equivalence Registry φ-criterion above (renaming / positive scale / constant
substitution, exact). Otherwise they are related, never merged: `same_form_different_theory`, `special_case_of`, `refines`, `reads`.
The latest formulation is the canonical statement; sources are never edited; occurrences `<record_id>#<label>` map to one code.

## Lineage (permanent library, BBL-179)
Every code has a lineage log in `LINEAGE.jsonl`: `{code, date, event: assigned|revised|retired|merged|split, from, to, reason, by}`.
A retired code stays forever with its successor. A revision of the statement bumps `.v<k>` and appends an event; mapping a new
occurrence appends `occurrence_added`. No silent edits.

## Coq (BBL-182)
File name = code: `EQ-012.v`, `MQ.08.v` → for filesystem safety dots and slashes map to `_`: `MQ_08.v`, `MQ_08__H_02.v`
(`/`→`__`, `.`→`_`); the exact code is repeated in the header comment. One identifier per code inside.

## Where codes live
Source of truth: `genesis_root.json`, `CANONICAL.json` (`code`), `LINEAGE.jsonl`, `CANONICAL_REGISTRY.json` (Coq ids). Generated
views: `EQ_LIBRARY.md`, Master Equation River Appendix C, textbook Appendix F. Deposit: the library's own Zenodo dataset record
(versioned; BBL-178), linked to Master River and the Coq record.

## Addendum, 2026-09-07 (v1.0.0 release) — domain letters, two more statuses, mangling fix

**1. The 8-letter domain set is final for v1.0.0.** Ruled same-day as the skeleton, commit
`7c2c1c1` ("scheme: 8 domain letters incl. B = biology/health"): `<D>` ∈ `{E, H, S, W, M, P, C,
B}` — epistemic, human–AI, social, world-system, method, physics, chemistry, biology/health.
`B` carries the BIRCA health-stream equations as `B` readings of their root; no ninth letter is
open. `registry/CANONICAL.json`'s `domain` enum and `registry/SCHEMA.md`'s code grammar already
state this set; this addendum is the dated record that it is a settled ruling, not a draft.

**2. Two additional `status` values, introduced at N4 (commit `988141d`, founder ruling
2026-09-06 22:20, `registry/split_proposal_SW.json`).** `registry/SCHEMA.md`'s original T1 status
enum (`current | superseded_by | historical | unverified | imprecise_as_stated`) did not yet
carry these; both are now live in `registry/CANONICAL.json` and must be read as part of the T2
status vocabulary:

- **`split`** — a raw record that bundled more than one distinct mathematical object under one
  code (found by re-reading the source quote, not merged under the φ-criterion). Retired with
  `status_note` quoting the distinct objects found and `children[]` listing the codes each
  member was split into. Example: `weld/S.01.v1` was split into 17 children after its source was
  found to state a continuum PDE model and a discrete PAR-stepper model as two different objects
  under one label.
- **`not_an_equation`** (T2) — a raw record whose only occurrence is prose (a claim, a
  definition, a proposition) with no operator at all. Kept as a coded pointer to its source
  (never presented as a formula), with `status_note` quoting the prose and, where relevant, the
  finding that a prior build had misattributed a formula to it. Example: `weld/S.06.v1`.

Both statuses inherit the same rule as every other non-`current` status: `status_note` is
required and non-empty. `registry/SCHEMA.md`'s `status` enum should read
`current | superseded_by | split | not_an_equation | historical | unverified |
imprecise_as_stated` from this date forward.

**3. Coq mangling rule, corrected.** The mangling line above (`/`→`__`, `.`→`_`) was written
before most `EQ-0nn` root codes existed in the registry and predates the hyphen they carry. The
rule actually implemented from the start in every mangling script
(`scripts/bbl182_split_coq.py`, `scripts/n4_coq_split.py`, `scripts/n4_coq_verify_update.py`,
`scripts/n4_merge.py`) — and now stated here to match — also maps `-`→`_`, because a Coq module
identifier cannot contain a hyphen:

```
code.replace('/', '__').replace('.', '_').replace('-', '_')
```

`EQ-015/M.01.v1` → `EQ_015__M_01_v1.v`. This mangling is Coq-filename-only; the docs-site URL
path (`site/<code>/index.html`) keeps the code's own literal characters (`/`, `.`, `-` are all
valid URL path-segment characters) and is unaffected.

## Root registry extension R1 (2026-09-07, founder ruling BBL-2026-09-07-207)

**Layer 0 roots may come from a founder-ruled root extension, not only from
`READOUT_GENESIS_CORE.md`/the whitepaper — with their own ids kept verbatim,
exactly like every other root code in this scheme.** Ruled by the founder,
2026-09-07 (relayed in `ops/HANDOFF_OVERNIGHT_2026-09-06.md`,
BBL-2026-09-07-207): the Theta programme and Causal-Memory Closure (CMC) are
added as roots and connected into the lineage. Full sourcing, quotes, and the
relation evidence live in `registry/GENESIS_CODE_SCHEME.md`'s own dated
addendum of the same name and on the `Theta`/`CMC` rows of
`registry/genesis_root.json`; this addendum states only the code-scheme
consequences.

**Roots added:**

| code | what it is | anchor | connects to (source-quoted) |
|---|---|---|---|
| `Theta` | living/relational-geometry root state | public `readout_genesis`@`082dde893b70c7500c13d463239909c99cf17f0a`, `formal/InfoThetaEdgeCensus_attempt.v` + 9 more `.v` files | `EQ-008` (reuses its forced admissibility characterization), `EQ-022` (Theta is `G[Theta_n]` inside EQ-022's own reader/record recurrence) |
| `CMC` | Causal-Memory Closure — a disclosed founder-level bridge axiom | "solver arc (private)"@`961151db33b0491cba8fabade69f594238d33f84`, `formal/CMC_TargetClass_Definitions.v` + 5 more `.v` files | none stated in any source text (checked, per `registry/root_candidates_report.md`) — `relations: []`, recorded rather than guessed |

**Readings added under these roots (Layer 1, same `<root>/<D>.<nn>.v1` grammar
as every other root):** every coq_map.json-listed identifier in the ten
Theta/CP files (86) and six CMC files (33) — 119 readings total, added by
`scripts/v12_R.py`. Domain letter: `P` for all Theta readings and for the one
CMC file whose own name and header declare it a physics layer
(`CMC_PhysicsClass_Instances.v`); `M` (method) for CMC's other five files, per
this scheme's own domain-letter rule ("a domain is a quotient/readout of the
one root") applied to the source's own stated subject matter. `statement`
carries `format: "coq"` — the literal Coq declaration, not a transliteration —
since no other verbatim form was available without inventing one. `tier` is
derived from `registry/coq_map.json`'s own recorded verification status
(itself copied from `coq/verify_all.sh`'s Print Assumptions output, per
`registry/SCHEMA.md`'s existing convention for the `assumptions` field): a
`Definition`/`Fixpoint`/`Inductive` declaration is tiered `Definition`; a
proved result with status `"Closed under the global context"` is tiered
`Th_coqc`; a proved result that itself names a disclosed axiom dependency
(3 of the 119 — `cmc_no_refuter_under_axioms`, `decomposed_bridge_obligation`,
`decomposed_no_refuter`, each depending on `cmc_bridge_axiom` and/or three
further named obligations) is tiered `Ax`, never above what that dependency
list says. `coq.coq_status` is `"mapped_not_wrapped"` for all 119 — matching
`registry/SCHEMA.md`'s own definition of that value (an evidence-backed
`coq_map.json` match with no Toledo-native wrapper file yet) — wrapping these
into `coq/canonical/` files is left to a later lane, same as the other 210
`mapped_not_wrapped`/`wrapped_related` entries already carried over from
v1.1. `registry/coq_map.json`'s own `codes[]` was updated for all 119 rows to
cite the new reading codes, by evidence (file+identifier match against the
same source line the reading's statement was copied from).
