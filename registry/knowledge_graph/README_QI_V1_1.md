# Qi–Dantian–Chakra–Fountain Knowledge Graph v1.1 — Full registry

**Registered 2026-10-14; tier: Dr / DRAFT; no clinical validation, no human simulation.**

Complete lossless graph package **mirrored in both repos**:
- Toledo `research/tcm-toledo-birca-bridge-20261014/registry/knowledge_graph/`
- BIRCA **ADMIN** `research/tcm-knowledge-readout-20261014/registry/knowledge_graph/`
- Reconstruct the *complete* source-extended semantic graph and **separate causal DAG** using `decode_qi_v1_1.py` and payload files `qi_v1_1.brotli_base64.part01.txt` through `part06.txt`.
- Run: `python -m pip install brotli && python registry/knowledge_graph/decode_qi_v1_1.py --output ./qi_unpacked_v1_1`
- The decoder checks Brotli SHA256 `adeff813a36b1525989ae1a26251ce63f37f90c2fbea9b4217753789cd054763` and raw JSON SHA256 `20f3218a85720efb292cd4a36fe63962e86878a452251ba75c41382efe35cd14`; **do not claim authenticity if any checksum fails**.
- The *complete original user ZIP*, all original CSV/GraphML/TTL and its 4.9MB original interactive HTML, plus v1.1 converted formats, are delivered as a separate downloadable user artifact in the conversation. This Git payload contains the entire v1.1 semantic graph, DAG and validation ledger losslessly, **not** the bundled Plotly HTML or the original generator's source code.

## Completeness matrix

| Asset or concept | Included in **Git payload** | Meaning / claim tier |
| --- | --- | --- |
| Original 457 nodes, original 845 edges | **Yes, exact preserved arrays** | WHO ontology, historical TCM and cross-tradition approximations |
| All 361 WHO standard point identifiers with pinyin/hanzi (from supplied atlas) | **Yes, retained** | Names only; point reference ≠ medical benefit |
| 14 WHO channels + 6 other extraordinary vessel concept nodes | **Yes** | Extra six are under their own namespace; incomplete routes remain explicitly so |
| DT-L/DT-M/DT-U and 7 Chakra nodes | **Yes** | Approximate body-level crosswalk, **not same organism or anatomy** |
| EX-HN3 Yintang | **Yes, EXTRA** | Must not increment standard 361 to 362 |
| WHO-related site/organ metadata from source | **Yes, preserved unchanged** | Zang-fu category ≠ modern anatomical organ |
| Symbolic SKY ↔ GV20 | **Yes** | Founder-declared heaven connection, not universal verified classical source |
| Symbolic EARTH → KI1 sole intake | **Yes, left and right SITE instances** | User-declared symbolic receiving channel, not proved Earth flux |
| Symbolic palm PC8 → external output | **Yes, left and right SITE instances** | User-declared symbolic outgoing role, not measured energy emission |
| Chinese posterior GV ascent and anterior CV descent | **Yes, source-attributed practice variant** | A practice-specific circuit, not a causal proof or physical tunnel |
| Indian Sushumna / Chakra ascending axis | **Yes, distinct type** | Different genealogy; do not collapse into Ren/Du |
| Brow → chest → abdomen → DT-L optional attentional sequence | **Yes** | Gentle attention-order ontology, not forced Qi transport |
| Information transformation QiHua interpretation | **Yes, conceptual reference + CAN-003** | Dr only; not spatial velocity or numerical Qi value |
| Mobile fountain source + DT-L reservoir analogy | **Yes, source location choices/steps** | **Fluid equations are an analogy** |
| Flow equations RUS-0108/0109/0164 | **Yes, equation-register links** | Bernoulli / continuity / Poiseuille are physical laws under their assumptions |
| Synchronization mismatch / persistence hypothesis | **Yes, graph concept** | Uncalibrated Dr; stiffness/viscosity does not always destabilize |
| Ten retrospective condition labels + 39 point mentions | **Yes** | Previously manually chosen; no predictive 10/10 score |
| Causal DAG, unrolled by observation steps | **Yes, 44 nodes, 93 edges** | The DAG is a separate hypothesis, **not** the closed orbit |
| Provenance/evidence tags | **Yes, carried edge by edge** | Historical/symbolic ≠ biological/clinical |

**Validated counts:** semantic graph **497 nodes / 959 edges**; old 457/845 unchanged; +40/+114; 361 standard + 1 extra; causal DAG **44 nodes / 93 edges**. The original 36/82 causal DAG structure is preserved as a strict subgraph.

**Interpretive anchor (fixed):** Qi (氣) in the user's *information cosmos* is **information transformation, not movement**. `氣` and `氣化` have distinct source-text meanings; mathematical fluid flow is **one modeling analogy** for propagation/lag, not evidence of physical fluid Qi.

## Source authority and falsifiability

1. [Toledo CAN-003 and registered equations](https://github.com/morrocwi/toledo/blob/main/registry/EQ_LIBRARY.md) — `S[n+1]=F(S[n],u[n],c[n],T[n])`; `RUS-0108` Bernoulli, `RUS-0109` continuity, `RUS-0164` Poiseuille. These are domain-specific laws or registered equations, **not biomedical validation** of Qi.
2. [Toledo Qihua 10-case proposal](https://github.com/morrocwi/toledo/blob/research/tcm-toledo-birca-bridge-20261014/docs/proposals/PROP-TCM-QIHUA-10CASE-01.md) — distinctions, status gates and 10 cases.
3. [Toledo movable fountain/attention companion](https://github.com/morrocwi/toledo/blob/research/tcm-toledo-birca-bridge-20261014/docs/proposals/PROP-TCM-ATTENTION-01.md) — EX-HN3/DT-L practice readout.
4. [BIRCA Admin research counterpart](https://github.com/morrocwi/birca_admin_5.0/blob/research/tcm-knowledge-readout-20261014/docs/TCM_QIHUA_10_CONDITION_READOUT_AUDIT_V1.md).
5. [WHO point naming](https://iris.who.int/handle/10665/353407); [comparative history of nāḍī and channels](https://www.kci.go.kr/kciportal/ci/sereArticleSearch/ciSereArtiView.kci?sereArticleSearchBean.artiId=ART003320764); [practitioner-specific Ren/Du orbit](https://mrneigong.com/the-microcosmic-orbit/).

BIRCA Admin's **clinical empirical evidence gate remains official PubMed only**. Classical primary-text and area/symbol interpretations are separately tracked and **never promoted** to biomedical causation. No patient diagnosis, no treatment instructions, no new drug, no forced-breath/Kundalini self-stimulation. `CAN-006`, `CAN-165`, B.29/B.30 biological weld remain **HOLD/OPEN**.

## Graph claim typing

Each edge must be read with its `relation`, `evidence_class`, `source_ref` and `semantics`. **A loop in the semantic KG does not authorize a loop in the causal DAG**. Left/right surface instance IDs (`SITE:PC8-L` etc.) are not new acupoint codes. For overlapping matches and ambiguous schools, keep the record `HOLD`; never average doctrine into a physical flow field.

**No merge into `main` or runtime activation is authorized by this documentation upload.**
