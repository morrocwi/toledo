# Mandatory AI Startup Protocol — Toledo / Clay Program

Toledo is the theorem/provenance/status registry for the shared Clay research program. It is not the place to invent or silently upgrade theorem status.

## Read first

1. `docs/CLAY_BRIDGE_PROGRAM_2026-09-11.md`
2. `registry/SCHEMA.md`
3. `docs/EQ_CODE_SCHEME.md`
4. `docs/NS_OBSERVABILITY_TO_EPSC_BRIDGE.md` when NS/EPSC is relevant
5. `morrocwi/readout-problem-navier-stokes/CLAY_READ_FIRST.md`
6. `morrocwi/readout-problem-navier-stokes/CLAY_RESEARCH_TODO.md`
7. `morrocwi/information-discrete-math/docs/UNIVERSAL_FINITE_OBSTRUCTION_UNIFORM_BRIDGE_KERNEL.md`

## Current proposal IDs

The following are research proposal identifiers, **not canonical Toledo codes** until issue #11 is completed through the normal audit/build workflow:

- `PROP-FUB-01..06`
- `NS-FUB-A1/A2`
- `PNP-FUB-A1`

## Rules

- Do not hand-edit generated registry outputs merely to force a desired status.
- Do not promote `Open`/`HOLD` to a stronger tier because a source document exists.
- Pin repo + commit + path before canonical ingestion.
- Attach tier evidence and relation/parent evidence explicitly.
- Map Coq/Rocq identifiers only when actual formal evidence exists.
- Keep finite theorem, finite uniformity bridge, global semantic bridge, and Clay conclusion separate.
- Record counterexamples, retractions, failed analogies, and non-vacuity failures as first-class provenance.

## Active work

- Toledo issue #11 — canonicalize shared Clay bridge proposals after statements stabilize.
- Upstream IDM issue #124 — formalize safe shared core.
- Upstream NS issue #25 — isolate `NS-FUB-A1`.
- Upstream IDM PR #117 — `PNP-FUB-A1` frontier.

Core rule:

> **Toledo records what is proved, open, held, refuted, or derived. It must never manufacture closure.**
