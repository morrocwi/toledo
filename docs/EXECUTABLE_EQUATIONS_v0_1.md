# Executable Equations v0.1 — spec

tier: Dr (specified from the founder question below plus direct re-measurement against this
checkout, `commit 66eb48a2c79e65d88102c2fc6fef8f7db4c465e9`; independently unreviewed — this
document is itself a candidate for the maker-checker gate, not a ruling).

> Founder question, 2026-09-08: should every equation also get executable forms (JavaScript or
> other)? Answered here against this workspace's real constraints — one scholar, one workstation,
> 1,267 canonical entries of which only a measured subset is computable at all — and against the
> lesson already paid for once: the 946 raw → 793 canonical drift (`docs/MEETING_2026-09-06_
> toledo_design.md`), which is what "one source of truth per equation, generated twins, never
> hand-written copies" below is built to prevent from recurring in a second artifact class.

**Answer: no, not every equation — a narrow, opt-in, human-reviewed subset, and never as a
hand-written second copy.** Section 1 gives the measured scope. Everything after it specifies one
architecture: a single shared interpreter (Python + JavaScript) that walks a small per-equation
intermediate representation (IR) file at run time. No per-entry source file is ever generated,
committed, or hand-written. This is the ruling this document exists to make.

---

## 0. How to read this document

This is a **build spec**, not a build log — nothing described below has been built yet except the
measurements in §1, which were run directly against the live registry while drafting this file (the
commands are given so anyone can re-run them). §§2–9 specify what four build streams (S1–S4, §10)
must produce. §12 traces every graft this spec applied, and §13 is the single, deduplicated
do-not-build list every stream must obey.

---

## 1. Scope rule — measured counts

### 1.1 Precondition: Content MathML was not functional at last build time (fold-in, verified)

`scripts/toledo_build.py::content_mathml` calls `sympy.parsing.latex.parse_latex`, which needs the
`antlr4-python3-runtime` package. Checked directly against every file in `registry/entries/` (1,877
files, one per code):

```
content_mathml populated:        0 / 1877
content_mathml_reason breakdown:
  "statement.format is not \"latex\"" ............... 1428
  "antlr4 runtime not installed" ..................... 449
```

This confirms the finding this document was asked to fold in: **every** `content_mathml` field in
the checked-in build artifacts is null, and for the 449 `format: latex` entries the reason is a
missing dependency, not a parse failure. Re-checked on this workstation today:

```
$ python3 -c "import antlr4; print(antlr4.__version__ if hasattr(antlr4,'__version__') else 'present')"
present
$ pip3 show antlr4-python3-runtime | grep Version
Version: 4.11.0
```

`antlr4-python3-runtime==4.11.0` — the exact version `content_mathml`'s own docstring names — **is
installed on this workstation now**, and was not at the checkout's last build (`registry/entries/`
is a build artifact, staler than the environment). This is exactly the "gap that must not silently
recur" this document was asked to close:

- **Precondition check, S1 owns it (`scripts/executable/check_antlr4.py`, called from `make
  build` before `content_mathml` is attempted):** import `antlr4`, print its resolved version, and
  fail closed (non-zero exit, no silent skip) if the version does not satisfy sympy's own stated
  requirement — never let `toledo_build.py` fall through to the "antlr4 runtime not installed"
  branch silently when the runtime actually is present but broken in some other way (import error,
  version too old); the two cases must produce visibly different messages.
- **`make build` re-run requirement:** `scripts/toledo_build.py` must be re-run against this
  checkout now that the precondition holds, so `registry/entries/*.json` and `registry/TOLEDO.json`
  stop asserting a stale "antlr4 not installed" reason once the dependency is actually present —
  this is a S1 deliverable (§10), not a hand-edit.
- **CI assertion (new, S1 owns it):** for the `format in (latex, latex+ascii)` subset (873 of 1,267
  canonical entries), `content_mathml` non-null count must be **> 0** after a build, or CI fails.
  This does not assert a target percentage (a low percentage is honest, given the false-positive
  problem §1.3 documents) — only that the precondition is checked mechanically going forward,
  never silently regressed to "0 populated, dependency absent" again.
- `pip3 install antlr4-python3-runtime==4.11.0` (or the conda equivalent) must be added to
  `requirements`/CI setup wherever `make build` runs, not left as an ambient workstation fact.

### 1.2 Eligible pool: status/format gate (the floor, not a ceiling)

Base eligibility gate, applied before any classifier runs — **the classifier schedules review
work, it never grants eligibility by itself** (reused verbatim from the graft that named this
framing; every mention of "candidate" below means exactly this and nothing stronger):

```
status not in {not_an_equation, split}
AND statement.format in {latex, latex+ascii}
```

Measured directly against `registry/CANONICAL.json` (1,267 entries) today:

```
canonical entries:                    1267
statement.format breakdown:  latex 449 · latex+ascii 424 · coq 393 · prose 1
status breakdown:            current 1176 · unverified 52 · split 30 · not_an_equation 9
eligible pool (gate above):            835
```

### 1.3 Classifier pass: sympy `parse_latex` over the eligible pool, and a new false-positive class

Re-run today, with `antlr4-python3-runtime` confirmed present (§1.1), using `statement.latex` for
`latex+ascii` entries and `statement.latest` for `latex` entries — the same source string
`content_mathml` itself uses:

```
eligible pool ............................................. 835
sympy.parsing.latex.parse_latex raises .................... 499
sympy.parsing.latex.parse_latex succeeds .................. 336
  of which: no top-level Eq (=) node at all ................ 219
            Eq node, both sides bare symbols (categorical) ..  1
            Eq node, at least one side has real structure .. 116

by domain (pool / parse-succeeds / Eq-with-structure):
  P (physics)     187 / 140 /  47
  B (biology)      75 /  61 /  25
  C (chemistry)    59 /  53 /  31
  M (method)      140 /  45 /   7
  H (human-AI)    122 /  26 /   3
  W (world-sys)    75 /   4 /   2
  E (epistemic)    62 /   7 /   1
  S (social)      115 /   0 /   0
```

