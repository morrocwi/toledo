# Navier--Stokes observability -> EPSC quantitative inversion bridge

Status: research integration note, finite-first.  This document explains how two previously separate programme lines fit together without collapsing their claim boundaries.

## 1. The two questions are not the same

### A. Energy observability asks whether the retained finite state is locally distinguishable

Fix one finite cubic Fourier--Galerkin cutoff `N`.  Let `X_N` be the finite real incompressible state space, with dimension

\[
d_N=2((2N+1)^3-1).
\]

The total-energy or shell-energy jet is a finite map

\[
\mathcal O_{N,R}:X_N\to\mathbb R^{m(R)}.
\]

Because the readers are invariant under spatial translation, generic rank cannot exceed `d_N-3`.  If

\[
\operatorname{rank}D\mathcal O_{N,R}(x_*)=d_N-3,
\]

then, at a state where the translation action is locally free, the only infinitesimal ambiguity is translation.  This is the **inner structural observability** statement recorded by `PROP-NSOBS-08`.

It does **not** yet say how measurement error propagates into state error.

### B. EPSC-18 asks for a quantitative finite-state radius

EPSC-18 needs an actual certificate of the form

\[
\|x-\widehat x\|\le\rho_N,
\]

on a declared finite symmetry-fixed branch.  Rank alone is insufficient.  We must choose an explicit transverse slice `S_N`, select a square observation chart `H_N`, and certify conditioning throughout a branch `B_N`.

If `A_N` is a fixed preconditioner and

\[
q_N:=\sup_{x\in B_N}\|I-A_NDH_N(x)\|<1,
\]

then

\[
\|x-z\|\le\frac{\|A_N\|}{1-q_N}\,\|H_N(x)-H_N(z)\|.
\]

Hence certified measurement and forward-residual radii give

\[
\boxed{
\rho_N\le\frac{\|A_N\|}{1-q_N}
(\sigma_{meas}+\sigma_{res})
}.
\]

This is the quantitative **inner certificate** recorded by `PROP-EPSC-31`.

## 2. The exact bridge

The research chain is therefore

\[
\boxed{
\text{energy/shell observations}
\to
\text{rank saturation modulo translation}
\to
\text{explicit symmetry slice}
\to
\text{square nonsingular chart}
\to
q_N<1
\to
\rho_N
}.
\]

In Toledo terms:

`PROP-NSOBS-03/05/08`
-> `PROP-EPSC-30`
-> `PROP-EPSC-31`.

The first arrow is not automatic globally.  It is a finite local construction: the saturated differential must be restricted to a declared transverse slice and a nonzero square minor must be selected.  The second arrow additionally requires a branch-wide Jacobian enclosure.

The fixed `N=1` programme provides an explicit worked instance of this architecture: a 52-real-coordinate finite state, a 49-dimensional translation slice, a 49-observation square chart, exact characteristic-zero Jacobian inversion, and a certified interval defect below one on a strictly positive local box.

## 3. Where energy transfer fits

The shell balance

\[
\dot I_s=T_s-2\nu sI_s+F_s
\]

separates nonlinear inter-shell transfer from viscous dissipation.  With prescribed forcing,

\[
T=\dot I+2\nu SI-F,
\]

so `(I,T)` is an affine reparameterization of `(I,\dot I)` and does not create extra local rank by itself (`PROP-NSOBS-10`).  Its value is structural: it exposes how distinguishability is propagated across shell/mode interactions and gives a derivative-free window identity after time integration (`PROP-EPSC-21`).

Thus transfer is best understood as a **coordinate/mechanism layer inside observability**, not as a replacement for the quantitative inverse certificate.

## 4. Where the outer EPSC certificate begins

The finite-native inner chain stops at `rho_N`.  Only after that do we optionally attach a separate outer/continuum adapter.  If an independently proved omitted-state bound `beta_N` is available in an orthogonal Fourier decomposition, `PROP-EPSC-17` gives

\[
\boxed{
\text{total error}\le\sqrt{\rho_N^2+\beta_N^2}.
}
\]

This separation is deliberate:

\[
\underbrace{\text{measurement}\to\rho_N}_{\text{finite-native inner certificate}}
\qquad+
\underbrace{\beta_N}_{\text{external outer adapter}}
\qquad\to
\underbrace{\varepsilon\text{-statement}}_{\text{declared target only}}.
\]

No completed infinite object is needed to formulate or prove the inner certificate.

## 5. Finite-first meaning of "all N"

The programme does not assume an already-existing completed `N=\infty` state.  The desired general statement is constructive:

\[
N<\infty\mapsto
\mathcal C_N=(S_N,H_N,A_N,B_N,q_N),
\qquad q_N<1.
\]

`PROP-EPSC-32` records this as an OPEN arbitrary-finite-resolution certificate programme.  A proof would mean: given any particular finite cutoff `N`, construct and verify a finite certificate package.  It would not by itself be a continuum regularity theorem.

## 6. Current frontier decomposition

The open work should stay separated:

- `PROP-NSOBS-07`: prove or refute earliest-order energy-readout saturation for arbitrary finite `N`.
- `PROP-EPSC-32`: strengthen structural saturation into constructive quantitative certificate packages at arbitrary finite `N`.
- `PROP-EPSC-19/21`: propagate realistic window/noise uncertainty into the finite observation chart without unstable high-order differentiation.
- `PROP-EPSC-16`: tighten and scale the independent outer certificate as cutoff/time increase.
- `PROP-EPSC-17`: already provides the mathematical composition rule once both `rho_N` and `beta_N` are actually certified.

These are related, but none should be relabeled as another.  In particular, observability rank saturation is not a noise-stable inverse; a finite inverse is not a continuum regularity theorem; and a continuum tail certificate is not a Clay solution.

## 7. Research objective

The near-term technical objective is the finite-first pipeline

\[
\boxed{
\text{finite measured readout}
\to
\rho_N
\to
\text{certified finite answer}
}
\]

for more than one resolution.  The optional downstream target is

\[
\boxed{
(\rho_N,\beta_N)
\to
\sqrt{\rho_N^2+\beta_N^2}
\le\varepsilon,
}
\]

under explicitly declared continuum-adapter assumptions.

This document is an architecture/provenance bridge.  It does not promote proposal codes to canonical Toledo theorem codes and makes no originality claim for the finite-dimensional inverse-function estimate itself.
