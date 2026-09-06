# Master Equation River — Coq Formalisation

Machine-checked companion to the Master Equation River provenance audit
(`../v1_3/main.tex` for eq. 1–66, `../v1_4/main.tex` for eq. 67–79). Every
equation (1)–(79), including `eq:lowrank` and `eq:gate`, is assigned
exactly one of three tiers and formalised accordingly. See `MR_Ledger.md`
for the full equation → file → identifier → tier → verification table.

## Discipline (readout-first / information-discrete-math)

- No `Coq.Reals`, no classical axioms (`Classical`, functional
  extensionality), no `Admitted`, no top-level `Axiom`/`Parameter`.
- All numeric content lives on `Q` (rationals) or `nat`/`bool`/finite
  lists — never on a continuum type.
- Abstract objects (state spaces, readout maps, vectors) are introduced as
  `Variable`/`Hypothesis` inside a `Section`, discharged when the section
  closes — never `Parameter`/`Axiom` at top level.
- Where the paper's own notation is continuum-flavoured (`exp(...)`, a
  derivative, a max over an unbounded set), the Coq statement uses an
  explicit discrete replacement (a `Q`-valued score, a discrete difference,
  a max over a finite list) and the comment says so — the substitution is
  recorded, never hidden.

## Tiers

Exactly one of the following per equation (founder ruling BBL-165):

- **Th_coqc** — a `Lemma`/`Theorem`, proved. Typically either (a) a
  non-collapse fact `X <> Y` proved by exhibiting a finite model where two
  readouts differ, or (b) an accounting identity/monotonicity fact proved
  over `Q`.
- **Definition** — a `Definition`/`Record`/`Inductive` typing the object
  exactly as the paper writes it, tagged `(* tier: Definition, eq. (n) *)`.
- **Open** — a `Prop`-valued `Definition` named `Open_eqNN`, stating the
  hypothesis in the model's own vocabulary, tagged
  `(* tier: Open (not proved; falsifier: ...) *)`. Never `Admitted`.

## Files

| File | Equations | Section of `main.tex` |
|---|---|---|
| `MR_Foundation.v` | 1–8 | 3.1 Foundation; 3.2 Naming; 3.3 Retention |
| `MR_Resonance.v` | 9–18 | 3.4 Resonance; 3.5 Rhythm/Momentum; 3.6 Accumulation/Barrier |
| `MR_Live.v` | 19–26 | Sec. 3.7 Live Possibility Field; Sec. 3.8/3.9 Potential/Power start |
| `MR_Prompt.v` | 27–34 | Sec. 3.8 Human-AI Coupling; Sec. 3.9 Dialogue/Retention start |
| `MR_Retention.v` | 35–42 (`eq:lowrank`=35, `eq:gate`=36) | Sec. 3.9 Session retention/candidate/direction; Sec. 3.10 Human Return |
| `MR_Corrections.v` | 43 | Sec. 4.1 kappa collision rename |
| `MR_River.v` | 44, 45, 65, 66 | Sec. 5 Corrected river + outer loop; Sec. 8 Conclusion |
| `MR_TopicEntry.v` | 46–51 | Sec. "Topic Entry and Agenda Ownership Before the Prompt"; Sec. "Human Return, Action, and World Feedback" |
| `MR_WorldSystem.v` | 52–64 | Sec. "The World-System Layer: Human Systemic Position and Human Conversion" |
| `MR_HCA.v` | 67–79 | v1.4 Sec. "Barrier Readout, Endorsement, Scaffold Fading, and Opportunity Conversion" (67–78); Sec. 5 outer-loop tail (79) |

All ten files exist as of this pass: `MR_Foundation.v`/`MR_Resonance.v`
(Block A, eq. 1–18), `MR_Live.v`/`MR_Prompt.v`/`MR_Retention.v`/
`MR_Corrections.v`/`MR_River.v` (Block B, eq. 19–45, 65–66),
`MR_TopicEntry.v`/`MR_WorldSystem.v` (Block C, eq. 46–64, the v1.3
additions), and `MR_HCA.v` (Block D, eq. 67–79, the v1.4 RG-HCA barrier/
opportunity layer). `_CoqProject` lists all ten; every equation (1)–(79),
including `eq:lowrank`/`eq:gate` (=35/36), is formalised at exactly one
tier. See `MR_Ledger.md` for the complete equation → file → identifier →
tier → verification table across all four blocks.

## Build

```sh
cd research/society-justice-peace/master-river/coq
coq_makefile -f _CoqProject -o Makefile
make
```

## Verify (Print Assumptions on every proved Lemma/Theorem)

```sh
./verify.sh
```

For every `Theorem`/`Lemma`/`Corollary`/`Example` in every `MR_*.v` file,
`verify.sh` generates a scratch file that `Require`s the module and runs
`Print Assumptions <ident>`, then checks for the literal string "Closed
under the global context" — the only acceptable result under this
discipline (no stray axioms, no classical logic, nothing left open).
Prints one `PASS`/`FAIL` line per identifier and exits non-zero if any
fail.

Coq version: 8.20.1 (`/usr/bin/coqc`).
