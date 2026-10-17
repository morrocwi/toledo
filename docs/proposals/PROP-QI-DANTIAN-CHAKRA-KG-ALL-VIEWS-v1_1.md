# PROP-QI-DANTIAN-CHAKRA-KG-ALL-VIEWS v1.1 — China × India × Toledo full graph registry

**Date:** 2026-10-14. **Status:** NONCANONICAL DRAFT; formal ontology + typed comparison only; no clinical validation.  
**Origin:** user-supplied `qi_dantian_kg_v1(1).zip`, ZIP SHA256 `c8f8df398ae49c1b27de4348366e49629d310fbab59681aee034f1521533e39e`.  
**Full enriched local graph SHA256:** `ce0badaa9e99c0ad5f839570a06d8b7ac0773c6e3c56ce4a3469dc6152cbfbf2`, UTF-8 JSON 394,895 bytes.  
**Committed graph TOPOLOGY:** [479 nodes, 894 typed edges + 48/109 step-unrolled DAG](assets/qi_dantian_chakra_full_topology_v1_1.lzma.b64). It is LZMA(base64) JSON containing `{n:[[node_id,type],...],e:[[source,target,relation],...],c:{n:causal_nodes,e:causal_edges}}`. **Topology is complete; rich source attributes/Pinyin/Hanzi/source CSVs remain in the separately delivered complete ZIP, not this compressed Git topology blob.** No incorrect claim of committing the full 1.6 MB HTML or GraphML.

## What was registered, and what was preserved

The input ZIP had 14 files: full 457-node / 845-edge knowledge graph, standard 361-point Pinyin/Hanzi names, 14 classical channel groups + 6 additional extraordinary vessels, 3 Dantian regions, 7 Chakra labels, 1 extra point `EX-HN3`, original 36/82 causal DAG, GraphML, TTL, CSV, offline HTML visualization, scripts, validation, and Thai README.

The extended local **fully attributed** graph preserves the original 457 node dicts and 845 edge dicts in original order and appends **22 concept/site/role nodes** and **49 typed edges** → **479 nodes / 894 edges**. Its causal-DAG model preserves the original 36 nodes and 82 directed edges and adds **12 nodes and 27 hypothesis edges** → **48 nodes / 109 edges**; acyclicity was checked in NetworkX. Original standard-point cardinality is unchanged: **361/361 standard, plus EX-HN3 in the extra-point namespace**. The extended **semantic** graph contains traditional orbits, so it is **cyclic by design**. Never label its full directed graph as a causal DAG.

### All eight registered graph views

| Graph view | Registered payload | Exact scope |
| --- | --- | --- |
| `full_semantic_graph` | all 479/894 | 361 point IDs, traditional meridian/organ + anatomy distinctions, extra point, 3 Dantian, 7 Chakra, new symbolic roles |
| `causal_step_unrolled_dag` | 48/109 | context, attention, respiration, posture, interoception, 3 Dantian readouts, observation, source-locus, transformation and mismatch, stepped n=0..3, **hypothetical edges** |
| `chinese_small_heavenly_orbit` | ordered **cycle** | `DT-L→CV1→GV1→GV4→GV14→GV20→CV22→CV17→CV12→CV6→DT-L` — a **user-provided simplified training schematic**, not a cited anatomical route |
| `indian_seven_chakra_axis` | ordered **chain** | `CH-01→CH-02→CH-03→CH-04→CH-05→CH-06→CH-07`, conceptual Sushumna axis, not identical to Ren/Du |
| `cross_tradition_seven_levels` | approximate matches | 7 chakra levels aligned with approximate body-region point references, NEVER identities or measured conduction |
| `flow_analogy` | movable source loci | `DT-L` lower reservoir plus source-locus choices `DT-L, DT-M, DT-U, EX-HN3, GV20, CV17, CV12, KI1, PC8` |
| `cosmic_symbolic_roles` | 3 named classes | GV20 crown links **SKY**; **EARTH→KI1** sole is 'receive from earth'; PC8 palm **→OUTWARD** is 'send outward'; bilateral sole/palm site nodes added without duplicating point numbers |
| `attention_sequence` | typed attentional route | `EX-HN3→CV17→CV12→DT-L` as an observation/attention program, no forced Qi/biological transport |

### Explicit founder-required crown/feet/palms bridge

```text
GV20 百會 (crown) ──traditional_symbolic_connects──> HEAVEN_LINK ──> SKY
EARTH ──symbolic_source_earth──> EARTH_RECEIVE ──symbolic_receives_from_earth──> KI1 湧泉
KI1 ──bilateral_surface_instance──> LEFT_SOLE, RIGHT_SOLE
PC8 勞宮 ──symbolic_output_role──> PALM_SEND ──symbolic_sends_outward──> OUTWARD
PC8 ──bilateral_surface_instance──> LEFT_PALM, RIGHT_PALM
```

**Do not infer electricity, Earth energy, atmospheric absorption, projected energy emission, blood/nerve pathways or measurable Qi currents.** This is the **founder's practice-symbolic interpretation**, and it is explicitly marked as such, not a verified classical citation or a treatment effect.

