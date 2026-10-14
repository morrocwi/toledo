# Toledo — What the Agency × Dantian equations actually reveal about “Qi circulation” (v0.3)

**Date:** 2026-10-14 · **Tier:** Dr / source-audited graph structure + exact graph-algebra identities, **NOT a physiological discovery**.  
**Mathematical root:** Toledo `CAN-003` (step), `CAN-006` (biological weld HOLD), `CAN-201` (readout ≠ hidden state), `CAN-115` (Laplacian/forced graph), `RUS-0109` (continuity for **real fluid under its physical assumptions**).  
**New equations:** [nine individually registered proposal objects](../../registry/proposals/agency_dantian_cycle_equations_v0_3.json) `AGDT-C19` through `AGDT-C27`. All are tagged **proposal** and none has a new `CAN` ID.  
**Prior source:** [Agency–DT-L v0.2](PROP-AGENCY-DANTIAN-BRIDGE-02.md), [18 earlier equation proposals](../../registry/proposals/agency_dantian_equations_v0_2.json), [graph v1.1](../../registry/knowledge_graph/README_QI_V1_1.md).  
**Downstream:** [BIRCA **Admin** v0.3 readout](https://github.com/morrocwi/birca_admin_5.0/blob/research/tcm-knowledge-readout-20261014/docs/agency_dantian/AGENCY_DANTIAN_CYCLE_READOUT_V03.md).

## One-sentence result / ข้อค้นพบ

**A closed, culturally labelled circulation route is not a measured flow: edge current can be nonzero while all node-level changes are zero, and passive symmetric gradient flow cannot maintain an independent cycle current.**

This means `DT-L`, `EX-HN3`, the spine, palms and soles can remain useful **attention/readout labels**, but their semantic routes cannot establish physical Qi channels or individualized efficacy. The user's information-first proposal identifies Qi as **information transformation**, *not* a liquid or movement of energy. Flow equations here formalize specific **readout analogies**, not the essence of Qi.

## 1. Direct audits against the two actual uploaded graphs

| Input | Nodes | Edge relationship rows | Unique undirected connections | Components | Independent undirected semantic cycle rank |
| --- | ---: | ---: | ---: | ---: | ---: |
| Original `qi_dantian_kg_v1` | **457** | **845** | **845** | 1 | **389** |
| Expanded `qi_unified_kg_v1_1` | **497** | **959** | **955** | 1 | **459** |

For an undirected underlying simple network, `rank_cycle = m - n + k`; *the counts above are mostly loops of cultural categories and atlas relations, not physical “Qi orbits”*. The expanded graph contains **4 pairs** with different semantics on the same undirected endpoints; its 959 relation rows are not 959 independent pipes.

### DT-L does not win every metric

| Node | Original incident links | Original closeness | Original betweenness | Expanded incident **rows** | Expanded distinct-neighbor degree | Expanded closeness | Expanded betweenness |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| **DT-L** | 6 | 0.108159 | 0.000130 | 14 | 13 | 0.201954 | 0.042100 |
| **DT-M** | 4 | 0.107878 | 0.000020 | 5 | 5 | 0.171448 | 0.000890 |
| **DT-U** | 5 | **0.113772** | **0.013140** | 6 | 6 | 0.189169 | 0.007930 |
| **GV20** | 8 | 0.127803 | 0.023820 | 15 | 15 | **0.211694** | **0.107530** |

**Falsifying a convenient conclusion:** the original `DT-U` scores above `DT-L` on *closeness and betweenness*, even while `DT-L` has more direct relations. The expanded `GV20` is also more central than `DT-L` on these two measures. The metrics are still **semantic atlas properties only**; no bodily Agency effect follows.

The expanded graph specifically contains a **single ten-edge directed practice circuit**:
```
DT-L → CV1 → GV1 → GV4 → GV14 → GV20
     → CV22 → CV17 → CV12 → CV6 → DT-L
```
All ten edges are `PRACTICE_MODEL_VARIANT`; the directed closed chain is **NOT a causal DAG** and is not an experimentally verified meridian or fluid channel. The separate *step-unrolled* causal hypothesis DAG remains acyclic.

## 2. Mathematical discovery A: cyclic connectivity ≠ circulating current

Pick an **arbitrary orientation** for the edges of an *actual specified graph*; let `B∈R^{m×n}` be the edge–vertex incidence matrix, `j_n∈R^m` a hypothetical edge flux, `u_n` external input, and `s_n` a conserved node stock **if and only if that stock and its units have been operationally defined**.

```text
[AGDT-C19] dim ker(B^T) = m - n + components
[AGDT-C20] s_(n+1) = s_n + B^T j_n + u_n
            1^T(s_(n+1)-s_n)=1^T u_n
```

If a hypothetical current `c` lies in `ker(B^T)`, then `B^T c=0`. Therefore a **nonzero loop current** can produce **zero observable node stock change**. This is why merely reading a person's felt pressure at the brow or warmth at DT-L cannot establish the direction or existence of Qi flow.

**Exact four-node incidence witness**, checked algebraically, NOT a biological data simulation:

```text
B = [[-1, 1, 0, 0],
     [ 0,-1, 1, 0],
     [ 0, 0,-1, 1],
     [ 1, 0, 0,-1]]

c = [3,3,3,3]^T   (nonzero)
B^T c = [0,0,0,0]^T
```

This is a **counterexample to “nothing changes at the nodes → no circulation”**. It is not evidence that the circulation exists in a real human body.

## 3. Mathematical discovery B: passive symmetric flows do not independently sustain a loop

Suppose all edge fluxes are purely *passive symmetric potential-driven* graph flows, with `W=diag(w_e)>0` and `phi` a potential-like field:

```text
[AGDT-C21] j = -W B phi + c,  with B^T c=0
[AGDT-C22] c^T W^-1 (-W B phi) = -c^T B phi = 0
```

The expression is a weighted graph-flow decomposition. A pure gradient flow (the `-W B phi` part) has **zero independent cycle-space component**. Thus **a ring drawn on paper, by itself, cannot establish a sustained circulating flux**. Such a flux would require some appropriate non-gradient drive, edge-current initial conditions not yet dissipated, directed/active feedback, or measured dynamics violating those purely passive assumptions.

```text
[AGDT-C24] c_(n+1)=rho c_n + a_n, 0≤rho<1.
Without drive a: c_n → 0.
With a constant admissible cycle drive: c* = a/(1-rho).
```

This is conditional theoretical dynamics on a **declared graph**, not a self-powered perpetual-motion claim and not a prescription to cause sensations.

## 4. Mathematical discovery C: the hidden circulation is not identifiable from node readings alone

```text
[AGDT-C23] B^T(j+c) = B^T j, for every c satisfying B^T c=0.
```

No readout of `s_(n+1)-s_n` and known `u_n`, no matter how accurate, can distinguish `j` from `j+c`. More nodal observations will not resolve this mathematical null-space **unless some new observation measures an edge-current-sensitive quantity or separately validated model constraints remove the ambiguity**.

This underdetermination is even larger with real human self-reported sensations, where the relevant physical `s, B, W, j` have not been identified at all.

## 5. Mathematical discovery D: DT-L has no inherent special status just because it sits on a symmetric loop

For a symmetric homogeneous ring with adjacency Laplacian `L`, any rotation/permutation `P` of vertex labels gives `P^T L P=L`. Therefore the same dynamics driven from a rotated point yields the same *shape* of outcomes after re-labeling. **The physics of an unweighted homogeneous ring has no favorite origin.**

```text
[AGDT-C25] f_k[n] = J[n] phi_k^T(e_source[n] - e_return)
[AGDT-C26] P^T L P = L  (homogeneous cyclic ring rotation)
```

Moving the source from DT-L to EX-HN3 in a *specified, fixed* network can change which spectral modes are excited. It **cannot change the eigenvalues** unless the network itself changes, and **cannot establish that EX-HN3 is harmful or DT-L is beneficial** without physiological identification and observations.

## 6. Mathematical discovery E: distinguish an internal reservoir's input and output

```text
[AGDT-C27] J = j(e_input - e_output).
If input == output as the very same unsplit vertex: J = 0.
Nonzero divergence-free internal cycle c is still mathematically possible on a loop.
```

`DT-L INPUT → ENCODE/MEMORY → TRANSFORM → SELECT/OUTPUT` therefore needs typed ports or internal state if used as an information-system architecture. **A zero total injection is not proof that all internal transformation has stopped.** Equally, greater retention/volume of an information store does not establish Toledo Agency. The registered `A.5/S.09.v1` criterion about adapting constraints and persistence must be measured independently, and `CAN-051` information horizon remains only an analogy here.

## 7. What this says and does not say about the actual body

**The model says:** to posit distinguishable circulation we need a typed carrier/readout, independent flows or temporal biomarkers, a driving/feedback term when sustained flow is claimed, and independent Agency measurements. It rules out multiple *invalid inferences* from an authored topology.

**The model does NOT say:** a fluid or energy physically flows through acupuncture pathways, pressing EX-HN3 redistributes energy to DT-L, physical “Sky→GV20” or “Earth→KI1” flux is measured, PC8 emits detectable Qi, DT-L dominates human brain–body integration, or intentional cyclic sensations improve health. All such biological and clinical claims stay `HOLD/NOT_TESTED`.

**Chinese textual concordance:** 《素問·六微旨大論》 explicitly discusses `升降`, `出入`, `往復`, `遲速`, and `變化` in its historical cosmology ([Chinese Text Project](https://ctext.org/huangdi-neijing/liu-wei-zhi-da-lun)); our *information-transformation* and *regulation* interpretation is modern and source-indexed, not identical to the classical authors' ontology. The ten-edge practice circuit is a **school-specific, previously curated semantic route**, not a universal primary-text claim.

## 8. Test and progression gate

- **Completed:** exact semantic 457/845 vs 497/959 audits; multiple centrality metrics; verified 10-edge directed cycle; four-node signed incidence witness; cycle-space and gradient-flow equations; forced/relaxing loop-state distinction; recorded 9 `AGDT-C19..C27` proposal IDs.
- **Not tested:** human biological edge flows, source-motion impact on attention outcomes, DT-L vs other attentional targets `Theta_L`, quantified organism Agency `Gamma_v`, new CAN-006 biological weld, clinical intervention efficacy.
- **Next decisive experiment:** preregister observational/intervention conditions for `DT-L, DT-M, DT-U, EX-HN3, nearby abdominal control, neutral`, with real consented records; compare a readout+memory baseline and a cycle-driver augmented model on held-out measured outcomes. If added cycle terms give no independent prediction, reject their incremental explanatory value. No human data invention or full-time-to-native-step substitution.

**Release:** proposal docs only, no amendment to generated canonical `EQ_LIBRARY.md`, no human clinical feature, no merge authorization.
