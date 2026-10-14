# PROP-TCM-QIHUA-10CASE-01 — Information transformation, ten-condition TCM mapping audit

**Date:** 2026-10-14  
**Repo:** morrocwi/toledo; **noncanonical research proposal / explanatory comparison**  
**Scope:** Chinese-medicine source/ontology compatibility only; **no numerical prediction, patient simulation, individual diagnosis, efficacy or clinical treatment claim**.  
**Downstream:** `morrocwi/birca_admin_5.0` [BIRCA Admin 5.0 TCM QiHua research handoff](https://github.com/morrocwi/birca_admin_5.0/blob/research/tcm-knowledge-readout-20261014/docs/TCM_QIHUA_10_CONDITION_READOUT_AUDIT_V1.md).

## 0. Decision and key correction

**FOUNDER CORRECTION:** In this information-first framework **Qi (氣) is understood through information TRANSFORMATION, not the spatial movement of an energy/substance.** Ascending, descending, entering, exiting, etc. are *possible historical descriptions of outcomes* or ways of speaking about transformation; these motion metaphors are **not** the universal definition of Qi.

This is a **proposed modern interpretation (Dr)**, not a philological assertion that every occurrence of 氣 in historical Chinese has this meaning. In particular `氣` and `氣化` (Qi transformation) must retain distinct original-language terms. Historical authors sometimes use 氣 for vapor, weather, activity, material constitution, and other senses; information theory must not retroactively overwrite them.

### Textual anchor: historical, not lab mechanism

- 《黃帝內經·素問·六微旨大論》: `夫物之生從於化，物之極由乎變` (life/formation associated with transformation and change). Read in original: https://ctext.org/huangdi-neijing/liu-wei-zhi-da-lun
- 《黃帝內經·素問·靈蘭秘典論》: `膀胱者，州都之官，津液藏焉，氣化則能出矣` (fluid-storage/expulsion in traditional functional language; not a claim of measured information-state physiology). https://ctext.org/huangdi-neijing/ling-lan-mi-dian-lun
- 《黃帝內經·素問·舉痛論》: `怒則氣上`, `思則氣結`; direction and knotting are **source-language categories**, not detected modern transport physics. https://ctext.org/huangdi-neijing/ju-tong-lun
- WHO standard names: 361 classical point names, 14 standard channel-code families; `EX-HN3` is a separate extra-point namespace. https://www.who.int/publications/i/item/9290611057

**Source-status discipline:** the primary excerpts above anchor *the kind of interpretation*. They do **not** individually attest to all point–disease links in the 10-case comparison below. Those individual bibliographic alignments require a separate classical/TCM textbook and PubMed-only article audit.

## 1. Toledo reuse first (NO new canonical root)

| Toledo register | Exact equation/guard | Role here |
| --- | --- | --- |
| CAN-003 / `EQ-015/M.02.v1` | `S[n+1]=F(S[n],u[n],c[n],T[n])` | retained informational step transition |
| CAN-006 / `weld/M.02.v1` | `q_D ◦ F = F_D ◦ q_D` | cross-domain dynamic commutation is **HOLD**, never assumed |
| CAN-007 | future-observation equivalence | disease-specific prediction not tested |
| CAN-165 | readout/future functional sufficiency condition | not demonstrated |
| CAN-201 | `Readout(S) != S` | conceptual Qi terms and biological observations differ from root state |
| `EQ-001/B.29.v1` / `EQ-001/B.30.v1` | real biological encoder/domain weld targets | remain **OPEN/HOLD** |

### Proposed, noncanonical QiHua interpretation

```text
Qihua_readout[n,question,source_context] :=
  Interpret_TCM( Transform_description(S[n] -> S[n+1] | memory H[n], context c[n]) )

Transformation_description is NOT a uniquely identified physical Qi quantity.
A printed medical pattern and a point-code label cannot recover S[n] or identify F.
No unit, magnitude, step->clock or causal clinical coefficient is supplied.
```

`Qihua_readout` is a *declared interpretation operator*, not an algebraically independent dynamical discovery: if `Transform_description` simply copies `F`, the definition is **tautological** and has zero predictive value until independently tested.

### The *proposed* separate adaptation question

$
A_n^{\mathrm{proposal}}(V,\mathcal U)
= \mathbb E_{u\sim\mathcal U}
\left[V(F(S_n,u,c_n))-V(S_n)\right].
$

`V` (real, prespecified evaluative functional), input distribution `U`, domain and readout must be externally defined **before** evaluation. `A_n` is **not Qi**, not a diagnosis and is **UNCOMPUTED**. It may be useful as a falsifiable question only after independent measurements and an admissible root-to-assay bridge.

## 2. Prior 10-condition retrospective correspondence register

The following mapping is transcribed from the 2026-10-14 discussion to preserve **what was proposed**, not to certify authoritative TCM clinical patterns, WHO anatomical locations or disease/point efficacy. Disease `D`, pattern `Z`, point set `P`, and information analogy `T` are **distinct types**. A biomedical diagnosis does not uniquely imply one Zang-Fu pattern, and the point list is not a therapeutic prescription.

Proposed information analogies, **not exact classical equivalents**:
- T1 constrained context-appropriate transformation ↔ 氣滯 (partial metaphor)
- T2 out-of-context or excessive response ↔ 氣逆 / 火 (partial metaphor)
- T3 diminished functional capacity ↔ 氣虛 (partial metaphor)
- T4 cross-system context-dependent incoherence ↔ 不和 (partial metaphor)
- T5 retained/slow-to-reorganize response ↔ 痰 / 瘀 (partial metaphor, **not** definition)

| Case | Biomedical topic | Information analogy | Candidate TCM pattern(s) | Points appearing in prior discussion | Verification |
| --- | --- | --- | --- | --- | --- |
| 01 | Migraine (ไมเกรน) | T2 | 肝陽上亢; 風; 氣滯 (pattern-dependent) | GB20; GB8; LR3; LI4 | RETROSPECTIVE_CANDIDATE; individual text/PMID verification pending |
| 02 | Insomnia (นอนไม่หลับ) | T4 | 心神不寧; 心腎不交 | HT7; SP6; GV20; PC6 | RETROSPECTIVE_CANDIDATE; individual text/PMID verification pending |
| 03 | Depression (ภาวะซึมเศร้า) | T1/T3 | 肝氣鬱結; 心脾兩虛 (pattern-dependent) | LR3; PC6; HT7; GV20 | RETROSPECTIVE_CANDIDATE; individual text/PMID verification pending |
| 04 | Nausea/vomiting (คลื่นไส้อาเจียน) | T2 | 胃氣上逆 | PC6; ST36; CV12 | RETROSPECTIVE_CANDIDATE; individual text/PMID verification pending |
| 05 | Constipation (ท้องผูก) | T1 | 氣滯; 腸燥; 氣虛 | ST25; ST37; ST36; TE6 | RETROSPECTIVE_CANDIDATE; individual text/PMID verification pending |
| 06 | Irritable bowel syndrome (ลำไส้แปรปรวน) | T4 | 肝脾不和 | ST25; ST36; CV12; SP6 | RETROSPECTIVE_CANDIDATE; individual text/PMID verification pending |
| 07 | Knee osteoarthritis (ข้อเข่าเสื่อม) | T5 | 痹證; 氣血瘀滯 (pattern-dependent) | ST35; GB34; SP9; ST36 | RETROSPECTIVE_CANDIDATE; individual text/PMID verification pending |
| 08 | Low back pain (ปวดหลังส่วนล่าง) | T3/T5 | 腎虛; 氣血瘀滯 (pattern-dependent) | BL23; BL25; BL40; GV3 | RETROSPECTIVE_CANDIDATE; individual text/PMID verification pending |
| 09 | Allergic rhinitis (ภูมิแพ้จมูก) | T2/T3 | 肺氣虛; 風寒; 風熱 | LI20; EX-HN3; LI4; ST36 | RETROSPECTIVE_CANDIDATE; individual text/PMID verification pending |
| 10 | Dysmenorrhea (ปวดประจำเดือน) | T1/T5 | 氣滯血瘀; 寒凝血瘀; 氣血虛 | SP6; BL32; SP8; CV4 | RETROSPECTIVE_CANDIDATE; individual text/PMID verification pending |

`EX-HN3` is an **EXTRA point**, not part of WHO's 361 classical points. The lists retain it separately. No point anatomical coordinates, doses, needling depths or pressure-force instructions are admitted.

## 3. Interpretation of the earlier "10/10" result

Two prior **retrospective** facts were reported: (a) 10/10 selected conditions could be manually *described* with at least one of five very broad T1–T5 labels and (b) a source-like point list could be *associated* with each after choosing the conditions.

**These scores are NOT model successes.** The labels and candidate points were assigned **with knowledge of the disease and TCM context**. The comparison was not blinded, did not pre-register labels, did not verify all ten individual texts against primary Chinese editions, did not run ten independent PubMed source-level study audits, and did not compute a quantitative native state. Treat `10/10` only as a **descriptive retrospective mapping count**; the actual independently validated disease classifier performance is `null`.

| Test | Conclusion |
| --- | --- |
| Retrospective categorisability of selected diseases | 10/10 **manual analogies only**; not specificity or accuracy |
| Retrospective availability of proposed point lists | 10/10 **from prior discussion**; per-condition source verification pending |
| Predict points using information framework *without prior knowledge of TCM texts* | **NOT TESTED** |
| Distinguish two competing TCM pattern diagnoses blindly | **NOT TESTED** |
| Predict a biological intervention response in humans | **HOLD / NOT TESTED** |
| Qi is necessarily informational transformation in the historical/biophysical sense | **OPEN / INTERPRETATION ONLY** |
| Reproduce the human condition or assign personal acupoints | **NOT AUTHORIZED** |

**Circularity guard:** loading the ten point lists into the graph and then getting them back from the same graph proves a lookup, not prediction. Over-broad T1–T5 categories can always fit after the fact unless novel decoy conditions and held-out classical evidence are used.

## 4. Rigorous falsification proposal, no simulation

1. Pre-register a frozen, source-attributed disease/pattern/point corpus: Chinese classical edition+locator for history, WHO only for codes, official PubMed PMID records only for biomedical experimental claims.
2. Create **previously unseen** conditions/pattern cases without looking at their assigned points; use independent TCM scholars to review translation and interpretive fidelity. Labels/point sets must be frozen *before* the answer key opens.
3. Compare a transformation-first crosswalk with strong controls: source-keyword lookup, semantic similarity, plain TCM taxonomy (without the new QiHua relation), disease-label-to-point frequency baseline, and a null/abstain strategy.
4. Score **out of sample** by precision/recall/top-k of exact source-attested point labels, pattern disambiguation, calibration/coverage of HOLD decisions, and inter-rater agreement. Report all excluded or ambiguous cases.
5. If testing real biological outcomes, require article-published or legally obtained real matched participants, interventions, comparators and measured data through the authorized evidence pathway. **Do not create synthetic patient data or interpolate from clinical case titles.**
6. Reject added explanatory/predictive value if the new transformation layer does not outperform the controls under the same information budget. If the evidence does not independently identify the latent state or native-step assay decoder, **HOLD**.

## 5. Phenomenology and counterexamples

A person can report "pressure or swirling near the brow" without any measured Qi moving; changes in attention or body sensation are a subjective `report` readout, not a localized blockage. A resting system can be well-adapted with few state changes; excessive cycling can indicate poor adaptation rather than "more Qi." Two observers may describe the same symptoms with different traditional patterns. Such counterexamples exclude a simplistic equation `Qi = spatial velocity` and also exclude `more transformation = healthier`.

## 6. Dependency and claim gates

```text
CAN-003 information step (existing)
       |
       +-- noncanonical qihua/TCM interpretation (Dr)
       |      |
       |      +-- 10 retrospectives (DESCRIPTION ONLY)
       |      +-- standard point IDs + EX-HN3 extra (NOMENCLATURE)
       |
       +-- CAN-006 external biomedical weld --> OPEN/HOLD
       +-- CAN-165 clinical sufficiency      --> OPEN/HOLD

No clinical interventions. No personalized predictions. No physical Qi transport inference.
```

**Documentation only. NOT merged into Toledo canonical registry, and not a formal proof.**

## References (scope-limited)

- Original Chinese: [Suwen, Liù Wēi Zhǐ Dà Lùn](https://ctext.org/huangdi-neijing/liu-wei-zhi-da-lun); [Líng Lán Mì Diǎn Lùn](https://ctext.org/huangdi-neijing/ling-lan-mi-dian-lun); [Jǔ Tòng Lùn](https://ctext.org/huangdi-neijing/ju-tong-lun).
- Terminology/point codes only: [WHO 361 classical point names](https://www.who.int/publications/i/item/9290611057).
- [Toledo registry](../../registry/EQ_LIBRARY.md) / [Toledo source policy](../../EQUATION_SOURCE_POLICY.md).
- [Older noncanonical Qi point specification](../external_references/TCM_Qi_Acupoint_Information_Equation_v1.0.md).
- [BIRCA Admin companion handoff](https://github.com/morrocwi/birca_admin_5.0/blob/research/tcm-knowledge-readout-20261014/docs/TCM_QIHUA_10_CONDITION_READOUT_AUDIT_V1.md).
