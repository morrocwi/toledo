# ObservableFlow v0.5 — Toledo Registration Intake

Status: proposal intake pending canonical registrar assignment  
Date: 2026-09-10  
Source project: `morrocwi/readout-problem-navier-stokes`  
Frozen source commit: `08064153e861d87f09b6c336a29ec08196a86358`

## Why this file exists

Founder instruction on 2026-09-10 requested that the important ObservableFlow equations be registered in Toledo and that future work be kept separate from the frozen v0.5 evidence lane.

The Toledo source policy requires an absent equation to be inspected for first and then entered as a **new derivation/proposal** rather than silently treated as an already-canonical Toledo equation. A repository search performed before this intake found no existing `ObservableFlow` entry and no existing entry named `observability matrix` that could be cited as the same registered object.

Accordingly, this change does **not** fabricate final Toledo codes or parentage. The proposal family is staged at:

`registry/proposals/observableflow_v0_5.json`

The placeholder form `ObservableFlow/M.??.v1` means exactly: the source project's own identifier `ObservableFlow` is proposed as the root and the formulas are method-domain readings whose final sequence numbers must be assigned by the Toledo registrar/build process. It is not a citable canonical code yet.

## Source boundary

All v0.5 formulas are anchored to the immutable closure commit above. The primary source files are:

- `software/observableflow/closure/OBSERVABLEFLOW_V05_TECHNICAL_NOTE.md`;
- `software/observableflow/closure/OBSERVABLEFLOW_V05_FINAL_MANIFEST.json`;
- `software/observableflow/observableflow/core.py`;
- `software/observableflow/observableflow/stability.py`;
- `software/observableflow/observableflow/openfoam_benchmark.py`;
- `software/observableflow/benchmarks/openfoam13_cavity/results/head_to_head_v05.json`.

The future deployment-cost decomposition is anchored separately to the post-freeze `FUTURE_WORK.md` commit and is explicitly marked `NOT USED IN v0.5`.

## Proposed equation family

The intake contains the following distinct mathematical objects:

| Proposal | Object | Tier at intake | Scope |
|---|---|---|---|
| `PROP-OBSFLOW-00` | design pair `(S,R)` | Definition | method architecture |
| `PROP-OBSFLOW-01` | affine reduced dynamics | Definition | fitted reduced model |
| `PROP-OBSFLOW-02` | affine measurement map | Definition | fitted measurement model |
| `PROP-OBSFLOW-03` | state-transition products `Phi_k` | Definition | local finite horizon |
| `PROP-OBSFLOW-04` | noise-whitened local observation matrix | Definition | implemented method |
| `PROP-OBSFLOW-05` | LTI observability specialization | Definition | frozen technical note |
| `PROP-OBSFLOW-06` | relative-SVD numerical rank rule | Definition | numerical convention |
| `PROP-OBSFLOW-07` | condition-number diagnostic | Definition | numerical stability diagnostic |
| `PROP-OBSFLOW-08` | spatial-plus-temporal declared cost | Definition | benchmark/design interface |
| `PROP-OBSFLOW-09` | structural feasibility gate | Definition | rank + singular-value floor |
| `PROP-OBSFLOW-10` | stability-aware structural objective | Definition | search objective |
| `PROP-OBSFLOW-11` | frozen validation-selection objective | Definition | v0.5 benchmark policy |
| `PROP-OBSFLOW-12` | affine stacked observation equation | Definition | reconstruction system |
| `PROP-OBSFLOW-13` | pseudoinverse state reconstruction | Definition | estimator |
| `PROP-OBSFLOW-14` | RMSE/NRMSE definitions | Definition | evaluation |
| `PROP-OBSFLOW-15` | frozen deployment gate | Definition | engineering policy, not theorem |
| `PROP-OBSFLOW-16` | three-axis Pareto dominance rule | Definition | frozen comparison rule |
| `PROP-OBSFLOW-17` | final-test coordinate inequalities | finite_diagnostic | one simulated cavity benchmark |
| `PROP-OBSFLOW-18` | deployment-gate failure inequality | finite_diagnostic | preserved negative result |
| `PROP-OBSFLOW-FW-01` | decomposed deployment-cost interface | Open | future v0.6+ proposal only |

## Tier discipline

No method equation is elevated to `Th_coqc`. No Coq closure is claimed. Algebraic/model/interface equations are registered as definitions. The two numerical result inequalities are labelled `finite_diagnostic` and carry `[SimulatedData] Simulation=Yes` because they come from the frozen OpenFOAM benchmark.

The v0.5 condition-number threshold, reconstruction-error thresholds, objective weights, and cost coefficients are benchmark/engineering choices. They are **not** physical constants or universal mathematical laws.

## Claim boundary preserved

The proposal intentionally does not register the prose chain

`full rank does not imply stable inversion does not imply held-out reconstruction quality does not imply deployment readiness`

as a mathematical equation. It remains a claim-boundary statement in the source technical note.

Likewise, the finite diagnostic that ObservableFlow Pareto-dominates the pinned PySensors baseline is restricted to the one frozen OpenFOAM-13 cavity benchmark and the declared axes `(cost, clean NRMSE, noisy NRMSE)`. It does not establish general superiority, industrial savings, continuum Navier--Stokes regularity, or production readiness.

## Registrar action required for canonicalization

The next Toledo registrar pass should:

1. rule whether `ObservableFlow` is accepted as a Layer-0 root extension using the source project's own identifier;
2. assign stable method-domain sequence codes `ObservableFlow/M.nn.v1` without renumbering existing objects;
3. map the proposal-parent graph to canonical `parents[]` using only allowed `derived_via` values;
4. set canonical `origin.source` and exact `repo_anchor` fields according to `registry/SCHEMA.md`;
5. add statement history, first-assigned date, lineage events and computed children;
6. run the Toledo build/check suite and regenerate derived registry surfaces;
7. only after those checks mark the assigned codes as canonical/citable.

Until that registrar pass is complete, the honest status is **REGISTERED PROPOSAL / NOT YET CANONICAL**.
