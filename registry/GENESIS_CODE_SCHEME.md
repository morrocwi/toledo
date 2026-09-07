# Genesis Root Equation Registry — Code Scheme

**Corrected per founder ruling (relayed 2026-09-06): do not invent a new numbering
on top of an identifier scheme Readout Genesis already carries.** The `code`
field in `genesis_root.json` is the equation's OWN identifier, verbatim, never
a re-prefixed or re-sequenced one:

- **If the equation is part of Appendix C's "SM DOMAIN EQUATION STREAM — INFO
  CORE UNIFICATION" (`READOUT_GENESIS_CORE.md`, lines ~7233–7597, `EQ-001` …
  `EQ-071`), the code is that `EQ-0nn` id.** This is the founder-designated
  Source of Truth for that stream's numbering/tiers/text (stated explicitly in
  the Appendix C preamble: "THIS Appendix is now the primary Source of Truth
  for this equation stream's numbering/tiers/text" — the synced mirrors at
  solver arc (private)'s `EQUATION_LIBRARY_ROOT_TO_SM_STREAM.md` and a
  same-purpose file in the public `readout_universe` repo (that second file's
  own name embeds the solver arc's real repo name — a pre-existing leak in
  that public repo, out of this registry's scope to reproduce or fix, so not
  repeated here) must match it, not the reverse). `EQ-001`–`EQ-014` restate
  ROOT-0's own
  `E00.1`–`E00.7` and the I.1a resource-logic-floor equations; `EQ-015`–`EQ-017`
  restate the Part II spine/`λ_c` equations; the rest carry the Part V.13a /
  V.20–V.22 Standard-Model-domain stream. `EQ-069`–`EQ-071` are RETRACTED
  (2026-07-26, continuum contamination) — kept in the registry with
  `tier_in_genesis: "RETRACTED"`, never deleted, per the source's own
  instruction that the numbers stay reserved so the correction is visible.
- **Otherwise, the code is the Genesis document's own other identifier, exactly
  as written** — `weld`, `Forced.I`…`Forced.XXIV`, `Face.1`…`Face.12`, `MQ.08`,
  `N1`…`N5`, `VI.1`…`VI.8`, `T0`/`T1`/`T1b`/`T2`, a Gate name (`Gate.4`), a
  whitepaper section anchor (`WP.S4.3` for whitepaper §4.3), etc. No `RG-`
  prefix, no Part-tag prefix, no invented sequence number. Where the source
  names an item only by an unlabeled bullet or heading (no numeral/tag of its
  own), the code is a short slug drawn from that heading (e.g. `RD-unit`,
  `CopyLicence`, `ExactDomainGate`) — still not a sequence number.

## `aliases`

Every other identifier the SAME equation carries anywhere in the two source
documents (or in the founder-cited RD1–RD9 / root-axiom naming, where it
differs from the `E00.x` labels actually printed in `READOUT_GENESIS_CORE.md`)
goes in an `aliases` array on that one row — the object gets ONE row in this
registry, not a duplicate row per place it is reprinted. Example: the object
whose Appendix C code is `EQ-008` (`L_R := D_W − W`) carries `aliases:
["E00.7", "weld"]` because the same line is Part I's `E00.7` and a component of
the one-line master weld. Where the founder's own shorthand `RD1`–`RD9` cannot
be matched to a specific printed root-axiom line with confidence, that
uncertainty is recorded in the registry-build report rather than guessed into
an alias.

## `section`

The markdown heading path where the equation is presented in its primary
(most complete) location — e.g. `"PART I — ROOT AXIOMS > I.1 The Primordial
Root > E00.7"`, or `"APPENDIX C (SM DOMAIN EQUATION STREAM) > EQ-021"`.

## `tier_in_genesis`

Copied **verbatim** from whatever bracketed/inline tag the source attaches
(`[Ax]`, `[Th]`, `[Ax→Th]`, `[Ax/Th]`, `Th_coqc`, `finite_diagnostic`, `Dr`,
`Open`/`[Open]`, `PROPOSED`, `fit_calibrated`, `declared_finite_architecture`,
`RETRACTED`, a Type-P/Type-U gate-law tag) — never normalized into a smaller
fixed enum. `"untagged"` when the source states the item with no tier marker
at all (most whitepaper architecture/interface equations carry no Genesis tier
tag, since the whitepaper is the universal-architecture layer, not the physics
claim layer).

## `external_owner_year` (optional field)

Present only when Genesis's own text marks the equation as importing a named
result from outside the project (a physics law, a classical theorem). Value
is the owner(s) and year exactly as solver arc (private)'s `docs/root/
EQUATION_REGISTRY.md` records them for that same result (e.g. `"E. Schrödinger,
1926"`, `"A. Einstein, 1915"`). Omitted (not `null`) when the equation is the
project's own content or when no matching registry row was found with
confidence — a missing field means "not checked/not found," never "confirmed
native."