**This number is a raw syntactic-parse count, not a coverage or rigor metric — stated here exactly
because every one of the three proposals this document reconciles independently arrived at a
different figure (roughly 553, 272/T3_STRICT, and a small clean count) from different filters over
the same registry, and none of those raw counts survives independent re-verification as a
coverage claim.** Two independent hazards, confirmed by direct inspection of this run's own output,
go beyond what any of the three proposals had already caught:

1. **sympy's `parse_latex` treats English prose as implicit multiplication of symbols.** Spot-check
   of the "parse succeeds" set found entries like `EQ-001/C.08.v1` ("Candidate mathematical
   languages must be frozen and reported before...") parsing without error into a product of
   single-letter symbols — a sentence, not a formula. This is a **stronger** failure mode than the
   bare-equation-name false positive already named below: it is not merely a name being mistaken
   for an equation, but running prose being silently accepted as if it had algebraic structure.
2. **Even the tighter 116-row "Eq node with real structure" set is dominated by multi-sentence
   prose with one formula fragment embedded** (e.g. `EQ-001/P.63.v1`: `"r_s = 2·G·E/c^4, admitted
   only as a declared calculator identity, ..."` — sympy parses only up to the first relational
   clause and is blind to the qualifying prose around it). Manual read of the first 15 of the 116
   found the large majority in this shape: a genuine formula exists inside the statement, but the
   *entry* is not a bare equation ready for evaluation — extracting the formula correctly requires
   a human to read the surrounding sentence, not just a stronger regex.

Net effect: **116 is an upper bound on today's raw classifier signal, not a projected build count.**
Given hazard (2), the actually-eligible set after human review is very likely a small fraction of
116 — consistent with, and now further below, the ~25–40-entry scale one of the three proposals
measured as unambiguously clean by direct read. **The very first pilot batch (§10, S1) must be
scoped at that ~25–40-entry level and timed for real before any larger number is committed to** —
this document commits to no fixed target (§13 item 8).

### 1.4 Domain-honesty note (carried into the site, not just this document)

The by-domain table in §1.3 shows real skew: **S (social) measured zero parse-successes; E
(epistemic), W (world-system) and H (human–AI) are all low.** This is not a quality gap in those
domains — they are legitimately mostly comparative, definitional, and relational statements
("agency A does not have epistemic veto over agency B", "a fork must preserve lineage"), not
numeric relations, and a low or zero executable count there is not a signal that those domains are
less rigorous or less complete than P/B/C/M. Every place this document's `executable` coverage
count is surfaced — `/browse/`'s new column, `/about/`'s corpus-wide tally, any future report — must
carry this note next to the number, not as a footnote nobody reads. This is a **display
requirement**, tracked as a S4 acceptance check (§10).

### 1.5 The one named structural risk this pilot cannot solve

**R5 (independent reviewer, `independence_class >= I2`) is structurally out of reach on a
one-scholar workstation for this feature, exactly as it already is for the rest of the registry.**
Every IR sidecar in this spec requires a human `reviewed_by` sign-off (§13 item 2) — but that
reviewer and the founder are, on this workstation, the same person for the foreseeable future. This
is stated here plainly, once, as this document's own risk-list entry, rather than left implicit the
way an earlier proposal round left it: R5 on an `executable` block, like R5 on the rest of the
resistance ladder (`registry/SCHEMA.md`'s resistance addendum), is expected to sit `held: false`
indefinitely absent a second qualified person, and no build step in this spec should be read as
working around that fact.

---

## 2. Architecture decision

**One shared, hand-written, hand-reviewed interpreter per language, reading a small per-equation IR
file at run time. No per-entry `.py` or `.js` source file is ever generated.** This is the
single biggest lever against a second 946→793-class drift, and it overrides the alternative of
generating one source file per eligible entry (which would create 100+ individually-drifting files
the moment the shared IR schema changes underneath them).

```
registry/executable/<mangled-code>.json      one small IR sidecar per reviewed-eligible entry
        │  read at run time by
        ▼
scripts/executable/ir_kernel.py  +  ir_eval.py      (Python reference: Fraction only)
site/static/js/_qfrac.js  +  _ir_eval.js            (JS twin: BigInt-rational only)
```

Both interpreters are written and reviewed **once**, ship unversioned at a fixed path (the same
"shared, once-generated, permanent, cacheable" convention already used for Coq file naming and for
`mcp/toledo_mcp/export_static.py`'s `mangle_code`), and every new eligible equation adds one small
JSON file, never a new line of interpreter code. Widening what the interpreter can express (a new
operator, a new transcendental function) is a reviewed change to exactly two files, done rarely and
deliberately — not a per-entry decision.

---

## 3. IR schema — `registry/executable/<code>.json`

File name uses the **existing** Coq-file mangling rule (`registry/SCHEMA.md`), reused verbatim
because it is already the shared, reviewed convention for turning a Toledo code into a filesystem-
safe name: `code.replace('/','__').replace('.','_').replace('-','_')` + `.json`. The literal `code`
is stored inside the file; this mangling is filesystem-only, exactly as it already is for Coq.

```json
{
  "schema_version": "executable-ir-0.1",
  "code": "EQ-045/P.03.v1",
  "root": "EQ-045",
  "generated_from_commit": "<toledo git sha at extraction time>",
  "source_statement": {
    "format": "latex+ascii",
    "text": "<verbatim statement.latex text this IR was extracted from>"
  },
  "classifier": {
    "tool": "sympy.parsing.latex.parse_latex",
    "sympy_version": "1.14.0",
    "antlr4_version": "4.11.0",
    "parsed_at": "2026-09-08",
    "parsed_repr": "<str(sympy expr) at extraction time, for human spot-check>"
  },
  "variables": [
    {"name": "n_dim", "domain": "Z_pos", "role": "input", "unit": null,
     "constraint": "n_dim >= 1"},
    {"name": "result", "domain": "Q", "role": "output", "unit": null, "constraint": null}
  ],
  "relation": "eq",
  "lhs": { "op": "var", "name": "result" },
  "rhs": { "op": "call", "fn": "some_closed_form",
           "args": [ { "op": "var", "name": "n_dim" } ] },
  "transcendental": null,
  "eligibility": {
    "classifier_candidate": true,
    "reviewed_by": "<human registrar id>",
    "reviewed_at": "2026-09-09",
    "review_note": "Genuine Q->Q relation once the surrounding prose's calculator-identity
                    caveat is applied; sample_inputs below chosen inside the stated domain."
  },
  "sample_inputs": [ {"n_dim": "3"}, {"n_dim": "10"} ],
  "status": "reviewed_eligible",
  "drift_note": null
}
```

- **`variables[].domain`** is one of `Z` / `Z_pos` / `Q` / `Q_pos` / `Q_nonzero` — always a subset
  of ℚ, per the mathematical floor (`glosa/methodology/P24_mathematical_floor.md`'s ℚ-computability
  law); an entry needing a genuine ℝ-only input (a free real parameter with no rational sampling
  convention) is not eligible, full stop — no domain value for "real" exists in this schema.
- **`expression_tree` (the `lhs`/`rhs` node shape)** is a small generic AST: every node is
  `{"op": "add"|"sub"|"mul"|"div"|"pow"|"neg"|"const"|"var"|"call", ...}`; `const` nodes carry
  `"value"` as an exact rational **string** (`"22/7"`, `"3"`, never a JSON number, so no reader's
  JSON parser silently rounds it to a float); `var` nodes carry `"name"`; `call` nodes carry `"fn"`
  and `"args"`. `fn` is one of a small fixed allowlist the shared kernels implement (§4, §5) —
  never an arbitrary string the kernel `eval`s.
- **`transcendental`**, present only when `rhs`/`lhs` contains a `call` node whose `fn` is not
  Q-exact (`sqrt`, `sin`, `cos`, `exp`, `log`, `pi_const`, ...): `{"terms_param": "n_terms",
  "algorithm_py": "taylor_argument_reduced", "algorithm_js": "continued_fraction",
  "default_terms": 40}`. **`algorithm_py` and `algorithm_js` must never name the same algorithm
  family for the same `fn`** — a build-time lint (S2, §10) rejects a sidecar where they match,
  because a shared bug in one algorithm re-typed twice would let a loose cross-check spuriously
  pass (the discipline `glosa/cases/repro/run_IDM_ladder_constants.py` already applies to Machin's
  formula vs. mpmath, generalised here to Python-reference-vs-JS-twin instead of vs.-oracle).
- **`sample_inputs`** — human-declared at review time, inside each variable's stated domain; these
  are the pre-registered inputs the Reproduction Card (§6) runs against, chosen **before** any run,
  never tuned after seeing a mismatch.
- **`eligibility.reviewed_by`** — **non-empty is mandatory before `status` may be anything other
  than `candidate`.** The classifier (S1) only ever writes `status: "candidate"` with
  `eligibility.reviewed_by: null`; a human registrar is the only writer of `reviewed_eligible` /
  `reviewed_rejected` / `built`. A `reviewed_rejected` sidecar is kept (not deleted) as a record of
  what the classifier proposed and why a human declined it — this is what lets a future reader
  distinguish "never looked at" from "looked at, correctly rejected."
- **`status`** lifecycle: `candidate` → (`reviewed_eligible` | `reviewed_rejected`) →
  `built` (S2 has generated no per-entry file, but has validated this IR loads and evaluates
  cleanly against `sample_inputs` under the shared kernel) → referenced by a filed Reproduction
  Card (S3) and, only then, surfaced by the site widget (S4, §9) and `toledo_eval` (§10).
- **`drift_note`** — same three-state convention as `registry/CANONICAL.json`'s own field
  (`registry/SCHEMA.md`): omitted when not applicable, present only to disclose a known weakness
  in this specific extraction (e.g. a unit that could not be confirmed from the source statement).

### 3.1 The computed `executable` block on `CANONICAL.json`

The **one** narrow, already-authorised exception to "do not edit `CANONICAL.json` content fields by
hand" (the same exception the `resistance` block already uses, `registry/SCHEMA.md`'s S3 addendum):
a new script, `scripts/compute_executable.py`, mirroring `scripts/compute_resistance.py`'s own
shape exactly (same in-place-write discipline, same "never touches `LINEAGE.jsonl`" rule, run in
the Makefile immediately alongside `resistance:` and before `build:`), writes:

```json
"executable": {
  "computed_at": "2026-09-09",
  "status": "not_attempted" | "candidate" | "reviewed_ineligible" | "reviewed_eligible" | "built",
  "ir_ref": "registry/executable/EQ_045__P_03_v1.json",
  "reviewed_by": "<human registrar id>",
  "reproduction_card": {"citation": {"repo": "glosa", "commit": "<sha>",
                                      "path": "cases/repro/EXEC-EQ_045__P_03_v1.json"},
                          "result_status": "PASS" | "FAIL" | "ERROR"}
}
```

`ir_ref`, `reviewed_by`, and `reproduction_card` are **omitted, not null**, whenever no IR sidecar
exists for a code yet — the same three-state convention `owner_year`/`drift_note` already use.
**`reproduction_card.result_status`** (added 2026-09-09, R1-2 integration fix) is read verbatim
from the filed card's own `result.status` in `registry/reproduction_card_index.json` — never
recomputed — and is itself omitted (not null) whenever the card exists but has not yet run
(`result: null`, still `PENDING`). A disclosed `FAIL` is carried here exactly as prominently as a
`PASS`: this is the one field that lets `registry/executable/INDEX.json` and `/browse/`/`/about/`
(§7) distinguish "filed and PASSED" from "filed and FAILED" without opening the card file, instead
of collapsing both into the same binary "has a card" signal. The
**vast majority of the 1,267 entries carry no `executable` block at all**, by design (§1.4) — this
is never rendered as "false" without the domain-honesty note (§9.3).

---

## 4. Python reference runtime — `scripts/executable/`

- **`ir_kernel.py`** — the shared AST walker. Pure standard library: `fractions.Fraction` for every
  Q-exact node; a small, named, from-scratch finite-series/Newton module for each transcendental
  `fn` (mirroring the shape `glosa`'s own `provefull/_kernel.py`/`cosmology.py` already use for
  pi/e/sqrt: argument-reduced Taylor series for `exp`/`sin`/`cos`, Machin-style arctan series for
  `pi_const`, Newton-Raphson for `sqrt`), every step computed on `Fraction` — **`mpmath` and
  `float` never appear in this file or in `ir_eval.py`**, checked by a CI grep guard (§9).
- **`ir_eval.py`** — loads one IR sidecar, validates it against the schema (§3), binds
  caller-supplied input values (accepted only as strings — `"3"`, `"22/7"` — parsed via
  `Fraction(str)`, never accepted as a JSON/Python `float`, so no floating value ever crosses into
  the evaluator), walks the tree via `ir_kernel`, and returns `{"value": "<exact Fraction as
  string>", "terms_used": int | null, "error_bound": "<Fraction as string>" | null}` for a
  transcendental result, or `{"value": ..., "terms_used": null, "error_bound": null}` for a fully
  Q-exact one. This is the **one** evaluator every other consumer (site widget's Python-side test
  harness if any, `toledo_eval`, the cross-check runner) imports — never re-implemented.
- Every generated artifact this stream touches (none — S1/S2 write only the two shared files above
  plus the sidecars, no per-entry generated code) carries no header, because there is nothing
  per-entry to stamp; the sidecar itself already carries `code` and `generated_from_commit` (§3).

---

## 5. JavaScript twin — `site/static/js/`

- **`_qfrac.js`** — a small BigInt-based exact rational type: `{num: BigInt, den: BigInt}`,
  always kept in lowest terms via a BigInt GCD, with `add`/`sub`/`mul`/`div`/`pow` (integer
  exponent only) and a `toDecimalString(digits)` **display-only** helper — the one place a
  floating-point-shaped string is ever produced, and it is never fed back into a comparison.
- **`_ir_eval.js`** — the same AST walker as `ir_kernel.py`, ES2020, zero dependencies, loaded by a
  bare `<script src="/static/js/_qfrac.js">` + `<script src="/static/js/_ir_eval.js">` pair with no
  bundler, no `import`, no network fetch of anything beyond these two same-origin static files.
  Every transcendental `fn` is implemented by the **algorithm named in the IR's own
  `transcendental.algorithm_js`** (§3), which a build-time lint enforces is never the same family
  as `algorithm_py` — e.g. Python's Machin-arctan-series `pi_const` reference is checked against a
  JS twin computing `pi_const` via a different rational approximation scheme (a distinct continued
  fraction or a different arctan identity), so agreement between the two is evidence of two
  independent derivations, not one algorithm typed twice. **`Math.sin`, `Math.PI`, `Math.sqrt`, or
  any other native floating-point transcendental never appears in the evaluated/compared value
  path** — checked by a CI grep guard (§9); `toDecimalString` is the sole, named exception, and it
  is display-only.
- These two files are **the only JavaScript this feature ships.** No per-entry `.js` file is ever
  generated; an entry page embeds a two-line `<script>` reference to these permanent, cacheable
  files plus a small inline `<script>` block carrying only that entry's IR (fetched as inline JSON
  at build time, never over the network at page load — §9).
- `node` (already present on this workstation, v24.16.0, native `BigInt`) runs these exact same two
  files headlessly for the automated cross-check (§6) — this is a **subprocess invocation of the
  shipped browser file**, never a second implementation for automation's sake.

---

## 6. Cross-check runner + Reproduction Card registration

**One generic, code-parameterized script — `scripts/executable/crosscheck_runner.py`** — not a
bespoke per-equation file (unlike glosa's own two existing example runners,
`run_EQ-045_gauge_dim.py` / `run_EQ-068_higgs_pdg.py`, each a separate hand-written file per claim;
this runner is the opposite pattern, one script for every eligible code, invoked as
`crosscheck_runner.py --code <toledo_code>` or `--all-reviewed` to batch over every
`reviewed_eligible`/`built` sidecar).

**Resolving one apparent tension directly:** this document's task explicitly asks for "a P22
reproduction card per entry," while the do-not-build list (§13 item 9) forbids "per-entry bespoke
hand-authored Reproduction Cards." Both are satisfied together: the **output** is still one filed
`cases/repro/EXEC-<mangled-code>.json` per equation (P22's schema is inherently one-file-per-claim,
and `scripts/register_reproduction_evidence.py` already reads `cases/repro/*.json` wholesale with
zero changes needed) — but every one of those files is the **mechanical output of the same one
generator function** inside `crosscheck_runner.py`, never hand-typed. "Per-entry" describes the
generated artifact; "never per-entry" (§13 item 9) describes the authoring effort, which stays at
exactly one script regardless of how many cards it eventually emits.

Per code, the runner:

1. Loads the IR sidecar; refuses (no card written) unless `status` is `reviewed_eligible` or
   `built` — a `candidate` or `reviewed_rejected` sidecar never reaches this step.
2. Writes a **pre-registered prediction** into the card **before** running anything: `sample_inputs`
   (from the IR, chosen at review time, §3) and, for a transcendental result, the declared
   `error_bound` at the IR's `default_terms` — exactly the "declared before run" discipline P22
   requires structurally (`glosa repro new`'s own fail-closed shape).
3. Runs the Python reference (`ir_eval.py`) once, for real, against each `sample_inputs` row.
4. Runs the JS twin once, for real, via `node _ir_eval.js` (a declared subprocess, `environment`
   block names `node` the same way an oracle names `mpmath`) against the identical inputs.
5. Compares the two exact rational results (Q-exact case: must be **identical**, not merely close;
   transcendental case: difference must fall inside the pre-registered `error_bound`, which is
   itself derived from `default_terms` and each side's own truncation, never loosened after seeing
   the actual delta) and writes `result.status` — `PASS`/`FAIL`/`ERROR`, honestly, a disclosed
   `FAIL` filed exactly as legitimately as a `PASS` (P22's own design principle).
6. Emits `cases/repro/EXEC-<mangled-code>.json` under a **sibling `glosa` checkout** (the existing
   `--glosa-repo PATH`-style convention `run_IDM_ladder_constants.py` and
   `register_reproduction_evidence.py` both already use — no absolute path, no username, ever
   written into the card), with:
   - `toledo_codes: ["<code>"]`
   - `oracle: {"kind": "twin_consistency", "source": "site/static/js/_ir_eval.js twin, run via
     node — walks the SAME IR tree as the Python reference, extracted once from the same Toledo
     statement by the same pipeline, via a different algorithm family per
     transcendental.algorithm_js where applicable (see IR sidecar)"}`. **Integration fix
     (2026-09-08):** this is `"twin_consistency"`, never `"independent_implementation"` —
     the two evaluators are generated to walk the *same* IR tree the *same* extraction pipeline
     produced from the *same* statement, so agreement between them is evidence a mis-extraction
     bug would reproduce identically on both sides (`ops/executable_classifier_report.md`'s own
     disclosed bare-word/superscript hazards); it is real, filed, hash-frozen evidence and holds
     R3 (§6 step 3, a reproducible `ai_at_runtime==0` run happened), but
     `scripts/compute_resistance.py::EXTERNAL_ORACLE_KINDS` deliberately excludes it, so it can
     never hold R4/R6 the way a genuine external-oracle `oracle.kind` can (registry/SCHEMA.md,
     `glosa/schema/reproduction_card.schema.json`'s six-value enum,
     `glosa/methodology/P22_reproduction_ledger.md`).
   - `environment.packages: {}` (both reference and twin are stdlib/BigInt-only; `node` itself is
     named in `run.command`, not as a Python package)
   - `run.ai_at_runtime: 0` (a mechanical comparison of two already-written, already-reviewed
     evaluators — no model call at run time)
   - `lineage.run_by`: the invoking identity; `lineage.ces`: this run's own Core Epistemic
     Structure block, scoped to this specific reproduction run (never a restatement of any paper-
     or claim-level CES block, per the schema's own one-fact-one-home note)
7. **Registration into `registry/reproduction_card_index.json` is unchanged** — the existing
   `scripts/register_reproduction_evidence.py [--glosa-repo PATH]` already regenerates that index
   wholesale from every `cases/repro/*.json` file; the new `EXEC-*.json` cards are picked up by
   that unmodified pipeline the next time it runs, with **zero edits to
   `register_reproduction_evidence.py` itself**.
8. `registry/executable/INDEX.json` — a single generated (never hand-edited) aggregate listing
   every sidecar's `code`/`status`/`reviewed_by`/card citation, the executable-feature's own
   analogue of `registry/genesis_root.json`'s summary role; not a second, competing registry (§13
   item 7) — every fact in it is a projection of the sidecars plus the citation indexes already
   described in `registry/SCHEMA.md`.

A live "try it" widget result (§7) is **never** written into any of this — only a filed,
hash-frozen card that has been through this runner counts (§13 item 10).

---

## 7. Site try-it widget spec

No network, no build step, offline-first — the same standing constraint `site/DESIGN.md` already
states for the rest of the site ("reading works with JavaScript disabled; search is a progressive
enhancement over the same data").

- Rendered only on an entry page whose `executable.status` (§3.1) is `reviewed_eligible` or
  `built` — every other entry page is unchanged, no stub, no "try it (coming soon)" placeholder
  (§13 item 3): an entry with no executable form gets nothing extra at all.
- The widget is a plain HTML `<form>` (one numeric/rational text `<input>` per `variables[].role
  == "input"`, pre-filled with the first `sample_inputs` row) plus a "compute" `<button>` and a
  result `<div>` — works with JavaScript disabled (the form simply does nothing without JS; the
  static page around it, including the source LaTeX as visible text, is unaffected, per
  `site/DESIGN.md`'s existing MathML/no-JS fallback convention).
- With JavaScript enabled: on submit, parses each input as an exact rational (`p/q` or an integer;
  a malformed input is rejected inline, never silently coerced to a float), calls `_ir_eval.js`
  against the entry's own inline-embedded IR JSON (embedded once at build time inside a
  `<script type="application/json">` block on the page — **never fetched over the network** at
  widget run time), and renders the exact rational result plus a **separately labelled** decimal
  display (`_qfrac.js`'s `toDecimalString`, explicitly captioned "decimal display only, not the
  computed value") so the exact/approximate distinction is visible to a reader, not just to code.
- The widget's own result is captioned, verbatim, "Not a Reproduction Card — a live convenience
  check. The filed Reproduction Card for this entry, run offline, is the evidence" with a link to
  the card's citation — this line exists specifically because a live browser result must never be
  mistaken for, or wired to, the R3/R4/R6 evidence that only §6's filed card provides (§13 item 10).
- `/browse/` gains one column showing the entry's own state, computed straight from
  `executable.status` (§3.1) and, when present, `executable.reproduction_card.result_status`
  (§3.1, R1-2 integration fix, 2026-09-08): **not a binary `yes/no`** — `not filed` (no sidecar,
  or a sidecar not yet `reviewed_eligible`/`built`) \| `filed — PASS` \| `filed — FAIL` \|
  `filed — ERROR`. A binary column would render a disclosed FAIL identically to an unattempted
  entry; this repository's own README worked-cards table and P22/P23's "cited regardless of
  outcome, never softened" discipline both require a FAIL to be exactly as visible as a PASS.
  Accompanied, once per page (not per row), by the domain-honesty note from §1.4, verbatim, so the
  column is never misread as a rigor or completeness score across domains. `/about/`'s corpus-wide
  tally is the identical `not filed / PASS / FAIL / ERROR` breakdown (mirroring
  `registry/executable/INDEX.json`'s own `counts.by_result`), never one collapsed count, and
  carries the same domain-honesty note next to it.

---

## 8. MCP `toledo_eval` contract (21st tool)

`mcp/toledo_mcp/server.py` currently defines exactly 20 tools (`toledo_search` … `toledo_
proposal_status`, confirmed by direct count against this checkout). `toledo_eval` is the 21st,
following the file's own existing conventions (`@mcp.tool()` + `@_safe`, an `_envelope`/`_invalid`
return shape, a docstring stating exactly what it does and does not do):

```python
@mcp.tool()
@_safe
def toledo_eval(code: str, inputs: dict[str, str]) -> dict[str, Any]:
    """Evaluate one reviewed-eligible executable equation at declared rational inputs.

    Fail-closed for any code with no IR sidecar, or whose sidecar status is not
    "reviewed_eligible"/"built": returns {"evaluable": false, "code": ..., "reason": "..."}
    rather than raising or guessing. `inputs` values MUST be strings ("3", "22/7") -- a
    JSON/float number is rejected, never silently coerced, so no floating value ever
    crosses into the evaluator.

    Reuses scripts/executable/ir_eval.py -- the SAME in-process evaluator the site widget's
    build step and the cross-check runner both call -- never a second, parallel
    interpretation of the same IR. A live toledo_eval result carries the identical
    "not a Reproduction Card" caveat the site widget shows (see docs/EXECUTABLE_EQUATIONS_
    v0_1.md sec.7) and is never written into any resistance/reproduction record.
    """
```

- Success shape: `data: {"evaluable": true, "code", "value": "<exact rational string>",
  "approx_display": "<decimal string, captioned display-only>", "terms_used": int | null,
  "error_bound": "<rational string>" | null, "reproduction_card": {citation} | null}`.
- Failure shape: `data: {"evaluable": false, "code", "reason": "no IR sidecar for this code" |
  "sidecar status is 'candidate', not yet human-reviewed" | "sidecar status is
  'reviewed_rejected': <review_note>" | "<input name> could not be parsed as an exact
  rational"}`.
- Import path: `from scripts.executable import ir_eval` (or an equivalent local-file import,
  matching `mcp/toledo_mcp/core.py`'s existing pattern of importing `scripts/toledo_build.py` by
  file path rather than duplicating its logic) — **never** a second AST walker written inside
  `server.py` or `core.py` (§13 item 4).
- `mcp/toledo_mcp/export_static.py` gains one passthrough addition: `/v1/entries/<code>.json`
  carries the entry's `executable` block verbatim (no live evaluation over the static API — the
  static export is read-only data, `toledo_eval` itself stays MCP/live-server-only), and a new
  `/v1/executable-summary.json` mirrors `/v1/resistance-summary.json`'s existing pattern.

---

## 9. Tests

- **Schema tests** (`tests/executable/test_ir_schema.py`): every `registry/executable/*.json`
  matches the shape in §3; `status` in `{reviewed_eligible, built}` implies non-empty
  `eligibility.reviewed_by` and non-null `eligibility.reviewed_at` (mechanically checked, mirroring
  `tests/test_registry.py`'s existing `test_status_consistency` pattern); every `code` referenced
  by a sidecar resolves to a real, non-`not_an_equation`/`split` entry in `CANONICAL.json`.
- **Shared test vectors** (`tests/executable/vectors.json`): a small set of `{ir, inputs, expected}`
  rows consumed by **both** the Python and the JS test suites, so the two kernels are checked
  against the identical expectations rather than two hand-typed, potentially-diverging test files.
- **`ir_kernel.py` / `ir_eval.py` unit tests** (`tests/executable/test_ir_kernel.py`): every vector
  above; explicit checks that dividing by a variable whose domain excludes zero raises rather than
  silently returning `0` or `inf`; a `float`/`mpmath` import-absence check via `ast`-parsing the two
  source files (no `import float`... rather: grep/AST scan for `mpmath` and any bare float literal
  used in an arithmetic operator context, matching the style already used elsewhere in this repo
  for denylist-style guards, e.g. `mcp/toledo_mcp/regex_guard.py`).
- **`_qfrac.js` / `_ir_eval.js` tests** (`tests/executable/test_ir_kernel.js`, run via `node`): same
  shared vectors; a grep guard over both files asserting no `Math.sin`/`Math.cos`/`Math.PI`/
  `Math.sqrt`/`Math.exp`/`Math.log` token appears outside `toDecimalString`'s own function body.
- **Cross-check runner integration test** (`tests/executable/test_crosscheck_runner.py`): one fixed
  fixture IR + a `--dry-run` mode that skips writing into the sibling `glosa` checkout, asserting
  the runner's own PASS/FAIL/ERROR classification against a hand-verified expected result.
- **`toledo_eval` MCP test** (`tests/executable/test_toledo_eval.py`): fail-closed for a code with
  no sidecar; fail-closed for a `candidate`-status sidecar; correct evaluation for a fixture
  `reviewed_eligible` sidecar; a non-string input is rejected.
- **Site widget test** (`site/checks/` addition): a grep-based no-network assertion over
  `_ir_eval.js`/`_qfrac.js` and over every rendered entry page's inline `<script>` block — no
  `fetch(`, `XMLHttpRequest`, or `WebSocket` token anywhere in the shipped widget code.
- **CI assertion from §1.1**: `content_mathml` non-null count over the `format in {latex,
  latex+ascii}` subset is `> 0` after `make build`.
- **Pilot-scale test**: the very first classifier + extraction pass (S1, §10) is run and timed
  against a ≤ 40-entry slice before any larger batch is scheduled — this is a process check, run by
  a human against a stopwatch, not an automated test, but it is a gate: no S2/S3/S4 work is
  scheduled against a larger number until this timing exists and is compared against this
  document's own estimate-free stance (§1.3, §13 item 8).

---

## 10. Build streams and file ownership

| Stream | Owns (writes) | Reads (never edits) | Depends on |
|---|---|---|---|
| **S1** — classifier + IR extraction | `scripts/executable/check_antlr4.py`, `scripts/executable/classify.py`, `scripts/executable/extract_ir.py`, `registry/executable/*.json` (drafts, `status: candidate` only — a human registrar, not S1's own script, flips a sidecar to `reviewed_eligible`/`reviewed_rejected`), `ops/executable_classifier_report.md` (per-domain table + the §1.3/§1.4 honesty notes, kept current) | `registry/CANONICAL.json`, `registry/entries/*.json` | Re-run `make build` once §1.1's precondition fix lands |
| **S2** — codegen (py + js) | `scripts/executable/ir_kernel.py`, `scripts/executable/ir_eval.py`, `site/static/js/_qfrac.js`, `site/static/js/_ir_eval.js`, `tests/executable/vectors.json`, `tests/executable/test_ir_kernel.py`, `tests/executable/test_ir_kernel.js` | `registry/executable/*.json` (reviewed-eligible ones only, to validate against) | S1's sidecar schema (frozen before S2 starts coding against it) |
| **S3** — cross-check runner + card registration | `scripts/executable/crosscheck_runner.py`, `scripts/compute_executable.py`, `registry/executable/INDEX.json` (generated), the `executable{}` block on `CANONICAL.json` (computed only, §3.1), sibling-repo output `glosa/cases/repro/EXEC-*.json` | `scripts/register_reproduction_evidence.py` (zero edits — reads its output unchanged), `ir_eval.py`/`_ir_eval.js` (calls, never re-implements) | S2's two shared kernels; a `reviewed_eligible` sidecar to run against |
| **S4** — site widget + MCP tool + tests | `site/templates/executable_widget.tmpl.html` (or the equivalent addition inside the existing entry-page template), `site/build_site.py`'s widget-embedding + `/browse/` column + `/about/` tally additions, `mcp/toledo_mcp/server.py`'s `toledo_eval` tool, `mcp/toledo_mcp/export_static.py`'s passthrough addition, `tests/executable/test_toledo_eval.py`, `site/checks/` no-network test | `ir_eval.py` (imports, never re-implements — §13 item 4) | S2's two shared kernels; S3's `executable{}` block for the `/browse/` column |

`Makefile` gains one new target, mirroring the existing `resistance:`/`build:` pattern exactly:

```makefile
executable: build ; python3 scripts/compute_executable.py
```

placed so `make build` (which already runs `resistance:` first) can be followed by `make
executable` without re-running the full registry build — the same "check only what changed"
discipline this workspace already applies to full-arc audits generally.

---

## 11. Adoption metric

The real success signal for this feature, going forward, is **not** a coverage percentage: track
how many Reproduction/claim cards, going forward, cite a `toledo_eval` call plus its `EXEC-`
reproduction-card id **instead of** a hand-typed number in prose. A rising count here is the
feature earning its keep; a flat count means the feature shipped but nobody is actually citing it,
which is itself useful, honest information — not a reason to inflate the entry count instead.

---

## 12. Grafts applied (traceability)

Every graft item supplied with this task landed somewhere specific above; listed here so a reader
can check none was dropped, without repeating the full text a second time.

1. *Proposal 3, antlr4 precondition* → §1.1 (precondition check + CI assertion).
2. *Proposal 2, R5 named risk* → §1.5.
3. *Proposal 2, eligibility-gate wording* → §1.2's opening sentence (verbatim reuse).
4. *Proposal 3, per-domain honesty note* → §1.4, §7 (`/browse/`, `/about/`).
5. *Designer 1, real sympy classifier as authoritative measurement* → §1.3 (re-run today, numbers
   corrected further per the new false-positive class §1.3 found).
6. *Designer 1, per-domain breakdown table* → §1.3's table.
7. *Designer 1, "floor not ceiling" + status/format gate* → §1.2.
8. *Designer 3, Content MathML non-functional disclosure* → §1.1 (re-verified directly, corrected:
   antlr4 is now present on this workstation — the fix, not just the disclosure, is specified).
9. *Designer 3, bare-equation-name / qualitative-label guard* → §1.3 (extended: prose-as-symbol-
   product is a stronger version of this same hazard, found directly this pass).
10. *Designer 3, adoption metric* → §11.
11. *Designer 3, start pilot at ~25–40, time it for real* → §1.3, §9's pilot-scale test.
12. *Designer 2, genuinely different transcendental algorithm per side* → §3 (`transcendental`
    field), §5, §6 step 5.
13. *Designer 2, no-per-entry-generated-source-file architecture* → §2 (the architecture decision).
14. *Designer 3, checksum/staleness guard applied to whatever ships* → not carried forward as a
    separate mechanism: under the winning architecture (§2) there are no per-entry generated
    source files to go stale — `generated_from_commit` inside each IR sidecar (§3) plus the schema
    test (§9) that every sidecar's referenced `code` still resolves serves the same purpose for the
    two artifacts (sidecars, shared kernels) that do exist.
15. *Designer 2 / 3, mandatory reviewed_by gate* → §3 (`eligibility.reviewed_by`), §13 item 2.
16. *All three, P22 wiring into the existing pipeline with zero pipeline changes* → §6 step 7.
17. *All three, toledo_eval as the 21st tool, fail-closed, reusing the in-process evaluator* → §8.
18. *Designer 1, shared unversioned `_qfrac`-style filename convention* → §5.

---

## 13. Do-not-build (consolidated, deduplicated across all three do-not-build lists supplied)

Every distinct item across the three supplied lists, merged (several appeared, worded slightly
differently, in two or all three lists):

1. **No hand-written JavaScript or Python for any entry, at any scale** — not for all 1,267, not
   for a 553/549/272-entry "eligible ceiling," not even for a small pilot. Every runtime artifact
   is either the two shared, hand-reviewed kernels (§4, §5) or a small IR sidecar (§3) — never a
   bespoke per-equation implementation typed by a human, and never generated ahead of an entry that
   has actually earned the eligibility gate.
2. **No auto-promotion from a classifier's raw output.** `sympy.parsing.latex` parse-success (or
   any regex/token heuristic) only ever produces `status: "candidate"`; promotion to
   `reviewed_eligible`/`reviewed_rejected` requires a non-empty human `eligibility.reviewed_by` —
   demonstrated necessary directly in §1.3 by a new, stronger false-positive class this pass found
   (prose parsing as a symbol product) beyond the bare-symbol and categorical-statement false
   positives already caught in the proposal round.
3. **No executable form for a non-computable entry.** Definitions, categorical/functional
   statements, quantifier/set-membership relations, bare equation names with no formula, Coq-only
   proof objects, prose — these get nothing at all: no stub, no placeholder, no "coming soon" block.
4. **No second, parallel, independently-written interpreter or transcendental library anywhere.**
   `toledo_eval`'s fallback path, any future MCP addition, any future codegen experiment — all call
   the exact same `ir_eval.py` / `_ir_eval.js` this spec builds once, never a freshly authored third
   implementation of the same walker. The one deliberate exception is Python-reference-vs-JS-twin
   *within* a single transcendental function (§3, §5, §6) — required to be genuinely different
   algorithms specifically so the cross-check is real, not two typings of the same series.
5. **No float, anywhere in the reference/comparison path.** `mpmath`/`numpy`/a bare Python `float`
   never enters `ir_kernel.py`/`ir_eval.py`; `Math.sin`/`Math.PI`/any native JS floating-point
   transcendental never enters the evaluated/compared value in `_ir_eval.js` — a decimal display
   helper is the sole, named, isolated exception on each side, checked by CI grep guards (§9).
6. **No network fetch of per-entry IR or generated code at run time.** The site widget's IR is
   inlined into the page at build time; the two shared kernel files are same-origin static assets,
   loaded once and cacheable, never re-fetched per entry.
7. **No second, parallel registry or index file for executable metadata.** The one allowed
   hand-authorable-adjacent surface is the computed `executable{}` block on `CANONICAL.json` (§3.1,
   written exclusively by `scripts/compute_executable.py`) plus `registry/executable/INDEX.json`
   (generated, never hand-edited) and the existing reproduction-card/resistance-index pipeline —
   never a fourth, competing tracking mechanism invented alongside these.
8. **No commitment to a fixed large-scale target (500, 553, or even 100 entries) before a real,
   timed pilot batch exists.** Every hour/entry-count estimate any prior proposal round produced is
   Dr-tier narrative, not measured (all three proposals concede this themselves) — this document
   commits to a ~25–40-entry first pilot (§1.3, §9) and nothing beyond it.
9. **No per-entry bespoke *hand-authored* Reproduction Card.** The one generic
   `crosscheck_runner.py` (§6) is the entire authoring surface; that it mechanically emits one
   filed card per equation is not the same thing as authoring 100+ cards by hand (§6's own
   "resolving one apparent tension" paragraph explains this distinction explicitly).
10. **No treating a live browser "try it" widget result as evidence, and no wiring it to
    resistance/R3/R4/R6.** Only a filed, hash-frozen Reproduction Card run through §6's offline
    process may move a rung; the widget is captioned, verbatim, as a non-evidentiary convenience
    (§7).
11. **No leaning on sympy's Content MathML / `antlr4-python3-runtime` as an already-working
    shortcut without first confirming the precondition for real** (§1.1) — pin the dependency, add
    the CI assertion, and re-run the build; do not assume either is already functional from a stale
    build artifact or from memory of a prior session.
12. **No treating any classifier's raw parse/regex-match count as itself a coverage or rigor
    metric**, in this document or in any future report drawing on it — report the per-domain skew
    honestly (§1.3, §1.4) as the shape of what these domains actually are, not as a quality signal.
13. **No hand-editing any generated file, the `executable{}` block, or `registry/executable/
    INDEX.json`** — these are build-step-only outputs, the same one-fact-one-home discipline
    `coq/canonical/` and the `resistance{}` block already hold the rest of this registry to.
