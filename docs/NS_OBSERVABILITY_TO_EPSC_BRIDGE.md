# Navier--Stokes observability -> EPSC quantitative inversion bridge

Status: research integration note, finite-first. This document makes the bridge between the energy-observability lane and the EPSC lane explicit without collapsing their claim boundaries.

The proposal records referenced here are now stored in:

- `registry/proposals/ns_energy_observability.json` (`PROP-NSOBS-01..08`),
- `registry/proposals/ns_energy_observability_extensions.json` (`PROP-NSOBS-09..13`),
- `registry/proposals/discrete_epsilon_completion_relative_energy.json` (`PROP-EPSC-13..19`), and
- `registry/proposals/discrete_epsilon_completion_observability_bridge.json` (`PROP-EPSC-20..36`).

All `weld/P.??.v1` codes remain proposal placeholders until canonical Toledo audit.

## 1. Four logically distinct layers

### A. Structural inner observability

Fix one finite cubic Fourier--Galerkin cutoff `N`. Let `X_N` be the finite real incompressible state space,

\[
d_N=2((2N+1)^3-1).
\]

For a total-energy or shell-energy observation jet

\[
\mathcal O_{N,R}:X_N\to\mathbb R^{m(R)},
\]

spatial-translation invariance forces generic rank at most `d_N-3`. Thus

\[
\operatorname{rank}D\mathcal O_{N,R}(x_*)=d_N-3
\]

means local differential completeness only modulo the three translation directions, provided the translation action is locally free (`PROP-NSOBS-08`).

For shell energies,

\[
\operatorname{rank}D\mathcal J_{N,R}
\le
\min\bigl(m_N+(m_N-1)R,d_N-3\bigr).
\]

Exact reproduction reaches the ceiling at the first structurally admissible order for three consecutive fixed finite cutoffs:

\[
\boxed{(N,R_I^{min},d_N-3)=(1,23,49),(2,30,245),(3,39,681).}
\]

The `N=2` middle case is `PROP-NSOBS-12`; the three-case conjunction is `PROP-NSOBS-13`. These are finite witnesses, not a proof of arbitrary-finite-`N` saturation. `PROP-NSOBS-07` remains OPEN.

### B. Quantitative inner certification

Rank saturation is not yet an error certificate. Choose an explicit transverse slice `S_N`, select a square observation chart `H_N`, and certify one convex branch `B_N`.

If `A_N` is a fixed preconditioner and

\[
q_N:=\sup_{x\in B_N}\|I-A_NDH_N(x)\|_\infty<1,
\]

then for `x,z` in the same branch,

\[
\|x-z\|_\infty
\le
\frac{\|A_N\|_\infty}{1-q_N}
\|H_N(x)-H_N(z)\|_\infty.
\]

`PROP-EPSC-30` is the structural bridge from saturated quotient rank to an explicit square chart. `PROP-EPSC-31` is the quantitative bridge from a certified branch and `q_N<1` to a retained-state radius.

### C. Measurement interface

The quantitative inverse begins with uncertainty in the declared chart, not automatically with raw sensor samples. If measured chart data `y` obeys

\[
\|y-H_N(x)\|_\infty\le\sigma
\]

and a candidate `z` in the same certified branch obeys

\[
\|H_N(z)-y\|_\infty\le\tau,
\]

then

\[
\boxed{
\rho_N\le
\frac{\|A_N\|_\infty}{1-q_N}(\sigma+\tau).
}
\]

This is already rigorous once branch membership and chart uncertainty are certified. The remaining measurement problem is upstream: convert raw finite samples/windows into certified uncertainty for `H_N` and certify the correct branch without assuming it. That open interface is `PROP-EPSC-36` and is part of the still-open full `PROP-EPSC-19` programme.

### D. Optional outer completion

Only after an inner finite radius `rho_N` exists do we optionally attach a separately proved omitted-tail certificate `beta_N`. If the retained/tail decomposition is orthogonal and the symmetry preserves the cutoff, `PROP-EPSC-17` gives

\[
\boxed{
\inf_{g\in G}\|u(T)-g\widehat x_N\|_2
\le
\sqrt{\rho_N^2+\beta_N^2}.
}
\]

The outer continuum adapter is not a premise of the finite-native inverse proof.

## 2. The bridge as one explicit chain

The finite-native programme is

\[
\boxed{
\text{finite observations}
\to
\text{rank saturation modulo translation}
\to
S_N
\to
H_N
\to
q_N<1
\to
\rho_N.
}
\]

For actual measured data the unresolved upstream interface is

\[
\boxed{
\text{raw finite samples/windows}
\to
(H_N\text{-uncertainty},\text{branch certificate})
\to
\rho_N.
}
\]

Only when a continuum target is declared do we append

\[
\boxed{
(\rho_N,\beta_N)
\to
\sqrt{\rho_N^2+\beta_N^2}
\to
\varepsilon\text{-verdict}.
}
\]

In Toledo lineage terms:

`PROP-NSOBS-03/08/12/13`
-> `PROP-EPSC-30`
-> `PROP-EPSC-31`
-> fixed-resolution witnesses `PROP-EPSC-33/34/35`
-> `PROP-EPSC-32` (OPEN arbitrary-finite-`N` programme).

`PROP-EPSC-21` supplies a derivative-free window-transfer summary. `PROP-EPSC-36` is the OPEN raw-window/chart-and-branch interface. `PROP-EPSC-17` sits downstream as the optional inner-plus-outer composition theorem.

## 3. Fixed N=1: quantitative bridge and chart-noise step

