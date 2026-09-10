# Navier--Stokes observability -> EPSC quantitative inversion bridge

Status: research integration note, finite-first. This document makes the bridge between the energy-observability lane and the EPSC lane explicit without collapsing their claim boundaries.

## 1. Three logically distinct layers

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

means local differential completeness only modulo the three translation directions, provided the translation action is locally free. This is the structural content of the NSOBS lane, especially `PROP-NSOBS-08`.

For shell energies,

\[
\operatorname{rank}D\mathcal J_{N,R}
\le
\min\bigl(m_N+(m_N-1)R,d_N-3\bigr).
\]

Exact reproduction reaches the ceiling at the first structurally admissible order for three consecutive fixed finite cutoffs:

\[
\boxed{
(N,R_I^{min},d_N-3)
=(1,23,49),(2,30,245),(3,39,681).
}
\]

The `N=2` middle case is `PROP-NSOBS-12`; the three-case conjunction is `PROP-NSOBS-13`. These are strong finite witnesses, not a proof of arbitrary-finite-`N` saturation (`PROP-NSOBS-07` remains open).

### B. Quantitative inner certification

Rank saturation is not yet an error certificate. To turn structural observability into a finite-state radius, choose an explicit transverse slice `S_N`, select a square observation chart `H_N`, and certify one branch `B_N`.

If `A_N` is a fixed preconditioner and

\[
q_N:=\sup_{x\in B_N}\|I-A_NDH_N(x)\|_\infty<1,
\]

then

\[
\|x-z\|_\infty
\le
\frac{\|A_N\|_\infty}{1-q_N}
\|H_N(x)-H_N(z)\|_\infty.
\]

Consequently certified observation and forward-model residual radii give

\[
\boxed{
\rho_N\le
\frac{\|A_N\|_\infty}{1-q_N}
(\sigma_{meas}+\sigma_{res}).
}
\]

`PROP-EPSC-30` is the structural bridge from saturated quotient rank to an explicit square chart. `PROP-EPSC-31` is the quantitative bridge from a certified branch and `q_N<1` to `rho_N`.

### C. Outer completion

Only after an inner finite radius `rho_N` exists do we optionally attach a separately proved omitted-tail certificate `beta_N`. If the Fourier retained/tail decomposition is orthogonal and the symmetry preserves the cutoff, `PROP-EPSC-17` gives

\[
\boxed{
\inf_{g\in G}\|u(T)-g\widehat x_N\|_2
\le
\sqrt{\rho_N^2+\beta_N^2}.
}
\]

The outer EPSC certificate is not a premise of the finite-native inverse proof.

## 2. The bridge as one explicit chain

The programme should therefore be read as

\[
\boxed{
\text{energy/shell observations}
\to
\text{rank saturation modulo translation}
\to
S_N
\to
H_N
\to
q_N<1
\to
\rho_N
}
\]

followed, only when needed and independently justified, by

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

`PROP-NSOBS-03/05/08/12/13`
-> `PROP-EPSC-30`
-> `PROP-EPSC-31`
-> fixed-resolution witnesses `PROP-EPSC-33` and `PROP-EPSC-34`
-> `PROP-EPSC-32` (OPEN arbitrary-finite-`N` programme).

`PROP-EPSC-17` sits downstream as the optional inner-plus-outer composition theorem.

## 3. Fixed N=1: quantitative bridge crossed tightly

For `N=1`, the finite real state dimension is 52. An explicit translation gauge leaves a 49-dimensional slice, and a selected 49-observation shell-energy Taylor chart is nonsingular in characteristic zero.

The exact centered entrywise enclosure certifies

\[
\|x-x_*\|_\infty\le10^{-17},
\qquad
\boxed{q_1\le0.08058674502845<1/2}.
\]

This is `PROP-EPSC-33`. It is a genuine branch-local finite inverse certificate. It still does not by itself certify that noisy physical measurements lie in or select that branch.

## 4. Fixed N=2: the same bridge is now crossed a second time

For `N=2`,

\[
d_2=248,\qquad d_2-3=245,\qquad m_2=9.
\]

The shell reader reaches exact rank 245 at the earliest possible depth `R=30`. An explicit three-coordinate translation gauge produces a 245-dimensional slice, and an exact good-prime computation selects a nonsingular 245-observation shell chart. A deterministic small-integer center with every coordinate of magnitude at most 3 also retains full rank.

