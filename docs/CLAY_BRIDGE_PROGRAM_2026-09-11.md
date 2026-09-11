# Clay Bridge Program — Shared Finite Obstruction / Uniformity Ledger

**Date:** 2026-09-11  
**Status:** Toledo research integration note; proposal identifiers below are non-canonical until registry audit  
**Primary upstream specs:**

- `morrocwi/readout-problem-navier-stokes/CLAY_MULTI_PROBLEM_FINITE_BRIDGE_PROGRAM.md`
- `morrocwi/information-discrete-math/docs/UNIVERSAL_FINITE_OBSTRUCTION_UNIFORM_BRIDGE_KERNEL.md`

> This ledger does not assert that any Millennium Prize Problem is solved. It records the shared dependency structure, current load-bearing open statements, and claim boundaries so future sessions do not confuse finite evidence, uniform theorems, bridge theorems, and Clay conclusions.

---

## 1. Program invariant

The common research architecture is

\[
\boxed{
\text{finite/local structure}
\to
\text{finite certificate or obstruction}
\to
\text{uniform constructive theorem}
\to
\text{explicit domain bridge}
\to
\text{global target}
}
\]

Two logically separate bridges must always be tracked:

1. **Finite Uniformity Bridge** — from tested/individual finite objects to a theorem over the full admissible finite family.
2. **Global Semantic Bridge** — from the all-finite theorem to the exact global/continuum/complexity statement required by the target problem.

No Toledo claim may silently collapse these two bridges.

---

## 2. Shared proposal ledger

These are proposal identifiers, not canonical Toledo codes.

| Proposal | Statement role | Tier/status | Direct dependencies | Primary lanes |
|---|---|---|---|---|
| `PROP-FUB-01` | finite certificate kernel schema `(X,G,L,D,V,R,eta,beta,M)` | Definition / program spec | existing finite certificate discipline | all |
| `PROP-FUB-02` | strict certified margin / remainder composition | generic target; domain instances exist | finite error accounting | NS, PNP, YM candidate |
| `PROP-FUB-03` | global failure implies finite witness | **OPEN** | domain hypotheses required | NS first; RH/YM probes |
| `PROP-FUB-04` | constructive uniform capture of a nonzero defect | **OPEN** | efficient witness construction/sampling | PNP first; NS analogue possible |
| `PROP-FUB-05` | cross-resolution compatibility + extension bound | **OPEN generic schema** | finite comparison maps and certified budgets | NS first; YM candidate |
| `PROP-FUB-06` | non-vacuity / hidden-target audit | Definition / mandatory gate | bridge premise and target | all |

The program intentionally does not canonicalize `PROP-FUB-*` until the source statements stabilize and Toledo's normal canonical audit assigns legal registry codes.

---

## 3. Direct Clay lane: Navier--Stokes

### Existing finite evidence

The NS repository already contains fixed-resolution observability, quantitative inverse certificates, symmetry obstructions, EPSC tail/adaptor results, and fail-closed certificate machinery. These remain supporting mathematics unless connected through a Clay bridge.

### Load-bearing open proposal `NS-FUB-A1`

\[
\boxed{
\mathsf{FiniteTimeSingularity}
\Longrightarrow
\exists N<\infty:\mathsf{CertifiedFiniteFailure}_N
}
\]

**Status:** OPEN.

The finite failure must be regularity/PDE relevant. Failure of a particular reader, sensor, branch, or inverse chart is not automatically a Navier--Stokes singularity witness.

### Load-bearing open proposal `NS-FUB-A2`

\[
\boxed{
\forall N<\infty:\neg\mathsf{CertifiedFiniteFailure}_N
\Longrightarrow
\mathsf{NoFiniteTimeSingularity}
}
\]

**Status:** OPEN.

This is a Global Semantic Bridge candidate. Its antecedent must be independently provable and must pass `PROP-FUB-06`.

### NS dependency chain

```text
fixed-N finite certificates
    -> arbitrary-N structural theorem            [OPEN in important components]
    -> cross-resolution compatibility            [OPEN program]
    -> finite extension/tail control              [partly developed; bridge-specific strength OPEN]
    -> NS-FUB-A1 finite singularity witness       [OPEN]
    -> exclusion of every admissible witness      [OPEN]
    -> NS-FUB-A2 Clay bridge                      [OPEN]
    -> Clay NS conclusion                         [OPEN]
```

---

## 4. Direct Clay lane: P vs NP

The P-vs-NP branch and PR #117 already isolate a finite restriction-defect interface and formal transfer kernels. The remaining load-bearing statement is not a bookkeeping gap; it is the unrestricted circuit-lower-bound frontier.

### Load-bearing proposal `PNP-FUB-A1`

For every polynomial circuit-size bound `p`, find some input length `n` such that every candidate circuit `C` with `|C|<=p(n)` admits an efficiently constructible or samplable locally verifiable defect with inverse-polynomial capture probability, without SAT/equivalence/MCSP or hidden exponential enumeration.

ADC form:

\[
\boxed{1-q_C\ge 1/\operatorname{poly}(n).}
\]

**Status:** OPEN.

### PNP dependency chain

```text
SAT local restriction/boundary laws
    -> wrong candidate has local defect                 [finite interface established]
    -> robust finite defect checker                     [supporting kernels developed]
    -> PNP-FUB-A1 unrestricted constructive capture     [OPEN]
    -> SAT notin P/poly transfer                        [formal/logical target available]
    -> P != NP                                          [OPEN because PNP-FUB-A1 is OPEN]
```