For `N=1`, the finite real state dimension is 52. An explicit translation gauge leaves a 49-dimensional slice, and a selected 49-observation shell-energy Taylor chart is nonsingular in characteristic zero (`PROP-EPSC-22`).

The tightening sequence is recorded as `PROP-EPSC-25..29`. The current exact centered entrywise enclosure certifies

\[
\|x-x_*\|_\infty\le10^{-17},
\qquad
q_1\le0.08058674502845<1/2.
\]

This fixed-resolution bridge instance is `PROP-EPSC-33`.

There is now one further partial EPSC-19 closure. The exact center inverse satisfies

\[
\|A_1\|_\infty<1.29.
\]

Using only the conservative certified bound `q_1<=1/2`, for true state `x` and candidate `z` already certified to lie in the same N=1 box,

\[
\|y-H_1(x)\|_\infty\le\sigma,
\qquad
\|H_1(z)-y\|_\infty\le\tau
\]

implies

\[
\boxed{
\|x-z\|_\infty<\frac{129}{50}(\sigma+\tau)=2.58(\sigma+\tau).
}
\]

This is `PROP-EPSC-35`. It is a genuine finite noise-to-state radius for the selected **scaled chart**, conditional on branch membership. It is not yet a physical sensor tolerance because raw time samples have not yet been certified into that high-order chart and the branch has not yet been selected from the raw data.

## 4. Fixed N=2: structural and positive quantitative bridge

For `N=2`,

\[
d_2=248,\qquad d_2-3=245,\qquad m_2=9.
\]

The shell reader reaches exact rank 245 at the earliest possible depth `R=30` (`PROP-NSOBS-12`). An explicit three-coordinate translation gauge produces a 245-dimensional slice, and an exact good-prime computation selects a nonsingular 245-observation shell chart. A deterministic small-integer center with every coordinate of magnitude at most 3 retains full rank.

The first quantitative certificate uses integer Taylor-row scale `C=14400`, which clears `nu=1/200` and the declared basis-extraction denominators. Cramer--Hadamard plus finite recurrence majorants give

\[
\boxed{10^{-79490}<r_2\le10^{-79489}},
\qquad
\boxed{q_2\le\tfrac12<1}.
\]

This is `PROP-EPSC-34`. It proves that the full structural-to-positive-quantitative bridge crosses a second finite resolution. The radius is deliberately very loose and is not a useful sensor tolerance. The next N=2 target is conditioning quality: construct an exact or validated preconditioner and centered entrywise enclosure, analogous to the N=1 tightening.

## 5. Energy transfer is a mechanism/measurement layer, not a substitute for the inverse

For finite Fourier-Galerkin Navier--Stokes shell energy,

\[
\dot I_s=T_s-2\nu sI_s+F_s.
\]

For prescribed forcing,

\[
T=\dot I+2\nu SI-F,
\]

so `(I,T)` is an affine reparameterization of `(I,dI/dt)` and does not create extra first-order rank (`PROP-NSOBS-10`). Transfer remains useful because it exposes redistribution and supports finite-window balances. Time integration gives

\[
\int_{t_0}^{t_1}T_sdt
=
I_s(t_1)-I_s(t_0)
+2\nu s\int_{t_0}^{t_1}I_sdt
-\int_{t_0}^{t_1}F_sdt,
\]

which is `PROP-EPSC-21` and avoids numerical differentiation in this substep.

The remaining problem is not to pretend that a transfer integral already equals the selected high-order inverse chart. `PROP-EPSC-36` must certify that measurement interface.

## 6. Finite-first meaning of arbitrary N

The general target is constructive:

\[
\boxed{
N<\infty\mapsto
\mathcal C_N=(S_N,H_N,A_N,B_N,q_N),
\qquad q_N<1.
}
\]

This is `PROP-EPSC-32`. It means an algorithm/schema that accepts any particular finite cutoff and emits a finite proof object. It does not postulate a completed `N=infinity` state.

The current evidence ladder is

\[
N=1:\;\text{structural + tight local quantitative + branch-conditioned chart-noise certificate},
\]

\[
N=2:\;\text{structural + conservative positive quantitative certificate},
\]

\[
N=3:\;\text{structural saturation certificate only}.
\]

Therefore the high-value next tasks are (i) raw-window/sample -> chart plus branch certification at N=1, (ii) improve N=2 conditioning, (iii) build an explicit N=3 quantitative branch, and (iv) separately attack arbitrary-finite-N structural minor independence.

## 7. Fail-closed boundaries

The following remain distinct open obligations:

- `PROP-NSOBS-07`: arbitrary-finite-`N` earliest-order saturation.
- `PROP-EPSC-32`: arbitrary-finite-`N` constructive quantitative certificate packages.
- `PROP-EPSC-36`: raw finite-window/sample -> selected chart uncertainty plus branch capture.
- `PROP-EPSC-24`: practical measurement-ready full-N=1 radius; `PROP-EPSC-35` closes only the downstream branch-conditioned chart-noise step.
- `PROP-EPSC-19`: full noisy measurement-to-continuum propagation.
- practical N=2 conditioning beyond the extremely conservative `PROP-EPSC-34` radius.
- `PROP-EPSC-16`: scalable/tight outer path/tail certification.
- a valid `beta_N` whenever a continuum target is actually claimed.

If any certificate required for a declared target is absent, the correct verdict is `HOLD`.

This document is an architecture/provenance bridge. Proposal identifiers are not canonical verified Toledo theorem codes. No result here proves continuum Navier--Stokes regularity, physical DNS adequacy, or the Clay Millennium problem.
