## Cycle and identifiability follow-up v0.3 (2026-10-14)

[Mathematical follow-up: what the Qi-cycle equations actually prove](https://github.com/morrocwi/toledo/blob/research/tcm-toledo-birca-bridge-20261014/docs/proposals/PROP-AGENCY-DANTIAN-CYCLE-03.md) · [nine Dr/PROPOSAL registrations AGDT-C19..C27](https://github.com/morrocwi/toledo/blob/research/tcm-toledo-birca-bridge-20261014/registry/proposals/agency_dantian_cycle_equations_v0_3.json) · [reproducible KG/SymPy test](https://github.com/morrocwi/toledo/blob/research/tcm-toledo-birca-bridge-20261014/registry/knowledge_graph/test_agency_cycle_v0_3.py). Original 457/845 semantic graph has 389 independent *cultural* cycles; expanded 497/959 relation rows have only 955 undirected unique connections and 459 semantic cycles. A source-attributed ten-edge directed practice loop exists, but physical Qi current is **not identified**. In the original graph DT-U exceeds DT-L in closeness and betweenness even though DT-L has more directly curated links. In graph incidence dynamics, nonzero loop current may have zero nodal divergence; a passive pure gradient flow cannot independently sustain a loop. No clinical validation, no newly minted CAN ID.

# Toledo × Agency × Dantian — Bridge v0.2: structural audit, agency gates and cyclic-flow hypothesis

**Date:** 2026-10-14  
**Status:** `PROPOSAL/Dr` for all new equations and edges; **finite diagnostic is limited to observed cultural KG structure and algebraic identities**, not physiology, clinical data or Qi circulation.  
**Canonical source-of-truth:** Toledo `registry/EQ_LIBRARY.md` and `EQUATION_SOURCE_POLICY.md`.  
**Source uploads:** `toledo_agency_dantian_bridge_sketch_v0.1(1).md`, `toledo_dt_agency_structural_audit(1).json`, `Pasted text(20261014-142328).txt`, original `qi_dantian_kg_v1(1).zip`, complete `qi_unified_kg_v1_1.zip`.  
**Equation registration:** [agency_dantian_equations_v0_2.json](../../registry/proposals/agency_dantian_equations_v0_2.json) — **18 separately listed Dr proposals**, 9 verified pre-existing equation anchors.  
**Graph registration:** [agency_dantian_bridge_overlay_v0_2.json](../../registry/knowledge_graph/agency_dantian_bridge_overlay_v0_2.json) — 15 additional typed conceptual nodes, 25 overlay semantic relations; separate two-step DAG with 20 nodes and 24 arrows. No original node/edge overwritten.  
**BIRCA ADMIN downstream:** [research report](https://github.com/morrocwi/birca_admin_5.0/blob/research/tcm-knowledge-readout-20261014/docs/agency_dantian/AGENCY_DANTIAN_STRUCTURAL_AUDIT_V02.md).

## 1. Research question and actual results

**H1** — Does Lower Dantian `DT-L` have a structurally distinct neighborhood compared with `DT-M`, `DT-U`, and close comparator points?  
**H2** — Does voluntarily attending to `DT-L` improve an independently selected subjective regulation outcome over neutral and other focus targets?  
**H3** — Does the change satisfy Toledo's *adaptive constraint/persistence* criterion for Agency, not merely a pleasant bodily sensation?  
**H4** — Does adding internal input/store/output ports and optional information-horizon interpretation give predictive value over attention, generic memory and storage-only baselines?

### Direct structural audit of real provided KG files (NO generated patients, NO invented measurements)

| Node | Original KG v1.0 direct relations | Prior unified KG v1.1 direct relations | Author-curated new links | Region / cross-tradition relations unchanged |
| --- | ---: | ---: | ---: | ---: |
| DT-L | **6** | **14** | +8 | **6** |
| DT-M | **4** | **5** | +1 | **4** |
| DT-U | **5** | **6** | +1 | **5** |
| EX-HN3 (Yintang; extra point) | 5 | 10 | +5 | 1 |
| CV6 | 5 | 7 | +2 | 1 |
| CV17 | 7 | 12 | +5 | 1 |
| GV20 | 8 | 15 | +7 | 1 |

Input v1.0 had **457 nodes and 845 edges**, v1.1 **497 nodes and 959 edges**. Exact JSON source SHA-256: original `5f02f479ad7092ecfcbc1b194e4df471065654930b1ba11cfcaf55786d4bedaa`; expanded `6aaf42b23b4dc0b503498877b33eef79337dcdbdedf14d51fd16608525c0080d`. The input filenames/arrays, rather than a novel clinical cohort, were audited. This is a **descriptive difference in curator-defined relations only**.

**Result:** `DT-L` has the highest degree of the three Dantian nodes *in the supplied ontology*, but that is partly the result of how the ontology was authored. It is **not independent evidence** that DT-L has more physical connectivity, Qi output or Agency. Remove the eight newly declared practice/fountain/observation edges, and the 6/4/5 pattern remains. There is no independent test that 6 vs 5 is a biologically meaningful margin. Note `DT-L` and `CV6` share an approximate lower-abdomen region, so CV6 alone is a weak placebo control.

## 2. Registered root equation ancestry (verified, DO NOT RENUMBER)

| Code actually in Toledo | Identifier | Applicability |
| --- | --- | --- |
| `EQ-015/M.02.v1` | CAN-003 | `S[n+1]=F(S[n],u[n],c[n],T[n])` native-step state evolution |
| `A.5/S.11.v1` | CAN-121-SPLIT-08 | `C[n+1]=G(x[n],C[n],H[n])` history-sensitive constraint update |
| `A.5/S.09.v1` | CAN-121-SPLIT-06 | `(∂Tp/∂C)(∂C/∂x)>0` scalar directional Agency condition, unestimated |
| `weld/H.02.v1` | CAN-051 | `Delta_A(lambda)=D_A^2-4M_AK_A lambda`; horizon triad (no physical black-hole identification) |
| `EQ-002/M.03.v1` | CAN-201 | candidate readout `z` is not the full retained state `S` |
| `weld/M.02.v1` | CAN-006 | biological dynamical weld `q_B circ F=F_B circ q_B` NOT proven |
| `EQ-015/P.60.v1` | RUS-0108 | Bernoulli on physical steady flow only |
| `EQ-015/P.61.v1` | RUS-0109 | fluid continuity on physical ducts only |
| `EQ-015/P.116.v1` | RUS-0164 | laminar cylindrical-fluid Poiseuille; no asserted meridian tubes |

## 3. Typed bridge with native-event ordering (all new terms Dr PROPOSAL)

```text
r_v,n = O_v(z_n, A_n=v, c_n),      z_n = q_B(S_n)
x_n^(v) = (z_n, r_v,n)
C_(n+1) = G(x_n^(v), C_n, H_n)  [specializes registered A.5/S.11]
u_n = pi(C_(n+1), H_n, r_v,n)
S_(n+1) = F(S_n, u_n, c_n, T_n) [unchanged CAN-003]
```

This is a step-ordered sub-operation sequence, not necessarily a biological reflex. The overlay links a stable historical KG to **separate** proposed causal semantics. Any graph cycle involving outcome feedback is only valid when unrolled from one native step to the next. Observational timestamps are not automatically Toledo `n`.

**Agency test:** `Gamma_v=(∂T_p/∂C)(∂C/∂x^(v))>0` is a *hypothesis to estimate*, not proven by concentration, tingle, connection count or report of energy.

**Intervention estimands (not computed):**

```text
Delta_v = E[Y | do(A=v)] - E[Y | do(A=neutral)]
Theta_L = Delta_DT-L - max_{v in comparators} Delta_v
```

Choose outcome `Y` before data collection (e.g., return-to-calm or undistracted reorientation at a prespecified observation). Randomized/counterbalanced conditions must include `DT-L`, `DT-M`, `DT-U`, `EX-HN3`, a nearby but distinctly instructed lower-abdomen control, and neutral grounding; `CV6` is not independent of DT-L. Control instruction length, expectancy, breathing and posture. The contrast `Theta_L` may be positive for one stated outcome and nonpositive for another; it is *not* proof of a Qi reservoir or black-hole horizon.

## 4. Flow circulation, reservoir and horizon *as mathematical analogy*

**Critical algebraic degeneracy** of an ordinary source-sink forcing:

```text
J_n = j_n (e_source - e_sink).
If source == sink == DT-L, J_n = 0 (exact identity).
```

This means a one-vertex net-flux representation cannot express an **internal** circulation inside DT-L. It does NOT demonstrate that a human practitioner cannot experience lower-abdominal warmth or focus. Use *typed internal ports*:

```text
DT-L : INPUT PORT  -> ENCODE / MEMORY (H_n)
          -> TRANSFORM (NOT LITERAL BLACK HOLE)
          -> SELECT/DECODE -> DT-L : OUTPUT PORT
          -> external readout -> H_(n+1) [next-step only].
```

With a *common ledger unit and declared capacity* a proposed reservoir accounting identity is

```text
h_(n+1) = h_n + J_in - J_out - J_loss - J_reject.
```

No quantity of actual Qi, pressure, information mass or treatment effect has been measured. Retained information alone does not guarantee Agency: **memory/storage != adaptive constraint regulation**.

### The discrete modal calculation was checked symbolically

For a candidate graph mode `lambda>0`:

```text
M(y[n+1]-2y[n]+y[n-1]) + D(y[n]-y[n-1])
  + K*lambda*y[n] = J[lambda,n]

p(r) = M*r^2 + (-2*M+D+K*lambda)*r + (M-D)
Disc = (D+K*lambda)^2 - 4*M*K*lambda
```

With `M>0`, strict Schur stability of that single unforced scalar mode is equivalent to `D>0`, `K*lambda>0`, and `2*D + K*lambda < 4*M` (for this specific discrete stencil). With `lambda=0`, `p(r)=(r-1)(M*r+ D-M)`, so a **neutral root r=1** remains — do not claim all graph modes strictly decay. No measured modal damping parameter exists for acupoints or Dantian. This is **algebra not a clinical/biophysical test**.

### Mobile fountain and Chinese/Indian/cosmological nodes

In the inherited v1.1 cultural graph, alternate attention/source anchors include `DT-L`, `DT-M`, `DT-U`, `EX-HN3`, `GV20`, `CV6`, and any other declared point; the 361 atlas points are **labels**, not proved pipes. The Chinese 小周天 loop and distinct Indian chakra/Sushumna axis remain independent historical/practice layers. The user-declared **GV20 ↔ heaven**, **KI1 soles ← Earth**, and **PC8 palms → external world** stay symbolic and are not candidate physiological causal input/output without an assay. The proposed DT-L split ports do not add or alter WHO point codes.

## 5. No fabricated physiological experiment

| Experiment | Admissible conclusion today |
| --- | --- |
| Graph degree and source-tagged neighborhood comparison | **COMPLETED: DT-L 6/4/5 historical ontology edge count; v1.1 14/5/6.** |
| Algebraic source/sink cancellation | **COMPLETED: exact 0 at equal source/sink** |
| Symbolic discrete characteristic / Jury constraints | **COMPLETED: formula and zero-mode exception** |
| `E[Y|do(A=v)]` for DT-L and other focus targets | **NOT TESTED: no intervention observation** |
| Agency `Gamma_v>0` for real human body | **NOT TESTED** |
| Biological Toledo/BIRCA CAN-006 weld, real qi flux or pressure | **HOLD** |
| Added-value of information horizon beyond ordinary memory and attentional regulation | **NOT TESTED** |

**Required next empirical step:** source-independent, randomized real-person attention comparison with ethical consent and safe ordinary breathing; use genuinely recorded Y and proper uncertainty bounds, lock comparison criteria before data. Ask whether an attention target specifically outperforms controls, then separately test if context-relevant adaptive constraints and viability actually improve.

**Conclusion:** DT-L is a *distinct culturally designated, information-rich node* of the ontology, not a validated special physiological/Agency center. What the model gives us is a falsifiable experimental bridge, not a proven way to circulate physical Qi.
