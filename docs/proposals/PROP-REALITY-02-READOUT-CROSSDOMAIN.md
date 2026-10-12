# PROP-REALITY-02 — Readout-first cross-domain recovery (2026-10-13)

**Status: NONCANONICAL PROPOSAL, SCIENTIFIC HOLD.** Never call a generic mathematical witness a biological measurement. This extension answers why the frozen observed-event proxy of Toledo F failed GSE22248 (MAE 0.277763 vs zero 0.193630), without changing CAN-003, constructing a new mother law, or fitting the donor-92 holdout again.

## 1. What exactly failed

The v1.1 probe-specific empirical encoder was `A_p = mean_TRAIN(Y_single,p-Y_untreated,p)`, `predicted double-minus-single = A_p*(r2-r1)/(r1-r0)`, where `r0,r1,r2` are F signal readouts after zero/one/two **observed LPS additions**. Its outcome was worse than a zero-contrast forecast. The intervening source biological transitions, expression regulation, donor-specific assay calibration, dose and cell-type mixture were not identified. We cannot assign the failure specifically to F, to clock mapping, to a memory kernel or to the RNA encoder. Nothing about a successful software pipeline changes that claim.

## 2. Extracted EXACT source operators from other Toledo areas

| Origin inside Toledo | Authoritative source/form | What transfers to this problem | What does NOT transfer |
|---|---|---|---|
| Root information state | CAN-003 `S_(n+1)=F(S_n,u_n,c_n,T_n)` | Keep the only mathematical root; n is retained successor, not an hour. | Does NOT specify how many unseen transitions separate laboratory samples. |
| Root admissibility | CAN-006 `q∘F=F#∘q` and `O=O#∘q`; CAN-007 finite-horizon reader equivalence | Need a quotient/readout that preserves predictions under the declared future questions. | Current RNA equality is NOT automatically future-state equality. |
| Method/factorisation | CAN-165: `ker(R) subseteq ker(P)` iff prediction `P` factors through readout `R` | Necessary/sufficient test of whether a present assay readout is adequate for a target future outcome. | A theorem about functions says nothing about which biological reader is physically calibrated. |
| Discrete mathematics | `coq/information-discrete-math/formal/IDM_ReaderDomainFoundation.v` T3/T4b/T7 | Current and challenge readers should be composed; future-equivalence quotient stable under declared actions; adding experiments refines indistinguishability. | Generic proof is not a proof about PBMC. |
| Electric RC circuit / discrete hidden elimination | `coq/readout_universe/evidence/DRL_Hidden_Elimination_Convolution.v`: `h[n+1]=r h[n]+v[n]` and `h[n]=r^n h[0]+SUM_{k<n}r^(n-1-k)v[k]` | A hidden internal variable can retain a finite step-indexed history even though one visible output is quiet. This identity is machine-checked for a declared rational recurrence. | The kernel r and forcing v have not been identified as immune chromatin/transcript dynamics; do not use circuit RC time constants or transplant physical units. |
| Control/system identification | `docs/NS_OBSERVABILITY_TO_EPSC_BRIDGE.md` structural observability before inversion | Test observability/rank and reader symmetry before inverting assay results into latent state; condition-number or radius cert is needed for quantitative inference. | Navier–Stokes Fourier ranks or numerical radii are not biological measurements. |
| Root/epistemic sensor | CAN-205 finite window `z_tilde[n]=SUM a[n,j] z[n-j]` | A multi-readout panel can collect distinct measurements instead of a single endpoint; index sample observations separately from hidden native steps. | Raw sample clock labels must not be reinterpreted as native transitions. |
| Method / experimental action | CAN-170: choose `u*` with rival predictions `delta_hat_i(u*)!=delta_hat_j(u*)` | Rechallenge, washout and orthogonal assays should be selected to discriminate hidden-state hypotheses (after independent registration). | Observed differences cannot establish causality without matching controls and experimental randomization. |
| Bridge admissibility | `docs/READOUT_BRIDGE_CLOSURE.md` S5 ACCEPT/HOLD certificate | Without an independently calibrated, bounded observation map, return HOLD rather than an optimistic score. | Abstract bridge certificate is not automatically a protein measurement or continuum limit. |

