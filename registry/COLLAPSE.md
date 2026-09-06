# Collapse of the Master River — root spine and domain readings

Source: `registry/CANONICAL.json` (253 canonical ids, deduplicated from 946 raw equations
across 40 chapters; `registry/eq_<record_id>.json` per chapter). Notation reference:
`v1_4/main.tex` (Master River v1.4, eq. 1–79 + glossary). Chapter dates:
`textbook-written-by-ai-still-true/manifest.yaml`. Root reference:
`~/ANSE.ASIA/readout_genesis/READOUT_GENESIS_CORE.md`.

This is a **mapping**, not an edit: no source file, no CANONICAL.json entry, and no raw
`eq_<record_id>.json` record is changed by this document. Every canonical id keeps the
tier CANONICAL.json already assigned it; nothing here upgrades a tier. Per BBL-176
(readout-not-truth), the classification below is itself a reading of the registry, tiered
by its own evidence, not asserted as the one true grouping — see §4 for the tier ledger
on the classification act itself.

## 0. The one-line weld this whole line reads

> δ_R = (a ♯ b) ⊢[Th_coqc] L_R = D_W − W ⊢[Dr] F (MQ.08 stepper) ≡
> { q_D : q_D ∘ F = F♯_D ∘ q_D }

"Stating the master equation and admitting a domain are the same act." Every one of the
253 canonical ids below is either a piece of this weld (the 9-element spine, §1) or a
reading of a piece of it through some domain's q_D (§2–§3).

## 1. Root spine (`spine_ids`)

Nine CAN ids, all `domain: "root"` in CANONICAL.json, in the order the line is read
(world → retained state → readout → weld/retention → stepper → domain admission →
quotient → non-collapse guard → semantic ordering → historical closure, then back to the
next world-state):

| order | CAN id | key | statement | tier (as CANONICAL.json states it) |
|---|---|---|---|---|
| 1 | **CAN-002** | root-state-tuple | $S_n=(G_n,\Lambda_n,T_n)$ — relational carrier, retained typed distinctions, append-only tape | definition |
| 2 | **CAN-201** | root-readout-gate | $\mathrm{Readout}_{Q,O,c}(S)=z,\ z\neq S$ — a bounded, reader-conditioned map that never returns the source unchanged | definition |
| 3 | **CAN-001** | root-weld | $\delta_R=(a\sharp b)\vdash_{Th_{coqc}} L_R=D_W-W \vdash_{Dr} F$ (MQ.08 stepper), corroborated by the discrete telegraph form and the Impermanence Theorem | Th_coqc (δ_R⊢L_R) / Dr (F) / theorem-in-source (MQ.08, Th-5) |
| 4 | **CAN-003** | root-stepper | $S_{n+1}=F(S_n,u_n,c_n,T_n)$ — the finite Genesis stepper, quoted verbatim as the rail for every domain paper | Dr |
| 5 | **CAN-006** | domain-weld | $q_{D,n+1}\circ F_n = F^{\#}_{D,n}\circ q_{D,n}$; $O_{D,n}=O^{\#}_{D,n}\circ q_{D,n}$ — the admissibility condition a translation must satisfy to count as a domain at all | definition (admissibility condition) |
| 6 | **CAN-007** | reader-equivalence | $z\sim_{Q,O,c,L}z' \iff O(F^kz)=O(F^kz')\ \forall k\le L$ — no-early-collapse: states merge only when no future readout within the declared horizon could tell them apart | definition |
| 7 | **CAN-008** | constitutional-noncollapse | $S_n\neq Z_{D,n}\neq D_{D,n}$ — the root state, a candidate domain representation, and a discovered quotient are three different things | definition |
| 8 | **CAN-004** | constitutional-ordering | Retention → Structure → Translation → Readout → Meaning → Experience → Memory → Belief → Claim → Checking → Status → Public report; forbidden order: naming first, backfilling knowledge status after | law (constitutional ordering rule) |
| 9 | **CAN-009** | historical-invariance | $\Delta A_{\mathrm{past}}=0$ — the historical occurrence is not rewritten by later reinterpretation; only bindings among trace/meaning/experience/memory change | law (invariant) |

Two further `domain: "root"` ids are **not** in the spine because they are themselves
readings of a spine element by the root paper's own semantic layer, not additional root
objects:

- **CAN-005** (readout-admission-order) reads **CAN-004** — it is the same
  Retention→…→Report progression restated as the compressed/extended admission chains for
  the semantic/human register. CANONICAL.json's own note says so verbatim: "Directly
  instances Genesis's Part I.2 Root-to-Trunk Progression … applied to the semantic/human
  domain."
- **CAN-222** (root-non-collapse-chain) reads **CAN-008** — it is Genesis's own bundled
  family of $X\neq Y$ non-collapse pairs over its typed epistemic vocabulary (belief,
  authority, power, status…), i.e. the constitutional non-collapse discipline applied
  inside one chapter's own vocabulary, not a tenth root object. (CANONICAL.json flags this
  entry itself as a dedup-fix, dissolved out of an earlier over-merge — see §4.)

`spine_ids = ["CAN-002","CAN-201","CAN-001","CAN-003","CAN-006","CAN-007","CAN-008","CAN-004","CAN-009"]`

## 2. The three declared sub-chains (BBL-172, human–AI river + social + world-system)

The Master River v1.4 human–AI chain (eq. 44/65/66/79 in `v1_4/main.tex`) is one
$q_{\mathrm{HAI}}$ reading of the spine above, not a second equation:

