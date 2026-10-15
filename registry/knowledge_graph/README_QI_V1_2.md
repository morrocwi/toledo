# Qi-Dantian-Chakra-Fountain Knowledge Graph v1.2 - additive release

**Date 2026-10-15; tier Dr / DRAFT; proposal data, not canonical; no new equation; Toledo canon unchanged; no clinical validation, no human simulation, no efficacy claim.** v1.2 only adds nodes and edges to v1.1. No v1.1 file was edited; the v1.1 node and edge lists are an exact prefix of v1.2 (checked by `test_qi_v1_2.py` in this directory). The v1.1 gates, `simulation=false`, `clinical=false` and the causal DAG (44 nodes / 93 edges) are unchanged.

Read in this order: [v1.1 README](README_QI_V1_1.md) for the unchanged base, then this file. Thai summary: [README_TH_QI_V1_2.md](README_TH_QI_V1_2.md). Hash/count record: [qi_dantian_chakra_full_graph_manifest_v1_2.json](../proposals/qi_dantian_chakra_full_graph_manifest_v1_2.json).

## Decode

```bash
python -m pip install brotli
python registry/knowledge_graph/decode_qi_v1_2.py --output ./qi_unpacked_v1_2
```

Payload: `qi_v1_2.brotli_base64.part01.txt` .. `part09.txt` (4000 base64 characters per part, last part shorter; 33196 total). Brotli SHA256 `f8c01dd1c64b8c0edc3991d42daf45c04a8601712859a88b79f03a3c7b936e1a`, raw JSON SHA256 `baa0fc67dbd8ea872b71099c62220cb7ccad603ea0fc66b56fdb77a87da1279f`. The decoder checks both hashes and every count below.

## Counts before and after

| Category | v1.1 | v1.2 |
|---|---|---|
| Semantic nodes | 497 | 550 (+53) |
| Semantic edges | 959 | 1218 (+259) |
| Causal DAG nodes / edges | 44 / 93 | 44 / 93 (unchanged) |
| WHO classical acupoints (`Acupoint`) | 361 | 361 |
| Extra points (`ExtraAcupoint`) | 1 (EX-HN3) | 48 (+47) |
| Luo-connecting points with WHO code | none stored as luo | 15 classical luo (plus 1 non-coded Xuli node) |

New nodes: ExtraPointRegion 5, ExtraAcupoint 47, GreatLuoSite 1.
New edges by relation: `member_of_extra_point_region` 48, `flows_to` 12, `channel_connection_point` 17, `luo_connecting` 16, `luo_connecting_to_coupled_channel` 13, `member_of_extraordinary_vessel` 55, `confluent_point_of` 8, `crossing_point_of` 90.
28 new edges are `contested: true`; every new edge carries `evidence_class`, `source_ref`, `confidence`, `contested`, `verification`. Verification tallies for new edges: SECONDARY_RELAYED_WHO1991_PRIMARY_UNREADABLE_HTTP403 48, TEXT_READ 203, WEB_CONFIRMED_SECONDARY 8.

## What was added

1. **Extra points.** EX-HN1-15, EX-CA1, EX-B1-9, EX-UE1-11, EX-LE1-12 = 48 (the count follows the WHO 1991 report summary; the WHO Standard Acupuncture Nomenclature 2nd ed. 1993 covers the 361 classical points only). Codes, pinyin and hanzi were transcribed from Wikibooks tables because the WHO 1991 PDF returned HTTP 403; nodes say so in `verification`. EX-HN3 is reused unchanged. Five `REGION:EX-*` grouping nodes and 48 `member_of_extra_point_region` edges. Thai names are omitted (not confident).
2. **Circulation.** 12 `flows_to` edges, LU-LI-ST-SP-HT-SI-BL-KI-PC-TE-GB-LR-LU, from Lingshu ch.16 (Yingqi). Plus 17 `channel_connection_point` edges (point to first point of the next channel) read from the branch descriptions in Lingshu ch.10; where the text names an internal branch only, or where modern teaching uses a different point, the edge is `contested: true` and has a disagreement record.
3. **Luo.** 15 classical luo points (LU7, LI6, ST40, SP4, HT5, SI7, BL58, KI4, PC6, TE5, GB37, LR5, CV15, GV1, SP21) with `luo_connecting` to their own channel and, where Lingshu ch.10 names it, `luo_connecting_to_coupled_channel` (13 edges; PC6 is contested because the text names no target). The Stomach great luo Xuli is node `TCM:XULI` with a weaker evidence class and a disagreement record; it is not counted among the 15.
4. **Extraordinary vessels.** `member_of_extraordinary_vessel` for Chong, Dai, Yin Qiao, Yang Qiao, Yin Wei, Yang Wei from Li Shizhen (Qijing bamai kao) united with Zhenjiu jiayi jing vol.3 readings; eight `confluent_point_of` edges; `crossing_point_of` edges (jiaohui) from Zhenjiu jiayi jing.
5. Version strings are `1.2.0-draft`; `changelog`, `disagreements` and `coverage_limits_v1_2` are top-level keys of the `semantic_graph` object; `validation.v1_2` records the new counts.

