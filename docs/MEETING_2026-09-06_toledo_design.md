> Terminology note (2026-09-07): the judge-scoring axis originally labelled with a comparative term was renamed `design_quality` throughout this record; the scores and their meaning are unchanged.

# บันทึกการประชุมออกแบบ Toledo — 2026-09-06 (คืน N2)
# MEETING RECORD — Toledo design meeting, 2026-09-06 (overnight, N2)

## 0. ที่มา / Provenance

การประชุมนี้เป็นส่วนหนึ่งของ BBL-188 (งานอัตโนมัติข้ามคืน). ผู้เสนอ 3 คน — REGISTRAR (schema/code
grammar/root-parent/dedup), FORMALISER (นำเข้า Coq/การตั้งชื่อ/verification), LIBRARIAN (การนำเสนอ/
findability/release) — เสนอแบบคนละชุด แล้วให้ผู้ตัดสิน 2 ชุด (แต่ละชุดให้คะแนน design_quality /
constraint_fidelity / feasibility / verified ต่อข้อเสนอ พร้อม cross_conflicts และ missing) ตรวจสอบ
อิสระ 2 รอบ. เลขาการประชุม (secretary agent) เป็นผู้รวมข้อเสนอ+คำตัดสินเป็นมติที่นี่ — ไม่ใช่ผู้ตัดสินเอง;
ทุก DECISION ด้านล่างอ้างอิงข้อเสนอต้นทาง + ฉันทามติ/ข้อขัดแย้งที่ผู้ตัดสินชี้ไว้.

This meeting is part of BBL-188 (overnight autonomous work). Three proposers — REGISTRAR (schema /
code grammar / root-parent rule / dedup), FORMALISER (Coq import, naming, verification), LIBRARIAN
(presentation, findability, release) — each drafted an independent design; two judge passes scored
every proposal (design_quality / constraint_fidelity / feasibility / verified) and logged cross-proposal
conflicts and gaps independently. This secretary record merges the three proposals plus both judge
passes into ruled decisions — it does not re-judge; every decision below cites its source proposal and
the judges' consensus or dispute.

**Chair:** Fable (orchestrator). **Proposers:** REGISTRAR, FORMALISER, LIBRARIAN. **Judges:** J1, J2
(two independent scoring passes over the same three proposals).

---

## 1. ข้อเท็จจริงที่ยืนยันแล้ว (คำสั่งเป็นหลักฐาน) / Verified facts (command-backed)

ทุกแถวคือ readout จากคำสั่งจริงที่รันในการประชุมนี้ (2026-09-06), ไม่ใช่จากความจำ — ปรัชญา
readout-not-truth บังคับให้ตรวจนับจากไฟล์เสมอ.

| # | Fact | Command / source | Result |
|---|---|---|---|
| 1 | `registry/genesis_root.json` root rows | `python3 -c "len(json.load(open(...))['root_equations'])"` | **590**, all `code` unique (`len(set(codes))==590`) |
| 2 | Root codes matching `EQ-0\d\d` | filter on `code` prefix | **71** (`EQ-001`…`EQ-071`) |
| 3 | RETRACTED root rows | filter `tier_in_genesis=='RETRACTED'` | `['EQ-069','EQ-070','EQ-071']`, kept (not deleted) |
| 4 | Raw inventory chapters | `ls registry/eq_*.json \| wc -l` | **40** |
| 5 | Raw equations total | sum of `equations[]` across the 40 files | **946** |
| 6 | `registry/CANONICAL.json` | `ls` | **does not exist yet** — `test_registry.py` and `build_eq_library.py` both already guard for its absence |
| 7 | `tests/test_registry.py` | read in full | exactly **3** tests: raw-inventory-loads, canonical-codes-unique-and-mapped (no-op while CANONICAL.json absent), lineage-shape (no-op while LINEAGE.jsonl absent) |
| 8 | `pytest -q tests` | run | **3 passed** |
| 9 | `coq/master-river/` | `ls` | **10** `MR_*.v` files + `verify.sh` + `_CoqProject` + `MR_Ledger.md`; `verify.sh` classifies PASS only on the literal string `Closed under the global context` |
| 10 | `coqc --version` | run | 8.20.1, at `/usr/bin/coqc` |
| 11 | Public Coq import sources (`.v` counts) | `find <repo> -name '*.v' \| wc -l` | readout_genesis: **13** (`formal/`) + **26** (`domains/`) = 39; readout_universe: **14**; information-discrete-math: **27**; zero-readout-certifies: **4**; finite-readout-acceleration: **1** — total **85** |
| 12 | Genesis domain rule registries | read each `RULE_REGISTRY*.json`'s `rules`/`gates` arrays | chem **17**, quantum **33** (+14 gates), relativity **38**, biology **36** (+6 gates) — rule totals sum to **124**, matching BBL-189 |
| 13 | `MQ.08` as a root row | search all 590 rows for `MQ.08`/`MQ08` | **not a standalone top-level code** — it is an alias on `EQ-015` ("Universal spine PDE") and named in the statement/name text of `weld`, `InverseArrow`, `MQ08-stepper`, `MQ08-CFL`, `MasterEqCanon`, `step11`, `step12` |
| 14 | `EQ-008` aliases | read row | `["E00.7-operator", "weld", "RG-I.E00.7=..."]` — i.e. `EQ-008` already claims `weld` as an alias |
| 15 | `weld` as its own row | read row | exists separately, `aliases: []`, statement stages `δ_R ⊢[Th_coqc] L_R ⊢[Dr] F (MQ.08 stepper) ≡ {q_D:...}` — a candidate φ-criterion merge target against `EQ-008`, not yet resolved |
| 16 | Domain-letter set, two founder-facing docs | read `docs/EQ_CODE_SCHEME.md` line 22 vs `docs/HANDOFF_OVERNIGHT_2026-09-06.md` line 13 | **mismatch**: EQ_CODE_SCHEME.md defines `D ∈ {E,H,S,W,M}` (5 letters); the handoff's definition-of-done #2 requires `D ∈ {E,H,S,W,M,P,C,B}` (8 letters) for the domain-registry scope |
| 17 | `build_eq_library.py` code generator | read script in full | contains a live `HRP-EQ-<D>.<nnn>.v1` auto-numbering fallback (`if not c.get('code'): ... c['code']=f"HRP-EQ-{d}.{counters[d]:03d}.v1"`) that **contradicts** `registry/GENESIS_CODE_SCHEME.md`'s founder-corrected rule (reuse Genesis ids verbatim, never invent a new sequence) |
| 18 | LaTeX toolchain for the catalogue PDF | `which`/`kpsewhich` | `/usr/bin/lualatex`, `/usr/bin/latexmk` present; `fontspec.sty`, `longtable.sty`, `hyperref.sty` all resolve via `kpsewhich` |
| 19 | RAM headroom (this session) | `free -g` | 14 GB total / 2 GB free / **9 GB available** — above the ≤3–4-worker / ≥2 GB-available floor |
| 20 | Repo git/licence state | `git log`, `git remote -v`, `cat LICENSE`, `ls .github` | origin `github.com/morrocwi/toledo.git`; 9 commits, most recent already scrubs private repo names (`156394f public-readiness: private repo names scrubbed`); `LICENSE` = CC BY 4.0 (registries/docs) + MIT (`coq/`, `scripts/`); **no `.github/` directory yet** — CI/Pages workflows are new, not rewrites |
| 21 | `CITATION.cff` | read in full | anchors concept DOI `10.5281/zenodo.22537318` (v0.1.0 = `22537319`); no `identifiers:` array yet |