**Source distinction:** EQ-001/B.29 and EQ-001/B.30 are OPEN biological-encoder and measured-event links (see `coq/canonical/EQ_001__B_29_v1.v`, `EQ_001__B_30_v1.v`). They must not be confused with `BiologyDomain_living_unit/B.29.v1` (Karlin–Altschul E-value), an entirely different namespace. Their open status is retained.

## 3. Exact readout lens: why one RNA endpoint cannot be inverted into a hidden memory by assumption

Let `R_0(s)` be the presently observed assay and `P_u(s)=R_1(F_u(s))` the future response under declared intervention `u`. For a deterministic predictor `g` using **only** present data to be defined for ALL admissible hidden states, the key admissibility condition is:

```
R_0(s)=R_0(t) => P_u(s)=P_u(t) for all admissible s,t and declared u.
Equivalently ker(R_0) subseteq ker(P_u), or P_u=g_u∘R_0.
```

This is a **CAN-165 factorisation instance**. If even one admissible pair has identical present readout but divergent future response under the same challenge, no universal `g_u(R_0)` can recover the response; returning a single confident state estimate is invalid.

### Exact finite counterexample — [SimulatedData], not a biological model

Use the two-state rational **diagnostic only**:
```
s_n = (visible_n, hidden_n)
hidden_(n+1) = r*hidden_n + d*u_n
visible_(n+1) = a*visible_n + b*hidden_n*u_n + c*u_n
R_0(s) = visible
a=1/2, b=1/2, c=0, r=3/4, d=1   (chosen toy coefficients)
```
For `s_A=(0,0)`, `s_B=(0,1)`, the PRESENT readout is 0 in both. Under no new intervention `u=0`, the next visible readout is still 0 for both; under standardized challenge `u=1`, next visible readout is **0 vs 1/2**. Hence the present reader collapses future-distinguishable states.

In this toy, a two-readout observability matrix conditioned on intervention `u` is:
```
O2(u) = [[1,0],[a,b*u]], det(O2(u))=b*u
rank at u=0: 1; rank at u=1: 2.
```
The computational witness is EXACT rational (no floating point). This illustrates how an intervention plus future measurement can distinguish history without claiming that any PBMC specimen is in these states. It also shows why simply adding more current RNA probes without independent reader diversity does NOT guarantee that the hidden state becomes identifiable.

The `hidden` recurrence yields the exact convolution `h[n]=r^n*h[0]+SUM_{k<n}r^(n-1-k)*d*u[k]`. This is borrowed from DRL's proven **structure**, not inserted as a second universal law or identified as the root F. Indeed, the kernel coefficients, state dimension, challenge access and output assay remain **candidate observer maps**, not deduced biological numbers.



### Stronger diagnostic: the UNCHANGED BIRCA DOMAIN-PROTOTYPE stepper has a readout alias [SimulatedData]

BIRCA `reality_readout_crossdomain_v1.py` now reuses **the unchanged BIRCA domain prototype** `step_native_imf.py` F (no new laws, no coefficient changes), not only the illustrative two-state circuit. Replay a single `Event(1.0,"PBMC","train")` versus a single `Event(1.0,"PBMC","tolerize")`, each from the same BIRCA-prototype initial state. Their `signal_proxy` outputs **after the first event are exactly equal**, because the first exposure updates different retained trace components but the prior trace was initially empty. Append **the identical** `Event(1.0,"PBMC","neutral")` to each history. The next `signal_proxy` values diverge, due to previously acquired `trained` versus `tolerant` trace.

Consequently, even INSIDE the unchanged BIRCA domain-prototype stepper, choosing `q(S)=signal_proxy(S)` alone violates the CAN-006 dynamics-preserving quotient condition on this explicit pair:
```
q(S_train) = q(S_tolerant)
but q(F(S_train,u)) != q(F(S_tolerant,u)).
```
CAN-007 therefore forbids collapsing these two histories for the future challenge question **in the prototype**. The abstract Toledo CAN-003 root only posits F and is not identified with this chosen implementation. This **shows that a present-only signal reader is not a sufficient state for all future-response questions inside this prototype**. It does not establish which factor caused the observed GSE model error. It does **not** establish that actual human PBMC has exactly those traces, that LPS should be coded as the toy `train/tolerize` modes, or that the latent native-step history has been measured. The runnable witness is a **model-internal software simulation**, not biological evidence.