## Disagreements recorded (top-level `disagreements`, 19)

- `D-EXTRA-SCOPE` - Which standard defines the extra-point list and how many entries (status OPEN; affects EX-*)
- `D-YINTANG` - Yintang classification (status OPEN; affects EX-HN3)
- `D-EXTRA-NUMBERING` - Code-to-name pairing inside EX-B5..EX-B9, EX-LE3, EX-UE7 (status OPEN; affects EX-B5, EX-B6, EX-B7, EX-B8, EX-B9, EX-LE3, EX-UE7)
- `D-CONN-ST` - ST to SP connecting point (status OPEN; affects ST42, ST45, SP1)
- `D-CONN-SP` - SP to HT connecting point (status OPEN; affects SP21, HT1)
- `D-CONN-SI` - SI to BL connecting point (status OPEN; affects SI18, SI19, BL1)
- `D-CONN-KI` - KI to PC connecting point (status OPEN; affects KI22, PC1)
- `D-CONN-PC` - PC to TE connecting point (status OPEN; affects PC8, PC9, TE1)
- `D-CONN-TE` - TE to GB connecting point (status OPEN; affects TE22, TE23, GB1)
- `D-CONN-GB` - GB to LR connecting point (status OPEN; affects GB41, GB44, LR1)
- `D-CONN-LR` - LR to LU connecting point (status OPEN; affects LR14, LU1)
- `D-LUO-XULI` - Fifteen versus sixteen luo (status OPEN; affects TCM:XULI)
- `D-LUO-PC` - Coupled channel of the Pericardium luo (status OPEN; affects PC6)
- `D-YINQ` - Yin Qiao start point (status OPEN; affects KI2)
- `D-YINW-COUNT` - Yin Wei stated count versus named points (status OPEN; affects CHN:XYINWEI)
- `D-YANGW` - Yang Wei membership (status OPEN; affects ST8, GV15, GV16)
- `D-YANGQ` - Yang Qiao membership and 蹺脈 wording (status OPEN; affects ST3, LI15, LI16, CHN:XYANGQIAO)
- `D-CONFLUENT` - Confluent-point pairing outlier (status OPEN; affects SI3, GB41, BL62, TE5)
- `D-CROSS-CV12` - Zhongwan wording (status OPEN; affects CV12)

Each record lists every claim with its `source_ref` and a `verification` tag. None is silently resolved. The task brief expected GB/T 12346-2021 to have more or renumbered extras; the relayed evidence says the opposite (it deleted them, and GB/T 40997-2021 lists 51), so this is recorded as `D-EXTRA-SCOPE`.

## Coverage limits (stated, not capped silently)

- Extra points: code/pinyin/hanzi transcribed from Wikibooks tables because the WHO 1991 PDF returned HTTP 403; flagged verification=SECONDARY_RELAYED_WHO1991_PRIMARY_UNREADABLE_HTTP403. No Thai names added.
- Crossing points (jiaohui): parsed from Wikisource transcription of Zhenjiu jiayi jing vol.3 (revid 2327541). 90 crossing edges over 66 points. Entries whose wording the parser could not resolve are NOT stored (examples: GV14 三陽, CV7 氣沖 wording, CV1 corrupted, GV28 蹺脈, LU1, LI9) and the transcription omits some chapters. This is a well-attested subset, not the full 交會穴 inventory.
- Extraordinary-vessel membership: union of Li Shizhen (Qijing bamai kao) and Jiayijing readings; Yang Qiao section of the Li transcription missing; Deadman, A Manual of Acupuncture (ISBN 0951054651) was NOT consulted, so the modern-compilation list is absent.
- Channel connection points: the Lingshu ch.10 branches were read; the surface-point assignment is a maker reading flagged contested:true; modern textbook variants are recorded but their text was not consulted.
- Confluent points: confirmed from a secondary page; Zhenjiu dacheng primary not read.

## Gates unchanged

`original_nodes_unchanged`, `original_edges_unchanged`, `WHO_standard_361_count_valid`, `Yintang_extra_distinct`, `no_clinical_effects_asserted`, `no_patient_simulation` keep their v1.1 values. Edge `semantics` fields state that nothing here is measured qi transport. A textual circuit order (`flows_to`) is a record of what a classical text says, not a physiological flow. Do not use any of this for diagnosis or choosing care.

## Status in Toledo

This is Dr/proposal data carried in the `research/tcm-toledo-birca-bridge-20261014` branch next to v1.1. It registers no equation, assigns no CAN code and changes no canonical Toledo object, status or tier. Equation authority stays with the Toledo registry; the v1.1 files are untouched.

## Tests

`python -m pytest -q registry/knowledge_graph/test_qi_v1_2.py` (needs `brotli`; with `CI` set a missing brotli fails instead of skipping).