## `.v` (optional field, keyed `coq_file`)

Present only when Genesis's own text names a specific Coq artifact
(`formal/*.v`) as already proving the equation (e.g.
`InfoRetentionMetricSkewDecomposition_attempt.v` for T1,
`InfoTrueRecordUnreadable_attempt.v` for the two Appendix-C entries it names).
Omitted when no `.v` file is named in the text at that equation's location.

## Build notes (as actually applied, 2026-09-06)

The registry was built by parallel section-by-section extraction (one pass per
Part of `READOUT_GENESIS_CORE.md`, one pass per half of the whitepaper), then
merged by hand with the following curated, content-verified folds (not a blind
string match — each fold below was checked against the actual quoted text
before merging):

- Root axioms `E00.1`–`E00.7`, the I.1a resource-logic-floor equations
  (`RD-unit`, `Enc_Ω`, `Dec_Ω`, the resource-logic judgment, the copy licence),
  the II.3 spine PDE, the II.7 `λ_c` discriminant, the II.8 RTPE reduced form,
  and the II.8a DRL two-field apparatus's four core equations — all of which
  Appendix C's own preamble states are "already stated earlier in this file;
  repeated here only as the entry point of the continuous numbered stream" —
  were folded into their `EQ-0nn` row as verified-identical restatements, with
  every other location they appear (Part VI's `N1`, `N2`, `N4`; the "Three
  Stacked Layers" repeated near-verbatim in Parts II/III/IV/VI; Face 10's
  record-genesis and canon-record lines; the bR-ledger conservation identity)
  recorded in that `EQ-0nn` row's `aliases` array with its own location noted.
- `N3` and `N5` (of the Five Irreducible Equations) are **not** in the
  Appendix-C stream and keep their own bare codes (`N3`, `N5`).
- A handful of items that are genuinely the SAME content in two different
  Parts but NOT part of the `EQ-0nn` stream (e.g. the LP-NS-audit "Layer 3"
  checker description repeated in Part III and Part IV) were folded into one
  row with an `aliases` note the same way.
- Four accidental code collisions after prefix-stripping (`Layer.3` doubled —
  folded per above; `FailAbleGateLaw` doubled, from V.14 and VI.7, genuinely
  two separate statements of the law in two Parts — disambiguated as
  `V.14.FailAbleGateLaw` / `VI.7.FailAbleGateLaw`; `B.1`/`B.3` doubled, from
  Part VI-A's own B.1–B.8 numbering versus Appendix B's own unrelated B.1–B.3
  numbering — the Appendix B ones were disambiguated as `APP-B.1`/`APP-B.3`
  matching how the source itself labels them, "APP-B.1", "APP-B.3").
- **Open item, flagged rather than guessed:** the founder's shorthand
  `RD1`–`RD9` for the root axioms does not appear verbatim anywhere in either
  source file (confirmed by direct grep of both files) — the text's own root-
  axiom tags are `E00.1`–`E00.7` (`ROOT-0`). This registry uses `E00.1`–`E00.7`
  as the codes (the actual verbatim text) rather than guessing an `RD1`–`RD9`
  mapping that cannot be confirmed against the source; if `RD1`–`RD9` is a
  live external naming convention (e.g. from the solver arc, private),
  reconciling it against `E00.1`–`E00.7` is a follow-up, not something this
  build invented a mapping for.
- Sub-equations within one named unit that carries only ONE tag in the source
  (a Face, a `B.x` process step) but states several distinct equations use a
  slug appended to that unit's own tag (e.g. `Face.10.StrictGap`,
  `Face.10.bRLedger` — both genuinely under Face 10, genuinely different
  equations) — this is the scheme's own documented fallback ("a short slug
  drawn from the item's own heading"), not an invented sequence number.

## Anchor

See `genesis_root.json["anchor"]` for the exact commit and blob hashes this
registry was built from (`readout_genesis` repo, files
`READOUT_GENESIS_CORE.md` and
`READOUT_GENESIS_UNIVERSAL_TECHNICAL_WHITEPAPER_v1.2.0.md`).

## Root registry extension R1 (2026-09-07, founder ruling BBL-2026-09-07-207)

**Roots may also come from a founder-ruled root extension, sourced outside the
two anchored Genesis documents above, using that extension's own identifiers
verbatim — the same "no invented numbering" discipline this file already
applies to `READOUT_GENESIS_CORE.md`, extended to a second kind of source.**

