# Clay NS P2 status — energy-only H3 tail suppression no-go

**Date:** 2026-09-11  
**Role:** Toledo provenance/status note.  
**Claim effect:** negative bridge audit only; no Millennium Prize Problem conclusion is promoted.

## Source

Repository: `morrocwi/readout-problem-navier-stokes`  
Merged source commit: `af97fc84542dc042b3b6c386458fc0afbd797bef`  
Source PR: #37  
Primary statement: `paper/NS_FUB_A1_H3_TAIL_NO_GO.md`  
Exact controls: `reproduction/checks/check_ns_fub_a1_h3_tail_nogo.py`

The final source head passed the dedicated `ns-fub-a1-h3-tail-nogo` workflow together with the existing H3 witness, validated-tube, residual-tube, tube-chain, completeness, and Clay-governance workflows before merge.

## Non-canonical research statement

### `NS-FUB-A1-TAIL-L2-NOGO`

For every finite cutoff `N`, every `epsilon>0`, and every finite `B>0`, there exists a real divergence-free Fourier tail supported entirely above `N` satisfying

\[
\|u_{>N}\|_{L^2,F}\le\epsilon
\]

while

\[
\|u_{>N}\|_{H^3,F}>B.
\]

The source proof uses one conjugate Fourier mode pair `±(K,0,0)` with transverse polarization and amplitude `epsilon/2`; the H3 weight grows like `(1+K^2)^3` while the L2 mass remains fixed.

**Status:** DERIVED analytic counterexample theorem; representative instances are checked by exact rational/integer regression controls.

## P2 consequence

The following bridge premise is **REFUTED**:

```text
small omitted L2 / energy tail
    -> uniform omitted H3 tail bound
```

For fixed `N` and fixed positive `epsilon`, the supremum of the H3 norm over divergence-free tails with L2 norm at most `epsilon` is infinite.

A finite-band inequality of the form

\[
\|u_{N<\cdot\le M}\|_{H^3}^2
\le (1+M^2)^3\|u_{N<\cdot\le M}\|_{L^2}^2
\]

is valid but does not become an all-scale theorem because the coefficient diverges with `M`.

## Repair template and non-vacuity boundary

A stronger weighted tail budget such as

\[
\|u_{>N}\|_{H^{3+\sigma}}^2\le C
\]

implies

\[
\|u_{>N}\|_{H^3}^2\le (1+N^2)^{-\sigma}C.
\]

This is only a mathematically sufficient repair template. A uniform higher-Sobolev premise is not counted as progress toward Clay unless a new finite/PDE mechanism proves it without importing global regularity or a stronger equivalent target.

## Updated frontier

The positive `NS-FUB-A1/A2` tail route now requires a genuinely frequency-weighted or PDE-derived all-scale smoothing/decay mechanism. Total energy alone cannot provide the regularity-sensitive tail information.

The general `NS-FUB-A1`, `NS-FUB-A2`, and Clay Navier--Stokes regularity statements remain OPEN.

## Canonicalization

`NS-FUB-A1-TAIL-L2-NOGO` is a non-canonical research identifier. Toledo issue #11 remains the canonicalization gate. No generated canonical registry output is changed by this note.
