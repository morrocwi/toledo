# Equation Library — Human–AI Readout Programme

Generated 2026-09-06 by `registry/build_eq_library.py`. One file for the state of every equation: raw inventory per chapter → canonical id (Genesis-first: one root equation read per domain; latest formulation wins; occurrences mapped, sources never edited) → Coq identifier and tier.

## Status
- Chapters inventoried: 40
- Raw equations: 946
- Canonical objects: not yet built (WF-CANON running)
- Raw→canonical mapped: 0
- Coq identifiers (canonical set): 0
- Master River v1.4 (22519148) equations 1–79: Coq set 22518450, 45 lemmas closed (coq/MR_Ledger.md)
- Founder rulings: BBL-165 (Th_coqc for every equation), 170 (all chapters, one file), 171 (canonicalise first), 172 (latest formulation), 173 (map only), 174 (one master equation along the line), 175/176 (Readout Genesis first: same equation read per domain), 177 (collapse until one reader reads the whole line)

## Raw inventory by chapter (every numbered equation, with its canonical id when assigned)

### The Language Bridge: Expanding Human Potential in the Age of AI — 10.5281/zenodo.17280546 (0 equations)

_No numbered equations (One-page reflective conceptual abstract, pure prose (no displayed formulas, no numbered/boxed equations, no named propositions/definitions written as formulas). Checked plain and -layout pdftotext output in full; nothing to extract.)._

### Violence as a Special Case of Instability in Finite–Memory Causal Systems — 10.5281/zenodo.18383439 (13 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | Sec. 2, From Events to States: Ontologic | s(x,t) ∈ R^n | definition |  |  |
| (2) | Sec. 2, From Events to States: Ontologic | V(x,t) = Φ(s(x,t)) | definition |  |  |
| (3) | Sec. 3, Finite Causal Memory and Telegra | τ ∂t j + j = −D∇s | definition |  |  |
| (4) | Sec. 3, Finite Causal Memory and Telegra | ∂t s = −∇·j − Γ(s) + Senv | definition |  |  |
| (5) | Sec. 4, Spectral Structure and Persisten | ∂t s = Lτ s | identity |  |  |
| (6) | Sec. 4, Spectral Structure and Persisten | s(t) = Σ_k c_k e^{−λ_k t} r_k | identity |  |  |
| Theorem (No-Go for Elimination by Suppression) | Sec. 5, A Structural No-Go Result | Given Lτ with τ > 0, assuming (i) at least one slow spectral mode exists, (ii) suppression acts only on state amplitudes | theorem |  |  |
| (7) | Sec. 8, Minimal Constructive Model | L = [[−α, ε], [ε, −β]], α, β > 0 | definition |  |  |
| (8) | Sec. 8, Minimal Constructive Model | λ± = −(α+β)/2 ± sqrt( ((α−β)/2)^2 + ε^2 ) | identity |  |  |
| (9) | Sec. 9, Ecosystem-Level Stabilization | Γ ↑ (increase dissipation) | measurement |  |  |
| (10) | Sec. 9, Ecosystem-Level Stabilization | Senv ↓ (reduce load) | measurement |  |  |
| (11) | Sec. 9, Ecosystem-Level Stabilization | Lij ↓ (limit propagation) | measurement |  |  |
| (12) | Sec. 9, Ecosystem-Level Stabilization | τ ↓ (shorten memory) | measurement |  |  |

