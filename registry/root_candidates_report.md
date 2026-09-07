# Root candidates report — Theta programme and CMC (Toledo v1.1 Lane C, task 2)

**Purpose.** The overnight handoff names two bodies of work that read, on inspection, like they
could be candidate ROOTS in the sense `registry/GENESIS_CODE_SCHEME.md` uses (a Layer-0 object
alongside `EQ-001`…`EQ-071`, `weld`, `MQ.08`, etc.) but for which **no `genesis_root.json` row
exists today**. This report states what each one is and where it can be found, on the public
record only, and stops there: it recommends that a future root-registry extension be considered
by the founder, it does not create one. No code is invented, no row is added to
`registry/genesis_root.json`, and no entry in `registry/CANONICAL.json` cites either of these as a
`root` or `parents[].code`.

---

## 1. The Theta programme

**What it is.** A line of work that elevates a fourth root-level object, `Theta` (the living/
relational-geometry state), to sit alongside the three objects the corpus already treats as
primary — reader `Phi`, record `Psi`, and retained difference `delta_R`. The elevation is stated
explicitly, as a dated founder ruling, in the header comment of a file that is part of this
programme:

> "CONTEXT (founder ruling 2026-08-08: Theta is elevated to a NEW ROOT alongside reader Phi /
> record Psi / retained difference delta_R)."
> — `coq/readout_genesis/formal/InfoThetaEdgeCensus_attempt.v`, lines 4–5 (imported into this
> Toledo tree; public source, see anchor below)

The programme's own working name, cited in another file of the same set, is `THETA_ROOT_PROGRAM.md`
(a companion document, not itself copied into this Toledo tree — only the `.v` files that cite it
were imported):

> "Step 5.2b-2 of THETA_ROOT_PROGRAM.md (companion: theta_minimal_living_v1.py)."
> — `coq/readout_genesis/formal/InfoThetaMinimalLiving_attempt.v`, line 4

**What it covers, by direct inspection of the imported files.** Nine `*_attempt.v` files under
`coq/readout_genesis/formal/` carry the `Info Theta…` naming and are the machine-checked pieces of
this programme currently present in this tree:

