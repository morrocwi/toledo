# Clay NS P2 complex holonomy and geometric frustration-or-cut provenance — 2026-09-11

**Role:** Toledo provenance/status note only.  
**Canonicalization:** still gated by Toledo issue #11.  
**Upstream immutable NS merge:** `morrocwi/readout-problem-navier-stokes@e1f9cef783e39724279216db92dfdeaa65bcb39f` (PR #50).  
**Prior handoff provenance:** `docs/CLAY_NS_P0_P2_HANDOFF_TRIAD_ATTACK_2026-09-11.md`.

This note records the next stabilized P2 frontier after the P0–P2 handoff. It does not assign canonical Toledo equation codes and does not promote the Clay Navier–Stokes regularity problem.

## Upstream source paths

The immutable source merge contains:

```text
paper/NS_P2_COMPLEX_PHASE_HOLONOMY.md
paper/NS_P2_DYADIC_COMPLEX_PHASE_HOLONOMY.md
paper/NS_P2_GEOMETRIC_FRUSTRATION_CUT_FAMILY.md
reproduction/checks/check_ns_p2_phase_holonomy.py
reproduction/checks/check_ns_p2_dyadic_phase_holonomy_alln.py
reproduction/checks/check_ns_p2_geometric_frustration_cut_family.py
.github/workflows/ns-p2-triad-attack.yml
CLAY_GOVERNANCE_ACK.json
```

At the upstream merge, the P2 exact checker workflow and Clay governance gate were green.

---

## 1. Genuine complex phase holonomy

For scalar complex Fourier amplitudes in the declared real divergence-free polarization basis, an actual Fourier–Leray channel `p+q=k` has

\[
\dot z_k=-ic_\tau z_pz_q,
\]

so the target-mode quadratic transfer is

\[
\frac{d}{dt}|z_k|^2=2c_\tau\operatorname{Im}(z_pz_q\overline{z_k}).
\]

The maximizing phase target is therefore derived from the actual channel coefficient:

\[
\Theta_\tau^*=\operatorname{sgn}(c_\tau)\frac{\pi}{2}\pmod{2\pi}.
\]

The all-`n` overlapping-channel family pinned by the upstream merge has exact coefficients

\[
-n,\qquad -\frac1n,\qquad -\frac{n^3}{n^2+1},\qquad +\frac{n^3}{n^2+1},
\]

with incidence dependency

\[
r_A-r_B+r_C-r_D=0,
\]

but maximizing targets have a `pi` holonomy mismatch. Hence simultaneous outward saturation is impossible for every integer `n>=1`.

The mismatch gives

\[
\max_i\operatorname{dist}_{\mathbb T}(\Theta_i,\Theta_i^*)\ge\frac\pi4
\]

and the local quantitative tax

\[
\sum_iT_i\le\sum_iA_i-\left(1-\frac1{\sqrt2}\right)\min_iA_i.
\]

Source status:

```text
NS-P2-COMPLEX-CHANNEL-COEFF-ALLN   PASS exact symbolic checker
NS-P2-COMPLEX-HOLONOMY-ALLN        DERIVED
NS-P2-COMPLEX-HOLONOMY-TAX         DERIVED
NS-P2-LOCAL-FRUSTRATION-OR-CUT     DERIVED
```

These are local/network-family statements only.

---

## 2. Genuine dyadic `n -> 2n` complex holonomy

The upstream merge also pins the exact family

\[
p=(0,0,n),\qquad q=(n,-n,n),\qquad k=(n,-n,2n),
\]

so all declared channels cross max-coordinate scale `n -> 2n`.

The four polarization-channel coefficients are

\[
-\frac{n^2}{5},\qquad
+\frac{3n^3}{5},\qquad
-\frac n{15},\qquad
-\frac{7n^2}{15}.
\]

Their incidence rows obey

\[
r_A-r_B-r_C+r_D=0,
\]

while the maximizing targets again have a `pi` mismatch. Thus simultaneous outward saturation is impossible for every integer `n>=1`.

The exact `H^3`-normalized channel magnitudes share a common scale factor asymptotic to `const/n^2`; the source therefore explicitly does **not** treat the local coupling as cutoff-uniform by itself.

Source status:

```text
NS-P2-DYADIC-COMPLEX-HOLONOMY-ALLN    DERIVED
NS-P2-DYADIC-LOCAL-FRUSTRATION-OR-CUT DERIVED
```

Boundary coverage remains OPEN.

---

## 3. Three-parameter geometric frustration-or-cut family

The stronger family in the source merge is

\[
p=(0,0,a),\qquad
q=(b,-b,c),\qquad
k=(b,-b,a+c),
\]

for positive integers `a,b,c`, with one input polarization fixed and a `2x2` rectangle over the other input/output polarizations.

Its exact coefficient product factors as

\[
 c_Ac_Bc_Cc_D
=
\frac{
2a^6b^6(a^2-b^2-c^2)(ac+b^2+c^2)P
}{D_1^4D_2^2},
\]

where all factors except `a^2-b^2-c^2` are positive on the declared domain.

Therefore the family has the exact phase/geometry trichotomy:

```text
a^2 < b^2+c^2  -> pi phase holonomy and local frustration tax
a^2 = b^2+c^2  -> one channel coefficient vanishes exactly
a^2 > b^2+c^2  -> this four-channel rectangle is phase-compatible
```

The compatible branch is not treated as a success of unrestricted transfer. Writing

\[
x=b/a,\qquad y=c/a,
\]

phase compatibility or the exact-cut boundary implies

\[
x^2+y^2\le1.
\]

If near-dyadic vertical scale gain is required,

\[
a+c\ge(2-\eta)a,
\qquad 0\le\eta\le\frac12,
\]

then

\[
\frac ba\le\sqrt{2\eta}.
\]

After physical inhomogeneous `H^3` normalization, the source proves the explicit conservative bound

\[
\boxed{
|\Gamma_i^{\rm inh}|\le\frac{12288\sqrt\eta}{a^2}
}
\]

for every channel in the rectangle.

Thus, in this declared actual Fourier–Leray family, approaching factor-two scale gain cannot simultaneously retain both phase compatibility and nondegenerate normalized coupling.

Source status:

```text
NS-P2-GEOMETRIC-CHANNEL-FACTOR              PASS exact symbolic identities
NS-P2-GEOMETRIC-PHASE-TRICHOTOMY            DERIVED
NS-P2-GEOMETRIC-NEAR-DYADIC-CUT             DERIVED
NS-P2-GEOMETRIC-FRUSTRATION-OR-CUT-FAMILY   DERIVED
```

This remains a **family theorem**, not an all-boundary coverage theorem.

---

## 4. What changed from the previous Toledo handoff

At the prior provenance merge, genuine overlapping complex phase holonomy was still OPEN. The new immutable NS merge advances that frontier to exact/derived results for two explicit all-scale families and a three-parameter geometric family.

The following statements remain unresolved and are not promoted:

```text
all dyadic-boundary flux is quantitatively covered by taxed/weak sectors      OPEN
high-weight phase-compatible sparse/forest escape is excluded                 OPEN
temporal phase switching over the finite observation window is controlled     OPEN
constructive cutoff-uniform/nonuniform-decaying R_j recurrence is proved      OPEN
NS-P2-FRUSTRATION-OR-CUT as the parent global mechanism                       OPEN
Clay Navier-Stokes global regularity                                           OPEN
```

The next load-bearing falsification target is a symmetry/sector coverage theorem **or** an actual high-weight phase-compatible escape network. Only after such spatial coverage survives should the programme move to temporal switching and the finite-observation recurrence.

---

## 5. Canonicalization boundary

No canonical Toledo code is assigned by this note.

Toledo issue #11 remains the canonicalization gate. Any future registry promotion must separately audit source stability, parents/relations, legal Toledo code assignment, evidence tier, and OPEN/HOLD boundaries, and must use normal Toledo tooling rather than hand-edit generated registry outputs.
