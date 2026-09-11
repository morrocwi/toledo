# Clay NS P2 H1 / window packing / fresh-donor provenance — 2026-09-11

**Role:** Toledo provenance/status only.  
**Canonicalization:** still gated by Toledo issue #11.  
**Upstream immutable NS merge:** `morrocwi/readout-problem-navier-stokes@f6e6980df9576e5091e9d1ad01827002a24767c5` (PR #51).  
**Prior P2 provenance:** `docs/CLAY_NS_P2_COMPLEX_HOLONOMY_GEOMETRIC_CUT_2026-09-11.md`.

This note records the next stabilized constructive-P2 frontier. It assigns no new Toledo equation code and does not promote `NS-P2-FRUSTRATION-OR-CUT`, `NS-P2B-SCALE-CONTRACTION-UNIFORM`, or Clay Navier–Stokes regularity.

## 1. Polarization-gauge correction

The upstream merge proves that a single non-collinear Fourier triad admits an adapted real divergence-free frame with only three nonzero scalar Fourier–Leray channels. The earlier coplanar ladder also admits a common adapted frame with an explicit SAT phase assignment.

Therefore the fixed-basis identities remain valid in their declared coordinates, but the stronger interpretation that single-triad/coplanar-ladder scalar holonomy is polarization-basis invariant is REFUTED.

Recorded status:

```text
NS-P2-TRIAD-ADAPTED-SPARSE-TENSOR                 DERIVED
NS-P2-SINGLE-TRIAD-HOLONOMY-BASIS-INVARIANT      REFUTED
```

## 2. Gauge-robust shared-mode geometry and zero-dispersion holonomy

For incident triads at one shared mode the source defines projective frame dispersion

\[
D_p=1-\left|\frac1W\sum_r w_r e^{i4\theta_r}\right|^2
=\frac4{W^2}\sum_{r<s}w_rw_s\sin^2(2\delta_{rs}).
\]

Positive dispersion forces weighted mass of non-simultaneously-adaptable pairs.

The source also gives an exact all-scale 3D network with zero projective dispersion at its shared modes but an exact cross-triad `pi` holonomy. Hence zero frame dispersion does not imply phase SAT or lower-dimensional/non-dyadic escape.

Recorded status includes:

```text
NS-P2-FRAME-DISPERSION-IDENTITY                       DERIVED
NS-P2-FRAME-DISPERSION-PAIR-MASS                      DERIVED
NS-P2-FRAME-COMPATIBLE-DYADIC-HOLONOMY-ALLN          DERIVED
NS-P2-ZERO-FRAME-DISPERSION-IMPLIES-PHASE-SAT        REFUTED
NS-P2-ZERO-FRAME-DISPERSION-IS-LOWER-DIMENSIONAL     REFUTED
```

## 3. Cutoff-uniform H1 bridge

For the gauge-compatible four-channel dyadic holonomy cycle, the source recomputes the coefficients in the physical H1 normalization used by the finite-observation quantity `K_N`:

\[
-\sqrt2,\qquad -2\sqrt3,\qquad +\sqrt6,\qquad -2.
\]

Thus every member has homogeneous H1 magnitude at least `sqrt(2)`, and the physical inhomogeneous H1 magnitude has the conservative all-scale floor

\[
|\Gamma_i^{H^1,inh}|\ge\frac1{\sqrt2}.
\]

Recorded status:

```text
NS-P2-FRAME-COMPATIBLE-DYADIC-H1-HOM-FLOOR      DERIVED
NS-P2-FRAME-COMPATIBLE-DYADIC-H1-INH-FLOOR      DERIVED
NS-P2-H1-CYCLE-WEIGHT-ADAPTER                    DERIVED finite coordinate identity
```

This removes coefficient decay with cutoff as an escape for that exact cycle in the normalization relevant to `K_N`.

## 4. Non-overcounted and window-integrated holonomy packing

For a finite family of four-channel `pi` cycles with amplitude budget `A_e`, greedy fractional packing yields packed mass `P` and

\[
\sum_eT_e\le\sum_eA_e-c_0P,
\qquad c_0=1-1/\sqrt2.
\]

The saturated channels form a hitting set `H` with

\[
A(H)\le4P.
\]

The pointwise inequality integrates directly across any finite observation window:

\[
T_I\le S_I-c_0P_I.
\]

Therefore arbitrary switching of which edge pays the phase error does not erase the packed-cycle tax.

Recorded status:

```text
NS-P2-HOLONOMY-GREEDY-PACKING                 DERIVED
NS-P2-HOLONOMY-NONOVERLAP-TAX                 DERIVED
NS-P2-HOLONOMY-HITTING-SET                    DERIVED
NS-P2-HOLONOMY-PACKING-OR-HITTING-CUT         DERIVED
NS-P2-HOLONOMY-WINDOW-TAX                     DERIVED
NS-P2-HOLONOMY-WINDOW-PACKING-OR-CUT          DERIVED
NS-P2-PHASE-SWITCHING-EVADES-PACKED-HOLONOMY-TAX REFUTED
```

## 5. Fresh-donor conflict-free escape and its dynamic cost

The source then red-teams the small-packing/conflict-free branch with an exact all-scale selected channel tree. It is constructively phase-SAT for every finite prefix, advances one dyadic max-coordinate boundary per selected step, and has a cutoff-uniform H1 coupling floor.

Thus static holonomy geometry alone does not make the conflict-free remainder weak:

```text
NS-P2-CONFLICT-FREE-REMAINDER-GEOMETRICALLY-WEAK   REFUTED
NS-P2-SPATIAL-HOLONOMY-ALONE-FORCES-CONTRACTION    REFUTED
```

However, the selected tree is not invariant under the full NSE convolution. For the first consecutive donors

\[
q_0=n(1,0,1),\qquad q_1=n(2,0,-1),
\]

the off-tree mode

\[
r=q_0+q_1=n(3,0,0)
\]

is generated with raw coefficient

\[
c_{01}=\frac{3\sqrt{10}}{10}n,
\]

homogeneous H1 coefficient `9/5`, and conservative inhomogeneous H1 floor `9/10` in the energy-transfer normalization. On the declared two-step support with `z_r=0`, the only other reality-allowed backbone pair summing to `r` has zero coefficient, so simultaneous nonzero donors generate the off-tree mode immediately.

Recorded status:

```text
NS-P2-DYADIC-FRESH-DONOR-COEFF-ALLN            PASS exact identities
NS-P2-FRESH-DONOR-TREE-SAT                      DERIVED
NS-P2-DYADIC-FRESH-DONOR-H1-FLOOR               DERIVED
NS-P2-FRESH-DONOR-INDUCED-COEFF-ALLN            PASS exact identities
NS-P2-FRESH-DONOR-INDUCED-H1-FLOOR              DERIVED
NS-P2-FRESH-DONOR-TREE-NOT-INVARIANT             DERIVED on declared support
NS-P2-FRESH-DONOR-OVERLAP-OR-DYNAMIC-COST        DERIVED on declared support
```

## 6. Current load-bearing frontier

The upstream merge narrows the unresolved P2 bridge to a genuinely dynamical statement:

```text
conflict-rich critical transfer
  -> packed holonomy window tax;

conflict-poor critical transfer
  -> small donor overlap
     OR off-tree/cancellation mass that must be recursively charged.
```

Still OPEN:

```text
window aggregation of induced donor/off-tree interactions
recursive control of cancellation complexity
channel-envelope inequality -> K_N / R_j contraction
constructive all-scale R_j recurrence
NS-P2-FRUSTRATION-OR-CUT
NS-P2B-SCALE-CONTRACTION-UNIFORM
Clay Navier-Stokes global regularity
```

The next attack should therefore target a window donor-overlap / response-or-cancellation charge and its composition across scales, not another isolated phase motif.

## 7. Source paths and CI

The immutable source merge includes the theorem notes/checkers/workflows for:

```text
paper/NS_P2_POLARIZATION_GAUGE_FRAME_COVER.md
paper/NS_P2_FRAME_COMPATIBLE_DYADIC_HOLONOMY.md
paper/NS_P2_FRAME_COMPATIBLE_DYADIC_H1_BRIDGE.md
paper/NS_P2_HOLONOMY_PACKING_DICHOTOMY.md
paper/NS_P2_HOLONOMY_WINDOW_PACKING.md
paper/NS_P2_DYADIC_FRESH_DONOR_TREE_ESCAPE.md
paper/NS_P2_FRESH_DONOR_INDUCED_INTERACTION.md
reproduction/checks/check_ns_p2_polarization_gauge_frame.py
reproduction/checks/check_ns_p2_frame_compatible_dyadic_holonomy.py
reproduction/checks/check_ns_p2_frame_compatible_dyadic_h1_floor.py
reproduction/checks/check_ns_p2_holonomy_packing_dichotomy.py
reproduction/checks/check_ns_p2_holonomy_window_packing.py
reproduction/checks/check_ns_p2_dyadic_fresh_donor_tree.py
reproduction/checks/check_ns_p2_fresh_donor_induced_interaction.py
```

At the pinned PR head, the P2 triad attack, holonomy packing, H1/fresh-donor, Clay governance, final-closure and finite-observation gates were green. No global regularity claim was promoted.
