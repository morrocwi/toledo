# Clay NS P2 donor-ancestry / planar-closure / orthogonal-turn provenance — 2026-09-11

**Role:** Toledo provenance/status only.  
**Canonicalization:** still gated by Toledo issue #11.  
**Upstream immutable NS merge:** `morrocwi/readout-problem-navier-stokes@28e6db869251de9cd1c1ad441feb90520df71984` (PR #52).  
**Prior provenance:** `docs/CLAY_NS_P2_H1_WINDOW_FRESH_DONOR_2026-09-11.md`.

This note records the stabilized next P2 frontier after the H1/window/fresh-donor batch. It assigns no new Toledo equation code and does not promote `NS-P2-FRUSTRATION-OR-CUT`, `NS-P2B-SCALE-CONTRACTION-UNIFORM`, or Clay Navier--Stokes regularity.

## 1. Window donor-overlap charge

For the self-similar consecutive donors

\[
q_0=n(1,0,1),\qquad q_1=n(2,0,-1),\qquad r=n(3,0,0),
\]

the exact physical inhomogeneous H1 normalized amplitude coefficient satisfies

\[
\alpha_n^2-\frac12
=\frac{(n^2-1)(31n^2+5)}{10(1+2n^2)(1+5n^2)}\ge0.
\]

Hence `alpha_n >= 1/sqrt(2)` and on every finite window `I`,

\[
\frac1{\sqrt2}\int_I|X_{q_0}X_{q_1}|
\le
\int_I|D_r|+\int_I|R_r|.
\]

Recorded status includes:

```text
NS-P2-FRESH-DONOR-H1-AMPLITUDE-FLOOR          DERIVED
NS-P2-FRESH-DONOR-RESPONSE-OR-CANCELLATION    DERIVED
NS-P2-FRESH-DONOR-WINDOW-CHARGE               DERIVED
NS-P2-FRESH-DONOR-MULTISCALE-WINDOW-CHARGE    DERIVED
```

## 2. Positive-lag memory cannot supply arbitrarily large fresh donors

Combining the existing positive-lag Stokes H3 tail with `H1<=H3` and the energy inequality gives

\[
\epsilon_{N,\delta}
=\frac{8\sqrt3 M_0}{(2\nu\delta)^2(N+1)}.
\]

For an omitted H1 donor scalar coordinate decomposed into positive-lag memory plus recent nonlinear Duhamel,

\[
X_q=M_q^{(\delta)}+Y_q^{(\delta)},
\]

one has

\[
|Y_q^{(\delta)}|\ge (|X_q|-\epsilon_{N,\delta})_+.
\]

At donor scale `n`, choosing `N=n-1` makes the memory envelope `O(1/n)`. High donors above this envelope must therefore carry recent nonlinear ancestry.

Recorded status:

```text
NS-P2-FRESH-DONOR-STOKES-MEMORY-H1-TAIL       DERIVED
NS-P2-FRESH-DONOR-RECENT-ANCESTRY              DERIVED
NS-P2-FRESH-DONOR-LARGE-IMPLIES-RECENT         DERIVED
NS-P2-FRESH-DONOR-PAIR-RECENT-ANCESTRY         DERIVED
```

## 3. Exact mirror cancellation refutes automatic cancellation cost

The upstream merge gives a reflected donor pair producing the same target with the opposite exact Fourier--Leray coefficient. Hence symmetry-driven cancellation can be exact and need not be combinatorially complicated.

Recorded status:

```text
NS-P2-FRESH-DONOR-MIRROR-COEFF-CANCEL                  PASS
NS-P2-FRESH-DONOR-SIMPLE-CANCELLATION-EXISTS          DERIVED
NS-P2-FRESH-DONOR-CANCELLATION-AUTOMATICALLY-COSTLY   REFUTED
```

## 4. Exact plane-supported escape is a regular branch

Fourier support in a fixed lattice plane is invariant under the NSE convolution. The corresponding velocity field reduces exactly to a 2D3C system: two-dimensional Navier--Stokes for the in-plane velocity plus a passive advection-diffusion equation for the normal component.

By classical 2D NSE regularity, an exactly plane-supported fresh-donor/mirror escape is not a singularity-producing branch.

Recorded status:

```text
NS-P2-PLANAR-FOURIER-SUPPORT-INVARIANT       DERIVED
NS-P2-PLANAR-2D3C-REDUCTION                  DERIVED
NS-P2-PLANAR-ESCAPE-REGULAR                  DERIVED
NS-P2-EXACT-PLANAR-FRESH-DONOR-ESCAPE-SINGULAR REFUTED
```

## 5. Shared-mode plane-turn trichotomy

For two triads sharing mode `p`, with nonzero plane normals `n_1,n_2`, define

\[
c^2=\frac{(n_1\cdot n_2)^2}{|n_1|^2|n_2|^2},
\qquad
\mu=4c^2(1-c^2).
\]

Then `mu=0` iff `c^2` is `0` or `1`. Thus zero-dispersion shared-mode geometry is exactly:

```text
same plane
OR
orthogonal plane turn.
```

Positive `mu` returns to the already-derived shared-mode frame-mismatch frustration/cut branch.

Recorded status:

```text
NS-P2-SHARED-MODE-TURN-INVARIANT                         DERIVED
NS-P2-ZERO-DISPERSION-SAME-OR-ORTHOGONAL                DERIVED
NS-P2-SHARED-MODE-PLANE-TURN-TRICHOTOMY                 DERIVED
NS-P2-NONPLANAR-ZERO-DISPERSION-REDUCES-TO-ORTHOGONAL-TURNS DERIVED
NS-P2-SHARED-MODE-TURN-FIXTURES                         PASS
```

## 6. Exact all-scale orthogonal-turn selected escape

The final zero-dispersion non-planar local geometry is itself red-teamed by the integer matrix

\[
A=
\begin{pmatrix}
3&0&4\\
4&0&-3\\
0&5&0
\end{pmatrix},
\qquad
A^TA=25I,
\qquad
\det A=125.
\]

Define

\[
p_j=A^j e_1,
\qquad
q_j=A^j(2,4,0),
\qquad
p_{j+1}=p_j+q_j.
\]

Exact consequences verified by the source checker:

- every `p_j+q_j=p_{j+1}` is an integer Fourier triad;
- consecutive triad-plane normals are orthogonal for every `j`;
- the chain is genuinely three-dimensional;
- the orthogonal turn exchanges the adapted polarization axes at the shared backbone mode;
- every finite selected scalar prefix is phase-SAT;
- the physical homogeneous H1 **energy-transfer** coefficient is exactly

\[
\Gamma_j^{H^1,hom}=4\sqrt5
\]

for every scale;
- every step advances by more than a factor `2` in max-coordinate cutoff scale.

Recorded status:

```text
NS-P2-ORTHOGONAL-TURN-SIMILITUDE                      PASS
NS-P2-ORTHOGONAL-TURN-ALLSCALE-TRIADS                 DERIVED
NS-P2-ORTHOGONAL-TURN-ALLSCALE-GEOMETRY               DERIVED
NS-P2-ORTHOGONAL-TURN-AXIS-EXCHANGE                   DERIVED
NS-P2-ORTHOGONAL-TURN-H1-HOM-COEFF                    DERIVED
NS-P2-ORTHOGONAL-TURN-SELECTED-TREE-SAT               DERIVED
NS-P2-ORTHOGONAL-TURN-DYADIC-PROGRESS                 DERIVED
NS-P2-ORTHOGONAL-TURN-ALONE-FORCES-SELECTED-HOLONOMY  REFUTED
```

This selected tree is not claimed to be invariant under the full NSE convolution.

## 7. Updated load-bearing frontier

The spatial/geometric escape map is now substantially exhausted at the selected-channel level:

```text
positive frame dispersion
    -> existing frustration/cut tax;

same-plane zero dispersion
    -> 2D3C regular branch;

orthogonal-turn zero dispersion
    -> all-scale phase-SAT selected escape exists.
```

Therefore the next P2 attack is no longer another local geometry motif. It is the full NSE interaction closure of the orthogonal-turn chain, combined with recent nonlinear ancestry:

```text
full NSE convolution of orthogonal-turn chain
+ recent nonlinear ancestry
-> induced off-tree interaction graph
-> packed holonomy / relative window loss
   OR a matching richer escape
-> K_N / R_j contraction ?
```

Still OPEN:

```text
full-convolution orthogonal-turn interaction closure
recent-ancestry + induced-interaction relative scale loss
response/cancellation budget -> K_N inequality
constructive R_j recurrence
NS-P2-FRUSTRATION-OR-CUT
NS-P2B-SCALE-CONTRACTION-UNIFORM
Clay Navier-Stokes global regularity
```

## 8. Source paths and CI

Pinned source paths include:

```text
paper/NS_P2_FRESH_DONOR_WINDOW_CHARGE.md
paper/NS_P2_FRESH_DONOR_RECENT_ANCESTRY.md
paper/NS_P2_FRESH_DONOR_MIRROR_CANCELLATION.md
paper/NS_P2_PLANAR_ESCAPE_REGULAR_BRANCH.md
paper/NS_P2_SHARED_MODE_TURN_TRICHOTOMY.md
paper/NS_P2_ORTHOGONAL_TURN_ALLSCALE_ESCAPE.md
reproduction/checks/check_ns_p2_fresh_donor_window_charge.py
reproduction/checks/check_ns_p2_fresh_donor_recent_ancestry.py
reproduction/checks/check_ns_p2_fresh_donor_mirror_cancellation.py
reproduction/checks/check_ns_p2_planar_escape_regular_branch.py
reproduction/checks/check_ns_p2_shared_mode_turn_trichotomy.py
reproduction/checks/check_ns_p2_orthogonal_turn_allscale_escape.py
.github/workflows/ns-p2-donor-window-charge.yml
CLAY_GOVERNANCE_ACK.json
```

At the pinned PR head, the dedicated donor-window workflow passed every exact checker and claim-boundary guard; `ns-p2-triad-attack`, Clay governance, final-closure, H1 fresh-donor, holonomy-packing, and finite-observation gates were also green. No global regularity claim was promoted.
