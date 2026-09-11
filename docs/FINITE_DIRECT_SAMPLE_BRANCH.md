# Finite direct-sample branch bridge

Status: proposal/provenance note, finite-first. `PROP-EPSC-39` is a reusable local theorem connecting a **direct finite sample map** to branch capture and a retained-state radius. It is not a canonical Toledo code; `weld/P.??.v1` remains a placeholder pending canonical audit.

## Position in the chain

The measurement bridge is now best separated as

\[
\boxed{
\text{structural finite observability}
\to
\text{direct finite sample map }S
\to
(q<1+\text{raw-data self-map gate})
\to
\rho_N.
}
\]

This avoids the potentially ill-conditioned intermediate reconstruction

\[
\text{samples}\to\text{high-order scaled Taylor jet}\to\rho_N,
\]

whose exact finite conditioning is recorded as `PROP-EPSC-38`.

## PROP-EPSC-39

Let

\[
S:B(z,r)\subset\mathbb R^d\to\mathbb R^d
\]

be a finite differentiable direct observation map and let `A` be a fixed invertible preconditioner. Suppose

\[
q:=\sup_{x\in B(z,r)}\|I-A DS(x)\|_\infty<1.
\]

For raw observed center `y_obs`, finite model center `y_model`, sensor radius `sigma`, and validated forward-model radius `tau`, define

\[
\delta=\|y_{obs}-y_{model}\|_\infty+\sigma+\tau.
\]

If

\[
\boxed{\|A\|_\infty\delta+qr\le r,}
\]

then for every exact data vector inside that raw-data uncertainty box,

\[
T_y(x)=x-A(S(x)-y)
\]

is a contraction self-map of `B(z,r)`. Therefore there is one unique root of `S(x)=y` **inside that local branch**, and

\[
\boxed{
\|x-z\|_\infty
\le
\frac{\|A\|_\infty}{1-q}\delta.
}
\]

The importance for `PROP-EPSC-36` is that branch membership no longer has to be assumed as an external boolean: once a domain-specific calculation supplies `A`, `q`, `r`, `tau` and the raw measurement bounds, the self-map inequality itself certifies the local branch.

## Boundaries

`PROP-EPSC-39` does not construct a Navier--Stokes sample schedule, does not certify a particular `q`, and does not prove global injectivity. It certifies uniqueness only inside the declared finite branch. It also has no arbitrary-finite-`N`, continuum-regularity, physical-DNS, or Clay implication by itself.

The fixed-`N=1` Navier--Stokes instantiation is a separate executable obligation. Only after that domain checker passes should Toledo register the concrete fixed-resolution sample schedule and its numerical certificate as a separate proposal record.
