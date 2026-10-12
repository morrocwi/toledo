# PROP-IMF-MULTI-01 — Four-question event-response specialization of information memory

**2026-10-12. NEW DOMAIN PROPOSAL / Dr + finite_diagnostic on toy system. BIOLOGICAL BRIDGE OPEN.**
Stacked on [Toledo PR #69](https://github.com/morrocwi/toledo/pull/69), whose informational memory proposal itself rests on [Toledo PR #68](https://github.com/morrocwi/toledo/pull/68). The application is [BIRCA PR #20](https://github.com/morrocwi/birca_admin_5.0/pull/20) (stacked on BIRCA PRs #19/#18). This **does NOT add a second mother equation**.

## 1. Speak the universe's native language FIRST

Retained difference RD1–RD9 and RD4 injectivity, AP7 append-only tape, DRL's retention-time reading, and Omega_all lens law (Readout Universe v2); Readout Genesis's F-domain stepper/biological-adapter split; Toledo CAN-003 (F), CAN-006 (required quotient commutation), CAN-007 (future probe relative equivalence), CAN-009 (immutable record), CAN-034 (state sufficiency), CAN-054 (selective retention), CAN-201 (readout != state). EQ-001/B.07 is used only in a typed abstract resource ledger. EQ-001/B.29/B.30 (real biological encoder and event-identified bridge) remain OPEN.

No axiom of RD1–RD9 implies any clinical LPS response, "immune memory timescale", endogenous delayed activation, threshold, cytokine half-life or skin barrier kinetic parameter. These are **posited application laws** competing with simpler alternatives.

## 2. Four information questions and minimal distinguishing readouts

| Q | root-language question | toy test | empirical bridge obligation |
|---|---|---|---|
| Q1 remains active after stated stimulus ends? | Is a retained load-bearing internal difference still accessible at future n when explicit event amplitude u=0? | significant p excess 24h after a strong 0–3h event but not after a weak event | measured time-matched inputs and inflammatory protein profiles; unmeasured causal input must not be called absent |
| Q2 relapse or different rechallenge outcome? | Can a prior retained event and time-delayed access move a later readout without new external input; can a matched site probe reveal otherwise hidden trained vs tolerized history? | strong pulse p(8h)<p(16h) while u=0; after 6 days trained > naive > tolerant at matched site, no site-B false effect | longitudinal priming/washout/rechallenge, unconditioned delayed response, same assay/controls |
| Q3 current assay quiet yet tissue impaired? | Can distinct questions project different retained components with different recovery windows? | dimensionless marker proxy near baseline at 144h but barrier remains reduced | paired cytokine protein + TEWL and barrier functionality; protein proxy is NOT a measured cytokine |
| Q4 actual recovery vs superficial quiet? | Are multiple current readouts stable AND response to an admissible future standardized probe equivalent to matched untouched controls? | operational recovered = quiet proxy AND closure/barrier/resource thresholds AND matched-probe equivalence | longitudinal controlled functional assays and uncertainty; unit/assay-specific thresholds to be estimated not invented |

**Actual biological evidence considered before constructing the conceptual tests, not independent validation:** human monocyte trained immunity versus LPS tolerance PMID 24521784; resolved psoriasis lesion tissue-resident response PMID 29510191; human wound closure by ~day 7 versus functional barrier ~day 11 PMID 9655416; muscle injury IL-6 normalization with continued damage-marker elevation PMID 15870626. These are qualitative motivations only; source readouts use different specimens and modalities and cannot be equated.

## 3. The complete event-memory **domain specialization** — one F, not another root

Let H_n be an ordered typed event tape; rho_n=(tick, dt, amplitude, site, kind) and Accessible(H_n) a site-indexed projection. Each site c has effective train/tolerance signatures and two accessible *temporal traces* (fast, slow). A full retained record is never identified with an accessible signature.

    H_(n+1) = H_n CONCAT rho_n                        [RD4-typed software append]
    m_mu,c(n+1) = exp(-dt/tau_mem)*m_mu,c(n)
                    + [1-exp(-dt/tau_mem)*m_mu,c(n)]
                      *[1-exp(-dt*u/ell)] if kind matches mu at c
                    else exp(-dt/tau_mem)*m_mu,c(n)
    a_fast,c(n+1) = min(1, exp(-dt/tau_fast)*a_fast,c(n) + g*u*dt)
    a_slow,c(n+1) = min(1, exp(-dt/tau_slow)*a_slow,c(n) + g*u*dt)
    L_n = max(0, sum_c(max(0,a_slow,c-a_fast,c)) - theta)   [delayed accessible echo]
    Recall_(c,n) = (1+alpha*m_train,c(n))/(1+beta*m_tol,c(n))
    d_n = k_ext*u_n*Recall_(c,n) + k_echo*L_n
    k_n = k_relax + d_n
    p_eq = p0 + (1-p0)*d_n/k_n
    p_(n+1) = p_eq + (p_n-p_eq)*exp(-k_n*dt)

q_n is a bounded relaxation to q0 plus a p-dependent resolution proposal. The observable "protein proxy" is a separate bounded lowpass projection of p (dimensionless, not ELISA), with its own timescale. Tissue closure C_n and barrier B_n are two distinct dynamical recovery channels with bounded damage and repair; reserve e_n is capacity-limited. Define x=(C+B)/2, repair r, damage D and supply j; reuse Toledo B.07 **exactly for this chosen finite arithmetic**:

    x_(n+1)+e_(n+1) = x_n+e_n+j_n-D_n.

The *endogenous echo* after external u=0 is a posited delayed **internal driver**: it is NOT a proof of stimulation without any physical cause. Neither a self-generated time-delayed second peak nor an oscillatory phenomenon is forced by RD4.

Model default p0=.04, q0=.2, C=B=e=1, marker proxy=.04 is fixed under an unforced blank event. Tape still grows at each time-step, independently of projected stationarity. Full effective memory and fast/slow echoes must reconstruct from a complete time-typed event tape, or the program responds HOLD. No unbounded biological memory capacity is implied.

## 4. Answering Q4 requires a future readout, not just a threshold now

A proposed **operational toy** recovery gate at a stated site c:

    Apparent = abs(marker-proxy - p0)<0.05
    Tissue   = B>=0.92 AND C>=0.95 AND e>=0.85
    Probe    = abs(Peak_p[2h matched standard probe on current state]
                - Peak_p[same probe on untouched reference]) < 0.045
    Full     = Apparent AND Tissue AND Probe

These are explicitly hand-chosen, dimensionless illustrative cutoffs, NOT clinically derived diagnostic thresholds. In living systems an intervention/probe must be approved separately; no application to patients is permitted here. This definition makes "recovered" **question, context, horizon and intervention-relative**, not an absolute recovery theorem.

## 5. Frozen 18-scenario, 20-criterion conceptual benchmark (exploratory, not blind)

The BIRCA companion implementation executes 18 synthetic event histories: sham; weak/medium/strong matched-duration inputs; training/tolerance/neutral primers; six-day matched-site vs different-site probe; naive controls; two-pulse same-site/cross-site; train-then-tolerize vs reverse order; three moderate pulses; alternating primed sites; zero-amplitude non-learning negative control.

On deliberately chosen synthetic parameters and criterion cutoffs:
- Full v11 candidate: **20/20 structural directional criteria**.
- Ablate accessible training/tolerance readout: **15/20**.
- Ablate delayed retained-echo term: **16/20**.
- Ablate both: **11/20**.
- Step-size sensitivity for dt=0.25, 0.5 and 1h: same 20/20 toy criteria in the local software witness.
- A strong pulse u=1 for 0–3h produces p(8h)=0.204, p(16h)=0.322 **with external u=0**; a weak 0–3h pulse returns by 24h. The *internal echoed input* is nonzero in the strong case.
- At 144h p and marker proxy are 0.04 but barrier is approximately 0.902 following a strong pulse (sham=1). Two actual protein vs barrier values were **NOT measured**.
- A matched re-probe at 144–147h gives p(147)≈0.486 trained, 0.361 naive, 0.272 tolerized. A B-site probe after only A-site priming remains ≈naive.
- At 192h a previously trained exposure may be marker-quiet but FAIL the functional probe recovery gate while weak exposure passes.

These numerical results are **design/ability checks, not evidence of biological truth**. The test suite and thresholds were chosen with knowledge of the desired phenomena; 20/20 cannot be described as accuracy, a blinded pass, PubMed replication or world ranking. Original v9 problems, previously external test two-pool underperformance vs simpler first-order, and uncertainty remain recorded in prior PRs.

## 6. Adverse cases to prevent confirmation bias

Falsifiers/negative controls include no-input sham (no spontaneous flare), weak input (no false sustained response), location specificity, same-input trained vs tolerized directions, zero-dose event (no memory creation), reverse event order, two-event injury increased relative to single event, model ablations and time-grid variations.

A **real biological** falsifier would be a preregistered matched-assay 6-day human monocyte priming/washout/rechallenge experiment showing the proposed state does not improve held-out cross-donor prediction over a no-memory model; or multi-time-point protein-plus-barrier outcomes that cannot be fit with a single locked parameter system while preserving its resource balance. The regime required before testing this clinically includes consent/ethics oversight, verified inputs and controls, event and specimen units, instrument response, identifiability, uncertainty and true reserved cohorts. The software cannot certify those conditions.

## 7. Governance

Tier: (a) chosen ontology and declared domain readout maps Dr; (b) deterministic finite arithmetic and negative ablations finite_diagnostic; (c) empirical B.29/B.30 OPEN. Full code in [BIRCA PR #20](https://github.com/morrocwi/birca_admin_5.0/pull/20) and tests. Existing canonical Toledo registration and root equations unchanged; v9 and v10 prior errors remain. CI green means reproducible toy code, NOT a biological derivation or certified medical system.

## 8. Mandatory later correction: STEP-FIRST (PROP-IMF-STEP-01)

**Do not interpret dt_h in this legacy 18-scenario demonstration as ontic time.** The actual foundational information state evolves in discrete retention order n (RD2-4); the observer measures a protocol-dependent laboratory clock separately. [PROP-IMF-STEP-01](PROP-IMF-STEP-01.md) supersedes the temporal interpretation of this proposed domain, without rewriting or deleting the original test data. The associated `information_events_v11.py` outputs are frozen clock-parameterized toy examples only, and **20/20 is not transferred** to the new native-step kernel. Critical open issue: externally observed lab duration does not identify number of retained steps, and step-resolution covariance has NOT been proved. Any application to 3h, 6h, 24h or 6d samples requires a registered observer-clock bridge, not a default .5-hour step.