The quantitative certificate then chooses the integer Taylor-row scale

\[
C=14400,
\]

which clears `nu=1/200` and all declared N=2 basis-extraction denominators. The selected row-scaled characteristic-zero Jacobian has nonzero integer determinant. Cramer--Hadamard bounds its inverse, while finite recurrence majorants bound Jacobian variation on the surrounding finite box.

The resulting rigorous but deliberately coarse radius satisfies

\[
\boxed{10^{-79490}<r_2\le10^{-79489}},
\]

and throughout

\[
\|x-x_*\|_\infty\le r_2
\]

the certificate gives

\[
\boxed{q_2\le\tfrac12<1}.
\]

This is `PROP-EPSC-34`.

The radius is far too small to interpret as a practical sensor tolerance. Its significance is different: the full logical bridge

\[
\text{structural observability}
\to
\text{explicit quotient chart}
\to
\text{positive quantitative inverse box}
\]

has now been reproduced at **two distinct finite resolutions**, `N=1` and `N=2`.

That is evidence for the architecture of `PROP-EPSC-32`; it does not prove the arbitrary-finite-`N` schema.

## 5. Why the N=1 and N=2 certificates are different in strength

The `N=1` result uses an exact rational center inverse plus centered entrywise propagation and therefore reaches the much larger state radius `10^-17` with `q_1≈0.08059`.

The first `N=2` quantitative result deliberately avoids forming a huge exact 245x245 rational inverse. Instead it uses only the fact that the row-scaled determinant is a nonzero integer, Cramer--Hadamard, and global finite operator majorants. That makes the proof cheap and rigorous but creates enormous slack, hence the radius near `10^-79490`.

The next N=2 engineering/mathematical target is therefore not existence. Existence and a positive `q_2<1` branch are already certified. The target is **conditioning quality**: build an exact or validated numerical preconditioner and centered entrywise Jacobian enclosure to enlarge the N=2 radius by many orders of magnitude.

## 6. Energy transfer is a mechanism/measurement layer, not a substitute for the inverse

The shell balance

\[
\dot I_s=T_s-2\nu sI_s+F_s
\]

separates nonlinear inter-shell transfer from dissipation. For prescribed forcing,

\[
T=\dot I+2\nu SI-F,
\]

so `(I,T)` is an affine reparameterization of `(I,\dot I)` and does not manufacture extra first-order rank by itself (`PROP-NSOBS-10`). Its role is to expose how distinguishability moves through shell interactions and to support derivative-free finite-window measurements (`PROP-EPSC-21`).

Thus transfer belongs inside the observation/measurement mechanism layer; it does not replace `H_N`, branch certification, or `q_N<1`.

## 7. Finite-first meaning of arbitrary N

The general target is constructive:

\[
\boxed{
N<\infty\mapsto
\mathcal C_N=(S_N,H_N,A_N,B_N,q_N),
\qquad q_N<1.
}
\]

This is `PROP-EPSC-32`. It means an algorithm/schema that accepts any particular finite cutoff and emits a finite proof object. It does not postulate a completed `N=\infty` state.

The evidence ladder is now sharper:

\[
N=1:\;\text{structural + strong quantitative certificate},
\]

\[
N=2:\;\text{structural + conservative positive quantitative certificate},
\]

\[
N=3:\;\text{structural saturation certificate only}.
\]

The natural next tests are therefore (i) improve N=2 conditioning and (ii) build an explicit N=3 quotient chart/positive branch, while separately attacking the arbitrary-finite-`N` structural theorem.

## 8. Fail-closed boundaries

The following remain distinct open obligations:

- `PROP-NSOBS-07`: arbitrary-finite-`N` earliest-order saturation.
- `PROP-EPSC-32`: arbitrary-finite-`N` constructive quantitative certificate packages.
- practical N=2 conditioning and measurement branch capture beyond the extremely conservative `PROP-EPSC-34` radius.
- `PROP-EPSC-19/21`: realistic noise/window uncertainty propagation.
- `PROP-EPSC-16`: scalable/tight outer path/tail certification.
- a valid `beta_N` whenever a continuum target is actually claimed.

If the required inner or outer certificate for a declared target is absent, the correct verdict is `HOLD`.

This document is an architecture/provenance bridge. Proposal identifiers are not canonical verified Toledo theorem codes. No result here proves continuum Navier--Stokes regularity, physical DNS adequacy, or the Clay Millennium problem.