- **eq.(44)** — $x_t\to r_t\to \mu_t\to E_t\to H_{t+1}\to\cdots\to H_{t+2}\to Q_{t+2}\to \mathrm{AI}\to K_{\mathrm{like}}\to\cdots\to H_{\mathrm{return}}$ — reads **CAN-004** (the same Retention→…→Report admission order, now walked with Genesis/Experience/MEMK/Human-LoRA/Fusion/CTSA as the domain-specific names for each stage) and **CAN-003** (each named transition is a $q_{\mathrm{HAI}}$ instance of $S_{n+1}=F(S_n,u_n,c_n,T_n)$: CAN-045, CAN-047, CAN-050, CAN-055 are the specific readings).
- **eq.(65)** — the appended tail $H_{\mathrm{return}}\to a_s\to\delta^{\mathrm{world}}\to H_{t+3}$ — continues the same reading, not a new arrow inside eq.(44).
- **eq.(66)** — the outer world-system loop $(H_t\to H_{t+3})\to \mathrm{Readout}_{Q,O,c}\to C^H_{t+3}\to P^H_{t+3}\to(H_{t+3}\to H_{t+6})$ — reads **CAN-201** (an explicit $\mathrm{Readout}_{Q,O,c}$ call, same operator as the root) and **CAN-006** (CAN-150's political-economy-to-human bridge is exactly this readout's domain weld).
- **eq.(79)** — RG-HCA's placement $H_{t+3}\to Z_{\mathrm{HCA},t+3}\to(C^H_{t+3}\to P^H_{t+3})$ — reads **CAN-006** again (CAN-105's opportunity-conversion weld) without adding an arrow inside eq.(44)–(65) or reweighting eq.(66), exactly as `v1_4/main.tex` §"The Corrected Master Equation River" states.

