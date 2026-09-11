# Clay NS P0–P2 handoff and reopened triad-attack provenance — 2026-09-11

**Role:** Toledo provenance/status note only.  
**Canonicalization:** still gated by Toledo issue #11.  
**Upstream canonical source merge:** `morrocwi/readout-problem-navier-stokes@dc1073f7403342e6609e8ea24ddfdeccd6a8ef4b` (PR #48).  
**Primary handoff:** `CLAY_P0_P2_RESEARCH_HANDOFF_2026-09-11.md`.  
**Future work:** `FUTURE_WORK_P2_TRIAD_ATTACK.md`.

This note records the exact research state after consolidation of P0–P2 and the reopened direct Navier–Stokes triad/phase attack. It does not assign new canonical Toledo equation codes and does not promote any OPEN statement.

## Status discipline

- `PASS`: finite executable check passed for the declared artifact.
- `DERIVED`: proved from declared assumptions.
- `OPEN`: theorem not proved.
- `HOLD`: insufficient evidence/adapter/process state.
- `REFUTED`: matching counterexample/impossibility proof for the precise statement.

Methodological correction carried by the upstream merge:

```text
equivalence != refutation
```

`NS-P2-FINAL-EQUIV` remains a valid DERIVED equivalence theorem. What is withdrawn is only the former workflow inference that regularity-equivalence is by itself a reason to abandon the constructive attack.

---

## P0 provenance

P0 is CLOSED as an audit/orientation phase. It established the finite-first research architecture, frozen source/CI/formal boundaries, P-vs-NP formal/process blockers, and fail-closed governance discipline.

Primary upstream source:

```text
morrocwi/readout-problem-navier-stokes/CLAY_P0_AUDIT_2026-09-11.md
```

No global theorem was promoted by P0.

---

## P1 provenance

IDM P1 safe finite core is `PASS / Th_coqc` at merged commit:

```text
morrocwi/information-discrete-math@1ddf295ea6fd9c504a10e6296fdea5bb97cf78fd
```

The promoted Coq 8.20 finite kernels are:

```text
strict_margin_pass_sound
strict_margin_pass_complete
strict_margin_hold_when_not_strict
missing_certificate_holds
gated_pass_requires_certificate_and_margin
error_budget_monotone
error_budget_additive
finite_chain_budget_composition
compatibility_two_step
symmetry_transport_pass
verified_local_defect_sound
```

They establish finite fail-closed certificate/error/symmetry/local-defect composition only. They do not manufacture a domain witness, all-resolution theorem, PDE regularity theorem, or circuit lower bound.

Generic P2 negative controls then REFUTED the naive unrestricted forms of:

1. arbitrary global failure -> natural finite-prefix failure;
2. adjacent discrepancy -> 0 -> global Cauchy control;
3. defect existence -> efficient generic black-box capture.

The strengthened structured/domain forms remain OPEN.

---

## NS P2 established finite/reduction stack

The consolidated upstream handoff preserves the following established pieces.

### Finite singularity-sensitive witness stack

- `NS-FUB-A1E`: DERIVED under declared continuation/Galerkin adapters: finite-time singularity forces arbitrarily large finite-Galerkin `H^3` exceedances.
- `A1V`: PASS exact rational finite `H^3` exceedance verifier.
- fixed-`N` validated tube, tube-chain, residual-tube and rational certificate-completeness machinery: PASS/DERIVED in the declared finite rational Galerkin setting.

### Refuted shortcuts

- energy/`L2` omitted-tail control as a surrogate for omitted `H^3` control: REFUTED.
- fixed-`N` solver/certificate breakdown as a standalone singularity witness: REFUTED.
- local/adjacent refinement agreement as an all-scale theorem: REFUTED as a generic inference.

### Positive tail pieces

The upstream programme records explicit positive-lag Stokes and old-Duhamel `H^3` tail envelopes, including

\[
\|Q_Ne^{\nu\tau\Delta}f\|_{H^3,F}^2
\le
\frac{192}{(2\nu\tau)^4(N+1)^2}\|f\|_2^2,
\]

and

\[
\|D_{old}(t)\|_{H^3,F}^2
\le
\frac{960}{(2\nu\delta)^5(N+1)^2}A_F^2.
\]

Thus the remaining nonlinear difficulty is concentrated in recent transfer rather than positive-lag memory.

### Adapter-neutral H3 margin reduction

For

\[
X_N=\|u_N\|_{H^3}^2,
\qquad
\mathcal D_N=\nu\|\nabla\Lambda^3u_N\|_2^2,
\qquad
\frac12X_N'+\mathcal D_N=\mathcal P_N,
\]

a cutoff-independent inequality

\[
\mathcal P_N(t)
\le
\theta\mathcal D_N(t)+C_T(1+X_N(t)),
\qquad 0\le\theta<1,
\]

implies the cutoff-independent Gronwall bound

\[
1+X_N(t)
\le
(1+\|u_0\|_{H^3}^2)e^{2C_TT}.
\]

This implication is DERIVED. Constructing such a margin non-vacuously from NSE structure remains the difficult content.

### P2B finite-observation route

For

\[
K_N(u)=
\sup_t
\left(
\int_t^{t+\tau_0}\|P_Nu(s)\|_{H^1}^{2p}ds
\right)^{1/(2p)},
\qquad p>2,
\]

the upstream source records:

- `NS-P2B-EPSC-OBS-LIFT`: DERIVED;
- strict subcritical observation scaling -> finite observation gate: DERIVED reduction;
- energy+dissipation-only strict exponent gain: REFUTED as an inference by critical-spike accounting;
- integrated shell balance + total transfer conservation alone -> strict contraction: REFUTED as an inference by an abstract accounting countermodel;
- strict scale recurrence -> `R_j -> 0` -> eventual finite-observation gate: DERIVED.

With

\[
R_j=
\frac{(K_{N_j}^2)^{2p/(p-2)}}{\Lambda_j},
\]

the recurrence

\[
R_j\le U_j,
\qquad
U_{j+1}\le\kappa U_j+B\rho^j,
\qquad
0\le\kappa,\rho<1,
\]

implies `R_j -> 0`.

### `NS-P2-FINAL-EQUIV`

Under the declared periodic modal/dyadic finite-observation adapter:

\[
\boxed{
\text{regularity on }[0,T]
\iff
SC(T)
}
\]

where `SC(T)` is existence of the strict scale-contraction certificate above.

Status: **DERIVED under the declared adapter**.

Current interpretation after the correction:

```text
existential SC(T) is regularity-equivalent
constructive SC(T) from weaker finite/checkable NSE structure remains an OPEN direct attack
```

---

## Reopened exact triad/phase findings pinned to NS merge dc1073f...

These findings are sourced from PR #48 and the merged files/checkers at `dc1073f7403342e6609e8ea24ddfdeccd6a8ef4b`.

### `NS-P2-TRIAD-PHASE-01` — shell-energy-only signed transfer

An exact isolated NSE triad has the same shell-energy coordinates `(x,y,z)` but opposite signed phase coordinate `r`. At the declared calibration state the high-shell derivative changes from

\[
19/20
\]

to

\[
-21/20.
\]

Ruling: shell energies alone -> universal signed transfer/strict contraction is **REFUTED for this reader class**.

### `NS-P2-TRIAD-PHASE-02` — viscosity-only normalized phase contraction

For normalized isolated-triad phase coherence

\[
\chi=r/\sqrt{xyz},
\]

the viscous contribution cancels from the logarithmic derivative.

Ruling: viscosity alone -> strict contraction of normalized phase coherence is **REFUTED**.

### Isolated-triad coherence-defect identity

For

\[
D=xyz-r^2,
\]

the declared exact isolated-triad reduction gives

\[
\boxed{D'=-16\nu D.}
\]

Thus `D=0` is invariant; a single triad can remain perfectly phase locked. Status: **DERIVED for the declared exact reduction**.

### Exact N=1 H3 sign-frustration

The exact N=1 real-coordinate Galerkin tensor (`d=52`) gives an inhomogeneous `H^3` nonlinear-production cubic polynomial with 432 nonzero aggregated cubic monomials: 218 positive and 214 negative. The exact GF(2) all-sign-alignment system is UNSAT and a tracked contradiction uses four equations.

Status: **PASS exact finite structural result**. No all-N or quantitative global contraction follows from this alone.

### Four-term finite frustration tax

For one extracted finite conflict cycle,

\[
Q_{cycle}=600a[-19bc+18bd-19ce-18de].
\]

Writing `S_cycle` for the sum of absolute term magnitudes and `m_cycle` for the minimum term magnitude gives

\[
\boxed{|Q_{cycle}|\le S_{cycle}-2m_{cycle}.}
\]

Status: **DERIVED finite inequality**. The ratio `m_cycle/S_cycle` may approach zero, so no uniform all-scale deficit is implied.

### Symbolic all-n ladder family

The upstream symbolic family has coefficient pattern

\[
A_n,-B_n,A_n,B_n,
\]

where

\[
A_n=n^3(4n^4-6n^2-17),
\qquad
B_n=2n^3(4n^6-6n^2-7),
\]

and for integer `n>=1` the product is `-A_n^2B_n^2<0`.

Status: **DERIVED for the declared symbolic family**. Coverage of all transfer paths remains OPEN.

### Symbolic dyadic high-high motif

For

\[
q=(n,n,0),
\qquad
r=(n,-n,0),
\qquad
t=(2n,0,0),
\]

the exact subpolynomial is

\[
\boxed{
Q_n=C_n\Im(z_qz_r\overline{z_t})
}
\]

with

\[
C_n=8n^7(28n^4+18n^2+3)>0,
\]

and the normalized coefficient satisfies

\[
\boxed{
\Gamma_n\le\frac{7\sqrt2}{8n^2}.
}
\]

Status: **DERIVED for the declared symbolic family**.

Important claim boundary: a single complex triad can choose a maximizing phase, so its four-real-coordinate sign pattern must not be promoted as genuine network cancellation. Genuine phase frustration must involve overlapping triads/shared phase constraints or another actual network mechanism.

---

## Current active frontier

### `NS-P2-FRUSTRATION-OR-CUT` — OPEN

The next load-bearing target is an NSE-specific overlapping-triad theorem:

```text
overlapping complex triad phase incidence
  -> quantitative phase incompatibility / cancellation tax
OR
  -> quantitative amplitude cut
```

strong enough to aggregate over dyadic boundaries and time windows into

\[
R_{j+1}
\le
(1-\delta_j)R_j+\beta_j
\]

with a proved uniform or nonuniform decay condition sufficient for `R_j -> 0`.

The upstream `FUTURE_WORK_P2_TRIAD_ATTACK.md` specifies the continuation order:

1. exact complex phase-incidence/holonomy object;
2. SAT/UNSAT falsification on overlapping triads;
3. minimal genuine complex conflict cycle;
4. quantitative phase-distance deficit;
5. frustration-or-amplitude-cut lemma;
6. dyadic boundary cycle cover/decomposition;
7. time-window switching/coherence cost;
8. recent nonlinear remainder accounting;
9. all-scale recurrence;
10. finite fail-closed certificate/formalization;
11. final adapter audit.

### Current status summary

```text
P0 audit                                      CLOSED
P1 safe finite core                          PASS / Th_coqc
naive generic FUB-03/04/05 forms            REFUTED in declared controls
fixed-N NS certificate machinery             PASS / DERIVED in declared finite setting
L2->H3 tail shortcut                         REFUTED
fixed-N failure->singularity shortcut        REFUTED
positive-lag Stokes/old-Duhamel tails        DERIVED
H3 dissipative-margin implication            DERIVED
EPSC -> modal observation lift               DERIVED
accounting-only strict-gain inferences       REFUTED
scale-contraction -> eventual gate           DERIVED
NS-P2-FINAL-EQUIV                            DERIVED under declared adapter
"equivalence => stop" workflow rule          WITHDRAWN
shell-energy-only signed transfer             REFUTED by actual triad
viscosity-only normalized phase contraction  REFUTED
isolated-triad D'=-16nu D                    DERIVED for declared reduction
N=1 H3 sign-frustration                      PASS exact finite
N=1 frustration tax                          DERIVED finite inequality
all-n ladder motif                           DERIVED for declared family
dyadic HH motif and Gamma_n bound            DERIVED for declared family
overlapping-triad phase holonomy             OPEN
NS-P2-FRUSTRATION-OR-CUT                     OPEN
constructive uniform R_j recurrence          OPEN
```

## Canonicalization boundary

This provenance note does not assign Toledo codes to the research identifiers above. Toledo issue #11 remains the canonicalization gate. Any future promotion must pin the exact upstream repo/commit/path, attach the correct evidence tier, preserve OPEN/HOLD where appropriate, and run the normal Toledo build/checkers rather than hand-edit generated registry outputs.