- `InfoThetaEdgeCensus_attempt.v` — 3-vertex admissible-operator census (declares the index set of
  `G[Theta] = G_0 + Σ_a Theta^a G_a`, a gap the file's own header says "was never declared anywhere
  in the corpus" before it).
- `InfoThetaCPSquareObstruction_attempt.v` — CP-signed-readout obstruction for real mixing
  matrices built from living-Theta-graph eigenbases (Item 2 Attempt 4 / programme step 5.4).
- `InfoThetaMinimalLiving_attempt.v` — the `n=2` reader/record/Theta system admits no living fixed
  point; minimal living system needs ≥ 3 slots (programme step 5.2b-2).
- `InfoThetaFixedPointBalance_attempt.v`, `InfoThetaLivingOrientationSign_attempt.v`,
  `InfoThetaOrientedSkewObstruction_attempt.v`, `InfoThetaQuartetSquareObstruction_attempt.v`,
  `InfoThetaSectorSpectrum_attempt.v`, `InfoThetaTopologyReadout_attempt.v` — further steps of the
  same programme (fixed-point balance conditions, orientation-sign obstructions, skew obstructions,
  quartet-square obstructions, sector-spectrum and topology readouts of the living-Theta system).

Two related files outside the `InfoTheta*` naming but explicitly part of the same bridge work are
also present: `InfoCPEquivariantGenerationBound_attempt.v` (the CP-conditional generation-count
bound the Theta programme's own bridge work cites) and `InfoRetentionMetricSkewDecomposition_attempt.v`.

**Where it lives (public git anchor only).** All of the above are `formal/*_attempt.v` files in the
**public** repository `github.com/morrocwi/readout_genesis`, anchored at commit
`082dde893b70c7500c13d463239909c99cf17f0a` (the same commit `registry/genesis_root.json["anchor"]`
already cites for `READOUT_GENESIS_CORE.md`). No LICENSE/CITATION.cff exists in that repo at this
commit (already recorded in `coq/readout_genesis/PROVENANCE.json`); these files were imported under
the Toledo design meeting's public-source import policy (T8), not under the private solver-arc rule.
The `THETA_ROOT_PROGRAM.md` companion document these files cite by name was not itself found copied
into this Toledo tree or into `READOUT_GENESIS_CORE.md`/the whitepaper at the anchored commit — its
existence is known only through these files' own citations of it; this report does not claim to have
read it directly, only the nine (plus two related) `.v` files above.

**Why no `genesis_root.json` row exists yet.** `genesis_root.json` was built (per
`registry/GENESIS_CODE_SCHEME.md`) strictly from `READOUT_GENESIS_CORE.md` and the whitepaper at the
anchored commit — the Appendix-C `EQ-0nn` stream plus the document's other named identifiers
(`weld`, `Forced.I`…, `Face.n`, `MQ.08`, `N1`…`N5`, `VI.n`, `T0`…`T2`, etc.). `Theta` already appears
*inside* many of those rows as a state-slot in composite equations (e.g. the `Z_n` state tuple, the
`G[Theta]` metric, the `Theta_{n+1}` update law — all captured as ordinary readings under their own
existing root codes, not as a root of their own), and a handful of genesis_root rows already carry
`Theta`-bearing statements (`LivingGeometry`, `Guard15`, `WP.S24.CalibrationDesign`). But the
2026-08-08 founder ruling that elevates `Theta` itself to root status alongside `Phi`/`Psi`/`delta_R`
is not, itself, a line inside `READOUT_GENESIS_CORE.md` or the whitepaper at the anchored commit — it
is stated only in the imported `.v` files' own header comments, i.e. downstream of the two documents
`genesis_root.json` was built from. Treating `Theta` as a fourth Layer-0 root therefore is not
something this registry build can do without either (a) a newer Genesis document snapshot that
states the elevation directly, or (b) a founder decision to add it as a root candidate sourced from
the `.v` header citation alone. **Recommendation, not action:** a future root-registry extension
could add a `Theta` row to `genesis_root.json` (role `root-axiom`, citing the 2026-08-08 ruling and
the nine `.v` files above as its earliest machine-checked evidence) once the founder decides whether
a `.v`-header-only citation is sufficient sourcing or whether `THETA_ROOT_PROGRAM.md` itself should
first be located/anchored. This report takes no position on that question beyond stating it.

---

## 2. CMC (Causal-Memory Closure)

**What it is.** A named bridge-theorem programme with its own target-class vocabulary
(`ClosureForm`, `TransportReadout`, `CMC_TargetClass`, `CMC_Bridge_Obligation`) and one explicitly
disclosed, named axiom:

> "Founder-level CMC axiom, intentionally named and disclosed. The project does not retreat from
> this claim. Journal-facing work must either defend this axiom, instantiate it for concrete
> classes, or exhibit an actual refuter satisfying CMC_Refuter_Burden."
> `Axiom cmc_bridge_axiom : CMC_Bridge_Obligation.`
> — `coq/solver-arc/formal/CMC_TargetClass_Definitions.v`

Five more files carry the same `CMC_` naming and continue the programme: `CMC_Bridge_Decomposition.v`,
`CMC_ClosureFree_Exhaustive.v`, `CMC_Independent_Definitions.v`, `CMC_ModelClass_Witnesses.v`,
`CMC_PhysicsClass_Instances.v` — 33 theorems/definitions across the six files per
`registry/coq_imports.json`'s manifest, all already imported and built in this Toledo tree
(`coq/solver-arc/formal/CMC_*.v`) and cross-referenced (33 rows) in `registry/coq_map.json`, every
one of them currently `"codes": []` — i.e. **already confirmed unmapped to any Toledo code**, which
is the same finding this report makes about a root row.

**Where it lives (public git anchor only): nowhere, as of this check.** Every `CMC_*.v` file in this
tree carries `"redacted": false` in `coq/solver-arc/PROVENANCE.json` and an `upstream_commit` of
`961151db33b0491cba8fabade69f594238d33f84` in the **private** solver arc — cited here as "solver arc
(private)" per this project's standing rule, never by its real repository name. A direct search of
every public repository already imported into this Toledo tree (`readout_genesis`, `readout_universe`,
`information-discrete-math`, `zero-readout-certifies`, `finite-readout-acceleration`) for the string
`CMC`, `Causal-Memory Closure`, or `Causal Memory Closure` returns **zero matches**. So, honestly
stated per the readout-not-truth discipline: **CMC currently has no public git anchor at all** — it
exists only inside the private solver arc. The task instruction to state "where it lives (public git
anchor only)" is answered here by that absence, not by citing the private path.

**Why no `genesis_root.json` row exists yet.** Same structural reason as Theta, stronger: `CMC` does
not appear anywhere in `READOUT_GENESIS_CORE.md` or the whitepaper at the anchored commit (confirmed
by direct grep of both files, as recorded in `registry/genesis_root.json`'s own build notes for other
similar checks), and it does not appear in any *public* repository at all. It is solver-arc-private,
project-internal vocabulary layered on top of the Genesis root (its `CMC_TargetClass` definitions
consume a `TransportReadout` record whose fields — `diffusion_positive`, `speed_positive`,
`speed_finite`, `retained_diffusive`, `intrinsic_finite_speed` — read as a bridge condition connecting
back to Genesis's own `EQ-005`/`EQ-006`/`EQ-007` persistence/discreteness/finite-speed root axioms,
but no source text anywhere states that identification explicitly, so this report does not assert it
as a `parents[]` link either). **Recommendation, not action:** if a `CMC` root candidate is ever
added, it should wait for the founder either to authorise citing the private solver-arc anchor
directly in a public root row (as was already done for the S7 Coq import under
DEC-toledo-solver-arc-copy-2026-0906) or to publish the CMC programme's own source document publicly
first. Until then, its 33 already-imported, already-unmapped theorem/definition identifiers
(`registry/coq_map.json`, `codes: []`) are correctly left uncoded — not a Toledo build gap so much
as a decision genuinely still open at the root-registry level.

---

## Summary

| Candidate | Public anchor? | Genesis root row today? | Action taken here |
|---|---|---|---|
| Theta programme | Yes — `github.com/morrocwi/readout_genesis@082dde893b70c7500c13d463239909c99cf17f0a`, `formal/InfoTheta*_attempt.v` (9 files) + 2 related | No | None — reported only |
| CMC (Causal-Memory Closure) | **No** — private solver-arc only, zero public-repo matches | No | None — reported only |

Neither candidate received a `genesis_root.json` row, a `CANONICAL.json` root entry, an alias, or a
`coq_map.json` code change from this report. Both are recommendations for a future founder-level
root-registry decision, per the task's explicit instruction to recommend, not create.