## 4. Concrete next mathematical architecture — without overwriting Toledo F

```
Immutable retained tape  H_n --CAN-003 F--> S_n
                                  |
                                  |  q_Q  (CAN-006/007 future reader quotient)
                                  v
                             R_Q(S_n)  [accessible observation class]
                                  |
                                  |  G_assay,feature  (TRAIN-only + physical calibration)
                                  v
                             Y_RNA / Y_protein / Y_barrier
```

To test whether `R_Q` suffices, register two competing hidden-history states that agree on the currently available readout. Choose `u*` from the assay-feasible interventions that maximize **predeclared** separation in their *future* predicted readouts, subject to validated noise/measurement sensitivity, as a CAN-170 experimental-design candidate:

```
u* in argmax_(u in U_admissible) min_(s!=t in C(R0))
      distance( E[Y_future | s,u], E[Y_future | t,u] )
```

This **new optimization is only a research proposal**, not a canonical Toledo theorem and not evaluated numerically for biology. If forecasts are nonidentifiable, a feasible intervention is missing, or predictive separation is smaller than independently calibrated assay noise, preserve HOLD. This query selection cannot be fitted to already-viewed heldout donor 92 and then retroactively validated on donor 92.

Minimal independent future readout panel: under proper consent and relevant protocols, independent aliquots and multiple predeclared sample points for transcript RNA, IL-6/TNF-alpha **protein**, recorded washout/pulse and re-stimulation; if Q3/Q4 are assessed, a separate barrier-competent epithelial/skin system and TEER/TEWL accordingly. Keep each assay as a different typed question/reader, not as interchangeable dimensions of one flat numeric state.

## 5. Hard gates and result status

- **Exact math structural gate:** The current-only readout has an explicit finite factorisation counterexample in the toy. Its future-reader challenge separates it. This is mathematical software evidence, not experimental evidence.
- **Existing GSE22248 metadata gate:** Four donors, 12 endpoint microarray samples and 24,526 probes. Native transitions and assay encoder cannot be identified from these observation labels alone. At best the existing event-index score is negative for that restricted decoder.
- **Independent biology gate:** Not yet run. Requires predeclared event-resolved measurement, donor/study-disjoint TEST, training-only calibration, accurate assay noise/units, uncertainty over donors and a fair comparison against same-input zero/state-only/memory baselines.
- **Falsification:** If the future-reader representation fails to improve on fair controls on independent data, FAIL that representation; do not retune the test to win. If quotient/equivalence or assay mapping cannot be justified, HOLD. No data-driven native-step count shall be fabricated.
- **Four phenomena:** Q1 persistence, Q2 rechallenge, Q3 low-cytokine-barrier injury, and Q4 durable recovery each need different experimentally validated readers. A cross-domain analogy does not count as passing any of them.

### Source / implementation
- [Toledo registry](https://github.com/morrocwi/toledo/blob/main/registry/CANONICAL_MAP.md)
- [Reader-domain Coq kernel](https://github.com/morrocwi/toledo/blob/main/coq/information-discrete-math/formal/IDM_ReaderDomainFoundation.v)
- [DRL hidden convolution Coq](https://github.com/morrocwi/toledo/blob/main/coq/readout_universe/evidence/DRL_Hidden_Elimination_Convolution.v)
- [NS observability bridge](https://github.com/morrocwi/toledo/blob/main/docs/NS_OBSERVABILITY_TO_EPSC_BRIDGE.md)
- [BIRCA v1.1 negative RNA audit](https://github.com/morrocwi/birca_admin_5.0/blob/research/reality-bridge-v1-2026-10-12/admin/research/data/reality_gse22248_F_event_proxy_negative_20261013.json)
- Companion BIRCA exact-arithmetic code: `admin/research/reality_readout_crossdomain_v1.py` and `tests/test_reality_readout_crossdomain_v1.py`.