The founder ruled (2026-09-07, relayed in
`ops/HANDOFF_OVERNIGHT_2026-09-06.md`, "2026-09-07 09:10 — founder rulings →
v1.2.0", BBL-2026-09-07-207): *"โปรแกรม Theta และ CMC ขยายรากให้จบ ให้ต่อกัน"*
— extend the root registry with the Theta programme and Causal-Memory
Closure (CMC) as roots, connected to the existing Genesis roots wherever a
source states the connection. `scripts/v12_R.py` (Toledo v1.2 Lane R) applied
this ruling; the two rows it added to `root_equations` are:

- **`Theta`** — the living/relational-geometry root state. Code is the
  identifier the source itself uses verbatim (`Theta`, capitalised, as used
  throughout the imported files and the founder's own 2026-08-08 ruling
  quoted in their header comments); alias `THETA_ROOT_PROGRAM` (the
  companion document's own name, cited but not itself copied into this
  tree). Anchor: public repo `readout_genesis`, commit
  `082dde893b70c7500c13d463239909c99cf17f0a`,
  `formal/InfoThetaEdgeCensus_attempt.v` (+ 8 further `InfoTheta*_attempt.v`
  files and `InfoCPEquivariantGenerationBound_attempt.v`, all already
  imported under `coq/readout_genesis/formal/` by the earlier S7 lane).
  Connected to Genesis roots `EQ-008` and `EQ-022` — quoted evidence for both
  links is recorded on the `Theta` row's own `relations[]` in
  `genesis_root.json`, not asserted here.
- **`CMC`** (Causal-Memory Closure) — code is the abbreviation the source
  files themselves use throughout (`CMC_TargetClass`, `CMC_Bridge_Obligation`,
  `cmc_bridge_axiom`, `CMC_Refuter_Burden`). Anchor: "solver arc (private)",
  commit `961151db33b0491cba8fabade69f594238d33f84`,
  `formal/CMC_TargetClass_Definitions.v` (+ 5 further `CMC_*.v` files, already
  imported under `coq/solver-arc/formal/` by the earlier S7 lane, per
  `DEC-toledo-solver-arc-copy-2026-0906`). `registry/root_candidates_report.md`
  already checked this root for a stated connection to Genesis's own
  `EQ-005`/`EQ-006`/`EQ-007` and found none stated explicitly in any source
  text — so the `CMC` row's `relations[]` is `[]`, with a `relations_note`
  quoting that finding rather than asserting the link.

Both rows carry `role: "root-extension"` (not `root-axiom`), an `origin{}`
object (this file's own root rows otherwise rely on the single top-level
`genesis_root.json["anchor"]`, which does not cover a second source), and a
`step: null` with a `step_note` explaining that neither root is invented a
position in `READOUT_GENESIS_CORE.md`'s own step-by-step ordering (BBL-192/
193) — both are downstream of that document, not part of it. Every equation/
named theorem in the imported files (86 for Theta, 33 for CMC) was added as a
`<root>/<D>.<nn>.v1` reading in `registry/CANONICAL.json` under these two
roots (`D=P` for Theta and for CMC's one explicitly physics-labelled file,
`CMC_PhysicsClass_Instances.v`; `D=M` for CMC's other five files), `coq_status
"mapped_not_wrapped"` — see `docs/EQ_CODE_SCHEME.md`'s own addendum for the
per-reading rules applied.

## Root registry extension R2 (2026-09-08, information-discrete-math)

**A third source of roots, same discipline as R1 above: no invented
numbering, codes = the source's own identifiers verbatim.** Founder ruling
(2026-09-08, relayed in `ops/HANDOFF_OVERNIGHT_2026-09-06.md`, "2026-09-08 —
Resistance ladder + Reproduction Ledger (founder ruling BBL-229)" section,
context BBL-2026-09-07-229): *"เอา idm เอาเข้า toledo ก่อน และใน idm
ให้อัพเดทรหัสสมการให้ตรงกับ toledo, ultracode"* — take
`information-discrete-math` (IDM, public, `https://github.com/morrocwi/
information-discrete-math`, MIT, commit `147fc92671f35eb102405fec913eb361dc41f966`)
into Toledo first, using the same root-extension mechanism R1 already
established; IDM's own repo then gets updated to carry the codes Toledo
assigns it (a separate, later lane — this addendum covers the Toledo-side
registration only). `scripts/v16_idm_merge.py` applied this ruling, merging
`registry/proposals/idm.json` (the extractor's own proposal, built directly
from `textbook/INFORMATION_DISCRETE_MATHEMATICS.md`, `THEOREM.md`,
`formal/*.v` headers, `README.md`, `plugins/*/SKILL.md`, `API.md`, and the
274/274-closed mirror already imported at
`coq/information-discrete-math/PROVENANCE.json` +
`coq/information-discrete-math/verify_report.json`).

**18 roots added** — every one of IDM's own Layer-0 objects, code = IDM's own
verbatim id, never re-prefixed:

| code | what it is (IDM's own name) | tier (IDM's own tag) |
|---|---|---|
| `delta_R` | the primitive — a retained difference exists (Def 2.1) | `Dr` → `Th_coqc` realization |
| `RD1`…`RD9` | Axioms of Retained Difference (Ax-RD1…RD9): ground `0`, `succ`, `succ n ≠ 0`, injectivity, induction, and (bundled under one source bullet, RD6) the `⊕`/`⊗`/`≺` recursion clauses | `Ax` |
| `D` | the naturals — the retained-difference engine generated by RD1–RD9 | `Th_coqc` |
| `Z` | the integers — Grothendieck completion of `D` | `Th_coqc` |
| `Q` | the rationals — field of fractions of `Z` | `Th_coqc` |
| `R` | the reals — the continuum AS a readout (Bishop regular Cauchy sequences of `Q`) | `Th_coqc, axiom-free unless noted` |
| `L_R` | the relation graph and the operator `L_R` (`=D_W−W`) | `Th_coqc` |
| `Keystone` | `B(Φ,Φ) = I(Φ)` — the retained-information density identity | `Th_coqc` |
| `A2` | FOLD (the engine) — the generic accumulation `I_⊕[f](N) = ⨁_{k<N} f[k]` | `Th_coqc` |
| `A3` | DECISION (the search) — `P(X) ⇔ ∃ w finite: check(X,w)=⊤` | `Th_coqc` |

**Connection to Genesis, by quote only — never guessed:** the proposal's own
`phi_check` found exactly 3 quoted textual links (`genesis_relations_asserted:
3`), and only those 3 roots carry the linked code as a real `parents` entry
(mirroring how R1's `Theta` row mirrors its `relations` into `parents`):
`delta_R` → `EQ-001` (both are primordial-first-distinction existence claims,
quoted both sides — evidence on the `delta_R` row's own `relations[]`); `L_R`
→ `EQ-008` and `Keystone` → `EQ-008` (both state the identical retained
graph-Laplacian object `L_R = D_W − W`, quoted both sides). The other 15 roots
(`RD1`–`RD9`, `D`, `Z`, `Q`, `R`, `A2`, `A3`) carry `parents: []` with
`relations: []` and a non-empty `relations_note` — the same disclosed-
non-finding exemption R1's `CMC` row already uses
(`tests/test_registry.py::_root_orphan_exempt`):

- **`RD1`–`RD9`**: not re-checked from scratch — IDM's own treatise states
  its RD1–RD9 are "the exact same RD1–RD9" as the solver-arc/`readout_universe`
  `RD.v` mirror (`information-discrete-math/textbook/
  INFORMATION_DISCRETE_MATHEMATICS.md`, lines 799–800, 1071–1072: "the exact
  same RD1–RD9 that generate `D` (Part II) are the shared root of both
  repos"), and `registry/rd_root_map.json` had *already* adversarially
  checked that exact mirror against every Genesis root row and found
  `NOT_SAME_OBJECT` for all nine (a from-scratch Peano/natural-number
  construction — `D : Type` with `zero`/`succ`/`add`/`mul` — versus Genesis's
  physical/epistemic root axioms `E00.1`–`E00.7`/`EQ-001`–`EQ-008`, no
  renaming/scale/constant-substitution bijection relates them). By IDM's own
  claim of identity with the checked mirror, that finding transfers rather
  than being redone; each `RD*` row's `relations_note` quotes its own
  `rd_root_map.json` entry directly.
- **`D`, `Z`, `Q`, `R`, `A2`, `A3`**: `GENESIS_CODE_SCHEME.md` (this file) and
  `genesis_root.json`'s 592 pre-existing rows were checked directly; no
  source text (IDM's own or either of Genesis's two anchored documents)
  states a connection for these six, so none is invented — `relations_note`
  records the check, per the same convention.

**274 readings added under these 10 code-bearing roots** (`RD1`–`RD9` besides
`RD3` carry no readings of their own — every mirrored Coq identifier that
cites an `RD*` axiom directly resolves to the root `D` it generates, per the
extractor's own `by_root` breakdown: `R` 40 · `D` 80 · `Z` 23 · `L_R` 28 ·
`delta_R` 11 · `Q` 19 · `Keystone` 30 · `RD3` 1 · `A2` 28 · `A3` 14 = 274),
one per identifier in the 274/274-closed
`coq/information-discrete-math/verify_report.json` mirror, `<root>/<D>.<nn>.v1`
grammar, domain `P`/`M` per the source file's own subject matter, `tier
Th_coqc` (never above `verify_report.json`'s own "Closed under the global
context"), `coq.coq_status "mapped_not_wrapped"` — same honest middle state
as R1's 119 Theta/CMC readings (wrapping into `coq/canonical/` files left to
a later lane). `registry/coq_map.json`'s own `codes[]` was updated for all
274 rows, by evidence (file+identifier match against the same source line
the reading's statement was copied from).
