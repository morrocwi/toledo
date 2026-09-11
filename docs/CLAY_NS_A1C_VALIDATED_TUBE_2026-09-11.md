# Clay NS-FUB-A1C-V Status — 2026-09-11

**Role:** Toledo provenance/status note.  
**Claim boundary:** fixed-`N=1` finite verifier/calibration only; no Clay conclusion.

## Source

Repository: `morrocwi/readout-problem-navier-stokes`  
Merged commit: `188671ff50273587588e1e74be7f6f03e8d3b5a5`  
Source PR: `#29`  
Primary note: `paper/NS_FUB_A1C_VALIDATED_TUBE.md`  
Executable checker: `reproduction/checks/check_ns_fub_a1c_n1_validated_tube.py`

## Result

For the existing 52-dimensional `N=1` exact Fourier-Galerkin coordinates, the checker uses

\[
F(x)=\frac{1}{600}(Dx+T(x,x)),
\]

with the previously audited exact integer quadratic tensor. It constructs a rational tube around the deterministic small-integer center and checks a self-map bound plus a strict contraction bound.

The final-head GitHub Actions evidence passed `ns-fub-a1c-validated-tube`, `ns-fub-a1-h3-witness`, and `Clay Research Governance`.

Exact calibration output:

\[
r=\frac1{1000},\qquad
\max_i M_i=\frac{52651213}{200000},\qquad
L_\infty=\frac{2009}{8},
\]

\[
h=\frac{100}{52651213},\qquad
\frac{hM}{r}=\frac12,
\]

\[
hL=\frac{50225}{105302426}<\frac12.
\]

The same run reproduced:

```text
exact tensor nonzero coefficients = 2096
exact tensor infinity row-sum = 36000
```

The validated endpoint enclosure was converted to full Fourier coefficient rectangles and passed to the existing exact `NS-FUB-A1V` verifier, producing an exact positive `H^3 > 1` margin. The threshold `1` is a calibration threshold only and has no singularity significance.

## Toledo status

### `NS-FUB-A1C-V`

- finite exact certificate inequalities: **PASS** at the pinned fixed-`N=1` calibration;
- tube/endpoint implication: **DERIVED** from standard finite-dimensional Banach contraction theory under the checked bounds;
- identifier remains a non-canonical research sub-identifier.

### `NS-FUB-A1C-G`

General/adaptive validated certificate generator for arbitrary admissible finite cutoffs and target finite times: **OPEN**.

### `NS-FUB-A1C-X`

Finite-time singularity implies a constructible validated `A1V` exceedance certificate: **OPEN**.

## Non-vacuity boundary

This result closes a checker-side finite trajectory-enclosure gap only. It does not provide arbitrary-`N` validated integration, a uniform regularity-sensitive bound, a singularity exclusion theorem, or a continuum/global regularity bridge.

The next load-bearing direction is a finite multi-step certificate-chain verifier and then a genuinely general/adaptive generator or a counterexample showing why the proposed generator class is insufficient.

## Canonicalization

No Toledo canonical code is assigned by this note. Toledo issue #11 remains the canonicalization gate.