### Mandatory non-vacuity audit

Any proposed constructor for `mu_C` or a hitting support must be rejected/HOLD if it calls or hides:

- SAT solving of the target instance family;
- circuit equivalence;
- MCSP-strength subroutines;
- exhaustive search over exponentially many states without a valid resource bound;
- semantic-oracle leaves that already know the target function.

---

## 5. Candidate third lane: Yang--Mills

**Current Toledo status:** exploratory adapter only; not a direct Clay claim.

Tentative shared structure:

```text
finite regulator/lattice
    -> gauge quotient
    -> finite spectral/observable certificate
    -> cross-scale compatibility
    -> uniform positive-gap candidate
    -> continuum Yang--Mills bridge
```

Promotion criteria:

1. precise regulated finite object;
2. exact treatment of gauge symmetry;
3. refinement/coarse-graining maps;
4. finite gap certificate with declared evidence tier;
5. uniform lower-gap theorem candidate;
6. explicit continuum construction/bridge strong enough for the Clay statement.

A nonzero finite-lattice numerical gap is finite evidence only.

---

## 6. Probe lanes

### Riemann Hypothesis

Research probe:

\[
\text{off-critical zero}
\stackrel{?}{\Longrightarrow}
\text{finite detectable obstruction}.
\]

Finite verification to height `T` does not constitute an all-height theorem. Status: no valid global adapter yet.

### Birch--Swinnerton--Dyer

Research probe: arithmetic and analytic quantities as independent readouts of a common invariant. Computed agreement on finite families does not supply a universal bridge. Status: no valid global adapter yet.

### Hodge Conjecture

Research probe: whether algebraic representability/nonrepresentability admits a finite witness/obstruction architecture with a universal bridge. Status: no valid global adapter yet.

---

## 7. Cross-lane dependency graph

```text
                       PROP-FUB-01
                  finite certificate schema
                           |
              +------------+------------+
              |                         |
         PROP-FUB-02                PROP-FUB-06
       robust margin gate          non-vacuity audit
              |                         |
       +------+-------+                 |
       |              |                 |
 PROP-FUB-03      PROP-FUB-04           |
 finite witness   uniform capture       |
       |              |                 |
       |              +------> PNP-FUB-A1 ----> SAT !in P/poly ----> P != NP
       |
       +------> NS-FUB-A1
                    |
               PROP-FUB-05
             cross-resolution /
              extension control
                    |
               NS-FUB-A2
                    |
             NS Clay conclusion

PROP-FUB-05 + symmetry/gap adapters
                    |
              Yang--Mills probe

PROP-FUB-03 / witness logic
          |          |          |
         RH         BSD       Hodge
      probe only  probe only  probe only
```

---

## 8. Highest-leverage work order

### P0 — audit

Before new proof work, inspect current HEAD/PR/CI/claim ledgers and known counterexamples.

### P1 — formalize the safe shared core

Formalize only statements that do not smuggle a Clay target into a premise:

- strict-margin soundness;
- finite error-budget monotonicity/composition;
- symmetry-quotient certificate transport;
- local finite-defect checker soundness;
- cross-resolution budget composition along finite chains;
- fail-closed HOLD semantics.

### P2 — falsify generic obstruction claims

Actively search for counterexamples to naive versions of `PROP-FUB-03/04/05`. Tighten hypotheses rather than protecting an attractive statement.

### P3 — attack one load-bearing lemma per direct lane

- NS: `NS-FUB-A1` / `NS-FUB-A2`.
- P vs NP: `PNP-FUB-A1`.

Do not substitute more fixed finite examples for these quantified statements.

### P4 — formal/CI gate

Promote a result only after executable/formal evidence matches its prose and assumptions.

### P5 — Yang--Mills adapter

Only after the shared kernel survives NS and PNP stress tests.

### P6 — RH/BSD/Hodge transfer probes

Record honest positive and negative transfers. `NO VALID ADAPTER YET` is an acceptable and useful result.

---

## 9. Required status vocabulary

- `PASS`: executable finite verification passed.
- `DERIVED`: mathematically proved from declared assumptions.
- `OPEN`: theorem not proved.
- `HOLD`: evidence or assumptions are insufficient.

A Clay conclusion requires all links:

```text
domain theorem
+ finite-uniform theorem
+ global semantic bridge
+ exact target-statement match
```

If any link is missing, Clay status is OPEN.

---

## 10. Canonicalization rule

This document is the initial Toledo program ledger. It deliberately does **not** directly modify `registry/CANONICAL.json`.

Reason: Toledo's schema requires provenance, legal code grammar, parent chains, tier evidence, and Coq status. The `PROP-FUB-*`, `NS-FUB-*`, and `PNP-FUB-*` names are research proposal identifiers until a later canonical audit.

Canonicalization task:

1. stabilize statement wording in source repos;
2. pin source commits/paths;
3. identify or create legal Toledo parent relations;
4. assign Toledo codes using the governed code scheme;
5. attach tier evidence and Coq mapping where available;
6. rebuild/check the canonical registry through Toledo tooling rather than hand-editing the generated registry.

---

## 11. Immediate next target

The single highest-leverage mathematical target is to find a sound hypothesis class for a finite-obstruction theorem strong enough to instantiate in NS without becoming equivalent to global regularity itself, while simultaneously keeping the P-vs-NP capture lane honest about computational resources.

In short:

\[
\boxed{
\text{finite witness}
+\text{constructive capture}
+\text{uniform compatibility}
+\text{non-vacuity}
}
\]

is the shared frontier.
