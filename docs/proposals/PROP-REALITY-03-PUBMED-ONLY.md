# PROP-REALITY-03 — PubMed-only measured human biochemical readouts (2026-10-13)

**Status:** Live PubMed primary-publication evidence passed provenance checks; **Toledo native biology = HOLD**. This is a noncanonical PROPOSAL, not a biological law or an executable biological reader.

**Founder evidence constraint (2026-10-13):** NO simulation. PubMed ONLY. No GEO, PMC scraping, fabricated assay numbers, assumed hours-to-native-step conversion, fitted surrogate F, or synthetic proof cases are admitted as biological evidence.

## Real-world source and software readout

Active provenance comes solely from the PubMed bibliographic database via official Entrez EFetch `db=pubmed`; links resolve to `pubmed.ncbi.nlm.nih.gov/<PMID>`. BIRCA's [PubMed-only audited extraction script](https://github.com/morrocwi/birca_admin_5.0/blob/research/reality-bridge-v1-2026-10-12/admin/research/reality_pubmed_only_v1.py) verified **7 real PubMed article records** in [successful action 38305842396](https://github.com/morrocwi/birca_admin_5.0/actions/runs/38305842396), source-response XML SHA256 `14db828f8a7011bfdeb465a1cc92068e05fcc8215eac7a11648b7f83a1b5829d`.

Source records are pinned to identity, title, PubMed abstract SHA256, and literal numeric context. A change in article wording or a missing source is a **HOLD**, never a synthetic replacement. Public [evidence artifact](https://github.com/morrocwi/birca_admin_5.0/actions/runs/38305842396/artifacts/11773041247).

## Published REAL measurements (not simulated)

| PMID | Population and actual experimental measurement | Exact author-reported summary in PubMed |
|---|---|---|
| [19242351](https://pubmed.ncbi.nlm.nih.gov/19242351/) | 14 healthy men, daily LPS for five days, circulating cytokine responses | TNF response reduced 97% ±3%; IL-6 response reduced 88% ±8% on day 5 |
| [21494102](https://pubmed.ncbi.nlm.nih.gov/21494102/) | 16 healthy men; separate ex-vivo serial observation vs repeat in-vivo LPS challenge | Second-challenge in-vivo plasma peak TNF reduced 46%; IL-6 reduced 36%. Ex-vivo tolerance resolves earlier than in-vivo tolerance |
| [7687636](https://pubmed.ncbi.nlm.nih.gov/7687636/) | CD14+ human cells isolated six hours after systemic endotoxin; then stimulated | Compared to pre-injection cells, TNF synthesis 47% less, IL-6 56% less |
| [20730374](https://pubmed.ncbi.nlm.nih.gov/20730374/) | Healthy human monocytes, LPS conditioning and separate antimicrobial functional assays | Intracellular IL-6 reduction of 40% under published conditioning; phagocytosis and ROS production preserved or increased |
| [20974955](https://pubmed.ncbi.nlm.nih.gov/20974955/) | Human primary monocytes; IFN-gamma, chromatin remodeling and cytokine responses | Published qualitative chromatin/RNA/cytokine mechanism; **NO numeric effect size extracted from abstract** |
| [1284277](https://pubmed.ncbi.nlm.nih.gov/1284277/) | Cancer patients receiving repeated LPS, in-vivo serum vs ex-vivo PBMC response | Published evidence that systemic and ex-vivo cytokine readouts can move in different directions; **NO numeric effect size extracted** |
| [37805492](https://pubmed.ncbi.nlm.nih.gov/37805492/) | Primary human monocytes from six healthy donors, ATAC-seq/RNA-seq | Chromatin accessibility and transcription are independently measured dimensions; **NO readout-encoder coefficients extracted** |

**Non-collapse:** None of these percent changes is a single standardized response variable across all seven papers. Human cohorts, specimen preparation, LPS challenge sequence, assay units and measurement context differ. `97%` attenuation from 5-day plasma cytokine observation cannot be used as the `47%` reduction in ex-vivo CD14+ cell synthesis. Clock times are just protocol labels, not native informational steps.

## Readout lens — mathematical gate without biological simulation

Existing Toledo **CAN-006/007/165** supplies a **conditional admission rule**: a claimed future target `P_u` can be a function of present readout `R` only if `ker R \subseteq ker P_u` over the explicitly declared domain. None of these seven abstracts directly tests the kernel relation at donor level; therefore **DO NOT claim that it is empirically proved**.

**CAN-201/205** explains why a plural reader family is methodologically required to be investigated: TNF plasma, IL-6 intracellular protein, stimulus-induced ex-vivo cytokines, chromatin accessibility, RNA and phagocytic capacity are **different readers**. The published in-vivo/ex-vivo discrepancy is a serious cross-context check against conflating them.

**CAN-003:** `S[n+1]=F(S[n],u[n],c[n],T[n])` is retained unchanged. The abstract root F is not identified with any reported human LPS mechanism by these papers. The number of laboratory LPS injections or hours does **not** identify the full native sequence of informational transitions.

**No model fitting / prediction:** No joint participant-wise measurements or assay-specific native `q`, `G_assay` calibration are recovered through PubMed abstracts, so do not compute an MAE, coefficient matrix, cytokine value, or apparent pass rate. EQ-001/B.29/B.30 remain OPEN/HOLD.

## Four question status

- **Q1 (persistence):** Published source evidence includes distinct ex-vivo and in-vivo durations but does not supply a fitted native transition rate. `REAL_PUBLISHED_DESCRIPTIVE_EVIDENCE / NATIVE_MODEL_HOLD`.
- **Q2 (rechallenge / tolerance):** Human cytokine attenuation after repeat LPS is supported as study-specific descriptive evidence. `REAL_PUBLISHED_DESCRIPTIVE_EVIDENCE / NATIVE_MODEL_HOLD`.
- **Q3 (tissue barrier):** These selected PubMed studies do **NOT** publish a paired epithelial TEER/TEWL barrier and cytokine protocol for Toledo. `HOLD_INSUFFICIENT_PUBMED_EVIDENCE_FOR_THIS_QUERY`.
- **Q4 (durable tissue repair):** No admitted matched serial wound/TEER/TEWL reconstruction in this source set. `HOLD_INSUFFICIENT_PUBMED_EVIDENCE_FOR_THIS_QUERY`.

## Hard source policy (effective now)

The old Readout Recovery proposal `PROP-REALITY-02` remains accessible as historical methodology, **LEGACY and excluded** from this PubMed-only claim. Its synthetic cases and GEO-processed numeric outcomes are not admissible even if runnable. The active BIRCA workflow is *PubMed-only* and no longer executes the legacy synthetic/GEO lanes; no previous generated/simulated object is silently relabelled as real data.

**Evidence status:** `PUBMED_ONLY_REAL_EVIDENCE_VERIFIED_BIOLOGICAL_WELD_HOLD`. This means the literature evidence checks pass; it does **not** mean Toledo F biological prediction passed. A future independent quantitative test must obtain genuinely measured, article-published sufficient datasets from PubMed itself or HOLD if unavailable.
