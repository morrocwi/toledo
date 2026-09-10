# Navier--Stokes observability -> EPSC quantitative inversion bridge

Status: research integration note, finite-first.  Proposal identifiers remain `weld/P.??.v1` placeholders until canonical Toledo audit.

This bridge keeps four logically different questions separate:

1. **structural observability**: do the declared finite observations separate tangent directions modulo reader symmetries?
2. **quantitative local inversion**: on one declared local chart, does a certified preconditioned defect satisfy `q<1` and yield a retained-state error factor?
3. **measurement interface**: can finite raw observations be converted into a finite data budget without silently assuming the unknown branch?
4. **optional outer completion**: if a continuum target is declared, can a separately proved tail certificate `beta_N` be composed with the retained-state radius?

The outer layer is never a premise of the finite-native inner proof.

## 1. Structural observability

For one fixed finite cubic Fourier--Galerkin cutoff `N`,

\[
d_N=2((2N+1)^3-1).
\]

Spatial translations give a continuous three-dimensional kernel for energy readers.  For shell energies,

\[
\operatorname{rank}D\mathcal J_{N,R}
\le
\min\bigl(m_N+(m_N-1)R,d_N-3\bigr).
\]

Exact finite reproduction reaches this ceiling at the earliest structurally admissible order for three consecutive cutoffs:

\[
\boxed{(N,R_I^{min},d_N-3)=(1,23,49),(2,30,245),(3,39,681).}
\]

These are fixed finite witnesses (`PROP-NSOBS-12/13`), not an arbitrary-`N` theorem. `PROP-NSOBS-07` remains OPEN.

A crucial global correction is now explicit.  Continuous rank accounting sees only the translation kernel, but shell-energy readers also admit discrete lattice symmetries. `PROP-NSOBS-14` gives an N=1 axis-swap witness: one-mode states supported at `(1,0,0)` and `(0,1,0)` are not translation-equivalent, yet have identical shell-energy derivative records for every arbitrary finite derivative order.  Local rank `d_N-3` therefore does **not** imply global injectivity on `X_N/T^3`.

## 2. Structural rank -> local quantitative chart

After choosing an explicit translation-transverse slice and independent observation rows, `PROP-EPSC-30` gives a square local chart.  If a fixed finite preconditioner `A_N` and a declared branch `B_N` satisfy

\[
q_N:=\sup_{x\in B_N}\|I-A_NDH_N(x)\|_\infty<1,
\]

then for two states already known to belong to that chart,

\[
\boxed{
\|x-z\|_\infty
\le
\frac{\|A_N\|_\infty}{1-q_N}
\|H_N(x)-H_N(z)\|_\infty.
}
\]

This is the quantitative inner bridge (`PROP-EPSC-31`).

At fixed `N=1`, the current exact centered entrywise enclosure gives

\[
\|x-x_*\|_\infty\le10^{-17},
\qquad
q_1\le0.08058674502845<1/2.
\]

At fixed `N=2`, a deliberately coarse but positive certificate gives

\[
10^{-79490}<r_2\le10^{-79489},
\qquad q_2\le1/2.
\]

The N=2 number proves positivity, not practical conditioning.

## 3. Raw samples without numerical differentiation

At `N=1`, define the 49-component finite-time shell sample map

\[
\mathcal S_h(x)=
\bigl(I_0(\phi_{jh}(x))\bigr)_{j=0}^{23}
\oplus
\bigl(I_1(\phi_{jh}(x))\bigr)_{j=0}^{23}
\oplus I_2(x).
\]

`PROP-EPSC-37` proves the structural derivative-free lift: for sufficiently small nonzero `h`, the local sample chart is nonsingular.  `PROP-EPSC-38` then shows why reconstructing the high-order Taylor jet from noisy samples is a poor intermediate route: the exact Vandermonde interpolation norm grows severely as `h` shrinks.

The correct route is therefore direct:

\[
\boxed{
\text{raw finite samples}
\to
\mathcal S_h
\to
\text{direct preconditioner/defect gate}
\to
\rho_N.
}
\]

## 4. EPSC-39: the finite direct-sample gate

The fixed-N=1 direct construction uses explicit rational spacing `h=10^-200`, an exact rational preconditioner, finite order-24 Jacobian remainder bounds, finite order-48 sample-value remainder bounds, and a declared local radius.

Let

\[
\delta=\|y_{obs}-y_{model}\|_\infty+\sigma+\tau.
\]

The native finite gate is only the pair of exact inequalities

\[
q<1,
\qquad
\|A\|_\infty\delta+qr\le r.
\]

These imply the finite budgets

\[
\boxed{
\delta\le\frac{(1-q)r}{\|A\|_\infty},
\qquad
\rho_{cond}:=\frac{\|A\|_\infty}{1-q}\delta\le r.
}
\]