### China–India correspondence — seven tiers are *approximate*, not exact

| Chakra | Chinese vicinity | Dantian context |
| --- | --- | --- |
| CH-01 Muladhara | CV1 / GV1 | lower base; DT-L is *not* necessarily identical |
| CH-02 Svadhisthana | CV2–CV4 | DT-L vicinity |
| CH-03 Manipura | CV8 / CV12 | abdominal region, interpretation-dependent |
| CH-04 Anahata | CV17 | DT-M |
| CH-05 Vishuddha | CV22 / CV23 | throat |
| CH-06 Ajna | EX-HN3 Yintang | DT-U in some lineages |
| CH-07 Sahasrara | GV20 Baihui | DT-U in some lineages |

Dantian `DT-L/M/U` are **regions/reading centers**, not points or chakra equivalence classes. Canonical WHO `CV4`, `CV5`, `CV6` remain separate. `EX-HN3` is not among the 361 standard point codes.

## Formula reuse — no new Toledo mother equation

1. **CAN-003**: `S[n+1]=F(S[n],u[n],c[n],T[n])`; observation-step sequence does not fix seconds/minutes/hours.
2. **CAN-201**: body/attention/TCM record is a partial readout of the world/state, not a physical Qi quantity.
3. **CAN-023**: retained experience/memory affects future reading; source-recitation does not prove physiological causation.
4. **RUS-0108**: Bernoulli (fluid-energy balance) **physical-fluid analogy ONLY**.
5. **RUS-0109**: 1D steady incompressible continuity `A1 v1 = A2 v2` **physical-fluid analogy ONLY**.
6. **RUS-0164**: Hagen–Poiseuille `Q = πr⁴ΔP/(8μL)` within its laminar/tube hypotheses, **physical-fluid analogy ONLY**.
7. **External EQ-QI-01/02/03/04/07**: conceptual 361-point Laplacian, telegraph-inspired graph dynamics, retention/blockage proxies and energy-like graph quantity **remain proposal/unmeasured**.
8. **CAN-006, CAN-165 and EQ-001/B.29–B.30:** biomedical readout sufficiency and domain weld **OPEN/HOLD**.
9. **QiHua:** `氣化` is rendered as *information transformation*, explicitly not physical movement and not an asserted historical universal equivalence of `氣`.
10. **Movable fountain:** source location is an **independent controllable graph label**. Changing it may change graph-mode excitation. It need **not** change native eigenfrequencies or force literal flow into the glabella; viscous loss does **not** automatically produce a phase mismatch.

Fluid source-on-location conditional toy equation `H-Δz_ℓ=a_ℓ Q_ℓ + b_ℓ Q_ℓ²` is **proposed** from flow/head-loss modelling; `a,b≥0` plus valid boundary conditions required. Pressure-head/water-flow numerical values are **not Qi units**. The physically meaningful fluid system must be separately measured. There are no synthetic/personal biological records in these graphs.

## Registration, decoding and repeatability

To recover complete **node IDs/types, edge endpoints/types and the causal DAG** from either Git repo topology asset:

```python
import base64, lzma, json, pathlib
p = pathlib.Path("assets/qi_dantian_chakra_full_topology_v1_1.lzma.b64")
d = json.loads(lzma.decompress(base64.b64decode(p.read_text())))
assert len(d["n"]) == 479 and len(d["e"]) == 894
assert len(d["c"]["n"]) == 48 and len(d["c"]["e"]) == 109
```

**Source completeness limit:** Git topology includes ALL IDs/type and typed directed edges, but the *rich per-node and per-edge metadata, other serialized graph variants (GraphML/TTL/CSV), exact source ZIP and offline HTML* are in the accompanying complete downloadable ZIP delivered in conversation, not in Git. Register their SHA256 in the artifact-manifest; avoid implying that a compressed topology substitutes for an atlas/citation audit.

**Evidence ceiling:** `SYMBOLIC_TCM_YOGA_CROSSWALK`, `Dr`, `NO_HUMAN_DATA`, `BIOPHYSICAL_TRANSFER_UNPROVEN`, `PERSONAL_PREDICTION_NOT_IN_SCOPE`.

**Companion repository:** `morrocwi/birca_admin_5.0`, [BIRCA Admin complete-graph registry](https://github.com/morrocwi/birca_admin_5.0/blob/research/tcm-knowledge-readout-20261014/docs/TCM_QI_DANTIAN_CHAKRA_ALL_GRAPHS_v1_1.md) and [BIRCA Admin Draft PR #22](https://github.com/morrocwi/birca_admin_5.0/pull/22). **Do not upload into `morrocwi/birca`.**

See also: [earlier Qi–TCM ontology](PROP-TCM-BIRCA-01.md), [transformation-first 10-case audit](PROP-TCM-QIHUA-10CASE-01.md), [brow→lower-Dantian](PROP-TCM-ATTENTION-01.md).
