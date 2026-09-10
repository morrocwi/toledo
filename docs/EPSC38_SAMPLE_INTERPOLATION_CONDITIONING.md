# EPSC-38 — finite sample interpolation conditioning

Status: proposal/provenance note. `PROP-EPSC-38` uses placeholder Toledo code `weld/P.??.v1` until canonical audit.

`PROP-EPSC-37` established a fixed-`N=1` structural bridge from a saturated Taylor observation chart to a derivative-free finite-time sample chart for sufficiently small nonzero spacing. `PROP-EPSC-38` records a different, quantitative finite-algebra fact: if one reconstructs Taylor/interpolation coefficients from samples and then applies a diagonal scaling, the exact induced infinity-norm amplification is

\[
\boxed{
\kappa_\infty(h)
=
\|S D_h^{-1}V^{-1}\|_\infty
=
\max_n |s_n| |h|^{-n}\sum_j |(V^{-1})_{nj}|.
}
\]

Thus a sample-space measurement radius `sigma` and separately certified sample-model remainder `r_sample` obey

\[
\|\delta z\|_\infty
\le
\kappa_\infty(h)(\sigma+r_{sample}).
\]

For the present `N=1` Navier--Stokes application, the two 24-sample primary shell channels use nodes `0,...,23` and the existing scaled Taylor chart uses `s_n=600^n n!`. Exact rational reproduction shows order 23 dominates at the tested spacings and gives

\[
10^{70}\le\kappa_\infty(1)<10^{71},
\]

\[
10^{93}\le\kappa_\infty(10^{-1})<10^{94},
\]

\[
10^{116}\le\kappa_\infty(10^{-2})<10^{117},
\]

\[
10^{134}\le\kappa_\infty(1/600)<10^{135}.
\]

This narrows the measurement programme: structural invertibility at small spacing does not make the route `samples -> high-order scaled Taylor chart -> retained inverse` measurement-ready. The preferred next target is a direct finite sample-map inverse with an explicit spacing, validated flow/tangent enclosure, branch-wide preconditioned defect `q_h<1`, noise propagation and branch capture.

`PROP-EPSC-36`, `PROP-EPSC-19`, arbitrary-finite-`N` extension, outer `beta_N`, physical DNS adequacy, continuum Navier--Stokes regularity and the Clay Millennium problem remain open and separate.