### CAUSAL ETHICS : The Mathematics of Regime Choice and Survival — 10.5281/zenodo.18444260 (37 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| CE-01 | Ch.1 §1.1.1; Ch.2 §2.1 (Axiom I: Reality | M(t') ∈ M | axiom (Axiom I: Reality-as-Record) |  |  |
| CE-02 | Ch.1 §1.1.2; Ch.2 §2.2 (Axiom II: Agency | A_i(t') ⊆ M(t') | axiom (Axiom II: Agency-as-Choice) |  |  |
| CE-03 | Ch.1 §1.1.3; Ch.2 §2.5 (Axiom IV: Collec | G(t') := {A_1(t'), …, A_N(t')} ⊆ M(t') | axiom (Axiom IV: Collective as Coupled Agencies) |  |  |
| CE-04 | Ch.1 §1.1.4 (Admissible Regime Set); Equ | R ∈ R_adm(t') | definition |  |  |
| CE-05 | Ch.1 §1.1.5; Ch.2 §2.3 (Axiom III: Regim | R := (T_R, I_R) | axiom (Axiom III: Regime Structure) |  |  |
| CE-06 | Ch.1 §1.1.6; Ch.2 §2.3.2 (Update Laws);  | M(t' + Δt') = T_R(M(t')) | law (update law) |  |  |
| CE-07 | Ch.1 §1.1.6; Ch.2 §2.3.2 (Update Laws);  | A(t' + Δt') ⊆ I_R(A(t'), M(t')) | law (update law) |  |  |
| CE-08 | Ch.1 §1.2.3 (What 'Etic' Means Here); Ch | Etic(A; t') := ∃ R_A(t') ∈ R_adm(t') : A ⊆ M(t'), M(t'+Δt') = T_{R_A}(M(t')), A(t'+Δt') ⊆ I_{R_A}(A(t'), M(t')) | definition |  |  |
| CE-09 | Ch.3 §3.2 (Ethical Load: the Lyapunov Po | V_{A,R}(M) ≥ 0 | definition |  |  |
| CE-10 | Ch.3 §3.3 (Causal Memory Constraint); Eq | τ_c'(R) > 0 | definition |  |  |
| CE-11 | Ch.3 §3.4 (Spectral Stability Margin); E | Δ_spec(R) > 0 | definition |  |  |
| CE-12 | Ch.3 §3.1.1 (Core Definition: Ethics as  | Ethical(A) ⇔ ∃ Choice(A → R_A) : d/dt' V_{A,R_A}(M(t')) ≤ 0 ∧ τ_c'(R_A) > 0 ∧ Δ_spec(R_A) > 0 | definition (author-labelled 'final' / locked) |  |  |
| CE-13 | Ch.4/Ch.7 §4.1.2/§7.1.2 (Interpretation  | V̇⁺ := max(dV/dt', 0) | definition |  |  |
| CE-14 | Ch.1 §1.3 (Symbol Dictionary — Spectrum  | M(t') = M_0 φ_0 + Σ_k a_k(t') φ_k | definition |  |  |
| CE-15 | Ch.1 §1.3 (Symbol Dictionary); Equation  | S_A(R) ⊆ span{φ_k} | definition |  |  |
| CE-16 | Ch.1 §1.3 (Symbol Dictionary); Equation  | P_{S_A(R)} : M → S_A(R) | definition |  |  |
| CE-17 | Ch.5 §5.6 (Individual Survival Link); Eq | limsup_{n→∞} ‖P_{S_A(R_A)} M(t'+n)‖² > 0 | definition |  |  |
| CE-18 | Ch.5 §5.6 (Individual Survival Link); Eq | lim_{n→∞} ‖P_{S_A(R_A)} M(t'+n)‖² = 0 | definition |  |  |
| CE-19 | Ch.5 §5.3 (Individual Admissibility Test | Eth_ind(A) ⇔ d/dt' V_{A,R_A} ≤ 0 ∧ Δ_spec(R_A) > 0 | definition |  |  |
| CE-20 | Ch.6 §6.1 (From Individual Potentials to | V_G(M) := Σ_{i=1}^N w_i V_{A_i,R_i}(M),  w_i > 0 | definition |  |  |
| CE-21 | Ch.6 §6.2 (Collective Admissibility and  | Eth_col(G) ⇔ d/dt' V_G(M) ≤ 0 ∧ min_i Δ_spec(R_i) > 0 | definition |  |  |
| CE-22 | Ch.8 §8.2.1 (Individual-Admissible, Coll | Conf_{ind→col} ⇔ d/dt' V_{A_i} ≤ 0 ∧ d/dt' V_G > 0 | definition |  |  |
| CE-23 | Ch.8 §8.2.2 (Collective-Admissible, Indi | Conf_{col→ind} ⇔ d/dt' V_G ≤ 0 ∧ ∃i: d/dt' V_{A_i} > 0 | definition |  |  |
| CE-24 | Ch.8 §8.1 (Moral Conflict as a Mathemati | Δ_spec(R_i ∪ R_j) ≤ 0 | definition |  |  |
| CE-25 | Ch.4/Ch.7 §4.2.1/§7.2.1 (Definition (Cau | χ_causal(R) := 1[τ_c'(R) ≈ 0] | definition |  |  |
| CE-26 | Ch.4/Ch.7 §4.2.2/§7.2.2 (Definition (Spe | χ_spec(R) := 1[Δ_spec(R) ≤ 0] | definition |  |  |
| CE-27 | Ch.4/Ch.7 §4.1.1/§7.1.1 (Definition (Mor | C_{A,R}[t1,t2] := ∫_{t1}^{t2} [ α V̇⁺_{A,R}(M(t')) + β χ_causal(R) + γ χ_spec(R) ] dt',  α,β,γ > 0 | definition |  |  |
| CE-28 | Ch.4/Ch.7 §4.3/§7.3 (Definition (Respons | Resp(A) ≡ C_{A,R_A} | definition |  |  |
| CE-29 | Ch.4/Ch.7 §4.4/§7.4 (Definition (Collect | C_G[t1,t2] := Σ_{i=1}^N w_i C_{A_i,R_i}[t1,t2] | definition |  |  |
| CE-30 | Ch.4/Ch.7 §4.4.2/§7.4.2 (Definition (Str | ∃ i,j : C_{A_i,R_i} ≫ C_{A_j,R_j} | definition |  |  |
| CE-31 | Ch.4/Ch.7 §4.5/§7.5 (Definition (Karma a | lim_{T→∞} C_{A,R}[0,T] = ∞ | definition |  |  |
| CE-32 | Ch.4/Ch.7 §4.5.2/§7.5.2 (Theorem (Cost–S | lim_{T→∞} C_{A,R}[0,T] = ∞ ⇒ lim_{n→∞} ‖P_{S_A} M(t'+n)‖² = 0 | theorem (author-labelled 'Theorem (Cost–Survival Link)') |  |  |
| CE-33 | Ch.4/Ch.7 §4.6.1/§7.6.1 (Definition (Zer | Eth(A) ⇔ C_{A,R_A}[t,∞) = 0 | definition (author-labelled 'ideal condition') |  |  |
| CE-34 | Ch.4/Ch.7 §4.6.2/§7.6.2 (Definition (Con | R* ∈ argmin_{R∈R_adm} C_{system,R}  s.t.  τ_c'(R) > 0, Δ_spec(R) > 0 | definition |  |  |
| (CE-choice gate) | Ch.5 §5.3 (Hard rule: Choice gate) | ¬∃ Choice(A → R_A) ⇒ no ethics attribution, no responsibility attribution, and no moral cost attribution | law (author-labelled 'Hard rule') |  |  |
| (Tragic) | Ch.5 §5.4 (Definition (Tragic regime cla | ∀ R ∈ R_available(t') : ¬[τ_c'(R) > 0 ∧ Δ_spec(R) > 0] ∨ C_{A,R}[t',t'+T] > 0,  for all T > 0 | definition |  |  |
| (Tragic-min) | Ch.5 §5.4 (Consequence, following Defini | R†_A ∈ argmin_{R∈R_available(t')} C_{A,R}[t',t'+T]  s.t.  τ_c'(R) > 0, Δ_spec(R) > 0 | proposition (derived consequence of the Tragic definition) |  |  |

### AI, Translation, and Access to Event-Specific Contex — 10.5281/zenodo.18517054 (20 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| Def-1 | 3.1 Events and reality | E := an event in the world (used as a separation device, not an ontological claim). | definition |  |  |
| Def-2 | 3.2 Event-specific context | C_e := (S_e, R_e, A_e, τ_e), where S_e = situational/environmental condition, R_e = relational/causal structure, A_e = s | definition |  |  |
| Def-3 | 3.3 Translation/interpretation and non-i | T̂ := I(E \| C_acc), where I is the human interpreter (language + reasoning + experience) and C_acc is the context actual | definition |  |  |
| Prop-1 | 3.3 Translation/interpretation and non-i | T̂ ≠ E | proposition |  |  |
| Def-4 | 3.4 Human agency and self-context | A := the capacity to decide under context while retaining accountability; agency is anchored by preservation of S. | definition |  |  |
| Def-5 | 3.4 Human agency and self-context | S := (goals, constraints, stakes, role, local evidence, lived situation). | definition |  |  |
| Def-6 | 3.5 External context-frame | F := a context-frame induced by external structures (ranking, engagement optimization, typicality pressures, standardiza | definition |  |  |
| Prop-2 | 3.5 External context-frame | When S is not preserved, the tendency for F to dominate interpretation increases, with a corresponding risk of agency de | proposition |  |  |
| Def-7 | 3.6 Grounding vs embodiment | G (referential grounding) = ability to pick out referents/factual anchors; Ge (experiential grounding) = meaning anchore | definition |  |  |
| Prop-3 | 3.6 Grounding vs embodiment | G ≠ Emb | hypothesis/Open |  |  |
| (1) | 3.7 Interaction efficiency | 𝓔 := f(ConstraintPrecision, ContextRecall, SourceTraceability, ErrorRepair). | definition |  |  |
| Eq-unifying | 4.1 A unifying formalization | T̂^(k) = I(E \| C_acc^(k)), where k indexes the dominant mediation architecture (epoch). | definition |  |  |
| Eq-epoch3 | 4.5 Epoch 3: LLM-based AI mediation | T̂^(3) = I(E \| C_acc^(3)) + ΔC via dialogue(S, prompts, checks). | definition |  |  |
| Prop-4 | 4.6 The context-access chain | E → C_acc^(0) → C_acc^(1) → C_acc^(2) → C_acc^(3). | proposition |  |  |
| Finding-1 (H1) | 6.2 H1: Context-access amplification wit | AI does not directly increase access to event-specific context E; it increases access to, and reorganization of, human i | hypothesis/Open |  |  |
| Finding-2 (H3) | 6.3 H3: Open-ended but bounded interpret | When human–AI interaction achieves high 𝓔 and preserves S, individuals may tend toward open-ended cross-domain interpret | hypothesis/Open |  |  |
| Finding-3 (H4) | 6.4 H4: Architectural doorway through di | AI introduces an architectural doorway enabling access to diverse human-generated translations/interpretations via immed | hypothesis/Open |  |  |
| Prop-5 (B1) | 6.5 Boundary B1: External-context domina | AI-mediated empowerment tends to occur iff (i) 𝓔 is high and (ii) S is preserved; if S is displaced by language alone, F | proposition |  |  |
| (2) | 7. Boxed master equation and interpretiv | AI-Empowerment(H) ⇐⇒ S preserved ∧ high 𝓔. | proposition |  |  |
| (3) | 7. Boxed master equation and interpretiv | S replaced by language ⇒ F dominates ⇒ [agency] degrades. | proposition |  |  |

### Learning Under Generative Abundance: A Structural Law of Epistemic Stabilization — None (2 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| L1 | A Structural Law of Epistemic Environmen | When the external generation of coherent structure increases without bound, observable production ceases to serve as a u | law |  |  |
| L2 | The Regime Transition | accumulation --> discrimination | law |  |  |

### Causal Agency  A Persistence Control Theory of Adaptive Systems — 10.5281/zenodo.18897585 (10 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| Def-1 | 6.1 Constrained Dynamical Systems | x' = F(x, C) | definition |  |  |
| Def-2 | 6.2 Persistence and Viable Regions | x(t) ∈ V,  where V ⊆ S is the viable region of the state space S, for all times in the interval of observation | definition |  |  |
| Persistence-Regulation-Condition | 6.4 Persistence Regulation | d/dt [ d(x(t), V) ] < 0  (in expectation), where d(x,V) is the distance between state x and the viable region V | definition (formalization of persistence regulation) |  |  |
| Constraint-Evolution | 5.5 / 6.3 Constraint Dynamics | C_{t+1} = G(x_t, C_t) | definition (schematic representation, not yet the agency condition) |  |  |
| State-Constraint-Coupling | 6.5 Agency as Constraint Regulation | ∂C/∂x ≠ 0 | definition (necessary condition, part of the agency criterion) |  |  |
| Def-3 (Agency-Condition) | 6.5 Agency as Constraint Regulation | ∂Tp/∂C · ∂C/∂x > 0,  where Tp is the expected persistence time of the system within the viable region V | definition |  |  |
| Proto-Agency-Condition | 8.2–8.3 Level 0 / Level 1; 9.2 Control S | ∂C/∂x = 0 | definition |  |  |
| L3-Constraint-Evolution-History | 8.5 Level 3: Adaptive Constraint Regulat | C_{t+1} = G(x_t, C_t, H_t),  where H_t is the system's interaction history | definition |  |  |
| L4-Constraint-Evolution-Predictive | 8.6 Level 4: Predictive Constraint Regul | C_{t+1} = G(x_t, C_t, x̂_{t+k}),  where x̂_{t+k} represents predicted future states | definition |  |  |
| L5-Meta-Regulation | 8.7 Level 5: Reflective Constraint Regul | G_{t+1} = M(G_t) | definition |  |  |

### Knowledge as Stabilized Translation: Toward an Observer-Constrained Epistemology — 10.5281/zenodo.18925129 (2 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 6. The Observer as a Bounded System | M_A(E) = (T_A o Pi_A)(S_A(E)) | definition (source manuscripts' minimal observation pipeline) |  |  |
| (2) | 6. The Observer as a Bounded System | Know_A(W) = 1 iff Dist(R_A[n], R_A^nu[n]) <= epsilon_K for all admissible variations nu on the declared window W | definition (knowledge as stability-achievement) |  |  |

### The Causal Grammar of Structured Coexistence: Conflict, Violence, Repair, and Non-Suppress — 10.5281/zenodo.18925131 (0 equations)

_No numbered equations (Preprint, 9 March 2026, 5 pages. Read in full via pdftotext (plain and -layout). This is a purely qualitative/sociological theory paper: it contains no numbered or boxed mathematical equations, no lettered propositions/lemmas (no CE-/P-/H-style labels), and no non-collapse 'X ≠ Y' formulas. Its only formal apparatus is prose definitions (structure as organized possibility; conflict as incompatible coexistence; violence as possibility compression; repair as protected reopening; peace as non-suppressive stability), one causal diagram (Figure 1: Structure -> Compatible/Incompatible Coexistence -> Violence -> Repair -> Peace), and one qualitative typology table (Table 1: Regimes of structured coexistence -- Tension/Conflict/Violence/Pseudo-peace/Peace by Compatibility x Possibility Space x Repair). Cross-checked against Master Equation River v1.4/main.tex and refs.bib: this paper is not cited there and has no restated equation among eq:1-79. Confirmed not restated in Master River v1.4 (record_id/title/'causal grammar'/'structured coexistence' do not appear in main.tex or refs.bib).)._

### The Civilization of Knowledge: Who Has the Authority to Interpret the World — 10.5281/zenodo.18943971 (1 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| Canonical Formula | Working Thesis and Governing Formula | M_A(E) = (T_A ∘ Π_A)(S_A(E)),   S_A(E) ⊆ Δ(E) | definition (author-labelled 'Canonical Formula'; the paper explicitly states it does not claim all historical formations can be captured by one formula without remainder — it is an organizing heuristic, not a proven law) |  |  |

### The Architecture of Mediated Agency: Beyond the Misframing of Free Will and Truth — 10.5281/zenodo.19176260 (0 equations)

_No numbered equations (5-page prose article with no numbered, boxed, or otherwise displayed equations. It uses inline symbolic notation only within running prose — 'inherent errors (ε_tot > 0)' (abstract; §2.1 Theorem of Irreducible Error) and 'perfect self-knowledge (ε_self = 0)' (§5) — neither of which is set off as a formal displayed/numbered equation, definition box, or named proposition. Checked via both plain and -layout pdftotext extraction of the full 5 pages; no equation environment, numbered formula, or non-collapse (X ≠ Y) law block appears anywhere in the text.)._

### Constraint-First Epistemology: Normativity, Conditioned Agency, and the Non-Zero Kantian F — 10.5281/zenodo.19205869 (6 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 4 Formal Core | O_A[n] = Π_A(E[n]) | definition |  |  |
| (2) | 4 Formal Core | enc_A(O_A)[n] = T_A(O_A[n]) | definition |  |  |
| (3) | 4 Formal Core | M_A[n+1] = U_A(M_A[n], enc_A(O_A)[n], C_A, Δ_A[n]) | definition |  |  |
| (4) | 4 Formal Core | ε_tot > 0 | law |  |  |
| (5) | 4 Formal Core | V_A[n] = Align(M_A[n], θ_W \| D) | definition |  |  |
| (6) | 4 Formal Core | E[V_A[n+1] \| Rsn_A, D] > E[V_A[n] \| D] | proposition |  |  |

### When AI Expands Human Potential: Reflective Dissonance, Epistemic Agency, and Constraint — 10.5281/zenodo.19215748 (2 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| unlabeled (§7, display 1) | 7 Context-Indexed Evaluation | K_A(D, t) := V_A^D( M_A(t), θ_D ) | definition |  |  |
| unlabeled (§7, display 2) | 7 Context-Indexed Evaluation | V_A^D = w_1^D P + w_2^D I + w_3^D S + w_4^D R + w_5^D L,  with Σ_i w_i^D = 1 | definition |  |  |

### Mind as Information Horizon: From Primordial Difference to Expertise Formation on the Disc — 10.5281/zenodo.19640361 (18 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| P3 | 2.2 The Three Postulates and the Telegra | v = sqrt(D/τ_c) < ∞ | law |  |  |
| MQ.08 | 2.2 The Three Postulates and the Telegra | V[n+1] = V[n] + Δθ·(−γ·V[n] − D_s·L_R·X[n]) | theorem |  |  |
| Th-5 | 2.3 Eigenmodes, Decay, and the Emergence | \|a_k[n]\| ≤ \|a_k[0]\| · e^(−γ_k · n · Δθ) | theorem |  |  |
| (1) | 3.1 The Causal Body Framework | B[n] → H_body[n] → N[n] → S[n] ↔ A[n] → π[n] → U[n] → B[n+1] | definition |  |  |
| (2) | 3.1 The Causal Body Framework | H_body[n+1] = Φ_H(B[n], H_body[n]) | definition |  |  |
| (3) | 3.1 The Causal Body Framework | N[n+1] = Φ_N(B[n], H_body[n], N[n]) | definition |  |  |
| (4) | 3.1 The Causal Body Framework | S[n+1] = Φ_S(S[n], N[n], H_body[n]) | definition |  |  |
| (5) | 3.1 The Causal Body Framework | A[n+1] = Φ_A(S[n], A[n])  (brain-internal only) | definition |  |  |
| (6) | 3.1 The Causal Body Framework | π[n+1] ∈ arg min_{π∈Π_feas} L_sel(S, H_body, π) | definition |  |  |
| (7) | 3.1 The Causal Body Framework | U[n+1] = Exec(π[n+1]) | definition |  |  |
| (8) | 3.1 The Causal Body Framework | B[n+1] = Φ_B(B[n], U[n+1]) | definition |  |  |
| (9) | 4.1 The Coupling Model | B[t+1] = F(B[t]) + C_H(H[t]) | definition |  |  |
| (10) | 4.1 The Coupling Model | H[t+1] = G(H[t]) + C_B(B[t]) | definition |  |  |
| (11) | 4.1 The Coupling Model | E[t] = R(B[t], H[t]) | definition |  |  |
| (12) | 5.2 World-Resistance and Structural Erro | ε_tot = ε_clock + ε_cross + ε_sel + ε_map + ε_self | theorem |  |  |
| (13) | 5.3 The Knowledge Event | Knowing = Coupled System + Selection + Retention + Model + Error + Correction | definition |  |  |
| (14) | 6.1 The Knowledge Triple | K_S^A = (Tr_A, Str_A, Cap_A) | definition |  |  |
| (15) | 6.3 The Legitimacy Gate | LegitKnow ⇔ Know_A ∧ Grounded ∧ Q_auth ≥ θ_Q ∧ N_know ≥ θ_N | theorem |  |  |

### Experience Is the Human LoRA: A Readout–Retention Theory of Selective Model Change — 10.5281/zenodo.21425420 (47 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 2.1 The readout-not-truth stance | G_H[n] = (V_H[n], E_H[n], w_H[n]) | definition |  |  |
| (2) | 2.1 The readout-not-truth stance | w_H[n](e) in Q_{>0} | definition |  |  |
| (3) | 2.1 The readout-not-truth stance | phi_n in Q^{\|V_H[n]\|} | definition |  |  |
| (4) | 2.2 Discrete time and the human spine | delta phi_n = phi_{n+1} - phi_n | definition |  |  |
| (5) | 2.2 Discrete time and the human spine | delta^2 phi_n = phi_{n+1} - 2 phi_n + phi_{n-1} | definition |  |  |
| (6) | 2.2 Discrete time and the human spine | mu_H delta^2 phi_n + d_H delta phi_n + kappa_H L_H[n] phi_n + partial_Q V_H(phi_n) = J_H[n] - eta_H[n] | Dr/interpretive (explicitly not a derived law) |  |  |
| (7) | 3.1 World contact and selected readout | S_n : X_n -> Z_n | definition |  |  |
| (8) | 3.1 World contact and selected readout | z_n = Pi_n S_n(X_n) + eta_n,  z_n in Q^{m_n} | definition |  |  |
| (9) | 3.2 Finite temporal thickness | W_n = {n - h_n + 1, ..., n} | definition |  |  |
| (10) | 3.2 Finite temporal thickness | tilde{z}_n = sum_{j=0}^{h_n-1} a_{n,j} z_{n-j} | definition |  |  |
| (11) | 3.3 Embodied and relational phenomenaliz | O_H[n] = O(G_brain[n], G_body[n], G_environment[n], G_relation[n], G_practice[n], G_language[n], V_H[n]) | definition |  |  |
| (12) | 3.3 Embodied and relational phenomenaliz | P_n = Phi_n(tilde{z}_n, O_H[n], B_n, A^aff_n, C_n, U_n) | definition |  |  |
| (13) | 3.3 Embodied and relational phenomenaliz | E_n = <X_n, z_n, tilde{z}_n, P_n, u_n, R_{n+1}, Delta O_n> | definition |  |  |
| (14) | 3.4 No experience without retained diffe | H_{n+1} != H_n | law |  |  |
| (15) | 4.1 Two aspects of one event | E_n^phen = P_n | definition |  |  |
| (16) | 4.1 Two aspects of one event | E_n^adapt = Delta O_n | definition |  |  |
| (17) | 4.1 Two aspects of one event | E_n = <E_n^phen, E_n^adapt> = Human LoRA_n | identity |  |  |
| (18) | 4.2 Transient and retained updates | Delta O_n^fast = B_n A_n | definition |  |  |
| (19) | 4.2 Transient and retained updates | g_n = Gamma_n(s_n, r_n^err, q_n, v_n, c_n, p_n) in Q intersect [0,1] | definition |  |  |
| (20) | 4.2 Transient and retained updates | Delta O_n^ret = g_n * Delta O_n^fast | definition |  |  |
| (21) | 4.2 Transient and retained updates | O_H[n+1] = O_H[n] + Delta O_n^ret + epsilon_n | definition |  |  |
| (22) | 5.1 The finite-bottleneck postulate | 0 < m_n < d_n | hypothesis/Open |  |  |
| (23)-(24) | 5.1 The finite-bottleneck postulate | A_n in Q^{m_n x d_n},  B_n in Q^{d_n x m_n} | definition |  |  |
| (25) | 5.1 The finite-bottleneck postulate | Delta O_n = B_n A_n | definition |  |  |
| (26) | 5.1 (Proposition 1) | rank_Q(B_n A_n) <= m_n | theorem |  |  |
| (27) | 5.1 (Proposition 2) | (O_H[n] + B_n A_n) x = O_H[n] x   whenever A_n x = 0 | theorem |  |  |
| (28) | 5.1 (Proposition 3) | rank_Q( sum_{i=1}^{N} Delta O_i ) <= sum_{i=1}^{N} m_i | theorem |  |  |
| (29) | 5.2 Transformative experience without re | O_H[N] = O_H[0] + sum_{n=0}^{N-1} g_n B_n A_n + sum_{0<=i<j<N} Lambda_{ij} + sum_{n=0}^{N-1} epsilon_n | definition |  |  |
| (30) | 6.1 Intentionality | I_n = (x --as--> y)_n | definition |  |  |
| (31) | 6.2 Horizon | H_n subseteq V_H[n],  \|H_n\| < infinity | definition |  |  |
| (32) | 7.2 Consolidation, retrieval, and recons | Delta O^{old}_{new} = g_n B_n A_n Q_n(Delta O^{old}) | definition |  |  |
| (33) | 7.3 Neural-manifold findings translated  | Y in Q^{T x p} | measurement |  |  |
| (34) | 7.3 (Definition 3) | r_rho(D) = rank_Q( q_rho(D) ) | definition |  |  |
| (35) | 8.1 Adaptation is not well-being | successful adaptation = mental health   [explicitly REJECTED] | law (non-collapse, rejected identity) |  |  |
| (36) | 8.1 Adaptation is not well-being | W_n = (F_n, A_n^agency, M_n^meaning, R_n^relation, C_n^competence, Q_n^repair) | definition |  |  |
| (37) | 8.2 A discrete misfit model | C_mal[n] = rig(a_n) * gen(a_n) * mis(a_n) * loss(a_n) | measurement |  |  |
| (38) | 8.4 Therapeutic learning as adapter comp | O_post = O_threat + g_s B_s A_s | Dr/interpretive |  |  |
| (39) | 9.1 Four synchronized readout layers | D_n = {D_n^first, D_n^beh, D_n^neural, D_n^world} | measurement |  |  |
| (40) | 9.2 Study 1: finite bottleneck and rank  | D_{post-pre} = B A + E | hypothesis/Open |  |  |
| (41) | 9.2 Study 1: finite bottleneck and rank  | r_rho(D_{post-pre}) <= m | hypothesis/Open |  |  |
| (42) | 9.4 Study 3: consolidation and rank traj | r_rho(D_0), r_rho(D_1), ..., r_rho(D_N) | hypothesis/Open |  |  |
| (43) | 9.7 Competing models | M0: context-only state change | hypothesis/Open |  |  |
| (44) | 9.7 Competing models | M1: sparse but not low-rank update | hypothesis/Open |  |  |
| (45) | 9.7 Competing models | M2: low-rank factorized update | hypothesis/Open |  |  |
| (46) | 9.7 Competing models | M3: regularized full-rank update | hypothesis/Open |  |  |
| (47) | 9.7 Competing models | M4: finite graph rewiring | hypothesis/Open |  |  |
| (48) | 9.7 Competing models | M5: hybrid fast trace plus slow update | hypothesis/Open |  |  |

### Readout Genesis Standalone Synthesis: Information Epistemic Foundation, Conditioned Agency — 10.5281/zenodo.21529456 (91 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | III.A Retained distinction and graph str | delta_R = (a # b);  delta_R => L_R = D_W - W;  S_{n+1} = F(S_n, u_n, c_n, T_n) | identity (root weld / architecture) |  |  |
| (2) | III.A Retained distinction and graph str | q_{D,n+1} o F_n = F^#_{D,n} o q_{D,n};  O_{D,n} = O^#_{D,n} o q_{D,n} | definition (admissibility condition) |  |  |
| (3) | III.A Retained distinction and graph str | delta_R = (a # b) | definition |  |  |
| (4) | III.A Retained distinction and graph str | L_R = D_W - W | identity |  |  |
| (5) | III.A Retained distinction and graph str | S_{n+1} = F(S_n, u_n, c_n, T_n) | definition |  |  |
| (6) | III.B Domain translation and reader equi | q_D(F(z,u,c,T)) = F_D(q_D(z), u, c, T) | definition (admissibility) |  |  |
| (7) | III.B Domain translation and reader equi | O_D(z; Q, c) = O^#_D(q_D(z); Q, c) | definition (admissibility) |  |  |
| (8) | III.B Domain translation and reader equi | z ~_{Q,O,c,L} z'  <=>  O(F^k z) = O(F^k z')  for all k <= L | definition |  |  |
| (9) | III.C Constitutional ordering | retention -> structure -> translation -> readout -> meaning -> experience -> memory -> belief -> claim -> checking -> st | law (constitutional ordering rule) |  |  |
| (10) | IV From occurrence to meaning, experienc | A != x != mu != E != M != Bel != p != sigma_K(p) | law (non-collapse) |  |  |
| (11) | IV From occurrence to meaning, experienc | x_{i,n} = Access(A_n; O_i, L_i, T_i, R_i, C_i) | definition |  |  |
| (12) | IV From occurrence to meaning, experienc | A_i = A_j  =/=>  x_i = x_j | law (non-collapse) |  |  |
| (13) | IV From occurrence to meaning, experienc | mu_{i,n} = G_mu(x_{i,n}, M_{i,n-1}, K_{i,n-1}, Theta_{i,n-1}, I_{i,n-1}, S_{i,n}^active, c_n) | definition |  |  |
| (14) | IV From occurrence to meaning, experienc | E_{i,n} = Phi_E(x_{i,n}, mu_{i,n}, kappa_{i,n}, c_n) | definition | 4 |  |
| (15) | IV From occurrence to meaning, experienc | M_{i,n} = U_M(M_{i,n-1}, x_{i,n}, mu_{i,n}, E_{i,n}, c_n, Lineage_n, T_n) | definition |  |  |
| (16) | IV From occurrence to meaning, experienc | Delta A_past = 0 | law (invariant) |  |  |
| (17) | V.A Relational and multidimensional beli | Bel_{i,p,n} = Rel_B(a_i, p \| x_i, mu_i, E_i, M_i, Theta_i, I_i, S_i^active, c_i) | definition |  |  |
| (18) | V.A Relational and multidimensional beli | b_{i,p,n} = (e_{i,p}, c_{i,p}, s_{i,p}, a_{i,p}, eta_{i,p}, g_{i,p}, r_{i,p}) | definition |  |  |
| (19) | V.A Relational and multidimensional beli | b_{i,p,n+1} = U_B(b_{i,p,n}, Ev_{i,p}, M_i, mu_i, E_i, Theta_i, I_i, Trust_i, Affect_i, Utility_i, Repetition_i, Auth_i, | law (descriptive update rule) |  |  |
| (20) | V.B Scale and stabilization | Bel_{g,d,n}^{(l)}(p) = Stabilize_B({b_{i,p,n}}_{i in G}, C_B) | definition |  |  |
| (21) | V.B Scale and stabilization | Belief Strength(p), Belief Distribution(p), Auth(p), Pow(p), Val_E(p) | law (non-collapse) |  |  |
| Prop-1 | V.B Scale and stabilization | Belief-scale nonpromotion: for any proposition p, increasing the distribution scale of Bel(p) does not, without addition | proposition (with proof) |  |  |
| Def-1 | VI.A Normative proposal | Knowledge status: Knowledge is the bounded epistemic status granted to a claim about the world or a declared domain when | definition |  |  |
| (22) | VI.A Normative proposal | sigma_K(p) = Admit_E(p \| Agent, D, C, O, Access, Language, Tools, Rights, Prov, Ev, Method, Infer, Assumptions, Uncertai | definition |  |  |
| (23) | VI.A Normative proposal | K_p = <p, C_p, P_p, E_p, M_p, I_p, U_p, Omega_p, O_p, L_p, sigma_K(p)> | definition |  |  |
| (24) | VI.B Status of speaker and status of cla | StatusOfSpeaker != StatusOfClaim;  Auth(p) != Val_E(p);  Pow(p) != Val_E(p) | law (non-collapse) |  |  |
| (25) | VI.C Practical effectiveness as a separa | Pi_prac(p) = TestPerformance(Y, Y_hat, intervention, C, O) | definition |  |  |
| (26) | VI.C Practical effectiveness as a separa | sigma_K(p) != Pi_prac(p) | law (non-collapse) |  |  |
| (27) | VII.A The gate sequence | chi_G in {1, 0, perp};  1 = ADMITTED, 0 = OBSTRUCTED, perp = UNRESOLVED | definition |  |  |
| (28) | VII.B State sufficiency and invariant co | Suff_{E,L}(Z_E^cand; Q, O, c, T) in {1, 0, perp} | definition |  |  |
| (29) | VII.B State sufficiency and invariant co | Inv_E(z) != Inv_E(z')  =>  q_E(z) != q_E(z') | law (invariant preservation) |  |  |
| (30) | VII.D Claim ceiling | tau_public(p) <= inf_{g in G_p} tau(g) | identity (claim-ceiling bound) |  |  |
| Prop-2 | VII.D Claim ceiling | Weakest-link claim ceiling: if any load-bearing gate for p is unresolved or obstructed, a public claim that presupposes  | proposition (with proof) |  |  |
| (31) | VII.D Claim ceiling | sigma_K(p) in {ADMITTED, LOCAL, TRANSPORTABLE, UNRESOLVED, OBSTRUCTED, RETRACTED, SUPERSEDED} | definition |  |  |
| (32) | VIII Local, institutional, and global kn | Omega(K) = {(g, d, l, P, O, c) : all required gates pass} | definition |  |  |
| (33) | VIII Local, institutional, and global kn | K_local = K \|_{Omega_local} | definition |  |  |
| (34) | VIII Local, institutional, and global kn | T^Y_{ij} o K_i ~= K_j o T^C_{ij};  epsilon_bridge = d(T^Y_{ij} o K_i, K_j o T^C_{ij}) | definition (transport condition) |  |  |
| (35) | VIII Local, institutional, and global kn | Bel_global(p) != K_global(p) | law (non-collapse) |  |  |
| (36) | IX.A Agency as a process quotient | A_{i,n} = q_A(Z_{i,n}; Q_A, O_A, c_n) | definition |  |  |
| (37) | IX.A Agency as a process quotient | Aut(F_A, O_A) = {h : O_A o h = O_A, h o F_A = F_A o h} | definition |  |  |
| (38) | IX.A Agency as a process quotient | I_n = q_comp(M_n (+) Bel_n (+) Theta_n (+) Roles_n (+) BodyTool_n (+) SocialLineage_n) | definition |  |  |
| (39) | IX.B The conditional chain | x_n -> zeta_n -> v_n -> rho_n -> U_n -> beta_n -> I_{n+1} -> a_n -> S_{n+1} | definition (chain structure) |  |  |
| (40) | IX.B The conditional chain | zeta_n = Contact(x_n, O_n, BodyTool_n, Attention_n, c_n) | definition |  |  |
| (41) | IX.B The conditional chain | v_n = V_valence(zeta_n, M_n, mu_n, BodyState_n, c_n) | definition |  |  |
| (42) | IX.B The conditional chain | rho_n = R_drive(v_n, ExpectedRelief_n, ExpectedGain_n, Habit_n, c_n) | definition |  |  |
| (43) | IX.B The conditional chain | U_n = Bind_self(rho_n, Bel_n, Theta_n, I_n, S_n^active, c_n) | definition |  |  |
| (44) | IX.C Distortion before knowledge | xi_n = (xi_n^+, xi_n^-, xi_n^0) | definition |  |  |
| (45) | IX.C Distortion before knowledge | Xi_n = alpha_n^+ P_n^+ + alpha_n^- P_n^- + alpha_n^0 P_n^0;  G~_{mu,n} = G_{mu,n} o (I + Xi_n) | definition |  |  |
| (46) | IX.C Distortion before knowledge | epsilon_{Xi,n} = d_O(G_{mu,n}(z_n), G~_{mu,n}(z_n)) | definition (measurement) |  |  |
| (47) | X.A Typed self readout | S_A[n] = q_self(F^n[delta_R, T_A, c_{0:n}]) = <A_A[n], Delta_A[n], H_A[n], Phen_A^str[n], P_A^lived[n], Own_A[n], Coh_A[ | definition |  |  |
| (48) | X.A Typed self readout | A_A != I_A != Phen_A^str != P_A^lived != Own_A != Coh_A != Val_A | law (non-collapse) |  |  |
| (49) | X.A Typed self readout | I_A[n+1] = q_id(I_A[n] (+) A_A[n] (+) P_A^lived[n] (+) Pi_A^star[n] (+) Res_A[n] (+) Delta T_A[n]) | definition |  |  |
| (50) | X.B The horizon triad | H_dyn: Delta_A(lambda) = D_A^2 - 4 M_A K_A lambda = 0 | definition |  |  |
| (51) | X.B The horizon triad | H_info(A) = {z in Z_A : Rec(z) => (E_b < infinity, R_p > 0)} | definition |  |  |
| (52) | X.B The horizon triad | H_phen(A) = {r = A_A^acc Pi_A T_A(delta_R) : PhenGate(r) = 1} | definition |  |  |
| (53) | X.B The horizon triad | H_dyn --DI_K--> H_info --IP_K--> H_phen | hypothesis/Open (weld, bridge open) |  |  |
| (54) | X.B The horizon triad | Phen_A^str[n] = A_A^acc Pi_A T_A^{<=n}(delta_R; T_A, c_n) | definition |  |  |
| (55) | X.B The horizon triad | P_A^lived[n] = Phi_A^phen(M_A^rec[n], Omega_A[n], B_A[n], c_n) | definition |  |  |
| (56) | XI.A Three levels of knowledge | K_prop(p) = sigma_K(p) | definition |  |  |
| (57) | XI.A Three levels of knowledge | K_op(p) = <K_prop(p), Task_p, Completion_p> | definition |  |  |
| (58) | XI.A Three levels of knowledge | K_trans(p) = <K_op(p), Delta Theta, Delta I, Delta U, Delta Action, Persistence, Transport, Viability> | definition |  |  |
| (59) | XI.A Three levels of knowledge | sigma_K(p) = ADMITTED | definition (admission condition) |  |  |
| (60) | XI.A Three levels of knowledge | Completion_p = PASS | definition (admission condition) |  |  |
| (61) | XI.A Three levels of knowledge | z_post in V_A | definition (admission condition) |  |  |
| (62) | XI.A Three levels of knowledge | Defects_{persistence, transport, lineage} <= tau | definition (admission condition) |  |  |
| (63) | XI.B Release without destruction | U_{n+1} = Pi_{U>=0}[(I - D_U) U_n + J_{reinforce,n} - J_{release,n}] | definition |  |  |
| (64) | XI.B Release without destruction | J_release - J_reinforce >= epsilon_release > 0 | definition (sufficient condition) |  |  |
| (65) | XI.B Release without destruction | z_n in V_A,  O_E(z_n) != 0,  \|\|U_n\|\| -> 0 | definition (conditions) |  |  |
| (66) | XI.B Release without destruction | v_free in ker B_I,  B_I v_free = 0,  O_E(v_free) != 0 | definition |  |  |
| (67) | XII.A From readout to readout-of-readout | R_A^{(1)}[n] = O_A(q_A(Z_A[n]); c_n, T_n) | definition |  |  |
| (68) | XII.A From readout to readout-of-readout | R_A^{(2)}[n] = O_A(R_A^{(1)}[n]; c_n, T_n) | definition |  |  |
| (69) | XII.A From readout to readout-of-readout | W_A^R[n] = R_{tau_g}(R_A^{(2)}[n]; T_n) | definition |  |  |
| (70) | XII.B Interruptibility, alternatives, an | R_A^{(1)} != Claim_A != Identity_A;  Identity_A != ActionCandidate_A != CommittedAction_A | law (non-collapse) |  |  |
| (71) | XII.B Interruptibility, alternatives, an | C_A^ret[n] = O_A^ctx(c_{n-h:n}, T_{n-h:n}) | definition |  |  |
| (72) | XII.B Interruptibility, alternatives, an | L_A^acc[n] = O_A^lin(Lambda_A[n], T_n) | definition |  |  |
| (73) | XII.B Interruptibility, alternatives, an | U_A[n] = {u : C_A(u \| Z_A[n], c_n, T_n) = 1} | definition |  |  |
| (74) | XII.B Interruptibility, alternatives, an | F_A^act[n] = O_A^act(U_A[n], Pi_A[n]) | definition |  |  |
| (75) | XII.B Interruptibility, alternatives, an | I_A^resp[n] = 1  <=>  exists u' != u*: u' in U_A[n], t < t_c, Repair(F(Z_A, u')) >= R_min | definition |  |  |
| (76) | XII.B Interruptibility, alternatives, an | A_A^pol[n] = O_A^alt(U_A[n]) | definition |  |  |
| (77) | XII.B Interruptibility, alternatives, an | Pi_A^star[n] = arg min_{u in U_A[n]} J_A(u) | definition |  |  |
| (78) | XII.B Interruptibility, alternatives, an | J_A(u) = E\|\|Res_{A,u}\|\|^2 + lambda_C C(u) + rho R(u) + mu L_repair(u) - nu V(u) | definition |  |  |
| (79) | XII.B Interruptibility, alternatives, an | u_A^repair = arg min_{u in U_A^repair} (\|\|Res_A(F(Z_A,u))\|\|^2 + Cost(u) + RepairLoss(u)) | definition |  |  |
| (80) | XII.C Governance state and operator | G_A^MR[n] = <R_A^{(1)}, R_A^{(2)}, W_A^R, D_A^type, C_A^ret, L_A^acc, F_A^act, I_A^resp, A_A^pol, Pi_A^star, Delta Z_A^r | definition |  |  |
| (81) | XII.C Governance state and operator | G_A^MR[n] = R_{tau_g}(O_A(O_A(q_A(Z_A[n]))), C_A^ret, L_A^acc, F_A, Pi_A) | definition |  |  |
| (82) | XII.C Governance state and operator | Delta_G Pi_A^star = d_Pi(Pi_A^star, Pi_{A,-G}^star) > tau_idle | definition (relevance criterion) |  |  |
| (83) | XII.D Defect vector, capture, and finite | epsilon_G = (epsilon_R1, epsilon_R2, epsilon_W, epsilon_D, epsilon_C, epsilon_L, epsilon_F, epsilon_I, epsilon_A, epsilo | measurement (diagnostic) |  |  |
| (84) | XII.D Defect vector, capture, and finite | Gamma_A = Load_A - Capacity_A | definition |  |  |
| (85) | XII.D Defect vector, capture, and finite | CurrentReadout + SelectionPriority + SelectionStability + SelfReport  =/=>  G_A^MR | law (non-collapse / no-free-governance) |  |  |
| (86) | XII.D Defect vector, capture, and finite | B_G = I(R_A^{(2)}; Z_A) / tau_cA < infinity,  ker O_A^{(2)} != empty | law / measurement |  |  |
| (87) | XIII Human-AI relation and knowledge civ | AIOutput != ClaimIdentity != Evidence;  Evidence != Inference != KnowledgeStatus | law (non-collapse) |  |  |
| (88) | XIII Human-AI relation and knowledge civ | T_{H<-AI} o K_AI ~= K_H o T_C | definition (transport condition, Maker-Checker firewall) |  |  |

### The Standalone Scholar: A Dual-Track Architecture for AI-Native Scholarship — 10.5281/zenodo.22163849 (122 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 2.1 Cumulative advantage without prestig | Credit != EpistemicValue | identity (non-collapse) |  |  |
| (2) | 2.2 Conceptual research as disciplined t | Phenomenon -> ExistingExplanations -> PreciseInadequacy -> Mechanism -> Boundary -> Propositions | definition |  |  |
| (3) | 2.3 Social objectivity, distributed reas | Friction != Fellowship | identity (non-collapse) |  |  |
| (4) | 3.1 Standalone is an infrastructural con | K0_start = I0 + R0 + N0 + P0 | definition (bookkeeping identity, not a psychometric scale) |  |  |
| (5) | 3.1 Standalone is an infrastructural con | E_t = f(Q_t, C_t, V_t, U_t, X_t, T_t) | definition (conceptual/Dr, directional claim only) |  |  |
| (6) | 3.2 Two engines and one bridge | Phenomenon -> TheoreticalInadequacy -> Mechanism -> ConceptualContribution | definition |  |  |
| (7) | 3.2 Two engines and one bridge | Practice -> Observation -> Intervention -> Evidence -> Implementation | definition |  |  |
| (8) | 3.2 Two engines and one bridge | Bridge = 1  <=>  Practice Delta Theory | definition |  |  |
| (9) | 3.3 The lived and positional bridge: con | SelfExperience != GeneralEvidence | identity (non-collapse) |  |  |
| (10) | 3.3 The lived and positional bridge | PosCap = Access x Language x SituatedObservation x TranslationCapacity x Trust | definition/Dr (not a psychometric construct) |  |  |
| (11) | 3.3 The lived and positional bridge | PositionalAccess != PopulationAuthority | identity (non-collapse) |  |  |
| (12) | 3.3 The lived and positional bridge | CommunityTrust != Representativeness | identity (non-collapse) |  |  |
| (13)-(16) | 4 Knowledge states: synthetic formation  | K0: private candidate;  K1: public, timestamped, citable, explicitly provisional;  K2: K1 + independent external frictio | definition |  |  |
| (17) | 4 Knowledge states | K0 -> K1 -> K2 -> K3 | definition |  |  |
| (18) | 4 Knowledge states | DVP =/=> K2 | identity (non-collapse) |  |  |
| (19) | 5.1 The Epistemic Isolation Constraint | mu_H,f approx 0,   mu_A >> mu_H,f | finite_diagnostic / definitional starting condition |  |  |
| (20) | 5.1 The Epistemic Isolation Constraint | EIC => BuildSyntheticFormationInfrastructure | governance definition |  |  |
| (21) | 5.1 The Epistemic Isolation Constraint | AI speed -> synthetic criticism -> K1 -> human correction | definition |  |  |
| (22) | 5.2 Bottleneck inversion | Lambda = min(mu_L, mu_H, mu_E, mu_P, mu_C) | governance definition |  |  |
| (23) | 5.2 Bottleneck inversion | V_c = (H * L * T)^(1/3) | governance definition |  |  |
| (24) | 5.2 Bottleneck inversion | D_e = A * (1 - V_c) | governance definition |  |  |
| (25) | 5.2 Bottleneck inversion | PublicOutputVelocity <= VerificationCapacity | governance definition |  |  |
| (26) | 6.1 Route diversity, not model voting | ManyModels =/=> Independence | identity (non-collapse) |  |  |
| (27) | 6.1 Route diversity, not model voting | DVP* = ReduceCorrelatedError + ExposeResidualDependence + BottomOutWherePossible | governance definition |  |  |
| (28) | 6.2 Frame break, recovery, and anchored  | MechanicalValidity != SemanticValidity | identity (non-collapse) |  |  |
| (29) | 6.2 Frame break, recovery, and anchored  | SourceExistence != ClaimSupport | identity (non-collapse) |  |  |
| (30) | 6.3 Disagreement as information | Disagreement => Resolve v Declare | governance definition |  |  |
| (31) | 7 From friction to fellowship | Friendship != IndependentEvidence | identity (non-collapse) |  |  |
| (32) | 7 From friction to fellowship | Correspondence != PeerReview | identity (non-collapse) |  |  |
| (33) | 7 From friction to fellowship | IntellectualAffinity != Truth | identity (non-collapse) |  |  |
| (34) | 8 Programme legibility: coherence that c | Coh_effective = Coh_latent x L_g | governance definition |  |  |
| (35) | 8 Programme legibility | L_g^proxy = (public assets with a one-click programme path) / (public assets) | definition (proxy measure) |  |  |
| (36) | 8 Programme legibility | K1 -> RelatedAssetDiscovery -> LongerExposure -> K2 opportunity | definition |  |  |
| (37) | 8.1 Association stability and recognitio | A_s = AssociationStrength(Author, Problem) | definition |  |  |
| (38) | 8.1 Association stability and recognitio | A_s(t+1) > A_s(t) | governance definition |  |  |
| (39) | 8.1 Association stability and recognitio | Paper1 -> Theme;  Paper2 -> SameTheme + NewMechanism;  Paper3 -> EmpiricalTest;  Paper4 -> BoundaryExtension | definition |  |  |
| (40) | 9.1 Production criticality is not schola | chi_t = lambda_mint / (lambda_conv + epsilon) | governance definition |  |  |
| (41) | 9.1 Production criticality is not schola | B_t+1 = B_t + M_t - omega * X_t | governance definition |  |  |
| (42) | 9.2 Mint-convert coupling | M_t <= lambda * X_t | governance definition |  |  |
| (43) | 9.3 Back-catalog activation | C_t+1 = (1 - delta) * C_t + G_t + Phi_t(Stock) * I_t * P_t^(r) * S_t | governance definition |  |  |
| (44) | 9.3 Back-catalog activation | ActivationAction != CreditEvent | identity (non-collapse) |  |  |
| (45) | 9.3 Back-catalog activation | d^2 E[C] / dt^2 > 0   can occur while   dM/dt <= 0 | governance definition |  |  |
| (46) | 9.3 Back-catalog activation | dPhi(Stock)/dt > 0 | governance definition |  |  |
| (47) | 9.4 Concept-cluster compounding | FlagshipConcept -> Preprint -> Conference -> Journal -> EmpiricalTest -> ComparativeExtension -> Grant | definition |  |  |
| (48) | 9.4 Concept-cluster compounding | CreditLeverage_i = ( sum_{j=1}^{n} CreditEvent_ij ) / (CoreIntellectualInvestment_i + epsilon) | governance definition |  |  |
| (49) | 10 Credit, provenance, and Goodhart cont | PRC(e_i) in {0, 1} | definition |  |  |
| (50) | 10 Credit, provenance, and Goodhart cont | C_t^valid = sum_i w_i * e_i * PRC(e_i) | governance definition |  |  |
| (51) | 11 Scholarly Credit Velocity and Gradien | V_C = dE[C]/dt ~= (CreditCreation x Retention x Conversion) / H_critical | governance definition |  |  |
| (52) | 11 Scholarly Credit Velocity and Gradien | AIAcceleration -> HumanTimeReallocation | governance definition |  |  |
| (53) | 11 Scholarly Credit Velocity and Gradien | V proportional-to  product_j x_j | definition/Dr (heuristic functional form) |  |  |
| (54) | 11 Scholarly Credit Velocity and Gradien | dV/dx_j = V / x_j | definition (algebraic consequence of eq.53) |  |  |
| (55) | 11 Scholarly Credit Velocity and Gradien | Priority_j = (dV/dx_j) / (MarginalHumanCost_j + epsilon) | governance definition |  |  |
| (56) | 12 Criticality as a control mapping | k_t = nu_t * f_coh,t * L_g,t * p_int,t * m_leg,t * u_conv,t * P_NL,t | definition (diagnostic; explicitly disclaimed as a structural analogy, not a physical law) |  |  |
| (57) | 12.1 Prompt versus delayed channels | beta_D = ( sum_d w_d E_d ) / ( sum_d w_d E_d + sum_p w_p E_p + epsilon ) | governance definition |  |  |
| (58) | 12.1 Prompt versus delayed channels | IncreaseMintRate => beta_D >= beta_min  AND  IntegrityClean  AND  XenonLow  AND  ConversionLogOn | governance definition |  |  |
| (59) | 12.2 Reflectors, moderators, xenon, and  | rho_R = N^ind_{<=6m} / N^cit_{>6m} | governance definition |  |  |
| (60) | 12.2 Reflectors, moderators, xenon, and  | RawSpeed (down-arrow) =/=> V_C (down-arrow) | identity (non-collapse) |  |  |
| (61) | 12.2 Reflectors, moderators, xenon, and  | X_t = 1*(O_sub) + 2*(E_known) + 3*(C_stale) | governance definition |  |  |
| (62) | 12.2 Reflectors, moderators, xenon, and  | BR_t = N^{ind-reuse}_t / N^{terminal}_t | governance definition |  |  |
| (63) | 13 Legitimacy without truth laundering | L_H != Truth,   L_V != Truth | identity (non-collapse) |  |  |
| (64) | 13 Legitimacy without truth laundering | HorizontalGeneration -> EpistemicFriction -> VerticalStrengthening -> ResourceReturn -> HorizontalGrowth | definition |  |  |
| (65) | 14 Readout Universe as meta-governance | M_A[n] = K_A * theta(E[n]) + eta_sel + eta_map + eta_self | definition (inherited from Readout Universe/Lahtee 2026a) |  |  |
| (66) | 14 Readout Universe as meta-governance | M_A[n] != theta(E) | identity (non-collapse) |  |  |
| (67) | 14 Readout Universe as meta-governance | r = A*epsilon - delta,   V = (1/2) * r^T * W * r | definition/Dr |  |  |
| (68) | 14 Readout Universe as meta-governance | ClaimStrength <= EvidenceStrength | governance definition |  |  |
| (69) | 15.1 Why one global route is insufficien | P_local (not subset of) D_AI | definition/Dr (conditional premise) |  |  |
| (70) | 15.1 Why one global route is insufficien | MultiAIConsensus =/=> GeographicCompleteness | identity (non-collapse) |  |  |
| (71) | 15.2 Geographic Distribution Audit | DVP* = DVP + GDA | governance definition |  |  |
| (72) | 15.3 Global strength without identity de | S_G = L x G x M x B x F | definition/Dr (not a psychometric scale) |  |  |
| (73)-(74) | 15.3 Global strength without identity de | DoubleBlind = Bonus;   DoubleBlind != Requirement | identity (non-collapse) |  |  |
| (75) | 15.3 Global strength without identity de | ManuscriptStrength > IdentityDependence | governance definition |  |  |
| (76) | 15.4 Global and Thai tracks | ConversionPlan_i = {Global_i, Thai_i} | definition |  |  |
| (77) | 15.4 Global and Thai tracks | K2,Global != K2,Thai | identity (non-collapse) |  |  |
| (78) | 15.4 Global and Thai tracks | K2,Global + K2,Thai => RouteDiversity (up-arrow) | governance definition |  |  |
| (79) | 16 Thailand as an operational epistemic  | FrictionValue_e = (F_e * O_e * D_e * R_e) / (T_e + C_e + P_e + epsilon) | governance definition |  |  |
| (80) | 16 Thailand as an operational epistemic  | GlobalAsset -> ThaiLegibility -> ThaiFriction | definition |  |  |
| (81) | 17 Open research toolchain as epistemic  | a*_f = argmax_a  FaceIndependence_f(a) | governance definition |  |  |
| (82) | 18.1 Integrity firewall | AI candidate -> OriginalSource -> ClaimMatch -> VerifiedCitation | definition |  |  |
| (83) | 18.3 Survival buffer | Reject -> Objection -> Revision -> Delta Q | definition |  |  |
| (84) | 18.4 Attention-credit separation | A_t != C_t^scholarly | identity (non-collapse) |  |  |
| (85) | 19 Human Mastery, ethics, and creator-ev | H_g = (questions defended without AI) / 10 | definition (governance heuristic) |  |  |
| (86) | 19 Human Mastery, ethics, and creator-ev | InterventionCreator != SoleEvaluator | identity (non-collapse) |  |  |
| (87) | 19 Human Mastery, ethics, and creator-ev | PracticeExperience != PopulationEvidence | identity (non-collapse) |  |  |
| (88) | 20 Portfolio control and defeat conditio | SCRAM = FreezeNewRelease + Correction + ReAudit | governance definition |  |  |
| (89) | 21 An integrated architecture | Phenomenon -> AIExploration -> DVP -> HumanMastery -> Integrity -> K1 -> {Global, Local Friction} -> K2 -> Revision -> K | definition |  |  |
| (90) | 21 An integrated architecture | E[C_{t+k}] > C_t | governance definition |  |  |
| (91) | 21 An integrated architecture | V_C* = (C_Y * Coh_latent * L_g * Conv * Net * I * R * P * S * Ver) / (H_critical * (Debt + Frag + Bias + COI + epsilon)) | definition (deliberately heuristic, not a precision instrument) |  |  |
| (92) | 22 Research propositions and empirical a | P* = argmax_{P_i} [ TheoreticalImportance_i x DiscriminatingPower_i ] | governance definition |  |  |
| (93) | 22 Research propositions and empirical a | ConceptualPaper -> CriticalEmpiricalTest -> TheoryRevision | definition |  |  |
| (94) | 24 Conclusion: from epistemic isolation  | EpistemicPosition = RecognizableProblem + RepeatHumanNodes + CitableAssets + CorrectionHistory | definition |  |  |
| (95) | 24 Conclusion: from epistemic isolation  | CrediblePath = EarlyTimestamp + ExplicitProvisionality + RapidRevision + ExternalFriction + EventualCertification | definition |  |  |
| (96) | Appendix A: Finite diagnostic that motiv | M_attention != M_truth,   M_attention != M_K2 | identity (non-collapse) |  |  |
| (97)-(100) | Appendix B.1 Knowledge-state boundary | K0: private candidate;  K1: K0 + public timestamp, provenance, provisionality;  K2: K1 + substantive external friction;  | definition |  |  |
| (101) | Appendix B.1 Knowledge-state boundary | DVP =/=> K2 | identity (non-collapse) |  |  |
| (102) | Appendix B.2 DVP route packet | MechanicalValidity != SemanticValidity | identity (non-collapse) |  |  |
| (103) | Appendix B.2 DVP route packet | SourceExistence != ClaimSupport | identity (non-collapse) |  |  |
| (104) | Appendix B.4 Preprint-to-human conversio | NoHumanAvailable =/=> ResearchStop | identity (non-collapse) |  |  |
| (105) | Appendix B.4 Preprint-to-human conversio | NoHumanAvailable => DVP -> K1 -> HumanAcquisition | governance definition |  |  |
| (106) | Appendix C Material feasibility and publ | B_year = B_conference + B_ethics + B_software + B_data + B_publication + B_travel | governance definition |  |  |
| (107)-(108) | Appendix C Material feasibility and publ | Prestige =/=> APCApproval;   APCApproval => FieldFit + CreditYield + BudgetFit | governance definition |  |  |
| (109) | Appendix C Material feasibility and publ | MissingResource => ProjectHold | governance definition |  |  |
| (110) | Appendix C.1 Superseded publication-cred | PC_i = JournalQuality_i x ProgrammeFit_i x ContributionStrength_i x UptakePotential_i | definition (superseded) |  |  |
| (111) | Appendix D K2 procurement | Cost_{K2,r} = (Cash_r + lambda_H*H_r + lambda_L*L_r) / (D_r * R_r * I_r + epsilon) | governance definition |  |  |
| (112) | Appendix D K2 procurement | ExpectedK2Yield_j = ( P(Review_j) * Depth_j * Fit_j ) / (Cash_j + Prep_j + Latency_j + epsilon) | governance definition |  |  |
| (113) | Appendix D K2 procurement | EffectiveK2 = Depth x Relevance x Independence | governance definition |  |  |
| (114) | Appendix E.1 Stock pressure and mint-con | chi_t = lambda_mint,t / (lambda_conv,t + epsilon) | governance definition |  |  |
| (115) | Appendix E.1 Stock pressure and mint-con | B_t+1 = B_t + M_t - omega * X_t | governance definition |  |  |
| (116) | Appendix E.1 Stock pressure and mint-con | M_t <= lambda * X_t | governance definition |  |  |
| (117) | Appendix E.1 Stock pressure and mint-con | C_t+1 = (1 - delta) * C_t + G_t + Phi_t(Stock) * I_t * P_t^(r) * S_t | governance definition |  |  |
| (118) | Appendix E.2 Critical human time and WIP | H_planned > H_sustainable => PortfolioShrink | governance definition |  |  |
| (119) | Appendix E.2 Critical human time and WIP | PublicWIP <= 3 | definition (local heuristic guardrail) |  |  |
| (120) | Appendix E.3 Portfolio and project prior | Priority_i = (I_i * N_i * E_i * F_i * Y_i * S_i) / (D_i + C_i + Frag_i + COI_i + epsilon) | governance definition |  |  |
| (121)-(122) | Appendix F AI disclosure and provenance  | DisclosurePenalty =/=> Concealment;   DisclosurePenalty => BetterProvenance + BetterHumanDefence + VenueFit | governance definition |  |  |
| (123) | Appendix F.2 Route-level disclosure | AIContribution != EpistemicResponsibility | identity (non-collapse) |  |  |
| (124) | Appendix H Embedded-practice and positio | NetPractice = P_A - (Co + Bi) | definition (bookkeeping heuristic) |  |  |
| (125) | Appendix H.1 Discovery-justification sep | PracticeObservation -> Hypothesis | definition |  |  |
| (126) | Appendix H.1 Discovery-justification sep | Claim <- Literature + ExternalEvidence + ComparativeEvidence | definition |  |  |
| (127) | Appendix H.1 Discovery-justification sep | InterventionCreator != SoleEvaluator | identity (non-collapse) |  |  |
| (128) | Appendix H.1 Discovery-justification sep | ClaimScope <= SamplingScope | governance definition |  |  |
| (129) | Appendix I.1 Dual-track invariant | ConversionPlan_i = {Global_i, Thai_i} | definition |  |  |
| (130) | Appendix I.1 Dual-track invariant | K2,Global != K2,Thai | identity (non-collapse) |  |  |
| (131) | Appendix I.2 Geographic Distribution Aud | MultiAIConsensus =/=> GeographicCompleteness | identity (non-collapse) |  |  |

### Written by AI. Still True. Knower Fetishism, Epistemic Pedigree, and the Human Face as a B — 10.5281/zenodo.22301202 (16 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| SC | 3. The Possession-Constitution Collapse | SC :  K(S, p) -> Subject(S) | definition (deliberately weak premise) |  |  |
| HSC | 3. The Possession-Constitution Collapse | HSC :  Epi(X, p) -> Knower(X, p) | hypothesis (the collapse the paper rejects) |  |  |
| Def-1 | 3. The Possession-Constitution Collapse | Pre-subjective constraint structure: a worldly state, relation, trace, record, or lawful dependence capable of constrain | definition |  |  |
| Def-2 | 3. The Possession-Constitution Collapse | Possession-Constitution Collapse: occurs when a condition on who can possess knowledge is treated as a condition on what | definition |  |  |
| Prin-1 | 3. The Possession-Constitution Collapse | Role Separation: generation, truth, evidential support, reliability, understanding, possession, endorsement, accountabil | law (non-collapse, named principle) |  |  |
| Prop-1 | 3. The Possession-Constitution Collapse | No transitivity of knowerhood: from the fact that knowledge has a subject it does not follow that every epistemically si | proposition |  |  |
| (RA) | 3.1 The source label is a readout, not a | R_A = O_A(W; Pi_A) | definition |  |  |
| (m-rho) | 3.1 The source label is a readout, not a | m(A) != rho(A) | law (non-collapse) |  |  |
| Prin-2 | 3.1 The source label is a readout, not a | Bridge Burden: any inference from source metadata to a change in epistemic standing must identify the mediating relation | law (named principle) |  |  |
| Prin-3 | 3.1 (Table 1 discussion) | No Bare Pedigree: a source label is epistemically incomplete reporting. The relevant object is not merely who or what pr | law (named principle) |  |  |
| (dCr) | 7. The Epistemic Pedigree Paradox | origin, procedure, dependence, checks, answerability  -->  Delta Cr(p) | definition (functional diagram) |  |  |
| (RPE) | 7. The Epistemic Pedigree Paradox | RPE = Cr(p \| E, R, A, O1) - Cr(p \| E, R, A, O2) | measurement (diagnostic, not a psychological law) |  |  |
| Def-4 | 7. The Epistemic Pedigree Paradox | Residual Provenance Effect: occurs when epistemic assessment changes with provenance after the epistemically relevant pa | definition |  |  |
| Prin-4 | 7. The Epistemic Pedigree Paradox | Provenance Relevance Constraint: provenance may rationally alter epistemic standing insofar as it changes total evidence | law (named principle) |  |  |
| Def-3 | 6. Knower fetishism | Knower fetishism: the treatment of the recognized identity, humanity, credentials, or social standing of a knower as tho | definition |  |  |
| Prin-5 | 10. Institutions after epistemic monarch | Friction, not magic: institutional certification has epistemic force insofar as institutions produce reliable epistemic  | law (named principle) |  |  |

### The Readout Condition: Distinguishability, Access, and Epistemic Warrant — 10.5281/zenodo.22301318 (47 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 1. Introduction | No epistemic discrimination without provenance. | law (governing maxim) |  |  |
| (2) | 2.5 Suhrawardi: selectivity without repr | Representationality != Selectivity | law (non-collapse) |  |  |
| (3) | 3.2 Units and roles | D_Phi(x0) = { d0_x' = (x0, x') : Phi(x') != Phi(x0) } | definition |  |  |
| (4) | 3.2 Units and roles | P(d) = (V_d, E_d, tau_d) | definition |  |  |
| (5) | 4.1 Local contrasts and claim discrimina | Phi : X -> Z | definition |  |  |
| (6) | 4.2 Exact functional case | R : X -> Y | definition |  |  |
| Def-1 | 4.2 Exact functional case | Readout-admissible discrimination: a categorical claim structure Phi: X->Z is readout-admissible relative to R: X->Y whe | definition |  |  |
| (7) | 4.2 Exact functional case | R(x) = R(x')  =>  Phi(x) = Phi(x') | definition |  |  |
| Prop-1 | 4.2 Exact functional case | Factorization: for functions R: X->Y and Phi: X->Z, the following are equivalent: (i) Phi is constant on every fiber of  | proposition (with proof) |  |  |
| Princ-4 | 4.2 Exact functional case | Exact Readout Condition: if a categorical distinction in Phi is licensed by R alone, then Phi must be readout-admissible | law (named principle) |  |  |
| (8) | 4.3 Relational readouts: pointwise licen | N_R(x0) = { x' in X : (x0, x') in I_R } | definition |  |  |
| (9) | 4.3 Relational readouts: pointwise licen | N_R(x0) subseteq Phi^{-1}(z0) | law (named principle) |  |  |
| Prop-2 | 4.3 Relational readouts: pointwise licen | Reduction to the deterministic case: if I_R is induced by a deterministic readout R via x I_R x' <=> R(x)=R(x'), then re | proposition |  |  |
| (10) | 4.4 Stochastic readouts: access audit, n | K* : Y \| X | definition |  |  |
| (11) | 4.4 Stochastic readouts: access audit, n | C = G o K* | law (named principle) |  |  |
| (12) | 4.4 Stochastic readouts: access audit, n | K* != K~ | law (non-collapse) |  |  |
| (13) | 4.4 Stochastic readouts: access audit, n | Lambda_K~(y; x, x') = K~(y\|x) / K~(y\|x') | definition |  |  |
| (14) | 4.4 Stochastic readouts: access audit, n | log[P(x\|y)/P(x'\|y)] = log[P(x)/P(x')] + log Lambda_K~(y; x, x') | identity |  |  |
| (15) | 5.2 Identification ladder | A0 subseteq A1 subseteq ... subseteq Am | definition |  |  |
| (16) | 5.2 Identification ladder | l(d0_x') = min{ j : x' not in Gamma_j } | definition (identification-ladder audit) |  |  |
| Def-2 | 5.1 Typed augmentation grammar | Access augmentation: a new target-sensitive route is added to the epistemic basis (e.g. a second measurement, testimony, | definition |  |  |
| Def-3 | 5.1 Typed augmentation grammar | Contrast or relevance operation: the contrast domain changes, X -> X' subseteq X; a restriction selected after inspectin | definition |  |  |
| Def-4 | 5.1 Typed augmentation grammar | Inferential commitment: a model, prior, theory, bridge principle, calibration assumption, or other rule changes what can | definition |  |  |
| Def-5 | 5.1 Typed augmentation grammar | Decision-policy augmentation: a loss function, threshold, utility, or institutional rule maps an epistemic state into an | definition |  |  |
| Princ-7 | 5.3 The E-A-D form of the Readout Condit | E: provenance existence -- for every epistemically load-bearing claim distinction d, P(d) is nonempty or the claim is ex | law (named principle) |  |  |
| Princ-8 | 5.3 The E-A-D form of the Readout Condit | A: provenance attribution -- if the public or doxastic attribution map credits distinction d to source S, then S must pa | law (named principle) |  |  |
| Princ-9 | 5.3 The E-A-D form of the Readout Condit | D: provenance disclosure -- every non-source node on an essential dependency path to d must remain declared or recoverab | law (named principle) |  |  |
| Def-6 | 5.4 Epistemic overreach and silent lift | Epistemic overreach: a claim-level distinction exhibits epistemic overreach when it lacks an adequate provenance path, i | definition |  |  |
| Def-7 | 5.4 Epistemic overreach and silent lift | Silent lift: with lambda(d) the actual essential dependency set of distinction d and lambda-hat(d) the represented depen | definition |  |  |
| (17) | 5.5 Defeater routing on the provenance D | Ess(d) = intersection over p in Pi(d) of V(p) | definition |  |  |
| (18) | 5.5 Defeater routing on the provenance D | Pi_{Delta v}(d) = { p in Pi(d) : v not in V(p) } | proposition (with proof) |  |  |
| Cor-1 | 5.5 Defeater routing on the provenance D | Misrouted defeat under silent lift: if the symmetric difference between the actual essential set Ess(d) and the represen | corollary |  |  |
| (19) | 6.1 Deterministic composition | X --R1--> Y1 --R2--> Y2 --...--> Yn | definition |  |  |
| (20) | 6.1 Deterministic composition | ker R1 subseteq ker R1:n | corollary |  |  |
| (21) | 6.2 Stochastic composition | I(X; Y_{j+1}) <= I(X; Y_j) | identity |  |  |
| (22) | 6.3 Calibration and the model of the rea | R* != R~,   K* != K~ | law (non-collapse) |  |  |
| (23) | 8.1 Worked audit I: a positive diagnosti | P(D \| +) = 0.90(0.01) / [0.90(0.01) + 0.09(0.99)] ~= 0.0917 | measurement (worked example) |  |  |
| (24) | 8.1 Worked audit I: a positive diagnosti | (y, K~) + pi + L --> belief/action | definition (diagram) |  |  |
| (25) | 8.2 Worked audit II: AI-assisted inferen | C_D = G_D o K* | identity (worked example) |  |  |
| Prop-4 | 8.2 Worked audit II: AI-assisted inferen | Retained-record route: if a supposedly fixed background corpus contains a current-case-specific retained record D(x) tha | proposition |  |  |
| (26) | 9.1 What is actually new | distinction-token audit + source licensing + identification layer + typed provenance DAG + E-A-D norms + defeater routin | definition (novelty claim) |  |  |
| (27) | 11. Conclusion | What does the attributed source distinguish? | law (governing questions) |  |  |
| (28) | 11. Conclusion | Which distinction does the claim add? | law (governing questions) |  |  |
| (29) | 11. Conclusion | Which provenance path makes that addition licit? | law (governing questions) |  |  |
| (30) | 11. Conclusion | No epistemic discrimination without provenance. | law (governing maxim) |  |  |
| (31) | A.2 Pointwise relational reduction | N_R(x0) = R^{-1}(R(x0)) | identity |  |  |
| (32) | A.3 Distinction-level attribution map | lambda-hat : D_Phi(x0) -> 2^V | definition |  |  |

### From Problem to Hypothesis: Dynamic Semantic Mobility, Bounded Knowers, and the Readout-Di — 10.5281/zenodo.22307148 (54 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 4.1 Readout-not-truth and problem format | M_A[n] = K_A * theta(E[n]) + eta_sel + eta_map + eta_self | definition |  |  |
| (2) | 4.1 Readout-not-truth and problem format | M_A[n] != theta(E[n]) | identity (non-collapse) |  |  |
| (3) | 4.1 Readout-not-truth and problem format | r_t = A_t*epsilon_t - delta_t,  V_t = (1/2) r_t^T W_t r_t | definition |  |  |
| (4) | 4.1 Readout-not-truth and problem format | P_t := Retain_{Pi_P}(r_t) | definition |  |  |
| (5) | 4.1 Readout-not-truth and problem format | Q_{Pi_Q}(P_t) = d_{Q,t} | definition |  |  |
| (6) | 4.2 Meaning after readout | S_{A,t} := q_{sem,A,Omega_t}(Z_t) | definition |  |  |
| (7) | 4.2 Meaning after readout | S_{A,t+1} != S_{A,t}  is admissible and expected | identity (non-collapse) |  |  |
| (8) | 4.3 Reader equivalence | x ~_{O_D} y  <=>  O_alpha(x) = O_alpha(y)  for all alpha | definition |  |  |
| (9) | 5.1 A provenance-typed distinction ledge | L_{Q,t} = {(d, chi_t(d))} | definition |  |  |
| (10) | 5.1 A provenance-typed distinction ledge | chi_t(d) in {FORCED, DERIVED, POSITED, BORROWED, OPEN} | definition |  |  |
| (11)-(12) | 5.2 Transport with explicit defect accou | Def_Q(T) := {d in L_{Q,t} : the declared readout of d is lost under T} | definition |  |  |
| (13) | 5.2 Transport with explicit defect accou | Delta_O(d; s, T, Pi) := \|\| O^out_{A,Pi}(T(s (+) d)) - O^out_{A,Pi}(T(s)) \|\|_G | definition |  |  |
| (14) | 5.2 Transport with explicit defect accou | lambda^{RG}_{A,T,Pi}(d;s) := Delta_O(d;s,T,Pi) / \|\|d\|\|^{in}_G | definition (diagnostic) |  |  |
| (15) | 5.3 Reachability is not accessibility | 0 <= kappa_{A,t,Q}(s'\|s) <= 1 | definition |  |  |
| (16) | 5.3 Reachability is not accessibility | mu_{A,t}(pi\|Q) := product_{k=0}^{m-1} kappa_{A,t,Q}(s_{k+1}\|s_k) | definition |  |  |
| (17) | 5.3 Reachability is not accessibility | Acc_{A,t}(H\|Q) := sup_{pi: Gamma_Q(pi)=H} mu_{A,t}(pi\|Q) | definition |  |  |
| (18) | 5.3 Reachability is not accessibility | reachable(H) = 1  =/=>  Acc(H\|Q) is high | proposition (non-collapse) |  |  |
| (19) | 5.4 History-shaped access: attraction an | a_{Q,t}(e) := [ Phi_{Q,t}(s) - Phi_{Q,t}(s') ]_+   for oriented edge e: s -> s' | definition |  |  |
| (20) | 5.4 History-shaped access: attraction an | m_{t+1}(e) = rho*m_t(e) + 1[e_t=e],  0<=rho<1 | definition | 13 |  |
| (21) | 5.4 History-shaped access: attraction an | kappa^{(0)}_{t+1}(e\|Q) propto kappa_t(e\|Q) * exp[ beta*a_{Q,t}(e) + mu*m_t(e) - nu*c_{A,t,Q}(e) + xi_t(e) ] | hypothesis [Open] | 14 |  |
| (22) | 5.5 Historical structural analogy, not e | wholesome =/= true,  unwholesome =/= false | identity (non-collapse) |  |  |
| (23) | 5.6 Restructuring and insight | D^{sem}_t := < q_{sem,t}, L_{Q,t}, G_t, kappa_t, Pi_{Q,t} > | definition |  |  |
| (24) | 5.6 Restructuring and insight | B_t : D^{sem}_{t-} -> D^{sem}_{t+} | definition |  |  |
| (25) | 5.6 Restructuring and insight | Acc_{t+}(H*\|Q) >> Acc_{t-}(H*\|Q) | measurement (candidate signature) |  |  |
| (26) | 5.4 (thesis restatement) | Imagination is mobility inside finitude. | definition (thesis) |  |  |
| (27) | 6.1 Generation, retention, and warrant a | H~_{A,t}(Q) := {(H, Acc_{A,t}(H\|Q)) : H retained by Gamma_Q} | definition |  |  |
| (28) | 6.1 Generation, retention, and warrant a | A_i = A_t + Delta_{H_i} A | definition |  |  |
| (29) | 6.1 Generation, retention, and warrant a | W_t(H_i) = W(delta_{<=t}, independence, defects, calibration) | definition |  |  |
| (30)-(32) | 6.1 Generation, retention, and warrant a | a_{Q,t}(H_i) high =/=> W_t(H_i) high;  m_t(H_i) high =/=> W_t(H_i) high;  Acc(H_i) high =/=> W_t(H_i) high | identity (non-collapse, [Dr]) |  |  |
| (33) | 6.1 Generation, retention, and warrant a | Attraction != Warrant,  Momentum != Truth | identity (non-collapse) |  |  |
| (34)-(35) | 6.2 Readout-discriminable hypothesis cla | H_i ~_{O_D,U_{D,t},L} H_j  <=>  delta-hat_i(u) = delta-hat_j(u)  for all u in U_{D,t} over the declared horizon | definition |  |  |
| (36) | 6.2 Readout-discriminable hypothesis cla | H^{disc}_{A,t}(Q) := {H : (H,Acc(H\|Q)) in H~_{A,t}(Q)} / ~_{O_D,U_{D,t},L} | definition |  |  |
| (37) | 6.2 Readout-discriminable hypothesis cla | D_H(t) := \| H^{disc}_{A,t}(Q) \| | definition |  |  |
| (38) | 6.2 Readout-discriminable hypothesis cla | H_i ~_{U_{D,t}} H_j  =/=>  H_i ~_{U_{D,t+1}} H_j | identity (non-collapse) |  |  |
| (39) | 7 Bounded Knower: Epistemic Standing Is  | K_{A,t}(Q, D; O_D, Pi_t, R_t) | definition |  |  |
| (40) | 7 Bounded Knower: Epistemic Standing Is  | K_{A,t}(Q1,D1;...) =/=> K_{A,t}(Q2,D2;...) | identity (non-collapse) |  |  |
| (41) | 7 Bounded Knower: Epistemic Standing Is  | K_{A,t}(Q,D;...) =/=> K_{A,t+1}(Q,D;...) | identity (non-collapse) |  |  |
| (42) | 7 Bounded Knower: Epistemic Standing Is  | social/epistemic label  =/=>  unconditional standing across Q, D, t | proposition [Dr] (corollary) |  |  |
| (43) | 8 Collective Epistemic Systems Without a | Z_{G,t} := < {Z_{A_i,t}}_{i=1}^n, T_{G,t}, A_{G,t}, C_{G,t} > | definition |  |  |
| (44) | 8 Collective Epistemic Systems Without a | S_{G,t} := q_{sem,G,Omega_{G,t}}(Z_{G,t}) | definition |  |  |
| (45) | 8 Collective Epistemic Systems Without a | m^G_{t+1}(e) = rho_G * m^G_t(e) + sigma_{G,t}(e) | definition |  |  |
| (46) | 8 Collective Epistemic Systems Without a | W_{G,t}(H) = W_G(R_{G,<=t}, independence, defects, calibration, objection channels) | definition |  |  |
| (47) | 8 Collective Epistemic Systems Without a | a_G up  =/=>  W_G(H) up;   m_G up  =/=>  truth | identity (non-collapse) |  |  |
| (48) | 9 Discrimination, Record, and Revision | delta-hat_i(u*) != delta-hat_j(u*) | definition |  |  |
| (49) | 9 Discrimination, Record, and Revision | delta*_{t+1} = O_D(Z_{t+1}; u*) | definition |  |  |
| (50) | 9 Discrimination, Record, and Revision | r*_i = delta-hat_i(u*) - delta*_{t+1} | definition |  |  |
| (51) | 9 Discrimination, Record, and Revision | (Z_{t+1}, A_{t+1}, D^{sem}_{t+1}) = Update(Z_t, A_t, delta*_{t+1}, Pi_R) | definition |  |  |
| (52) | 10 The Final Architecture | X_{A,t}(Q) := B_t(S_{A,t}, L_{Q,t}, Pi_{Q,t}) | definition |  |  |
| (53) | 10 The Final Architecture | H~_{A,t}(Q) := Gamma_Q[ WReach^{kappa}_{A,t,Q}[X_{A,t}(Q)] ] | definition |  |  |
| (54) | 10 The Final Architecture | H^{disc}_{A,t}(Q) = H~_{A,t}(Q) / ~_{O_D,U_{D,t},L} | definition |  |  |
| (55) | 11 Human-AI Operator Attribution | alpha_t(o) in {HUMAN, AI, JOINT} | definition |  |  |
| (56) | 11 Human-AI Operator Attribution | o in Omega = {q_sem, Pi_P, Pi_Q, B, a, m, kappa, Gamma_Q, U_D, Pi_R} | definition |  |  |
| (57) | 11 Human-AI Operator Attribution | S^{epi}_H = (c_P, c_Q, c_H, c_D, c_R) | definition |  |  |
| (58) | 16 Conclusion | Attraction != Accessibility != Warrant != Truth | identity (non-collapse law) |  |  |

### Knowledge Topology and the First Passage to Usable Hypotheses: A Readout Theory of Discove — 10.5281/zenodo.22307561 (15 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 3.1 Knowledge organization is a domain r | G^K_{A,t}(Q) = < V_{A,t}, E_{A,t}, omega_{A,t,Q}, chi_{A,t} > | definition |  |  |
| (2)-(3) | 3.2 From access to a usable hypothesis | U_{A,t}(Q) = { [H] in H^disc_{A,t}(Q) : W_t(H) >= w0,  exists u in U_{D,t} with Delta_u(H,H') > 0 for at least one live  | definition |  |  |
| (4) | 3.2 From access to a usable hypothesis | usable != true | identity (non-collapse) |  |  |
| (5) | 4.1 First-passage time | tau_U = inf{ n >= 0 : Gamma_Q(S_n) in U_{A,n}(Q) } | definition |  |  |
| (6) | 4.1 First-passage time | T_U(G^K, Q) = E[ tau_U \| G^K, Q ] | definition |  |  |
| (7) | 4.2 Direction is a first-hit distributio | pi^{first}_{G^K,Q}(C_j) = Pr[ H_{tau_U} = C_j \| G^K, Q ] | definition |  |  |
| (8) | 4.2 Direction is a first-hit distributio | D_dir = JS( pi_1^{first}, pi_2^{first} ) | definition (finite diagnostic) |  |  |
| H1 | 5 Central Hypothesis and Propositions (H | G_1^K =/=~ G_2^K  =>  L(tau_U \| G_1^K, Q) =/=~ L(tau_U \| G_2^K, Q) | hypothesis [Open] |  |  |
| (9) | 5.2 H3 - Efficiency-diversity tradeoff | P_Q(G^K) = < T_U, H(pi^{first}), D_H, W, C_escape > | definition |  |  |
| H2 | 5.1 H2 - Organization-to-direction | pi^{first}_{G_1^K,Q} != pi^{first}_{G_2^K,Q} | hypothesis [Open] |  |  |
| (10) | 7.4 Experiment D: graph-structured AI co | graph organization -> Delta T_U != 0 | hypothesis/measurement (prediction) |  |  |
| (11) | 7.4 Experiment D: graph-structured AI co | graph organization -> D_dir > 0 | hypothesis/measurement (prediction) |  |  |
| (12) | 8.1 Speed is not warrant | T_U down  =/=>  W(H) up  =/=>  truth | identity (non-collapse) |  |  |
| (13) | 9 Relationship to the Companion Theory | G^K --> (tau_U, pi^{first}) --> U | definition (schematic) |  |  |
| (14) | 13 Conclusion | G^K => ( L(tau_U), pi^{first} ) | hypothesis (central proposal, [Open]) |  |  |

### Before Evidence Can Decide: Candidate-Set Formation, Discovery Routing, and Unconceived Al — 10.5281/zenodo.22307564 (7 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 2 A Minimal Cycle, Not a Solution | Psi_{E,t,Q} : H^disc_{E,t}(Q) -> C_{E,t}(Q) | definition |  |  |
| (2) | 2 A Minimal Cycle, Not a Solution | Appraise_t : ( C_{E,t}(Q), delta_{<=t}, Pi_t ) -> R_t | definition |  |  |
| (3) | 2 A Minimal Cycle, Not a Solution | H not in C_{E,t}(Q)  =>  H receives no comparative appraisal at cycle t | identity (definitional consequence) |  |  |
| (4) | 2 A Minimal Cycle, Not a Solution | delta_{t+1} -> B_{t+1} -> C_{E,t+1}(Q') | definition |  |  |
| (5) | 2 A Minimal Cycle, Not a Solution | C_t -> Appraise_t -> delta_{t+1} -> B_{t+1} -> C_{t+1} | definition |  |  |
| (Q5, unlabeled) | 4.5 Q5. What is the collective candidate | C_{G,t} = union_i C_{A_i,t}  ? | hypothesis (posed then rejected as insufficient) [Open] |  |  |
| (6) | 11 Conclusion | Question -> Candidate-set formation -> Appraisal -> Record -> Candidate-set revision | definition (schematic) |  |  |

### Rigour Without Infrastructure: Three Propositions on Claim-Card Discipline as a Substitute — 10.5281/zenodo.22307841 (4 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (unnumbered, Sec.1) | 1 Problem Before Observation | R_A = O_A(W; Pi_A) != W | definition (readout-not-truth notation, inherited from Readout Universe/Readout Genesis) |  |  |
| (unnumbered, Sec.3.3) | 3.3 Existence-Attribution-Disclosure and | mechanical validity != semantic validity | identity (non-collapse) |  |  |
| (unnumbered, Sec.8.1, disclaimer D-DVP-NOT-K2) | 8.1 Knowledge state / D-DVP-NOT-K2 | DVP != K2 | identity (non-collapse) |  |  |
| (unnumbered, Sec.9 / Appendix disclaimer D-AUTHORSHIP) | 9 AI-assistance disclosure / D-AUTHORSHI | AIContribution != EpistemicResponsibility | identity (non-collapse) |  |  |

### State of Evidence for the Readout Hypothesis-Generation Programme: A Shared Evidence Regis — 10.5281/zenodo.22308066 (7 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (unnumbered, Sec.1) | 1 Purpose and Evidence Coding (Non-colla | neighboring evidence != formal-variable validation != truth of the integrated theory | identity (non-collapse rule) |  |  |
| (1) | 4 What the Literature Jointly Supports | reachability != accessibility | identity (non-collapse) |  |  |
| (2) | 4 What the Literature Jointly Supports | speed != quality/warrant | identity (non-collapse) |  |  |
| (3) | 4 What the Literature Jointly Supports | AI output volume != epistemic diversity | identity (non-collapse) |  |  |
| (unnumbered, Sec.4) | 4 What the Literature Jointly Supports ( | Attraction != Accessibility != Warrant != Truth | identity (non-collapse) / conceptual typing rule, not yet decomposed |  |  |
| (unnumbered, Sec.3.4) | 3.4 Stage D: hypothesis timing, usabilit | generation speed != hypothesis quality | identity (non-collapse), OBSERVED/MODERATE evidence support |  |  |
| (4) | 3.6 Stage F / 5.2 Paper II: knowledge to | G1K != G2K => L(tau_U \| G1K, Q) != L(tau_U \| G2K, Q) | hypothesis [Open] (Paper II H1-H2, requires randomized content-matched topology experiment) |  |  |

### The Epistemic Chain Reaction: Human-AI Multiplication from Questions to Readout-Distinguis — 10.5281/zenodo.22308072 (20 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 3.1 Human question as retained seed | Q^{AI}_{t+1} = Decompose_AI(Q_{H,t}, R_{<=t}, Pi_H) | definition |  |  |
| (2) | 3.2 Parallel semantic transport | T_AI = { T_lit, T_data, T_analogy, T_cross, T_counter, T_model, ... } | definition |  |  |
| (3) | 3.3 Candidate generation is not multipli | H^{disc}_{t+1} = H~_{t+1} / ~_{D,t} | definition |  |  |
| (4) | 3.3 Candidate generation is not multipli | U_{t+1} = Gate( H^{disc}_{t+1} ; W >= w0, provenance, testability ) | definition |  |  |
| (5) | 3.3 Candidate generation is not multipli | usable for propagation != true | identity (non-collapse) |  |  |
| (6) | 4 The Epistemic Multiplication Factor | New_{t+1} = U_{t+1} \ (union_{s<=t} U_s) | definition |  |  |
| (7) | 4 The Epistemic Multiplication Factor | k_epi(t) = \|New_{t+1}\| / max(1, \|F_t\|) | definition |  |  |
| (8) | 4 The Epistemic Multiplication Factor | k_epi < 1 : contractive frontier | definition |  |  |
| (9) | 4 The Epistemic Multiplication Factor | k_epi ~= 1 : roughly critical frontier | definition |  |  |
| (10) | 4 The Epistemic Multiplication Factor | k_epi > 1 : expanding frontier | definition |  |  |
| (11) | 5.3 A synergy quantity | Sigma_{H+AI} = D^{use}_{H+AI}(B,Q) / max{ D^{use}_H(B,Q), D^{use}_{AI}(B,Q), 1 } | definition (finite diagnostic) |  |  |
| (12) | 6 Why Maximum Delegation Is Not Maximum  | more AI output != more epistemic diversity;  more epistemic diversity != better warrant | identity (non-collapse) |  |  |
| (13)-(15) | 7 A Proposed Human-AI Chain-Reaction Wor | P^H_t -> Q_{H,t} --Decompose_AI--> Q^{AI}_{t+1} --T_AI--> H~_{t+1} --/~_{D,t}--> H^{disc}_{t+1} --Gate--> U_{t+1} --Spaw | definition (schematic) |  |  |
| (16) | 8.1 H1 - Productive multiplication | D^{use}_{H+AI,chain} > max{ D^{use}_H, D^{use}_{AI,1shot}, D^{use}_{AI,auto} } | hypothesis [Open] |  |  |
| (17) | 8.2 H2 - First-passage acceleration | T_U^{H+AI,chain} < T_U^H | hypothesis [Open] |  |  |
| (18) | 10 Relationship to Papers I-III | Question -> bounded semantic mobility -> H^{disc} | definition (schematic, cites Paper I) |  |  |
| (19) | 10 Relationship to Papers I-III | G^K -> ( L(tau_U), pi^{first} ) | definition (schematic, cites Paper II) |  |  |
| (20) | 10 Relationship to Papers I-III | H^{disc} --Psi--> C_t --appraisal--> delta_{t+1} | definition (schematic, cites Paper III) |  |  |
| (21) | 10 Relationship to Papers I-III | Q^H -> AI branching -> readout classes -> gated frontier -> new questions / hypotheses | definition (schematic) |  |  |
| (22) | 13 Conclusion | Question -> Branches -> Distinct Hypotheses -> Gates -> New Questions -> ... | definition (schematic) |  |  |

### Epistemic Fusion or Epistemic Tunnel: A Phenomenology-Anchored, Global-Literature-Constrai — 10.5281/zenodo.22331922 (29 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| CN-1 | 1. Claim Types, Evidence, and Legitimate | D > 0, R > 0, A > 0 (constitutive necessities: Difference, Resistance, Agency). | hypothesis/Open |  |  |
| EF-01 | 3. Problem 1 - entry state | H0 = (P0, M0, U0, E0, Φ0), where the human declares the problem, current model, unknowns, independent evidence, and a ch | definition |  |  |
| EF-02 (Repair 1) | 3. Problem 1 - Repair 1: Baseline withou | H0* = (P0, M0, U0, E0, Φ0, κ0), where κ0 is the human's declared confidence in the pre-AI model. | definition |  |  |
| EF-03 (Repair 1) | 3. Problem 1 - Repair 1 | ENTRY_{H→AI} = H0* ∧ V0 ∧ C0 ∧ R*, where V0 is verification intent, C0 the candidate-status contract, R* a precommitted  | definition |  |  |
| EF-04 | 4. Problem 2 | AI(Q) = K_like, K_like ≠ K_validated. | law |  |  |
| EF-05 | 4. Problem 2 | K_like → K_assumed. | law |  |  |
| EF-06 (Repair 2) | 4. Problem 2 - Repair 2: status as state | K_like --check--> K_checked --independent support--> K_supported --declared warrant criterion V*--> K_validated\|V*. | proposition |  |  |
| EF-07 (Repair 3) | 5. Problem 3 - Repair 3: count equivalen | D_s^eff = \|C_s / ∼_R\|, d_s = D_s^eff / \|C_s\|. | measurement |  |  |
| EF-08 (Repair 4) | 6. Problem 4 - Repair 4: resistance qual | R_s^ep = ρ(I_s, V_s, Q_s); U_s^R = u(C_s^v, T_s^v, A_s^v), where I_s = independence from generative loop, V_s = practica | proposition |  |  |
| EF-09 (Repair 4) | 6. Problem 4 - Repair 4 | R_s^ex = ψ(R_s^ep, U_s^R). | proposition |  |  |
| EF-10 | 6. Problem 4 | Resistance quality ≠ resistance accessibility. | law |  |  |
| EF-11 (Repair 5) | 7. Problem 5 - Repair 5 | K_s = (κ0, κ1, W0, W1), where W_t is the best available task-relative warrant/readout of correctness. | measurement |  |  |
| EF-12 (Repair 5) | 7. Problem 5 | Calibration error ≈ N^{-1} Σ_i (κ_i − y_i)^2, where y_i are repeated objective outcomes. | measurement |  |  |
| EF-13 | 8. Problem 6 | H_{s,t} → AI_{s,t} → H_{s,t+1} → AI_{s,t+1} → ⋯ | definition |  |  |
| EF-14 | 8. Problem 6 - finite history scores | m^H_{s,n+1}(e) = λ_H m^H_{s,n}(e) + 1[e_{s,n}=e]; m^AI_{s,n+1}(e) = λ_AI m^AI_{s,n}(e) + 1[e_{s,n}=e]. | measurement |  |  |
| EF-15 (Repair 6) | 8. Problem 6 - Repair 6 | P(e_{t+1} \| X_t, H_{<t}) ≠ P(e_{t+1} \| X_t). | hypothesis/Open |  |  |
| EF-16 | 8. Problem 6 - finite reciprocal amplifi | χ_recip[s,n,L] = \|D_recip[s,n,L]\| / \|Σ[s,n]\|. | measurement |  |  |
| EF-17 | 9. Problem 7 | Exposure ≠ Retention ≠ Improvement. | law |  |  |
| EF-18 (Repair 7) | 9. Problem 7 - Repair 7 | Y^return_{s+Δ} = (R_rec, R_disc, T_new, Q_next). | measurement |  |  |
| EF-19 (Repair 7) | 9. Problem 7 - Repair 7 | RET = (P^post_{H,AI} − P^pre_{H,AI}) − (P^post_{H,C} − P^pre_{H,C}). | measurement |  |  |
| EF-20 | 10. Problem 8 | G_s = g(k_s, d_s, v_s, p_s, r_s, 1−f_s, a_s); T_s = h(c_s, f_s, b_s, o_s); Δ_s = G_s − T_s. | definition |  |  |
| EF-21 | 10. Problem 8 | G_s = g(· \| Θ_s, Π_s); T_s = h(· \| Θ_s, Π_s). | definition |  |  |
| EF-22 (Repair 8) | 10. Problem 8 - Repair 8 | η_s > 0, Δ_s > 0 ⇒ durable expansion; η_s > 0, Δ_s < 0 ⇒ durable epistemic tunnel. | proposition |  |  |
| EF-23 | 11. Problem 9 | AUG_s = P_s^joint − P_s^H; SYN_s = P_s^joint − max(P_s^H, P_s^AI); RET_s = ΔP^return_{H,s+Δ}. | definition |  |  |
| EF-24 (Repair 9) | 11. Problem 9 - Repair 9 | J*_s = (AUG_s, SYN_s, RET_s). | definition |  |  |
| EF-25 | 12. Problem 10 | Θ_s = (C_s, U_s, V_s, T_s, Δ^{AI−H}_s), where C_s = task complexity, U_s = uncertainty, V_s = practical verifiability, T | definition |  |  |
| EF-26 (Repair 10) | 12. Problem 10 - Repair 10 | G_s = g(k,d,v,p,r,1−f,a \| Θ_s, Π_s); T_s = h(c,f,b,o \| Θ_s, Π_s). | proposition |  |  |
| EF-27 | 13. Revised Problem-First Architecture | H0* → K_like → D^eff → R^eff → H↔AI → χ_recip → η → (G−T \| Θ,Π) → Y^return → J*. | proposition |  |  |
| NCL-14 | 14. Revised Non-Collapse Laws | AI-first fluency ≠ human baseline; explanation ≠ verification; resistance quality ≠ resistance accessibility; uncertaint | law |  |  |

### CTSA Human-Return Readout: A Session-Boundary Measurement Architecture for Retained Human  — 10.5281/zenodo.22339909 (12 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| CTSA-01 | 5.1 Retained difference before semantic  | Δ^ret_H = R_Q(S^post_H) − R_Q(S^pre_H), where R_Q is a declared reader/question and S^pre_H, S^post_H are bounded task-r | definition |  |  |
| CTSA-02 | 5.2 Meaning, persistence, and truth rema | AI(Q) = K_like, K_like ≠ K_validated\|V*. | law |  |  |
| CTSA-03 | 7.1 Where workflow belongs | C → T → Workflow → S → A → C′. | proposition |  |  |
| CTSA-04 | 9. The Full Human-Return Audit | R_H = ⟨G_CTSA, L, M, P, W, Δ_dir⟩. | definition |  |  |
| CTSA-05 | 10. Session-Boundary Architecture | Frozen Human baseline → K_like → Difference/Resistance → H↔AI → Retention gate → CTSA Return Profile → Unaided Return Te | proposition |  |  |
| NCL-10 | 10. Session-Boundary Architecture (prese | AI fluency ≠ human baseline; explanation ≠ verification; output count ≠ epistemic diversity; exposure ≠ retention ≠ impr | law |  |  |
| H1 | 12. Hypotheses and Legitimate Defeaters | Incremental Readout Hypothesis [Open]: a CTSA Return Profile will explain reproducible variance in delayed unaided human | hypothesis/Open |  |  |
| H2 | 12. Hypotheses and Legitimate Defeaters | Partial Dissociation Hypothesis [Open]: Conceptual, Tool-Selection, Skill-Execution, and Alternative-Generation returns  | hypothesis/Open |  |  |
| H3 | 12. Hypotheses and Legitimate Defeaters | Return-vs-Exposure Prediction [Externally constrained]: items visible only while AI support is present will predict assi | hypothesis/Open |  |  |
| H4 | 12. Hypotheses and Legitimate Defeaters | Gain/Loss Asymmetry Hypothesis [Open]: positive CTSA gain can coexist with negative loss in previously accessible routes | hypothesis/Open |  |  |
| H5 | 12. Hypotheses and Legitimate Defeaters | Recombination Hypothesis [Open]: CTSA gains will sometimes interact compositionally (new Concept improves Tool selection | hypothesis/Open |  |  |
| H6 | 12. Hypotheses and Legitimate Defeaters | Regulation/Direction Hypothesis [Open]: equal gross CTSA gains will yield different later corrigibility depending on met | hypothesis/Open |  |  |

### glosa — Rigour Without Infrastructure: A Standalone Scholar Methodology for Human–AI Knowl — 10.5281/zenodo.22340255 (0 equations)

_No numbered equations ()._

### Human Learning as Epistemic Architecture: A Method for Word Mapping, Life-Concept Graphs,  — 10.5281/zenodo.22341297 (0 equations)

_No numbered equations (Checked exhaustively (full pdftotext, both plain and -layout modes, 51 pages, all sections read/scanned): this paper contains ZERO LaTeX-style numbered or boxed mathematical equations. It is a qualitative methods/pedagogy paper. Across the entire document there is exactly one algebraic-looking line in the whole text -- a prose identity the paper itself frames rhetorically, not as a formal equation: 'success = external recognition' -- and the paper's only recurring formal-looking objects are unnumbered prose pipeline/arrow diagrams (e.g. 'AI: data -> tokens -> embeddings -> relations -> retrieval -> evaluation -> update' vs 'Human learning: experience -> lived words -> meaning maps -> life-concept graphs -> retrieval-augmented inquiry -> constraint testing -> revision -> responsible action'; 'subject -> relation -> object' for life-concept-graph triples; 'encounter -> friction -> branching -> validation -> integration' for reflective dissonance; and an extended end-to-end pipeline 'word -> pre-reflective meaning -> source map -> meaning map -> semantic neighborhood -> life-concept graph -> retrieval -> constraint test -> reflective dissonance -> revision -> problem-context -> tools & workflow -> deliberate practice -> skill -> real problems -> feedback -> revision of map'). These are illustrative process diagrams and YAML-style worksheet templates (life_concept_graph triples, claim_status, constraint_test), not numbered/boxed propositions, definitions, theorems, or non-collapse laws with defined operators the way Experience Is the Human LoRA or Experience Is Meaning-Giving have. Master Equation River v1.4 confirms this: \citep{human_learning} is cited only descriptively (Sec. 'programme' list, Table 1 lineage) and is never attached via a \Src tag to any numbered master-river equation (eq.1-79); no symbol or pipeline from this paper appears in main.tex. Per the task instruction, a chapter with no numbered equations gets an empty array and this note; nothing has been invented to fill it.)._

### Experience Is Meaning-Giving: A Strong-Form Readout-Retention Theory of Phenomena, Resonan — 10.5281/zenodo.22357744 (29 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| EMG-01 | 6. Readout-Native Formalization | r_n = R_H(x_n \| H_n, c_n) | definition | 1 |  |
| EMG-02 | 6. Readout-Native Formalization | mu_n = Psi_H(r_n, H_n, c_n, Q_n) | definition | 2 |  |
| EMG-03 | 5.1 Meaning plurality without dilution / | mu_n = (mu_n^aff, mu_n^prag, mu_n^auto, mu_n^conc, mu_n^epi) | definition | 3 |  |
| EMG-04 | 6. Readout-Native Formalization | E_n = Phi_E(x_n, mu_n, kappa_n, c_n) | definition | 4 |  |
| EMG-05 | 6. Readout-Native Formalization | Experience = phenomenon-as-meaningfully-read (within a declared human domain) | identity | 5 |  |
| EMG-06 | 6. Readout-Native Formalization | ell_n = L_H(E_n, mu_n \| H_n, c_n); permits E_n, mu_n before stable ell_n | definition | 6 |  |
| EMG-07 | 10. Naming as a Recursive Operator | mu_n -> E_n -> ell_n -> mu_{n+1} -> E_{n+1} | identity | 7 |  |
| EMG-08 | 6. Readout-Native Formalization | H_{n+1} = U_H( H_n, Retain(E_n, mu_n, r_n), delta^world_{n:n+1} ) | definition | 8 |  |
| EMG-09 | 7. Resonance: External-Internal Experien | I_{H,n} = Retrieve(M_{H,n} \| c_n, Q_n) | definition | 9 |  |
| EMG-10 | 7. Resonance: External-Internal Experien | C_H(E_n^cur, I_{H,n} \| c_n, Q_n) in [0,1];  Res_H(n) = C_H(E_n^cur, I_{H,n} \| c_n, Q_n) | definition | 10 |  |
| EMG-11 | 7. Resonance: External-Internal Experien | Res != Identity,  Res != Truth,  Res != Retention,  Res != Improvement | law | 11 |  |
| EMG-12 | 7. Resonance: External-Internal Experien | Delta_Res = P(Y \| B, Res) - P(Y \| B) | hypothesis/Open |  |  |
| EMG-13 | 8. Rhythm: Structured Recurrence Across  | T_n = {(x_k, t_k, w_k)}_{k<=n};   R_n = Omega(T_n, B_n) | definition | 12 |  |
| EMG-14 | 8. Rhythm: Structured Recurrence Across  | m_{t+1}(e) = rho*m_t(e) + 1[e_t = e],  0 <= rho < 1 | definition | 13 |  |
| EMG-15 | 8. Rhythm: Structured Recurrence Across  | order != rhythm,  repetition != rhythm,  rhythm != meaning,  rhythm != retention | law |  |  |
| EMG-16 | 9. Accumulation, Potential, Barrier Cros | Delta W_{j,N} = sum_{n=1}^{N} eta_n * eligibleGradient_n | definition | 16 |  |
| EMG-17 | 9. Accumulation, Potential, Barrier Cros | W_n^eff = W_{info,n} * g( Res_H(n), eligibility, context ),  g left DR/Open | definition | 17 |  |
| EMG-18 | 9. Accumulation, Potential, Barrier Cros | sum_{k<=n} W_k^eff >= Delta V^dagger_{old->new} | hypothesis/Open | 18 |  |
| EMG-19 | 9. Accumulation, Potential, Barrier Cros | z_{n+1} = z_n + alpha*W_n^eff + epsilon_n | hypothesis/Open |  |  |
| EMG-20 | 9. Accumulation, Potential, Barrier Cros | release != transformation,  intensity != truth,  shock != insight,  barrier crossing != improvement | law |  |  |
| EMG-21 | 11. Human-AI Coupling Begins Before the  | H_t --L_H--> Q_t | law | 27 |  |
| EMG-22 | 11. Human-AI Coupling Begins Before the  | Y_t --R_H--> E^AI_{H,t} | definition | 28 |  |
| EMG-23 | 11. Human-AI Coupling Begins Before the  | H_{t+1} = U_H(H_t, E^AI_{H,t}, world correction, other experience) | definition | 29 |  |
| EMG-24 | 11. Human-AI Coupling Begins Before the  | H_t -> Q_t -> AI_t -> Y_t -> E_{H,t} -> Retain? -> H_{t+1} -> Q_{t+1} | definition |  |  |
| EMG-25 | 12. From Retained Experience to CTSA Hum | retained experiential reorganization -> possible later CTSA crystallization | hypothesis/Open |  |  |
| EMG-26 | 12. From Retained Experience to CTSA Hum | retained sensitivity -> C_return;  retained reweighting -> A_return;  retained reorganization -> Q_next^better | hypothesis/Open |  |  |
| EMG-27 | 13. Non-Collapse Laws | phenomenon != experience; event trace != meaning; meaning-giving != truth-making; pre-explicit significance != fully for | law |  |  |
| EMG-28 | 14.10 Rival model ladder | M0 = arousal/intensity only; M1 = familiarity/exposure; M2 = prediction/surprise; M3 = language/category construction; M | hypothesis/Open |  |  |
| EMG-29 | 5.1 Meaning plurality without dilution | mu^aff != mu^epi,  mu^auto != mu^epi,  mu^prag != truth | law |  |  |

### Choice Begins Before Choice: Meaning-Shaped Accessibility, Live Possibility, and Effective — 10.5281/zenodo.22357788 (29 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| CBC-01 | Sec. 6, Six Levels That Must Not Collaps | Πlive_{A,t}(g) ⊆ Πfeas_{A,t}(g) ⊆ Πphys_t(g), π^choice ∈ Πlive_{A,t}(g) | definition | 19 |  |
| CBC-02 | Sec. 6, Six Levels That Must Not Collaps | π^choice_{A,t} ∈ Πlive_{A,t}(g) | definition | 22 |  |
| CBC-03 | Sec. 6, Six Levels That Must Not Collaps | π^act ≠ π^choice possible; Yobs = Oq(H0:T); Yobs ≠ H0:T | definition | 23 |  |
| CBC-04 | Sec. 6, Six Levels That Must Not Collaps | possible ≠ feasible ≠ live ≠ chosen ≠ enacted ≠ observed | definition | 24 |  |
| CBC-05 | Sec. 7, A Live Possibility Field | L_{A,t}(g) = {(π, κ_{A,t}(π\|g)) : π ∈ Πfeas_{A,t}(g)} | definition | 20 |  |
| CBC-06 | Sec. 7, A Live Possibility Field | Πlive_{A,t}(g) = {π : κ_{A,t}(π\|g) ≥ τlive} | definition | 21 |  |
| CBC-07 | Sec. 8.1, Resonance: experiential fit | Resonance ≠ Consent, Resonance ≠ Truth | definition |  |  |
| CBC-08 | Sec. 9, Effective, Corrigible Agency Rev | p*_{A,g} = max_{π∈Πfeas_A(g)} Pr(Rg ∩ Dg ∩ Xg ∩ Fg) | definition | 25 |  |
| CBC-09 | Sec. 9, Effective, Corrigible Agency Rev | Πlive_{A,t}(g) ⊆ Πfeas_A(g; h, z, T, B) | definition |  |  |
| CBC-10 | Sec. 11, Structural Deprivation and Viol | L^live_{A,g} = max_{z∈Jfeas} DL(L^z_A(g), L^{z0}_A(g)) | definition | 26 |  |
| CBC-11 | Sec. 13, Human-AI: The Pre-Prompt Live P | Ht —L_H→ Qt | identity | 27 |  |
| CBC-12 | Sec. 13, Human-AI: The Pre-Prompt Live P | Qt → AIt → Yt —R_H→ E^AI_{H,t} | identity | 28 |  |
| CBC-13 | Sec. 13, Human-AI: The Pre-Prompt Live P | Ht+1 = UH(Ht, E^AI_{H,t}, δ^world, X^other) | definition | 29 |  |
| CBC-14 | Sec. 13, Human-AI: The Pre-Prompt Live P | L_{A,t+1} ≠ L_{A,t} | identity | 30 |  |
| CBC-15 | Sec. 13, Human-AI: The Pre-Prompt Live P | more live accessibility ≠ better agency; more fluent choice ≠ better choice | definition |  |  |
| CBC-16 | Sec. 15, Non-Collapse Laws | objective possibility ≠ structural feasibility; feasibility ≠ live possibility; live possibility ≠ stated preference; st | definition |  |  |
| CBC-P1 | Sec. 5, The Core Thesis: Choice Begins B | P1 — Objective possibility is not practical possibility. An action may be physically or legally available while remainin | proposition |  |  |
| CBC-P2 | Sec. 5, The Core Thesis: Choice Begins B | P2 — Practical possibility is meaning-shaped. An option becomes live only insofar as the agent can discriminate, interpr | proposition |  |  |
| CBC-P3 | Sec. 5, The Core Thesis: Choice Begins B | P3 — Meaning-shaping can alter agency. Changing how an option is named, framed, remembered, socially recognized, or conn | proposition |  |  |
| CBC-P4 | Sec. 5, The Core Thesis: Choice Begins B | P4 — Choice can be real within a narrowed field. A person may genuinely choose among the live options available while st | proposition |  |  |
| CBC-P5 | Sec. 5, The Core Thesis: Choice Begins B | P5 — Expansion can also be harmful. Increasing the number or salience of live options is not automatically emancipatory. | proposition |  |  |
| CBC-H1 | Sec. 16, Empirical Programme: Try to Kil | H1 [Open] — Live possibility beyond formal option count: the live-field model should predict which options enter deliber | hypothesis/Open |  |  |
| CBC-H2 | Sec. 16, Empirical Programme: Try to Kil | H2 [Open] — Meaning access beyond resources: holding material resources constant, whether an option is intelligible/name | hypothesis/Open |  |  |
| CBC-H3 | Sec. 16, Empirical Programme: Try to Kil | H3 [Open] — History-shaped re-entry: holding current option content fixed, prior traversal history should predict which  | hypothesis/Open |  |  |
| CBC-H4 | Sec. 16, Empirical Programme: Try to Kil | H4 [Open] — Resonance without consent: high experiential congruence should predict felt fit or uptake but should not per | hypothesis/Open |  |  |
| CBC-H5 | Sec. 16, Empirical Programme: Try to Kil | H5 [Open] — Structural closure before overt prohibition: changing retaliation risk, complaint credibility, interpretive  | hypothesis/Open |  |  |
| CBC-H6 | Sec. 16, Empirical Programme: Try to Kil | H6 [Open] — Evaluator visibility: changing the assessment interface may change observed agency rankings without changing | hypothesis/Open |  |  |
| CBC-H7 | Sec. 16, Empirical Programme: Try to Kil | H7 [Open/externally allied] — Human-AI live-field carryover: randomizing AI dialogue histories and then removing AI shou | hypothesis/Open |  |  |
| CBC-H8 | Sec. 16, Empirical Programme: Try to Kil | H8 [Open] — Corrigibility predicts durable agency: feedback/objection capacity should predict later error correction bey | hypothesis/Open |  |  |

### Potential as a Readout: Witnessed Envelopes, Two-Layer Agency, and the Measurement of Pseu — 10.5281/zenodo.22361830 (25 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | Sec. 4.2, The joint event and the envelo | p*_{A,g}(h,z;T,B,P) := max_{π∈Πwit_A(g;h,z,T,B)} Pr^π_P(Rg ∩ Dg ∩ Xg ∩ Fg), with p*_{A,g} := 0 when the set is empty | definition | 25 |  |
| (2) | Sec. 4.2, The joint event and the envelo | p*_A = (p*_{A,g})_{g∈G}, C^α_A = {g : p*_{A,g} ≥ α} | definition |  |  |
| (3) | Sec. 4.2, The joint event and the envelo | A^corr_A(h,z;T,B,P,w) := Σ_g w_g p*_{A,g} ∈ [0,1] | definition |  |  |
| unnumbered | Sec. 4.2, The joint event and the envelo | p_{A,g}(π) = r·d·x·f, with r = Pr(Rg), d = Pr(Dg\|Rg), x = Pr(Xg\|Rg,Dg), f = Pr(Fg\|Rg,Dg,Xg) | identity |  |  |
| (4) | Sec. 4.3, Two layers | p*(2)_{A,g} := max_{z∈Jfeas} p*_{A,g}(h,z;T,B,P) | definition |  |  |
| (5) | Sec. 4.3, Two layers | L^recoverable_A = max_{z∈Jfeas} A^corr_A(h,z) − A^corr_A(h,z0) | definition |  |  |
| (6) | Sec. 4.4, Corrigibility and spectral sup | Δspec(Ri) > 0 ⟺ channel_i = open ∧ Ṙ_i ≠ 0 | definition |  |  |
| (7) | Sec. 6, Pseudo-peace: a gate collapse wi | Yobs = calm ∧ p*wit = low ∧ F = blocked | definition |  |  |
| PAR-stepper | Sec. 5, Setting (forced Laplacian model) | LR = DW − W (forced Laplacian); A := LR + Γ; s[n+1] = s[n] + dt(−A s[n] + J) | definition |  |  |
| L1 | Sec. 5, Lemmas (invariance and recurrenc | s* = A^{-1}J is the unique fixed point independent of u; ∥s[n]−s*∥ ≤ ρ^{n−nB}∥s[nB]−s*∥ after the last nonzero tick of a | theorem |  |  |
| L2 | Sec. 5, Lemmas (the bill) | \|u_i[n]\| = dt[(γ_i+D_i)(s*_i−θ) − Σ_{k≠i} W_ik(s*_k−s_k[n])], converging to a rate F_i^∞ > 0 whenever s*_i ≥ θ, so cumul | theorem |  |  |
| L3 | Sec. 5, Lemmas (operator change) | s*'_i = s*_i / (1+ΔB_ii) with B = A^{-1} (Sherman–Morrison); any θ < s*_i is reached below with Δ > Δ* = (s*_i/θ − 1)/B_ | theorem |  |  |
| L4 | Sec. 5, Lemmas (mutation) | s_j ≳ (J_j + W_ij·s̄_i)/(γ_j+D_j), with s̄_i an explicit increasing function of node i's own inflow, under permanent per | theorem |  |  |
| D1 (NC-78) | Sec. 3, An anatomy of 'potential': seven | Potential ≠ exercised ≠ observed | definition |  |  |
| D2 | Sec. 3, An anatomy of 'potential': seven | Declared set ≠ witnessed set | definition |  |  |
| D3 | Sec. 3, An anatomy of 'potential': seven | Layer 1 ≠ layer 2 | definition |  |  |
| D4 | Sec. 3, An anatomy of 'potential': seven | Task potential ≠ aggregate potential | definition |  |  |
| D5 | Sec. 3, An anatomy of 'potential': seven | Feasible ≠ permitted | definition |  |  |
| D6 (NC-79) | Sec. 3, An anatomy of 'potential': seven | Diagnosis of compression ≠ attribution of responsibility | definition |  |  |
| D7 | Sec. 3, An anatomy of 'potential': seven | Recoverable gap ≠ accumulated loss | definition |  |  |
| P-A | Sec. 8, Falsifiable propositions | Pseudo-peace signature: amplitude-suppressing interventions raise the calm an evaluator reads while p*wit does not rise  | hypothesis/Open |  |  |
| P-B | Sec. 8, Falsifiable propositions | Channel shift: when F is blocked and C^α shrinks in task g, load rises in a coupled task g' while the aggregate (3) stay | hypothesis/Open |  |  |
| P-C | Sec. 8, Falsifiable propositions | The excluded path: groups whose min_i \|C^α_i\| falls while the mean rises show persistent cost concentration (CE-30) and  | hypothesis/Open |  |  |
| P-D | Sec. 8, Falsifiable propositions | Layer 2 dominates the structural case: in cases classified as structural, the gap closable by layer-2 interventions exce | hypothesis/Open |  |  |
| PAR-cert | Sec. 4.5, Identifiability (an exact cert | P1: r=d=x=9/10, channel always open, every reason voiced ⇒ f_P1=1, p*_P1=729/1000. P2: channel open w.p. 1/5, every open | measurement |  |  |

### Meaning Before Naming: A Readout-Retention Architecture of Affective-Semantic Reorganizati — 10.5281/zenodo.22410666 (15 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| MBN-readout | 5. The Core Readout-Retention Architectu | r_n = R_H(x_n \| H_n, c_n) | definition |  |  |
| MBN-config | 5. The Core Readout-Retention Architectu | μ_n = G(r_n, M_{n-1}, A_{n-1}, L_{n-1}, V_{n-1}, c_n) | definition |  |  |
| MBN-experience | 5. The Core Readout-Retention Architectu | E_n = Φ(r_n, μ_n, B_n, c_n) | definition |  |  |
| MBN-retention | 5. The Core Readout-Retention Architectu | H_{n+1} = U(H_n, Retain(E_n, r_n, μ_n), δ^world_{n:n+1}) | definition |  |  |
| MBN-naming | 5. The Core Readout-Retention Architectu | ℓ_n = L_H(E_n, μ_n \| H_n, c_n) | definition | 6 |  |
| MBN-resonance-diagnostic | 6. Resonance Is Reorganization, Not Tran | ΔA_H(x,c) = A_H^post − A_H^pre | measurement |  |  |
| MBN-articulation | 7. Language Is a Special Transport Layer | Z_{H,t} —L_H→ Q_{H,t} | definition |  |  |
| §8-non-collapse-chain | 8. From Felt Change to Retained Human Ch | Exposure ≠ felt intensity ≠ retention ≠ improvement | law |  |  |
| §11-non-collapse-laws | 11. Non-Collapse Laws | external pattern ≠ meaning; meaning ≠ explicit naming; shared stimulus ≠ shared inner state; affective intensity ≠ epist | law |  |  |
| H1 | 13. Empirical Programme | H1 — Pre-nominative reorganization [Open] | hypothesis/Open |  |  |
| H2 | 13. Empirical Programme | H2 — Reader dependence [Open] | hypothesis/Open |  |  |
| H3 | 13. Empirical Programme | H3 — Translation loss [Open] | hypothesis/Open |  |  |
| H4 | 13. Empirical Programme | H4 — Retention selectivity [Open] | hypothesis/Open |  |  |
| H5 | 13. Empirical Programme | H5 — Recursive naming [Open] | hypothesis/Open |  |  |
| H6 | 13. Empirical Programme | H6 — No automatic improvement [Derived guardrail] | hypothesis/Open |  |  |

### Before Meaning, Before Choice: A Readout-Native Derivation of Experience, Live Possibility — 10.5281/zenodo.22424434 (56 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 2.5 Power, interpretive resources, and s | Retention -> Structure -> Translation -> Readout -> Meaning -> Report | definition |  |  |
| (2) | 2.5 Power, interpretive resources, and s | Retention -> Structure -> Candidate State -> Sufficiency -> Quotient -> Domain Dynamics -> Readout -> Meaning -> Experie | definition |  |  |
| (3) | 3.1 Root state and finite stepper | S_n = (G_n, Lambda_n, T_n) | definition |  |  |
| (4) | 3.1 Root state and finite stepper | S_(n+1) = F(S_n, u_n, c_n, T_n) | definition |  |  |
| (5) | 3.1 Root state and finite stepper | S_n != Z_(MEMK,n) != D_(MEMK,n) | definition |  |  |
| (6) | 4. Domain Weld: How Human Vocabulary Is  | q_(D,n+1) o F_n = F^#_(D,n) o q_(D,n) | definition |  |  |
| (7) | 4. Domain Weld: How Human Vocabulary Is  | epsilon_H = Def( q~_H o F, F^#_H o q~_H, O_H, Inv_H ) | definition |  |  |
| (8) | 5. From Retained Record to Meaning and E | A_n != r_n != x_n | definition |  |  |
| (9) | 5. From Retained Record to Meaning and E | rho^H_n = R_H(x_n \| H_n, c_n, Q_n) | definition |  |  |
| (10) | 5. From Retained Record to Meaning and E | mu_n = Psi_H(rho^H_n, H_n, c_n, Q_n) | definition |  |  |
| (11) | 5. From Retained Record to Meaning and E | mu_n = (mu_n^aff, mu_n^prag, mu_n^auto, mu_n^conc, mu_n^epi) | definition |  |  |
| (12) | 5. From Retained Record to Meaning and E | E_n = Phi_E(x_n, mu_n, gamma^mu_n, c_n) | definition |  |  |
| (13) | 5. From Retained Record to Meaning and E | Experience = phenomenon-as-meaningfully-read | definition |  |  |
| (14) | 5.1 Naming comes later, but can loop bac | l_n = L_H(E_n, mu_n \| H_n, c_n);  E_n, mu_n may precede stable l_n | definition |  |  |
| (15) | 5.1 Naming comes later, but can loop bac | mu_n -> E_n -> l_n -> mu_(n+1) -> E_(n+1) | definition |  |  |
| (16) | 6. Retention: The Reader Can Change | H_(n+1) = U_H( H_n, Retain(E_n, mu_n, rho^H_n), delta^world_(n:n+1), X^other_(n:n+1) ) | definition |  |  |
| (17) | 6. Retention: The Reader Can Change | Retain(E_n) > 0  ==>  H_(n+1) != H_n  (possible, not guaranteed) | proposition |  |  |
| (18) | 7. History-Shaped Readout-Accessibility | a_(Q,t)(e) = [ Phi_(Q,t)(s) - Phi_(Q,t)(s') ]_+ | definition |  |  |
| (19) | 7. History-Shaped Readout-Accessibility | m_(t+1)(e) = rho m_t(e) + 1[e_t = e],  0 <= rho < 1 | definition |  |  |
| (20) | 7. History-Shaped Readout-Accessibility | kappa^sem_(t+1)(e\|Q) proportional-to kappa^sem_t(e\|Q) * exp[ beta a_(Q,t)(e) + mu_m m_t(e) - nu c_(A,t,Q)(e) + xi_t(e) ] | hypothesis/Open |  |  |
| (21) | 7. History-Shaped Readout-Accessibility  | Pi^live_(A,t)(g) subseteq Pi^feas_(A,t)(g) subseteq Pi^phys_t(g) | definition |  |  |
| (22) | 8. Before Choice: The Live Possibility F | L_(A,t)(g) = { (pi, lambda^live_(A,t)(pi\|g)) : pi in Pi^feas_(A,t)(g) } | definition |  |  |
| (23) | 8. Before Choice: The Live Possibility F | Pi^live_(A,t)(g) = { pi : lambda^live_(A,t)(pi\|g) >= tau_live } | definition |  |  |
| (24) | 8. Before Choice: The Live Possibility F | pi^choice_(A,t) in Pi^live_(A,t)(g) | definition |  |  |
| (25) | 8. Before Choice: The Live Possibility F | pi^act_(A,t) != pi^choice_(A,t) is possible;  Y_obs = O_q(H_(0:T)),  Y_obs != H_(0:T) | definition |  |  |
| (26) | 8. Before Choice: The Live Possibility F | possible != feasible != live != chosen != enacted != observed | definition |  |  |
| (27) | 9. Effective, Corrigible Agency | p*_(A,g)(h,z;T,B,P) = max_(pi in Pi^wit_A(g;h,z,T,B)) Pr^(pi_P)( Read_g cap D_g cap X_g cap F_g ) | measurement |  |  |
| (28) | 9.1 Power before prohibition | Power may alter agency by altering meaning/accessibility before overt choice | proposition |  |  |
| (29) | 10. Human-AI Mediation Begins Before the | H_t --L_H--> Q_t,  Q_t != H_t | definition |  |  |
| (30) | 10. Human-AI Mediation Begins Before the | Q_t -> AI_t -> Y_t | definition |  |  |
| (31) | 10. Human-AI Mediation Begins Before the | AI(Q_t) = K_like,  K_like != K_validated | definition |  |  |
| (32) | 10. Human-AI Mediation Begins Before the | Y_t --R_H--> E^AI_(H,t) | definition |  |  |
| (33) | 10. Human-AI Mediation Begins Before the | H_(t+1) = U_H( H_t, E^AI_(H,t), delta^world, X^other ) | definition |  |  |
| (34) | 10. Human-AI Mediation Begins Before the | L_(A,t+1) != L_(A,t) | definition |  |  |
| (35) | 10.1 Difference, resistance, and retaine | D > 0,  Resist > 0,  A_H > 0 | definition |  |  |
| (36) | 10.1 Difference, resistance, and retaine | Delta Omega^(fH)_s = B_s A_s,  rank(B_s A_s) << d_H | definition |  |  |
| (37) | 10.1 Difference, resistance, and retaine | Omega^H_(s+1,0) = Omega^H_(s,0) + eta_s Delta Omega^(fH)_s,  0 <= eta_s <= 1 | definition |  |  |
| (38) | 11. Human Return: The Upper Measurement  | H^return = < G_CTSA, L, M, P, W, Delta_dir > | definition |  |  |
| (39) | 11. Human Return: The Upper Measurement  | Exposure != Retention != Improvement | definition |  |  |
| (40) | 11. Human Return: The Upper Measurement  | Assisted performance != Unaided Human Return | definition |  |  |
| (41) | 13. Provenance and Claim Status Are Part | Lambda(e_i) = < Prov_i, Tier_i, Def_i, Reader_i, Falsifier_i > | definition |  |  |
| (42) | 14. Why This Is Not Simply Active Infere | root retention =/=\|= belief state =/=\|= meaning =/=\|= experience =/=\|= choice | definition |  |  |
| (43) | 15. Why This Is Not Simply Affordance or | feasible for the agent != currently live for the agent | definition |  |  |
| (44) | 17.1 Rival-model ladder | M0 = formal option count + stated preference | definition |  |  |
| (45) | 17.1 Rival-model ladder | M1 = affordance/capability + cost/resources | definition |  |  |
| (46) | 17.1 Rival-model ladder | M2 = constructed-preference / salience model | definition |  |  |
| (47) | 17.1 Rival-model ladder | M3 = predictive or active-inference implementation | definition |  |  |
| (48) | 17.1 Rival-model ladder | M4 = readout-native live-field model | definition |  |  |
| (49) | 18. Graceful Degradation | retained distinction -> domain translation/readout -> meaning -> experience -> retained change -> graded accessibility - | definition |  |  |
| (50) | 20. Conclusion: Before Meaning, Before C | Retained Difference -> Admissible Readout -> Meaning -> Experience -> History-Shaped Accessibility -> Live Possibility - | definition |  |  |
| H1 | 17.2 Minimal empirical predictions | H1 - Live-field incremental value [Open]. Under matched feasible sets, L_(A,t) will explain reproducible variance in whi | hypothesis/Open |  |  |
| H2 | 17.2 Minimal empirical predictions | H2 - History residual [Open]. Prior traversal history will predict later route accessibility after current semantic stat | hypothesis/Open |  |  |
| H3 | 17.2 Minimal empirical predictions | H3 - Pre-prompt carryover [externally constrained, mechanism Open]. Repeated Human-AI interaction can alter later human  | hypothesis/Open |  |  |
| H4 | 17.2 Minimal empirical predictions | H4 - Human Return dissociation [Open]. Delayed unaided Concept, Tool, Skill, and Alternative Return will show partially  | hypothesis/Open |  |  |
| H5 | 17.2 Minimal empirical predictions | H5 - Gain/loss asymmetry [Open]. Positive gross return can coexist with reduced checking habits, uncertainty sensitivity | hypothesis/Open |  |  |
| H6 | 17.2 Minimal empirical predictions | H6 - Optional modifiers must earn survival [Open]. Resonance, rhythm, and barrier/transition variables remain only if th | hypothesis/Open |  |  |

### AI–Cognitive Interaction: Activating Youth Potential through Reflective Dialogue and Lingu — 10.5281/zenodo.22456414 (2 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 2. Reading This Paper Through the Progra | Π^live_{A,t}(g) ⊆ Π^feas_{A,t}(g) ⊆ Π^phys_t(g) | definition (quoted, not a new claim of this paper) | 21 |  |
| (2) | 2. Reading This Paper Through the Progra | H_{n+1} = U_H( H_n, Retain(E_n, μ_n, ρ^H_n), δ^world_{n:n+1}, X^other_{n:n+1} ) | definition (quoted, not a new claim of this paper) | 8 |  |

### Operational Linguistic Wisdom: Elective Connectivity and Linguistic Capital Activation in  — 10.5281/zenodo.22456487 (14 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 5.1 Elective Connectivity | H_org,t --consent, scope--> Q_org,t,   Q_org,t ≠ H_org,t | definition | 27 |  |
| (2) | 5 (Capability Activation stage) | AI(Q_org,t) = K_like,   K_like ≠ K_validated | definition | 38 |  |
| unlabeled (5, Reflexive Reconfiguration stage) | 5 (Reflexive Reconfiguration stage) | H_org,t+1 = U_Horg( H_org,t , ... ) | definition | 8 |  |
| unlabeled (§2, falsifier condition) | 2 Introduction: From Communication Chann | no H_org,n+1 ≠ H_org,n attributable to the processing | hypothesis/Open |  |  |
| unlabeled (§5.1, provenance ledger) | 5.1 Construct clarity | Λ(e_i) = ⟨ Prov_i, Tier_i, Def_i, Reader_i, Falsifier_i ⟩ | definition |  |  |
| unlabeled (§5.2, AVRH) | 5.2 OLW and AVRH (kept, reformulated) | D > 0,   Resist > 0,   A_H > 0 | definition |  |  |
| P1 | 7 Propositions for Future Testing (Open  | Connectivity quality: Elective Connectivity quality predicts the breadth and safety of linguistic assets available for l | hypothesis/Open |  |  |
| P2 | 7 Propositions for Future Testing (Open  | Activation clarity: Capability Activation routines predict concept clarity and perceived value alignment. | hypothesis/Open |  |  |
| P3 | 7 Propositions for Future Testing (Open  | Reconfiguration cadence: Reflexive Reconfiguration cadence predicts policy-update rates and learning-KPI improvements. | hypothesis/Open |  |  |
| P4 | 7 Propositions for Future Testing (Open  | Reviewer diversity: Reviewer diversity strengthens clarity and alignment (moderation). | hypothesis/Open |  |  |
| P5 | 7 Propositions for Future Testing (Open  | Over-reliance: Over-reliance on LLM outputs weakens the P2-P3 relationships (negative moderation), paralleling K_like ≠  | hypothesis/Open |  |  |
| P6 | 7 Propositions for Future Testing (Open  | Minimization trade-off: Data minimization reduces decontextualization risk without lowering activation benefits. | hypothesis/Open |  |  |
| P7 | 7 Propositions for Future Testing (Open  | Dissent protocols: Formal dissent protocols reduce power-capture risk. | hypothesis/Open |  |  |
| P8 | 7 Propositions for Future Testing (Open  | SECI complementarity: SECI-practicing organizations experience complementary gains from OLW routines. | hypothesis/Open |  |  |

### The Dialogue as the Ground of Enlightenment: Religious and Cognitive Frameworks for Unders — 10.5281/zenodo.22456564 (9 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 3 Reflective Dialogue as a Mirror of Tho | μ_n = Ψ_H(ρ_n^H, H_n, c_n, Q_n) | definition | 2 |  |
| (2) | 6 Digital Yonisomanasīkāra as a Working  | Z_dlg[s,n+1] = F#_dlg( Z_dlg[s,n], u_H[s,n], u_AI[s,n], c[s,n], T[s,n] ) | definition | 31 |  |
| (3) | 7 AI as Mirror, Not Moral Agent | AI(Q_t) = K_like,   K_like ≠ K_validated | definition | 38 |  |
| (4) | 7 AI as Mirror, Not Moral Agent | Assisted performance ≠ Unaided Human Return | identity |  |  |
| (5) | 7.1 Difference, resistance, and retained | D > 0,   Resist > 0,   A_H > 0 | definition |  |  |
| unlabeled (§6, Framing bullet) | 6 Digital Yonisomanasīkāra as a Working  | H_t —L_H→ Q_t,   Q_t ≠ H_t | definition | 27 |  |
| unlabeled (§6, Integration bullet) | 6 Digital Yonisomanasīkāra as a Working  | H_{n+1} = U_H( H_n, Retain(E_n, μ_n, ρ_n^H), δ^world, X^other ),  with the explicit non-guarantee: Retain(E_n) > 0 ⇒ H_{ | definition |  |  |
| P1 | 6.2 Minimal empirical predictions for th | Framing residual: under matched topic and matched AI model, dialogues that open with an explicit statement of moral or c | hypothesis/Open |  |  |
| P2 | 6.2 Minimal empirical predictions for th | Iteration without Integration is insufficient: recursive questioning (Iteration, Equation (2)) that is not followed by a | hypothesis/Open |  |  |

### After Labour: Human Position in an AI-Robotic World System (full world-system standalone,  — 10.5281/zenodo.22481924 (58 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 1. The Question After Labour | human labour -> production -> wage -> claim on output | definition |  |  |
| (2) | 2.1 Readout in this paper | Readout_(Q,O,c)(S) = z,  z != S | definition | 52 |  |
| (3) | 5. Technology Block: Candidate Generatio | Z_dot_t = v_t G_t - delta_Z Z_t,  0 <= v_t <= 1 | definition |  |  |
| (4) | 5. Technology Block: Candidate Generatio | K_like != K_validated | definition |  |  |
| (5) | 5. Technology Block: Candidate Generatio | B^RB_t = N^RB_t q^RB_t | definition |  |  |
| (6) | 5. Technology Block: Candidate Generatio | B_dot^RB_t / B^RB_t = N_dot^RB_t / N^RB_t + q_dot^RB_t / q^RB_t | identity |  |  |
| (7) | 5. Technology Block: Candidate Generatio | M_t = (K^M_t)^kappa (A^AI_t)^alpha (B^RB_t)^beta | definition |  |  |
| (8) | 6. Labour Centrality, Not Labour Disappe | L_t = < L^task_t, L^income_t, L^bottleneck_t, L^bargain_t > | definition | 53 |  |
| Labour-Decentering Proposition | 6. Labour Centrality, Not Labour Disappe | Labour-Decentering Proposition [Open]. AI and robotics can reduce labour centrality without eliminating labour. Stable e | hypothesis/Open |  |  |
| (9) | 6. Labour Centrality, Not Labour Disappe | rho = (sigma - 1) / sigma | definition |  |  |
| (10) | 6. Labour Centrality, Not Labour Disappe | s^L_t = (omega_H H_t^rho) / (omega_H H_t^rho + omega_M M_t^rho) | identity |  |  |
| (11) | 7. The Claim Constitution: From Wages to | q_t = o_t + tau_t(1 - o_t) = 1 - (1 - o_t)(1 - tau_t) | definition |  |  |
| (12) | 7. The Claim Constitution: From Wages to | Gamma_t = s^L_t + q_t(1 - s^L_t) | identity |  |  |
| (13) | 7. The Claim Constitution: From Wages to | q^min_t = (Gamma_bar - s^L_t) / (1 - s^L_t) | identity | 54 |  |
| (14) | 7. The Claim Constitution: From Wages to | D^rent_(i,t) = (Rent^(AI,out)_(i,t) - Rent^(AI,in)_(i,t)) / Y_(i,t) | definition |  |  |
| (15) | 7. The Claim Constitution: From Wages to | Gamma^net_(i,t) = Gamma_(i,t) - D^rent_(i,t) | identity |  |  |
| (16) | 8. Ownership Accumulation: The Stock Tha | W^M_(i,t+1) = (1 - delta_W) W^M_(i,t) + r^M_t W^M_(i,t) + s^(M,cap)_(i,t) + T^cap_(i,t) - Tax^cap_(i,t) | definition |  |  |
| (17) | 8. Ownership Accumulation: The Stock Tha | o_t = ( sum_(i in B) W^M_(i,t) ) / ( sum_i W^M_(i,t) ) | definition |  |  |
| (18) | 8. Ownership Accumulation: The Stock Tha | current redistribution != future ownership reproduction | definition |  |  |
| (19) | 9. Scarce Assets, Rent Burden, and Effec | B^scarce_(i,t) = (R^house_(i,t) + R^land_(i,t) + R^energy_(i,t) + DS_(i,t)) / Y_(i,t) | definition |  |  |
| (20) | 9. Scarce Assets, Rent Burden, and Effec | Gamma^eff_(i,t) = max{0, Gamma^net_(i,t) - B^scarce_(i,t)} | identity |  |  |
| (21) | 9. Scarce Assets, Rent Burden, and Effec | machine abundance != low rent burden != effective material freedom | definition |  |  |
| (22) | 10. Aggregate Demand and Realization: Wh | AD_t = C(Gamma^eff_t Y_t, m_t) + I_t + G_t + NX_t | definition |  |  |
| (23) | 10. Aggregate Demand and Realization: Wh | chi^dem_t = min{1, AD_t / Y_t} | definition |  |  |
| (24) | 10. Aggregate Demand and Realization: Wh | Pi^M_t = chi^dem_t Y_t - Cost^M_t | identity |  |  |
| (25) | 10. Aggregate Demand and Realization: Wh | Gamma^eff Y -> AD -> Pi^M -> W^M_(t+1) -> M_(t+1) | definition |  |  |
| (26) | 11. Ownership Is Not Transition Power: C | G^conv_(j,t)(e) = 1 - [ V_t(e \| -j) / V_t(e) ]_+ | definition |  |  |
| (27) | 11. Ownership Is Not Transition Power: C | X_(i,t)(e; j) = clip( V_(i,t)(e \| -j) / V_(i,t)(e), 0, 1 ) | definition |  |  |
| (28) | 11. Ownership Is Not Transition Power: C | D_(i->j,t)(g) = sum_(e in E(g)) w_e(g) G^conv_(j,t)(e) [1 - X_(i,t)(e; j)] | definition |  |  |
| (29) | 11. Ownership Is Not Transition Power: C | Concentration != G^conv != D | definition |  |  |
| (30) | 12. Relational Class Position in an AI-R | C_(i,t) = < O_(i,t), G_(i,t), Gamma_(i,t), A^access_(i,t), X_(i,t), D_(i,t), R^rent_(i,t) > | definition |  |  |
| (31) | 13. The Political-Economy-to-Human Bridg | c^(PE->H)_(i,t) = B^(PE->H)(Z_t; i, g) | definition |  |  |
| (32) | 13.1 Live possibility, defined here | Pi^live_(i,t)(g) subseteq Pi^feas_(i,t)(g) subseteq Pi^phys_(i,t)(g) | definition | 55 |  |
| (33) | 13.1 Live possibility, defined here | Lambda_dot^live_(H,t) = lambda_1 B_t + lambda_2 X_t + lambda_3 P^plural_t + lambda_4 r^H_t - lambda_5 D_t - lambda_6 C^I | hypothesis/Open |  |  |
| (34) | 13.2 Corrigible human agency, defined he | A^corr_(H,i,t)(g) = max_(pi in Pi^live_(i,t)(g)) Pr^pi( R_g cap D_g cap X_g cap F_g ) | definition | 56 |  |
| (35) | 13.3 Human Return, defined here | R^return_(H,t) = < C_t, T_t, S^skill_t, A^alt_t > | definition | 57 |  |
| (36) | 14. Social Role After Labour | S_dot^H_t = s_1 W_t + s_2 N_t - delta_S S^H_t | definition |  |  |
| (37) | 14. Social Role After Labour | 1 = l_wage + l_care + l_learn + l_civic + l_leisure | identity |  |  |
| (38) | 15. Social Reproduction: Productive Nece | H_dot^cap_t = f(Care_t, Health_t, Education_t, Nutrition_t, Community_t) - delta_H H^cap_t | hypothesis/Open |  |  |
| (39) | 15. Social Reproduction: Productive Nece | productive necessity of humans != social necessity of human reproduction | definition |  |  |
| (40) | 16. The Human Systemic Position Equation | P^H_t = [ (Gamma^eff_t)^theta_Gamma (A^corr_(H,t))^theta_A (Lambda^live_(H,t))^theta_Lambda (r^H_t)^theta_R (S^H_t)^thet | definition | 58 |  |
| (41) | 16. The Human Systemic Position Equation | P_dot^H_t / P^H_t = theta_Gamma (Gamma_dot^eff_t/Gamma^eff_t) + theta_A (A_dot^corr_(H,t)/A^corr_(H,t)) + theta_R (r_dot | identity |  |  |
| (42) | 16. The Human Systemic Position Equation | ... + theta_S (S_dot^H_t/S^H_t) + theta_X (X_dot^H_t/X^H_t) - theta_D (D_dot^H_t/(1+D^H_t)) | identity |  |  |
| (43) | 16. The Human Systemic Position Equation | Y_dot_t > 0  =/=>  P_dot^H_t > 0 | definition | 59 |  |
| (44) | 17. Abundance Without Agency | AWA_t = < Y(up), Gamma^eff adequate, O^H(down), X^H(down), D^H(up), Lambda^live_H(down), A^corr_H(down), r_H(down), S_H( | definition |  |  |
| (45) | 18. Recursive Political Economy: Three P | P_t = < P^econ_t, P^info_t, P^coerc_t > | definition |  |  |
| (46) | 18. Recursive Political Economy: Three P | P^B_t proportional-to Gamma^eff_t A^corr_(H,t) Lambda^live_(H,t) X^H_t r^H_t | definition |  |  |
| (47) | 18. Recursive Political Economy: Three P | P^E_t = P_E( P_t, G_dot^conv, D^H_t, 1 - Gamma^eff_t ) | definition |  |  |
| (48) | 18. Recursive Political Economy: Three P | I_dot_t = F_I( P^B_t, P^E_t, state capacity, rules, shocks ) | hypothesis/Open |  |  |
| (49) | 18. Recursive Political Economy: Three P | economic gate control -> rents -> political influence -> future gate control;  information control -> attention/interpre | definition |  |  |
| (50) | 18. Recursive Political Economy: Three P | ownership != informational power != coercive power | definition |  |  |
| (51) | 21. What Humans May Actually Do | labour-based claim -> human/citizen claim on social production | definition |  |  |
| (52) | 23. What Can and Cannot Be Forecast Now | Omega_t = w_M(g_M - g_H) + w_D g_D + w_G g_G - w_q g_q - w_Gamma g_(Gamma^eff) - w_X g_X - w_R g_(r^H) - w_Lambda g_Lamb | measurement |  |  |
| (53) | 24. Claim Boundaries | concentration =/=> dependency =/=> agency loss | definition |  |  |
| (54) | 25. Conclusion: From Productive Necessit | candidate generation -> validated K/A^AI -> robotic embodiment -> M_t -> Y_t -> L_t -> s^L_t -> Gamma_t -> W^M_t -> o_(t | definition |  |  |
| (55) | 25. Conclusion: From Productive Necessit | Gamma^eff Y -> AD -> Pi^M -> W^M_(t+1) -> {o_(t+1), M_(t+1)} | definition |  |  |
| (56) | 25. Conclusion: From Productive Necessit | {Care, Health, Education} -> H^cap -> {A^corr_H, r_H, S_H} -> P -> I_(t+1) | definition |  |  |
| (57) | 25. Conclusion: From Productive Necessit | growth of machine productive power  versus  growth of broad human claim, exit, agency, and Human Return | definition |  |  |

### The Human Conversion Imperative: Machine Acceleration, Human Potential, and the Reversibil — 10.5281/zenodo.22481926 (30 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 1. The Missing Dependent Variable | Machine expansion  =/=>  Human expansion | definition | 60 |  |
| (2) | 4. Non-Collapse Discipline | AI capability != validated knowledge | definition |  |  |
| (3) | 4. Non-Collapse Discipline | assisted performance != human learning | definition |  |  |
| (4) | 4. Non-Collapse Discipline | augmentation != synergy | definition |  |  |
| (5) | 4. Non-Collapse Discipline | formal options != live possibilities | definition |  |  |
| (6) | 4. Non-Collapse Discipline | access != credible exit | definition |  |  |
| (7) | 4. Non-Collapse Discipline | income transfer != future ownership | definition |  |  |
| (8) | 4. Non-Collapse Discipline | material security != agency | definition |  |  |
| (9) | 4. Non-Collapse Discipline | market concentration != domination | definition |  |  |
| (10) | 4. Non-Collapse Discipline | productive necessity != social necessity | definition |  |  |
| (11) | 5. Human Conversion as a Vector, Not a S | C^H_t = < Gamma^eff_t, X^H_t, Lambda^live_(H,t), A^corr_(H,t), R^route_(H,t), W^world_(H,t), r_(H,t), H^cap_t, S_(H,t) > | definition | 61 |  |
| (12) | 5. Human Conversion as a Vector, Not a S | eta^HC_(j,t) = d(ln C^H_(j,t)) / d(ln M_t) | definition | 62 |  |
| (13) | 5. Human Conversion as a Vector, Not a S | eta^HC_Gamma > 0,  eta^HC_(rH) < 0,  eta^HC_X < 0 | definition |  |  |
| Proposition 1 | 5. Human Conversion as a Vector, Not a S | Proposition 1 (Conversion non-identity) [Open]. An increase in M_t or current human-AI performance is insufficient to es | hypothesis/Open |  |  |
| (14) | 6. The Epistemic Conversion Mechanism | H problem -> AI divergence -> H resistance -> World test -> H integration -> AI removal -> H return | definition |  |  |
| (15) | 6. The Epistemic Conversion Mechanism | H problem -> AI answer -> use -> dependence | definition |  |  |
| Proposition 2 | 6. The Epistemic Conversion Mechanism | Proposition 2 (Assistance-conversion divergence) [Open]. The AI assistance intensity that maximizes current performance  | hypothesis/Open |  |  |
| (16) | 7. Bad Mode Is a State Space, Not a Stai | B_t = < D_t, G_dot^conv_t, C^info_t, 1 - X^H_t, 1 - r_(H,t), 1 - Lambda^live_(H,t), 1 - A^corr_(H,t), 1 - Gamma^eff_t, 1 | definition |  |  |
| (17) | 8. Reversibility, Hysteresis, and the In | W_j = { t : C^rec_(j,t) <= C_bar_j  AND  tau^rec_(j,t) <= tau_bar_j } | definition | 63 |  |
| Proposition 3 | 8. Reversibility, Hysteresis, and the In | Proposition 3 (Reversibility Principle) [Open]. The faster machine capability grows relative to human conversion, the mo | hypothesis/Open |  |  |
| (18) | 9. An Urgency Vector Instead of a Panic  | Delta g_(j,t) = [ g~_(M,t) - g~_(Cj,t) ]_+ | definition |  |  |
| (19) | 9. An Urgency Vector Instead of a Panic  | U_(j,t) = Delta g_(j,t) * L_(j,t) * S_(j,t) * tau^rec_(j,t) | definition | 64 |  |
| (20) | 9. An Urgency Vector Instead of a Panic  | U_t = < U_(1,t), ..., U_(J,t) > | definition |  |  |
| (21) | 9. An Urgency Vector Instead of a Panic  | U^max_t = max_j U_(j,t) | definition |  |  |
| (22) | 10. Distribution: Whose Potential Expand | C^10_(j,t), C^50_(j,t), C^90_(j,t) | definition |  |  |
| (23) | 10. Distribution: Whose Potential Expand | I^H_(j,t) = C^90_(j,t) - C^10_(j,t) | definition |  |  |
| Proposition 4 | 10. Distribution: Whose Potential Expand | Proposition 4 (Distributional conversion) [Open]. Broad human expansion requires that conversion gains reach a declared  | hypothesis/Open |  |  |
| (24) | 15. Discussion: From Maximum Assistance  | Maximum AI assistance -> Maximum durable human conversion | definition |  |  |
| (25) | 16. Conclusion | rate of machine capability growth  versus  rate of human conversion and institutional adaptation | definition |  |  |
| (26) | 16. Conclusion | Machine Capability -> Human Conversion Vector -> Human Return/Agency/Exit -> Reversibility or Lock-in -> Next Institutio | definition |  |  |

### How Humans Should Converse with AI: A Problem-First Adaptive Dialogue Conversion Protocol  — 10.5281/zenodo.22481928 (59 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 3. The Unit of Analysis | H_{s,0} --L_H--> Q_{s,0}. | definition |  |  |
| (2) | 3. The Unit of Analysis | Q_{s,t} → AI_{s,t} → Y_{s,t} --R^AI_H--> E_{H,s,t}. | definition |  |  |
| (3) | 3. The Unit of Analysis | H_{s+1,0} = U_H(H_{s,0}, E^AI_{H,s,*}, δ^world, X^other). | definition |  |  |
| (4) | 4. Topic Entry Condition | P^live_{H,t} = a presently consequential unresolved difference in the person's life, work, understanding, relationship t | definition |  |  |
| (5) | 4. Topic Entry Condition | TopicEntry ∈ {LiveProblem, OpenExploration, RoutineDelegation}. | definition |  |  |
| (6) | 4. Topic Entry Condition | Problem-First ⇒ (Human Agenda Ownership, Bounded Relevance, World-Side Testability, Observable Human Return). | proposition |  |  |
| (7) | 4. Topic Entry Condition | Problem-First ≠ Problem-Only. | law |  |  |
| PFDP | 5. Deployment Layer | Problem-First Dialogue Principle [Open]: when AI is used for human development rather than entertainment or routine exec | hypothesis/Open |  |  |
| (8) | 5. Deployment Layer | π^deploy = f(Stakes, LearningNeed, Irreversibility, DependencyRisk, UserSkill). | definition |  |  |
| (9) | 5. Deployment Layer - DCP-Lite | State → Challenge → Check → Own. | definition |  |  |
| AFP | 5. Deployment Layer | Adaptive-friction proposition [Open]: the best real-world protocol will often be the least burdensome policy that preser | hypothesis/Open |  |  |
| (10) | 5. Deployment Layer - DCP-Critical | Topic Entry → Triage → Minimum Sufficient Dialogue → Escalate if Stakes Rise → Periodic Return. | definition |  |  |
| (11) | 6. The Dialogue Conversion Protocol | Anchor → Expand → Oppose → Discriminate → Verify → Integrate → Remove → Return. | definition |  |  |
| (12) | 6.1 Anchor | A0 = ⟨P0, M0, U0, E0, F0, S0⟩, where P0 = problem as understood, M0 = current model/tentative answer, U0 = important unk | definition |  |  |
| (13) | 6.1 Anchor - elicitation for novices | AI_clarify → {Known, Unknown, Goal, Stakes} → Human Anchor. | definition |  |  |
| (14) | 6.2 Expand | Q_t --AI--> {Q_{i,t+1}, K_{i,t}}_{i=1}^n. | definition |  |  |
| (15) | 6.3 Oppose or boundary-test | Rival Generation: for genuinely open spaces. | definition |  |  |
| (16) | 6.3 Oppose or boundary-test | Boundary Test: for strongly asymmetric evidence. | definition |  |  |
| (17) | 6.3 Oppose or boundary-test | Oppose a claim ≠ manufacture an opposite claim. | law |  |  |
| (18) | 6.4 Discriminate | N_distinct = \|{C1, ..., Cn} / ∼_Q\|. | measurement |  |  |
| (19) | 6.5 Verify | L(c) = {Decision, Risk, Money, Health, Legal, Publication, IrreversibleAction}. | definition |  |  |
| (20) | 6.5 Verify | V = {primary source, data, experiment, calculation, expert, independent method, world outcome}. | definition |  |  |
| (21) | 6.5 Verify | Source ≠ AI synthesis ≠ Human inference ≠ Unverified candidate. | law |  |  |
| (22) | 6.6 Integrate | I_s = ⟨ΔM_s, E^decisive_s, U^remain_s, Next_s⟩. | definition |  |  |
| (23) | 6.7 Remove | Reset: fresh framing/session/source route. | definition |  |  |
| (24) | 6.7 Remove | Removal: absence of decisive AI assistance. | definition |  |  |
| (25) | 6.8 Return | R^return_H = ⟨C, T, S, A⟩, where C = Conceptual reconstruction, T = Tool selection, S = Skill execution, A = Alternative | definition |  |  |
| (26) | 6.8 Return | ΔH_s = ⟨ΔC_s, ΔT_s, ΔS_s, ΔA_s, ΔA^corr_{H,s}, ΔΛ^live_{H,s}⟩. | definition |  |  |
| (27) | 6.8 Return | ΔPerformance_AI > 0 ⇏ ΔH_s > 0. | law |  |  |
| (28) | 6.8 Return | F^return = f(Criticality, LearningNeed, FailureCost, DependencyRisk). | definition |  |  |
| (29) | 7. Action and World Feedback | I_s → a_s → δ^world_{s+1} → H_{s+1,0}. | definition |  |  |
| (30) | 7. Action and World Feedback | Live Problem → Question → Dialogue → Human Return → Action → World Feedback → Revision or New Problem. | definition |  |  |
| WCP | 7. Action and World Feedback | World-closure proposition [Open]: for live problems with observable consequences, dialogue policies that include post-co | hypothesis/Open |  |  |
| (31)-(32) | 8. Expansion and Contraction Must Altern | Expansion := maximize candidate diversity and discriminability. | definition |  |  |
| (33)-(34) | 8. Expansion and Contraction Must Altern | Contraction := prune by evidence, provenance, stakes, and action relevance. | definition |  |  |
| (35) | 10. Dialogue Policy Must Depend on the G | π^dialogue = f(TopicMode, Goal, Skill, Stakes, Domain, LearningNeed, Reversibility). | definition |  |  |
| (36) | 10.1 Personal and relational dialogue | Experience → Interpretations → Absent Perspective → Observable Evidence → Direct Human Conversation. | definition |  |  |
| (37) | 11. Protocol Burden and Behavioral Adopt | B^use = ⟨Time, CognitiveLoad, VerificationCost, Interruption, LiteracyDemand⟩. | definition |  |  |
| (38) | 11. Protocol Burden and Behavioral Adopt | Epistemically optimal ≢ Behaviorally adoptable. | law |  |  |
| (39) | 12. Provenance Ledger | Status ∈ {Source, AI-Synthesis, Human-Inference, Candidate, Decision}. | definition |  |  |
| (40)-(41) | 14. Formal Success Condition | π* ∈ argmax_π E[ΔH_s \| π, task, user], subject to minimum task-performance/safety constraints and B_use(π) ≤ B̄(task, us | definition |  |  |
| (42) | 14. Formal Success Condition | π^perf ∈ argmax_π E[P^assist_s \| π]. | definition |  |  |
| DCPp | 14. Formal Success Condition | Dialogue Conversion Proposition [Open]: for tasks in which learning, judgment transfer, or future unaided competence mat | hypothesis/Open |  |  |
| DEPp | 14. Formal Success Condition | Deployment Proposition [Open]: the full protocol will not maximize real-world adoption across all tasks; adaptive triage | hypothesis/Open |  |  |
| AgP | 14. Formal Success Condition | Agenda Proposition [Open]: when the objective is human development, self-selected live-problem entry will often produce  | hypothesis/Open |  |  |
| H1 | 15.2 Primary hypotheses | Direct-answer AI will often maximize immediate performance but not delayed Human Return in learning-intensive tasks. | hypothesis/Open |  |  |
| H2 | 15.2 Primary hypotheses | DCP and cognitive-forcing conditions will reduce overreliance but may increase cognitive load. | hypothesis/Open |  |  |
| H3 | 15.2 Primary hypotheses | DCP will produce more non-equivalent unaided alternatives at follow-up than direct-answer AI. | hypothesis/Open |  |  |
| H4 | 15.2 Primary hypotheses | Provenance accuracy and error detection after AI removal will mediate the relationship between protocol and Human Return | hypothesis/Open |  |  |
| H5 | 15.2 Primary hypotheses | Effects will be heterogeneous by prior skill: novices may require more scaffolded opposition/verification than experts. | hypothesis/Open |  |  |
| H6 | 15.2 Primary hypotheses | In creation tasks, aggressive expansion may improve coupled output without harming Return, whereas high-stakes decision  | hypothesis/Open |  |  |
| H7 | 15.2 Primary hypotheses | DCP-Lite will achieve higher adoption and lower burden than DCP-Standard in low-stakes tasks with little loss of safety  | hypothesis/Open |  |  |
| H8 | 15.2 Primary hypotheses | In relational interpretation tasks, facts-versus-interpretation separation and absent-perspective prompts will reduce un | hypothesis/Open |  |  |
| H9 | 15.2 Primary hypotheses | For capability-sensitive tasks, self-selected live-problem entry will increase perceived relevance, follow-through, and  | hypothesis/Open |  |  |
| H10 | 15.2 Primary hypotheses | For action-relevant live problems, Action → World Feedback closure will improve calibration and transfer relative to oth | hypothesis/Open |  |  |
| (43) | 18. Conclusion | Problem-First ≠ Problem-Only. | law |  |  |
| (44) | 18. Conclusion | Topic Entry → Triage → Minimum Sufficient Dialogue → Human Return → Action/World Feedback → Revision or New Problem. | definition |  |  |
| (45) | 18. Conclusion | Anchor → Expand → Oppose/Boundary-Test → Discriminate → Verify → Integrate → Remove → Return. | definition |  |  |
| (46) | 18. Conclusion | What unresolved difference deserves my attention? / How much AI/friction does this task require? / What remains with me  | proposition |  |  |

### From Assistance to Human Capability: A Readout-Genesis Architecture for Proactive AI, Uneq — 10.5281/zenodo.22498047 (38 equations)

| Label | Section | Statement | Paper tier | In MR 1–79 | Canonical |
|---|---|---|---|---|---|
| (1) | 2. Readout Genesis Is the Rail, Not a Me | S_n = (G_n, Lambda_n, T_n) | definition |  |  |
| (2) | 2. Readout Genesis Is the Rail, Not a Me | S_(n+1) = F(S_n, u_n, c_n, T_n) | definition |  |  |
| (3) | 2. Readout Genesis Is the Rail, Not a Me | q#_(HCA,n+1) o F_n = F_(HCA,n) o q_(HCA,n) | definition |  |  |
| (4) | 2. Readout Genesis Is the Rail, Not a Me | S_n != Z_(HCA,n) != D_(HCA,n) | definition |  |  |
| (5) | 3. Internal Programme Lineage: The Nativ | Retained Difference -> Human Readout -> Live Problem -> Barrier Readout -> Candidate Routes -> Human Endorsement -> Adap | definition | 67 |  |
| (6) | 5. Candidate HCA Domain State and Defect | Z_(HCA,i,n) = < P^live_(i,n), K^life_(i,n), B^bar_(i,n), C^cand_(i,n), C^live_(i,n), h_(i,n), R^return_(H,i,n), Omega^re | definition |  |  |
| (7) | 5. Candidate HCA Domain State and Defect | epsilon_HCA = Def( q~_HCA o F, F_HCA o q~_HCA, O_HCA, Inv_HCA ) | definition |  |  |
| (8) | 6. Unequal Life Conditions: Capability C | K^life_(i,n) = < E^econ, F^base, L^lang, D^digital, T^disc, H^health, M^mob, N^mentor, C^cred >_(i,n) | definition | 68 |  |
| (9) | 6. Unequal Life Conditions: Capability C | Resources != Access,  Access != Capability,  Capability != Realized Opportunity | definition |  |  |
| (10) | 6. Unequal Life Conditions: Capability C | Access(z) != Control(z) | definition |  |  |
| (11) | 6. Unequal Life Conditions: Capability C | Equal AI Access =/=> Equal Capability Conversion | definition |  |  |
| (12) | 7. Live Problem Entry and Barrier Readou | B^bar_(i,n) subseteq {Knowledge, Skill, Language, Tool, ResourceTime, Network, Credential, Permission, Opportunity, Unkn | definition | 69 |  |
| (13) | 7. Live Problem Entry and Barrier Readou | Observed Difficulty != Skill Deficit | definition | 70 |  |
| (14) | 7. Live Problem Entry and Barrier Readou | u*^diag_(i,n) = argmax_(u in U^diag) [ IG_B(u) - lambda_C Cost(u) - rho Risk(u) ] | hypothesis/Open |  |  |
| (15) | 8. Candidate Advancement Routes: Capabil | C^cand_(i,n) = Gen( P^live_(i,n), B^bar_(i,n), K^life_(i,n), R^return_(H,i,n) ) | definition |  |  |
| (16) | 8. Candidate Advancement Routes: Capabil | C^live_(i,n) = { c in C^cand_(i,n) : Endorse_i(c) = 1 } | definition | 71 |  |
| (17) | 8. Candidate Advancement Routes: Capabil | Proactive Suggestion != Human Goal Ownership | definition | 72 |  |
| (18) | 8. Candidate Advancement Routes: Capabil | Capability Advancement != AI Goal Authority | definition | 72 |  |
| (19) | 8. Candidate Advancement Routes: Capabil | Scaffolding != Control | definition | 72 |  |
| (20) | 9. The Proactive Human Capability Advanc | u*^adv_(i,n) = argmin_(u in U^adv) E[ (Res^cap_i + u)^2 + lambda_B B^use(u) + rho R_u + mu D_u + xi A_u + psi O_u - nu V | hypothesis/Open |  |  |
| (21) | 9. The Proactive Human Capability Advanc | subject to: AgendaOwnership = 1, Endorsement = 1, Transparency = 1, Safety/Governance = 1 | hypothesis/Open |  |  |
| Human Capability Advancement Principle | 9. The Proactive Human Capability Advanc | Human Capability Advancement Principle [Open]. When durable human development is an endorsed goal, AI may proactively id | hypothesis/Open |  |  |
| (22) | 10. Adaptive Scaffolding: Use What the L | Stable Unaided Return (up) => h^decisive (down) | hypothesis/Open | 73 |  |
| (23) | 10. Adaptive Scaffolding: Use What the L | Attempt -> Minimal Sufficient Scaffold -> Feedback -> Reattempt -> Fading -> Unaided Execution -> Novel Transfer | definition |  |  |
| (24) | 11. Human Return: The AI Should Know Whe | R^return_H = < C, T, S, A > | definition |  |  |
| (25) | 11. Human Return: The AI Should Know Whe | Delta Performance_AI > 0  =/=>  Delta R^return_H > 0 | definition |  |  |
| (26) | 11. Human Return: The AI Should Know Whe | R^return_H (up) => h^decisive (down) | hypothesis/Open |  |  |
| (27) | 12. World Return: Capability That Never  | R^return_(H,i,n) -> a_(i,n) -> delta^world_(i,n+1) -> Z_(HCA,i,n+1) | definition | 74 |  |
| (28) | 13. Opportunity Conversion: The Market M | Omega^real_(i,n) = G_O( R^return_(H,i,n), K^life_(i,n), Cred_(i,n), Net_(i,n), Perm_(i,n), MarketReadout_n ) | definition | 75 |  |
| (29) | 13. Opportunity Conversion: The Market M | Credential != Capability | definition | 76 |  |
| (30) | 13. Opportunity Conversion: The Market M | Market Legibility != Human Worth | definition | 76 |  |
| (31) | 13. Opportunity Conversion: The Market M | Skill -> Evidence of Skill -> Recognition -> Opportunity | definition |  |  |
| (32) | 14. Worked Scenario: Three Children, Une | Outcome_C - Outcome_A  !=  Effect_HCA | definition |  |  |
| (33) | 14. Worked Scenario: Three Children, Une | Schooling + Human-Owned Inquiry + Supervised Adaptive AI + Projects + Human Return + Opportunity Bridges | proposition |  |  |
| (34) | 15. Child and Adult Governance: Proactiv | Purpose + Transparency + Refusal + Revision + Data Minimization | definition |  |  |
| (35) | 15. Child and Adult Governance: Proactiv | Child Assent + Adult Oversight + Privacy + Safety + No Opaque Persuasion (+ Age-Appropriate Design) | definition |  |  |
| (36) | 16. Measurement Architecture: What Would | A^HCA_i = < Gain_CTSA, Loss, Transfer, Ownership, Burden, BarrierChange, OpportunityChange, Provenance, Warrant > | definition | 77 |  |
| (37) | 17.6 Identification discipline | ATE_HCA(x) = E[ Y(1) - Y(0) \| K^life = x ] | definition | 78 |  |