The solver arc's own file counts (334 `.v` under `formal/`, 284 `*_attempt.v`, 50 canonical; four
disclosed axioms in its `AXIOM_STATUS.md`; a proprietary "ALL RIGHTS RESERVED" `LICENSE`) are carried
into this record **as reported by the proposers**, re-stated here without the repo's real name per the
standing constraint — this record does not itself open that private repository. Whoever runs N4/N5
must re-verify those counts directly and record the command output in `registry/COQ_IMPORTS.json`'s
`PROVENANCE.json`, not copy the number from this meeting record.

---

## 2. DECISIONS

Each decision states the ruling, its rationale, the source proposal(s), judge consensus, any
dispute, and a cost note. Where the three proposers disagreed (three incompatible schema shapes was
the headline conflict both judge passes flagged), this section rules **one** answer — the ruled shape
below is not a fourth invention; it is REGISTRAR's D3 field set (the most complete against the task's
own field list) laid out as ONE `CANONICAL.json` document instead of REGISTRAR's `registry/entries/`
one-file-per-code split, because both judge passes flagged the file-count/PR-diff-noise cost of the
split without any proposer weighing it against the alternative, and `README.md`/`EQ_CODE_SCHEME.md`
(already public, already committed) name `CANONICAL.json` as the one artifact holding "every distinct
equation object" — a per-code file layout would contradict text already shipped.

### T1 — Schema: one `CANONICAL.json`, one entry shape at every layer

**Decision.** `registry/CANONICAL.json` is a single JSON document:
```json
{
  "schema_version": "1.0.0",
  "generated_from_commit": "<toledo git sha at build time>",
  "canonical": [ <entry>, ... ],
  "raw_to_canonical": {"<record_id>:<label>": "<code>"}
}
```
Every object under `canonical[]` — a Layer-0 root, a Layer-1 reading, an imported-Coq-only object, a
domain-rule object — uses the **same** entry shape (fields below), populated differently by layer.
This is what makes "every code, roots included, traces to the root" (BBL-191/192) one graph-closure
property checkable by one validator, not two schemas for two layers.

Entry fields (all present, `null`/`[]` when empty, so every entry diffs cleanly):
```json
{
  "id": "CAN-000001",
  "code": "MQ.08/H.02.v1",
  "root": "MQ.08",
  "layer": "root | reading | coq_import | rule",
  "domain": null,
  "aliases": [],
  "name": "",
  "statement": {"latest": "", "format": "ascii-math | latex | coq"},
  "statements_history": [{"v": 1, "statement": "", "date": "YYYY-MM-DD", "reason": "", "by": ""}],
  "parents": [{"code": "", "derived_via": "reads | restates | specializes | forcing_step | same_object"}],
  "children": [],
  "origin": {"source": "genesis | textbook | readout_genesis | readout_universe | information-discrete-math | zero-readout-certifies | finite-readout-acceleration | solver_arc | domain_registry",
             "repo_anchor": {"repo": "", "commit": "", "path": ""} , "record_id": null, "doi": null, "section": null},
  "status": "current | superseded_by | historical | unverified | imprecise_as_stated",
  "status_note": "",
  "superseded_by": null,
  "tier": "Th_coqc | finite_diagnostic | Dr | Open | Definition | Ax | RETRACTED | untagged",
  "tier_in_genesis_verbatim": "",
  "coq": {"file": null, "identifier": null, "assumptions": null, "imported_from": null,
          "coq_status": "closed | axioms | build_failed | not_yet_formalised | none",
          "coq_axioms": [], "coq_source_redistributed": true},
  "relations": [{"type": "reads | refines | supersedes | same_form_different_theory | special_case_of", "target": "", "note": ""}],
  "occurrences": [{"record_id": 0, "doi": "", "label": "", "section": "", "raw_key": ""}],
  "role": "root-axiom | domain-gate | tier-rule | other",
  "first_assigned": "YYYY-MM-DD"
}
```
`owner_year` is a **key present only when checked** (not `null`) — its absence means "not
checked/not applicable," per BBL-181's three-state rule; it is intentionally omitted from the fixed
skeleton above because a schema validator must treat its absence as legal, not as a missing-field
error.
`children[]` is **computed at build time** (invert `parents[]` across the full array) and must never
be hand-authored — a build that finds a hand-written `children[]` differing from the computed one
overwrites it and logs a `LINEAGE.jsonl` note, never trusts the input.

**Rationale.** REGISTRAR's D3 (field list) — chosen because it is the only one of the three proposals
that separately carries `parents[].derived_via` per edge (LIBRARIAN's schema put `derived_via` as a
single top-level field, which cannot express a reading with two different-kind parents) and keeps
`tier` normalized alongside `tier_in_genesis_verbatim` for the observed 150+ distinct free-text tier
strings. Storage as one `CANONICAL.json` array (not `registry/entries/<code>.json` per REGISTRAR's
D1) — because `README.md` and `docs/EQ_CODE_SCHEME.md` are already public and already say
`CANONICAL.json` is where "every distinct equation object" lives, and because a growing per-code file
layout was flagged by J1 as a real, unweighed PR-diff-noise cost with no proposer having compared it
against the single-file alternative.