The **social** reading (CAN-115 B-SOC-LRSTEPPER) reads **CAN-001** directly and by the
same symbol: $L_R=D_W-W$ is not a social-domain analogue of the Genesis Laplacian, it is
the identical object, independently corroborated in a second chapter (per CAN-001's own
occurrence list, which already names both `21529456`/`19640361`; B-SOC-LRSTEPPER is a
third independent statement of the same forced Laplacian). CAN-117 (regime translation
operator $T_R$) reads **CAN-003**: $M(t'+\Delta t')=T_R(M(t'))$ is a $q_{\mathrm{social}}$
instance of $S_{n+1}=F(S_n,u_n,c_n,T_n)$.

The **world-system** reading has no bare Laplacian/weld object of its own (see the blank
cell in §3) — it enters through **CAN-006** (CAN-150's bridge
$c^{(PE\to H)}_{i,t}=B^{(PE\to H)}(Z_t;i,g)$, a textbook domain-weld instance) and
**CAN-004** (CAN-151's Human Systemic Position index, an ordered audit stage) rather than
through CAN-001/CAN-003 directly.

## 3. Root term × domain reading (table)

See `reading_table.tex` (LaTeX longtable, 9 rows × 4 columns: Epistemic / Social /
Human–AI / World-system). A blank cell means the registry currently holds no CAN id in
that domain that reads the row's spine term as a *separate* object — see the "Blank
cells" drift note in §5. Method-domain ids (69) are not given a fifth column because they
are overwhelmingly a cross-cutting provenance/credit discipline over CAN-008/CAN-009
rather than a domain reading of the world/social/human-AI kind (see §3.1).

### 3.1 Full non-spine mapping (244 CAN ids → spine element, with evidence tier)

Three evidence tiers, disclosed per BBL-176 rather than hidden:

- **graph-evidenced** (67 ids) — CANONICAL.json's own `relations` field already links this
  id, directly or by a short chain, to a spine id. Strongest tier: this is the registry's
  own recorded relation, not an interpretation added here.
- **manual (verified textual match)** (4 ids: CAN-005, CAN-115, CAN-117, CAN-150) — the
  canonical_text is symbol-identical or near-identical to a spine element's own text
  (checked by hand, cited above in §1–§2).
- **textual/keyword** (129 ids) — the id's own key/object/canonical_text contains a term
  (non-collapse, weld, readout, retention, record/provenance, stepper/chain, ordering,
  state/tuple, equivalence) that names which spine element it is elaborating. A first-pass
  reading, not independently re-derived.
- **domain-default (weakest)** (44 ids) — no relation, no matching keyword; placed on the
  spine element that domain most often reads (epistemic→CAN-201, human–AI→CAN-003,
  social→CAN-001, world-system→CAN-002, method→CAN-009). Flagged individually in §5 as the
  weakest-confidence placements — candidates for a human or future-pass re-check, not
  claims of a demonstrated reading.

<details>
<summary>Root domain, non-spine (2 ids)</summary>

| CAN id | key | reads | evidence |
|---|---|---|---|
| CAN-005 | readout-admission-order | CAN-004 (constitutional ordering) | manual (verified textual match) |
| CAN-222 | root-non-collapse-chain | CAN-008 (non-collapse S≠Z_D≠D_D) — corrected below, see note | graph-evidenced |

Note: §1 above states CAN-222 reads CAN-008 by direct textual content (a non-collapse
family). The BFS graph-evidence pass (§4 method) independently placed it at CAN-007
(reader-equivalence) via a 3-hop relation chain through CAN-031; both are defensible
(quotient-non-merging and non-collapse are the same discipline stated two ways), and this
is recorded as a drift note in §5 rather than silently picking one.

</details>

<details>
<summary>Epistemic domain (49 ids)</summary>

| CAN id | key | reads | evidence |
|---|---|---|---|
| CAN-010 | human-readout-instance | CAN-201 (readout R) | graph-evidenced |
| CAN-011 | source-provenance-readout | CAN-201 (readout R) | graph-evidenced |
| CAN-012 | observer-pipeline | CAN-201 (readout R) | graph-evidenced |
| CAN-013 | meaning-giving | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-014 | meaning-distortion | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-015 | meaning | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-016 | meaning-modes | CAN-201 (readout R) | domain-default (weakest) |
| CAN-017 | experience-equation | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-019 | naming-operator | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-020 | naming-loop | CAN-201 (readout R) | domain-default (weakest) |
| CAN-021 | resonance | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-022 | accumulation-barrier | CAN-003 (stepper F) | textual/keyword |
| CAN-023 | retention-update | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-024 | history-accessibility | CAN-201 (readout R) | domain-default (weakest) |
| CAN-025 | knowledge-stability | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-026 | fallibilism-axiom | CAN-201 (readout R) | domain-default (weakest) |
| CAN-027 | alignment-readout | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-028 | generative-abundance-law | CAN-003 (stepper F) | textual/keyword |
| CAN-029 | knower-constitution | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-030 | context-indexed-evaluation | CAN-002 (root state S_n) | textual/keyword |
| CAN-031 | knowledge-admission | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-032 | practical-effectiveness | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-033 | tier-ledger | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-034 | state-sufficiency | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-035 | claim-ceiling | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-036 | knowledge-transport | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-037 | memk-record-noncollapse | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-039 | B-EPI-CANDSET | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-040 | B-EPI-KEPI | CAN-201 (readout R) | domain-default (weakest) |
| CAN-202 | mission-stepper-reading | CAN-003 (stepper F) | graph-evidenced |
| CAN-203 | access-exposure-function | CAN-201 (readout R) | graph-evidenced |
| CAN-204 | encoder-pipeline | CAN-201 (readout R) | graph-evidenced |
| CAN-205 | windowed-sensor-readout | CAN-001 (weld δ_R⊢L_R⊢F) | graph-evidenced |
| CAN-206 | domain-taxonomy-Dn | CAN-201 (readout R) | textual/keyword |
| CAN-207 | semantic-quotient-reading | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-208 | provenance-governing-maxim | CAN-009 (historical invariance ΔA_past=0) | textual/keyword |
| CAN-209 | provenance-distinction-and-path | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-217 | residual-provenance-effect | CAN-009 (historical invariance ΔA_past=0) | textual/keyword |
| CAN-218 | bridge-burden-principle | CAN-006 (domain weld q_D) | textual/keyword |
| CAN-219 | no-bare-pedigree-principle | CAN-002 (root state S_n) | textual/keyword |
| CAN-220 | provenance-relevance-constraint | CAN-009 (historical invariance ΔA_past=0) | textual/keyword |
| CAN-221 | friction-not-magic-principle | CAN-201 (readout R) | domain-default (weakest) |
| CAN-223 | role-separation-principle | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-224 | representationality-selectivity-noncollapse | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-225 | affective-semantic-non-collapse-bundle | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-226 | meaning-giving-non-collapse-bundle | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-227 | human-lora-adaptation-non-collapse | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-228 | hypothesis-space-non-collapse-bundle | CAN-003 (stepper F) | graph-evidenced |
| CAN-229 | discovery-topology-non-collapse-bundle | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |

</details>

<details>
<summary>Human–AI domain (74 ids)</summary>

| CAN id | key | reads | evidence |
|---|---|---|---|
| CAN-041 | pre-prompt-human-state-transport | CAN-002 (root state S_n) | textual/keyword |
| CAN-042 | pre-prompt-transport | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-043 | entry-state-anchor | CAN-002 (root state S_n) | textual/keyword |
| CAN-044 | DCP-topic-entry | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-045 | B-HAI-PREPROMPT | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-046 | ai-response-chain | CAN-003 (stepper F) | textual/keyword |
| CAN-047 | human-AI-session-stepper | CAN-003 (stepper F) | manual (verified textual match) |
| CAN-048 | agency-conditional-chain | CAN-201 (readout R) | textual/keyword |
| CAN-049 | agency-quotient | CAN-201 (readout R) | textual/keyword |
| CAN-050 | self-readout | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-051 | horizon-triad | CAN-006 (domain weld q_D) | textual/keyword |
| CAN-052 | release-dynamics | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-053 | meta-readout-governance | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-054 | selective-retention-mechanism | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-055 | human-domain-state-graph | CAN-001 (weld δ_R⊢L_R⊢F) | graph-evidenced |
| CAN-056 | B-HAI-SYNERGY | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-057 | live-possibility | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-058 | live-set-weight | CAN-003 (stepper F) | domain-default (weakest) |
| CAN-059 | choice-noncollapse-chain | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-060 | corrigible-agency-witnessed | CAN-004 (constitutional ordering) | textual/keyword |
| CAN-061 | live-possibility-dynamics | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-062 | K_like-noncollapse | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-063 | K_like-statemachine | CAN-002 (root state S_n) | textual/keyword |
| CAN-064 | human-ai-transport | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-065 | domain-weld-defect | CAN-006 (domain weld q_D) | textual/keyword |
| CAN-066 | session-retention-gate | CAN-001 (weld δ_R⊢L_R⊢F) | textual/keyword |
| CAN-067 | gain-tunnel-functions | CAN-003 (stepper F) | domain-default (weakest) |
| CAN-068 | epistemic-fusion-architecture-sequence | CAN-004 (constitutional ordering) | textual/keyword |
| CAN-069 | fusion-non-collapse-bundle | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword (corrected; see §5) |
| CAN-070 | equivalence-class-diagnostic | CAN-007 (reader-equivalence) | textual/keyword |
| CAN-071 | resistance-quality-accessibility | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-072 | calibration-audit | CAN-003 (stepper F) | domain-default (weakest) |
| CAN-073 | ctsa-bridge | CAN-006 (domain weld q_D) | textual/keyword |
| CAN-074 | assisted-vs-return-noncollapse | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword (corrected; see §5) |
| CAN-075 | exposure-retention-improvement-noncollapse | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-076 | human-return-CTSA6 | CAN-002 (root state S_n) | textual/keyword |
| CAN-077 | human-return-CTSA4 | CAN-002 (root state S_n) | textual/keyword |
| CAN-078 | D-R-A-constitutive | CAN-003 (stepper F) | domain-default (weakest) |
| CAN-079 | outcome-vector-J* | CAN-002 (root state S_n) | textual/keyword (corrected; see §5) |
| CAN-080 | ctsa-non-collapse-bundle | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-081 | ctsa-hypotheses | CAN-003 (stepper F) | domain-default (weakest) |
| CAN-082 | DCP-deployment-triage | CAN-002 (root state S_n) | textual/keyword |
| CAN-083 | DCP-protocol-stages | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-084 | DCP-verify-stage | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-085 | DCP-integrate-stage | CAN-009 (historical invariance ΔA_past=0) | textual/keyword |
| CAN-086 | DCP-remove-stage | CAN-003 (stepper F) | textual/keyword |
| CAN-087 | DCP-return-conversion-vector | CAN-002 (root state S_n) | textual/keyword |
| CAN-088 | DCP-return-action-feedback | CAN-003 (stepper F) | domain-default (weakest) |
| CAN-089 | DCP-expand-contract | CAN-009 (historical invariance ΔA_past=0) | textual/keyword |
| CAN-090 | DCP-open-propositions | CAN-003 (stepper F) | domain-default (weakest) |
| CAN-091 | DCP-hypotheses | CAN-003 (stepper F) | domain-default (weakest) |
| CAN-092 | DCP-closing-questions | CAN-003 (stepper F) | domain-default (weakest) |
| CAN-093 | event-translation-core | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-094 | self-context-agency | CAN-001 (weld δ_R⊢L_R⊢F) | textual/keyword |
| CAN-095 | grounding-embodiment | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-096 | interaction-efficiency | CAN-003 (stepper F) | domain-default (weakest) |
| CAN-097 | ai-mediation-hypotheses | CAN-003 (stepper F) | domain-default (weakest) |
| CAN-098 | HCA-native-river | CAN-201 (readout R) | textual/keyword |
| CAN-099 | HCA-candidate-state | CAN-002 (root state S_n) | textual/keyword |
| CAN-100 | life-capital-context | CAN-002 (root state S_n) | textual/keyword |
| CAN-101 | capability-conversion-noncollapse | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-102 | barrier-readout | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-103 | candidate-vs-endorsed-routes | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-104 | scaffold-fading | CAN-003 (stepper F) | domain-default (weakest) |
| CAN-105 | opportunity-conversion | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-106 | net-advancement-record | CAN-009 (historical invariance ΔA_past=0) | textual/keyword |
| CAN-107 | HCA-worked-scenario | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-108 | HCA-governance-bundle | CAN-003 (stepper F) | domain-default (weakest) |
| CAN-109 | before-meaning-hypotheses | CAN-003 (stepper F) | domain-default (weakest) |
| CAN-110 | rival-model-ladder-prechoice | CAN-007 (reader-equivalence) | textual/keyword |
| CAN-111 | human-ai-attribution | CAN-201 (readout R) | textual/keyword |
| CAN-112 | decisive-record-argmax | CAN-009 (historical invariance ΔA_past=0) | textual/keyword |
| CAN-113 | CTSA-taxonomy | CAN-001 (weld δ_R⊢L_R⊢F) | textual/keyword |
| CAN-114 | dialogue-open-predictions | CAN-003 (stepper F) | domain-default (weakest) |

</details>

<details>
<summary>Social domain (25 ids)</summary>

| CAN id | key | reads | evidence |
|---|---|---|---|
| CAN-115 | B-SOC-LRSTEPPER | CAN-001 (weld δ_R⊢L_R⊢F) | manual (verified textual match) |
| CAN-116 | B-SOC-ETHAXIOM | CAN-006 (domain weld q_D) | textual/keyword |
| CAN-117 | B-SOC-REGIME | CAN-003 (stepper F) | manual (verified textual match) |
| CAN-118 | B-SOC-ETHLOAD | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-119 | B-SOC-COLCONF | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-120 | B-SOC-MORALCOST | CAN-006 (domain weld q_D) | textual/keyword |
| CAN-121 | B-SOC-AGENCYHIER | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-122 | belief-relation | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-123 | collective-readout | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-124 | power-live-gap | CAN-001 (weld δ_R⊢L_R⊢F) | domain-default (weakest) |
| CAN-125 | DCP-relational-route | CAN-001 (weld δ_R⊢L_R⊢F) | domain-default (weakest) |
| CAN-126 | OLW-falsifier | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-127 | OLW-propositions | CAN-001 (weld δ_R⊢L_R⊢F) | domain-default (weakest) |
| CAN-128 | B-SOC-LIVEPOSS | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword (corrected; see §5) |
| CAN-129 | B-SOC-NCLIST | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-130 | B-SOC-MEANPROP | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-131 | B-SOC-LIVEHYP | CAN-001 (weld δ_R⊢L_R⊢F) | domain-default (weakest) |
| CAN-132 | B-SOC-POTENTIAL | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-133 | B-SOC-RECOVENV | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-134 | B-SOC-RECOVLIVE | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-135 | B-SOC-CORRIG | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-136 | B-SOC-PSEUDOPEACE | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-137 | B-SOC-SEVENDIST | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-138 | B-SOC-FALSIF | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-139 | B-SOC-IDCERT | CAN-009 (historical invariance ΔA_past=0) | textual/keyword |

</details>

<details>
<summary>World-system domain (25 ids)</summary>

| CAN id | key | reads | evidence |
|---|---|---|---|
| CAN-140 | labour-claim-chain | CAN-003 (stepper F) | textual/keyword |
| CAN-141 | epistemic-firewall-validation | CAN-002 (root state S_n) | domain-default (weakest) |
| CAN-142 | machine-capacity-block | CAN-002 (root state S_n) | domain-default (weakest) |
| CAN-143 | labour-centrality | CAN-002 (root state S_n) | domain-default (weakest) |
| CAN-144 | claim-constitution | CAN-002 (root state S_n) | domain-default (weakest) |
| CAN-145 | demand-realization | CAN-002 (root state S_n) | domain-default (weakest) |
| CAN-146 | ownership-accumulation | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-147 | scarce-asset-rent | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-148 | conversion-gates | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-149 | relational-class-position | CAN-002 (root state S_n) | textual/keyword |
| CAN-150 | pe-to-human-bridge | CAN-006 (domain weld q_D) | manual (verified textual match) |
| CAN-151 | human-systemic-position | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-152 | social-role-standing | CAN-002 (root state S_n) | domain-default (weakest) |
| CAN-153 | social-reproduction | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-154 | power-channels | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-155 | early-warning-diagnostic | CAN-002 (root state S_n) | domain-default (weakest) |
| CAN-156 | after-labour-river-summary | CAN-006 (domain weld q_D) | textual/keyword |
| CAN-157 | corrigible-agency-worldsystem | CAN-002 (root state S_n) | domain-default (weakest) |
| CAN-158 | human-return-worldsystem | CAN-002 (root state S_n) | textual/keyword |
| CAN-159 | human-conversion-vector | CAN-002 (root state S_n) | textual/keyword |
| CAN-160 | conversion-noncollapse-bundle | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword (corrected; see §5) |
| CAN-161 | epistemic-conversion-mechanism | CAN-002 (root state S_n) | domain-default (weakest) |
| CAN-162 | bad-mode-state | CAN-002 (root state S_n) | textual/keyword |
| CAN-163 | reversibility-window-urgency | CAN-002 (root state S_n) | textual/keyword |
| CAN-164 | distributional-conversion | CAN-201 (readout R) | textual/keyword |

</details>

<details>
<summary>Method domain (69 ids) — cross-cutting provenance/credit discipline</summary>

| CAN id | key | reads | evidence |
|---|---|---|---|
| CAN-165 | readout-factorization-admissibility | CAN-201 (readout R) | graph-evidenced |
| CAN-166 | rival-model-ladder-experience | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-167 | problem-formation | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-168 | discovery-accessibility | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-169 | discovery-first-passage | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-170 | discriminating-action-loop | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-171 | provenance-ledger | CAN-009 (historical invariance ΔA_past=0) | textual/keyword |
| CAN-172 | DCP-status-categories | CAN-009 (historical invariance ΔA_past=0) | textual/keyword |
| CAN-173 | credit-provenance-goodhart | CAN-009 (historical invariance ΔA_past=0) | textual/keyword |
| CAN-174 | tier-ledger-invariant | CAN-007 (reader-equivalence) | graph-evidenced |
| CAN-175 | k2-procurement | CAN-009 (historical invariance ΔA_past=0) | domain-default (weakest) |
| CAN-177 | theorizing-pipeline | CAN-006 (domain weld q_D) | textual/keyword |
| CAN-178 | scholarly-capital-bookkeeping | CAN-009 (historical invariance ΔA_past=0) | textual/keyword |
| CAN-179 | knowledge-state-ladder | CAN-007 (reader-equivalence) | textual/keyword |
| CAN-180 | epistemic-isolation-constraint | CAN-009 (historical invariance ΔA_past=0) | domain-default (weakest) |
| CAN-181 | bottleneck-inversion | CAN-009 (historical invariance ΔA_past=0) | domain-default (weakest) |
| CAN-182 | dvp-protocol | CAN-003 (stepper F) | textual/keyword |
| CAN-183 | programme-legibility | CAN-201 (readout R) | textual/keyword |
| CAN-184 | recognition-conversion | CAN-009 (historical invariance ΔA_past=0) | domain-default (weakest) |
| CAN-185 | credit-velocity-governance | CAN-001 (weld δ_R⊢L_R⊢F) | textual/keyword |
| CAN-186 | concept-cluster-compounding | CAN-009 (historical invariance ΔA_past=0) | textual/keyword |
| CAN-187 | reactor-criticality-analogy | CAN-009 (historical invariance ΔA_past=0) | domain-default (weakest) |
| CAN-188 | legitimacy-circulation-loop | CAN-003 (stepper F) | textual/keyword |
| CAN-189 | residual-model | CAN-009 (historical invariance ΔA_past=0) | domain-default (weakest) |
| CAN-190 | geographic-coverage | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-191 | integrity-firewall | CAN-009 (historical invariance ΔA_past=0) | textual/keyword |
| CAN-192 | human-mastery-gate | CAN-009 (historical invariance ΔA_past=0) | domain-default (weakest) |
| CAN-193 | standalone-scholar-architecture | CAN-004 (constitutional ordering) | textual/keyword |
| CAN-194 | feasibility-budget | CAN-009 (historical invariance ΔA_past=0) | domain-default (weakest) |
| CAN-195 | discovery-justification-separation | CAN-009 (historical invariance ΔA_past=0) | domain-default (weakest) |
| CAN-196 | evidence-registry-noncollapse | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-197 | knowledge-topology-firstpassage | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-198 | rhythm-momentum-accessibility | CAN-003 (stepper F) | textual/keyword |
| CAN-199 | mind-body-coupling | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-200 | DCP-burden-vector | CAN-003 (stepper F) | textual/keyword |
| CAN-210 | identification-ladder | CAN-006 (domain weld q_D) | textual/keyword |
| CAN-211 | typed-augmentation-grammar | CAN-004 (constitutional ordering) | graph-evidenced |
| CAN-212 | ead-provenance-norms | CAN-009 (historical invariance ΔA_past=0) | textual/keyword |
| CAN-213 | epistemic-overreach-and-silent-lift | CAN-009 (historical invariance ΔA_past=0) | textual/keyword |
| CAN-214 | essential-dependency-defeater-routing | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-215 | worked-audit-diagnostic-test | CAN-009 (historical invariance ΔA_past=0) | domain-default (weakest) |
| CAN-216 | retained-record-contamination-route | CAN-001 (weld δ_R⊢L_R⊢F) | textual/keyword |
| CAN-230 | credit-not-epistemic-value | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-231 | friction-not-fellowship | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-232 | self-experience-not-general-evidence | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-233 | positional-access-not-population-authority | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-234 | community-trust-not-representativeness | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-235 | dvp-not-k2 | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-236 | many-models-not-independence | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-237 | mechanical-not-semantic-validity | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-238 | source-existence-not-claim-support | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-239 | friendship-not-independent-evidence | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-240 | correspondence-not-peer-review | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-241 | intellectual-affinity-not-truth | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-242 | activation-action-not-credit-event | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-243 | rawspeed-not-vc | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-244 | lh-lv-not-truth | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-245 | mission-stepper-not-theta | CAN-003 (stepper F) | graph-evidenced |
| CAN-246 | multiai-consensus-not-geographic-completeness | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-247 | doubleblind-bonus-not-requirement | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-248 | k2global-not-k2thai | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-249 | interventioncreator-not-soleevaluator | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-250 | practiceexperience-not-populationevidence | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-251 | at-not-ctscholarly | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-252 | mattention-not-mtruth-mk2 | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-253 | nohuman-not-researchstop | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-254 | prestige-not-apc-approval | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-255 | disclosurepenalty-not-concealment | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |
| CAN-256 | aicontribution-not-epistemicresponsibility | CAN-008 (non-collapse S≠Z_D≠D_D) | textual/keyword |

Method-domain summary: 26 of 69 read CAN-009 (historical invariance / decisive record —
these are the provenance-ledger, credit, and citation-integrity constructs, which are all
disciplines for auditing a record without rewriting it), 26 read CAN-008 (non-collapse —
the "X ≠ Y" credit/evidence guard-pairs CAN-230–256 dominate this count), 8 read CAN-007
(reader-equivalence — the identification-ladder/first-passage/problem-formation cluster,
which is about when a downstream distinction may be credited to an upstream readout without
merging states that should stay separate), 5 read CAN-003, 3 read CAN-004, 2 read CAN-006,
0 read CAN-001, CAN-002, CAN-201. This is why method is not given its own reading-table
column: it does not read the spine as a fourth *domain* the way epistemic/social/human–AI/
world-system read it as agents-in-a-world; it reads the spine as an audit layer over
whichever domain produced the claim.

</details>

## 4. What collapsed into what

Counting only CAN ids (already deduplicated once from 946 raw equations to 253 canonical
ids by the prior collapse pass that produced CANONICAL.json — see its own `raw_to_canonical`
map, 946→253), this pass collapses further:

- **253 canonical ids → 9 root-spine ids + 244 domain/method readings.** The whole
  946-equation, 40-chapter corpus is, at the root level, one weld (δ_R⊢L_R⊢F) read through
  five domain lenses (epistemic, human–AI, social, world-system) plus one cross-cutting
  audit lens (method).
- **60 non-collapse bundles/pairs (CAN-008 readers) → the single root non-collapse guard
  $S_n\neq Z_{D,n}\neq D_{D,n}$.** Every "$X\neq Y$" identity in the corpus — from
  CAN-037's occurrence≠record≠trace to the 27-item method-domain credit/evidence guard-pair
  family CAN-230–256 to CAN-069's twelve Fusion non-collapse laws and CAN-128/160's social
  and world-system non-collapse chains — is a domain-specific instance of the same
  constitutional discipline: retained state, candidate representation, and discovered
  quotient are never silently identified. CANONICAL.json's own note on CAN-222 already
  performed one round of this collapse inside a single paper (dissolving an earlier
  over-merge, "CAN-038 non-collapse-chain", that had pooled *several different papers'*
  non-collapse pairs under one id purely because they shared the "$X\neq Y$" shape — a
  violation of BBL-170 rule 1 that CANONICAL.json's authors already caught and reversed).
  This pass extends the same *reading* relation (not a re-merge of the ids — they keep
  separate ids and separate occurrence lists) one level further, to the root.
- **40 constitutional-ordering readers (CAN-004) → one Retention→Structure→Translation→
  Readout→Meaning→Experience→Memory→Belief→Claim→Checking→Status→Report progression.**
  Every domain's own "architecture," "sequence," or "stage list" (Fusion's ten-problem
  architecture, DCP's eight-stage protocol, RG-HCA's native river, the social B-SOC family's
  seven-distinction and non-collapse-constitutive lists) is the same admission order walked
  with that domain's own names substituted at each stage.
- **29 stepper readers (CAN-003) → one $S_{n+1}=F(S_n,u_n,c_n,T_n)$.** The human-AI session
  stepper, the social regime-update law, the labour-claim chain, and the various
  "response chain"/"dialogue"/"loop" objects across all four domains are the same finite
  transition with domain-specific $(u_n,c_n,T_n)$.
- **25 state-tuple readers (CAN-002) → one $S_n=(G_n,\Lambda_n,T_n)$.** Every domain's own
  "state vector"/"index"/"tuple" (entry-state anchor, life-capital context, Human Systemic
  Position index, relational class position, human-return tuples) is a $q_D$-typed
  restatement of the same retained-state carrier.
- **19 readout readers (CAN-201) → one $\mathrm{Readout}_{Q,O,c}(S)=z\neq S$.** The human
  readout instance, source-provenance readout, observer pipeline, encoder pipeline, and the
  human-AI agency-quotient are the same bounded map.
- **12 weld readers (CAN-001) → one $\delta_R\vdash L_R\vdash F$.** Most consequentially: the
  Social-Instability/Peace Spine (CAN-115) is not a metaphorical borrowing of "Laplacian
  language" from physics — CANONICAL.json's own occurrence data already shows the identical
  object independently re-derived in a second (now third, counting the social chapter)
  domain paper.
- **10 domain-weld readers (CAN-006) → one $q_{D,n+1}\circ F_n=F^\#_{D,n}\circ q_{D,n}$.**
  Every domain's own "bridge," "defect vector for a weld," or "admissibility axiom" is an
  instance of the one condition a translation must satisfy to be a domain at all — this is
  also where CANONICAL.json's own CAN-006 entry records that it already folded the HCA-scale
  weld instance in as one occurrence rather than a separate id, per BBL-170 rule 1.
- **8 reader-equivalence readers (CAN-007) → one $z\sim_{Q,O,c,L}z'$.** Knowledge-admission,
  state-sufficiency, tier-ledger, and the method-domain identification-ladder/discovery/
  problem-formation cluster are all instances of the no-early-merge quotient rule.
- **26 historical-invariance readers (CAN-009) → one $\Delta A_{\mathrm{past}}=0$.** The
  provenance ledger, DCP's Integrate/Expand-Contract stage records, the decisive-record
  argmax policy, and nearly the whole method-domain credit/citation apparatus are audits
  *of* the decisive record, never rewrites *of* it.

No raw equation and no CAN id was deleted, merged into another id, or had its tier changed
by this pass — the "collapse" is entirely in the *reading relation* newly drawn from 244
ids to 9, not in the registry's own bookkeeping.

## 5. Drift notes

Read plainly, per BBL-177 (no priority words): these are the places a single reader moving
start-to-end through this line would have to stop and choose, or would find no clean
placement at all.

1. **CAN-222's own reading is itself two defensible answers, not one.** §1 states by direct
   textual content that CAN-222 (a bundle of $X\neq Y$ non-collapse pairs) reads CAN-008.
   The graph-BFS pass (§3.1, using CANONICAL.json's own recorded `relations` edges)
   independently routed it to CAN-007 via a chain through CAN-031 (knowledge-admission).
   Both are correct under a different notion of "nearest": textual content says CAN-008,
   the registry's own recorded relation graph says CAN-007. This is left open rather than
   silently resolved.

2. **44 CAN ids (listed below) carry only a domain-default placement** — no relation
   recorded in CANONICAL.json, and no matching keyword in their own key/object/
   canonical_text pointed to a specific spine element. They are placed on whichever spine
   element their domain most often reads, which is a *convention*, not a demonstrated
   reading. A future pass with direct access to each source chapter (rather than the
   registry's own condensed `canonical_text`) could place these more specifically:
   CAN-016, CAN-020, CAN-024, CAN-026, CAN-040, CAN-058, CAN-067, CAN-072, CAN-078,
   CAN-081, CAN-088, CAN-090, CAN-091, CAN-092, CAN-096, CAN-097, CAN-104, CAN-108,
   CAN-109, CAN-114, CAN-124, CAN-125, CAN-127, CAN-131, CAN-141, CAN-142, CAN-143,
   CAN-144, CAN-145, CAN-152, CAN-155, CAN-157, CAN-161, CAN-175, CAN-180, CAN-181,
   CAN-184, CAN-187, CAN-189, CAN-192, CAN-194, CAN-195, CAN-215, CAN-221.

   **Re-checked 2026-09-06 (REGISTRAR checker, block `44-domain-default-ids-not-resolved`).**
   All 44 were re-tested against this section's own keyword list (non-collapse, weld,
   readout, retention, record/provenance, stepper/chain, ordering, state/tuple,
   equivalence, gate) with word-boundary matching over each id's own name+statement text:
   **0 genuine matches** — the domain-default convention above was already the honest
   answer, not an unchecked shortcut. Each of the 44 now carries a `drift_note` field in
   `CANONICAL.json` (registry/SCHEMA.md) recording that this check was run and its negative
   result, so the weakness is disclosed per-entry, not only in this shared paragraph. Two
   of the 44 that already carried a (previously blank) `relations[]` entry were filled with
   real, quoted evidence rather than left silent: **CAN-157** got a structural match
   (its "corrigible agency envelope" is the same construct as `EQ-015/H.09.v1`'s
   "corrigible/effective agency potential," read at world-system vs. individual scale —
   same `max_pi Pr(...)` shape over the same four conjuncts); **CAN-040** got a weaker,
   honestly-flagged thematic match only (both are threshold/Gate-based regime
   classifiers), explicitly marked lower-confidence than CAN-157's. None of the 44 was
   recoded `HRP-X`: none is rootless (each already has a known, cited root/parent), so
   `HRP-X` — reserved for genuinely rootless Layer-0 objects — would misstate their status;
   see `registry/LINEAGE.jsonl` for the full reasoning.

3. **Blank cells in the reading table are real, not oversights.** CAN-002 and CAN-201 have
   no social reading, and CAN-001, CAN-007, and CAN-009 have no world-system reading. The
   social chapters bundle state+readout+weld into one object (CAN-115's PAR-stepper) rather
   than separating them the way the root paper and the human–AI chapters do — a real
   difference in how finely each domain's own authors factored the stepper, not a gap in
   this registry. World-system's chapters likewise never state a bare Laplacian/retention
   object, a bare reader-equivalence quotient, or a bare historical-invariance law of their
   own — those disciplines are inherited through CAN-006's bridge and CAN-004's ordering
   rather than restated at world-system scale.

4. **Two identities are affirmed with different modalities** and should not be read as
   equally settled just because both sit under CAN-001: CAN-001 itself is
   Th_coqc/machine-checked for $\delta_R\vdash L_R$ but only Dr (forced-but-not-independently-
   verified) for the F-stepper and MQ.08/Th-5; CAN-115 (its social reading) is explicitly
   "theorem [paper-internal, not Coq-verified]." Reading CAN-115 as inheriting CAN-001's
   Th_coqc tier would be an upgrade this collapse does not make (BBL-174).

5. **The κ / R symbol collisions that Master River v1.4 itself already fixed** (§"Canonical
   Notation Corrections Before Freezing Master", `v1_4/main.tex`) are a documented case of
   exactly the drift this collapse is meant to prevent: three different papers used $\kappa$
   for three different quantities (meaning strength / semantic accessibility / live-policy
   accessibility) and five different objects were called $R$ (Read, Resistance, Resonance,
   Rhythm, Human Return) before v1.4's own renaming pass. That renaming is upstream of
   CANONICAL.json and is inherited here without re-litigation; it is recorded because a
   reader moving from the raw `eq_<record_id>.json` records straight into this document,
   bypassing v1.4, would hit the same collision.

6. **A relayed external assessment of the Dialogue Conversion Protocol** (noted in
   `v1_4/main.tex`, 2026-09-06, unverified, relayed from another AI session, its own
   citations not independently checked) sits behind several CAN-08x/CAN-09x ids (DCP
   hypotheses, closing questions). It is recorded there, and here, only as a readout, never
   adopted as validation — consistent with BBL-165 (horizontal knowledge validation): no
   external assessment raises any of these ids' tier.

7. **The classification act in §3.1 is itself tiered** (graph-evidenced / manual /
   textual-keyword / domain-default) exactly because it is a reading of CANONICAL.json, not
   CANONICAL.json's own authority. 67 ids (26%) carry registry-recorded evidence; 129 (51%)
   carry a first-pass textual match; 44 (17%) carry only a domain convention; 4 (2%) were
   manually verified by direct comparison of canonical_text. Any future pass that
   re-classifies an id should update this ledger rather than silently overwrite it.

8. **A handful of ids were moved by hand after the automated pass, from their
   graph/keyword result to a better-fitting spine element, because their own content is a
   clear instance of CAN-008's non-collapse guard even though the registry's `relations`
   field (or a keyword match) initially routed them elsewhere:** CAN-069
   (fusion-non-collapse-bundle), CAN-074 (assisted-vs-return-noncollapse), CAN-079
   (outcome-vector-J\*, moved to CAN-002 as a state vector rather than CAN-004, since it is
   a tuple, not a sequenced admission chain), CAN-128 (B-SOC-LIVEPOSS, "Six-Level
   Live-Possibility *Non-Collapse* Chain" — its own name says non-collapse), and CAN-160
   (conversion-noncollapse-bundle). These moves are recorded here rather than silently
   applied, per the same disclosure discipline as the tier ledger in §3.1's introduction.

## Files produced by this pass

- `registry/COLLAPSE.md` — this file.
- `registry/master_equation.tex` — one displayed, singly-numbered equation: the root spine
  (§1) plus the human–AI (Master River v1.4 eq. 44/65/66/79), social, and world-system
  sub-chains, each arrow tagged `[CAN-nnn]`.
- `registry/reading_table.tex` — LaTeX longtable, root term × {epistemic, social,
  human–AI, world-system} reading, blanks where §5.3 applies.