This is `PROP-EPSC-39`.  It is a finite inequality theorem only.  It does **not** manufacture an exact real root, an attained contraction limit, or branch membership.

## 5. EPSC-40: explicit real-analysis adapter, not native finite mathematics

If a user additionally grants a complete real metric-space interpretation of the declared branch and sample map, the ordinary Banach fixed-point theorem may turn the same self-map/contraction inequalities into existence and uniqueness of one root inside that real branch.

That implication is stored separately as `PROP-EPSC-40`, tier `Open`.  This separation is mandatory under the project rule:

\[
\boxed{
\text{finite gate}
\neq
\text{silent assumption of real completeness/attained infinite limit}.
}
\]

A future fully finite-native branch theorem may instead supply a finite witness/exclusion certificate on a declared finite admissible record set.

## 6. EPSC-41: global translation-only branch capture is impossible for shell energy alone

`PROP-NSOBS-14` yields the explicit counterexample

\[
x_b\notin\mathbb T^3\!\cdot x_a,
\qquad
I^{(n)}(x_a)=I^{(n)}(x_b)
\]

for every arbitrary finite `n` in the declared one-mode N=1 construction.  Therefore

\[
\boxed{
\text{shell-energy-only data}
\not\Longrightarrow
\text{globally unique state in }X_1/\mathbb T^3.
}
\]

This is `PROP-EPSC-41`.  It is not a failure of the local inverse; it is a global invariance obstruction.

Accordingly, the original wording of `PROP-EPSC-36` must not be interpreted as demanding an impossible translation-only global orientation recovery from invariant shell data.

## 7. EPSC-42: corrected measurement target

A globally meaningful target must choose one of the following finite declarations:

\[
\boxed{
\text{raw shell samples}
\to
[x]_G\pm\rho_N
}
\]

where `G` contains every declared reader/dynamics symmetry being quotiented, or

\[
\boxed{
\text{raw shell samples}
+
\text{orientation-breaking reader/prior}
\to
x\pm\rho_N.
}
\]

This repaired target is `PROP-EPSC-42` and remains OPEN because the complete relevant symmetry group, a globally sufficient augmented reader, and practical measurement tolerances have not yet all been certified.

The immediate research consequence is important: **do not spend effort trying to force global uniqueness modulo translations from shell-energy-only data.**  Either return an orbit-valued answer or add information that breaks the discrete aliases.

## 8. Energy transfer remains a useful measurement layer

For finite Fourier--Galerkin shell energy,

\[
\dot I_s=T_s-2\nu sI_s+F_s.
\]

For prescribed forcing,

\[
T=\dot I+2\nu SI-F,
\]

so `(I,T)` is an affine reparameterization of `(I,dI/dt)` at first order; it does not create extra rank (`PROP-NSOBS-10`).  Integration gives the derivative-free finite window identity

\[
\int_{t_0}^{t_1}T_sdt
=
I_s(t_1)-I_s(t_0)
+2\nu s\int_{t_0}^{t_1}I_sdt
-\int_{t_0}^{t_1}F_sdt,
\]

which is `PROP-EPSC-21`.

Transfer is therefore a mechanism/measurement coordinate, not a substitute for the inverse or for symmetry accounting.

## 9. Optional outer completion

Only after a retained-state radius is valid for the declared target do we attach a separately proved omitted-tail certificate `beta_N`.  When the retained/tail splitting is orthogonal and the declared symmetry preserves the cutoff,

\[
\boxed{
\inf_{g\in G}\|u(T)-g\widehat x_N\|_2
\le
\sqrt{\rho_N^2+\beta_N^2}.
}
\]

This is `PROP-EPSC-17`.  The outer continuum adapter is optional and downstream.

## 10. Current open frontier

The finite-first frontier is now sharper:

- `PROP-EPSC-39`: finite direct-sample q/data-budget gate -- structurally specified; fixed-N=1 executable certificate is being reproduced.
- `PROP-EPSC-40`: real fixed-point existence adapter -- explicitly separate/Open.
- `PROP-EPSC-41`: translation-only global shell branch capture -- obstructed by explicit N=1 alias.
- `PROP-EPSC-42`: symmetry-aware/orientation-augmented repair -- OPEN.
- `PROP-EPSC-24`: practical N=1 measurement radius -- OPEN; `h=10^-200` is not sensor-ready.
- `PROP-EPSC-32`: arbitrary-finite-N constructive quantitative packages -- OPEN.
- `PROP-NSOBS-07`: arbitrary-finite-N earliest-order saturation -- OPEN.
- `PROP-EPSC-16`: scalable/tight outer certificate -- OPEN.

If a required finite certificate or explicitly declared adapter is missing, the verdict is `HOLD`.

No statement here proves continuum Navier--Stokes regularity, physical DNS adequacy, or the Clay Millennium problem.