**Source.** REGISTRAR D1/D3 (field set); ruling deviates from REGISTRAR D1 (storage layout) per J1's
weak-point finding, reconciled against LIBRARIAN's and FORMALISER's independent (and mutually
incompatible) `CANONICAL.json` shapes — this is the resolution of the "three incompatible schemas"
conflict both judge passes flagged as the batch's most consequential integration gap.

**Judge consensus.** Both J1 and J2 rated REGISTRAR's entry-shape idea highly (design_quality 7/7,
"cleanest formalization... a real improvement over the doc") and both independently flagged the
storage-layout mismatch against LIBRARIAN and FORMALISER as the top cross-conflict requiring a single
ruling before N3/N4 write anything.

**Cost.** One shared field-name contract that `scripts/build_eq_library.py`, `scripts/build_site.py`,
`scripts/build_catalogue.py`, and `tests/test_registry.py` must all read identically — LIBRARIAN's own
LIB-9 risk (schema drift across consumers) is closed by giving every consumer script the exact same
field names in this one ruling, not four independently-guessed ones.

### T2 — Code grammar (one regex, two layers)

**Decision.**
```
^(?P<root>EQ-0\d{2}|[A-Za-z][A-Za-z0-9]*(?:[._-][A-Za-z0-9]+)*)(?:/(?P<domain>[EHSWMPCB])\.(?P<seq>\d{2,4})(?:\.v(?P<rev>[1-9]\d*))?)?$
```
Layer-0 (root) = `EQ-0nn` or a bare Genesis id (`weld`, `MQ.08`, `Forced.XII`, `Face.10.bRLedger`, `N2`,
`VI.7.FailAbleGateLaw`, `T1`, `E00.7`, `WP.S4.3`, …), never re-prefixed/re-sequenced (`docs/EQ_CODE_SCHEME.md`
already rules this; this decision formalises it as one machine-checkable pattern). Layer-1 (reading) =
`<root>/<D>.<nn>.v<k>`.

Filesystem-safe mangling (Coq file names, BBL-182): `code.replace('/','__').replace('.','_')` — e.g.
`MQ.08/H.02.v1` → `MQ_08__H_02_v1.v`.

A rootless object (target: **zero** at every release) is coded `HRP-X.<nnn>` and must carry a
`drift_note`; the validator (T7) treats any `HRP-X.*` code as build-blocking, never a normal citizen.

**Domain letters — ruled, not deferred.** `docs/EQ_CODE_SCHEME.md` (already public) defines 5 letters
(`E,H,S,W,M`); `docs/HANDOFF_OVERNIGHT_2026-09-06.md`'s own definition-of-done independently requires
8 (`+P,C,B`) for the domain-rule-registry scope (BBL-189). **Ruling: the 8-letter set is authoritative
for v1.0.0** (`P` physics-domain rule registries not otherwise covered, `C` chemistry, `B` biology,
used only when a domain-rule-registry item does not collapse under the φ-criterion into an existing
E/H/S/W/M reading — see T5); `docs/EQ_CODE_SCHEME.md` gets a **dated addendum** (not a silent rewrite,
per BBL-173's spirit applied to our own docs) recording the 3 additional letters and the date/reason.
If N4 finds zero domain-rule items actually need `P`/`C`/`B` (all fold into existing E/H/S/W/M
readings), the addendum records that outcome instead and the letters are documented as reserved-but-
unused, not deleted.

**Rationale/Source.** REGISTRAR D2 (regex, mangling); LIBRARIAN's independent, command-verified
discovery of the doc mismatch (`docs/EQ_CODE_SCHEME.md` line 22 vs handoff line 13, re-confirmed in
§1.16 above) forces the explicit ruling rather than REGISTRAR's original "document once N4 runs"
deferral.

**Judge consensus.** J2 rated LIBRARIAN's catch of this mismatch as a top best-idea specifically
because it was **independently, verifiably** confirmed by direct read of both docs and *not* raised by
either other proposer; J1 flagged REGISTRAR's silent 8-letter adoption without reconciliation as a
constraint-fidelity weak point. Ruling resolves it: adopt 8 now, addendum the scheme doc now (this
section *is* that addendum's authorization), let N4 report actual usage.

**Cost.** One addendum paragraph in `docs/EQ_CODE_SCHEME.md` at N3 time; zero code cost beyond the
regex above.

### T3 — Root-parent rule (answers MQ.08's own ancestry, BBL-191/192)

**Decision**, entirely derived from verified data (§1.13–§1.15), no fabricated edges:

1. `EQ-015` (carries alias `MQ.08`, folds II.3 spine PDE + II.7 λ_c + II.8 RTPE + II.8a DRL per its
   own fold note, which states this material is "already stated earlier... repeated here only as the
   entry point of the continuous numbered stream") → `parents = [{"code": "weld", "derived_via": "forcing_step"}]`.
2. Every row that only *names* MQ.08 without carrying the alias (`MQ08-stepper`, `MQ08-CFL`,
   `MasterEqCanon`, `step11`, `step12`, `InverseArrow`) → `parents = [{"code": "EQ-015", "derived_via": "specializes"}]`.
3. `weld` (§1.15) and `EQ-008` (§1.14, already claims `weld` as an alias) are a **candidate**
   φ-criterion merge, not yet independently confirmed against the full Genesis text — flagged
   `pending-merge`; until N3 runs that check, `weld.parents = [{"code": "EQ-008", "derived_via": "same_object"}]` as an
   explicitly-flagged interim, never silently promoted to a confirmed merge.
4. `EQ-001` (`E00.1`, the primordial difference, `∃ a,b : a≠b`) is the **only** legal zero-parent
   code in the corpus (verified §1.1: this is the sole root axiom with nothing logically prior in the
   corpus). Every other zero-parent root or reading is a build-blocking finding under T7.
5. `Forced.I..XXIV`: a strict linked chain (T4), not a fan-out.

**Rationale.** Directly answers the founder's own named example ("MQ.08's own ancestry from E00.x /
δ_R → L_R → F through the step-by-step construction") using facts sitting in `genesis_root.json`
itself — MQ.08 is not a standalone root row; it is an alias of `EQ-015` and named text in 6 satellite
rows — never a guessed new edge, honoring BBL-173 (map only, never edit sources).

**Source.** REGISTRAR D4. **Judge consensus.** Both J1 and J2 named this the standout of the whole
batch ("the only proposal that answers... with cited data rather than assertion"); both also flagged
the same honest limitation — the `weld`/`EQ-008` fold is self-flagged as unresolved, so the flagship
ancestry claim is fully closed for the `EQ-015`/MQ.08-satellite chain but not yet for `weld`'s own
place in the tree. Ruling keeps that limitation explicit (item 3 above) rather than resolving it by
assertion.

**Cost.** N3 must re-run the φ-criterion check on `weld` vs `EQ-008` against the full Genesis text
before promoting item 3 from `pending-merge` to a confirmed `merged` lineage event (T6).

### T4 — Forced-set chain (BBL-192's named case)

**Decision.** `Forced.I.parents = [{"code": "EQ-015", "derived_via": "forcing_step"}]`;
`Forced.N.parents = [{"code": "Forced.<N-1 roman>", "derived_via": "forcing_step"}]` for `N = 2..24`.
Validated by `test_forced_chain_intact` (T7.5): walk `Forced.I → Forced.XXIV`; fail if any link is
missing or any `Forced.N` points anywhere but `Forced.N-1`.

**Rationale/Source.** REGISTRAR D5 — a forcing argument is logically a chain (each step depends on
the accumulated prior steps), not a hub-and-spoke off one axiom; BBL-192 names this case explicitly.
**Judge consensus.** Uncontested by either judge pass; no proposer offered an alternative.

### T5 — Dedup mapping (three-tier resolve-to-primary)

**Decision.** To fold {946 raw + 590 root + 124 domain rules} into `CANONICAL.json` without
double-counting:
- **Tier A (root wins).** A raw equation whose text/section `registry/GENESIS_CODE_SCHEME.md`'s own
  documented fold list already identifies as a restatement of a root row (E00.1–E00.7, RD-unit/Enc_Ω/
  Dec_Ω/copy-licence, II.3 spine PDE, II.7 λ_c, II.8 RTPE, II.8a DRL, "Three Stacked Layers" repeats,
  Face 10's record-genesis/canon-record lines, the bR-ledger identity) maps `raw_key → root code` via
  `occurrences[]`, **no new entry**.
- **Tier B (domain-rule fold).** A domain-registry rule (chem/quantum/relativity/biology, 124 total)
  that a φ-criterion check shows is the same object as an existing root/textbook equation folds the
  same way (occurrence added, no new entry); one that does not pass gets its own new reading code
  `<nearest-root>/<D>.<nn>.v1` (using the T2 domain letters).
- **Tier C (textbook residual).** Every `eq_*.json` label not resolved by A/B either merges into an
  existing reading under the same φ-criterion test (occurrence appended) or becomes a fresh reading
  code `<root>/<D>.<nn>.v1`, `parents` set to the root it reads (nearest-matching per the paper's own
  framework; defaulting to `weld` only when nothing more specific is identifiable — every such default
  is flagged for review, never silent).
- Anything matched by **neither rule with confidence** goes to `registry/UNRESOLVED_RAW.json`
  (`[{"raw_key": "...", "reason": "..."}]`) and is excluded from `CANONICAL.json` until resolved.
  `test_no_unresolved_raw_above_threshold` (T7.2) targets **0** at v1.0.0.

**Rationale/Source.** REGISTRAR D6. **Judge consensus.** Both judge passes accepted this as the
concrete answer to the explicit double-counting question; J2's own risk note (Tier C could wrongly
mint a new code if the fold list is incomplete, and `UNRESOLVED_RAW.json` only catches equations that
fail *all* three tiers, not ones that pass Tier C's φ-check *incorrectly*) is carried forward as an
**open item** (§4) rather than resolved — no proposer offered a stronger check than "0 unresolved" and
a documented fold list.

### T6 — Lineage events (append-only, φ-evidence on merges)

**Decision.** `registry/LINEAGE.jsonl`, one JSON object per line:
`{code, date, event: assigned|revised|retired|merged|split|occurrence_added, from, to, reason, by}`
— matches the shape `tests/test_registry.py` already checks (§1.7). `merged` events additionally
**require** `phi_criterion_evidence` (which of the three φ-forms — renaming / positive-scale /
constant-substitution — plus the two compared statements). `test_merge_has_phi_evidence` (T7.6) fails
the build on any `merged` line missing it.

**Source.** REGISTRAR D8. **Judge consensus.** Uncontested.

### T7 — Validation tests (extend `tests/test_registry.py`)

The 3 existing tests are kept unchanged. New tests, each with a concrete failure condition (no vague
"validate the schema" gestures — this was J1's explicit ask):

| # | Test | Fails when |
|---|---|---|
| T7.1 | `test_no_orphans` | any non-root entry has `parents==[]`; any root entry except `EQ-001` has `parents==[]` |
| T7.2 | `test_no_unresolved_raw_above_threshold` | `len(UNRESOLVED_RAW.json) > 0` at v1.0.0 |
| T7.3 | `test_no_cycles` | DFS with recursion-stack over the `parents[]→code` graph finds a cycle; reports the exact cycle path |
| T7.4 | `test_duplicate_codes` | any code (root ∪ canonical) is not globally unique **including across aliases** — an alias must never equal another entry's primary code (the exact `Layer.3`/`FailAbleGateLaw`/`B.1`/`B.3` collision class `GENESIS_CODE_SCHEME.md` already documents disambiguating) |
| T7.5 | `test_forced_chain_intact` | `Forced.I → Forced.XXIV` chain (T4) has a missing or misdirected link |
| T7.6 | `test_merge_has_phi_evidence` | any `LINEAGE.jsonl` `merged` line lacks `phi_criterion_evidence` |
| T7.7 | `test_status_consistency` | `status=='superseded_by'` without a non-null existing `superseded_by` (no 2-cycle); `status=='current'` with non-null `superseded_by`; any non-`current` status with empty `status_note` |
| T7.8 | `test_code_grammar` | any code fails the T2 regex; any `HRP-X.*` code lacks a `drift_note` |
| T7.9 | `test_coq_assumptions_honest` | any entry with non-null `coq.file` has `coq.assumptions` other than exactly `"Closed under the global context"` or a string starting `"+axioms:"` |

**Run order (WF-NO-REAUDIT, applied to Coq generally, not just this repo's Coq).** T7.1/.3/.4/.5/.7/.8/.9
run on every `CANONICAL.json`/`genesis_root.json` change — cheap, pure Python, no coqc. The actual
`coqc`/`Print Assumptions` pass stays in `coq/verify_all.sh` (T9), run **sequentially, once per
session**; `pytest` only checks that `verify_all.sh`'s own output already on disk says "Closed under
the global context" — it never re-invokes `coqc` itself.

**Source.** REGISTRAR D9. **Judge consensus.** Rated the most complete test surface of the three
proposals by both judge passes; no disputes.

### T8 — Coq import layout: cite, don't copy the public sources' verbatim text into a second location — import as read-only mirrors, wrap per code

**Decision** (resolves the REGISTRAR-vs-FORMALISER copy/cite conflict both judge passes flagged as
the second headline cross-conflict):

- `coq/<source>/` — one directory per **public** import source (`readout_genesis/`, `readout_universe/`,
  `information-discrete-math/`, `zero-readout-certifies/`, `finite-readout-acceleration/`), holding the
  **original `.v` files byte-for-byte** (never edited — a diff against the source repo's own commit must
  be empty) plus one `PROVENANCE.json` manifest (`{source, repo_url, commit, licence, build_status,
  files:[{path, sha256, imported_as}]}`).
- `coq/canonical/<mangled-code>.v` — one thin wrapper per Toledo code with a backing proof: header
  comment with the exact code, licence line, `From <Qual> Require Import <OriginalModule>.`, then one
  or more `Notation <safe_ident> := <OriginalLemmaIdent>.` lines. No new proof text, no `Admitted`.
  This is the literal BBL-182 deliverable (file name = code) *and* BBL-185/186 (import, don't re-prove)
  satisfied at once — the wrapper never re-derives, it names.
- `registry/COQ_THEOREM_MAP.json` — `[{code, source, source_file, coq_identifier, kind, canonical_file, status}]`,
  hand-reviewed pairing (no automatic string-similarity merge).
- `registry/COQ_IMPORT_LEDGER.jsonl` — append-only `{date, code, source, source_identifier, canonical_file, action: mapped|wrapper_created|excluded_attempt|build_failed|status_changed, by, reason}`.

**Rationale.** REGISTRAR's D7 (cite-only, no copy at all) protects against ever committing anything
that later turns out non-redistributable, but leaves "how does a public CI actually verify a code
whose Coq lives in someone else's repo" unanswered — both judge passes named this exact gap in D7.
FORMALISER's D1 (copy everything in) answers verifiability but copies a repo (`readout_universe`)
whose own `LICENSE` FORMALISER's own verified_facts call "a named-copyright text, not MIT" into a
`coq/` tree Toledo's own `LICENSE` commits as MIT — a real, unflagged conflict (J1). **Ruling:** copy
only the five **public** sources (their licences must each be individually checked against Toledo's
MIT `coq/` commitment at N4 time, before the copy — if a public source's licence is not MIT-compatible
for redistribution, it is cited-only like the private one, never force-copied); the private solver
arc is **never** copied (T9 handles it as a hard blocker).

**Source.** REGISTRAR D7, FORMALISER D1–D4, reconciled per J1/J2's cross_conflicts entry
"COQ IMPORT STRATEGY CONFLICT." **Open item:** the individual licence-compatibility check on each of
the five public sources (readout_genesis, readout_universe, information-discrete-math,
zero-readout-certifies, finite-readout-acceleration) has not been run in this meeting — §4.

### T9 — The solver-arc licence block (new finding, both proposer batches under-weighted it)

**Decision.** The private solver arc's `.v` source text is **not** committed into the public
MIT-licensed Toledo repository under any circumstance, pending an explicit founder decision recorded
as a `DECISIONS.yaml` row (not a chat decision — the workspace's own standing rule that a decision is
not "done" until it is a row applies here with full force). Until that row exists:
- `coq/solver_arc/` (label only, never the real repo name — even in this public-facing meeting record,
  per the standing constraint) is populated **locally, git-ignored**, so a sequential verify pass can
  still run end-to-end on this machine.
- Only `PROVENANCE.json` (commit sha, file list, sha256 per file, `licence: "proprietary — not
  redistributed, source-arc verification-only pending founder decision"`) and
  `registry/COQ_VERIFY_REPORT.md`'s status rows (status text, axiom names — **no source code**) are
  committed and pushed public.
- `coq/canonical/<code>.v` wrappers whose `Require` target lives in the solver arc are fine to publish
  (they carry no proprietary text) but must carry a comment noting the `Require` will not resolve
  outside a checkout that also has the private repo; their `CANONICAL.json` row gets
  `coq.coq_source_redistributed: false`.
- The solver arc's canonical import scope is exactly its **own** Makefile's file list, never a set
  Toledo decides on its own authority — a source project's own promotion convention is not overridden
  by Toledo (BBL-173's "map only" applied to Coq promotion status, not just equation text). Any file
  the source project has not promoted to its own canonical set (including any health/BIRCA file still
  on the source's own "in-progress" naming convention as of the commit anchored in `PROVENANCE.json`)
  is excluded from Toledo's canonical import and listed by filename+count in
  `coq/solver_arc/EXCLUDED_ATTEMPTS.md` with reason "not on the source project's own canonical file list
  as of `<commit>`."

**Rationale.** This is exactly the incident class `PUB-ADVERSARIAL-REVIEW` exists to catch before a
public push (the readout_universe two-week proprietary-code-on-public-GitHub leak is the founder's
own gate rule's cited precedent) — surfacing it now, before any `git add`, is cheaper than after.
**Source.** FORMALISER D6/D7. **Judge consensus.** Both judge passes rated this the single most
consequential engineering-safety catch across the entire batch, and both independently confirmed the
underlying facts hold (a proprietary all-rights-reserved licence, verified directly against the file,
at the commit cited). **Judges also flagged (uncontested, carried forward as §4 open items):** (a) a
definition-of-done line elsewhere names health/BIRCA as in-scope for v1.0.0 while every current
health/BIRCA file in that source is on its own in-progress naming convention — a real scope tension,
not silently resolved either direction here; (b) a public CI job that tries to build a
solver-arc-backed `coq/canonical/*.v` wrapper will fail on a fresh public-only clone (its `Require`
target is absent) — T10 below scopes CI to skip `coq_source_redistributed:false` codes explicitly so
this does not silently red the build.

### T10 — Verification runner (sequential, one owner)

**Decision.** `coq/verify_all.sh` is the **single** sequential runner (resolves the "two uncoordinated
verify owners" conflict both judge passes flagged between FORMALISER's `verify_all.sh` and
LIBRARIAN's separate `ci.yml` verify job):
1. Before each source's build step: `free -g`; proceed only if `MemAvailable ≥ 2` GB, else wait and
   re-check — never spawn a second `coqc` while waiting. Never `-j` on any `make`.
2. For each source with its own `_CoqProject`/`Makefile` (`readout_universe`, `information-discrete-math`,
   `zero-readout-certifies`, `finite-readout-acceleration`, and the solver arc's own build tree): `cd`
   into it, run **its own** `make` — never a hand-rolled `coqc` invocation with guessed flags.
3. `readout_genesis/formal` has no `Makefile` (verified) — generate a **Toledo-side** `_CoqProject`
   from its own `Require` graph (a small, provenance-noted addition Toledo makes on its own side, never
   an edit to the source's original files) so build order is topological, not guessed.
4. For every `COQ_THEOREM_MAP.json` row: write a scratch file, run `Print Assumptions`, classify
   `closed` (exact string) / `axioms` (matches the source's own disclosed axiom list exactly — a
   fifth, undisclosed axiom halts classification and is flagged, never silently bucketed) /
   `build_failed` (full stderr appended, never reinterpreted).
5. Re-run `Print Assumptions` on each `coq/canonical/<code>.v` wrapper's own identifier as an
   independent second check that the wrapper did not drop or widen anything.
6. Run the existing `coq/master-river/verify.sh` unchanged.
7. Emit `registry/COQ_VERIFY_REPORT.md` (one row per code: source, identifier, status, axioms, wrapper
   file, pass/fail) and write `coq.coq_status` back into `CANONICAL.json` (never into the top-level
   `status` field, which stays the 5-value BBL-190 enum — a `build_failed` or unnamed-axiom
   `coq_status` can only push `status` toward `unverified`, never invent a sixth value).

`.github/workflows/ci.yml`'s own `verify` job (T12) **delegates to `coq/verify_all.sh`** rather than
re-implementing the sequential pass — CI's only addition is running it inside a pinned
`coqorg/coq:8.20.1` container (matching the locally-observed `coqc --version`, §1.10) and **skipping**
any code whose `coq.coq_source_redistributed==false` (so a public-only clone's CI does not go red on
a `Require` target it structurally cannot have).

**Source.** FORMALISER D5/D9/D10, LIBRARIAN LIB-4, reconciled per both judge passes'
"VERIFY-JOB OWNERSHIP OVERLAP" / "CI verify job scope" conflict entries.

### T11 — Fix the live code-generator defect before anything downstream runs

**Decision.** Delete the `HRP-EQ-<D>.<nnn>.v1` auto-assignment block in
`scripts/build_eq_library.py` (confirmed present and live, §1.17) **before** N4/N5 write
`CANONICAL.json`. Every object in `CANONICAL.json` must already carry `code` from T5's dedup mapping —
a root code copied verbatim from `genesis_root.json`, or a Layer-1 reading per T2. If any build script
(`build_eq_library.py`, `build_site.py`, `build_catalogue.py`) finds an entry with a missing or
`HRP-X.*` code, it prints the offender and exits non-zero — no silent fallback generator kept as a
safety net.

**Rationale.** Shipping the docs site/catalogue on top of the uncorrected generator would publish the
exact invented-numbering scheme the founder already corrected once (`registry/GENESIS_CODE_SCHEME.md`'s
own preamble). **Source.** LIBRARIAN LIB-1. **Judge consensus.** Both judge passes independently
re-verified this defect against the live file (exact line quoted, §1.17) and rated it the single
highest-value catch in the batch for a library whose selling point is stable, non-invented codes.
**Cost.** ~12 lines deleted; this is a precondition for T13, not new scope.

### T12 — Docs site + catalogue spec

**Docs site** (`scripts/build_site.py`, `make site`): reads `genesis_root.json`, `CANONICAL.json`,
`LINEAGE.jsonl`, `eq_*.json`, no network. Computes `children`/descendants by inverting `parents[]`.
Emits `site/index.html` (Genesis-first browse order = `genesis_root.json`'s own array order, per
BBL-175/176/177, plus a search box), `site/search-index.js` (a single inlined
`const TOLEDO_INDEX=[...]` literal — no fetch, works opened as a local file too), and one page per
code at `site/<code>/index.html` — a Layer-1 code's own literal `/` becomes the URL's own directory
boundary (`MQ.08/H.02.v1` → `site/MQ.08/H.02.v1/index.html`), dots stay literal in the path (valid in
URLs; unrelated to the T2 Coq-mangling rule, which is Coq-filename-only). Each page: code+name,
statement (verbatim, monospace), tier/status(+note), provenance, verification (linked to the pinned
Coq commit), ancestry chain root→code (breadcrumb), descendants (computed, linked), occurrences
(linked), history (`LINEAGE.jsonl` slice).

**Catalogue PDF** (`scripts/build_catalogue.py` → `catalogue/generated_body.tex`, static
`catalogue/main.tex` preamble, `lualatex`/`fontspec`/`longtable`/`hyperref` — confirmed installed,
§1.18): Part 1, one subsection per Genesis-order root with its Domain-readings longtable; Part 2,
"Rootless items (target: none)" — any surviving `HRP-X.*` orphan with its drift note, a **visible**
orphan-check-failure surface in the built PDF itself, not only in CI logs. Built via
`latexmk -lualatex -interaction=nonstopmode catalogue/main.tex`; output gitignored, attached fresh as
a release asset.

**`EQ_LIBRARY.md`**: keep its existing two-part layout; add `Parents` and `Status` columns to the
Canonical-objects table header so BBL-191/192 ancestry is visible in the one file everyone already
reads (a 2-line diff to `build_eq_library.py`'s header/row f-strings).

**Source.** LIBRARIAN LIB-2/LIB-5/LIB-6, gated by T11.

### T13 — Release / CI procedure

- `.github/workflows/ci.yml` (new — confirmed no `.github/` exists yet, §1.20): job `test` =
  `pytest -q tests`; job `verify` = `coqorg/coq:8.20.1` container, delegates to `coq/verify_all.sh`
  (T10), skips `coq_source_redistributed:false` codes; job `library` = regenerate `EQ_LIBRARY.md` then
  `git diff --exit-code` it (a stale hand-edit fails CI).
- `.github/workflows/pages.yml` (new): on push to `main` touching `registry/**`/`scripts/build_site.py`,
  build then deploy via `actions/upload-pages-artifact` + `actions/deploy-pages` — OIDC `GITHUB_TOKEN`
  only, no configured secret. Pages source = "GitHub Actions," leaving `docs/` free for design notes.
- `.github/workflows/release.yml` (new): on tag `v*`, full build + catalogue, then
  `softprops/action-gh-release` (default `GITHUB_TOKEN`) attaches the catalogue PDF, a
  `registry.zip`, and a `coq.zip` (public sources + wrappers only — never the solver-arc directory).
- **Release procedure (v1.0.0 and every later tag):** (1) `make test && make verify && make library &&
  make site && make catalogue` all green; (2) an **independent** checker pass (`maker-checker-gate`
  skill) on `CANONICAL.json` + `LINEAGE.jsonl` + the built site/catalogue — a different pass/agent
  from whoever built them, per the workspace's own maker-checker discipline; this checker pass must
  complete **before** the tag is pushed, because Zenodo's GitHub-App integration auto-publishes the
  moment a GitHub Release exists from a tag — there is no draft/review step on Zenodo's side (a real
  irreversibility risk both judge passes flagged); (3) update `CHANGELOG.md` + bump `CITATION.cff`;
  (4) founder-authorised `git tag -a v1.0.0` (BBL-167 stands — tagging is the human gate); (5)
  `git push origin v1.0.0` triggers `release.yml`; (6) Zenodo's GitHub-App integration (one-time
  founder OAuth grant in Zenodo's own web UI, not a CI secret) mints the new version under the
  existing concept DOI `10.5281/zenodo.22537318`; (7) **separately and manually** — cannot be
  automated without a Zenodo API token in CI, which the no-secrets constraint forbids — the founder
  (or a locally-run script using a personal token kept out of CI/repo secrets) edits the **old** Coq
  record `22518450`'s own metadata to add `related_identifiers: [{relation: "isSupersededBy",
  identifier: "10.5281/zenodo.22537318"}]`; `docs/RELEASE.md` makes this a **checked step**, not a
  footnote, since it happens entirely outside this repo's own pipeline and is easy to forget.

**Source.** LIBRARIAN LIB-3/LIB-4/LIB-8, T10's delegation ruling folded in. **Judge consensus.**
Both judge passes flagged the Zenodo auto-publish-on-tag irreversibility as real; both independently
confirmed the origin remote, absence of `.github/`, and the LICENSE/CITATION.cff facts. No dispute on
the OIDC/no-secret pattern itself.

### T14 — RETRACTED rows, disk budget, downstream citation contract (small ruled items)

- **RETRACTED handling.** `EQ-069/070/071` (§1.3) get `CANONICAL.json` entries with `tier: RETRACTED`,
  `status: historical`, `status_note` quoting the retraction reason from Genesis's own text, and are
  **shown** on the docs site/catalogue with a visible RETRACTED badge — never silently excluded (the
  numbers stay reserved "so the correction is visible," per `GENESIS_CODE_SCHEME.md`'s own instruction).
  If a RETRACTED root has any children in the corpus, `test_no_orphans` (T7.1) still requires those
  children to resolve their `parents[]` to something non-retracted or to carry an explicit
  `status_note` explaining the retracted lineage — never a silent pass-through.
- **Disk budget.** The 85 public-source `.v` files (§1.11) plus the solver arc's git-ignored local
  copy plus `site/`+`catalogue/` build output is small relative to this machine's headroom (§1.19,
  9 GB available) — no budget gate needed beyond the existing RAM gate in T10.
- **Downstream citation contract** (Master River paper, textbook Appendix F — outside this repo):
  cite `toledo/<code>` pinned to a **version** DOI (not the concept DOI alone), since a Layer-1
  `.v<k>` can bump under "latest formulation wins" while a paper's own citation must stay
  reproducible. This is a coordination note for whichever session owns those repos, not work inside
  Toledo itself.

**Source.** LIBRARIAN LIB-9 (citation contract); RETRACTED handling and disk budget are this
secretary's own rulings on the "missing" items both judge passes flagged (§4 below lists what
remains genuinely open rather than ruled).

---

## 3. ข้อขัดแย้ง + คำตัดสิน / Conflicts + rulings (summary table)

| Conflict (named by both judge passes) | Ruling | Where |
|---|---|---|
| Three incompatible `CANONICAL.json` schemas (REGISTRAR per-code files + thin index; FORMALISER assumes a fourth undefined shape; LIBRARIAN's own third shape) | One `CANONICAL.json` array, REGISTRAR's field set, LIBRARIAN's flat-array storage | T1 |
| Copy-in (FORMALISER) vs cite-only (REGISTRAR) for public Coq imports | Copy the five **public** sources after an individual per-source licence check; cite-only (never copy) for the private solver arc | T8, T9 |
| Domain-letter set: 5 (`EQ_CODE_SCHEME.md`) vs 8 (handoff) | 8-letter set ruled for v1.0.0; dated addendum to `EQ_CODE_SCHEME.md`; unused letters reported, not deleted | T2 |
| Two uncoordinated Coq-verify runners (FORMALISER's `verify_all.sh` vs LIBRARIAN's `ci.yml` verify job) | `verify_all.sh` is the one runner; CI delegates to it inside a pinned container, skipping non-redistributable codes | T10 |
| REGISTRAR's `role=='primitive'` parents-`[]` escape hatch vs REGISTRAR's own stricter "only `EQ-001` may have zero parents" rule | The stricter rule wins — `EQ-001` only; `role` is descriptive metadata, never a licence to skip the ancestry walk | T1 (role field), T3.4, T7.1 |
| health/BIRCA named as in-scope for v1.0.0 (handoff def-of-done #4) vs every current health/BIRCA file being on the source's own in-progress naming convention | Not resolved here — Toledo does not unilaterally promote what the source project has not promoted (T9); recorded as an open item, not silently decided either way | T9, §4 |

---

## 4. ขาดหาย → รายการเปิด / Missing → open items

รายการนี้คือสิ่งที่ผู้ตัดสินทั้งสองชุดตรงกันว่ายังไม่มีข้อเสนอใดปิดได้ — ไม่ใช่ DECISION, เป็นสิ่งที่ N3–N7 หรือ
founder ต้องตัดสินใจต่อ.

1. **A `DECISIONS.yaml` row for the solver-arc re-licensing/verification-only question (T9)** — every
   proposal correctly names that a founder decision is needed; none drafts the actual row. Whoever
   runs N4 must write it before touching that source's files.
2. **A `DECISIONS.yaml` row for the health/BIRCA promotion tension** (handoff def-of-done #4 vs the
   source project's own current naming convention) — same gap, same fix.
3. **Per-source licence compatibility check** for the five *public* Coq import repos against Toledo's
   MIT `coq/` commitment (T8) — flagged that `readout_universe`'s licence is "a named-copyright text,
   not MIT" per FORMALISER's own verified_facts; the other four were not individually re-checked in
   this meeting.
4. **φ-criterion adjudication path for disputed merges.** Both proposals and both judge passes assume
   φ-criterion checks are mechanically decidable; for a non-trivial statement pair this requires
   judgment. No proposal names who/what adjudicates a contested merge (a natural fit for
   `maker-checker-gate`, not designed here).
5. **`owner_year` population process at scale** — the three-state field (T1) is specified, but no
   proposal designs the actual lookup/matching workflow against the solver arc's own Equation Registry
   that would populate it for hundreds of textbook-derived readings.
6. **Raw-inventory internal consistency gate** — whether the 40 `eq_*.json` files' own `equations[]`
   arrays ever contain duplicate `record_id:label` keys within one chapter was never checked in this
   meeting; T5's Tier-A/B/C dedup assumes clean raw keys going in.
7. **CANONICAL.json / validator scale** — no proposal sized the search-index/`children`-inversion cost
   once the array holds on the order of 1,000+ entries (590 root + new readings from 946 raw + 124
   domain rules); likely fine at this scale for a build script, but not measured.
8. **Weld/EQ-008 merge** (T3.3) stays `pending-merge` — not an open item to found a `DECISIONS.yaml`
   row on, but a concrete N3 task: re-run the φ-criterion check against the full Genesis text before
   promoting it to a confirmed `merged` lineage event.

---

## 5. Executable next steps (N3–N7, in order)

- **N3 — relabel + seed.** Apply T1 (schema)/T2 (grammar, incl. the `EQ_CODE_SCHEME.md` addendum from
  T2)/T3 (root parents, incl. re-checking the `weld`/`EQ-008` φ-criterion per open item #8)/T4 (Forced
  chain)/T5 (dedup, Tiers A/B/C) to produce `registry/CANONICAL.json` and seed `registry/LINEAGE.jsonl`
  (`assigned` events). Run T7.1/.3/.4/.8 (orphan/cycle/duplicate/grammar) as the acceptance gate — a
  BLOCK on any failure, not a warning. **Precondition:** T11 (delete the `HRP-EQ-*` generator) must
  land first so N3's output is not immediately re-corrupted by the old fallback.
- **N4 — import the rest + Coq theorem map.** Domain rule registries (124 rows, using T2's ruled
  8-letter set); readout_universe; the solver-arc equation stream + health/BIRCA (gated by the two
  `DECISIONS.yaml` rows in open items #1–#2 — do not touch solver-arc `.v` text before those rows
  exist); build `registry/COQ_THEOREM_MAP.json` (T8) and the per-source `PROVENANCE.json` manifests
  (verify counts by command, per §1's discipline — do not copy this meeting's cited numbers for the
  solver arc without re-running the count).
- **N5 — Coq: rename, wrap, verify.** Populate `coq/canonical/<mangled-code>.v` wrappers (T8); run
  `coq/verify_all.sh` (T10) sequentially, respecting the `free -g ≥2GB` gate; write `COQ_VERIFY_REPORT.md`
  and back-fill `coq.coq_status` into `CANONICAL.json`; append `COQ_IMPORT_LEDGER.jsonl` rows.
- **N6 — presentation + release.** Regenerate `EQ_LIBRARY.md` (T11 fix applied, T12's Parents/Status
  columns added); build the docs site and catalogue PDF (T12); add the three new GitHub Actions
  workflows (T13); run `pytest -q tests` with the full T7 suite; get the independent checker pass
  (`maker-checker-gate`) on `CANONICAL.json`+`LINEAGE.jsonl`+site/catalogue **before** tagging; tag
  `v1.0.0`; push; let `release.yml` + Zenodo's GitHub-App integration mint the new version; then
  perform the manual, checked, out-of-CI step against the old Coq record `22518450` (T13 step 7).
- **N7 — downstream.** Master River v1.5 (new version of its own record) cites `toledo/<code>` pinned
  to the v1.0.0 version DOI (T14); textbook Appendix F rebuilt from a pinned Toledo tag (never `main`
  HEAD); final independent checker pass; publish the reserved book record; refresh `isPartOf`
  back-links, hubs/KG, and this repo's own `HANDOFF_OVERNIGHT_2026-09-06.md` + memory.

---

*Secretary note: this record is a readout of three proposal documents and two independent judge
passes conducted earlier in the same overnight run, cross-checked here against the live repository
state (§1) where a claim was checkable by command. It is not itself the independent checker pass
`maker-checker-gate`/T13 requires before release — that pass still has to happen, by a different
agent, against the actual `CANONICAL.json`/`LINEAGE.jsonl`/site/catalogue N3–N6 produce.*
